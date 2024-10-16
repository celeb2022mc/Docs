#!/bin/bash

vnet=$1
managed_identity_object_id=$2
centralized_subscription_id=$3
centralized_storage_account=$4

#Reinstall splunk if service or process is down
function reinstallSplunk 
{

  echo "Setting VNET as '$1'"

  # uninstall splunk process
  rm -rf /opt/splunkforwarder
  yum -y remove splunkforwarder
  #ps -ef | grep splunk | grep -v grep | awk '{print $2}' | xargs -I x kill x

  # download installer for splunk
  az login --identity --username $managed_identity_object_id
  az account set --subscription $centralized_subscription_id
  az storage blob download --account-name $centralized_storage_account --container-name common --name splunkforwarder-7.2.9.1-605df3f0dfdd-linux-2.6-x86_64.rpm --file /tmp/splunkforwarder-7.2.9.1-605df3f0dfdd-linux-2.6-x86_64.rpm --auth-mode login
  sleep 10


  # protect with read-permissions and perform install.
  chmod 755 splunkforwarder-7.2.9.1-605df3f0dfdd-linux-2.6-x86_64.rpm
  rpm -ivh /tmp/splunkforwarder-7.2.9.1-605df3f0dfdd-linux-2.6-x86_64.rpm
  sleep 10

  # fetch critical instance information
  export hostname=`curl -H Metadata:true "http://169.254.169.254/metadata/instance/compute/name?api-version=2019-08-01&format=text"`
  export location=`curl -H Metadata:true "http://169.254.169.254/metadata/instance/compute/location?api-version=2019-08-01&format=text"`
  export vmId=`curl -H Metadata:true "http://169.254.169.254/metadata/instance/compute/vmId?api-version=2019-08-01&format=text"`
  export subscriptionId=`curl -H Metadata:true "http://169.254.169.254/metadata/instance/compute/subscriptionId?api-version=2019-08-01&format=text"`
  export id=`curl -H Metadata:true "    http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2017-08-01&format=text"`
  export vnetname=$1

  # FILE #1: remove & reconfigure /opt/splunkforwarder/etc/apps/deployment_client/default/deployment.conf file
  rm -rf /opt/splunkforwarder/etc/apps/deployment_client/default/deploymentclient.conf
  mkdir -p /opt/splunkforwarder/etc/apps/deployment_client/default
  echo [deployment-client] > /opt/splunkforwarder/etc/apps/deployment_client/default/deploymentclient.conf
  echo clientName = $location:$vnetname:$subscriptionId >> /opt/splunkforwarder/etc/apps/deployment_client/default/deploymentclient.conf
  echo "disabled = false" >> /opt/splunkforwarder/etc/apps/deployment_client/default/deploymentclient.conf
  echo "[target-broker:deploymentServer]" >> /opt/splunkforwarder/etc/apps/deployment_client/default/deploymentclient.conf
  echo "targetUri = ds-useast.gelogging.com:443" >> /opt/splunkforwarder/etc/apps/deployment_client/default/deploymentclient.conf
  
  # FILE #2: remove & reconfigure /opt/splunkforwarder/etc/system/local directory
  rm -rf /opt/splunkforwarder/etc/system/local/inputs.conf
  mkdir -p /opt/splunkforwarder/etc/system/local
  echo host = $hostname:$id:$location:$vnetname:$subscriptionId > /opt/splunkforwarder/etc/system/local/inputs.conf

  # FILE #3: remove & reconfigure /opt/splunkforwarder/etc/apps/deployment/local directory
  rm -rf /opt/splunkforwarder/etc/apps/deployment/local/server.conf
  mkdir -p /opt/splunkforwarder/etc/apps/deployment/local
  echo "[deployment]" >> /opt/splunkforwarder/etc/apps/deployment/local/server.conf
  echo "pass4SymmKey = D85A9TuK8itcU^HA#04Wi7quVL4F#4 " >> /opt/splunkforwarder/etc/apps/deployment/local/server.conf

  # change permissions of key input files
  chown root:root /opt/splunkforwarder/etc/system/local/inputs.conf
  chmod 600 /opt/splunkforwarder/etc/system/local/inputs.conf
  chmod 600 /opt/splunkforwarder/etc/apps/deployment_client/default/deploymentclient.conf

  # check if splunk process running
  if [ -z "$(ps -ef | grep splunkd | grep -v grep)" ]
  then 
    /opt/splunkforwarder/bin/splunk start --answer-yes --no-prompt --accept-license    
  fi    

  if [ "$(/opt/splunkforwarder/bin/splunk display boot-start | grep not | wc -l)" -ne 0 ]
  then
    /opt/splunkforwarder/bin/splunk enable boot-start
  fi
}

#splunk service is failing while start
CheckFailure=`systemctl status SplunkForwarder | grep -w 'failed'`

#splunk process check
CheckExistingProcess=`ps -ef | grep 'splunkd' | grep -v grep`

#splunk is stopped
CheckRunning=`systemctl status SplunkForwarder  | grep 'active (running) since'`

#splunk if installed
CheckInstalled=`rpm -qa | grep 'splunk'`

# STEP #1: Service config has failed or not installed
if [[ ! -z "$CheckFailure" || -z "$CheckInstalled" ]]
then
  echo "Splunk status FAILED or NOT INSTALLED.. RE-INSTALLING..."
  reinstallSplunk $vnet
else
  echo "Splunk status CORRECT and INSTALLED.. SUCCESSS"
fi


# STEP #2 Splunk is running
if [[ -z "$CheckRunning" || -z "$CheckExistingProcess" ]]
then
  if [ "$(/opt/splunkforwarder/bin/splunk status | grep 'not running' | wc -l)" -eq 1 ]
  then
    echo 'splunk is not running'
    /opt/splunkforwarder/bin/splunk start --answer-yes --no-prompt --accept-license
  else 
    echo 'splunk has already ran restart to adopt config'
    /opt/splunkforwarder/bin/splunk restart
  fi
else  
  echo "No need to restart Splunk.. SUCCESS"
fi