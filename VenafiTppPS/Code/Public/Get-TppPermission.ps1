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
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppPermission/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppPermission.ps1

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____1

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-external.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____2

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-local.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____3

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____5

#>
function Get-TppPermission {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'List', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Local', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'External', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String[]] $Guid,

        [Parameter(Mandatory, ParameterSetName = 'External')]
        [ValidateSet('AD', 'LDAP')]
        [string] $ExternalProviderType,

        [Parameter(Mandatory, ParameterSetName = 'External')]
        [string] $ExternalProviderName,

        [Parameter(Mandatory, ParameterSetName = 'Local')]
        [Parameter(Mandatory, ParameterSetName = 'External')]
        [Alias('Universal')]
        [string] $UniversalId,

        [Parameter(ParameterSetName = 'List')]
        [Parameter(ParameterSetName = 'Local')]
        [Parameter(ParameterSetName = 'External')]
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
                'List' {
                    $perms = Invoke-TppRestMethod @params
                    if ( $PSBoundParameters.ContainsKey('Effective') ) {
                        $perms.ForEach{
                            # get details from list of perms on the object
                            # loop through and get effective perms on each by re-calling this function
                            # TODO: update split to support local
                            $type, $name, $id = $_.Split('+:')
                            $effectiveParams = @{
                                Guid                 = $thisGuid
                                ExternalProviderType = $type
                                ExternalProviderName = $name
                                UniversalId          = $id
                                Effective            = $true
                            }
                            Get-TppPermission @effectiveParams
                        }
                    } else {
                        # just list out users/groups with rights
                        [PSCustomObject] @{
                            GUID        = $thisGuid
                            Permissions = $perms
                        }
                    }
                }

                {$_ -in 'Local', 'External'} {
                    # different URLs if local vs external
                    if ( $PSBoundParameters.ContainsKey('ExternalProviderType') ) {
                        $params.UriLeaf += "/$ExternalProviderType/$ExternalProviderName/$UniversalId"
                    } else {
                        $params.UriLeaf += "/local/$UniversalId"
                    }

                    if ( $PSBoundParameters.ContainsKey('Effective') ) {
                        $params.UriLeaf += '/Effective'
                    }

                    $response = Invoke-TppRestMethod @params

                    if ( $PSBoundParameters.ContainsKey('Effective') ) {
                        [PSCustomObject] @{
                            GUID                 = $thisGuid
                            EffectivePermissions = $response.EffectivePermissions
                        }
                    } else {
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
}
