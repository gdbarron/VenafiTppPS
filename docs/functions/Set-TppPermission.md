# Set-TppPermission

## SYNOPSIS
Set permissions for TPP objects

## SYNTAX

```
Set-TppPermission [-Guid] <Guid[]> [-PrefixedUniversalId] <String[]> [-Permission] <TppPermission> [-Force]
 [[-TppSession] <TppSession>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Determine who has rights for TPP objects and what those rights are

## EXAMPLES

### EXAMPLE 1
```
Set-TppPermission -Guid '1234abcd-g6g6-h7h7-faaf-f50cd6610cba' -PrefixedUniversalId 'AD+mydomain.com:azsxdcfvgbhnjmlk09877654321' -Permission $TppPermObject
```

Permission a user on an object

## PARAMETERS

### -Guid
Guid representing a unique object

```yaml
Type: Guid[]
Parameter Sets: (All)
Aliases: ObjectGuid

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PrefixedUniversalId
The id that represents the user or group. 
You can use Get-TppIdentity or Get-TppPermission to get the id.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrefixedUniversal

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Permission
TppPermission object. 
You can create a new object or get existing object from Get-TppPermission.

```yaml
Type: TppPermission
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
{{Fill Force Description}}

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Guid
## OUTPUTS

### None
## NOTES
Confirmation impact is set to Medium, set ConfirmPreference accordingly.

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Set-TppPermission/](http://venafitppps.readthedocs.io/en/latest/functions/Set-TppPermission/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Set-TppPermission.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Set-TppPermission.ps1)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____6](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____6)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-PUT-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____7](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-PUT-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____7)

