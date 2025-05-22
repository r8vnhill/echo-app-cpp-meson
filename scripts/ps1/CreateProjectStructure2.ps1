<#
.SYNOPSIS
Creates the basic directory and file structure for a modular C++ project using Meson.

.DESCRIPTION
This script initializes a predefined directory and file layout for a modular C++ application structured around Meson build files.
# Specifically, it creates two main components:

- `App`: Contains the entry point (`main.cpp`) and its `meson.build` file.
- `Core`: Contains the core logic (`echo.cpp` and `echo.hpp`) and its `meson.build`.

For each defined file path, the script ensures the parent directory exists and creates an empty file.
It prints progress and status messages to the console using colored output for better visibility.

This is designed to help students or developers quickly bootstrap a standard folder layout for working on multi-module C++ projects with Meson.

.NOTES
- This script is designed for Windows PowerShell or PowerShell Core.
- It can be run from the terminal or invoked as part of a larger project initialization routine.

.EXAMPLE
PS> .\CreateProjectStructure2.ps1

Output:
📁 Creating structure for module: App
✅ src/app/main.cpp
✅ src/app/meson.build
📁 Creating structure for module: Core
✅ src/core/echo.cpp
✅ src/core/echo.hpp
✅ src/core/meson.build
🟢 Project initialized successfully.
#>

@{
    App = @("src/app/main.cpp", "src/app/meson.build")
    Core = @("src/core/echo.cpp", "src/core/echo.hpp", "src/core/meson.build")
}.GetEnumerator() | ForEach-Object {
    $module = $_.Key
    $files = $_.Value

    Write-Host "📁 Creating structure for module: $module" -ForegroundColor Cyan

    foreach ($file in $files) {
        $dir = Split-Path $file -Parent
        if (-not (Test-Path $dir)) {
            New-Item -Path $dir -ItemType Directory -Force | Out-Null
        }
        New-Item -Path $file -ItemType File -Force | Out-Null
        Write-Host "✅ $file" -ForegroundColor Green
    }
}

Write-Host "🟢 Project initialized successfully." -ForegroundColor Green
