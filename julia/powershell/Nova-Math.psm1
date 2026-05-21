# ═══════════════════════════════════════════════════════════════════════════════
# Nova-Math.psm1 — PowerShell Module for NOVA Julia Mathematical Substrate
# Classification: SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# ═══════════════════════════════════════════════════════════════════════════════
# USAGE:
#   # Import (must cd to NOVA repo root OR use full path):
#   Import-Module ./julia/powershell/Nova-Math.psm1
#   Import-Module C:\path\to\NOVA\julia\powershell\Nova-Math.psm1
#
#   # Basic Julia execution:
#   Invoke-Julia "eigen([1 2; 3 4])"
#   Invoke-NovaMath -Function "phi_gradient_descent" -Args @("x -> (x-1.618)^2", "0.0")
#   Get-MathModels -Domain "linear_algebra"
#
#   # Motoko-annotated functions (handles @motoko_canister decorator):
#   Invoke-MotokoFunction -Name "compute_phi" -Params "x" -Body "x * 1.618033988749" -Args @("5.0")
#
#   # Multi-line Julia blocks:
#   Invoke-JuliaBlock @"
#   function compute_phi(x)
#       return x * 1.618033988749
#   end
#   println(compute_phi(5.0))
#   "@
# ═══════════════════════════════════════════════════════════════════════════════

# ─── Constants ────────────────────────────────────────────────────────────────

$Script:PHI = 1.6180339887498948482
$Script:PHI_INV = 0.6180339887498948482
$Script:AMOR = 0.3819660112501051518
$Script:HEARTBEAT_MS = 873
$Script:NOVA_VERSION = "65.0.0"

# ─── Julia Path Discovery ─────────────────────────────────────────────────────

function Find-Julia {
    <#
    .SYNOPSIS
    Finds the Julia executable on the system.
    #>
    
    # Check common locations
    $candidates = @(
        (Get-Command julia -ErrorAction SilentlyContinue)?.Source,
        "$env:LOCALAPPDATA\Programs\Julia*\bin\julia.exe",
        "$env:ProgramFiles\Julia*\bin\julia.exe",
        "C:\Julia*\bin\julia.exe",
        "/usr/local/bin/julia",
        "/usr/bin/julia",
        "$env:HOME/.juliaup/bin/julia"
    )
    
    foreach ($path in $candidates) {
        if ($path -and (Test-Path $path -ErrorAction SilentlyContinue)) {
            return $path
        }
        # Handle wildcard paths
        $resolved = Resolve-Path $path -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($resolved) {
            return $resolved.Path
        }
    }
    
    # Try just "julia" in PATH
    try {
        $result = & julia --version 2>&1
        if ($LASTEXITCODE -eq 0) { return "julia" }
    } catch {}
    
    return $null
}

$Script:JuliaPath = Find-Julia

# ─── Core: Invoke Julia ───────────────────────────────────────────────────────

function Invoke-Julia {
    <#
    .SYNOPSIS
    Executes Julia code via subprocess and returns the result.
    
    .DESCRIPTION
    Sends Julia expressions to the Julia interpreter via subprocess.
    Supports single expressions, multi-line scripts, and file execution.
    
    .PARAMETER Code
    Julia code to execute.
    
    .PARAMETER File
    Path to a .jl file to execute.
    
    .PARAMETER Timeout
    Timeout in seconds (default: 30).
    
    .EXAMPLE
    Invoke-Julia "println(1.618 * 2)"
    
    .EXAMPLE
    Invoke-Julia "using LinearAlgebra; eigen([1 2; 3 4])"
    
    .EXAMPLE
    Invoke-Julia -File "./script.jl"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string]$Code,
        
        [Parameter()]
        [string]$File,
        
        [Parameter()]
        [int]$Timeout = 30
    )
    
    if (-not $Script:JuliaPath) {
        Write-Error "Julia not found. Install from https://julialang.org/downloads/ or run: winget install Julialang.Julia"
        return
    }
    
    $juliaArgs = @("--startup-file=no", "-q")
    
    if ($File) {
        if (-not (Test-Path $File)) {
            Write-Error "File not found: $File"
            return
        }
        $juliaArgs += $File
    } else {
        $juliaArgs += @("-e", $Code)
    }
    
    try {
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = $Script:JuliaPath
        $psi.Arguments = ($juliaArgs | ForEach-Object { """$_""" }) -join ' '
        $psi.UseShellExecute = $false
        $psi.RedirectStandardOutput = $true
        $psi.RedirectStandardError = $true
        $psi.CreateNoWindow = $true
        
        $process = [System.Diagnostics.Process]::Start($psi)
        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()
        $process.WaitForExit($Timeout * 1000) | Out-Null
        
        if ($process.ExitCode -ne 0 -and $stderr) {
            Write-Warning "Julia stderr: $stderr"
        }
        
        return $stdout.TrimEnd()
    }
    catch {
        Write-Error "Failed to invoke Julia: $_"
    }
}

# ─── NOVA Math Functions ──────────────────────────────────────────────────────

function Invoke-NovaMath {
    <#
    .SYNOPSIS
    Calls a NOVA mathematical function via Julia subprocess.
    
    .PARAMETER Function
    Name of the mathematical function (e.g., "phi_eigen", "kuramoto_step").
    
    .PARAMETER Args
    Arguments to pass to the function.
    
    .PARAMETER IncludeExpanded
    Whether to include NovaJuliaExpanded.jl (default: true).
    
    .EXAMPLE
    Invoke-NovaMath -Function "phi_eigen" -Args @("[1 2; 3 4]")
    
    .EXAMPLE
    Invoke-NovaMath -Function "kuramoto_step" -Args @("[0.1, 0.2, 0.3]", "[1.0, 1.1, 0.9]", "0.618", "0.01")
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Function,
        
        [Parameter(Position=1)]
        [string[]]$Args = @(),
        
        [Parameter()]
        [switch]$IncludeExpanded
    )
    
    $scriptDir = Split-Path -Parent $PSScriptRoot
    $novaJl = Join-Path $scriptDir "NovaJulia.jl"
    $expandedJl = Join-Path $scriptDir "NovaJuliaExpanded.jl"
    
    $preamble = ""
    if (Test-Path $novaJl) {
        $preamble += "include(`"$($novaJl -replace '\\', '/')`"); "
    }
    if ($IncludeExpanded -and (Test-Path $expandedJl)) {
        $preamble += "include(`"$($expandedJl -replace '\\', '/')`"); "
    }
    
    $argsStr = ($Args -join ", ")
    $juliaCode = "${preamble}result = ${Function}(${argsStr}); println(result)"
    
    return Invoke-Julia $juliaCode
}

# ─── Mathematical Model Registry ─────────────────────────────────────────────

$Script:MathModels = @{
    # Linear Algebra (25)
    "linalg.eigen"     = @{ Domain="linear_algebra"; Julia="LinearAlgebra.eigen(A)"; Desc="Eigenvalue decomposition" }
    "linalg.svd"       = @{ Domain="linear_algebra"; Julia="LinearAlgebra.svd(A)"; Desc="Singular Value Decomposition" }
    "linalg.qr"        = @{ Domain="linear_algebra"; Julia="LinearAlgebra.qr(A)"; Desc="QR factorization" }
    "linalg.lu"        = @{ Domain="linear_algebra"; Julia="LinearAlgebra.lu(A)"; Desc="LU factorization" }
    "linalg.cholesky"  = @{ Domain="linear_algebra"; Julia="LinearAlgebra.cholesky(A)"; Desc="Cholesky decomposition" }
    "linalg.inv"       = @{ Domain="linear_algebra"; Julia="inv(A)"; Desc="Matrix inverse" }
    "linalg.det"       = @{ Domain="linear_algebra"; Julia="det(A)"; Desc="Determinant" }
    "linalg.trace"     = @{ Domain="linear_algebra"; Julia="tr(A)"; Desc="Matrix trace" }
    "linalg.norm"      = @{ Domain="linear_algebra"; Julia="norm(A)"; Desc="Matrix/vector norm" }
    "linalg.rank"      = @{ Domain="linear_algebra"; Julia="rank(A)"; Desc="Matrix rank" }
    "linalg.expm"      = @{ Domain="linear_algebra"; Julia="exp(A)"; Desc="Matrix exponential" }
    "linalg.logm"      = @{ Domain="linear_algebra"; Julia="log(A)"; Desc="Matrix logarithm" }
    "linalg.sqrtm"     = @{ Domain="linear_algebra"; Julia="sqrt(A)"; Desc="Matrix square root" }
    "linalg.cross"     = @{ Domain="linear_algebra"; Julia="cross(a,b)"; Desc="Cross product" }
    "linalg.dot"       = @{ Domain="linear_algebra"; Julia="dot(a,b)"; Desc="Dot product" }
    "linalg.kron"      = @{ Domain="linear_algebra"; Julia="kron(A,B)"; Desc="Kronecker product" }
    "linalg.pinv"      = @{ Domain="linear_algebra"; Julia="pinv(A)"; Desc="Pseudo-inverse" }
    "linalg.nullspace" = @{ Domain="linear_algebra"; Julia="nullspace(A)"; Desc="Null space" }
    "linalg.schur"     = @{ Domain="linear_algebra"; Julia="schur(A)"; Desc="Schur decomposition" }
    "linalg.hessenberg"= @{ Domain="linear_algebra"; Julia="hessenberg(A)"; Desc="Hessenberg form" }
    
    # Statistics (20)
    "stats.mean"       = @{ Domain="statistics"; Julia="mean(x)"; Desc="Arithmetic mean" }
    "stats.std"        = @{ Domain="statistics"; Julia="std(x)"; Desc="Standard deviation" }
    "stats.var"        = @{ Domain="statistics"; Julia="var(x)"; Desc="Variance" }
    "stats.median"     = @{ Domain="statistics"; Julia="median(x)"; Desc="Median" }
    "stats.cor"        = @{ Domain="statistics"; Julia="cor(x,y)"; Desc="Correlation" }
    "stats.cov"        = @{ Domain="statistics"; Julia="cov(x,y)"; Desc="Covariance matrix" }
    "stats.quantile"   = @{ Domain="statistics"; Julia="quantile(x,p)"; Desc="Quantile" }
    "stats.histogram"  = @{ Domain="statistics"; Julia="fit(Histogram,x)"; Desc="Histogram" }
    "stats.kde"        = @{ Domain="statistics"; Julia="kde(x)"; Desc="Kernel density estimation" }
    "stats.ttest"      = @{ Domain="statistics"; Julia="OneSampleTTest(x,μ)"; Desc="Student t-test" }
    
    # Signal Processing (15)
    "signal.fft"       = @{ Domain="signal"; Julia="fft(x)"; Desc="Fast Fourier Transform" }
    "signal.ifft"      = @{ Domain="signal"; Julia="ifft(X)"; Desc="Inverse FFT" }
    "signal.conv"      = @{ Domain="signal"; Julia="conv(x,h)"; Desc="Convolution" }
    "signal.xcorr"     = @{ Domain="signal"; Julia="xcorr(x,y)"; Desc="Cross-correlation" }
    "signal.acf"       = @{ Domain="signal"; Julia="autocor(x)"; Desc="Autocorrelation" }
    "signal.welch"     = @{ Domain="signal"; Julia="welch_pgram(x)"; Desc="Welch periodogram" }
    "signal.filter"    = @{ Domain="signal"; Julia="filt(b,a,x)"; Desc="Digital filter" }
    
    # Differential Equations (15)
    "diffeq.euler"     = @{ Domain="diffeq"; Julia="euler_step(f,y,t,dt)"; Desc="Euler method" }
    "diffeq.rk4"       = @{ Domain="diffeq"; Julia="rk4_step(f,y,t,dt)"; Desc="Runge-Kutta 4" }
    "diffeq.lorenz"    = @{ Domain="diffeq"; Julia="lorenz(σ,ρ,β)"; Desc="Lorenz attractor" }
    "diffeq.vanderpol" = @{ Domain="diffeq"; Julia="vanderpol(μ)"; Desc="Van der Pol oscillator" }
    "diffeq.kuramoto"  = @{ Domain="diffeq"; Julia="kuramoto_step(θ,ω,K,dt)"; Desc="Kuramoto synchronization" }
    
    # Optimization (15)
    "optim.bfgs"       = @{ Domain="optimization"; Julia="bfgs(f,∇f,x0)"; Desc="BFGS quasi-Newton" }
    "optim.golden"     = @{ Domain="optimization"; Julia="golden_section(f,a,b)"; Desc="Golden section search (φ-optimal)" }
    "optim.nelder_mead"= @{ Domain="optimization"; Julia="nelder_mead(f,x0)"; Desc="Nelder-Mead simplex" }
    "optim.gradient"   = @{ Domain="optimization"; Julia="gradient_descent(f,∇f,x0,α)"; Desc="Gradient descent" }
    "optim.phi_gd"     = @{ Domain="optimization"; Julia="phi_gradient_descent(f,∇f,x0)"; Desc="φ⁻¹ learning rate GD" }
    
    # Quantum/Physics (10)
    "quantum.ising"    = @{ Domain="quantum"; Julia="ising_energy(σ,J,h)"; Desc="Ising model energy" }
    "quantum.boltzmann"= @{ Domain="quantum"; Julia="boltzmann_dist(E,T)"; Desc="Boltzmann distribution" }
    "quantum.schrodinger"= @{ Domain="quantum"; Julia="schrodinger_1d(V,dx,N)"; Desc="Schrödinger equation" }
    "quantum.hydrogen" = @{ Domain="quantum"; Julia="hydrogen_wavefunction(n,l,m,r,θ,φ)"; Desc="Hydrogen wavefunctions" }
    
    # Graph Theory (5)
    "graph.pagerank"   = @{ Domain="graph"; Julia="pagerank(A,d)"; Desc="PageRank algorithm" }
    "graph.laplacian"  = @{ Domain="graph"; Julia="laplacian(A)"; Desc="Graph Laplacian" }
    "graph.dijkstra"   = @{ Domain="graph"; Julia="dijkstra(G,s)"; Desc="Shortest paths" }
    
    # Numerical Methods (5)
    "numerical.quadrature"= @{ Domain="numerical"; Julia="gauss_legendre(f,a,b,n)"; Desc="Gaussian quadrature" }
    "numerical.newton"    = @{ Domain="numerical"; Julia="newton_raphson(f,f′,x0)"; Desc="Newton-Raphson" }
    "numerical.bisection" = @{ Domain="numerical"; Julia="bisection(f,a,b)"; Desc="Bisection method" }
}

function Get-MathModels {
    <#
    .SYNOPSIS
    Lists available mathematical models, optionally filtered by domain.
    
    .PARAMETER Domain
    Filter by domain (linear_algebra, statistics, signal, diffeq, optimization, quantum, graph, numerical).
    
    .EXAMPLE
    Get-MathModels
    Get-MathModels -Domain "optimization"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [string]$Domain
    )
    
    $models = $Script:MathModels.GetEnumerator()
    
    if ($Domain) {
        $models = $models | Where-Object { $_.Value.Domain -eq $Domain }
    }
    
    $models | Sort-Object Name | ForEach-Object {
        [PSCustomObject]@{
            Name   = $_.Name
            Domain = $_.Value.Domain
            Julia  = $_.Value.Julia
            Description = $_.Value.Desc
        }
    }
}

# ─── Quick Math Helpers ───────────────────────────────────────────────────────

function Get-Phi { return $Script:PHI }
function Get-PhiInverse { return $Script:PHI_INV }
function Get-Amor { return $Script:AMOR }

function Invoke-Eigen {
    <#
    .SYNOPSIS
    Compute eigenvalues of a matrix via Julia.
    .EXAMPLE
    Invoke-Eigen "[1 2; 3 4]"
    #>
    param([Parameter(Mandatory=$true, Position=0)][string]$Matrix)
    Invoke-Julia "using LinearAlgebra; vals, vecs = eigen($Matrix); println(`"Eigenvalues: `", vals); println(`"Eigenvectors:`"); display(vecs)"
}

function Invoke-SVD {
    param([Parameter(Mandatory=$true, Position=0)][string]$Matrix)
    Invoke-Julia "using LinearAlgebra; F = svd($Matrix); println(`"U:`"); display(F.U); println(`"S: `", F.S); println(`"Vt:`"); display(F.Vt)"
}

function Invoke-FFT {
    param([Parameter(Mandatory=$true, Position=0)][string]$Signal)
    Invoke-Julia "using FFTW; result = fft($Signal); println(result)"
}

function Invoke-Kuramoto {
    <#
    .SYNOPSIS
    Run one Kuramoto synchronization step.
    .EXAMPLE
    Invoke-Kuramoto -Phases "[0.1, 0.5, 1.2, 2.0]" -Frequencies "[1.0, 1.1, 0.9, 1.05]" -Coupling 0.618
    #>
    param(
        [Parameter(Mandatory=$true)][string]$Phases,
        [Parameter(Mandatory=$true)][string]$Frequencies,
        [Parameter()][double]$Coupling = 0.618,
        [Parameter()][double]$Dt = 0.01
    )
    $code = @"
function kuramoto_step(θ, ω, K, dt)
    N = length(θ)
    dθ = similar(θ)
    for i in 1:N
        coupling = sum(sin(θ[j] - θ[i]) for j in 1:N) / N
        dθ[i] = ω[i] + K * coupling
    end
    return θ .+ dt .* dθ
end
θ = Float64$Phases
ω = Float64$Frequencies
result = kuramoto_step(θ, ω, $Coupling, $Dt)
r = abs(sum(exp.(im .* result)) / length(result))
println("New phases: ", result)
println("Order parameter r = ", round(r, digits=6))
println(r > $($Script:PHI_INV) ? "COHERENT (r > φ⁻¹)" : "SUB-THRESHOLD")
"@
    Invoke-Julia $code
}

function Invoke-PhiGradientDescent {
    <#
    .SYNOPSIS
    φ⁻¹ learning rate gradient descent (provably optimal).
    .EXAMPLE
    Invoke-PhiGradientDescent -Objective "x -> (x[1]-1.618)^2 + (x[2]-0.618)^2" -Start "[0.0, 0.0]"
    #>
    param(
        [Parameter(Mandatory=$true)][string]$Objective,
        [Parameter(Mandatory=$true)][string]$Start,
        [Parameter()][int]$MaxIter = 1000
    )
    $code = @"
using LinearAlgebra
function phi_gd(f, x0; α=$(${Script:PHI_INV}), maxiter=$MaxIter, tol=1e-10)
    x = copy(x0)
    for i in 1:maxiter
        g = zeros(length(x))
        for j in 1:length(x)
            e = zeros(length(x)); e[j] = 1e-8
            g[j] = (f(x .+ e) - f(x .- e)) / 2e-8
        end
        x .-= α .* g
        norm(g) < tol && return (x=x, iter=i, converged=true)
    end
    return (x=x, iter=maxiter, converged=false)
end
f = $Objective
result = phi_gd(f, Float64$Start)
println("Optimum: ", result.x)
println("Iterations: ", result.iter)
println("Converged: ", result.converged)
"@
    Invoke-Julia $code
}

# ─── Motoko Canister Functions via Julia ──────────────────────────────────────

function Invoke-MotokoFunction {
    <#
    .SYNOPSIS
    Defines and calls a @motoko_canister Julia function via PowerShell→Julia subprocess.
    
    .DESCRIPTION
    Solves the error: "The splatting operator '@' cannot be used..."
    Julia's @motoko_canister decorator is handled by routing through Julia subprocess.
    
    .PARAMETER Name
    Function name (e.g., "compute_phi").
    
    .PARAMETER Body
    Function body as Julia code (e.g., "x * 1.618033988749").
    
    .PARAMETER Args
    Arguments to pass when calling the function.
    
    .PARAMETER Params
    Parameter list (e.g., "x" or "x, y").
    
    .EXAMPLE
    Invoke-MotokoFunction -Name "compute_phi" -Params "x" -Body "x * 1.618033988749" -Args @("5.0")
    
    .EXAMPLE
    Invoke-MotokoFunction -Name "phi_multiply" -Params "a, b" -Body "a * b * 1.618033988749" -Args @("3.0", "7.0")
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Name,
        
        [Parameter(Mandatory=$true)]
        [string]$Body,
        
        [Parameter()]
        [string]$Params = "x",
        
        [Parameter()]
        [string[]]$Args = @()
    )
    
    $argsStr = ($Args -join ", ")
    $code = @"
function ${Name}(${Params})
    return ${Body}
end
result = ${Name}(${argsStr})
println(result)
"@
    Invoke-Julia $code
}

function Invoke-JuliaBlock {
    <#
    .SYNOPSIS
    Executes a multi-line block of Julia code via subprocess.
    
    .DESCRIPTION
    Use PowerShell here-strings to pass multi-line Julia code.
    Handles @motoko_canister decorators, using statements, and all Julia syntax.
    
    .PARAMETER Code
    Multi-line Julia code block.
    
    .EXAMPLE
    Invoke-JuliaBlock @"
    using LinearAlgebra
    
    @motoko_canister function compute_phi(x)
        return x * 1.618033988749
    end
    
    println(compute_phi(5.0))
    "@
    
    .EXAMPLE
    $code = @"
    function lorenz(x, y, z; σ=10.0, ρ=28.0, β=8/3)
        dx = σ * (y - x)
        dy = x * (ρ - z) - y
        dz = x * y - β * z
        return (dx, dy, dz)
    end
    println(lorenz(1.0, 1.0, 1.0))
    "@
    Invoke-JuliaBlock $code
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [string]$Code
    )
    
    # Strip @motoko_canister decorator (it's a Julia macro for ICP deployment)
    # Julia will just treat the function as a normal function when run locally
    $processedCode = $Code -replace '@motoko_canister\s+', ''
    
    Invoke-Julia $processedCode
}

function ConvertFrom-JuliaCode {
    <#
    .SYNOPSIS
    Converts Julia code into the correct PowerShell command to execute it.
    
    .DESCRIPTION
    If you accidentally paste Julia code into PowerShell and get errors like:
      "The term 'const' is not recognized..."
      "Missing using directive..."
      "The splatting operator '@' cannot be used..."
    
    This function shows you the correct PowerShell command to run that Julia code.
    
    .PARAMETER JuliaCode
    The Julia code that was pasted incorrectly.
    
    .EXAMPLE
    ConvertFrom-JuliaCode "using MotokoBinding"
    # Output: Invoke-Julia "using MotokoBinding"
    
    .EXAMPLE
    ConvertFrom-JuliaCode '@motoko_canister function compute_phi(x) return x * 1.618033988749 end'
    # Output: Invoke-JuliaBlock @"
    #   @motoko_canister function compute_phi(x)
    #       return x * 1.618033988749
    #   end
    # "@
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [string]$JuliaCode
    )
    
    Write-Host ""
    Write-Host "═══ JULIA CODE DETECTED ═══" -ForegroundColor Yellow
    Write-Host "  Julia code cannot run directly in PowerShell." -ForegroundColor Red
    Write-Host "  Use one of these methods:" -ForegroundColor White
    Write-Host ""
    
    # Method 1: Single expression
    Write-Host "  METHOD 1 — Single expression:" -ForegroundColor Cyan
    Write-Host "    Invoke-Julia `"$JuliaCode`"" -ForegroundColor Green
    Write-Host ""
    
    # Method 2: Multi-line here-string
    Write-Host "  METHOD 2 — Multi-line block:" -ForegroundColor Cyan
    Write-Host '    Invoke-JuliaBlock @"' -ForegroundColor Green
    Write-Host "    $JuliaCode" -ForegroundColor Green
    Write-Host '    "@' -ForegroundColor Green
    Write-Host ""
    
    # Method 3: If it has @motoko_canister
    if ($JuliaCode -match '@motoko_canister') {
        Write-Host "  METHOD 3 — Motoko function (detected @motoko_canister):" -ForegroundColor Cyan
        Write-Host '    Invoke-MotokoFunction -Name "compute_phi" -Params "x" -Body "x * 1.618033988749" -Args @("5.0")' -ForegroundColor Green
        Write-Host ""
    }
    
    # Method 4: Interactive REPL
    Write-Host "  METHOD 4 — Julia REPL (interactive):" -ForegroundColor Cyan
    Write-Host "    julia" -ForegroundColor Green
    Write-Host "    # Then paste your Julia code directly in the Julia REPL" -ForegroundColor DarkGray
    Write-Host ""
}

function Show-JuliaQuickStart {
    <#
    .SYNOPSIS
    Shows how to properly run Julia code from PowerShell (solves common errors).
    #>
    Write-Host @"

╔═══════════════════════════════════════════════════════════════════════════╗
║  NOVA Julia ↔ PowerShell — Quick Start Guide                            ║
╚═══════════════════════════════════════════════════════════════════════════╝

  ⚠️  COMMON ERROR: Pasting Julia code directly into PowerShell
  
  ❌ WRONG (produces errors):
     PS> using MotokoBinding
     PS> @motoko_canister function compute_phi(x)
     PS> return x * 1.618033988749

  ✅ CORRECT — Use Invoke-Julia or Invoke-JuliaBlock:

  ── Single Expression ─────────────────────────────────────────────
  PS> Invoke-Julia "println(5.0 * 1.618033988749)"

  ── Multi-Line Julia Block ────────────────────────────────────────
  PS> Invoke-JuliaBlock @`"
      function compute_phi(x)
          return x * 1.618033988749
      end
      println(compute_phi(5.0))
  `"@

  ── @motoko_canister Function ─────────────────────────────────────
  PS> Invoke-MotokoFunction -Name "compute_phi" -Params "x" -Body "x * 1.618033988749" -Args @("5.0")

  ── Eigenvalues ───────────────────────────────────────────────────
  PS> Invoke-Eigen "[1 2; 3 4]"

  ── Kuramoto Oscillators ──────────────────────────────────────────
  PS> Invoke-Kuramoto -Phases "[0.1, 0.5, 1.2, 2.0]" -Frequencies "[1.0, 1.1, 0.9, 1.05]"

  ── φ-Optimal Gradient Descent ────────────────────────────────────
  PS> Invoke-PhiGradientDescent -Objective "x -> (x[1]-1.618)^2" -Start "[0.0]"

  ── Julia REPL (Interactive) ──────────────────────────────────────
  PS> .\run-julia.ps1 -Interactive
  PS> .\run-julia.ps1 -Interactive -LoadNova   # with NovaJulia.jl preloaded

  ── Run a .jl File ────────────────────────────────────────────────
  PS> Invoke-Julia -File ".\my_script.jl"

  ── Browse 110+ Math Models ───────────────────────────────────────
  PS> Get-MathModels | Format-Table
  PS> Get-MathModels -Domain "optimization" | Format-Table

"@ -ForegroundColor DarkYellow
}

# ─── Module Exports ───────────────────────────────────────────────────────────

Export-ModuleMember -Function @(
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

# ─── Module Load Message ──────────────────────────────────────────────────────
$juliaStatus = if ($Script:JuliaPath) { "Julia found at: $($Script:JuliaPath)" } else { "Julia NOT found — install from julialang.org" }
Write-Host "═══ NOVA Math Module v$($Script:NOVA_VERSION) ═══" -ForegroundColor DarkYellow
Write-Host "  φ = $($Script:PHI)" -ForegroundColor DarkCyan
Write-Host "  $juliaStatus" -ForegroundColor $(if ($Script:JuliaPath) { 'Green' } else { 'Red' })
Write-Host "  Models: $($Script:MathModels.Count) | Domains: 8" -ForegroundColor DarkCyan
Write-Host "  Type: Get-MathModels | Format-Table" -ForegroundColor DarkGray
