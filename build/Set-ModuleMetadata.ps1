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
    [string] $ModuleName,
    
    [Parameter(Mandatory)]
    [string] $GitHubPat
)

$ErrorActionPreference = "Stop"

# get platyPS needed for documentation generation
Install-PackageProvider -Name Nuget -Scope CurrentUser -Force -Confirm:$false
Install-Module -Name platyPS -Scope CurrentUser -Force -Confirm:$false
Import-Module platyPS

# get current environment variables just for reference
Get-ChildItem env:
$branch = $env:BUILD_SOURCEBRANCHNAME
$projectRoot = $env:BUILD_SOURCESDIRECTORY
$BuildDate = Get-Date -uFormat '%Y-%m-%d'
$releaseNotesPath = "$projectRoot\RELEASE.md"
$changeLogPath = "$projectRoot\docs\ChangeLog.md"


$manifestPath = '{0}\{1}\code\{1}.psd1' -f $projectRoot, $ModuleName
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
$releaseNotes = Get-Content -Path $releaseNotesPath -Raw

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


############### UPDATE DOCS #################
$modulePath = $manifestPath.Replace('.psd1', '.psm1')

"Loading Module from $modulePath to update docs"
Remove-Module $ModuleName -Force -ea SilentlyContinue -Verbose
# platyPS + AppVeyor requires the module to be loaded in Global scope
Import-Module $modulePath -force -Verbose

#Build YAMLText starting with the header
$YMLtext = (Get-Content "$projectRoot\header-mkdocs.yml") -join "`n"
$YMLtext = "$YMLtext`n"
$parameters = @{
    Path        = $releaseNotesPath
    ErrorAction = 'SilentlyContinue'
}
$ReleaseText = (Get-Content @parameters) -join "`n"
if ($ReleaseText) {
    $ReleaseText | Set-Content "$projectRoot\docs\RELEASE.md"
    $YMLText = "$YMLtext  - Release Notes: RELEASE.md`n"
}
if ((Test-Path -Path $changeLogPath)) {
    $YMLText = "$YMLtext  - Change Log: ChangeLog.md`n"
}
$YMLText = "$YMLtext  - Functions:`n"
# Drain the swamp
$parameters = @{
    Recurse     = $true
    Force       = $true
    Path        = "$projectRoot\docs\functions"
    ErrorAction = 'SilentlyContinue'
}
$null = Remove-Item @parameters
$Params = @{
    Path        = "$projectRoot\docs\functions"
    type        = 'directory'
    ErrorAction = 'SilentlyContinue'
}
$null = New-Item @Params
$Params = @{
    Module       = $ModuleName
    Force        = $true
    OutputFolder = "$projectRoot\docs\functions"
    NoMetadata   = $true
}
New-MarkdownHelp @Params | foreach-object {
    $Function = $_.Name -replace '\.md', ''
    $Part = "    - {0}: functions/{1}" -f $Function, $_.Name
    $YMLText = "{0}{1}`n" -f $YMLText, $Part
    $Part
}
$YMLtext | Set-Content -Path "$projectRoot\mkdocs.yml"

$YMLtext
gci "$projectRoot\docs" -Recurse

try {
    Write-Output ("Updating {0} branch source" -f $branch)
    git config user.email 'greg@jagtechnical.com'
    git config user.name 'Greg Brownstein'
    git add *.psd1
    git add *.md
    git add "$projectRoot\mkdocs.yml"
    git status -v
    git commit -m "Updated $ModuleName Version to $NewVersion ***NO_CI***"

    # if we are performing pull request validation, do not push the code to the repo
    if ( $env:BUILD_REASON -eq 'PullRequest') {
        Write-Output "Bypassing git push given this build is for pull request validation"
    } else {
        git push https://$($GitHubPat)@github.com/gdbarron/VenafiTppPS.git ('HEAD:{0}' -f $branch)
        Write-Output ("Updated {0} branch source" -f $branch)
    }

} catch {
    Write-Output ("Failed to update {0} branch with updated module metadata" -f $branch)
    $_ | Format-List -Force
}
