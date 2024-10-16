# Module rg

Used to create resource groups

## Released Versions

| Version | Ref Name | Description                       | Change Log |
| ------- | -------- | --------------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module         | N/A        |
| 1.1     | 1.1      | Validated and released the module | N/A        |

## Variables

| Name    | Type   | Description                                                                                                                   | Example                    | Optional? |
| ------- | ------ | ----------------------------------------------------------------------------------------------------------------------------- | -------------------------- | --------- |
| subcode | string | The subcode for the subscription. This will be used to make the name in the following format: rg-{subcode}-{uai}-{appName}    | 303                        | No        |
| region  | String | Region                                                                                                                        | "East US" or "West Europe" | No        |
| uai     | string | NA - (Follow UAI convention). This will be used to make the name in the following format: rg-{subcode}-{uai}-{appName}        | uai3047228                 | No        |
| env     | string | dev, qa, stg, lab, prd. This will be used to make the name in the following format: rg-{subcode}-{uai}-{appName}              | dev                        | No        |
| appName | string | The app name for the resource group. This will be used to make the name in the following format: rg-{subcode}-{uai}-{appName} | autonesting                | No        |

## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.rg.rg-name)

| Name        | Description                                |
| ----------- | ------------------------------------------ |
| rg-location | Location of the provisioned resource group |
| rg-name     | Name of the provisioned resource group     |

## Example Usage

```
#Create resource_group
module "resource_group" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/rg?ref=1.6"
  subcode = var.subcode
  uai = var.uai
  env = var.env
  region = var.region
  appName = var.appName
}
```

## Details

Creates an resource group with the provided details and tags with uai & env.
