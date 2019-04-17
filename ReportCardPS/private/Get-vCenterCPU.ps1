function Get-vCenterCPU
{
    <#
    .DESCRIPTION
        Gathers vCenter overall CPU information.
    .PARAMETER Include
        Provide a String to use when including specific VMHosts based on Name
    .PARAMETER Exclude
        Provide a String to use when excluding specific VMHosts based on Name
    .EXAMPLE
        Get-vCenterCPU
    .NOTES
        No notes at this time.
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Low"
    )]
    [OutputType([String])]
    param(
        [Parameter()][String]$Include,
        [Parameter()][String]$Exclude
    )
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterCPU function."))
    {
        try
        {
            # Get the VMHosts
            if ($null -ne $Include)
            {
                $VMHosts = Get-VMHost | Where-Object { $_.Name -like "*$Include*" }
            }
            elseif ($null -ne $Exclude)
            {
                $VMHosts = Get-VMHost | Where-Object { $_.Name -notlike "*$Exclude*" }
            }
            else
            {
                $VMHosts = Get-VMHost
            }
            
            # Setup some empty Variables to store things
            $vCenterCpuTotalMhz = $null
            $vCenterCpuUsageMhz = $null
            # Loop Through the hosts to get the and CPU stats
            Write-Output "Looping through the VMHosts to gather and CPU data."
            foreach ($VMHost in $VMHosts)
            {
                $VMHostName = $VMHost.Name
                Write-Output "Collecting Stats for $VMHostName"
                $thisVMhostCpuTotalMhz = $VMHost.CpuTotalMhz
                $thisVMhostCpuUsageMhz = $VMHost.CpuUsageMhz
                # Add the Items to the total
                $vCenterCpuTotalMhz += $thisVMhostCpuTotalMhz
                $vCenterCpuUsageMhz += $thisVMhostCpuUsageMhz
            }

            #CPU
            $vCenterCpuUsagePercent = ([math]::Round(($vCenterCpuUsageMhz / $vCenterCpuTotalMhz), 2)) * 100
            $vCenterCPUFreeMhz = ([math]::Round(($vCenterCpuTotalMhz - $vCenterCpuUsageMhz), 2))
            $vCenterCPUFreeGhz = $vCenterCPUFreeMhz / 1000
            $vCenterCpuTotalGhz = $vCenterCpuTotalMhz / 1000

            # Build the HTML Card
            $CPUCard = New-ClarityCard -Title CPU -Icon CPU -IconSize 24

            $CPUCardBody = New-ClarityCardBody -CardText "$vCenterCPUFreeGhz GHz free"
            $CPUCardBody += New-ClarityProgressBlock -value $vCenterCPUUsagePercent -max 100 -DisplayValue $vCenterCPUUsagePercent
            $CPUCardBody += New-ClarityCardBodyFooter -FooterText "$vCenterCpuTotalMhz MHz used | $vCenterCpuTotalGhz GHz total"
            $CPUCardBody += Close-ClarityCardBody
            $CPUCard += $CPUCardBody
            $CPUCard += Close-ClarityCard
            $CPUCard
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "Get-vCenterCPU: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}
