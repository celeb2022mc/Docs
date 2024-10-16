#!/bin/bash
CustomerId=68eb016f-54af-dd18-8239-669f3efb4315
ActivationId=898b238d-0cf8-4c3c-a4e0-3118984584e2
managed_identity_object_id=$1
centralized_subscription_id=$2
centralized_storage_account=$3

#Reinstall qualys if service or process is down
function reinstallQualys
{

  # identify & uninstall qualys hostid & qualys-cloud-agent
  rm -rf /etc/qualys/hostid && yum -y remove qualys-cloud-agent
  
  # authenticate to azure using managed identity
  az login --identity --username $managed_identity_object_id

  # configure subscription id
  az account set --subscription $centralized_subscription_id

  # download installer script
  az storage blob download --account-name "$centralized_storage_account" --container-name common --name qualys-cloud-agent.x86_64_1.7.1.37.rpm --file /tmp/QualysCloudAgent_6.2.0.59.rpm --auth-mode login

  # install qualys agent
  rpm -ivh /tmp/QualysCloudAgent_6.2.0.59.rpm

  # configure qualys agent to use activation/customer key
  /usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId="$ActivationId" CustomerId="$CustomerId"
}


#Qualys service is failing while configuring
CheckExited=`systemctl status qualys-cloud-agent | grep -w 'code=exited'`

#Qualys service if there is a falcon-sensor process
CheckExistingProcess=`ps -ef | grep 'qualys' | grep -v grep`

#Qualys if installed
CheckInstalled=`rpm -qa | grep 'qualys'`

#Qualys check qualys-cloud-agent is stopped
#CheckStopped=`systemctl status qualys-cloud-agent  | grep 'Stopped Qualys cloud agent'`

#Qualys check qualys-cloud-agent is started
CheckRunning=`systemctl status qualys-cloud-agent  | grep 'active (running) since'`

#Qualys agent running incorrect Activation Key
CheckActivationKey=`cat /etc/qualys/cloud-agent/qualys-cloud-agent.conf | grep "ActivationId=346faac7-8411-41aa-a235-105652a8064b"`

# STEP #1: Service is failing while configuring & service if there is a falcon-sensor process & if installed
if [[ -n "$CheckExited" || -z "$CheckExistingProcess" || -z "$CheckInstalled" ]]
then
  echo "Qualys either not installed, started properly, or no process exists.. RE-INSTALLING..."
  reinstallQualys
else
  echo "Qualys Status installed, started properly, and a process has been identified.. SUCCESS"
fi

# STEP #2: Check if Activation Key is configured on this box
if [[ -z "$CheckActivationKey" ]]
then
  echo "Incorrect Activation Key Found On Server.. setting to ActivationId=$ActivationId"
  # configure qualys agent to use activation/customer key
  /usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId="$ActivationId" CustomerId="$CustomerId"
  # restart qualys
  systemctl start qualys-cloud-agent
else
  echo "Activation Key Already Configured Properly.. SUCCESS"
fi

# STEP #3: If this "grep" returns a match on 'dead' status, then re-install crowdstrike
if [[ -z "$CheckRunning" ]]
then
  echo "Restarting Qualys..."
  systemctl start qualys-cloud-agent
else
  echo "No need to restart Qualys.. SUCCESS"
fi