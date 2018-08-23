# Get-TppIdentity

## SYNOPSIS
Get identity details

## SYNTAX

### Browse (Default)
```
Get-TppIdentity -Name <String[]> [-Limit <Int32>] [-IncludeUsers] [-IncludeSecurityGroups]
 [-IncludeDistributionGroups] [-TppSession <TppSession>] [<CommonParameters>]
```

### Me
```
Get-TppIdentity [-Me] [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Returns information about individual identity, group identity, or distribution groups from a local or non-local provider such as Active Directory.
If no identity types are selected, all types will be included in the search.

## EXAMPLES

### EXAMPLE 1
```
Get-TppIdentity -Name 'greg' -IncludeUsers
```

FullName          : CN=Greg Brownstein,OU=My Group,DC=my,DC=company,DC=com
IsContainer       : False
IsGroup           : False
Name              : greg
Prefix            : AD+company.com
PrefixedName      : AD+company.com:greg
PrefixedUniversal : AD+company.com:1234567890asdfghjklmnbvcxz
Universal         : 1234567890asdfghjklmnbvcxz

Find user identities with the name greg

### EXAMPLE 2
```
Get-TppIdentity -Name 'greg'
```

Find all identity types with the name greg

### EXAMPLE 3
```
'greg', 'brownstein' | Get-TppIdentity
```

Find all identity types with the name greg and brownstein

### EXAMPLE 4
```
Get-TppIdentity -Me
```

Find authenticated user identity and all associated identities

## PARAMETERS

### -Name
The individual identity, group identity, or distribution group name to search for in the provider.
For non-local identity providers, such as AD and LDAP, use both the Filter and Limit parameters.

```yaml
Type: String[]
Parameter Sets: Browse
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Limit
Limit how many items are returned, the default is 100.

```yaml
Type: Int32
Parameter Sets: Browse
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeUsers
Include user identity type in search

```yaml
Type: SwitchParameter
Parameter Sets: Browse
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeSecurityGroups
Include security group identity type in search

```yaml
Type: SwitchParameter
Parameter Sets: Browse
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeDistributionGroups
Include distribution group identity type in search

```yaml
Type: SwitchParameter
Parameter Sets: Browse
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Me
Returns the identity of the authenticated user and all associated identities

```yaml
Type: SwitchParameter
Parameter Sets: Me
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

### Name
## OUTPUTS

### PSCustomObject with the following properties:
###     FullName
###     IsContainer
###     IsGroup
###     Name
###     Prefix
###     PrefixedName
###     PrefixedUniversal
###     Universal
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppIdentity/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppIdentity/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppIdentity.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppIdentity.ps1)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Identity-Browse.php?tocpath=REST%20API%20reference%7CIdentity%20programming%20interfaces%7C_____3](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Identity-Browse.php?tocpath=REST%20API%20reference%7CIdentity%20programming%20interfaces%7C_____3)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Identity-Self.php?tocpath=REST%20API%20reference%7CIdentity%20programming%20interfaces%7C_____8](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Identity-Self.php?tocpath=REST%20API%20reference%7CIdentity%20programming%20interfaces%7C_____8)

