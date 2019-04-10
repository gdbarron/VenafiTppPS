# New-TppCertificate

## SYNOPSIS
Enrolls or provisions a new certificate

## SYNTAX

### ByName (Default)
```
New-TppCertificate -Name <String> [-CommonName <String>] -Path <String> -CertificateAuthorityPath <String>
 [-ManagementType <String>] [-PassThru] [-TppSession <TppSession>] [<CommonParameters>]
```

### BySubject
```
New-TppCertificate -CommonName <String> -Path <String> -CertificateAuthorityPath <String>
 [-ManagementType <String>] [-PassThru] [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Enrolls or provisions a new certificate

## EXAMPLES

### EXAMPLE 1
```
New-TppCertificate -Path '\ved\policy\folder' -Name 'mycert.com' -CertificateAuthorityDN '\ved\policy\CA Templates\my template'
```

Create certifcate by name

### EXAMPLE 2
```
New-TppCertificate -Path '\ved\policy\folder' -CommonName 'mycert.com' -CertificateAuthorityDN '\ved\policy\CA Templates\my template' -PassThru
```

Create certificate using common name. 
Return the created object.

## PARAMETERS

### -Name
Name of the certifcate. 
If not provided, the name will be the same as the subject.

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommonName
Subject Common Name. 
If Name isn't provided, CommonName will be used.

```yaml
Type: String
Parameter Sets: ByName
Aliases: Subject

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: BySubject
Aliases: Subject

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The folder DN path for the new certificate.
If the value is missing, use the system default

```yaml
Type: String
Parameter Sets: (All)
Aliases: PolicyDN

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CertificateAuthorityPath
{{ Fill CertificateAuthorityPath Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: CertificateAuthorityDN

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagementType
The level of management that Trust Protection Platform applies to the certificate:
- Enrollment: Default.
Issue a new certificate, renewed certificate, or key generation request to a CA for enrollment.
Do not automatically provision the certificate.
- Provisioning:  Issue a new certificate, renewed certificate, or key generation request to a CA for enrollment.
Automatically install or provision the certificate.
- Monitoring:  Allow Trust Protection Platform to monitor the certificate for expiration and renewal.
- Unassigned: Certificates are neither enrolled or monitored by Trust Protection Platform.

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

### -PassThru
Return a TppObject representing the newly created certificate.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### TppObject, if PassThru is provided
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppCertificate/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppCertificate/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppCertificate.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppCertificate.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-request.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7CPOST%20Certificates%2FRequest%7C_____0](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-request.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7CPOST%20Certificates%2FRequest%7C_____0)

