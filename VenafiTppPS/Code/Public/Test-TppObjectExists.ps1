<#
.SYNOPSIS 
Test if an object exists

.DESCRIPTION
Provided with either a DN path or GUID, find out if an object exists.

.PARAMETER DN
DN path to object.  Provide either this or Guid.  This is the default if both are provided.

.PARAMETER Guid
Guid which represents a unqiue object  Provide either this or DN.

.PARAMETER ExistOnly
Only return true/false instead of Object DN/Guid and existence true/false.  Helpful when just validating 1 object.

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
        [Parameter(Mandatory, ParameterSetName = 'DN', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [string[]] $DN,
        
        [Parameter(Mandatory, ParameterSetName = 'GUID', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Guid[]] $Guid,

        [Parameter()]
        [Switch] $ExistOnly,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method = 'Post'
            UriLeaf = 'config/IsValid'
            Body = @{}
        }
    }

    process {

        foreach ( $thisValue in $PsBoundParameters[$PsCmdlet.ParameterSetName] ) {

            if ( $PsCmdlet.ParameterSetName -eq 'GUID') {
                $thisValue = "{$thisValue}"
            }

            $params.Body = @{
                ("Object{0}" -f $PsCmdlet.ParameterSetName) = $thisValue
            }

            $response = Invoke-TppRestMethod @params

            if ( $ExistOnly ) {
                $response.Result -eq [ConfigResult]::Success
            } else {
                [PSCustomObject] @{
                    Object = $thisValue
                    Exists = ($response.Result -eq [ConfigResult]::Success)
                }
            }
        }
    }
}
