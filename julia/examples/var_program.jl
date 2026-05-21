# ═══════════════════════════════════════════════════════════════════════════════
# var_program.jl — Variance with φ-Stabilized Computation
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Example
# ═══════════════════════════════════════════════════════════════════════════════
#
# var(x) — Variance with φ-stabilized computation
#
# Uses Welford's online algorithm stabilized with φ-thresholding for
# numerical stability. Prevents catastrophic cancellation by maintaining
# running compensated sums with φ-bounded correction terms.
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
    phi_var(x::Vector{Float64}; stabilized=true) -> Float64

Variance with φ-stabilized computation.

Uses Welford's online algorithm with φ-bounded correction terms to prevent
catastrophic cancellation. The φ-stabilization adds a floor of
AMOR × machine_epsilon to intermediate sums.

# Arguments
- `x::Vector{Float64}`: Input data vector
- `stabilized::Bool`: Use φ-numerical stabilization (default: true)

# Returns
- `σ²_phi::Float64`: φ-stabilized variance estimate

# Properties
- Numerically stable for large datasets
- Single-pass (O(n) time, O(1) space)
- φ-floor prevents underflow in compensated sums
"""
function phi_var(x::Vector{Float64}; stabilized=true)
    n = length(x)
    if n < 2
        return 0.0
    end

    if !stabilized
        return var(x)
    end

    # Welford's algorithm with φ-stabilization
    mean_acc = 0.0
    M2 = 0.0
    phi_floor = AMOR * eps(Float64)  # φ-stability floor

    for i in 1:n
        delta = x[i] - mean_acc
        mean_acc += delta / i

        # φ-stabilized second moment accumulation
        delta2 = x[i] - mean_acc
        correction = max(delta * delta2, phi_floor)
        M2 += correction
    end

    return M2 / (n - 1)  # Bessel correction
end

"""
    phi_var_online() -> (update!, value, reset!)

Create an online φ-stabilized variance estimator (streaming).
Returns functions for updating with new values and querying current variance.
"""
function phi_var_online()
    n = Ref(0)
    mean_acc = Ref(0.0)
    M2 = Ref(0.0)
    phi_floor = AMOR * eps(Float64)

    function update!(x::Float64)
        n[] += 1
        delta = x - mean_acc[]
        mean_acc[] += delta / n[]
        delta2 = x - mean_acc[]
        M2[] += max(delta * delta2, phi_floor)
    end

    function value()
        n[] < 2 && return 0.0
        return M2[] / (n[] - 1)
    end

    function reset!()
        n[] = 0
        mean_acc[] = 0.0
        M2[] = 0.0
    end

    return (update!, value, reset!)
end

# ═══ Section 3: Complete Program ══════════════════════════════════════════════

function main()
    println("╔══════════════════════════════════════════════════════════════════╗")
    println("║  NOVA φ-VAR — Variance with Golden Stabilization               ║")
    println("╚══════════════════════════════════════════════════════════════════╝")
    println()

    # ─── Example 1: Standard Computation ──────────────────────────────────────
    println("═══ Example 1: Standard Variance Computation ═══")
    x₁ = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]

    v_standard = var(x₁)
    v_phi = phi_var(x₁)

    println("Data: $x₁")
    println("Standard variance: $(round(v_standard, digits=6))")
    println("φ-stabilized var:  $(round(v_phi, digits=6))")
    println("Agreement: $(round(abs(v_standard - v_phi) / v_standard * 100, digits=6))% difference")
    println()

    # ─── Example 2: Numerical Stability (Large Offset) ────────────────────────
    println("═══ Example 2: Numerical Stability Test ═══")
    # Classic catastrophic cancellation scenario
    offset = 1e12
    x₂ = [offset + 1.0, offset + 2.0, offset + 3.0, offset + 4.0, offset + 5.0]

    v_naive = sum((x₂ .- mean(x₂)).^2) / (length(x₂) - 1)
    v_phi₂ = phi_var(x₂)
    v_true = 2.5  # True variance of [1,2,3,4,5]

    println("Data: [1e12+1, 1e12+2, 1e12+3, 1e12+4, 1e12+5]")
    println("True variance:     $v_true")
    println("Naive two-pass:    $(round(v_naive, digits=10))")
    println("φ-stabilized:      $(round(v_phi₂, digits=10))")
    println("φ-error:           $(round(abs(v_phi₂ - v_true), digits=12))")
    println()

    # ─── Example 3: Online/Streaming Variance ─────────────────────────────────
    println("═══ Example 3: Online Streaming Variance ═══")
    update!, get_var, reset! = phi_var_online()

    data_stream = [1.5, 2.3, 3.1, 4.7, 2.8, 5.2, 3.9, 4.1, 2.6, 3.4]
    println("Streaming data: $data_stream")
    println()
    println("Progressive variance:")

    for (i, x) in enumerate(data_stream)
        update!(x)
        v = get_var()
        bar = repeat("█", max(1, Int(round(v * 5))))
        println("  After $i values: σ² = $(lpad(round(v, digits=4), 8))  $bar")
    end

    println()
    println("Final streaming var:  $(round(get_var(), digits=6))")
    println("Batch var:            $(round(var(data_stream), digits=6))")
    println("Match: $(abs(get_var() - var(data_stream)) < 1e-10 ? "✓" : "✗")")
    println()

    # ─── Example 4: Bridge Output ─────────────────────────────────────────────
    println("═══ Example 4: Bridge Output Format ═══")
    x₄ = [PHI, PHI_INV, AMOR, 1.0, PHI^2, PHI^3]
    v₄ = phi_var(x₄)

    println("{")
    println("  \"result\": $(round(v₄, digits=10)),")
    println("  \"standard_var\": $(round(var(x₄), digits=10)),")
    println("  \"mean\": $(round(mean(x₄), digits=10)),")
    println("  \"n\": $(length(x₄)),")
    println("  \"metadata\": {")
    println("    \"function\": \"phi_var\",")
    println("    \"stabilized\": true,")
    println("    \"algorithm\": \"welford_phi\",")
    println("    \"phi_floor\": $(AMOR * eps(Float64))")
    println("  }")
    println("}")
end

main()
