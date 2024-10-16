
## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |

## Module Azure Application Insights

Used to create azure application insights

## Variables

| Name                            | Type   | Description                                        | example                              | Optional? |
| ------------------------------- | ------ | -------------------------------------------------- | ------------------------------------ | --------- |
| uai                             | string | application uai                                    | uai1234567                           | no        |
| appname                         | string | common name used to create infra resources         | app1                                 | no        |
| resource_group                  | string | Resource Group Name for azure application insights | rg-286-uai3026350-terraform-test     | no        |
| purpose                         | string | purpose of the application                         | common                               | no        |
| azurerm_log_analytics_workspace | string | Log Analytics                                      | 327-gr-log | no|

## Outputs

| Name                | Description                                 |
| ------------------- | ------------------------------------------- |
| instrumentation_key | instrumentation key of application insights |
| app_id              | App Id of application insights              |

## Example Usage

```
#Create App insight
module "azure_application_insights" {
  source                          =  "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/app_insights?ref=1.6"
  uai                             = var.uai
  appname                         = var.appName
  purpose                         = "testing"
  resource_group                  = module.resource_group.rg-name
  azurerm_log_analytics_workspace = var.lgworkspace
  depends_on                      =[module.resource_group.rg-name]
}
```

## Details

Creates a azure application insights that follows our baseline configuration
