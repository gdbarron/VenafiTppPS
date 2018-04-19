# Invoke-TppCertificateRenewal

## SYNOPSIS
Renew a certificate

## SYNTAX

```
Invoke-TppCertificateRenewal [-DN] <String> [[-TppSession] <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Requests renewal for an existing certificate.
This call marks a certificate for
immediate renewal.
The certificate must not be in error, already being processed, or
configured for Monitoring in order for it be renewable.
Caller must have Write access
to the certificate object being renewed.

## EXAMPLES

### EXAMPLE 1
```
Invoke-TppCertificateRenew -Path '\VED\Policy\My folder\app.mycompany.com'
```

## PARAMETERS

### -DN
this regex could be better

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Position: 2
Default value: $Script:TppSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Path (alias: DN)

## OUTPUTS

### PSCustomObject with the following properties:
DN - Certificate path
Success - A value of true indicates that the renewal request was successfully submitted and
granted.
Error - Indicates any errors that occurred. Not returned when successful

## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Invoke-TppCertificateRenewal/](http://venafitppps.readthedocs.io/en/latest/functions/Invoke-TppCertificateRenewal/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Invoke-TppCertificateRenewal.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Invoke-TppCertificateRenewal.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-renew.php?TocPath=REST%20API%20reference|Certificates%20module%20programming%20interfaces|_____9](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-renew.php?TocPath=REST%20API%20reference|Certificates%20module%20programming%20interfaces|_____9)

