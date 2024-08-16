# PowerShell Module Documenter

This PowerShell script generates comprehensive HTML documentation for any specified PowerShell module. It creates a well-structured, printable document that includes detailed information about each command in the module.

## Features

- Generates a single HTML file containing documentation for all commands in a specified module
- Creates a table of contents with page numbers for easy navigation
- Includes detailed information for each command:
  - Synopsis
  - Description
  - Parameters (with types and descriptions)
  - Examples
  - Source code (when available)
- Produces print-friendly output with proper page breaks
- Formats code snippets for improved readability

## Requirements

- PowerShell 5.1 or later
- Write access to the directory where the script is run

## Usage

1. Save the script as `Get-ModuleDocumentation.ps1` in your desired directory.

2. Open a PowerShell terminal and navigate to the directory containing the script.

3. Run the script with the name of the module you want to document as an argument:

   ```powershell
   .\Get-ModuleDocumentation.ps1 -ModuleName "YourModuleName"
   ```

   Replace `"YourModuleName"` with the name of the PowerShell module you want to document.

4. The script will generate an HTML file named `YourModuleName-Documentation.html` in the same directory.

5. Open the generated HTML file in a web browser to view the documentation.

## Example

To generate documentation for the `Microsoft.PowerShell.Management` module:

```powershell
.\Get-ModuleDocumentation.ps1 -ModuleName "Microsoft.PowerShell.Management"
```

This will create a file named `Microsoft.PowerShell.Management-Documentation.html` in the current directory.

## Customization

You can modify the script to adjust the styling or layout of the generated documentation. Look for the CSS styles within the script to make visual changes.

## Notes

- The script may take a while to run for large modules with many commands.
- Ensure you have the necessary permissions to import the module you're trying to document.
- The generated HTML file can be quite large for modules with many commands or extensive documentation.

## Contributing

Feel free to fork this repository and submit pull requests with any enhancements or bug fixes. Issues and feature requests are also welcome in the GitHub issue tracker.

## License

[Specify your chosen license here, e.g., MIT License, GPL, etc.]

