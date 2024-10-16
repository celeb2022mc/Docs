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
}

variable "image_name" {
  type = string
  validation {
    condition = can(contains(["GESOS-AZ-BASE-CENTOS7", "GESOS-AZ-BASE-ORACLELINUX7", "GESOS-AZ-BASE-RHEL7"], var.image_name))
    error_message = "Tne image_name variable must be one of [GESOS-AZ-BASE-CENTOS7, GESOS-AZ-BASE-ORACLELINUX7, GESOS-AZ-BASE-RHEL7]."
  }
}

variable "vm_scale_set_name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "custom_data" {
  type = string
  default = null
}

variable "num_instances" {
  type = number
}

variable "user_identity_ids" {
  type = list(string)
  default = []
}

variable "custom_rg" {
  type = string
  description = "Resource group to deploy in, leave empty to deploy in default rg (rg-sub-uai-app)"
}

variable "subnet_name" {
  type = string
  description = "The subnet to deploy the nic into"
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

variable "extensions" {
  type = list(object({
    name = string,
    publisher = string,
    type = string,
    type_handler_version = string,
    settings = string,
    protected_settings = string
  }))
  default = []
}

variable "vnet_rg" {
  type        = string
  description = "Virtual Network Resource Group."
  default     = "cs-connectedVNET"
}
