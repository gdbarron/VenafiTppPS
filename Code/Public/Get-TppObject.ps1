<#
.SYNOPSIS 
Find objects which match the pattern.  Optionally, you can limit matching the pattern to certain attributes.

.DESCRIPTION

.PARAMETER Pattern

.PARAMETER AttributeNames

.PARAMETER VenafiSession
Session object created from New-VenafiSession method.  The value defaults to the script session object $VenafiSession.

.OUTPUTS

.EXAMPLE
Find all certificates with a specific common name
Get-VenafiObjectsByPattern -VenafiSession $sess -Pattern 'mysite.com' -AttributeNames 'X509 Subject'

#>
function Get-TppObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'FindByClass')]
        [ValidateNotNullOrEmpty()]
        [String] $Class,

        [Parameter(Mandatory, ParameterSetName = 'FindByClasses')]
        [ValidateNotNullOrEmpty()]
        [String[]] $Classes,

        [Parameter(Mandatory, ParameterSetName = 'Find')]
        [Parameter(ParameterSetName = 'FindByClass')]
        [Parameter(ParameterSetName = 'FindByClasses')]
        [ValidateNotNullOrEmpty()]
        [String] $Pattern,

        [Parameter(ParameterSetName = 'Find')]
        [ValidateNotNullOrEmpty()]
        [String[]] $AttributeNames,

        [Parameter(ParameterSetName = 'FindByClass')]
        [ValidateNotNullOrEmpty()]
        [String] $DN,
        
        [Parameter(ParameterSetName = 'FindByClass')]
        [Switch] $Recursive,
        
        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    Switch ($PsCmdlet.ParameterSetName)	{
        'Find' {
            $params = @{
                TppSession = $TppSession
                Method     = 'Post'
                UriLeaf    = 'config/find'
                Body       = @{
                    Pattern = $Pattern
                }
            }

            if ( $AttributeNames ) {
                $params.body += @{
                    AttributeNames = $AttributeNames
                }
            }

        }

        {$_ -in 'FindByClass', 'FindByClasses'} {
            $params = @{
                TppSession = $TppSession
                Method     = 'Post'
                UriLeaf    = 'config/FindObjectsOfClass'
            }

            if ( $Class ) {
                $body = @{Class = $Class}
            } else {
                $body = @{Classes = $Classes}
            }

            $params += @{
                Body = $body
            }

            if ( $Pattern ) {
                $params.body += @{
                    Pattern = $Pattern
                }
            }

            if ( $DN ) {
                $params.body += @{
                    ObjectDN = $DN
                }
            }

            if ( $Recursive ) {
                $params.body += @{
                    AttributeNames = $AttributeNames
                }
            }

        }
            
    }

    $response = Invoke-TppRestMethod @params

    if ( $response.Result -eq [ConfigResult]::Success ) {
        $response.Objects
    } else {
        throw $response.Error
    }

}