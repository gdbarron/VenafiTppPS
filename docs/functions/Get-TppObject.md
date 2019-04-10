# Get-TppObject

## SYNOPSIS
Get object by path

## SYNTAX

```
Get-TppObject [-Path] <String> [[-TppSession] <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Get object by path

## EXAMPLES

### EXAMPLE 1
```
Get-TppObject -Path '\VED\Policy\My object'
```

Get an object by full path

## PARAMETERS

### -Path
The full path to the object

```yaml
Type: String
Parameter Sets: (All)
Aliases: DN

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Path
## OUTPUTS

### TppObject
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppObject/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppObject/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppObject.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppObject.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-enumerate.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____13](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-enumerate.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____13)

