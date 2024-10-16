variable "subcode" {
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

variable "resource_group" {
  type        = string
  description = "resource group name"
}

variable "lgworkspace_rg" {
  type        = string
  description = "resource group name for loganalytics"
  default     = "cs-loganalytics"
}

variable "os_type" {
  type        = string
  default     = "Windows"
  description = "use this variable if we require linux app service plan for by default it chooses windows"
}

variable "sku_name" {
  type    = string
  default = "S1"
  validation {
    condition     = can(contains(["P1v2", "P1v3", "S1", "WS1", "WS2", "WS3"], var.sku_name))
    error_message = "The env variable must be one of [P1v2,P1v3,S1,WS1,WS2,WS3]."
  }
}

variable "app_service_environment_id" {
  type        = string
  description = "this is required in case of creation app service enviorment with Isolated SKU"
  default     = null
}
