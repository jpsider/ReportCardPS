function Get-vCenterPluginSet
{
    <#
    .DESCRIPTION
        Builds HTML Reports using VMware's ClarityUI library.
    .PARAMETER tbd01
        working on the details
    .PARAMETER tbd02
        working on the details
    .EXAMPLE
        Get-vCenterPluginSet
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
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterPluginSet function."))
    {
        try
        {
            #Add Function details
            # Get the list of vCenter plugins
            $ExtensionManager = Get-View ExtensionManager

            $InstalledPlugins = $ExtensionManager.ExtensionList | Select-Object @{N = 'Name'; E = { $_.Description.Label } }, Version, Company | ConvertTo-Html -Fragment

            # Build the HTML Card
            $PluginCard = New-ClarityCard -Title Plugin -Icon Plugin -IconSize 
            $PluginCardBody = New-ClarityCardBody -CardText "$InstalledPlugins"
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
