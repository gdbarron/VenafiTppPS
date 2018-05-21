function Test-TppDnPath {
   
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Path
    )

    process {
        $_ -match '(^\\VED)(\\[^\\]+)+$'
    }
}