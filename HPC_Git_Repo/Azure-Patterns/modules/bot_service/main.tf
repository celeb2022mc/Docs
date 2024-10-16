# CREATE A Bot Service
#--------------------------
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "> 1.12.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "> 2.15.0"
    }    
  }
}


locals {
  common_tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
  tags                              = local.common_tags
  api_version                       = "Microsoft.BotService/botServices@2022-09-15"
  developerAppInsightKey            = var.enable_app_insight ? data.azurerm_application_insights.app_insight[0].instrumentation_key : null
  developerAppInsightsApiKey        = var.enable_app_insight ? azurerm_application_insights_api_key.app_insight_api_key[0].api_key : null
  developerAppInsightsApplicationId = var.enable_app_insight ? data.azurerm_application_insights.app_insight[0].app_id : null
}

# This block reads the resource group where bot service app will be deployed
data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

# Service principle account for the key encryption
# data "azuread_service_principal" "bot_user" {
#   display_name = "Bot Service CMEK Prod"
# }

# Azure Application Insight
data "azurerm_application_insights" "app_insight" {
  count               = var.enable_app_insight ? 1 : 0
  name                = var.app_insight_name
  resource_group_name = var.resource_group
}

# Azure Application Insight API jey creation
resource "azurerm_application_insights_api_key" "app_insight_api_key" {
  count                   = var.enable_app_insight ? 1 : 0
  name                    = "bs-${var.uai}-${var.appName}-${var.purpose}"
  application_insights_id = data.azurerm_application_insights.app_insight[0].id
  read_permissions        = ["aggregate", "api", "draft", "extendqueries", "search"]
}

# Role assignment for the CMK encryption
resource "azurerm_role_assignment" "role_assignment" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.key_vault_rg}/providers/Microsoft.KeyVault/vaults/${var.key_vault_name}"
  role_definition_name = "Key Vault Crypto Service Encryption User"
  #principal_id         = "d74bf732-4e9a-41fc-b575-4e29c6bf08ab"
  principal_id         = var.service_principle_id

  lifecycle {
    ignore_changes = all
  }
}

# This blocks reads the virtual network where private endpoint app will be deployed
data "azurerm_virtual_network" "bsvnet" {
  name                = var.virtual_network
  resource_group_name = var.vnet_rg
}

# This blocks reads the subnet where private endpoint service app will be deployed
data "azurerm_subnet" "bsubnet" {
  name                 = var.subnet
  resource_group_name  = var.vnet_rg
  virtual_network_name = data.azurerm_virtual_network.bsvnet.name
}

/* // commented the code because it doesn't support public network disable and customer managed key encryption in azurerm 3.75.0 version.
resource "azurerm_bot_service_azure_bot" "bs" {
  name                         = "bs-${var.uai}-${var.appName}-${var.purpose}"
  resource_group_name          = var.resource_group
  location                     = var.location
  microsoft_app_id             = var.microsoft_app_id
  sku                          = var.sku
  endpoint                     = var.endpoint
  local_authentication_enabled = false
  tags                         = local.tags
}
*/

# Block to create the bot service.
resource "azapi_resource" "bs" {
  type      = local.api_version
  name      = "bs-${var.uai}-${var.appName}-${var.purpose}"
  location  = var.location
  parent_id = data.azurerm_resource_group.rg.id
  tags      = local.tags
  body = jsonencode({
    properties = {
      cmekKeyVaultUrl                   = var.key_vault_key_id
      developerAppInsightKey            = local.developerAppInsightKey
      developerAppInsightsApiKey        = local.developerAppInsightsApiKey
      developerAppInsightsApplicationId = local.developerAppInsightsApplicationId
      disableLocalAuth                  = false
      displayName                       = "bs-${var.uai}-${var.appName}-${var.purpose}"
      endpoint                          = var.endpoint
      isCmekEnabled                     = true
      isStreamingSupported              = var.enable_streaming
      msaAppId                          = var.microsoft_app_id
      publicNetworkAccess               = "Disabled"
    }
    sku = {
      name = var.sku
    }
    kind = "azurebot"
  })

  depends_on = [
    azurerm_role_assignment.role_assignment,
    azurerm_application_insights_api_key.app_insight_api_key
  ]

}

# DNS zone creation
# resource "azurerm_private_dns_zone" "dnszone" {
#   name                = var.private_dns_zone
#   resource_group_name = var.resource_group
# }

# Private endpoint creation
resource "azurerm_private_endpoint" "bsendpoint" {
  name                = "pe-${var.uai}-${var.appName}-${var.purpose}-bs"
  location            = var.private_endpoint_location
  resource_group_name = var.resource_group
  subnet_id           = data.azurerm_subnet.bsubnet.id

  private_service_connection {
    name                           = "bspe-${var.uai}-${var.appName}-${var.purpose}-privateserviceconnection"
    private_connection_resource_id = azapi_resource.bs.id
    subresource_names              = ["Bot"]
    is_manual_connection           = false
  }
  depends_on = [
    azapi_resource.bs
  ]
}
