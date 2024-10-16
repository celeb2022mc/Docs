variable "region" {
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

variable "purpose" {
  type        = string
  description = "The purpose of the storage account. To be used in the name. Must contain only characters"
}

variable "resource_group" {
  type = string
}
