# Get-TppCertificateDetail

## SYNOPSIS
Get basic or detailed certificate information

## SYNTAX

### ByPath
```
Get-TppCertificateDetail -Path <String> [-Recursive] [-Limit <Int32>] [-Country <String>]
 [-CommonName <String>] [-Issuer <String>] [-KeyAlgorithm <String[]>] [-KeySize <Int32[]>]
 [-KeySizeGreaterThan <Int32>] [-KeySizeLessThan <Int32>] [-Locale <String[]>] [-Organization <String[]>]
 [-OrganizationUnit <String[]>] [-State <String[]>] [-SanDns <String>] [-SanEmail <String>] [-SanIP <String>]
 [-SanUpn <String>] [-SanUri <String>] [-SerialNumber <String>] [-SignatureAlgorithm <String>]
 [-Thumbprint <String>] [-IssueDate <DateTime>] [-ExpireDate <DateTime>] [-ExpireAfter <DateTime>]
 [-ExpireBefore <DateTime>] [-Enabled <Boolean>] [-InError <Boolean>] [-NetworkValidationEnabled <Boolean>]
 [-CreateDate <DateTime>] [-CreatedAfter <DateTime>] [-CreatedBefore <DateTime>] [-ManagementType <String[]>]
 [-PendingWorkflow] [-Stage <Int32[]>] [-StageGreaterThan <Int32>] [-StageLessThan <Int32>]
 [-ValidationEnabled <Boolean>] [-ValidationState <String[]>] [-TppSession <TppSession>] [<CommonParameters>]
```

### NoPath
```
Get-TppCertificateDetail [-Limit <Int32>] [-Country <String>] [-CommonName <String>] [-Issuer <String>]
 [-KeyAlgorithm <String[]>] [-KeySize <Int32[]>] [-KeySizeGreaterThan <Int32>] [-KeySizeLessThan <Int32>]
 [-Locale <String[]>] [-Organization <String[]>] [-OrganizationUnit <String[]>] [-State <String[]>]
 [-SanDns <String>] [-SanEmail <String>] [-SanIP <String>] [-SanUpn <String>] [-SanUri <String>]
 [-SerialNumber <String>] [-SignatureAlgorithm <String>] [-Thumbprint <String>] [-IssueDate <DateTime>]
 [-ExpireDate <DateTime>] [-ExpireAfter <DateTime>] [-ExpireBefore <DateTime>] [-Enabled <Boolean>]
 [-InError <Boolean>] [-NetworkValidationEnabled <Boolean>] [-CreateDate <DateTime>] [-CreatedAfter <DateTime>]
 [-CreatedBefore <DateTime>] [-ManagementType <String[]>] [-PendingWorkflow] [-Stage <Int32[]>]
 [-StageGreaterThan <Int32>] [-StageLessThan <Int32>] [-ValidationEnabled <Boolean>]
 [-ValidationState <String[]>] [-TppSession <TppSession>] [<CommonParameters>]
```

### Full
```
Get-TppCertificateDetail -Guid <String[]> [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Get certificate info based on a variety of attributes.
Additional details can be had by passing the guid.

## EXAMPLES

### EXAMPLE 1
```
Get-TppCertificateDetail -ExpireBefore ([DateTime] "2018-01-01")
```

Find all certificates expiring before a certain date

### EXAMPLE 2
```
Get-TppCertificateDetail -ExpireBefore ([DateTime] "2018-01-01") -Limit 5
```

Find 5 certificates expiring before a certain date

### EXAMPLE 3
```
Get-TppCertificateDetail -Path '\VED\Policy\My Policy'
```

Find all certificates in a specific path

### EXAMPLE 4
```
Get-TppCertificateDetail -Path '\VED\Policy\My Policy' -Recursive
```

Find all certificates in a specific path and all subfolders

### EXAMPLE 5
```
Get-TppCertificateDetail -ExpireBefore ([DateTime] "2018-01-01") -Limit 5 | Get-TppCertificateDetail
```

Get detailed certificate info on the first 5 certificates expiring before a certain date

## PARAMETERS

### -Path
Starting path to search from

```yaml
Type: String
Parameter Sets: ByPath
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recursive
Search recursively starting from the search path.

```yaml
Type: SwitchParameter
Parameter Sets: ByPath
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Limit how many items are returned. 
Default is 0 for no limit.
It is definitely recommended to filter on another property when searching with no limit.

```yaml
Type: Int32
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Country
Find certificates by Country attribute of Subject DN.
Example - US

```yaml
Type: String
Parameter Sets: ByPath, NoPath
Aliases: C

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommonName
Find certificates by Common name attribute of Subject DN.
Example - test.venafi.com

```yaml
Type: String
Parameter Sets: ByPath, NoPath
Aliases: CN

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Issuer
Find certificates by issuer.
Use the CN ,O, L, S, and C values from the certificate request.
Surround the complete Issuer DN within double quotes (").
If a value DN already contains double quotes, enclose the string in a second set of double quotes.
Example - CN=Example Root CA, O=Venafi,Inc., L=Salt Lake City, S=Utah, C=US

```yaml
Type: String
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyAlgorithm
Find certificates by algorithm for the public key.
Example - 'RSA','DSA'

```yaml
Type: String[]
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeySize
Find certificates by public key size.
Example - 1024,2048

```yaml
Type: Int32[]
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeySizeGreaterThan
Find certificates with a key size greater than the specified value.
Example - 1024

```yaml
Type: Int32
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeySizeLessThan
Find certificates with a key size less than the specified value.
Example: 1025

```yaml
Type: Int32
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Locale
Find certificates by Locality/City attribute of Subject Distinguished Name (DN).
Example - London

```yaml
Type: String[]
Parameter Sets: ByPath, NoPath
Aliases: L

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Organization
Find certificates by Organization attribute of Subject DN.
Example - 'Venafi Inc.','BankABC'

```yaml
Type: String[]
Parameter Sets: ByPath, NoPath
Aliases: O

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrganizationUnit
Find certificates by Organization Unit (OU).
Example - 'Quality Assurance'

```yaml
Type: String[]
Parameter Sets: ByPath, NoPath
Aliases: OU

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Find certificates by State/Province attribute of Subject DN.
Example - 'New York', 'Georgia'

```yaml
Type: String[]
Parameter Sets: ByPath, NoPath
Aliases: S

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SanDns
Find certificates by Subject Alternate Name (SAN) Distinguished Name Server (DNS).
Example - sso.venafi.com

```yaml
Type: String
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SanEmail
Find certificates by SAN Email RFC822.
Example - first.last@venafi.com

```yaml
Type: String
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SanIP
Find certificates by SAN IP Address.
Example - '10.20.30.40'

```yaml
Type: String
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SanUpn
Find certificates by SAN User Principal Name (UPN) or OtherName.
Example - My.Email@venafi.com

```yaml
Type: String
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SanUri
Find certificates by SAN Uniform Resource Identifier (URI).
Example - https://login.venafi.com

```yaml
Type: String
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SerialNumber
Find certificates by Serial number.
Example - 13279B74000000000053

```yaml
Type: String
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SignatureAlgorithm
Find certificates by the algorithm used to sign the certificate (e.g.
SHA1RSA).
Example - 'sha1RSA','md5RSA','sha256RSA'

```yaml
Type: String
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Thumbprint
Find certificates by one or more SHA-1 thumbprints.
Example - 71E8672798C03842735293EF49425EF06C7FA8AB&

```yaml
Type: String
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IssueDate
Find certificates by the date of issue.
Example - \[DateTime\] '2017-10-24'

```yaml
Type: DateTime
Parameter Sets: ByPath, NoPath
Aliases: ValidFrom

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpireDate
Find certificates by expiration date.
Example - \[DateTime\] '2017-10-24'

```yaml
Type: DateTime
Parameter Sets: ByPath, NoPath
Aliases: ValidTo

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpireAfter
Find certificates that expire after a certain date.
Specify YYYY-MM-DD or the ISO 8601 format, for example YYYY-MM-DDTHH:MM:SS.mmmmmmmZ.
Example - \[DateTime\] '2017-10-24'

```yaml
Type: DateTime
Parameter Sets: ByPath, NoPath
Aliases: ValidToGreater

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpireBefore
Find certificates that expire before a certain date.
Specify YYYY-MM-DD or the ISO 8601 format, for example YYYY-MM-DDTHH:MM:SS.mmmmmmmZ.
Example - \[DateTime\] '2017-10-24'

```yaml
Type: DateTime
Parameter Sets: ByPath, NoPath
Aliases: ValidToLess

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled
Include only certificates that are enabled or disabled

```yaml
Type: Boolean
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -InError
Include only certificates by error state: No error or in an error state

```yaml
Type: Boolean
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkValidationEnabled
Include only certificates with network validation enabled or disabled

```yaml
Type: Boolean
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateDate
Find certificates that were created at an exact date and time

```yaml
Type: DateTime
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatedAfter
Find certificate created after this date and time

```yaml
Type: DateTime
Parameter Sets: ByPath, NoPath
Aliases: CreatedOnGreater

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatedBefore
Find certificate created before this date and time

```yaml
Type: DateTime
Parameter Sets: ByPath, NoPath
Aliases: CreatedOnLess

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagementType
Find certificates with a Management type of Unassigned, Monitoring, Enrollment, or Provisioning

```yaml
Type: String[]
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PendingWorkflow
Include only certificates that have a pending workflow resolution (have an outstanding workflow ticket)

```yaml
Type: SwitchParameter
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Stage
Find certificates by one or more stages in the certificate lifecycle

```yaml
Type: Int32[]
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StageGreaterThan
Find certificates with a stage greater than the specified stage (does not include specified stage)

```yaml
Type: Int32
Parameter Sets: ByPath, NoPath
Aliases: StageGreater

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StageLessThan
Find certificates with a stage less than the specified stage (does not include specified stage)

```yaml
Type: Int32
Parameter Sets: ByPath, NoPath
Aliases: StageLess

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidationEnabled
Include only certificates with validation enabled or disabled

```yaml
Type: Boolean
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidationState
Find certificates with a validation state of Blank, Success, or Failure

```yaml
Type: String[]
Parameter Sets: ByPath, NoPath
Aliases:

Required: False
Position: Named
Default value: None
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

### ByPath and NoPath parameter sets returns a PSCustomObject with the following properties:
###     CreatedOn
###     DN
###     Guid
###     Name
###     ParentDn
###     SchemaClass
###     _links
### Guid returns a PSCustomObject with the following properties:
###     CertificateAuthorityDN
###     CertificateDetails
###     Consumers
###     Contact
###     CreatedOn
###     CustomFields
###     Description
###     DN
###     Guid
###     ManagementType
###     Name
###     ParentDn
###     ProcessingDetails
###     RenewalDetails
###     SchemaClass
###     ValidationDetails
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppCertificateDetail/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppCertificateDetail/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppCertificateDetail.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppCertificateDetail.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Certificates.php?TocPath=REST%20API%20reference|Certificates%20module%20programming%20interfaces|_____3](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Certificates.php?TocPath=REST%20API%20reference|Certificates%20module%20programming%20interfaces|_____3)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Certificates-guid.php?TocPath=REST%20API%20reference|Certificates%20module%20programming%20interfaces|_____5](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Certificates-guid.php?TocPath=REST%20API%20reference|Certificates%20module%20programming%20interfaces|_____5)

[https://msdn.microsoft.com/en-us/library/system.web.httputility(v=vs.110).aspx](https://msdn.microsoft.com/en-us/library/system.web.httputility(v=vs.110).aspx)

