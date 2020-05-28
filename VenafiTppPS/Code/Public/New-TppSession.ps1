<#
.SYNOPSIS
Create a new Venafi TPP session

.DESCRIPTION
Authenticates a user and creates a new session with which future calls can be made.
Key based username/password and windows integrated are supported as well as token-based integrated and oauth.
Note, key-based authentication will be fully deprecated in v20.4.

.PARAMETER ServerUrl
URL for the Venafi server.

.PARAMETER Credential
Username and password used for key and token-based authentication.  Not required for integrated authentication.

.PARAMETER ClientId
Applcation Id configured in Venafi for token-based authentication

.PARAMETER Scope
Hashtable with Scopes and privilege restrictions.
The key is the scope and the value is one or more privilege restrictions separated by commas.

.PARAMETER IncludeAllScope
Include all scopes and privilege restrictions when authenticating via token, instead of selecting individual ones.

.PARAMETER State
A session state, redirect URL, or random string to prevent Cross-Site Request Forgery (CSRF) attacks

.PARAMETER PassThru
Optionally, send the session object to the pipeline instead of script scope.

.OUTPUTS
TppSession, if PassThru is provided

.EXAMPLE
New-TppSession -ServerUrl venafitpp.mycompany.com
Create key-based session using Windows Integrated authentication

.EXAMPLE
New-TppSession -ServerUrl venafitpp.mycompany.com -Credential $cred
Create key-based session using Windows Integrated authentication

.EXAMPLE
New-TppSession -ServerUrl venafitpp.mycompany.com -ClientId MyApp
Connect using token-based Windows Integrated authentication with the 'any' scope

.EXAMPLE
New-TppSession -ServerUrl venafitpp.mycompany.com -ClientId MyApp -Scope @{'certificate'='manage'}
Create token-based session using Windows Integrated authentication with a certain scope and privilege restriction

.EXAMPLE
New-TppSession -ServerUrl venafitpp.mycompany.com -ClientId MyApp -IncludeAllScope -Credential $cred
Create token-based session using oauth authentication for all scopes and privilege restrictions

.EXAMPLE
$sess = New-TppSession -ServerUrl venafitpp.mycompany.com -Credential $cred -PassThru
Create session and return the session object instead of setting to script scope variable

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppSession/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppSession.ps1

.LINK
https://docs.venafi.com/Docs/19.4/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Authorize.php?tocpath=Topics%20by%20Guide%7CDeveloper%27s%20Guide%7CWeb%20SDK%20reference%7CAuthentication%20programming%20interfaces%7C_____1

.LINK
https://docs.venafi.com/Docs/19.4/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Authorize-Integrated.php?tocpath=Topics%20by%20Guide%7CDeveloper%27s%20Guide%7CWeb%20SDK%20reference%7CAuthentication%20programming%20interfaces%7C_____3

.LINK
https://docs.venafi.com/Docs/20.1SDK/TopNav/Content/SDK/AuthSDK/r-SDKa-POST-Authorize-Integrated.php?tocpath=Auth%20SDK%20reference%20for%20token%20management%7C_____10

.LINK
https://docs.venafi.com/Docs/20.1SDK/TopNav/Content/SDK/AuthSDK/r-SDKa-POST-AuthorizeOAuth.php?tocpath=Auth%20SDK%20reference%20for%20token%20management%7C_____11

#>
function New-TppSession {

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'KeyIntegrated')]

    param(
        [Parameter(Mandatory)]
        [string] $ServerUrl,

        [Parameter(Mandatory, ParameterSetName = 'KeyCredential')]
        [Parameter(Mandatory, ParameterSetName = 'TokenOAuth')]
        [System.Management.Automation.PSCredential] $Credential,

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

    $ServerUrl = $ServerUrl.Trim('/')
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

                Write-Warning 'Key-based authentication will be deprecated in release 20.4 in favor of token-based'

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
