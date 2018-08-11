Describe 'Testing against PSSA rules' {
    Context 'PSSA Standard Rules' {
        
        # load up my list of scripts to test
        #$Public  = @( Get-ChildItem -Path ..\Deloitte.GTS.uDeploy\Deloitte.GTS.uDeploy\Public\*.ps1 -ErrorAction SilentlyContinue )
        #$Private = @( Get-ChildItem -Path ..\Deloitte.GTS.uDeploy\Deloitte.GTS.uDeploy\Private\*.ps1 -ErrorAction SilentlyContinue )
        $scripts = @( Get-ChildItem -Path .\*.ps1 -Recurse -ErrorAction SilentlyContinue | ? {$_.FullName -notmatch '\\Tests\\'} )
        
        Foreach($import in $scripts) {
            Try {
                write-output "Processing $import.fullname"
                $analysis = Invoke-ScriptAnalyzer -Path $import.fullname
                $scriptAnalyzerRules = Get-ScriptAnalyzerRule | where {$excludePssaTests -notcontains $_.RuleName}
 
                forEach ($rule in $scriptAnalyzerRules) {
                    It "Should pass $rule" {
                        If ($analysis.RuleName -contains $rule) {
                            $analysis |
                            Where RuleName -EQ $rule -outvariable failures |
                            Out-Default
                            $failures.Count | Should Be 0
                        }
                    }
                }
            }
            Catch {
                Write-Error -Message "Failed to run test $($import.fullname): $_"
            }
        }

    }
}