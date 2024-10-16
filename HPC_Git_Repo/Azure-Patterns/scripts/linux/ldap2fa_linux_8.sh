#!/bin/bash

managed_identity_object_id=$1
centralized_subscription_id=$2
centralized_storage_account=$3
ldap_bind_dn=$4
ldap_password=$5
net_group=$6
radius_password=$7

# authenticate to azure using 328 managed identity attached to vm
az login --identity --username $managed_identity_object_id

# configure subscription id
az account set --subscription $centralized_subscription_id


# AUTHENTICATED AND READY TO INVOKE INSTALLATION PROCESS
#####################################################################

# declare placeholder for required packages
dependencies='oddjob-mkhomedir openldap-clients openssh-clients unzip openssh-server sssd sssd-client ksh pam_radius'

# install all required packages
for dependency in $dependencies; do
  yum install $dependency -y
done

# move into special directory for 2fa installation 
mkdir -p /tmp/2fa
cd /tmp/2fa

# fetch configs zip file from common storage account
az storage blob download --account-name $centralized_storage_account --container-name common --name LDAP_REHL8_OEL8_config_files.zip --file LDAP_REHL8_OEL8_config_files.zip --auth-mode login
sleep 10

# extract config files from downloaded zip & move into unzipped folder
unzip -n /tmp/2fa/LDAP_REHL8_OEL8_config_files.zip
sleep 10
cd /tmp/2fa/LDAP_REHL8_OEL8_config_files

# remove zip file we downloaded - we no longer need it
rm -rf /tmp/2fa/LDAP_REHL8_OEL8_config_files.zip

# create all directories (required for 2fa) on this server
mkdir -p /etc/openldap/cacerts /etc/pam.d /etc/raddb /etc/security /etc/sssd /etc/sysconfig /lib64/security /lib/security

# protects a file against any access from other users, while the issuing user still has full access.
chmod 700 /etc/openldap
chmod 0700 /etc/openldap/cacerts
chmod 0700 /etc/openldap/certs
chmod 700 /etc/raddb

# traverse through all files we've downloaded
for line in `ls /tmp/2fa/LDAP_REHL8_OEL8_config_files`; do
  file=`echo "$line" | sed 's/\@/\//g'`
  \cp "$line" "$file"
  
  # convert owner priveleges onto file
  chown root:root "$file"

  # sets permissions so that, user / owner can read, can write and can't execute
  chmod 0644 "$file"
done

# sets permissions so that, user / owner can read, can write and can't execute
chmod 0600 '/etc/security/access.conf'
chmod 0600 '/etc/sssd/sssd.conf'
sleep 5

# replace placeholders for variables with provided parameters
sed -i "s|<ldap_bind_dn>|$ldap_bind_dn|g" /etc/sssd/sssd.conf
sed -i "s|<ldap_bind_pass>|$ldap_password|g" /etc/sssd/sssd.conf

#Add in all netgroups
groups=${net_group//,/ }
groupsArr=($groups)
for group in "${groupsArr[@]}"
do
    #echo $group
    echo "+ : @$group : ALL"$'\r' >> /etc/security/access.conf
done
#Append end of access.conf
echo $'+ : ALL : cron crond at atd\r' >> /etc/security/access.conf
sed -i /'- : ALL : ALL'/d /etc/security/access.conf
echo $'- : ALL : ALL\r' >> /etc/security/access.conf


# make self owner of the sudoers directory & ensure that cloud ops admins are the only aloud sudoers
chown root:root /etc/sudoers
chmod 0400 /etc/sudoers

# rehash certificates
openssl rehash /etc/openldap/cacerts

# sets permissions so that, user / owner can read, can write and can't execute
chmod 0600 /etc/raddb/server

# replace placeholders for variables with provided parameters
sed -i "s|<radius_password>|$radius_password|g" /etc/raddb/server

# sets permissions so that, user / owner can read, can write and can't execute
chmod 0600 /etc/ssh/sshd_config


# replace placeholders for variables with provided parameters
sed -i "s/UsePAM no/UsePAM yes/g" /etc/ssh/sshd_config &> /dev/null
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config &> /dev/null
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/ssh_config &> /dev/null
sed -i "s/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g" /etc/ssh/sshd_config &> /dev/null
sed -i "s/AllowTcpForwarding no/AllowTcpForwarding yes/g" /etc/ssh/sshd_config &> /dev/null
sed -i "s/MaxAuthTries 2/MaxAuthTries 6/g" /etc/ssh/sshd_config &> /dev/null
sed -i "s/AllowAgentForwarding no/AllowAgentForwarding yes/g" /etc/ssh/sshd_config &> /dev/null

# rehash certificates..
openssl rehash /etc/openldap/cacerts
openssl rehash /etc/openldap/certs

# Create symlinks
cd /etc/pam.d/
ln -sf  /etc/pam.d/password-auth-ac /etc/pam.d/password-auth
ln -sf  /etc/pam.d/system-auth-ac /etc/pam.d/system-auth

# restarting key services
systemctl enable sshd
systemctl restart sshd
systemctl enable sssd
systemctl restart sssd
