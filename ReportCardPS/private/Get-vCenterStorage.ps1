function Get-vCenterStorage
{
    <#
    .DESCRIPTION
        Builds HTML Reports using VMware's ClarityUI library.
    .PARAMETER tbd01
        working on the details
    .PARAMETER tbd02
        working on the details
    .EXAMPLE
        Get-vCenterStorage
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
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterStorage function."))
    {
        try
        {
            #Add Function details
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
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "Get-vCenterStorage: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}
