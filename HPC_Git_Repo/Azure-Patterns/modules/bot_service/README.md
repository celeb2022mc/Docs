## Module Azure Bot Service

Used to create azure bot service

## Versions
| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Added SP as variable    | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |

## Variables

| Name                | Type   | Description                                                                       | example                              | Optional? |
| ------------------- | ------ | --------------------------------------------------------------------------------- | ------------------------------------ | --------- |
| microsoft_app_id             | string | microsoft_app_id for the bot service                                                                  | 085f0b34-555c-4868-934e-ab1e48d17a06                                  | no        |
| uai                 | string | application uai                                                                   | uai1234567                           | no        |
| env                 | string | dev, qa, stg, prd                                                                 | dev                                  | no        |
| appName             | string | common name used to create infra resources                                        | app1                                 | no        |
| region              | string | Region                                                                            | "Global"                        | no        |
| subscription_id     | string | subcription id                                                                    | 8f7e459a-ce27-4c52-9ceb-22dd839772c8 | no        |
| resource_group      | string | Resource Group Name for Azure bot service                                     | rg-286-uai3026350-terraform-test     | no        |
| virtual_network     | string | Existing VnetName                                                                 | vnet-286                             | no        |
| purpose             | string | purpose of the application                                                        | testing                              | no        |
| service_principle_id             | string | Service Principle to run the services                                | d74bf732-4e9a-41fc-b575-4e29c6bf08ab                              | no        |
| subnet         | string | Existing subnetName                                                               | ControlPlanceSwxtch                  | no        |
| sku            | string | sku for bot service service                                                   | F0                                   | no        |
| endpoint       | string | endpoint for the azure bot service                                                    | https://example.com                                   | no        |
| private_endpoint_location | string | private_endpoint_location  | East US                              | no        |
| key_vault_rg       | string | key vault resource group name                                                    | rg-418-uai3026350-nti-testing                                   | no        |
| key_vault_name    | string | key vault name | mlgekeyvault                              | no        |
| key_vault_key_id | string | key vault key id for enncryption  | "https://mlgekeyvault.vault.azure.net/keys/ml-key/c7bb797f214f41b6847383cff506059c"                              | no        |
| enable_app_insight | bool | enable app insight for the bot service, default value is false  | true                              | yes        |
| app_insight_name | string | app_insight_name for the bot service, use the variable when enable_app_insight is set to true | appinsight                              | yes        |
| enable_streaming | bool | variable to enable or disable streaming, deafult value is false  | false                             | yes        |

## Outputs

| Name                       | Description                                          |
| -------------------------- | ---------------------------------------------------- |
| bs-id         | Id of the azure bot service                     |

## Example Usage

```
module "bot_service" {
  source                    = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/bot_service?ref=1.6"
  subscription_id           = var.subscription_id
  uai                       = var.uai
  env                       = var.env
  appName                   = var.appName
  location                  = "Global"
  resource_group            = module.resource_group.rg-name
  purpose                   = var.purpose
  subnet                    = "Application-Subnet"
  app_insight_name          = "ai-${var.uai}-${var.appName}-${var.purpose}"
  enable_app_insight        = true // deafult value is false
  sku                       = "F0"
  endpoint                  = "https://example.com"
  virtual_network           = var.vnet_name
  private_endpoint_location = "East US"
  microsoft_app_id          = "085f0b34-555c-4868-934e-ab1e48d17a06"
  key_vault_name            = module.key_vault.keyvault-name
  key_vault_rg              = module.key_vault.keyvault-rg
  key_vault_key_id          = module.key_vault_key.key-id
  service_principle_id      = var.service_principle_id
}
```

## Details

Creates a azure bot service that follows our baseline configuration
