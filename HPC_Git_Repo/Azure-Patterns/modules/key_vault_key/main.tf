# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A KEY VAULT KEY
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

#Key Vault Key
resource "azurerm_key_vault_key" "key" {
  name            = "key-${var.purpose}"
  key_vault_id    = var.keyvault_id
  key_type        = "RSA"
  key_size        = 2048
  key_opts        = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  expiration_date = formatdate("YYYY-MM-DD'T'00:00:00Z", timeadd(timestamp(), "8736h"))

  tags = local.tags

  lifecycle {
    ignore_changes = [expiration_date]
  }
}
