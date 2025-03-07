function New-PSOneQRCodeVCard {
    <#
            .SYNOPSIS
            Creates a QR code graphic containing person data

            .DESCRIPTION
            Creates a QR code graphic in png format that - when scanned by a smart device - adds a contact to the address book.

            .PARAMETER FirstName
            Person first name

            .PARAMETER LastName
            Person last name

            .PARAMETER Company
            Company name

            .PARAMETER Title
            Title

            .PARAMETER Email
            email address

            .PARAMETER Mobile
            Mobile phone number

            .PARAMETER Phone
            Telephone number

            .PARAMETER Address
            Postal address

            .PARAMETER Width
            Height and Width of generated graphics (in pixels). Default is 100.

            .PARAMETER Show
            Opens the generated QR code in associated program

            .PARAMETER OutPath
            Path to generated png file. When omitted, a temporary file name is used.

            .PARAMETER AsByteArray
            Returns the byte array data for in memory processing.

            .EXAMPLE
            New-PSOneQRCodeVCard -FirstName Tom -LastName Sawyer -Company "Huckle Inc." -Email t.sawyer@huckle.com -Width 200 -Show -OutPath "$home\Desktop\qr.png"
            Creates a QR code png graphics on your desktop, and opens it with the associated program

            .NOTES
            Compatible with all PowerShell versions including PowerShell 6/Core
            Uses binaries from https://github.com/codebude/QRCoder/wiki

            .LINK
            https://github.com/TobiasPSP/Modules.QRCodeGenerator
    #>

    [CmdletBinding(DefaultParameterSetName = 'File')]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $FirstName,

        [Parameter(Mandatory)]
        [string]
        $LastName,

        [string]
        $Company,

        [string]
        $Title,

        [AllowEmptyString()]
        [string]
        $Email,

        [AllowEmptyString()]
        [string]
        $Mobile,

        [AllowEmptyString()]
        [string]
        $Phone,

        [AllowEmptyString()]
        [string]
        $Address,
        
        [ValidateRange(10, 2000)]
        [int]
        $Width = 100,

        [Switch]
        $Show,

        [Parameter(ParameterSetName = 'File')]
        [string]
        $OutPath = $Global:defaultQrCodePath,
        
        [Parameter(ParameterSetName = 'ByteArray')]
        [switch]
        $AsByteArray,

        [byte[]] 
        $DarkColorRgba = @(0, 0, 0),

        [byte[]]
        $LightColorRgba = @(255, 255, 255)
    )

    $Name = "$FirstName $LastName"

    $payload = @"
BEGIN:VCARD
VERSION:3.0
KIND:individual
N:$LastName;$FirstName
FN:$Name
"@

    if ($Company) { $payload += "ORG:$Company`n" }
    if ($Title) {  $payload += "TITLE:$Title`n" }
    if ($Email) { $payload += "EMAIL;TYPE=INTERNET:$Email`n" }
    if ($Mobile) { $payload += "TEL;TYPE=CELL:$Mobile`n" }
    if ($Phone) { $payload += "TEL;TYPE=WORK:$Phone`n" }
    if ($Address) { $payload += "ADR;TYPE=WORK:$Address`n" }

    $payload += "END:VCARD"

    $splat = @{
        payload        = $payload
        Show           = $Show
        Width          = $Width
        OutPath        = $OutPath
        darkColorRgba  = $darkColorRgba
        lightColorRgba = $lightColorRgba
    }

    if ($PSCmdlet.ParameterSetName -match 'ByteArray') {
        $splat.Add('AsByteArray', $true)
        $splat.Remove('OutPath')
        $splat.Show = $False
    }
    
    New-PSOneQRCode @splat
}
