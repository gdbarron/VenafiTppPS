<#
.SYNOPSIS 
Enrolls or provisions a new certificate

.DESCRIPTION
Enrolls or provisions a new certificate

.PARAMETER PolicyDN
The folder DN for the new certificate. If the value is missing, use the system default

.PARAMETER Name
Either the Name or Subject parameter is required. Both the Name and Subject parameters can appear in the same Certificates/Request call. If the Subject parameter has a value, The friendly name for the certificate object in Trust Protection Platform. If the value is missing, the Name is the Subject DN

.PARAMETER Subject
Either the Name or Subject parameter is required. Both parameters are allowed in same request. The Common Name field for the certificate Subject Distinguished Name (DN). Specify a value when a centrally generated CSR is being requested

.PARAMETER CertificateAuthorityDN
The Distinguished Name (DN) of the Trust Protection Platform Certificate Authority Template object for enrolling the certificate. If the value is missing, use the default CADN

.PARAMETER ManagementType
The level of management that Trust Protection Platform applies to the certificate:

Enrollment: Default. Issue a new certificate, renewed certificate, or key generation request to a CA for enrollment. Do not automatically provision the certificate.
Provisioning:  Issue a new certificate, renewed certificate, or key generation request to a CA for enrollment. Automatically install or provision the certificate.
Monitoring:  Allow Trust Protection Platform to monitor the certificate for expiration and renewal.
Unassigned: Certificates are neither enrolled or monitored by Trust Protection Platform.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
None

.OUTPUTS
PSCustomObject with the following properties:
    CertificateDN - The Trust Protection Platform DN of the newly created certificate object, if it was successfully created. Otherwise, this value is absent.
    Guid - A Guid that uniquely identifies the certificate.
    Error - The reason why Certificates/Request could no create the certificate. Otherwise, this value is not present.

.EXAMPLE

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppCertificate/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppCertificate.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-request.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7CPOST%20Certificates%2FRequest%7C_____0

#>
function New-TppCertificate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [String] $PolicyDN,

        [Parameter()]
        [String] $Name,

        [Parameter()]
        [String] $Subject,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [String] $CertificateAuthorityDN,

        [Parameter()]
        [ValidateSet('Enrollment', 'Provisioning', 'Monitoring', 'Unassigned')]
        [String] $ManagementType,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        if ( -not $Name -and -not $Subject ) {
            throw "Either Name or Subject is required"
        }

        $TppSession.Validate()
    }

    process {

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'certificates/request'
            Body       = @{
                PolicyDN = $PolicyDN
                CADN     = $CertificateAuthorityDN
            }
        }

        if ( $Name ) {
            $params.Body += @{
                ObjectName = $Name
            }
        }

        if ( $Subject ) {
            $params.Body += @{
                Subject = $Subject
            }
        }

        if ( $ManagementType ) {
            $params.Body += @{
                ManagementType = $ManagementType
            }
        }

        Invoke-TppRestMethod @params
    }
}
