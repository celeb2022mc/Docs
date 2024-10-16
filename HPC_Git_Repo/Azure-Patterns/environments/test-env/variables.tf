variable "subcode" {
  type = string
}


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

variable "subscription_id" {
  type = string
}

variable "subnet_details" {
  type = list(object(
    {
      subnet_name       = string
      address_prefixes  = list(string)
      service_endpoints = list(string)
  }))
}

variable "appName" {
  type = string
}

# variable "storage_acc_type" {
#   type = string
# }

# variable "storage_container_name" {
#   type = string
# }


variable "include_subnets" {
  type = bool
}

# variable "subnet_name" {
#  type    = string
#  default = ""
#}

# variable "backup_frequency" {
#   type = string
# }

# variable "backup_time" {
#   type = string
# }

# variable "file_path" {
#   type = string
# }

# variable "bastionCIDR" {
#   type = string
# }