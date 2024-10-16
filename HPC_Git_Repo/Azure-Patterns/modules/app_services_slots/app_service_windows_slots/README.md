## Module Azure Windows App Services Slot(s)

Used to create Azure App Services Slot(s) based on Windows OS

## Released Versions

| Version | Ref Name | Description                   | Change Log                                     |
| ------- | -------- | ----------------------------- | ---------------------------------------------- |
| 1.0     | 1.0     | Initial release of module     | N/A                                            |
| 1.1     | 1.1     | Fixed Wiz Deffects     | N/A                                            |
| 1.2     | 1.2     | Tested and released module     | N/A                                            |

## Variables
| Name                            | Type         | Description                                                                    | example                                                                        | Optional? |
| ------------------------------- | ------------ | ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------ | --------- |
| subcode 			              | string       | subcription code              						                          | 327                                              							   | no        |
| staging_slot_name                 | list(string)       | name of one or multiple app service slots              	                                                  | staging_slot_name = ["stg", "uat"]                                           | no          |
| uai                             | string       | application uai                                                                | uai3026350                                                                     | no        |
| env							  | string		 | dev, qa, stg, prd 															  | dev 													   					   | no 	   |
| appName                         | string       | common name used to create infra resources                                     | app1                                                                           | no        |
| purpose                         | string       | purpose of the application                                                     | testing                          		                                       | no        |
| region						  | string		 | region																		  | "East US" or "West Europe"													   | no		   |
| vnet_name                       | string       | existing VnetName                                                              | 327-gr-vnet                                                                    | no        |
| resource_group                    | string       | resource Group for the App Service                                                    | rg-286-uai3026350-testing-01                                                               | no        |
| vnet_rg                    | string       | resource Group for the Vnet                                                    | cs-connectedVNET                                                               | no        |
| subnet_name                     | string       | existing subnet name for private endpoint creation                                                       | Application-Subnet                                                             | no        |
| app_service_id                         | string       | app service id for the slot, that depends upon the app_services/app_service_windows module           					                  | module.app_service_windows                                                               | no     |
| vnet_integration_subnet                    | string	     | existing dedicated subnet for vnet integration, mentioned delegation must be enabled in the subnet //Microsoft.Web/serverFarms    ,  default value is null  , depends on the    vnet_integration variable.                                           | Integration-Subnet                            				                               | yes        |
| vnet_integration			          | bool         | enable vnet integration in app service, default value is true                  	                                      | true                    						                               | yes       |
| enable_app_insight                            | bool       | enable appinsight integration with app service   , default value is false                                                      | false													   | yes        |
| lgworkspace_rg				      | string       | resource group for the log analytics workspace     			                              | cs-loganalytics			  									   | yes        |
| dns_zone_group			      | string       | dns zone group for private end point     			                          | dns-app			  															   | no        |
| appinsight_name			      | string       | Application Insight name, depends on the  enable_app_insight variable    			                          | appinsight-appservices			  															   | yes        |
| app_settings			      | map(string)       | app settings in form of key value pair    			                          | app_settings = { "key1" = "value1" "key2" = "value2"}	  | yes  |
| connection_strings			      | list(map(string))       | connection string in app services        | connection_strings = [{ name      = "dbconnection"  type  = "SQLServer" value  = "Server=some-server.mydomain.com;Integrated Security=SSPI"  sensitive = true }] | yes |
| staging_slot_custom_app_settings			      | map(string)       | custom app settings for the stagintg slot(s) | staging_slot_custom_app_settings = { "key_slot1" = "value_slot1" } | yes |
| site_config | any | A key-value pair of site config for the app service  | site_config = { http2_enabled = false   application_stack = { current_stack  = "dotnet" dotnet_version = "v6.0" }}	| no|

## Application Specific parameters are passed through site_config variables


| parameters Name                            | Variable Name         | Description                                                                    | example                                                    | Optional? |
| ------------------------------- | ------------ | ------------------------------------------------------------------------------ | ---------------------------------------------------------- | --------- |
| http2_enabled 				      | site_config         | enable http2.0 in app service, default value if false  | http2_enabled = false   | yes       |
| always_on 				      | site_config         | to keep your app service active, default value is false    | always_on           = false   | yes       |
| minimum_tls_version 				      | site_config         | A TLS version for app service, default value is 1.2 | minimum_tls_version = "1.2"   | yes       |
| ftps_state 				      | site_config         | enable ftp in app service, default is Disabled  | ftps_state = "Disabled"   | yes       |
| remote_debugging_enabled 				      | site_config         | enable remote debugging, default is false  | remote_debugging_enabled = false   | yes       |
| scm_type 				      | site_config         | provide scm_type for deployment, default is null  | scm_type = null   | yes       |

## Application Runtime Stack parameters are passed through site_config variables inside application_stack block.


| parameters Name                            | Variable Name         | Description                                                                    | example                                                    | Optional? |
| ------------------------------- | ------------ | ------------------------------------------------------------------------------ | ---------------------------------------------------------- | --------- |
| current_stack 				      | application_stack in site_config         | cuurent runtime stack for app service, Only one runtime stack can be paased at a time. options are dotnet, dotnetcore, node, python, php, java  | current_stack  = "dotnet"   | yes       |
| dotnet_version 				      | application_stack in site_config         | version of dotnet framework    | dotnet_version = "v6.0"   | yes       |
| java_container 				      | application_stack in site_config         | java container name | java_container = "TOMCAT" or java_container = "JAVA"  | yes       |
| java_container_version 				      | application_stack in site_config         | version of java container  | java_container_version = "9.0""   | yes       |
| java_version 				      | application_stack in site_config         | version of java, The version of Java to use when current_stack is set to java, version options 1.8, 1.8.0_322, 11, 11.0.14, 17 and 17.0.2  | java_version = "11"   | yes       |
| node_version 				      | application_stack in site_config         | version of node, The version of node to use when current_stack is set to node. Possible values are ~12, ~14, ~16, and ~18  | node_version = "~12"   | yes       |
| php_version 				      | application_stack in site_config         | version of php, The version of PHP to use when current_stack is set to php. Possible values are 7.1, 7.4 and Off  | php_version = "7.1"   | yes       |
| python_version  | application_stack in site_config         | version of python, The windows app doesn't support the latest version, it only support till 3.6, for latest use linux OS based app service.  | python_version = "3.6"   | yes       |

## Example Usage
```
module "app_service_windows" {
  source                  = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/app_services/app_service_windows?ref=1.6"
  subcode                 = var.subcode
  uai                     = var.uai
  env                     = var.env
  appName                 = var.appName
  resource_group          = module.resource_group.rg-name
  purpose                 = var.purpose
  vnet_name               = var.vnet_name
  vnet_rg                 = var.vnet_rg
  vnet_integration_subnet = var.integration_subnet //Microsoft.Web/serverFarms
  enable_app_insight      = true
  appinsight_name         = "ai-${var.uai}-${var.appName}-${var.purpose}"
  app_service_plan        = var.app_service_win_plan
  app_settings = {
    "key1" = "value1"
    "key2" = "value2"
  }
  connection_strings = [
    {
      name      = "dbconnection"
      type      = "SQLServer"
      value     = "Server=some-server.mydomain.com;Integrated Security=SSPI"
      sensitive = true
    }
  ]

  site_config = {
    application_stack = {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }

  sticky_settings = {
    app_setting_names       = ["key1", "key2"]
    connection_string_names = ["dbconnection"]
  }

  
  depends_on                      = [module.resource_group]
}

module "app_service_windows_slots" {
  source                  = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/app_services_slots/app_service_windows_slots?ref=1.6"
  subcode                 = var.subcode
  uai                     = var.uai
  env                     = var.env
  appName                 = var.appName
  resource_group          = module.resource_group.rg-name
  purpose                 = var.purpose
  vnet_name               = var.vnet_name
  vnet_rg                 = var.vnet_rg
  vnet_integration_subnet = var.integration_subnet //Microsoft.Web/serverFarms
  vnet_integration        = true
  enable_app_insight      = true
  appinsight_name         = "ai-${var.uai}-${var.appName}-${var.purpose}"
  app_service_id          = module.app_service_windows.app_service_id
  app_settings = {
    "key1" = "value1"
    "key2" = "value2"
  }
  connection_strings = [
    {
      name      = "dbconnection"
      type      = "SQLServer"
      value     = "Server=some-server.mydomain.com;Integrated Security=SSPI"
      sensitive = true
    }
  ]

  staging_slot_name = ["stg", "uat"]

  site_config = {
    application_stack = {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
    }
  }

  staging_slot_custom_app_settings = {
    "key_slot1" = "value_slot1"
  }
  depends_on = [module.app_service_windows] // dependency of the app_service_id variable and other keys
}
```
## Details

Creates a azure app service slot(s) based on Windows OS that follows our baseline configuration
