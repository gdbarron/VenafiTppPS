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
function ConvertTo-TppDN {
    [CmdletBinding(DefaultParameterSetName = 'Guid')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Guid', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String] $Guid,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {

        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'config/GuidToDN'
            Body       = @{
                ObjectGUID = ''
            }
        }
    }

    process {

        foreach ( $thisGuid in $Guid ) {

            $params.Body['ObjectGUID'] = $thisGuid
            $response = Invoke-TppRestMethod @params

            if ( $response.Result -eq [ConfigResult]::Success ) {
                $response.ObjectDN
            } else {
                throw $response.Error
            }
        }
    }
}