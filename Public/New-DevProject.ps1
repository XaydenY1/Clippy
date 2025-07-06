function New-DevProject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet('node', 'python', 'dotnet', 'react', 'vue')]
        [string]$Template,
        
        [Parameter(Mandatory=$false)]
        [string]$Path = (Get-Location)
    )
    
    process {
        try {
            $projectPath = Join-Path $Path $ProjectName
            
            switch ($Template) {
                'node' {
                    New-Item -ItemType Directory -Path $projectPath -Force
                    Set-Location $projectPath
                    & npm init -y
                    & npm install --save-dev jest eslint prettier
                    New-Item -ItemType File -Path ".gitignore", "README.md", ".env.example"
                }
                'python' {
                    New-Item -ItemType Directory -Path $projectPath -Force
                    Set-Location $projectPath
                    & python -m venv venv
                    New-Item -ItemType File -Path "requirements.txt", ".gitignore", "README.md", ".env.example"
                    New-Item -ItemType Directory -Path "tests", "src"
                }
                'dotnet' {
                    & dotnet new webapi -n $ProjectName -o $projectPath
                }
                'react' {
                    & npx create-react-app $projectPath --template typescript
                }
                'vue' {
                    & npm create vue@latest $projectPath
                }
            }
            
            Write-Host "Project $ProjectName created successfully with $Template template" -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to create project: $_"
        }
    }
}
