output "availability_set_id" {
  value       = azurerm_availability_set.as.id
  description = "The ID of the provisioned availability set"
}