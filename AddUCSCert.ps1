# UCS PowerTool Script that will setup Trusted Point, Keychain and Certificate Request and then assign the certificate and update HTTPS to use it.
# @davidstamen
# http://davidstamen.com

#Define Variables
$UCS = "FQDNofUCS" #Used to Connect to UCSM via PowerTool
$TrustPoint = "TP-Name" #Name of TrustPoint, AKA Root CA
$KeyRing = "KeyRingName" #name of KeyRing. Stores Certificate Information
$Modulus = "mod2048" #2048 bit key this can be 1024,2048,4096, etc
$CertDNS = "FQDNofUCS" #FQDN for Cert Request
$CertLocality = "City" #City for Cert Request
$CertState = "State" #State for Cert Request
$CertCountry = "US" #Country for Cert Request
$CertOrgName = "Org" #OrgName for Cert Request
$CertEmail = "me@lab.com" #Email for Cert Request
$CertSubjName = "FQDNofUCS" #FQDN for Cert Request
$CertIP = "FI-VIP-IP" #FI-VIP IP for Cert Request
$CertIpA = "FI-A-IP" #FI-A IP for Cert Request
$CertIpB = "FI-B-IP" #FI-B IP for Cert Request
$TPChain = "-----BEGIN CERTIFICATE-----
PASTE CERT CONTENT HERE FOR ROOTCA
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
PASTE CERT CONTENT HERE FOR SUB CA
-----END CERTIFICATE-----" #Delete Second part if not using a Root/Sub Scenario.

#Function to read in multiple lines to a variable
function Read-MultiLineInputBoxDialog([string]$Message, [string]$WindowTitle, [string]$DefaultText)
{
<#
    .SYNOPSIS
    Prompts the user with a multi-line input box and returns the text they enter, or null if they cancelled the prompt.

    .DESCRIPTION
    Prompts the user with a multi-line input box and returns the text they enter, or null if they cancelled the prompt.

    .PARAMETER Message
    The message to display to the user explaining what text we are asking them to enter.

    .PARAMETER WindowTitle
    The text to display on the prompt window's title.

    .PARAMETER DefaultText
    The default text to show in the input box.

    .EXAMPLE
    $userText = Read-MultiLineInputDialog "Input some text please:" "Get User's Input"

    Shows how to create a simple prompt to get mutli-line input from a user.

    .EXAMPLE
    # Setup the default multi-line address to fill the input box with.
    $defaultAddress = @'
    John Doe
    123 St.
    Some Town, SK, Canada
    A1B 2C3
    '@

    $address = Read-MultiLineInputDialog "Please enter your full address, including name, street, city, and postal code:" "Get User's Address" $defaultAddress
    if ($address -eq $null)
    {
        Write-Error "You pressed the Cancel button on the multi-line input box."
    }

    Prompts the user for their address and stores it in a variable, pre-filling the input box with a default multi-line address.
    If the user pressed the Cancel button an error is written to the console.

    .EXAMPLE
    $inputText = Read-MultiLineInputDialog -Message "If you have a really long message you can break it apart`nover two lines with the powershell newline character:" -WindowTitle "Window Title" -DefaultText "Default text for the input box."

    Shows how to break the second parameter (Message) up onto two lines using the powershell newline character (`n).
    If you break the message up into more than two lines the extra lines will be hidden behind or show ontop of the TextBox.

    .NOTES
    Name: Show-MultiLineInputDialog
    Author: Daniel Schroeder (originally based on the code shown at http://technet.microsoft.com/en-us/library/ff730941.aspx)
    Version: 1.0
#>
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName System.Windows.Forms

    # Create the Label.
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Size(10,10)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.AutoSize = $true
    $label.Text = $Message

    # Create the TextBox used to capture the user's text.
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Size(10,40)
    $textBox.Size = New-Object System.Drawing.Size(575,200)
    $textBox.AcceptsReturn = $true
    $textBox.AcceptsTab = $false
    $textBox.Multiline = $true
    $textBox.ScrollBars = 'Both'
    $textBox.Text = $DefaultText

    # Create the OK button.
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Size(415,250)
    $okButton.Size = New-Object System.Drawing.Size(75,25)
    $okButton.Text = "OK"
    $okButton.Add_Click({ $form.Tag = $textBox.Text; $form.Close() })

    # Create the Cancel button.
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Size(510,250)
    $cancelButton.Size = New-Object System.Drawing.Size(75,25)
    $cancelButton.Text = "Cancel"
    $cancelButton.Add_Click({ $form.Tag = $null; $form.Close() })

    # Create the form.
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $WindowTitle
    $form.Size = New-Object System.Drawing.Size(610,320)
    $form.FormBorderStyle = 'FixedSingle'
    $form.StartPosition = "CenterScreen"
    $form.AutoSizeMode = 'GrowAndShrink'
    $form.Topmost = $True
    $form.AcceptButton = $okButton
    $form.CancelButton = $cancelButton
    $form.ShowInTaskbar = $true

    # Add all of the controls to the form.
    $form.Controls.Add($label)
    $form.Controls.Add($textBox)
    $form.Controls.Add($okButton)
    $form.Controls.Add($cancelButton)

    # Initialize and show the form.
    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog() > $null   # Trash the text of the button that was clicked.

    # Return the text that the user entered.
    return $form.Tag
}
#Import UCS Module
Import-Module *UCS*

#Connect UCSM
Connect-UCS $UCS

#Add UCS TrustPoint
Add-UCSTrustPoint -Name $TrustPoint

#Add CA Cert to TrustPoint
Get-UCSTrustPoint -Name $TrustPoint | Set-UCSTrustPoint -Force -CertChain $TPChain

# Add UCS KeyRing
Add-UcsKeyring -Name $KeyRing -Modulus $Modulus

#Create UCS Certificate Request
Get-UcsKeyRing -Name $KeyRing | Add-UcsCertRequest -Dns $CertDNS -Locality $CertLocality -State $CertState -Country $CertCountry -OrgName $CertOrgName -Email $CertEmail -SubjName $CertSubjName -Ip $CertIP -IpA $CertIpA -IpB $CertIpB

#Set UCS Certificate in KeyChain
$multiLineText = Read-MultiLineInputBoxDialog -Message "Please paste completed certificate text" -WindowTitle "Paste Completed UCS Certificate"
if ($multiLineText -eq $null) { Write-Host "You clicked Cancel" }
else { Write-Host "You entered the following text: $multiLineText" }
Get-UcsKeyRing $KeyRing | Set-UcsKeyRing -Tp $TrustPoint -Force –Cert $multiLineText

#Set HTTPS to use new Certificate
Get-UcsHttps | Set-UcsHttps -KeyRing $KeyRing -AdminState enabled -Force

#Disconnect UCS
Disconnect-UCS
