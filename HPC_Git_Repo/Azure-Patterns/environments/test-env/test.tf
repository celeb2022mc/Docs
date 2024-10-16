# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# REQUIRED PROVIDERS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

provider "azurerm" {
  alias                      = "gesos"
  subscription_id            = "f28c99ba-3eac-470a-a3ee-fa026a3302d3" # DO NOT CHANGE
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = "9c1ab385-2554-43ca-bdf8-f8d937bf4a28" # Use with East US
  #subscription_id = "4e02b754-b491-401d-b5c8-6e0f92663d8e" # Use with West Europe
  skip_provider_registration = true
  features {}
}

data "azurerm_disk_encryption_set" "des1" {
  name                = "des-327-uai3047228-common"
  resource_group_name = "rg-327-uai3047228-common"
}

#Create Linux VM
module "my_vm" {
  # source = "../../modules/gp_windows_standard"
  source = "../../modules/gp_linux_standard"
  providers = {
    azurerm.gesos = azurerm.gesos,
    azurerm.hub   = azurerm.hub
  }
  #The code at the beginning of your subscription name (i.e 123)
  subcode = var.subcode
  #The subscription id
  subscription_id = var.subscription_id
  #The uai for the VM (uai#######)
  uai = var.uai
  #The uai used for the base networking asgs (uai#######)
  asg_uai = var.uai
  #The environment type (dev, prd, qa)
  env = var.env
  #The app name to use
  appName = var.appName
  #The region to deploy in (East US or West Europe)
  region = var.region
  #The VM Image to use (GESOS-AZ-BASE-CENTOS7, GESOS-AZ-BASE-ORACLELINUX7, GESOS-AZ-BASE-RHEL7)
  image_name = "GESOS-AZ-BASE-CENTOS7"

  AppEnvCfgID = "test"

  # image_name = "GESOS-AZ-BASE-WINDOWS2019"
  #The default asgs to attach to this VM. Set to true which ones to use
  # linux_base = truete
  default_asgs = {

    linux_base      = true
    gessh_internal  = true
    gitend_http     = true
    gehttp_internal = true
    bastion_base    = false
    db_base         = false
    smtp_relay      = false
  }

  os_disk_caching_type      = "None"
  os_disk_storage_acct_type = "Premium_LRS"
  os_disk_size_gb           = 265

  #The application asgs to attach to this VM
  #Example
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
  app_asgs = {}
  #The disks to add to this vm. You can add as many of these as you need
  #Example
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
  #   disk_configs = {
  #     "1" = {
  #         disk_alias        = "testdisk1",
  #         disk_size         = "64",
  #         logical_number    = 1,
  #         caching = "None"
  #     }
  #   }
  #The name of the VM (app-env-role)
  vm_name = "pankaj-dev-test001"
  #The subnet to deploy the NIC into
  subnet_name = "Application-Subnet"
  #The size of the VM (i.e. Standard_D2as_v4)
  vm_size = "Standard_D2as_v4"
  #A custom resource group to deploy into. Only specify if you do not have a resource group in the format of rg-subcode-uai-appname or want it in a different location
  custom_rg = "rg-327-uai3047228-mina-lab"
  #The disk encryption set to use for any additional disks. The base infra one (rg-subcode-uai3047228-common) is used for all OS disks.
  data_des_id = "/subscriptions/d0795f6d-b7a1-41a6-a156-ee5335433d9d/resourceGroups/rg-327-uai3047228-common/providers/Microsoft.Compute/diskEncryptionSets/des-327-uai3047228-common"
  #The backup policy to use for this VM
  backup_policy_name = "bkp-policy-327-uai3047228-common-20h00"
  #The ldap net group. If empty, will default to bastion credentials for the specified region
  # net_groups = []
  net_groups = []
}

module "vm_gp_windows_standard1" {
  source = "../../modules/gp_windows_standard"
  providers = {
    azurerm.gesos = azurerm.gesos,
    azurerm.hub   = azurerm.hub
  }
  #The code at the beginning of your subscription name (i.e 123)
  subcode = var.subcode
  #The subscription id
  subscription_id = var.subscription_id
  #The uai for the VM (uai#######)
  uai = var.uai
  #The uai used for the base networking asgs (uai#######)
  asg_uai = var.uai
  #The environment type (dev, prd, qa)
  env = var.env
  #The app name to use
  appName = "testwin2"
  #The region to deploy in (East US or West Europe)
  region = var.region
  #The VM Image to use (GESOS-AZ-BASE-WINDOWS2012R2, GESOS-AZ-BASE-WINDOWS2016, GESOS-AZ-BASE-WINDOWS2019)
  image_name = "GESOS-AZ-BASE-WINDOWS2019"

  #AppConfigId 
  AppEnvCfgID="test"

   # OS Managed Disk information
  os_disk_caching_type      = "ReadWrite"
  os_disk_storage_acct_type = "Premium_LRS"
  os_disk_size_gb           = 128
  os_des_rg                 = "rg-327-uai3047228-common"

  #The default asgs to attach to this VM. Set to true which ones to use
  default_asgs = {
    windows_base    = true
    gessh_internal  = false
    gitend_http     = true
    gehttp_internal = true
    bastion_base    = false
    db_base         = false
    smtp_relay      = false
  }
  #The application asgs to attach to this VM
  #Example
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
  app_asgs = {}
  #The disks to add to this vm. You can add as many of these as you need
  #Example
  # disk_configs = {
  #     "1" = {
  #         disk_alias        = "disk1",
  #         disk_size         = "64GB",
  #         logical_number    = 1,
  #         caching ="ReadWrite"
  #     },
  #     "2" = {
  #         disk_alias        = "disk2",
  #         disk_size         = "64GB",
  #         logical_number    = 2,
  #         caching ="ReadWrite"
  #     },
  # }
  
  #The name of the VM (app[5]-env[3]-role[5]). Cannot exceed that character limit for each section or configuration will not be done correctly.
  vm_name = "pankaj-dev-test004"
  #The subnet to deploy the NIC into
  subnet_name = "Application-Subnet"
  #The size of the VM (i.e. Standard_D2as_v4)
  vm_size = "Standard_D4s_v5"
  #User identities to attach to this vm. Centralized identity added by default. This is the entire resource id i.e. /subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/rg-328-uai3046421-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-328-linux-common
  user_identity_ids = []
  #A custom resource group to deploy into. Only specify if you do not have a resource group in the format of rg-subcode-uai-appname or want it in a different location
  custom_rg = "rg-327-uai3047228-common"
  #The disk encryption set to use for any additional disks. The base infra one (rg-subcode-uai3047228-common) is used for all OS disks.
  data_des_id = data.azurerm_disk_encryption_set.des1.id
  #The backup policy to use for this VM
  backup_policy_name = "bkp-policy-327-uai3047228-common-20h00"
  #The netgroups to use for domain join. If domain join is not needed, leave list empty.
  netgroups = []
}
