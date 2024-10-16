## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |

## Module Azure Form Recognizer

Used to create Used to create azure form recognizer

## Variables

| Name             | Type   | Description                                            | example                              | Optional? |
| ---------------- | ------ | ------------------------------------------------------ | ------------------------------------ | --------- |
| uai              | string | application uai                                        | uai1234567                           | no        |
| env              | string | dev, qa, stg, prd                                      | dev                                  | no        |
| appName          | string | common name used to create infra resources             | app1                                 | no        |
| region           | string | Region                                                 | "East US" or "West Europe"           | no        |
| subscription_id  | string | subcription id                                         | 8f7e459a-ce27-4c52-9ceb-22dd839772c8 | no        |
| resource_group   | string | Resource Group Name for Azure form recognizer          | rg-286-uai3026350-terraform-test     | no        |
| custom_subdomain | string | The subdomain name used for token-based authentication | infratest                              | no        |
| purpose          | string | purpose of the application                             | testing                              | no        |
| subnet_name      | string | Existing subnetName                                    | ControlPlanceSwxtch                  | no        |
| virtual_network  | string | Existing VnetName                                      | vnet-286                             | no        |
| fr_sku              | string | sku for service                                        | S0                                   | no        |
| key_vault_rg              | string | key vault resource group                                        | rg-286-uai3026350-terraform-test                                  | no        |
| key_vault_name              | string | key vault name                                       | mlgekeyvault                                 | no        |
| key_vault_key_id              | string | key key id                                     | https://mlgekeyvault.vault.azure.net/keys/ml-key/c7bb797f214f41b6847383cff506059c                                 | no        |

## Outputs

| Name             | Description                                          |
| ---------------- | ---------------------------------------------------- |
| fr-id            | Id of the azure form recognizer                      |
| fr-endpoint      | The endpoint assigned to the form recognizer service |
| fr-primary-key   | The primary key of the form recognizer service       |
| fr-secondary-key | The seconday key of the form recognizer service      |

## Example Usage

```
#Create Azure Form Recognizer
module "azure_form_recognizer" {
  source                               =  "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/azure_form_recognizer?ref=1.6"
  subscription_id                      =  var.subscription_id
  uai                                  =  var.uai
  env                                  =  var.env
  appName                              =  var.appName
  region                               =  var.region
  resource_group                       =  module.resource_group.rg-name
  purpose                              =  "testing"
  virtual_network                      =  var.virtual_network
  subnet_name                          =  "Application-Subnet"
  custom_subdomain                     =  "infratest"
  fr_sku                               =  "S0"
  key_vault_rg                         = module.key_vault.keyvault-rg
  key_vault_name                       = module.key_vault.keyvault-name
  key_vault_key_id                     = module.key_vault_key.key-id  
}
```

## Details

Creates a azure form recognizer that follows our baseline configuration
