$netgroups = NETGROUPS

$netgroups = $netgroups.Split(" ")

#Add Netgroups
$groups = @($netgroups)
foreach ($grp in $groups) 
{
  $domain = "mgmt.cloud.ds.ge.com"
  $admin_group = $grp
  net localgroup administrators $domain $admin_group /ADD
  Write-Output "server group for domain access = $admin_group"
}