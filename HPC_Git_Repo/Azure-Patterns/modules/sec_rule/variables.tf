variable "resource_group" {
  type = string
}

variable "sec_rule_name" {
  type = string
}

variable "nsg_name" {
  type = string
}

variable "description" {
  type = string
}

variable "protocol" {
  type = string
  validation {
    condition     = can(contains(["Tcp", "Udp", "Icmp", "Esp", "Ah", "*"], var.protocol))
    error_message = "The env variable must be one of [Tcp,Udp,Icmp,Esp,Ah, *]."
  }
}

variable "destination_port_ranges" {
  type = list(string)
}

variable "source_address_prefixes" {
  type    = list(string)
  default = []
}

variable "source_application_security_group_ids" {
  type    = list(string)
  default = []
}

variable "destination_address_prefixes" {
  type    = list(string)
  default = []
}

variable "destination_application_security_group_ids" {
  type    = list(string)
  default = []
}

variable "access" {
  type = string
  validation {
    condition     = can(contains(["Allow", "Deny"], var.access))
    error_message = "The access variable must be one of [Allow, Deny]."
  }
}

variable "priority" {
  type = number
  validation {
    condition     = can(var.priority > 99 && var.priority < 4097)
    error_message = "The priority variable must be between 100 and 4096."
  }
}

variable "direction" {
  type = string
  validation {
    condition     = can(contains(["Inbound", "Outbound"], var.direction))
    error_message = "The direction variable must be one of [Inbound, Outbound]."
  }
}