terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
}

locals {
  common_tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
  tags = local.common_tags
}

# This blocks reads the virtual network where private endpoint app will be deployed
data "azurerm_virtual_network" "cslvnet" {
  name                = var.virtual_network
  resource_group_name = var.vnet_rg
}

# This blocks reads the subnet where private endpoint service app will be deployed
data "azurerm_subnet" "cslubnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_virtual_network.cslvnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.cslvnet.name
}

resource "azurerm_user_assigned_identity" "az_assigned" {
  resource_group_name = var.resource_group
  location            = var.region
  name                = "csfl-${var.uai}-${var.appName}-${var.purpose}-uid"
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.key_vault_rg}/providers/Microsoft.KeyVault/vaults/${var.key_vault_name}"
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.az_assigned.principal_id

  depends_on = [
    azurerm_user_assigned_identity.az_assigned
  ]

  lifecycle {
    ignore_changes = all
  }
}

# Create the private endpoint for the Cognitive Service for Language
resource "azurerm_private_endpoint" "csl-endpoint" {
  depends_on          = [azurerm_cognitive_account.csl]
  name                = "pe-${var.uai}-${var.appName}-${var.purpose}-csl"
  location            = var.region
  resource_group_name = var.resource_group
  subnet_id           = data.azurerm_subnet.cslubnet.id

  private_service_connection {
    name                           = "pe-${var.uai}-${var.appName}-${var.purpose}-ls-privateserviceconnection"
    private_connection_resource_id = azurerm_cognitive_account.csl.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  tags = local.tags
}

# Create the Cognitive Service for Language
resource "azurerm_cognitive_account" "csl" {
  name                          = "csl-${var.uai}-${var.appName}-${var.purpose}"
  location                      = var.region
  resource_group_name           = var.resource_group
  public_network_access_enabled = false
  kind                          = var.kind
  sku_name                      = var.ls_sku
  custom_subdomain_name         = var.custom_subdomain
  local_auth_enabled            = false

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.az_assigned.id]
  }

  customer_managed_key {
    key_vault_key_id   = var.key_vault_key_id
    identity_client_id = azurerm_user_assigned_identity.az_assigned.client_id
  }
  tags = local.tags

  depends_on = [
    azurerm_role_assignment.role_assignment,
    azurerm_user_assigned_identity.az_assigned
  ]
}
