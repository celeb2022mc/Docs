output "vm_id" {
  value       = azurerm_windows_virtual_machine.windows_vm.id
  description = "The ID of the Windows Virtual Machine"
}

output "virtual_machine_id" {
  value       = azurerm_windows_virtual_machine.windows_vm.virtual_machine_id
  description = "A 128-bit identifier which uniquely identifies this Virtual Machine"
}

output "private_ip" {
  value       = azurerm_windows_virtual_machine.windows_vm.private_ip_address
  description = "The private IP of the Windows Virtual Machine"
}

# output "password" {
#   value       = random_password.password.result
#   description = "The password for the Windows Virtual Machine"
# }

output "computer_name" {
  value       = azurerm_windows_virtual_machine.windows_vm.computer_name
  description = "The computer name for the Windows Virtual Machine"
}


