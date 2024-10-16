variable "subcode" {
  type = string
}

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

variable "storage_acc_type" {
  type = string
}

variable "storage_acc_tier" {
  type        = string
  default     = "Standard"
  description = "The tier for the storage account. Standard or Premium"
}

variable "keyvault_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "keyvault_name" {
  type = string
}

variable "keyvault_rg" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "include_subnets" {
  type        = bool
  default     = true
  description = "Whether to include the default 3 subnets (App, Int, DB) as whitelisted vnets"
}

variable "purpose" {
  type        = string
  description = "The purpose of the storage account. To be used in the name. Must contain only characters"
}

variable "include_subcode" {
  type        = bool
  default     = false
  description = "Whether to include the subcode in the storage account name"
}

variable "excluded_subnets_list" {
  type        = list(string)
  description = "Names of subnets that will not access this storage account"
}

variable "vnet_rg" {
  type    = string
  default = "cs-connectedVNET"
}

variable "ip_address" {
  type    = string
  default = "52.21.224.216"
}
