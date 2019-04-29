function Get-vCenterHostSet
{
    <#
    .DESCRIPTION
        Gathers VMHost State information.
    .PARAMETER Include
        Provide a String to use when including specific VMHosts based on Name
    .PARAMETER Exclude
        Provide a String to use when excluding specific VMHosts based on Name
    .EXAMPLE
        Get-vCenterHostSet
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
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterHostSet function."))
    {
        try
        {
            #Add Function details
            # Get the VMHosts
            if ($Include)
            {
                $VMHosts = Get-VMHost | Where-Object { $_.Name -like "*$Include*" }
            }
            elseif ($Exclude)
            {
                $VMHosts = Get-VMHost | Where-Object { $_.Name -notlike "*$Exclude*" }
            }
            else
            {
                $VMHosts = Get-VMHost
            }
            $ConnectedVMHosts = ($VMHosts | Where-Object { $_.ConnectionState -eq "Connected" } | Measure-Object).count
            $DisConnectedVMHosts = ($VMHosts | Where-Object { $_.ConnectionState -eq "DisConnected" } | Measure-Object).count
            $MaintenanceVMHosts = ($VMHosts | Where-Object { $_.ConnectionState -eq "Maintenance" } | Measure-Object).count

            # Make a Custom object with the information
            $vmHostObject = New-Object System.Object
            $vmHostObject | Add-Member -MemberType NoteProperty -Name "Connected" -Value "$ConnectedVMHosts"
            $vmHostObject | Add-Member -MemberType NoteProperty -Name "Disconnected" -Value "$DisConnectedVMHosts"
            $vmHostObject | Add-Member -MemberType NoteProperty -Name "Maintenance" -Value "$MaintenanceVMHosts"
            $vmHostObject | ConvertTo-Html -Fragment

            # Build the HTML Card
            $vmHostCard = New-ClarityCard -Title VMHosts -Icon VMHosts -IconSize 24
            $vmHostCardBody = New-ClarityCardBody -CardText "$vmHostObject"
            $vmHostCardBody += Close-ClarityCardBody
            $vmHostCard += $vmHostCardBody
            $vmHostCard += Close-ClarityCard
            $vmHostCard
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "Get-vCenterHostSet: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}
