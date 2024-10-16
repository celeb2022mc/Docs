output "id" {
  value       = module.vm_windows.vm_id
  description = "The ID of the Windows Virtual Machine."
}

output "private_ip_address" {
  value       = module.vm_windows.private_ip
  description = "The Primary Private IP Address assigned to this Virtual Machine."
}

output "virtual_machine_id" {
  value       = module.vm_windows.virtual_machine_id
  description = "A 128-bit identifier which uniquely identifies this Virtual Machine."
}