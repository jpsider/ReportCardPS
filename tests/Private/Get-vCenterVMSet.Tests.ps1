$script:ModuleName = 'ReportCardPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

function New-ClarityCard { }
function Add-ClarityCardBody { }
function Close-ClarityCardBody { }
function Close-ClarityCard { }
function Get-VM { }

Describe "Get-vCenterVMSet function for $script:ModuleName" -Tags Build {
    It "Should return False if -WhatIf is used." {
        Get-vCenterVMSet -WhatIf | Should be $false
    }
    It "Should Return true." {
        Mock -CommandName 'Get-VM' -MockWith {
            $RawReturn = @(
                @{
                    name       = 'testvm01'
                    PowerState = 'POWEREDON'
                },
                @{
                    name       = 'testvm02'
                    PowerState = 'POWEREDON'
                }
            )
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Mock -CommandName 'New-ClarityCard' -MockWith {
            return "<Card>FakeHTMLCard"
        }
        Mock -CommandName 'Add-ClarityCardBody' -MockWith {
            return "<cardbody>FakeHTMLBody"
        }
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        Get-vCenterVMSet -Include testvm01 | Should not be $null
    }
    It "Should Return true." {
        Mock -CommandName 'Get-VM' -MockWith {
            $RawReturn = @(
                @{
                    name       = 'testvm01'
                    PowerState = 'POWEREDON'
                },
                @{
                    name       = 'testvm02'
                    PowerState = 'POWEREDON'
                }
            )
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Mock -CommandName 'New-ClarityCard' -MockWith {
            return "<Card>FakeHTMLCard"
        }
        Mock -CommandName 'Add-ClarityCardBody' -MockWith {
            return "<cardbody>FakeHTMLBody"
        }
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        Get-vCenterVMSet -Exclude testvm01 | Should not be $null
    }
    It "Should Return true." {
        Mock -CommandName 'Get-VM' -MockWith {
            $RawReturn = @(
                @{
                    name       = 'testvm01'
                    PowerState = 'POWEREDON'
                },
                @{
                    name       = 'testvm02'
                    PowerState = 'POWEREDON'
                }
            )
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Mock -CommandName 'New-ClarityCard' -MockWith {
            return "<Card>FakeHTMLCard"
        }
        Mock -CommandName 'Add-ClarityCardBody' -MockWith {
            return "<cardbody>FakeHTMLBody"
        }
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        Get-vCenterVMSet | Should not be $null
    }
    It "Should Return true." {
        Mock -CommandName 'Get-VM' -MockWith {
            $RawReturn = @(
                @{
                    name       = 'testvm01'
                    PowerState = 'POWEREDON'
                },
                @{
                    name       = 'testvm02'
                    PowerState = 'POWEREDON'
                }
            )
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Mock -CommandName 'New-ClarityCard' -MockWith {
            return "<Card>FakeHTMLCard"
        }
        Mock -CommandName 'Add-ClarityCardBody' -MockWith {
            return "<cardbody>FakeHTMLBody"
        }
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        { Get-vCenterVMSet } | Should not Throw
    }
    It "Should Return true." {
        Mock -CommandName 'Get-VM' -MockWith {
            Throw "Could not get VM"
        }
        Mock -CommandName 'New-ClarityCard' -MockWith {
            return "<Card>FakeHTMLCard"
        }
        Mock -CommandName 'Add-ClarityCardBody' -MockWith {
            return "<cardbody>FakeHTMLBody"
        }
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        { Get-vCenterVMSet } | Should Throw
    }
}
