@{
    RootModule = 'Clippy.psm1'
    ModuleVersion = '1.0.0'
    GUID = '12345678-90ab-cdef-1234-567890abcdef'
    Author = 'Xayden Yagiela'
    CompanyName = 'Clippy'
    Copyright = 'open-source'
    Description = 'A professional developer toolkit providing various utilities for daily development tasks'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'New-DevProject',
        'Test-Endpoint',
        'Find-Port',
        'Watch-Directory',
        'Get-ProjectStats',
        'Invoke-Benchmark',
        'Get-EnvDiff',
        'Convert-JsonYaml',
        'Start-DevServer'
    )
    PrivateData = @{
        PSData = @{
            Tags = @('Development', 'Tools', 'Utility', 'Conversion', 'Git')
            LicenseUri = 'https://opensource.org/licenses/MIT'
            ProjectUri = 'https://github.com/yourusername/Clippy'
        }
    }
}
