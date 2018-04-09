function Invoke-VenafiRestMethod {
    <#
	.SYNOPSIS 
	Generic REST call for Venafi
	
	.DESCRIPTION
	
	.PARAMETER VenafiSession

	.PARAMETER Method

	.PARAMETER UriLeaf

	.PARAMETER Header

	.PARAMETER Body

	.INPUTS

	.OUTPUTS

	.EXAMPLE

	#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [alias("sess")]
        $VenafiSession,

        [Parameter(Mandatory)]
        [ValidateSet("Get", "Post", "Patch", "Put", "Delete")] 
        [String]$Method,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$UriLeaf,

        [Parameter()]
        [String]$Header,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$Body
    )

    # always verify authorization first
    $testAuth = Test-VenafiSession -VenafiSession $VenafiSession -PassThrough

    if ($testAuth.Valid) {
        if ( $null -ne $testAuth.NewSession ) {
            Write-Verbose "Test-VenafiSession came back with a new session"

            # ensure we set the new session to the local variable
            $VenafiSession = $testAuth.NewSession
        }
    } else {
        throw ($testAuth.Error)
    }

    $ServerUrl = $VenafiSession.ServerUrl
    $hdr = @{ "X-Venafi-Api-Key" = $VenafiSession.ApiKey }

    if ( $FullUri ) {
        $uri = $FullUri
    } else {
        $uri = Join-UriPath @($ServerUrl, "vedsdk", $UriLeaf)
    }
    Write-Verbose ("URI: {0}" -f $uri)
		
    if ( -not $Header ) {
        $hdr += $Header
    }
    Write-Verbose ("Adding to header {0}" -f $Header | out-string)
		
    if ( $Body ) {
        $restBody = $Body
        if ( $Method -ne 'Get' ) {
            $restBody = ConvertTo-Json $Body -depth 5 
        }
    }
    Write-Verbose ("Body: {0}" -f $restBody | Out-String)

    $params = @{
        Method      = $Method
        Uri         = $uri
        Headers     = $hdr
        Body        = $restBody
        ContentType = 'application/json'
    }
    Invoke-RestMethod @params
}

