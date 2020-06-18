<#
.SYNOPSIS
Revoke a token

.DESCRIPTION
Revoke a token and invalidate the refresh token if provided/available.
This could be an access token retrieved from this module or from other means.

.PARAMETER AuthServer
Server name or URL for the vedauth service

.PARAMETER AccessToken
Access token to be revoked

.PARAMETER TppToken
Token object obtained from New-TppToken

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
TppToken

.OUTPUTS
Version

.EXAMPLE
Revoke-TppToken
Revoke token stored in session variable from New-TppSession

.EXAMPLE
Revoke-TppToken -AuthServer venafi.company.com -AccessToken x7xc8h4387dkgheysk
Revoke a token obtained from TPP, not necessarily via VenafiTppPS

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Revoke-TppToken/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Revoke-TppToken.ps1

.LINK
https://docs.venafi.com/Docs/20.1SDK/TopNav/Content/SDK/AuthSDK/r-SDKa-GET-Revoke-Token.php?tocpath=Auth%20SDK%20reference%20for%20token%20management%7C_____13

#>
function Revoke-TppToken {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'Session')]

    param (
        [Parameter(Mandatory, ParameterSetName = 'AccessToken')]
        [ValidateScript( {
                if ( $_ -match '^(https?:\/\/)?(((?!-))(xn--|_{1,1})?[a-z0-9-]{0,61}[a-z0-9]{1,1}\.)*(xn--)?([a-z0-9][a-z0-9\-]{0,60}|[a-z0-9-]{1,30}\.[a-z]{2,})$' ) {
                    $true
                } else {
                    throw 'Please enter a valid server, https://venafi.company.com or venafi.company.com'
                }
            }
        )]
        [string] $AuthServer,

        [Parameter(Mandatory, ParameterSetName = 'AccessToken')]
        [string] $AccessToken,

        [Parameter(Mandatory, ParameterSetName = 'TppToken', ValueFromPipeline)]
        [pscustomobject] $TppToken,

        [Parameter(ParameterSetName = 'Session')]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $params = @{
            Method  = 'Get'
            UriRoot = 'vedauth'
            UriLeaf = 'Revoke/Token'
        }
    }

    process {

        Write-Verbose ('Parameter set: {0}' -f $PSCmdlet.ParameterSetName)

        switch ($PsCmdlet.ParameterSetName) {
            'Session' {
                $params.TppSession = $TppSession
            }

            'AccessToken' {
                $AuthUrl = $AuthServer
                # add prefix if just server was provided
                if ( $AuthServer -notlike 'https://*') {
                    $AuthUrl = 'https://{0}' -f $AuthUrl
                }

                $params.ServerUrl = $AuthUrl
                $params.Header = @{'Authorization' = 'Bearer {0}' -f $AccessToken }
            }

            'TppToken' {
                if ( -not $TppToken.AuthUrl -or -not $TppToken.AccessToken ) {
                    throw 'Not a valid TppToken'
                }

                $params.ServerUrl = $TppToken.AuthUrl
                $params.Header = @{'Authorization' = 'Bearer {0}' -f $TppToken.AccessToken }
            }

            Default {
                throw ('Unknown parameter set {0}' -f $PSCmdlet.ParameterSetName)
            }
        }

        Write-Verbose ($params | Out-String)

        if ( $PSCmdlet.ShouldProcess($TppToken.AccessToken, 'Revoke token') ) {
            Invoke-TppRestMethod @params
        }
    }
}
