# Module vm_network_interface

Used to create virtual machine network interfaces (nic)

## Variables

| Name | Type | Description |
| ---- | ---- | ---------- |
| subcode | String | The code for the Azure subscription
| uai | string | UAI for the vm
| env | string | Environment (dev, qa, stg, lab, prd)
| appName | string | Name of the app this resource belongs to
| region | String | Region (East US or West Europe)
| subnet_name | string | Name of the subnet this resource is to be deployed in
| ipAllocation | string | Private ip allocation for this nic. If left empty, allocation is dynamic
| vm_name | string | Name of the vm this nic will belong to
| custom_rg | string | Name of the resource group to deploy in. If left empty, will default to rg-sub-uai-app (Optional)
| vnet_rg | string | The VNET that the Key Vault should be apart of (defaults to "cs-connectedVNET") | "cs-connectedVNET-dr" | Yes

## Outputs

| Name | Description |
| ---- | ----------- |
| nic_id | ID for the provisioned network interface
| private_ip_address | Private IP address given to the nic
