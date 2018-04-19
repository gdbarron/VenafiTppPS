<#
.SYNOPSIS 
Test if an object exists

.DESCRIPTION
Provided with either a DN path or GUID, find out if an object exists.

.PARAMETER DN
DN path to object.  Provide either this or Guid.  This is the default if both are provided.

.PARAMETER Guid
Guid which represents a unqiue object  Provide either this or DN.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
DN or Guid.  The default is DN, but both are of type string.

.OUTPUTS
PSCustomObject will be returned with properties 'Object', a System.String, and 'Exists', a System.Boolean.

.EXAMPLE
$multDNs | Test-TppObjectExist
Object                    Exists
--------                  -----
\VED\Policy\My folder1    True
\VED\Policy\My folder2    False

Test for existence by DN

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Test-TppObjectExists/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Test-TppObjectExists.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-isvalid.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____24

#>
function Test-TppObjectExists {

    [CmdletBinding(DefaultParameterSetName = 'DN')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'DN', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                # this regex could be better
                if ( $_ -match "^\\VED\\Policy\\.*" ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN"
                }
            })]
        [string[]] $DN,
        
        [Parameter(Mandatory, ParameterSetName = 'Guid', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ -match "^{[A-Z0-9]{8}-([A-Z0-9]{4}-){3}[A-Z0-9]{12}}$" ) {
                    $true
                } else {
                    throw "'$_' is not a valid GUID"
                }
            })]
        [string[]] $Guid,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $baseParams = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'config/IsValid'
        }

        Switch ($PsCmdlet.ParameterSetName)	{

            'DN' {
                $restParameterName = 'ObjectDN'
                $boundParameter = 'DN'
            }
            
            'Guid' {
                $restParameterName = 'ObjectGUID'
                $boundParameter = 'Guid'
            }

        }

        $params = $baseParams += @{
            Body = @{
                $restParameterName = ''
            }
        }
    }

    process {

        foreach ( $thisValue in $PsBoundParameters[$boundParameter] ) {

            $params.body[$restParameterName] = $thisValue

            $response = Invoke-TppRestMethod @params

            [PSCustomObject] @{
                Object = $thisValue
                Exists = ($response.Result -eq [ConfigResult]::Success)
            }
        }
    }
}
