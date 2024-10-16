# Module container_instances

create container instances (internal only)

## Notes

1. Check the Baseline Config for the Container Instances
2. The container instances require dedicated subnets. (Subnet Delegation should set to use 'Microsoft.ContainerInstance/containerGroups')

## Released Versions

| Version | Ref Name | Description                  | Change Log |
| ------- | -------- | ---------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module    | N/A        |
| 1.1     | 2.4      | Added Port and Log Analytcis | N/A        |

## Variables

| Name                        | Type   | Description                       | example                                        | Optional? |
| --------------------------- | ------ | --------------------------------- | ---------------------------------------------- | --------- |
| rg_name                     | string | Resource Group Name               | rg-327-uai3047228-core-infra                   | no        |
| vnet_name                   | string | Existing VnetName                 | 327-gr-vnet                                    | no        |
| vnet_rg_name                | string | Resource Group for the Vnet       | cs-connectedVNET                               | no        |
| analytics_workspace_rg                | string | Resource Group for the analytics_workspace       | cs-loganalytics                               | no        |
| restart_policy              | string | "Always", "Never", "OnFailure"    | Never                                          | no        |
| env                         | string | dev, qa, stg, lab, prd            | dev                                            | no        |
| uai                         | string | application uai                   | uai3047228                                     | no        |
| appName                     | string | infra app name                    | demo                                           | no        |
| subnet_name                 | string | Name of the subnet                | application-subnet                             | no        |
| cpu                         | string | cpu for container                 | 0.5                                            | no        |
| memory                      | String | memory for the container instance | 1.5                                            | no        |
| image                       | string | image url from container registry | myregistry.azurecr.io/samples/myimage:20210106 | no        |
| port                        | number | port number for the container     | 80                                             |
| loganalytics_workspace_name | string | log analytics workspace name      | 327-gr-logs                                    |

## Outputs

| Name         | Description                  |
| ------------ | ---------------------------- |
| container-id | Id of the container instance |

## Example Usage

```terraform
// Create container instance
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Create container instance
module "demo-container-instance" {
  source                      = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/container_instances?ref=1.6"
  rg_name                     = module.resource_group.rg-name
  vnet_rg_name                = var.vnet_rg
  vnet_name                   = var.virtual_network
  subnet_name                 = "container-subnet" // Microsoft.ContainerInstance/containerGroups subnet delegation must be enabled
  uai                         = var.uai
  env                         = var.env
  appName                     = "contest"
  cpu                         = "0.5"
  memory                      = "1.5"
  image                       = "mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine"
  port                        = 80
  loganalytics_workspace_name = var.lgworkspace
  analytics_workspace_rg      = var.lgworkspace_rg 
}


```
