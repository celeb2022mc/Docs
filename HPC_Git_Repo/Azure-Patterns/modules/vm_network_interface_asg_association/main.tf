# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE NETWORK INTERFACE ASG ASSOCIATIONS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.75.0"
    }
  }
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DATA
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# data "azurerm_application_security_group" "asgs" {
#   for_each             = var.asgs
#   name                 = each.value.asg_name
#   resource_group_name  = each.value.asg_rgname
# }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# RESOURCES
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "azurerm_network_interface_application_security_group_association" "associations" {
  for_each                      = var.asgs
  network_interface_id          = var.nic_id
#   network_interface_id            = toset(azurerm_network_interface.nic[*].id)
#    for_each                      = toset(azurerm_network_interface.nic[*].id)
#    network_interface_id          = azurerm_network_interface.nic[*].id
  application_security_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/${each.value.asg_rgname}/providers/Microsoft.Network/applicationSecurityGroups/${each.value.asg_name}"

  lifecycle {
    ignore_changes = [network_interface_id]
  }
}
