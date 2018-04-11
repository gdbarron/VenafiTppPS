function Get-TppConfig {
    <#
	.SYNOPSIS 
	Get attributes for a given object
	
	.DESCRIPTION
    Retrieves object’s attributes.  You can either retrieve all attributes or individual ones.
    By default, the attributes returned are not the effective policy, but that can be requested with the
    EffectivePolicy switch.

	.PARAMETER Path
    Path to the object to retrieve configuration attributes.  Just providing Path will return all attributes.

	.PARAMETER AttributeName
    Only retrieve the value/values for this attribute

	.PARAMETER EffectivePolicy
    Get the effective policy of the attribute

	.PARAMETER TppSession
    Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

	.INPUTS

	.OUTPUTS

	.EXAMPLE

	#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'EffectivePolicy', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'NonEffectivePolicy', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("DN")]
        [String[]] $Path,
        
        [Parameter(Mandatory, ParameterSetName = 'EffectivePolicy')]
        [Parameter(ParameterSetName = 'NonEffectivePolicy')]
        [ValidateNotNullOrEmpty()]
        [String] $AttributeName,

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
    }

    process {
	
        foreach ( $thisPath in $Path ) {

            $params = @{
                TppSession = $TppSession
                Method        = 'Post'
                UriLeaf       = $uriLeaf
                Body          = @{
                    ObjectDN = $thisPath
                }
            }

            if ( $AttributeName ) {
                $params.Body += @{
                    AttributeName = $AttributeName
                }
            }

            $response = Invoke-TppRestMethod @params

            if ( $response ) {
                if ( $AttributeName ) {
                    [PSCustomObject] @{
                        DN     = $thisPath
                        Config = $response.Values
                    }
                } else {
                    [PSCustomObject] @{
                        DN     = $thisPath
                        Config = $response.NameValues
                    }
                }
            }
        }
    }

}
