$script:ModuleName = 'ReportCardPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-ReportCard function for $script:ModuleName" -Tags Build {
    It "Should return False if -WhatIf is used." {
        New-ReportCard -WhatIf | Should be $false
}
It "Should Return true." {
    New-ReportCard | Should not be $null
}
It "Should Return true." {
    { New-ReportCard } | Should not Throw
}
It "Should Return Throw, if Write-Output Fails." {
    Mock -CommandName 'Write-Output' -MockWith {
        Throw "Write-Output failed."
    }
    { New-ReportCard } | Should Throw
}
}