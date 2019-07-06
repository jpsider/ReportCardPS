function Get-LocalHandleCount
{
    <#
    .DESCRIPTION
        Returns CPU usage by processes.
    .PARAMETER Count
        Number of items to return, Default is 5.
    .EXAMPLE
        Get-LocalHandleCount -Count 5
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
        [Parameter()][int]$Count = 5
    )
    if ($pscmdlet.ShouldProcess("Starting Get-LocalHandleCount function."))
    {
        try
        {
            # Get Alarm Information
            $ProcessHandleData = Get-Process | Sort-Object -Property Handles -Descending | Select-Object ProcessName, Handles, Id | Select-Object -First $Count
            $ProcessHandleDataHTML = $ProcessHandleData | ConvertTo-Html -Fragment

            # Build the HTML Card
            $HandlesCard = New-ClarityCard -Title "Top $Count Handles" -Icon cpu -IconSize 24
            $HandlesCardBody = Add-ClarityCardBody -CardText "$ProcessHandleDataHTML"
            $HandlesCardBody += Close-ClarityCardBody
            $HandlesCard += $HandlesCardBody
            $HandlesCard += Close-ClarityCard -Title "Close Handles Card"
            $HandlesCard
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "Get-LocalHandleCount: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}