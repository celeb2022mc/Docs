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
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
  }
}

locals {
  rg_name = "rg-${var.subcode}-uai3064621-common"
  rv_name = "rv-${var.subcode}-uai3064621-common"
  vm_name = element(split("/", var.vm_id), length(split("/", var.vm_id))-1)
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# data "azurerm_backup_policy_vm""policy" {
#   name                = var.backup_policy_name
#   recovery_vault_name = local.rv_name
#   resource_group_name = local.rg_name
# }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RESOURCES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# resource "azurerm_backup_protected_vm" "vm" {
#   resource_group_name = local.rg_name
#   recovery_vault_name = local.rv_name
#   source_vm_id        = var.vm_id
#   backup_policy_id    = data.azurerm_backup_policy_vm.policy.id

#   lifecycle {
#     ignore_changes = [
#       tags
#     ]
#   }
# }

#Set backup (Deletion not currently supported by azurerm modules)
resource "null_resource" "add-vm-backup" {
  provisioner "local-exec" {
    command = <<EOT
      az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID;
      az account set --subscription ${var.subscription_id};
      $backupStatus = (az backup item show --container-name ${local.vm_name} --name ${local.vm_name} --resource-group ${local.rg_name} --vault-name ${local.rv_name} --backup-management-type AzureIaasVM --query 'properties.protectionState')
      if ($backupStatus -ne '"Protected"'){
        az backup protection enable-for-vm --policy-name ${var.backup_policy_name} --resource-group ${local.rg_name} --vault-name ${local.rv_name} --vm ${var.vm_id} --exclude-all-data-disks false
      }
      else{
        echo "VM is already protected";
      }
    EOT
    interpreter = ["pwsh", "-Command"]
  }
}
