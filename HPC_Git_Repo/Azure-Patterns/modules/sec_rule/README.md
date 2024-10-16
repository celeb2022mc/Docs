# Module Network Security Rule

Used to create network security rules that define what traffic is permitted in an NSG

## Released Versions

| Version | Ref Name | Description               | Change Log |
| ------- | -------- | ------------------------- | ---------- |
| 1.0     | 1.0      | Initial release of module | N/A        |
| 1.1     | 1.1      | Validated and released    | N/A        |

## Variables

| Name                                       | Type         | Description                                                                     | Example                                                                                                                                                                                   | Optional?                                                                        |
| ------------------------------------------ | ------------ | ------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| resource_group                             | String       | The NSG resource group                                                          | rg-303-uai3047228-core-infra                                                                                                                                                              | No                                                                               |
| nsg_name                                   | Sting        | The Name of the NSG you want this rule to go in                                 | nsg-303-uai3047228-application                                                                                                                                                            | No                                                                               |
| sec_rule_name                              | Sting        | The name of the rule                                                            | Test Sec Rule                                                                                                                                                                             | No                                                                               |
| description                                | string       | NA - Details of purpose of this rule                                            | This rule lets internet traffic out                                                                                                                                                       | No                                                                               |
| protocol                                   | string       | The protocol used                                                               | Tcp, Udp, Icmp, Esp, Ah, \*                                                                                                                                                               | No                                                                               |
| destination_port_ranges                    | list(string) | Minimum one string list of ports to use                                         | ["1433","1433-5432"]                                                                                                                                                                      | No                                                                               |
| source_address_prefixes                    | list(string) | Identifies CIDR blocks, or AZURE Service Tags. If used minimum one string list. | ["VirtualNetwork"] <br> ["3.0.0.0/8", "10.0.0.0/8"] <br>...                                                                                                                               | Yes (Either this one or source_application_security_group_ids must be used)      |
| source_application_security_group_ids      | list(string) | Ids for the application security groups to use. If used minimum one string list | ["/subscriptions/0a5cbf80-58cc-4d2f-8195-13d1e07e306c/resourceGroups/rg-365-uai3047228-core-infra/providers/Microsoft.Network/applicationSecurityGroups/asg-365-uai3047228-bastion-base"] | Yes (Either this one or source_address_prefixes must be used)                    |
| destination_address_prefixes               | list(string) | Identifies CIDR blocks, or AZURE Service Tags. If used minimum one string list  | ["3.0.0.0/8", "10.0.0.0/8]<br> ["*"] <br> ["VirtualNetwork"]                                                                                                                              | Yes (Either this one or destination_application_security_group_ids must be used) |
| destination_application_security_group_ids | list(string) | Ids for the application security groups to use. If used minimum one string list | ["/subscriptions/0a5cbf80-58cc-4d2f-8195-13d1e07e306c/resourceGroups/rg-365-uai3047228-core-infra/providers/Microsoft.Network/applicationSecurityGroups/asg-365-uai3047228-bastion-base"] | Yes (Either this one or destination_address_prefixes must be used)               |
| access                                     | string       | What access to use                                                              | Allow, Deny                                                                                                                                                                               | No                                                                               |
| priority                                   | number       | Between 100 and 4096. Follow GP rule priority guide                             | 601                                                                                                                                                                                       | No                                                                               |
| direction                                  | string       | Inbound, Outbound                                                               | Inbound                                                                                                                                                                                   | No                                                                               |


## Outputs

These are able to be referenced by other modules in the same terraform file (i.e. module.sec_rule.net-rule)

| Name     | Description                                 |
| -------- | ------------------------------------------- |
| net-rule | ID of the provisioned network security rule |

## Example Usage

```
#Create test nsg rule
module "sec_rule" {
  source        = "git::https://github.build.ge.com/vernova-cloud-iac/Azure-Patterns.git//modules/sec_rule?ref=1.6"
  sec_rule_name = "Infra-Test"
  resource_group = var.applicationNSGResourceGroup
  nsg_name = var.nsg_name
  description = "Test App Rule."
  protocol = "Tcp"
  destination_port_ranges =["80","443"]
  source_address_prefixes = ["3.0.0.0/8", "10.0.0.0/8"]
  destination_address_prefixes = ["*"]
  access = "Allow"
  priority = "666"
  direction = "Inbound"
}  
```

## Details

Creates an Network Security Rule with the provided details.
