<#
.SYNOPSIS
Get basic or detailed certificate information

.DESCRIPTION
Get certificate info based on a variety of attributes.
Additional details can be had by passing the guid.

.PARAMETER Path
Starting path to search from

.PARAMETER Recursive
Search recursively starting from the search path.

.PARAMETER Limit
Limit how many items are returned.  Default is 0 for no limit.
It is definitely recommended to filter on another property when searching with no limit.

.PARAMETER Country
Find certificates by Country attribute of Subject DN.
Example - US

.PARAMETER CommonName
Find certificates by Common name attribute of Subject DN.
Example - test.venafi.com

.PARAMETER Issuer
Find certificates by issuer. Use the CN ,O, L, S, and C values from the certificate request.
Surround the complete Issuer DN within double quotes (").
If a value DN already contains double quotes, enclose the string in a second set of double quotes.
Example - CN=Example Root CA, O=Venafi,Inc., L=Salt Lake City, S=Utah, C=US

.PARAMETER KeyAlgorithm
Find certificates by algorithm for the public key.
Example - 'RSA','DSA'

.PARAMETER KeySize
Find certificates by public key size.
Example - 1024,2048

.PARAMETER KeySizeGreater
Find certificates with a key size greater than the specified value.
Example - 1024

.PARAMETER KeySizeLess
Find certificates with a key size less than the specified value.
Example: 1025

.PARAMETER Locale
Find certificates by Locality/City attribute of Subject Distinguished Name (DN).
Example - London

.PARAMETER Organization
Find certificates by Organization attribute of Subject DN.
Example - 'Venafi Inc.','BankABC'

.PARAMETER OrganizationUnit
Find certificates by Organization Unit (OU).
Example - 'Quality Assurance'

.PARAMETER State
Find certificates by State/Province attribute of Subject DN.
Example - 'New York', 'Georgia'

.PARAMETER SanDns
Find certificates by Subject Alternate Name (SAN) Distinguished Name Server (DNS).
Example - sso.venafi.com

.PARAMETER SanEmail
Find certificates by SAN Email RFC822.
Example - first.last@venafi.com

.PARAMETER SanIP
Find certificates by SAN IP Address.
Example - '10.20.30.40'

.PARAMETER SanUpn
Find certificates by SAN User Principal Name (UPN) or OtherName.
Example - My.Email@venafi.com

.PARAMETER SanUri
Find certificates by SAN Uniform Resource Identifier (URI).
Example - https://login.venafi.com

.PARAMETER SerialNumber
Find certificates by Serial number.
Example - 13279B74000000000053

.PARAMETER SignatureAlgorithm
Find certificates by the algorithm used to sign the certificate (e.g. SHA1RSA).
Example - 'sha1RSA','md5RSA','sha256RSA'

.PARAMETER Thumbprint
Find certificates by one or more SHA-1 thumbprints.
Example - 71E8672798C03842735293EF49425EF06C7FA8AB&

.PARAMETER ValidFrom
Find certificates by the date of issue.
Example - [DateTime] '2017-10-24'

.PARAMETER ValidTo
Find certificates by expiration date.
Example - [DateTime] '2017-10-24'

.PARAMETER ValidToGreater
Find certificates that expire after a certain date. Specify YYYY-MM-DD or the ISO 8601 format, for example YYYY-MM-DDTHH:MM:SS.mmmmmmmZ.
Example - [DateTime] '2017-10-24'

.PARAMETER ValidToLess
Find certificates that expire before a certain date. Specify YYYY-MM-DD or the ISO 8601 format, for example YYYY-MM-DDTHH:MM:SS.mmmmmmmZ.
Example - [DateTime] '2017-10-24'

.PARAMETER Guid
Guid representing a unique certificate in Venafi.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Guid

.OUTPUTS
ByPath and NoPath parameter sets returns a PSCustomObject with the following properties:
    CreatedOn
    DN
    Guid
    Name
    ParentDn
    SchemaClass
    _links

Guid returns a PSCustomObject with the following properties:
    CertificateAuthorityDN
    CertificateDetails
    Consumers
    Contact
    CreatedOn
    CustomFields
    Description
    DN
    Guid
    ManagementType
    Name
    ParentDn
    ProcessingDetails
    RenewalDetails
    SchemaClass
    ValidationDetails

.EXAMPLE
Get-TppCertificateDetail -ValidToLess ([DateTime] "2018-01-01")
Find all certificates expiring before a certain date

.EXAMPLE
Get-TppCertificateDetail -ValidToLess ([DateTime] "2018-01-01") -Limit 5
Find 5 certificates expiring before a certain date

.EXAMPLE
Get-TppCertificateDetail -Path '\VED\Policy\My Policy'
Find all certificates in a specific path

.EXAMPLE
Get-TppCertificateDetail -Path '\VED\Policy\My Policy' -Recursive
Find all certificates in a specific path and all subfolders

.EXAMPLE
Get-TppCertificateDetail -ValidToLess ([DateTime] "2018-01-01") -Limit 5 | Get-TppCertificateDetail
Get detailed certificate info on the first 5 certificates expiring before a certain date

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppCertificateDetail/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppCertificateDetail.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Certificates.php?TocPath=REST%20API%20reference|Certificates%20module%20programming%20interfaces|_____3

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Certificates-guid.php?TocPath=REST%20API%20reference|Certificates%20module%20programming%20interfaces|_____5

.LINK
https://msdn.microsoft.com/en-us/library/system.web.httputility(v=vs.110).aspx

#>
function Get-TppCertificateDetail {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ByPath')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [String] $Path,

        [Parameter(ParameterSetName = 'ByPath')]
        [Switch] $Recursive,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [int] $Limit = 0,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [Alias('C')]
        [String] $Country,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [Alias('CN')]
        [String] $CommonName,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [String] $Issuer,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [String[]] $KeyAlgorithm,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [Int[]] $KeySize,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [Int] $KeySizeGreater,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [Int] $KeySizeLess,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [Alias('L')]
        [String[]] $Locale,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [Alias('O')]
        [String[]] $Organization,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [Alias('OU')]
        [String[]] $OrganizationUnit,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [Alias('S')]
        [String[]] $State,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [String] $SanDns,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [String] $SanEmail,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [String] $SanIP,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [String] $SanUpn,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [String] $SanUri,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [String] $SerialNumber,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [String] $SignatureAlgorithm,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [String] $Thumbprint,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [DateTime] $ValidFrom,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [DateTime] $ValidTo,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [DateTime] $ValidToGreater,

        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(ParameterSetName = 'NoPath')]
        [DateTime] $ValidToLess,

        [Parameter(Mandatory, ParameterSetName = 'Full', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String[]] $Guid,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        Switch ($PsCmdlet.ParameterSetName)	{
            {$_ -in 'NoPath', 'ByPath'} {
                $params = @{
                    TppSession = $TppSession
                    Method     = 'Get'
                    UriLeaf    = 'certificates'
                    Body       = @{
                        'Limit' = $Limit
                    }
                }

                if ( $Path ) {
                    if ( $Recursive ) {
                        $params.Body += @{
                            ParentDnRecursive = $Path
                        }
                    } else {
                        $params.Body += @{
                            ParentDn = $Path
                        }
                    }
                }

                if ( $Country ) {
                    $params.Body += @{
                        C = $Country
                    }
                }

                if ( $CommonName ) {
                    $params.Body += @{
                        CN = $CommonName
                    }
                }

                if ( $Issuer ) {
                    $params.Body += @{
                        Issuer = $Issuer
                    }
                }

                if ( $KeyAlgorithm ) {
                    $params.Body += @{
                        KeyAlgorithm = $KeyAlgorithm -join ','
                    }
                }

                if ( $KeySize ) {
                    $params.Body += @{
                        KeySize = $KeySize -join ','
                    }
                }

                if ( $KeySizeGreater ) {
                    $params.Body += @{
                        KeySizeGreater = $KeySizeGreater
                    }
                }

                if ( $KeySizeLess ) {
                    $params.Body += @{
                        KeySizeLess = $KeySizeLess
                    }
                }

                if ( $Locale ) {
                    $params.Body += @{
                        L = $Locale -join ','
                    }
                }

                if ( $Organization ) {
                    $params.Body += @{
                        O = $Organization -join ','
                    }
                }

                if ( $OrganizationUnit ) {
                    $params.Body += @{
                        OU = $OrganizationUnit -join ','
                    }
                }

                if ( $State ) {
                    $params.Body += @{
                        S = $State -join ','
                    }
                }

                if ( $SanDns ) {
                    $params.Body += @{
                        'SAN-DNS' = $SanDns
                    }
                }

                if ( $SanEmail ) {
                    $params.Body += @{
                        'SAN-Email' = $SanEmail
                    }
                }

                if ( $SanIP ) {
                    $params.Body += @{
                        'SAN-IP' = $SanIP
                    }
                }

                if ( $SanUpn ) {
                    $params.Body += @{
                        'SAN-UPN' = $SanUpn
                    }
                }

                if ( $SanUri ) {
                    $params.Body += @{
                        'SAN-URI' = $SanUri
                    }
                }

                if ( $SerialNumber ) {
                    $params.Body += @{
                        Serial = $SerialNumber
                    }
                }

                if ( $SignatureAlgorithm ) {
                    $params.Body += @{
                        SignatureAlgorithm = $SignatureAlgorithm -join ','
                    }
                }

                if ( $Thumbprint ) {
                    $params.Body += @{
                        Thumbprint = $Thumbprint
                    }
                }

                if ( $ValidFrom ) {
                    $params.Body += @{
                        ValidFrom = $ValidFrom.ToUniversalTime().ToString( "yyyy-MM-ddTHH:mm:ss.fffffffZ" )
                    }
                }

                if ( $ValidTo ) {
                    $params.Body += @{
                        ValidTo = $ValidTo.ToUniversalTime().ToString( "yyyy-MM-ddTHH:mm:ss.fffffffZ" )
                    }
                }

                if ( $ValidToGreater ) {
                    $params.Body += @{
                        ValidToGreater = $ValidToGreater.ToUniversalTime().ToString( "yyyy-MM-ddTHH:mm:ss.fffffffZ" )
                    }
                }

                if ( $ValidToLess ) {
                    $params.Body += @{
                        ValidToLess = $ValidToLess.ToUniversalTime().ToString( "yyyy-MM-ddTHH:mm:ss.fffffffZ" )
                    }
                }
            }

            'Full' {
                $params = @{
                    TppSession = $TppSession
                    Method     = 'Get'
                    UriLeaf    = 'placeholder'
                }
            }
        }

    }

    process {

        Switch ($PsCmdlet.ParameterSetName)	{
            {$_ -in 'NoPath', 'ByPath'} {

                $response = Invoke-TppRestMethod @params

                if ( $response ) {
                    $response.Certificates
                }
            }

            'Full' {
                $GUID.ForEach{
                    $params.UriLeaf = [System.Web.HttpUtility]::HtmlEncode("certificates/$_")
                    Invoke-TppRestMethod @params
                }
            }
        }

    }
}
