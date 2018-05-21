# New-TppSession

## SYNOPSIS
Create a new Venafi TPP session

## SYNTAX

### Credential
```
New-TppSession -ServerUrl <String> -Credential <PSCredential> [-PassThru] [<CommonParameters>]
```

### UsernamePassword
```
New-TppSession -ServerUrl <String> -Username <String> -SecurePassword <SecureString> [-PassThru]
 [<CommonParameters>]
```

## DESCRIPTION
Authenticates a user via a username and password against a configured Trust
Protection Platform identity provider (e.g.
Active Directory, LDAP, or Local).
After
the user is authenticated, Trust Protection Platform returns an API key allowing
access to all other REST calls.

## EXAMPLES

### EXAMPLE 1
```
New-TppSession -ServerUrl https://venafitpp.mycompany.com -Credential $cred
```

Connect to the TPP server and store the session object in the script variable

### EXAMPLE 2
```
$sess = New-TppSession -ServerUrl https://venafitpp.mycompany.com -Credential $cred -PassThru
```

Connect to the TPP server and return the session object

## PARAMETERS

### -ServerUrl
URL for the Venafi server.

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

### -Credential
PSCredential object utilizing the same credentials as used for the web front-end

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
Username to authenticate to ServerUrl with

```yaml
Type: String
Parameter Sets: UsernamePassword
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecurePassword
SecureString password to authenticate to ServerUrl with

```yaml
Type: SecureString
Parameter Sets: UsernamePassword
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Optionally, send the session object to the pipeline.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject with the following properties:
    APIKey - Guid representing the current session with TPP
    Credential - Credential object provided to authenticate against TPP server.  This will be used to re-authenticate once the connection has expired.
    ServerUrl - URL to the TPP server
    ValidateUtil - DateTime when the session will expire.
    CustomField - PSCustomObject containing custom fields defined on this server.  Properties include:
        AllowedValues
        Classes
        ConfigAttribute
        DN
        DefaultValues
        Guid
        Label
        Mandatory
        Name
        Policyable
        RenderHidden
        RenderReadOnly
        Single
        Type

## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppSession/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppSession/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppSession.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/New-TppSession.ps1)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Authorize.php?TocPath=REST%20API%20reference|Authentication%20and%20API%20key%20programming%20interfaces|_____1](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Authorize.php?TocPath=REST%20API%20reference|Authentication%20and%20API%20key%20programming%20interfaces|_____1)

