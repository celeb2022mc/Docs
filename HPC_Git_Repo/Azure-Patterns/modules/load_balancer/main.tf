terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
}

locals {
  common_tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
  tags = local.common_tags
}

data "azurerm_subnet" "frontend_subnet" {
  name                 = var.frontend_subnet_name
  resource_group_name  = var.vnet_rg
  virtual_network_name = var.virtual_network
}

resource "azurerm_lb" "lb" {
  name                = "lb-${var.uai}-${var.appName}-${var.purpose}"
  resource_group_name = var.resource_group
  location            = var.region
  sku                 = var.lb_sku
  tags                = local.tags

  frontend_ip_configuration {
    name                          = "lb-ip-${var.uai}-${var.appName}-${var.purpose}"
    subnet_id                     = data.azurerm_subnet.frontend_subnet.id
    private_ip_address_allocation = var.frontend_private_ip_address_allocation
    private_ip_address            = var.frontend_private_ip_address_allocation == "Static" ? var.private_ip_address : null
    zones                         = var.zones
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  count               = length(var.backend_pools)
  name                = var.backend_pools[count.index].name
  loadbalancer_id     = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "lb-probe" {
  count               = length(var.lb_probe)
  name                = "lb-probe-${var.uai}-${var.appName}-${var.purpose}-${count.index}"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 0)
  port                = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 1)
  interval_in_seconds = var.lb_probe_interval
  number_of_probes    = var.lb_probe_unhealthy_threshold
  request_path        = element(var.lb_probe[element(keys(var.lb_probe), count.index)], 2)
}

resource "azurerm_lb_rule" "lb-rule" {
  count                          = length(var.backend_pools)
  name                           = "lb-rule-${var.uai}-${var.appName}-${var.purpose}-${count.index}"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = element(var.lb_port[element(keys(var.lb_port), count.index)], 1)
  frontend_port                  = element(var.lb_port[element(keys(var.lb_port), count.index)], 0)
  backend_port                   = element(var.lb_port[element(keys(var.lb_port), count.index)], 2)
  frontend_ip_configuration_name = "lb-ip-${var.uai}-${var.appName}-${var.purpose}"
  enable_floating_ip             = false
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool[count.index].id]
  idle_timeout_in_minutes        = 10
  probe_id                       = element(azurerm_lb_probe.lb-probe[*].id, count.index)
}

data "azurerm_network_interface" "network-interface" {
  count               = length(var.ni_associations)
  name                = var.ni_associations[count.index]
  resource_group_name = var.resource_group
}

locals {
  # Create a list of backend pool associations with NIC names
  nic_to_backend_pool_list = flatten([
    for idx, pool in var.backend_pools : [
      for ni in pool.ni_associations : {
        nic_name        = ni
        backend_pool_id = azurerm_lb_backend_address_pool.backend_pool[idx].id
        key             = "${pool.name}-${ni}"
      }
    ]
  ])
  # Convert the list to a map
  nic_to_backend_pool = {
    for item in local.nic_to_backend_pool_list : item.key => {
      nic_name        = item.nic_name
      backend_pool_id = item.backend_pool_id
    }
  }
}

data "azurerm_network_interface" "network_interface" {
  for_each            = local.nic_to_backend_pool
  name                = each.value.nic_name
  resource_group_name = var.resource_group
}

resource "azurerm_network_interface_backend_address_pool_association" "backendpoolassociation" {
  for_each                = local.nic_to_backend_pool
  network_interface_id    = data.azurerm_network_interface.network_interface[each.key].id
  ip_configuration_name   = data.azurerm_network_interface.network_interface[each.key].ip_configuration[0].name
  backend_address_pool_id = each.value.backend_pool_id
}
