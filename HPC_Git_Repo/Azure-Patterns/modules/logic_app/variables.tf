variable "region" {
  type = string
}

variable "uai" {
  type = string
}

variable "env" {
  type = string
}

variable "appName" {
  type = string
}

variable "purpose" {
  type        = string
  description = "The purpose of the resource. To be used in the name. Must contain only characters."
}

variable "app_service_plan" {
  type        = string
  description = "app_service_plan name"
}

variable "resource_group" {
  type        = string
  description = "resource group name"
}

variable "resource_group_str" {
  type        = string
  description = "resource group name for the storage account"
}

variable "resource_group_vnet" {
  type        = string
  description = "resource group name which contains private network"
}

variable "virtual_network" {
  type        = string
  description = "virtual network name"
}

variable "subnet_vnet" {
  type        = string
  description = "subnet name for the vnet integration, subnet must have subnet delegation enabled."
}

# variable "subnet_private_endpoint" {
#   type        = string
#   description = "subnet name for the private endpoint, subnet must not have subnet delegation enabled."
# }

# variable "privatedns" {
#   type        = string
#   description = "private dns zone name as privatelink.azurewebsites.net"
# }

variable "application_insight" {
  type        = string
  description = "application insight name for logging"
}

variable "storage_account" {
  type        = string
  description = "storage account name"
}

variable "https_only" {
  type        = bool
  description = "to access logic app over https"
}
