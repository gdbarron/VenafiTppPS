# New-TppCapiApplication

## SYNOPSIS
Create a new CAPI application object

## SYNTAX

### None (Default)
```
New-TppCapiApplication -DN <String> -FriendlyName <String> [-Disable] -CertificateDN <String>
 [-Description <String>] -CredentialDN <String> [-WinRmPort <Int32>] [-TppSession <TppSession>]
 [<CommonParameters>]
```

### UpdateIis
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
Parameter Sets: UpdateIis
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
Parameter Sets: UpdateIis
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
Parameter Sets: UpdateIis
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
Parameter Sets: UpdateIis
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
Parameter Sets: UpdateIis
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
Parameter Sets: UpdateIis
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
