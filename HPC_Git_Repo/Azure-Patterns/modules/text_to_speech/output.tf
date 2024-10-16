output "ss-id" {
  description = "The ID of the SS service."
  value       = azurerm_cognitive_account.ss.id
}

output "ss-endpoint" {
  description = "The endpoint assigned to the SS service."
  value       = azurerm_cognitive_account.ss.endpoint
}

output "ss-primary-key" {
  description = "The primary key of the SS service."
  value       = azurerm_cognitive_account.ss.primary_access_key
  sensitive   = true
}

output "ss-secondary-key" {
  description = "The seconday key of the SS service"
  value       = azurerm_cognitive_account.ss.secondary_access_key
  sensitive   = true
}
