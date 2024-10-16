# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A USER MANAGED IDENTITY
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

#User Identity
resource "azurerm_user_assigned_identity" "identity" {
  resource_group_name = var.resource_group
  location            = var.region
  tags                = local.tags
  name                = "mi-${var.appName}-${var.purpose}"
}
