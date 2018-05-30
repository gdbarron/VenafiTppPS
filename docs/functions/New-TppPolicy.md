# New-TppPolicy

## SYNOPSIS
Add a new policy folder

## SYNTAX

```
New-TppPolicy [-PolicyDN] <String> [[-Description] <String>] [[-TppSession] <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Add a new policy folder

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -PolicyDN
DN path to the new policy

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Policy description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
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

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppPolicy/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppPolicy/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppPolicy.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppPolicy.ps1)

