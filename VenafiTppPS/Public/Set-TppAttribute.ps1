<#
.SYNOPSIS 
Adds a value to an attribute

.DESCRIPTION
Write a value to the object's configuration.  This function will append by default.  Attributes can have multiple values which may not be the intended use.  To ensure you only have one value for an attribute, use the Overwrite switch.

.PARAMETER ObjectDN
Path to the object to modify

.PARAMETER AttributeName
Name of the attribute to modify

.PARAMETER Value
Value or list of values to write to the attribute.

.PARAMETER IsCustomField
Attribute name provided matches a "Label" for a custom field.
The Guid associated with this custom field will be used as the attribute name when updating.

.PARAMETER Overwrite
Replace existing values as opposed to appending

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
Set-TppAttribute -DN '\VED\Policy\My Folder\app.company.com -AttributeName 'My custom field' -Value 'new custom value' -IsCustomField
Set value on custom field.  This will add to any existing value.

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

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String[]] $Value,

        [Parameter()]
        [Switch] $IsCustomField,
        
        [Parameter()]
        [Switch] $Overwrite,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
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

            $realAttributeName = $AttributeName
            if ( $IsCustomField ) {
                $field = $TppSession.CustomField | where {$_.Label -eq $AttributeName}
                if ( $field ) {
                    $realAttributeName = $field.Guid
                } else {
                    throw ("Attribute name {0} was not found as a custom field" -f $AttributeName)
                }
            }
            
            $params.Body = @{
                ObjectDN      = $thisDn
                AttributeName = $realAttributeName
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