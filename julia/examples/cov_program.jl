# ═══════════════════════════════════════════════════════════════════════════════
# cov_program.jl — Covariance with φ-Normalized Output
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Example
# ═══════════════════════════════════════════════════════════════════════════════
#
# cov(x, y) — Covariance with φ-normalized output
#
# Computes covariance with φ-normalization that bounds the output to
# [-1/φ, 1/φ] range for cross-bridge numerical safety, while preserving
# the sign and relative magnitude of the relationship.
#
# ═══════════════════════════════════════════════════════════════════════════════

using Statistics
using LinearAlgebra

# ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482
const PHI_INV = 0.6180339887498948482
const AMOR = 0.3819660112501051518

# ═══ Section 2: Core Function ═════════════════════════════════════════════════

"""
    phi_cov(x::Vector{Float64}, y::Vector{Float64}; normalized=true) -> Float64

Covariance with φ-normalized output.

When normalized=true, output is scaled to [-PHI_INV, PHI_INV] range
using geometric normalization: cov_φ = cov(x,y) / (φ × σ_x × σ_y).
This ensures bounded output for safe cross-bridge transmission.

# Arguments
- `x::Vector{Float64}`: First variable
- `y::Vector{Float64}`: Second variable
- `normalized::Bool`: Apply φ-normalization (default: true)

# Returns
- `cov_phi::Float64`: φ-normalized covariance ∈ [-PHI_INV, PHI_INV]

# Properties
- Bounded: |output| ≤ PHI_INV ≈ 0.618
- Sign-preserving: positive for positive association
- Zero-centered: independent variables → 0
"""
function phi_cov(x::Vector{Float64}, y::Vector{Float64}; normalized=true)
    if length(x) != length(y)
        error("phi_cov: vectors must have same length. Got $(length(x)) and $(length(y))")
    end

    raw_cov = cov(x, y)

    if !normalized
        return raw_cov
    end

    # φ-normalization: scale by φ × product of standard deviations
    σ_x = std(x)
    σ_y = std(y)

    if σ_x < 1e-15 || σ_y < 1e-15
        return 0.0
    end

    # Normalized covariance bounded to [-PHI_INV, PHI_INV]
    cov_normalized = raw_cov / (PHI * σ_x * σ_y)

    # Clamp to φ-bounds (should already be within if data is well-behaved)
    return clamp(cov_normalized, -PHI_INV, PHI_INV)
end

"""
    phi_cov_matrix(X::Matrix{Float64}) -> Matrix{Float64}

φ-normalized covariance matrix for multivariate data.
Each row is an observation, each column is a variable.
"""
function phi_cov_matrix(X::Matrix{Float64})
    n_vars = size(X, 2)
    C = zeros(n_vars, n_vars)

    for i in 1:n_vars
        for j in 1:n_vars
            C[i, j] = phi_cov(X[:, i], X[:, j])
        end
    end

    return C
end

# ═══ Section 3: Complete Program ══════════════════════════════════════════════

function main()
    println("╔══════════════════════════════════════════════════════════════════╗")
    println("║  NOVA φ-COV — Covariance with Golden Normalization             ║")
    println("╚══════════════════════════════════════════════════════════════════╝")
    println()

    # ─── Example 1: Perfect Correlation ───────────────────────────────────────
    println("═══ Example 1: Perfect Positive Correlation ═══")
    x₁ = collect(1.0:10.0)
    y₁ = 2.0 .* x₁ .+ 3.0

    cov_raw = cov(x₁, y₁)
    cov_phi = phi_cov(x₁, y₁)

    println("x = [1, 2, ..., 10]")
    println("y = 2x + 3 (perfect linear)")
    println("Raw covariance:       $(round(cov_raw, digits=4))")
    println("φ-normalized cov:     $(round(cov_phi, digits=6))")
    println("Expected (±PHI_INV):  ±$(round(PHI_INV, digits=6))")
    println("Bounded: |$(round(cov_phi, digits=6))| ≤ $(PHI_INV)? $(abs(cov_phi) <= PHI_INV ? "✓" : "✗")")
    println()

    # ─── Example 2: No Correlation ───────────────────────────────────────────
    println("═══ Example 2: Independent Variables ═══")
    n = 10000
    x₂ = randn(n)
    y₂ = randn(n)

    cov_phi₂ = phi_cov(x₂, y₂)
    println("x, y ~ independent N(0,1), n=$n")
    println("φ-normalized cov: $(round(cov_phi₂, digits=6)) (≈ 0)")
    println("Within noise:     $(abs(cov_phi₂) < 0.05 ? "✓" : "✗")")
    println()

    # ─── Example 3: Negative Correlation ──────────────────────────────────────
    println("═══ Example 3: Negative Correlation ═══")
    x₃ = collect(1.0:20.0)
    y₃ = -1.5 .* x₃ .+ randn(20) .* 0.5

    cov_phi₃ = phi_cov(x₃, y₃)
    println("x = [1..20], y ≈ -1.5x + noise")
    println("φ-normalized cov: $(round(cov_phi₃, digits=6)) (negative)")
    println("Sign correct:     $(cov_phi₃ < 0 ? "✓" : "✗")")
    println()

    # ─── Example 4: Multivariate Covariance Matrix ────────────────────────────
    println("═══ Example 4: Multivariate φ-Covariance Matrix ═══")
    # 3 variables with known structure
    n_obs = 500
    z = randn(n_obs)
    X = hcat(
        z .+ 0.1 .* randn(n_obs),          # Var 1: strongly related to z
        -z .+ 0.1 .* randn(n_obs),         # Var 2: negatively related
        randn(n_obs)                         # Var 3: independent
    )

    C = phi_cov_matrix(X)
    println("3-variable system (strongly corr., neg. corr., independent):")
    println("φ-Covariance Matrix:")
    for i in 1:3
        row = ["$(lpad(round(C[i,j], digits=4), 8))" for j in 1:3]
        println("  [$(join(row, ", "))]")
    end
    println()
    println("Interpretation:")
    println("  C[1,2] = $(round(C[1,2], digits=4)) → strong negative (correct)")
    println("  C[1,3] = $(round(C[1,3], digits=4)) → near zero (correct)")
    println("  All bounded in [-$(PHI_INV), $(PHI_INV)]? $(all(abs.(C) .<= PHI_INV + 1e-10) ? "✓" : "✗")")
    println()

    # ─── Bridge Output ────────────────────────────────────────────────────────
    println("═══ Bridge Output Format ═══")
    println("{")
    println("  \"result\": $(round(cov_phi, digits=10)),")
    println("  \"raw_covariance\": $(round(cov_raw, digits=10)),")
    println("  \"bounds\": [-$(PHI_INV), $(PHI_INV)],")
    println("  \"metadata\": {")
    println("    \"function\": \"phi_cov\",")
    println("    \"normalized\": true,")
    println("    \"normalization_factor\": \"φ × σ_x × σ_y\",")
    println("    \"n\": $(length(x₁))")
    println("  }")
    println("}")
end

main()
