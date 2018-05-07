param ($Task = 'Default')

# Grab nuget bits, install modules, set build variables, start build.
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

Install-Module Psake, PSDeploy, BuildHelpers, platyPS, PSScriptAnalyzer -force
Install-Module Pester -Force -SkipPublisherCheck
Import-Module Psake, BuildHelpers, platyPS, PSScriptAnalyzer, PSDeploy -force

Set-BuildEnvironment

Invoke-psake -buildFile .\build\psake.ps1 -taskList $Task -nologo -verbose
exit ([int](-not $psake.build_success))