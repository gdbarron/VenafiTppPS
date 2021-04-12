# New-TppDevice

## SYNOPSIS
Add a new device

## SYNTAX

```
New-TppDevice [-Path] <String> [[-DeviceName] <String[]>] [[-Description] <String>]
 [[-CredentialPath] <String>] [[-IpAddress] <IPAddress>] [-PassThru] [[-TppSession] <TppSession>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Add a new device with optional attributes

## EXAMPLES

### EXAMPLE 1
```
$newPolicy = New-TppDevice -Path '\VED\Policy\MyFolder\device' -PassThru
```

Create device with full path to device and returning the object created

### EXAMPLE 2
```
$policyPath | New-TppDevice -DeviceName 'myDevice' -IpAddress 1.2.3.4
```

Pipe policy path and provide device details

## PARAMETERS

### -Path
Full path to the new device.
Alternatively, you can provide just the policy path, but then DeviceName must be provided.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -DeviceName
Name of 1 or more devices to create.
Path must be of type Policy to use this.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Device description

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CredentialPath
Path to the credential which has permissions to update the device

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IpAddress
IP Address of the device

```yaml
Type: IPAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Return a TppObject representing the newly created policy.

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
Position: 6
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Path
## OUTPUTS

### TppObject, if PassThru provided
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppDevice/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppDevice/)

[https://github.com/gdbarron/VenafiTppPS/blob/main/VenafiTppPS/Code/Public/New-TppDevice.ps1](https://github.com/gdbarron/VenafiTppPS/blob/main/VenafiTppPS/Code/Public/New-TppDevice.ps1)

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppObject/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppObject/)

[https://github.com/gdbarron/VenafiTppPS/blob/main/VenafiTppPS/Code/Public/New-TppObject.ps1](https://github.com/gdbarron/VenafiTppPS/blob/main/VenafiTppPS/Code/Public/New-TppObject.ps1)

