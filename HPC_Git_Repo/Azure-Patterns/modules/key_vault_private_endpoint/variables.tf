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

variable "keyvault_name" {
  type = string
}

variable "keyvault_id" {
  type = string
}

variable "subnet_name" {
  type    = string
  default = ""
}

variable "resource_group" {
  type = string
}

variable "vnet_rg" {
  type        = string
  description = "Virtual Network Resource Group."
  default     = "cs-connectedVNET"
}