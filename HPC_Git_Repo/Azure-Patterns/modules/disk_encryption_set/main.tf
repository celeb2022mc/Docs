# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A DISK ENCRYTPION SET
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "> 3.2.1"
    }    
  }
}

#Store common variables
locals {
  des_name = format("des-%s-%s", var.appName, var.purpose)
  tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
}

#DES Generation
resource "azurerm_disk_encryption_set" "des" {
  name                = local.des_name
  resource_group_name = var.resource_group
  location            = var.region
  key_vault_key_id    = var.keyvault_key_id
  tags                = local.tags

  identity {
    type = "SystemAssigned"
  }

}

#Add Key Vault Crypto Service Encryption User permissions to disk encryption set on key vault
resource "azurerm_role_assignment" "vault" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.keyvault_rg}/providers/Microsoft.KeyVault/vaults/${var.keyvault_name}"
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.des.identity[0].principal_id

  depends_on = [
    azurerm_disk_encryption_set.des
  ]
}

#Set auto-rotation (Not currently supported by tf)
# resource "null_resource" "add-cmk-rotation" {
#   provisioner "local-exec" {
#     command     = <<EOT
#       az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID;
#       az account set --subscription ${var.subscription_id};
#       az disk-encryption-set update --name ${azurerm_disk_encryption_set.des.name} --resource-group ${azurerm_disk_encryption_set.des.resource_group_name} --key-url ${var.keyvault_key_id} --source-vault ${var.keyvault_name} --auto-rotation ${var.auto_key_rotation_enabled}
#     EOT
#     interpreter = ["pwsh", "-Command"]
#   }

#   depends_on = [
#     azurerm_disk_encryption_set.des,
#     azurerm_role_assignment.vault
#   ]
# }
