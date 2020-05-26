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
        # [ValidateNotNullOrEmpty()]
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
        [String] $Header,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
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

        # this should never occur as the module inits the variable
        # but if TppSession ever gets wiped, this will catch it
        # if ( -not $TppSession ) {
        #     throw "You must first connect to the TPP server with New-TppSession"
        # }

        # $TppSession.Validate()

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

    $uri = Join-UriPath @($ServerUrl, $UriRoot, $UriLeaf)

    if ( $Header ) {
        $hdr += $Header
    }

    if ( $Body ) {
        $restBody = $Body
        if ( $Method -ne 'Get' ) {
            $restBody = ConvertTo-Json $Body -depth 5
        }
    }

    $params = @{
        Method      = $Method
        Uri         = $uri
        Headers     = $hdr
        Body        = $restBody
        ContentType = 'application/json'
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
        Invoke-RestMethod @params
    }
}

