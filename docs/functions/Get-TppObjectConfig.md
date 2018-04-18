# Get-TppObjectConfig

## SYNOPSIS
Get attributes for a given object

## SYNTAX

### NonEffectivePolicy
```
Get-TppObjectConfig -DN <String[]> [-AttributeName <String[]>] [-TppSession <TppSession>] [<CommonParameters>]
```

### EffectivePolicy
```
Get-TppObjectConfig -DN <String[]> -AttributeName <String[]> [-EffectivePolicy] [-TppSession <TppSession>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves objectâ€™s attributes. 
You can either retrieve all attributes or individual ones.
By default, the attributes returned are not the effective policy, but that can be requested with the
EffectivePolicy switch.

## EXAMPLES

### EXAMPLE 1
```

```

## PARAMETERS

### -DN
Path to the object to retrieve configuration attributes. 
Just providing DN will return all attributes.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AttributeName
Only retrieve the value/values for this attribute

```yaml
Type: String[]
Parameter Sets: NonEffectivePolicy
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String[]
Parameter Sets: EffectivePolicy
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EffectivePolicy
Get the effective policy of the attribute

```yaml
Type: SwitchParameter
Parameter Sets: EffectivePolicy
Aliases:

Required: True
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

## NOTES

## RELATED LINKS
