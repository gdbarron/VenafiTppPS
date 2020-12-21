<#
.SYNOPSIS
Delete a code sign project

.DESCRIPTION
Delete a code sign project.  You must be a code sign admin or owner of the project.

.PARAMETER Path
Path of the project to delete

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Path

.OUTPUTS
None

.EXAMPLE
Remove-TppCodeSignProject -Path '\ved\code signing\projects\my_project'
Delete a project

.EXAMPLE
$projectObj | Remove-TppCodeSignProject
Remove 1 or more projects.  Get projects with Find-TppCodeSignProject

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Remove-TppCodeSignProject/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Remove-TppCodeSignProject.ps1

.LINK
https://docs.venafi.com/Docs/20.4SDK/TopNav/Content/SDK/CodeSignSDK/r-SDKc-POST-Codesign-DeleteProject.php?tocpath=CodeSign%20Protect%20Admin%20REST%C2%A0API%7CProjects%20and%20environments%7C_____7

#>
function Remove-TppCodeSignProject {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid path"
                }
            })]
        [String] $Path,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate($true)

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'Codesign/DeleteProject'
            Body       = @{ }
        }
    }

    process {

        $params.Body.Dn = $Path

        if ( $PSCmdlet.ShouldProcess($Path, 'Remove code sign project') ) {

            $response = Invoke-TppRestMethod @params

            if ( -not $response.Success ) {
                Write-Error ('{0} : {1} : {2}' -f $response.Result, [enum]::GetName([TppCodeSignResult], $response.Result), $response.Error)
            }
        }
    }
}
