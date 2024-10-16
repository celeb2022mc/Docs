variable "subcode" {
  type = string
  description = "The code for the subscription (i.e. 303)"
}

variable "uai" {
  type = string
}

variable "AppEnvCfgID" {
  type = string
  description = "CI of the application."
}  

variable "asg_uai" {
  type = string
  description = "This variable is used if there is a different uai used for the asgs (i.e. 303 Sub)"
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
}

variable "image_name" {
  type = string
  validation {
    condition = can(contains(["GESOS-AZ-BASE-WINDOWS2012R2", "GESOS-AZ-BASE-WINDOWS2016", "GESOS-AZ-BASE-WINDOWS2019"], var.image_name))
    error_message = "Tne image_name variable must be one of [GESOS-AZ-BASE-WINDOWS2012R2, GESOS-AZ-BASE-WINDOWS2016, GESOS-AZ-BASE-WINDOWS2019]."
  }
}


variable "availability_set_id" {
  type = string
  description = "Availability Set ID. Leave empty for none"
  default = ""
}

variable "default_asgs" {
  type = object(
    {
      windows_base = bool
      gessh_internal = bool
      gitend_http = bool
      gehttp_internal = bool
      bastion_base = bool
      db_base = bool
      smtp_relay = bool
    }
  )
  description = "This is used to determine which of the default asgs are added to your VM"
}

#default_asgs example
/*
    {
      windows_base = true
      gessh_internal = false
      gitend_http = true
      gehttp_internal = true
      bastion_base = true
      db_base = false
      smtp_relay = false
    }
*/

variable "app_asgs" {
  type = map(object(
    {
      asg_name = string
      asg_rgname = string
    }))
  description = "Any app asgs to add. Leave empty for none"
  default = {}
}

#app_asgs example
# app_asgs = {
#     "1" = {
#         asg_name        = "asg1",
#         asg_rgname      = "rgname1"
#     },
#     "2" = {
#         asg_name        = "asg2",
#         asg_rgname      = "rgname2"
#     },
# }

variable "disk_configs" {
  type = map(object(
    {
      disk_alias = string
      disk_size = number
      logical_number = number
      caching = string
    }))
  description = "The configurations for all of the managed disks to add to the VM. Leave empty for none"
  default = {}
}

#disk_configs example
# disk_configs = {
#     "1" = {
#         disk_alias        = "disk1",
#         disk_size         = "64",
#         logical_number    = 1
#     },
#     "2" = {
#         disk_alias        = "disk2",
#         disk_size         = "64",
#         logical_number    = 2
#     },
# }

variable "vm_name" {
  type = string
}

variable "password" {
  type = string
  sensitive = true
  default = ""
}

variable "ipAllocation" {
  type = string
  default = ""
}

variable "subnet_name" {
  type = string
}

variable "vm_size" {
  type = string
  description = "Size for the VM that will be deployed (i.e. Standard_D2as_v4)"
}

variable "custom_data" {
  type = string
  description = "Any custom data for the VM"
  default = ""
}

variable "user_identity_ids" {
  type = list(string)
  description = "User identities to attach to this vm. This is the entire resource id i.e. /subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/rg-328-uai3046421-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-328-linux-common"
  default = []
}

variable "custom_rg" {
  type = string
  description = "Resource group to deploy in, leave empty to deploy in default rg (rg-sub-uai-app)"
  default = ""
}

variable "data_des_id" {
  type = string
  description = "Disk Encryption Set id that is to be used for encrypting managed disks. Please use app specific DES if this VM is for an app."
  default = ""
}

variable "backup_policy_name" {
  type = string
  description = "The name of the backup policy to use from the common recovery vault."
}

variable "netgroups" {
  type = list(string)
  description = "The net groups to add during domain join."
  default = []
}

variable "custom_tags" {
  type = map(string)
  description = "Any additional tags to add to the vm"
  default = {}
}

#custom_tags example
# custom_tags = {
#   "key1" = "value1",
#   "key2" = "value2"
# }

variable "os_des_rg" {
  type = string
  description = "Resource group for the common disk encryption set. Only provide if not in default rg-subcode-uai3064621-common rg."
  default = ""
}

variable "include_backup" {
  type = bool
  description = "Variable to be used by EA only for testing a vm."
  default = true
}

variable "include_configuration" {
  type = bool
  description = "Variable to be used by EA only for testing a vm."
  default = true
}

variable "subscription_id" {
  type = string
}

variable "vm_zone" {
  type = string
  description = "Zone to deploy the VM in. Leave blank for default."
  default = null
}
variable "os_disk_caching_type" {
  type = string
  description = "Caching type for the OS Disk."
  default = "ReadWrite"
}

variable "os_disk_size_gb" {
  type = number
  description = "Size of the OS disk attached to the VM in GB."
  default = 128
}


variable "os_disk_storage_acct_type" {
  type = string
  description = "Type of Storage Account used to store the managed OS Disk."
  default = "Premium_LRS"
}

variable "vnet_rg" {
  type = string
  description = "RG of Target VNET"
  default = "cs-connectedVNET"
}

variable "vm_zones" {
  type = number
  description = "Zones to deploy the data disk in. Leave blank for default."
  default = null
}
variable  "MaintenanceSchedule" {
  type   = string
  description = "MaintenanceSchedule has defined values"
  validation {
    condition     = contains(["MO-WK1-SA-0000", "MO-WK1-SA-1200", "MO-WK1-TH-0000", "MO-WK1-TH-1200", "MO-WK2-SA-0000", "MO-WK2-SA-1200", "MO-WK2-TH-0000", "MO-WK2-TH-1200", "MO-WK3-SA-0000", "MO-WK3-SA-1200", "MO-WK3-TH-0000", "MO-WK3-TH-1200"], var.MaintenanceSchedule)
    error_message = "The image_name variable must be one of [(Non Prod Linux:MO-WK1-SA-0000,MO-WK1-SA-1200,MO-WK1-TH-0000,MO-WK1-TH-1200), (Non Prod Windows and Prod Linux:MO-WK2-SA-0000,MO-WK2-SA-1200,MO-WK2-TH-0000,MO-WK2-TH-12000, (Prod Windows:MO-WK3-SA-0000, MO-WK3-SA-1200,MO-WK3-TH-0000,MO-WK3-TH-1200)]."
  }
}
