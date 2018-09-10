<#
.SYNOPSIS
Get identity details

.DESCRIPTION
Returns information about individual identity, group identity, or distribution groups from a local or non-local provider such as Active Directory.
If no identity types are selected, all types will be included in the search.

.PARAMETER Name
The individual identity, group identity, or distribution group name to search for in the provider. For non-local identity providers, such as AD and LDAP, use both the Filter and Limit parameters.

.PARAMETER Limit
Limit how many items are returned, the default is 100.

.PARAMETER IncludeUsers
Include user identity type in search

.PARAMETER IncludeSecurityGroups
Include security group identity type in search

.PARAMETER IncludeDistributionGroups
Include distribution group identity type in search

.PARAMETER Me
Returns the identity of the authenticated user and all associated identities

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Name

.OUTPUTS
PSCustomObject with the following properties:
    FullName
    IsContainer
    IsGroup
    Name
    Prefix
    PrefixedName
    PrefixedUniversal
    Universal

.EXAMPLE
Get-TppIdentity -Name 'greg' -IncludeUsers
FullName          : CN=Greg Brownstein,OU=My Group,DC=my,DC=company,DC=com
IsContainer       : False
IsGroup           : False
Name              : greg
Prefix            : AD+company.com
PrefixedName      : AD+company.com:greg
PrefixedUniversal : AD+company.com:1234567890asdfghjklmnbvcxz
Universal         : 1234567890asdfghjklmnbvcxz

Find user identities with the name greg

.EXAMPLE
Get-TppIdentity -Name 'greg'

Find all identity types with the name greg

.EXAMPLE
'greg', 'brownstein' | Get-TppIdentity

Find all identity types with the name greg and brownstein

.EXAMPLE
Get-TppIdentity -Me

Find authenticated user identity and all associated identities

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppIdentity/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppIdentity.ps1

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Identity-Browse.php?tocpath=REST%20API%20reference%7CIdentity%20programming%20interfaces%7C_____3

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Identity-Self.php?tocpath=REST%20API%20reference%7CIdentity%20programming%20interfaces%7C_____8

#>
function Get-TppIdentity {

    [CmdletBinding(DefaultParameterSetName = 'Browse')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Browse', ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [String[]] $Name,

        [Parameter(ParameterSetName = 'Browse')]
        [int] $Limit = 100,

        [Parameter(ParameterSetName = 'Browse')]
        [Switch] $IncludeUsers,

        [Parameter(ParameterSetName = 'Browse')]
        [Switch] $IncludeSecurityGroups,

        [Parameter(ParameterSetName = 'Browse')]
        [Switch] $IncludeDistributionGroups,

        [Parameter(Mandatory, ParameterSetName = 'Me')]
        [Switch] $Me,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $identityType = 0
        # determine settings to use
        if ( $PSBoundParameters.ContainsKey('IncludeUsers') ) {
            $identityType += [IdentityType]::User
        }
        if ( $PSBoundParameters.ContainsKey('IncludeSecurityGroups') ) {
            $identityType += [IdentityType]::SecurityGroups
        }
        if ( $PSBoundParameters.ContainsKey('IncludeDistributionGroups') ) {
            $identityType += [IdentityType]::DistributionGroups
        }

        # if no types to include were provided, include all
        if ( $identityType -eq 0 ) {
            $identityType = [IdentityType]::User + [IdentityType]::SecurityGroups + [IdentityType]::DistributionGroups
        }

        Switch ($PsCmdlet.ParameterSetName)	{
            'Browse' {
                $params = @{
                    TppSession = $TppSession
                    Method     = 'Post'
                    UriLeaf    = 'Identity/Browse'
                    Body       = @{
                        Filter       = 'placeholder'
                        Limit        = $Limit
                        IdentityType = $identityType
                    }
                }
            }

            'Me' {
                $params = @{
                    TppSession = $TppSession
                    Method     = 'Get'
                    UriLeaf    = 'Identity/Self'
                }
            }
        }
    }

    process {

        Switch ($PsCmdlet.ParameterSetName)	{
            'Browse' {
                $response = $Name.ForEach{
                    $params.Body.Filter = $_
                    Invoke-TppRestMethod @params
                }
            }

            'Me' {
                $response = Invoke-TppRestMethod @params
            }
        }

        if ( $response ) {
            $response.Identities
        }

    }
}
