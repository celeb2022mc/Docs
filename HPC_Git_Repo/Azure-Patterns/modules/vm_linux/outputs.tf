output "vm_id" {
  value       = azurerm_linux_virtual_machine.linux_vm.id
  description = "The ID of the Linux Virtual Machine"
}

output "virtual_machine_id" {
  value       = azurerm_linux_virtual_machine.linux_vm.virtual_machine_id
  description = "A 128-bit identifier which uniquely identifies this Virtual Machine"
}

output "private_ip" {
  value       = azurerm_linux_virtual_machine.linux_vm.private_ip_address
  description = "The private IP of the Linux Virtual Machine"
}

