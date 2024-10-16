# App service plan id
output "app_service_id" {
  value = azurerm_linux_web_app.linux_webapp.id
}