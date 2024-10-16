variable "restart_policy" {
  type    = string
  default = "Never"
  validation {
    condition     = can(contains(["Always", "Never", "OnFailure"], var.restart_policy))
    error_message = "The restart_policy variable must be one of [Always, Never, OnFailure]."
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

variable "analytics_workspace_rg" {
  type    = string
  default = "cs-loganalytics"
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
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


variable "cpu" {
  type = string
}

variable "memory" {
  type = string
}

variable "image" {
  type = string
}

variable "port" {
  type = number
}

variable "loganalytics_workspace_name" {
  type = string
}
