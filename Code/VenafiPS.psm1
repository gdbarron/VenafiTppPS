<#
.SYNOPSIS
    PowerShell module to access the features of Venafi Trust Protection Platform REST API

.DESCRIPTION
    Author: Greg Brownstein
#>

$Script:VenafiSession = $null
$script:VenafiUrl = $null

###############

$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach ($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    } Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -variable VenafiUrl
Export-ModuleMember -variable VenafiSession
Export-ModuleMember -Function $Public.Basename
