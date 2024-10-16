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

variable "Built-By" {
  type    = string
  default = "EA Terraform"
}

variable "AppEnvCfgID" {
  type = string
}

variable "region" {
  type = string
}

variable "image_name" {
  type = string
  validation {
    condition     = can(contains(["GESOS-AZ-BASE-WINDOWS2012R2", "GESOS-AZ-BASE-WINDOWS2016", "GESOS-AZ-BASE-WINDOWS2019"], var.image_name))
    error_message = "Tne image_name variable must be one of [GESOS-AZ-BASE-WINDOWS2012R2, GESOS-AZ-BASE-WINDOWS2016, GESOS-AZ-BASE-WINDOWS2019]."
  }
}

variable "nic_id" {
  type = string
}

variable "availability_set_id" {
  type        = string
  description = "Availability Set ID. Leave empty for none"
}

variable "vm_name" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "vm_size" {
  type = string
}

variable "custom_data" {
  type = string
}

variable "user_identity_ids" {
  type = list(string)
}

variable "custom_rg" {
  type        = string
  description = "Resource group to deploy in, leave empty to deploy in default rg (rg-sub-uai-app)"
  default     = ""
}

variable "custom_tags" {
  type        = map(string)
  description = "Any additional tags to add to the vm"
  default     = {}
}

#custom_tags example
# custom_tags = {
#   "key1" = "value1",
#   "key2" = "value2"
# }

variable "os_des_rg" {
  type        = string
  description = "Resource group for the common disk encryption set. Only provide if not in default rg-subcode-uai3064621-common rg."
  default     = ""
}

variable "vm_zone" {
  type        = string
  description = "Zone to deploy the VM in. Leave blank for default."
  default     = null
}

variable "os_disk_caching" {
  type        = string
  description = "Caching type for the OS Disk."
  default     = null
}

variable "os_disk_size" {
  type        = number
  description = "Size of the OS disk attached to the VM in GB."
  default     = null
}


variable "os_disk_storage_account_type" {
  type        = string
  description = "Type of Storage Account used to store the managed OS Disk."
  default     = null
}
variable  "MaintenanceSchedule" {
  type   = string
  description = "MaintenanceSchedule has defined values"
  validation {
    condition     = contains(["MO-WK1-SA-0000", "MO-WK1-SA-1200", "MO-WK1-TH-0000", "MO-WK1-TH-1200", "MO-WK2-SA-0000", "MO-WK2-SA-1200", "MO-WK2-TH-0000", "MO-WK2-TH-1200", "MO-WK3-SA-0000", "MO-WK3-SA-1200", "MO-WK3-TH-0000", "MO-WK3-TH-1200"], var.MaintenanceSchedule)
    error_message = "The image_name variable must be one of [(Non Prod Linux:MO-WK1-SA-0000,MO-WK1-SA-1200,MO-WK1-TH-0000,MO-WK1-TH-1200), (Non Prod Windows and Prod Linux:MO-WK2-SA-0000,MO-WK2-SA-1200,MO-WK2-TH-0000,MO-WK2-TH-12000, (Prod Windows:MO-WK3-SA-0000, MO-WK3-SA-1200,MO-WK3-TH-0000,MO-WK3-TH-1200)]."
  }
}
