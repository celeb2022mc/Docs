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

data "azurerm_subnet" "applicaton_gateway_subnet" {
  name                 = var.application_gateway_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg_name
}

data "azurerm_log_analytics_workspace" "lgworkspace" {
  name                = var.loganalytics_workspace_name
  resource_group_name = "cs-loganalytics"
}

locals {

  frontend_port_name                     = "${var.uai}-${var.subcode}-${var.appName}-port"
  frontend_ip_configuration_name_public  = "${var.uai}-${var.subcode}-${var.appName}-public-ip"
  frontend_ip_configuration_name_private = "${var.uai}-${var.subcode}-${var.appName}-pvt-ip"
  http_setting_name                      = "${var.uai}-${var.subcode}-${var.appName}-http-setting"

  zones = ["1", "2", "3"]

  capacity = {
    min = 2  #Minimum capacity for autoscaling. Accepted values are in the range 0 to 100.
    max = 15 #Maximum capacity for autoscaling. Accepted values are in the range 2 to 125.
  }

  diagonostic_logs = [
    "ApplicationGatewayAccessLog",
    "ApplicationGatewayPerformanceLog",
    "ApplicationGatewayFirewallLog"
  ]

  diagonostic_metrics = [
    "AllMetrics"
  ]
}

resource "azurerm_public_ip" "app_gateway_public_ip" {
  name                = "${var.uai}-${var.subcode}-${var.appName}-pip"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = local.zones // To create the application gateway with availibilty zones, public IP alse needs to be created with availibilty zones
  tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
}

/* //log analytics solution is not supported
resource "azurerm_log_analytics_solution" "log_analytics_solution" {
  solution_name         = "AzureAppGatewayAnalytics"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = "cs-loganalytics"
  workspace_resource_id = data.azurerm_log_analytics_workspace.lgworkspace.id
  workspace_name        = var.loganalytics_workspace_name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/AzureAppGatewayAnalytics"
  }

  tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
}
*/

resource "azurerm_application_gateway" "app_gateway" {

  # Added depends_on attribute to ensure proper order of execution

  #depends_on = [azurerm_log_analytics_solution.log_analytics_solution, azurerm_public_ip.app_gateway_public_ip] //log analytics solution is not supported
  depends_on = [azurerm_public_ip.app_gateway_public_ip]

  # Replaced name attribute with id attribute for referencing resources

  name                = "${var.uai}-${var.subcode}-${var.appName}-appgateway"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  enable_http2        = true
  zones               = local.zones

  # Replaced sku block with tier and capacity attributes
  sku {
    name = var.sku_type
    tier = var.sku_type
    #capacity = local.capacity.min  // In SKU_V2 either capacity in sku or capacity in autoscale_configuration can be used, that's why commented this block.
  }
  # Added autoscale_configuration block for autoscaling settings

  autoscale_configuration {
    min_capacity = local.capacity.min
    max_capacity = local.capacity.max
  }



  gateway_ip_configuration {
    name      = "${var.uai}-${var.subcode}-${var.appName}-ip-configuration"
    subnet_id = data.azurerm_subnet.applicaton_gateway_subnet.id
  }

  frontend_port {
    name = "${local.frontend_port_name}-443"
    port = 443
  }

  frontend_port {
    name = "${local.frontend_port_name}-80"
    port = "80"
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name_public
    public_ip_address_id = azurerm_public_ip.app_gateway_public_ip.id
  }

  //This block will only execute if internal resource 
  dynamic "frontend_ip_configuration" {
    for_each = var.gateway_type == "internal" ? tolist([local.frontend_ip_configuration_name_private]) : []
    iterator = each
    content {
      name                          = var.gateway_type == "internal" ? each.value : null
      private_ip_address_allocation = var.gateway_type == "internal" ? "Static" : null
      private_ip_address            = var.gateway_type == "internal" ? var.private_ip_address : null
      subnet_id                     = var.gateway_type == "internal" ? data.azurerm_subnet.applicaton_gateway_subnet.id : null
    }
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Enabled"
    path                  = var.backend_path
    port                  = var.backend_port
    protocol              = "Http"
    request_timeout       = 60
  }

  dynamic "backend_address_pool" {
    for_each = toset(var.backends)
    iterator = each
    content {
      name         = "${each.value.app_uai}-${each.value.app_short_name}-pool"
      fqdns        = each.value.fqdn != null ? each.value.fqdn : null
      ip_addresses = each.value.ip_address != null ? each.value.ip_address : null
    }
  }

  dynamic "ssl_certificate" {
    for_each = toset(var.ssl_certificates)
    iterator = each
    content {
      name                = each.value.certificate_name
      key_vault_secret_id = each.value.keyvault_cert_id
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.gateway_identity]
  }


  dynamic "http_listener" {
    for_each = toset(var.backends)
    iterator = each
    content {
      name                           = "${each.value.app_uai}-${each.value.app_short_name}-listener-https"
      frontend_ip_configuration_name = var.gateway_type == "internal" ? local.frontend_ip_configuration_name_private : local.frontend_ip_configuration_name_public
      frontend_port_name             = "${local.frontend_port_name}-443"
      protocol                       = "Https"
      require_sni                    = false
      host_name                      = each.value.host_name
      ssl_certificate_name           = each.value.certificate_name
    }
  }

  dynamic "http_listener" {
    for_each = toset(var.backends)
    iterator = each
    content {
      name                           = "${each.value.app_uai}-${each.value.app_short_name}-listener-http"
      frontend_ip_configuration_name = var.gateway_type == "internal" ? local.frontend_ip_configuration_name_private : local.frontend_ip_configuration_name_public
      frontend_port_name             = "${local.frontend_port_name}-80"
      protocol                       = "Http"
      host_name                      = each.value.host_name
    }
  }

  dynamic "request_routing_rule" {
    for_each = toset(var.backends)
    iterator = each
    content {
      name                       = "${each.value.app_uai}-${each.value.app_short_name}-rule-https"
      http_listener_name         = "${each.value.app_uai}-${each.value.app_short_name}-listener-https"
      rule_type                  = "Basic"
      backend_address_pool_name  = "${each.value.app_uai}-${each.value.app_short_name}-pool"
      backend_http_settings_name = local.http_setting_name
      priority                   = each.value.priority_https
    }
  }

  dynamic "redirect_configuration" {
    for_each = toset(var.backends)
    iterator = each
    content {
      name                 = "${each.value.app_uai}-${each.value.app_short_name}-redirectconfig"
      redirect_type        = "Permanent"
      include_path         = true
      include_query_string = true
      target_listener_name = "${each.value.app_uai}-${each.value.app_short_name}-listener-https"
    }
  }

  dynamic "request_routing_rule" {
    for_each = toset(var.backends)
    iterator = each
    content {
      name                        = "${each.value.app_uai}-${each.value.app_short_name}-rule-http"
      http_listener_name          = "${each.value.app_uai}-${each.value.app_short_name}-listener-http"
      rule_type                   = "Basic"
      redirect_configuration_name = "${each.value.app_uai}-${each.value.app_short_name}-redirectconfig"
      priority                    = each.value.priority_http
    }
  }

  tags = {
    uai          = var.uai
    env          = var.env
    appname      = var.appName
    gateway_type = var.gateway_type
  }

  // Uncomment below lines if you want to manage manually. 
  lifecycle {
    ignore_changes = [
      // backend_address_pool,
      // backend_http_settings,
      // frontend_port,
      // http_listener,
      probe,
      // request_routing_rule,
      // url_path_map,
      // ssl_certificate,
      // redirect_configuration,
      // autoscale_configuration

    ]
  }
}
resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  name                       = "${var.uai}-${var.subcode}-${var.appName}-diagnostic"
  target_resource_id         = azurerm_application_gateway.app_gateway.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.lgworkspace.id
  dynamic "enabled_log" {
    for_each = toset(local.diagonostic_logs)
    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = toset(local.diagonostic_metrics)
    content {
      category = metric.value
    }
  }
}

