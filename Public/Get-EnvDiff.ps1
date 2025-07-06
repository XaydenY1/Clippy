function Get-EnvDiff {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$FirstEnvFile,
        
        [Parameter(Mandatory=$true)]
        [string]$SecondEnvFile,
        
        [Parameter(Mandatory=$false)]
        [switch]$IgnoreValues
    )
    
    process {
        try {
            function Parse-EnvFile($path) {
                $envVars = @{}
                if (Test-Path $path) {
                    Get-Content $path | ForEach-Object {
                        if ($_ -match '^([^=]+)=(.*)$') {
                            $envVars[$matches[1]] = $matches[2]
                        }
                    }
                }
                return $envVars
            }
            
            $first = Parse-EnvFile $FirstEnvFile
            $second = Parse-EnvFile $SecondEnvFile
            
            $allKeys = $first.Keys + $second.Keys | Select-Object -Unique
            
            $comparison = @{
                OnlyInFirst = @{}
                OnlyInSecond = @{}
                Different = @{}
                Same = @{}
            }
            
            foreach ($key in $allKeys) {
                if (-not $first.ContainsKey($key)) {
                    $comparison.OnlyInSecond[$key] = $second[$key]
                }
                elseif (-not $second.ContainsKey($key)) {
                    $comparison.OnlyInFirst[$key] = $first[$key]
                }
                elseif ($first[$key] -ne $second[$key]) {
                    if (-not $IgnoreValues) {
                        $comparison.Different[$key] = @{
                            FirstValue = $first[$key]
                            SecondValue = $second[$key]
                        }
                    }
                }
                else {
                    $comparison.Same[$key] = $first[$key]
                }
            }
            
            return [PSCustomObject]$comparison
        }
        catch {
            Write-Error "Environment comparison failed: $_"
        }
    }
}
