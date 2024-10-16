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

variable "lb_sku" {
  description = "The SKU of the Azure Load Balancer. Accepted values are Basic and Standard."
  type        = string
  default     = "Basic"
}

variable "frontend_subnet_name" {
  description = "Frontend subnet Name to use."
  type        = string
  default     = ""
}

variable "virtual_network" {
  description = "virtual network Name to use."
  type        = string
  default     = ""
}

variable "frontend_private_ip_address_allocation" {
  description = "Frontend IP allocation type (Dynamic or Static)."
  type        = string
}

variable "lb_probe" {
  description = "Protocols to be used for load balancer health probes. Format as [protocol, port, request_path]"
  type        = map(any)
  default     = {}
}

variable "lb_probe_interval" {
  description = "Interval in seconds the load balancer health probe rule does a check."
  type        = number
  default     = 5
}

variable "lb_probe_unhealthy_threshold" {
  description = "Number of times the load balancer health probe has an unsuccessful attempt before considering the endpoint unhealthy."
  type        = number
  default     = 2
}

variable "lb_port" {
  description = "Protocols to be used for the load balancer rules. Format as [frontend_port, protocol, backend_port]"
  type        = map(any)
  default     = {}
}

variable "lb_pool_name" {
  description = "LB Pool Name"
  type        = string
}

variable "ni_associations" {
  description = "Network Interfaces to be associated with the Backend Pool"
  type        = list(string)
  default     = []
}

variable "vnet_rg" {
  type        = string
  description = "Virtual Network Resource Group."
  default     = "cs-connectedVNET"
}


variable "private_ip_address" {
  type     = string
}

variable "backend_pools" {
  description = "List of backend pools."
  type = list(object({
    name            = string
    frontend_port   = number
    backend_port    = number
    ni_associations = list(string)
  }))
}
variable "zones" {
  description = "List of availability zones to enable for the frontend IP address."
  type        = list(string)
}
