# Get-TppVersion

## SYNOPSIS
Get the TPP version

## SYNTAX

```
Get-TppVersion [[-TppSession] <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Returns the TPP version

## EXAMPLES

### EXAMPLE 1
```
Get-TppVersion
```

Get the version

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### none
## OUTPUTS

### Version
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppVersion/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppVersion/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppVersion.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppVersion.ps1)

[https://docs.venafi.com/Docs/18.4SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-SystemStatusVersion.php?tocpath=REST%20API%20reference%7CSystemStatus%20programming%20interfaces%7C_____2](https://docs.venafi.com/Docs/18.4SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-SystemStatusVersion.php?tocpath=REST%20API%20reference%7CSystemStatus%20programming%20interfaces%7C_____2)

