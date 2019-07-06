$script:ModuleName = 'ReportCardPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"


function New-ClarityCard { }
function Add-ClarityCardBody { }
function Close-ClarityCardBody { }
function Close-ClarityCard { }
function Get-Process { }

Describe "Get-LocalHandleCount function for $script:ModuleName" -Tags Build {
    It "Should return False if -WhatIf is used." {
        Get-LocalHandleCount -WhatIf | Should be $false
    }
    It "Should Return true." {
        Mock -CommandName 'Get-Process' -MockWith {
            $RawReturn = @(
                @{
                    ProcessName = 'System'
                    CPU         = '2152'
                    Id          = '4'
                },
                @{
                    ProcessName = 'WmiPrvSE'
                    CPU         = '1101'
                    Id          = '4408'
                },
                @{
                    ProcessName = 'svchost'
                    CPU         = '1032'
                    Id          = '2024'
                },
                @{
                    ProcessName = 'MsMpEng'
                    CPU         = '654'
                    Id          = '3872'
                },
                @{
                    ProcessName = 'vmware-authd'
                    CPU         = '323'
                    Id          = '6324'
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
        Get-LocalHandleCount -Count 5 | Should not be $null
    }
    It "Should Return true." {
        Mock -CommandName 'Get-Process' -MockWith {
            $RawReturn = @(
                @{
                    ProcessName = 'System'
                    CPU         = '2152'
                    Id          = '4'
                },
                @{
                    ProcessName = 'WmiPrvSE'
                    CPU         = '1101'
                    Id          = '4408'
                },
                @{
                    ProcessName = 'svchost'
                    CPU         = '1032'
                    Id          = '2024'
                },
                @{
                    ProcessName = 'MsMpEng'
                    CPU         = '654'
                    Id          = '3872'
                },
                @{
                    ProcessName = 'vmware-authd'
                    CPU         = '323'
                    Id          = '6324'
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
        Get-LocalHandleCount -Count 5 | Should not be $null
    }
    It "Should Return true." {
        Mock -CommandName 'Get-Process' -MockWith {
            $RawReturn = @(
                @{
                    ProcessName = 'System'
                    CPU         = '2152'
                    Id          = '4'
                },
                @{
                    ProcessName = 'WmiPrvSE'
                    CPU         = '1101'
                    Id          = '4408'
                },
                @{
                    ProcessName = 'svchost'
                    CPU         = '1032'
                    Id          = '2024'
                },
                @{
                    ProcessName = 'MsMpEng'
                    CPU         = '654'
                    Id          = '3872'
                },
                @{
                    ProcessName = 'vmware-authd'
                    CPU         = '323'
                    Id          = '6324'
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
        Get-LocalHandleCount | Should not be $null
    }
    It "Should Return true." {
        Mock -CommandName 'Get-Process' -MockWith {
            $RawReturn = @(
                @{
                    ProcessName = 'System'
                    CPU         = '2152'
                    Id          = '4'
                },
                @{
                    ProcessName = 'WmiPrvSE'
                    CPU         = '1101'
                    Id          = '4408'
                },
                @{
                    ProcessName = 'svchost'
                    CPU         = '1032'
                    Id          = '2024'
                },
                @{
                    ProcessName = 'MsMpEng'
                    CPU         = '654'
                    Id          = '3872'
                },
                @{
                    ProcessName = 'vmware-authd'
                    CPU         = '323'
                    Id          = '6324'
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
        { Get-LocalHandleCount } | Should not Throw
    }
    It "Should Return true." {
        Mock -CommandName 'Get-Process' -MockWith {
            Throw "Could not get processes"
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
        { Get-LocalHandleCount } | Should Throw
    }
}
