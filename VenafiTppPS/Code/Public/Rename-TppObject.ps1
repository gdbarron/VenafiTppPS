<#
.SYNOPSIS
Rename an object of any type

.DESCRIPTION
Rename an object of any type

.PARAMETER Path
Full path to an object in TPP

.PARAMETER NewName
New name for the object

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS

.EXAMPLE
Rename-TppObject -Path '\VED\Policy\My Devices\OldDeviceName' -NewName 'NewDeviceName'
Rename device

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Rename-TppObject/

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Test-TppObject/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Rename-TppObject.ps1

.LINK
https://docs.venafi.com/Docs/20.4SDK/TopNav/Content/SDK/WebSDK/r-SDK-POST-Config-renameobject.php?tocpath=Web%20SDK%7CConfig%20programming%20interface%7C_____35

#>
function Rename-TppObject {
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
        [Alias('SourceDN')]
        [String] $Path,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $NewName,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    # ensure the object to rename already exists
    if ( -not (Test-TppObject -Path $Path -ExistOnly -TppSession $TppSession) ) {
        throw ("{0} does not exist" -f $Path)
    }

    # ensure the new object doesn't already exist
    $newDN = "{0}\{1}" -f (Split-Path $Path -Parent), $NewName
    if ( Test-TppObject -Path $newDN -ExistOnly -TppSession $TppSession ) {
        throw ("{0} already exists" -f $newDN)
    }

    $params = @{
        TppSession = $TppSession
        Method     = 'Post'
        UriLeaf    = 'config/RenameObject'
        Body       = @{
            ObjectDN    = $Path
            NewObjectDN = $newDN
        }
    }

    $response = Invoke-TppRestMethod @params

    if ( $response.Result -ne [TppConfigResult]::Success ) {
        throw $response.Error
    }
}