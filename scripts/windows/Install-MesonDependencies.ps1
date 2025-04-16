<#
.SYNOPSIS
Installs Meson build system dependencies using Scoop, if they are not already available.

.DESCRIPTION
This script checks for the availability of essential tools required for building software with the Meson build system.
If a tool is missing, it installs the corresponding package using Scoop.

The dependencies include:
- `clang` (provided by the `llvm` package)
- `meson`
- `ninja`

Each tool is verified using its command name. If the command is not found, the script uses Scoop to install the
associated package.

.PARAMETER Quiet
Suppresses output from Scoop when installing packages.

.EXAMPLE
Install-MesonDependencies
# Checks for required tools and installs any that are missing using Scoop.

.EXAMPLE
Install-MesonDependencies -Quiet
# Same as above, but suppresses installation output.

.NOTES
Requires Scoop to be installed and configured on the system.
#>

function Install-MesonDependencies {
    [CmdletBinding()]
    param (
        [switch]$Quiet
    )

    # 🔍 Checks if a given command is available in the system
    function Test-Command {
        param ([string]$Command)
        return ($null -ne (Get-Command $Command -ErrorAction SilentlyContinue))
    }

    # 📦 Installs a list of packages with Scoop if their associated command is missing
    function Install-PackagesWithScoop {
        param (
            [hashtable]$CommandMap,
            [switch]$Quiet
        )

        foreach ($pkg in $CommandMap.Keys) {
            $command = $CommandMap[$pkg]

            if (Is-CommandAvailable $command) {
                Write-Host "🔹 $pkg is already available (via '$command'). Skipping Scoop." `
                    -ForegroundColor DarkGray
                continue
            }

            Write-Host "📦 Installing $pkg with Scoop..." -ForegroundColor Cyan

            if ($Quiet) {
                scoop install $pkg *>&1 | Out-Null
            } else {
                scoop install $pkg
            }

            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ $pkg installed successfully." -ForegroundColor Green
            } else {
                Write-Error "❌ Failed to install $pkg." -ForegroundColor Red
                return 1
            }
        }
    }

    # 🧱 Define which packages to install and how to verify them
    $commandMap = @{
        llvm  = 'clang'   # Required to compile C/C++ code
        meson = 'meson'   # Build system configuration tool
        ninja = 'ninja'   # Compilation executor
    }

    Install-PackagesWithScoop -CommandMap $commandMap @PSBoundParameters
}

