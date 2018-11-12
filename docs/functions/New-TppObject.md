# New-TppObject

## SYNOPSIS
Create a new object

## SYNTAX

```
New-TppObject [-Path] <String> [-Class] <String> [-Attribute] <Hashtable[]> [-PassThru]
 [[-TppSession] <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Create a new object. 
Generic use function if a specific function hasn't been created yet for the class.
There doesn't seem to be a great way to get an explicit list of what the attributes for any one class should be.
You can either review the online SDK documentation or manually create the object via the admin GUI and
go to the Support-\>Attributes tab.

## EXAMPLES

### EXAMPLE 1
```
New-TppObject -Path '\VED\Policy\Test Device' -Class 'Device' -Attribute @(@{'Name'='Description';'Value'='new device testing'})
```

Create a new device

### EXAMPLE 2
```
New-TppObject -Path '\VED\Policy\Test Device' -Class 'Device' -Attribute @(@{'Name'='Description';'Value'='new device testing'}) -PassThru
```

Create a new device and return the resultant object

## PARAMETERS

### -Path
Full path for the object to be created.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Class
Class name of the new object.
See https://docs.venafi.com/Docs/18.3SDK/TopNav/Content/SDK/WebSDK/Schema_Reference/r-SDK-CNattributesWhere.php for more info.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Attribute
List of Hashtables with initial values for the new object.
These will be specific to the object class being created.
Each Hashtable should have Name as one key and Value as the other.
See the examples.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
{{Fill PassThru Description}}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### none
## OUTPUTS

### TppObject
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppObject/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppObject/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppObject.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppObject.ps1)

[https://docs.venafi.com/Docs/18.3SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-create.php?tocpath=REST%20API%20reference%7CConfig%20programming%20interfaces%7C_____9](https://docs.venafi.com/Docs/18.3SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-create.php?tocpath=REST%20API%20reference%7CConfig%20programming%20interfaces%7C_____9)

[https://docs.venafi.com/Docs/18.3SDK/TopNav/Content/SDK/WebSDK/Schema_Reference/r-SDK-CNattributesWhere.php](https://docs.venafi.com/Docs/18.3SDK/TopNav/Content/SDK/WebSDK/Schema_Reference/r-SDK-CNattributesWhere.php)

