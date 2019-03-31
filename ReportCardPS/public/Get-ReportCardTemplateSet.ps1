function Get-ReportCardTemplateSet
{
    <#
    .DESCRIPTION
        Builds HTML Reports using VMware's ClarityUI library.
    .PARAMETER tbd01
        working on the details
    .PARAMETER tbd02
        working on the details
    .EXAMPLE
        Get-ReportCardTemplateSet
    .NOTES
        No notes at this time.
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Low"
    )]
    [OutputType([String])]
    [OutputType([Boolean])]
    param(
        [Parameter()][String]$tbd01,
        [Parameter()][String]$tbd02
    )
    if ($pscmdlet.ShouldProcess("Starting Get-ReportCardTemplateSet function."))
    {
        try
        {
            # Add Function details
            # If a path is specified, return the .json files.
            # otherwise use the default module location

        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "Get-ReportCardTemplateSet: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}