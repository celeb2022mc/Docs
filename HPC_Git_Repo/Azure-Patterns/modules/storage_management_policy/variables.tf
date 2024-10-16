variable "storage_account_id" {
  type        = string
  description = "The id for the storage account to apply the management policy to"
}

variable "rules" {
  type = list(object({
    name    = string
    enabled = bool
    prefix  = list(string)
    base_blob = list(object({
      blob_tier_to_cool      = number
      blob_tier_to_archive   = number
      blob_delete_after_days = number
    }))
    snapshot = list(object({
      snapshot_tier_to_archive   = number
      snapshot_tier_to_cool      = number
      snapshot_delete_after_days = number
    }))
    version = list(object({
      version_tier_to_archive   = number
      version_tier_to_cool      = number
      version_delete_after_days = number
    }))
  }))
  description = "The rules to apply to the storage management policy"
  default     = []
}
