<#
.SYNOPSIS
Get basic or full details about certificates

.DESCRIPTION
Get details about a certificate based on search criteria.  See the examples for a few of the available options; the SDK provides a full list.  See Certificates attribute filters, https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-Certificates-search-attribute.php, and Certificates status filters, https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-Certificates-search-status.php.
Additional details can be had by passing the guid.

.PARAMETER Filter
Hashtable providing 1 or more key/value pairs with search criteria.

.PARAMETER Limit
Limit how many items are returned.  Default is 0 for no limit.
It is definitely recommended you provide a Query when searching with no limit.

.PARAMETER Guid
Guid representing a unique certificate in Venafi.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Guid

.OUTPUTS
Query returns a PSCustomObject with the following properties:
    Certificates
    DataRange
    TotalCount

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
Get-TppCertificateDetail -Filter @{'ValidToLess'='2018-04-30T00:00:00.0000000Z'}
Find all certificates expiring before a certain date

.EXAMPLE
Get-TppCertificateDetail -Filter @{'ParentDn'='\VED\Policy\My folder'}
Find all certificates in the specified folder

.EXAMPLE
Get-TppCertificateDetail -Filter @{'ParentDnRecursive'='\VED\Policy\My folder'}
Find all certificates in the specified folder and subfolders

.EXAMPLE
Get-TppCertificateDetail -Filter @{'ParentDnRecursive'='\VED\Policy\My folder'} -limit 20
Find all certificates in the specified folder and subfolders, but limit the results to 20

.EXAMPLE
$certs | Get-TppCertificateDetail
Get detailed certificate info after performing basic query

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
        [Parameter(ParameterSetName = 'Basic')]
        [ValidateNotNullOrEmpty()]
        [Alias('Query')]
        [Hashtable] $Filter,

        [Parameter(ParameterSetName = 'Basic')]
        [int] $Limit = 0,

        [Parameter(Mandatory, ParameterSetName = 'Full', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String[]] $Guid,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()
    }

    process {

        Switch ($PsCmdlet.ParameterSetName)	{
            'Basic' {
                $params = @{
                    TppSession = $TppSession
                    Method        = 'Get'
                    UriLeaf       = 'certificates'
                    Body          = $query += @{
                        'limit' = $Limit
                    }
                }

                $response = Invoke-TppRestMethod @params

                if ( $response ) {
                    $response.Certificates
                }
            }

            'Full' {
                $params = @{
                    TppSession = $TppSession
                    Method        = 'Get'
                    UriLeaf       = [System.Web.HttpUtility]::HtmlEncode("certificates/$GUID")
                }
                Invoke-TppRestMethod @params
            }
        }

    }
}
