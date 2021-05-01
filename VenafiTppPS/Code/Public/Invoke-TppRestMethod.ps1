<#
.SYNOPSIS
Generic REST API call

.DESCRIPTION
Generic REST API call

.PARAMETER TppSession
TppSession object from New-TppSession.
For typical calls to New-TppSession, the object will be stored as a session object named $TppSession.
Otherwise, if -PassThru was used, provide the resulting object.

.PARAMETER Method
API method, either get, post, patch, put or delete.

.PARAMETER UriLeaf
Path to the api endpoint excluding the base url and site, eg. certificates/import

.PARAMETER Header
Optional additional headers.  The authorization header will be included automatically.

.PARAMETER Body
Optional body to pass to the endpoint

.INPUTS
None

.OUTPUTS
PSCustomObject

.EXAMPLE

#>
function Invoke-TppRestMethod {
    [CmdletBinding(DefaultParameterSetName = 'Session')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Session')]
        [ValidateNotNullOrEmpty()]
        [TppSession] $TppSession,

        [Parameter(Mandatory, ParameterSetName = 'URL')]
        [ValidateNotNullOrEmpty()]
        [String] $ServerUrl,

        [Parameter(ParameterSetName = 'URL')]
        [switch] $UseDefaultCredentials,

        [Parameter()]
        [ValidateSet("Get", "Post", "Patch", "Put", "Delete")]
        [String] $Method = 'Get',

        [Parameter()]
        [String] $UriRoot = 'vedsdk',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String] $UriLeaf,

        [Parameter(Mandatory, ParameterSetName = 'CloudKey')]
        [guid] $CloudKey,

        [Parameter()]
        [string] $CloudUriLeaf,

        [Parameter()]
        [hashtable] $Header,

        [Parameter()]
        [Hashtable] $Body
    )

    # ensure this api is supported for the current version
    # $supportedVersion = $TppSupportedVersion.Where{$_.UriLeaf -eq $UriLeaf}
    # if ( $supportedVersion ) {
    #     if ( $TppSession.Version -lt ([Version] $supportedVersion.Version) ) {
    #         throw ("{0} is not a supported api call for this version (v{1}) of TPP" -f $UriLeaf, $TppSession.Version)
    #     }
    # }

    switch ($PSCmdLet.ParameterSetName) {
        'Session' {
            $ServerUrl = $TppSession.ServerUrl
            $uri = '{0}/{1}/{2}' -f $ServerUrl, $UriRoot, $UriLeaf

            if ( $TppSession.Key ) {
                if ( $ServerUrl -eq $script:CloudUrl ) {
                    $hdr = @{
                        "tppl-api-key" = $TppSession.Key
                    }
                    $uri = '{0}/v1/{1}' -f $ServerUrl, $CloudUriLeaf
                } else {
                    $hdr = @{
                        "X-Venafi-Api-Key" = $TppSession.Key.ApiKey
                    }
                }
            } else {
                # token
                $hdr = @{
                    'Authorization' = 'Bearer {0}' -f $TppSession.Token.AccessToken
                }
            }

        }

        'URL' {
            $uri = '{0}/{1}/{2}' -f $ServerUrl, $UriRoot, $UriLeaf
        }

        'CloudKey' {
            $ServerUrl = $script:CloudUrl
            $hdr = @{
                "tppl-api-key" = $CloudKey
            }
            $uri = '{0}/v1/{2}' -f $ServerUrl, $CloudUriLeaf
        }

        Default {}
    }


    if ( $Header ) {
        $hdr += $Header
    }

    $params = @{
        Method      = $Method
        Uri         = $uri
        Headers     = $hdr
        ContentType = 'application/json'
    }

    if ( $Body ) {
        $restBody = $Body
        if ( $Method -ne 'Get' ) {
            $restBody = ConvertTo-Json $Body -Depth 5
        }
        $params.Body = $restBody
    }

    if ( $UseDefaultCredentials ) {
        $params.Add('UseDefaultCredentials', $true)
    }

    $params | Write-VerboseWithSecret

    try {
        $verboseOutput = $($response = Invoke-RestMethod @params) 4>&1
        $verboseOutput.Message | Write-VerboseWithSecret
    } catch {

        # if trying with a slash below doesn't work, we want to provide the original error
        $originalError = $_

        Write-Verbose ('Response status code {0}' -f $originalError.Exception.Response.StatusCode.value__)

        switch ($originalError.Exception.Response.StatusCode.value__) {

            '409' {
                # item already exists.  some functions use this for a 'force' option, eg. Set-TppPermission
                $response = $originalError.Exception.Response
            }

            { $_ -in '307', '401' } {
                # try with trailing slash as some GETs return a 307/401 without it
                if ( -not $uri.EndsWith('/') ) {

                    Write-Verbose "$Method call failed, trying again with a trailing slash"

                    $params.Uri += '/'

                    try {
                        $verboseOutput = $($response = Invoke-RestMethod @params) 4>&1
                        $verboseOutput.Message | Write-VerboseWithSecret
                        Write-Warning ('{0} call requires a trailing slash, please create an issue at https://github.com/gdbarron/VenafiTppPS/issues and mention api endpoint {1}' -f $Method, ('{1}/{2}' -f $UriRoot, $UriLeaf))
                    } catch {
                        # this didn't work, provide details from pre slash call
                        throw $originalError
                    }
                }
            }

            Default {
                throw ('"{0} {1}: {2}' -f $originalError.Exception.Response.StatusCode.value__, $originalError.Exception.Response.StatusDescription, $originalError | Out-String )
            }
        }
    }

    $response
}