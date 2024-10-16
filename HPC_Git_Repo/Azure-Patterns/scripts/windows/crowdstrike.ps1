Param(
  [String] $managed_identity_object_id,
  [String] $centralized_subscription_id,
  [String] $centralized_storage_account
)

# fetch configuration for crowdstrike sensor platform
$app = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -match "CrowdStrike Sensor Platform"}

# is crowdstrike sensor installed?
if ( "CrowdStrike Sensor Platform" -eq $app.Name )
{
  echo "CrowdStrike is already installed. Quitting..."
} 
else 
{
  # navigate to the installation directory
  cd 'C:\temp'   

  # invoke executable
  $EXECUTABLE = "C:\temp\WindowsSensor_D96C92BDFB0946B589727FF82FB4601A-9E.exe"

  az login --identity --username $managed_identity_object_id

  az account set --subscription $centralized_subscription_id
    
  az storage blob download --account-name $centralized_storage_account --container-name "common" --name "WindowsSensor_D96C92BDFB0946B589727FF82FB4601A-9E.exe" --file "WindowsSensor_D96C92BDFB0946B589727FF82FB4601A-9E.exe" --auth-mode login
  
  # pause installation
  sleep 10
  
  # invoke crowdstrike sensor
  Start-Process -Wait -FilePath $EXECUTABLE -ArgumentList "/install /quiet /norestart CID=D96C92BDFB0946B589727FF82FB4601A-9E"
  
  echo "CrowdStrike has been installed"
}