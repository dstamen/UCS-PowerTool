# UCS PowerTool Script that will Configure the Policy Backup and Export.
# @davidstamen
# http://davidstamen.com

#Define Variables
$UCS = "FQDNofUCS" #FQDN of UCS To COnnect To
$Hostname = "ucs.lab.local" #Hostname to Upload backup to.
$Protocol = "scp" #Transfer Protocol. ftp,scp,tftp,sftp
$User = "ftpuser" #Username
$Password = "ftpuser" #Password
$MgmtBackupRemoteFile = "Full" #Location/Prefix of File. Location/Prefix will be in front of filename
$ConfigBackupRemoteFile = "AllConfig" #Location/Prefix of File. Location/Prefix will be in front of filename
$AdminState = "enable" #enable or disable
$Schedule = "1day" #1day, 7day, 14day for daily, weekly or biweekly backups

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
