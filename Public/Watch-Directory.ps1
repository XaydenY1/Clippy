function Watch-Directory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]$Path = (Get-Location),
        
        [Parameter(Mandatory=$false)]
        [string[]]$Filter = @('*.*'),
        
        [Parameter(Mandatory=$false)]
        [scriptblock]$Action,
        
        [Parameter(Mandatory=$false)]
        [switch]$Recurse
    )
    
    process {
        try {
            $watcher = New-Object System.IO.FileSystemWatcher
            $watcher.Path = $Path
            $watcher.IncludeSubdirectories = $Recurse
            
            foreach ($f in $Filter) {
                $watcher.Filters.Add($f)
            }
            
            $onChange = {
                $path = $Event.SourceEventArgs.FullPath
                $changeType = $Event.SourceEventArgs.ChangeType
                $timeStamp = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
                
                Write-Host "[$timeStamp] $changeType : $path" -ForegroundColor Yellow
                
                if ($Action) {
                    try {
                        Invoke-Command -ScriptBlock $Action -ArgumentList $path, $changeType
                    }
                    catch {
                        Write-Error "Action failed: $_"
                    }
                }
            }
            
            $handlers = @()
            'Changed', 'Created', 'Deleted', 'Renamed' | ForEach-Object {
                $handlers += Register-ObjectEvent -InputObject $watcher -EventName $_ -Action $onChange
            }
            
            $watcher.EnableRaisingEvents = $true
            
            Write-Host "Watching directory: $Path"
            Write-Host "Press Ctrl+C to stop watching..."
            
            try {
                while ($true) { Start-Sleep -Milliseconds 500 }
            }
            finally {
                $watcher.EnableRaisingEvents = $false
                $handlers | ForEach-Object { Unregister-Event -SourceIdentifier $_.Name }
                $watcher.Dispose()
            }
        }
        catch {
            Write-Error "Watch failed: $_"
        }
    }
}
