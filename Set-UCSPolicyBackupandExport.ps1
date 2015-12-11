# UCS PowerTool Script that will Configure the Policy Backup and Export.
# @davidstamen
# http://davidstamen.com

#Define Variables
$UCS = "FQDNofUCS"
$Hostname = "ucs.lab.local"
$Protocol = "scp"
$User = "ftpuser"
$Password = "ftpuser"
$MgmtBackupRemoteFile = "Full"
$ConfigBackupRemoteFile = "AllConfig"
$AdminState = "enable"
$Schedule = "1day"

#Import UCS Module
Import-Module *UCS*

#Connect UCSM
Connect-UCS $UCS

#Set UCS Mgmt Backup Policy
Set-UcsMgmtBackupPolicy -AdminState $AdminState -Host $Hostname -Proto $Protocol -User $User -Pwd $Password -RemoteFile $MgmtBackupRemoteFile -MgmtBackupPolicy "default" -Force

#Set UCS Config Backup Policy
Set-UcsMgmtCfgExportPolicy -AdminState $AdminState -Host $Hostname -Proto $Protocol -User $User -Pwd $Password -RemoteFile $ConfigBackupRemoteFile -MgmtCfgExportPolicy "default" -Force

#Disconnect UCS
Disconnect-UCS
