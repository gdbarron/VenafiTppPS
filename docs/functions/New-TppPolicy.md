# New-TppPolicy

## SYNOPSIS
Add a new policy folder

## SYNTAX

```
New-TppPolicy [-Path] <String> [[-Description] <String>] [-PassThru] [[-TppSession] <TppSession>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Add a new policy folder

## EXAMPLES

### EXAMPLE 1
```
$newPolicy = New-TppPolicy -Path '\VED\Policy\Existing Policy Folder\New Policy Folder' -PassThru
```

Create policy returning the policy object created

### EXAMPLE 2
```
New-TppPolicy -Path '\VED\Policy\Existing Policy Folder\New Policy Folder' -Description 'this is awesome'
```

Create policy with description

## PARAMETERS

### -Path
DN path to the new policy

```yaml
Type: String
Parameter Sets: (All)
Aliases: PolicyDN

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### -PassThru
Return a TppObject representing the newly created policy.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Path
## OUTPUTS

### TppObject, if PassThru provided
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppPolicy/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppPolicy/)

[https://github.com/gdbarron/VenafiTppPS/blob/main/VenafiTppPS/Code/Public/New-TppPolicy.ps1](https://github.com/gdbarron/VenafiTppPS/blob/main/VenafiTppPS/Code/Public/New-TppPolicy.ps1)

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppObject/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppObject/)

[https://github.com/gdbarron/VenafiTppPS/blob/main/VenafiTppPS/Code/Public/New-TppObject.ps1](https://github.com/gdbarron/VenafiTppPS/blob/main/VenafiTppPS/Code/Public/New-TppObject.ps1)

