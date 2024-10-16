
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
  name = var.resource_group
}

data "azurerm_log_analytics_workspace" "la" {
  name                = var.azurerm_log_analytics_workspace
  resource_group_name = var.loganalytics_rg_name
}

resource "azurerm_application_insights" "ai" {
  name                          = "ai-${var.uai}-${var.appname}-${var.purpose}"
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  workspace_id                  = data.azurerm_log_analytics_workspace.la.id
  local_authentication_disabled = true
  internet_ingestion_enabled    = false
  internet_query_enabled        = false
  application_type              = "web"

  tags = {
    uai     = var.uai
    appname = var.appname
    purpose = var.purpose
  }
}
