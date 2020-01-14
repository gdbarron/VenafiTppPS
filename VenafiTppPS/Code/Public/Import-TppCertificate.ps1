<#
.SYNOPSIS
Import a certificate

.DESCRIPTION
Import a certificate with or without private key.

.PARAMETER CertificatePath
Policy path to import the certificate to

.PARAMETER FilePath
Path to a certificate file.  Provide either this or CertificateData.

.PARAMETER CertificateData
Contents of a certificate to import.  Provide either this or FilePath.

.PARAMETER EnrollmentAttribute
A hashtable providing any CA attributes to store with the Certificate object, and then submit to the CA during enrollment

.PARAMETER Name
Friendly name for the certificate object.  Required if replacing an existing certificate.

.PARAMETER PrivateKey
The private key data. Requires a Password. For a PEM certificate, the private key is in either the RSA or PKCS#8 format. If the CertificateData field contains a PKCS#12 formatted certificate, this parameter is ignored because only one private key is allowed.

.PARAMETER Password
Password required when including a private key.

.PARAMETER Overwrite
Import and replace, the default is to use the latest certificate with the most recent 'Valid From' date.
Import the certificate into the PolicyDN regardless of whether a past, future, or same version of the certificate exists.
Name must be provided.

.PARAMETER PassThru
Return a TppObject representing the newly imported object.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.EXAMPLE
Import-TppCertificate -CertificatePath \ved\policy\mycerts -FilePath c:\www.venafitppps.com.cer
Import a certificate

.EXAMPLE
Import-TppCertificate -CertificatePath \ved\policy\mycerts -FilePath c:\www.venafitppps.com.cer -Name www.venafitppps.com -Overwrite
Import a certificate with overwrite

.INPUTS
None

.OUTPUTS
TppObject, if PassThru provided

.NOTES
Must have Master Admin permission or must have View, Read, Write, Create and Private Key Write permission to the Certificate object.
#>
function Import-TppCertificate {
    [CmdletBinding(DefaultParameterSetName = 'ByFile')]
    param (

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [String] $CertificatePath,

        [Parameter(Mandatory, ParameterSetName = 'ByFile')]
        [Parameter(Mandatory, ParameterSetName = 'ByFileWithPrivateKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-Path ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid path"
                }
            })]
        [String] $FilePath,

        [Parameter(Mandatory, ParameterSetName = 'ByData')]
        [Parameter(Mandatory, ParameterSetName = 'ByDataWithPrivateKey')]
        [String] $CertificateData,

        [Parameter()]
        [String] $Name,

        [Parameter()]
        [Hashtable] $EnrollmentAttribute,

        [Parameter(Mandatory, ParameterSetName = 'ByFileWithPrivateKey')]
        [Parameter(Mandatory, ParameterSetName = 'ByDataWithPrivateKey')]
        [String] $PrivateKey,

        [Parameter(Mandatory, ParameterSetName = 'ByFileWithPrivateKey')]
        [Parameter(Mandatory, ParameterSetName = 'ByDataWithPrivateKey')]
        [SecureString] $Password,

        [Parameter()]
        [switch] $Overwrite,

        [Parameter()]
        [switch] $PassThru,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {

        $TppSession.Validate()

        if ( $PSBoundParameters.ContainsKey('FilePath') ) {
            # get cert data from file
            $CertificateData = Get-Content -Path $FilePath -Raw
        }

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'certificates/import'
            Body       = @{
                PolicyDN        = $CertificatePath
                CertificateData = $CertificateData
                Reconcile       = 'true'
            }
        }

        if ( $PSBoundParameters.ContainsKey('EnrollmentAttribute') ) {
            $updatedAttribute = @($EnrollmentAttribute.GetEnumerator() | ForEach-Object { @{'Name' = $_.name; 'Value' = $_.value } })
            $params.Body.CASpecificAttributes = $updatedAttribute

        }

        if ( $PSBoundParameters.ContainsKey('Overwrite') ) {
            if (-not $PSBoundParameters.ContainsKey('Name') ) {
                throw 'Name must be provided when using the Overwrite option'
            }
            $params.Body.Reconcile = 'false'
        }

        if ( $PSBoundParameters.ContainsKey('Name') ) {
            $params.Body.ObjectName = $Name
        }

        if ( $PSBoundParameters.ContainsKey('PrivateKey') ) {
            $params.Body.PrivateKeyData = $PrivateKey
            $plainTextPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
            $params.Body.Password = $plainTextPassword
        }

        try {

            $response = Invoke-TppRestMethod @params
            Write-Verbose ('Successfully imported certificate')

            if ( $PassThru ) {
                $response.CertificateDN | Get-TppObject
            }
        }
        catch {
            throw $_
        }
    }

    process {
    }
}
