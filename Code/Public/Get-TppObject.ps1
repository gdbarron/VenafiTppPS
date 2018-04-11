<#
.SYNOPSIS 
Find objects by class or pattern

.DESCRIPTION

.PARAMETER Class

.PARAMETER Classes

.PARAMETER Pattern

.PARAMETER AttributeName

.PARAMETER DN

.PARAMETER Recursive

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS

.EXAMPLE

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
        [String[]] $AttributeName,

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

            if ( $AttributeName ) {
                $params.body += @{
                    AttributeNames = $AttributeName
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