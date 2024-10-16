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

variable "resource_group" {
  type = string
}

variable "custom_subdomain" {
  type = string
}

variable "purpose" {
  type        = string
  description = "The purpose of the resource. To be used in the name. Must contain only characters."
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet to deploy the private endpoint."
}

variable "virtual_network" {
  type        = string
  description = "The name of the virtual network to deploy the private endpoint."
}

variable "ss_sku" {
  type = string
  validation {
    condition     = can(contains(["F0", "S0"], var.ss_sku))
    error_message = "Tne region variable must be one of [F0, S0]."
  }
}

variable "key_vault_name" {
  type        = string
  description = "the key vault name"
}

variable "key_vault_rg" {
  type        = string
  description = "the key vault resource group"
}

variable "key_vault_key_id" {
  type        = string
  description = "the key vault key name for encryption"
}

variable "vnet_rg" {
  type = string
  default = "cs-connectedVNET"
}