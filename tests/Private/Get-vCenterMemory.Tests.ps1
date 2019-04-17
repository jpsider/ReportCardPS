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

Describe "Get-vCenterMemory function for $script:ModuleName" -Tags Build {
    It "Should return False if -WhatIf is used." {
        Get-vCenterMemory -WhatIf | Should be $false
    }
    It "Should not be null." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            $RawReturn = @(
                @{
                    name          = 'Host01'
                    MemoryTotalGB = '600'
                    MemoryUsageGB = '299'
                },
                @{
                    name          = 'Host02'
                    MemoryTotalGB = '400'
                    MemoryUsageGB = '320'
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
        Get-vCenterMemory | Should not be $null
    }
    It "Should not be null." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            $RawReturn = @(
                @{
                    name          = 'Host01'
                    MemoryTotalGB = '600'
                    MemoryUsageGB = '299'
                },
                @{
                    name          = 'Host02'
                    MemoryTotalGB = '400'
                    MemoryUsageGB = '320'
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
        Get-vCenterMemory -Include Host01 | Should not be $null
    }
    It "Should not be null." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            $RawReturn = @(
                @{
                    name          = 'Host01'
                    MemoryTotalGB = '600'
                    MemoryUsageGB = '299'
                },
                @{
                    name          = 'Host02'
                    MemoryTotalGB = '400'
                    MemoryUsageGB = '320'
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
        Get-vCenterMemory -Exclude Host01 | Should not be $null
    }
    It "Should throw" {
        Mock -CommandName 'Get-VMHost' -MockWith {
            Throw "Could not get VMhost Info."
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
        { Get-vCenterMemory } | Should Throw
    }
    It "Should not Throw." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            $RawReturn = @(
                @{
                    name          = 'Host01'
                    MemoryTotalGB = '600'
                    MemoryUsageGB = '299'
                },
                @{
                    name          = 'Host02'
                    MemoryTotalGB = '400'
                    MemoryUsageGB = '320'
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
        { Get-vCenterMemory } | Should not throw
    }
}
