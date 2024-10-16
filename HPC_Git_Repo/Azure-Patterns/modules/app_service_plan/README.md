## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |

## Module Azure App Service Plan

Used to create azure App Service Plan for windows and Linux OS.

## Variables

| Name                            | Type         | Description                                                                    | example                                                                        | Optional? |
| ------------------------------- | ------------ | ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------ | --------- |
| subcode                         | string       | subscription code                                                               | 286                                                                            | no        |
| uai                             | string       | application uai                                                                | uai1234567                                                                     | no        |
| env                             | string       | dev, qa, stg,  prd                                                             | dev                                                                            | no        |
| appName                         | string       | common name used to create infra resources                                     | app1                                                                           | no         |
| os_type						  | string		 | operating system for the plan "Windows" or "Linux" Default is "Windows"																		  | "Windows"	                                                                         | no        |        |
| resource_group                       | string       | Resource Group Name for Logic App                                                              | rg-286-uai3026350-test                                                                   | no        |
| sku_name                       | string       | sku_name for service plan, default is "S1"                                                              | "P1v2"                                                                   | no        |



## Outputs

| Name          | Description                   |
| ------------- | ----------------------------- |
| service_plan_id | Id of the app service plan  |

## Example Usage
```
module "app_service_plan" {
  source          = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/app_service_plan?ref=1.6"
  uai             = var.uai
  env             = var.env
  appName         = var.appName
  resource_group  = module.resource_group.rg-name
  os_type         = "Linux"
  subcode         = var.subcode
  depends_on      =[module.resource_group.rg-name]
}
```
## Details

create azure App Service Plan for windows and Linux OS.
