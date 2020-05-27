<#
.SYNOPSIS
Create a new Venafi TPP session

.DESCRIPTION
Authenticates a user and creates a new session with which future calls can be made.
Key based credential and integrated are supported as well as token-based integrated and oauth.

.PARAMETER ServerUrl
URL for the Venafi server.

.PARAMETER Credential
PSCredential object utilizing the same credentials as used for the web front-end

.PARAMETER ClientId
Applcation Id as configured in Venafi

.PARAMETER Scope
Hashtable with Scopes and privilege restrictions

.PARAMETER IncludeAllScope
Include all scopes, when authenticating via token, instead of selecting individual ones.  Be careful with this.

.PARAMETER State
A session state, redirect URL, or random string to prevent Cross-Site Request Forgery (CSRF) attacks

.PARAMETER PassThru
Optionally, send the session object to the pipeline instead of script scope.

.OUTPUTS
TppSession, if PassThru is provided

.EXAMPLE
New-TppSession -ServerUrl https://venafitpp.mycompany.com
Connect using Windows Integrated authentication and store the session object in the script scope

.EXAMPLE
New-TppSession -ServerUrl https://venafitpp.mycompany.com -Credential $cred
Connect to the TPP server and store the session object in the script scope

.EXAMPLE
New-TppSession -ServerUrl https://venafitpp.mycompany.com -ClientId MyApp -Scope @{'certificate'='manage'}
Connect using token-based Windows Integrated authentication

.EXAMPLE
$sess = New-TppSession -ServerUrl https://venafitpp.mycompany.com -Credential $cred -PassThru
Connect to the TPP server and return the session object

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppSession/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppSession.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Authorize.php?TocPath=REST%20API%20reference|Authentication%20and%20API%20key%20programming%20interfaces|_____1

.LINK
https://docs.venafi.com/Docs/18.3SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Authorize-Integrated.php?tocpath=REST%20API%20reference%7CAuthentication%20and%20API%20key%20programming%20interfaces%7C_____2

#>
function New-TppSession {

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'KeyIntegrated')]

    param(
        [Parameter(Mandatory)]
        [string] $ServerUrl,

        [Parameter(Mandatory, ParameterSetName = 'KeyCredential')]
        [Parameter(Mandatory, ParameterSetName = 'TokenOAuth')]
        [System.Management.Automation.PSCredential] $Credential,

        # [Parameter(Mandatory, ParameterSetName = 'UsernamePassword')]
        # [ValidateNotNullOrEmpty()]
        # [string] $Username,

        # [Parameter(Mandatory, ParameterSetName = 'UsernamePassword')]
        # [ValidateNotNullOrEmpty()]
        # [Security.SecureString] $SecurePassword,

        [Parameter(Mandatory, ParameterSetName = 'TokenIntegrated')]
        [Parameter(Mandatory, ParameterSetName = 'TokenOAuth')]
        [string] $ClientId,

        [Parameter(ParameterSetName = 'TokenIntegrated')]
        [Parameter(ParameterSetName = 'TokenOAuth')]
        [hashtable] $Scope = @{'any' = $null },

        [Parameter(ParameterSetName = 'TokenIntegrated')]
        [Parameter(ParameterSetName = 'TokenOAuth')]
        [string] $State,

        [Parameter(ParameterSetName = 'TokenIntegrated')]
        [Parameter(ParameterSetName = 'TokenOAuth')]
        [switch] $IncludeAllScope,

        [Parameter()]
        [switch] $PassThru
    )

    # add prefix if just server url was provided
    if ( $ServerUrl -notlike 'https://*') {
        $ServerUrl = 'https://{0}' -f $ServerUrl
    }

    $newSession = [TppSession] @{
        ServerUrl = $ServerUrl
    }

    Write-Verbose ('Parameter set: {0}' -f $PSCmdlet.ParameterSetName)

    # including this check here instead of parameter sets as it would have created too many imo
    if ( $PSBoundParameters.ContainsKey('Scope') -and $IncludeAllScope ) {
        throw 'Scope and IncludeAllScope cannot both be provided'
    }

    if ( $PSCmdlet.ShouldProcess($ServerUrl, 'New session') ) {
        Switch -Wildcard ($PsCmdlet.ParameterSetName)	{

            "Key*" {

                if ( $PsCmdlet.ParameterSetName -eq 'KeyCredential' ) {
                    $newSession.Connect($Credential)
                } else {
                    # integrated
                    $newSession.Connect($null)
                }

            }

            'Token*' {
                if ( $PSBoundParameters.ContainsKey('Scope') ) {
                    $scopeHash = $Scope
                } else {
                    $scopeHash = @{
                        'agent'         = 'delete'
                        'certificate'   = 'delete,discover,manage,revoke'
                        'configuration' = 'delete,manage'
                        'restricted'    = 'delete,manage'
                        'security'      = 'delete,manage'
                        'ssh'           = 'approve,delete,discover,manage'
                        'statistics'    = $null
                    }
                }
                $scopeString = @(
                    $scopeHash.GetEnumerator() | ForEach-Object {
                        if ($_.Value) {
                            '{0}:{1}' -f $_.Key, $_.Value
                        } else {
                            $_.Key
                        }
                    }
                ) -join ';'
                if ( $PsCmdlet.ParameterSetName -eq 'TokenOAuth' ) {
                    $newSession.Connect($Credential, $ClientId, $scopeString, $State)
                } else {
                    # integrated
                    $newSession.Connect($null, $ClientId, $scopeString, $State)
                }

            }
        }

        if ( $PassThru ) {
            $newSession
        } else {
            $Script:TppSession = $newSession
        }
    }
}
