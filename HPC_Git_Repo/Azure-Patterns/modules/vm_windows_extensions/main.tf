# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A MANAGED DISK
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "=3.75.0"
      configuration_aliases = [azurerm.hub]
    }
    template = {
      version = ">= 2.1.2"
    }
  }
}

locals {
  /* tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
  standard_rg = "rg-${var.subcode}-${var.uai}-${var.appName}" */

  common_uai = "uai3064621"

  #Centralized subscription details
  us_east = {
    "managed_identity_resource_id" : ["/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/rg-328-uai3046421-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-328-linux-common"],
    "managed_identity_object_id" : "9b863056-d02e-4d5a-a790-31df84d596f6",
    "centralized_subscription_id" : "9c1ab385-2554-43ca-bdf8-f8d937bf4a28",
    "centralized_storage_account" : "sa328uai3047228common",
    "centralized_key_vault" : "kv-328-uai3047228-common",
    "workspaceId" : "41b20e10-defd-46ca-a025-39e4c9f3237c",
    "workspaceResourceId" : "/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/cs-loganalytics/providers/Microsoft.OperationalInsights/workspaces/328-gr-logs",
    "workspaceKey" : "KLo87VkxsQoJE7ylufIssbpuMnb6lGZmA5p3JYs3QPuWw1IjmCRT6MKdCRwr5wLdR2OkTPPhR+SSVo1ytgel8A=="
  }

  west_europe = {
    "managed_identity_resource_id" : ["/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/rg-328-uai3046421-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-328-linux-common"],
    "managed_identity_object_id" : "9b863056-d02e-4d5a-a790-31df84d596f6",
    "managed_identity_objectId" : "9b863056-d02e-4d5a-a790-31df84d596f6",
    "centralized_subscription_id" : "4e02b754-b491-401d-b5c8-6e0f92663d8e",
    "centralized_storage_account" : "sa362uai3047228common",
    "centralized_key_vault" : "kv-362-uai3047228-common",
    "workspaceId" : "41b20e10-defd-46ca-a025-39e4c9f3237c",
    "workspaceResourceId" : "/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/cs-loganalytics/providers/Microsoft.OperationalInsights/workspaces/328-gr-logs",
    "workspaceKey" : "KLo87VkxsQoJE7ylufIssbpuMnb6lGZmA5p3JYs3QPuWw1IjmCRT6MKdCRwr5wLdR2OkTPPhR+SSVo1ytgel8A=="
  }

  #If netgroups variable is empty, skip domain join. Otherwise, append the OPS HPA group to the provided netgroups
  net_groups = length(var.net_groups) == 0 ? "" : join(" ", concat(var.net_groups, ["SVR_GAS_POWER_OPS_AZURE_SERVER_ADMIN"]))

  #Set managed identity resource id for configuration scripts
  managed_identity_resource_id = length(regexall("US", var.region)) > 0 ? local.us_east.managed_identity_resource_id : local.west_europe.managed_identity_resource_id

  #Set managed identity object id for configuration scripts
  managed_identity_object_id = length(regexall("US", var.region)) > 0 ? local.us_east.managed_identity_object_id : local.west_europe.managed_identity_object_id

  #Set centralized subscription id for configuration scripts
  centralized_subscription_id = length(regexall("US", var.region)) > 0 ? local.us_east.centralized_subscription_id : local.west_europe.centralized_subscription_id

  #Set centralized storage account for configuration scripts
  centralized_storage_account = length(regexall("US", var.region)) > 0 ? local.us_east.centralized_storage_account : local.west_europe.centralized_storage_account

  #Set centralized key vault for configuration scripts
  centralized_key_vault = length(regexall("US", var.region)) > 0 ? local.us_east.centralized_key_vault : local.west_europe.centralized_key_vault

  #Set workspace id for patching
  #workspace_id = length(regexall("US", var.region)) > 0 ? local.us_east.workspaceId : local.west_europe.workspaceId

  #Set workspace key for patching
  #workspace_key = length(regexall("US", var.region)) > 0 ? local.us_east.workspaceKey : local.west_europe.workspaceKey

  #Set workspace resource id 
  workspace_resource_id = length(regexall("US", var.region)) > 0 ? local.us_east.workspaceResourceId : local.west_europe.workspaceResourceId

}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#Get master run file for extension
data "template_file" "master" {
  template = file("${path.module}/scripts/master.ps1")
  vars = {
    vnet_name                   = join("-", [var.subcode, "gr-vnet"])
    managed_identity_object_id  = local.managed_identity_object_id
    centralized_subscription_id = local.centralized_subscription_id
    centralized_storage_account = local.centralized_storage_account
    netgroups                   = local.net_groups
    centralized_key_vault       = local.centralized_key_vault
  }
}


data "azurerm_monitor_data_collection_rule" "windowsrule" {
  provider            = azurerm
  name                = "${var.subcode}-windows-dcr-rule"
  resource_group_name = "rg-${var.subcode}-${local.common_uai}-common"
}

data "azurerm_monitor_data_collection_endpoint" "endpoint" {
  provider            = azurerm
  name                = "${var.subcode}-dcr-endpoint"
  resource_group_name = "rg-${var.subcode}-${local.common_uai}-common"
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RESOURCES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Dependency Agent for VM Insights
resource "azurerm_virtual_machine_extension" "DependencyAgentWindows" {
  provider                   = azurerm
  name                       = "dependency-agent-${var.vm_name}"
  virtual_machine_id         = var.vm_id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.5"
  auto_upgrade_minor_version  = true
  automatic_upgrade_enabled   = true
  failure_suppression_enabled = false

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_virtual_machine_extension" "AzureMonitorWindowsAgent" {
  provider                    = azurerm
  name                        = "AzureMonitorWindowsAgent"
  publisher                   = "Microsoft.Azure.Monitor"
  type                        = "AzureMonitorWindowsAgent"
  type_handler_version        = "1.16"
  virtual_machine_id          = var.vm_id
  auto_upgrade_minor_version  = true
  automatic_upgrade_enabled   = true
  failure_suppression_enabled = false
  settings = jsonencode({
    authentication = {
      managedIdentity = {
        identifier-name  = "mi_res_id"
        identifier-value = var.dcr_managed_identity_id
      }
    }
  })

  depends_on = [
    azurerm_virtual_machine_extension.DependencyAgentWindows
  ]
  lifecycle {
    ignore_changes = all
  }
}


resource "azurerm_monitor_data_collection_rule_association" "windowsruleassociation" {
  provider                    = azurerm
  name                        = "windows-rule-association-dcra"
  target_resource_id          = var.vm_id
  data_collection_rule_id     = data.azurerm_monitor_data_collection_rule.windowsrule.id
  description                 = "windows rule association"
  depends_on = [
    azurerm_virtual_machine_extension.AzureMonitorWindowsAgent
  ]
  lifecycle {
    ignore_changes = all
  }
}


resource "azurerm_monitor_data_collection_rule_association" "endpointassociation" {
  provider                    = azurerm
  target_resource_id          = var.vm_id
  description                 = "endpoint association"
  data_collection_endpoint_id = data.azurerm_monitor_data_collection_endpoint.endpoint.id
  depends_on = [
    azurerm_monitor_data_collection_rule_association.windowsruleassociation
  ]
  lifecycle {
    ignore_changes = all
  }
}



#Install Custom Extension Scripts
resource "azurerm_virtual_machine_extension" "custom_scripts" {
  #Ability to not add configuration for ansible testing only
  count                = var.include_configuration ? 1 : 0
  name                 = "custom-scripts-${var.vm_name}"
  virtual_machine_id   = var.vm_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
  {
      "commandToExecute": "powershell -command New-Item -ItemType Directory -Force -Path 'C:\\setup_scripts\\' && powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.master.rendered)}')) | Out-File -filepath C:\\setup_scripts\\master.ps1\" && powershell -command \"C:\\setup_scripts\\master.ps1 | Out-File -filepath C:\\setup_scripts\\master.txt\""
  }
  SETTINGS

  depends_on = [
    azurerm_monitor_data_collection_rule_association.endpointassociation
  ]

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

