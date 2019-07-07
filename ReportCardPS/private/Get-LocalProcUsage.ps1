function Get-LocalProcUsage
{
    <#
    .DESCRIPTION
        Returns CPU usage by processes.
    .PARAMETER Count
        Number of items to return, Default is 5.
    .EXAMPLE
        Get-LocalProcUsage -Count 5
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
    if ($pscmdlet.ShouldProcess("Starting Get-LocalProcUsage function."))
    {
        try
        {
            # Get CPU Information
            $ProcessData = Get-Process | Sort-Object -Property CPU -Descending | Select-Object ProcessName, CPU, Id | Select-Object -First $Count
            $TopProcessesHTML = $ProcessData | ConvertTo-Html -Fragment

            # Build the HTML Card
            $ProcessCPUCard = New-ClarityCard -Title "Top $Count CPU processes" -Icon cpu -IconSize 24
            $ProcessCPUCardBody = Add-ClarityCardBody -CardText "$TopProcessesHTML"
            $ProcessCPUCardBody += Close-ClarityCardBody
            $ProcessCPUCard += $ProcessCPUCardBody
            $ProcessCPUCard += Close-ClarityCard -Title "Close CPU Card"
            $ProcessCPUCard
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "Get-LocalProcUsage: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}