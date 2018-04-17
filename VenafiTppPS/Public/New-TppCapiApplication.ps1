<#
.SYNOPSIS 
Create a new CAPI application object

.DESCRIPTION
Create a new CAPI application object

.PARAMETER DN
DN path to the new object.

.PARAMETER FriendlyName
CAPI Settings\Friendly Name

.PARAMETER CertificateDN
Path to the associated certificate

.PARAMETER CredentialDN
Path to the associated credential which has rights to access the connected device

.PARAMETER Disable
Set processing to disabled.  It is enabled by default.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS

#>
function New-TppCapiApplication {

    [CmdletBinding(DefaultParameterSetName = 'None')]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                # this regex could be better
                if ( $_ -match "^\\VED\\Policy\\.*" ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN"
                }
            })]
        [string] $DN,
        
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $FriendlyName,

        [Parameter()]
        [Switch] $Disable,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                # this regex could be better
                if ( $_ -match "^\\VED\\Policy\\.*" ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN"
                }    
            })]    
        [String] $CertificateDN,    

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String] $Description,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                # this regex could be better
                if ( $_ -match "^\\VED\\Shared Credentials\\.*" ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN"
                }    
            })]    
        [String] $CredentialDN,    

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

    if ( -not (Test-TppObjectExists -DN $CertificateDN).Exists ) {
        throw ("The certificate {0} does not exist" -f $CertificateDN)
    }

    if ( -not (Test-TppObjectExists -DN $CredentialDN).Exists ) {
        throw ("The credential {0} does not exist" -f $CredentialDN)
    }

    $params = @{
        DN        = $DN
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
                Value = $CredentialDN
            },
            @{
                Name  = 'Certificate'
                Value = $CertificateDN
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
    New-TppObject @params

}
