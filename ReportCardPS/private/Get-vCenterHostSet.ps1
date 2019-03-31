function Get-vCenterHostSet
{
    <#
    .DESCRIPTION
        Builds HTML Reports using VMware's ClarityUI library.
    .PARAMETER tbd01
        working on the details
    .PARAMETER tbd02
        working on the details
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
    param(
        [Parameter()][String]$tbd01,
        [Parameter()][String]$tbd02
    )
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterHostSet function."))
    {
        try
        {
            #Add Function details
            # Hosts Section
            # Get a list of all the VMhosts
            $VMHosts = Get-VMHost
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
            $vmHostCard = New-ClarityCard -Title VMHosts -Icon VMHosts -IconSize 
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
