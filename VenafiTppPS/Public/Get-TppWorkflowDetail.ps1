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
function Get-TppWorkflowDetail {

    [CmdletBinding()]
    param (
        
        [Parameter(Mandatory, ParameterSetName = 'DN', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                # this regex could be better
                if ( $_ -match "^\\VED\\.*" ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN"
                }
            })]
        [String[]] $DN,

        [Parameter(Mandatory, ParameterSetName = 'Guid')]
        [ValidateNotNullOrEmpty()]
        [Guid[]] $Guid,
        
        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        Write-Warning "WORK IN PROGRESS"
        $TppSession.Validate()
    }

    process {
        
        Switch ($PsCmdlet.ParameterSetName)	{
            'DN' {
                $Guid = foreach ($thisDn in $DN) {
            
                    # if a guid wasn't provided, go get the existing ones
                    $params = @{
                        TppSession = $TppSession
                        Method     = 'Post'
                        UriLeaf    = 'Workflow/Ticket/Enumerate'
                        Body       = @{
                            'ObjectDN' = $thisDn
                        }
                    }
                
                    $response = Invoke-TppRestMethod @params
                
                    if ( $response ) {
                        $response.GUIDs
                    }
                }
            }
        } 

        foreach ($thisGuid in $Guid) {
            $params = @{
                TppSession = $TppSession
                Method     = 'Post'
                UriLeaf    = 'Workflow/Ticket/Details'
                Body       = @{
                    'GUID' = $thisGuid
                }
            }
                
            $response = Invoke-TppRestMethod @params
            
            if ( $response.Result -eq [WorkflowResult]::Success ) {
                $response
            } else {
                throw ("Error getting ticket details, error is {0}" -f [enum]::GetName([WorkflowResult], $response.Result))
            }
        }
    }
}
