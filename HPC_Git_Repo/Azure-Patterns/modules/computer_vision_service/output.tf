output "acv-id" {
  description = "The ID of the ACV service."
  value       = azurerm_cognitive_account.acv.id
}

output "acv-endpoint" {
  description = "The endpoint assigned to the ACV service."
  value       = azurerm_cognitive_account.acv.endpoint
}

output "acv-primary-key" {
  description = "The primary key of the ACV service."
  value       = azurerm_cognitive_account.acv.primary_access_key
  sensitive   = true
}

output "acv-secondary-key" {
  description = "The seconday key of the ACV service"
  value       = azurerm_cognitive_account.acv.secondary_access_key
  sensitive   = true
}
