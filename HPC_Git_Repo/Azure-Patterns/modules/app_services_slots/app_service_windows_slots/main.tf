
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
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
  count                = var.vnet_integration ? length(toset(var.staging_slot_name)) : 0
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

# This blocks creates the actual azure appservice. 
resource "azurerm_windows_web_app_slot" "windows_webapp_slot" {
  for_each                      = toset(var.staging_slot_name)
  name                          = each.value
  tags                          = local.common_tags
  app_settings                  = local.app_settings_slot
  app_service_id                = var.app_service_id
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

}

#---------------------------------------------------
# USE EXISTING LOG ANALYSTIC WORKSPACE
#---------------------------------------------------
data "azurerm_log_analytics_workspace" "lgworkspace" {
  name                = "${var.subcode}-gr-logs"
  resource_group_name = var.lgworkspace_rg
}

resource "azurerm_monitor_diagnostic_setting" "diagnos" {
  for_each                   = toset(var.staging_slot_name)
  name                       = "azapp-wn-${var.uai}-${var.appName}-${var.purpose}-${each.value}-ds"
  target_resource_id         = azurerm_windows_web_app_slot.windows_webapp_slot[each.key].id
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
    azurerm_windows_web_app_slot.windows_webapp_slot
  ]
}


/*
# This block is to get info od a private DNS zone for the app services
data "azurerm_private_dns_zone" "app_private_dns_zone" {
  name                = var.privatedns
  resource_group_name = data.azurerm_resource_group.rg_network.name
}

# This block creates  Private endpoint configuration for azure fuctions
resource "azurerm_private_endpoint" "app_service_pvtendpoint_slot" {
  for_each            = toset(var.staging_slot_name)
  name                = "pe-azapp-wn-${var.uai}-${var.appName}-${var.purpose}-${each.value}"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.application_subnet.id
  tags                = local.common_tags
  private_dns_zone_group {

    name                 = var.dns_zone_group
    private_dns_zone_ids = [data.azurerm_private_dns_zone.app_private_dns_zone.id]
  }

  private_service_connection {
    name                           = "pes-azapp-wn-${var.uai}-${var.appName}-${var.purpose}-${each.value}"
    private_connection_resource_id = var.app_service_id
    subresource_names              = ["sites-${each.value}"]
    is_manual_connection           = false
  }
  depends_on = [
    azurerm_windows_web_app_slot.windows_webapp_slot
  ]
}
*/
