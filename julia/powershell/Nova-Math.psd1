# ═══════════════════════════════════════════════════════════════════════════════
# Nova-Math.psd1 — Module Manifest for NOVA Julia Mathematical Substrate
# Classification: SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
# ═══════════════════════════════════════════════════════════════════════════════

@{
    # Module script
    RootModule        = 'Nova-Math.psm1'

    # Version
    ModuleVersion     = '65.0.0'

    # Module GUID
    GUID              = 'a7c3f618-8730-4e2d-b619-a00a00000001'

    # Author
    Author            = 'Alfredo Medina Hernandez'

    # Company
    CompanyName       = 'Medina Tech'

    # Description
    Description       = 'NOVA Sovereign Mathematical Substrate — PowerShell interface to Julia high-performance computing. Provides 110+ mathematical models across 8 domains (linear algebra, statistics, signal processing, differential equations, optimization, quantum/physics, graph theory, numerical methods) via Julia subprocess invocation.'

    # Minimum PowerShell version
    PowerShellVersion = '5.1'

    # Functions to export
    FunctionsToExport = @(
        'Find-Julia',
        'Invoke-Julia',
        'Invoke-NovaMath',
        'Get-MathModels',
        'Get-Phi',
        'Get-PhiInverse',
        'Get-Amor',
        'Invoke-Eigen',
        'Invoke-SVD',
        'Invoke-FFT',
        'Invoke-Kuramoto',
        'Invoke-PhiGradientDescent',
        'Invoke-MotokoFunction',
        'Invoke-JuliaBlock',
        'ConvertFrom-JuliaCode',
        'Show-JuliaQuickStart'
    )

    # Private data
    PrivateData = @{
        PSData = @{
            Tags         = @('NOVA', 'Julia', 'Mathematics', 'Motoko', 'ICP', 'Sovereign')
            ProjectUri   = 'https://github.com/ItsNotAILABS/NOVA'
            LicenseUri   = 'https://github.com/ItsNotAILABS/NOVA/blob/main/LICENSE'
        }
    }
}
