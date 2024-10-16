## Module Azure Cognitive Service for Language

Used to create azure cognitive service for language

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated the modules     | N/A        |
| 1.2     | 1.2      | Tested whitelisting the modules     | N/A        |
| 1.3     | 1.3      | Released the module     | N/A        |

## Variables

| Name             | Type   | Description                                                  | example                              | Optional? |
| ---------------- | ------ | ------------------------------------------------------------ | ------------------------------------ | --------- |
| uai              | string | application uai                                              | uai1234567                           | no        |
| env              | string | dev, qa, stg, prd                                            | dev                                  | no        |
| appName          | string | common name used to create infra resources                   | app1                                 | no        |
| region           | string | Region                                                       | "East US" or "West Europe"           | no        |
| subscription_id  | string | subcription id                                               | 8f7e459a-ce27-4c52-9ceb-22dd839772c8 | no        |
| resource_group   | string | Resource Group Name for azure cognitive service for language | rg-286-uai3026350-terraform-test     | no        |
| vnet_rg   | string | Resource Group Name for virtual network | rg-286-uai3026350-terraform-test     | no        |
| custom_subdomain | string | The subdomain name used for token-based authentication       | csubdomain                           | no        |
| purpose          | string | purpose of the application                                   | testing                              | no        |
| kind             | string | kind for service                                             | TextAnalytics                        | no        |
| subnet_name      | string | Existing subnetName                                          | ControlPlanceSwxtch                  | no        |
| virtual_network  | string | Existing VnetName                                            | 2020-gr-vnet                           | no        |
| ls_sku              | string | sku for service                                              | F0                                   | no        |
| key_vault_rg              | string | key vault resource group                                        | rg-286-uai3026350-terraform-test                                  | no        |
| key_vault_name              | string | key vault name                                       | mlgekeyvault                                 | no        |
| key_vault_key_id              | string | key key id                                     | https://kv-inf2020-common.vault.azure.net/keys/key-testkey/19febb8d8b5a49f09764f3fd766b7f72)                                 | no        |

## Outputs

| Name              | Description                                                 |
| ----------------- | ----------------------------------------------------------- |
| csl-id            | Id of the cognitive service for language                    |
| csl-endpoint      | The endpoint assigned to the cognitive service for language |
| csl-primary-key   | The primary key of the cognitive service for language       |
| csl-secondary-key | The seconday key of the cognitive service for language      |

## Example Usage

```
#Create Computer Vission
module "computer_vision_service" {
  source                               =  "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/computer_vision_service?ref=1.6"
  subscription_id                      =  var.subscription_id
  uai                                  =  var.uai
  env                                  =  var.env
  appName                              =  var.appName
  region                               =  var.region
  resource_group                       =  module.resource_group.rg-name
  purpose                              =  "testing"
  subnet_name                          =  "Application-Subnet"
  custom_subdomain                     =  "infra"
  acv_sku                              =  "F0"
  virtual_network                      =  var.virtual_network 
  vnet_rg                              = var.vnet_rg
  key_vault_rg                         = module.resource_group.rg-name
  key_vault_name                       = module.key_vault.keyvault-name
  key_vault_key_id                     = "https://kv-inf2020-common.vault.azure.net/keys/key-testkey/19febb8d8b5a49f09764f3fd766b7f72"    
}
```

## Details

Create cognitive service for language that follows our baseline configuration
