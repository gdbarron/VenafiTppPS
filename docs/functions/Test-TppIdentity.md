# Test-TppIdentity

## SYNOPSIS
Test if an identity exists

## SYNTAX

```
Test-TppIdentity [-PrefixedUniversalId] <String[]> [-ExistOnly] [[-TppSession] <TppSession>]
 [<CommonParameters>]
```

## DESCRIPTION
Provided with a prefixed universal id, find out if an identity exists.

## EXAMPLES

### EXAMPLE 1
```
'local:78uhjny657890okjhhh', 'AD+mydomain.com:azsxdcfvgbhnjmlk09877654321' | Test-TppIdentity
```

Identity                                       Exists
--------                                       -----
local:78uhjny657890okjhhh                      True
AD+mydomain.com:azsxdcfvgbhnjmlk09877654321    False

Test multiple identities

### EXAMPLE 2
```
Test-TppIdentity -PrefixedUniversalId 'AD+mydomain.com:azsxdcfvgbhnjmlk09877654321' -ExistOnly
```

Retrieve existence for only one identity, returns boolean

## PARAMETERS

### -PrefixedUniversalId
The id that represents the user or group.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrefixedUniversal

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ExistOnly
Only return boolean instead of Identity and Exists list. 
Helpful when validating just 1 identity.

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
Position: 2
Default value: $Script:TppSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### PrefixedUniversalId
## OUTPUTS

### PSCustomObject will be returned with properties 'Identity', a System.String, and 'Exists', a System.Boolean.
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Test-TppIdentity/](http://venafitppps.readthedocs.io/en/latest/functions/Test-TppIdentity/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Test-TppIdentity.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Test-TppIdentity.ps1)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Identity-Validate.php?tocpath=REST%20API%20reference%7CIdentity%20programming%20interfaces%7C_____9](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Identity-Validate.php?tocpath=REST%20API%20reference%7CIdentity%20programming%20interfaces%7C_____9)

