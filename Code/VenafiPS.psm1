<#
.SYNOPSIS
PowerShell module to access the features of Venafi Trust Protection Platform REST API

.DESCRIPTION
Author: Greg Brownstein
#>

$Script:VenafiSession = $null
$script:VenafiUrl = $null

class VenafiSession {
    
    [ValidateNotNullOrEmpty()][string] $APIKey
    [ValidateNotNullOrEmpty()][System.Management.Automation.PSCredential] $Credential
    [ValidateNotNullOrEmpty()][string] $ServerUrl
    [ValidateNotNullOrEmpty()][datetime] $ValidUntil

    VenafiSession($APIKey, $Credential, $ServerUrl, $ValidUntil) {
        $this.APIKey = $APIKey
        $this.Credential = $Credential
        $this.ServerUrl = $ServerUrl
        $this.ValidUntil = $ValidUntil
    }
}

$public = @( Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -ErrorAction SilentlyContinue )
$private = @( Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue )

Foreach ($import in @($public + $private)) {
    Try {
        . $import.fullname
    } Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -variable VenafiUrl
Export-ModuleMember -variable VenafiSession
Export-ModuleMember -Function $public.Basename
