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
        DN        = $PolicyDN
        Class     = 'Policy'
        Attribute = @( )
    }
        
    if ( $Description ) {
        $params.Attribute += @{
            Name  = 'Description'
            Value = $Description
        }
    }

    New-TppObject @params

}
