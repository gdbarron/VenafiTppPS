<#
.SYNOPSIS
Get object information

.DESCRIPTION
Return object information by either path or guid.  This will return a TppObject which can be used with many other functions.

.PARAMETER Path
The full path to the object

.PARAMETER Guid
Guid of the object

.PARAMETER TppSession
Session object created from New-TppSession method.  The value defaults to the script session object $TppSession.

.INPUTS
Path, Guid

.OUTPUTS
TppObject

.EXAMPLE
Get-TppObject -Path '\VED\Policy\My object'

Get an object by path

.EXAMPLE
[guid]'dab22152-0a81-4fb8-a8da-8c5e3d07c3f1' | Get-TppObject

Get an object by guid

.LINK
http://venafitppps.readthedocs.io/en/latest/functions/Get-TppObject/

.LINK
https://github.com/gdbarron/VenafiTppPS/blob/master/VenafiTppPS/Code/Public/Get-TppObject.ps1

#>
function Get-TppObject {

    [CmdletBinding()]

    param (
        [Parameter(Mandatory, ParameterSetName = 'ByPath', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( {
                if ( $_ | Test-TppDnPath ) {
                    $true
                } else {
                    throw "'$_' is not a valid DN path"
                }
            })]
        [Alias('DN')]
        [String[]] $Path,

        [Parameter(Mandatory, ParameterSetName = 'ByGuid', ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('ObjectGuid')]
        [guid[]] $Guid,

        [Parameter()]
        [TppSession] $TppSession = $Script:TppSession
    )

    begin {
        $TppSession.Validate()
    }

    process {

        if ( $PSCmdLet.ParameterSetName -eq 'ByPath' ) {
            $inputObject = $Path
        } else {
            $inputObject = $Guid
        }

        foreach ($thisInputObject in $inputObject) {
            [TppObject]::new($thisInputObject)
        }
    }
}