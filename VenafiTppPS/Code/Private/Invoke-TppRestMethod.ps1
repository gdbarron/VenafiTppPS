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
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Session')]
        [ValidateNotNullOrEmpty()]
        [TppSession] $TppSession,

        [Parameter(Mandatory, ParameterSetName = 'URL')]
        [ValidateNotNullOrEmpty()]
        [String] $ServerUrl,

        [Parameter(Mandatory)]
        [ValidateSet("Get", "Post", "Patch", "Put", "Delete")]
        [String] $Method,

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

    Switch ($PsCmdlet.ParameterSetName)	{
        "Session" {
            $ServerUrl = $TppSession.ServerUrl
            $hdr = @{
                "X-Venafi-Api-Key" = $TppSession.ApiKey
            }
        }
    }

    $uri = Join-UriPath @($ServerUrl, "vedsdk", $UriLeaf)

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

    Write-Verbose ($params | ConvertTo-Json | out-string)

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

