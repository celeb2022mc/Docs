## Module Azure Functions App

Used to create Azure Function app

## Released Versions

| Version | Ref Name | Description                           | Change Log                                              |
| ------- | -------- | ------------------------------------- | ------------------------------------------------------- |
| 1.0     | 1.0      | Initial release of module             | N/A                                                     |
| 1.1     | 1.1      | Wiz scan - Deffect on idenitity settings and auth settings resolved  | N/A                      |
| 1.2     | 1.2      | Tested and released the modules  | N/A                      |

## Variables

| Name                       | Type   | Description                                | example                              | Optional? |
| -------------------------- | ------ | ------------------------------------------ | ------------------------------------ | --------- |
| uai                        | string | application uai                            | uai3026350                           | no        |
| env                        | string | dev, qa, stg, prd                          | dev                                  | no        |
| appName                    | string | common name used to create infra resources | app1                                 | no        |
| resource_group             | string | Resource Group Name for Azure Fuction      | rg-327-uai3047228-ansible-refactor   | no        |
| purpose                    | string | purpose of the application                 | testing                              | no        |
| vnet_name                  | string | Existing VnetName                          | 327-gr-vnet                          | no        |
| vnet_rg_name               | string | Resource Group for the Vnet                | cs-connectedVNET                     | no        |
| subnet_name                | string | existing subnet details                    | Application-Subnet                   | no        |
| fuction_stor               | string | Existing storage account                   | 327commonautomation                  | no        |
| resource_group_stor        | string | Storage resource group                     | rg-327-uai3047228-common             | no        |
| storage_account_access_key | string | Private end point for storage              | pe-327commonautomation               | no        |
| app_service_plan           | string | app_service_plan name             | app-lx-uai3026350-dev-test               | no        |



Application Specific parameters

| Name                              | Type      | Description                             | example                     | Optional? |
| --------------------------------- | --------- | --------------------------------------- | --------------------------- | --------- |
| run_time                          | string    | FuctionApp run time env                 | "Node" or "Python"          | no        |
| run_version                       | string    | FuctionApp run time env version         | "10.14.1" or "3.9" or "3.4" | no        |

## Note:

    ## Create a service plan from the app service plan module

## Outputs

| Name        | Description                  |
| ----------- | ---------------------------- |
| function-id | Id of the azure function app |

## Example Usage

```
# #Create azure functions
  module "azure_function" {
  source                               =  "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/azure_function?ref=1.6"
  uai                                  =  var.uai
  env                                  =  var.env
  appName                              =  var.appName
  resource_group                       =  module.resource_group.rg-name
  purpose                              =  "infratest"
  vnet_name                            =  var.virtual_network
  vnet_rg                              =  var.vnet_rg
  subnet_name                          =  "subnet-iac" // subnet with subnet delegation
  fuction_stor                         =  module.storage_account.storageaccount-name #"testingfuctionstor"
  resource_group_stor                  =  module.resource_group.rg-name
  storage_account_access_key           =  "pe-2020commonautomation"
  run_time                             =  "python"
  run_version                          =  "3.4"
  app_service_plan                     = var.app_service_plan
}
```

## Details

Creates a azure function that follows our baseline configuration
