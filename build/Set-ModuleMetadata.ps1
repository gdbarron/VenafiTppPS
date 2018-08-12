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

$manifestPath = '{0}\{1}\code\{1}.psd1' -f $env:BUILD_SOURCESDIRECTORY, $ModuleName
$nuspecPath = "{0}\$ModuleName\$ModuleName.nuspec" -f $env:BUILD_SOURCESDIRECTORY
Write-Output "Processing module path $manifestPath and nuspec path $nuspecPath"
try {
    $manifest = Import-PowerShellDataFile $manifestPath
}
catch {
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



try {
    Write-Output "Updating the module metadata
        New version: $newVersion
        Functions: $ExportFunctions
        Aliases: $ExportAliases
    "
    Update-ModuleManifest -Path $manifestPath -ModuleVersion $newVersion
    if ( $ExportFunctions ) {
        Update-ModuleManifest -Path $manifestPath -FunctionsToExport $ExportFunctions
    }
    if ( $ExportAliases ) {
        Update-ModuleManifest -Path $manifestPath -AliasesToExport $ExportAliases
    }
    Write-Output "Updated the module metadata"
} catch {
    Write-Error "Failed to update the module metadata - $_"
}

# update nuspec version
# $nuspec = [xml] (Get-Content $nuspecPath -Raw)
# $nuspec.package.metadata.version = $NewVersion.ToString()
# $nuspec.Save($nuspecPath)

try {
    Write-Output ("Updating {0} branch source" -f $env:BUILD_SOURCEBRANCHNAME)
    git config user.email 'greg@jagtechnical.com'
    git config user.name 'Greg Brownstein'
    # git add *.nuspec
    git add *.psd1
    git status -v
    git commit -m "Updated $ModuleName Version to $NewVersion ***NO_CI***"

    git push https://$($env:GitHubPAT)@github.com/gdbarron/VenafiTppPS.git ('HEAD:{0}' -f $env:BUILD_SOURCEBRANCHNAME)

    Write-Output ("Updated {0} branch source" -f $env:BUILD_SOURCEBRANCHNAME)

} catch {
    $_ | Format-List -Force
    Write-Output "Failed to update master branch with updated module metadata"
}
