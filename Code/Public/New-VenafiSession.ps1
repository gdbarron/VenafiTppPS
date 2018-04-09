function New-VenafiSession {
    <#
	.SYNOPSIS 
	Create a new Venafi session
	
	.DESCRIPTION
	Authenticates a user via a username and password against a configured Trust
	Protection Platform identity provider (e.g. Active Directory, LDAP, or Local). After
	the user is authenticated, Trust Protection Platform returns an API key allowing
	access to all other REST calls.

	.PARAMETER ServerUrl
	URL for the Venafi server.

    .PARAMETER Credential

    .PARAMETER Username

    .PARAMETER SecurePassword

    .PARAMETER PassThrough

	.OUTPUTS

	.EXAMPLE
	
	#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $ServerUrl,

        [Parameter(Mandatory, ParameterSetName = 'Credential')]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter(Mandatory, ParameterSetName = 'UsernamePassword')]
        [ValidateNotNullOrEmpty()]
        [string]$Username,

        [Parameter(Mandatory, ParameterSetName = 'UsernamePassword')]
        [ValidateNotNullOrEmpty()]
        [Security.SecureString]$SecurePassword,

        [Parameter()]
        [switch]$PassThrough
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

    # if ( $Username -like '*\*' ) {
    #     $username = $username.split('\')[1]
    # }


    $body = @{
        Username = $Username
        Password = $Password
    }

    $newSession = Invoke-VenafiRestMethod -Method Post -ServerUrl $ServerUrl -UriLeaf "authorize" -Body $body
    $newSession | Add-Member @{
        ServerUrl  = $ServerUrl
        # add the credential to the session so we can reauthorize in case of timeout
        Credential = $sessionCredential
    }

    $script:VenafiSession = $newSession

    if ( $PassThrough ) {
        $newSession
    }
}
