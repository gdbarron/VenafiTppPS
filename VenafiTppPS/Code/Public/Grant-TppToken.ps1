<#
.SYNOPSIS
Get an API Access and Refresh Token from TPP for use in New-TPPSession (or other scripts/utilities that take such a token)

.DESCRIPTION
Accepts username/password credential, scope, and ClientId to get a token grant from specified TPP server.

.PARAMETER ServerUrl
URL for the Venafi server.

.PARAMETER Credential
Username / password credential used to request API Token

.PARAMETER ClientId
Applcation Id configured in Venafi for token-based authentication

.PARAMETER Scope
Hashtable with Scopes and privilege restrictions.
The key is the scope and the value is one or more privilege restrictions separated by commas.

.EXAMPLE
Grant-TPPToken -ServerUrl 'https://mytppserver.example.com' -Scope @{ Certificate = "manage,discover"; Config = "manage" } -ClientId 'MyAppId' -Credential $credential

#>
function Grant-TppToken {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory)]
        [string] $ServerUrl,
        
        [Parameter(Mandatory)]
        [string] $ClientId,
        
        [Parameter(Mandatory)]
        [hashtable] $Scope = @{'any' = $null },
        
        [Parameter(Mandatory, ParameterSetName = 'OAuth')]
        [System.Management.Automation.PSCredential] $Credential,
        
        [Parameter(ParameterSetName = 'OAuth')]
        [string] $State
        
        #[Parameter(Mandatory, ParameterSetName = 'Certificate')]
        #[System.Management.Automation.PSCredential] $Credential,
    )

    $ServerUrl = $ServerUrl.Trim('/')
    # The authorize endpoints for token auth are not under /vedsdk, remove it if it was added by mistake
    $ServerUrl = $ServerUrl.Trim('/vedsdk')
    # add prefix if just server url was provided
    if ( $ServerUrl -notlike 'https://*') {
        $ServerUrl = 'https://{0}' -f $ServerUrl
    }
    
    $scopeString = @(
                    $scope.GetEnumerator() | ForEach-Object {
                        if ($_.Value) {
                            '{0}:{1}' -f $_.Key, $_.Value
                        } else {
                            $_.Key
                        }
                    }
                ) -join ';'

    $params = @{
        Method    = 'Post'
        ServerUrl = $ServerUrl
        UriRoot   = 'vedauth'
        Body      = @{
            client_id = $ClientId
            scope = $scopeString
        }
    }

    if ( $Credential ) {
        $params.UriLeaf = 'authorize/oauth'
        $params.Body.username = $Credential.UserName
        $params.Body.password = $Credential.GetNetworkCredential().Password
    } else {
        $params.UriLeaf = 'authorize/integrated'
        $params.UseDefaultCredentials = $true
    }

    if ( $State ) {
        $params.Body.state = $State
    }

    $response = Invoke-TppRestMethod @params

    Write-Verbose ($response | Out-String)

    $Token = [PSCustomObject]@{
        AccessToken  = $response.access_token
        RefreshToken = $response.refresh_token
        Scope        = $response.scope
        Identity     = $response.identity
        TokenType    = $response.token_type
        ClientId     = $ClientId
        Expires = ([datetime] '1970-01-01 00:00:00').AddSeconds($response.Expires)
    }

    return $Token
}

<#
## Refresh Token

 Write-Verbose ("RefreshUntil: {0}, Current: {1}" -f $this.Token.RefreshUntil, (Get-Date).ToUniversalTime())
                if ( $this.Token.RefreshUntil -and $this.Token.RefreshUntil -lt (Get-Date) ) {
                    throw "The refresh token has expired.  You must create a new session with New-TppSession."
                }

                if ( $this.Token.RefreshToken ) {

                    $params = @{
                        Method    = 'Post'
                        ServerUrl = $this.ServerUrl
                        UriRoot   = 'vedauth'
                        UriLeaf   = 'authorize/token'
                        Body      = @{
                            refresh_token = $this.Token.RefreshToken
                            client_id     = $this.Token.ClientId
                        }
                    }
                    $response = Invoke-TppRestMethod @params

                    Write-Verbose ($response | Out-String)

                    $this.Expires = ([datetime] '1970-01-01 00:00:00').AddSeconds($response.expires)
                    $this.Token = [PSCustomObject]@{
                        AccessToken  = $response.access_token
                        RefreshToken = $response.refresh_token
                        Scope        = $response.scope
                        Identity     = $this.Token.Identity
                        ClientId     = $this.Token.ClientId
                        TokenType    = $response.token_type
                        RefreshUntil = ([datetime] '1970-01-01 00:00:00').AddSeconds($response.refresh_until)
                    }

                } else {
                    throw "The token has expired and no refresh token exists.  You must create a new session with New-TppSession."
                }
#>