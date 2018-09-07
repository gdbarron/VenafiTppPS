<#
.SYNOPSIS
Remove certificate associations

.DESCRIPTION
Disassociates one or more Application objects from an existing certificate.
Optionally, you can remove the application objects and corresponding orphaned device objects that no longer have any applications

.PARAMETER Path
DN path of one or more certificates to process

.PARAMETER ApplicationPath
One or more application objects, specified by their distinguished names, that uniquely identify them in the Venafi platform

.PARAMETER OrphanCleanup
Delete the Application object. Only delete the corresponding Device DN when it has no child objects. Otherwise retain only the Device DN and its children. Use this option to completely remove the application object and corresponding device objects.

.PARAMETER RemoveAll
Remove all associated application objects

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Path

.OUTPUTS
None

.EXAMPLE
Remove-TppCertificateAssocation -Path '\ved\policy\my folder' -ApplicationPath '\ved\policy\my capi'
Remove a single application object association

.EXAMPLE
Remove-TppCertificateAssocation -Path '\ved\policy\my folder' -ApplicationPath '\ved\policy\my capi' -OrphanCleanup
Disassociate and delete the application object

.EXAMPLE
Remove-TppCertificateAssocation -Path '\ved\policy\my folder' -RemoveAll
Remove all certificate associations

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Remove-TppCertificateAssociation/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Remove-TppCertificateAssociation.ps1

.LINK
https://docs.venafi.com/Docs/18.2SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Certificates-Dissociate.php?tocpath=REST%20API%20reference%7CCertificates%20module%20programming%20interfaces%7C_____6

.NOTES
You must have:
- Write permission to the Certificate object.
- Write or Associate permission to Application objects that are associated with the certificate
- Delete permission to Application and device objects when specifying -OrphanCleanup

#>
function Remove-TppCertificateAssociation {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'RemoveOne')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'RemoveAll')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('DN', 'CertificateDN')]
        [String] $Path,

        [Parameter(Mandatory, ParameterSetName = 'RemoveOne')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [String[]] $ApplicationPath,

        [Parameter()]
        [switch] $OrphanCleanup,

        [Parameter(Mandatory, ParameterSetName = 'RemoveAll')]
        [switch] $RemoveAll,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'Certificates/Dissociate'
            Body       = @{}
        }
    }

    process {

        $Path.ForEach{
            $thisCertPath = $_
            $shouldProcessAction = "Remove associations"

            if ( -not ($thisCertPath | Test-TppObject -ExistOnly) ) {
                Write-Error ("Certificate path {0} does not exist" -f $thisCertPath)
                Continue
            }

            $params.Body = @{
                'CertificateDN' = $thisCertPath
            }

            if ( $PSBoundParameters.ContainsKey('OrphanCleanup') ) {
                $params.Body.Add( 'DeleteOrphans', $true )
                $shouldProcessAction += ' AND ORPHANS'
            }

            Switch ($PsCmdlet.ParameterSetName)	{
                'RemoveOne' {
                    $params.Body.Add( 'ApplicationDN', $ApplicationPath )
                }

                'RemoveAll' {
                    $associatedApps = ($thisCertPath | Get-TppAttribute -Attribute "Consumers" -EffectivePolicy).Config.Value
                    $params.Body.Add( 'ApplicationDN', @($associatedApps) )
                }
            }

            # make sure we have apps to process.  there might not be any if removeall was used
            if ( -not $params.Body.ApplicationDN ) {
                continue
            }

            try {
                if ( $PSCmdlet.ShouldProcess($thisCertPath, $shouldProcessAction) ) {
                    $null = Invoke-TppRestMethod @params
                }
            } catch {
                $myError = $_.ToString() | ConvertFrom-Json
                Write-Error ('Error removing associations from certificate {0}: {1}' -f $thisCertPath, $myError.Error)
                Continue
            }
        }
    }
}
