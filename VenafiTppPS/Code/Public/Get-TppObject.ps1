<#
.SYNOPSIS
Find objects by DN, class, or pattern

.DESCRIPTION
Find objects by DN, class, or pattern.

.PARAMETER Class
Single class name to search.  To provide a list, use Classes.

.PARAMETER Classes
List of class names to search on

.PARAMETER Pattern
A pattern to match against object attribute values:

- To list DNs that include an asterisk (*) or question mark (?), prepend two backslashes (\\). For example, \\*.MyCompany.net treats the asterisk as a literal character and returns only certificates with DNs that match *.MyCompany.net.
- To list DNs with a wildcard character, append a question mark (?). For example, "test_?.mycompany.net" counts test_1.MyCompany.net and test_2.MyCompany.net but not test12.MyCompany.net.
- To list DNs with similar names, prepend an asterisk. For example, *est.MyCompany.net, counts Test.MyCompany.net and West.MyCompany.net.
You can also use both literals and wildcards in a pattern.

.PARAMETER AttributeName
A list of attribute names to limit the search against.  Only valid when searching by pattern.

.PARAMETER DN
The path to start our search.  If not provided, the root, \VED, is used.

.PARAMETER Recursive
Searches the subordinates of the object specified in DN.
Not supported when searching Classes or by Pattern.
Default value is true.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS

.OUTPUTS
PSCustomObject with the following properties:
    AbsoluteGUID: The left-to-right concatenation of all of the GUIDs for all of the objects in the DN.
    DN: The Distinguished Name (DN) of the object.
    GUID: The GUID that identifies the object.
    ID: The object identifier.
    Name: The Common Name (CN) of the object.
    Parent: The parent DN of the object.
    Revision: The revision of the object.
    TypeName: the class name of the object.

.EXAMPLE
Get-TppObject
Get all objects

.EXAMPLE
Get-TppObject -class 'iis6'
Get all objects of the type iis6

.EXAMPLE
Get-TppObject -classes 'iis6', 'capi'
Get all objects of the type iis6 or capi

.EXAMPLE
Get-TppObject -DN '\VED\Policy\My Policy Folder' -Recursive
Get all objects in 'My Policy Folder' and subfolders

.EXAMPLE
Get-TppObject -DN '\VED\Policy\My Policy Folder' -Pattern 'MyDevice'
Get all objects in 'My Policy Folder' that match the name MyDevice.  Only search the folder "My Policy Folder", not subfolders.

.EXAMPLE
Get-TppObject -Pattern 'MyDevice' -Recursive
Get all objects that match the name MyDevice.  As starting DN isn't provided, this will search all.

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppObject/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Get-TppObject.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-find.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____17

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-findobjectsofclass.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____19

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-enumerate.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____13

#>
function Get-TppObject {
    [CmdletBinding(DefaultParameterSetName = 'FindByDN')]
    param (

        [Parameter(ParameterSetName = 'FindByDN')]
        [Parameter(ParameterSetName = 'FindByClass')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [String] $DN = '\VED',

        [Parameter(Mandatory, ParameterSetName = 'FindByClass')]
        [ValidateNotNullOrEmpty()]
        [String] $Class,

        [Parameter(Mandatory, ParameterSetName = 'FindByClasses')]
        [ValidateNotNullOrEmpty()]
        [String[]] $Classes,

        [Parameter(Mandatory, ParameterSetName = 'FindByPattern')]
        [Parameter(ParameterSetName = 'FindByDN')]
        [Parameter(ParameterSetName = 'FindByClass')]
        [Parameter(ParameterSetName = 'FindByClasses')]
        [ValidateNotNullOrEmpty()]
        [String] $Pattern,

        [Parameter(ParameterSetName = 'FindByPattern')]
        [ValidateNotNullOrEmpty()]
        [String[]] $AttributeName,

        [Parameter(ParameterSetName = 'FindByDN')]
        [Parameter(ParameterSetName = 'FindByClass')]
        [Bool] $Recursive = $true,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    Write-Verbose $PsCmdlet.ParameterSetName

    Switch ($PsCmdlet.ParameterSetName)	{
        'FindByPattern' {
            $params = @{
                TppSession = $TppSession
                Method     = 'Post'
                UriLeaf    = 'config/find'
                Body       = @{
                    Pattern = $Pattern
                }
            }

            if ( $AttributeName ) {
                $params.body += @{
                    AttributeNames = $AttributeName
                }
            }

        }

        'FindByDN' {
            $params = @{
                TppSession = $TppSession
                Method     = 'Post'
                UriLeaf    = 'config/enumerate'
                Body       = @{
                    ObjectDN = $DN
                }
            }

            if ( $Pattern ) {
                $params.body += @{
                    Pattern = $Pattern
                }
            }

            if ( $Recursive ) {
                $params.body += @{
                    Recursive = 'true'
                }
            }
        }

        {$_ -in 'FindByClass', 'FindByClasses'} {
            $params = @{
                TppSession = $TppSession
                Method     = 'Post'
                UriLeaf    = 'config/FindObjectsOfClass'
            }

            if ( $Class ) {
                $body = @{Class = $Class}
            } else {
                $body = @{Classes = $Classes}
            }

            $params += @{
                Body = $body
            }

            if ( $Pattern ) {
                $params.body += @{
                    Pattern = $Pattern
                }
            }

            if ( $DN ) {
                $params.body += @{
                    ObjectDN = $DN
                }
            }

            if ( $Recursive ) {
                $params.body += @{
                    Recursive = 'true'
                }
            }

        }

    }

    $response = Invoke-TppRestMethod @params

    if ( $response.Result -eq [ConfigResult]::Success ) {
        $response.Objects
    } else {
        throw $response.Error
    }

}