#Variables to be injected by terraform
$managed_identity_object_id = "${managed_identity_object_id}"
$centralized_subscription_id = "${centralized_subscription_id}"
$centralized_storage_account = "${centralized_storage_account}"
$netgroups = '"${netgroups}"'
$vnet_name = "${vnet_name}"
$centralized_key_vault = "${centralized_key_vault}"

#Setup az cli
# Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi

az login --identity --username $managed_identity_object_id

az account set --subscription $centralized_subscription_id

#Download and Run Disk Mount
az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/windows/disk_mount.ps1" --file "C:\setup_scripts\disk_mount.ps1" --auth-mode login
Set-Location "C:\setup_scripts"
.\disk_mount.ps1

#Download and Run Qualys Installation
az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/windows/qualys.ps1" --file "C:\setup_scripts\qualys.ps1" --auth-mode login
Set-Location "C:\setup_scripts"
.\qualys.ps1 $managed_identity_object_id $centralized_subscription_id $centralized_storage_account

# Download and Run Splunk Installation
# az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/windows/splunk.ps1" --file "C:\setup_scripts\splunk.ps1" --auth-mode login
# Set-Location "C:\setup_scripts"
# .\splunk.ps1 $managed_identity_object_id $centralized_subscription_id $centralized_storage_account $vnet_name

# Download and Run Crowdstrike Installation
# az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/windows/crowdstrike.ps1" --file "C:\setup_scripts\crowdstrike.ps1" --auth-mode login
# Set-Location "C:\setup_scripts"
# .\crowdstrike.ps1 $managed_identity_object_id $centralized_subscription_id $centralized_storage_account

#Download and Run Ansible User Creation Script.
#az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/windows/add-ansible-user.ps1" --file "C:\setup_scripts\add-ansible-user.ps1" --auth-mode login
#Set-Location "C:\setup_scripts"
#.\add-ansible-user.ps1 $managed_identity_object_id $centralized_subscription_id $centralized_storage_account $centralized_key_vault -ErrorAction SilentlyContinue


#Only run domain join if there are provided netgroups
if ($netgroups.Length -gt 10) {
    #Download Net Groups scripts and replace variables
    az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/windows/addnetgroups.ps1" --file "C:\setup_scripts\addnetgroups.ps1" --auth-mode login
    (Get-Content C:\setup_scripts\addnetgroups.ps1).replace('NETGROUPS', $netgroups) | Set-Content C:\setup_scripts\addnetgroups.ps1

    #Download domain join
    az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/windows/domainjoin.ps1" --file "C:\setup_scripts\domainjoin.ps1" --auth-mode login
    Set-Location "C:\setup_scripts"
    .\domainjoin.ps1 $managed_identity_object_id $centralized_subscription_id $centralized_key_vault

    #Download addcomputer
    az storage blob download --account-name $centralized_storage_account --container-name "common" --name "vm/windows/addcomputer_restart.ps1" --file "C:\setup_scripts\addcomputer.ps1" --auth-mode login
    (Get-Content C:\setup_scripts\addcomputer.ps1).replace('managed_identity_object_id', $managed_identity_object_id) | Set-Content C:\setup_scripts\addcomputer.ps1
    (Get-Content C:\setup_scripts\addcomputer.ps1).replace('centralized_subscription_id', $centralized_subscription_id) | Set-Content C:\setup_scripts\addcomputer.ps1
    (Get-Content C:\setup_scripts\addcomputer.ps1).replace('centralized_key_vault', $centralized_key_vault) | Set-Content C:\setup_scripts\addcomputer.ps1

    #Set scheduled task for add computer
    $runTime = (Get-Date).addMinutes(5)
    $Trigger = New-ScheduledTaskTrigger -Once -At $runtime
    $User = "NT AUTHORITY\SYSTEM"
    $Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -File C:\setup_scripts\addcomputer.ps1"
    Register-ScheduledTask -TaskName "AddComputerToDomain" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force

    #Set scheduled task for add net groups
    $runTime2 = (Get-Date).addMinutes(10)
    $Trigger2 = New-ScheduledTaskTrigger -Once -At $runtime2
    $User2 = "NT AUTHORITY\SYSTEM"
    $Action2 = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -File C:\setup_scripts\addnetgroups.ps1"
    Register-ScheduledTask -TaskName "AddNetgroups" -Trigger $Trigger2 -User $User2 -Action $Action2 -RunLevel Highest –Force
}
