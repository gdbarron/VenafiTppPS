<#
.SYNOPSIS
Convert datetime to UTC ISO 8601 format

.DESCRIPTION
Convert datetime to UTC ISO 8601 format

.PARAMETER InputObject
DateTime object

.INPUTS
InputObject

.OUTPUTS
System.String

.EXAMPLE
(get-date) | ConvertTo-UtcIso8601

#>
function ConvertTo-TppCodeSignEnvironment {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject] $InputObject
    )

    begin {
    }

    process {
        $InputObject | Select-Object -ExcludeProperty Dn, Type, OrganizationalUnit, IpAddressRestriction, KeyUseFlowDN, TemplateDN, CertificateAuthorityDN, CertificateDN, CertificateSubject, City, KeyAlgorithm, KeyStorageLocation, Organization, OrganizationUnit, SANEmail, State, Country -Property *,
        @{
            n = 'Path'
            e = {
                $_.Dn
            }
        },
        @{
            n = 'Name'
            e = { Split-Path $_.DN -Leaf }
        },
        @{
            n = 'TypeName'
            e = { $_.Type }
        },
        @{
            n = 'OrganizationalUnit'
            e = { $_.OrganizationalUnit.Value }
        },
        @{
            n = 'IPAddressRestriction'
            e = { $_.IPAddressRestriction.Items }
        },
        @{
            n = 'KeyUseFlowPath'
            e = { $_.KeyUseFlowDN }
        },
        @{
            n = 'TemplatePath'
            e = { $_.TemplateDN }
        },
        @{
            n = 'CertificateAuthorityPath'
            e = { $_.CertificateAuthorityDN.Value }
        },
        @{
            n = 'CertificatePath'
            e = { $_.CertificateDN }
        },
        @{
            n = 'CertificateSubject'
            e = { $_.CertificateSubject.Value }
        },
        @{
            n = 'City'
            e = { $_.City.Value }
        },
        @{
            n = 'KeyAlgorithm'
            e = { $_.KeyAlgorithm.Value }
        },
        @{
            n = 'KeyStorageLocation'
            e = { $_.KeyStorageLocation.Value }
        },
        @{
            n = 'Organization'
            e = { $_.Organization.Value }
        },
        @{
            n = 'OrganizationUnit'
            e = { $_.OrganizationUnit.Value }
        },
        @{
            n = 'SANEmail'
            e = { $_.SANEmail.Value }
        },
        @{
            n = 'State'
            e = { $_.State.Value }
        },
        @{
            n = 'Country'
            e = { $_.Country.Value }
        }

    }
}