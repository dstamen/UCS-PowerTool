# UCS PowerTool Script that will create tech support for each chassis and all blades for the ucs domains listed
# @davidstamen
# http://davidstamen.com

#Define Variables
$cred = Get-Credential
$domains = "ucs01.lab.local","ucs02.lab.local"
$fileloc = "C:\Users\david\desktop\logs\"

#Cycles through each UCS creating a tech support for each chassis.
Foreach ($ucs in $domains) {
Connect-UCS $ucs -Credential $cred
$Chassis = Get-UCSChassis
  Foreach ($chassis in $chassis) {
    $id = $chassis.id
    $filename = "$fileloc$ucs-techsupp-chassis-$id.tar"
    Get-UcsTechSupport -PathPattern $filename -RemoveFromUcs -TimeoutSec 600 -ChassisId $id -CIMC 'all'
  }
Disconnect-UCS
}
