# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A MANAGED DISK
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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RESOURCES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "azurerm_managed_disk" "datadisk" {
  for_each               = var.disk_configs
  name                   = "disk-${var.vm_name}-${each.value.disk_alias}"
  location               = var.region
  resource_group_name    = length(var.custom_rg) == 0 ? local.standard_rg : var.custom_rg
  storage_account_type   = "Premium_LRS"
  disk_encryption_set_id = var.data_des_id
  create_option          = "Empty"
  disk_size_gb           = each.value.disk_size
  tags                   = local.tags
  zone                   = var.vm_zones //zones has been renamed with zone in current version
  
  #required by security - Policy deployed to enforce
  network_access_policy = "DenyAll"
  # public_network_access_enabled = false
}

resource "azurerm_virtual_machine_data_disk_attachment" "datadiskattachment" {
  for_each           = var.disk_configs
  managed_disk_id    = azurerm_managed_disk.datadisk[each.key].id
  virtual_machine_id = var.vm_id
  lun                = each.value.logical_number
  caching            = each.value.caching
}
