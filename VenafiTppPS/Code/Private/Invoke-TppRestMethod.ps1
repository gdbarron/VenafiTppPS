<#
.SYNOPSIS
Generic REST call for Venafi

.DESCRIPTION

.PARAMETER TppSession

.PARAMETER Method

.PARAMETER UriLeaf

.PARAMETER Header

.PARAMETER Body

.INPUTS

.OUTPUTS

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

        [Parameter(Mandatory)]
        [ValidateSet("Get", "Post", "Patch", "Put", "Delete")]
        [String] $Method,

        [Parameter()]
        [String] $UriRoot = 'vedsdk',

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $UriLeaf,

        [Parameter()]
        [hashtable] $Header,

        [Parameter()]
        [Hashtable] $Body,

        [Parameter()]
        [switch] $UseWebRequest
    )

    # ensure this api is supported for the current version
    # $supportedVersion = $TppSupportedVersion.Where{$_.UriLeaf -eq $UriLeaf}
    # if ( $supportedVersion ) {
    #     if ( $TppSession.Version -lt ([Version] $supportedVersion.Version) ) {
    #         throw ("{0} is not a supported api call for this version (v{1}) of TPP" -f $UriLeaf, $TppSession.Version)
    #     }
    # }

    if ( $PsCmdlet.ParameterSetName -eq 'Session' ) {

        $ServerUrl = $TppSession.ServerUrl

        if ( $TppSession.Key ) {
            $hdr = @{
                "X-Venafi-Api-Key" = $TppSession.Key.ApiKey
            }
        } else {
            # token
            $hdr = @{
                'Authorization' = 'Bearer {0}' -f $TppSession.Token.AccessToken
            }
        }
    }

    $uri = '{0}/{1}/{2}' -f $ServerUrl, $UriRoot, $UriLeaf

    if ( $Header ) {
        $hdr += $Header
    }

    $params = @{
        Method      = $Method
        Uri         = $uri
        Headers     = $hdr
        ContentType = 'application/json'
    }

    if ( $Body.Count -gt 0 ) {
        $restBody = $Body
        if ( $Method -ne 'Get' ) {
            $restBody = ConvertTo-Json $Body -depth 5
        }
        $params.Body = $restBody
    }

    if ( $UseDefaultCredentials ) {
        $params.Add('UseDefaultCredentials', $true)
    }

    Write-Verbose ($params | ConvertTo-Json | Out-String)

    if ( $PSBoundParameters.ContainsKey('UseWebRequest') ) {
        Write-Debug "Using Invoke-WebRequest"
        try {
            Invoke-WebRequest @params
        } catch {
            $_.Exception.Response
        }
    } else {
        Write-Debug "Using Invoke-RestMethod"
        try {
            Invoke-RestMethod @params
        } catch {
            # try with trailing slash as some GETs return a 307/401 without it
            if ( $Method -eq 'Get' -and (-not $uri.EndsWith('/')) ) {

                Write-Verbose 'GET call failed, trying again with a trailing slash'

                $params.Uri += '/'

                try {
                    Invoke-RestMethod @params
                    Write-Warning ('GET call requires a trailing slash, please create an issue at https://github.com/gdbarron/VenafiTppPS/issues and mention api endpoint {0}' -f ('{1}/{2}' -f $UriRoot, $UriLeaf))
                } catch {
                    throw ('"{0} {1}: {2}' -f $_.Exception.Response.StatusCode.value__, $_.Exception.Response.StatusDescription, $_ | Out-String )
                }
            } else {
                throw ('"{0} {1}: {2}' -f $_.Exception.Response.StatusCode.value__, $_.Exception.Response.StatusDescription, $_ | Out-String )
            }
        }
    }
}

