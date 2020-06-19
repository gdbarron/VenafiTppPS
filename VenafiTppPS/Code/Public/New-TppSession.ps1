<#
.SYNOPSIS
Create a new Venafi TPP session

.DESCRIPTION
Authenticate a user and create a new session with which future calls can be made.
Key based username/password and windows integrated are supported as well as token-based integrated, oauth, and certificate.
Note, key-based authentication will be fully deprecated in v20.4.

.PARAMETER Server
Server or url to access vedsdk, venafi.company.com or https://venafi.company.com.
If AuthServer is not provided, this will be used to access vedauth as well for token-based authentication.
If just the server name is provided, https:// will be appended.

.PARAMETER Credential
Username and password used for key and token-based authentication.  Not required for integrated authentication.

.PARAMETER Certificate
Certificate for token-based authentication

.PARAMETER ClientId
Applcation Id configured in Venafi for token-based authentication

.PARAMETER Scope
Hashtable with Scopes and privilege restrictions.
The key is the scope and the value is one or more privilege restrictions separated by commas.
For a privilege restriction of none or read, use a value of $null.
Scopes include Agent, Certificate, Code Signing, Configuration, Restricted, Security, SSH, and statistics.
See https://docs.venafi.com/Docs/20.1/TopNav/Content/SDK/AuthSDK/r-SDKa-OAuthScopePrivilegeMapping.php?tocpath=Topics%20by%20Guide%7CDeveloper%27s%20Guide%7CAuth%20SDK%20reference%20for%20token%20management%7C_____6 for more info.

.PARAMETER State
A session state, redirect URL, or random string to prevent Cross-Site Request Forgery (CSRF) attacks

.PARAMETER TppToken
Token object obtained from New-TppToken

.PARAMETER AccessToken
Access token retrieved from TPP

.PARAMETER AuthServer
Optional server or url to access vedauth, venafi.company.com or https://venafi.company.com.
If AuthServer is not provided, the value provided for Server will be used.
If just the server name is provided, https:// will be appended.

.PARAMETER PassThru
Optionally, send the session object to the pipeline instead of script scope.

.OUTPUTS
TppSession, if PassThru is provided

.EXAMPLE
New-TppSession -Server venafitpp.mycompany.com
Create key-based session using Windows Integrated authentication

.EXAMPLE
New-TppSession -Server venafitpp.mycompany.com -Credential $cred
Create key-based session using Windows Integrated authentication

.EXAMPLE
New-TppSession -Server venafitpp.mycompany.com -ClientId MyApp
Connect using token-based Windows Integrated authentication with the 'any' scope

.EXAMPLE
New-TppSession -Server venafitpp.mycompany.com -ClientId MyApp -Scope @{'certificate'='manage'}
Create token-based session using Windows Integrated authentication with a certain scope and privilege restriction

.EXAMPLE
New-TppSession -Server venafitpp.mycompany.com -AuthServer tppauth.mycompany.com -ClientId MyApp -Credential $cred
Create token-based session using oauth authentication where the vedauth and vedsdk are hosted on different servers

.EXAMPLE
$sess = New-TppSession -Server venafitpp.mycompany.com -Credential $cred -PassThru
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

.LINK
https://docs.venafi.com/Docs/20.1/TopNav/Content/SDK/AuthSDK/r-SDKa-POST-AuthorizeCertificate.php?tocpath=Topics%20by%20Guide%7CDeveloper%27s%20Guide%7CAuth%20SDK%20reference%20for%20token%20management%7C_____9
#>
function New-TppSession {

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'KeyIntegrated')]

    param(
        [Parameter(Mandatory, ParameterSetName = 'KeyCredential')]
        [Parameter(Mandatory, ParameterSetName = 'KeyIntegrated')]
        [Parameter(Mandatory, ParameterSetName = 'TokenOAuth')]
        [Parameter(Mandatory, ParameterSetName = 'TokenIntegrated')]
        [Parameter(Mandatory, ParameterSetName = 'TokenCertificate')]
        [Parameter(Mandatory, ParameterSetName = 'AccessToken')]
        [Parameter(ParameterSetName = 'TppToken')]
        [ValidateScript( {
                if ( $_ -match '^(https?:\/\/)?(((?!-))(xn--|_{1,1})?[a-z0-9-]{0,61}[a-z0-9]{1,1}\.)*(xn--)?([a-z0-9][a-z0-9\-]{0,60}|[a-z0-9-]{1,30}\.[a-z]{2,})$' ) {
                    $true
                } else {
                    throw 'Please enter a valid server, https://venafi.company.com or venafi.company.com'
                }
            }
        )]
        [Alias('ServerUrl')]
        [string] $Server,

        [Parameter(Mandatory, ParameterSetName = 'KeyCredential')]
        [Parameter(Mandatory, ParameterSetName = 'TokenOAuth')]
        [System.Management.Automation.PSCredential] $Credential,

        [Parameter(Mandatory, ParameterSetName = 'TokenIntegrated')]
        [Parameter(Mandatory, ParameterSetName = 'TokenOAuth')]
        [string] $ClientId,

        [Parameter(Mandatory, ParameterSetName = 'TokenIntegrated')]
        [Parameter(Mandatory, ParameterSetName = 'TokenOAuth')]
        [hashtable] $Scope,

        [Parameter(ParameterSetName = 'TokenIntegrated')]
        [Parameter(ParameterSetName = 'TokenOAuth')]
        [string] $State,

        [Parameter(Mandatory, ParameterSetName = 'TppToken')]
        [ValidateScript( {
                if ( $_.AccessToken -and $_.AuthUrl -and $_.ClientId  ) {
                    $true
                } else {
                    throw 'Object provided for TppToken is not valid.  Please request a new token with New-TppToken.'
                }
            }
        )]
        [pscustomobject] $TppToken,

        [Parameter(Mandatory, ParameterSetName = 'AccessToken')]
        [string] $AccessToken,

        [Parameter(Mandatory, ParameterSetName = 'TokenCertificate')]
        [X509Certificate] $Certificate,

        [Parameter(ParameterSetName = 'TokenOAuth')]
        [Parameter(ParameterSetName = 'TokenIntegrated')]
        [Parameter(ParameterSetName = 'AccessToken')]
        [ValidateScript( {
                if ( $_ -match '^(https?:\/\/)?(((?!-))(xn--|_{1,1})?[a-z0-9-]{0,61}[a-z0-9]{1,1}\.)*(xn--)?([a-z0-9][a-z0-9\-]{0,60}|[a-z0-9-]{1,30}\.[a-z]{2,})$' ) {
                    $true
                } else {
                    throw 'Please enter a valid server, https://venafi.company.com or venafi.company.com'
                }
            }
        )]
        [string] $AuthServer,

        [Parameter()]
        [switch] $PassThru
    )

    $isVerbose = if ($PSBoundParameters.Verbose -eq $true) { $true } else { $false }

    $ServerUrl = $Server
    # add prefix if just server url was provided
    if ( $Server -notlike 'https://*') {
        $ServerUrl = 'https://{0}' -f $ServerUrl
    }

    $newSession = [TppSession] @{
        ServerUrl = $ServerUrl
    }

    Write-Verbose ('Parameter set: {0}' -f $PSCmdlet.ParameterSetName)

    if ( $PSCmdlet.ShouldProcess($Server, 'New session') ) {
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
                $params = @{
                    AuthServer = $Server
                    ClientId   = $ClientId
                    Scope      = $Scope
                }

                # in case the auth server isn't the same as vedsdk...
                if ( $AuthServer ) {
                    $params.AuthServer = $AuthServer
                }

                if ($Credential) {
                    $params.Credential = $Credential
                }

                if ($Certificate) {
                    $params.Certificate = $Certificate
                }

                if ($State) {
                    $params.State = $State
                }

                $token = New-TppToken @params -Verbose:$isVerbose
                $newSession.Token = $token
                $newSession.Expires = $token.Expires
            }

            'TppToken' {
                $newSession.Token = $TppToken
                $newSession.Expires = $TppToken.Expires

                if ( -not $Server ) {
                    $newSession.ServerUrl = $TppToken.AuthUrl
                }
            }

            'AccessToken' {
                $newSession.Token = [PSCustomObject]@{
                    AccessToken = $AccessToken
                }
            }

            Default {
                throw ('Unknown parameter set {0}' -f $PSCmdlet.ParameterSetName)
            }
        }

        # will fail if user is on an older version
        # this isn't required so bypass on failure
        $newSession.Version = (Get-TppVersion -TppSession $newSession -ErrorAction SilentlyContinue)

        $allFields = (Get-TppCustomField -TppSession $newSession -Class 'X509 Certificate').Items
        $deviceFields = (Get-TppCustomField -TppSession $newSession -Class 'Device').Items
        $allFields += $deviceFields | Where-Object { $_.Guid -notin $allFields.Guid }
        $newSession.CustomField = $allFields

        if ( $PassThru ) {
            $newSession
        } else {
            $Script:TppSession = $newSession
        }
    }
}
