# Module storage_account

Used to create storage accounts

## Released Versions

| Version | Ref Name | Description                                                                               | Change Log                                                                                                                                                                                                  |
| ------- | -------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1.0     | 1.0      | Initial release of module                                                                 | N/A                                                                                                                                                                                                         |
| 1.1     | 1.1      | Updated the module and tested whitelisting                                          | NA                                     |
| 1.2     | 1.2      | Whitelisted infra processor IP as variable                                                       | Whitelisting infra processor IP helps to connect the storage account and creates resources such as container. |
| 1.3     | 1.3     | Added exemptions to accept public_network_access_enabled' is 'true                                              | This enable to create storage account with selected virtual networks and IP addresses                 |
                                                                        |

## Variables

| Name                  | Type         | Description                                                                                                                                                                | Example                                                                                                                                                  | Optional?                  |
| --------------------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| subcode               | String       | The code for the Azure subscription                                                                                                                                        | 303                                                                                                                                                      | No                         |
| uai                   | string       | UAI                                                                                                                                                                        | uai3047228                                                                                                                                               | No                         |
| env                   | string       | dev, qa, stg, lab, prd                                                                                                                                                     | dev                                                                                                                                                      | No                         |
| appName               | string       | Name of the app this resource belongs to. appName must be one word and only characters. This will be used to make the name in the following format: sa{app}{purpose}       | autonesting                                                                                                                                              | No                         |
| region                | String       | Region                                                                                                                                                                     | "East US" or "West Europe"                                                                                                                               | No                         |
| subscription_id       | string       | id for the subscription this is deployed in                                                                                                                                | 9f6a141f-2b42-4d6e-a851-0734d997b62e                                                                                                                     | No                         |
| storage_acc_type      | string       | Type of replication for the storage account (i.e. GRS, LRS, etc.)                                                                                                          | LRS                                                                                                                                                      | No                         |
| storage_acc_tier      | string       | Tier for the storage account (Standard or Premium). Be sure the storage tier you choose is compatible with the replication type.                                           | Standard                                                                                                                                                 | Yes (Defaults to Standard) |
| keyvault_id           | string       | id for the keyvault the CMK is in                                                                                                                                          | /subscriptions/bd0082b8-fd17-4360-97b4-448d93bedd2b/resourceGroups/rg-302-uai3047228-common/providers/Microsoft.KeyVault/vaults/kv-302-uai3047228-common | No                         |
| keyvault_rg           | string       | rg for the keyvault the CMK is in                                                                                                                                          | rg-303-uai3047228-common                                                                                                                                 | No                         |
| keyvault_name         | string       | name for the keyvault the CMK is in                                                                                                                                        | kv-303-uai3047228-common                                                                                                                                 | No                         |
| key_name              | string       | Name of the CMK                                                                                                                                                            | key-common                                                                                                                                               | No                         |
| include_subnets       | bool         | Whether to include the core infra subnets for the sub in the selected networks for storage account and key vault. Defaults to true. This is required for the CI/CD to work | true                                                                                                                                                     | Yes                        |
| include_subcode       | bool         | Whether to include the subcode in the storage account name. Defaults to false.                                                                                             | true                                                                                                                                                     | Yes                        |
| purpose               | string       | The purpose of the storage account. This will be used to make the name in the following format: sa{app}{purpose}. This should not contains spaces or other characters      | data-store                                                                                                                                               | No                         |
| resource_group        | string       | The resource group to deploy to                                                                                                                                            | rg-303-uai3047228-common                                                                                                                                 | No                         |
| excluded_subnets_list | list(string) | Corporate & service delegated subnets cannot access storage accounts/key vaults.                                                                                           | ["AzureFirewallSubnet", "sn-PctMgmt", "ANF-Subnet"]                                                                                                      | no                         |
| vnet_rg               | string       | The VNET that the Storage Account should be apart of (defaults to "cs-connectedVNET")                                                                                      | "cs-connectedVNET-dr"                                                                                                                                    | Yes                        |

## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.storage_account.storageaccount-id)

| Name                | Description                             |
| ------------------- | --------------------------------------- |
| storageaccount-id   | ID for the provisioned storage account  |
| storageaccount-name | Name of the provisioned storage account |

## Example Usage

```
#Create Storage Account
module "storage_account" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/storage_account?ref=1.6"
  subcode = var.subcode
  region = var.region
  uai = var.uai
  env = var.env
  appName = var.appName
  keyvault_id = module.key_vault.keyvault-id
  keyvault_name = module.key_vault.keyvault-name
  keyvault_rg = module.key_vault.keyvault-rg
  key_name = module.key_vault_key.key-name
  subscription_id = var.subscription_id
  storage_acc_type = "LRS"
  purpose = "infratest"
  resource_group = module.resource_group.rg-name
  excluded_subnets_list = ["AzureFirewallSubnet", "sn-PctMgmt"]
}
```

## Details

Creates a storage account that follows our baseline configuration
