# Revoke-TppCertificate

## SYNOPSIS
Revoke a certificate

## SYNTAX

### CertificateDN (Default)
```
Revoke-TppCertificate -CertificateDN <String[]> [-Reason <Int32>] [-Comments <String>] [-Disable] [-Wait]
 [-TppSession <TppSession>] [<CommonParameters>]
```

### Thumbprint
```
Revoke-TppCertificate -Thumbprint <String[]> [-Reason <Int32>] [-Comments <String>] [-Disable] [-Wait]
 [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Requests that an existing certificate be revoked.
The caller must have Write permissions to the Certificate object.
Either the CertificateDN or the Thumbprint must be provided

## EXAMPLES

### EXAMPLE 1
```
Invoke-TppCertificateRevocation -CertificateDN '\VED\Policy\My folder\app.mycompany.com' -Reason 2
```

Revoke the certificate with a reason of the CA being compromised

### EXAMPLE 2
```
Invoke-TppCertificateRevocation -CertificateDN '\VED\Policy\My folder\app.mycompany.com' -Reason 2 -Wait
```

Revoke the certificate with a reason of the CA being compromised and wait for it to complete

### EXAMPLE 3
```
Invoke-TppCertificateRevocation -Thumbprint 'a909502dd82ae41433e6f83886b00d4277a32a7b'
```

Revoke the certificate with a reason of the CA being compromised and wait for it to complete

## PARAMETERS

### -CertificateDN
Full path to a certificate in TPP

```yaml
Type: String[]
Parameter Sets: CertificateDN
Aliases: DN

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Thumbprint
The thumbprint (hash) of the certificate to revoke

```yaml
Type: String[]
Parameter Sets: Thumbprint
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Reason
The reason for revocation of the certificate:

    0: None
    1: User key compromised
    2: CA key compromised
    3: User changed affiliation
    4: Certificate superseded
    5: Original use no longer valid

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

### -Comments
The details about why the certificate is being revoked

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

### -Disable
The setting to manage the Certificate object upon revocation. 
Default is to allow a new certificate to be enrolled to replace the revoked one. 
Provide this switch to mark the certificate as disabled and no new certificate will be enrolled to replace the revoked one.

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

### -Wait
Wait for the requested revocation to be complete

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### CertificateDN (alias: DN) or Thumbprint
## OUTPUTS

### PSCustomObject with the following properties:
###     CertificateDN/Thumbprint - Whichever value was provided
###     Requested - Indicates whether revocation has been requested.  Only returned if the revocation was requested, but not completed yet.
###     Revoked - Indicates whether revocation has been completed.  Only returned once complete.
###     Error - Indicates any errors that occurred. Not returned when successful
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Revoke-TppCertificate/](http://venafitppps.readthedocs.io/en/latest/functions/Revoke-TppCertificate/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Revoke-TppCertificate.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Revoke-TppCertificate.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-revoke.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7C_____15](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-revoke.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7C_____15)

