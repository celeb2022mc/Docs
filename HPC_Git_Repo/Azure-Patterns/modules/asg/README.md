# Module asg

Used to create application security groups

## Released Versions

| Version | Ref Name | Description                       | Change Log |
| ------- | -------- | --------------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module         | N/A        |
| 1.1     | 1.1      | Validated and released the module | N/A        |

## Variables

| Name           | Type   | Description                                                                                             | Example                           | Optional? |
| -------------- | ------ | ------------------------------------------------------------------------------------------------------- | --------------------------------- | --------- |
| resource_group | String | Resource group this asg is to be deployed in                                                            | rg-303-uai3047228-test-app-connor | No        |
| region         | String | Region                                                                                                  | "East US" or "West Europe"        | No        |
| uai            | string | UAI                                                                                                     | uai3047228                        | No        |
| env            | string | Environment (dev, qa, stg, lab, prd)                                                                    | dev                               | No        |
| appName        | String | Name for the app. This will be used to make the name in the following format: asg-{app}-{purpose}       | autonesting                       | No        |
| purpose        | string | The purpose of the asg. This will be used to make the name in the following format: asg-{app}-{purpose} | vda-to-db                         | No        |

## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.asg.asg-id)

| Name     | Description                                                   |
| -------- | ------------------------------------------------------------- |
| asg-id   | ID of the provisioned application security group              |
| asg-rg   | Resource group for the provisioned application security group |
| asg-name | Name of the provisioned application security group            |

## Example Usage

```
#Create asg
module "asg" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/asg?ref=1.6"
  uai = var.uai
  env = var.env
  region = var.region
  resource_group = module.resource_group.rg-name
  appName = var.appName
  purpose = "vda-to-db"
}
```

## Details

Creates an ASG with the provided details and tags with uai & env.
