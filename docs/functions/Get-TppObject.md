# Get-TppObject

## SYNOPSIS
Find objects by DN path, class, or pattern

## SYNTAX

### FindByClassAndPath
```
Get-TppObject -Path <String> -Class <String[]> [-Pattern <String>] [-Recursive] [-TppSession <TppSession>]
 [<CommonParameters>]
```

### FindByPath
```
Get-TppObject -Path <String> [-Pattern <String>] [-Recursive] [-TppSession <TppSession>] [<CommonParameters>]
```

### FindByClass
```
Get-TppObject -Class <String[]> [-Pattern <String>] [-TppSession <TppSession>] [<CommonParameters>]
```

### FindByPattern
```
Get-TppObject -Pattern <String> [-Attribute <String[]>] [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Find objects by DN path, class, or pattern.

## EXAMPLES

### EXAMPLE 1
```
Get-TppObject -Path '\VED\Policy'
```

Get all objects in the root of a specific folder

### EXAMPLE 2
```
Get-TppObject -Path '\VED\Policy\My Folder' -Recursive
```

Get all objects in a folder and subfolders

### EXAMPLE 3
```
Get-TppObject -Path '\VED\Policy' -Pattern 'test'
```

Get items in a specific folder filtering the path

### EXAMPLE 4
```
Get-TppObject -Class 'iis6'
```

Get all objects of the type iis6

### EXAMPLE 5
```
Get-TppObject -Class 'iis6' -Pattern 'test*'
```

Get all objects of the type iis6 filtering the path

### EXAMPLE 6
```
Get-TppObject -Class 'iis6', 'capi'
```

Get all objects of the type iis6 or capi

### EXAMPLE 7
```
Get-TppObject -Pattern 'test*'
```

Find all objects matching the pattern

### EXAMPLE 8
```
Get-TppObject -Pattern 'test*' -Attribute 'Consumers'
```

Find all objects where the specific attribute matches the pattern

## PARAMETERS

### -Path
The path to start our search.

```yaml
Type: String
Parameter Sets: FindByClassAndPath, FindByPath
Aliases: DN

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Class
1 or more classes to search for

```yaml
Type: String[]
Parameter Sets: FindByClassAndPath, FindByClass
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
Parameter Sets: FindByClassAndPath, FindByPath, FindByClass
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

### -Attribute
A list of attribute names to limit the search against. 
Only valid when searching by pattern.

```yaml
Type: String[]
Parameter Sets: FindByPattern
Aliases: AttributeName

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recursive
Searches the subordinates of the object specified in Path.

```yaml
Type: SwitchParameter
Parameter Sets: FindByClassAndPath, FindByPath
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

### None
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

