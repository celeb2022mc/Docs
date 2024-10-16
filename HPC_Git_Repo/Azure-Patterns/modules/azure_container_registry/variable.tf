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

variable "purpose" {
  type = string
}

variable "region" {
  type = string
  validation {
    condition     = can(contains(["East US", "West Europe"], var.region))
    error_message = "Tne region variable must be one of [East US, West Europe]."
  }
}

variable "resource_group" {
  type = string
}

variable "sku" {
  type = string
  validation {
    condition     = can(contains(["Basic", "Standard", "Premium"], var.sku))
    error_message = "Tne region variable must be one of [Basic, Standard, Premium]."
  }
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet to deploy the private endpoint for container registry."
}

variable "virtual_network" {
  type        = string
  description = "The name of the virtual network to deploy the private endpoint."
}

variable "admin_enabled" {
  type = string
  validation {
    condition     = can(contains(["true", "false"], var.admin_enabled))
    error_message = "Tne region variable must be one of [true, false]."
  }
}

variable "loganalytics_workspace_name" {
  type        = string
  description = "log analytics workspace name"
}

variable "vnet_rg" {
  type        = string
  default     = "cs-connectedVNET"
  description = "Name of resource group for vnet"
}

variable "loganalytics_rg" {
  type        = string
  description = "Name of resource group for log analyticks workspace rg"
  default     = "cs-loganalytics"
}