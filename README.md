# Fix_Dates.ps1

Author: [SoggyCow](https://github.com/SoggyCow)  
License: MIT  
Repository: [SoggyCow/Scripts](https://github.com/SoggyCow/Scripts)

## Overview

This PowerShell script recursively scans a directory for supported media files (images and videos) and pairs them with corresponding `.json` metadata files, such as those exported from Google Photos. If a matching JSON file contains a valid `photoTakenTime` timestamp, the script updates the media file’s **CreationTime** and **LastWriteTime** to reflect the original capture date.

## Supported Media Formats

- Images: `.png`, `.jpg`, `.jpeg`, `.bmp`, `.webp`, `.heic`
- Videos: `.mp4`, `.mov`, `.gif`, `.webm`, `.3gpp`, `.3gp`

## Matching Logic

- Matches media files to JSON files using their **base name**, escaping special characters for robust pairing.
- Employs wildcard and fuzzy logic to handle naming variations.
- Lists potential JSON matches if no exact pair is found.
- Logs errors gracefully to ensure reliable processing of complex directory structures.

## Features

- Recursively processes nested folders.
- Filters out irrelevant files (e.g., `.html`, `.ps1`, `.zip`) and unsupported media extensions.
- Converts Unix timestamps from JSON to system-local time.
- Updates timestamps only when valid data is present, preventing unintended overwrites.

## Requirements

- Windows PowerShell
- JSON metadata files containing a `photoTakenTime.timestamp` field
- Read/write access to the target directory

## Usage

Run the script in the directory containing your media and JSON files:

```powershell
.\Fix_Dates.ps1
```

## Technical Notes

- **Error Handling**: Gracefully logs errors to maintain stability in messy directories.
- **Timestamp Conversion**: Parses Unix timestamps and adjusts to local system time.
- **Testing**: Test in a sandbox or backup your files before running to avoid unintended changes.

## Disclaimer

This script is provided for educational purposes only. Use on files you own or have permission to modify. The author, SoggyCow, is not liable for data loss or other issues resulting from misuse.

## License

Licensed under the MIT License. See the `LICENSE` file for details.