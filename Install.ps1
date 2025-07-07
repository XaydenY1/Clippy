# Installer script for Clippy Developer Tools
param (
    [Parameter(Mandatory=$false)]
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

# Define the installation paths based on OS
if ($IsWindows) {
    $installPath = "$env:ProgramFiles\ClippyDevTools"
    $modulePath = "$env:ProgramFiles\PowerShell\Modules\Clippy"
} elseif ($IsLinux) {
    $installPath = "/opt/clippy"
    $modulePath = "/usr/local/share/powershell/Modules/Clippy"
} elseif ($IsMacOS) {
    $installPath = "/usr/local/clippy"
    $modulePath = "/usr/local/share/powershell/Modules/Clippy"
} else {
    throw "Unsupported operating system"
}

Write-Host "Installing Clippy Developer Tools..." -ForegroundColor Green

try {
    # Create installation directories if they don't exist
    if (-not (Test-Path $installPath)) {
        New-Item -ItemType Directory -Path $installPath -Force | Out-Null
    }
    
    if (-not (Test-Path $modulePath)) {
        New-Item -ItemType Directory -Path $modulePath -Force | Out-Null
    }

    # Copy module files
    Copy-Item -Path "$PSScriptRoot\Clippy\*" -Destination $modulePath -Recurse -Force

    # Add to PSModulePath if not already present
    $envPath = [Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
    if ($envPath -notlike "*$modulePath*") {
        [Environment]::SetEnvironmentVariable(
            "PSModulePath",
            "$envPath;$modulePath",
            "Machine"
        )
    }

    # Import the module in current session
    Import-Module Clippy -Force

    Write-Host "`nCliffy Developer Tools has been successfully installed!" -ForegroundColor Green
    Write-Host "You can now use the following commands:" -ForegroundColor Yellow
    Write-Host "  - Convert-NumberBase : Convert numbers between different bases"
    Write-Host "  - Get-TimezoneDiff  : Calculate time differences between timezones"
    Write-Host "  - New-GitIgnore     : Generate .gitignore files for your projects"
    Write-Host "`nTo get help for any command, use Get-Help, for example:" -ForegroundColor Yellow
    Write-Host "  Get-Help Convert-NumberBase -Full"
}
catch {
    Write-Error "Installation failed: $_"
    exit 1
}
