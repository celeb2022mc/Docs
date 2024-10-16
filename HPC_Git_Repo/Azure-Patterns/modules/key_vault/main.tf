# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A KEY VAULT
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
}

#Store common variables
locals {
  kv_name = "kv-${var.appName}-${var.purpose}"
  tags = {
    uai         = var.uai
    env         = var.env
    appname     = var.appName
    KeyRotation = "true"
  }
  filtered_subs = [for subnet in data.azurerm_virtual_network.gr-vnet.subnets : subnet if contains(var.excluded_subnets_list, subnet) == false]
  subnets       = [for subnet in local.filtered_subs : "/subscriptions/${var.subscription_id}/resourceGroups/${var.vnet_rg}/providers/Microsoft.Network/virtualNetworks/${var.subcode}-gr-vnet/subnets/${subnet}"]
  agent_subnet  = var.region == "West Europe" ? "/subscriptions/4e02b754-b491-401d-b5c8-6e0f92663d8e/resourceGroups/cs-connectedVNET/providers/Microsoft.Network/virtualNetworks/362-gr-vnet/subnets/Application-Subnet" : "/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/cs-connectedVNET/providers/Microsoft.Network/virtualNetworks/328-gr-vnet/subnets/Application-Subnet"
}

#Client Config Info
data "azurerm_client_config" "current" {}

#Retrieve existing vnet
data "azurerm_virtual_network" "gr-vnet" {
  name                = "${var.subcode}-gr-vnet"
  resource_group_name = var.vnet_rg
}

# Create the Azure Key Vault
resource "azurerm_key_vault" "keyvault" {
  name                            = length(local.kv_name) > 24 ? substr(local.kv_name, 0, 24) : local.kv_name ##  "name" may only contain alphanumeric characters and dashes and must be between 3-24 chars
  location                        = var.region
  resource_group_name             = var.resource_group
  sku_name                        = "premium"
  purge_protection_enabled        = true
  tags                            = local.tags
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment          = "true"
  enabled_for_disk_encryption     = "true"
  enabled_for_template_deployment = "true"
  enable_rbac_authorization       = "true"
  soft_delete_retention_days      = 30

  lifecycle {
    ignore_changes = [soft_delete_retention_days, tenant_id]
  }

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = var.include_subnets ? concat([local.agent_subnet], local.subnets) : [local.agent_subnet]
    ip_rules = ["52.21.224.216/32"]
  }
}

#Add Key Vault Administrator permissions to service principal on key vault
resource "azurerm_role_assignment" "vault" {
  count                = length(data.azurerm_client_config.current.object_id) > 0 ? 1 : 0
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_key_vault.keyvault.resource_group_name}/providers/Microsoft.KeyVault/vaults/${azurerm_key_vault.keyvault.name}"
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id

  depends_on = [
    azurerm_key_vault.keyvault
  ]

  lifecycle {
    ignore_changes = all
  }
}

# #Get Log Analytics Workspace for logging
data "azurerm_log_analytics_workspace" "workspace" {
  name                = "${var.subcode}-gr-logs"
  resource_group_name = var.analytics_workspace_rg
}

#Logging for key vault
resource "azurerm_monitor_diagnostic_setting" "vault" {
  name                       = "KeyVaultLogging-${azurerm_key_vault.keyvault.name}"
  target_resource_id         = azurerm_key_vault.keyvault.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.workspace.id

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
  }

  depends_on = [
    azurerm_key_vault.keyvault
  ]

  lifecycle {
    ignore_changes = all
  }
}
