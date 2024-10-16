# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A STORAGE ACCOUNT
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
  storage_name = var.include_subcode ? format("sa%s%s%s", var.subcode, var.appName, var.purpose) : format("sa%s%s", var.appName, var.purpose)
  tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
  filtered_subs = [for subnet in data.azurerm_virtual_network.gr-vnet.subnets : subnet if contains(var.excluded_subnets_list, subnet) == false]
  subnets       = [for subnet in local.filtered_subs : "/subscriptions/${var.subscription_id}/resourceGroups/${var.vnet_rg}/providers/Microsoft.Network/virtualNetworks/${var.subcode}-gr-vnet/subnets/${subnet}"]
  agent_subnet  = var.region == "West Europe" ? "/subscriptions/4e02b754-b491-401d-b5c8-6e0f92663d8e/resourceGroups/cs-connectedVNET/providers/Microsoft.Network/virtualNetworks/362-gr-vnet/subnets/Application-Subnet" : "/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/cs-connectedVNET/providers/Microsoft.Network/virtualNetworks/328-gr-vnet/subnets/Application-Subnet"
}

#Retrieve existing vnet
data "azurerm_virtual_network" "gr-vnet" {
  name                = "${var.subcode}-gr-vnet"
  resource_group_name = var.vnet_rg
}

#Storage Account
resource "azurerm_storage_account" "storage" {
  name                            = length(local.storage_name) > 24 ? substr(replace(local.storage_name, "-", ""), 0, 24) : replace(local.storage_name, "-", "")
  resource_group_name             = var.resource_group
  location                        = var.region
  account_tier                    = var.storage_acc_tier
  account_replication_type        = var.storage_acc_type
  access_tier                     = "Hot"
  min_tls_version                 = "TLS1_2"
  enable_https_traffic_only       = true
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
  tags                            = local.tags

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = var.include_subnets ? concat([local.agent_subnet], local.subnets) : [local.agent_subnet]
    ip_rules                   = [var.ip_address]
  }

  #Container soft delete
  blob_properties {
    container_delete_retention_policy {
      days = 30
    }

    delete_retention_policy {
      days = 7
    }
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags]
  }

}

#Add Key Vault Administrator permissions to storage account on key vault
resource "azurerm_role_assignment" "vault" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.keyvault_rg}/providers/Microsoft.KeyVault/vaults/${var.keyvault_name}"
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_storage_account.storage.identity[0].principal_id

  depends_on = [
    azurerm_storage_account.storage
  ]
}

#Attaches CMK to storage account for encryption
resource "azurerm_storage_account_customer_managed_key" "cmk" {
  storage_account_id = azurerm_storage_account.storage.id
  key_vault_id       = var.keyvault_id
  key_name           = var.key_name

  depends_on = [
    azurerm_storage_account.storage,
    azurerm_role_assignment.vault
  ]
}

# Reading the value for the workspace
data "azurerm_log_analytics_workspace" "lgworkspace" {
  name                = "${var.subcode}-gr-logs"
  resource_group_name = "cs-loganalytics"
}


#Logging for storage account
resource "azurerm_monitor_diagnostic_setting" "logging" {
  name                       = "StorageAccountLogging-${azurerm_storage_account.storage.name}"
  target_resource_id         = "${azurerm_storage_account.storage.id}/blobServices/default"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lgworkspace.id

  enabled_log {
    category = "StorageDelete"
  }

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  metric {
    category = "AllMetrics"
  }

  depends_on = [
    azurerm_storage_account.storage
  ]

  lifecycle {
    ignore_changes = all
  }
}
