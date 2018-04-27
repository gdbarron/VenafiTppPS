<#
.SYNOPSIS 
Adds a value to an attribute

.DESCRIPTION
Write a value to the object's configuration.  This function will append by default.  Attributes can have multiple values which may not be the intended use.  To ensure you only have one value for an attribute, use the Overwrite switch or call Remove-TppAttribute prior to calling Set-TppAttribute.

.PARAMETER ObjectDN
Path to the object to modify

.PARAMETER AttributeName
Name of the attribute

.PARAMETER Value
Value to write to the attribute

.PARAMETER Overwrite
Provide this switch to replace an existing value as opposed to appending

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

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String] $Value,

        [Parameter()]
        [Switch] $Overwrite,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()
    }

    process {

        foreach ($thisDn in $DN) {

            # cleanup existing values to ensure we don't have multiples
            if ($Overwrite) {
                Remove-TppAttribute -ObjectDN $thisDn -AttributeName $AttributeName
            }

            $params = @{
                TppSession = $TppSession
                Method     = 'Post'
                UriLeaf    = 'config/AddValue'
                Body       = @{
                    ObjectDN      = $thisDn
                    AttributeName = $AttributeName
                    Value         = $Value
                }
            }
		
            $response = Invoke-TppRestMethod @params
            [PSCustomObject] {
                DN = $thisDn
                Success = $response.Result -eq [ConfigResult]::Success
                Error = $response.Error
            }
        }
    }
}