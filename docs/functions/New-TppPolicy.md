# New-TppPolicy

## SYNOPSIS
Add a new policy folder

## SYNTAX

```
New-TppPolicy [-PolicyDN] <String> [[-Description] <String>] [[-TppSession] <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Add a new policy folder

## EXAMPLES

### EXAMPLE 1
```
New-TppPolicy -PolicyDN '\VED\Policy\Existing Policy Folder\New Policy Folder' -Description 'this is awesome'
```

## PARAMETERS

### -PolicyDN
DN path to the new policy

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

### -Description
Policy description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 3
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
###     AbsoluteGUID: The left-to-right concatenation of all of the GUIDs for all of the objects in the DN.
###     DN: The Distinguished Name (DN) of the object, provided as PolicyDN
###     GUID: The GUID that identifies the object.
###     ID: The object identifier.
###     Name: The Common Name (CN) of the object.
###     Parent: The parent DN of the object.
###     Revision: The revision of the object.
###     TypeName: will always be Policy
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppPolicy/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppPolicy/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppPolicy.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppPolicy.ps1)

