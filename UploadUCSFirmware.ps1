# UCS PowerTool Script that will upload specified firmware to UCS
# @davidstamen
# http://davidstamen.com

#Define Variables
$cred = Get-Credential
$domains = "ucs01.lab.local","ucs02.lab.local"
$fileName = "C:\Users\david\Downloads\ucs-k9-bundle-infra.2.2.6e.A.bin"

#Cycles through each UCS uploading the UCS Firmware
Foreach ($ucs in $domains)
{
Connect-UCS $ucs -Credential $cred
Send-UcsFirmware -LiteralPath $fileName | Watch-Ucs -Property TransferState -SuccessValue downloaded -PollSec 30 -TimeoutSec 600
Disconnect-UCS
}
