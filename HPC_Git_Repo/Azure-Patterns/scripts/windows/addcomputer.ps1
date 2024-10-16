#Get domain join secret
az login --identity --username managed_identity_object_id

az account set --subscription centralized_subscription_id

$domain_join_pass = az keyvault secret show --name "domain-join-password" --vault-name centralized_key_vault --query "value"
$domain_join_pass = $domain_join_pass.Replace("`"","")

#Setup variables
$password = $domain_join_pass | ConvertTo-SecureString -asPlainText -Force
$domain = "mgmt.cloud.ds.ge.com"
$username = 'mgmt.cloud.ds.ge.com\lg397053sv'
$credential = New-Object System.Management.Automation.PSCredential($username,$password)

#Add computer to the domain
Add-Computer -DomainName $domain -Credential $credential