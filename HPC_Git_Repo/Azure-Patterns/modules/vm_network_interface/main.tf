# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A NETWORK INTERFACE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.75.0"
    }
  }
}

locals {
  tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
  standard_rg = "rg-${var.subcode}-${var.uai}-${var.appName}"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.vnet_rg
  virtual_network_name = "${var.subcode}-gr-vnet"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RESOURCES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "azurerm_network_interface" "nic" {
  name                            = "nic-${var.vm_name}"
#   count                           = var.nic_count
#   name                            = "nic-${var.vm_name}-${format("%02d", count.index)}"
  location                        = var.region
  resource_group_name             = length(var.custom_rg) == 0 ? local.standard_rg : var.custom_rg
  tags                            = local.tags
  
  ip_configuration {
    name                          = "ip-${var.vm_name}"
#     name                          = "ip-${var.vm_name}-${format("%02d", count.index)}"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = length(var.ipAllocation) == 0 ? "Dynamic" : "Static"
    private_ip_address            = length(var.ipAllocation) == 0 ? null : var.ipAllocation
  }
}
