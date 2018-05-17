# Get-TppAttribute

## SYNOPSIS
Get attributes for a given object

## SYNTAX

### NonEffectivePolicy
```
Get-TppAttribute -DN <String[]> [-AttributeName <String[]>] [-TppSession <TppSession>] [<CommonParameters>]
```

### EffectivePolicy
```
Get-TppAttribute -DN <String[]> -AttributeName <String[]> [-EffectivePolicy] [-TppSession <TppSession>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves object attributes. 
You can either retrieve all attributes or individual ones.
By default, the attributes returned are not the effective policy, but that can be requested with the
EffectivePolicy switch.

## EXAMPLES

### EXAMPLE 1
```
Get-TppAttribute -DN '\VED\Policy\My Folder\myapp.company.com'
```

Retrieve all configurations for a certificate

### EXAMPLE 2
```
Get-TppAttribute -DN '\VED\Policy\My Folder\myapp.company.com' -EffectivePolicy
```

Retrieve all effective configurations for a certificate

### EXAMPLE 3
```
Get-TppAttribute -DN '\VED\Policy\My Folder\myapp.company.com' -AttributeName 'driver name'
```

Retrieve all effective configurations for a certificate

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

### DN by property name

## OUTPUTS

### PSCustomObject with properties DN and Config.
    DN, path provided to the function
    Attribute, PSCustomObject with the following properties:
        Name
        Values
        IsCustomField

## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppAttribute/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppAttribute/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppAttribute.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppAttribute.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-read.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____26](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-read.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____26)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-readall.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____27](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-readall.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____27)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-readeffectivepolicy.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____30](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-readeffectivepolicy.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____30)

