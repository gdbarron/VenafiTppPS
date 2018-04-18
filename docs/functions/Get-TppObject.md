# Get-TppObject

## SYNOPSIS
Find objects by class or pattern

## SYNTAX

### FindByClass
```
Get-TppObject -Class <String> [-Pattern <String>] [-DN <String>] [-Recursive] [-TppSession <TppSession>]
 [<CommonParameters>]
```

### FindByClasses
```
Get-TppObject -Classes <String[]> [-Pattern <String>] [-TppSession <TppSession>] [<CommonParameters>]
```

### Find
```
Get-TppObject -Pattern <String> [-AttributeName <String[]>] [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Find objects by class or pattern

## EXAMPLES

### EXAMPLE 1
```
Get-TppObject -class 'iis6'
```

Get all objects of the type iis6

### EXAMPLE 2
```
Get-TppObject -classes 'iis6', 'capi'
```

Get all objects of the type iis6 or capi

## PARAMETERS

### -Class
Single class name to search

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
Parameter Sets: FindByClass, FindByClasses
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Find
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttributeName
A list of attribute names to limit the search against

```yaml
Type: String[]
Parameter Sets: Find
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DN
The starting DN of the object to search for subordinates under.
ObjectDN and Recursive is only supported if Class is provided

```yaml
Type: String
Parameter Sets: FindByClass
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recursive
Searches the subordinates of the object specified in DN

```yaml
Type: SwitchParameter
Parameter Sets: FindByClass
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

### none

## OUTPUTS

### PSCustomObject with the following properties:
    AbsoluteGUID: The left-to-right concatenation of all of the GUIDs for all of the objects in the DN.
    DN: The Distinguished Name (DN) of the object.
    GUID: The GUID that identifies the object.
    ID: The object identifier.
    Name: The Common Name (CN) of the object.
    Parent: The parent DN of the object.
    Revision: The revision of the object.
    TypeName: the class name of the object.

## NOTES

## RELATED LINKS
