output "disk_id" {
  value = toset([
    for disk in azurerm_managed_disk.datadisk : disk.id
  ])
  description = "The ID of the provisioned managed disk"
}