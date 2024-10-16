variable "subcode" {
  type        = string
  description = "The code for the subscription (i.e. 303)"
}

/*variable "uai" {
  type = string
}*/

variable "env" {
  type = string
  validation {
    condition     = can(contains(["dev", "qa", "stg", "lab", "prd"], var.env))
    error_message = "The env variable must be one of [dev,qa,stg,lab,prd]."
  }
}

/* variable "appName" {
  type = string
}*/

variable "region" {
  type = string
  validation {
    condition     = can(contains(["West US", "East US", "West Europe"], var.region))
    error_message = "Tne region variable must be one of [West US, East US, West Europe]."
  }
}

variable "vm_id" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "include_configuration" {
  type        = bool
  description = "Variable to be used by EA only for testing a vm."
  default     = true
}

variable "disk_mount_directory" {
  type        = string
  description = "The directory to mount any data disks to"
  default     = "/opt/data"
}

variable "custom_rg" {
  type        = string
  description = "Resource group to deploy in, leave empty to deploy in default rg (rg-sub-uai-app)"
}

variable "net_groups" {
  type        = list(string)
  description = "The ldap net groups to add"
  default     = []
}

variable "dcr_managed_identity_id" {
  type        = string
  description = "The id of the DCR managed identity"  
}