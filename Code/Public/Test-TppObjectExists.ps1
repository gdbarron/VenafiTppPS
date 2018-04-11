<#
.SYNOPSIS 
Test if an object exists

.DESCRIPTION
Provided with either a DN path or GUID, find out if an object exists.

.PARAMETER DN
DN path to object

.PARAMETER Guid
Guid which represents a unqiue object

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
DN or Guid

.OUTPUTS
If providing a DN or Guid via the pipeline, a PSCustomObject will be returned with properties Object and Found.  Object will be either the DN or Guid provided and Found is a boolean if the Object was found.  Otherwise, this function simply returns a boolean.

.EXAMPLE
Test-TppObjectExist -DN '\VED\Policy\My Folder'
False

Test for existence of a single object by DN

.EXAMPLE
Test-TppObjectExist -Guid '{1234-5555555-777777-xxssss}
True

Test for existence of a single object by Guid

.EXAMPLE
$multDNs | Test-TppObjectExist
ObjectDN                  Found
--------                  -----
\VED\Policy\My folder1    True
\VED\Policy\My folder2    False

Test for existence of a single object by Guid

#>
function Test-TppObjectExists {

    [CmdletBinding(DefaultParameterSetName = 'DN')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'DN', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]] $DN,
        
        [Parameter(Mandatory, ParameterSetName = 'Guid', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [String[]] $Guid,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()

        $baseParams = @{
            TppSession = $TppSession
            Method     = 'Post'
            UriLeaf    = 'config/IsValid'
        }

        Switch ($PsCmdlet.ParameterSetName)	{

            'DN' {
                $parameterName = 'ObjectDN'
            }
            
            'Guid' {
                $parameterName = 'ObjectGUID'
            }

        }

        $params = $baseParams += @{
            Body = @{
                $parameterName = ''
            }
        }

        $isPipeline = $PSCmdlet.MyInvocation.ExpectingInput

    }

    process {

        Switch ($PsCmdlet.ParameterSetName)	{

            'DN' {
                $iterateValue = $DN
            }

            'Guid' {
                $iterateValue = $Guid
            }
        }

        foreach ( $thisValue in $iterateValue ) {

            $params.body[$parameterName] = $thisValue

            $response = Invoke-TppRestMethod @params

            if ( $isPipeline ) {
                [PSCustomObject] @{
                    'Object' = $thisValue
                    Found    = ($response.Result -eq [ConfigResult]::Success)
                }
            } else {
                $response.Result -eq [ConfigResult]::Success
            }
        }
    }
}
