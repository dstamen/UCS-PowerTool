# UCS PowerTool Script that to set Syslog
# @davidstamen
# http://davidstamen.com

#Define Variables
$cred = Get-Credential
$domains = "ucs01.lab.local","ucs02.lab.local"
$SyslogServer = "syslog.lab.local"
$Name = "primary"
$Facility = "local7"
$AdminState = "enabled"
$Severity = "notifications"

#Cycles through each UCS setting values
Foreach ($ucs in $domains) {
  Connect-UCS $ucs -Credential $cred
  Get-UcsSyslogClient -Name $Name | Set-UcsSyslogClient -AdminState $AdminState -ForwardingFacility $Facility -Hostname $SyslogServer -Severity $Severity -Force
  Disconnect-UCS
}
