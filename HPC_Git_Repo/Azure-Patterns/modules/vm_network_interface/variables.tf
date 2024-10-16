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

variable "subnet_name" {
  description = "The subnet the nic is being deployed in"
  type        = string
}

variable "ipAllocation" {
  description = "The IP Allocation for the VM"
  type        = string
  default     = ""
}

variable "vm_name" {
  type = string
}

variable "custom_rg" {
  type        = string
  description = "Resource group to deploy in, leave empty to deploy in default rg (rg-sub-uai-app)"
}

variable "vnet_rg" {
  type        = string
  description = "RG of Target VNET"
  default     = "cs-connectedVNET"
}

# variable "nic_count" {
#   type = number
#   description = "number of nic"
#   default = 1  
# }

