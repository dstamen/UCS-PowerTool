# UCS PowerTool Script that set UCS equipment name and label to match service profile
# @davidstamen
# http://davidstamen.com

#Define Variables
$cred = Get-Credential
$domains = "ucs01.lab.local","ucs02.lab.local"

#Cycles through each UCS setting values
#This script is currently setup to be applied to Rack Units. To have this work for blades, change the Get-UCSRackUnit and Set-UCSRackunit to be Get-UCSBlade and Set-UCSBlade.
Foreach ($ucs in $domains) {
  Connect-UCS $ucs -Credential $cred
  $servers = Get-UCSRackUnit
  Foreach ($server in $servers) {
    Get-UCSRackUnit -id $server.id | Set-UCSRackunit -UsrLbl $server.assignedtodn.substring(12) -Name $server.assignedtodn.substring(12) -force
  }
  Disconnect-UCS
}
