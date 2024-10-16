variable "subcode" {
  type = string
}

variable "uai" {
  type = string
}

variable "purpose" {
  type        = string
  description = "The purpose of the resource. To be used in the name. Must contain only characters."
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

# the region is being used in the pvt endpoint creation. since pvt endpoint is commented so commented the region variable
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


variable "vnet_rg" {
  type        = string
  description = " describe your variable"

}

variable "vnet_name" {
  type        = string
  description = "The purpose of the resource. To be used in the name. Must contain only characters."
}

# variable "subnet_name" {
#   type        = string
#   description = " describe your variable"

# }

variable "vnet_integration_subnet" {
  type        = string
  default     = null
  description = "default value of the variable is null, please provide the name of the subnet with the subnet delegation"
}


variable "enable_app_insight" {
  type        = bool
  default     = false
  description = "provide true or false value"
}

variable "appinsight_name" {
  type        = string
  description = "use this variable for app insight name."
  default     = null
}

variable "staging_slot_name" {
  type        = list(string)
  description = "Custom name of the app service slot"
  default     = ["staging"]
}


variable "staging_slot_custom_app_settings" {
  type        = map(string)
  description = "Override staging slot with custom app settings"
  default     = null
}

variable "vnet_integration" {
  type        = bool
  default     = true
  description = "provide true or false value"
}

variable "public_access" {
  type        = bool
  default     = false
  description = "provide true or false value"
}

variable "site_config" {
  description = "A key-value pair of site config for the web app."
  type        = any
  default     = {}
}

variable "app_settings" {
  description = "key value pair app settings for the app services."
  type        = map(string)
  default     = {}
}
variable "connection_strings" {
  description = "Connection strings for App Service."
  type        = list(map(string))
  default     = []
}

variable "app_service_id" {
  type        = string
  description = " describe your variable"
}

# variable "dns_zone_group" {
#   type        = string
#   default     = "default"
#   description = "use this variable for dns app group."
# }

# variable "privatedns" {
#   type        = string
#   default     = "privatelink.azurewebsites.net"
#   description = "use this variable for private end point."
# }

variable "https_only" {
  type        = bool
  default     = true
  description = "provide true or false value"
}

variable "lgworkspace_rg" {
  type        = string
  description = "resource group name for loganalytics"
  default     = "cs-loganalytics"
}