<#
.SYNOPSIS
Get attribute values for TPP identity objects

.DESCRIPTION
Get attribute values for TPP identity objects.

.PARAMETER IdentityId
The id that represents the user or group.  Use Find-TppIdentity to get the id.

.PARAMETER Attribute
Retrieve identity attribute values for the users and groups.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
IdentityId

.OUTPUTS
PSCustomObject with the properties Identity and Attribute

.EXAMPLE
Get-TppIdentityAttribute -IdentityId 'AD+blah:{1234567890olikujyhtgrfedwsqa}' | format-list
Identity : AD+blah:1234567890olikujyhtgrfedwsqa
Attribute           : @{FullName=CN=greg,OU=Users,DC=mydomain,DC=com; IsContainer=False; IsGroup=False; Name=greg; Prefix=AD+mydomain.com;
                      PrefixedName=AD+blah:greg; PrefixedUniversal=AD+blah:1234567890olikujyhtgrfedwsqa; Universal=1234567890olikujyhtgrfedwsqa}

Get basic attributes

.EXAMPLE
Get-TppIdentityAttribute -IdentityId 'AD+blah:{1234567890olikujyhtgrfedwsqa}' -Attribute 'Surname'
Identity                              Attribute
-------------------                     ---------
AD+blah:1234567890olikujyhtgrfedwsqa     @{Surname=Brownstein}

Get specific attribute for user

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppIdentityAttribute/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppIdentityAttribute.ps1

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Identity-Readattribute.php?tocpath=REST%20API%20reference%7CIdentity%20programming%20interfaces%7C_____7

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Identity-Validate.php?tocpath=REST%20API%20reference%7CIdentity%20programming%20interfaces%7C_____9

#>
function Get-TppIdentityAttribute {

    [CmdletBinding()]
    param (

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('PrefixedUniversalId', 'Contact')]
        [string[]] $IdentityId,

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

        foreach ( $thisId in $IdentityId ) {

            # if ( -not ($thisId | Test-TppIdentity -ExistOnly -TppSession $TppSession) ) {
            #     Write-Error ('The id, {0}, does not exist' -f $thisId)
            #     continue
            # }

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
                IdentityId = $thisId
                Attributes = $attribsOut
            }
        }
    }
}
