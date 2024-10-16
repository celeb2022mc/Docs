terraform {
    backend "azurerm" {
        resource_group_name  = "rg-2013-uai3064621-common"
        subscription_id      = "9fd8d0ba-5d07-45b2-84e6-1c85cc79832d" // INPUT THE SUBSCRIPTION ID
        storage_account_name = "sa2013uai3064621common"
        container_name       = "statefilestorage"
        key = "2013/uai3064621test.tfstate"
    }
}