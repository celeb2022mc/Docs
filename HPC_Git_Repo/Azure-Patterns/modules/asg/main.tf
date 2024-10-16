# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE AN APPLICATION SECURITY GROUP
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
}


locals {
  asg_name = "asg-${var.appName}-${var.purpose}"
  tags = {
    uai     = var.uai
    env     = var.env
    appname = var.appName
  }
}

#Create ASG
resource "azurerm_application_security_group" "asg" {
  name                  = local.asg_name
  resource_group_name   = var.resource_group 
  location              = var.region  
  tags                  = local.tags
}
