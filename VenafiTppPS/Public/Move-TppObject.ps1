<#
.SYNOPSIS 
Rename or move an object of any type

.DESCRIPTION
Renames or moves an object. Renaming is accomplished by changing the leaf name of the object’s DN, while moving can be accomplished by changing the path of the DN.

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

.EXAMPLE
Move-TppObject -SourceDN '\VED\Policy\My Devices\OldDeviceName' -TargetDN '\VED\Policy\My Devices\NewDeviceName'
Rename device

.LINK


#>
function Move-TppObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                # this regex could be better
                if ( $_ -match "^\\VED\\Policy\\.*" ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN"
                }
            })]
        [String] $SourceDN,
        
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                # this regex could be better
                if ( $_ -match "^\\VED\\Policy\\.*" ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN"
                }
            })]
        [String] $TargetDN,
        
        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

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