<#
.SYNOPSIS
Create a new object

.DESCRIPTION
Create a new object.  Generic use function if a specific function hasn't been created yet for the class.
There doesn't seem to be a great way to get an explicit list of what the attributes for any one class should be.
You can either review the online SDK documentation or manually create the object via the admin GUI and
go to the Support->Attributes tab.

.PARAMETER Path
Full path for the object to be created.

.PARAMETER Class
Class name of the new object.
See https://docs.venafi.com/Docs/18.3SDK/TopNav/Content/SDK/WebSDK/Schema_Reference/r-SDK-CNattributesWhere.php for more info.

.PARAMETER Attribute
List of Hashtables with initial values for the new object.
These will be specific to the object class being created.
Each Hashtable should have Name as one key and Value as the other.
See the examples.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.EXAMPLE
New-TppObject -Path '\VED\Policy\Test Device' -Class 'Device' -Attribute @(@{'Name'='Description';'Value'='new device testing'})
Create a new device

.EXAMPLE
New-TppObject -Path '\VED\Policy\Test Device' -Class 'Device' -Attribute @(@{'Name'='Description';'Value'='new device testing'}) -PassThru
Create a new device and return the resultant object

.INPUTS
none

.OUTPUTS
TppObject

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/New-TppObject/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/New-TppObject.ps1

.LINK
https://docs.venafi.com/Docs/18.3SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-create.php?tocpath=REST%20API%20reference%7CConfig%20programming%20interfaces%7C_____9

.LINK
https://docs.venafi.com/Docs/18.3SDK/TopNav/Content/SDK/WebSDK/Schema_Reference/r-SDK-CNattributesWhere.php

#>
function New-TppObject {

    [CmdletBinding()]
    [OutputType( [TppObject] )]

    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [string] $Path,

        [Parameter(Mandatory)]
        [String] $Class,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Hashtable[]] $Attribute,

        [Parameter()]
        [switch] $PassThru,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

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

    $response = Invoke-TppRestMethod @params

    if ( $response.Result -eq [ConfigResult]::Success ) {

        Write-Verbose "Successfully created $Class at $Path"

        if ( $PassThru ) {

            $object = $response.Object

            [TppObject] @{
                Name     = $object.Name
                TypeName = $object.TypeName
                Path     = $object.DN
                Guid     = $object.Guid
            }
        }
    }
    else {
        Throw $response.Error
    }
}
