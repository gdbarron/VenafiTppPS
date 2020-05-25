<#
.SYNOPSIS
Create a new Venafi TPP session

.DESCRIPTION
Authenticates a user and creates a new session with which future calls can be made.
Windows Integrated authentication is the default.

.PARAMETER ServerUrl
URL for the Venafi server.

.PARAMETER Credential
PSCredential object utilizing the same credentials as used for the web front-end

.PARAMETER Username
Username to authenticate to ServerUrl with

.PARAMETER SecurePassword
SecureString password to authenticate to ServerUrl with

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

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'WindowsIntegrated')]

    param(
        [Parameter(Mandatory)]
        [string] $ServerUrl,

        [Parameter(Mandatory, ParameterSetName = 'Credential')]
        [Parameter(Mandatory, ParameterSetName = 'OAuth')]
        [System.Management.Automation.PSCredential] $Credential,

        # [Parameter(Mandatory, ParameterSetName = 'UsernamePassword')]
        # [ValidateNotNullOrEmpty()]
        # [string] $Username,

        # [Parameter(Mandatory, ParameterSetName = 'UsernamePassword')]
        # [ValidateNotNullOrEmpty()]
        # [Security.SecureString] $SecurePassword,

        [Parameter(Mandatory, ParameterSetName = 'OAuth')]
        [string] $ClientId,

        [Parameter(ParameterSetName = 'OAuth')]
        [hashtable] $Scope,

        [Parameter(ParameterSetName = 'OAuth')]
        [string] $State,

        [Parameter()]
        [switch] $PassThru
    )

    # add prefix if just server name was provided
    if ( $ServerUrl -notlike 'https://*') {
        $ServerUrl = 'https://{0}' -f $ServerUrl
    }

    Switch ($PsCmdlet.ParameterSetName)	{

        "Credential" {
            $newSession = [TppSession] @{
                ServerUrl = $ServerUrl
            }

            if ( $PsCmdlet.ParameterSetName -ne 'WindowsIntegrated' ) {
                $newSession.Credential = $Credential
            }

            if ( $PSCmdlet.ShouldProcess($ServerUrl, 'New session') ) {

                $newSession.Connect()

                if ( $PassThru ) {
                    $newSession
                } else {
                    $Script:TppSession = $newSession
                }
            }
        }

        'OAuth' {

            $params = @{
                Method    = 'Post'
                ServerUrl = $ServerUrl
                UriRoot   = 'vedauth'
                UriLeaf   = 'authorize/oauth'
                Body      = @{
                    client_id = $ClientId
                    username  = $Credential.username
                    password  = $Credential.GetNetworkCredential().password
                }
            }

            if ( $Scope ) {
                $params.Body.scope = $Scope
            }

            if ( $State ) {
                $params.Body.state = $State
            }

            $response = Invoke-TppRestMethod @params
            $response
            # $this.APIKey = $response.ApiKey
            # $this.ValidUntil = $response.ValidUntil

            # # get custom fields
            # if ( -not $this.CustomField ) {
            #     $allFields = (Get-TppCustomField -TppSession $this -Class 'X509 Certificate').Items
            #     $deviceFields = (Get-TppCustomField -TppSession $this -Class 'Device').Items
            #     $allFields += $deviceFields | Where-Object { $_.Guid -notin $allFields.Guid }
            #     $this.CustomField = $allFields
            # }

        }

        # "UsernamePassword" {
        #     # build a credential object to attached to the session object
        #     $sessionCredential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)
        # }

    }

}
