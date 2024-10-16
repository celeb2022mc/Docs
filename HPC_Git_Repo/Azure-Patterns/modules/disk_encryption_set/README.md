# Module disk_encryption_set

Used to create disk encryption sets

## Released Versions

| Version | Ref Name | Description                       | Change Log |
| ------- | -------- | --------------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module         | N/A        |
| 1.1     | 1.1      | Validated and released the module | N/A        |

## Variables

| Name            | Type   | Description                                                                                                                 | Example                                                                                                          | Optional? |
| --------------- | ------ | --------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- | --------- |
| uai             | string | UAI                                                                                                                         | uai3047228                                                                                                       | No        |
| env             | string | dev, qa, stg, lab, prd                                                                                                      | dev                                                                                                              | No        |
| appName         | String | Name for the app. This will be used to make the name in the following format: des-{appName}-{purpose}                       | autonesting                                                                                                      | No        |
| region          | String | Region                                                                                                                      | "East US" or "West Europe"                                                                                       | No        |
| subscription_id | string | id for the subscription this is deployed in                                                                                 | 9f6a141f-2b42-4d6e-a851-0734d997b62e                                                                             | No        |
| keyvault_rg     | string | rg for the keyvault the CMK is in                                                                                           | rg-303-uai3047228-common                                                                                         | No        |
| keyvault_name   | string | name for the keyvault the CMK is in                                                                                         | kv-303-uai3047228-common                                                                                         | No        |
| keyvault_key_id | string | id for the cmk                                                                                                              | https://kv-302-uai3047228-common.vault.azure.net/keys/key-302-uai3047228-common/e03af0dcb4a341598eda08002efd5eca | No        |
| resource_group  | string | The resource group to deploy to                                                                                             | rg-303-uai3047228-common                                                                                         | No        |
| purpose         | string | The purpose of the disk encryption set. This will be used to make the name in the following format: des-{appName}-{purpose} | data-disks                                                                                                       | No        |
| auto_key_rotation_enabled         | bool | enable or disable the key rotation, default value is true| true                                                                                                       | yes        |

## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.disk_encryption_set.des-id)

| Name     | Description                                            |
| -------- | ------------------------------------------------------ |
| des-id   | ID for the provisioned disk encryption set             |
| des-rg   | Resource group the disk encryption set was deployed in |
| des-name | Name for the disk encryption set                       |

## Example Usage

```
#Create app disk encryption set
module "disk_encryption_set" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/disk_encryption_set?ref=1.6"
  uai = var.uai
  env = var.env
  appName = var.appName
  region = var.region
  subscription_id = var.subscription_id
  keyvault_rg = module.key_vault.keyvault-rg
  keyvault_name = module.key_vault.keyvault-name
  keyvault_key_id = module.key_vault_key.key-id
  resource_group = module.resource_group.rg-name
  purpose = "data-disks"
}
```

## Details

Creates a disk encryption set that follows our baseline configuration
