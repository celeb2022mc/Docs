output "csl-id" {
  description = "The ID of the CSL service."
  value       = azurerm_cognitive_account.csl.id
}

output "csl-endpoint" {
  description = "The endpoint assigned to the CSL service."
  value       = azurerm_cognitive_account.csl.endpoint
}

output "csl-primary-key" {
  description = "The primary key of the CSL service."
  value       = azurerm_cognitive_account.csl.primary_access_key
  sensitive   = true
}

output "csl-secondary-key" {
  description = "The seconday key of the CSL service"
  value       = azurerm_cognitive_account.csl.secondary_access_key
  sensitive   = true
}
