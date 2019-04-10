# Write-TppLog

## SYNOPSIS
Write entries to the TPP log

## SYNTAX

### DefaultGroup (Default)
```
Write-TppLog -EventGroup <TppEventGroup> -EventId <String> -Component <String> [-Severity <TppEventSeverity>]
 [-SourceIp <IPAddress>] [-ComponentID <Int32>] [-ComponentSubsystem <String>] [-Text1 <String>]
 [-Text2 <String>] [-Value1 <Int32>] [-Value2 <Int32>] [-TppSession <TppSession>] [<CommonParameters>]
```

### CustomGroup
```
Write-TppLog -CustomEventGroup <String> -EventId <String> -Component <String> [-Severity <TppEventSeverity>]
 [-SourceIp <IPAddress>] [-ComponentID <Int32>] [-ComponentSubsystem <String>] [-Text1 <String>]
 [-Text2 <String>] [-Value1 <Int32>] [-Value2 <Int32>] [-TppSession <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Write entries to the TPP Default SQL Channel log. 
Requires an event group and event.
Default and custom event groups are supported.

## EXAMPLES

### EXAMPLE 1
```
Write-TppLog -EventGroup WebSDKRESTAPI -EventId '0001' -Component '\ved\policy\mycert.com'
```

Log an event to a default group

### EXAMPLE 2
```
Write-TppLog -EventGroup '0200' -EventId '0001' -Component '\ved\policy\mycert.com'
```

Log an event to a custom group

## PARAMETERS

### -EventGroup
Default event group.

```yaml
Type: TppEventGroup
Parameter Sets: DefaultGroup
Aliases:
Accepted values: Logging, VenafiConfiguration, VenafiSecretStore, VenafiCredentials, VenafiPermissions, Vagent, VenafiDiscovery, Identity, VenafiCertificateManager, VenafiWorkflow, VenafiCertificateCore, AdminUI, VenafiCertificateAuthority, VenafiPlatform, VenafiSSHWorkflow, VenafiEncryption, VenafiMonitoring, VenafiValidationService, VenafiCredentialMonitoring, LogClient, VenafiReporter, VenafiMonitor, NetworkDeviceEnrollment, Aperture, CertificateRevocation, SSHManagerServiceModule, VenafiCAImport, SSHManagerClientRestModule, UserPortal, CertificateReports, ClientRestService, VenafiTrustNetIntegration, VenafiOnboardDiscovery, WebSDKRESTAPI, VenafiCloudInstanceMonitoring, ACMEService, VenafiSoftwareEncryption, VenafiHardwareEncryption, IdentityAD, IdentityLocal, IdentityLDAP, LogMsSql, LogSplunk, LogAdaptable, MicrosoftCA, SymantecMPKI, RedhatCA, EntrustDotNet, UniCERT, Thawte, RSA, GeoTrustCA, DigiCertCA, OpenSSLCA, GlobalSignMSSLCA, GeoTrustEnterpriseCA, OpenTrustPKICA, SelfsignedCA, TrustwaveCA, QuoVadisCA, HydrantIdCA, ComodoCCMCA, GeoTrustTrueFlexCA, Xolphin, AmazonCA, Adaptable, Apache, GlobalSecurityKit, IIS6, X509Certificate, VenafiSSH, VenafiHTTP, VenafiSQL, Pkcs12, Application, IIS5, CiscoACE, CiscoCSS, JavaKeystore, iPlanet, NetScaler, VAMnShield, DataPower, TealeafPCA, PEM, F5LTMAdvanced, Basic, ImpervaMX, A10AXTM, Layer7SSG, JuniperSAS, ConnectDirect, BlueCoat, PaloAlto, AmazonApp, AzureKeyVault, Common, RiverbedSteelHead, AdaptableApp, CAPI, AgentKeystore, AgentSsh, Migration, AWSEC2CloudInstanceMonitoringDriver, CyberArk, VenafiTools, Tracing

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomEventGroup
Custom Event Group ID, 4 characters.

```yaml
Type: String
Parameter Sets: CustomGroup
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventId
Event ID from within the EventGroup or CustomEventGroup provided. 
Only provide the 4 character event id, do not precede with group ID.

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

### -Component
The item this event is associated with. 
Typically, this is the Path (DN) of the object.

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

### -Severity
Severity of the event

```yaml
Type: TppEventSeverity
Parameter Sets: (All)
Aliases:
Accepted values: Emergency, Alert, Critical, Error, Warning, Notice, Info, Debug

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceIp
The IP that originated the event

```yaml
Type: IPAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ComponentID
Component ID that originated the event

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

### -ComponentSubsystem
Component subsystem that originated the event

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

### -Text1
String data to write to log. 
See link for event ID messages for more info.

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

### -Text2
String data to write to log. 
See link for event ID messages for more info.

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

### -Value1
Integer data to write to log. 
See link for event ID messages for more info.

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

### -Value2
Integer data to write to log. 
See link for event ID messages for more info.

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

### none
## OUTPUTS

### none
## NOTES

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Write-TppLog/](http://venafitppps.readthedocs.io/en/latest/functions/Write-TppLog/)

[https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Write-TppLog.ps1](https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Write-TppLog.ps1)

[https://docs.venafi.com/Docs/18.4SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Log.php?tocpath=REST%20API%20reference%7CLog%20programming%20interfaces%7C_____2](https://docs.venafi.com/Docs/18.4SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Log.php?tocpath=REST%20API%20reference%7CLog%20programming%20interfaces%7C_____2)

[https://support.venafi.com/hc/en-us/articles/360003460191-Info-Venafi-Trust-Protection-Platform-Event-ID-Messages-For-All-18-X-Releases](https://support.venafi.com/hc/en-us/articles/360003460191-Info-Venafi-Trust-Protection-Platform-Event-ID-Messages-For-All-18-X-Releases)

