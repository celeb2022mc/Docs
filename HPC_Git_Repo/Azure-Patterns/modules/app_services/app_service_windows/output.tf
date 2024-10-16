# App service plan id
output "app_service_id" {
  value = azurerm_windows_web_app.windows_webapp.id
}