<#
.SYNOPSIS
Get attribute values for TPP identity objects

.DESCRIPTION
Get attribute values for TPP identity objects.

.PARAMETER ID
The id that represents the user or group.  Use Find-TppIdentity to get the id.

.PARAMETER Attribute
Retrieve identity attribute values for the users and groups.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
ID

.OUTPUTS
PSCustomObject with the properties Identity and Attribute

.EXAMPLE
Get-TppIdentityAttribute -IdentityId 'AD+blah:{1234567890olikujyhtgrfedwsqa}'

Get basic attributes

.EXAMPLE
Get-TppIdentityAttribute -IdentityId 'AD+blah:{1234567890olikujyhtgrfedwsqa}' -Attribute 'Surname'

Get specific attribute for user

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppIdentityAttribute/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppIdentityAttribute.ps1

.LINK
https://docs.venafi.com/Docs/20.4SDK/TopNav/Content/SDK/WebSDK/r-SDK-POST-Identity-Validate.php?tocpath=Web%20SDK%7CIdentity%20programming%20interface%7C_____15

.LINK
https://docs.venafi.com/Docs/20.4SDK/TopNav/Content/SDK/WebSDK/r-SDK-POST-Identity-Readattribute.php?tocpath=Web%20SDK%7CIdentity%20programming%20interface%7C_____10

#>
function Get-TppIdentityAttribute {

    [CmdletBinding()]
    param (

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('PrefixedUniversalId', 'Contact', 'IdentityId')]
        [string[]] $ID,

        [Parameter()]
        [ValidateSet('Group Membership', 'Name', 'Internet Email Address', 'Given Name', 'Surname')]
        [string[]] $Attribute,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        # $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'Identity/Validate'
            Body       = @{
                'ID' = @{
                    PrefixedUniversal = 'placeholder'
                }
            }
        }

        if ( $PSBoundParameters.ContainsKey('Attribute') ) {
            $params.UriLeaf = 'Identity/ReadAttribute'
            $params.Body.Add('AttributeName', 'placeholder')
        }

    }

    process {

        foreach ( $thisId in $ID ) {

            $params.Body.ID.PrefixedUniversal = $thisId

            if ( $PSBoundParameters.ContainsKey('Attribute') ) {

                $attribHash = @{ }
                foreach ( $thisAttribute in $Attribute ) {

                    $params.Body.AttributeName = $thisAttribute

                    $response = Invoke-TppRestMethod @params
                    if ( $response.Attributes ) {
                        $attribHash.$thisAttribute = $response.Attributes[0]
                    }
                }

                $attribsOut = [PSCustomObject] $attribHash

            } else {
                $response = Invoke-TppRestMethod @params
                $attribsOut = $response.Id
            }

            [PSCustomObject] @{
                ID         = $thisId
                Attributes = $attribsOut
            }
        }
    }
}
