terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.75.0"
    }
  }
}

# This blocks reads the resource group where Azure appservice app will be deployed 
data "azurerm_resource_group" "rg" {
  name = var.resource_group
}


# This blocks reads the resource group where Azure network details are stored . 
data "azurerm_resource_group" "rg_network" {
  name = var.vnet_rg
}


# This blocks reads the  Azure VNet details that will be used to deploy Azure fuction App in case we choose Vnet Integration
data "azurerm_virtual_network" "gr-vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg_network.name

}

# # Subnet used for private endpoints
# data "azurerm_subnet" "application_subnet" {
#   name                 = var.subnet_name
#   virtual_network_name = data.azurerm_virtual_network.gr-vnet.name
#   resource_group_name  = data.azurerm_resource_group.rg_network.name
# }

# Subnet used for vnet integration
data "azurerm_subnet" "vnet_integration_subnet" {
  count                = var.vnet_integration ? 1 : 0
  name                 = var.vnet_integration_subnet
  virtual_network_name = data.azurerm_virtual_network.gr-vnet.name
  resource_group_name  = data.azurerm_resource_group.rg_network.name
}

# App Insight for App Services
data "azurerm_application_insights" "azure_app_insight" {
  count               = var.enable_app_insight ? 1 : 0
  name                = var.appinsight_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_service_plan" "service_plan" {
  name                = var.app_service_plan
  resource_group_name = data.azurerm_resource_group.rg.name
}

# This blocks creates the actual azure appservice. 
resource "azurerm_windows_web_app" "windows_webapp" {
  name                          = "azapp-wn-${var.uai}-${var.appName}-${var.purpose}"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  https_only                    = var.https_only
  service_plan_id               = data.azurerm_service_plan.service_plan.id
  tags                          = local.common_tags
  app_settings                  = local.app_settings
  public_network_access_enabled = var.public_access
  virtual_network_subnet_id     = var.vnet_integration ? data.azurerm_subnet.vnet_integration_subnet[0].id : null

  dynamic "site_config" {
    for_each = [local.site_config]
    content {
      windows_fx_version       = lookup(site_config.value, "windows_fx_version", null)
      always_on                = lookup(site_config.value, "always_on", false)
      minimum_tls_version      = lookup(site_config.value, "minimum_tls_version", false)
      http2_enabled            = lookup(site_config.value, "http2_enabled", null)
      ftps_state               = lookup(site_config.value, "ftps_state", "Disabled")
      remote_debugging_enabled = lookup(site_config.value, "remote_debugging_enabled", false)
      scm_type                 = lookup(site_config.value, "scm_type", null)
      vnet_route_all_enabled   = var.vnet_integration ? true : false

      dynamic "application_stack" {
        for_each = lookup(site_config.value, "application_stack", null) == null ? [] : ["application_stack"]
        content {
          current_stack          = lookup(local.site_config.application_stack, "current_stack", null)
          dotnet_version         = lookup(local.site_config.application_stack, "dotnet_version", null)
          java_container         = lookup(local.site_config.application_stack, "java_container", null)
          java_container_version = lookup(local.site_config.application_stack, "java_container_version", null)
          java_version           = lookup(local.site_config.application_stack, "java_version", null)
          node_version           = lookup(local.site_config.application_stack, "node_version", null)
          php_version            = lookup(local.site_config.application_stack, "php_version", null)
          python_version         = lookup(local.site_config.application_stack, "python_version", null)
        }
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }

  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = lookup(connection_string.value, "name", null)
      type  = lookup(connection_string.value, "type", null)
      value = lookup(connection_string.value, "value", null)
    }
  }

  dynamic "sticky_settings" {
    for_each = var.sticky_settings == null ? [] : [var.sticky_settings]
    content {
      app_setting_names       = sticky_settings.value.app_setting_names
      connection_string_names = sticky_settings.value.connection_string_names
    }
  }

}

#---------------------------------------------------
# USE EXISTING LOG ANALYSTIC WORKSPACE
#---------------------------------------------------
data "azurerm_log_analytics_workspace" "lgworkspace" {
  name                = "${var.subcode}-gr-logs"
  resource_group_name = var.lgworkspace_rg
}

resource "azurerm_monitor_diagnostic_setting" "diagnos" {
  name                       = "azapp-wn-${var.uai}-${var.appName}-${var.purpose}"
  target_resource_id         = azurerm_windows_web_app.windows_webapp.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lgworkspace.id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceAppLogs"
  }

  metric {
    category = "AllMetrics"
  }

  depends_on = [
    azurerm_windows_web_app.windows_webapp
  ]
}


/*
# This block is to get info od a private DNS zone for the app services
data "azurerm_private_dns_zone" "app_private_dns_zone" {
  name                = var.privatedns
  resource_group_name = data.azurerm_resource_group.rg_network.name
}

# This block creates  Private endpoint configuration when azure private dns zone already exists.
resource "azurerm_private_endpoint" "app_service_pvtendpoint" {
  name                = "pe-${azurerm_windows_web_app.windows_webapp.name}"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.application_subnet.id
  tags                = local.common_tags

  private_dns_zone_group {

    name                 = var.dns_zone_group
    private_dns_zone_ids = [data.azurerm_private_dns_zone.app_private_dns_zone.id]
  }

  private_service_connection {
    name                           = "pes-${azurerm_windows_web_app.windows_webapp.name}"
    private_connection_resource_id = azurerm_windows_web_app.windows_webapp.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  depends_on = [
    azurerm_windows_web_app.windows_webapp
  ]
}
*/
