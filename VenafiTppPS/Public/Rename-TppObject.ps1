<#
.SYNOPSIS 
Rename an object of any type

.DESCRIPTION
Rename an object of any type

.PARAMETER DN
Full path to an object in TPP

.PARAMETER NewName
New name for the object

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS

.EXAMPLE
Rename-TppObject -DN '\VED\Policy\My Devices\OldDeviceName' -NewName 'NewDeviceName'
Rename device

.LINK


#>
function Rename-TppObject {
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
        [String] $NewName,
        
        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    # ensure the object to rename already exists
    if ( -not (Test-TppObjectExists -DN $DN).Exists ) {
        throw ("{0} does not exist" -f $DN)
    }

    # ensure the new object doesn't already exist
    $newDN = "{0}\{1}" -f (Split-Path $DN -Parent), $NewName
    if ( (Test-TppObjectExists -DN $newDN).Exists ) {
        throw ("{0} already exists" -f $newDN)
    }

    $params = @{
        TppSession = $TppSession
        Method     = 'Post'
        UriLeaf    = 'config/RenameObject'
        Body       = @{
            ObjectDN    = $DN
            NewObjectDN = $newDN
        }
    }

    $response = Invoke-TppRestMethod @params
 
    if ( $response.Result -ne [ConfigResult]::Success ) {
        throw $response.Error
    }
}