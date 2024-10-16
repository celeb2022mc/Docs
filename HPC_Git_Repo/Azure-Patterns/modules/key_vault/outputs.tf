output "keyvault-id" {
  value = azurerm_key_vault.keyvault.id
}

output "keyvault-name" {
  value = azurerm_key_vault.keyvault.name
}

output "keyvault-rg" {
  value = azurerm_key_vault.keyvault.resource_group_name
}
