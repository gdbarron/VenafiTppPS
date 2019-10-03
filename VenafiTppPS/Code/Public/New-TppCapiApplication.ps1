<#
.SYNOPSIS
Create a new CAPI application

.DESCRIPTION
Create a new CAPI application

.PARAMETER Path
Full path, including name, to the application to be created.  The application must be created under a device.
Alternatively, provide the path to the device and provide ApplicationName.

.PARAMETER ApplicationName
1 or more application names to create.  Path must be a path to a device.

.PARAMETER FriendlyName
Optional friendly name

.PARAMETER CertificatePath
Path to the certificate to associate to the new application

.PARAMETER CredentialPath
Path to the associated credential which has rights to access the connected device

.PARAMETER Disable
Set processing to disabled.  It is enabled by default.

.PARAMETER ProvisionCertificate
Push the certificate to the application.  CertificatePath must be provided.

.PARAMETER SkipExistenceCheck
By default, the paths for the new application, certifcate, and credential will be validated for existence.
Specify this switch to bypass this check.

.PARAMETER PassThru
Return a TppObject representing the newly created capi app.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Path

.OUTPUTS
TppObject, if PassThru provided

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppCapiApplication/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppCapiApplication.ps1

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppObject.ps1

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Find-TppCertificate/

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppObject/

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-create.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____9

#>
function New-TppCapiApplication {

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'NonIis')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '')]

    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [string] $Path,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]] $ApplicationName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('CertificateDN')]
        [String] $CertificatePath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('CredentialDN')]
        [String] $CredentialPath,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String] $FriendlyName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String] $Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Int] $WinRmPort,

        [Parameter()]
        [Switch] $Disable,

        [Parameter(Mandatory, ParameterSetName = 'Iis')]
        [ValidateNotNullOrEmpty()]
        [String] $WebSiteName,

        [Parameter(ParameterSetName = 'Iis')]
        [ValidateNotNullOrEmpty()]
        [ipaddress] $BindingIpAddress,

        [Parameter(ParameterSetName = 'Iis')]
        [ValidateNotNullOrEmpty()]
        [Int] $BindingPort,

        [Parameter(ParameterSetName = 'Iis')]
        [ValidateNotNullOrEmpty()]
        [String] $BindingHostName,

        [Parameter(ParameterSetName = 'Iis')]
        [ValidateNotNullOrEmpty()]
        [Bool] $CreateBinding,

        [Parameter()]
        [switch] $ProvisionCertificate,

        [Parameter()]
        [switch] $SkipExistenceCheck,

        [Parameter()]
        [switch] $PassThru,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {

        $TppSession.Validate()

        if ( $PSBoundParameters.ContainsKey('ProvisionCertificate') -and (-not $PSBoundParameters.ContainsKey('CertificatePath')) ) {
            throw 'A CertificatePath must be provided when using ProvisionCertificate'
        }

        if ( -not $PSBoundParameters.ContainsKey('SkipExistenceCheck') ) {

            if ( $PSBoundParameters.ContainsKey('CertificatePath') ) {
                $certPath = (Split-Path $CertificatePath -Parent)
                $certName = (Split-Path $CertificatePath -Leaf)
                $certObject = Find-TppCertificate -Path $certPath -TppSession $TppSession

                if ( -not $certObject -or ($certName -notin $certObject.Name) ) {
                    throw ('A certificate object could not be found at ''{0}''' -f $CertificatePath)
                }
            }

            # ensure the credential exists and is actually of type credential
            if ( $PSBoundParameters.ContainsKey('CredentialPath') ) {

                $credObject = Get-TppObject -Path $CredentialPath -TppSession $TppSession

                if ( -not $credObject -or $credObject.TypeName -notlike '*credential*' ) {
                    throw ('A credential object could not be found at ''{0}''' -f $CredentialPath)
                }
            }
        }

        $params = @{
            Path       = ''
            Class      = 'CAPI'
            Attribute  = @{
                'Driver Name' = 'appcapi'
            }
            PassThru   = $true
            TppSession = $TppSession
        }

        if ( $PSBoundParameters.ContainsKey('FriendlyName') ) {
            $params.Attribute.Add('Friendly Name', $FriendlyName)
        }

        if ( $PSBoundParameters.ContainsKey('CertificatePath') ) {
            $params.Attribute.Add('Certificate', $CertificatePath)
        }

        if ( $PSBoundParameters.ContainsKey('CredentialPath') ) {
            $params.Attribute.Add('Credential', $CredentialPath)
        }

        if ( $PSBoundParameters.ContainsKey('ProvisionCertificate') ) {
            $params.Attribute.Add('ProvisionCertificate', $true)
        }

        if ( $PSBoundParameters.ContainsKey('Disabled') ) {
            $params.Attribute.Add('Disabled', '1')
        }

        if ( $PSBoundParameters.ContainsKey('WebSiteName') ) {
            $params.Attribute.Add('Update IIS', '1')
            $params.Attribute.Add('Web Site Name', $WebSiteName)
        }

        if ( $PSBoundParameters.ContainsKey('BindingIpAddress') ) {
            $params.Attribute.Add('Binding IP Address', $BindingIpAddress.ToString())
        }

        if ( $PSBoundParameters.ContainsKey('BindingPort') ) {
            $params.Attribute.Add('Binding Port', $BindingPort)
        }

        if ( $PSBoundParameters.ContainsKey('BindingHostName') ) {
            $params.Attribute.Add('Hostname', $BindingHostName)
        }

        if ( $PSBoundParameters.ContainsKey('CreateBinding') ) {
            $params.Attribute.Add('Create Binding', $CreateBinding)
        }
    }

    process {

        if ( -not $PSBoundParameters.ContainsKey('SkipExistenceCheck') ) {

            # ensure the parent path exists and is of type device
            if ( $PSBoundParameters.ContainsKey('ApplicationName') ) {
                $devicePath = $Path
            }
            else {
                $devicePath = (Split-Path $Path -Parent)
            }

            $device = Get-TppObject -Path $devicePath -TppSession $TppSession

            if ( $device ) {
                if ( $device.TypeName -ne 'Device' ) {
                    throw ('A device object could not be found at ''{0}''' -f $devicePath)
                }
            }
            else {
                throw ('No object was found at the parent path ''{0}''' -f $devicePath)
            }
        }

        if ( $PSBoundParameters.ContainsKey('ApplicationName') ) {
            $appPaths = $ApplicationName | ForEach-Object {
                $Path + "\$_"
            }
        }
        else {
            $appPaths = @($Path)
        }

        foreach ($thisPath in $appPaths) {

            $params.Path = $thisPath

            if ( $PSCmdlet.ShouldProcess($thisPath, 'Create CAPI application Object') ) {

                $response = New-TppObject @params

                if ( $PassThru ) {
                    $response
                }
            }
        }
    }
}