# Remove-TppCertificateAssociation

## SYNOPSIS
Remove certificate associations

## SYNTAX

### RemoveAll
```
Remove-TppCertificateAssociation -Path <String> [-OrphanCleanup] [-RemoveAll] [-TppSession <TppSession>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### RemoveOne
```
Remove-TppCertificateAssociation -Path <String> -ApplicationPath <String[]> [-OrphanCleanup]
 [-TppSession <TppSession>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Disassociates one or more Application objects from an existing certificate.
Optionally, you can remove the application objects and corresponding orphaned device objects that no longer have any applications

## EXAMPLES

### EXAMPLE 1
```
Remove-TppCertificateAssocation -Path '\ved\policy\my folder' -ApplicationPath '\ved\policy\my capi'
```

Remove a single application object association

### EXAMPLE 2
```
Remove-TppCertificateAssocation -Path '\ved\policy\my folder' -ApplicationPath '\ved\policy\my capi' -OrphanCleanup
```

Disassociate and delete the application object

### EXAMPLE 3
```
Remove-TppCertificateAssocation -Path '\ved\policy\my folder' -RemoveAll
```

Remove all certificate associations

## PARAMETERS

### -Path
DN path of one or more certificates to process

```yaml
Type: String
Parameter Sets: (All)
Aliases: DN, CertificateDN

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ApplicationPath
One or more application objects, specified by their distinguished names, that uniquely identify them in the Venafi platform

```yaml
Type: String[]
Parameter Sets: RemoveOne
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrphanCleanup
Delete the Application object.
Only delete the corresponding Device DN when it has no child objects.
Otherwise retain only the Device DN and its children.
Use this option to completely remove the application object and corresponding device objects.

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

### -RemoveAll
Remove all associated application objects

```yaml
Type: SwitchParameter
Parameter Sets: RemoveAll
Aliases:

Required: True
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

### Path
## OUTPUTS

### None
## NOTES
You must have:
- Write permission to the Certificate object.
- Write or Associate permission to Application objects that are associated with the certificate
- Delete permission to Application and device objects when specifying -OrphanCleanup

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Remove-TppCertificateAssociation/](http://venafitppps.readthedocs.io/en/latest/functions/Remove-TppCertificateAssociation/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Remove-TppCertificateAssociation.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Remove-TppCertificateAssociation.ps1)

[https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-Dissociate.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7C_____6](https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-Dissociate.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7C_____6)
