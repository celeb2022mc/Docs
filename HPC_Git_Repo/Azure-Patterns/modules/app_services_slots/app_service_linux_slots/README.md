## Module Azure Linux App Services Slot(s)

Used to create Azure App Services Slot(s) based on Linux OS

## Released Versions

| Version | Ref Name | Description                   | Change Log                                     |
| ------- | -------- | ----------------------------- | ---------------------------------------------- |
| 1.0     | 1.9     | Initial release of module     | N/A                                            |
| 1.1     | 1.1     | Fixed wiz deffects- Identity settings     | N/A                                            |
| 1.1     | 1.1     | Applied Execeptions- azurerm_virtual_network[gr-vnet]     | N/A                                            |
| 1.2     | 1.2     | Validated and released module     | N/A                                            |

## Variables
| Name                            | Type         | Description                                                                    | example                                                                        | Optional? |
| ------------------------------- | ------------ | ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------ | --------- |
| subcode 			              | string       | subcription code              						                          | 327                                              							   | no        |
| staging_slot_name                 | list(string)       | name of one or multiple app service slots              	                                                  | staging_slot_name = ["stg", "uat"]                                           | no        |
| uai                             | string       | application uai                                                                | uai3026350                                                                     | no        |
| env							  | string		 | dev, qa, stg, prd 															  | dev 													   					   | no 	   |
| appName                         | string       | common name used to create infra resources                                     | app1                                                                           | no        |
| purpose                         | string       | purpose of the application                                                     | testing                          		                                       | no        |
| region						  | string		 | region																		  | "East US" or "West Europe"													   | no		   |
| vnet_name                       | string       | existing VnetName                                                              | 327-gr-vnet                                                                    | no        |
| resource_group                    | string       | resource Group for the App Service                                                    | rg-286-uai3026350-testing-01                                                               | no        |
| vnet_rg                    | string       | resource Group for the Vnet                                                    | cs-connectedVNET                                                               | no        |
| subnet_name                     | string       | existing subnet name for private endpoint creation                                                       | Application-Subnet                                                             | no        |
| app_service_id                         | string       | app service id for the slot, that depends upon the app_services/app_service_linux module           					                  | module.app_service_linux                                                               | no        |
| vnet_integration_subnet                    | string	     | existing dedicated subnet for vnet integration, mentioned delegation must be enabled in the subnet //Microsoft.Web/serverFarms    ,  default value is null  , depends on the    vnet_integration variable.                                           | Integration-Subnet                            				                               | yes        |
| vnet_integration			          | bool         | enable vnet integration in app service, default value is false                  	                                      | false                    						                               | yes       |
| enable_app_insight                            | bool       | enable appinsight integration with app service   , default value is false                                                      | false													   | yes        |
| lgworkspace_rg				      | string       | log analytics workspace resource group     			                              | cs-loganalytics			  									   | no        |
| dns_zone_group			      | string       | dns zone group for private end point     			                          | dns-app			  															   | no        |
| appinsight_name			      | string       | Application Insight name, depends on the  enable_app_insight variable    			                          | appinsight-appservices			  															   | yes        |
| app_settings			      | map(string)       | app settings in form of key value pair    			                          | app_settings = { "key1" = "value1" "key2" = "value2"}	  | yes  |
| connection_strings			      | list(map(string))       | connection string in app services        | connection_strings = [{ name      = "dbconnection"  type  = "SQLServer" value  = "Server=some-server.mydomain.com;Integrated Security=SSPI"  sensitive = true }] | yes |
| staging_slot_custom_app_settings			      | map(string)       | custom app settings for the stagintg slot(s) | staging_slot_custom_app_settings = { "key_slot1" = "value_slot1" } | yes |
| site_config | any | A key-value pair of site config for the app service  | site_config = { http2_enabled = false   application_stack = { python_version = "3.9" }}	| no|

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
| python_version 				      | application_stack in site_config         | version of Python, The version of Python to run. Possible values include 3.7, 3.8, 3.9, 3.10 and 3.11.    | python_version = "3.9"   | yes       |
| java_server 				      | application_stack in site_config         | java server name, Possible values include JAVA, TOMCAT, and JBOSSEAP. | java_server = "TOMCAT"  | yes       |
| java_server_version 				      | application_stack in site_config         | version of java server, java_version, java_server and java_server_version can be checked from the command line via az webapp list-runtimes --linux  | java_server_version = "9.0""   | yes       |
| java_version 				      | application_stack in site_config         | version of java, The Version of Java to use. Possible values include 8, 11, and 17.  | java_version = "11"   | yes       |
| node_version 				      | application_stack in site_config         | version of node, The version of Node to run. Possible values include 12-lts, 14-lts, 16-lts, and 18-lts. This property conflicts with java_version  | node_version = "14-lts"   | yes       |
| php_version 				      | application_stack in site_config         | version of php, The version of PHP to run. Possible values are 8.0, 8.1 and 8.2.  | php_version = "8.0"   | yes       |
| ruby_version  | application_stack in site_config         | version of python, Te version of Ruby to run. Possible values include 2.6 and 2.7..  | ruby_version = "2.6"   | yes       |

## Example Usage

```

module "app_service_linux" {
  source                  = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/app_services/app_service_linux?ref=1.6"
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
  app_service_plan        = var.app_service_plan
  app_settings = {
    "key1" = "value1"
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
      python_version = "3.9"
    }
  }

  sticky_settings = {
    app_setting_names       = ["key1", "key2"]
    connection_string_names = ["dbconnection"]
  }

  depends_on               = [module.resource_group]
}

module "app_service_linux_slots" {
  source                  = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/app_services_slots/app_service_linux_slots?ref=1.6"
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
  app_service_id          = module.app_service_linux.app_service_id
  app_settings = {
    "key1" = "value1"
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
      python_version = "3.9"
    }
  }

 staging_slot_name = ["stg", "uat"]

  staging_slot_custom_app_settings = {
    "key_slot1" = "value_slot1"
  }
  depends_on = [module.app_service_linux]
}

```
## Details

Creates a azure app service slot(s) based on Linux OS that follows our baseline configuration
