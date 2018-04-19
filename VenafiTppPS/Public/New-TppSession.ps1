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
PSCustomObject

.EXAMPLE

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppSession/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppSession.ps1

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
            $Username = $Credential.username
            $Password = $Credential.GetNetworkCredential().password
        }
		
        "UsernamePassword" {
            # we have username, just need password
            $Password = ConvertTo-InsecureString $SecurePassword

            # build a credential object to attached to the session object
            $sessionCredential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)
        }
		
    }

    $newSession = [TppSession] @{
        ServerUrl  = $ServerUrl
        Credential = $sessionCredential
    }

    $newSession.Connect()

    $Script:TppSession = $newSession

    if ( $PassThru ) {
        $newSession
    }
}
