function Get-vCenterVMSet
{
    <#
    .DESCRIPTION
        Gathers VM data for PowerState report.
    .PARAMETER Include
        Provide a String to use when including specific VMs based on Name
    .PARAMETER Exclude
        Provide a String to use when excluding specific VMs based on Name
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
    [OutputType([boolean])]
    param(
        [Parameter()][String]$Include,
        [Parameter()][String]$Exclude
    )
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterVMSet function."))
    {
        try
        {
            if ($Include)
            {
                $vmList = Get-VM | Where-Object { $_.Name -like "*$Include*" } | Select-Object PowerState
            }
            elseif ($Exclude)
            {
                $vmList = Get-VM | Where-Object { $_.Name -notlike "*$Exclude*" } | Select-Object PowerState
            }
            else
            {
                $vmList = Get-VM | Select-Object PowerState
            }

            $PoweredOnVMsCount = ($vmList | Where-Object { $_.PowerState -eq "PoweredOn" } | Measure-Object).count
            $PoweredOffVMsCount = ($vmList | Where-Object { $_.PowerState -eq "PoweredOff" } | Measure-Object).count
            $SuspendedVMsCount = ($vmList | Where-Object { $_.PowerState -eq "Suspended" } | Measure-Object).count

            # Make a Custom object with the information
            $vmObject = New-Object System.Object
            $vmObject | Add-Member -MemberType NoteProperty -Name "Powered On" -Value "$PoweredOnVMsCount"
            $vmObject | Add-Member -MemberType NoteProperty -Name "Powered Off" -Value "$PoweredOffVMsCount"
            $vmObject | Add-Member -MemberType NoteProperty -Name "Suspended" -Value "$SuspendedVMsCount"
            $CardText = $vmObject | ConvertTo-Html -Fragment

            # Build the HTML Card
            $VMCard = New-ClarityCard -Title VM -Icon VM -IconSize 24
            $VMCardBody = New-ClarityCardBody -CardText "$CardText"
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
