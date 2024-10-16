# Module application_gateway with WAF_V2

create application gateway (Internal and External)

## Notes:

1. Check the Baseline Config for the Application Gateway
2. Application Gateway is a shared resource. If you are using shared resource for your application contact with operations team to check if there is application gateway present in your subscription.
3. If you needed dedicated application subnet for your application. DPR approval is required.

## Released Versions

| Version | Ref Name | Description                   | Change Log                                     |
| ------- | -------- | ----------------------------- | ---------------------------------------------- |
| 1.0     | 1.0      | Initial release of module     | N/A                                            |
| 1.1     | 1.1      | Created new modules | Added changes for internal application gateway |
| 1.2     | 1.2      | Tested and released  | Removed support for external                   |


## Variables

| Name                            | Type         | Description                                                                    | example                                                                                                                                                                         | Optional? |
| ------------------------------- | ------------ | ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| subscription_id                 | string       | subscription id                                                                | d0795f6d-b7a1-41a6-a156-ee5335433d9d                                                                                                                                            | no        |
| subcode                         | string       | Subcription code                                                               | 327                                                                                                                                                                             | no        |
| rg_name                         | string       | Resource Group Name                                                            | rg-327-uai3047228-core-infra                                                                                                                                                    | no        |
| vnet_name                       | string       | Existing VnetName                                                              | 327-gr-vnet                                                                                                                                                                     | no        |
| vnet_rg_name                    | string       | Resource Group for the Vnet                                                    | cs-connectedVNET                                                                                                                                                                | no        |
| application_gateway_subnet_name | string       | Application gateway subnet                                                     | ApplicationGateway-Subnet                                                                                                                                                       | no        |
| env                             | string       | dev, qa, stg, lab, prd                                                         | dev                                                                                                                                                                             | no        |
| uai                             | string       | application uai                                                                | uai3047228                                                                                                                                                                      | no        |
| appName                         | string       | infra app name                                                                 | demo                                                                                                                                                                            | no        |
| sku_type                        | string       | "WAF_v2"                                                        | WAF_v2                                                                                                                                                                     | no        |
| backend_path                    | string       | backend path                                                                   | /                                                                                                                                                                               | no        |
| backend_port                    | number       | backend port                                                                   | 80                                                                                                                                                                              | no        |
| gateway_identity                | string       | identity with Access to Key Vault                                              | /subscriptions/d0795f6d-b7a1-41a6-a156-ee5335433d9d/resourceGroups/rg-327-uai3047228-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-uai3047228-appgateway | no        |
| loganalytics_workspace_name     | string       | log analytics workspace name                                                   | 327-gr-logs                                                                                                                                                                     | no        |
| ssl_certificates                | list(object) | list of certficiate and key vault id                                           |
| backends                        | list(object) | one or more Application configs                                                | see table below                                                                                                                                                                 | no        |
| private_ip_address              | string       | ip address in Application Gateway Subnet. only needed when gateway is internal | 10.245.18.10                                                                                                                                                                | yes       |
| gateway_type                    | string       | only internal allowed at this time                                             | internal                                                                                                                                                                        | yes       |
| WAF_firewall_Mode                    | string       | Allowed values are "prevention" or "detection"                                             | Prevention                                                                                                                                                                        | yes       |
| WAF_rule_set                     | string       | Allowed value OWASP (Open Web Application Security Project)                                             | OWASP                                                                                                                                                                        | yes       |
| WAF_rule_version                    | string       | App gateway WAF Rule version                                              | 3.2                                                                                                                                                                        | yes       |
| WAF_upload_limit                    | string       | App gateway WAF upload_limit                                               | 100                                                                                                                                                                        | yes       |
| WAF_request_size                    | string       | App gateway WAF request_size                                              | 128                                                                                                                                                                        | yes       |
## Application Specific Variables

Application specific Variables

| Name             | Type   | Constraint/Description                                                 | example                                                                  | Optional? |
| ---------------- | ------ | ---------------------------------------------------------------------- | ------------------------------------------------------------------------ | --------- |
| app_uai          | string | Application specific UAI                                               | uai3047228                                                               | no        |
| app_short_name   | string | Application short name                                                 | demo-dmz                                                                 | no        |
| certificate_name | string | certificate to be used with application                                | infra-test-appgateway                                                      | no        |
| keyvault_cert_id | string | Cert id in the key vault                                               |https://kv-common-appgateway-cer.vault.azure.net/secrets/star-Vernova-com | no        |
| host_name        | string | Cert id in the key vault                                               | demo-dmz.gepass.com                                                     | no        |
| ip_address       | list(object) | optional param (provide either ip_address or fqdn of backend instance) | ["10.245.18.5", "10.245.18.6"]                                                        | yes       |
| fqdn             | list(object) | optional param (provide either ip_address or fqdnof backend instance)  | ["test-dmz-pool1.gepower.com  "]                                                   | yes       |
| priority_https             | number | required parameter for the https rule's priority  | 8                                                    | no       |
| priority_http             | number | required parameter for the http rule's priority  | 9                                                  | no       |

## Outputs

| Name          | Description                   |
| ------------- | ----------------------------- |
| appgateway-id | Id of the application gateway |

## Example Usage

```terraform
// Create application gateway V2
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "demo-dmz-application-gateway" {
  subscription_id                 = var.subscription_id
  private_ip_address              = "10.245.18.10"
  gateway_type                    = "internal"
  source                          = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/application_gateway_WAF_v2?ref=1.6"
  rg_name                         = module.resource_group.rg-name
  vnet_rg_name                    = var.vnet_rg
  vnet_name                       = var.virtual_network
  application_gateway_subnet_name = "AppGatewaySubnet"
  uai                             = var.uai
  env                             = var.env
  subcode                         = var.subcode
  appName                         = "infra-demo"
  sku_type                        = "WAF_v2"
  backend_path                    = "/"
  backend_port                    = "80"
  WAF_firewall_Mode               = var.WAF_firewall_Mode
  WAF_rule_set                    = var.WAF_rule_set
  WAF_rule_version                = var.WAF_rule_version
  WAF_upload_limit                = var.WAF_upload_limit
  WAF_request_size                = var.WAF_request_size
  gateway_identity                = "/subscriptions/${var.subscription_id}/resourceGroups/rg-${var.subcode}-${var.uai}-${var.appName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-${var.appName}-common"
  # gateway_identity = "/subscriptions/f73de5ea-80be-49c6-bcaf-0afefa551b63/resourceGroups/rg-2006-uai3064621-common/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-Infraresource-common"                   # added this ID for testing, it has to be custom in the deployment
  loganalytics_workspace_name     = var.lgworkspace
    
   
  ssl_certificates = [{
    certificate_name = "infra-test-appgateway"
    keyvault_cert_id = "https://kv-common-appgateway-cer.vault.azure.net/secrets/star-Vernova-com"
  }]

  backends = [
    {
      app_uai          =  var.uai
      app_short_name   = "test-dmz-pool1"
      certificate_name = "infra-test-appgateway"
      host_name        = "test-dmz-pool1.gepower.com"
      ip_address       = ["10.245.18.5"]
      priority_https   = 8
      priority_http    = 9      
    }
  ]
}
```
