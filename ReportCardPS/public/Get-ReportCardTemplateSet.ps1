function Get-ReportCardTemplateSet
{
    <#
    .DESCRIPTION
        Builds HTML Reports using VMware's ClarityUI library.
    .PARAMETER Path
        Path to a directory with JSON templates.
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
        [Parameter()][String]$Path
    )
    if ($pscmdlet.ShouldProcess("Starting Get-ReportCardTemplateSet function."))
    {
        try
        {
            # If the Path is empty, search the module Root Lib directory.
            if (!($Path))
            {
                $Path = (Split-Path -Path (Get-Module -ListAvailable ReportCardPS | Sort-Object -Property Version -Descending | Select-Object -First 1).path)
                $Path = $Path + "\lib"
            }
            $TemplateFiles = Get-ChildItem -Path $Path -Recurse -File | Select-Object FullName
            $TemplateFiles
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