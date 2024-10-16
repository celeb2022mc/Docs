Param(
  [String] $managed_identity_object_id,
  [String] $centralized_subscription_id,
  [String] $centralized_storage_account,
  [String] $vnet_name
)

# prepare local directories for splunk installation 
# Following files must be deleted: "server.conf", "server.pem", "input.conf", "deploymentclient.conf"
# Must create following directory: "C:\Program Files\SplunkUniversalForwarder\etc\apps\deployment\local"
function prepare_filesystem {

  # clear configs already existing: "server.conf", "server.pem"
  if (Test-PATH 'C:\Program Files\SplunkUniversalForwarder\etc\system\local\server.conf')
  {
    remove-item -path 'C:\Program Files\SplunkUniversalForwarder\etc\system\local\server.conf'
  }
  if (Test-PATH 'C:\Program Files\SplunkUniversalForwarder\etc\auth\server.pem')
  {
    remove-item -path 'C:\Program Files\SplunkUniversalForwarder\etc\auth\server.pem'
  }

  # remove "input.conf"
  if (Test-PATH 'C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs.conf')
  {
    remove-item -path 'C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs.conf'
  }

  # remove "deploymentclient.conf"
  if (Test-PATH 'C:\Program Files\SplunkUniversalForwarder\etc\apps\deployment_client\default\deploymentclient.conf')
  {
    remove-item -path 'C:\Program Files\SplunkUniversalForwarder\etc\apps\deployment_client\default\deploymentclient.conf'
  }

  # create & prepare deployment local directory if not present already
  if (!(Test-Path 'C:\Program Files\SplunkUniversalForwarder\etc\apps\deployment\local'))
  {
    mkdir 'C:\Program Files\SplunkUniversalForwarder\etc\apps\deployment\local'
  }

  if (!(Test-Path 'C:\Program Files\SplunkUniversalForwarder\etc\system\local'))
  {
    mkdir 'C:\Program Files\SplunkUniversalForwarder\etc\system\local'
  }


  if (!(Test-Path 'C:\Program Files\SplunkUniversalForwarder\etc\apps\deployment_client\default'))
  {
    mkdir 'C:\Program Files\SplunkUniversalForwarder\etc\apps\deployment_client\default'
  }

}

# assign system environment variables, update file contents
function update_configurations {
  
  # fetch VM attributes from API 
  Set-Variable -Name "hostname" -Value (Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance/compute/name?api-version=2017-08-01&format=text")
  Set-Variable -Name "ip" -Value (Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2017-08-01&format=text")
  Set-Variable -Name "location" -Value (Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance/compute/location?api-version=2017-08-01&format=text")
  Set-Variable -Name "vmId" -Value (Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance/compute/vmId?api-version=2017-08-01&format=text")
  Set-Variable -Name "subscriptionId" -Value (Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance/compute/subscriptionId?api-version=2017-08-01&format=text")
  Set-Variable -Name "vmsize" -Value (Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance/compute/vmSize?api-version=2017-08-01&format=text")

  # concatenate provided variables into new attributes
  Set-Variable -Name "inputconfig" -Value  "host = ${hostname}:${vmId}:${ip}:${location}:${vnet_name}:${subscriptionId}"
  Set-Variable -Name "deploymentclient" -Value  "clientName = ${location}:${vnet_name}:${subscriptionId}:${vmsize}"

  # transfer into following directory to update "inputs.conf"
  cd 'C:\Program Files\SplunkUniversalForwarder\etc\system\local'
  Set-Content -Path  '.\inputs.conf' -Value "[default]"
  Add-Content -Path  '.\inputs.conf' -Value "${inputconfig}"

  # transfer into directory to update "deploymentclient.conf" file
  cd 'C:\Program Files\SplunkUniversalForwarder\etc\apps\deployment_client\default'
  Set-Content -Path  '.\deploymentclient.conf' -Value "[deployment-client]"
  Add-Content -Path  '.\deploymentclient.conf' -Value "${deploymentclient}"
  Add-Content -Path  '.\deploymentclient.conf' -Value "disabled = false"
  Add-Content -Path  '.\deploymentclient.conf' -Value "[target-broker:deploymentServer]"
  Add-Content -Path  '.\deploymentclient.conf' -Value "targetUri = ds-useast.gelogging.com:443"

  # transfer into directory to update "server.conf" file
  cd 'C:\Program Files\SplunkUniversalForwarder\etc\apps\deployment\local'
  Set-Content -Path '.\server.conf' -Value "[deployment] `r`npass4SymmKey = D85A9TuK8itcU^HA#04Wi7quVL4F#4"

}

# Decipher status of Splunk "UniversalForwarder"
$app = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -match "UniversalForwarder"}

# Determine if "UniversalForwarder" is installed
if ( "UniversalForwarder" -eq $app.Name )
{
    echo "Splunk is already installed. checking ..."

} 
else 
{
    # navigate into installation directory
    cd 'C:\temp'   

    # download splunk forwarder from common storage account
    az login --identity --username $managed_identity_object_id
    
    az account set --subscription $centralized_subscription_id

    az storage blob download --account-name $centralized_storage_account --container-name "common" --name "splunkforwarder-7.1.1-8f0ead9ec3db-x64-release.msi" --file "splunkforwarder-7.1.1-8f0ead9ec3db-x64-release.msi" --auth-mode login

    # pause before invoking msiexec.exe file
    sleep 30

    # invoke splunk forwarder
    msiexec.exe /i C:\temp\splunkforwarder-7.1.1-8f0ead9ec3db-x64-release.msi AGREETOLICENSE=Yes /quiet
    
    # pause before deciphering sucessful installation
    sleep 200

    # prepare directories for installation
    prepare_filesystem

    # set proper variables in all files 
    update_configurations

    # restart splunk forwarder
    restart-service -name SplunkForwarder
}

$ServiceName = 'SplunkForwarder'

$arrService = Get-Service -Name $ServiceName

while ($arrService.Status -ne 'Running')
{

    Start-Service $ServiceName
    write-host $arrService.status
    write-host 'Service starting'
    Start-Sleep -seconds 60
    $arrService.Refresh()
    
    if ($arrService.Status -eq 'Running')
    {
        Write-Host 'Service is now Running'
    }

}