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

# Subnet for container registry private endpoint
data "azurerm_subnet" "cr-subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.vnet_rg
  virtual_network_name = var.virtual_network
}

# Create the container registry service
resource "azurerm_container_registry" "cr" {
  name                = "cr${var.uai}${var.appName}${var.purpose}"
  location            = var.region
  resource_group_name = var.resource_group
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  public_network_access_enabled = false
  anonymous_pull_enabled =  false

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

# Create the private endpoint for container registry service
resource "azurerm_private_endpoint" "cr-endpoint" {
  depends_on          = [azurerm_container_registry.cr]
  name                = "pe-${var.uai}-${var.appName}-${var.purpose}-cr"
  location            = var.region
  resource_group_name = var.resource_group
  subnet_id           = data.azurerm_subnet.cr-subnet.id

  private_service_connection {
    name                           = "pe-${var.uai}-${var.appName}-${var.purpose}-cr-privateserviceconnection"
    private_connection_resource_id = azurerm_container_registry.cr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  tags = local.tags
}

#---------------------------------------------------
# USE EXISTING LOG ANALYSTIC WORKSPACE
#---------------------------------------------------

data "azurerm_log_analytics_workspace" "lgworkspace" {
  name                = var.loganalytics_workspace_name
  resource_group_name = var.loganalytics_rg
}

#---------------------------------------------------
# ENBLE DIAGNOSTIC SETTING TO USE LOG ANALYTICS WORKSPACE
#---------------------------------------------------

resource "azurerm_monitor_diagnostic_setting" "diagnos" {
  name                       = "cr-${var.uai}-${var.appName}-${var.purpose}-ds"
  target_resource_id         = azurerm_container_registry.cr.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lgworkspace.id

  enabled_log {
    category = "ContainerRegistryRepositoryEvents"
  }

  metric {
    category = "AllMetrics"
  }

  lifecycle {
    ignore_changes = [log, metric]
  }
}

#---------------------------------------------------
# CREATE NEW RESOURCE LOCK FOR CONTAINER REGISTRY
#---------------------------------------------------
resource "azurerm_management_lock" "cr" {
  name       = "cr-resource-lock"
  scope      = azurerm_container_registry.cr.id
  lock_level = "CanNotDelete"
  notes      = "TERRAFORM CREATED RESOURCE"
}
