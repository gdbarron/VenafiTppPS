# Get-TppSystemStatus

## SYNOPSIS
Get the TPP system status

## SYNTAX

```
Get-TppSystemStatus [[-TppSession] <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Returns service module statuses for Trust Protection Platform, Log Server, and Trust Protection Platform services that run on Microsoft Internet Information Services (IIS)

## EXAMPLES

### EXAMPLE 1
```
Get-TppSystemStatus
```

Get the status

## PARAMETERS

### -TppSession
Session object created from New-TppSession method. 
The value defaults to the script session object $TppSession.

```yaml
Type: TppSession
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:TppSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### none
## OUTPUTS

### PSCustomObject
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppSystemStatus/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppSystemStatus/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppSystemStatus.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppSystemStatus.ps1)

[https://docs.venafi.com/Docs/17.4SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-SystemStatus.php?tocpath=REST%20API%20reference%7CServiceStatus%20programming%20interfaces%7C_____1](https://docs.venafi.com/Docs/17.4SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-SystemStatus.php?tocpath=REST%20API%20reference%7CServiceStatus%20programming%20interfaces%7C_____1)

