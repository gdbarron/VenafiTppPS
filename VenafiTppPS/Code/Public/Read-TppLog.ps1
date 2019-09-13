<#
.SYNOPSIS
Read entries from the TPP log

.DESCRIPTION
Read entries from the TPP log

.PARAMETER InputObject
TppObject which represents a unique object to search for related records

.PARAMETER Path
Path to search for related records

.PARAMETER Severity
Filter records by severity

.PARAMETER StartTime
Start time of events

.PARAMETER EndTime
End time of events

.PARAMETER Text1
Filter matching results of Text1

.PARAMETER Text2
Filter matching results of Text2

.PARAMETER Value1
Filter matching results of Value1

.PARAMETER Value2
Filter matching results of Value2

.PARAMETER Limit
Specify the number of items to retrieve, starting with most recent.  The default is 100 and there is no maximum.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
InputObject

.OUTPUTS
PSCustomObject with properties:
    ClientTimestamp
    Component
    ComponentId
    ComponentSubsystem
    Data
    Grouping
    Id
    Name
    ServerTimestamp
    Severity
    SourceIP
    Text1
    Text2
    Value1
    Value2

.EXAMPLE
Read-TppLog -Limit 10
Get the most recent 10 log items

.EXAMPLE
$capiObject | Read-TppLog
Find all events for a specific object

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Read-TppLog/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Read-TppLog.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Log.php?tocpath=REST%20API%20reference%7CLog%20programming%20interfaces%7C_____1

#>
function Read-TppLog {
    [CmdletBinding(DefaultParameterSetName = 'ByObject')]
    param (
        [Parameter(ValueFromPipeline, ParameterSetName = 'ByObject')]
        [TppObject] $InputObject,

        [Parameter(ParameterSetName = 'ByPath')]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('DN')]
        [string] $Path,

        [Parameter()]
        [TppEventSeverity] $Severity,

        [Parameter()]
        [DateTime] $StartTime,

        [Parameter()]
        [DateTime] $EndTime,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Text1,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Text2,

        [Parameter()]
        [int] $Value1,

        [Parameter()]
        [int] $Value2,

        [Parameter()]
        [Int] $Limit,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    $params = @{
        TppSession = $TppSession
        Method     = 'Get'
        UriLeaf    = 'Log'
        Body       = @{ }
    }

    switch ($PSBoundParameters.Keys) {
        'InputObject' {
            $params.Body.Add('Component', $InputObject.Path)
        }

        'Path' {
            $params.Body.Add('Component', $Path)
        }

        'Severity' {
            $params.Body.Add('Severity', $Severity)
        }

        'StartTime' {
            $params.Body.Add('FromTime', ($StartTime | ConvertTo-UtcIso8601) )
        }

        'EndTime' {
            $params.Body.Add('ToTime', ($EndTime | ConvertTo-UtcIso8601) )
        }

        'Text1' {
            $params.Body.Add('Text1', $Text1)
        }

        'Text2' {
            $params.Body.Add('Text2', $Text2)
        }

        'Value1' {
            $params.Body.Add('Value1', $Value1)
        }

        'Value2' {
            $params.Body.Add('Value2', $Value2)
        }

        'Limit' {
            $params.Body.Add('Limit', $Limit)
        }
    }

    Invoke-TppRestMethod @params | Select-Object -ExpandProperty LogEvents

}