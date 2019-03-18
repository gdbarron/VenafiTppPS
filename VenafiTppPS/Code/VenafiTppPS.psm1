<#
.SYNOPSIS
PowerShell module to access the features of Venafi Trust Protection Platform REST API

.DESCRIPTION
Author: Greg Brownstein
#>

$folders = @('Enum', 'Class', 'Public', 'Private')

foreach ( $folder in $folders) {

    $files = Get-ChildItem -Path $PSScriptRoot\$folder\*.ps1 -Recurse

    Foreach ( $thisFile in $files ) {
        Try {
            . $thisFile.fullname
        }
        Catch {
            Write-Error ("Failed to import function {0}: {1}" -f $thisFile.fullname, $folder)
        }
    }
}

$publicFiles = Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -Recurse -ErrorAction SilentlyContinue
Export-ModuleMember -Function $publicFiles.Basename

$Script:TppSupportedVersion = ConvertFrom-Json (Get-Content "$PSScriptRoot\Config\SupportedVersion.json" -Raw)
Export-ModuleMember -variable TppSupportedVersion

$Script:TppSession = New-Object 'TppSession'
Export-ModuleMember -variable TppSession

Set-Alias -Name 'ConvertTo-TppDN' -Value 'ConvertTo-TppPath'
Set-Alias -Name 'Get-TppWorkflowDetail' -Value 'Get-TppWorkflowTicket'
Set-Alias -Name 'Get-TppIdentity' -Value 'Find-TppIdentity'
Set-Alias -Name 'Restore-TppCertificate' -Value 'Invoke-TppCertificateRenewal'
Set-Alias -Name 'Get-TppLog' -Value 'Read-TppLog'
Export-ModuleMember -Alias *

$TppEventGroupHash = @{
    Logging                             = '0001'
    VenafiConfiguration                 = '0002'
    VenafiSecretStore                   = '0003'
    VenafiCredentials                   = '0004'
    VenafiPermissions                   = '0005'
    Vagent                              = '0006'
    VenafiDiscovery                     = '0007'
    Identity                            = '0008'
    VenafiCertificateManager            = '0009'
    VenafiWorkflow                      = '000A'
    VenafiCertificateCore               = '000B'
    AdminUI                             = '000C'
    VenafiCertificateAuthority          = '000D'
    VenafiPlatform                      = '000E'
    VenafiSSHWorkflow                   = '000F'
    VenafiEncryption                    = '0011'
    VenafiMonitoring                    = '0013'
    VenafiValidationService             = '0014'
    VenafiCredentialMonitoring          = '0015'
    LogClient                           = '0016'
    VenafiReporter                      = '0017'
    VenafiMonitor                       = '0018'
    NetworkDeviceEnrollment             = '001A'
    Aperture                            = '001B'
    CertificateRevocation               = '001C'
    SSHManagerServiceModule             = '001D'
    VenafiCAImport                      = '001E'
    SSHManagerClientRestModule          = '0020'
    UserPortal                          = '0023'
    CertificateReports                  = '0024'
    ClientRestService                   = '0025'
    VenafiTrustNetIntegration           = '0026'
    VenafiOnboardDiscovery              = '0027'
    WebSDKRESTAPI                       = '0029'
    VenafiCloudInstanceMonitoring       = '0031'
    ACMEService                         = '0032'
    VenafiSoftwareEncryption            = '1004'
    VenafiHardwareEncryption            = '1005'
    IdentityAD                          = '1008'
    IdentityLocal                       = '1009'
    IdentityLDAP                        = '100A'
    LogMsSql                            = '2001'
    LogSplunk                           = '2003'
    LogAdaptable                        = '2100'
    MicrosoftCA                         = '3002'
    SymantecMPKI                        = '3003'
    RedhatCA                            = '3004'
    EntrustDotNet                       = '3007'
    UniCERT                             = '3008'
    Thawte                              = '3009'
    RSA                                 = '300A'
    GeoTrustCA                          = '300B'
    DigiCertCA                          = '300C'
    OpenSSLCA                           = '300D'
    GlobalSignMSSLCA                    = '300E'
    GeoTrustEnterpriseCA                = '300F'
    OpenTrustPKICA                      = '3011'
    SelfsignedCA                        = '3013'
    TrustwaveCA                         = '3014'
    QuoVadisCA                          = '3015'
    HydrantIdCA                         = '3016'
    ComodoCCMCA                         = '3017'
    GeoTrustTrueFlexCA                  = '3019'
    Xolphin                             = '3021'
    AmazonCA                            = '3022'
    Adaptable                           = '3091'
    Apache                              = '4001'
    GlobalSecurityKit                   = '4002'
    IIS6                                = '4003'
    X509Certificate                     = '4005'
    VenafiSSH                           = '4006'
    VenafiHTTP                          = '4007'
    VenafiSQL                           = '4008'
    Pkcs12                              = '4009'
    Application                         = '400A'
    IIS5                                = '400B'
    CiscoACE                            = '400C'
    CiscoCSS                            = '400D'
    JavaKeystore                        = '400E'
    iPlanet                             = '4010'
    NetScaler                           = '4014'
    VAMnShield                          = '4015'
    DataPower                           = '4017'
    TealeafPCA                          = '4018'
    PEM                                 = '4019'
    F5LTMAdvanced                       = '401A'
    Basic                               = '401B'
    ImpervaMX                           = '401C'
    A10AXTM                             = '401D'
    Layer7SSG                           = '401E'
    JuniperSAS                          = '401F'
    ConnectDirect                       = '4020'
    BlueCoat                            = '4021'
    PaloAlto                            = '4022'
    AmazonApp                           = '4023'
    AzureKeyVault                       = '4024'
    Common                              = '4100'
    RiverbedSteelHead                   = '4666'
    AdaptableApp                        = '4668'
    CAPI                                = '4FFF'
    AgentKeystore                       = '5001'
    AgentSsh                            = '5002'
    Migration                           = '6001'
    AWSEC2CloudInstanceMonitoringDriver = '7001'
    CyberArk                            = '8001'
    VenafiTools                         = 'FFFE'
    Tracing                             = 'FFFF'
}