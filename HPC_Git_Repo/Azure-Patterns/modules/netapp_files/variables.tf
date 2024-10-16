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
  validation {
    condition     = can(contains(["East US", "West Europe"], var.region))
    error_message = "Tne region variable must be one of [East US, West Europe]."
  }
}

variable "resource_group" {
  type = string
}

variable "purpose" {
  type        = string
  description = "The purpose of the resource. To be used in the name. Must contain only characters."
}

variable "pool_service_level" {
  type = string
  validation {
    condition     = can(contains(["Premium", "Standard", "Ultra"], var.pool_service_level))
    error_message = "Tne service level variable must be one of [Premium , Standard , Ultra]."
  }
}

variable "pool_size" {
  type        = string
  description = "The provisioned size of the pool in TB."
}

# variable "subnet_detail" {
#   type = list(object(
#     {
#       subnet_name = string
#       address_prefixes = list(string)
#       service_delegations = list(string)
#     }))
# }

variable "subnet_name" {
  type = string
}

variable "volume_protocol" {
  type = list(string)
}

variable "volume_service_level" {
  type = string
  validation {
    condition     = can(contains(["Premium", "Standard", "Ultra"], var.volume_service_level))
    error_message = "Tne service level variable must be one of [Premium , Standard , Ultra]."
  }
}

variable "volume_configs" {
  type = map(object(
    {
      volume_path  = string
      volume_quota = string
      export_policy = map(object({
        allowed_clients     = list(string)
        access_level        = string
        root_access_enabled = bool
      }))
  }))
  validation {
    condition = alltrue([
      for volume_config in var.volume_configs : alltrue([
        for policy in volume_config.export_policy : alltrue([
          for client in policy.allowed_clients : !contains(["0.0.0.0/0"], client)
        ])
      ])
    ])
    error_message = "Allowed Clients CIDR should not contain 0.0.0.0/0 - Please mention VNet/Subnet CIDR."
  }
  validation {
    condition = alltrue([
      for volume_config in var.volume_configs : alltrue([
        for policy in volume_config.export_policy : contains(["read_only", "read_write"], policy.access_level)
      ])
    ])
    error_message = "Access Level should be either read_only or read_write."
  }
}

variable "vnet_rg" {
  type        = string
  description = "Virtual Network Resource Group."
  default     = "cs-connectedVNET"
}
