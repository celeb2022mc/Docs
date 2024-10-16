# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A LINUX VM SCALE SET
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.75.0"
      configuration_aliases = [azurerm.gesos]
    }
  }
}

locals {
  common_tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
  tags = length(var.custom_tags) == 0 ? local.common_tags : merge(var.custom_tags, local.common_tags)
  standard_rg = "rg-${var.subcode}-${var.uai}-${var.appName}"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

data "azurerm_disk_encryption_set" "des" {
  name                 = "des-${var.subcode}-uai3064621-common"
  resource_group_name  = length(var.os_des_rg) == 0 ? "rg-${var.subcode}-uai3064621-common": var.os_des_rg
}

#Get provider for gesos subscription to get latest image
# provider "azurerm" {
#   alias = "gesos"
#   subscription_id = "f28c99ba-3eac-470a-a3ee-fa026a3302d3"
#   skip_provider_registration = true
#   features {}
# }

data "azurerm_shared_image" "image" {
  provider            = azurerm.gesos
  name                = var.image_name
  gallery_name        = "gesos_image_central"
  resource_group_name = "gesos-prd"
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.vnet_rg
  virtual_network_name = "${var.subcode}-gr-vnet"
}

data "azurerm_ssh_public_key" "common" {
  name                = "sshkey-${var.subcode}-uai3064621-common"
  resource_group_name = "rg-${var.subcode}-uai3064621-common"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RESOURCES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Create Linux Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "azurerm_vm_scale_set" {
  name                = var.vm_scale_set_name
  resource_group_name = length(var.custom_rg) == 0 ? local.standard_rg : var.custom_rg
  location            = var.region
  sku                 = var.vm_size
  instances           = var.num_instances
  admin_username      = "gecloud"
  source_image_id     = data.azurerm_shared_image.image.id
  tags                = local.tags
  custom_data         = var.custom_data
  computer_name_prefix = trimsuffix(length(var.vm_scale_set_name) > 9 ? substr(var.vm_scale_set_name, 0, 9) : var.vm_scale_set_name, "-")
  
  admin_ssh_key {
    username   = "gecloud"
    public_key = data.azurerm_ssh_public_key.common.public_key
  }

  os_disk {
    caching                = "ReadWrite"
    storage_account_type   = "Premium_LRS"
    disk_size_gb           = 128
    disk_encryption_set_id = data.azurerm_disk_encryption_set.des.id
  }

  identity {
    type              = "SystemAssigned"
  }

  network_interface {
    name    = "nic-${var.vm_scale_set_name}"
    primary = true

    ip_configuration {
      name      = "ip-${var.vm_scale_set_name}"
      primary   = true
      subnet_id = data.azurerm_subnet.subnet.id
    }
  }

  dynamic "extension" {
    for_each = var.extensions
    content {
      name = extension.value["name"]
      publisher = extension.value["publisher"]
      type = extension.value["type"]
      type_handler_version = extension.value["type_handler_version"]
      settings = extension.value["settings"]
      protected_settings = extension.value["protected_settings"]
    }
  }

  lifecycle {
    ignore_changes = all
  }
}
