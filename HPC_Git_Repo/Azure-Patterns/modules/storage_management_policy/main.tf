# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A STORAGE MANAGEMENT POLICY
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
}

#Create storage management policy
resource "azurerm_storage_management_policy" "example" {
  storage_account_id = var.storage_account_id

  dynamic "rule" {
    for_each = var.rules
    content {
      name    = rule.value["name"]
      enabled = rule.value["enabled"]
      filters {
        prefix_match = rule.value["prefix"]
        blob_types   = ["blockBlob"]
      }
      actions {
        dynamic "base_blob" {
          for_each = rule.value.base_blob
          content {
            tier_to_cool_after_days_since_modification_greater_than    = base_blob.value["blob_tier_to_cool"]
            tier_to_archive_after_days_since_modification_greater_than = base_blob.value["blob_tier_to_archive"]
            delete_after_days_since_modification_greater_than          = base_blob.value["blob_delete_after_days"]
          }
        }
        dynamic "snapshot" {
          for_each = rule.value.snapshot
          content {
            change_tier_to_archive_after_days_since_creation = snapshot.value["snapshot_tier_to_archive"]
            change_tier_to_cool_after_days_since_creation    = snapshot.value["snapshot_tier_to_cool"]
            delete_after_days_since_creation_greater_than    = snapshot.value["snapshot_delete_after_days"]
          }
        }
        dynamic "version" {
          for_each = rule.value.version
          content {
            change_tier_to_archive_after_days_since_creation = version.value["version_tier_to_archive"]
            change_tier_to_cool_after_days_since_creation    = version.value["version_tier_to_cool"]
            delete_after_days_since_creation                 = version.value["version_delete_after_days"]
          }
        }
      }
    }
  }
}
