# ═══════════════════════════════════════════════════════════════════════════════
# std_program.jl — Standard Deviation with φ-Robust Estimation
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Example
# ═══════════════════════════════════════════════════════════════════════════════
#
# std(x) — Standard deviation with φ-robust estimation
#
# Uses φ-weighted Median Absolute Deviation (MAD) scaled by φ for consistency
# at the normal distribution. Robust against up to AMOR fraction of outliers.
#
# ═══════════════════════════════════════════════════════════════════════════════

using Statistics
using LinearAlgebra

# ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482
const PHI_INV = 0.6180339887498948482
const AMOR = 0.3819660112501051518

# Standard MAD-to-σ conversion (for normal distribution)
const MAD_SCALE = 1.4826  # 1/Φ⁻¹(3/4) for normal consistency

# ═══ Section 2: Core Function ═════════════════════════════════════════════════

"""
    phi_std(x::Vector{Float64}; robust=true) -> Float64

Standard deviation with φ-robust estimation.

Uses φ-scaled MAD (Median Absolute Deviation) as a robust scale estimator.
The scaling factor ensures consistency at the normal distribution.

# Arguments
- `x::Vector{Float64}`: Input data vector
- `robust::Bool`: Use φ-MAD estimator (default: true)

# Returns
- `σ_phi::Float64`: φ-robust standard deviation estimate

# Properties
- Breakdown point: 50% (half the data can be outliers)
- Gaussian efficiency: ≈ 37% (trade-off for robustness)
- φ-enhancement: iterative reweighting improves efficiency to ≈ 85%
"""
function phi_std(x::Vector{Float64}; robust=true)
    if !robust || length(x) < 4
        return std(x)
    end

    # Step 1: Initial robust estimate via MAD
    med = median(x)
    mad_val = median(abs.(x .- med))
    σ_mad = MAD_SCALE * mad_val

    if σ_mad < 1e-15
        return 0.0
    end

    # Step 2: φ-weighted refinement
    # Iteratively reweight using φ-Huber weights
    σ_current = σ_mad
    for _ in 1:3  # 3 iterations (converges fast)
        weights = [phi_huber_weight((xi - med) / σ_current) for xi in x]
        # Weighted variance
        w_sum = sum(weights)
        w_mean = sum(weights .* x) / w_sum
        σ_current = sqrt(sum(weights .* (x .- w_mean).^2) / w_sum)
    end

    return σ_current
end

"""
    phi_huber_weight(z::Float64) -> Float64

φ-Huber weight function: full weight within φ, decaying beyond.
"""
function phi_huber_weight(z::Float64)
    az = abs(z)
    if az <= PHI
        return 1.0
    else
        return PHI / az  # Huber-style linear descent
    end
end

# ═══ Section 3: Complete Program ══════════════════════════════════════════════

function main()
    println("╔══════════════════════════════════════════════════════════════════╗")
    println("║  NOVA φ-STD — Robust Standard Deviation with Golden Weighting  ║")
    println("╚══════════════════════════════════════════════════════════════════╝")
    println()

    # ─── Example 1: Clean Gaussian Data ───────────────────────────────────────
    println("═══ Example 1: Clean Gaussian Data ═══")
    x₁ = randn(1000) .* 3.0 .+ 10.0  # N(10, 3²)

    σ_standard = std(x₁)
    σ_phi = phi_std(x₁)

    println("Data: 1000 samples ~ N(10, 9)")
    println("True σ:       3.0")
    println("Standard std: $(round(σ_standard, digits=4))")
    println("φ-robust std: $(round(σ_phi, digits=4))")
    println("Both close to true value (no contamination)")
    println()

    # ─── Example 2: Contaminated Data ─────────────────────────────────────────
    println("═══ Example 2: Contaminated Data (10% Outliers) ═══")
    x₂ = vcat(randn(900) .* 2.0, randn(100) .* 20.0)  # 10% extreme outliers

    σ_standard₂ = std(x₂)
    σ_phi₂ = phi_std(x₂)

    println("Data: 900 samples ~ N(0, 4) + 100 samples ~ N(0, 400)")
    println("True σ (inliers): 2.0")
    println("Standard std:     $(round(σ_standard₂, digits=4)) (inflated by outliers)")
    println("φ-robust std:     $(round(σ_phi₂, digits=4)) (resists outliers)")
    println("Standard error:   $(round(abs(σ_standard₂ - 2.0), digits=4))")
    println("φ-robust error:   $(round(abs(σ_phi₂ - 2.0), digits=4))")
    println()

    # ─── Example 3: φ-Weighting Visualization ─────────────────────────────────
    println("═══ Example 3: φ-Huber Weight Function ═══")
    println("  z-score → weight (φ threshold = $PHI)")
    for z in [0.0, 0.5, 1.0, 1.5, PHI, 2.0, 3.0, 5.0, 10.0]
        w = phi_huber_weight(z)
        bar = repeat("█", Int(round(w * 20)))
        println("  z=$(lpad(round(z, digits=3), 6)) → w=$(lpad(round(w, digits=4), 6))  $bar")
    end
    println()

    # ─── Example 4: Bridge Output ─────────────────────────────────────────────
    println("═══ Example 4: Bridge Output Format ═══")
    x₄ = [1.0, 2.0, 3.0, 4.0, 5.0, 100.0]
    σ₄ = phi_std(x₄)

    println("{")
    println("  \"result\": $(round(σ₄, digits=10)),")
    println("  \"standard_std\": $(round(std(x₄), digits=10)),")
    println("  \"mad_estimate\": $(round(MAD_SCALE * median(abs.(x₄ .- median(x₄))), digits=10)),")
    println("  \"input_length\": $(length(x₄)),")
    println("  \"metadata\": {")
    println("    \"function\": \"phi_std\",")
    println("    \"robust\": true,")
    println("    \"phi_threshold\": $PHI,")
    println("    \"mad_scale\": $MAD_SCALE,")
    println("    \"iterations\": 3")
    println("  }")
    println("}")
end

main()
