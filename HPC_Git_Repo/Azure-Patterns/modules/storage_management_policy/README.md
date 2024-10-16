# Module storage_management_policy

Used to create storage management policy

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |

## Variables

| Name               | Type         | Description                                                      | Example                                                                                                                                                                                                                                                                                                                                                                                                                                                         | Optional? |
| ------------------ | ------------ | ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| storage_account_id | String       | The id for the storage account to apply the management policy to | /subscriptions/d0795f6d-b7a1-41a6-a156-ee5335433d9d/resourceGroups/rg-327-uai3047228-common/providers/Microsoft.Storage/storageAccounts/sa327uai3047228common                                                                                                                                                                                                                                                                                                   | No        |
| rules              | list(object) | The rules to apply to the storage management policy              | [{<br>name = "TestStorageRule" <br>enabled = true<br> prefix = ["apptest"] <br>base_blob = <br>[{ <br>blob_tier_to_cool = 30 <br>blob_tier_to_archive = 60 <br>blob_delete_after_days = 90<br>}] <br>snapshot = <br>[{<br>snapshot_tier_to_archive = 10<br>snapshot_tier_to_cool = 20<br>snapshot_delete_after_days = 30<br>}] <br>version = <br>[{<br>version_tier_to_archive = 10 <br>version_tier_to_cool = 20<br>version_delete_after_days = 30<br>}]<br>}] | No        |

## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.asg.asg-id)

| Name | Description |
| ---- | ----------- |

## Example Usage

```
#Create storage management policy
# The example below uses base_blob and snapshot, but not version. Any combination of the 3 can be used
module "storage_management_policy" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/storage_management_policy?ref=1.6"
  storage_account_id = module.storage_account.storageaccount-id
  rules = [
    {
      name = "TestStorageRule"
      enabled = true
      prefix = ["apptest"]
      base_blob = [
        {
          blob_tier_to_cool = 30
          blob_tier_to_archive = 60
          blob_delete_after_days = 90
        }
      ]
      snapshot = [
        {
          snapshot_tier_to_archive = 10
          snapshot_tier_to_cool = 20
          snapshot_delete_after_days = 30
        }
      ]
      version = [
        # {
        #   version_tier_to_archive = 10
        #   version_tier_to_cool = 20
        #   version_delete_after_days = 30
        # }
      ]
    }
  ]

  depends_on = [
    module.storage_account
  ]
}
```
