# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A WINDOWS VM
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
    "Patch Group" = var.env == "prd" ? "Patch-App-PrdWindows" : "Patch-App-NonPrdWindows"
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

#Get provider for gesos subscription to get latest image
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

#Get provider for 328 subscription
# provider "azurerm" {
#   alias = "sub328"
#   subscription_id = "9c1ab385-2554-43ca-bdf8-f8d937bf4a28"
#   features {}
# }

# data "azurerm_key_vault" "centralized" {
#   provider            = azurerm.sub328
#   name                = "kv-328-uai3064621-common"
#   resource_group_name = "rg-328-uai3046421-common"
# }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RESOURCES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Generate random password for windows vm
resource "random_password" "password" {
  length      = 16
  special     = false
  lower       = true
  upper       = true
  numeric     = true
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
}

#Create Windows VM
resource "azurerm_windows_virtual_machine" "windows_vm" {
  name                       = var.vm_name
  location                   = var.region
  resource_group_name        = length(var.custom_rg) == 0 ? local.standard_rg : var.custom_rg
  availability_set_id        = length(var.availability_set_id) == 0 ? null : var.availability_set_id
  admin_username             = "gecloud"
  admin_password             = length(var.password) == 0 ? random_password.password.result : var.password
  source_image_id            = data.azurerm_shared_image_version.latest.id
  network_interface_ids      = [var.nic_id]
  size                       = var.vm_size
  allow_extension_operations = true
  custom_data                = length(var.custom_data) == 0 ? null : var.custom_data
  tags                       = local.tags
  enable_automatic_updates   = true
  computer_name              = length(var.vm_name) > 15 ? substr(var.vm_name, 0, 14) : var.vm_name
  zone                       = var.vm_zone
  encryption_at_host_enabled = true

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = var.user_identity_ids
  }

  os_disk {
    name                   = "disk-${var.vm_name}-windows-os"
    caching                = var.os_disk_caching
    storage_account_type   = var.os_disk_storage_account_type
    disk_size_gb           = var.os_disk_size
    disk_encryption_set_id = data.azurerm_disk_encryption_set.des.id
  }

  # Ignore changes that would require vm recreation
  lifecycle {
    ignore_changes = [
      source_image_id,
      admin_password,
      os_disk
    ]
  }

  # Boot diagnostics configuration (Set to null for managed)
  boot_diagnostics {
    storage_account_uri = null
  }
}
