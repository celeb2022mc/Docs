# Module netapp_files

Used to create an Azure NetApp Files pool, volume(s), and account

## Released Versions

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and tested module    | N/A        |
| 1.2     | 1.2      | Whitelisted and released the module    | N/A        |
## Variables

| Name                 | Type   | Description                                                                                                                 | Example                              | Optional? |
| -------------------- | ------ | --------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ | --------- |
| uai                  | string | UAI                                                                                                                         | uai3047228                           | No        |
| env                  | string | dev, qa, stg, lab, prd                                                                                                      | dev                                  | No        |
| appName              | string | Name of the app this resource belongs to. This will be used to make the name in the following format: mi-{app}-{purpose}    | app1                                 | No        |
| region               | String | Region                                                                                                                      | "East US" or "West Europe"           | No        |
| resource_group       | string | The resource group to deploy to.                                                                                            | rg-327-uai3026350-anf-01             | No        |
| purpose              | string | The purpose of the Virtual Desktop instance. This will be used to make the name in the following format: hp-{app}-{purpose} | common                               | No        |
| subcode              | string | The project/subscription code.                                                                                              | rg-303-uai3047228-common             | No        |
| pool_service_level   | string | The service level of the pool's file system.                                                                                | Premium or Standard or Ultra         | No        |
| pool_size            | string | The provisioned size of the pool in TB.                                                                                     | 4                                    | No        |
| volume_configs       | map    | Configuration for all Volumes                                                                                               |                                      | Yes       |
| volume_path          | string | The unique file path for the volume.                                                                                        | test-path                            | No        |
| volume_service_level | string | The target performance of the volume's file system.                                                                         | Premium or Standard or Ultra         | No        |
| volume_quota         | string | The maximum storage quota allowed for a file system in Gigabytes.                                                           | 100                                  | No        |
| volume_protocol      | list   | The target volume protocol.                                                                                                 | ["NFSv3"]                            | No        |
| export_policy        | map    | Export Policy Rules to add to the Volume                                                                                    |                                      | Yes       |
| allowed_clients      | list   | IPs/CIDRs allowed to access the volume - Please mention VNet CIDR                                                           | ["10.155.150.0/23"]                  | Yes       |
| access_level         | string | Export policy access level - either read_only or read_write                                                                 | read_only                            | Yes       |
| root_access_enabled  | bool   | Whether to enable root access attribute on the export policy rule                                                           | false                                | Yes       |
| subnet_name          | string | The name of the subnet that is being used for ANF volumes.                                                                  | ANF-Subnet                           | No        |
| vnet_rg              | string | Name of Virtual Network's Resource Group.                                                                                   | "cs-cs-connectedVNET"                | yes       |

## Outputs

These are able to be referenced by other modules in the same Terraform file (i.e. module.netapp_files.anf-account-id.id)

| Name           | Description                              |
| -------------- | ---------------------------------------- |
| anf-account-id | The ID of the Azure NetApp Files account |

## Example Usage

```

# Create NetApp Files instance
module "anf-instance" {
  source                     = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/netapp_files?ref=1.6"
  uai                        = var.uai
  env                        = var.env
  appName                    = var.appName
  region                     = var.region
  resource_group             = module.resource_group.rg-name
  purpose                    = "test"
  subcode                    = var.subcode
  pool_service_level         = "Premium"
  pool_size                  = "4"
  subnet_name                = "subnet-netapp"
  volume_service_level       = "Premium"
  volume_protocol            = ["NFSv4.1"]
  volume_configs = {
    "1" = {
      volume_path  = "mnt"
      volume_quota = "500"
      export_policy = {
        "1" = {
          allowed_clients     = ["10.155.150.0/23"]
          access_level        = "read_only"
          root_access_enabled = false
        }
      }
    },
    "2" = {
      volume_path  = "mnt2"
      volume_quota = "500"
      export_policy = {
        "1" = {
          allowed_clients     = ["10.155.150.1", "10.155.150.2"]
          access_level        = "read_write"
          root_access_enabled = true
        }
      }
    }
  }
}


## Details

Creates an Azure NetApp Files pool, volume(s), and account.
```
