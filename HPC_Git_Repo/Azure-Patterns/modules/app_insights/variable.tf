variable "resource_group" {
  type        = string
  description = "The name of the resource group for deployment."
}

variable "uai" {
  type = string
}

variable "appname" {
  type = string
}

variable "purpose" {
  type        = string
  description = "The purpose of the resource. To be used in the name. Must contain only characters."
}

variable "azurerm_log_analytics_workspace" {
  type = string
}

variable "loganalytics_rg_name" {
  type    = string
  default = "cs-loganalytics"
}