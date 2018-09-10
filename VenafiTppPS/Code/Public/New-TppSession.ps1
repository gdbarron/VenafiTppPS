<#
.SYNOPSIS
Create a new Venafi TPP session

.DESCRIPTION
Authenticates a user via a username and password against a configured Trust
Protection Platform identity provider (e.g. Active Directory, LDAP, or Local). After
the user is authenticated, Trust Protection Platform returns an API key allowing
access to all other REST calls.

.PARAMETER ServerUrl
URL for the Venafi server.

.PARAMETER Credential
PSCredential object utilizing the same credentials as used for the web front-end

.PARAMETER Username
Username to authenticate to ServerUrl with

.PARAMETER SecurePassword
SecureString password to authenticate to ServerUrl with

.PARAMETER PassThru
Optionally, send the session object to the pipeline.

.OUTPUTS
PSCustomObject with the following properties:
    APIKey - Guid representing the current session with TPP
    Credential - Credential object provided to authenticate against TPP server.  This will be used to re-authenticate once the connection has expired.
    ServerUrl - URL to the TPP server
    ValidateUtil - DateTime when the session will expire.
    CustomField - PSCustomObject containing custom fields defined on this server.  Properties include:
        AllowedValues
        Classes
        ConfigAttribute
        DN
        DefaultValues
        Guid
        Label
        Mandatory
        Name
        Policyable
        RenderHidden
        RenderReadOnly
        Single
        Type


.EXAMPLE
New-TppSession -ServerUrl https://venafitpp.mycompany.com -Credential $cred
Connect to the TPP server and store the session object in the script variable

.EXAMPLE
$sess = New-TppSession -ServerUrl https://venafitpp.mycompany.com -Credential $cred -PassThru
Connect to the TPP server and return the session object

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppSession/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppSession.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Authorize.php?TocPath=REST%20API%20reference|Authentication%20and%20API%20key%20programming%20interfaces|_____1

#>
function New-TppSession {
    [OutputType('TppSession')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $ServerUrl,

        [Parameter(Mandatory, ParameterSetName = 'Credential')]
        [System.Management.Automation.PSCredential] $Credential,

        [Parameter(Mandatory, ParameterSetName = 'UsernamePassword')]
        [ValidateNotNullOrEmpty()]
        [string] $Username,

        [Parameter(Mandatory, ParameterSetName = 'UsernamePassword')]
        [ValidateNotNullOrEmpty()]
        [Security.SecureString] $SecurePassword,

        [Parameter()]
        [switch] $PassThru
    )

    Switch ($PsCmdlet.ParameterSetName)	{

        "Credential" {
            $sessionCredential = $Credential
            # $Username = $Credential.username
            # $Password = $Credential.GetNetworkCredential().password
        }

        "UsernamePassword" {
            # we have username, just need password
            # $Password = ConvertTo-InsecureString $SecurePassword

            # build a credential object to attached to the session object
            $sessionCredential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)
        }

    }

    $newSession = [TppSession] @{
        ServerUrl  = $ServerUrl
        Credential = $sessionCredential
    }

    $newSession.Connect()

    if ( $PassThru ) {
        $newSession
    } else {
        $Script:TppSession = $newSession
    }
}
