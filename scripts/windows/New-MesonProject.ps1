<#
.SYNOPSIS
Creates a new Meson-based C++ project scaffold with a default structure.

.DESCRIPTION
This function generates a directory structure for a Meson project, including:
- A root `meson.build` file
- A `src/` folder with its own `meson.build`
- One or more default C++ source files (e.g., `main.cpp`)

If the specified source files do not exist, they will be created.
If any of the files already exist, the function will warn without overwriting them.

.PARAMETER ProjectName
The name of the project and the directory to create. This parameter is required.

.PARAMETER SourceFiles
An optional array of C++ source files to include in the project (default is `main.cpp`).

.EXAMPLE
New-MesonProject -ProjectName HelloWorld

Creates a new Meson project in a folder called `HelloWorld`, with a default `main.cpp` file.

.EXAMPLE
New-MesonProject -ProjectName Engine -SourceFiles main.cpp, engine.cpp, player.cpp | Set-Location

Creates a project with multiple source files under `src/`.

.OUTPUTS
System.String
Returns the full path to the newly created project directory.
#>
function New-MesonProject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ProjectName,

        [string[]]$SourceFiles = @("main.cpp")
    )

    Write-Host "🚀 Creating new Meson project: $ProjectName" `
        -ForegroundColor Cyan

    # Resolve full path and create base directory
    $projectPath = Resolve-Path -Path (
        New-Item -Path $ProjectName -ItemType Directory -Force
    ).FullName
    $srcPath = Join-Path $projectPath "src"

    Write-Host "📁 Creating folders and Meson files..."
    New-Item -Path (Join-Path $projectPath "meson.build") `
             -ItemType File `
             -Force | Out-Null
    New-Item -Path $srcPath `
             -ItemType Directory `
             -Force | Out-Null
    New-Item -Path (Join-Path $srcPath "meson.build") `
             -ItemType File `
             -Force | Out-Null

    foreach ($file in $SourceFiles) {
        $filePath = Join-Path $srcPath $file
        if (-not (Test-Path $filePath)) {
            New-Item -Path $filePath `
                     -ItemType File `
                     -Force | Out-Null
            Write-Host "📄 Created source file: $file"
        } else {
            Write-Warning "⚠️ File already exists: $file"
        }
    }

    Write-Host "✅ Meson project '$ProjectName' created successfully." `
        -ForegroundColor Green

    # Output path so it can be piped into Set-Location
    return $projectPath
}
