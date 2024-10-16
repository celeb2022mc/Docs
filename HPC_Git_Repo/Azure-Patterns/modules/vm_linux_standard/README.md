# Module gp_linux_standard

Used to create a standard gas power linux virtual machine

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |
| 1.2     | 1.2      | Added Maintenance Schedule| N/A        |
## Variables

| Name                      | Type              | Description                                                                                                                                                                               | Example                                                                                                                                                                      | Optional?                                                                                                                                      |
| ------------------------- | ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| subcode                   | String            | The code for the Azure subscription                                                                                                                                                       | 303                                                                                                                                                                          | No                                                                                                                                             |
| subscription_id           | string            | The id for the subscription this is in.                                                                                                                                                   | 9f6a141f-2b42-4d6e-a851-0734d997b62e                                                                                                                                         | No <br><b>Required for version 1.1 and above</b>                                                                                               |
| uai                       | string            | UAI for the vm                                                                                                                                                                            | uai3047228                                                                                                                                                                   | No                                                                                                                                             |
| asg_uai                   | string            | This variable is used to specify the UAI on the common asgs                                                                                                                               | uai3047228                                                                                                                                                                   | No                                                                                                                                             |
| env                       | string            | Environment (dev, qa, stg, lab, prd)                                                                                                                                                      | dev                                                                                                                                                                          | No                                                                                                                                             |
| appName                   | string            | Name of the app this resource belongs to                                                                                                                                                  | autonesting                                                                                                                                                                  | No                                                                                                                                             |
| AppEnvCfgID               | string            | CI for the Application.                                                                                                                                                                   | 1100261180                                                                                                                                                                   | No                                                                                                                                             |
| region                    | String            | Region                                                                                                                                                                                    | East US or West Europe                                                                                                                                                       | No                                                                                                                                             |
| image_name                | string            | Name of the image for this VM. Must be one of the following: [GESOS-AZ-BASE-CENTOS7, GESOS-AZ-BASE-ORACLELINUX7, GESOS-AZ-BASE-RHEL7]                                                     | GESOS-AZ-BASE-CENTOS7                                                                                                                                                        | No                                                                                                                                             |
| availability_set_id       | string            | ID for the availability set to use with this VM                                                                                                                                           | /subscriptions/4eb04b93-89c2-4d07-95e3-6f4c358bb07b/resourceGroups/cst-poc-rg/providers/Microsoft.Compute/availabilitySets/cst-poc-vm-availabilitySet-eastus                 | Yes                                                                                                                                            |
| default_asgs              | object            | This is used to determine which of the default asgs are added to your VM                                                                                                                  | default_asgs = { linux_base = true, gessh_internal = true, gitend_http = true, gehttp_internal = true, bastion_base = false, db_base = false, smtp_relay = false }           | No                                                                                                                                             |
| app_asgs                  | object            | Any app asgs to add                                                                                                                                                                       | app_asgs = { "1" = { asg_name = "asg1", asg_rgname = "rgname1"}}                                                                                                             | Yes                                                                                                                                            |
| vm_name                   | string            | Name of the vm this nic will belong to (app-env-role)                                                                                                                                     | vmprov-dev-test1                                                                                                                                                             | No                                                                                                                                             |
| ipAllocation              | string            | Private ip to give to the VM. <b>Do not provide unless necessary</b>                                                                                                                      | 10.210.10.33                                                                                                                                                                 | Yes                                                                                                                                            |
| subnet_name               | string            | Name of the subnet this vm will be deployed in                                                                                                                                            | Application-Subnet                                                                                                                                                           | No                                                                                                                                             |
| vm_size                   | string            | Size for the VM that will be deployed                                                                                                                                                     | Standard_D2as_v4                                                                                                                                                             | No                                                                                                                                             |
| custom_data               | string            | Any custom data for the VM                                                                                                                                                                | N/A                                                                                                                                                                          | Yes                                                                                                                                            |
| user_identity_ids         | list(string)      | User identities to attach to this vm. Example common one is added to all VMs automatically                                                                                                | [/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/rg-328-uai3046421-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-328-linux-common] | Yes                                                                                                                                            |
| disk_configs              | map(object)       | Contains details for disk alias, disk size, logical number, and caching.                                                                                                                  | disk_configs = { "1" = { disk_alias = "disk1",disk_size = "64",logical_number = 1 , caching ="ReadWrite" }}                                                                  | Yes                                                                                                                                            |
| custom_rg                 | string            | Name of the resource group to deploy in. If left empty, will default to rg-sub-uai-app                                                                                                    | rg-303-uai3047228-common                                                                                                                                                     | Yes                                                                                                                                            |
| data_des_id               | string            | ID of the disk encryption set that will be used. If for an app, use app specific DES, otherwise use common DES.                                                                           | /subscriptions/4eb04b93-89c2-4d07-95e3-6f4c358bb07b/resourceGroups/rg-266-uai3047228-common/providers/Microsoft.Compute/diskEncryptionSets/des-266-uai3047228-common         | Yes (Required if providing disk_configs)                                                                                                       |
| backup_policy_name        | string            | The name of the backup policy to use from the common recovery vault.                                                                                                                      | bkp-policy-303-uai3047228-common                                                                                                                                             | No                                                                                                                                             |
| net_groups                | list(string)      | The ldap net groups to use                                                                                                                                                                | ["CA_NRGPOWR_NC_AZURE-PRDBASTION"]                                                                                                                                           | Yes <br>Before Release 1.5, this variable is "net_group" and must be a string. <b>NOTE: (Excluding variable will skip LDAP Config Scrips) </b> |
| disk_mount_directory      | string            | The directory to mount any data disks to. Must start with a "/". Will default to "/opt/data". All disks created at this directory will have the name "dataN", where N is the disk number. | /opt/data                                                                                                                                                                    | Yes                                                                                                                                            |
| custom_tags               | list(map(string)) | Any additional tags to attach to the vm. UAI, ENV, APP automatically added.                                                                                                               | custom_tags = { "test_tag" = "test1", "test_tag2"= "test2" }                                                                                                                 | Yes                                                                                                                                            |
| os_des_rg                 | string            | Resource group for the common disk encryption set. <b>Only provide if not in default rg-subcode-uai3047228-common rg.</b>                                                                 | rg-328-uai3047228-special                                                                                                                                                    | Yes                                                                                                                                            |
| vm_zone                   | string            | The zone to deploy the VM into. Leave empty for default                                                                                                                                   | "1"                                                                                                                                                                          | Yes                                                                                                                                            |
| os_disk_caching_type      | string            | Caching type for the OS Disk                                                                                                                                                              | "ReadWrite"                                                                                                                                                                  | Yes                                                                                                                                            |
| os_disk_size_gb           | number            | OS Disk size in GB                                                                                                                                                                        | "64"                                                                                                                                                                         | Yes                                                                                                                                            |
| os_disk_storage_acct_type | string            | OS Disk storage account type                                                                                                                                                              | "Premium_LRS"                                                                                                                                                                | Yes                                                                                                                                            |
| vnet_rg                   | string            | The VNET that the Key Vault should be apart of (defaults to "cs-connectedVNET")                                                                                                           | "cs-connectedVNET-dr"                                                                                                                                                        | Yes                                                                                                                                            |
| vm_zones                   | number            | the availbility zones for the managed disk (default is null)                                                                                                          | 1                                                                                                                                                        | Yes      
| MaintenanceSchedule                  | String            | MaintenanceSchedule values are pre defined.                                                                                                          |[(Non Prod Linux:MO-WK1-SA-0000,MO-WK1-SA-1200,MO-WK1-TH-0000,MO-WK1-TH-1200), (Non Prod Windows and Prod Linux:MO-WK2-SA-0000,MO-WK2-SA-1200,MO-WK2-TH-0000,MO-WK2-TH-12000, (Prod Windows:MO-WK3-SA-0000, MO-WK3-SA-1200,MO-WK3-TH-0000,MO-WK3-TH-1200)]                                                                                                                                                        | Yes                                                                                                                                            |                                                                          |

## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.vm_gp_linux_standard.id)

| Name               | Description                                                          |
| ------------------ | -------------------------------------------------------------------- |
| id                 | ID for the provisioned virtual machine                               |
| private_ip_address | Private IP assigned to this vm                                       |
| virtual_machine_id | A 128-bit identifier which uniquely identifies this Virtual Machine. |

## Example Usage

```
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
# VIRTUAL MACHINES - LINUX
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


module "vm_gp_linux_standard" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/vm_linux_standard?ref=1.6"
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
  MaintenanceSchedule = var.MaintenanceSchedule
  # OS Managed Disk information
  os_disk_caching_type = "ReadWrite"
  os_disk_storage_acct_type = "Premium_LRS"
  os_disk_size_gb = 128  #Minimum size 128

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
    module.resource_group
   ] 
}
