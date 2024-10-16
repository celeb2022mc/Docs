# Create a Computer Vision Service
#--------------------------
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
}


# virtual network details
data "azurerm_virtual_network" "cslvnet" {
  name                = var.virtual_network
  resource_group_name = var.vnet_rg
}

# Subnet for Computer Vision Service Private Endpoint
data "azurerm_subnet" "acv_subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_virtual_network.cslvnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.cslvnet.name
}

locals {
  common_tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
  tags = local.common_tags
}

resource "azurerm_user_assigned_identity" "az_assigned" {
  resource_group_name = var.resource_group
  location            = var.region
  name                = "acv-${var.uai}-${var.appName}-${var.purpose}-uid"
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

# Create the Computer Vision Service
resource "azurerm_cognitive_account" "acv" {
  name                          = "acv-${var.uai}-${var.appName}-${var.purpose}"
  location                      = var.region
  resource_group_name           = var.resource_group
  public_network_access_enabled = false
  kind                          = "ComputerVision"
  sku_name                      = var.acv_sku
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

# Create the private endpoint for the Computer Vision service
resource "azurerm_private_endpoint" "acv-endpoint" {
  depends_on          = [azurerm_cognitive_account.acv]
  name                = "pe-${var.uai}-${var.appName}-${var.purpose}-acv"
  location            = var.region
  resource_group_name = var.resource_group
  subnet_id           = data.azurerm_subnet.acv_subnet.id

  private_service_connection {
    name                           = "pe-${var.uai}-${var.appName}-${var.purpose}-acv-privateserviceconnection"
    private_connection_resource_id = azurerm_cognitive_account.acv.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }

  tags = local.tags
}
