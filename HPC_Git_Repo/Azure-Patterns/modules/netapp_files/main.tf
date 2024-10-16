terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
}

data "azurerm_subnet" "anf-subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.vnet_rg
  virtual_network_name = "${var.subcode}-gr-vnet"
}

# Create the Azure NetApp Files subnet
# resource "null_resource" "anf-subnet" {
#   provisioner "local-exec" {
#     command = <<EOT
#       az login --service-principal -u $env:ARM_CLIENT_ID -p $env:ARM_CLIENT_SECRET --tenant $env:ARM_TENANT_ID;
#       az account set --subscription ${var.subscription_id};
#       az network vnet subnet create -g ${var.vnet_rg} --vnet-name ${var.vnet_name} -n ${var.subnet_name} --address-prefixes ${var.subnet_address_prefixes} --delegations ${var.subnet_service_delegations} --disable-private-endpoint-network-policies true
#     EOT
#     working_dir = "C:\\"
#     interpreter = ["pwsh", "-Command"]
#   }

#   lifecycle {
#     ignore_changes = all
#   }
# }

# Create the Azure NetApp Files account
resource "azurerm_netapp_account" "anf-account" {
  name                = "anf-${var.uai}-${var.appName}-${var.purpose}"
  resource_group_name = var.resource_group
  location            = var.region
  tags = {
    uai = var.uai
    env = var.env
  }
}

# Create the Azure NetApp Files pool
resource "azurerm_netapp_pool" "anf-pool" {
  name                = "anfp-${var.uai}-${var.appName}-${var.purpose}"
  account_name        = azurerm_netapp_account.anf-account.name
  location            = var.region
  resource_group_name = var.resource_group
  service_level       = var.pool_service_level
  size_in_tb          = var.pool_size
  tags = {
    uai = var.uai
    env = var.env
  }
}

# Create the Azure NetApp Files volume
resource "azurerm_netapp_volume" "anf-vol" {
  for_each            = var.volume_configs
  name                = "nfv-${var.uai}-${var.appName}-${var.purpose}-${each.key}"
  location            = var.region
  resource_group_name = var.resource_group
  account_name        = azurerm_netapp_account.anf-account.name
  pool_name           = azurerm_netapp_pool.anf-pool.name
  volume_path         = each.value.volume_path
  service_level       = var.volume_service_level
  subnet_id           = data.azurerm_subnet.anf-subnet.id
  protocols           = var.volume_protocol
  # security_style            = "Unix"
  storage_quota_in_gb = each.value.volume_quota
  # snapshot_directory_visible = false
  tags = {
    uai = var.uai
    env = var.env
  }
  dynamic "export_policy_rule" {
    for_each = each.value.export_policy
    content {
      rule_index          = export_policy_rule.key
      allowed_clients     = export_policy_rule.value.allowed_clients
      protocols_enabled   = var.volume_protocol
      unix_read_only      = export_policy_rule.value.access_level == "read_only" ? true : false
      unix_read_write     = export_policy_rule.value.access_level == "read_write" ? true : false
      root_access_enabled = export_policy_rule.value.root_access_enabled
    }
  }
  lifecycle {
    prevent_destroy = true
  }
}
