# Get-TppPermission

## SYNOPSIS
Get permissions for TPP objects

## SYNTAX

### ByObject (Default)
```
Get-TppPermission -InputObject <TppObject> [-PrefixedUniversalId <String[]>] [-Explicit]
 [-Attribute <String[]>] [-TppSession <TppSession>] [<CommonParameters>]
```

### ByPath
```
Get-TppPermission -Path <String[]> [-PrefixedUniversalId <String[]>] [-Explicit] [-Attribute <String[]>]
 [-TppSession <TppSession>] [<CommonParameters>]
```

### ByGuid
```
Get-TppPermission -Guid <Guid[]> [-PrefixedUniversalId <String[]>] [-Explicit] [-Attribute <String[]>]
 [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Get permissions for users and groups on any object.
The effective permissions will be retrieved by default, but inherited/explicit permissions can be retrieved as well.
All permissions can be retrieved for an object, the default, or for one specific id.

## EXAMPLES

### EXAMPLE 1
```
Find-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission
```

Get effective permissions for users/groups on a specific policy folder

### EXAMPLE 2
```
Find-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission -Attribute 'Given Name','Surname'
```

Get effective permissions on a policy folder including identity attributes for the permissioned users/groups

### EXAMPLE 3
```
Find-TppObject -Path '\VED\Policy\My folder' | Get-TppPermission -Explicit
```

Get explicit and implicit permissions for users/groups on a specific policy folder

## PARAMETERS

### -InputObject
One or more TppObject

```yaml
Type: TppObject
Parameter Sets: ByObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path
Full path to an object

```yaml
Type: String[]
Parameter Sets: ByPath
Aliases: DN, CertificateDN

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Guid
Guid representing a unique object in Venafi.

```yaml
Type: Guid[]
Parameter Sets: ByGuid
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PrefixedUniversalId
Get permissions for a specific id for the object provided.
You can use Find-TppIdentity to get the id.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: PrefixedUniversal

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Explicit
Get explicit (direct) and implicit (inherited) permissions instead of effective.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ExplicitImplicit

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### InputObject, Path, Guid
## OUTPUTS

### List parameter set returns a PSCustomObject with the properties Guid and Permissions
### Local and external parameter sets returns a PSCustomObject with the following properties:
###     Guid
###     PrefixedUniversalId
###     EffectivePermissions (if Explicit switch is not used)
###     ExplicitPermissions (if Explicit switch is used)
###     ImplicitPermissions (if Explicit switch is used)
###     Attributes (if Attribute provided)
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppPermission/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppPermission/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppPermission.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppPermission.ps1)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____1](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____1)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-external.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____2](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-external.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____2)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-local.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____3](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-local.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____3)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____5](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Permissions-object-guid-principal.php?tocpath=REST%20API%20reference%7CPermissions%20programming%20interfaces%7C_____5)

