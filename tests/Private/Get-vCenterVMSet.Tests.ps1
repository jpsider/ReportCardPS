$script:ModuleName = 'ReportCardPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-vCenterVMSet function for $script:ModuleName" -Tags Build
{
    It "Should return False if -WhatIf is used." {
        Get-vCenterVMSet -WhatIf | Should be $false
    }
    It "Should Return true." {
        Get-vCenterVMSet | Should be $true
    }
}
