Start-Transcript -Path C:\setup_scripts\ansibleusercreation.log -Append
# authenticate to azure using 328 managed identity attached to vm
az login --identity --username "managed_identity_object_id"
# configure subscription id
az account set --subscription "centralized_subscription_id"
# fetch password from keyvault secrets
$kvSecret = az keyvault secret show --name "ansible-user-windows-prd" --vault-name "centralized_key_vault" --query "value" -o tsv

az storage blob download --account-name "centralized_storage_account" --container-name "common" --name "ansible/ConfigureRemotingForAnsible.ps1" --file "C:/Windows/Temp/ConfigureRemotingForAnsible.ps1" --auth-mode login

Get-ChildItem "C:/Windows/Temp/ConfigureRemotingForAnsible.ps1"

winrm enumerate winrm/config/Listener
Remove-Item -Path WSMan:\localhost\Listener\* -Recurse -Force
powershell.exe -ExecutionPolicy UnRestricted -File C:/Windows/Temp/ConfigureRemotingForAnsible.ps1
Enable-WSManCredSSP -Role Server -Force

$password = $kvSecret | ConvertTo-SecureString -asPlainText -Force
$username = "ansible"

$user = Get-LocalUser -Name $username -ErrorAction SilentlyContinue

if ($null -ne $user) {
    try {
        Set-LocalUser -Name $username -Password $password -ErrorAction Stop
        Write-Host "The password for $username was updated successfully."
    }
    catch {
        Write-Host "An error occurred while updating the password: $_"
    }
}
else {
    try {
        New-LocalUser -Name $username -Password $password -FullName "ansible" -Description "User for ansible tower" -ErrorAction Stop
        Add-LocalGroupMember -Group "Administrators" -Member $username -ErrorAction Stop
        Write-Host "The user $username was created successfully."
    }
    catch {
        Write-Host "An error occurred while creating the user: $_"
    }
}

Stop-Transcript