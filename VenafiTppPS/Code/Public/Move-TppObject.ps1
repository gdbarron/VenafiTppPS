<#
.SYNOPSIS 
Move an object of any type

.DESCRIPTION
Move an object of any type

.PARAMETER SourceDN
Full path to an object in TPP

.PARAMETER TargetDN
New path

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS

.EXAMPLE
Move-TppObject -SourceDN '\VED\Policy\My Folder\mycert.company.com' -TargetDN '\VED\Policy\New Folder\mycert.company.com'
Moves mycert.company.com to a new Policy folder

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Move-TppObject/

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Test-TppObjectExists/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Move-TppObject.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-renameobject.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____36

#>
function Move-TppObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [String] $SourceDN,
        
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [String] $TargetDN,
        
        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    # ensure the object to rename already exists
    if ( -not (Test-TppObjectExists -DN $DN -ExistOnly) ) {
        throw ("Source DN '{0}' does not exist" -f $DN)
    }

    # ensure the new object doesn't already exist
    if ( Test-TppObjectExists -DN $TargetDN -ExistOnly ) {
        throw ("Target DN '{0}' already exists" -f $TargetDN)
    }

    $params = @{
        TppSession = $TppSession
        Method     = 'Post'
        UriLeaf    = 'config/RenameObject'
        Body       = @{
            ObjectDN    = $SourceDN
            NewObjectDN = $TargetDN
        }
    }

    $response = Invoke-TppRestMethod @params
 
    if ( $response.Result -ne [ConfigResult]::Success ) {
        throw $response.Error
    }
}