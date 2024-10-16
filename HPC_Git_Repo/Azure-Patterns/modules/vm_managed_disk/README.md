# Module vm_managed_disk

Used to create virtual machine managed disks

## Variables

| Name | Type | Description |
| ---- | ---- | ---------- |
| subcode | String | The code for the Azure subscription
| uai | string | UAI for the vm
| env | string | Environment (dev, qa, stg, lab, prd)
| appName | string | Name of the app this resource belongs to
| region | String | Region (East US or West Europe)
| vm_id | string | ID for the vm this disk will be attached to
| vm_name | string | Name of the vm this nic will belong to
| disk_configs | map(object) | Contains details for disk alias, disk size, caching (None, ReadOnly and ReadWrite) and logical number
| custom_rg | string | Name of the resource group to deploy in. If left empty, will default to rg-sub-uai-app (Optional)
| data_des_id | string | ID of the disk encryption set that will be used. If for an app, use app specific DES, otherwise use common DES
| zones | number | Availability zones for the data disk


## Outputs

| Name | Description |
| ---- | ----------- |
| disk_id | ID for the provisioned managed disk
