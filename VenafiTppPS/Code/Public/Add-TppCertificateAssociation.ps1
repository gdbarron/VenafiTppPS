<#
.SYNOPSIS
Add certificate association

.DESCRIPTION
Associates one or more Application objects to an existing certificate.
Optionally, you can provision the certificate once the association is complete.

.PARAMETER InputObject
TppObject which represents a certificate

.PARAMETER CertificatePath
Path to the certificate.  Required if InputObject not provided.

.PARAMETER ApplicationPath
List of application object paths to associate

.PARAMETER ProvisionCertificate
Provision the certificate after associating it to the Application objects.
This will only be successful if the certificate management type is Provisioning and is not disabled, in error, or the provisioning is already in process.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
InputObject, Path

.OUTPUTS
None

.EXAMPLE
Add-TppCertificateAssocation -CertificatePath '\ved\policy\my cert' -ApplicationPath '\ved\policy\my capi'
Add a single application object association

.EXAMPLE
Add-TppCertificateAssocation -Path '\ved\policy\my cert' -ApplicationPath '\ved\policy\my capi' -ProvisionCertificate
Add the association and provision the certificate

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Add-TppCertificateAssociation/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Add-TppCertificateAssociation.ps1

.LINK
https://docs.venafi.com/Docs/19.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-Associate.php?tocpath=REST%20API%20reference%7CCertificates%20programming%20interface%7C_____6

.NOTES
You must have:
- Write permission to the Certificate object.
- Write or Associate and Delete permission to Application objects that are associated with the certificate

#>
function Add-TppCertificateAssociation {

    [CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory, ParameterSetName = 'AddByObject', ValueFromPipeline)]
        [TppObject] $InputObject,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'AddByPath')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('DN', 'CertificateDN')]
        [String] $CertificatePath,

        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [String[]] $ApplicationPath,

        [Parameter()]
        [switch] $ProvisionCertificate,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'Certificates/Associate'
            Body       = @{
                CertificateDN = ''
                ApplicationDN = ''
            }
        }

        if ( $ProvisionCertificate ) {
            $params.Body.Add('PushToNew', 'true')
        }
    }

    process {

        if ( $PSBoundParameters.ContainsKey('InputObject') ) {
            $CertificatePath = $InputObject.Path
        }

        $params.Body = @{
            'CertificateDN' = $CertificatePath
            'ApplicationDN' = @($ApplicationPath)
        }

        try {
            if ( $PSCmdlet.ShouldProcess($CertificatePath, 'Add association') ) {
                $null = Invoke-TppRestMethod @params
            }
        }
        catch {
            $myError = $_.ToString() | ConvertFrom-Json
            Write-Error ($myError.Error)
        }
    }
}
