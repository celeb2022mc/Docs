variable "uai" {
  type = string
}

variable "env" {
  type = string
  validation {
    condition     = can(contains(["dev", "qa", "stg", "lab", "prd"], var.env))
    error_message = "The env variable must be one of [dev,qa,stg,lab,prd]."
  }
}

variable "appName" {
  type = string
}

variable "region" {
  type = string
}

variable "subscription_id" {
  type = string
  default = ""
}

variable "keyvault_name" {
  type = string
}

variable "keyvault_rg" {
  type = string
}

# variable "keyvault_key_id" {
#   type = string
# }

variable "resource_group" {
  type = string
}

variable "purpose" {
  type        = string
  description = "The purpose of the storage account. To be used in the name. Must contain only characters"
}

variable "auto_key_rotation_enabled" {
  type        = bool
  default     = true
  description = "enable disable auto rotation of key"
}

variable "keyvault_key_id" {
  type        = string
  description = "keyvault_key_id for the data encryption"
}
