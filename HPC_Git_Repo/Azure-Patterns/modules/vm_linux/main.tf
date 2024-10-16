# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A LINUX VM
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "=3.75.0"
      configuration_aliases = [azurerm.gesos]
    }
  }
}

locals {
  common_tags = {
    uai           = var.uai
    env           = var.env
    appname       = var.appName
    AppEnvCfgID   = var.AppEnvCfgID
    Built-By      = "EA Terraform"
    Patch         = "Yes"
    MaintenanceSchedule = var.MaintenanceSchedule
    "Patch Group" = var.env == "prd" ? "Patch-App-PrdLinux" : "Patch-App-NonPrdLinux"
  }
  tags        = length(var.custom_tags) == 0 ? local.common_tags : merge(var.custom_tags, local.common_tags) 
  standard_rg = "rg-${var.subcode}-${var.uai}-${var.appName}"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

data "azurerm_disk_encryption_set" "des" {
  name                = "des-${var.subcode}-uai3064621-common"
  resource_group_name = length(var.os_des_rg) == 0 ? "rg-${var.subcode}-uai3064621-common" : var.os_des_rg
}

data "azurerm_ssh_public_key" "common" {
  name                = "sshkey-${var.subcode}-uai3064621-common"
  resource_group_name = "rg-${var.subcode}-uai3064621-common"
}

# #Get provider for gesos subscription to get latest image
# provider "azurerm" {
#   alias = "gesos"
#   subscription_id = "f28c99ba-3eac-470a-a3ee-fa026a3302d3"
#   skip_provider_registration = true
#   features {}
# }

data "azurerm_shared_image_version" "latest" {
  provider            = azurerm.gesos
  name                = "latest"
  image_name          = var.image_name
  gallery_name        = "gesos_image_central"
  resource_group_name = "gesos-prd"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RESOURCES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                       = var.vm_name
  location                   = var.region
  resource_group_name        = length(var.custom_rg) == 0 ? local.standard_rg : var.custom_rg
  availability_set_id        = length(var.availability_set_id) == 0 ? null : var.availability_set_id
  admin_username             = "gecloud"
  source_image_id            = data.azurerm_shared_image_version.latest.id
  network_interface_ids      = [var.nic_id]
#   network_interface_ids      = var.nic_id
  size                       = var.vm_size
  allow_extension_operations = true
  custom_data                = length(var.custom_data) == 0 ? null : var.custom_data
  tags                       = local.tags
  zone                       = var.vm_zone
  encryption_at_host_enabled = true


  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = var.user_identity_ids
  }

  admin_ssh_key {
    public_key = data.azurerm_ssh_public_key.common.public_key
    username   = "gecloud"
  }

  os_disk {
    name                   = "disk-${var.vm_name}-linux-os"
    caching                = var.os_disk_caching
    storage_account_type   = var.os_disk_storage_account_type
    disk_size_gb           = var.os_disk_size
    disk_encryption_set_id = data.azurerm_disk_encryption_set.des.id
  }

  # Ignore changes that would require vm recreation
  lifecycle {
    ignore_changes = [
      admin_ssh_key,
      source_image_id,
      os_disk
    ]
  }

  # Boot diagnostics configuration (Set to null for managed)
  boot_diagnostics {
    storage_account_uri = null
  }
}
