output "id" {
  value       = module.vm_linux.vm_id
  description = "The ID of the Linux Virtual Machine."
}

output "private_ip_address" {
  value       = module.vm_linux.private_ip
  description = "The Primary Private IP Address assigned to this Virtual Machine."
}

output "virtual_machine_id" {
  value       = module.vm_linux.virtual_machine_id
  description = "A 128-bit identifier which uniquely identifies this Virtual Machine."
}