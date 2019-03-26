function Get-vCenterHosts
{
    <#
    .DESCRIPTION
        Builds HTML Reports using VMware's ClarityUI library.
    .PARAMETER tbd01
        working on the details
    .PARAMETER tbd02
        working on the details
    .EXAMPLE
        Get-vCenterHosts
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
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterHosts function."))
    {
        try
        {
            #Add Function details
            # Hosts Section
            # Get a list of all the VMhosts
            $VMHosts = Get-VMHost
            $ConnectedVMHosts = ($VMHosts | Where-Object {$_.ConnectionState -eq "Connected"} | Measure-Object).count
            $DisConnectedVMHosts = ($VMHosts | Where-Object {$_.ConnectionState -eq "DisConnected"} | Measure-Object).count
            $MaintenanceVMHosts = ($VMHosts | Where-Object {$_.ConnectionState -eq "Maintenance"} | Measure-Object).count
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "Get-vCenterHosts: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}
