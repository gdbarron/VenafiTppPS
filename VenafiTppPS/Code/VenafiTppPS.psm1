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

# since these aren't typical integer values, we can't use a true enum
$TppEventGroup = @{
    'Logging'                                  = '0001'
    'Venafi Configuration'                     = '0002'
    'Venafi SecretStore'                       = '0003'
    'Venafi Credentials'                       = '0004'
    'Venafi Permissions'                       = '0005'
    'Vagent'                                   = '0006'
    'Venafi Discovery'                         = '0007'
    'Identity'                                 = '0008'
    'Venafi Certificate Manager'               = '0009'
    'Venafi Workflow'                          = '000A'
    'Venafi Certificate Core'                  = '000B'
    'Admin UI'                                 = '000C'
    'Venafi Certificate Authority'             = '000D'
    'Venafi Platform'                          = '000E'
    'Venafi SSH Workflow'                      = '000F'
    'Venafi Encryption'                        = '0011'
    'Venafi Monitoring'                        = '0013'
    'Venafi Validation Service'                = '0014'
    'Venafi Credential Monitoring'             = '0015'
    'Log Client'                               = '0016'
    'Venafi Reporter'                          = '0017'
    'Venafi Monitor'                           = '0018'
    'Network Device Enrollment'                = '001A'
    'Aperture'                                 = '001B'
    'Certificate Revocation'                   = '001C'
    'SSHManager Service Module'                = '001D'
    'Venafi CA Import'                         = '001E'
    'SSHManager ClientRest Module'             = '0020'
    'User Portal'                              = '0023'
    'Certificate Reports'                      = '0024'
    'Client Rest Service'                      = '0025'
    'Venafi TrustNet Integration'              = '0026'
    'Venafi Onboard Discovery'                 = '0027'
    'WebSDK REST API'                          = '0029'
    'Venafi Cloud Instance Monitoring'         = '0031'
    'ACME Service'                             = '0032'
    'Venafi Software Encryption'               = '1004'
    'Venafi Hardware Encryption'               = '1005'
    'Identity AD'                              = '1008'
    'Identity Local'                           = '1009'
    'Identity LDAP'                            = '100A'
    'LogMsSql'                                 = '2001'
    'LogSplunk'                                = '2003'
    'LogAdaptable'                             = '2100'
    'Microsoft CA'                             = '3002'
    'Symantec MPKI'                            = '3003'
    'Redhat CA'                                = '3004'
    'Entrust.Net'                              = '3007'
    'UniCERT'                                  = '3008'
    'Thawte'                                   = '3009'
    'RSA'                                      = '300A'
    'GeoTrust CA'                              = '300B'
    'DigiCert CA'                              = '300C'
    'OpenSSL CA'                               = '300D'
    'GlobalSign MSSL CA'                       = '300E'
    'GeoTrust Enterprise CA'                   = '300F'
    'OpenTrust PKI CA'                         = '3011'
    'Self-signed CA'                           = '3013'
    'Trustwave CA'                             = '3014'
    'QuoVadis CA'                              = '3015'
    'HydrantId CA'                             = '3016'
    'Comodo CCM CA'                            = '3017'
    'GeoTrust TrueFlex CA'                     = '3019'
    'Xolphin'                                  = '3021'
    'Amazon CA'                                = '3022'
    'Adaptable'                                = '3091'
    'Apache'                                   = '4001'
    'Global Security Kit'                      = '4002'
    'IIS6'                                     = '4003'
    'X509 Certificate'                         = '4005'
    'Venafi SSH'                               = '4006'
    'Venafi HTTP'                              = '4007'
    'Venafi SQL'                               = '4008'
    'Pkcs12'                                   = '4009'
    'Application'                              = '400A'
    'IIS5'                                     = '400B'
    'Cisco ACE'                                = '400C'
    'Cisco CSS'                                = '400D'
    'Java Keystore'                            = '400E'
    'iPlanet'                                  = '4010'
    'NetScaler'                                = '4014'
    'VAM nShield'                              = '4015'
    'DataPower'                                = '4017'
    'Tealeaf PCA'                              = '4018'
    'PEM'                                      = '4019'
    'F5LTMAdvanced'                            = '401A'
    'Basic'                                    = '401B'
    'Imperva MX'                               = '401C'
    'A10AXTM'                                  = '401D'
    'Layer 7 SSG'                              = '401E'
    'Juniper SAS'                              = '401F'
    'ConnectDirect'                            = '4020'
    'BlueCoat'                                 = '4021'
    'PaloAlto'                                 = '4022'
    'Amazon App'                               = '4023'
    'Azure Key Vault'                          = '4024'
    'Common'                                   = '4100'
    'Riverbed SteelHead'                       = '4666'
    'Adaptable App'                            = '4668'
    'CAPI'                                     = '4FFF'
    'AgentKeystore'                            = '5001'
    'AgentSsh'                                 = '5002'
    'Migration'                                = '6001'
    'AWS EC2 Cloud Instance Monitoring Driver' = '7001'
    'CyberArk'                                 = '8001'
    'Venafi Tools'                             = 'FFFE'
    'Tracing'                                  = 'FFFF'
}
Export-ModuleMember -Variable TppEventGroup