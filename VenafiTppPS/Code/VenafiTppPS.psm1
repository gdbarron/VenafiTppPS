<#
.SYNOPSIS
PowerShell module to access the features of Venafi Trust Protection Platform REST API

.DESCRIPTION
Author: Greg Brownstein
#>

$folders = @('Enums', 'Classes', 'Public', 'Private')

foreach ( $folder in $folders) {

    $files = Get-ChildItem -Path $PSScriptRoot\$folder\*.ps1 -Recurse

    Foreach ( $thisFile in $files ) {
        Try {
            . $thisFile.fullname
        }
        Catch {
            Write-Error ("Failed to import function {0}: {1}" -f $thisFile.fullname, $folder)
        }
    }
}

$publicFiles = Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -Recurse -ErrorAction SilentlyContinue
Export-ModuleMember -Function $publicFiles.Basename

$Script:TppSession = New-Object 'TppSession'
Export-ModuleMember -variable TppSession

Set-Alias -Name 'ConvertTo-TppDN' -Value 'ConvertTo-TppPath'
Set-Alias -Name 'Get-TppObject' -Value 'Find-TppObject'
Export-ModuleMember -Alias *
