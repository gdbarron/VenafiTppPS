<#
.SYNOPSIS
Find objects by DN path, class, or pattern

.DESCRIPTION
Find objects by DN path, class, or pattern.

.PARAMETER Path
The path to start our search.

.PARAMETER Class
1 or more classes to search for

.PARAMETER Pattern
A pattern to match against object attribute values:

- To list DNs that include an asterisk (*) or question mark (?), prepend two backslashes (\\). For example, \\*.MyCompany.net treats the asterisk as a literal character and returns only certificates with DNs that match *.MyCompany.net.
- To list DNs with a wildcard character, append a question mark (?). For example, "test_?.mycompany.net" counts test_1.MyCompany.net and test_2.MyCompany.net but not test12.MyCompany.net.
- To list DNs with similar names, prepend an asterisk. For example, *est.MyCompany.net, counts Test.MyCompany.net and West.MyCompany.net.
You can also use both literals and wildcards in a pattern.

.PARAMETER Attribute
A list of attribute names to limit the search against.  Only valid when searching by pattern.

.PARAMETER Recursive
Searches the subordinates of the object specified in Path.

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
None

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
Get-TppObject -Path '\VED\Policy'
Get all objects in the root of a specific folder

.EXAMPLE
Get-TppObject -Path '\VED\Policy\My Folder' -Recursive
Get all objects in a folder and subfolders

.EXAMPLE
Get-TppObject -Path '\VED\Policy' -Pattern 'test'
Get items in a specific folder filtering the path

.EXAMPLE
Get-TppObject -Class 'iis6'
Get all objects of the type iis6

.EXAMPLE
Get-TppObject -Class 'iis6' -Pattern 'test*'
Get all objects of the type iis6 filtering the path

.EXAMPLE
Get-TppObject -Class 'iis6', 'capi'
Get all objects of the type iis6 or capi

.EXAMPLE
Get-TppObject -Pattern 'test*'
Find all objects matching the pattern

.EXAMPLE
Get-TppObject -Pattern 'test*' -Attribute 'Consumers'
Find all objects where the specific attribute matches the pattern

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
    [CmdletBinding()]
    param (

        [Parameter(Mandatory, ParameterSetName = 'FindByPath')]
        [Parameter(Mandatory, ParameterSetName = 'FindByClassAndPath')]
        [ValidateNotNullOrEmpty()]
        [Alias('DN')]
        [String] $Path,

        [Parameter(Mandatory, ParameterSetName = 'FindByClass')]
        [Parameter(Mandatory, ParameterSetName = 'FindByClassAndPath')]
        [ValidateNotNullOrEmpty()]
        [String[]] $Class,

        [Parameter(Mandatory, ParameterSetName = 'FindByPattern')]
        [Parameter(ParameterSetName = 'FindByPath')]
        [Parameter(ParameterSetName = 'FindByClass')]
        [Parameter(ParameterSetName = 'FindByClassAndPath')]
        [ValidateNotNullOrEmpty()]
        [String] $Pattern,

        [Parameter(ParameterSetName = 'FindByPattern')]
        [ValidateNotNullOrEmpty()]
        [Alias('AttributeName')]
        [String[]] $Attribute,

        [Parameter(ParameterSetName = 'FindByPath')]
        [Parameter(ParameterSetName = 'FindByClassAndPath')]
        [switch] $Recursive,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    Write-Verbose $PsCmdlet.ParameterSetName

    $params = @{
        TppSession = $TppSession
        Method     = 'Post'
        UriLeaf    = 'placeholder'
        Body       = @{}
    }

    Switch ($PsCmdlet.ParameterSetName)	{
        'FindByPattern' {
            $params.UriLeaf = 'config/find'
        }

        'FindByPath' {
            $params.UriLeaf = 'config/enumerate'
        }

        {$_ -in 'FindByClass', 'FindByClassAndPath'} {
            $params.UriLeaf = 'config/FindObjectsOfClass'
        }
    }

    # add filters
    if ( $PSBoundParameters.ContainsKey('Pattern') ) {
        $params.Body.Add( 'Pattern', $Pattern )
    }

    if ( $PSBoundParameters.ContainsKey('Attribute') ) {
        $params.Body.Add( 'AttributeNames', $Attribute )
    }

    if ( $PSBoundParameters.ContainsKey('Recursive') ) {
        $params.Body.Add( 'Recursive', 'true' )
    }

    if ( $PSBoundParameters.ContainsKey('Path') ) {
        $params.Body.Add( 'ObjectDN', $Path )
    }

    if ( $PSBoundParameters.ContainsKey('Class') ) {
        # the rest api doesn't have the ability to search for multiple classes and path at the same time
        # loop through classes to get around this
        $params.Body.Add('Class', '')
        $Class.ForEach{
            $thisClass = $_
            $params.Body.Class = $thisClass

            $response = Invoke-TppRestMethod @params

            if ( $response.Result -eq [ConfigResult]::Success ) {
                $response.Objects
            } else {
                Write-Error ('Retrieval of class {0} failed with error {1}' -f $thisClass, $response.Error)
                Continue
            }
        }
    } else {
        $response = Invoke-TppRestMethod @params

        if ( $response.Result -eq [ConfigResult]::Success ) {
            $response.Objects
        } else {
            Write-Error $response.Error
        }
    }
}