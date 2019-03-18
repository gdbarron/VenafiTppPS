<#
.SYNOPSIS
Get custom field details

.DESCRIPTION
Get details about custom fields for either certificates or devices

.PARAMETER Class
Class to get details on.  Value can be either Device or X509 Certificate

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
None

.OUTPUTS
Query returns a PSCustomObject with the following properties:
    Items
        AllowedValues
        Classes
        ConfigAttribute
        DN
        DefaultValues
        Guid
        Label
        Mandatory
        Name
        Policyable
        RenderHidden
        RenderReadOnly
        Single
        Type
    Locked
    Result

.EXAMPLE
Get-TppCustomField -Class 'X509 Certificate'
Get custom fields for certificates

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppCustomField/

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Metadata-GetItemsForClass.php?tocpath=REST%20API%20reference%7CMetadata%20programming%20interfaces%7C_____11

.NOTES
All custom fields are retrieved upon inital connect to the server and a property of TppSession
#>
function Get-TppCustomField {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Device', 'X509 Certificate')]
        [string] $Class,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()
    }

    process {
        $params = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'Metadata/GetItemsForClass'
            Body       = @{
                'ConfigClass' = $Class
            }
        }

        $response = Invoke-TppRestMethod @params

        if ( $response.Result -eq [TppMetadataResult]::Success ) {
            [PSCustomObject] @{
                Items  = $response.Items
                Locked = $response.Locked
            }
        } else {
            throw $response.Error
        }
    }
}
