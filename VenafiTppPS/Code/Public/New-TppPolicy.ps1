<#
.SYNOPSIS
Add a new policy folder

.DESCRIPTION
Add a new policy folder

.PARAMETER PolicyDN
DN path to the new policy

.PARAMETER Description
Policy description

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS
PSCustomObject with the following properties:
    AbsoluteGUID: The left-to-right concatenation of all of the GUIDs for all of the objects in the DN.
    DN: The Distinguished Name (DN) of the object, provided as PolicyDN
    GUID: The GUID that identifies the object.
    ID: The object identifier.
    Name: The Common Name (CN) of the object.
    Parent: The parent DN of the object.
    Revision: The revision of the object.
    TypeName: will always be Policy

.EXAMPLE
New-TppPolicy -PolicyDN '\VED\Policy\Existing Policy Folder\New Policy Folder' -Description 'this is awesome'

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppPolicy/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppPolicy.ps1

#>
function New-TppPolicy {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [string] $PolicyDN,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String] $Description,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    $params = @{
        DN    = $PolicyDN
        Class = 'Policy'
    }

    if ( $Description ) {
        $params += @{
            Attribute = @(
                @{
                    Name  = 'Description'
                    Value = $Description
                }
            )
        }
    }

    $response = New-TppObject @params

    if ( $response.Result -eq [ConfigResult]::Success ) {
        $response.Object
    } else {
        throw $response.Error
    }

}
