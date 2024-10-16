# Module vm_linux

Used to create linux virtual machine

## Variables

| Name                | Type              | Description                                                                                                                                                                                                              |
| ------------------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| subcode             | String            | The code for the Azure subscription                                                                                                                                                                                      |
| uai                 | string            | UAI for the vm                                                                                                                                                                                                           |
| env                 | string            | Environment (dev, qa, stg, lab, prd)                                                                                                                                                                                     |
| appName             | string            | Name of the app this resource belongs to                                                                                                                                                                                 |
| AppEnvCfgID         | string            | CI for the Application.                                                                                                                                                                                                  |
| region              | String            | Region (East US or West Europe)                                                                                                                                                                                          |
| image_name          | string            | Name of the image to use for the vm                                                                                                                                                                                      |
| nic_id              | string            | ID for the nic this vm will use                                                                                                                                                                                          |
| availability_set_id | string            | ID for the availability set this vm will use (Optional)                                                                                                                                                                  |
| vm_name             | string            | Name of the vm this nic will belong to                                                                                                                                                                                   |
| vm_size             | string            | Size of the vm                                                                                                                                                                                                           |
| custom_data         | string            | Any custom data to provide to the vm                                                                                                                                                                                     |
| user_identity_ids   | list(string)      | Any user identities to add to the vm (i.e. "/subscriptions/9c1ab385-2554-43ca-bdf8-f8d937bf4a28/resourceGroups/rg-328-uai3046421-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-328-linux-common") |
| custom_rg           | string            | Name of the resource group to deploy in. If left empty, will default to rg-sub-uai-app (Optional)                                                                                                                        |
| custom_tags         | list(map(string)) | Any additional tags to attach to the vm                                                                                                                                                                                  |
| os_des_rg           | string            | Resource group for the common disk encryption set. Only provide if not in default rg-subcode-uai3047228-common rg.                                                                                                       |
| vm_zone             | string            | The zone to deploy the VM into. Leave empty for default                                                                                                                                                                  |

## Outputs

| Name  | Description                            |
| ----- | -------------------------------------- |
| vm_id | ID for the provisioned virtual machine |
