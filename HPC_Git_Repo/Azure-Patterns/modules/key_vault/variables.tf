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

variable "include_subnets" {
  type        = bool
  default     = true
  description = "Whether to include the default 3 subnets (App, Int, DB) as whitelisted vnets"
}

variable "excluded_subnets_list" {
  type        = list(string)
  description = "Names of subnets that will not access this key vault"
}

variable "purpose" {
  type        = string
  description = "The purpose of the storage account. To be used in the name. Must contain only characters"
}

variable "resource_group" {
  type = string
}

variable "vnet_rg" {
  type    = string
  default = "cs-connectedVNET"
}

variable "analytics_workspace_rg" {
  type    = string
  default = "cs-loganalytics"
}
