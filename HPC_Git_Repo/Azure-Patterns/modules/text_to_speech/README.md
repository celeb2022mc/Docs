## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |

## Module Azure Speech Service

Used to create azure speech service
Kindly create text to speech manually

## Variables

| Name             | Type   | Description                                            | example                              | Optional? |
| ---------------- | ------ | ------------------------------------------------------ | ------------------------------------ | --------- |
| subcode          | string | subcode code                                       | 286                                  | no        |
| uai              | string | application uai                                        | uai1234567                           | no        |
| env              | string | dev, qa, stg, prd                                      | dev                                  | no        |
| appName          | string | common name used to create infra resources             | app1                                 | no        |
| region           | string | Region                                                 | "East US" or "West Europe"           | no        |
| subscription_id  | string | subcription id                                         | 8f7e459a-ce27-4c52-9ceb-22dd839772c8 | no        |
| resource_group   | string | Resource Group Name for Azure Speech service           | rg-286-uai3026350-terraform-test     | no        |
| vnet_rg   | string | Resource Group Name for virtual network           | rg-286-uai3026350-terraform-test     | no        |
| custom_subdomain | string | The subdomain name used for token-based authentication | csubdomain                           | no        |
| purpose          | string | purpose of the application                             | testing                              | no        |
| subnet_name      | string | Existing subnetName                                    | Application-Subnet                  | no        |
| virtual_network  | string | Existing VnetName                                      | vnet-286                             | no        |
| ss_sku              | string | sku for service                                        | S0                                   | no        |
| key_vault_rg              | string | key vault resource group                                        | rg-286-uai3026350-terraform-test                                  | no        |
| key_vault_name              | string | key vault name                                       | mlgekeyvault                                 | no        |
| key_vault_key_id              | string | key key id                                     | https://mlgekeyvault.vault.azure.net/keys/ml-key/c7bb797f214f41b6847383cff506059c                                 | no        |

## Outputs

| Name             | Description                                         |
| ---------------- | --------------------------------------------------- |
| ss-id            | Id of the azure speech service                      |
| ss-endpoint      | The endpoint assigned to the speech service service |
| ss-primary-key   | The primary key of the speech service service       |
| ss-secondary-key | The seconday key of the speech service service      |

## Example Usage

```
module "text_to_speech" {
  source                               =  "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/text_to_speech?ref=1.6"
  subcode                              =  var.subcode
  subscription_id                      =  var.subscription_id
  uai                                  =  var.uai
  env                                  =  var.env
  appName                              =  var.appName
  region                               =  var.region
  resource_group                       =  module.resource_group.rg-name
  purpose                              =  "testing"
  subnet_name                          =  "Application-Subnet"
  custom_subdomain                     =  "custom"
  ss_sku                               =  "S0"
  vnet_rg                              = var.vnet_rg
  key_vault_rg                         = module.key_vault.keyvault-rg
  key_vault_name                       = module.key_vault.keyvault-name
  key_vault_key_id                     = module.key_vault_key.key-id  // keyvault key id for encryption     
}
```

## Details

Creates a azure speech service that follows our baseline configuration
