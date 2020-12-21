<#
.SYNOPSIS
Search for code sign environments

.DESCRIPTION
Search for specific code sign environments that match a name you provide or get all.  This will search across projects.

.PARAMETER Name
Name of the environment to search for

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
None

.OUTPUTS
TppObject

.EXAMPLE
Find-TppCodeSignEnvironment
Get all code sign environments

.EXAMPLE
Find-TppCodeSignEnvironment -Name Development
Find all environments that match the name Development

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Find-TppCodeSignEnvironment/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Find-TppCodeSignEnvironment.ps1

#>
function Find-TppCodeSignEnvironment {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String[]] $Name,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate($true)
        $projects = Find-TppCodeSignProject | Get-TppCodeSignProject
    }

    process {

        Switch ($PsCmdlet.ParameterSetName)	{
            'Name' {
                $envs = $Name.ForEach{
                    $thisEnvName = $_
                    $projects.CertificateEnvironment | Where-Object { $_.Name -match $thisEnvName }
                }
                $envs = $envs | Sort-Object -Property Path -Unique
            }

            'All' {
                $envs = $projects.CertificateEnvironment
            }
        }

        if ( $envs ) {
            foreach ($env in $envs) {
                [TppObject] @{
                    Name     = $env.Name
                    TypeName = $env.TypeName
                    Path     = $env.Path
                    Guid     = $env.Guid
                }
            }
        }

    }
}
