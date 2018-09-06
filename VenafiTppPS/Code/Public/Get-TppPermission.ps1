<#
.SYNOPSIS
Get permissions for TPP objects

.DESCRIPTION
Determine who has rights for TPP objects and what those rights are

.PARAMETER Guid
Guid representing a unique object in Venafi.

.PARAMETER PrefixedUniversalId
The id that represents the user or group.  Use Get-TppIdentity to get the id.

.PARAMETER Effective
Get effective permissions for the specific user or group on the object.
If only an object guid is provided with this switch, all user and group permssions will be provided.

.PARAMETER ExplicitImplicit
Get explicit and implicit permissions for the specific user or group on the object.
If only an object guid is provided with this switch, all user and group permssions will be provided.

.PARAMETER Attribute
Retrieve identity attribute values for the users and groups.  Attributes include Group Membership, Name, Internet Email Address, Given Name, Surname.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Guid

.OUTPUTS
List parameter set returns a PSCustomObject with the properties Guid and Permissions

Local and external parameter sets returns a PSCustomObject with the following properties:
    Guid
    PrefixedUniversalId
    EffectivePermissions (if Effective switch is used)
    ExplicitPermissions (if ExplicitImplicit switch is used)
    ImplicitPermissions (if ExplicitImplicit switch is used)
    Attribute (if Attribute provided)

.EXAMPLE
Get-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission
Guid                             PrefixedUniversalId
----                                   -----------
{1234abcd-g6g6-h7h7-faaf-f50cd6610cba} {AD+mydomain.com:1234567890olikujyhtgrfedwsqa, AD+mydomain.com:azsxdcfvgbhnjmlk09877654321}

Get users/groups permissioned to a policy folder

.EXAMPLE
Get-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission -Attribute 'Given Name','Surname'
Guid                             PrefixedUniversalId                              Attribute
----------                             -------------------                              ---------
{1234abcd-g6g6-h7h7-faaf-f50cd6610cba} AD+mydomain.com:1234567890olikujyhtgrfedwsqa {@{Name=Given Name; Value=Greg}, @{Name=Surname; Value=Brownstein}}
{1234abcd-g6g6-h7h7-faaf-f50cd6610cba} AD+mydomain.com:azsxdcfvgbhnjmlk09877654321 {@{Name=Given Name; Value=Greg}, @{Name=Surname; Value=Brownstein}}

Get users/groups permissioned to a policy folder including identity attributes for those users/groups

.EXAMPLE
Get-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission -Effective
Guid           : {1234abcd-g6g6-h7h7-faaf-f50cd6610cba}
PrefixedUniversalId  : AD+mydomain.com:1234567890olikujyhtgrfedwsqa
EffectivePermissions : @{IsAssociateAllowed=False; IsCreateAllowed=True; IsDeleteAllowed=True; IsManagePermissionsAllowed=True; IsPolicyWriteAllowed=True;
                       IsPrivateKeyReadAllowed=True; IsPrivateKeyWriteAllowed=True; IsReadAllowed=True; IsRenameAllowed=True; IsRevokeAllowed=False; IsViewAllowed=True;
                       IsWriteAllowed=True}

Guid           : {1234abcd-g6g6-h7h7-faaf-f50cd6610cba}
PrefixedUniversalId  : AD+mydomain.com:azsxdcfvgbhnjmlk09877654321
EffectivePermissions : @{IsAssociateAllowed=False; IsCreateAllowed=False; IsDeleteAllowed=False; IsManagePermissionsAllowed=False; IsPolicyWriteAllowed=True;
                       IsPrivateKeyReadAllowed=False; IsPrivateKeyWriteAllowed=False; IsReadAllowed=True; IsRenameAllowed=False; IsRevokeAllowed=True; IsViewAllowed=False;
                       IsWriteAllowed=True}

Get effective permissions for users/groups on a specific policy folder

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
        [Parameter(Mandatory, ParameterSetName = 'Effective', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'ExplicitImplicit', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('ObjectGuid')]
        [guid[]] $Guid,

        [Parameter(Mandatory, ParameterSetName = 'Effective')]
        [Parameter(Mandatory, ParameterSetName = 'ExplicitImplicit')]
        [ValidateScript( {
                $_ -match '(AD|LDAP)+\S+:\w{32}$' -or $_ -match 'local:\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$'
            })]
        [Alias('PrefixedUniversal')]
        [string[]] $PrefixedUniversalId,

        [Parameter(ParameterSetName = 'List')]
        [Parameter(ParameterSetName = 'Effective')]
        [switch] $Effective,

        [Parameter(ParameterSetName = 'List')]
        [Parameter(ParameterSetName = 'ExplicitImplicit')]
        [switch] $ExplicitImplicit,

        [Parameter()]
        [ValidateSet('Group Membership', 'Name', 'Internet Email Address', 'Given Name', 'Surname')]
        [string[]] $Attribute,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        Write-Verbose ("Parameter set {0}" -f $PsCmdlet.ParameterSetName)

        $params = @{
            TppSession = $TppSession
            Method     = 'Get'
            UriLeaf    = 'placeholder'
        }

        $returnObject = @()
    }

    process {

        $GUID.ForEach{
            $thisGuid = "{$_}"
            $params.UriLeaf = "Permissions/Object/$thisGuid"

            Switch ($PsCmdlet.ParameterSetName)	{
                'List' {
                    $perms = Invoke-TppRestMethod @params
                    $perms.ForEach{
                        if ( $PSBoundParameters.ContainsKey('Effective') -or $PSBoundParameters.ContainsKey('ExplicitImplicit') ) {
                            # get details from list of perms on the object
                            # loop through and get perms on each by re-calling this function

                            $permParams = @{
                                Guid                = $thisGuid
                                PrefixedUniversalId = $_
                            }

                            if ( $PSBoundParameters.ContainsKey('Effective') ) {
                                $permParams.Add( 'Effective', $true )
                            } else {
                                $permParams.Add( 'ExplicitImplicit', $true )
                            }

                            if ( $PSBoundParameters.ContainsKey('Attribute') ) {
                                $permParams.Add( 'Attribute', $Attribute )
                            }

                            Get-TppPermission @permParams
                        } else {
                            # just list out users/groups with rights
                            $returnObject += [PSCustomObject] @{
                                Guid          = $thisGuid
                                PrefixedUniversalId = $_
                            }
                        }
                    }
                }

                {$_ -in 'Effective', 'ExplicitImplicit'} {

                    $PrefixedUniversalId.ForEach{
                        $thisId = $_

                        if ( $thisId.StartsWith('local:') ) {
                            # format of local is local:universalId
                            $type, $id = $thisId.Split(':')
                            $params.UriLeaf += "/local/$id"
                        } else {
                            # external source, eg. AD, LDAP
                            # format is type+name:universalId
                            $type, $name, $id = $thisId.Split('+:')
                            $params.UriLeaf += "/$type/$name/$id"
                        }

                        if ( $PSBoundParameters.ContainsKey('Effective') ) {
                            $params.UriLeaf += '/Effective'
                        }

                        $response = Invoke-TppRestMethod @params

                        $thisReturnObject = [PSCustomObject] @{
                            Guid          = $thisGuid
                            PrefixedUniversalId = $thisId
                        }

                        if ( $PSBoundParameters.ContainsKey('Effective') ) {
                            $thisReturnObject | Add-Member @{
                                EffectivePermissions = [TppPermission] $response.EffectivePermissions
                            }
                        } else {
                            $thisReturnObject | Add-Member @{
                                ExplicitPermissions = [TppPermission] $response.ExplicitPermissions
                                ImplicitPermissions = [TppPermission] $response.ImplicitPermissions
                            }
                        }

                        $returnObject += $thisReturnObject
                    }
                }
            }

            if ( $PSBoundParameters.ContainsKey('Attribute') ) {

                $returnObject | Add-Member @{
                    Attribute = $null
                }

                $returnObject.ForEach{
                    $thisObject = $_
                    $Attribute.ForEach{
                        $attribResponse = Get-TppIdentityAttribute -PrefixedUniversalId $thisObject.PrefixedUniversalId -Attribute $Attribute
                        $thisObject.Attribute = $attribResponse.Attribute
                        }
                    }
                }

            $returnObject
        }
    }
}
