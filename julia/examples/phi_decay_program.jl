# ═══════════════════════════════════════════════════════════════════════════════
# phi_decay_program.jl — φ-Exponential Decay Function
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Example
# ═══════════════════════════════════════════════════════════════════════════════
#
# phiDecay(t, τ) — φ-exponential decay function
#
# f(t) = φ^(-t/τ) — decay governed by golden ratio
#
# Half-life occurs at t_½ = τ × ln(2) / ln(φ) ≈ 1.44τ
# The φ-decay is between exponential and power-law: optimal for
# memory retention in cognitive systems.
#
# ═══════════════════════════════════════════════════════════════════════════════

# ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482
const PHI_INV = 0.6180339887498948482
const AMOR = 0.3819660112501051518
const HEARTBEAT_MS = 873
const LN_PHI = log(PHI)  # ≈ 0.4812

# ═══ Section 2: Core Function ═════════════════════════════════════════════════

"""
    phi_decay(t::Float64, τ::Float64) -> Float64

φ-exponential decay function.

f(t) = φ^(-t/τ)

# Arguments
- `t::Float64`: Time (or any monotonically increasing variable)
- `τ::Float64`: Time constant (characteristic decay time)

# Returns
- `f_t::Float64`: Decay value ∈ (0, 1]

# Properties
- f(0) = 1 (full strength at t=0)
- f(τ) = φ⁻¹ ≈ 0.618 (retains 61.8% at t=τ)
- f(2τ) = φ⁻² = AMOR ≈ 0.382 (retains 38.2% at t=2τ)
- Half-life: t_½ = τ × ln(2)/ln(φ) ≈ 1.44τ
- Area under curve: τ/ln(φ) ≈ 2.078τ
"""
function phi_decay(t::Float64, τ::Float64)
    if τ <= 0
        error("phi_decay: τ must be positive, got $τ")
    end
    return PHI^(-t / τ)
end

"""
    phi_decay_integral(t::Float64, τ::Float64) -> Float64

Definite integral of φ-decay from 0 to t.
∫₀ᵗ φ^(-s/τ) ds = τ/ln(φ) × (1 - φ^(-t/τ))
"""
function phi_decay_integral(t::Float64, τ::Float64)
    return (τ / LN_PHI) * (1.0 - phi_decay(t, τ))
end

"""
    phi_decay_halflife(τ::Float64) -> Float64

Compute half-life for φ-decay with time constant τ.
t_½ = τ × ln(2) / ln(φ)
"""
function phi_decay_halflife(τ::Float64)
    return τ * log(2) / LN_PHI
end

"""
    phi_memory_weight(age::Float64, τ::Float64; threshold=AMOR) -> Float64

Memory weight function: returns φ-decay weight, or 0 if below threshold.
Used for attention/memory systems where old memories are forgotten.
"""
function phi_memory_weight(age::Float64, τ::Float64; threshold=AMOR)
    w = phi_decay(age, τ)
    return w >= threshold ? w : 0.0
end

"""
    phi_decay_series(t_values::Vector{Float64}, τ::Float64) -> Vector{Float64}

Compute φ-decay for a series of time values.
"""
function phi_decay_series(t_values::Vector{Float64}, τ::Float64)
    return [phi_decay(t, τ) for t in t_values]
end

# ═══ Section 3: Complete Program ══════════════════════════════════════════════

function main()
    println("╔══════════════════════════════════════════════════════════════════╗")
    println("║  NOVA φ-DECAY — Golden Ratio Exponential Decay                 ║")
    println("╚══════════════════════════════════════════════════════════════════╝")
    println()

    # ─── Example 1: Basic Decay Curve ─────────────────────────────────────────
    println("═══ Example 1: φ-Decay Curve (τ = 1.0) ═══")
    τ = 1.0
    println("f(t) = φ^(-t/τ), τ = $τ")
    println("Key values:")
    println("  f(0)  = $(phi_decay(0.0, τ))  (full)")
    println("  f(τ)  = $(round(phi_decay(τ, τ), digits=10))  = φ⁻¹")
    println("  f(2τ) = $(round(phi_decay(2τ, τ), digits=10))  = φ⁻² = AMOR")
    println("  f(3τ) = $(round(phi_decay(3τ, τ), digits=10))  = φ⁻³")
    println("  f(5τ) = $(round(phi_decay(5τ, τ), digits=10))  = φ⁻⁵")
    println()
    println("Decay curve:")
    for t in 0.0:0.5:5.0
        val = phi_decay(t, τ)
        bar_len = Int(round(val * 40))
        bar = repeat("█", bar_len) * repeat("░", 40 - bar_len)
        println("  t=$(lpad(round(t, digits=1), 4)) | $(bar) | $(round(val, digits=4))")
    end
    println()

    # ─── Example 2: Half-Life Comparison ──────────────────────────────────────
    println("═══ Example 2: φ-Decay vs Standard Exponential ═══")
    τ₂ = 2.0
    t_half_phi = phi_decay_halflife(τ₂)
    t_half_exp = τ₂ * log(2)  # Standard exp half-life

    println("Time constant τ = $τ₂")
    println("Half-life comparison:")
    println("  φ-decay:   t_½ = $(round(t_half_phi, digits=6)) (τ×ln2/lnφ)")
    println("  Exp decay: t_½ = $(round(t_half_exp, digits=6)) (τ×ln2)")
    println("  Ratio:     $(round(t_half_phi / t_half_exp, digits=6))")
    println()
    println("At t = τ:")
    println("  φ-decay:   $(round(phi_decay(τ₂, τ₂), digits=6))  (retains 61.8%)")
    println("  Exp decay: $(round(exp(-1), digits=6))  (retains 36.8%)")
    println("  φ-decay retains $(round((PHI_INV - exp(-1)) * 100, digits=1))% more → slower forgetting")
    println()

    # ─── Example 3: Memory System (NOVA 873ms Heartbeat) ─────────────────────
    println("═══ Example 3: NOVA Memory System (τ = 873ms) ═══")
    τ_hb = HEARTBEAT_MS / 1000.0  # 0.873 seconds

    println("Memory decay at NOVA heartbeat timescale (τ = $(τ_hb)s):")
    println("  AMOR threshold = $AMOR (memories below this are forgotten)")
    println()

    ages = [0.0, 0.5, 1.0, 1.5, 2.0, 3.0, 5.0, 10.0]
    println("  $(lpad("Age(s)", 7))  $(lpad("Weight", 8))  $(lpad("Status", 12))")
    for age in ages
        w = phi_memory_weight(age, τ_hb)
        raw = phi_decay(age, τ_hb)
        status = w > 0 ? "RETAINED" : "FORGOTTEN"
        println("  $(lpad(round(age, digits=1), 7))  $(lpad(round(raw, digits=5), 8))  $status")
    end
    println()

    # Memory lifetime (when weight drops below AMOR)
    # φ^(-t/τ) = AMOR → t = -τ × ln(AMOR)/ln(φ) = 2τ
    memory_lifetime = -τ_hb * log(AMOR) / LN_PHI
    println("  Memory lifetime (AMOR threshold): $(round(memory_lifetime, digits=4))s = 2τ")
    println("  In heartbeats: $(round(memory_lifetime / τ_hb, digits=2))")
    println()

    # ─── Example 4: Integral (Total Influence) ────────────────────────────────
    println("═══ Example 4: Total Influence (Integral) ═══")
    τ₄ = 1.0
    println("∫₀ᵗ φ^(-s/τ) ds = τ/ln(φ) × (1 - φ^(-t/τ))")
    println()
    println("Cumulative influence:")
    for t in [1.0, 2.0, 5.0, 10.0, 100.0, Inf]
        if t == Inf
            area = τ₄ / LN_PHI
            println("  ∫₀^∞ = $(round(area, digits=6)) = τ/ln(φ)")
        else
            area = phi_decay_integral(t, τ₄)
            frac = area / (τ₄ / LN_PHI) * 100
            println("  ∫₀^$(lpad(round(t, digits=0), 3)) = $(lpad(round(area, digits=6), 10)) ($(round(frac, digits=1))% of total)")
        end
    end
    println()

    # ─── Bridge Output ────────────────────────────────────────────────────────
    println("═══ Bridge Output Format ═══")
    t_sample = collect(0.0:0.5:5.0)
    values = phi_decay_series(t_sample, 1.0)
    println("{")
    println("  \"decay_values\": $(round.(values, digits=8)),")
    println("  \"time_points\": $t_sample,")
    println("  \"tau\": 1.0,")
    println("  \"half_life\": $(round(phi_decay_halflife(1.0), digits=10)),")
    println("  \"total_area\": $(round(1.0 / LN_PHI, digits=10)),")
    println("  \"metadata\": {")
    println("    \"function\": \"phi_decay\",")
    println("    \"formula\": \"φ^(-t/τ)\",")
    println("    \"at_tau\": \"φ⁻¹ = $PHI_INV\",")
    println("    \"at_2tau\": \"φ⁻² = AMOR = $AMOR\",")
    println("    \"ln_phi\": $LN_PHI")
    println("  }")
    println("}")
end

main()
