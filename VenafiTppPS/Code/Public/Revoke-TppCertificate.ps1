<#
.SYNOPSIS
Revoke a certificate

.DESCRIPTION
Requests that an existing certificate be revoked. The caller must have Write permissions to the Certificate object. Either the CertificateDN or the Thumbprint must be provided

.PARAMETER CertificateDN
Full path to a certificate in TPP

.PARAMETER Thumbprint
The thumbprint (hash) of the certificate to revoke

.PARAMETER Reason
The reason for revocation of the certificate:

    0: None
    1: User key compromised
    2: CA key compromised
    3: User changed affiliation
    4: Certificate superseded
    5: Original use no longer valid

.PARAMETER Comments
The details about why the certificate is being revoked

.PARAMETER Disable
The setting to manage the Certificate object upon revocation.  Default is to allow a new certificate to be enrolled to replace the revoked one.  Provide this switch to mark the certificate as disabled and no new certificate will be enrolled to replace the revoked one.

.PARAMETER Wait
Wait for the requested revocation to be complete

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
CertificateDN (alias: DN) or Thumbprint

.OUTPUTS
PSCustomObject with the following properties:
    CertificateDN/Thumbprint - Whichever value was provided
    Requested - Indicates whether revocation has been requested.  Only returned if the revocation was requested, but not completed yet.
    Revoked - Indicates whether revocation has been completed.  Only returned once complete.
    Error - Indicates any errors that occurred. Not returned when successful

.EXAMPLE
Invoke-TppCertificateRevocation -CertificateDN '\VED\Policy\My folder\app.mycompany.com' -Reason 2
Revoke the certificate with a reason of the CA being compromised

.EXAMPLE
Invoke-TppCertificateRevocation -CertificateDN '\VED\Policy\My folder\app.mycompany.com' -Reason 2 -Wait
Revoke the certificate with a reason of the CA being compromised and wait for it to complete

.EXAMPLE
Invoke-TppCertificateRevocation -Thumbprint 'a909502dd82ae41433e6f83886b00d4277a32a7b'
Revoke the certificate with a reason of the CA being compromised and wait for it to complete

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Revoke-TppCertificate/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Revoke-TppCertificate.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-revoke.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7C_____15

#>
function Revoke-TppCertificate {
    [CmdletBinding(DefaultParameterSetName = 'CertificateDN')]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'CertificateDN')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [alias("DN")]
        [String[]] $CertificateDN,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Thumbprint')]
        [ValidateNotNullOrEmpty()]
        [String[]] $Thumbprint,

        [Parameter()]
        [ValidateRange(0, 5)]
        [Int] $Reason,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String] $Comments,

        [Parameter()]
        [Switch] $Disable,

        [Parameter()]
        [Switch] $Wait,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'Certificates/Revoke'
            Body       = ''
        }
    }

    process {

        Write-Verbose $PsCmdlet.ParameterSetName

        Switch ($PsCmdlet.ParameterSetName)	{
            'CertificateDN' {
                write-verbose "Revoking $CertificateDN..."
                $certValueToRevoke = @{
                    CertificateDN = $CertificateDN
                }
            }

            'Thumbprint' {
                write-verbose "Revoking $Thumbprint..."
                $certValueToRevoke = @{
                    Thumbprint = $Thumbprint
                }
            }
        }

        $params.Body = $certValueToRevoke

        if ( $Reason ) {
            $params.Body += @{
                Reason = $Reason
            }
        }

        if ( $Comments ) {
            $params.Body += @{
                Comments = $Comments
            }
        }

        if ( $Disable ) {
            $params.Body += @{
                Disable = $true
            }
        }

        $response = Invoke-TppRestMethod @params

        if ( $Wait ) {
            while (-not $response.Revoked) {
                Start-Sleep -Seconds 1
                $response = Invoke-TppRestMethod @params
            }
        }

        $response | Add-Member $certValueToRevoke

        $response
    }
}
