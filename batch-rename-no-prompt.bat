<# ::
powershell -NoProfile -ExecutionPolicy Bypass -Command "& {iex ((Get-Content '%~f0') -join [Environment]::Newline)}"
exit /b
#>

$validPatterns = '\.docset'  # Ensure exact match for folder names ending in .docset

Write-Host "Scanning for folders matching pattern: $validPatterns"

Get-ChildItem -Directory |
    Where-Object Name -Match $validPatterns |
    ForEach-Object {
        $newName = $_.Name -replace '\.docset$', '_cheatsheet.docset'

        # Prevent renaming if the name hasn't changed
        if ($newName -ne $_.Name) {
            Write-Host "Renaming folder: $($_.Name) > $newName"
            Rename-Item -Path $_.FullName -NewName $newName
        } else {
            Write-Host "Skipping: $($_.Name) (No change needed)"
        }
    }

Write-Host "Finished processing!"
pause

# Make sure to wrap everything from $_.BaseName to the end of -replace operation in a pair of parenthesis.

# Example Lines:
# Where-Object Extension -In $validPatterns |
# ($_.BaseName -replace 'something', 'something else').ToUpper() + $_.Extension
# $_.Name + '_cheatsheet'
# For files: Where-Object Length -GT 0b | 

# Need to append $_.Extension because $_.BaseName -replace removes the extension.
# Last Dot Segment (.something) in a Folder Name is also Treated as an Extension ".something". Try: Get-ChildItem -Directory | Select-Object Name, BaseName, Extension

# Second Argument in -replace operation does not need to escape special characters of regex.