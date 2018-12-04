<#
.SYNOPSIS
Get attribute values for TPP identity objects

.DESCRIPTION
Get attribute values for TPP identity objects.

.PARAMETER PrefixedUniversalId
The id that represents the user or group.  Use Find-TppIdentity to get the id.

.PARAMETER Attribute
Retrieve identity attribute values for the users and groups.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
PrefixedUniversalId

.OUTPUTS
PSCustomObject with the properties PrefixedUniversalId and Attribute

.EXAMPLE
Get-TppIdentityAttribute -PrefixedUniversalId 'AD+mydomain.com:1234567890olikujyhtgrfedwsqa' | format-list
PrefixedUniversalId : AD+mydomain.com:1234567890olikujyhtgrfedwsqa
Attribute           : @{FullName=CN=greg,OU=Users,DC=mydomain,DC=com; IsContainer=False; IsGroup=False; Name=greg; Prefix=AD+mydomain.com;
                      PrefixedName=AD+mydomain.com:greg; PrefixedUniversal=AD+mydomain.com:1234567890olikujyhtgrfedwsqa; Universal=1234567890olikujyhtgrfedwsqa}

Get basic attributes

.EXAMPLE
Get-TppIdentityAttribute -PrefixedUniversalId 'AD+mydomain.com:1234567890olikujyhtgrfedwsqa' -Attribute 'Surname'
PrefixedUniversalId                              Attribute
-------------------                              ---------
AD+mydomain.com:1234567890olikujyhtgrfedwsqa     @{Surname=Brownstein}

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
        [ValidateScript( {
                $_ -match '(AD|LDAP)+\S+:\w{32}$' -or $_ -match 'local:\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$'
            })]
        [Alias('PrefixedUniversal')]
        [string[]] $PrefixedUniversalId,

        [Parameter()]
        [string[]] $Attribute,

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

        $PrefixedUniversalId.ForEach{

            $thisId = $_

            if ( -not (Test-TppIdentity -PrefixedUniversalId $thisId -ExistOnly) ) {
                Write-Error "Id $thisId does not exist"
                Continue
            }

            $params.Body.ID.PrefixedUniversal = $thisId

            if ( $PSBoundParameters.ContainsKey('Attribute') ) {

                $attribHash = @{}

                $Attribute.ForEach{
                    $params.Body.AttributeName = $_

                    $response = Invoke-TppRestMethod @params

                    $attribHash.Add($_, $response.Attributes[0])
                }

                $attribsOut = [PSCustomObject] $attribHash

            }
            else {
                $response = Invoke-TppRestMethod @params
                $attribsOut = $response.Id
            }

            [PSCustomObject] @{
                PrefixedUniversalId = $thisId
                Attributes          = $attribsOut
            }
        }
    }
}
