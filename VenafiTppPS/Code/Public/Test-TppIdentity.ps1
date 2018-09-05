<#
.SYNOPSIS
Test if an object exists

.DESCRIPTION
Provided with either a DN path or GUID, find out if an object exists.

.PARAMETER Path
DN path to object.  Provide either this or Guid.  This is the default if both are provided.

.PARAMETER Guid
Guid which represents a unqiue object.  Provide either this or Path.

.PARAMETER ExistOnly
Only return boolean instead of Object and Exists list.  Helpful when validating just 1 object.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Path or Guid.

.OUTPUTS
PSCustomObject will be returned with properties 'Object', a System.String, and 'Exists', a System.Boolean.

.EXAMPLE
$multDNs | Test-TppObject
Object                    Exists
--------                  -----
\VED\Policy\My folder1    True
\VED\Policy\My folder2    False

Test for existence by Path

.EXAMPLE
Test-TppObject -Path '\VED\Policy\My folder' -ExistOnly

Retrieve existence for only one object

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Test-TppObject/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Test-TppObject.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-isvalid.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____24

#>
function Test-TppIdentity {

    [CmdletBinding()]
    param (

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript( {
                $_ -match '(AD|LDAP)+\S+:\w{32}$' -or $_ -match 'local:\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$'
            })]
        [Alias('PrefixedUniversal')]
        [string[]] $PrefixedUniversalId,

        [Parameter()]
        [Switch] $ExistOnly,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'Identity/Validate'
            Body       = @{
                'ID' = @{
                    'PrefixedUniversal' = ''
                }
            }
        }
    }

    process {

        foreach ( $thisId in $PrefixedUniversalId ) {

            $params.Body.Id.PrefixedUniversal = $thisId

            $response = Invoke-TppRestMethod @params

            if ( $ExistOnly ) {
                $null -ne $response.Id
            } else {
                [PSCustomObject] @{
                    Identity = $thisId
                    Exists   = ($null -ne $response.Id)
                }
            }
        }
    }
}
