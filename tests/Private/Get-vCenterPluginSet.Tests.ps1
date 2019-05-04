$script:ModuleName = 'ReportCardPS'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

function New-ClarityCard { }
function Add-ClarityCardBody { }
function Close-ClarityCardBody { }
function Close-ClarityCard { }
function Get-View { }

Describe "Get-vCenterPluginSet function for $script:ModuleName" -Tags Build {
    It "Should return False if -WhatIf is used." {
        Get-vCenterPluginSet -WhatIf | Should be $false
    }
    It "Should not be null." {
        Mock -CommandName 'Get-View' -MockWith {
            $RawReturn = "{
                'ExtensionList' : [
                    {
                        Description  : {
                            label : 'MyPlugin'
                        },
                        Version : '2.0.2',
                        Company : 'Invoke-Automation'
                    },
                    {
                        Description : {
                            label : 'YourPlugin'
                        },
                        Version : '2.0.3',
                        Company :'Invoke-Automation'
                    }
                ]
            }"
            $ReturnData = $RawReturn | ConvertFrom-Json
            $ReturnData
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
        Get-vCenterPluginSet | Should not be $null
    }
    It "Should not be null." {
        Mock -CommandName 'Get-View' -MockWith {
            $RawReturn = "{
                'ExtensionList' : [
                    {
                        Description  : {
                            label : 'MyPlugin'
                        },
                        Version : '2.0.2',
                        Company : 'Invoke-Automation'
                    },
                    {
                        Description : {
                            label : 'YourPlugin'
                        },
                        Version : '2.0.3',
                        Company :'Invoke-Automation'
                    }
                ]
            }"
            $ReturnData = $RawReturn | ConvertFrom-Json
            $ReturnData
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
        Get-vCenterPluginSet -Filter "My" | Should not be $null
    }
    It "Should Throw if Get-View fails." {
        Mock -CommandName 'Get-View' -MockWith {
            Throw "Get-View failed"
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
        { Get-vCenterPluginSet -Filter "My" } | Should Throw
    }
}
