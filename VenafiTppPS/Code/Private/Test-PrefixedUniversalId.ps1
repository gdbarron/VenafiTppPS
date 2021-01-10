function Test-PrefixedUniversalId {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string] $PrefixedUniversalId
    )

    process {
        $PrefixedUniversalId -match '^(AD|LDAP)+.+:\w{32}$' -or $PrefixedUniversalId -match '^local:\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$'
    }
}