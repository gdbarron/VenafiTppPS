function Test-TppSession {
    <#
	.SYNOPSIS 
	Validate session object
	
	.DESCRIPTION
	Verifies that an APIKey is still valid. If the session has expired due to a timeout, the session will be reestablished and a new key retrieved.  The new session will replace the old script scope session object.

	.PARAMETER VenafiSession
	Session object created from New-TppSession.  Defaults to current session object.

	.OUTPUTS
	none

	.EXAMPLE
    Test-TppSession
    Validate current session set as script variable

	#>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $VenafiSession = $script:VenafiSession
    )

    begin {

        if ( -not ($VenafiSession.PSobject.Properties.name -contains "APIKey") ) {
            throw "Valid VenafiSession was not provided.  Please authenticate with New-TppSession."
        }
        
        If ($VenafiSession.ValidUntil -lt (Get-Date).ToUniversalTime()) {
            # we need to re-authenticate
            Write-Verbose "Session timeout, re-authenticating"
            $newSession = New-TppSession -ServerUrl $VenafiSession.ServerUrl -Credential $VenafiSession.Credential -PassThrough
            $VenafiSession = $newSession
        }
    }

    process {

        # $params = @{
        #     VenafiSession = $VenafiSession
        #     Method        = 'Get'
        #     UriLeaf       = 'authorize/checkvalid'
        # }
        # $null = Invoke-TppRestMethod @params

        $VenafiSession
    }
}
