variable "storage_account_name" {
  type = string
}

variable "storage_container_name" {
  type = string
}

variable "metadata" {
  type        = map(string)
  description = "Any tags to add to the storage account"
  default     = {}
}
