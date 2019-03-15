function Invoke-vCenterHomeReport {
    <#
    .DESCRIPTION
        Generates an HTML report that Looks like a vCenter home page.
    .PARAMETER TemplateHtmlFilePath
        A Template path is optional. Default: $env:SystemDrive\temp\ReportCardsPS\vCenter_Template.html
    .PARAMETER OutputHtmlFilePath
        A Destitnation path is optional. Default: $env:SystemDrive\temp\ReportCardsPS\vCenterReport.html
    .EXAMPLE
        Invoke-vCenterHomeReport
    .EXAMPLE
        Invoke-vCenterHomeReport -TemplateHtmlFilePath c:\temp\temp\ReportCardsPS\vCenter_Template.html -OutputHtmlFilePath c:\temp\ReportCardsPS\vCenterReport.html
    .EXAMPLE
        Invoke-vCenterHomeReport -TemplateHtmlFilePath /tmp/ReportCardsPS/vCenter_Template.html -OutputHtmlFilePath /tmp/ReportCardsPS/vCenterReport.html
    .NOTES
        Not yet tested on Linux.
    #>
    
    [CmdletBinding()]
    [OutputType([boolean])]
    param(
        [String]$TemplateHtmlFilePath="$env:SystemDrive\temp\ReportCardsPS\vCenter_Template.html",
        [String]$OutputHtmlFilePath="$env:SystemDrive\temp\ReportCardsPS\vCenterReport.html"
    )
    if(Test-Path -Path "$TemplateHtmlFilePath") {
        if(($global:DefaultVIServer).IsConnected){
            # Grab the vCenter Name
            $vCenterName = ($Global:defaultVIServer).Name
            Write-Output "Creating HTML file for vCenter $vCenterName Homepage"
            # Get a list of all the VMhosts
            $VMHosts = Get-VMHost

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
            # Get the List of DataStores
            Write-Output "Gathering Storage Data."
            $DataStores = Get-Datastore

            # Start some Empty Variables to store things
            $vCenterFreeSpaceGB = $null
            $vCenterCapacityGB = $null

            # Loop Through each to determine the Used space.
            foreach($DataStore in $DataStores){
                $thisDSCapacityGB = $Datastore.CapacityGB
                $thisDSFreeSpaceGB = $DataStore.FreeSpaceGB

                $vCenterFreeSpaceGB += $thisDSFreeSpaceGB
                $vCenterCapacityGB  += $thisDSCapacityGB
            }
            $vCenterFreeSpaceGB = ([math]::Round($vCenterFreeSpaceGB,2))
            $vCenterCapacityGB = ([math]::Round($vCenterCapacityGB,2))
            $vCenterUsedSpaceGB = ([math]::Round(($vCenterCapacityGB - $vCenterFreeSpaceGB),2))
            $vCenterUsedSpaceGBPercent = ([math]::Round(($vCenterUsedSpaceGB/$vCenterCapacityGB),2)) * 100

            # VMs Section
            $vmList = Get-VM | Select-Object PowerState
            $PoweredOnVMsCount = ($vmList | Where-Object {$_.PowerState -eq "PoweredOn"} | Measure-Object).count
            $PoweredOffVMsCount = ($vmList | Where-Object {$_.PowerState -eq "PoweredOff"} | Measure-Object).count
            $SuspendedVMsCount = ($vmList | Where-Object {$_.PowerState -eq "Suspended"} | Measure-Object).count

            # Hosts Section
            # Re-use $VMHosts from above
            $ConnectedVMHosts = ($VMHosts | Where-Object {$_.ConnectionState -eq "Connected"} | Measure-Object).count
            $DisConnectedVMHosts = ($VMHosts | Where-Object {$_.ConnectionState -eq "DisConnected"} | Measure-Object).count
            $MaintenanceVMHosts = ($VMHosts | Where-Object {$_.ConnectionState -eq "Maintenance"} | Measure-Object).count

            # Get Alarm Information
            $ServiceInstance = Get-View ServiceInstance
            $AlarmManager = Get-View -Id $ServiceInstance.Content.AlarmManager
            $vCenterInventory = Get-Inventory

            # Loop through each inventory Item to determine the number of active alarms
            $vCenterAlarmCollection = New-Object System.Collections.ArrayList
            foreach($Item in $vCenterInventory) {
                $thisItem = New-Object System.Object
                $objectName = $Item.Name
                $thisItemAlarmsCount = 0
                $thisItemWarningsCount = 0
                $thisItemAlarmsCount = ($AlarmManager.GetAlarmState($Item.ExtensionData.MoRef) | Where-Object {[VMware.Vim.ManagedEntityStatus]::yellow -contains $_.OverallStatus} | Measure-Object).count

                $thisItemWarningsCount = ($AlarmManager.GetAlarmState($Item.ExtensionData.MoRef) | Where-Object {[VMware.Vim.ManagedEntityStatus]::red -contains $_.OverallStatus} | Measure-Object).count

                if (($thisItemAlarmsCount -ne 0) -or ($thisItemWarningsCount -ne 0)) {
                    # Add the item to the collection
                    $thisItem | Add-Member -MemberType NoteProperty -Name "ObjectName" -Value "$objectName"
                    $thisItem | Add-Member -MemberType NoteProperty -Name "thisItemAlarmsCount" -Value "$thisItemAlarmsCount"
                    $thisItem | Add-Member -MemberType NoteProperty -Name "thisItemWarningsCount" -Value "$thisItemWarningsCount"
                    $vCenterAlarmCollection.Add($thisItem) | Out-Null
                }
            }
            $vCenterTop5Alarms = $vCenterAlarmCollection | Sort-Object -Property thisItemWarningsCount -Descending | Select-Object -First 5

            # Get the list of vCenter plugins
            $ExtensionManager = Get-View ExtensionManager

            $InstalledPlugins = $ExtensionManager.ExtensionList | Select-Object @{N='Name';E={$_.Description.Label}},Version,Company 

            # Pull in the Contents of the Template file
            Write-Output "Replacing the Template file data."
            $Template_Content = Get-Content -Path "$TemplateHtmlFilePath" -Raw

            # Replace all the Text
            $UpdatedContent = $Template_Content -replace ('REPLACE_vCenterName',"$vCenterName")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_CPU_FREE',"$vCenterCPUFreeGhz")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_CPU_USED',"$vCenterCpuUsageMhz")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_CPU_PERCENT',"$vCenterCpuUsagePercent")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_CPU_TOTAL',"$vCenterCpuTotalGhz")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_MEMORY_FREE',"$vCenterMemoryUsageFree")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_MEMORY_USED',"$vCenterMemoryUsagePercent")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_MEMORY_PERCENT',"$vCenterMemoryUsageGB")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_MEMORY_TOTAL',"$vCenterMemoryTotalGB")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_STORAGE_FREE',"$vCenterFreeSpaceGB")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_STORAGE_USED',"$vCenterUsedSpaceGB")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_STORAGE_PERCENT',"$vCenterUsedSpaceGBPercent")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_STORAGE_TOTAL',"$vCenterCapacityGB")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_VMs_POWEREDON',"$PoweredOnVMsCount")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_VMs_POWEREDOFF',"$PoweredOffVMsCount")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_VMs_SUSPENEDED',"$SuspendedVMsCount")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_HOSTS_CONNECTED',"$ConnectedVMHosts")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_HOSTS_DISCONNECTED',"$DisConnectedVMHosts")
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_HOSTS_MAINTENANCE',"$MaintenanceVMHosts")

            # Loop Through the Alerts
            $vCenterTop5AlarmsHTML = ""
            foreach($alarm in $vCenterTop5Alarms){
                $Item = $alarm.ObjectName
                $alertCount = $alarm.thisItemAlarmsCount
                $warnCount = $alarm.thisItemWarningsCount
                $vCenterTop5AlarmsHTML += "<tr><td align='left'>$Item</td><td align='center'>$alertCount</td><td align='center'>$warnCount</td></tr>"
            }
            $UpdatedContent = $UpdatedContent -replace ('REPLACE_ALERTS',"$vCenterTop5AlarmsHTML")

            # Loop Through the Plugins
            $InstalledPluginsHTML = ""
            foreach($Plugin in $InstalledPlugins){
                $PluginName = $Plugin.Name
                $InstalledPluginsHTML += "<tr><th align='left'>$PluginName</th></tr>"
            }

            $UpdatedContent = $UpdatedContent -replace ('REPLACE_PLUGINS',"$InstalledPluginsHTML")

            # Write the file out
            Write-Output "Writing the data to file: $OutputHtmlFilePath"
            $UpdatedContent | Out-File -FilePath "$OutputHtmlFilePath" -Encoding ascii
        } else {
            Write-Output "You are not currently connected to a vCenter."
        }
    } else{
        write-Output "The Template file specified did not exist."
    }
}