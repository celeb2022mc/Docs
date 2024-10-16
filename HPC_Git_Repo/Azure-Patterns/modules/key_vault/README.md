# Module key_vault

Used to create key vaults

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |                                                                                                                                                                                                                                                                   |

## Variables

| Name                  | Type         | Description                                                                                                                                                                | Example                                             | Optional? |
| --------------------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- | --------- |
| subcode               | String       | The code for the Azure subscription                                                                                                                                        | 303                                                 | No        |
| uai                   | string       | UAI                                                                                                                                                                        | uai3047228                                          | No        |
| env                   | string       | dev, qa, stg, lab, prd                                                                                                                                                     | dev                                                 | No        |
| appName               | String       | Name for the app. This will be used to make the name in the following format: kv-{app}-{purpose}                                                                           | autonesting                                         | No        |
| region                | String       | Region                                                                                                                                                                     | "East US" or "West Europe"                          | No        |
| subscription_id       | string       | id for the subscription this is deployed in                                                                                                                                | 9f6a141f-2b42-4d6e-a851-0734d997b62e                | No        |
| include_subnets       | bool         | Whether to include the core infra subnets for the sub in the selected networks for storage account and key vault. Defaults to true. This is required for the CI/CD to work | true                                                | Yes       |
| excluded_subnets_list | list(string) | Corporate & service delegated subnets cannot access key vault.                                                                                                             | ["AzureFirewallSubnet", "sn-PctMgmt", "ANF-Subnet"] | No        |
| purpose               | string       | The purpose of the key vault. This will be used to make the name in the following format: kv-{app}-{purpose}                                                               | common                                              | No        |
| resource_group        | string       | The resource group to deploy to                                                                                                                                            | rg-303-uai3047228-common                            | No        |
| vnet_rg               | string       | The VNET that the Key Vault should be apart of (defaults to "cs-connectedVNET")                                                                                            | "cs-connectedVNET-dr"                               | Yes       |

## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.key_vault.keyvault-id)

| Name          | Description                       |
| ------------- | --------------------------------- |
| keyvault-id   | ID for the provisioned key vault  |
| keyvault-name | Name of the provisioned key vault |

## Example Usage

```
#  #Create key vault
module "key_vault" {
  source = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/key_vault?ref=1.6"
  subcode = var.subcode
  region = var.region
  uai = var.uai
  env = var.env
  appName = var.appName
  subscription_id = var.subscription_id
  purpose = "common"
  resource_group = module.resource_group.rg-name
  excluded_subnets_list = ["AzureFirewallSubnet", "sn-PctMgmt"] # name of subnet which needs to be excluded
}
```

## Details

1. Creates a key vault that follows our baseline configuration
2. _NOTE To deploy the Key Vault, we must invoke the terraform (terraform apply) from a VM in the key vault's whitelisted subnets ("Selected Networks"). All Key Vaults whitelist the EU/US Hub Subscription's Application Subnet since it contains the Jenkins instance & ADO Pipeline Hybrid Workers._
3. Corporate provided default subnets: "AzureFirewallSubnet", "sn-PctMgmt".
4. Subnet delegations: To check if a subnet contains a delegation, open the portal: portal.azure.com, search "Virtual Network", then "Subnets", click on the subnet, and confirm there are no service delegations.
