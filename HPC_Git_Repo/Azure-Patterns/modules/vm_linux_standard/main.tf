terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "=3.75.0"
      configuration_aliases = [azurerm.hub, azurerm.gesos]
    }

  }
}

locals {
  linux_base = {
    exists = {
      1 = {
        asg_name   = "asg-${var.subcode}-${var.asg_uai}-linux-base",
        asg_rgname = "rg-${var.subcode}-${var.asg_uai}-core-infra"
      }
    }
    not_exists = {}
  }
  gessh_internal = {
    exists = {
      2 = {
        asg_name   = "asg-${var.subcode}-${var.asg_uai}-gessh-internal",
        asg_rgname = "rg-${var.subcode}-${var.asg_uai}-core-infra"
      }
    }
    not_exists = {}
  }
  gitend_http = {
    exists = {
      3 = {
        asg_name   = "asg-${var.subcode}-${var.asg_uai}-gitent-http",
        asg_rgname = "rg-${var.subcode}-${var.asg_uai}-core-infra"
      }
    }
    not_exists = {}
  }
  gehttp_internal = {
    exists = {
      4 = {
        asg_name   = "asg-${var.subcode}-${var.asg_uai}-gehttp-internal",
        asg_rgname = "rg-${var.subcode}-${var.asg_uai}-core-infra"
      }
    }
    not_exists = {}
  }
  bastion_base = {
    exists = {
      5 = {
        asg_name   = "asg-${var.subcode}-${var.asg_uai}-bastion-base",
        asg_rgname = "rg-${var.subcode}-${var.asg_uai}-core-infra"
      }
    }
    not_exists = {}
  }
  db_base = {
    exists = {
      6 = {
        asg_name   = "asg-${var.subcode}-${var.asg_uai}-db-base",
        asg_rgname = "rg-${var.subcode}-${var.asg_uai}-core-infra"
      }
    }
    not_exists = {}
  }
  smtp_relay = {
    exists = {
      7 = {
        asg_name   = "asg-${var.subcode}-${var.asg_uai}-smtp-relay",
        asg_rgname = "rg-${var.subcode}-${var.asg_uai}-core-infra"
      }
    }
    not_exists = {}
  }

  us_east = {
    "managed_identity_resource_id" : ["/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/rg-328-uai3046421-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-328-linux-common"]
  }
  west_europe = {
    "managed_identity_resource_id" : ["/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/rg-328-uai3046421-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-328-linux-common"]
  }
  #Append centralized managed identity to user provided list
  user_identity_ids = length(regexall("US", var.region)) > 0 ? concat(var.user_identity_ids, local.us_east.managed_identity_resource_id) : concat(var.user_identity_ids, local.west_europe.managed_identity_resource_id)

  #Compiled asgs map based on variables provided
  asgs = merge(
    local.linux_base[var.default_asgs.linux_base ? "exists" : "not_exists"],
    local.gessh_internal[var.default_asgs.gessh_internal ? "exists" : "not_exists"],
    local.gitend_http[var.default_asgs.gitend_http ? "exists" : "not_exists"],
    local.gehttp_internal[var.default_asgs.gehttp_internal ? "exists" : "not_exists"],
    local.bastion_base[var.default_asgs.bastion_base ? "exists" : "not_exists"],
    local.db_base[var.default_asgs.db_base ? "exists" : "not_exists"],
    local.smtp_relay[var.default_asgs.smtp_relay ? "exists" : "not_exists"],
  )
}

data "azurerm_user_assigned_identity" "mi_dcr" {
  name                = "mi-${var.subcode}-dcr-common"
  resource_group_name = "rg-${var.subcode}-uai3064621-common"
}

#Create NIC
module "vm_nic" {
  source       = "../vm_network_interface"
  subcode      = var.subcode
  uai          = var.uai
  env          = var.env
  appName      = var.appName
  region       = var.region
  subnet_name  = var.subnet_name
  ipAllocation = var.ipAllocation
  vm_name      = var.vm_name
  custom_rg    = var.custom_rg
  vnet_rg      = var.vnet_rg
}

#Create Default Linux NIC ASG Associations
module "vm_nic_associations_default" {
  source          = "../vm_network_interface_asg_association"
#   nic_id          = module.vm_nic.nic_id[*].id
  nic_id            = module.vm_nic.nic_id
  asgs            = local.asgs
  subscription_id = var.subscription_id
}

#Create Any App-Specific NSG Associations
module "vm_nic_associations_app" {
  source          = "../vm_network_interface_asg_association"
  nic_id          = module.vm_nic.nic_id
#   network_interface_id          = azurerm_network_interface.nic[*].id
  asgs            = var.app_asgs
  count           = length(var.app_asgs) == 0 ? 0 : 1
  subscription_id = var.subscription_id
}

#Create VM
module "vm_linux" {
  source = "../vm_linux"
  providers = {
    azurerm.gesos = azurerm.gesos
  }
  subcode                      = var.subcode
  uai                          = var.uai
  env                          = var.env
  AppEnvCfgID                  = var.AppEnvCfgID
  appName                      = var.appName
  region                       = var.region
  image_name                   = var.image_name
#   nic_id                       = module.vm_nic[*].nic_id
  nic_id                       = module.vm_nic.nic_id
  availability_set_id          = var.availability_set_id
  vm_name                      = var.vm_name
  vm_size                      = var.vm_size
  custom_data                  = var.custom_data
  user_identity_ids            = concat(local.user_identity_ids, [data.azurerm_user_assigned_identity.mi_dcr.id])
  custom_rg                    = var.custom_rg
  custom_tags                  = var.custom_tags
  MaintenanceSchedule          = var.MaintenanceSchedule
  os_des_rg                    = var.os_des_rg
  vm_zone                      = var.vm_zone
  os_disk_caching              = var.os_disk_caching_type
  os_disk_storage_account_type = var.os_disk_storage_acct_type
  os_disk_size                 = var.os_disk_size_gb


}

#Create Managed Disks
module "vm_managed_disk" {
  source       = "../vm_managed_disk"
  count        = length(var.disk_configs) > 0 ? 1 : 0
  subcode      = var.subcode
  uai          = var.uai
  env          = var.env
  appName      = var.appName
  region       = var.region
  vm_id        = module.vm_linux.vm_id
  vm_name      = var.vm_name
  disk_configs = var.disk_configs
  custom_rg    = var.custom_rg
  data_des_id  = var.data_des_id
  # vm_zones     = var.vm_zone == null ? null : [var.vm_zone]
  vm_zones = var.vm_zones //zones has been renamed with zone in current version for vm_managed_disk
  # disk_caching = var.disk_caching
}

module "vm_extension" {
  source = "../vm_linux_extensions"
  providers = {
    azurerm.hub = azurerm.hub
  }
  subcode = var.subcode
  # uai        = var.uai
  env = var.env
  # appName    = var.appName
  region                  = var.region
  vm_id                   = module.vm_linux.vm_id
  vm_name                 = var.vm_name
  custom_rg               = var.custom_rg
  net_groups              = var.net_groups
  dcr_managed_identity_id = data.azurerm_user_assigned_identity.mi_dcr.id
  depends_on = [
    module.vm_managed_disk
  ]
}


#Add VM to Backup
module "vm_backup" {
  #Ability to not add backup for testing purposes only
  count              = var.include_backup ? 1 : 0
  source             = "../vm_backup_tf"
  subcode            = var.subcode
  vm_id              = module.vm_linux.vm_id
  backup_policy_name = var.backup_policy_name
  # subscription_id    = var.subscription_id
  depends_on = [
    module.vm_extension
  ]
}


