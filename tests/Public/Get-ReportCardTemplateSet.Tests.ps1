$script:ModuleName = 'ReportCardPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

function Get-Module { }
function Get-ChildItem { }
$RawReturn = @(
    @{
        path = 'c:\someModulePath'
    }               
)
$ReturnJson = $RawReturn | ConvertTo-Json
$ReturnData = $ReturnJson | convertfrom-json
$RawReturn1 = @(
    @{
        fullname = 'c:\someModulePath\lib\test.json'
    }               
)
$ReturnJson1 = $RawReturn1 | ConvertTo-Json
$ReturnData1 = $ReturnJson1 | convertfrom-json
Describe "Get-ReportCardTemplateSet function for $script:ModuleName" -Tags Build {
    It "Should return False if -WhatIf is used." {
        Get-ReportCardTemplateSet -WhatIf | Should be $false
    }
    It "Should Return true." {
        Mock -CommandName 'Get-Module' -MockWith {
            return $ReturnData
        }
        Mock -CommandName 'Get-ChildItem' -MockWith {
            return $ReturnData1
        }
        Get-ReportCardTemplateSet | Should not be $null
    }
    It "Should Return true." {
        Mock -CommandName 'Get-Module' -MockWith {
            return $ReturnData
        }
        Mock -CommandName 'Get-ChildItem' -MockWith {
            return $ReturnData1
        }
        { Get-ReportCardTemplateSet } | Should not Throw
    }
    It "Should Throw, if Get-Module Fails." {
        Mock -CommandName 'Get-Module' -MockWith {
            Throw "Get-Module Failed"
        }
        Mock -CommandName 'Get-ChildItem' -MockWith {
            return $ReturnData1
        }
        { Get-ReportCardTemplateSet } | Should Throw
    }
    It "Should Throw, if Get-ChildItem Fails." {
        Mock -CommandName 'Get-Module' -MockWith {
            return $ReturnData
        }
        Mock -CommandName 'Get-ChildItem' -MockWith {
            Throw "Get-ChildItem Failed"
        }
        { Get-ReportCardTemplateSet } | Should Throw
    }
}