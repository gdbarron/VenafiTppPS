<#
.SYNOPSIS
Get permissions for TPP objects

.DESCRIPTION
Get permissions for users and groups on any object.
The effective permissions will be retrieved by default, but inherited/explicit permissions can be retrieved as well.
All permissions can be retrieved for an object, the default, or for one specific id.

.PARAMETER InputObject
One or more TppObject

.PARAMETER Path
Full path to an object

.PARAMETER Guid
Guid representing a unique object in Venafi.

.PARAMETER PrefixedUniversalId
Get permissions for a specific id for the object provided.
You can use Find-TppIdentity to get the id.

.PARAMETER Explicit
Get explicit (direct) and implicit (inherited) permissions instead of effective.

.PARAMETER Attribute
Retrieve identity attribute values for the users and groups.  Attributes include Group Membership, Name, Internet Email Address, Given Name, Surname.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
InputObject, Path, Guid

.OUTPUTS
List parameter set returns a PSCustomObject with the properties Guid and Permissions

Local and external parameter sets returns a PSCustomObject with the following properties:
    Guid
    PrefixedUniversalId
    EffectivePermissions (if Explicit switch is not used)
    ExplicitPermissions (if Explicit switch is used)
    ImplicitPermissions (if Explicit switch is used)
    Attributes (if Attribute provided)

.EXAMPLE
Find-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission

Get effective permissions for users/groups on a specific policy folder

.EXAMPLE
Find-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission -Attribute 'Given Name','Surname'

Get effective permissions on a policy folder including identity attributes for the permissioned users/groups

.EXAMPLE
Find-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission -Explicit

Get explicit and implicit permissions for users/groups on a specific policy folder

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppPermission/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppPermission.ps1

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

    [CmdletBinding(DefaultParameterSetName = 'ByObject')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ByObject', ValueFromPipeline)]
        [TppObject] $InputObject,

        [Parameter(Mandatory, ParameterSetName = 'ByPath', ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('DN', 'CertificateDN')]
        [String[]] $Path,

        [Parameter(Mandatory, ParameterSetName = 'ByGuid', ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Guid[]] $Guid,

        [Parameter()]
        [ValidateScript( {
                $_ -match '(AD|LDAP)+\S+:\w{32}$' -or $_ -match 'local:\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$'
            })]
        [Alias('PrefixedUniversal')]
        [string[]] $PrefixedUniversalId,

        [Parameter()]
        [Alias('ExplicitImplicit')]
        [switch] $Explicit,

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

        if ( $PSBoundParameters.ContainsKey('Path') ) {
            $InputObject = Get-TppObject -Path $Path
        }
        elseif ( $PSBoundParameters.ContainsKey('Guid') ) {
            $InputObject = $Guid | ConvertTo-TppPath | Get-TppObject
        }


        foreach ( $thisObject in $InputObject ) {

            $thisGuid = $thisObject.Guid

            if ( $PSBoundParameters.ContainsKey('PrefixedUniversalId') ) {
                $principals = $PrefixedUniversalId
            }
            else {
                # get list of principals permissioned to this object
                $thisGuid = "{$thisGuid}"
                $params.UriLeaf = "Permissions/Object/$thisGuid"
                $principals = Invoke-TppRestMethod @params
            }

            foreach ( $principal in $principals ) {

                if ( $principal.StartsWith('local:') ) {
                    # format of local is local:universalId
                    $type, $id = $principal.Split(':')
                    $params.UriLeaf += "/local/$id"
                }
                else {
                    # external source, eg. AD, LDAP
                    # format is type+name:universalId
                    $type, $name, $id = $principal.Split('+:')
                    $params.UriLeaf += "/$type/$name/$id"
                }

                if ( -not $PSBoundParameters.ContainsKey('Explicit') ) {
                    $params.UriLeaf += '/Effective'
                }

                $response = Invoke-TppRestMethod @params

                $thisReturnObject = [PSCustomObject] @{
                    Object              = $thisObject
                    PrefixedUniversalId = $principal
                }

                if ( $PSBoundParameters.ContainsKey('Explicit') ) {
                    $thisReturnObject | Add-Member @{
                        ExplicitPermissions = [TppPermission] $response.ExplicitPermissions
                        ImplicitPermissions = [TppPermission] $response.ImplicitPermissions
                    }
                }
                else {
                    $thisReturnObject | Add-Member @{
                        EffectivePermissions = [TppPermission] $response.EffectivePermissions
                    }
                }

                $returnObject += $thisReturnObject
            }

            if ( $PSBoundParameters.ContainsKey('Attribute') ) {

                $returnObject | Add-Member @{
                    Attributes = $null
                }

                foreach ( $thisObject in $returnObject ) {
                    $attribResponse = Get-TppIdentityAttribute -PrefixedUniversalId $thisObject.PrefixedUniversalId -Attribute $Attribute
                    $thisObject.Attributes = $attribResponse.Attributes
                }
            }

            $returnObject

        }
    }
}
