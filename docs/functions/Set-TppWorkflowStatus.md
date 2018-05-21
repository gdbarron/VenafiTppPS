# Set-TppWorkflowStatus

## SYNOPSIS
Get details about workflow tickets

## SYNTAX

### DN
```
Set-TppWorkflowStatus -CertificateDN <String[]> -Status <String> [-Explanation <String>]
 [-ScheduledStart <DateTime>] [-ScheduledStop <DateTime>] [-TppSession <TppSession>] [<CommonParameters>]
```

### Guid
```
Set-TppWorkflowStatus -Guid <Guid[]> -Status <String> [-Explanation <String>] [-ScheduledStart <DateTime>]
 [-ScheduledStop <DateTime>] [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Get details about workflow tickets via a certificate DN or a ticket GUID directly

## EXAMPLES

### EXAMPLE 1
```
Get-TppWorkflowDetail -DN '\VED\myapp.company.com'
```

Get details for 1 certificate

### EXAMPLE 2
```
$certs | Get-TppWorkflowDetail
```

Get ticket details for multiple certificates

## PARAMETERS

### -CertificateDN
{{Fill CertificateDN Description}}

```yaml
Type: String[]
Parameter Sets: DN
Aliases: DN

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Guid
Guid representing a unique ticket

```yaml
Type: Guid[]
Parameter Sets: Guid
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Status
{{Fill Status Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Explanation
{{Fill Explanation Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduledStart
{{Fill ScheduledStart Description}}

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduledStop
{{Fill ScheduledStop Description}}

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TppSession
Session object created from New-TppSession method. 
The value defaults to the script session object $TppSession.

```yaml
Type: TppSession
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:TppSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### DN

## OUTPUTS

### PSCustomObject with the following properties:
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

## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppWorkflowDetail/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppWorkflowDetail/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppWorkflowDetail.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppWorkflowDetail.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Workflow-ticket-enumerate.php?tocpath=REST%20API%20reference%7CWorkflow%20Ticket%20programming%20interfaces%7C_____6](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Workflow-ticket-enumerate.php?tocpath=REST%20API%20reference%7CWorkflow%20Ticket%20programming%20interfaces%7C_____6)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Workflow-ticket-details.php?tocpath=REST%20API%20reference%7CWorkflow%20Ticket%20programming%20interfaces%7C_____5](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Workflow-ticket-details.php?tocpath=REST%20API%20reference%7CWorkflow%20Ticket%20programming%20interfaces%7C_____5)

