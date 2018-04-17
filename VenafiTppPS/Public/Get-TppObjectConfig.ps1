<#
.SYNOPSIS 
Get attributes for a given object

.DESCRIPTION
Retrieves object’s attributes.  You can either retrieve all attributes or individual ones.
By default, the attributes returned are not the effective policy, but that can be requested with the
EffectivePolicy switch.

.PARAMETER DN
Path to the object to retrieve configuration attributes.  Just providing DN will return all attributes.

.PARAMETER AttributeName
Only retrieve the value/values for this attribute

.PARAMETER EffectivePolicy
Get the effective policy of the attribute

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
DN

.OUTPUTS

.EXAMPLE

#>
function Get-TppObjectConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'EffectivePolicy', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'NonEffectivePolicy', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                # this regex could be better
                if ( $_ -match "^\\VED\\Policy\\.*" ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN"
                }
            })]
        [String[]] $DN,
        
        [Parameter(Mandatory, ParameterSetName = 'EffectivePolicy')]
        [Parameter(ParameterSetName = 'NonEffectivePolicy')]
        [ValidateNotNullOrEmpty()]
        [String[]] $AttributeName,

        [Parameter(Mandatory, ParameterSetName = 'EffectivePolicy')]
        [Switch] $EffectivePolicy,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        if ( $AttributeName ) {
            if ( $EffectivePolicy ) {
                $uriLeaf = 'config/ReadEffectivePolicy'
            } else {
                $uriLeaf = 'config/read'
            }
        } else {
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
	
        foreach ( $thisDN in $DN ) {

            $baseParams.Body['ObjectDN'] = $thisDN

            if ( $AttributeName ) {

                $configValues = @()
                # $configValues = [System.Collections.ArrayList] @()
    
                foreach ( $thisAttribute in $AttributeName ) {
    
                    $params = $baseParams.Clone()
                    $params.Body += @{
                        AttributeName = $thisAttribute
                    }
    
                    $response = Invoke-TppRestMethod @params
    
                    if ( $response ) {
                        $configValues += [PSCustomObject] @{
                            Name  = $thisAttribute
                            Value = $response.Values
                        }
                        # $null = $configValues.Add(
                        #     [PSCustomObject] @{
                        #         Name  = $thisAttribute
                        #         Value = $response.Values
                        #     }
                        # )
                        # $null = $configValues.Add($response.Values)
                    }
                } # attribute
            } else {
                $response = Invoke-TppRestMethod @baseParams
                if ( $response ) {
                    $configValues = $response.NameValues
                }
            } # DN

            if ( $configValues ) {
                [PSCustomObject] @{
                    DN     = $thisDN
                    Config = $configValues
                }
            }
        }
    }
}