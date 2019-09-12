<#
.SYNOPSIS
Set workflow ticket status

.DESCRIPTION
Set workflow ticket status for a certificate

.PARAMETER TicketGuid
Guid representing a unique ticket

.PARAMETER Status
The new status to assign to the ticket.
Possible values include "Pending", "Approved", "Approved After", "Approved Between", and "Rejected".

.PARAMETER Explanation
Explanation for the status change

.PARAMETER ScheduledStart
Specifies the time after which the ticket should be processed.
ScheduledStart must be specified when the "Approved After" or "Approved Between" statuses are set

.PARAMETER ScheduledStop
Specifies the time before which the ticket should be processed.
ScheduledStop must be specified when the "Approved Between" status is set

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
TicketGuid

.OUTPUTS
None

.EXAMPLE
Get-TppWorkflowTicket -Path '\VED\policy\myapp.company.com' | Set-TppWorkflowTicketStatus -Status Approved
Approve all tickets for a certificate

.EXAMPLE
Get-TppWorkflowTicket -Path '\VED\policy\myapp.company.com' | Set-TppWorkflowTicketStatus -Status 'Approved After' -ScheduledStart (Get-Date).AaaDays(3) -Explanation 'weekend upgrade'
Approve all tickets for a certificate after a certain date with an explanation

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Set-TppWorkflowTicketStatus/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Set-TppWorkflowTicketStatus.ps1

.LINK
https://docs.venafi.com/Docs/18.3SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Workflow-ticket-updatestatus.php?tocpath=REST%20API%20reference%7CWorkflow%20Ticket%20programming%20interfaces%7C_____9

#>
function Set-TppWorkflowTicketStatus {

    [CmdletBinding()]
    param (

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Guid[]] $TicketGuid,

        [Parameter(Mandatory)]
        [ValidateSet('Pending', 'Approved', 'Approved After', 'Approved Between', 'Rejected')]
        [String] $Status,

        [Parameter()]
        [String] $Explanation,

        [Parameter()]
        [DateTime] $ScheduledStart,

        [Parameter()]
        [DateTime] $ScheduledStop,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {

        switch ($Status) {
            'Approved After' {
                if ( -not $ScheduledStart ) {
                    throw "A status of 'Approved After' requires a value for ScheduledStart"
                }
                if ( $ScheduledStop ) {
                    throw "Do not provide a scheduled stop with a status of 'Approved After'"
                }
            }
            'Approved Between' {
                if ( -not $ScheduledStart -or -not $ScheduledStop ) {
                    throw "A status of 'Approved Between' requires a value for ScheduledStart and ScheduledStop"
                }
            }
            Default {
            }
        }

        $TppSession.Validate()
    }

    process {

        foreach ($thisGuid in $TicketGuid) {
            $params = @{
                TppSession = $TppSession
                Method     = 'Post'
                UriLeaf    = 'Workflow/Ticket/UpdateStatus'
                Body       = @{
                    'GUID' = $thisGuid
                    'Status' = $Status
                }
            }

            if ( $PSBoundParameters.ContainsKey('Explanation') ) {
                $params.Body.Add('Explanation', $Explanation)
            }

            if ( $PSBoundParameters.ContainsKey('ScheduledStart') ) {
                $params.Body.Add( 'ScheduledStart', ($ScheduledStart | ConvertTo-UtcIso8601) )
            }

            if ( $PSBoundParameters.ContainsKey('ScheduledStop') ) {
                $params.Body.Add( 'ScheduledStop', ($ScheduledStop | ConvertTo-UtcIso8601) )
            }

            $response = Invoke-TppRestMethod @params

            if ( -not ($response.Result -eq [TppWorkflowResult]::Success) ) {
                throw ("Error setting workflow ticket status, error is {0}" -f [enum]::GetName([TppWorkflowResult], $response.Result))
            }
        }
    }
}
