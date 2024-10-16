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

# This blocks reads the resource group where logic app will be hosted
data "azurerm_resource_group" "rg" {
  name = var.resource_group

}

# The resource group where virtual network is available for the Vnet Integration.
data "azurerm_resource_group" "rg_vnet" {
  name = var.resource_group_vnet

}

# This block reads the virtual network details for the private endpoints creation.
data "azurerm_virtual_network" "private_endpoint_vnet" {
  name                = var.virtual_network
  resource_group_name = data.azurerm_resource_group.rg_vnet.name
}

# This block reads the subnet details for the vnet integration, 
# Note: The subnet delegation must be enabled in the subnet.
data "azurerm_subnet" "vnet_integration_subnet" {
  name                 = var.subnet_vnet
  resource_group_name  = data.azurerm_resource_group.rg_vnet.name
  virtual_network_name = data.azurerm_virtual_network.private_endpoint_vnet.name
}

# # This block reads the subnet details for the private endpoints creation, 
# # Note: The subnet delegation must not be enabled in the subnet.
# data "azurerm_subnet" "private_endpoint_subnet" {
#   name                 = var.subnet_private_endpoint
#   resource_group_name  = data.azurerm_resource_group.rg_vnet.name
#   virtual_network_name = data.azurerm_virtual_network.private_endpoint_vnet.name
# }

# This block reads the existing storage account details
data "azurerm_storage_account" "storage_account" {
  name                = var.storage_account
  resource_group_name = var.resource_group_str
}

# This block is to read the details of the existing application insight.
data "azurerm_application_insights" "application_insights" {
  name                = var.application_insight
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_service_plan" "service_plan" {
  name                = var.app_service_plan
  resource_group_name = data.azurerm_resource_group.rg.name
}

# This block is to create the logic app standard.
resource "azurerm_logic_app_standard" "logic_app_standard" {
  name                       = "la-${var.uai}-${var.appName}-${var.purpose}"
  location                   = var.region
  resource_group_name        = data.azurerm_resource_group.rg.name
  app_service_plan_id        = data.azurerm_service_plan.service_plan.id
  storage_account_name       = data.azurerm_storage_account.storage_account.name
  storage_account_access_key = data.azurerm_storage_account.storage_account.primary_access_key
  virtual_network_subnet_id  = data.azurerm_subnet.vnet_integration_subnet.id
  tags                       = local.tags
  https_only                 = var.https_only

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = data.azurerm_application_insights.application_insights.instrumentation_key
    "WEBSITE_CONTENTOVERVNET"        = 1
  }
  site_config {
    ftps_state = "FtpsOnly"
  }
}

/*
# This block is used to create the private endpoints.
resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "pe-${azurerm_logic_app_standard.logic_app_standard.name}"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.rg_vnet.name
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id
  tags                = local.tags
  private_service_connection {
    name                           = "pc-${azurerm_logic_app_standard.logic_app_standard.name}"
    private_connection_resource_id = azurerm_logic_app_standard.logic_app_standard.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
  depends_on = [
    azurerm_logic_app_standard.logic_app_standard
  ]
}
# This block is to create the azure dns zone.
resource "azurerm_private_dns_zone" "dns_zone" {
  name                = var.privatedns
  resource_group_name = data.azurerm_resource_group.rg_vnet.name
  tags                = local.tags
}
#private DNS Link
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "dnslink-${var.uai}-${var.appName}-${var.purpose}"
  resource_group_name   = data.azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.private_endpoint_vnet.id
  registration_enabled  = false
}
*/
