$script:ModuleName = 'ReportCardPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"


function New-ClarityCard { }
function New-ClarityCardBody { }
function Close-ClarityCardBody { }
function New-ClarityProgressBlock { }
function New-ClarityCardBodyFooter { }
function Close-ClarityCard { }
function Get-VMHost { }

Describe "Get-vCenterCPU function for $script:ModuleName" -Tags Build {
    It "Should return False if -WhatIf is used." {
        Get-vCenterCPU -WhatIf | Should be $false
    }
    It "Should not be null." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            $RawReturn = @(
                @{
                    name        = 'host01'
                    CpuTotalMhz = '600'
                    CpuUsageMhz = '299'
                },
                @{
                    name        = 'host02'
                    CpuTotalMhz = '400'
                    CpuUsageMhz = '320'
                }
            )
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Mock -CommandName 'New-ClarityCard' -MockWith {
            return "<Card>FakeHTMLCard"
        }
        Mock -CommandName 'New-ClarityCardBody' -MockWith {
            return "<cardbody>FakeHTMLBody"
        }
        Mock -CommandName 'New-ClarityProgressBlock' -MockWith {
            return "<div class='progress-block'><div class='progress success'><progress value='52' max='100' data-displayval='52'></progress></div></div>"
        }
        Mock -CommandName 'New-ClarityCardBodyFooter' -MockWith {
            return "footerText"
        }
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        Get-vCenterCPU | Should not be $null
    }
    It "Should not be null." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            $RawReturn = @(
                @{
                    name        = 'host01'
                    CpuTotalMhz = '600'
                    CpuUsageMhz = '299'
                },
                @{
                    name        = 'host02'
                    CpuTotalMhz = '400'
                    CpuUsageMhz = '320'
                }
            )
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Mock -CommandName 'New-ClarityCard' -MockWith {
            return "<Card>FakeHTMLCard"
        }
        Mock -CommandName 'New-ClarityCardBody' -MockWith {
            return "<cardbody>FakeHTMLBody"
        }
        Mock -CommandName 'New-ClarityProgressBlock' -MockWith {
            return "<div class='progress-block'><div class='progress success'><progress value='52' max='100' data-displayval='52'></progress></div></div>"
        }
        Mock -CommandName 'New-ClarityCardBodyFooter' -MockWith {
            return "footerText"
        }
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        Get-vCenterCPU -Include host01 | Should not be $null
    }
    It "Should not be null." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            $RawReturn = @(
                @{
                    name        = 'host01'
                    CpuTotalMhz = '600'
                    CpuUsageMhz = '299'
                },
                @{
                    name        = 'host02'
                    CpuTotalMhz = '400'
                    CpuUsageMhz = '320'
                }
            )
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Mock -CommandName 'New-ClarityCard' -MockWith {
            return "<Card>FakeHTMLCard"
        }
        Mock -CommandName 'New-ClarityCardBody' -MockWith {
            return "<cardbody>FakeHTMLBody"
        }
        Mock -CommandName 'New-ClarityProgressBlock' -MockWith {
            return "<div class='progress-block'><div class='progress success'><progress value='52' max='100' data-displayval='52'></progress></div></div>"
        }
        Mock -CommandName 'New-ClarityCardBodyFooter' -MockWith {
            return "footerText"
        }
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        Get-vCenterCPU -Exclude host01 | Should not be $null
    }
    It "Should throw" {
        Mock -CommandName 'Get-VMHost' -MockWith {
            Throw "Could not get VMHost Info."
        }
        Mock -CommandName 'New-ClarityCard' -MockWith {
            return "<Card>FakeHTMLCard"
        }
        Mock -CommandName 'New-ClarityCardBody' -MockWith {
            return "<cardbody>FakeHTMLBody"
        }
        Mock -CommandName 'New-ClarityProgressBlock' -MockWith {
            return "<div class='progress-block'><div class='progress success'><progress value='52' max='100' data-displayval='52'></progress></div></div>"
        }
        Mock -CommandName 'New-ClarityCardBodyFooter' -MockWith {
            return "footerText"
        }
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        { Get-vCenterCPU } | Should Throw
    }
    It "Should not Throw." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            $RawReturn = @(
                @{
                    name        = 'host01'
                    CpuTotalMhz = '600'
                    CpuUsageMhz = '299'
                },
                @{
                    name        = 'host02'
                    CpuTotalMhz = '400'
                    CpuUsageMhz = '320'
                }
            )
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Mock -CommandName 'New-ClarityCard' -MockWith {
            return "<Card>FakeHTMLCard"
        }
        Mock -CommandName 'New-ClarityCardBody' -MockWith {
            return "<cardbody>FakeHTMLBody"
        }
        Mock -CommandName 'New-ClarityProgressBlock' -MockWith {
            return "<div class='progress-block'><div class='progress success'><progress value='52' max='100' data-displayval='52'></progress></div></div>"
        }
        Mock -CommandName 'New-ClarityCardBodyFooter' -MockWith {
            return "footerText"
        }
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        { Get-vCenterCPU } | Should not throw
    }
}
