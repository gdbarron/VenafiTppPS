<#
.SYNOPSIS
Set permissions for TPP objects

.DESCRIPTION
Determine who has rights for TPP objects and what those rights are

.PARAMETER Guid
Guid representing a unique object in Venafi.

.PARAMETER PrefixedUniversalId
The id that represents the user or group.  Use Get-TppIdentity to get the id.

.PARAMETER Permission
Get effective permissions for the specific user or group on the object.
If only an object guid is provided with this switch, all user and group permssions will be provided.

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
function Set-TppPermission {

    [CmdletBinding()]
    param (
        # [Parameter(Mandatory, ValueFromPipeline)]
        # [ValidateNotNullOrEmpty()]
        # [PSCustomObject[]] $InputObject,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('ObjectGuid')]
        [guid[]] $Guid,

        [Parameter(Mandatory)]
        [ValidateScript( {
                $_ -match '(AD|LDAP)+\S+:\w{32}$' -or $_ -match 'local:\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$'
            })]
        [Alias('PrefixedUniversal')]
        [string[]] $PrefixedUniversalId,

        [Parameter(Mandatory)]
        [TppPermission] $Permission,

        [Parameter()]
        [switch] $UpdateExisting,

        [Parameter()]
        [switch] $Force,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $params = @{
            TppSession    = $TppSession
            Method        = 'Post'
            UriLeaf       = 'placeholder'
            Body          = $Permission.Splat()
            UseWebRequest = $true
        }
    }

    process {

        # TODO: accept object with guid and universal id, eg. from get-tpppermission
        if ( $PSBoundParameters.ContainsKey('InputObject') ) {

        }

        $GUID.ForEach{
            $thisGuid = "{$_}"
            $params.UriLeaf = "Permissions/Object/$thisGuid"

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

                if ( -not $PSBoundParameters.ContainsKey('Force') ) {
                    # confirm perm addition/update
                    Write-Information
                }

                $response = Invoke-TppRestMethod @params
                Write-Verbose $response.StatusCode
                switch ($response.StatusCode) {
                    'Conflict' {
                        # user/group already has permissions defined on this object
                        # need to use a put method instead
                        if ( $PSBoundParameters.ContainsKey('UpdateExisting') ) {
                            Write-Warning "Existing user/group found, updating existing permissions"
                            $params.Method = 'Put'
                            $response = Invoke-TppRestMethod @params
                        }
                    }
                }
                $response
            }
        }
    }
}
