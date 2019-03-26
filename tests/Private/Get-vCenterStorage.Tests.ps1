$script:ModuleName = 'ReportCardPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-vCenterStorage function for $script:ModuleName" -Tags Build
{
    It "Should return False if -WhatIf is used." {
        Get-vCenterStorage -WhatIf | Should be $false
}
It "Should Return true." {
    Get-vCenterStorage | Should be $true
}
}
