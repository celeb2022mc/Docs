output "search-service-id" {
  description = "The ID of the Cognitive Search service."
  value       = azurerm_search_service.cognitive-search.id
}

output "search-service_primary-key" {
  description = "The primary key used for Cognitive Search service Administration."
  value       = azurerm_search_service.cognitive-search.primary_key
}

output "search-service_secondary-key" {
  description = "The secondary key used for Cognitive Search service Administration."
  value       = azurerm_search_service.cognitive-search.secondary_key
}

output "search-service_query-keys" {
  description = "Query keys"
  value       = azurerm_search_service.cognitive-search.query_keys
}

output "search-service_query-keys_map" {
  description = "Query keys, returned as a map with array of values."
  value       = { for e in azurerm_search_service.cognitive-search.query_keys : e.name => e.key... }
}

output "search-service-url" {
  description = "URL of the Cognitive Search service."
  value       = "https://pe-${var.uai}-${var.appName}-${var.purpose}.search.windows.net"
}
