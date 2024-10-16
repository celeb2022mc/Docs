# Module vm_backup_tf



Used to create virtual machine backups

## Note  

This module is an enhancement to the vm_backup module where az cli commands is utilized to check and create azure backups 
This module has the same utility but azure backup is configured by terraform.
If we choose to use this module update name from  "vm_backup" module to "vm_backup_tf" in  the module "gp_linux_standard"

## Variables

| Name | Type | Description |
| ---- | ---- | ---------- |
| subcode | String | The code for the Azure subscription
| vm_id | string | ID for the vm this disk will be attached to
| backup_policy_name | string | Name of the backup policy for this vm
| subscription_id | string | The id for the subscription this is in

## Outputs

| Name | Description |
| ---- | ----------- |
