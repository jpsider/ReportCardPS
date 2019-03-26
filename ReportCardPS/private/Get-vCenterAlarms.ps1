function Get-vCenterAlarms
{
    <#
    .DESCRIPTION
        Builds HTML Reports using VMware's ClarityUI library.
    .PARAMETER tbd01
        working on the details
    .PARAMETER tbd02
        working on the details
    .EXAMPLE
        Get-vCenterAlarms
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
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterAlarms function."))
    {
        try
        {
            #Add Function details
            # Get Alarm Information
            $ServiceInstance = Get-View ServiceInstance
            $AlarmManager = Get-View -Id $ServiceInstance.Content.AlarmManager
            $vCenterInventory = Get-Inventory

            # Loop through each inventory Item to determine the number of active alarms
            $vCenterAlarmCollection = New-Object System.Collections.ArrayList
            foreach ($Item in $vCenterInventory)
            {
                $thisItem = New-Object System.Object
                $objectName = $Item.Name
                $thisItemAlarmsCount = 0
                $thisItemWarningsCount = 0
                $thisItemAlarmsCount = ($AlarmManager.GetAlarmState($Item.ExtensionData.MoRef) | Where-Object { [VMware.Vim.ManagedEntityStatus]::yellow -contains $_.OverallStatus } | Measure-Object).count

                $thisItemWarningsCount = ($AlarmManager.GetAlarmState($Item.ExtensionData.MoRef) | Where-Object { [VMware.Vim.ManagedEntityStatus]::red -contains $_.OverallStatus } | Measure-Object).count

                if (($thisItemAlarmsCount -ne 0) -or ($thisItemWarningsCount -ne 0))
                {
                    # Add the item to the collection
                    $thisItem | Add-Member -MemberType NoteProperty -Name "ObjectName" -Value "$objectName"
                    $thisItem | Add-Member -MemberType NoteProperty -Name "thisItemAlarmsCount" -Value "$thisItemAlarmsCount"
                    $thisItem | Add-Member -MemberType NoteProperty -Name "thisItemWarningsCount" -Value "$thisItemWarningsCount"
                    $vCenterAlarmCollection.Add($thisItem) | Out-Null
                }
            }
            $vCenterTop5Alarms = $vCenterAlarmCollection | Sort-Object -Property thisItemWarningsCount -Descending | Select-Object -First 5
            $vCenterTop5Alarms
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "Get-vCenterAlarms: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}
