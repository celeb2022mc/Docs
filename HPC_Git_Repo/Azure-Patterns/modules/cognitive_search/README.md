# Module cognitive_search

Used to create Cognitive Search service, configure scaling, create custom query keys and a private endpoint.

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Added az login for authentication in the module  | N/A        |
| 1.2     | 1.2      | Whitelisted and released the module.  | N/A        |

## Variables

| Name            | Type   | Description                                                                                                                         | Example                              | Optional? |
| --------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ | --------- |
| uai             | string | UAI                                                                                                                                 | uai3047228                           | No        |
| env             | string | dev, qa, stg, lab, prd                                                                                                              | dev                                  | No        |
| appName         | string | Name of the app this resource belongs to. This will be used to make the name in the following format: mi-{app}-{purpose}            | app1                                 | No        |
| region          | String | Region                                                                                                                              | "East US" or "West Europe"           | No        |
| resource_group  | string | The resource group to deploy to.                                                                                                    | rg-327-uai3026350-anf-01             | No        |
| purpose         | string | The purpose of the Virtual Desktop instance. This will be used to make the name in the following format: hp-{app}-{purpose}         | common                               | No        |
| sku             | string | The SKU which should be used for this Search Service. Possible values are `basic`, `free`, `standard`, `standard2` and `standard3`. | standard                             | No        |
| replica_count   | number | Instances of the search service, used primarily to load balance query operations. Each replica always hosts one copy of an index.   | 3                                    | No        |
| partition_count | number | Provides index storage and I/O for read/write operations (for example, when rebuilding or refreshing an index).                     | 1                                    | No        |
| subnet_name     | string | The name of the subnet that is being used for Cognitive Search private endpoint.                                                    | Application-Subnet                   | No        |
| query_keys      | list   | Names of the query keys to create.                                                                                                  | ["admin"]                            | No        |
| vnet_rg         | string | Name of Virtual Network's Resource Group.                                                                                           | "cs-connectedVNET"                | yes       |
| virtual_network         | string | Name of Virtual Network.                                                                                           | "327-vnet"     2020-gr-vnet           | yes       |

## Outputs

These are able to be referenced by other modules in the same Terraform file (i.e. module.cognitive_search.search_service_id.id)

| Name                          | Description                                                         |
| ----------------------------- | ------------------------------------------------------------------- |
| search-service-id             | The ID of the Cognitive Search service.                             |
| search-service-primary-key    | The primary key used for Cognitive Search service Administration.   |
| search-service-secondary-key  | The secondary key used for Cognitive Search service Administration. |
| search-service_query-keys     | Query keys                                                          |
| search-service_query-keys_map | Query keys, returned as a map with array of values.                 |
| search-service-url            | URL of the Cognitive Search service.                                |

## Example Usage

```
# Create Cognitive Search service



module "search-service" {
  source                 = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/cognitive_search?ref=1.6"
  uai                    = var.uai
  env                    = var.env
  appName                = var.appName
  region                 = var.region
  resource_group         = var.resource_group
  purpose                = var.purpose
  sku                    = "standard"
  replica_count          = "3"
  partition_count        = "1"
  virtual_network        = var.vnet_name
  subnet_name            = "Application-Subnet"
  vnet_rg                = var.vnet_rg
  query_keys             = ["admin"]
}

```

## Details

it Creates a Cognitive Search service, configure scaling, create custom query keys and a private endpoint.
