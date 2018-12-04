<#
.SYNOPSIS
Get object by path

.DESCRIPTION
Get object by path

.PARAMETER Path
The full path to the object

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Path

.OUTPUTS
TppObject

.EXAMPLE
Get-TppObject -Path '\VED\Policy\My object'

Get an object by full path

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppObject/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppObject.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-enumerate.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____13

#>
function Get-TppObject {

    [CmdletBinding()]
    [OutputType( [TppObject] )]

    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('DN')]
        [String] $Path,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'config/enumerate'
            Body       = @{
                'ObjectDN' = ''
                'Pattern'  = ''
            }
        }
    }

    process {

        $params.Body.ObjectDN = Split-Path $Path -Parent
        $params.Body.Pattern = Split-Path $Path -Leaf

        $response = Invoke-TppRestMethod @params

        if ( $response.Result -eq [ConfigResult]::Success ) {
            $objects = $response.Objects
        }
        else {
            Write-Error $response.Error
        }

        foreach ($object in $objects) {
            [TppObject] @{
                Name     = $object.Name
                TypeName = $object.TypeName
                Path     = $object.DN
                Guid     = $object.Guid
            }
        }
    }
}