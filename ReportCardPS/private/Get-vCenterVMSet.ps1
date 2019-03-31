function Get-vCenterVMSet
{
    <#
    .DESCRIPTION
        Builds HTML Reports using VMware's ClarityUI library.
    .PARAMETER tbd01
        working on the details
    .PARAMETER tbd02
        working on the details
    .EXAMPLE
        Get-vCenterVMSet
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
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterVMSet function."))
    {
        try
        {
            #Add Function details
            # VMs Section
            $vmList = Get-VM | Select-Object PowerState
            $PoweredOnVMsCount = ($vmList | Where-Object { $_.PowerState -eq "PoweredOn" } | Measure-Object).count
            $PoweredOffVMsCount = ($vmList | Where-Object { $_.PowerState -eq "PoweredOff" } | Measure-Object).count
            $SuspendedVMsCount = ($vmList | Where-Object { $_.PowerState -eq "Suspended" } | Measure-Object).count

            # Make a Custom object with the information
            $vmObject = New-Object System.Object
            $vmObject | Add-Member -MemberType NoteProperty -Name "Powered On" -Value "$PoweredOnVMsCount"
            $vmObject | Add-Member -MemberType NoteProperty -Name "Powered Off" -Value "$PoweredOffVMsCount"
            $vmObject | Add-Member -MemberType NoteProperty -Name "Suspended" -Value "$SuspendedVMsCount"
            $vmObject | ConvertTo-Html -Fragment

            # Build the HTML Card
            $VMCard = New-ClarityCard -Title VM -Icon VM -IconSize 
            $VMCardBody = New-ClarityCardBody -CardText "$vmObject"
            $VMCardBody += Close-ClarityCardBody
            $VMCard += $VMCardBody
            $VMCard += Close-ClarityCard
            $VMCard
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "Get-vCenterVMSet: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}
