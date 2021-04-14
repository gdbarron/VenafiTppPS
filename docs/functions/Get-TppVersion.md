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

[https://github.com/gdbarron/VenafiTppPS/blob/main/VenafiTppPS/Code/Public/Get-TppVersion.ps1](https://github.com/gdbarron/VenafiTppPS/blob/main/VenafiTppPS/Code/Public/Get-TppVersion.ps1)

[https://docs.venafi.com/Docs/20.4SDK/TopNav/Content/SDK/WebSDK/r-SDK-GET-SystemStatusVersion.php?tocpath=Web%20SDK%7CSystemStatus%20programming%20interface%7C_____9](https://docs.venafi.com/Docs/20.4SDK/TopNav/Content/SDK/WebSDK/r-SDK-GET-SystemStatusVersion.php?tocpath=Web%20SDK%7CSystemStatus%20programming%20interface%7C_____9)

