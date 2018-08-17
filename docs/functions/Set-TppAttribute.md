# Set-TppAttribute

## SYNOPSIS
Adds a value to an attribute

## SYNTAX

```
Set-TppAttribute [-DN] <String[]> [-AttributeName] <String> [-Value] <String[]> [-NoClobber]
 [[-TppSession] <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Write a value to the object's configuration. 
This function will append by default. 
Attributes can have multiple values which may not be the intended use. 
To ensure you only have one value for an attribute, use the Overwrite switch.

## EXAMPLES

### EXAMPLE 1
```
Set-TppAttribute -DN '\VED\Policy\My Folder\app.company.com -AttributeName 'My custom field Label' -Value 'new custom value'
```

Set value on custom field. 
This will add to any existing value.

### EXAMPLE 2
```
Set-TppAttribute -DN '\VED\Policy\My Folder\app.company.com -AttributeName 'Consumers' -Value '\VED\Policy\myappobject.company.com' -Overwrite
```

Set value on a certificate by overwriting any existing values

## PARAMETERS

### -DN
{{Fill DN Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AttributeName
Name of the attribute to modify. 
If modifying a custom field, use the Label.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Value or list of values to write to the attribute.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoClobber
Append existing values as opposed to replacing which is the default

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
Position: 4
Default value: $Script:TppSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[] for DN
## OUTPUTS

### PSCustomObject with the following properties:
###     DN = path to object
###     Success = boolean indicating success or failure
###     Error = Error message in case of failure
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Set-TppAttribute/](http://venafitppps.readthedocs.io/en/latest/functions/Set-TppAttribute/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Set-TppAttribute.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Set-TppAttribute.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-addvalue.php?tocpath=REST%20API%20reference%7CConfig%20programming%20interfaces%7C_____4](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-addvalue.php?tocpath=REST%20API%20reference%7CConfig%20programming%20interfaces%7C_____4)

