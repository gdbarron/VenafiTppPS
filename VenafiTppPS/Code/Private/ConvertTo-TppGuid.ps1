<#
.SYNOPSIS
Convert DN path to GUID

.DESCRIPTION
Convert DN path to GUID

.PARAMETER Path
DN path representing an object

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Path

.OUTPUTS
Guid

.EXAMPLE
ConvertTo-TppGuid -Guid 'xyxyxyxy-xyxy-xyxy-xyxy-xyxyxyxyxyxy'

#>
function ConvertTo-TppGuid {

    [CmdletBinding()]
    [OutputType( [System.Guid] )]

    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
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
        [switch] $IncludeType,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {

        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'config/DnToGuid'
        }
    }

    process {

        $params.Add('Body', @{
                ObjectDN = $Path
            }
        )

        $response = Invoke-TppRestMethod @params

        if ( $response.Result -eq [ConfigResult]::Success ) {
            if ( $PSBoundParameters.ContainsKey('IncludeType') ) {
                [PSCustomObject] @{
                    Guid     = [Guid] $response.Guid
                    TypeName = $response.ClassName
                }
            }
            else {
                [Guid] $response.Guid
            }
        }
        else {
            throw $response.Error
        }
    }
}