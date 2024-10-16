# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A RESOURCE GROUP
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

#Create resource group
resource "azurerm_resource_group" "rg" {
  location = var.region
  name     = "rg-${var.subcode}-${var.uai}-${var.appName}"
  tags     = local.tags
}
