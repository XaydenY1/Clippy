function Convert-NumberBase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Number,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Decimal", "Hex", "Binary")]
        [string]$From = "Decimal",
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Decimal", "Hex", "Binary", "All")]
        [string]$To = "All"
    )

    begin {
        Write-Verbose "Converting number $Number from $From to $To"
    }

    process {
        try {
            # Function to convert to decimal
            function ConvertToDecimal($value, $fromBase) {
                switch ($fromBase) {
                    "Decimal" { return [int]$value }
                    "Hex" { return [Convert]::ToInt32($value, 16) }
                    "Binary" { return [Convert]::ToInt32($value, 2) }
                }
            }

            # Convert input to decimal first
            $decimalValue = ConvertToDecimal $Number $From

            # Create output object
            $result = [PSCustomObject]@{
                OriginalValue = $Number
                OriginalBase = $From
            }

            # Add conversions based on requested output
            if ($To -eq "All" -or $To -eq "Decimal") {
                $result | Add-Member -MemberType NoteProperty -Name "Decimal" -Value $decimalValue
            }
            if ($To -eq "All" -or $To -eq "Hex") {
                $result | Add-Member -MemberType NoteProperty -Name "Hexadecimal" -Value ("0x" + [Convert]::ToString($decimalValue, 16).ToUpper())
            }
            if ($To -eq "All" -or $To -eq "Binary") {
                $result | Add-Member -MemberType NoteProperty -Name "Binary" -Value ("0b" + [Convert]::ToString($decimalValue, 2).PadLeft(8, '0'))
            }

            return $result
        }
        catch {
            Write-Error "Failed to convert number: $_"
        }
    }
}
