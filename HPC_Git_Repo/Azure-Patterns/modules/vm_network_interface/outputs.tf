output "nic_id" {
  value       = azurerm_network_interface.nic.id
#   value        = azurerm_network_interface.nic[*].id
  description = "The ID of the Network Interface associated with this Virtual Machine."
}
