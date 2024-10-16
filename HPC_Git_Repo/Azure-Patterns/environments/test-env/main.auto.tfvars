subcode = "327"
region  = "East US"
uai     = "uai3047228"
env     = "dev"

appName = "mina-lab"



subscription_id = "d0795f6d-b7a1-41a6-a156-ee5335433d9d"


subnet_details = [
  {
    "subnet_name"       = "Application-Subnet"
    "address_prefixes"  = ["10.155.151.0/25"]
    "service_endpoints" = ["Microsoft.KeyVault", "Microsoft.Storage"]
  },
  {
    "subnet_name"       = "DB-Subnet"
    "address_prefixes"  = ["10.155.150.128/26"]
    "service_endpoints" = ["Microsoft.KeyVault", "Microsoft.Storage"]
  },
  {
    "subnet_name"       = "Integration-Subnet"
    "address_prefixes"  = ["10.155.150.192/26"]
    "service_endpoints" = ["Microsoft.KeyVault", "Microsoft.Storage"]
  },
]

# bastionCIDR     = "10.155.150.0/23"
include_subnets = false

# keyvault_id = "/subscriptions/d0795f6d-b7a1-41a6-a156-ee5335433d9d/resourceGroups/rg-327-uai3047228-common/providers/Microsoft.KeyVault/vaults/kv-327-uai3047228-common"
# key_name = "kv-327-uai3047228-common"
# keyvault_name = "kv-327-uai3047228-common"
# keyvault_rg = "rg-327-uai3047228-common"