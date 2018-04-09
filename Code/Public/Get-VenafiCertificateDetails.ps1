<#
.SYNOPSIS 
Get basic details about a certificate that exists in Venafi

.DESCRIPTION
Get details about a certificate based on search criteria.  The number of search parameters is quite extensive.
Be sure to provide '\VED\Policy' at the start of any path.  See the examples.

.PARAMETER Query
Hashtable providing 1 or more key/value pairs with search criteria.

.PARAMETER VenafiSession
Session object created from New-VenafiSession method.  The value defaults to the script session object $VenafiSession.

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
Get-VenafiCertificateDetails -query @{'ValidToLess'='2018-04-30T00:00:00.0000000Z'}
Find all certificates expiring before a certain date

.EXAMPLE
Get-VenafiCertificateDetails -query @{'ParentDn'='\VED\Policy\My folder'}
Find all certificates in the specified folder

.EXAMPLE
Get-VenafiCertificateDetails -query @{'ParentDnRecursive'='\VED\Policy\My folder'}
Find all certificates in the specified folder and subfolders

.EXAMPLE
Get-VenafiCertificateDetails -query @{'ParentDnRecursive'='\VED\Policy\My folder'; 'Limit'='20'}
Find all certificates in the specified folder and subfolders, but limit the results to 20

.EXAMPLE
$certs | Get-VenafiCertificateDetails
Get detailed certificate info after performing basic query

#>
function Get-VenafiCertificateDetails {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Basic')]
        [ValidateNotNullOrEmpty()]
        [hashtable] $Query,
        
        [Parameter(Mandatory, ParameterSetName = 'Full', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String[]] $Guid,

        $VenafiSession = $Script:VenafiSession
    )

    begin {
        $VenafiSession = $VenafiSession | Test-VenafiSession
    }

    process {
        Switch ($PsCmdlet.ParameterSetName)	{
            'Basic' {
                $params = @{
                    VenafiSession = $VenafiSession
                    Method        = 'Get'
                    UriLeaf       = 'certificates'
                    Body          = $query
                }
            }

            'Full' {
                $params = @{
                    VenafiSession = $VenafiSession
                    Method        = 'Get'
                    UriLeaf       = [System.Web.HttpUtility]::HtmlEncode("certificates/$GUID")
                }
            }
        }

        Invoke-VenafiRestMethod @params
    }
}
