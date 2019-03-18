<#
.SYNOPSIS
Read entries from the TPP log

.DESCRIPTION
Read entries from the Tpp log

.PARAMETER Limit
Specify the number of items to retrieve, starting with most recent

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
none

.OUTPUTS

.EXAMPLE
Read-TppLog -Limit 10
Get the most recent 10 log items

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Read-TppLog/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Read-TppLog.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-GET-Log.php?tocpath=REST%20API%20reference%7CLog%20programming%20interfaces%7C_____1

#>
function Read-TppLog {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Int] $Limit,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    $TppSession.Validate()

    $params = @{
        TppSession = $TppSession
        Method     = 'Get'
        UriLeaf    = 'Log'
        Body       = @{ }
    }

    if ( $Limit ) {
        $params.Body += @{
            Limit = $Limit
        }
    }

    Invoke-TppRestMethod @params

}