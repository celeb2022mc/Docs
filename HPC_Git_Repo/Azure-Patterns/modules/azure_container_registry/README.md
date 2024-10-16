Install docker in your local machine manually
Create docker images and push/pull images to/from ACR manually

## Released Versions

| Version | Ref Name | Description                       | Change Log |
| ------- | -------- | --------------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module         | N/A        |
| 1.1     | 1.1      | Created the moduled               | N/A        |
| 1.2     | 1.2      | Validated and released the module | N/A        |

## Module Azure Container Registry

Used to create azure container registry

## Variables

| Name                    | Type   | Description                                         | example                            | Optional? |
| ----------------------- | ------ | --------------------------------------------------- | ---------------------------------- | --------- |
| uai                     | string | application uai                                     | "uai1234567"                       | no        |
| env                     | string | dev, qa, stg, prd                                   | "dev"                              | no        |
| appName                 | string | common name used to create infra resources          | "app1"                             | no        |
| purpose                 | string | purpose of the application                          | "testing"                          | no        |
| region                  | string | Region                                              | "East US" or "West Europe"         | no        |
| resource_group          | string | Resource Group Name for Azure cosmosdb with sql api | "rg-286-uai3026350-terraform-test" | no        |
| sku                     | string | sku of the azure container registry                 | "Premium"                          | no        |
| subnet_name             | string | Existing subnetName                                 | "ControlPlanceSwxtch"              | no        |
| virtual_network         | string | Existing VnetName                                   | "vnet-286"                         | no        |
| admin_enabled           | string | admin enabled of the azure container registry       | "false"                            | no        |
| loganalytics_workspace_name | string | existing log_analytics_workspace                    | "327-gr-logs"                      | no        |
| vnet_rg          | string | vnet resource group                                 | "cs-connectedVNET"         | no        |


## Outputs

| Name  | Description                      |
| ----- | -------------------------------- |
| cr-id | The ID of the container registry |

## Example Usage

```
module "azure_container_registry" {
  source                               =  "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/azure_container_registry?ref=1.6"
  uai                                  =  var.uai
  env                                  =  var.env
  appName                              =  var.appName
  purpose                              =  "testing"
  region                               =  var.region
  resource_group                       =  module.resource_group.rg-name
  sku                                  =  "Premium"
  subnet_name                          =  "Application-Subnet"
  virtual_network                      =  var.virtual_network
  admin_enabled                        =  "true"
  loganalytics_workspace_name          =  var.lgworkspace
  vnet_rg                              =  var.vnet_rg
}
```

## Details

Creates a azure container registry that follows our baseline configuration
