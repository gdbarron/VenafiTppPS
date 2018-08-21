<#
.SYNOPSIS
Get permissions for TPP objects

.DESCRIPTION
Determine who has rights for TPP objects and what those rights are

.PARAMETER Guid
Guid representing a unique object in Venafi.

.PARAMETER ExternalProviderType
External provider type with users/groups to assign permissions.  AD and LDAP are currently supported.

.PARAMETER ExternalProviderName
Name of the external provider as configured in TPP

.PARAMETER UniversalId
The id that represents the user or group.  Use Get-TppIdentity to get the id.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Guid

.OUTPUTS
List parameter set returns a PSCustomObject with the properties ObjectGuid and Permissions

Local and external parameter sets returns a PSCustomObject with the following properties:
    ObjectGuid
    ProviderType
    ProviderName
    UniversalId
    EffectivePermissions (if Effective switch is used)
    ExplicitPermissions (if Effective switch is NOT used)
    ImplicitPermissions (if Effective switch is NOT used)

.EXAMPLE
Get-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission
ObjectGuid                             Permissions
----                                   -----------
{1234abcd-g6g6-h7h7-faaf-f50cd6610cba} {AD+mydomain.com:1234567890olikujyhtgrfedwsqa, AD+mydomain.com:azsxdcfvgbhnjmlk09877654321}

Get permissions for a specific policy folder

.EXAMPLE
Get-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission -Effective
ObjectGuid           : {1234abcd-g6g6-h7h7-faaf-f50cd6610cba}
ProviderType         : AD
ProviderName         : mydomain.com
UniversalId          : 1234567890olikujyhtgrfedwsqa
EffectivePermissions : @{IsAssociateAllowed=False; IsCreateAllowed=True; IsDeleteAllowed=True; IsManagePermissionsAllowed=True; IsPolicyWriteAllowed=True;
                       IsPrivateKeyReadAllowed=True; IsPrivateKeyWriteAllowed=True; IsReadAllowed=True; IsRenameAllowed=True; IsRevokeAllowed=False; IsViewAllowed=True;
                       IsWriteAllowed=True}

ObjectGuid           : {1234abcd-g6g6-h7h7-faaf-f50cd6610cba}
ProviderType         : AD
ProviderName         : mydomain.com
UniversalId          : azsxdcfvgbhnjmlk09877654321
EffectivePermissions : @{IsAssociateAllowed=False; IsCreateAllowed=False; IsDeleteAllowed=False; IsManagePermissionsAllowed=False; IsPolicyWriteAllowed=True;
                       IsPrivateKeyReadAllowed=False; IsPrivateKeyWriteAllowed=False; IsReadAllowed=True; IsRenameAllowed=False; IsRevokeAllowed=True; IsViewAllowed=False;
                       IsWriteAllowed=True}

Get effective permissions for a specific policy folder

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

                            if ( $_.StartsWith('local:') ) {

                                $type, $id = $_.Split(':')
                                $effectiveParams = @{
                                    Guid        = $thisGuid
                                    UniversalId = $id
                                    Effective   = $true
                                }
                            } else {
                                $type, $name, $id = $_.Split('+:')
                                $effectiveParams = @{
                                    Guid                 = $thisGuid
                                    ExternalProviderType = $type
                                    ExternalProviderName = $name
                                    UniversalId          = $id
                                    Effective            = $true
                                }
                            }
                            Get-TppPermission @effectiveParams
                        }
                    } else {
                        # just list out users/groups with rights
                        [PSCustomObject] @{
                            ObjectGuid  = $thisGuid
                            Permissions = $perms
                        }
                    }
                }

                {$_ -in 'Local', 'External'} {

                    # different URLs if local vs external
                    if ( $PSBoundParameters.ContainsKey('ExternalProviderType') ) {
                        $params.UriLeaf += "/$ExternalProviderType/$ExternalProviderName/$UniversalId"
                        $providerType = $ExternalProviderType
                        $providerName = $ExternalProviderName
                    } else {
                        $params.UriLeaf += "/local/$UniversalId"
                        $providerType = 'local'
                        $providerName = ''
                    }

                    if ( $PSBoundParameters.ContainsKey('Effective') ) {
                        $params.UriLeaf += '/Effective'
                    }

                    $response = Invoke-TppRestMethod @params

                    $returnObject = [PSCustomObject] @{
                        ObjectGuid   = $thisGuid
                        ProviderType = $providerType
                        ProviderName = $providerName
                        UniversalId  = $UniversalId
                    }

                    if ( $PSBoundParameters.ContainsKey('Effective') ) {
                        $returnObject | Add-Member @{
                            EffectivePermissions = $response.EffectivePermissions
                        }
                    } else {
                        $returnObject | Add-Member @{
                            ExplicitPermissions = $response.ExplicitPermissions
                            ImplicitPermissions = $response.ImplicitPermissions
                        }
                    }

                    $returnObject
                }
            }
        }
    }
}
