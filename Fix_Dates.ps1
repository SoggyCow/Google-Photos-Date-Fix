$files = Get-ChildItem $PSScriptRoot -File -Recurse -Exclude *.html,*.ps1,*.zip

foreach ($file in $files) {
    # Skip JSON files during the main file processing loop
    if ($file.Extension.ToLower() -eq ".json") {
        continue
    }

    Write-Host "Processing file: $($file.FullName)"

    # Only process supported file types
    if ($file.Extension.ToLower() -in ".png", ".jpg", ".jpeg", ".bmp", ".mp4", ".mov", ".gif", ".webm", ".3gpp", ".3gp", ".webp", ".heic") {
        # Retrieve all JSON files in the same directory
        $jsonFiles = Get-ChildItem -Path $file.DirectoryName -Filter "*.json"
        if ($jsonFiles.Count -eq 0) {
            Write-Host "No JSON files found in directory: $($file.DirectoryName)"
            continue
        }

        # Escape special characters in the base name for wildcard matching
        $mediaBaseName = [Regex]::Escape([System.IO.Path]::GetFileNameWithoutExtension($file.Name))

        # Match JSON file by checking for close matching patterns
        $jsonFilePath = $jsonFiles | Where-Object {
            $jsonBaseName = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)

            # Match base name ignoring suffix differences
            $jsonBaseName -like "$mediaBaseName*" -or $mediaBaseName -like "$($jsonBaseName.Split('.')[0])*"
        } | Select-Object -First 1

        # Log potential matches if no match is found
        if (-not $jsonFilePath) {
            Write-Host "Potential JSON files found but none matched:"
            $jsonFiles | ForEach-Object { Write-Host "  - $($_.Name)" }
        }

        # Process the file if a matching JSON is found
        if ($jsonFilePath) {
            Write-Host "Using JSON file: $($jsonFilePath.FullName)"

            try {
                # Load JSON data
                $jsondata = Get-Content -Path $jsonFilePath.FullName | ConvertFrom-Json

                # Extract timestamp from JSON data
                $UnixTime = $jsondata.photoTakenTime.timestamp.Trim('"')

                # Convert Unix timestamp to local time
                $UtcTime = ([DateTime]::Parse("1970/01/01 00:00:00")).AddSeconds($UnixTime)
                $LocalTime = [TimeZoneInfo]::ConvertTimeFromUtc($UtcTime, [TimeZoneInfo]::Local)

                # Set creation and last write times of the file
                $file.CreationTime = $LocalTime
                $file.LastWriteTime = $LocalTime
            } catch {
                Write-Host "Error reading JSON data for: $($file.FullName)"
            }
        } else {
            Write-Host "No matching JSON file found for: $($file.FullName)"
        }
    } else {
        Write-Host "Unsupported file type: $($file.FullName)"
    }
}

Write-Host "Processing has finished. Press Enter to exit."
Read-Host
