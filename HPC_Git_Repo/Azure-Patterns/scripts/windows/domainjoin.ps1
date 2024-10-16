Param(
  [String] $managed_identity_object_id,
  [String] $centralized_subscription_id,
  [String] $centralized_key_vault
)

#Get domain join secret
az login --identity --username $managed_identity_object_id

az account set --subscription $centralized_subscription_id

$domain_join_pass = az keyvault secret show --name "domain-join-password" --vault-name $centralized_key_vault --query "value"
$domain_join_pass = $domain_join_pass.Replace("`"","")

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

#Setup domain join creds
$password = $domain_join_pass | ConvertTo-SecureString -asPlainText -Force
$username = 'mgmt.cloud.ds.ge.com\lg397053sv'
$hostname = "$env:COMPUTERNAME"
$credential = New-Object System.Management.Automation.PSCredential($username,$password)

(Get-WmiObject -class Win32_TSGeneralSetting -Namespace root\cimv2\terminalservices -ComputerName $env:COMPUTERNAME -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0)

add-type @"
 using System.Net;
 using System.Security.Cryptography.X509Certificates;
 public class TrustAllCertsPolicy : ICertificatePolicy {
 public bool CheckValidationResult(
 ServicePoint srvPoint, X509Certificate certificate,
 WebRequest request, int certificateProblem) {
 return true;
 }
 }
"@

 [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
 [System.Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


#ARS Entry
$contenttype = "text/xml; charset=UTF-8"
$body = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><addRequest xmlns="urn:oasis:names:tc:SPML:2:0" returnData="nothing"><containerID ID="OU=Unclaimed,OU=Computers,OU=Enterprise,DC=mgmt,DC=cloud,DC=ds,DC=ge,DC=com" /><data><attr name="cn" xmlns="urn:oasis:names:tc:DSML:2:0:core"><value>changehostname</value></attr><attr name="sAMAccountName" xmlns="urn:oasis:names:tc:DSML:2:0:core"><value>changehostname$</value></attr><attr name="objectClass" xmlns="urn:oasis:names:tc:DSML:2:0:core"><value>computer</value></attr><attr name="edsaJoinComputerToDomain" xmlns="urn:oasis:names:tc:DSML:2:0:core"><value>CC-MGMT\DEL_GE009000000_SVR_Join_Domain</value></attr><attr name="GEHRINDUSTRYGROUPID" xmlns="urn:oasis:names:tc:DSML:2:0:core"><value>1877184</value></attr><attr name="GEVSVRTYPE" xmlns="urn:oasis:names:tc:DSML:2:0:core"><value>Windows</value></attr><attr name="GEVSVRSUPPORTEDBY" xmlns="urn:oasis:names:tc:DSML:2:0:core"><value>GE009000000</value></attr><attr name="otherManagedBy" xmlns="urn:oasis:names:tc:DSML:2:0:core"><value>CN=305017292,OU=Standard,OU=Users,OU=Enterprise,DC=Logon,DC=DS,DC=GE,DC=COM</value></attr></data></addRequest></soap:Body></soap:Envelope>'
$body = $body.Replace('changehostname', $hostname)
#$body = $body.Replace('changesso', $appowner)
$resp = Invoke-RestMethod -Method 'POST' -Uri https://ars.cloudad.tools.ds.ge.com/spml/SPMLProvider.asmx -Credential $credential -ContentType $contenttype -Body $body
$status = $resp.Envelope.Body.addResponse.status

#Make sure status is success before moving forward
while ($status.ToLower() -ne "success" -And ($status.ToLower() -eq "failure" -And $resp.Envelope.Body.addResponse.error.ToLower() -ne "alreadyExists")){
    $resp = Invoke-RestMethod -Method 'POST' -Uri https://ars.cloudad.tools.ds.ge.com/spml/SPMLProvider.asmx -Credential $credential -ContentType $contenttype -Body $body
    $status = $resp.Envelope.Body.addResponse.status
}
Write-Output "ARS Entry Added"
