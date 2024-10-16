## Module Azure logic app

Used to create azure logic app standard with private endpoint and vnet integration

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Added exception in the wiz scan    | N/A        |
| 1.2     | 1.2      | Validated and released    | N/A        |

## Variables

| Name                            | Type         | Description                                                                    | example                                                                        | Optional? |
| ------------------------------- | ------------ | ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------ | --------- |
| uai                             | string       | application uai                                                                | uai1234567                                                                     | no        |
| env                             | string       | dev, qa, stg,  prd                                                             | dev                                                                            | no        |
| appName                         | string       | common name used to create infra resources                                     | app1                                                                           | no         |
| region						  | string		 | Region																		  | "East US" or "West Europe"	                                                                         | no        |
| virtual_network                       | string       | Existing VnetName                                                              | vnet-286                                                                    | no        |
| resource_group                       | string       | Resource Group Name for Logic App                                                              | rg-286-uai3026350-logicapp                                                                   | no        |
| resource_group_vnet                       | string       | Resource Group Name of Virtual Network                                                              | rg-286-uai3026350-vnet                                                                    | no        |
| resource_group_str                       | string       | Resource Group Name of storage account                                                              | stroaragetest                                                                    | no        |
| subnet_vnet                       | string       | Existing subnetName for Vnet Integration with Subnet Delegation Enabled                                                              | subnet1                                                               | no        |
| app_service_plan                       | string       | Existing app_service_plan for the logic app                                                              | app-wn-uai3026350-dev-ge                                                                    | no        |											   | no	      |
| purpose                     	  | string       | purpose of the application                                                     | common                          		                                       | no        |
| application_insight                    | string       | Application Insight Name                                          | logicappinsight                                                               | no        |
| storage_account                    | string       | storage account name                                          | storageaccountlademotest                                                               | no        |
| https_only                    | boolean       | https true or false                                         | true                                                               | no        |

## Outputs

| Name          | Description                   |
| ------------- | ----------------------------- |
| logic_id | Id of the logic app  |

## Example Usage
```
#Create logic app
module "logic_app" {
  source                  = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/logic_app?ref=1.6"
  region                  = var.region
  uai                     = var.uai
  env                     = var.env
  appName                 = var.appName
  resource_group          = module.resource_group.rg-name
  resource_group_vnet     = var.vnet_rg
  virtual_network         = var.virtual_network
  subnet_vnet             = "subnet1"  #update the subnet with deligation Microsoft.Web/serverFarms required
  purpose                 = "common"
  application_insight     = var.application_insight
  resource_group_str      = module.resource_group.rg-name
  storage_account         = module.storage_account.storageaccount-name
  app_service_plan        = var.app_service_plan
  https_only              = true
  depends_on              = [module.resource_group.rg-name]
}
```
## Details

Creates a azure logic app with with private endpoint and vnet integration that follows our baseline configuration
