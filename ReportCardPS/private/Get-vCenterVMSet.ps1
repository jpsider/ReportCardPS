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
            $vmObject | Add-Member -MemberType NoteProperty -Name " | Powered Off | " -Value "$PoweredOffVMsCount"
            $vmObject | Add-Member -MemberType NoteProperty -Name "Suspended" -Value "$SuspendedVMsCount"
            $CardText = $vmObject | ConvertTo-Html -Fragment

            # Manipulate the HTML to get desired card layout.
            $Part1 = $CardText[0]
            $Part2 = $CardText[3] -replace ("<td>", "<th><h2>")
            $Part2 = $Part2 -replace ("</td>", "</h2></th>")
            $Part3 = $CardText[2] -replace ("th", "td")
            $Part4 = $CardText[4]

            $FinalCardTextHtml = $Part1 + $Part2 + $Part3 + $Part4

            # Build the HTML Card
            $VMCard = New-ClarityCard -Title VM -Icon vm -IconSize 24
            $VMCardBody += Add-ClarityCardBody -CardText "$FinalCardTextHtml"
            $VMCardBody += Close-ClarityCardBody
            $VMCard += $VMCardBody

            $VMCard += Close-ClarityCard -Title "Close VM card"
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