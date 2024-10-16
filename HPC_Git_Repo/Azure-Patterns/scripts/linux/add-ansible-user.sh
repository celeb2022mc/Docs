#DO NOT FORGET Semicolon at end of each line. The script is executed as single string 
#!/bin/bash
managed_identity_object_id=$1
centralized_subscription_id=$2
centralized_storage_account=$3

az login --identity --username $managed_identity_object_id --output none;
az account set --subscription "${centralized_subscription_id}" --output none;
az storage blob download --account-name "${centralized_storage_account}" --container-name "common" --name "ansible/ansible_public_rsa.pub" --file "ansible.pub" --auth-mode login --output none;
ls -la ansible.pub; 
egrep "ansible" /etc/passwd > /dev/null;
if [ $? -eq 0 ]
then
  echo "ansible user exists, replacing public key !";
  mv /home/ansible/.ssh/authorized_keys /home/ansible/.ssh/authorized_keys-`date --iso`;
  cat ansible.pub >> /home/ansible/.ssh/authorized_keys;
  chmod 0644 /home/ansible/.ssh/authorized_keys;
  service sshd reload;
  echo "complete";
else
  echo "ansible user not present, creating new";
  useradd -m "ansible";
  usermod -aG wheel "ansible";
  mkdir -p /home/ansible/.ssh;
  cat ansible.pub >> /home/ansible/.ssh/authorized_keys;
  chmod 0644 /home/ansible/.ssh/authorized_keys;
  sed -i -e '$aMatch User ansible\nPubkeyAuthentication yes\nPasswordAuthentication no\nAllowUsers ansible' /etc/ssh/sshd_config;
  sed -i "\$i + ":" ansible ":" ALL" /etc/security/access.conf;
  sed -i -e "\$i %wheel ALL=(ALL)       NOPASSWD":" ALL" /etc/sudoers;
  service sshd reload;
  echo "complete";
fi;