# Module key_vault_private_endpoint

Used to create key vault private endpoints

<b>Be sure the key vault private endpoint is the last resource made by making it depend on the other resources (as seen in the example below)</b>

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |

## Variables

| Name           | Type   | Description                                                                | Example                                                                                                                                                  | Optional? |
| -------------- | ------ | -------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| subcode        | String | The code for the Azure subscription                                        | 303                                                                                                                                                      | No        |
| uai            | string | UAI                                                                        | uai3047228                                                                                                                                               | No        |
| env            | string | dev, qa, stg, lab, prd                                                     | No                                                                                                                                                       |
| appName        | String | Name for the app.                                                          | autonesting                                                                                                                                              | No        |
| region         | String | Region                                                                     | "East US" or "West Europe"                                                                                                                               | No        |
| keyvault_id    | string | id for the keyvault this is deployed in                                    | /subscriptions/bd0082b8-fd17-4360-97b4-448d93bedd2b/resourceGroups/rg-302-uai3047228-common/providers/Microsoft.KeyVault/vaults/kv-302-uai3047228-common | No        |
| keyvault_name  | string | Name for the keyvault the private endpoint                                 | kv-303-uai3047228-common                                                                                                                                 | No        |
| subnet_name    | string | The subnet to use for deploying private endpoints. Defaults to Integration | Integration-Subnet                                                                                                                                       | Yes       |
| resource_group | string | The resource group to deploy to                                            | rg-303-uai3047228-common                                                                                                                                 | No        |
| vnet_rg        | string | Name of Virtual Network's Resource Group.                                  | "cs-connectedVNET-dr"                                                                                                                                    | yes       |

## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.key_vault_private_endpoint.keyvault-endpoint-id)

| Name                 | Description                               |
| -------------------- | ----------------------------------------- |
| keyvault-endpoint-id | ID for the provisioned key vault endpoint |

## Example Usage

```
#Create key vault private endpoint
module "key_vault_private_endpoint" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/key_vault_private_endpoint?ref=1.6"
  subcode = var.subcode
  uai = var.uai
  env = var.env
  appName = var.appName
  region = var.region
  keyvault_id = module.key_vault.keyvault-id
  keyvault_name = module.key_vault.keyvault-name
  resource_group = module.resource_group.rg-name

  #Depends on is necessary for private endpoints to ensure all prerequisite resources are made before we modify networking. Append all modules that use the key vault or key to the depends on list
  depends_on = [
    module.key_vault_key,
    module.disk_encryption_set,
    module.storage_account,
    # module.vm_windows
  ]
}
```

## Details

Creates a key vault private endpoint that follows our baseline configuration
