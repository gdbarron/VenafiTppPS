function Test-VenafiSession {
    <#
	.SYNOPSIS 
	Validate session object
	
	.DESCRIPTION
	Verifies that an APIKey is still valid. If the session has expired due to a timeout, the session will be reestablished and a new key retrieved.  The new session will replace the old script scope session object.

	.PARAMETER VenafiSession
	Session object created from New-VenafiSession.  Defaults to current session object.

	.OUTPUTS
	none

	.EXAMPLE
    Test-VenafiSession
    Validate current session set as script variable

	#>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $VenafiSession = $script:VenafiSession
    )

    begin {

        if ( -not ($VenafiSession.PSobject.Properties.name -contains "APIKey") ) {
            throw "Valid VenafiSession was not provided.  Please authenticate with New-VenafiSession."
        }
        
        If ($VenafiSession.ValidUntil -lt (Get-Date).ToUniversalTime()) {
            # we need to re-authenticate
            Write-Verbose "Session timeout, re-authenticating"
            $newSession = New-VenafiSession -ServerUrl $VenafiSession.ServerUrl -Credential $VenafiSession.Credential -PassThrough
            $VenafiSession = $newSession
        }
    }

    process {

        # $params = @{
        #     VenafiSession = $VenafiSession
        #     Method        = 'Get'
        #     UriLeaf       = 'authorize/checkvalid'
        # }
        # $null = Invoke-VenafiRestMethod @params

        $VenafiSession
    }
}
