<#
.SYNOPSIS
Set permissions for TPP objects

.DESCRIPTION
Determine who has rights for TPP objects and what those rights are

.PARAMETER Guid
Guid representing a unique object

.PARAMETER PrefixedUniversalId
The id that represents the user or group.  You can use Find-TppIdentity or Get-TppPermission to get the id.

.PARAMETER Permission
TppPermission object.  You can create a new object or get existing object from Get-TppPermission.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Guid

.OUTPUTS
None

.EXAMPLE
Set-TppPermission -Guid '1234abcd-g6g6-h7h7-faaf-f50cd6610cba' -PrefixedUniversalId 'AD+mydomain.com:azsxdcfvgbhnjmlk09877654321' -Permission $TppPermObject

Permission a user on an object

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Set-TppPermission/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Set-TppPermission.ps1

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____6

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-PUT-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____7

.NOTES
Confirmation impact is set to Medium, set ConfirmPreference accordingly.
#>
function Set-TppPermission {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
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
            Body          = $Permission.ToHashtable()
            UseWebRequest = $true
        }
    }

    process {

        # TODO: accept object with guid and universal id, eg. from get-tpppermission
        if ( $PSBoundParameters.ContainsKey('InputObject') ) {

        }

        $GUID.ForEach{
            if ( -not (Test-TppObject -Guid $_ -ExistOnly) ) {
                Write-Error ("Guid {0} does not exist" -f $_)
                Continue
            }

            $params.UriLeaf = "Permissions/Object/{$_}"

            $PrefixedUniversalId.ForEach{
                $thisId = $_

                if ( -not (Test-TppIdentity -PrefixedUniversalId $PrefixedUniversalId -ExistOnly) ) {
                    Write-Error "Id $thisId does not exist"
                    Continue
                }

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

                if ( $PSCmdlet.ShouldProcess($thisId, 'Set permission') ) {
                    $response = Invoke-TppRestMethod @params

                    Write-Verbose ('Response status code: {0}' -f $response.StatusCode)

                    switch ($response.StatusCode) {

                        {$_ -in 'Created', '201'} {
                            # success
                        }

                        {$_ -in 'Conflict', '409'} {
                            # user/group already has permissions defined on this object
                            # need to use a put method instead
                            Write-Verbose "Existing user/group found, updating existing permissions"
                            $params.Method = 'Put'
                            $response = Invoke-TppRestMethod @params
                            if ( $response.StatusCode -notin 'OK', '200' ) {
                                Write-Error ('Failed to update permission with error {0}' -f $response.StatusDescription)
                            }
                        }

                        default {
                            Write-Error ('Failed to create permission with error {0}, URL {1}' -f $response.StatusDescription, $response.ResponseUri)
                        }
                    }
                }
            }
        }
    }
}
