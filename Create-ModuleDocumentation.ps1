# LCS: This script generates detailed HTML documentation for a specified PowerShell module
param(
    [Parameter(Mandatory=$true)]
    [string]$ModuleName
)

# LCS: Function to get the full type name of a parameter
# This is useful for displaying accurate type information in the documentation
function Get-FullTypeName($type) {
    if ($type -is [System.Array]) {
        return $type.Name
    }
    if ($null -eq $type.FullName) {
        return $type.Name
    }
    return $type.FullName
}

# LCS: Function to create a URL-friendly ID from text
# This is used to generate anchor links for the table of contents
function Get-AnchorID($text) {
    return $text -replace '[^a-zA-Z0-9\s]', '' -replace '\s', '-'
}

# LCS: Import the specified module to ensure we have access to all its commands
Import-Module $ModuleName -Force

# LCS: Retrieve module information
$module = Get-Module $ModuleName

# LCS: Start building the HTML content
# This includes the HTML structure, CSS styling, and the beginning of the document body
$moduleInfo = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$($module.Name) Module Documentation</title>
    <style>
        /* AI: CSS styles for formatting the documentation */
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1, h2, h3 { color: #2c3e50; }
        h1 { border-bottom: 2px solid #2c3e50; padding-bottom: 10px; }
        h2 { border-bottom: 1px solid #bdc3c7; padding-bottom: 5px; }
        code { background-color: #f8f8f8; padding: 2px 4px; border-radius: 4px; }
        pre { background-color: #f8f8f8; padding: 10px; border-radius: 4px; overflow-x: auto; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .toc { background-color: #f8f8f8; padding: 20px; border-radius: 4px; margin-bottom: 20px; }
        .toc table { width: 100%; }
        .toc a { text-decoration: none; color: #3498db; }
        .toc a:hover { text-decoration: underline; }
        .page { page-break-after: always; }
        .page:last-child { page-break-after: avoid; }
        .toc-page-number { text-align: right; }
        @media print {
            .page { page-break-after: always; }
            .page:last-child { page-break-after: avoid; }
        }
    </style>
</head>
<body>

<h1>$($module.Name) Module Documentation</h1>

<p><strong>Version:</strong> $($module.Version)</p>
<p><strong>Description:</strong> $($module.Description)</p>

<div class="toc">
<h2>Table of Contents</h2>
<table>
<tr><th>Command</th><th>Page</th></tr>
"@

# LCS: Get all commands in the module
$commands = Get-Command -Module $ModuleName
$pageNumber = 1

# LCS: Create Table of Contents
# This loop generates links to each command with corresponding page numbers in a separate column
foreach ($command in $commands) {
    $anchorID = Get-AnchorID $command.Name
    $moduleInfo += "<tr><td><a href='#$anchorID'>$($command.Name)</a></td><td class='toc-page-number'>$pageNumber</td></tr>`n"
    $pageNumber++
}

$moduleInfo += @"
</table>
</div>

<div class="content">
"@

$pageNumber = 1

# LCS: Main loop to generate documentation for each command
foreach ($command in $commands) {
    $anchorID = Get-AnchorID $command.Name
    $moduleInfo += @"
<div class="page" id="$anchorID">
<h2>$($command.Name)</h2>
<p><strong>Page:</strong> $pageNumber</p>
<p><strong>Type:</strong> $($command.CommandType)</p>
"@
    
    # LCS: Retrieve and add help information for the command
    $help = Get-Help $command.Name -Full
    $moduleInfo += "<p><strong>Synopsis:</strong> $($help.Synopsis)</p>`n"
    
    if ($help.Description) {
        $moduleInfo += "<h3>Description</h3>`n<p>$($help.Description.Text)</p>`n"
    }
    
    # LCS: Add parameter information in a table format
    $moduleInfo += "<h3>Parameters</h3>`n<table>`n<tr><th>Name</th><th>Type</th><th>Description</th></tr>`n"
    foreach ($parameter in $command.Parameters.Values) {
        $parameterHelp = $help.Parameters.Parameter | Where-Object { $_.Name -eq $parameter.Name }
        $moduleInfo += "<tr><td><code>$($parameter.Name)</code></td><td>$(Get-FullTypeName $parameter.ParameterType)</td><td>$($parameterHelp.Description.Text)</td></tr>`n"
    }
    $moduleInfo += "</table>`n"
    
    # LCS: Add examples if available
    if ($help.Examples) {
        $moduleInfo += "<h3>Examples</h3>`n"
        foreach ($example in $help.Examples.Example) {
            $moduleInfo += "<pre><code class='language-powershell'>$($example.Code)</code></pre>`n"
            $moduleInfo += "<p>$($example.Remarks.Text)</p>`n"
        }
    }
    
    # LCS: Add source code if available
    $definition = $command.Definition
    if ($definition) {
        $moduleInfo += "<h3>Source Code</h3>`n<pre><code class='language-powershell'>$definition</code></pre>`n"
    }
    
    $moduleInfo += "</div>`n"  # LCS: Close the page div
    $pageNumber++
}

# LCS: Close the HTML structure
$moduleInfo += @"
</div>
</body>
</html>
"@

# LCS: Save the generated HTML documentation to a file
$outputPath = "$ModuleName-Documentation.html"
$moduleInfo | Out-File -FilePath $outputPath -Encoding UTF8

# LCS: Inform the user that the documentation has been generated
Write-Host "Documentation for $ModuleName has been saved to $outputPath"
