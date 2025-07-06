function Get-ProjectStats {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$Path = (Get-Location),
        
        [Parameter(Mandatory=$false)]
        [string[]]$ExcludeDir = @('node_modules', 'venv', 'bin', 'obj', '.git'),
        
        [Parameter(Mandatory=$false)]
        [string[]]$IncludeExtensions = @('.cs', '.js', '.ts', '.py', '.java', '.cpp', '.h', '.jsx', '.tsx')
    )
    
    process {
        try {
            $stats = @{
                TotalFiles = 0
                TotalLines = 0
                FilesByExtension = @{}
                LinesByExtension = @{}
                LargestFiles = @()
            }
            
            $files = Get-ChildItem -Path $Path -File -Recurse -ErrorAction SilentlyContinue |
                     Where-Object {
                         $shouldInclude = $true
                         foreach ($dir in $ExcludeDir) {
                             if ($_.FullName -like "*\$dir\*") {
                                 $shouldInclude = $false
                                 break
                             }
                         }
                         $shouldInclude -and ($IncludeExtensions -contains $_.Extension)
                     }
            
            foreach ($file in $files) {
                $stats.TotalFiles++
                $content = Get-Content $file.FullName
                $lineCount = $content.Count
                
                $stats.TotalLines += $lineCount
                
                if (-not $stats.FilesByExtension.ContainsKey($file.Extension)) {
                    $stats.FilesByExtension[$file.Extension] = 0
                    $stats.LinesByExtension[$file.Extension] = 0
                }
                
                $stats.FilesByExtension[$file.Extension]++
                $stats.LinesByExtension[$file.Extension] += $lineCount
                
                $stats.LargestFiles += [PSCustomObject]@{
                    Path = $file.FullName.Replace($Path, '')
                    Lines = $lineCount
                    SizeKB = [math]::Round($file.Length / 1KB, 2)
                }
            }
            
            $stats.LargestFiles = $stats.LargestFiles | Sort-Object Lines -Descending | Select-Object -First 10
            
            return [PSCustomObject]$stats
        }
        catch {
            Write-Error "Failed to get project stats: $_"
        }
    }
}
