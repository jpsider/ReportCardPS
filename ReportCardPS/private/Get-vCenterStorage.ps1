function Get-vCenterStorage
{
    <#
    .DESCRIPTION
        Builds HTML Reports using VMware's ClarityUI library.
    .PARAMETER Include
        Provide a String to use when including specific DataStores based on Name
    .PARAMETER Exclude
        Provide a String to use when excluding specific DataStores based on Name
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
    [OutputType([boolean])]
    param(
        [Parameter()][String]$Include,
        [Parameter()][String]$Exclude
    )
    if ($pscmdlet.ShouldProcess("Starting Get-vCenterStorage function."))
    {
        try
        {
            # Get the DataStores
            Write-Output "Gathering Storage Data."
            if ($Include)
            {
                $DataStores = Get-DataStore | Where-Object { $_.Name -like "*$Include*" }
            }
            elseif ($Exclude)
            {
                $DataStores = Get-Datastore | Where-Object { $_.Name -notlike "*$Exclude*" }
            }
            else
            {
                $DataStores = Get-Datastore
            }

            # Start some Empty Variables to store things
            $vCenterFreeSpaceGB = $null
            $vCenterCapacityGB = $null

            # Loop Through each to determine the Used space.
            foreach ($DataStore in $DataStores)
            {
                $thisDSCapacityGB = $Datastore.CapacityGB
                $thisDSFreeSpaceGB = $DataStore.FreeSpaceGB

                $vCenterFreeSpaceGB += $thisDSFreeSpaceGB
                $vCenterCapacityGB += $thisDSCapacityGB
            }
            $vCenterFreeSpaceGB = ([math]::Round($vCenterFreeSpaceGB, 2))
            $vCenterCapacityGB = ([math]::Round($vCenterCapacityGB, 2))
            $vCenterUsedSpaceGB = ([math]::Round(($vCenterCapacityGB - $vCenterFreeSpaceGB), 2))
            $vCenterUsedSpaceGBPercent = ([math]::Round(($vCenterUsedSpaceGB / $vCenterCapacityGB), 2)) * 100

            # Build the HTML Card
            $StorageCard = New-ClarityCard -Title Storage -Icon Storage -IconSize 24

            $StorageCardBody = Add-ClarityCardBody -CardText "$vCenterFreeSpaceGB GB free"
            $StorageCardBody += Add-ClarityProgressBlock -value $vCenterUsedSpaceGBPercent -max 100 -DisplayValue $vCenterUsedSpaceGBPercent
            $StorageCardBody += Add-CardText -CardText "$vCenterUsedSpaceGB GB used | $vCenterCapacityGB GB total"
            $StorageCardBody += Close-ClarityCardBody
            $StorageCard += $StorageCardBody
            $StorageCard += Close-ClarityCard -Title Storage
            $StorageCard
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
