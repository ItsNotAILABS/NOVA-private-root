# ═══════════════════════════════════════════════════════════════════════════════
# cor_program.jl — Correlation Coefficient with φ-Bounds
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Example
# ═══════════════════════════════════════════════════════════════════════════════
#
# cor(x, y) — Correlation coefficient with φ-bounds
#
# Computes Pearson correlation with φ-bounded confidence assessment.
# Returns both the correlation and a φ-confidence score indicating whether
# the correlation exceeds PHI_INV (strong) or AMOR (moderate) threshold.
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
    phi_cor(x::Vector{Float64}, y::Vector{Float64}) -> (Float64, Symbol, Float64)

Correlation coefficient with φ-bounds classification.

Returns the Pearson correlation along with a φ-classification:
- :strong if |r| ≥ PHI_INV (≈ 0.618)
- :moderate if AMOR ≤ |r| < PHI_INV
- :weak if |r| < AMOR (≈ 0.382)

Also returns a φ-confidence score: |r| / PHI_INV (>1 means strong).

# Arguments
- `x::Vector{Float64}`: First variable
- `y::Vector{Float64}`: Second variable

# Returns
- `r::Float64`: Pearson correlation coefficient ∈ [-1, 1]
- `class::Symbol`: φ-classification (:strong, :moderate, :weak)
- `confidence::Float64`: φ-confidence score (|r| / PHI_INV)
"""
function phi_cor(x::Vector{Float64}, y::Vector{Float64})
    if length(x) != length(y)
        error("phi_cor: vectors must have same length")
    end

    r = cor(x, y)
    abs_r = abs(r)

    # φ-classification
    class = if abs_r >= PHI_INV
        :strong
    elseif abs_r >= AMOR
        :moderate
    else
        :weak
    end

    # φ-confidence: ratio to golden threshold
    confidence = abs_r / PHI_INV

    return (r, class, confidence)
end

"""
    phi_cor_matrix(X::Matrix{Float64}) -> (Matrix{Float64}, Matrix{Symbol})

φ-classified correlation matrix.
Returns both the correlation matrix and a classification matrix.
"""
function phi_cor_matrix(X::Matrix{Float64})
    n_vars = size(X, 2)
    R = cor(X)

    classes = Matrix{Symbol}(undef, n_vars, n_vars)
    for i in 1:n_vars, j in 1:n_vars
        abs_r = abs(R[i, j])
        classes[i, j] = abs_r >= PHI_INV ? :strong :
                        abs_r >= AMOR ? :moderate : :weak
    end

    return (R, classes)
end

# ═══ Section 3: Complete Program ══════════════════════════════════════════════

function main()
    println("╔══════════════════════════════════════════════════════════════════╗")
    println("║  NOVA φ-COR — Correlation with Golden Bounds Classification    ║")
    println("╚══════════════════════════════════════════════════════════════════╝")
    println()

    # ─── Example 1: Strong Positive Correlation ───────────────────────────────
    println("═══ Example 1: Strong Positive Correlation ═══")
    x₁ = collect(1.0:50.0)
    y₁ = 2.5 .* x₁ .+ randn(50) .* 2.0

    r, class, conf = phi_cor(x₁, y₁)
    println("y ≈ 2.5x + noise(σ=2)")
    println("Pearson r:      $(round(r, digits=6))")
    println("φ-class:        $class")
    println("φ-confidence:   $(round(conf, digits=4)) (>1 = exceeds golden threshold)")
    println("Thresholds:     strong ≥ $(PHI_INV), moderate ≥ $(AMOR)")
    println()

    # ─── Example 2: Weak Correlation ─────────────────────────────────────────
    println("═══ Example 2: Weak Correlation ═══")
    x₂ = randn(200)
    y₂ = 0.1 .* x₂ .+ randn(200) .* 3.0

    r₂, class₂, conf₂ = phi_cor(x₂, y₂)
    println("y ≈ 0.1x + noise(σ=3) [signal buried in noise]")
    println("Pearson r:      $(round(r₂, digits=6))")
    println("φ-class:        $class₂")
    println("φ-confidence:   $(round(conf₂, digits=4)) (<1 = below golden threshold)")
    println()

    # ─── Example 3: φ-Boundary Cases ─────────────────────────────────────────
    println("═══ Example 3: φ-Boundary Demonstrations ═══")
    n = 100
    t = collect(1:n) ./ n

    # Construct correlations near φ-thresholds
    cases = [
        ("r ≈ 0.95 (strong)", t, t .+ randn(n) .* 0.1),
        ("r ≈ 0.62 (≈PHI_INV boundary)", t, t .+ randn(n) .* 0.9),
        ("r ≈ 0.38 (≈AMOR boundary)", t, t .+ randn(n) .* 2.0),
        ("r ≈ 0.10 (weak)", t, t .+ randn(n) .* 8.0),
    ]

    for (label, xi, yi) in cases
        ri, ci, confi = phi_cor(xi, yi)
        indicator = ci == :strong ? "████" : ci == :moderate ? "██░░" : "░░░░"
        println("  $label → r=$(lpad(round(ri, digits=3), 6)), class=$(lpad(ci, 9)), conf=$(round(confi, digits=3))  [$indicator]")
    end
    println()
    println("  Golden thresholds: |— weak —|— moderate —|— strong —|")
    println("                     0       $AMOR        $PHI_INV        1")
    println()

    # ─── Example 4: Multivariate Correlation Matrix ───────────────────────────
    println("═══ Example 4: φ-Classified Correlation Matrix ═══")
    n_obs = 300
    base = randn(n_obs)
    X = hcat(
        base,                                    # Var A
        0.9 .* base .+ 0.1 .* randn(n_obs),     # Var B: strongly correlated
        0.4 .* base .+ 0.6 .* randn(n_obs),     # Var C: moderately correlated
        randn(n_obs)                             # Var D: independent
    )

    R, classes = phi_cor_matrix(X)
    labels = ["A", "B", "C", "D"]

    println("     ", join([lpad(l, 9) for l in labels]))
    for i in 1:4
        row = [" $(round(R[i,j], digits=3))($(first(string(classes[i,j]))))" for j in 1:4]
        println("  $(labels[i])  $(join(row))")
    end
    println()
    println("  Legend: (s)=strong, (m)=moderate, (w)=weak")
    println()

    # ─── Bridge Output ────────────────────────────────────────────────────────
    println("═══ Bridge Output Format ═══")
    println("{")
    println("  \"correlation\": $(round(r, digits=10)),")
    println("  \"classification\": \"$class\",")
    println("  \"phi_confidence\": $(round(conf, digits=6)),")
    println("  \"thresholds\": {")
    println("    \"strong\": $PHI_INV,")
    println("    \"moderate\": $AMOR,")
    println("    \"weak\": 0")
    println("  },")
    println("  \"metadata\": {")
    println("    \"function\": \"phi_cor\",")
    println("    \"n\": $(length(x₁)),")
    println("    \"p_value_approx\": $(round(2 * (1 - 0.5 * erfc(-abs(r) * sqrt(length(x₁)-2) / sqrt(1-r^2) / sqrt(2))), digits=8))")
    println("  }")
    println("}")
end

# Helper for approximate p-value
erfc(x) = 1 - erf(x)
function erf(x)
    # Approximation
    t = 1.0 / (1.0 + 0.5 * abs(x))
    tau = t * exp(-x^2 - 1.26551223 + 1.00002368*t + 0.37409196*t^2 +
                  0.09678418*t^3 - 0.18628806*t^4 + 0.27886807*t^5 -
                  1.13520398*t^6 + 1.48851587*t^7 - 0.82215223*t^8 + 0.17087277*t^9)
    return x >= 0 ? 1 - tau : tau - 1
end

main()
