# Module vm_linux_scale_set

Used to create a linux virtual machine scale set

## Variables

| Name | Type | Description |
| ---- | ---- | ---------- |
| subcode | String | The code for the Azure subscription
| uai | string | UAI for the vm
| env | string | Environment (dev, qa, stg, lab, prd)
| appName | string | Name of the app this resource belongs to
| region | String | Region (East US or West Europe)
| image_name | string | Name of the image to use for the vm
| vm__scale_set_name | string | Name of the vm scale set
| vm_size | string | Size of the vm
| custom_data | string | Any custom data to provide to the vm
| num_instances | number | The number of instances for the scale set
| user_identity_ids | list(string) | Any user identities to add to the vm (i.e. "/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/rg-328-uai3046421-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-328-linux-common")
| custom_rg | string | Name of the resource group to deploy in. If left empty, will default to rg-sub-uai-app (Optional)
| subnet_name | string | Name of the subnet to deploy the nic into
| custom_tags | list(map(string)) | Any additional tags to attach to the vm
| os_des_rg | string | Resource group for the common disk encryption set. Only provide if not in default rg-subcode-uai3047228-common rg.
| extensions | list(object) | The list of extensions to install on the vm scale set
| vnet_rg | string | Name of Virtual Network's Resource Group. | "cs-connectedVNET-dr" | yes

## Outputs

| Name | Description |
| ---- | ----------- |
