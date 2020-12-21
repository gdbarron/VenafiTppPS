<#
.SYNOPSIS
Search for code sign projects

.DESCRIPTION
Search for specific code sign projects or return all

.PARAMETER Name
Name of the project to search for

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
None

.EXAMPLE
Find-TppCodeSignProject
Get all code sign projects

.EXAMPLE
Find-TppCodeSignProject -Name CSTest
Find all projects that match the name CSTest

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Find-TppCodeSignProject/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Find-TppCodeSignProject.ps1

.LINK
https://docs.venafi.com/Docs/20.3/TopNav/Content/SDK/CodeSignSDK/r-SDKc-POST-Codesign-EnumerateProjects.php?tocpath=CodeSign%20Protect%20SDK%20reference%7CProjects%20and%20environments%7C_____8

#>
function Find-TppCodeSignProject {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String[]] $Name,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate($true)

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'Codesign/EnumerateProjects'
            Body       = @{ }
        }
    }

    process {

        Switch ($PsCmdlet.ParameterSetName)	{
            'Name' {
                $response = $Name.ForEach{
                    $params.Body.Filter = $_
                    Invoke-TppRestMethod @params
                }
            }

            'All' {
                $response = Invoke-TppRestMethod @params
            }
        }

        if ( $response ) {
            foreach ($project in $response.Projects) {
                [TppObject] @{
                    Name     = Split-Path $project.DN -Leaf
                    TypeName = 'Code Signing Project'
                    Path     = $project.DN
                    Guid     = $project.Guid
                }
            }
        }

    }
}
