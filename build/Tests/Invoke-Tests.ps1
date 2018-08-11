# http://www.workingsysadmin.com/invoking-pester-and-psscriptanalyzer-tests-in-hosted-vsts/

$ErrorActionPreference = 'stop'

Install-PackageProvider -Name Nuget -Scope CurrentUser -Force -Confirm:$false

# skippublishercheck is required for pester, https://github.com/pester/Pester/wiki/Installation-and-Update
Install-Module -Name Pester -Scope CurrentUser -Force -Confirm:$false -SkipPublisherCheck

Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force -Confirm:$false
Import-Module Pester
Import-Module PSScriptAnalyzer
# Invoke-Pester -OutputFile 'PesterResults.xml' -OutputFormat 'NUnitXml' -Script '.\Tests\Set-E.tests.ps1'

$excludePssaTests = @('PSShouldProcess','PSUseShouldProcessForStateChangingFunctions')

if (test-path '.\Tests\Set-ModuleSpecificTestParams.ps1') {
    write-output ".\Tests\Set-ModuleSpecificTestParams.ps1 found, executing..."
    . .\Tests\Set-ModuleSpecificTestParams.ps1
}
        
$failure = $false

$results = Invoke-Pester -OutputFile 'PSSAResults.xml' -OutputFormat 'NUnitXml' -Script .\Tests -PassThru
if ($results.FailedCount -gt 0) {$failure=$true} 

$results = Invoke-Pester -OutputFile 'PSSAResults.xml' -OutputFormat 'NUnitXml' -Script "$PSScriptRoot\CommonPSSA.tests.ps1" -PassThru
if ($results.FailedCount -gt 0) {$failure=$true} 

if ($failure) {throw "at least one test failed"}