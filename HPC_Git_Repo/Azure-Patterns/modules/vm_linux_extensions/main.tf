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

  #Radius names for each region, env
  radius_map = {
    "us-dev"     = "vn-us-dev-radius",
    "us-qa"      = "vn-us-dev-radius",
    "us-lab"     = "vn-us-dev-radius",
    "us-prd"     = "vn-us-prd-radius",
    "us-stg"     = "vn-us-prd-radius",
    "europe-dev" = "vn-eu-dev-radius",
    "europe-qa"  = "vn-eu-dev-radius",
    "europe-lab" = "vn-eu-dev-radius",
    "europe-prd" = "vn-eu-prd-radius",
    "europe-stg" = "vn-eu-prd-radius"
  }


  #Centralized subscription details
  us_east = {
    "managed_identity_resource_id" : ["/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/rg-328-uai3046421-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-328-linux-common"],
    "managed_identity_object_id" : "9b863056-d02e-4d5a-a790-31df84d596f6",
    "centralized_subscription_id" : "9c1ab385-2554-43ca-bdf8-f8d937bf4a28",
    "centralized_storage_account" : "sa328uai3047228common",
    "centralized_key_vault_id" : "/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/rg-328-uai3046421-common/providers/Microsoft.KeyVault/vaults/kv-328-uai3047228-common",
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
    "centralized_key_vault_id" : "/subscriptions/4e02b754-b491-401d-b5c8-6e0f92663d8e/resourceGroups/rg-362-uai3047228-common/providers/Microsoft.KeyVault/vaults/kv-362-uai3047228-common",
    "workspaceId" : "41b20e10-defd-46ca-a025-39e4c9f3237c",
    "workspaceResourceId" : "/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/cs-loganalytics/providers/Microsoft.OperationalInsights/workspaces/328-gr-logs",
    "workspaceKey" : "KLo87VkxsQoJE7ylufIssbpuMnb6lGZmA5p3JYs3QPuWw1IjmCRT6MKdCRwr5wLdR2OkTPPhR+SSVo1ytgel8A=="
  }

  #Set managed identity resource id for configuration scripts
  managed_identity_resource_id = length(regexall("US", var.region)) > 0 ? local.us_east.managed_identity_resource_id : local.west_europe.managed_identity_resource_id

  #Set managed identity object id for configuration scripts
  managed_identity_object_id = length(regexall("US", var.region)) > 0 ? local.us_east.managed_identity_object_id : local.west_europe.managed_identity_object_id

  #Set centralized subscription id for configuration scripts
  centralized_subscription_id = length(regexall("US", var.region)) > 0 ? local.us_east.centralized_subscription_id : local.west_europe.centralized_subscription_id

  #Set centralized storage account for configuration scripts
  centralized_storage_account = length(regexall("US", var.region)) > 0 ? local.us_east.centralized_storage_account : local.west_europe.centralized_storage_account

  #Set centralized key vault for configuration scripts
  centralized_key_vault_id = length(regexall("US", var.region)) > 0 ? local.us_east.centralized_key_vault_id : local.west_europe.centralized_key_vault_id

  #If netgroups variable is empty, skip ldap2fa
  net_groups = length(var.net_groups) == 0 ? "" : join(",", var.net_groups)
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Get radius password from key vault
data "azurerm_key_vault_secret" "radius" {
  provider     = azurerm.hub
  name         = lookup(local.radius_map, join("-", [split(" ", lower(var.region))[1], lower(var.env)]), "")
  key_vault_id = local.centralized_key_vault_id
}

#Get ldap password from key vault
data "azurerm_key_vault_secret" "ldap" {
  provider     = azurerm.hub
  name         = "ldap-password"
  key_vault_id = local.centralized_key_vault_id
}

#Get master file for extension with variables replaced
data "template_file" "master" {
  template = file("${path.module}/scripts/master.sh")
  vars = {
    ldap_bind_dn                = "cn=AZURE-PRDBASTION"
    ldap_password               = data.azurerm_key_vault_secret.ldap.value
    net_group                   = local.net_groups
    radius_password             = data.azurerm_key_vault_secret.radius.value
    managed_identity_object_id  = local.managed_identity_object_id
    centralized_subscription_id = local.centralized_subscription_id
    centralized_storage_account = local.centralized_storage_account
    data_base                   = var.disk_mount_directory
    vnet_name                   = join("-", [var.subcode, "gr-vnet"])
  }
}


data "azurerm_monitor_data_collection_rule" "linuxrule" {
  provider            = azurerm
  name                = "${var.subcode}-linux-dcr-rule"
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
resource "azurerm_virtual_machine_extension" "DependencyAgentLinux" {
  provider                    = azurerm
  name                        = "dependency-agent-${var.vm_name}"
  virtual_machine_id          = var.vm_id
  publisher                   = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                        = "DependencyAgentLinux"
  type_handler_version        = "9.5"
  auto_upgrade_minor_version  = true
  automatic_upgrade_enabled   = true
  failure_suppression_enabled = false
  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_virtual_machine_extension" "AzureMonitorLinuxAgent" {
  provider                    = azurerm
  name                        = "AzureMonitorLinuxAgent"
  publisher                   = "Microsoft.Azure.Monitor"
  type                        = "AzureMonitorLinuxAgent"
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
    azurerm_virtual_machine_extension.DependencyAgentLinux
  ]
  lifecycle {
    ignore_changes = all
  }
}


resource "azurerm_monitor_data_collection_rule_association" "linuxruleassociation" {
  provider                    = azurerm
  name                        = "linux-rule-association-dcra"
  target_resource_id          = var.vm_id
  data_collection_rule_id     = data.azurerm_monitor_data_collection_rule.linuxrule.id
  description                 = "linux rule association"
  depends_on = [
    azurerm_virtual_machine_extension.AzureMonitorLinuxAgent
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
    azurerm_monitor_data_collection_rule_association.linuxruleassociation
  ]
  lifecycle {
    ignore_changes = all
  }
}

#Install Custom Scripts
resource "azurerm_virtual_machine_extension" "custom_scripts" {
  #Ability to not add configuration for ansible testing only
  provider             = azurerm
  count                = var.include_configuration ? 1 : 0
  name                 = "custom-scripts-${var.vm_name}"
  virtual_machine_id   = var.vm_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
  {
      "commandToExecute": "base64 -d <<< ${base64encode(data.template_file.master.rendered)} > master.sh; sed -i -e 's/\r//g' master.sh; bash master.sh > logs_master.txt"
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
