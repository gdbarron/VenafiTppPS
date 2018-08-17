# Get-TppObject

## SYNOPSIS
Find objects by DN, class, or pattern

## SYNTAX

### FindByDN (Default)
```
Get-TppObject [-DN <String>] [-Pattern <String>] [-Recursive <Boolean>] [-TppSession <TppSession>]
 [<CommonParameters>]
```

### FindByClass
```
Get-TppObject [-DN <String>] -Class <String> [-Pattern <String>] [-Recursive <Boolean>]
 [-TppSession <TppSession>] [<CommonParameters>]
```

### FindByClasses
```
Get-TppObject -Classes <String[]> [-Pattern <String>] [-TppSession <TppSession>] [<CommonParameters>]
```

### FindByPattern
```
Get-TppObject -Pattern <String> [-AttributeName <String[]>] [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Find objects by DN, class, or pattern.

## EXAMPLES

### EXAMPLE 1
```
Get-TppObject
```

Get all objects

### EXAMPLE 2
```
Get-TppObject -class 'iis6'
```

Get all objects of the type iis6

### EXAMPLE 3
```
Get-TppObject -classes 'iis6', 'capi'
```

Get all objects of the type iis6 or capi

### EXAMPLE 4
```
Get-TppObject -DN '\VED\Policy\My Policy Folder' -Recursive
```

Get all objects in 'My Policy Folder' and subfolders

### EXAMPLE 5
```
Get-TppObject -DN '\VED\Policy\My Policy Folder' -Pattern 'MyDevice'
```

Get all objects in 'My Policy Folder' that match the name MyDevice. 
Only search the folder "My Policy Folder", not subfolders.

### EXAMPLE 6
```
Get-TppObject -Pattern 'MyDevice' -Recursive
```

Get all objects that match the name MyDevice. 
As starting DN isn't provided, this will search all.

## PARAMETERS

### -DN
The path to start our search. 
If not provided, the root, \VED, is used.

```yaml
Type: String
Parameter Sets: FindByDN, FindByClass
Aliases:

Required: False
Position: Named
Default value: \VED
Accept pipeline input: False
Accept wildcard characters: False
```

### -Class
Single class name to search. 
To provide a list, use Classes.

```yaml
Type: String
Parameter Sets: FindByClass
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Classes
List of class names to search on

```yaml
Type: String[]
Parameter Sets: FindByClasses
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Pattern
A pattern to match against object attribute values:

- To list DNs that include an asterisk (*) or question mark (?), prepend two backslashes (\\\\).
For example, \\\\*.MyCompany.net treats the asterisk as a literal character and returns only certificates with DNs that match *.MyCompany.net.
- To list DNs with a wildcard character, append a question mark (?).
For example, "test_?.mycompany.net" counts test_1.MyCompany.net and test_2.MyCompany.net but not test12.MyCompany.net.
- To list DNs with similar names, prepend an asterisk.
For example, *est.MyCompany.net, counts Test.MyCompany.net and West.MyCompany.net.
You can also use both literals and wildcards in a pattern.

```yaml
Type: String
Parameter Sets: FindByDN, FindByClass, FindByClasses
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: FindByPattern
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttributeName
A list of attribute names to limit the search against. 
Only valid when searching by pattern.

```yaml
Type: String[]
Parameter Sets: FindByPattern
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recursive
Searches the subordinates of the object specified in DN.
Not supported when searching Classes or by Pattern.
Default value is true.

```yaml
Type: Boolean
Parameter Sets: FindByDN, FindByClass
Aliases:

Required: False
Position: Named
Default value: True
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

## OUTPUTS

### PSCustomObject with the following properties:
###     AbsoluteGUID: The left-to-right concatenation of all of the GUIDs for all of the objects in the DN.
###     DN: The Distinguished Name (DN) of the object.
###     GUID: The GUID that identifies the object.
###     ID: The object identifier.
###     Name: The Common Name (CN) of the object.
###     Parent: The parent DN of the object.
###     Revision: The revision of the object.
###     TypeName: the class name of the object.
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppObject/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppObject/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppObject.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppObject.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-find.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____17](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-find.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____17)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-findobjectsofclass.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____19](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-findobjectsofclass.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____19)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-enumerate.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____13](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-enumerate.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____13)

