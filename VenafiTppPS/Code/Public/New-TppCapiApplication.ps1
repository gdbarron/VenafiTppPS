<#
.SYNOPSIS
Create a new CAPI application

.DESCRIPTION
Create a new CAPI application

.PARAMETER Path
DN path to the new object.

.PARAMETER FriendlyName
CAPI Settings\Friendly Name

.PARAMETER CertificatePath
Path to the associated certificate

.PARAMETER CredentialPath
Path to the associated credential which has rights to access the connected device

.PARAMETER Disable
Set processing to disabled.  It is enabled by default.

.PARAMETER PassThru
Return a TppObject representing the newly created capi app.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS
TppObject, if PassThru provided

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppCapiApplication/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppCapiApplication.ps1

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Set-TppAttribute.ps1

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Test-TppObjectsExists/

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Find-TppObject/

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-create.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____9

#>
function New-TppCapiApplication {

    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '')]

    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('DN')]
        [string] $Path,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $FriendlyName,

        [Parameter()]
        [Switch] $Disable,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('CertificateDN')]
        [String] $CertificatePath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String] $Description,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('CredentialDN')]
        [String] $CredentialPath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Int] $WinRmPort,

        [Parameter(Mandatory, ParameterSetName = 'UpdateIis')]
        [Switch] $UpdateIis,

        [Parameter(Mandatory, ParameterSetName = 'UpdateIis')]
        [ValidateNotNullOrEmpty()]
        [String] $WebSiteName,

        [Parameter(ParameterSetName = 'UpdateIis')]
        [ValidateNotNullOrEmpty()]
        [ipaddress] $BindingIpAddress,

        [Parameter(ParameterSetName = 'UpdateIis')]
        [ValidateNotNullOrEmpty()]
        [Int] $BindingPort,

        [Parameter(ParameterSetName = 'UpdateIis')]
        [ValidateNotNullOrEmpty()]
        [String] $BindingHostName,

        [Parameter(ParameterSetName = 'UpdateIis')]
        [ValidateNotNullOrEmpty()]
        [Bool] $CreateBinding,

        [Parameter()]
        [switch] $PassThru,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    if ( -not (Test-TppObject -Path $CertificatePath -ExistOnly) ) {
        throw ("The certificate {0} does not exist" -f $CertificatePath)
    }

    # ensure the credential exists and is actually of type credential
    $credentialName = (Split-Path $CredentialPath -Leaf)
    $credentialObject = Find-TppObject -Path (Split-Path $CredentialPath -Parent) -Pattern $credentialName

    if ( -not $credentialObject ) {
        throw "Credential object not found"
    }

    if ( -not ($credentialObject | Where-Object {$_.Name -eq $credentialName -and $_.TypeName -like '*credential*'}) ) {
        throw "CredentialDN is not a credential object"
    }
    # end of validation

    # start the new capi app work here
    $params = @{
        DN        = $Path
        Class     = 'CAPI'
        Attribute = @{
            'Driver Name'   = 'appcapi'
            'Friendly Name' = $FriendlyName
            'Credential'    = $CredentialPath
            'Certificate'   = $CertificatePath
        }
        PassThru  = $true
    }

    if ( $Disabled ) {
        $params.Attribute.Add('Disabled', '1')
    }

    if ( $UpdateIis ) {
        $params.Attribute.Add(
            @{
                'Update IIS'    = '1'
                'Web Site Name' = $WebSiteName
            }
        )

        if ( $PSBoundParameters.ContainsKey('BindingIpAddress') ) {
            $params.Attribute.Add('Binding IP Address', $BindingIpAddress.ToString())
        }

        if ( $BindingPort ) {
            $params.Attribute.Add('Binding Port', $BindingPort)
        }

        if ( $BindingHostName ) {
            $params.Attribute.Add('Hostname', $BindingHostName)
        }

        if ( $CreateBinding ) {
            $params.Attribute.Add('Create Binding', $CreateBinding)
        }
    }

    $response = New-TppObject @params

    # update Consumers attribute on cert with DN of this new app
    # required to make the "cross connection" between objects
    $certUpdateParams = @{
        Path          = $CertificatePath
        AttributeName = 'Consumers'
        Value         = $response.Path
    }
    $certUpdateResponse = Set-TppAttribute @certUpdateParams -NoClobber

    if ( $certUpdateResponse.Success ) {
        if ( $PassThru ) {
            $response
        }
    }
    else {
        throw $certUpdateResponse.Error
    }
}
