#!/bin/bash

managed_identity_object_id="${managed_identity_object_id}"
centralized_subscription_id="${centralized_subscription_id}"
centralized_storage_account="${centralized_storage_account}"
ldap_bind_dn="${ldap_bind_dn}"
ldap_password="${ldap_password}"
net_group="${net_group}"
radius_password="${radius_password}"
data_base="${data_base}"
vnet_name="${vnet_name}"

#Setup az cli
# curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

az login --identity --username $managed_identity_object_id

az account set --subscription $centralized_subscription_id

#Download and Run Disk Mount
az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/linux/disk_mount.sh" --file "disk_mount.sh" --auth-mode login
sed -i -e 's/\r//g' disk_mount.sh
bash disk_mount.sh $data_base

#Download and Run Qualys Installation
az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/linux/qualys.sh" --file "qualys.sh" --auth-mode login
sed -i -e 's/\r//g' qualys.sh
bash qualys.sh $managed_identity_object_id $centralized_subscription_id $centralized_storage_account

#Download and Run Splunk Installation
# az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/linux/splunk.sh" --file "splunk.sh" --auth-mode login
# sed -i -e 's/\r//g' splunk.sh
# bash splunk.sh $vnet_name $managed_identity_object_id $centralized_subscription_id $centralized_storage_account

#Download and Run Crowdstrike Installation
# az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/linux/crowdstrike.sh" --file "crowdstrike.sh" --auth-mode login
# sed -i -e 's/\r//g' crowdstrike.sh
# bash crowdstrike.sh $managed_identity_object_id $centralized_subscription_id $centralized_storage_account

#Download and Run ldap2fa if netgroup provided
az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/linux/ldap2fa_linux_8.sh" --file "ldap2fa.sh" --auth-mode login
sed -i -e 's/\r//g' ldap2fa.sh
#Make sure there is a netgroup provided
if [ ! -z "$net_group" ]
then
bash ldap2fa.sh $managed_identity_object_id $centralized_subscription_id $centralized_storage_account $ldap_bind_dn $ldap_password $net_group $radius_password
else
echo "No Net Group. Skipping LDAP2FA"
fi

#Download and Run ldap2fa if netgroup provided
az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/linux/add-ansible-user.sh" --file "add-ansible-user.sh" --auth-mode login
sed -i -e 's/\r//g' add-ansible-user.sh
bash add-ansible-user.sh $managed_identity_object_id $centralized_subscription_id $centralized_storage_account
