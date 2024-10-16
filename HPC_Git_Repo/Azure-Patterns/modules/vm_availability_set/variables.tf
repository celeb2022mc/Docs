variable "subcode" {
  type        = string
  description = "The code for the subscription (i.e. 303)"
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

variable "custom_rg" {
  type        = string
  description = "Resource group to deploy in, leave empty to deploy in default rg (rg-sub-uai-app)"
}