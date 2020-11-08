# UCS PowerTool Script that will create tech support for each chassis and all blades for the ucs domains listed
# @davidstamen
# http://davidstamen.com

#Define Variables
$cred = Get-Credential
$domains = "ucs01.lab.local","ucs02.lab.local"
$filelocRoot = "C:\temp\ucs-logs\"

#Cycles through each UCS creating a tech support for each chassis.
Foreach ($ucs in $domains) {

        #Connect to UCS
        Connect-UCS $ucs -Credential $cred

        #Create the Folder for each ucs if it does not already exist
        $fileloc = $filelocRoot + $ucs + "\"
        if (!(Test-path $fileloc)){
            New-Item -Path $fileloc -ItemType "directory"
        }

        #Read FI Information and export it into a Text file for Serial Number infos to have it at hand for creating a Cisco Support Case
        $filename = $fileloc + "FIinfos.txt"
        Get-UcsNetworkElement | select ucs, dn, vendor, model ,serial, oobifip, operability | Out-File -FilePath $filename

        #Creates the UCS Manager tech support bundle and downloads it
        $filename = $fileloc + $ucs + "-techsupp-ucsm.tar"
        Get-UcsTechSupport -PathPattern $filename –UcsManager -RemoveFromUcs -TimeoutSec 600

        #Download Chassis Tech Support Bundle for each Chassis
        $Chassis = Get-UCSChassis
          Foreach ($chassis in $chassis) {
                  $id = $chassis.id
                  $filename = $fileloc + $ucs + "-techsupp-chassis-" + $id + ".tar"

                  #Abort if the file already exists
                  if (Test-Path $filename){
                      write-host "Bundle already exisis in folder $fileloc has to be deleted first"
                      exit
                  }
                  Get-UcsTechSupport -PathPattern $filename -RemoveFromUcs -TimeoutSec 600 -ChassisId $id -CIMC 'all'
          }
        Disconnect-UCS
}
