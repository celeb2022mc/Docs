# Module storage_account_private_endpoint

Used to create storage account private endpoints

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |


## Variables

| Name                 | Type   | Description                                                                | Example                                                                                                                                                       | Optional? |
| -------------------- | ------ | -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| subcode              | String | The code for the Azure subscription                                        | 303                                                                                                                                                           | No        |
| uai                  | string | UAI                                                                        | uai3047228                                                                                                                                                    | No        |
| env                  | string | dev, qa, stg, lab, prd                                                     | dev                                                                                                                                                           | No        |
| appName              | string | Name of the app this resource belongs to                                   | autonesting                                                                                                                                                   | No        |
| region               | String | Region                                                                     | "East US" or "West Europe"                                                                                                                                    | No        |
| storage_account_id   | string | id for the storage account this is deployed in                             | /subscriptions/9f6a141f-2b42-4d6e-a851-0734d997b62e/resourceGroups/rg-303-uai3047228-common/providers/Microsoft.Storage/storageAccounts/sa303uai3047228common | No        |
| storage_account_name | string | name for the storage account the private endpoint is in                    | sa303uai3047228common                                                                                                                                         | No        |
| subnet_name          | string | The subnet to use for deploying private endpoints. Defaults to Integration | Integration-Subnet                                                                                                                                            | Yes       |
| resource_group       | string | The resource group to deploy to                                            | rg-303-uai3047228-common                                                                                                                                      | No        |
| vnet_rg              | string | Name of Virtual Network's Resource Group.                                  | "cs-connectedVNET-dr"                                                                                                                                         | yes       |

## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.storage_account_private_endpoint.storage-endpoint-id)

| Name                | Description                                     |
| ------------------- | ----------------------------------------------- |
| storage-endpoint-id | ID for the provisioned storage account endpoint |

## Example Usage

```
#Create storage account private endpoint
module "storage_account_private_endpoint" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/storage_account_private_endpoint?ref=1.6"
  subcode = var.subcode
  uai = var.uai
  env = var.env
  appName = var.appName
  region = var.region
  storage_account_id = var.storageaccount_id
  storage_account_name = var.storage_account_name
  resource_group = module.resource_group.rg-name
  #Depends on is necessary for private endpoints to ensure all prerequisite resources are made before we modify networking. Append all modules that use the storage account to the depends on list
  depends_on = [
    module.storage_account,
    module.storage_account_container
  ]
}
```

## Details

Creates a storage account (blob) private endpoint that follows our baseline configuration
