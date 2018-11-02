<#
.SYNOPSIS
Get a certificate

.DESCRIPTION
Get a certificate with or without private key.
You have the option of simply getting the data or saving it to a file.

.PARAMETER Path
Path to the certificate object to retrieve

.PARAMETER Format
The format of the returned certificate.
Values include Base64, Base64 (PKCS #8)

.PARAMETER EffectivePolicy
Get the effective policy of the attribute

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Get-TppCertificate {
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
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

        [Parameter(Mandatory, ParameterSetName = 'PrivateKey')]
        [Security.SecureString] $SecurePassword,

        [Parameter(Mandatory, ParameterSetName = 'PrivateKey')]
        [switch] $IncludePrivateKey,

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

        $params.Body.CertificateDN = $Path

        if ( $PSCmdlet.ParameterSetName -eq 'PrivateKey' ) {

            # validate format to be able to export the private key
            if ( $Format -in @("Base64", "DER", "PKCS #7") ) {
                Throw "Format '$Format' does not support private keys"
            }

            $plainTextPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword))
            $params.Body.Add('IncludePrivateKey', $IncludePrivateKey)
            $params.Body.Add('Password', $plainTextPassword)
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
