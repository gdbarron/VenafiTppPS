<#
.SYNOPSIS
Get attribute values for TPP objects

.DESCRIPTION
Get attribute values for TPP identity objects

.PARAMETER PrefixedUniversalId
The id that represents the user or group.  Use Get-TppIdentity to get the id.

.PARAMETER Attribute
Retrieve identity attribute values for the users and groups.  Attributes include Group Membership, Name, Internet Email Address, Given Name, Surname.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
PrefixedUniversalId

.OUTPUTS
PSCustomObject with the properties PrefixedUniversalId and Attribute

.EXAMPLE
Get-TppIdentityAttribute -PrefixedUniversalId 'AD+mydomain.com:1234567890olikujyhtgrfedwsqa' -Attribute 'surname'
PrefixedUniversalId                              Attribute
-------------------                              ---------
AD+mydomain.com:1234567890olikujyhtgrfedwsqa {@{Name=surname; Value=Brownstein}}

Get Surname attribute for specific user

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppIdentityAttribute/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppIdentityAttribute.ps1

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Identity-Readattribute.php?tocpath=REST%20API%20reference%7CIdentity%20programming%20interfaces%7C_____7

#>
function Get-TppIdentityAttribute {

    [CmdletBinding()]
    param (

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateScript( {
                $_ -match '(AD|LDAP)+\S+:\w{32}$' -or $_ -match 'local:\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$'
            })]
        [Alias('PrefixedUniversal')]
        [string[]] $PrefixedUniversalId,

        [Parameter(Mandatory)]
        [ValidateSet('Group Membership', 'Name', 'Internet Email Address', 'Given Name', 'Surname')]
        [string[]] $Attribute,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'Identity/ReadAttribute'
            Body       = @{
                'ID'            = @{
                    PrefixedUniversal = 'placeholder'
                }
                'AttributeName' = 'placeholder'
            }
        }
    }

    process {

        $PrefixedUniversalId.ForEach{

            $thisId = $_

            $attribsOut = $Attribute.ForEach{
                $params.Body.AttributeName = $_
                $params.Body.ID.PrefixedUniversal = $thisId

                $response = Invoke-TppRestMethod @params

                if ( $response.Attributes ) {
                    [PSCustomObject] @{
                        Name  = $_
                        Value = $response.Attributes[0]
                    }
                }
            }

            [PSCustomObject] @{
                PrefixedUniversalId = $thisId
                Attribute           = $attribsOut
            }
        }
    }
}
