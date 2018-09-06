<#
.SYNOPSIS
Get details about workflow tickets

.DESCRIPTION
Get details about workflow tickets via a certificate DN or a ticket GUID directly

.PARAMETER Path
Path to the certificate

.PARAMETER Guid
Guid representing a unique ticket

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
DN

.OUTPUTS
PSCustomObject with the following properties:
    Guid: Workflow ticket Guid
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
Get-TppWorkflowDetail -Path '\VED\myapp.company.com'
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

    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param (

        [Parameter(Mandatory, ParameterSetName = 'Path', ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('DN', 'CertificateDN')]
        [String[]] $Path,

        [Parameter(Mandatory, ParameterSetName = 'GUID')]
        [ValidateNotNullOrEmpty()]
        [Guid[]] $Guid,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()
    }

    process {

        Write-Verbose $PsCmdlet.ParameterSetName

        Switch ($PsCmdlet.ParameterSetName)	{
            'Path' {
                # DN was provided, go get the existing ticket guids
                $GuidToProcess = foreach ($thisDn in $Path) {

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

            'Guid' {
                $GuidToProcess = $Guid
            }
        }

        foreach ($thisGuid in $GuidToProcess) {
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
                $response | Add-Member @{
                    Guid = $thisGuid
                }
                $response
            } else {
                throw ("Error getting ticket details, error is {0}" -f [enum]::GetName([WorkflowResult], $response.Result))
            }
        }
    }
}