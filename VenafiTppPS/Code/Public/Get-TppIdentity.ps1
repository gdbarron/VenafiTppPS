<#
.SYNOPSIS
Get identity details

.DESCRIPTION
Returns information about individual identity, group identity, or distribution groups from a local or non-local provider such as Active Directory.

.PARAMETER ID
The individual identity, group identity, or distribution group prefixed universal id

.PARAMETER Me
Returns the identity of the authenticated user

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
ID

.OUTPUTS
PSCustomObject with the following properties:
    Name
    ID
    Path

.EXAMPLE
Get-TppIdentity -ID 'AD+myprov:asdfgadsf9g87df98g7d9f8g7'

Get identity details from an id

.EXAMPLE
Get-TppIdentity -Me

Get identity details for user in the current session

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppIdentity/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/main/VenafiTppPS/Code/Public/Get-TppIdentity.ps1

.LINK
https://docs.venafi.com/Docs/20.4SDK/TopNav/Content/SDK/WebSDK/r-SDK-POST-Identity-Validate.php?tocpath=Web%20SDK%7CIdentity%20programming%20interface%7C_____15

.LINK
https://docs.venafi.com/Docs/20.4SDK/TopNav/Content/SDK/WebSDK/r-SDK-GET-Identity-Self.php?tocpath=Web%20SDK%7CIdentity%20programming%20interface%7C_____13

#>
function Get-TppIdentity {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',	Justification = "Parameter is used")]

    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String[]] $ID,

        [Parameter(Mandatory, ParameterSetName = 'Me')]
        [Switch] $Me,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        Switch ($PsCmdlet.ParameterSetName)	{
            'Id' {
                $params = @{
                    TppSession = $TppSession
                    Method     = 'Post'
                    UriLeaf    = 'Identity/Validate'
                    Body       = @{
                        'ID' = @{
                            'PrefixedUniversal' = ''
                        }
                    }
                }
            }

            'Me' {
                $params = @{
                    TppSession = $TppSession
                    Method     = 'Get'
                    UriLeaf    = 'Identity/Self'
                }
            }
        }
    }

    process {

        Switch ($PsCmdlet.ParameterSetName)	{
            'Id' {
                $idOut = foreach ( $thisId in $ID ) {

                    $params.Body.Id.PrefixedUniversal = $thisId

                    $response = Invoke-TppRestMethod @params
                }
            }

            'Me' {
                $response = Invoke-TppRestMethod @params

                $idOut = $response.Identities | Select-Object -First 1
            }
        }

        if ( $idOut ) {
            $idOut | Select-Object `
            @{
                n = 'Name'
                e = { $_.Name }
            },
            @{
                n = 'ID'
                e = { $_.PrefixedUniversal }
            },
            @{
                n = 'Path'
                e = { $_.FullName }
            }
        }
    }
}
