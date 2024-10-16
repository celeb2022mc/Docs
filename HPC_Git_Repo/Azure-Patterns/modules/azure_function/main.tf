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
}


# This blocks reads the resource group where Azure fuction app will be deployed 
data "azurerm_resource_group" "rg" {
  name = var.resource_group
}


# This blocks reads the existing Storage Account resource group which is required by  Azure fuction app to store internal configuration

data "azurerm_resource_group" "rg_stor" {
  name = var.resource_group_stor
}


# This blocks reads the storage that will be used with the azure fuction app 

data "azurerm_storage_account" "fuctionstor" {
  name                = var.fuction_stor
  resource_group_name = data.azurerm_resource_group.rg_stor.name

}


# This blocks reads the resource group where Azure network details are stored . 
data "azurerm_resource_group" "rg_network" {
  name = var.vnet_rg
}

# This blocks reads the  Azure VNet details that will be used to deploy Azure fuction App in case we choose Vnet Integration
data "azurerm_virtual_network" "VNet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg_network.name
}


# Subnet used for private endpoints
data "azurerm_subnet" "applicationsubnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.VNet.name
  resource_group_name  = data.azurerm_resource_group.rg_network.name
}


# This blocks creates the App service plan which is used by Azure fuction it also lets us choose the hosting plan ( consumption / premium)

data "azurerm_service_plan" "service_plan" {
  name                = var.app_service_plan
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_user_assigned_identity" "az_assigned" {
  resource_group_name = var.resource_group
  location            = data.azurerm_resource_group.rg.location
  name                = "azfunction-${var.uai}-${var.appName}-${var.purpose}-uid"
}

# This blocks creates the actual azure fuction. 
resource "azurerm_function_app" "fuctionapp" {
  name                       = "azfunc-${var.uai}-${var.appName}-${var.purpose}"
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  app_service_plan_id        = data.azurerm_service_plan.service_plan.id
  storage_account_name       = data.azurerm_storage_account.fuctionstor.name
  storage_account_access_key = var.storage_account_access_key #"testing-fuctions-pvtend"   
  enable_builtin_logging     = false
  https_only                 = true
  version                    = "~3" # version is mandetory for Linux environments.
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "",
    "FUNCTIONS_WORKER_RUNTIME" = "python",

  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.az_assigned.id]
  }

  # os_type - (Optional) A string indicating the Operating System type for this function app.
  # NOTE:
  # This value will be linux for Linux derivatives, or an empty string for Windows (default). 
  # When set to linux we must also set azurerm_app_service_plan arguments as kind = "Linux" and reserved = true

  os_type = "linux"

  site_config {
    linux_fx_version          = "${var.run_time}|${var.run_version}"
    use_32_bit_worker_process = false
    ftps_state                = "FtpsOnly"
    vnet_route_all_enabled    = true
  }

  tags = local.common_tags

  depends_on = [
    azurerm_user_assigned_identity.az_assigned
  ]
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_function_app.fuctionapp.id
  subnet_id      = data.azurerm_subnet.applicationsubnet.id
}

//Commented the code for the private endpoint and dnz zone
/*
# This block creates  Private endpoint configuration for azure fuctions
resource "azurerm_private_endpoint" "azurefnc" {
  name                = "pe-${azurerm_function_app.fuctionapp.name}"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.rg_network.name
  subnet_id           = data.azurerm_subnet.applicationsubnet.id
  tags                = local.common_tags
  private_dns_zone_group {
    name                 = "dns-app"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_endpoint.id]
  }
  private_service_connection {
    name                           = "pes${azurerm_function_app.fuctionapp.name}"
    private_connection_resource_id = azurerm_function_app.fuctionapp.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}
# This block creates private DNS
resource "azurerm_private_dns_zone" "private_endpoint" {
  name                = var.privatedns
  resource_group_name = data.azurerm_resource_group.rg_network.name
}
#private DNS Link
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "dnslink-${var.uai}-${var.appName}-${var.purpose}"
  resource_group_name   = data.azurerm_resource_group.rg_network.name
  private_dns_zone_name = azurerm_private_dns_zone.private_endpoint.name
  virtual_network_id    = data.azurerm_virtual_network.VNet.id
  registration_enabled  = false
}
*/
