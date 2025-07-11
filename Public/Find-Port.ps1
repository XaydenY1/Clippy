function Find-Port {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [int]$StartPort = 3000,
        
        [Parameter(Mandatory=$false)]
        [int]$EndPort = 9000,
        
        [Parameter(Mandatory=$false)]
        [switch]$ShowAll
    )
    
    process {
        try {
            # Cross-platform port checking
            if ($IsWindows) {
                $ports = Get-NetTCPConnection -ErrorAction SilentlyContinue | 
                         Select-Object LocalPort, RemotePort, State, OwningProcess, @{
                             Name='ProcessName';
                             Expression={(Get-Process -Id $_.OwningProcess).ProcessName}
                         }
            } else {
                # Use netstat on Linux/macOS
                $netstatOutput = & netstat -tuln 2>&1
                $ports = $netstatOutput | Select-String -Pattern ".*:(\d+).*" | ForEach-Object {
                    $port = $_.Matches.Groups[1].Value
                    [PSCustomObject]@{
                        LocalPort = [int]$port
                        State = "LISTEN"
                    }
                }
            
            if ($ShowAll) {
                $availablePorts = $StartPort..$EndPort | Where-Object {
                    $port = $_
                    -not ($ports | Where-Object { $_.LocalPort -eq $port })
                }
                
                return [PSCustomObject]@{
                    UsedPorts = $ports | Where-Object { $_.LocalPort -ge $StartPort -and $_.LocalPort -le $EndPort }
                    AvailablePorts = $availablePorts
                }
            }
            else {
                $firstAvailable = $StartPort..$EndPort | Where-Object {
                    $port = $_
                    -not ($ports | Where-Object { $_.LocalPort -eq $port })
                } | Select-Object -First 1
                
                return [PSCustomObject]@{
                    Port = $firstAvailable
                    IsAvailable = $true
                }
            }
        }
        catch {
            Write-Error "Failed to find ports: $_"
        }
    }
}
