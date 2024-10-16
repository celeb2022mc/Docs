terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
}



data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_subnet" "container_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}


data "azurerm_log_analytics_workspace" "lgworkspace" {
  name                = var.loganalytics_workspace_name
  resource_group_name = var.analytics_workspace_rg
}

locals {
  containergroup       = "${var.uai}-${var.appName}-containergroup"
  containername        = "${var.uai}-${var.appName}-instance"
}

resource "azurerm_container_group" "cinstance" {
  name                = local.containergroup
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_address_type     = "Private"
  subnet_ids          = [data.azurerm_subnet.container_subnet.id]
  os_type             = "Linux"
  restart_policy      = var.restart_policy

  container {
    name   = local.containername
    image  = var.image
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = var.port
      protocol = "TCP"
    }
  }

  diagnostics {
    log_analytics {
      workspace_id  = data.azurerm_log_analytics_workspace.lgworkspace.workspace_id
      workspace_key = data.azurerm_log_analytics_workspace.lgworkspace.primary_shared_key
    }
  }

  tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }

}
