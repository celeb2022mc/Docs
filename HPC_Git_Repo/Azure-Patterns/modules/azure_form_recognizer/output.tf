output "fr-id" {
  description = "The ID of the FR service."
  value       = azurerm_cognitive_account.fr.id
}

output "fr-endpoint" {
  description = "The endpoint assigned to the FR service."
  value       = azurerm_cognitive_account.fr.endpoint
}

output "fr-primary-key" {
  description = "The primary key of the FR service."
  value       = azurerm_cognitive_account.fr.primary_access_key
  sensitive   = true
}

output "fr-secondary-key" {
  description = "The seconday key of the FR service"
  value       = azurerm_cognitive_account.fr.secondary_access_key
  sensitive   = true
}
