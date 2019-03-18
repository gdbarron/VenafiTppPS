# Get-TppCertificate

## SYNOPSIS
Get a certificate

## SYNTAX

### ByObject (Default)
```
Get-TppCertificate -InputObject <TppObject> -Format <String> [-OutPath <String>] [-IncludeChain]
 [-FriendlyName <String>] [-TppSession <TppSession>] [<CommonParameters>]
```

### ByObjectWithPrivateKey
```
Get-TppCertificate -InputObject <TppObject> -Format <String> [-OutPath <String>] [-IncludeChain]
 [-FriendlyName <String>] [-IncludePrivateKey] -SecurePassword <SecureString> [-TppSession <TppSession>]
 [<CommonParameters>]
```

### ByPathWithPrivateKey
```
Get-TppCertificate -Path <String> -Format <String> [-OutPath <String>] [-IncludeChain] [-FriendlyName <String>]
 [-IncludePrivateKey] -SecurePassword <SecureString> [-TppSession <TppSession>] [<CommonParameters>]
```

### ByPath
```
Get-TppCertificate -Path <String> -Format <String> [-OutPath <String>] [-IncludeChain] [-FriendlyName <String>]
 [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Get a certificate with or without private key.
You have the option of simply getting the data or saving it to a file.

## EXAMPLES

### EXAMPLE 1
```
$certs | Get-TppCertificate -Format 'PKCS #7' -OutPath 'c:\temp'
```

Get one or more certificates

### EXAMPLE 2
```
$certs | Get-TppCertificate -Format 'PKCS #7' -OutPath 'c:\temp' -IncludeChain
```

Get one or more certificates with the certificate chain included

### EXAMPLE 3
```
$certs | Get-TppCertificate -Format 'PKCS #7' -OutPath 'c:\temp' -IncludeChain -FriendlyName 'MyFriendlyName'
```

Get one or more certificates with the certificate chain included and friendly name attribute specified

### EXAMPLE 4
```
$certs | Get-TppCertificate -Format 'PKCS #12' -OutPath 'c:\temp' -IncludePrivateKey -SecurePassword ($password | ConvertTo-SecureString -asPlainText -Force)
```

Get one or more certificates with private key included

### EXAMPLE 5
```
$certs | Get-TppCertificate -Format 'PKCS #12' -OutPath 'c:\temp' -IncludeChain -IncludePrivateKey -SecurePassword ($password | ConvertTo-SecureString -asPlainText -Force)
```

Get one or more certificates with private key and certificate chain included

### EXAMPLE 6
```
$certs | Get-TppCertificate -Format 'PKCS #12' -OutPath 'c:\temp' -IncludeChain -FriendlyName 'MyFriendlyName' -IncludePrivateKey -SecurePassword ($password | ConvertTo-SecureString -asPlainText -Force)
```

Get one or more certificates with private key and certificate chain included and friendly name attribute specified

## PARAMETERS

### -InputObject
TppObject which represents a unique object

```yaml
Type: TppObject
Parameter Sets: ByObject, ByObjectWithPrivateKey
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path
Path to the certificate object to retrieve

```yaml
Type: String
Parameter Sets: ByPathWithPrivateKey, ByPath
Aliases: DN

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Format
The format of the returned certificate.

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

### -OutPath
Folder path to save the certificate to. 
The name of the file will be determined automatically.

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

### -IncludeChain
Include the certificate chain with the exported certificate.

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

### -FriendlyName
The exported certificate's FriendlyName attribute.
This parameter is required when Format is JKS.

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

### -IncludePrivateKey
Include the private key. 
The Format chosen must support private keys.

```yaml
Type: SwitchParameter
Parameter Sets: ByObjectWithPrivateKey, ByPathWithPrivateKey
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecurePassword
Password required when including a private key. 
You must adhere to the following rules:
- Password is at least 12 characters.
- Comprised of at least three of the following:
    - Uppercase alphabetic letters
    - Lowercase alphabetic letters
    - Numeric characters
    - Special characters

```yaml
Type: SecureString
Parameter Sets: ByObjectWithPrivateKey, ByPathWithPrivateKey
Aliases:

Required: True
Position: Named
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
Position: Named
Default value: $Script:TppSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### InputObject or Path
## OUTPUTS

### If OutPath not provided, a PSCustomObject will be returned with properties CertificateData, Filename, and Format.  Otherwise, no output.
## NOTES

## RELATED LINKS
