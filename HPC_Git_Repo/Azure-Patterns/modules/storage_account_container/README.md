# Module storage_account_container

Used to create storage account containers

## Released Versions


| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |

## Variables

| Name                   | Type        | Description                                                                                                        | Example                                | Optional? |
| ---------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------ | -------------------------------------- | --------- |
| storage_container_name | string      | Name for the storage container                                                                                     | common                                 | No        |
| storage_account_name   | string      | Name of the storage account                                                                                        | sa303uai3047228common                  | No        |
| metadata               | map(string) | Any metadata that you want to add to the VM. Metadata must start with a letter or underscore and be all lowercase. | { "key" = "value", "key2" = "value2" } | Yes       |


## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.storage_account_container.storagecontainer-id)

| Name                | Description                                      |
| ------------------- | ------------------------------------------------ |
| storagecontainer-id | ID for the provisioned storage account container |

## Example Usage

```
#Create Storage Account Container
module "storage_account_container" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/storage_account_container?ref=1.6"
  storage_container_name = "apptest"
  storage_account_name = module.storage_account.storageaccount-name
  metadata = var.metadata
}
```

## Details

Creates a storage account container that follows our baseline configuration
