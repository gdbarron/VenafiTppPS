<#
.SYNOPSIS
Remove permissions from TPP objects

.DESCRIPTION
Remove permissions from TPP objects
You can opt to remove permissions for a specific user or all assigned

.PARAMETER Path
Full path to an object.  You can also pipe in a TppObject.

.PARAMETER PrefixedUniversalId
Identity of the user to have their permissions removed.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Path

.OUTPUTS
None

.EXAMPLE
Find-TppObject -Path '\VED\Policy\My folder' | Remove-TppPermission
Remove all permissions

.EXAMPLE
Find-TppObject -Path '\VED\Policy\My folder' | Remove-TppPermission -PrefixedUniversalId 'AD+blah:879s8d7f9a8ds7f9s8d7f9'
Remove permissions for a specific user

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Remove-TppPermission/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Remove-TppPermission.ps1

.LINK
https://docs.venafi.com/Docs/20.4SDK/TopNav/Content/SDK/WebSDK/r-SDK-DELETE-Permissions-object-guid-principal.php?tocpath=Web%20SDK%7CPermissions%20programming%20interface%7C_____6

#>
function Remove-TppPermission {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [String[]] $Path,

        [Parameter(ValueFromPipelineByPropertyName)]
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
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Delete'
            UriLeaf    = 'placeholder'
        }
    }

    process {

        foreach ( $thisPath in $Path ) {

            $thisGuid = $thisPath | ConvertTo-TppGuid -TppSession $TppSession

            $uriBase = ('Permissions/object/{{{0}}}' -f $thisGuid)
            $params.UriLeaf = $uriBase

            if ( $PSBoundParameters.ContainsKey('PrefixedUniversalId') ) {
                $principals = $PrefixedUniversalId
            } else {
                # get list of principals permissioned to this object
                $getParams = $params.Clone()
                $getParams.Method = 'Get'
                $principals = Invoke-TppRestMethod @getParams
            }

            foreach ( $principal in $principals ) {

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

                if ( $PSCmdlet.ShouldProcess($thisPath, "Remove permissions for $principal") ) {
                    try {
                        Invoke-TppRestMethod @params
                    }
                    catch {
                        Write-Error ("Failed to remove permissions on path $thisPath, user/group $principal.  $_")
                    }
                }
            }
        }
    }
}
