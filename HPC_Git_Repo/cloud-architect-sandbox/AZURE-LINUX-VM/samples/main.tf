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
# VIRTUAL MACHINES - LINUX
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


module "vm_gp_linux_standard" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/gp_linux_standard?ref=release-1.0"
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
  region = "East US"
  #The VM Image to use (GESOS-AZ-BASE-CENTOS7, GESOS-AZ-BASE-ORACLELINUX7, GESOS-AZ-BASE-RHEL7)
  image_name = "GESOS-AZ-BASE-RHEL8"

  # OS Managed Disk information
  os_disk_caching_type = "ReadWrite"
  os_disk_storage_acct_type = "Premium_LRS"
  os_disk_size_gb = 128

  #The default asgs to attach to this VM. Set to true which ones to use
  default_asgs =  {
      linux_base = true
      gessh_internal = true
      gitend_http = true
      gehttp_internal = true
      bastion_base = true
      db_base = false
      smtp_relay = false
  }
  disk_configs = {
        "1" = {
        disk_alias        = "u01",
        disk_size         = "1024",
        logical_number    = 1,
        caching ="ReadOnly"
    }
  }
  #The name of the VM (app-env-role)
  vm_name = "testlinux-demo"
  #The subnet to deploy the NIC into
  subnet_name = "Application-Subnet"
  #The size of the VM (i.e. Standard_D2as_v4)
  vm_size = "Standard_E4ds_v5"
  #The disk encryption set to use for any additional disks. The base infra one (rg-subcode-uai3047228-common) is used for all OS disks.
  data_des_id = "/subscriptions/${var.subscription_id}/resourceGroups/rg-${var.subcode}-${var.lzuai}-common/providers/Microsoft.Compute/diskEncryptionSets/des-${var.subcode}-${var.lzuai}-common"
  #The backup policy to use for this VM
  backup_policy_name = "bkp-policy-${var.subcode}-${var.lzuai}-common"
  #The ldap net group. If empty, will default to bastion credentials for the specified region
  net_groups = ["CA_CRP_NC_AZURE_VN_SA_ADMIN"]
  #vm_zones = 1
  depends_on = [  
    module.rg
   ] 
}