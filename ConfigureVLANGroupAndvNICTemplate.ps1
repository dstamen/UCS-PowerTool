# PowerCLI Script for adding VLAN to VLAN Group and vNIC Template
# @davidstamen
# http://davidstamen.com

#Define Variables
$cred = Get-Credential
$ucs = "ucs01"
$startvlan = "100"
$endvlan = "150"
$vnictemplate = "vnic-template"
$vlangroup = "vlan-group"

#Connect to UCS
Connect-UCS $ucs -credential $cred

#Assumes VLAN Name is the VLANID. Adds VLAN from start to end to vlan group
for($i=$startvlan;$i -le $endvlan;$i++){Get-UcsFabricNetGroup -Name $vlangroup |Add-UcsFabricPooledVlan -Name "$i"}

#Assumes VLAN Name is the VLANID. Adds VLAN from start to end to vnic template
for($i=$startvlan;$i -le $endvlan;$i++){Get-UcsVnicTemplate -Name $vnictemplate | Add-UcsVnicInterface -ModifyPresent -DefaultNet false -Name "$i"}
Disconnect-UCS
