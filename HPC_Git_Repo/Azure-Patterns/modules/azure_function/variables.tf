variable "uai" {
  type = string
}

variable "env" {
  type = string
  validation {
    condition     = can(contains(["dev", "qa", "stg", "prd"], var.env))
    error_message = "The env variable must be one of [dev,qa,stg,prd]."
  }
}

variable "appName" {
  type = string
}

# Region is being used in commented code of pvt endpoint
# variable "region" {
#   type = string
#   validation {
#     condition     = can(contains(["East US", "West Europe"], var.region))
#     error_message = "Tne region variable must be one of [East US, West Europe]."
#   }
# }

variable "resource_group" {
  type = string
}

variable "purpose" {
  type        = string
  description = "The purpose of the resource. To be used in the name. Must contain only characters."
}

variable "fuction_stor" {
  type        = string
  description = " describe your variable"
}

variable "resource_group_stor" {
  type        = string
  description = " describe your variable"
}

variable "storage_account_access_key" {
  type        = string
  description = " describe your variable"
}


variable "vnet_rg" {
  type        = string
  description = " describe your variable"

}

variable "subnet_name" {
  type        = string
  description = " describe your variable"

}


variable "app_service_plan" {
  type        = string
  description = "app service plan name"
}

variable "run_time" {
  type = string
  validation {
    condition     = can(contains(["node", "python", ], var.run_time))
    error_message = "The env variable must be one of [node,python]."
  }

}

variable "run_version" {
  type = string
  validation {
    condition     = can(contains(["10.14.1", "3.9", "3.4"], var.run_version))
    error_message = "The env variable must be one of [P1v2,P1v3,S1]."
  }
}
# variable "privatedns" {
#   type        = string
#   description = "use this variable if we require azure fuction inside the private dns"
# }


variable "vnet_name" {
  type        = string
  description = " describe your variable"
}

# variable "dns_zone_group" {
#   type        = string
#   description = "use this variable for dns app group."
# }
