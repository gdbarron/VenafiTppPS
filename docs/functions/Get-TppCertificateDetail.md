# Get-TppCertificateDetail

## SYNOPSIS
Get basic or full details about certificates

## SYNTAX

### Basic
```
Get-TppCertificateDetail [-Query <Hashtable>] [-Limit <Int32>] [-TppSession <TppSession>] [<CommonParameters>]
```

### Full
```
Get-TppCertificateDetail -Guid <String[]> [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Get details about a certificate based on search criteria. 
See the examples for a few of the available options; the SDK provides a full list. 
See Certificates attribute filters, https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-Certificates-search-attribute.php, and Certificates status filters, https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-Certificates-search-status.php.
Additional details can be had by passing the guid.

## EXAMPLES

### EXAMPLE 1
```
Get-TppCertificateDetail -query @{'ValidToLess'='2018-04-30T00:00:00.0000000Z'}
```

Find all certificates expiring before a certain date

### EXAMPLE 2
```
Get-TppCertificateDetail -query @{'ParentDn'='\VED\Policy\My folder'}
```

Find all certificates in the specified folder

### EXAMPLE 3
```
Get-TppCertificateDetail -query @{'ParentDnRecursive'='\VED\Policy\My folder'}
```

Find all certificates in the specified folder and subfolders

### EXAMPLE 4
```
Get-TppCertificateDetail -query @{'ParentDnRecursive'='\VED\Policy\My folder'} -limit 20
```

Find all certificates in the specified folder and subfolders, but limit the results to 20

### EXAMPLE 5
```
$certs | Get-TppCertificateDetail
```

Get detailed certificate info after performing basic query

## PARAMETERS

### -Query
Hashtable providing 1 or more key/value pairs with search criteria.

```yaml
Type: Hashtable
Parameter Sets: Basic
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Limit how many items are returned. 
Default is 0 for no limit.
It is definitely recommended you provide a Query when searching with no limit.

```yaml
Type: Int32
Parameter Sets: Basic
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Guid
Guid representing a unique certificate in Venafi.

```yaml
Type: String[]
Parameter Sets: Full
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### Guid

## OUTPUTS

### Query returns a PSCustomObject with the following properties:
    Certificates
    DataRange
    TotalCount

Guid returns a PSCustomObject with the following properties:
    CertificateAuthorityDN
    CertificateDetails
    Consumers
    Contact
    CreatedOn
    CustomFields
    Description
    DN
    Guid
    ManagementType
    Name
    ParentDn
    ProcessingDetails
    RenewalDetails
    SchemaClass
    ValidationDetails

## NOTES

## RELATED LINKS

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppCertificateDetail.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppCertificateDetail.ps1)

