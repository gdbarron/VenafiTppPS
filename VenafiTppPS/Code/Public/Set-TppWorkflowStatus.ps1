<#
.SYNOPSIS
Get details about workflow tickets

.DESCRIPTION
Get details about workflow tickets via a certificate DN or a ticket GUID directly

.PARAMETER DN
Path to the certificate

.PARAMETER Guid
Guid representing a unique ticket

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
DN

.OUTPUTS
PSCustomObject with the following properties:
    ApprovalExplanation: The explanation supplied by the approver.
    ApprovalFrom: The identity to be contacted for approving.
    ApprovalReason: The administrator-defined reason text.
    Approvers: An array of workflow approvers for the certificate.
    Blocking: The object that the ticket is associated with.
    Created: The date/time the ticket was created.
    IssuedDueTo: The workflow object that caused this ticket to be created (if any).
    Result: Integer result code indicating success 1 or failure. For more information, see Workflow result codes.
    Status: The status of the ticket.
    Updated: The date/time that the ticket was last updated.

.EXAMPLE
Get-TppWorkflowDetail -DN '\VED\myapp.company.com'
Get details for 1 certificate

.EXAMPLE
$certs | Get-TppWorkflowDetail
Get ticket details for multiple certificates

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppWorkflowDetail/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppWorkflowDetail.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Workflow-ticket-enumerate.php?tocpath=REST%20API%20reference%7CWorkflow%20Ticket%20programming%20interfaces%7C_____6

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Workflow-ticket-details.php?tocpath=REST%20API%20reference%7CWorkflow%20Ticket%20programming%20interfaces%7C_____5

#>
function Set-TppWorkflowStatus {

    [CmdletBinding()]
    param (

        [Parameter(Mandatory, ParameterSetName = 'DN', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('DN')]
        [String[]] $CertificateDN,

        [Parameter(Mandatory, ParameterSetName = 'Guid', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Guid[]] $Guid,

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

        Switch ($PsCmdlet.ParameterSetName)	{
            'DN' {
                $Guid = foreach ($thisDn in $DN) {
                    $thisDn | Get-TppWorkflowDetail
                }
            }
        }

        foreach ($thisGuid in $Guid) {
            $params = @{
                TppSession = $TppSession
                Method     = 'Post'
                UriLeaf    = 'Workflow/Ticket/UpdateStatus'
                Body       = @{
                    'GUID' = $thisGuid
                }
            }

            $response = Invoke-TppRestMethod @params

            if ( -not ($response.Result -eq [WorkflowResult]::Success) ) {
                throw ("Error setting workflow ticket status, error is {0}" -f [enum]::GetName([WorkflowResult], $response.Result))
            }
        }
    }
}
