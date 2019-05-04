$script:ModuleName = 'ReportCardPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
function New-ClarityDocument { }
function Invoke-Expression { }
function Get-Content { }
function Close-ClarityDocument { }
$RawReturn = @(
    @{
        "CardTile"      = "Memory"
        "CardFunction"  = "Get-vCenterMemory"
        "CardArguments" = ""
        "Order"         = "2"
    }               
)
$ReturnJson = $RawReturn | ConvertTo-Json

Describe "New-ReportCard function for $script:ModuleName" -Tags Build {
    It "Should return False if -WhatIf is used." {
        New-ReportCard -Title MyNewDoc -JsonFilePath "c:\test\thispath.json" -WhatIf | Should be $false
    }
    It "Should Return true." {
        Mock -CommandName "New-ClarityDocument" -MockWith {
            return "<New HTML>"
        }
        Mock -CommandName "Invoke-Expression" -MockWith {
            return "<The body html>"
        }
        Mock -CommandName "Get-Content" -MockWith {
            return $ReturnJson
        }
        Mock -CommandName "Close-ClarityDocument" -MockWith {
            return "<htmlStuff>"
        }
        New-ReportCard -Title MyNewDoc -JsonFilePath "c:\test\thispath.json" | Should not be $null
    }
    It "Should Return true." {
        Mock -CommandName "New-ClarityDocument" -MockWith {
            return "<New HTML>"
        }
        Mock -CommandName "Invoke-Expression" -MockWith {
            return "<The body html>"
        }
        Mock -CommandName "Get-Content" -MockWith {
            return $ReturnJson
        }
        Mock -CommandName "Close-ClarityDocument" -MockWith {
            return "<htmlStuff>"
        }
        { New-ReportCard -Title MyNewDoc -JsonFilePath "c:\test\thispath.json" } | Should not Throw
    }
    It "Should Return Throw, if Invoke-Expression Fails." {
        Mock -CommandName "New-ClarityDocument" -MockWith {
            return "<New HTML>"
        }
        Mock -CommandName "Invoke-Expression" -MockWith {
            Throw "Invoke-Expression Failed"
        }
        Mock -CommandName "Get-Content" -MockWith {
            return $ReturnJson
        }
        Mock -CommandName "Close-ClarityDocument" -MockWith {
            return "<htmlStuff>"
        }
        { New-ReportCard -Title MyNewDoc -JsonFilePath "c:\test\thispath.json" } | Should Throw
    }
    It "Should Return Throw, if New-ClarityDocument Fails." {
        Mock -CommandName "New-ClarityDocument" -MockWith {
            Throw "New ClarityDocument failed."
        }
        Mock -CommandName "Invoke-Expression" -MockWith {
            return "<The body html>"
        }
        Mock -CommandName "Get-Content" -MockWith {
            return $ReturnJson
        }
        Mock -CommandName "Close-ClarityDocument" -MockWith {
            return "<htmlStuff>"
        }
        { New-ReportCard -Title MyNewDoc -JsonFilePath "c:\test\thispath.json" } | Should Throw
    }
    It "Should Return Throw, if Close-ClarityDocument Fails." {
        Mock -CommandName "New-ClarityDocument" -MockWith {
            return "<New HTML>"
        }
        Mock -CommandName "Invoke-Expression" -MockWith {
            return "<The body html>"
        }
        Mock -CommandName "Get-Content" -MockWith {
            return $ReturnJson
        }
        Mock -CommandName "Close-ClarityDocument" -MockWith {
            Throw "Close-ClarityDocument failed."
        }
        { New-ReportCard -Title MyNewDoc -JsonFilePath "c:\test\thispath.json" } | Should Throw
    }
    It "Should Return Throw, if New-ClarityDocument Fails." {
        Mock -CommandName "New-ClarityDocument" -MockWith {
            return "<New HTML>"
        }
        Mock -CommandName "Invoke-Expression" -MockWith {
            return "<The body html>"
        }
        Mock -CommandName "Get-Content" -MockWith {
            Throw "Get-Content Failed."
        }
        Mock -CommandName "Close-ClarityDocument" -MockWith {
            return "<htmlStuff>"
        }
        { New-ReportCard -Title MyNewDoc -JsonFilePath "c:\test\thispath.json" } | Should Throw
    }
}