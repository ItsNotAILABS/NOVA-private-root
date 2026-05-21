# ═══════════════════════════════════════════════════════════════════════════════
# run-julia.ps1 — Quick Julia runner for NOVA Mathematical Substrate
# 
# USAGE:
#   .\run-julia.ps1 "eigen([1 2; 3 4])"
#   .\run-julia.ps1 -File "NovaJulia.jl"
#   .\run-julia.ps1 -Interactive
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# ═══════════════════════════════════════════════════════════════════════════════

param(
    [Parameter(Position=0)]
    [string]$Expression,
    
    [Parameter()]
    [string]$File,
    
    [Parameter()]
    [switch]$Interactive,
    
    [Parameter()]
    [switch]$LoadNova,
    
    [Parameter()]
    [switch]$Help
)

# ─── Help ─────────────────────────────────────────────────────────────────────

if ($Help) {
    Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║  NOVA Julia Runner — Mathematical Substrate Interface        ║
╚═══════════════════════════════════════════════════════════════╝

USAGE:
  .\run-julia.ps1 "expression"          Run a Julia expression
  .\run-julia.ps1 -File script.jl       Run a Julia file
  .\run-julia.ps1 -Interactive          Open Julia REPL
  .\run-julia.ps1 -LoadNova "expr"      Load NovaJulia.jl first

EXAMPLES:
  .\run-julia.ps1 "println(1.618 ^ 2)"
  .\run-julia.ps1 "using LinearAlgebra; eigen([1 2; 3 4])"
  .\run-julia.ps1 -LoadNova "phi_eigen([1 2; 3 4])"
  .\run-julia.ps1 -Interactive

MATHEMATICAL DOMAINS (110+ models):
  • Linear Algebra: eigen, svd, qr, lu, cholesky, inv, det, ...
  • Statistics: mean, std, cor, kde, ttest, ...
  • Signal Processing: fft, ifft, conv, xcorr, welch, ...
  • Differential Equations: lorenz, kuramoto, vanderpol, ...
  • Optimization: bfgs, golden_section, nelder_mead, phi_gd, ...
  • Quantum/Physics: ising, boltzmann, schrodinger, ...
  • Graph Theory: pagerank, laplacian, dijkstra, ...
  • Numerical Methods: quadrature, newton, bisection, ...

φ = 1.6180339887498948482 (golden ratio — sovereign constant)

"@ -ForegroundColor DarkYellow
    return
}

# ─── Find Julia ───────────────────────────────────────────────────────────────

$juliaPath = $null
$candidates = @(
    (Get-Command julia -ErrorAction SilentlyContinue)?.Source
)

# Add Windows-specific paths
if ($IsWindows -or $env:OS -eq "Windows_NT") {
    $candidates += @(
        "$env:LOCALAPPDATA\Programs\Julia*\bin\julia.exe",
        "$env:ProgramFiles\Julia*\bin\julia.exe",
        "C:\Julia*\bin\julia.exe"
    )
}

foreach ($candidate in $candidates) {
    if ($candidate) {
        $resolved = Resolve-Path $candidate -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($resolved) {
            $juliaPath = $resolved.Path
            break
        }
        if (Test-Path $candidate -ErrorAction SilentlyContinue) {
            $juliaPath = $candidate
            break
        }
    }
}

if (-not $juliaPath) {
    # Last try: just call julia
    try {
        $null = & julia --version 2>&1
        if ($LASTEXITCODE -eq 0) { $juliaPath = "julia" }
    } catch {}
}

if (-not $juliaPath) {
    Write-Host "ERROR: Julia not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Install Julia:" -ForegroundColor Yellow
    Write-Host "  winget install Julialang.Julia" -ForegroundColor Cyan
    Write-Host "  — or —" -ForegroundColor DarkGray
    Write-Host "  https://julialang.org/downloads/" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "After installing, restart PowerShell." -ForegroundColor Yellow
    exit 1
}

Write-Host "Julia: $juliaPath" -ForegroundColor DarkGray

# ─── Interactive Mode ─────────────────────────────────────────────────────────

if ($Interactive) {
    Write-Host "Starting Julia REPL..." -ForegroundColor Green
    if ($LoadNova) {
        $scriptDir = Split-Path -Parent $PSScriptRoot
        $novaJl = Join-Path (Split-Path -Parent $PSCommandPath) "..\NovaJulia.jl"
        if (Test-Path $novaJl) {
            & $juliaPath --startup-file=no -i -e "include(`"$($novaJl -replace '\\','/')`"); println(`"NovaJulia.jl loaded. φ = `", PHI)"
        } else {
            & $juliaPath
        }
    } else {
        & $juliaPath
    }
    return
}

# ─── File Execution ───────────────────────────────────────────────────────────

if ($File) {
    if (-not (Test-Path $File)) {
        Write-Error "File not found: $File"
        exit 1
    }
    & $juliaPath --startup-file=no $File
    return
}

# ─── Expression Execution ─────────────────────────────────────────────────────

if (-not $Expression) {
    Write-Host "No expression provided. Use -Help for usage information." -ForegroundColor Yellow
    return
}

$code = $Expression

# Optionally prepend NovaJulia include
if ($LoadNova) {
    $novaJl = Join-Path (Split-Path -Parent $PSCommandPath) "..\NovaJulia.jl"
    if (Test-Path $novaJl) {
        $novaPath = ($novaJl -replace '\\', '/')
        $code = "include(`"$novaPath`"); $code"
    }
}

& $juliaPath --startup-file=no -q -e $code
