function Get-TimezoneDiff {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$FromTimezone,
        
        [Parameter(Mandatory=$true)]
        [string]$ToTimezone,
        
        [Parameter(Mandatory=$false)]
        [DateTime]$Time = (Get-Date)
    )

    begin {
        Write-Verbose "Calculating time difference between $FromTimezone and $ToTimezone"
    }

    process {
        try {
            $fromTZ = [System.TimeZoneInfo]::FindSystemTimeZoneById($FromTimezone)
            $toTZ = [System.TimeZoneInfo]::FindSystemTimeZoneById($ToTimezone)
            
            $fromTime = [System.TimeZoneInfo]::ConvertTime($Time, $fromTZ)
            $toTime = [System.TimeZoneInfo]::ConvertTime($Time, $toTZ)
            
            [PSCustomObject]@{
                FromTimezone = $FromTimezone
                FromTime = $fromTime
                ToTimezone = $ToTimezone
                ToTime = $toTime
                HoursDifference = ($toTime - $fromTime).TotalHours
            }
        }
        catch {
            Write-Error "Failed to calculate timezone difference: $_"
        }
    }
}
