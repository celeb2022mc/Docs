variable "subcode" {
  type        = string
  description = "The code for the subscription (i.e. 303)"
}

variable "uai" {
  type = string
}

variable "env" {
  type = string
  validation{
    condition = can(contains(["dev","qa","stg","lab","prd"], var.env))
   error_message = "The env variable must be one of [dev,qa,stg,lab,prd]."
  }
}

variable "appName" {
  type = string
}

variable "region" {
  type = string
  validation {
    condition = can(contains(["West US", "East US", "West Europe"], var.region))
    error_message = "Tne region variable must be one of [West US, East US, West Europe]."
  }
}

variable "vm_id" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "disk_configs" {
  type = map(object(
    {
      disk_alias = string
      disk_size = number
      logical_number = number
      caching = string
    }))
}

#disk_configs example
# disk_configs = {
#     "1" = {
#         disk_alias        = "disk1",
#         disk_size         = "64GB",
#         logical_number    = 1
#     },
#     "2" = {
#         disk_alias        = "disk2",
#         disk_size         = "64GB",
#         logical_number    = 2
#     },
# }

variable "custom_rg" {
  type = string
  description = "Resource group to deploy in, leave empty to deploy in default rg (rg-sub-uai-app)"
}

variable "data_des_id" {
  type = string
  description = "Disk Encryption Set id that is to be used for encrypting managed disks. Please use app specific DES if this VM is for an app."
}

variable "vm_zones" {
  type = number
  description = "Zones to deploy the data disk in. Leave blank for default."
  default = null
}
