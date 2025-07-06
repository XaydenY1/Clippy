function Test-Endpoint {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Url,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('GET', 'POST', 'PUT', 'DELETE', 'HEAD')]
        [string]$Method = 'GET',
        
        [Parameter(Mandatory=$false)]
        [hashtable]$Headers,
        
        [Parameter(Mandatory=$false)]
        [object]$Body,
        
        [Parameter(Mandatory=$false)]
        [switch]$IncludeLatency
    )
    
    process {
        try {
            $params = @{
                Uri = $Url
                Method = $Method
                UseBasicParsing = $true
            }
            
            if ($Headers) { $params.Headers = $Headers }
            if ($Body) { $params.Body = $Body }
            
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            $response = Invoke-WebRequest @params
            $sw.Stop()
            
            $result = [PSCustomObject]@{
                Url = $Url
                StatusCode = $response.StatusCode
                StatusDescription = $response.StatusDescription
                ContentLength = $response.RawContentLength
                Headers = $response.Headers
            }
            
            if ($IncludeLatency) {
                $result | Add-Member -MemberType NoteProperty -Name 'LatencyMs' -Value $sw.ElapsedMilliseconds
            }
            
            return $result
        }
        catch {
            Write-Error "Endpoint test failed: $_"
        }
    }
}
