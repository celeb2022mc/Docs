\# Module load_balancer

Used to create an Load Balancer

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |
| 1.2     | 1.2      | Updated front end IP address allocation   | N/A        |
| 1.3     | 1.3      | Zone reduntancy for frontend IP   | N/A        |
| 1.4     | 1.4      | Support Multiple backend pools  | N/A        |

## Variables

| Name                                   | Type   | Description                                                                                                              | Example                              | Optional? |
| -------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------ | --------- |
| uai                                    | string | UAI                                                                                                                      | uai3047228                           | No        |
| env                                    | string | dev, qa, stg, lab, prd                                                                                                   | dev                                  | No        |
| appName                                | string | Name of the app this resource belongs to. This will be used to make the name in the following format: mi-{app}-{purpose} | app1                                 | No        |
| region                                 | String | Region                                                                                                                   | "East US" or "West Europe"           | No        |
| resource_group                         | string | The resource group to deploy to.                                                                                         | rg-327-uai3026350-anf-01             | No        |
| purpose                                | string | The purpose of the load balancer. This will be used to make the name in the following format: lb-{app}-{purpose}         | common                               | No        |
| lb_sku                                 | string | The SKU of the Azure Load Balancer. Accepted values are Basic and Standard.                                              | Standard                             | No        |
| frontend_subnet_name                   | string | Frontend subnet Name to use.                                                                                             | Application-Subnet                   | No        |
| frontend_private_ip_address_allocation | string | Frontend IP allocation type.                                                                         | Dynamic or Static                    | No        |
| private_ip_address                     | string | Private_IP_address required if the frontend_private_ip_address_allocation selected as Static. No value required if its Dynamic                                                                  | 10.245.18.201                              | No        |
| lb_probe                               | map    | Protocols to be used for load balancer health probes. Format as [protocol, port, request_path].                          |                                      | No        |
| lb_probe_interval                      | number | Interval in seconds the load balancer health probe rule does a check.                                                    | 5                                    | No        |
| lb_probe_unhealthy_threshold           | number | Number of times the load balancer health probe has an unsuccessful attempt before considering the endpoint unhealthy.    | 2                                    | No        |
| lb_port                                | map    | Protocols to be used for the load balancer rules. Format as [frontend_port, protocol, backend_port].                     |                                      | No        |
| lb_pool_name                           | string | Load Balancer backend pool name                                                                                          | testpool                             | Yes       |
| ni_associations                        | list   | Network Interfaces to be associated with the Backend Pool                                                                | ["vm-286-terraform-897"]             | No        |
| vnet_rg                                | string | Name of Virtual Network's Resource Group.                                                                                | "cs-connectedVNET-dr"                | yes       |
| virtual_network                                | string | Name of Virtual Network                                                                                | "327-gr-vnet"                | no       |
| Zone Redundancy                               | List of string | Added new feature to support zone reduntancy for frontend IP address                                                                              | ["1", "2", "3"]            | Yes       |
| Backend pool                               | List of string | Added new feature to support multiple backend pool. Value has to be passed as list of string in variable file.   | Example below                                                                          |No

### Backend Pool- variable- List of string example:
backend_pools = [
  {
    name            = "backend-pool-1"
    frontend_port   = "80"
    backend_port    = "8080"
    ni_associations = ["nic-gesostestvm", "gesossnapshotimagevm886"]
  },
  {
    name            = "backend-pool-2"
    frontend_port   = "443"
    backend_port    = "8443"
    ni_associations = ["nic-gesostestvm"]
  }
]

## Outputs

These are able to be referenced by other modules in the same Terraform file (i.e. module.load_balancer.lb-id.id)

| Name  | Description                 |
| ----- | --------------------------- |
| lb-id | The ID of the load balancer |

## Example Usage

```
# Create an Azure Load Balancer
#Load- Balancer
module "app-lb" {
  source                                 = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/load_balancer?ref=1.6"
  region                                 = var.region
  uai                                    = var.uai
  env                                    = var.env
  appName                                = var.appName
  purpose                                = "test"
  lb_sku                                 = "Standard"
  resource_group                         = module.resource_group.rg-name
  frontend_private_ip_address_allocation = "Dynamic"
  #private_ip_address                     = "10.245.18.201" # Not required for Dynamic
  virtual_network                        = var.virtual_network
  frontend_subnet_name                   = "Application-Subnet"
  zones                                  = var.zones


  lb_port = {
    http    = ["80", "Tcp", "80"]
    https   = ["443", "Tcp", "443"]
    custom  = ["81", "Tcp", "81"]
    custom1 = ["1443", "Tcp", "1443"]  // Protocol must be one of them in Tcp, Udp, All
  }
  lb_probe = {
    http    = ["Tcp", "80", ""] // in case of Tcp do not add /health it must be null examle: http  = ["Tcp", "80", ""]
    https   = ["Tcp", "443", ""]
    custom  = ["Http", "81", "/health"]
    custom1 = ["Https", "1443", "/health"]

  }
  backend_pools           = var.backend_pools
} 


```

## Details

Creates an Azure Load Balancer.
