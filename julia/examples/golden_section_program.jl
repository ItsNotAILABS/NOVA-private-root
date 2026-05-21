# ═══════════════════════════════════════════════════════════════════════════════
# golden_section_program.jl — Golden Section Search Optimization
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Example
# ═══════════════════════════════════════════════════════════════════════════════
#
# goldenSection(f, a, b) — Golden section search optimization
#
# Minimizes a unimodal function on [a, b] using the golden ratio to choose
# probe points. Each iteration reduces the search interval by φ⁻¹ ≈ 61.8%,
# achieving the provably optimal convergence rate for bracketing methods.
#
# ═══════════════════════════════════════════════════════════════════════════════

# ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482
const PHI_INV = 0.6180339887498948482
const AMOR = 0.3819660112501051518

# ═══ Section 2: Core Function ═════════════════════════════════════════════════

"""
    golden_section(f, a::Float64, b::Float64; tol=1e-10, max_iter=100) -> (Float64, Float64, Int)

Golden section search for minimum of unimodal function on [a, b].

At each step, two interior points divide the interval in golden ratio:
  x₁ = a + AMOR × (b - a)
  x₂ = a + PHI_INV × (b - a)

The interval shrinks by factor φ⁻¹ each iteration (optimal for bracketing).

# Arguments
- `f`: Unimodal function to minimize
- `a::Float64`: Left bracket
- `b::Float64`: Right bracket
- `tol::Float64`: Convergence tolerance (default: 1e-10)
- `max_iter::Int`: Maximum iterations (default: 100)

# Returns
- `x_min::Float64`: Location of minimum
- `f_min::Float64`: Function value at minimum
- `iterations::Int`: Number of iterations used

# Properties
- Convergence rate: linear, ratio = φ⁻¹ ≈ 0.618
- Function evaluations: max_iter + 1 (one reuse per step)
- Interval reduction after k steps: (b-a) × φ^(-k)
"""
function golden_section(f, a::Float64, b::Float64; tol=1e-10, max_iter=100)
    # Initial probe points
    x₁ = a + AMOR * (b - a)
    x₂ = a + PHI_INV * (b - a)
    f₁ = f(x₁)
    f₂ = f(x₂)

    iterations = 0

    for iter in 1:max_iter
        iterations = iter

        if abs(b - a) < tol
            break
        end

        if f₁ < f₂
            # Minimum is in [a, x₂]
            b = x₂
            x₂ = x₁
            f₂ = f₁
            x₁ = a + AMOR * (b - a)
            f₁ = f(x₁)
        else
            # Minimum is in [x₁, b]
            a = x₁
            x₁ = x₂
            f₁ = f₂
            x₂ = a + PHI_INV * (b - a)
            f₂ = f(x₂)
        end
    end

    # Return midpoint of final interval
    x_min = (a + b) / 2
    return (x_min, f(x_min), iterations)
end

"""
    golden_section_max(f, a::Float64, b::Float64; kwargs...) -> (Float64, Float64, Int)

Golden section search for MAXIMUM (negates f internally).
"""
function golden_section_max(f, a::Float64, b::Float64; kwargs...)
    x_min, neg_f_max, iters = golden_section(x -> -f(x), a, b; kwargs...)
    return (x_min, -neg_f_max, iters)
end

# ═══ Section 3: Complete Program ══════════════════════════════════════════════

function main()
    println("╔══════════════════════════════════════════════════════════════════╗")
    println("║  NOVA GOLDEN SECTION — φ-Optimal Bracket Search                ║")
    println("╚══════════════════════════════════════════════════════════════════╝")
    println()

    # ─── Example 1: Simple Quadratic ──────────────────────────────────────────
    println("═══ Example 1: Quadratic Minimization ═══")
    f₁(x) = (x - PHI)^2  # Minimum at x = φ

    x_min, f_min, iters = golden_section(f₁, 0.0, 3.0)

    println("f(x) = (x - φ)² on [0, 3]")
    println("True minimum: x* = φ = $PHI")
    println("Found minimum: x = $(round(x_min, digits=15))")
    println("f(x_min) = $(round(f_min, digits=15))")
    println("Error: |x - φ| = $(round(abs(x_min - PHI), digits=15))")
    println("Iterations: $iters")
    println("Interval reduction: $(round(3.0 * PHI_INV^iters, digits=15))")
    println()

    # ─── Example 2: Non-Smooth Function ───────────────────────────────────────
    println("═══ Example 2: Non-Differentiable Function ═══")
    f₂(x) = abs(x - 2.5) + 0.5 * abs(x - 1.0)  # V-shaped, min near x = 2.5

    x_min₂, f_min₂, iters₂ = golden_section(f₂, 0.0, 5.0)

    println("f(x) = |x - 2.5| + 0.5|x - 1.0| on [0, 5]")
    println("Found minimum: x = $(round(x_min₂, digits=10))")
    println("f(x_min) = $(round(f_min₂, digits=10))")
    println("Iterations: $iters₂")
    println("(Golden section works without derivatives!)")
    println()

    # ─── Example 3: Convergence Visualization ─────────────────────────────────
    println("═══ Example 3: Convergence Analysis ═══")
    f₃(x) = x^4 - 14x^3 + 60x^2 - 70x  # Quartic with minimum near x ≈ 0.78

    println("f(x) = x⁴ - 14x³ + 60x² - 70x on [0, 2]")
    println()
    println("Iteration convergence:")
    println("  $(lpad("Iter", 4))  $(lpad("[a, b]", 24))  $(lpad("Width", 12))  $(lpad("Reduction", 10))")

    a, b = 0.0, 2.0
    x₁ = a + AMOR * (b - a)
    x₂ = a + PHI_INV * (b - a)
    f1, f2 = f₃(x₁), f₃(x₂)
    prev_width = b - a

    for iter in 1:15
        width = b - a
        ratio = width / prev_width
        println("  $(lpad(iter, 4))  [$(lpad(round(a, digits=6), 9)), $(lpad(round(b, digits=6), 9))]  $(lpad(round(width, digits=8), 12))  $(lpad(round(ratio, digits=6), 10))")
        prev_width = width

        if f1 < f2
            b = x₂; x₂ = x₁; f2 = f1
            x₁ = a + AMOR * (b - a); f1 = f₃(x₁)
        else
            a = x₁; x₁ = x₂; f1 = f2
            x₂ = a + PHI_INV * (b - a); f2 = f₃(x₂)
        end
    end
    println()
    println("  Reduction ratio → φ⁻¹ = $(round(PHI_INV, digits=6)) (proven optimal)")
    println()

    # ─── Example 4: φ-Decay Parameter Optimization ───────────────────────────
    println("═══ Example 4: Optimizing a φ-System Parameter ═══")
    # Find optimal coupling strength for a 4-oscillator system
    function sync_quality(K)
        N = 4
        θ = [0.0, π/3, 2π/3, π]  # Fixed initial conditions
        ω = [1.0, 1.1, 0.9, 1.05]
        # Simulate 50 steps
        for _ in 1:50
            dθ = zeros(N)
            for i in 1:N
                coupling = sum(sin(θ[j] - θ[i]) for j in 1:N if j != i)
                dθ[i] = ω[i] + (K / N) * coupling
            end
            θ .+= dθ .* 0.1
        end
        # Order parameter (negative for minimization)
        R = abs(sum(exp.(im .* θ)) / N)
        return -R  # Negate because we minimize
    end

    K_opt, neg_R, iters₄ = golden_section(sync_quality, 0.0, 5.0)

    println("Optimizing Kuramoto coupling K for maximum synchronization:")
    println("Optimal K:        $(round(K_opt, digits=6))")
    println("Max order param:  $(round(-neg_R, digits=6))")
    println("Iterations:       $iters₄")
    println("Near φ⁻¹?:        |K_opt - φ⁻¹| = $(round(abs(K_opt - PHI_INV), digits=4))")
    println()

    # ─── Bridge Output ────────────────────────────────────────────────────────
    println("═══ Bridge Output Format ═══")
    println("{")
    println("  \"x_min\": $(round(x_min, digits=15)),")
    println("  \"f_min\": $(round(f_min, digits=15)),")
    println("  \"iterations\": $iters,")
    println("  \"convergence_rate\": $PHI_INV,")
    println("  \"metadata\": {")
    println("    \"function\": \"golden_section\",")
    println("    \"interval\": [0.0, 3.0],")
    println("    \"tolerance\": 1e-10,")
    println("    \"reduction_per_step\": \"φ⁻¹ = $PHI_INV\"")
    println("  }")
    println("}")
end

main()
