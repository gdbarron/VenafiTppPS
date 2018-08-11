function Join-UriPath {

    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]

    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Path
    )

    process {

        # http://stackoverflow.com/questions/9593535/best-way-to-join-parts-with-a-separator-in-powershell
        return ($Path | ? { $_ } | % { $_.trim('/').trim().replace('\', '/') } | ? { $_ } ) -join '/'
    }
}