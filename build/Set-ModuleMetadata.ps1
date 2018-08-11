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

$manifestPath = '{0}\Modules\{1}\code\{1}.psd1' -f $env:BUILD_SOURCESDIRECTORY, $ModuleName
$nuspecPath = "{0}\Modules\$ModuleName\$ModuleName.nuspec" -f $env:BUILD_SOURCESDIRECTORY
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


<#If required modules are sepcified, they must be imported otherwise test-modulemanifest/update-modulemanifest will error out with the error
'The specified RequiredModules entry 'Deloitte.GTS.Utilities' in the module manifest is invalid.  Try again after updating this entry with valid values.

https://stackoverflow.com/questions/46216038/how-do-i-define-requiredmodules-in-a-powershell-module-manifest-psd1
https://github.com/PowerShell/PowerShellGet/blob/90c5a3d4c8a2e698d38cfb5ef4b1c44d79180d66/Tests/PSGetPublishModule.Tests.ps1#L1470

This needs to be revisited to provide support for required modules that are not available in our repository.
For now, an errow will be thrown for any module not matching the name Deloitte

Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Write-Output "Attempting to add module path $AllModulesPath\$($RequiredModuleName)\code ."
$env:PSModulePath += ";$AllModulesPath\$($RequiredModuleName)\code"



Tried to get this working but removed dependency for now and should revisit.
Need the build agent to be able to install modules from its own repostitory.  Not sure how to do that without a PAT.



$AllModulesPath = "{0}\Modules" -f $env:BUILD_SOURCESDIRECTORY

    If (@($Manifest.RequiredModules))
    {
        Write-Output "Required modules are specified.  Attempting to install."

        #$securePassword = ConvertTo-SecureString $($env:SYSTEM_ACCESSTOKEN) -AsPlainText -Force
        #$vstsCredential = New-Object System.Management.Automation.PSCredential 'VssAdministrator', $securePassword

        Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
        Register-PSRepository -Name GTS_Packages -SourceLocation https://app0762-cto-sre.pkgs.visualstudio.com/_packaging/GTS_Packages/nuget/v2

        @($Manifest.RequiredModules).Foreach({
            $RequiredModuleName = $_
            If ($RequiredModuleName -notlike '*Deloitte*')
            {
                Throw "Required module ($($RequiredModuleName)) is not available in the Deloitte repository."
            }

            #Attempt to import
            Write-Output "Attempting to install module $($RequiredModuleName)."

            try {
                Install-Module -Name $RequiredModuleName -scope CurrentUser
            }
            catch {
                Throw "Problem importing $($RequiredModuleName).  $_"
            }
        })
    }
#>

# Load the module, read the exported functions and aliases, update the psd1
$FunctionFiles = Get-ChildItem ".\Modules\$ModuleName\code\Public\*.ps1" |
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
$nuspec = [xml] (Get-Content $nuspecPath -Raw)
$nuspec.package.metadata.version = $NewVersion.ToString()
$nuspec.Save($nuspecPath)

try {
    Write-Output "Updating master branch source"
    git config user.email $env:BUILD_REQUESTEDFOREMAIL
    git config user.name $env:BUILD_REQUESTEDFOR
    git add *.nuspec
    git add *.psd1
    git status -v
    git commit -m "Updated $ModuleName Version to $NewVersion ***NO_CI***"

    # git push https://$($env:SYSTEM_ACCESSTOKEN)@app0762-cto-sre.visualstudio.com/App0762-CTO-SRE-PowerShell/_git/App0762-CTO-SRE-PowerShell ('HEAD:{0}' -f $env:BUILD_SOURCEBRANCHNAME)
    # git push https://$($env:SYSTEM_ACCESSTOKEN)@app0762-cto-sre.visualstudio.com/App0762-CTO-SRE-PowerShell/_git/App0762-CTO-SRE-PowerShell HEAD:master
    Write-Output ("Updated {0} branch source" -f $env:BUILD_SOURCEBRANCHNAME)

} catch {
    $_ | Format-List -Force
    Write-Output "Failed to update master branch with updated module metadata"
}
