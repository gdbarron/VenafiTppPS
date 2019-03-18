<#
.SYNOPSIS
Enrolls or provisions a new certificate

.DESCRIPTION
Enrolls or provisions a new certificate

.PARAMETER Path
The folder DN path for the new certificate. If the value is missing, use the system default

.PARAMETER Name
Name of the certifcate.  If not provided, the name will be the same as the subject.

.PARAMETER CommonName
Subject Common Name.  If Name isn't provided, CommonName will be used.

.PARAMETER CertificateAuthorityDN
The Distinguished Name (DN) of the Trust Protection Platform Certificate Authority Template object for enrolling the certificate. If the value is missing, use the default CADN

.PARAMETER ManagementType
The level of management that Trust Protection Platform applies to the certificate:
- Enrollment: Default. Issue a new certificate, renewed certificate, or key generation request to a CA for enrollment. Do not automatically provision the certificate.
- Provisioning:  Issue a new certificate, renewed certificate, or key generation request to a CA for enrollment. Automatically install or provision the certificate.
- Monitoring:  Allow Trust Protection Platform to monitor the certificate for expiration and renewal.
- Unassigned: Certificates are neither enrolled or monitored by Trust Protection Platform.

.PARAMETER PassThru
Return a TppObject representing the newly created certificate.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
None

.OUTPUTS
TppObject, if PassThru is provided

.EXAMPLE
New-TppCertificate -Path '\ved\policy\folder' -Name 'mycert.com' -CertificateAuthorityDN '\ved\policy\CA Templates\my template'

Create certifcate by name
.EXAMPLE
New-TppCertificate -Path '\ved\policy\folder' -CommonName 'mycert.com' -CertificateAuthorityDN '\ved\policy\CA Templates\my template' -PassThru

Create certificate using common name.  Return the created object.
.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppCertificate/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppCertificate.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-request.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7CPOST%20Certificates%2FRequest%7C_____0

#>
function New-TppCertificate {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    [OutputType( [TppObject] )]
    param (

        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [String] $Name,

        [Parameter(ParameterSetName = 'ByName')]
        [Parameter(Mandatory, ParameterSetName = 'BySubject')]
        [Alias('Subject')]
        [String] $CommonName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('PolicyDN')]
        [String] $Path,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('CertificateAuthorityDN')]
        [String] $CertificateAuthorityPath,

        [Parameter()]
        [ValidateSet('Enrollment', 'Provisioning', 'Monitoring', 'Unassigned')]
        [String] $ManagementType,

        [Parameter()]
        [switch] $PassThru,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {

        $TppSession.Validate()
    }

    process {

        $params = @{
            TppSession    = $TppSession
            Method        = 'Post'
            UriLeaf       = 'certificates/request'
            Body          = @{
                PolicyDN = $Path
                CADN     = $CertificateAuthorityPath
            }
            UseWebRequest = $true
        }

        if ( $Name ) {
            $params.Body.Add('ObjectName', $Name)
        }

        if ( $CommonName ) {
            $params.Body.Add('Subject', $CommonName)
        }

        if ( $ManagementType ) {
            $params.Body.Add('ManagementType', $ManagementType)
        }

        $response = Invoke-TppRestMethod @params
        Write-Verbose ($response|Out-String)

        switch ($response.StatusCode) {

            '200' {
                if ( $PassThru ) {
                    $contentObject = $response.Content | ConvertFrom-Json
                    $info = $contentObject.CertificateDN | ConvertTo-TppGuid -IncludeType
                    [TppObject]@{
                        Path     = $contentObject.CertificateDN
                        Name     = Split-path $contentObject.CertificateDN -Leaf
                        Guid     = $info.Guid
                        TypeName = $info.TypeName
                    }
                }
            }

            default {
                throw $response.StatusDescription
            }
        }
    }
}
