# UCS PowerTool Script to set UCS SNMP configuration
# @davidstamen
# http://davidstamen.com

#Define Variables
$cred = Get-Credential
$domains = "ucs01.lab.local","ucs02.lab.local"
$Descr = "SNMP config for UCS"
$AdminState = "enabled"
$SysContact = "admin@lab.local"
$SysLocation = "US"
$Community = "public"

#Cycles through each UCS setting values
Foreach ($ucs in $domains) {
  Connect-UCS $ucs -Credential $cred
  $servers = Get-UCSRackUnit
  Foreach ($server in $servers) {
    Set-UcsSnmp -Descr $Descr -AdminState $AdminState -SysContact  $SysContact -SysLocation $SysLocation -Community $Community -force
  }
  Disconnect-UCS
}
