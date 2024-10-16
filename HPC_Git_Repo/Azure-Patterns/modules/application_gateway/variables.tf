variable "subscription_id" {
  type = string
  default = ""
}

variable "private_ip_address" {
  type    = string
  default = null
}

variable "subcode" {
  type = string
}

variable "gateway_type" {
  type    = string
  default = "internal"
  validation {
    condition     = can(contains(["internal"], var.gateway_type))
    error_message = "The gateway_type variable must be one of [internal]."
  }

}

variable "rg_name" {
  type    = string
  default = "cs-connectedVNET"
}

variable "vnet_rg_name" {
  type    = string
  default = "cs-connectedVNET"
}

variable "vnet_name" {
  type = string
}

variable "application_gateway_subnet_name" {
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

variable "sku_type" {
  type = string
  validation {
    condition     = can(contains(["Standard_v2"], var.sku_type))
    error_message = "The env sku_name must be one of [Standard_v2]."
  }
}

variable "backend_path" {
  type = string
}

variable "backend_port" {
  type = string
}

variable "gateway_identity" {
  type = string
}

variable "loganalytics_workspace_name" {
  type = string
}


variable "ssl_certificates" {
  type = list(object({
    certificate_name = string
    keyvault_cert_id = string
  }))
}
variable "backends" {
  type = list(object({
    app_uai          = string
    app_short_name   = string
    certificate_name = string
    host_name        = string
    priority_http    = number
    priority_https   = number
    fqdn             = optional(list(string))
    ip_address       = optional(list(string))
  }))
}
