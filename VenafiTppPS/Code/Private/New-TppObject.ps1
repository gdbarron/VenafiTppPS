<#
.SYNOPSIS
Create a new object

.DESCRIPTION
Create a new object

.PARAMETER Path
DN path to the new object.

.PARAMETER Class
Class name of the new object

.PARAMETER Attribute
Initial values for the new object.  These will be specific to the object class being created.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS

#>
function New-TppObject {

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
        [Alias('DN')]
        [string] $Path,

        [Parameter(Mandatory)]
        [ValidateSet('Device', 'CAPI', 'Policy')]
        [String] $Class,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Hashtable[]] $Attribute,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    # validation should take place in the calling function
    # $TppSession.Validate()

    # ensure the object doesn't already exist
    if ( Test-TppObject -Path $Path -ExistOnly ) {
        throw ("{0} already exists" -f $Path)
    }

    # ensure the parent folder exists
    if ( -not (Test-TppObject -Path (Split-Path $Path -Parent) -ExistOnly) ) {
        throw ("The parent folder, {0}, of your new object does not exist" -f (Split-Path $Path -Parent))
    }

    $params = @{
        TppSession = $TppSession
        Method     = 'Post'
        UriLeaf    = 'config/create'
        Body       = @{
            ObjectDN          = $Path
            Class             = $Class
            NameAttributeList = $Attribute
        }
    }

    Invoke-TppRestMethod @params

}
