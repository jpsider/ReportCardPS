function New-ReportCard
{
    <#
    .DESCRIPTION
        Builds HTML Reports using VMware's ClarityUI library.
    .PARAMETER Title
        Title for the document.
    .PARAMETER JsonFilePath
        Full Path to the JsonFile.
    .EXAMPLE
        New-ReportCard
    .NOTES
        No notes at this time.
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Low"
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingInvokeExpression", '')]
    [OutputType([String])]
    [OutputType([Boolean])]
    param(
        [Parameter()][String]$Title,
        [Parameter()][String]$JsonFilePath
    )
    if ($pscmdlet.ShouldProcess("Starting New-ReportCard function."))
    {
        try
        {
            # Validate the Template Json Path
            if (Test-Path -Path $JsonFilePath)
            {
                # Get the New-ClarityDocument HTML
                $ClarityDocument = New-ClarityDocument -Title "$Title"
                # Loop through the Json to create the HTML file.
                $JsonContent = Get-Content -Path $JsonFilePath | ConvertFrom-Json
                $JsonContent = $JsonContent | Sort-Object -Property Order
                foreach ($JsonObject in $JsonContent)
                {
                    # Execute each specified function
                    $CardFunction = $JsonObject.CardFunction
                    $CardArguments = $JsonObject.CardArguments
                    $CardHtml = Invoke-Expression -Command "$CardFunction $CardArguments"
                    $ClarityDocument += $CardHtml
                }
                # Close the Document
                $ClarityDocument += Close-ClarityDocument
                # Output the data (Allow passthru?)
                $ClarityDocument
            }
            else
            {
                Throw "New-ReportCard: Json File not found. $JsonFilePath"
            }
        }
        catch
        {
            $ErrorMessage = $_.Exception.Message
            $FailedItem = $_.Exception.ItemName
            Throw "New-ReportCard: $ErrorMessage $FailedItem"
        }
    }
    else
    {
        # -WhatIf was used.
        return $false
    }
}