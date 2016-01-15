# UCS PowerTool Script that set UCS equipment name and label to match service profile
# @davidstamen
# http://davidstamen.com

#Define Variables
$cred = Get-Credential
$domains = "ucs01.lab.local","ucs02.lab.local"

#Cycles through each UCS setting values
Foreach ($ucs in $domains) {
  Connect-UCS $ucs -Credential $cred
  $servers = Get-UCSRackUnit
  Foreach ($server in $servers) {
    Get-UCSRackUnit -id $server.id | Set-UCSRackunit -UsrLbl $server.assignedtodn.substring(12) -Name $server.assignedtodn.substring(12) -force
  }
  Disconnect-UCS
}
