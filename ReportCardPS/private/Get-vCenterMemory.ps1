function Get-vCenterMemory
{
    <#
    .DESCRIPTION
        Builds HTML Reports using VMware's ClarityUI library.
    .PARAMETER tbd01
        working on the details
    .PARAMETER tbd02
        working on the details
    .EXAMPLE
        Get-vCenterMemory
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
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterMemory function."))
    {
        try
        {
           # Setup some empty Variables to store things
           $vCenterMemoryTotalGB = $null
           $vCenterMemoryUsageGB = $null
           $vCenterCpuTotalMhz = $null
           $vCenterCpuUsageMhz = $null
           # Loop Through the hosts to get the Memory and CPU stats
           Write-Output "Looping through the VMHosts to gather Memory and CPU data."
           foreach($VMHost in $VMHosts){
               $VMHostName = $VMHost.Name
               Write-Output "Collecting Stats for $VMHostName"
               $thisVMhostMemoryTotalGB = $VMHost.MemoryTotalGB
               $thisVMhostMemoryUsageGB = $VMHost.MemoryUsageGB
               $thisVMhostCpuTotalMhz = $VMHost.CpuTotalMhz
               $thisVMhostCpuUsageMhz = $VMHost.CpuUsageMhz
               # Add the Items to the total
               $vCenterMemoryTotalGB += $thisVMhostMemoryTotalGB
               $vCenterMemoryUsageGB += $thisVMhostMemoryUsageGB
               $vCenterCpuTotalMhz   += $thisVMhostCpuTotalMhz
               $vCenterCpuUsageMhz   += $thisVMhostCpuUsageMhz
           }
           #Mem
           $vCenterMemoryTotalGB = [math]::Round($vCenterMemoryTotalGB,2)
           $vCenterMemoryUsageGB = [math]::Round($vCenterMemoryUsageGB,2)
           $vCenterMemoryUsagePercent = ([math]::Round(($vCenterMemoryUsageGB/$vCenterMemoryTotalGB),2)) * 100
           $vCenterMemoryUsageFree = $vCenterMemoryTotalGB - $vCenterMemoryUsageGB

           #CPU
           $vCenterCpuUsagePercent = ([math]::Round(($vCenterCpuUsageMhz/$vCenterCpuTotalMhz),2)) * 100
           $vCenterCPUFreeMhz = ([math]::Round(($vCenterCpuTotalMhz - $vCenterCpuUsageMhz),2))
           $vCenterCPUFreeGhz = $vCenterCPUFreeMhz/1000
           $vCenterCpuTotalGhz = $vCenterCpuTotalMhz/1000
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "Get-vCenterMemory: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}
