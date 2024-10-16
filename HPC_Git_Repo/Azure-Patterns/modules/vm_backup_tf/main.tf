# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A VM BACKUP
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
  rg_name = "rg-${var.subcode}-uai3064621-common"
  rv_name = "rv-${var.subcode}-uai3064621-common"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

data "azurerm_backup_policy_vm" "policy" {
  name                = var.backup_policy_name
  recovery_vault_name = local.rv_name
  resource_group_name = local.rg_name
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RESOURCES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "azurerm_backup_protected_vm" "vm" {
  resource_group_name = local.rg_name
  recovery_vault_name = local.rv_name
  source_vm_id        = var.vm_id
  backup_policy_id    = data.azurerm_backup_policy_vm.policy.id
}
