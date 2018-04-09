function Invoke-TppCertificateRenew {
    <#
	.SYNOPSIS 
	Renew a certificate
	
	.DESCRIPTION
	Requests renewal for an existing certificate. This call marks a certificate for
	immediate renewal. The certificate must not be in error, already being processed, or
	configured for Monitoring in order for it be renewable. Caller must have Write access
	to the certificate object being renewed.
	
	.PARAMETER Path
	Full path to a certificate in TPP

	.PARAMETER VenafiSession
    Session object created from New-VenafiSession method.  The value defaults to the script session object $VenafiSession.

    .OUTPUTS
    PSCustomObject with the following properties:
    DN - Certificate path
    Success - A value of true indicates that the renewal request was successfully submitted and
    granted.
    Error - Indicates any errors that occurred. Not returned when successful

	.EXAMPLE
    Invoke-TppCertificateRenew -Path '\VED\Policy\My folder\app.mycompany.com'

	#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [alias("DN")]
        [String[]] $Path,

        $VenafiSession = $Script:VenafiSession
    )

    begin {
        $VenafiSession = $VenafiSession | Test-TppSession
    }

    process {

        write-verbose "Renewing $Path..."

        $params = @{
            VenafiSession = $VenafiSession
            Method        = 'Post'
            UriLeaf       = 'certificates/renew'
            Body          = @{
                CertificateDN = $Path
            }
        }
        $response = Invoke-TppRestMethod @params
        $response | Add-Member @{'DN' = $Path}
        $response
    }
	
}
