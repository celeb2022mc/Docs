## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |

## Module Azure Speech Service/Translation

Used to create Used to create azure speech translation
It is not possible to create Terraform configuration for Monitor, Backup & Recovery. Kindly configure monitor, backup & recovery manually
Kindly configure speech translation manually

## Variables

| Name             | Type   | Description                                            | example                              | Optional? |
| ---------------- | ------ | ------------------------------------------------------ | ------------------------------------ | --------- |
| uai              | string | application uai                                        | uai1234567                           | no        |
| env              | string | dev, qa, stg, prd                                      | dev                                  | no        |
| appName          | string | common name used to create infra resources             | app1                                 | no        |
| region           | string | Region                                                 | "East US" or "West Europe"           | no        |
| subscription_id  | string | subcription id                                         | 8f7e459a-ce27-4c52-9ceb-22dd839772c8 | no        |
| resource_group   | string | Resource Group Name for Azure Speech translation       | rg-286-uai3026350-terraform-test     | no        |
| custom_subdomain | string | The subdomain name used for token-based authentication | csubdomain                           | no        |
| purpose          | string | purpose of the application                             | testing                              | no        |
| subnet_name      | string | Existing subnetName                                    | ControlPlanceSwxtch                  | no        |
| virtual_network  | string | Existing VnetName                                      | vnet-286                             | no        |
| ss_sku              | string | sku for service                                        | S0                                   | no        |
| key_vault_rg       | string | key vault resource group name                                                    | rg-418-uai3026350-nti-testing                                   | no        |
| key_vault_name    | string | key vault name | mlgekeyvault                              | no        |
| key_vault_key_id | string | key vault key id for enncryption  | "https://mlgekeyvault.vault.azure.net/keys/ml-key/c7bb797f214f41b6847383cff506059c"                              | no        |

## Outputs

| Name             | Description                                             |
| ---------------- | ------------------------------------------------------- |
| ss-id            | Id of the azure speech translation                      |
| ss-endpoint      | The endpoint assigned to the speech translation service |
| ss-primary-key   | The primary key of the speech translation service       |
| ss-secondary-key | The seconday key of the speech translation service      |

## Example Usage

```
#Create Azure Speech Translation
module "azure_speech_translation" {
  source                               =  "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/azure_speech_translation?ref=1.6"
  subscription_id                      =  var.subscription_id
  uai                                  =  var.uai
  env                                  =  var.env
  appName                              =  var.appName
  region                               =  var.region
  resource_group                       =  module.resource_group.rg-name
  purpose                              =  "testing"
  virtual_network                      =  var.virtual_network
  subnet_name                          =  "Application-Subnet"
  custom_subdomain                     =  "customaasl"
  ss_sku                               =  "S0"
  key_vault_rg                         = module.key_vault.keyvault-rg
  key_vault_name                       = module.key_vault.keyvault-name
  key_vault_key_id                     = module.key_vault_key.key-id  
}
```

## Details

Creates a azure speech translation that follows our baseline configuration
