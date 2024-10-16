# Module key_vault_key

Used to create keys

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |

## Variables

| Name        | Type   | Description                                                                                                             | Example                                                                                                                                                  | Optional? |
| ----------- | ------ | ----------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| uai         | string | UAI                                                                                                                     | uai3047228                                                                                                                                               | No        |
| env         | string | dev, qa, stg, lab, prd                                                                                                  | dev                                                                                                                                                      | No        |
| appName     | String | Name for the app. This will be used to make the name in the following format: key-{app}-{purpose}                       | autonesting                                                                                                                                              | No        |
| keyvault_id | string | id for the keyvault this is deployed in                                                                                 | /subscriptions/bd0082b8-fd17-4360-97b4-448d93bedd2b/resourceGroups/rg-302-uai3047228-common/providers/Microsoft.KeyVault/vaults/kv-302-uai3047228-common | No        |
| purpose     | string | The purpose of the disk encryption set. This will be used to make the name in the following format: key-{app}-{purpose} | data-disks                                                                                                                                               | No        |

## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.key_vault_key.key-id)

| Name     | Description                 |
| -------- | --------------------------- |
| key-id   | ID for the provisioned key  |
| key-name | Name of the provisioned key |

## Example Usage

```
#Create key vault key
module "key_vault_key" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/key_vault_key?ref=1.6"
  uai = var.uai
  env = var.env
  appName = var.appName
  keyvault_id = module.key_vault.keyvault-id
  purpose = "testkey"
}
```

## Details

Creates a key that follows our baseline configuration
