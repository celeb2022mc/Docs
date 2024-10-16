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
  os_type           = var.os_type == "Linux" ? "lx" : "wn"
  service_plan_name = "app-${local.os_type}-${var.uai}-${var.env}-${var.appName}"
}

# This blocks reads the resource group where logic app will be hosted
data "azurerm_resource_group" "rg" {
  #name = var.resource_group
  name = "rg-${var.subcode}-${var.uai}-${var.appName}"

}

# This blocks creates the App service plan which is used by Azure appservice it also lets us choose the hosting plan ( ASP / premium)
resource "azurerm_service_plan" "service_plan" {
  name                       = local.service_plan_name
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = data.azurerm_resource_group.rg.location
  app_service_environment_id = var.app_service_environment_id
  os_type                    = var.os_type
  sku_name                   = var.sku_name
  tags                       = local.common_tags
}

#---------------------------------------------------
# USE EXISTING LOG ANALYSTIC WORKSPACE
#---------------------------------------------------
data "azurerm_log_analytics_workspace" "lgworkspace" {
  name                = "${var.subcode}-gr-logs"
  resource_group_name = var.lgworkspace_rg
}

resource "azurerm_monitor_diagnostic_setting" "diagnos" {
  name                       = "${local.service_plan_name}-ds"
  target_resource_id         = azurerm_service_plan.service_plan.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lgworkspace.id

  metric {
    category = "AllMetrics"
  }

  depends_on = [
    azurerm_service_plan.service_plan
  ]
}
