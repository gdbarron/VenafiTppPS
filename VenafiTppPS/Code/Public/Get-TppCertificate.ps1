<#
.SYNOPSIS
Get a certificate

.DESCRIPTION
Get a certificate with or without private key.
You have the option of simply getting the data or saving it to a file.

.PARAMETER InputObject
TppObject which represents a unique object

.PARAMETER Path
Path to the certificate object to retrieve

.PARAMETER Format
The format of the returned certificate.

.PARAMETER OutPath
Folder path to save the certificate to.  The name of the file will be determined automatically.

.PARAMETER IncludeChain
Include the certificate chain with the exported certificate.

.PARAMETER FriendlyName
The exported certificate's FriendlyName attribute. This parameter is required when Format is JKS.

.PARAMETER IncludePrivateKey
Include the private key.  The Format chosen must support private keys.

.PARAMETER SecurePassword
Password required when including a private key.  You must adhere to the following rules:
- Password is at least 12 characters.
- Comprised of at least three of the following:
    - Uppercase alphabetic letters
    - Lowercase alphabetic letters
    - Numeric characters
    - Special characters

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.EXAMPLE
$certs | Get-TppCertificate -Format 'PKCS #7' -OutPath 'c:\temp'
Get one or more certificates

.EXAMPLE

$certs | Get-TppCertificate -Format 'PKCS #7' -OutPath 'c:\temp' -IncludeChain
Get one or more certificates with the certificate chain included

.EXAMPLE

$certs | Get-TppCertificate -Format 'PKCS #7' -OutPath 'c:\temp' -IncludeChain -FriendlyName 'MyFriendlyName'
Get one or more certificates with the certificate chain included and friendly name attribute specified

.EXAMPLE
$certs | Get-TppCertificate -Format 'PKCS #12' -OutPath 'c:\temp' -IncludePrivateKey -SecurePassword ($password | ConvertTo-SecureString -asPlainText -Force)
Get one or more certificates with private key included

.EXAMPLE
$certs | Get-TppCertificate -Format 'PKCS #12' -OutPath 'c:\temp' -IncludeChain -IncludePrivateKey -SecurePassword ($password | ConvertTo-SecureString -asPlainText -Force)
Get one or more certificates with private key and certificate chain included

.EXAMPLE
$certs | Get-TppCertificate -Format 'PKCS #12' -OutPath 'c:\temp' -IncludeChain -FriendlyName 'MyFriendlyName' -IncludePrivateKey -SecurePassword ($password | ConvertTo-SecureString -asPlainText -Force)
Get one or more certificates with private key and certificate chain included and friendly name attribute specified

.INPUTS
InputObject or Path

.OUTPUTS
If OutPath not provided, a PSCustomObject will be returned with properties CertificateData, Filename, and Format.  Otherwise, no output.

#>
function Get-TppCertificate {
    [CmdletBinding(DefaultParameterSetName = 'ByObject')]
    param (

        [Parameter(Mandatory, ParameterSetName = 'ByObject', ValueFromPipeline)]
        [Parameter(Mandatory, ParameterSetName = 'ByObjectWithPrivateKey', ValueFromPipeline)]
        [TppObject] $InputObject,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByPath')]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByPathWithPrivateKey')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid path"
                }
            })]
        [Alias('DN')]
        [String] $Path,

        [Parameter(Mandatory)]
        [ValidateSet("Base64", "Base64 (PKCS #8)", "DER", "JKS", "PKCS #7", "PKCS #12")]
        [String] $Format,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if (Test-Path $_ -PathType Container) {
                    $true
                }
                else {
                    Throw "Output path '$_' does not exist"
                }
            })]
        [String] $OutPath,

        [Parameter()]
        [switch] $IncludeChain,

        [Parameter()]
        [string] $FriendlyName,

        [Parameter(Mandatory, ParameterSetName = 'ByObjectWithPrivateKey')]
        [Parameter(Mandatory, ParameterSetName = 'ByPathWithPrivateKey')]
        [switch] $IncludePrivateKey,

        [Parameter(Mandatory, ParameterSetName = 'ByObjectWithPrivateKey')]
        [Parameter(Mandatory, ParameterSetName = 'ByPathWithPrivateKey')]
        [Security.SecureString] $SecurePassword,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {

        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'certificates/retrieve'
            Body       = @{
                CertificateDN = $Path
                Format        = $Format
            }
        }
    }

    process {

        if ( $PSBoundParameters.ContainsKey('InputObject') ) {
            $path = $InputObject.Path
        }

        $params.Body.CertificateDN = $Path

        if ($IncludePrivateKey) {

            # validate format to be able to export the private key
            if ( $Format -in @("Base64 (PKCS #8)", "DER", "PKCS #7") ) {
                Write-Error "Format '$Format' does not support private keys"
                Return
            }

            $params.Body.Add('IncludePrivateKey', $true)
            $plainTextPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword))
            $params.Body.Add('Password', $plainTextPassword)
        }

        if ($Format -in @("Base64 (PKCS #8)", "DER", "PKCS #7")) {
            if (-not ([string]::IsNullOrEmpty($FriendlyName))) {
                Write-Error "Only Base64, JKS, PKCS #12 formats support FriendlyName parameter"
                Return
            }
        }
        else {
            if ($Format -ieq 'JKS' -and [string]::IsNullOrEmpty($FriendlyName)) {
                Write-Error "JKS format requires FriendlyName parameter to be set"
                Return
            }
        }

        if (-not [string]::IsNullOrEmpty($FriendlyName)) {
            $params.Body.Add('FriendlyName', $FriendlyName)
        }

        if ($IncludeChain) {
            if ($Format -in @("Base64 (PKCS #8)", "DER"))
            {
                Write-Error "IncludeChain is only supported when Format is Base64, JKS, PKCS #7, or PKCS #12"
                Return
            }

            $params.Body.Add('IncludeChain', $true)
        }

        $response = Invoke-TppRestMethod @params

        if ( $PSBoundParameters.ContainsKey('OutPath') ) {
            if ( $response.PSobject.Properties.name -contains "CertificateData" ) {
                $outFile = join-path $OutPath ($response.FileName)
                $bytes = [Convert]::FromBase64String($response.CertificateData)
                [IO.File]::WriteAllBytes($outFile, $bytes)
                write-verbose ('Saved {0} of format {1}' -f $outFile, $response.Format)
            }
        }
        else {
            $response
        }
    }
}
