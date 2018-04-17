<#
.SYNOPSIS 
Find objects by class or pattern

.DESCRIPTION
Find objects by class or pattern

.PARAMETER Class
Single class name to search

.PARAMETER Classes
List of class names to search on

.PARAMETER Pattern
A pattern to match against object attribute values:

- To list DNs that include an asterisk (*) or question mark (?), prepend two backslashes (\\). For example, \\*.MyCompany.net treats the asterisk as a literal character and returns only certificates with DNs that match *.MyCompany.net.
- To list DNs with a wildcard character, append a question mark (?). For example, "test_?.mycompany.net" counts test_1.MyCompany.net and test_2.MyCompany.net but not test12.MyCompany.net.
- To list DNs with similar names, prepend an asterisk. For example, *est.MyCompany.net, counts Test.MyCompany.net and West.MyCompany.net.
You can also use both literals and wildcards in a pattern.

.PARAMETER AttributeName
A list of attribute names to limit the search against

.PARAMETER DN
The starting DN of the object to search for subordinates under. ObjectDN and Recursive is only supported if Class is provided

.PARAMETER Recursive
Searches the subordinates of the object specified in DN

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

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
Get-TppObject -class 'iis6'
Get all objects of the type iis6

.EXAMPLE
Get-TppObject -classes 'iis6', 'capi'
Get all objects of the type iis6 or capi

#>
function Get-TppObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'FindByClass')]
        [ValidateNotNullOrEmpty()]
        [String] $Class,

        [Parameter(Mandatory, ParameterSetName = 'FindByClasses')]
        [ValidateNotNullOrEmpty()]
        [String[]] $Classes,

        [Parameter(Mandatory, ParameterSetName = 'Find')]
        [Parameter(ParameterSetName = 'FindByClass')]
        [Parameter(ParameterSetName = 'FindByClasses')]
        [ValidateNotNullOrEmpty()]
        [String] $Pattern,

        [Parameter(ParameterSetName = 'Find')]
        [ValidateNotNullOrEmpty()]
        [String[]] $AttributeName,

        [Parameter(ParameterSetName = 'FindByClass')]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                # this regex could be better
                if ( $_ -match "^\\VED\\Policy\\.*" ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN"
                }
            })]
        [String] $DN,
        
        [Parameter(ParameterSetName = 'FindByClass')]
        [Switch] $Recursive,
        
        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    Switch ($PsCmdlet.ParameterSetName)	{
        'Find' {
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
                    AttributeNames = $AttributeNames
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