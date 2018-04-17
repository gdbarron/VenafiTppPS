<#
.SYNOPSIS 
Create a new object

.DESCRIPTION
Create a new object

.PARAMETER DN
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
                # this regex could be better
                if ( $_ -match "^\\VED\\Policy\\.*" ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN"
                }
            })]
        [string] $DN,
        
        [Parameter(Mandatory)]
        [ValidateSet("Device", "CAPI")]
        [String] $Class,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Hashtable[]] $Attribute,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    # $TppSession.Validate()

    # ensure the object doesn't already exist
    if ( (Test-TppObjectExists -DN $DN).Exists ) {
        throw ("{0} already exists" -f $DN)
    }
    
    # TODO: ensure the parent folder exists
    # if ( (Test-TppObjectExists -DN $DN).Exists ) {
    #     throw ("{0} already exists" -f $DN)
    # }
    
    $params = @{
        TppSession = $TppSession
        Method     = 'Post'
        UriLeaf    = 'config/create'
        Body       = @{
            ObjectDN          = $DN
            Class             = $Class
            NameAttributeList = $Attribute
        }
    }

    $response = Invoke-TppRestMethod @params

    if ( $response.Result -eq [ConfigResult]::Success ) {
        $response.Object
    } else {
        throw $response.Error
    }

}
