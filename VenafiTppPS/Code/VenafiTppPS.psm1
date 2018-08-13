<#
.SYNOPSIS
PowerShell module to access the features of Venafi Trust Protection Platform REST API

.DESCRIPTION
Author: Greg Brownstein
#>

$folders = @('Enums', 'Classes', 'Public', 'Private')

$folders | % {

    $files = Get-ChildItem -Path $PSScriptRoot\$_\*.ps1 -Recurse
    # $files = Get-ChildItem -Path $PSScriptRoot\$_\*.ps1 -Recurse -ErrorAction SilentlyContinue

    Foreach ( $thisFile in $files ) {
        Try {
            . $thisFile.fullname
        } Catch {
            Write-Error ("Failed to import function {0}: {1}" -f $thisFile.fullname, $_)
        }
    }
}

$publicFiles = Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -Recurse -ErrorAction SilentlyContinue
Export-ModuleMember -Function $publicFiles.Basename

$Script:TppSession = New-Object 'TppSession'
# $script:VenafiUrl = $null
# Export-ModuleMember -variable VenafiUrl
Export-ModuleMember -variable TppSession
