# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# REQUIRED PROVIDERS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}
provider "azurerm" {
  alias = "gesos"
  subscription_id = "8ce102f8-9ca3-4738-b6c2-fef8a062c578" # DO NOT CHANGE
  skip_provider_registration = true
  features {}
}
provider "azurerm" {
  alias = "hub"
  subscription_id = "9c1ab385-2554-43ca-bdf8-f8d937bf4a28" # HUB SUBSCRIPTION, DEPENDING ON REGION
  skip_provider_registration = true
  features {}
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##RESOURCE GROUP
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module "rg" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/rg?ref=release-1.0"
  subcode = var.subcode
  uai = var.uai
  env = var.env
  region = var.region
  appName = var.appName
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# VIRTUAL MACHINES -WINDOWS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Create Windows VM
module "vm_gp_windows_standard" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/gp_windows_standard?ref=release-1.0"
  providers = {
    azurerm.gesos = azurerm.gesos,
    azurerm.hub = azurerm.hub
  }
  #The code at the beginning of your subscription name (i.e 123)
  subcode = var.subcode
  #The subscription id
  subscription_id = var.subscription_id
  #The uai for the VM (uai#######)
  uai = var.uai
  #The uai used for the base networking asgs (uai#######)
  asg_uai = "uai3064621"
  #The CI used for the application based on the Environment. 
  AppEnvCfgID = "1101368113"
  #The environment type (dev, prd, qa)
  env = var.env
  #The app name to use
  appName = var.appName
  #The region to deploy in (East US or West Europe)
  region = var.region
  #The VM Image to use (GESOS-AZ-BASE-WINDOWS2012R2, GESOS-AZ-BASE-WINDOWS2016, GESOS-AZ-BASE-WINDOWS2019)
  image_name = "GESOS-AZ-BASE-WINDOWS2022"

  # OS Managed Disk information
  os_disk_caching_type = "ReadWrite"
  os_disk_storage_acct_type = "Premium_LRS"
  os_disk_size_gb = 128


  #The default asgs to attach to this VM. Set to true which ones to use
  default_asgs =  {
      windows_base = true
      gessh_internal = true
      gitend_http = true
      gehttp_internal = true
      bastion_base = false
      db_base = false
      smtp_relay = false
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
  disk_configs = {
    "1" = {
        disk_alias        = "testdisk1",
        disk_size         = "128",
        logical_number    = 1
        caching ="ReadWrite"
    }
  }
  #The name of the VM (app[5]-env[3]-role[5]). Cannot exceed that character limit for each section or configuration will not be done correctly.
  vm_name = "windows2022-demo1"
  #The subnet to deploy the NIC into
  subnet_name = "Application-Subnet"
  #The size of the VM (i.e. Standard_D2as_v4)
  vm_size = "Standard_D2as_v4"
  #User identities to attach to this vm. Centralized identity added by default. This is the entire resource id i.e. /subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/rg-328-uai3046421-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-328-linux-common
  user_identity_ids = []
  #A custom resource group to deploy into. Only specify if you do not have a resource group in the format of rg-subcode-uai-appname or want it in a different location
  #custom_rg = "rg-303-uai3047228-vmtesting"
  #The disk encryption set to use for any additional disks. The base infra one (rg-subcode-uai3047228-common) is used for all OS disks.
  data_des_id = "/subscriptions/${var.subscription_id}/resourceGroups/rg-${var.subcode}-${var.lzuai}-common/providers/Microsoft.Compute/diskEncryptionSets/des-${var.subcode}-${var.lzuai}-common"
  #The backup policy to use for this VM
  backup_policy_name = "bkp-policy-${var.subcode}-${var.lzuai}-common"
  #The netgroups to use for domain join. If domain join is not needed, leave list empty.
  netgroups = ["SVR_GAS_POWER_OPS_AZURE_SERVER_ADMIN"]  #Update SA team netgroup for testing
  #vm_zones = 1
}
