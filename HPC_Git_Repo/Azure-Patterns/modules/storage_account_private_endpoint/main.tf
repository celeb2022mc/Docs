# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A STORAGE ACCOUNT PRIVATE ENDPOINT
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
  tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
}

# Subnet used for private endpoints
data "azurerm_subnet" "integration" {
  name                 = length(var.subnet_name) == 0 ? "Integration-Subnet" : var.subnet_name
  virtual_network_name = "${var.subcode}-gr-vnet"
  resource_group_name  = var.vnet_rg
}

#Key Vault Private endpoint configuration, dns zone auto configured by account policy
resource "azurerm_private_endpoint" "storage" {
  name                = "pe-${var.storage_account_name}"
  location            = var.region
  resource_group_name = var.resource_group
  subnet_id           = data.azurerm_subnet.integration.id
  tags                = local.tags

  private_service_connection {
    name                           = "pes-${var.storage_account_name}"
    private_connection_resource_id = var.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  lifecycle {
    #Makes sure the coretech dns zone is not deleted when updating
    ignore_changes = all
  }

}
