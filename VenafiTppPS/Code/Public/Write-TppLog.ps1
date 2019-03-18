<#
.SYNOPSIS
Write entries to the TPP log

.DESCRIPTION
Write entries to the TPP Default SQL Channel log.  Requires an event group and event.
Default and custom event groups are supported.

.PARAMETER EventGroup
Default event group.

.PARAMETER CustomEventGroup
Custom Event Group ID, 4 characters.

.PARAMETER EventId
Event ID from within the EventGroup or CustomEventGroup provided.  Only provide the 4 character event id, do not precede with group ID.

.PARAMETER Component
The item this event is associated with.  Typically, this is the Path (DN) of the object.

.PARAMETER Severity
Severity of the event

.PARAMETER SourceIp
The IP that originated the event

.PARAMETER ComponentID
Component ID that originated the event

.PARAMETER ComponentSubsystem
Component subsystem that originated the event

.PARAMETER Text1
String data to write to log.  See link for event ID messages for more info.

.PARAMETER Text2
String data to write to log.  See link for event ID messages for more info.

.PARAMETER Value1
Integer data to write to log.  See link for event ID messages for more info.

.PARAMETER Value2
Integer data to write to log.  See link for event ID messages for more info.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS
none

.EXAMPLE
Write-TppLog -EventGroup WebSDKRESTAPI -EventId '0001' -Component '\ved\policy\mycert.com'

Log an event to a default group

.EXAMPLE
Write-TppLog -EventGroup '0200' -EventId '0001' -Component '\ved\policy\mycert.com'

Log an event to a custom group

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Write-TppLog/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Write-TppLog.ps1

.LINK
https://docs.venafi.com/Docs/18.4SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Log.php?tocpath=REST%20API%20reference%7CLog%20programming%20interfaces%7C_____2

.LINK
https://support.venafi.com/hc/en-us/articles/360003460191-Info-Venafi-Trust-Protection-Platform-Event-ID-Messages-For-All-18-X-Releases

#>
function Write-TppLog {
    [CmdletBinding(DefaultParameterSetName = 'DefaultGroup')]
    param (

        [Parameter(Mandatory, ParameterSetName = 'DefaultGroup')]
        [TppEventGroup] $EventGroup,

        [Parameter(Mandatory, ParameterSetName = 'CustomGroup')]
        [ValidateLength(4, 4)]
        [string] $CustomEventGroup,

        [Parameter(Mandatory)]
        [ValidateLength(4, 4)]
        [string] $EventId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $Component,

        [Parameter()]
        [TppEventSeverity] $Severity,

        [Parameter()]
        [ipaddress] $SourceIp,

        [Parameter()]
        [int] $ComponentID,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $ComponentSubsystem,

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
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    if ( $PSCmdlet.ParameterSetName -eq 'DefaultGroup' ) {
        $thisEventGroup = $TppEventGroupHash.($EventGroup.ToString())
    }
    else {
        $thisEventGroup = $CustomEventGroup
    }

    # the event id is the group id coupled with the event id
    $fullEventId = "$thisEventGroup$EventId"

    # convert the hex based eventid to decimal equivalent
    $decEventId = [System.Convert]::ToInt64($fullEventId, 16)

    $params = @{
        TppSession = $TppSession
        Method     = 'Post'
        UriLeaf    = 'Log'
        Body       = @{
            GroupID   = $thisEventGroup
            ID        = $decEventId
            Component = $Component
        }
    }

    if ( $PSBoundParameters.ContainsKey('Severity') ) {
        $params.Body.Add('Severity', [TppEventSeverity]::$Severity)
    }

    if ( $PSBoundParameters.ContainsKey('SourceIp') ) {
        $params.Body.Add('SourceIp', $SourceIp.ToString())
    }

    if ( $PSBoundParameters.ContainsKey('ComponentID') ) {
        $params.Body.Add('ComponentID', $ComponentID)
    }

    if ( $PSBoundParameters.ContainsKey('ComponentSubsystem') ) {
        $params.Body.Add('ComponentSubsystem', $ComponentSubsystem)
    }

    if ( $PSBoundParameters.ContainsKey('Text1') ) {
        $params.Body.Add('Text1', $Text1)
    }

    if ( $PSBoundParameters.ContainsKey('Text2') ) {
        $params.Body.Add('Text2', $Text2)
    }

    if ( $PSBoundParameters.ContainsKey('Value1') ) {
        $params.Body.Add('Value1', $Value1)
    }

    if ( $PSBoundParameters.ContainsKey('Value2') ) {
        $params.Body.Add('Value2', $Value2)
    }

    $response = Invoke-TppRestMethod @params

    if ( $response.LogResult -eq 1 ) {
        throw "Writing to the TPP log failed.  Ensure you have View permission and Read permission to the default SQL channel object."
    }

}