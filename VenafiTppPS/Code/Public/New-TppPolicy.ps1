<#
.SYNOPSIS
Add a new policy folder

.DESCRIPTION
Add a new policy folder

.PARAMETER Path
DN path to the new policy

.PARAMETER Description
Policy description

.PARAMETER PassThru
Return a TppObject representing the newly created policy.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS
TppObject, if PassThru provided

.EXAMPLE
$newPolicy = New-TppPolicy -Path '\VED\Policy\Existing Policy Folder\New Policy Folder' -PassThru
Create policy returning the policy object created

.EXAMPLE
New-TppPolicy -Path '\VED\Policy\Existing Policy Folder\New Policy Folder' -Description 'this is awesome'
Create policy with description

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppPolicy/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppPolicy.ps1

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppObject/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppObject.ps1

#>
function New-TppPolicy {

    [CmdletBinding()]
    [OutputType( [TppObject] )]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('PolicyDN')]
        [string] $Path,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String] $Description,

        [Parameter()]
        [switch] $PassThru,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    $params = @{
        Path     = $Path
        Class    = 'Policy'
        PassThru = $true
    }

    if ( $Description ) {
        $params.Add('Attribute', @{'Description' = $Description})
    }

    $response = New-TppObject @params

    if ( $PassThru ) {
        $response
    }

}
