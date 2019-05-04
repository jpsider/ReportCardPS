function Get-vCenterMemory
{
    <#
    .DESCRIPTION
        Gathers VMHost Memory Data.
    .PARAMETER Include
        Provide a String to use when including specific VMHosts
    .PARAMETER Exclude
        Provide a String to use when excluding specific VMHosts
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
    [OutputType([boolean])]
    param(
        [Parameter()][String]$Include,
        [Parameter()][String]$Exclude
    )
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterMemory function."))
    {
        try
        {
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
            # Setup some empty Variables to store things
            $vCenterMemoryTotalGB = $null
            $vCenterMemoryUsageGB = $null
            # Loop Through the hosts to get the Memory and CPU stats
            Write-Output "Looping through the VMHosts to gather Memory and CPU data."
            foreach ($VMHost in $VMHosts)
            {
                $VMHostName = $VMHost.Name
                Write-Output "Collecting Stats for $VMHostName"
                $thisVMhostMemoryTotalGB = $VMHost.MemoryTotalGB
                $thisVMhostMemoryUsageGB = $VMHost.MemoryUsageGB
                # Add the Items to the total
                $vCenterMemoryTotalGB += $thisVMhostMemoryTotalGB
                $vCenterMemoryUsageGB += $thisVMhostMemoryUsageGB
            }
            #Mem
            $vCenterMemoryTotalGB = [math]::Round($vCenterMemoryTotalGB, 2)
            $vCenterMemoryUsageGB = [math]::Round($vCenterMemoryUsageGB, 2)
            $vCenterMemoryUsagePercent = ([math]::Round(($vCenterMemoryUsageGB / $vCenterMemoryTotalGB), 2)) * 100
            $vCenterMemoryUsageFree = $vCenterMemoryTotalGB - $vCenterMemoryUsageGB

            # Build the HTML Card
            $MemoryCard = New-ClarityCard -Title Memory -Icon Memory -IconSize 24

            $MemoryCardBody = Add-ClarityCardBody -CardText "$vCenterMemoryUsageFree GB free"
            $MemoryCardBody += Add-ClarityProgressBlock -value $vCenterMemoryUsagePercent -max 100 -DisplayValue $vCenterMemoryUsagePercent
            $MemoryCardBody += Add-CardText -CardText "$vCenterMemoryUsageGB GB used | $vCenterMemoryTotalGB GB total"
            $MemoryCardBody += Close-ClarityCardBody
            $MemoryCard += $MemoryCardBody
            $MemoryCard += Close-ClarityCard
            $MemoryCard

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
