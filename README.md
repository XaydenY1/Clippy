# Clippy Developer Tools 🚀

A powerful suite of PowerShell tools designed to enhance developer productivity. Clippy provides essential utilities for daily development tasks, from project creation to performance testing.

## 🛠️ Features

### Project Management
- **New-DevProject**: Scaffold new projects with best practices
  - Supports: Node.js, Python, .NET, React, and Vue
  - Includes testing and linting setup
  - Creates standard project structure

### Development Tools
- **Test-Endpoint**: API endpoint testing utility
  ```powershell
  Test-Endpoint -Url "https://api.example.com/users" -Method GET -IncludeLatency
  ```

- **Find-Port**: Port availability checker
  ```powershell
  Find-Port -StartPort 3000 -EndPort 4000
  ```

- **Watch-Directory**: File system monitoring
  ```powershell
  Watch-Directory -Path "./src" -Filter @("*.js", "*.css") -Recurse
  ```

### Analysis & Statistics
- **Get-ProjectStats**: Project analysis tool
  ```powershell
  Get-ProjectStats -ExcludeDir @("node_modules", "dist")
  ```

- **Invoke-Benchmark**: Performance testing
  ```powershell
  Invoke-Benchmark -ScriptBlock { Get-Process } -Iterations 100 -Detailed
  ```

### Configuration Management
- **Get-EnvDiff**: Environment file comparison
  ```powershell
  Get-EnvDiff -FirstEnvFile ".env.development" -SecondEnvFile ".env.production"
  ```

- **Convert-JsonYaml**: Format conversion utility
  ```powershell
  Convert-JsonYaml -JsonPath "config.json" -OutputPath "config.yaml"
  ```

### Development Server
- **Start-DevServer**: Quick development server launcher
  ```powershell
  Start-DevServer -Type node -Port 3000 -Environment @{ "NODE_ENV" = "development" }
  ```

## 📦 Installation

1. Clone this repository or download the latest release:
   ```bash
   git clone https://github.com/XaydenY1/Clippy.git
   cd Clippy
   ```

2. Run the installer with appropriate privileges:

   ### Windows
   ```powershell
   Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"& '$PWD\Install.ps1'`""
   ```

   ### Linux/macOS
   ```bash
   sudo pwsh -c "./Install.ps1"
   ```

## 🔧 Requirements

### Windows
- PowerShell 5.1 or later, or PowerShell Core 7.x
- Administrator privileges for installation

### Linux/macOS
- PowerShell Core 7.x or later (pwsh)
- Sudo privileges for installation
- Additional requirements:
  - `curl` or `wget` for some network operations
  - Python 3.x for Python project templates
  - Node.js for Node.js/React/Vue templates
  - .NET SDK for .NET templates

## 📖 Usage

After installation, all commands are available in your PowerShell session. Use Get-Help to learn more about each command:

```powershell
Get-Help New-DevProject -Full
Get-Help Test-Endpoint -Detailed
Get-Help Find-Port -Examples
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.


## 👤 Author

Created by Xayden Yagiela

---
