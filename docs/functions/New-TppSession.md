# New-TppSession

## SYNOPSIS
Create a new Venafi TPP session

## SYNTAX

### KeyIntegrated (Default)
```
New-TppSession -Server <String> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### TppToken
```
New-TppSession [-Server <String>] -TppToken <PSObject> [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### AccessToken
```
New-TppSession -Server <String> -AccessToken <String> [-AuthServer <String>] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### TokenCertificate
```
New-TppSession -Server <String> -Certificate <X509Certificate> [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### TokenIntegrated
```
New-TppSession -Server <String> -ClientId <String> -Scope <Hashtable> [-State <String>] [-AuthServer <String>]
 [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### TokenOAuth
```
New-TppSession -Server <String> -Credential <PSCredential> -ClientId <String> -Scope <Hashtable>
 [-State <String>] [-AuthServer <String>] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### KeyCredential
```
New-TppSession -Server <String> -Credential <PSCredential> [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Authenticate a user and create a new session with which future calls can be made.
Key based username/password and windows integrated are supported as well as token-based integrated, oauth, and certificate.
Note, key-based authentication will be fully deprecated in v20.4.

## EXAMPLES

### EXAMPLE 1
```
New-TppSession -Server venafitpp.mycompany.com
```

Create key-based session using Windows Integrated authentication

### EXAMPLE 2
```
New-TppSession -Server venafitpp.mycompany.com -Credential $cred
```

Create key-based session using Windows Integrated authentication

### EXAMPLE 3
```
New-TppSession -Server venafitpp.mycompany.com -ClientId MyApp
```

Connect using token-based Windows Integrated authentication with the 'any' scope

### EXAMPLE 4
```
New-TppSession -Server venafitpp.mycompany.com -ClientId MyApp -Scope @{'certificate'='manage'}
```

Create token-based session using Windows Integrated authentication with a certain scope and privilege restriction

### EXAMPLE 5
```
New-TppSession -Server venafitpp.mycompany.com -AuthServer tppauth.mycompany.com -ClientId MyApp -Credential $cred
```

Create token-based session using oauth authentication where the vedauth and vedsdk are hosted on different servers

### EXAMPLE 6
```
$sess = New-TppSession -Server venafitpp.mycompany.com -Credential $cred -PassThru
```

Create session and return the session object instead of setting to script scope variable

## PARAMETERS

### -Server
Server or url to access vedsdk, venafi.company.com or https://venafi.company.com.
If AuthServer is not provided, this will be used to access vedauth as well for token-based authentication.
If just the server name is provided, https:// will be appended.

```yaml
Type: String
Parameter Sets: KeyIntegrated, AccessToken, TokenCertificate, TokenIntegrated, TokenOAuth, KeyCredential
Aliases: ServerUrl

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: TppToken
Aliases: ServerUrl

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Username and password used for key and token-based authentication. 
Not required for integrated authentication.

```yaml
Type: PSCredential
Parameter Sets: TokenOAuth, KeyCredential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
Applcation Id configured in Venafi for token-based authentication

```yaml
Type: String
Parameter Sets: TokenIntegrated, TokenOAuth
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
Hashtable with Scopes and privilege restrictions.
The key is the scope and the value is one or more privilege restrictions separated by commas.
For a privilege restriction of none or read, use a value of $null.
Scopes include Agent, Certificate, Code Signing, Configuration, Restricted, Security, SSH, and statistics.
See https://docs.venafi.com/Docs/20.1/TopNav/Content/SDK/AuthSDK/r-SDKa-OAuthScopePrivilegeMapping.php?tocpath=Topics%20by%20Guide%7CDeveloper%27s%20Guide%7CAuth%20SDK%20reference%20for%20token%20management%7C_____6 for more info.

```yaml
Type: Hashtable
Parameter Sets: TokenIntegrated, TokenOAuth
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
A session state, redirect URL, or random string to prevent Cross-Site Request Forgery (CSRF) attacks

```yaml
Type: String
Parameter Sets: TokenIntegrated, TokenOAuth
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TppToken
Token object obtained from New-TppToken

```yaml
Type: PSObject
Parameter Sets: TppToken
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessToken
Access token retrieved from TPP

```yaml
Type: String
Parameter Sets: AccessToken
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Certificate
Certificate for token-based authentication

```yaml
Type: X509Certificate
Parameter Sets: TokenCertificate
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthServer
Optional server or url to access vedauth, venafi.company.com or https://venafi.company.com.
If AuthServer is not provided, the value provided for Server will be used.
If just the server name is provided, https:// will be appended.

```yaml
Type: String
Parameter Sets: AccessToken, TokenIntegrated, TokenOAuth
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Optionally, send the session object to the pipeline instead of script scope.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### TppSession, if PassThru is provided
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/New-TppSession/](http://venafitppps.readthedocs.io/en/latest/functions/New-TppSession/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppSession.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppSession.ps1)

[https://docs.venafi.com/Docs/19.4/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Authorize.php?tocpath=Topics%20by%20Guide%7CDeveloper%27s%20Guide%7CWeb%20SDK%20reference%7CAuthentication%20programming%20interfaces%7C_____1](https://docs.venafi.com/Docs/19.4/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Authorize.php?tocpath=Topics%20by%20Guide%7CDeveloper%27s%20Guide%7CWeb%20SDK%20reference%7CAuthentication%20programming%20interfaces%7C_____1)

[https://docs.venafi.com/Docs/19.4/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Authorize-Integrated.php?tocpath=Topics%20by%20Guide%7CDeveloper%27s%20Guide%7CWeb%20SDK%20reference%7CAuthentication%20programming%20interfaces%7C_____3](https://docs.venafi.com/Docs/19.4/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Authorize-Integrated.php?tocpath=Topics%20by%20Guide%7CDeveloper%27s%20Guide%7CWeb%20SDK%20reference%7CAuthentication%20programming%20interfaces%7C_____3)

[https://docs.venafi.com/Docs/20.1SDK/TopNav/Content/SDK/AuthSDK/r-SDKa-POST-Authorize-Integrated.php?tocpath=Auth%20SDK%20reference%20for%20token%20management%7C_____10](https://docs.venafi.com/Docs/20.1SDK/TopNav/Content/SDK/AuthSDK/r-SDKa-POST-Authorize-Integrated.php?tocpath=Auth%20SDK%20reference%20for%20token%20management%7C_____10)

[https://docs.venafi.com/Docs/20.1SDK/TopNav/Content/SDK/AuthSDK/r-SDKa-POST-AuthorizeOAuth.php?tocpath=Auth%20SDK%20reference%20for%20token%20management%7C_____11](https://docs.venafi.com/Docs/20.1SDK/TopNav/Content/SDK/AuthSDK/r-SDKa-POST-AuthorizeOAuth.php?tocpath=Auth%20SDK%20reference%20for%20token%20management%7C_____11)

[https://docs.venafi.com/Docs/20.1/TopNav/Content/SDK/AuthSDK/r-SDKa-POST-AuthorizeCertificate.php?tocpath=Topics%20by%20Guide%7CDeveloper%27s%20Guide%7CAuth%20SDK%20reference%20for%20token%20management%7C_____9](https://docs.venafi.com/Docs/20.1/TopNav/Content/SDK/AuthSDK/r-SDKa-POST-AuthorizeCertificate.php?tocpath=Topics%20by%20Guide%7CDeveloper%27s%20Guide%7CAuth%20SDK%20reference%20for%20token%20management%7C_____9)

