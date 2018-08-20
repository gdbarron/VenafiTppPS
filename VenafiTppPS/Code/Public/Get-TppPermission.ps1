<#
.SYNOPSIS
Get basic or detailed certificate information

.DESCRIPTION
Get certificate info based on a variety of attributes.
Additional details can be had by passing the guid.

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
Get-TppCertificateDetail -ExpireBefore ([DateTime] "2018-01-01")
Find all certificates expiring before a certain date

.EXAMPLE
Get-TppCertificateDetail -ExpireBefore ([DateTime] "2018-01-01") -Limit 5
Find 5 certificates expiring before a certain date

.EXAMPLE
Get-TppCertificateDetail -Path '\VED\Policy\My Policy'
Find all certificates in a specific path

.EXAMPLE
Get-TppCertificateDetail -Path '\VED\Policy\My Policy' -Recursive
Find all certificates in a specific path and all subfolders

.EXAMPLE
Get-TppCertificateDetail -ExpireBefore ([DateTime] "2018-01-01") -Limit 5 | Get-TppCertificateDetail
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
function Get-TppPermission {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Default', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Effective', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Principal', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String[]] $Guid,

        [Parameter(Mandatory, ParameterSetName = 'Effective')]
        [Parameter(Mandatory, ParameterSetName = 'Principal')]
        [ValidateSet('local', 'AD', 'LDAP')]
        [string] $ProviderType,

        [Parameter(Mandatory, ParameterSetName = 'Effective')]
        [Parameter(Mandatory, ParameterSetName = 'Principal')]
        [string] $ProviderName,

        [Parameter(Mandatory, ParameterSetName = 'Effective')]
        [Parameter(Mandatory, ParameterSetName = 'Principal')]
        [Alias('Universal')]
        [string] $UniversalId,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(Mandatory, ParameterSetName = 'Effective')]
        [switch] $Effective,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Get'
            UriLeaf    = 'placeholder'
        }
    }

    process {

        $GUID.ForEach{
            $thisGuid = $_
            $uriLeaf = "Permissions/Object/$thisGuid"
            $params.UriLeaf = $uriLeaf

            Switch ($PsCmdlet.ParameterSetName)	{
                'Default' {
                    $perms = Invoke-TppRestMethod @params
                    if ( $Effective ) {
                        $perms.ForEach{
                            # get provider and principal
                            $type, $name, $id = $_.Split('+:')
                            $effectiveParams = @{
                                Guid         = $thisGuid
                                ProviderType = $type
                                ProviderName = $name
                                UniversalId  = $id
                                Effective = $true
                            }
                            Get-TppPermission @effectiveParams
                        }
                    } else {
                        [PSCustomObject] @{
                            GUID        = $thisGuid
                            Permissions = $perms
                        }
                    }
                }

                'Effective' {
                    if ( $ProviderType -eq 'local' ) {
                        $params.UriLeaf += "/$ProviderType/$UniversalId/Effective"
                    } else {
                        $params.UriLeaf += "/$ProviderType/$ProviderName/$UniversalId/Effective"
                    }
                    $response = Invoke-TppRestMethod @params
                    [PSCustomObject] @{
                        GUID                 = $thisGuid
                        EffectivePermissions = $response.EffectivePermissions
                    }
                }

                'Principal' {
                    if ( $ProviderType -eq 'local' ) {
                        $params.UriLeaf += "/$ProviderType/$UniversalId"
                    } else {
                        $params.UriLeaf += "/$ProviderType/$ProviderName/$UniversalId"
                    }
                    $response = Invoke-TppRestMethod @params
                    [PSCustomObject] @{
                        GUID                = $thisGuid
                        ExplicitPermissions = $response.ExplicitPermissions
                        ImplicitPermissions = $response.ImplicitPermissions
                    }
                }
            }

        }

    }
}
