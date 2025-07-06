function Start-DevServer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [ValidateSet('python', 'node', 'dotnet')]
        [string]$Type = 'python',
        
        [Parameter(Mandatory=$false)]
        [int]$Port = 3000,
        
        [Parameter(Mandatory=$false)]
        [string]$Path = (Get-Location),
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Environment = @{}
    )
    
    process {
        try {
            # First check if port is available
            $portCheck = Test-NetConnection -ComputerName localhost -Port $Port -WarningAction SilentlyContinue
            if ($portCheck.TcpTestSucceeded) {
                throw "Port $Port is already in use"
            }
            
            # Prepare environment variables
            $env:PORT = $Port
            foreach ($key in $Environment.Keys) {
                Set-Item -Path "env:$key" -Value $Environment[$key]
            }
            
            # Start server based on type
            switch ($Type) {
                'python' {
                    if (Test-Path (Join-Path $Path 'requirements.txt')) {
                        & pip install -r requirements.txt
                    }
                    Start-Process python -ArgumentList "-m", "http.server", $Port -WorkingDirectory $Path -NoNewWindow
                }
                'node' {
                    if (Test-Path (Join-Path $Path 'package.json')) {
                        & npm install
                        if ((Get-Content (Join-Path $Path 'package.json') | ConvertFrom-Json).scripts.dev) {
                            & npm run dev
                        }
                        elseif ((Get-Content (Join-Path $Path 'package.json') | ConvertFrom-Json).scripts.start) {
                            & npm start
                        }
                    }
                }
                'dotnet' {
                    & dotnet watch run --urls "http://localhost:$Port" --project $Path
                }
            }
            
            Write-Host "Development server started at http://localhost:$Port" -ForegroundColor Green
            Write-Host "Press Ctrl+C to stop the server..." -ForegroundColor Yellow
            
            # Keep the process running
            try {
                while ($true) { Start-Sleep -Seconds 1 }
            }
            finally {
                # Cleanup
                foreach ($key in $Environment.Keys) {
                    Remove-Item -Path "env:$key"
                }
            }
        }
        catch {
            Write-Error "Failed to start development server: $_"
        }
    }
}
