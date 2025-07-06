function Invoke-Benchmark {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [scriptblock]$ScriptBlock,
        
        [Parameter(Mandatory=$false)]
        [int]$Iterations = 100,
        
        [Parameter(Mandatory=$false)]
        [switch]$Detailed
    )
    
    process {
        try {
            $results = @()
            $total = [System.Diagnostics.Stopwatch]::StartNew()
            
            1..$Iterations | ForEach-Object {
                $sw = [System.Diagnostics.Stopwatch]::StartNew()
                $output = Invoke-Command -ScriptBlock $ScriptBlock
                $sw.Stop()
                
                $results += [PSCustomObject]@{
                    Iteration = $_
                    ElapsedMs = $sw.ElapsedMilliseconds
                    ElapsedTicks = $sw.ElapsedTicks
                    Output = $output
                }
            }
            
            $total.Stop()
            
            $stats = [PSCustomObject]@{
                TotalTime = $total.ElapsedMilliseconds
                AverageTime = ($results | Measure-Object -Property ElapsedMs -Average).Average
                MinTime = ($results | Measure-Object -Property ElapsedMs -Minimum).Minimum
                MaxTime = ($results | Measure-Object -Property ElapsedMs -Maximum).Maximum
                StandardDeviation = [Math]::Sqrt(($results | Measure-Object -Property ElapsedMs -Average -StandardDeviation).StandardDeviation)
                Iterations = $Iterations
            }
            
            if ($Detailed) {
                return [PSCustomObject]@{
                    Summary = $stats
                    RawResults = $results
                }
            }
            else {
                return $stats
            }
        }
        catch {
            Write-Error "Benchmark failed: $_"
        }
    }
}
