<#
.SYNOPSIS
Get permissions for TPP objects

.DESCRIPTION
Get permissions for users and groups on any object.
The effective permissions will be retrieved by default, but inherited/explicit permissions can be retrieved as well.
All permissions can be retrieved for an object, the default, or for one specific id.

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
Path, Guid

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

    [CmdletBinding(DefaultParameterSetName = 'ByPath')]
    param (

        [Parameter(Mandatory, ParameterSetName = 'ByPath', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('DN', 'CertificateDN')]
        [String[]] $Path,

        [Parameter()]
        [ValidateScript( {
                if ( $_ | Test-PrefixedUniversalId ) {
                    $true
                } else {
                    throw "'$_' is not a valid PrefixedUniversalId format.  See https://docs.venafi.com/Docs/20.4SDK/TopNav/Content/SDK/WebSDK/r-SDK-IdentityInformation.php."
                }
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

    }

    process {

        foreach ( $thisPath in $Path ) {

            $uriBase = ('Permissions/Object/{{{0}}}' -f ($thisPath | ConvertTo-TppGuid) )
            $params.UriLeaf = $uriBase

            try {
                # get list of principals permissioned to this object
                $principals = Invoke-TppRestMethod @params
            } catch {
                Write-Error "Couldn't obtain list of permissions for $thisPath.  $_"
                continue
            }

            if ( $PSBoundParameters.ContainsKey('PrefixedUniversalId') ) {
                $principals = $principals | Where-Object { $_ -in $PrefixedUniversalId }
            }

            foreach ( $principal in $principals ) {

                Write-Verbose ('Path: {0}, Id: {1}' -f $thisPath, $principal)

                $params.UriLeaf = $uriBase

                if ( $principal.StartsWith('local:') ) {
                    # format of local is local:universalId
                    $type, $id = $principal.Split(':')
                    $params.UriLeaf += "/local/$id"
                } else {
                    # external source, eg. AD, LDAP
                    # format is type+name:universalId
                    $type, $name, $id = $principal -Split { $_ -in '+', ':' }
                    $params.UriLeaf += "/$type/$name/$id"
                }

                if ( -not $Explicit.IsPresent ) {
                    $params.UriLeaf += '/Effective'
                }

                try {

                    $response = Invoke-TppRestMethod @params

                    # if not permissions are assigned, we won't get anything back
                    if ( $response ) {

                        $thisReturnObject = [PSCustomObject] @{
                            Path                = $thisPath
                            PrefixedUniversalId = $principal
                        }

                        if ( $Explicit.IsPresent ) {
                            $thisReturnObject | Add-Member @{
                                ExplicitPermissions = [TppPermission] $response.ExplicitPermissions
                                ImplicitPermissions = [TppPermission] $response.ImplicitPermissions
                            }
                        } else {
                            $thisReturnObject | Add-Member @{
                                EffectivePermissions = [TppPermission] $response.EffectivePermissions
                            }
                        }


                        if ( $PSBoundParameters.ContainsKey('Attribute') ) {

                            $thisReturnObject | Add-Member @{
                                Attributes = $null
                            }

                            $attribParams = @{
                                PrefixedUniversalId = $thisReturnObject.PrefixedUniversalId
                                Attribute           = $Attribute
                                TppSession          = $TppSession
                            }
                            try {
                                $attribResponse = Get-TppIdentityAttribute @attribParams
                                $thisReturnObject.Attributes = $attribResponse.Attributes
                            } catch {
                                Write-Error "Couldn't obtain identity attributes for $($attribParams.PrefixedUniversalId).  $_"
                            }
                        }

                        $thisReturnObject
                    }
                } catch {
                    Write-Error "Couldn't obtain permission set for path $Path, user/group $principal.  $_"
                }
            }
        }
    }
}
