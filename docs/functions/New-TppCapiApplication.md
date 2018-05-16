# New-TppCapiApplication

## SYNOPSIS
Create a new CAPI application object

## SYNTAX

```
New-TppCapiApplication -DN <String> -FriendlyName <String> [-Disable] -CertificateDN <String>
 [-Description <String>] -CredentialDN <String> [-WinRmPort <Int32>] [-UpdateIis] -WebSiteName <String>
 [-BindingIpAddress <String>] [-BindingPort <Int32>] [-BindingHostName <String>] [-CreateBinding <Boolean>]
 [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Create a new CAPI application object

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -DN
DN path to the new object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FriendlyName
CAPI Settings\Friendly Name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
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

### -CertificateDN
Path to the associated certificate

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
{{Fill Description Description}}

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

### -CredentialDN
Path to the associated credential which has rights to access the connected device

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WinRmPort
{{Fill WinRmPort Description}}

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

### -UpdateIis
{{Fill UpdateIis Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebSiteName
{{Fill WebSiteName Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BindingIpAddress
{{Fill BindingIpAddress Description}}

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

### -BindingPort
{{Fill BindingPort Description}}

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

### -BindingHostName
{{Fill BindingHostName Description}}

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

### -CreateBinding
{{Fill CreateBinding Description}}

```yaml
Type: Boolean
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### none

## OUTPUTS

## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppCapiApplication/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppCapiApplication/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppCapiApplication.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppCapiApplication.ps1)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Set-TppAttribute.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Set-TppAttribute.ps1)

[http://venafitppps.readthedocs.io/en/latest/functions/Test-TppObjectsExists/](http://venafitppps.readthedocs.io/en/latest/functions/Test-TppObjectsExists/)

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppObject/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppObject/)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-create.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____9](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-create.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____9)

