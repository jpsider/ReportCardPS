$script:ModuleName = 'ReportCardPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"


function New-ClarityCard { }
function New-ClarityCardBody { }
function Close-ClarityCardBody { }
function Close-ClarityCard { }
function Get-VMHost { }

Describe "Get-vCenterHostSet function for $script:ModuleName" -Tags Build {
    It "Should return False if -WhatIf is used." {
        Get-vCenterHostSet -WhatIf | Should be $false
    }
    It "Should Return true." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            $RawReturn = @(
                @{
                    name            = 'host01'
                    ConnectionState = 'Connected'
                },
                @{
                    name            = 'host02'
                    ConnectionState = 'DisConnected'
                },
                @{
                    name            = 'host03'
                    ConnectionState = 'Maintenance'
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
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        Get-vCenterHostSet -Include host01 | Should not be $null
    }
    It "Should Return true." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            $RawReturn = @(
                @{
                    name            = 'host01'
                    ConnectionState = 'Connected'
                },
                @{
                    name            = 'host02'
                    ConnectionState = 'DisConnected'
                },
                @{
                    name            = 'host03'
                    ConnectionState = 'Maintenance'
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
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        Get-vCenterHostSet -Exclude host01 | Should not be $null
    }
    It "Should Return true." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            $RawReturn = @(
                @{
                    name            = 'host01'
                    ConnectionState = 'Connected'
                },
                @{
                    name            = 'host02'
                    ConnectionState = 'DisConnected'
                },
                @{
                    name            = 'host03'
                    ConnectionState = 'Maintenance'
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
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        Get-vCenterHostSet | Should not be $null
    }
    It "Should Return true." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            $RawReturn = @(
                @{
                    name            = 'host01'
                    ConnectionState = 'Connected'
                },
                @{
                    name            = 'host02'
                    ConnectionState = 'DisConnected'
                },
                @{
                    name            = 'host03'
                    ConnectionState = 'Maintenance'
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
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        { Get-vCenterHostSet } | Should not Throw
    }
    It "Should Return true." {
        Mock -CommandName 'Get-VMHost' -MockWith {
            Throw "Could not get VM"
        }
        Mock -CommandName 'New-ClarityCard' -MockWith {
            return "<Card>FakeHTMLCard"
        }
        Mock -CommandName 'New-ClarityCardBody' -MockWith {
            return "<cardbody>FakeHTMLBody"
        }
        Mock -CommandName 'Close-ClarityCardBody' -MockWith {
            return "</cardbody>"
        }
        Mock -CommandName 'Close-ClarityCard' -MockWith {
            return "</card>"
        }
        { Get-vCenterHostSet } | Should Throw
    }
}

