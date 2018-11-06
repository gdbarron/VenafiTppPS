<#
.SYNOPSIS
Get attributes for a given object

.DESCRIPTION
Retrieves object attributes.  You can either retrieve all attributes or individual ones.
By default, the attributes returned are not the effective policy, but that can be requested with the
EffectivePolicy switch.

.PARAMETER InputObject
TppObject which represents a unique object

.PARAMETER Path
Path to the object to retrieve configuration attributes.  Just providing DN will return all attributes.

.PARAMETER Guid
Object Guid.  Just providing Guid will return all attributes.

.PARAMETER AttributeName
Only retrieve the value/values for this attribute

.PARAMETER EffectivePolicy
Get the effective policy of the attribute

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
InputObject, Path, Guid

.OUTPUTS
PSCustomObject with properties Name, Value, IsCustomField, and CustomName

.EXAMPLE
Get-TppAttribute -Path '\VED\Policy\My Folder\myapp.company.com'
Retrieve all configurations for a certificate

.EXAMPLE
Get-TppAttribute -Path '\VED\Policy\My Folder\myapp.company.com' -EffectivePolicy
Retrieve all effective configurations for a certificate

.EXAMPLE
Get-TppAttribute -Path '\VED\Policy\My Folder\myapp.company.com' -AttributeName 'driver name'
Retrieve all the value for attribute driver name from certificate myapp.company.com

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppAttribute/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppAttribute.ps1

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-read.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____26

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-readall.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____27

.LINK
https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Config-readeffectivepolicy.php?TocPath=REST%20API%20reference|Config%20programming%20interfaces|_____30

#>
function Get-TppAttribute {
    [CmdletBinding(DefaultParameterSetName = 'ByObject')]
    param (

        [Parameter(Mandatory, ParameterSetName = 'EffectiveByObject', ValueFromPipeline)]
        [Parameter(Mandatory, ParameterSetName = 'ByObject', ValueFromPipeline)]
        [TppObject] $InputObject,

        [Parameter(Mandatory, ParameterSetName = 'EffectiveByPath', ValueFromPipeline)]
        [Parameter(Mandatory, ParameterSetName = 'ByPath', ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                }
                else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('DN')]
        [String[]] $Path,

        [Parameter(Mandatory, ParameterSetName = 'EffectiveByGuid', ValueFromPipeline)]
        [Parameter(Mandatory, ParameterSetName = 'ByGuid', ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [guid[]] $Guid,

        [Parameter(Mandatory, ParameterSetName = 'EffectiveByObject')]
        [Parameter(ParameterSetName = 'ByObject')]
        [Parameter(Mandatory, ParameterSetName = 'EffectiveByPath')]
        [Parameter(ParameterSetName = 'ByPath')]
        [Parameter(Mandatory, ParameterSetName = 'EffectiveByGuid')]
        [Parameter(ParameterSetName = 'ByGuid')]
        [ValidateNotNullOrEmpty()]
        [String[]] $Attribute,

        [Parameter(Mandatory, ParameterSetName = 'EffectiveByObject')]
        [Parameter(Mandatory, ParameterSetName = 'EffectiveByPath')]
        [Parameter(Mandatory, ParameterSetName = 'EffectiveByGuid')]
        [Switch] $EffectivePolicy,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {

        $TppSession.Validate()

        if ( $PSBoundParameters.ContainsKey('Attribute') ) {
            if ( $PSBoundParameters.ContainsKey('EffectivePolicy') ) {
                $uriLeaf = 'config/ReadEffectivePolicy'
            }
            else {
                $uriLeaf = 'config/read'
            }
        }
        else {
            $uriLeaf = 'config/readall'
        }

        $baseParams = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = $uriLeaf
            Body       = @{
                ObjectDN = ''
            }
        }
    }

    process {

        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            '*Object' {
                $pathToProcess = $InputObject.Path
            }

            '*Path' {
                $pathToProcess = $Path
            }

            '*Guid' {
                $pathToProcess = $Guid | ConvertTo-TppPath
            }
        }

        foreach ($thisPath in $pathToProcess) {

            $baseParams.Body['ObjectDN'] = $thisPath

            # if specifying attribute name(s), it's a different rest api
            if ( $PSBoundParameters.ContainsKey('Attribute') ) {

                # get the attribute values one by one as there is no
                # api which allows passing a list
                $configValues = foreach ($thisAttribute in $Attribute) {

                    $params = $baseParams.Clone()
                    $params.Body += @{
                        AttributeName = $thisAttribute
                    }

                    $response = Invoke-TppRestMethod @params

                    if ( $response ) {
                        [PSCustomObject] @{
                            Name  = $thisAttribute
                            Value = $response.Values
                        }
                    }
                }
            }
            else {
                $response = Invoke-TppRestMethod @baseParams
                if ( $response ) {
                    $configValues = $response.NameValues | Select-Object Name,
                    @{
                        n = 'Value'
                        e = {
                            $_.Values
                        }
                    }
                }
            }

            if ( $configValues ) {

                $configValues = @($configValues)

                # convert custom field guids to names
                foreach ($thisConfigValue in $configValues) {

                    $customField = $TppSession.CustomField | Where-Object {$_.Guid -eq $thisConfigValue.Name}
                    $thisConfigValue | Add-Member @{
                        'IsCustomField' = $null -ne $customField
                        'CustomName'    = $null
                    }
                    if ( $customField ) {
                        $thisConfigValue.CustomName = $customField.Label
                    }

                    $thisConfigValue
                }

                # [PSCustomObject] @{
                #     Path      = $thisPath
                #     Attribute = $updatedConfigValues
                # }
            }
        }
    }

    end {

    }
}