function Get-vCenterVMs
{
    <#
    .DESCRIPTION
        Builds HTML Reports using VMware's ClarityUI library.
    .PARAMETER tbd01
        working on the details
    .PARAMETER tbd02
        working on the details
    .EXAMPLE
        Get-vCenterVMs
    .NOTES
        No notes at this time.
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Low"
    )]
    [OutputType([String])]
    param(
        [Parameter()][String]$tbd01,
        [Parameter()][String]$tbd02
    )
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterVMs function."))
    {
        try
        {
            #Add Function details
            # VMs Section
            $vmList = Get-VM | Select-Object PowerState
            $PoweredOnVMsCount = ($vmList | Where-Object {$_.PowerState -eq "PoweredOn"} | Measure-Object).count
            $PoweredOffVMsCount = ($vmList | Where-Object {$_.PowerState -eq "PoweredOff"} | Measure-Object).count
            $SuspendedVMsCount = ($vmList | Where-Object {$_.PowerState -eq "Suspended"} | Measure-Object).count
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "Get-vCenterVMs: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}
