# Get-TppLog

## SYNOPSIS
Get the TPP log

## SYNTAX

```
Get-TppLog [[-Limit] <Int32>] [[-TppSession] <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Get the Tpp log, with the ability to filter in a variety of ways.

## EXAMPLES

### EXAMPLE 1
```
Get-TppLog -Limit 10
```

Get the most recent 10 log items

## PARAMETERS

### -Limit
Specify the number of items to retrieve, starting with most recent

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
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
Position: 2
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

## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppLog/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppLog/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppLog.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppLog.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Log.php?tocpath=REST%20API%20reference%7CLog%20programming%20interfaces%7C_____1](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Log.php?tocpath=REST%20API%20reference%7CLog%20programming%20interfaces%7C_____1)

