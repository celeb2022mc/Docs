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

variable "resource_group" {
  type = string
}

variable "purpose" {
  type        = string
  description = "The purpose of the resource. To be used in the name. Must contain only characters."
}

variable "sku" {
  type        = string
  default     = "standard"
  description = "The SKU which should be used for this Search Service. Possible values are `basic`, `free`, `standard`, `standard2` and `standard3`."
}

variable "replica_count" {
  type        = number
  default     = 3 # 3 or more replicas for high availability of read-write workloads (queries and indexing)
  description = "Instances of the search service, used primarily to load balance query operations. Each replica always hosts one copy of an index."
}

variable "partition_count" {
  type        = number
  default     = 1
  description = "Provides index storage and I/O for read/write operations (for example, when rebuilding or refreshing an index)."
}

variable "virtual_network" {
  type        = string
  description = "The name of the virtual network to deploy the private endpoint."
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet to deploy the private endpoint."
}

variable "query_keys" {
  description = "Names of the query keys to create."
  type        = list(string)
  default     = []
}

variable "vnet_rg" {
  type        = string
  description = "Virtual Network Resource Group."
  default     = "cs-connectedVNET"
}

