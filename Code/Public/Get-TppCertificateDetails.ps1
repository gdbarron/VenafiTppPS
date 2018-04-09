<#
.SYNOPSIS 
Get basic or full details about certificates

.DESCRIPTION
Get details about a certificate based on search criteria.
Be sure to provide '\VED\Policy' at the start of any path.  See the examples for a few of the available options.
The SDK provides a full list.  Additional details can be had by passing the guid.

.PARAMETER Query
Hashtable providing 1 or more key/value pairs with search criteria.

.PARAMETER Guid
Guid representing a unique certificate in Venafi.

.PARAMETER VenafiSession
Session object created from New-TppSession method.  The value defaults to the script session object $VenafiSession.

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
Get-TppCertificateDetails -query @{'ValidToLess'='2018-04-30T00:00:00.0000000Z'}
Find all certificates expiring before a certain date

.EXAMPLE
Get-TppCertificateDetails -query @{'ParentDn'='\VED\Policy\My folder'}
Find all certificates in the specified folder

.EXAMPLE
Get-TppCertificateDetails -query @{'ParentDnRecursive'='\VED\Policy\My folder'}
Find all certificates in the specified folder and subfolders

.EXAMPLE
Get-TppCertificateDetails -query @{'ParentDnRecursive'='\VED\Policy\My folder'; 'Limit'='20'}
Find all certificates in the specified folder and subfolders, but limit the results to 20

.EXAMPLE
$certs | Get-TppCertificateDetails
Get detailed certificate info after performing basic query

#>
function Get-TppCertificateDetails {

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
        $VenafiSession = $VenafiSession | Test-TppSession
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
                $response = Invoke-TppRestMethod @params

                if ( $response ) {
                    $response.Certificates
                }
            }

            'Full' {
                $params = @{
                    VenafiSession = $VenafiSession
                    Method        = 'Get'
                    UriLeaf       = [System.Web.HttpUtility]::HtmlEncode("certificates/$GUID")
                }
                Invoke-TppRestMethod @params
            }
        }

    }
}
