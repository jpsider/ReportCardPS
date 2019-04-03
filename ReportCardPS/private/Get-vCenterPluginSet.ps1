function Get-vCenterPluginSet
{
    <#
    .DESCRIPTION
        Builds HTML Card with vCenter Plugin data using VMware's ClarityUI library.
    .PARAMETER Filter
        Optional - Provide a String to use as a filter. example: vSphere
    .EXAMPLE
        Get-vCenterPluginSet
    .EXAMPLE
        Get-vCenterPluginSet -Filter vSphere
    .NOTES
        No notes at this time.
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Low"
    )]
    [OutputType([String])]
    param(
        [Parameter()][String]$Filter
    )
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterPluginSet function."))
    {
        try
        {
            # Grab the Extention Manager Object
            $ExtensionManager = Get-View ExtensionManager
            # Get the list of vCenter plugins that match the filter
            $InstalledPlugins = $ExtensionManager.ExtensionList | Select-Object @{N = 'Name'; E = { $_.Description.Label } }, Version, Company | Where-Object {$_.Name -like "*$Filter*"}
            # Convert the List to HTML table
            $InstalledPluginsList = $InstalledPlugins | ConvertTo-Html -Fragment

            # Build the HTML Card
            $PluginCard = New-ClarityCard -Title "vCenter Plugins" -Icon Plugin -IconSize 
            $PluginCardBody = New-ClarityCardBody -CardText "$InstalledPluginsList"
            $PluginCardBody += Close-ClarityCardBody
            $PluginCard += $PluginCardBody
            $PluginCard += Close-ClarityCard
            $PluginCard
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "Get-vCenterPluginSet: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}
