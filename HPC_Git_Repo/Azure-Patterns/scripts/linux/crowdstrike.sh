#!/bin/bash

managed_identity_object_id=$1
centralized_subscription_id=$2
centralized_storage_account=$3

#Reinstall CS if service or process is down
function reinstallCrowdStrike
{

  # identify & uninstall crowdstrike package
  yum list package falcon-sensor && yum remove falcon-sensor -y
  
  # authenticate to azure using managed identity
  az login --identity --username $managed_identity_object_id

  # configure subscription id
  az account set --subscription $centralized_subscription_id

  # download installer script
  az storage blob download --account-name $centralized_storage_account --container-name common --name falcon-sensor.el7.x86_64.rpm --file /tmp/falcon-sensor.el7.x86_64.rpm --auth-mode login

  # run falcon sensor installer script on target system
  yum install /tmp/falcon-sensor.el7.x86_64.rpm -y

  # configure falcon-sensor to use custom CID
  /opt/CrowdStrike/falconctl -s --cid=D96C92BDFB0946B589727FF82FB4601A-9E

  # start crowdstrike service
  systemctl start falcon-sensor
  
}

#CS service is failing while configuring
CheckExited=`systemctl status falcon-sensor | grep -w 'code=exited'`

#CS check if there is a falcon-sensor process
CheckExistingProcess=`ps -ef | grep 'falcon-sensor' | grep -v grep`

#CS if installed 
CheckInstalled=`rpm -qa | grep 'falcon-sensor'`

#CS check if falcon-sensor is stopped
#CheckStopped=`systemctl status falcon-sensor  | grep 'dead'`

#CS check if falcon-sensor is running
CheckRunning=`systemctl status falcon-sensor  | grep 'active (running) since'`

# STEP #1: Falcon-sensor must start up properly & there must already be a crowdstrike process already running
if [[ ! -z "$CheckExited" || -z "$CheckExistingProcess" || -z "$CheckInstalled" ]]
then
  echo "CrowdStrike either not installed, started properly, or no process exists, RE-INSTALLING..."
  reinstallCrowdStrike
else
  echo "CrowdStrike Status installed, started properly, and a process has been identified.. SUCCESS"
fi

# STEP #2: If this "grep" returns a match on 'dead' status, then re-install crowdstrike 
if [[ ! -z "$CheckStopped" || -z "$CheckRunning" ]]
then
  echo "Restarting Crowdstrike..."

  # start crowdstrike service
  systemctl start falcon-sensor
else
  echo "No need to restart CrowdStrike.. SUCCESS"
fi