function Convert-JsonYaml {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ParameterSetName='FromJson')]
        [string]$JsonPath,
        
        [Parameter(Mandatory=$true, ParameterSetName='FromYaml')]
        [string]$YamlPath,
        
        [Parameter(Mandatory=$true)]
        [string]$OutputPath
    )
    
    begin {
        # Ensure powershell-yaml module is installed
        if (-not (Get-Module -ListAvailable -Name 'powershell-yaml')) {
            Install-Module -Name 'powershell-yaml' -Scope CurrentUser -Force
        }
        Import-Module 'powershell-yaml'
    }
    
    process {
        try {
            if ($PSCmdlet.ParameterSetName -eq 'FromJson') {
                $content = Get-Content $JsonPath -Raw | ConvertFrom-Json
                $yaml = $content | ConvertTo-Yaml
                $yaml | Out-File $OutputPath -Encoding UTF8
            }
            else {
                $content = Get-Content $YamlPath -Raw | ConvertFrom-Yaml
                $json = $content | ConvertTo-Json -Depth 100
                $json | Out-File $OutputPath -Encoding UTF8
            }
            
            return [PSCustomObject]@{
                SourcePath = if ($JsonPath) { $JsonPath } else { $YamlPath }
                OutputPath = $OutputPath
                ConversionType = if ($JsonPath) { 'JSON to YAML' } else { 'YAML to JSON' }
                Success = $true
            }
        }
        catch {
            Write-Error "Conversion failed: $_"
        }
    }
}
