output "instrumentation_key" {
  value     = azurerm_application_insights.ai.instrumentation_key
  sensitive = true
}

output "app_id" {
  value = azurerm_application_insights.ai.app_id
}
