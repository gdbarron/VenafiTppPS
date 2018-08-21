# Get-TppPermission

## SYNOPSIS
Get permissions for TPP objects

## SYNTAX

### External
```
Get-TppPermission -Guid <String[]> -ExternalProviderType <String> -ExternalProviderName <String>
 -UniversalId <String> [-Effective] [-TppSession <TppSession>] [<CommonParameters>]
```

### Local
```
Get-TppPermission -Guid <String[]> -UniversalId <String> [-Effective] [-TppSession <TppSession>]
 [<CommonParameters>]
```

### List
```
Get-TppPermission -Guid <String[]> [-Effective] [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Determine who has rights for TPP objects and what those rights are

## EXAMPLES

### EXAMPLE 1
```
Get-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission
```

ObjectGuid                             Permissions
----                                   -----------
{1234abcd-g6g6-h7h7-faaf-f50cd6610cba} {AD+mydomain.com:1234567890olikujyhtgrfedwsqa, AD+mydomain.com:azsxdcfvgbhnjmlk09877654321}

Get permissions for a specific policy folder

### EXAMPLE 2
```
Get-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission -Effective
```

ObjectGuid           : {1234abcd-g6g6-h7h7-faaf-f50cd6610cba}
ProviderType         : AD
ProviderName         : mydomain.com
UniversalId          : 1234567890olikujyhtgrfedwsqa
EffectivePermissions : @{IsAssociateAllowed=False; IsCreateAllowed=True; IsDeleteAllowed=True; IsManagePermissionsAllowed=True; IsPolicyWriteAllowed=True;
                       IsPrivateKeyReadAllowed=True; IsPrivateKeyWriteAllowed=True; IsReadAllowed=True; IsRenameAllowed=True; IsRevokeAllowed=False; IsViewAllowed=True;
                       IsWriteAllowed=True}

ObjectGuid           : {1234abcd-g6g6-h7h7-faaf-f50cd6610cba}
ProviderType         : AD
ProviderName         : mydomain.com
UniversalId          : azsxdcfvgbhnjmlk09877654321
EffectivePermissions : @{IsAssociateAllowed=False; IsCreateAllowed=False; IsDeleteAllowed=False; IsManagePermissionsAllowed=False; IsPolicyWriteAllowed=True;
                       IsPrivateKeyReadAllowed=False; IsPrivateKeyWriteAllowed=False; IsReadAllowed=True; IsRenameAllowed=False; IsRevokeAllowed=True; IsViewAllowed=False;
                       IsWriteAllowed=True}

Get effective permissions for a specific policy folder

## PARAMETERS

### -Guid
Guid representing a unique object in Venafi.

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

### -ExternalProviderType
External provider type with users/groups to assign permissions. 
AD and LDAP are currently supported.

```yaml
Type: String
Parameter Sets: External
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExternalProviderName
Name of the external provider as configured in TPP

```yaml
Type: String
Parameter Sets: External
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UniversalId
The id that represents the user or group. 
Use Get-TppIdentity to get the id.

```yaml
Type: String
Parameter Sets: External, Local
Aliases: Universal

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Effective
{{Fill Effective Description}}

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
Position: Named
Default value: $Script:TppSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Guid
## OUTPUTS

### List parameter set returns a PSCustomObject with the properties ObjectGuid and Permissions
### Local and external parameter sets returns a PSCustomObject with the following properties:
###     ObjectGuid
###     ProviderType
###     ProviderName
###     UniversalId
###     EffectivePermissions (if Effective switch is used)
###     ExplicitPermissions (if Effective switch is NOT used)
###     ImplicitPermissions (if Effective switch is NOT used)
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppPermission/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppPermission/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppPermission.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppPermission.ps1)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____1](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____1)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-external.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____2](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-external.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____2)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-local.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____3](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-local.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____3)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____5](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____5)

