<#
	.SYNOPSIS
	Updates module metadata, .psd1

	.DESCRIPTION
    Updates the module metadata.  The build component of the version is incremented by 1,
    the function to export are updated as are the aliases to export.

	.PARAMETER ModuleName
    Name of the module

	.EXAMPLE

    .NOTES
    Requires Allow script to access OAuth token is enbled in agent phase
	#>


[CmdletBinding()]

Param(
    [Parameter(Mandatory)]
    [string] $ModuleName
)

$ErrorActionPreference = "Stop"

# get current environment variables just for reference
Get-ChildItem env:
$branch = $env:BUILD_SOURCEBRANCHNAME

$manifestPath = '{0}\{1}\code\{1}.psd1' -f $env:BUILD_SOURCESDIRECTORY, $ModuleName
Write-Output "Processing module path $manifestPath"

try {
    $manifest = Import-PowerShellDataFile $manifestPath
} catch {
    throw "Unable to import PSD file -- check for proper definition file syntax.  `
    Try importing the PSD manually in a local powershell session to verify the cause of this error (import-powershelldatafile <psd1 file>) $_"
}

[version]$version = $Manifest.ModuleVersion
Write-Output "Old Version - $Version"
# Add one to the build of the version number
[version]$NewVersion = "{0}.{1}.{2}" -f $Version.Major, $Version.Minor, ($Version.Build + 1)
Write-Output "New Version - $NewVersion"

# Load the module, read the exported functions and aliases, update the psd1
$FunctionFiles = Get-ChildItem ".\$ModuleName\code\Public\*.ps1" |
    Where-Object { $_.name -notmatch 'Tests' }
$ExportFunctions = @()
$ExportAliases = @()
foreach ($FunctionFile in $FunctionFiles) {
    $AST = [System.Management.Automation.Language.Parser]::ParseFile($FunctionFile.FullName, [ref]$null, [ref]$null)
    $Functions = $AST.FindAll( {
            $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]
        }, $true)
    if ($Functions.Name) {
        $ExportFunctions += $Functions.Name
    }
    $Aliases = $AST.FindAll( {
            $args[0] -is [System.Management.Automation.Language.AttributeAst] -and
            $args[0].parent -is [System.Management.Automation.Language.ParamBlockAst] -and
            $args[0].TypeName.FullName -eq 'alias'
        }, $true)
    if ($Aliases.PositionalArguments.value) {
        $ExportAliases += $Aliases.PositionalArguments.value
    }
}

# get release notes
$releaseNotes = Get-Content -Path ('{0}\release.md' -f $env:BUILD_SOURCESDIRECTORY) -Raw

try {
    Write-Output "Updating the module metadata
        New version: $newVersion
        Functions: $ExportFunctions
        Aliases: $ExportAliases
        Release notes: $releaseNotes
    "

    $updateParams = @{
        Path = $manifestPath
        ModuleVersion = $newVersion
        ReleaseNotes = $releaseNotes
    }

    if ( $ExportFunctions ) {
        $updateParams += @{
            FunctionsToExport = $ExportFunctions
        }
    }

    if ( $ExportAliases ) {
        $updateParams += @{
            AliasesToExport = $ExportAliases
        }
    }

    Update-ModuleManifest @updateParams

    Write-Output "Updated the module metadata"
} catch {
    Write-Error "Failed to update the module metadata - $_"
}

try {
    Write-Output ("Updating {0} branch source" -f $branch)
    git config user.email 'greg@jagtechnical.com'
    git config user.name 'Greg Brownstein'
    git add *.psd1
    git status -v
    git commit -m "Updated $ModuleName Version to $NewVersion ***NO_CI***"

    # if we are performing pull request validation, do not push the code to the repo
    if ( $env:BUILD_REASON -eq 'PullRequest') {
        Write-Output "Bypassing git push given this build is for pull request validation"
    } else {
        git push https://$($env:GitHubPAT)@github.com/gdbarron/VenafiTppPS.git ('HEAD:{0}' -f $branch)
        Write-Output ("Updated {0} branch source" -f $branch)
    }

} catch {
    Write-Output ("Failed to update {0} branch with updated module metadata" -f $branch)
    $_ | Format-List -Force
}
