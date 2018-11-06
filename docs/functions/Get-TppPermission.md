# Get-TppPermission

## SYNOPSIS
Get permissions for TPP objects

## SYNTAX

### ExplicitImplicit
```
Get-TppPermission -Guid <Guid[]> -PrefixedUniversalId <String[]> [-ExplicitImplicit] [-Attribute <String[]>]
 [-TppSession <TppSession>] [<CommonParameters>]
```

### Effective
```
Get-TppPermission -Guid <Guid[]> -PrefixedUniversalId <String[]> [-Effective] [-Attribute <String[]>]
 [-TppSession <TppSession>] [<CommonParameters>]
```

### List
```
Get-TppPermission -Guid <Guid[]> [-Effective] [-ExplicitImplicit] [-Attribute <String[]>]
 [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Determine who has rights for TPP objects and what those rights are

## EXAMPLES

### EXAMPLE 1
```
Find-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission
```

Guid                             PrefixedUniversalId
----                                   -----------
{1234abcd-g6g6-h7h7-faaf-f50cd6610cba} {AD+mydomain.com:1234567890olikujyhtgrfedwsqa, AD+mydomain.com:azsxdcfvgbhnjmlk09877654321}

Get users/groups permissioned to a policy folder

### EXAMPLE 2
```
Find-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission -Attribute 'Given Name','Surname'
```

Get users/groups permissioned to a policy folder including identity attributes for those users/groups

### EXAMPLE 3
```
Find-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission -Effective
```

Guid           : {1234abcd-g6g6-h7h7-faaf-f50cd6610cba}
PrefixedUniversalId  : AD+mydomain.com:1234567890olikujyhtgrfedwsqa
EffectivePermissions : @{IsAssociateAllowed=False; IsCreateAllowed=True; IsDeleteAllowed=True; IsManagePermissionsAllowed=True; IsPolicyWriteAllowed=True;
                       IsPrivateKeyReadAllowed=True; IsPrivateKeyWriteAllowed=True; IsReadAllowed=True; IsRenameAllowed=True; IsRevokeAllowed=False; IsViewAllowed=True;
                       IsWriteAllowed=True}

Guid           : {1234abcd-g6g6-h7h7-faaf-f50cd6610cba}
PrefixedUniversalId  : AD+mydomain.com:azsxdcfvgbhnjmlk09877654321
EffectivePermissions : @{IsAssociateAllowed=False; IsCreateAllowed=False; IsDeleteAllowed=False; IsManagePermissionsAllowed=False; IsPolicyWriteAllowed=True;
                       IsPrivateKeyReadAllowed=False; IsPrivateKeyWriteAllowed=False; IsReadAllowed=True; IsRenameAllowed=False; IsRevokeAllowed=True; IsViewAllowed=False;
                       IsWriteAllowed=True}

Get effective permissions for users/groups on a specific policy folder

## PARAMETERS

### -Guid
Guid representing a unique object in Venafi.

```yaml
Type: Guid[]
Parameter Sets: (All)
Aliases: ObjectGuid

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PrefixedUniversalId
The id that represents the user or group. 
Use Get-TppIdentity to get the id.

```yaml
Type: String[]
Parameter Sets: ExplicitImplicit, Effective
Aliases: PrefixedUniversal

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Effective
Get effective permissions for the specific user or group on the object.
If only an object guid is provided with this switch, all user and group permssions will be provided.

```yaml
Type: SwitchParameter
Parameter Sets: Effective, List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExplicitImplicit
Get explicit and implicit permissions for the specific user or group on the object.
If only an object guid is provided with this switch, all user and group permssions will be provided.

```yaml
Type: SwitchParameter
Parameter Sets: ExplicitImplicit, List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Attribute
Retrieve identity attribute values for the users and groups. 
Attributes include Group Membership, Name, Internet Email Address, Given Name, Surname.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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

### List parameter set returns a PSCustomObject with the properties Guid and Permissions
### Local and external parameter sets returns a PSCustomObject with the following properties:
###     Guid
###     PrefixedUniversalId
###     EffectivePermissions (if Effective switch is used)
###     ExplicitPermissions (if ExplicitImplicit switch is used)
###     ImplicitPermissions (if ExplicitImplicit switch is used)
###     Attribute (if Attribute provided)
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppPermission/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppPermission/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppPermission.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppPermission.ps1)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____1](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____1)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-external.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____2](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-external.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____2)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-local.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____3](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-local.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____3)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____5](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____5)

