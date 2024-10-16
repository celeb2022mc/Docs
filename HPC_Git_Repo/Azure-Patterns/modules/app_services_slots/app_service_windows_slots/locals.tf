# ...............local variables.............
locals {
  common_tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
  # default app settings for the app services   
  local_app_settings = var.enable_app_insight ? {
    APPLICATION_INSIGHTS_IKEY             = data.azurerm_application_insights.azure_app_insight[0].instrumentation_key
    APPINSIGHTS_INSTRUMENTATIONKEY        = data.azurerm_application_insights.azure_app_insight[0].instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = data.azurerm_application_insights.azure_app_insight[0].connection_string
  } : {}

  app_settings = merge(local.local_app_settings, var.app_settings)

  # default site confif for the app service.
  default_site_config = {
    always_on           = false
    minimum_tls_version = "1.2"
    http2_enabled       = false
  }

  site_config       = merge(local.default_site_config, var.site_config)
  app_settings_slot = var.staging_slot_custom_app_settings == null ? local.app_settings : merge(local.local_app_settings, var.staging_slot_custom_app_settings)

}
