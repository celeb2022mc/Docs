# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE AN NSG RULE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
}



resource "azurerm_network_security_rule" "rule" {
  name                        = var.sec_rule_name
  resource_group_name         = var.resource_group
  network_security_group_name = var.nsg_name
  description                 = var.description
  protocol                    = var.protocol
  source_port_range           = "*"
  destination_port_range      = length(var.destination_port_ranges) == 1 ? var.destination_port_ranges[0] : null
  destination_port_ranges     = length(var.destination_port_ranges) > 1 ? var.destination_port_ranges : null
  /*
  the logic for source_address and source_applicaiton_security_group is as follows:
  You can only have one of the three [ source_address_prefix,  source_address_prefixs,  source_application_security_group_ids]

  source_address_prefix - Is only used when there is exactly 1 item in the source_address_prefixes list and no items in the source_application_security_group_ids list.
  source_address_prefixs - Is only used when there is more than 1 item in the source_address_prefixes list and no items in the source_application_security_group_ids list.
  source_application_security_group_ids - Is used when the source_address_prefixes has no items and source_application_security_group_ids has at least 1 item.
  */
  source_address_prefix                 = length(var.source_address_prefixes) == 1 && length(var.source_application_security_group_ids) < 1 ? var.source_address_prefixes[0] : null
  source_address_prefixes               = length(var.source_address_prefixes) > 1 && length(var.source_application_security_group_ids) < 1 ? var.source_address_prefixes : null
  source_application_security_group_ids = length(var.source_address_prefixes) == 0 && length(var.source_application_security_group_ids) > 0 ? var.source_application_security_group_ids : null

  /*
  Same logic as above for source_address and source_application
  */
  destination_address_prefix                 = length(var.destination_address_prefixes) == 1 && length(var.destination_application_security_group_ids) < 1 ? var.destination_address_prefixes[0] : null
  destination_address_prefixes               = length(var.destination_address_prefixes) > 1 && length(var.destination_application_security_group_ids) < 1 ? var.destination_address_prefixes : null
  destination_application_security_group_ids = length(var.destination_address_prefixes) == 0 && length(var.destination_application_security_group_ids) > 0 ? var.destination_application_security_group_ids : null

  access    = var.access
  priority  = var.priority
  direction = var.direction
}
