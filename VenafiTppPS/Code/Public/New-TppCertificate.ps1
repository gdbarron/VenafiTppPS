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

.PARAMETER CertificateType
Type of certificate to be created.
No value provided will default to X509 Server Certificate.
Valid values include 'Code Signing', 'Device', 'Server' (same as default), and 'User'.

.PARAMETER CertificateAuthorityDN
The Distinguished Name (DN) of the Trust Protection Platform Certificate Authority Template object for enrolling the certificate. If the value is missing, use the default CADN

.PARAMETER ManagementType
The level of management that Trust Protection Platform applies to the certificate:
- Enrollment: Default. Issue a new certificate, renewed certificate, or key generation request to a CA for enrollment. Do not automatically provision the certificate.
- Provisioning:  Issue a new certificate, renewed certificate, or key generation request to a CA for enrollment. Automatically install or provision the certificate.
- Monitoring:  Allow Trust Protection Platform to monitor the certificate for expiration and renewal.
- Unassigned: Certificates are neither enrolled or monitored by Trust Protection Platform.

.PARAMETER SubjectAltName
A list of Subject Alternate Names.
The value must be 1 or more hashtables with the SAN type and value.
Acceptable SAN types are OtherName, Email, DNS, URI, and IPAddress.
You can provide more than 1 of the same SAN type with multiple hashtables.

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
Create certificate by name

.EXAMPLE
New-TppCertificate -Path '\ved\policy\folder' -CommonName 'mycert.com' -CertificateAuthorityDN '\ved\policy\CA Templates\my template' -PassThru
Create certificate using common name.  Return the created object.

.EXAMPLE
New-TppCertificate -Path '\ved\policy\folder' -Name 'mycert.com' -CertificateAuthorityDN '\ved\policy\CA Templates\my template' -SubjectAltName @{'Email'='me@x.com'},@{'IPAddress'='1.2.3.4'}
Create certificate including subject alternate names

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppCertificate/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppCertificate.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-request.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7CPOST%20Certificates%2FRequest%7C_____0

#>
function New-TppCertificate {

    [CmdletBinding(DefaultParameterSetName = 'ByName', SupportsShouldProcess)]

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
        [Alias('PolicyDN')]
        [String] $Path,

        [Parameter(Mandatory, ParameterSetName = 'ByName', ValueFromPipeline)]
        [String] $Name,

        [Parameter(ParameterSetName = 'ByName')]
        [Parameter(Mandatory, ParameterSetName = 'BySubject')]
        [Alias('Subject')]
        [String] $CommonName,

        [Parameter()]
        [ValidateSet('Code Signing', 'Device', 'Server', 'User')]
        [String] $CertificateType,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('CertificateAuthorityDN')]
        [Alias('CADN')]
        [String] $CertificateAuthorityPath,

        [Parameter()]
        [TppManagementType] $ManagementType,

        [Parameter()]
        [Hashtable[]] $SubjectAltName,

        [Parameter()]
        [switch] $PassThru,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {

        $TppSession.Validate()

        if ( $PSBoundParameters.ContainsKey('SubjectAltName') ) {

            $errors = $SubjectAltName | ForEach-Object {
                $_.GetEnumerator() | ForEach-Object {

                    $thisKey = $_.Key
                    $thisValue = $_.Value

                    switch ($thisKey) {
                        'OtherName' {
                            # no validaton
                        }

                        'Email' {
                            try {
                                $null = [mailaddress]$thisValue
                            } catch {
                                ('''{0}'' is not a valid email' -f $thisValue)
                            }
                        }

                        'DNS' {
                            # no validaton
                        }

                        'URI' {
                            # no validaton
                        }

                        'IPAddress' {
                            try {
                                $null = [ipaddress]$thisValue
                            } catch {
                                ('''{0}'' is not a valid IP Address' -f $thisValue)
                            }
                        }

                        Default {
                            # invalid type name provided
                            ('''{0}'' is not a valid SAN type.  Valid values include OtherName, Email, DNS, URI, and IPAddress.' -f $thisKey)
                        }
                    }
                }
            }

            if ( $errors ) {
                throw $errors
            }
        }

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'certificates/request'
            Body       = @{
                PolicyDN             = $Path
                Origin               = 'VenafiTppPS'
                CASpecificAttributes = @{
                    'Name'  = 'Origin'
                    'Value' = 'VenafiTppPS'
                }
            }
        }

        if ( $PSBoundParameters.ContainsKey('CertificateAuthorityPath') ) {
            $params.Body.Add('CADN', $CertificateAuthorityPath)
        }

        if ( $PSBoundParameters.ContainsKey('CommonName') ) {
            $params.Body.Add('Subject', $CommonName)
        }

        if ( $PSBoundParameters.ContainsKey('ManagementType') ) {
            $params.Body.Add('ManagementType', [enum]::GetName([TppManagementType], $ManagementType))
        }

        if ( $PSBoundParameters.ContainsKey('SubjectAltName') ) {
            $newSan = @($SubjectAltName | ForEach-Object {
                    $_.GetEnumerator() | ForEach-Object {
                        @{
                            'TypeName' = $_.Key
                            'Name'     = $_.Value
                        }
                    }
                }
            )
            $params.Body.Add('SubjectAltNames', $newSan)
        }

    }

    process {

        $params.Body.ObjectName = $Name

        if ( $PSCmdlet.ShouldProcess($Path, 'Create new certificate') ) {

            try {
                $response = Invoke-TppRestMethod @params
                Write-Verbose ($response | Out-String)

                if ( $PassThru ) {
                    $returnObject = @{
                        Name     = $Name
                        TypeName = 'X509 Server Certificate'
                        Path     = $response.CertificateDN
                        Guid     = $response.Guid.Trim('{}')
                    }

                    if ( $PSBoundParameters.CertificateType ) {
                        $returnObject.TypeName = $CertificateType
                    }

                    [TppObject] $returnObject
                }
            } catch {
                Write-Error $_
                continue
            }
        }
    }
}
