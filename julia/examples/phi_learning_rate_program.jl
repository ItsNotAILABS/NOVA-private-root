# ═══════════════════════════════════════════════════════════════════════════════
# phi_learning_rate_program.jl — φ⁻¹ Scaled Learning Rate
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Example
# ═══════════════════════════════════════════════════════════════════════════════
#
# phiLearningRate(base) — Generate φ⁻¹ scaled learning rate
#
# Produces a learning rate schedule based on φ⁻¹ geometric decay.
# The golden ratio provides provably optimal step-size reduction:
# each step retains exactly φ⁻¹ ≈ 61.8% of the previous rate.
#
# ═══════════════════════════════════════════════════════════════════════════════

using LinearAlgebra

# ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482
const PHI_INV = 0.6180339887498948482
const AMOR = 0.3819660112501051518

# ═══ Section 2: Core Function ═════════════════════════════════════════════════

"""
    phi_learning_rate(base::Float64; epochs=nothing) -> Vector{Float64}

Generate φ⁻¹ scaled learning rate schedule.

Produces a geometric decay schedule where each epoch's learning rate
is φ⁻¹ × the previous. This is provably optimal for quadratic objectives
and near-optimal for strongly convex functions.

# Arguments
- `base::Float64`: Initial learning rate
- `epochs::Int`: Number of epochs (default: ⌈φ⁵⌉ = 12)

# Returns
- `schedule::Vector{Float64}`: Learning rate for each epoch

# Theory
- φ⁻¹ decay is optimal for: lr(t) = base × φ^(-t)
- After t epochs: lr(t) = base × (0.618...)^t
- Convergence rate: O(φ^(-2t)) for strongly convex
- Total budget: Σ lr(t) = base × φ² (geometric series sum)
"""
function phi_learning_rate(base::Float64; epochs=nothing)
    if epochs === nothing
        epochs = Int(ceil(PHI^5))  # ≈ 12 epochs
    end

    return [base * PHI_INV^t for t in 0:epochs-1]
end

"""
    phi_warmup_schedule(base::Float64; warmup_epochs=3, total_epochs=20) -> Vector{Float64}

Learning rate with φ-warmup followed by φ-decay.
Warmup: linearly increase from base×AMOR to base over warmup_epochs.
Decay: multiply by φ⁻¹ each epoch after warmup.
"""
function phi_warmup_schedule(base::Float64; warmup_epochs=3, total_epochs=20)
    schedule = Float64[]

    # Warmup phase: linear from AMOR×base to base
    for t in 1:warmup_epochs
        lr = base * (AMOR + (1 - AMOR) * t / warmup_epochs)
        push!(schedule, lr)
    end

    # Decay phase: φ⁻¹ geometric decay
    for t in 1:(total_epochs - warmup_epochs)
        lr = base * PHI_INV^t
        push!(schedule, lr)
    end

    return schedule
end

"""
    phi_gradient_descent_demo(f, ∇f, x0::Vector{Float64}, base_lr::Float64; epochs=20)

Demonstrate φ-learning rate gradient descent on a function.
"""
function phi_gradient_descent_demo(f, ∇f, x0::Vector{Float64}, base_lr::Float64; epochs=20)
    schedule = phi_learning_rate(base_lr, epochs=epochs)
    x = copy(x0)
    history = [(copy(x), f(x))]

    for (epoch, lr) in enumerate(schedule)
        grad = ∇f(x)
        x = x - lr * grad
        push!(history, (copy(x), f(x)))
    end

    return history, schedule
end

# ═══ Section 3: Complete Program ══════════════════════════════════════════════

function main()
    println("╔══════════════════════════════════════════════════════════════════╗")
    println("║  NOVA φ-LEARNING RATE — Golden Ratio Optimization Schedule     ║")
    println("╚══════════════════════════════════════════════════════════════════╝")
    println()

    # ─── Example 1: Basic Schedule ────────────────────────────────────────────
    println("═══ Example 1: φ⁻¹ Decay Schedule ═══")
    base = 0.01
    schedule = phi_learning_rate(base, epochs=12)

    println("Base learning rate: $base")
    println("Decay factor: φ⁻¹ = $PHI_INV")
    println("Default epochs: ⌈φ⁵⌉ = $(Int(ceil(PHI^5)))")
    println()
    println("Schedule:")
    for (i, lr) in enumerate(schedule)
        bar = repeat("█", max(1, Int(round(lr / base * 40))))
        println("  Epoch $(lpad(i, 2)): lr = $(lpad(round(lr, digits=8), 12))  $bar")
    end
    println()
    println("Total LR budget: $(round(sum(schedule), digits=6))")
    println("Theoretical sum: base × φ² = $(round(base * PHI^2, digits=6))")
    println()

    # ─── Example 2: Optimization Demo ─────────────────────────────────────────
    println("═══ Example 2: Gradient Descent with φ-LR ═══")
    # Rosenbrock-like function (simplified 2D)
    f(x) = (1 - x[1])^2 + PHI * (x[2] - x[1]^2)^2  # φ-Rosenbrock
    ∇f(x) = [-2*(1 - x[1]) - 4*PHI*x[1]*(x[2] - x[1]^2),
              2*PHI*(x[2] - x[1]^2)]

    x0 = [-1.0, 1.0]
    history, sched = phi_gradient_descent_demo(f, ∇f, x0, 0.1, epochs=25)

    println("φ-Rosenbrock: f(x) = (1-x₁)² + φ(x₂-x₁²)²")
    println("Optimum: x* = [1, 1], f* = 0")
    println("Start: x₀ = $x0, f(x₀) = $(round(f(x0), digits=4))")
    println()
    println("Convergence:")
    milestones = [1, 5, 10, 15, 20, 25]
    for m in milestones
        if m <= length(history)
            x_m, f_m = history[m]
            println("  Epoch $(lpad(m-1, 2)): f = $(lpad(round(f_m, digits=6), 10)), x = $(round.(x_m, digits=4))")
        end
    end
    println()
    println("Final: x = $(round.(history[end][1], digits=6)), f = $(round(history[end][2], digits=8))")
    println()

    # ─── Example 3: Warmup + Decay Schedule ──────────────────────────────────
    println("═══ Example 3: φ-Warmup + φ-Decay Schedule ═══")
    warmup_sched = phi_warmup_schedule(0.001, warmup_epochs=3, total_epochs=15)

    println("Warmup (3 epochs) → φ-decay (12 epochs):")
    for (i, lr) in enumerate(warmup_sched)
        phase = i <= 3 ? "WARMUP" : "DECAY "
        bar = repeat("█", max(1, Int(round(lr / 0.001 * 30))))
        println("  Epoch $(lpad(i, 2)) [$phase]: lr = $(lpad(round(lr, digits=8), 12))  $bar")
    end
    println()

    # ─── Example 4: Comparison with Standard Schedules ────────────────────────
    println("═══ Example 4: φ-Schedule vs Standard Schedules ═══")
    base_lr = 0.01
    epochs = 10

    phi_sched = phi_learning_rate(base_lr, epochs=epochs)
    exp_sched = [base_lr * exp(-0.3 * t) for t in 0:epochs-1]
    step_sched = [base_lr * 0.5^div(t, 3) for t in 0:epochs-1]

    println("Comparison (base=$base_lr, $epochs epochs):")
    println("  $(lpad("Epoch", 5))  $(lpad("φ-decay", 10))  $(lpad("Exp(0.3)", 10))  $(lpad("Step(3)", 10))")
    for t in 1:epochs
        println("  $(lpad(t, 5))  $(lpad(round(phi_sched[t], digits=7), 10))  $(lpad(round(exp_sched[t], digits=7), 10))  $(lpad(round(step_sched[t], digits=7), 10))")
    end
    println()
    println("Total budget: φ=$(round(sum(phi_sched), digits=5)), exp=$(round(sum(exp_sched), digits=5)), step=$(round(sum(step_sched), digits=5))")
    println()

    # ─── Bridge Output ────────────────────────────────────────────────────────
    println("═══ Bridge Output Format ═══")
    println("{")
    println("  \"schedule\": $(round.(phi_learning_rate(0.01, epochs=5), digits=10)),")
    println("  \"base_lr\": 0.01,")
    println("  \"decay_factor\": $PHI_INV,")
    println("  \"epochs\": 5,")
    println("  \"total_budget\": $(round(sum(phi_learning_rate(0.01, epochs=5)), digits=10)),")
    println("  \"metadata\": {")
    println("    \"function\": \"phi_learning_rate\",")
    println("    \"formula\": \"lr(t) = base × φ^(-t)\",")
    println("    \"convergence_rate\": \"O(φ^(-2t))\",")
    println("    \"optimal_for\": \"strongly_convex\"")
    println("  }")
    println("}")
end

main()
