<#
.SYNOPSIS 
Convert GUID to DN

.DESCRIPTION
Convert GUID to DN

.PARAMETER Guid
Standard guid including { and }

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Guid

.OUTPUTS
System.String

.EXAMPLE

#>
function ConvertTo-TppDN {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ -match "^{[A-Z0-9]{8}-([A-Z0-9]{4}-){3}[A-Z0-9]{12}}$" ) {
                    $true
                } else {
                    throw "'$_' is not a valid GUID"
                }
            })]
        [String[]] $Guid,

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