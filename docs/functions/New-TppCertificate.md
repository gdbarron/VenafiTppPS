# New-TppCertificate

## SYNOPSIS
Enrolls or provisions a new certificate

## SYNTAX

```
New-TppCertificate [-PolicyDN] <String> [[-Name] <String>] [[-Subject] <String>]
 [-CertificateAuthorityDN] <String> [[-ManagementType] <String>] [[-TppSession] <TppSession>]
 [<CommonParameters>]
```

## DESCRIPTION
Enrolls or provisions a new certificate

## EXAMPLES

### EXAMPLE 1
```

```

## PARAMETERS

### -PolicyDN
The folder DN for the new certificate.
If the value is missing, use the system default

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

### -Name
Either the Name or Subject parameter is required.
Both the Name and Subject parameters can appear in the same Certificates/Request call.
If the Subject parameter has a value, The friendly name for the certificate object in Trust Protection Platform.
If the value is missing, the Name is the Subject DN

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

### -Subject
Either the Name or Subject parameter is required.
Both parameters are allowed in same request.
The Common Name field for the certificate Subject Distinguished Name (DN).
Specify a value when a centrally generated CSR is being requested

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

### -CertificateAuthorityDN
The Distinguished Name (DN) of the Trust Protection Platform Certificate Authority Template object for enrolling the certificate.
If the value is missing, use the default CADN

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagementType
The level of management that Trust Protection Platform applies to the certificate:

Enrollment: Default.
Issue a new certificate, renewed certificate, or key generation request to a CA for enrollment.
Do not automatically provision the certificate.
Provisioning:  Issue a new certificate, renewed certificate, or key generation request to a CA for enrollment.
Automatically install or provision the certificate.
Monitoring:  Allow Trust Protection Platform to monitor the certificate for expiration and renewal.
Unassigned: Certificates are neither enrolled or monitored by Trust Protection Platform.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
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
    CertificateDN - The Trust Protection Platform DN of the newly created certificate object, if it was successfully created. Otherwise, this value is absent.
    Guid - A Guid that uniquely identifies the certificate.
    Error - The reason why Certificates/Request could no create the certificate. Otherwise, this value is not present.

## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppCertificate/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppCertificate/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppCertificate.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppCertificate.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-request.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7CPOST%20Certificates%2FRequest%7C_____0](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-request.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7CPOST%20Certificates%2FRequest%7C_____0)

