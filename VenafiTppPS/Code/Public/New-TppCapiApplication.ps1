<#
.SYNOPSIS
Create a new CAPI application object

.DESCRIPTION
Create a new CAPI application object

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

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS

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
                } else {
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
                } else {
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
                } else {
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
        [ValidateScript( {
                if ( $_ -match "^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])(\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])){3}$" ) {
                    $true
                } else {
                    throw "'$_' is not a valid IP address"
                }
            })]
        [String] $BindingIpAddress,

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
        Attribute = @(
            @{
                Name  = 'Driver Name'
                Value = 'appcapi'
            },
            @{
                Name  = 'Friendly Name'
                Value = $FriendlyName
            },
            @{
                Name  = 'Credential'
                Value = $CredentialPath
            },
            @{
                Name  = 'Certificate'
                Value = $CertificatePath
            }
        )
    }

    if ( $Disabled ) {
        $params.Attribute += @{
            Name  = 'Disabled'
            Value = '1'
        }
    }

    if ( $UpdateIis ) {
        $params.Attribute += @(
            @{
                Name  = 'Update IIS'
                Value = '1'
            },
            @{
                Name  = 'Web Site Name'
                Value = $WebSiteName
            }
        )

        if ( $BindingIpAddress ) {
            $params.Attribute += @{
                Name  = 'Binding IP Address'
                Value = $BindingIpAddress
            }
        }

        if ( $BindingPort ) {
            $params.Attribute += @{
                Name  = 'Binding Port'
                Value = $BindingPort
            }
        }

        if ( $BindingHostName ) {
            $params.Attribute += @{
                Name  = 'Hostname'
                Value = $BindingHostName
            }
        }

        if ( $CreateBinding ) {
            $params.Attribute += @{
                Name  = 'Create Binding'
                Value = $CreateBinding
            }
        }
    }

    $response = New-TppObject @params

    if ( $response.Result -eq [ConfigResult]::Success ) {
        $capiObject = $response.Object

        # update Consumers attribute on cert with DN of this new app
        # required to make the "cross connection" between objects
        $certUpdateParams = @{
            DN            = $CertificatePath
            AttributeName = 'Consumers'
            Value         = $capiObject.DN
        }
        $certUpdateResponse = Set-TppAttribute @certUpdateParams -NoClobber

        if ( $certUpdateResponse.Success ) {
            $capiObject
        } else {
            throw $certUpdateResponse.Error
        }

    } else {
        throw $response.Error
    }

}
