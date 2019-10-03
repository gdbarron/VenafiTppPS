# New-TppCapiApplication

## SYNOPSIS
Create a new CAPI application

## SYNTAX

### NonIis (Default)
```
New-TppCapiApplication -Path <String> [-ApplicationName <String[]>] [-CertificatePath <String>]
 [-CredentialPath <String>] [-FriendlyName <String>] [-Description <String>] [-WinRmPort <Int32>] [-Disable]
 [-ProvisionCertificate] [-SkipExistenceCheck] [-PassThru] [-TppSession <TppSession>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Iis
```
New-TppCapiApplication -Path <String> [-ApplicationName <String[]>] [-CertificatePath <String>]
 [-CredentialPath <String>] [-FriendlyName <String>] [-Description <String>] [-WinRmPort <Int32>] [-Disable]
 -WebSiteName <String> [-BindingIpAddress <IPAddress>] [-BindingPort <Int32>] [-BindingHostName <String>]
 [-CreateBinding <Boolean>] [-ProvisionCertificate] [-SkipExistenceCheck] [-PassThru]
 [-TppSession <TppSession>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Create a new CAPI application

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Path
Full path, including name, to the application to be created. 
The application must be created under a device.
Alternatively, provide the path to the device and provide ApplicationName.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ApplicationName
1 or more application names to create. 
Path must be a path to a device.

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

### -CertificatePath
Path to the certificate to associate to the new application

```yaml
Type: String
Parameter Sets: (All)
Aliases: CertificateDN

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CredentialPath
Path to the associated credential which has rights to access the connected device

```yaml
Type: String
Parameter Sets: (All)
Aliases: CredentialDN

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FriendlyName
Optional friendly name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
{{ Fill Description Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WinRmPort
{{ Fill WinRmPort Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disable
Set processing to disabled. 
It is enabled by default.

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

### -WebSiteName
{{ Fill WebSiteName Description }}

```yaml
Type: String
Parameter Sets: Iis
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BindingIpAddress
{{ Fill BindingIpAddress Description }}

```yaml
Type: IPAddress
Parameter Sets: Iis
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BindingPort
{{ Fill BindingPort Description }}

```yaml
Type: Int32
Parameter Sets: Iis
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -BindingHostName
{{ Fill BindingHostName Description }}

```yaml
Type: String
Parameter Sets: Iis
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateBinding
{{ Fill CreateBinding Description }}

```yaml
Type: Boolean
Parameter Sets: Iis
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProvisionCertificate
Push the certificate to the application. 
CertificatePath must be provided.

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

### -SkipExistenceCheck
By default, the paths for the new application, certifcate, and credential will be validated for existence.
Specify this switch to bypass this check.

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

### -PassThru
Return a TppObject representing the newly created capi app.

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

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppCapiApplication/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppCapiApplication/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppCapiApplication.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppCapiApplication.ps1)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppObject.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppObject.ps1)

[http://venafitppps.readthedocs.io/en/latest/functions/Find-TppCertificate/](http://venafitppps.readthedocs.io/en/latest/functions/Find-TppCertificate/)

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppObject/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppObject/)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-create.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____9](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-create.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____9)

