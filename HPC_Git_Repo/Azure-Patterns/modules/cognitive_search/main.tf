terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "> 3.2.1"
    }
  }
}

data "azurerm_subnet" "search-subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.vnet_rg
  virtual_network_name = var.virtual_network
}

locals {
  common_tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
  tags = local.common_tags
}

# Create the Coginitive Search service
resource "azurerm_search_service" "cognitive-search" {
  name                         = "cs-${var.uai}-${var.appName}-${var.purpose}"
  location                     = var.region
  resource_group_name          = var.resource_group
  sku                          = var.sku
  replica_count                = var.replica_count
  partition_count              = var.partition_count
  local_authentication_enabled = false
  # allowed_ips                   = var.allowed_ips
  public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

# Create the private endpoint for Cognitive Search
resource "azurerm_private_endpoint" "search-endpoint" {
  name                = "pe-${var.uai}-${var.appName}-${var.purpose}"
  location            = var.region
  resource_group_name = var.resource_group
  subnet_id           = data.azurerm_subnet.search-subnet.id

  private_service_connection {
    name                           = "pe-${var.uai}-${var.appName}-${var.purpose}-privateserviceconnection"
    private_connection_resource_id = azurerm_search_service.cognitive-search.id
    is_manual_connection           = false
    subresource_names              = ["searchService"]
  }

  tags = local.tags
}

# Create custom query keys for Coginitive Search service
resource "null_resource" "query-key" {
  for_each = toset(var.query_keys)

  provisioner "local-exec" {
    command = <<-EOT
      az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
      az rest --method post --url https://management.azure.com${azurerm_search_service.cognitive-search.id}/createQueryKey/${each.key}?api-version=2020-08-01
    EOT
  }

  triggers = {
    key_name    = each.key
    resource_id = azurerm_search_service.cognitive-search.id
  }
}

