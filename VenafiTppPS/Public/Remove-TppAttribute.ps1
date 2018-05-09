<#
.SYNOPSIS 
TO BE IMPLEMENTED - Removes a value from an attribute

.DESCRIPTION
Write a value to the object's configuration.  This function will append by default.  Attributes can have multiple values which may not be the intended use.  To ensure you only have one value for an attribute, use the Overwrite switch.

.PARAMETER ObjectDN
Path to the object to modify

.PARAMETER AttributeName
Name of the attribute to modify

.PARAMETER RemoveAll


.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
System.String[] for DN

.OUTPUTS
PSCustomObject with the following properties:
    DN = path to object
    Success = boolean indicating success or failure
    Error = Error message in case of failure

.EXAMPLE
Set-TppAttribute -DN '\VED\Policy\My Folder\app.company.com -AttributeName '{xyz12345-1234-abcd-efgh-dfghjklmnbvf}' -Value 'new custom value'
Set value on custom field

.EXAMPLE
Set-TppAttribute -DN '\VED\Policy\My Folder\app.company.com -AttributeName 'Consumers' -Value '\VED\Policy\myappobject.company.com' -Overwrite
Set value on a certificate by overwriting any existing values

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Set-TppAttribute/

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Remove-TppAttribute/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Public/Set-TppAttribute.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-addvalue.php?tocpath=REST%20API%20reference%7CConfig%20programming%20interfaces%7C_____4

#>
function Set-TppAttribute {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ -match "^\\VED\\.*" ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN"
                }
            })]
        [String[]] $DN,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $AttributeName,

        [Parameter()]
        [Switch] $RemoveAll,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {

        Write-Warning "Not implemented yet"
        exit

        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            Body       = @{
                AttributeName = $AttributeName
            }
        }

        if ($Overwrite) {
            $params += @{
                UriLeaf = 'config/Write'
            }
        } else {
            $params += @{
                UriLeaf = 'config/AddValue'
            }
        }
    }

    process {

        foreach ($thisDn in $DN) {

            $params.Body += @{
                ObjectDN = $thisDn
            }

            # overwrite can accept multiple values at once so pass in the entire list
            # adding values can not so we must loop
            if ($Overwrite) {
                $params.Body += @{
                    Values = $Value
                }
                $response = Invoke-TppRestMethod @params

                [PSCustomObject] @{
                    DN      = $thisDn
                    Success = $response.Result -eq [ConfigResult]::Success
                    Error   = $response.Error
                }
            } else {
                foreach ($thisValue in $Value) {
                    
                    $params.Body += @{
                        Value = $thisValue
                    }
                    $response = Invoke-TppRestMethod @params
        
                    [PSCustomObject] @{
                        DN      = $thisDn
                        Success = $response.Result -eq [ConfigResult]::Success
                        Error   = $response.Error
                    }
                }
            }

        }
    }
}