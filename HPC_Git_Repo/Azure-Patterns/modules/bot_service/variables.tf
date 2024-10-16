variable "resource_group" {
  type = string
}

variable "vnet_rg" {
  type    = string
  default = "cs-connectedVNET"
}

variable "subscription_id" {
  type = string
  default = ""
}

variable "private_endpoint_location" {
  type = string
}

variable "location" {
  type = string
  validation {
    condition     = can(contains(["Global", "Regional"], var.location))
    error_message = "Tne region variable must be one of [Global, Regional]."
  }
}

# Name of Virtual Network for Azure Bot Service Private Endpoint
variable "virtual_network" {
  type        = string
  description = "The name of the virtual network to deploy the private endpoint."
}

# Name of Subnet for Azure Bot Service Private Endpoint 
variable "subnet" {
  type        = string
  description = "The name of the subnet to deploy the private endpoint."
}

# Name of Private DNS Zone Group
# variable "private_dns_zone" {
#   type        = string
#   description = "The name of the dns zone group."
# }

variable "microsoft_app_id" {
  type        = string
  description = "The Microsoft App ID "
}

variable "service_principle_id" {
  type        = string
  description = "Provide the Service Principle Object Id"
}

variable "env" {
  type = string
  validation {
    condition     = can(contains(["dev", "qa", "stg", "lab", "prd"], var.env))
    error_message = "The env variable must be one of [dev,qa,stg,lab,prd]."
  }
}

variable "purpose" {
  type        = string
  description = "The purpose of the resource. To be used in the name. Must contain only characters."
}

variable "appName" {
  type = string
}

variable "uai" {
  type = string
}

variable "sku" {
  type = string
}

variable "endpoint" {
  type        = string
  description = "The valid endpoint like https://example.com, use https not http"
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

variable "app_insight_name" {
  type        = string
  default     = null
  description = "app insight name"
}

variable "enable_streaming" {
  type        = bool
  default     = false
  description = "enable streaming variable"
}

variable "enable_app_insight" {
  type        = bool
  default     = false
  description = "enable app_insight variable"
}
