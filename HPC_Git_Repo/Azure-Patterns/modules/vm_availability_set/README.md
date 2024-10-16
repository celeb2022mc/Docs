# Module vm_availability_set

Used to create virtual machine availability sets

## Variables

| Name | Type | Description |
| ---- | ---- | ---------- |
| subcode | String | The code for the Azure subscription
| uai | string | UAI for the vm
| env | string | Environment (dev, qa, stg, lab, prd)
| appName | string | Name of the app this resource belongs to
| region | String | Region (East US or West Europe)
| custom_rg | string | Name of the resource group to deploy in. If left empty, will default to rg-sub-uai-app (Optional)

## Outputs

| Name | Description |
| ---- | ----------- |
| availability_set_id | ID for the provisioned availability set
