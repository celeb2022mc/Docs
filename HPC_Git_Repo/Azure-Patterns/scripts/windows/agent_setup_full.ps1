# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# SETUP A PIPELINE AGENT
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Region: us or europe
$environment = "us"
# ADO Org: gp-azr-ops-dev
$ado_org = ""
# PAT Token
$ado_token = ""

#Set variables based on region
if ($environment -eq "us"){
    $managed_identity_object_id = "9b863056-d02e-4d5a-a790-31df84d596f6"
    $centralized_subscription_id = "9c1ab385-2554-43ca-bdf8-f8d937bf4a28"
    $centralized_storage_account = "sa328uai3047228common"
    $pool = "eastus"
} else {
    $managed_identity_object_id = "9b863056-d02e-4d5a-a790-31df84d596f6"
    $centralized_subscription_id = "4e02b754-b491-401d-b5c8-6e0f92663d8e"
    $centralized_storage_account = "sa362uai3047228common"
    $pool = "westeurope"
}

#Sign in with managed identity
az login --identity --username $managed_identity_object_id
#Set subscription
az account set --subscription $centralized_subscription_id
#Download pipeline agent file
az storage blob download --container-name common --file vsts-agent-win-x64-2.189.0.zip --name vsts-agent-win-x64-2.189.0.zip --auth-mode login --account-name $centralized_storage_account
#Unzip the archive
Expand-Archive -Path .\vsts-agent-win-x64-2.189.0.zip -DestinationPath c:\agents -Force
#Run the agent setup
cd "C:\agents"
$serverURL = -join("https://dev.azure.com/", $ado_org)
.\config.cmd --unattended --url $serverURL --auth pat --token $ado_token --pool $pool --runAsService

#Install necessary powershell modules
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Az -Repository PSGallery -Force
Import-Module Az

#Install chocolately to get git and terraform
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install -y git
choco install -y terraform --version 1.0.7
refreshenv