# Module user_managed_identity

Used to create user managed identities

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |


## Variables

| Name            | Type   | Description                                                                                                              | Example                              | Optional? |
| --------------- | ------ | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------ | --------- |
| uai             | string | UAI                                                                                                                      | uai3047228                           | No        |
| env             | string | dev, qa, stg, lab, prd                                                                                                   | dev                                  | No        |
| appName         | string | Name of the app this resource belongs to. This will be used to make the name in the following format: mi-{app}-{purpose} | autonesting                          | No        |
| region          | String | Region                                                                                                                   | "East US" or "West Europe"           | No        |
| resource_group  | string | The resource group to deploy to                                                                                          | rg-303-uai3047228-common             | No        |
| purpose         | string | The purpose of the managed identity. This will be used to make the name in the following format: mi-{app}-{purpose}      | common                               | No        |

## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.user_managed_identity.identity-id)

| Name        | Description                                  |
| ----------- | -------------------------------------------- |
| identity-id | ID for the provisioned user managed identity |

## Example Usage

```
#Create user identity
module "user_managed_identity" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/user_managed_identity?ref=1.6"
  uai = var.uai
  env = var.env
  appName = var.appName
  region = var.region
  resource_group = module.resource_group.rg-name
  purpose = "common"
}
```

## Details

Creates a user managed identity that follows our baseline configuration
