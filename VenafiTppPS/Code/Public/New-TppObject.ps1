<#
.SYNOPSIS
Create a new object

.DESCRIPTION
Create a new object.  Generic use function if a specific function hasn't been created yet for the class.

.PARAMETER Path
Full path for the object to be created.

.PARAMETER Class
Class name of the new object.
See https://docs.venafi.com/Docs/18.3SDK/TopNav/Content/SDK/WebSDK/Schema_Reference/r-SDK-CNattributesWhere.php for more info.

.PARAMETER Attribute
Hashtable with initial values for the new object.  These will be specific to the object class being created.

.PARAMETER PassThru
Return a TppObject representing the newly created object.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.EXAMPLE
New-TppObject -Path '\VED\Policy\Test Device' -Class 'Device' -Attribute @{'Description'='new device testing'}
Create a new device

.EXAMPLE
New-TppObject -Path '\VED\Policy\Test Device' -Class 'Device' -Attribute @{'Description'='new device testing'} -PassThru
Create a new device and return the resultant object

.EXAMPLE
New-TppObject -Path '\VED\Policy\Test Device\App' -Class 'Basic' -Attribute @{'Driver Name'='appbasic';'Certificate'='\Ved\Policy\mycert.com'}
Create a new Basic application and associate it to a device and certificate

.INPUTS
none

.OUTPUTS
TppObject, if PassThru provided

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

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Hashtable] $Attribute,

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
            ObjectDN = $Path
            Class    = $Class
        }
    }

    if ( $Attribute ) {
        # api requires a list of hashtables for nameattributelist
        # with 2 items per hashtable, with key names 'name' and 'value'
        # this is cumbersome for the user so allow them to pass a standard hashtable and convert it for them
        $updatedAttribute = @($Attribute.GetEnumerator() | ForEach-Object {@{'Name' = $_.name; 'Value' = $_.value}})
        $params.Body.Add('NameAttributeList', $updatedAttribute)
    }

    $response = Invoke-TppRestMethod @params

    if ( $response.Result -eq [TppConfigResult]::Success ) {

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
