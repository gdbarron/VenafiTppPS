<#
.SYNOPSIS
Test if an identity exists

.DESCRIPTION
Provided with a prefixed universal id, find out if an identity exists.

.PARAMETER PrefixedUniversalId
The id that represents the user or group.

.PARAMETER ExistOnly
Only return boolean instead of Identity and Exists list.  Helpful when validating just 1 identity.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
PrefixedUniversalId

.OUTPUTS
PSCustomObject will be returned with properties 'Identity', a System.String, and 'Exists', a System.Boolean.

.EXAMPLE
'local:78uhjny657890okjhhh', 'AD+mydomain.com:azsxdcfvgbhnjmlk09877654321' | Test-TppIdentity
Identity                                       Exists
--------                                       -----
local:78uhjny657890okjhhh                      True
AD+mydomain.com:azsxdcfvgbhnjmlk09877654321    False

Test multiple identities

.EXAMPLE
Test-TppIdentity -PrefixedUniversalId 'AD+mydomain.com:azsxdcfvgbhnjmlk09877654321' -ExistOnly

Retrieve existence for only one identity, returns boolean

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Test-TppIdentity/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Test-TppIdentity.ps1

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Identity-Validate.php?tocpath=REST%20API%20reference%7CIdentity%20programming%20interfaces%7C_____9

#>
function Test-TppIdentity {

    [CmdletBinding()]
    param (

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript( {
                $_ -match '^(AD|LDAP)\+.+:{?\w{32}}?$' -or $_ -match 'local:{?\w{8}-\w{4}-\w{4}-\w{4}-\w{12}}?$'
            })]
        [Alias('PrefixedUniversal', 'Contact')]
        [string[]] $PrefixedUniversalId,

        [Parameter()]
        [Switch] $ExistOnly,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'Identity/Validate'
            Body       = @{
                'ID' = @{
                    'PrefixedUniversal' = ''
                }
            }
        }
    }

    process {

        foreach ( $thisId in $PrefixedUniversalId ) {

            $params.Body.Id.PrefixedUniversal = $thisId

            $response = Invoke-TppRestMethod @params

            if ( $ExistOnly ) {
                $null -ne $response.Id
            } else {
                [PSCustomObject] @{
                    Identity = $thisId
                    Exists   = ($null -ne $response.Id)
                }
            }
        }
    }
}
