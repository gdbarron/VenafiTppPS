<#
.SYNOPSIS 
Convert GUID to DN

.DESCRIPTION
Convert GUID to DN

.PARAMETER Guid
Standard guid, xyxyxyxy-xyxy-xyxy-xyxy-xyxyxyxyxyxy

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Guid

.OUTPUTS
String representing the DN

.EXAMPLE
ConvertTo-TppDN -Guid 'xyxyxyxy-xyxy-xyxy-xyxy-xyxyxyxyxyxy'

#>
function ConvertTo-TppDN {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Guid[]] $Guid,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {

        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'config/GuidToDN'
            Body       = @{ }
        }
    }

    process {

        foreach ( $thisGuid in $Guid ) {

            $params.Body = @{
                ObjectGUID = "{$thisGuid}"
            }
            
            $response = Invoke-TppRestMethod @params

            if ( $response.Result -eq [ConfigResult]::Success ) {
                $response.ObjectDN
            } else {
                throw $response.Error
            }
        }
    }
}