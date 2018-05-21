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

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Path (alias: DN)

.OUTPUTS
PSCustomObject with the following properties:
DN - Certificate path
Success - A value of true indicates that the renewal request was successfully submitted and
granted.
Error - Indicates any errors that occurred. Not returned when successful

.EXAMPLE
Invoke-TppCertificateRenew -Path '\VED\Policy\My folder\app.mycompany.com'

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Invoke-TppCertificateRenewal/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Invoke-TppCertificateRenewal.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-renew.php?TocPath=REST%20API%20reference|Certificates%20module%20programming%20interfaces|_____9

#>
function Invoke-TppCertificateRenewal {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [String] $DN,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()
    }

    process {

        write-verbose "Renewing $DN..."

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'certificates/renew'
            Body       = @{
                CertificateDN = $DN
            }
        }

        $response = Invoke-TppRestMethod @params
        $response | Add-Member @{
            'DN' = $DN
        }
        $response
    }
}
