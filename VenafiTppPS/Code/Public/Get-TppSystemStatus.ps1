<#
.SYNOPSIS
Get the TPP system status

.DESCRIPTION
Returns service module statuses for Trust Protection Platform, Log Server, and Trust Protection Platform services that run on Microsoft Internet Information Services (IIS)

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS
PSCustomObject

.EXAMPLE
Get-TppSystemStatus
Get the status

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppSystemStatus/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppSystemStatus.ps1

.LINK
https://docs.venafi.com/Docs/18.4SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-SystemStatus.php?tocpath=REST%20API%20reference%7CSystemStatus%20programming%20interfaces%7C_____1

#>
function Get-TppSystemStatus {
    [CmdletBinding()]
    param (
        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    Write-Warning "Possible bug with Venafi TPP API causing this to fail"

    $TppSession.Validate()

    $params = @{
        TppSession = $TppSession
        Method     = 'Get'
        UriLeaf    = 'SystemStatus'
    }

    try {
        Invoke-TppRestMethod @params
    }
    catch {
        Throw ("Getting the system status failed with the following error: {0}.  Ensure you have read rights to the engine root." -f $_)
    }
}