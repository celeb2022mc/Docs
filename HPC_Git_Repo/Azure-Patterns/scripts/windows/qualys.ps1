Param(
  [String] $managed_identity_object_id,
  [String] $centralized_subscription_id,
  [String] $centralized_storage_account
)

# Point Qualys Cloud Agent back towards GE Gas Power
$CustomerId = "68eb016f-54af-dd18-8239-669f3efb4315"
$ActivationId = "898b238d-0cf8-4c3c-a4e0-3118984584e2"

Set-Location 'C:\temp'   

Write-Output "Downloading Qualys Cloud Agent"
az login --identity --username $managed_identity_object_id

az account set --subscription $centralized_subscription_id

az storage blob download --account-name $centralized_storage_account --container-name "common" --name "QualysCloudAgent.exe" --file "QualysCloudAgent.exe" --auth-mode login

# pause invocation
Start-Sleep 10

Write-Output "Configuring Qualys"
# run qualys cloud agent installer
.\QualysCloudAgent.exe CustomerId=$CustomerId  ActivationId=$ActivationId

Write-Output "Qualys has been installed"