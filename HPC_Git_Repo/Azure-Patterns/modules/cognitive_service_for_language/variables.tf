# Name of Subscription for Cognitive Service for Language
variable "uai" {
  type = string
}

# Name of environment for Cognitive Service for Language
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

# Name of Region for Cognitive Service for Language
variable "region" {
  type = string
}

# Name of Subscription ID for Cognitive Service for Language
variable "subscription_id" {
  type    = string
  default = ""
}

# Name of Resource Group for Cognitive Service for Language
variable "resource_group" {
  type = string
}

# Name of Custom Domain for Cognitive Service for Language
variable "custom_subdomain" {
  type = string
}

variable "purpose" {
  type        = string
  description = "The purpose of the resource. To be used in the name. Must contain only characters."
}

variable "kind" {
  type        = string
  default     = "TextAnalytics"
  description = "The purpose of the resource. To be used in the name. Must contain only characters."
}

# Name of Subnet for Cognitive Service for Language
variable "subnet_name" {
  type        = string
  description = "The name of the subnet to deploy the private endpoint."
}

variable "virtual_network" {
  type        = string
  description = "The name of the subnet to deploy the private endpoint."
}

variable "vnet_rg" {
  type    = string
  default = "cs-connectedVNET"
}

variable "ls_sku" {
  type = string
  validation {
    condition     = can(contains(["F0", "S0"], var.ls_sku))
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