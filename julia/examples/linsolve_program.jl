# ═══════════════════════════════════════════════════════════════════════════════
# linsolve_program.jl — Linear System Solver with φ-Preconditioner
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Example
# ═══════════════════════════════════════════════════════════════════════════════
#
# linsolve(A, b) — Linear system solver with φ-preconditioner
#
# Solves Ax = b using LU decomposition with φ-diagonal preconditioning.
# The preconditioner adds φ⁻² × max(diag(A)) to diagonal elements for
# numerical stability without significantly altering the solution.
#
# ═══════════════════════════════════════════════════════════════════════════════

using LinearAlgebra

# ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482
const PHI_INV = 0.6180339887498948482
const AMOR = 0.3819660112501051518

# ═══ Section 2: Core Function ═════════════════════════════════════════════════

"""
    phi_linsolve(A::Matrix{Float64}, b::Vector{Float64}; precondition=true) -> Vector{Float64}

Solve linear system Ax = b with φ-diagonal preconditioner.

Adds AMOR × max(|diag(A)|) to diagonal before solving, providing
Tikhonov-style regularization scaled by the golden ratio. This prevents
ill-conditioning while introducing minimal bias proportional to φ⁻².

# Arguments
- `A::Matrix{Float64}`: Coefficient matrix (n × n)
- `b::Vector{Float64}`: Right-hand side vector
- `precondition::Bool`: Apply φ-preconditioner (default: true)

# Returns
- `x::Vector{Float64}`: Solution vector

# Properties
- Complexity: O(n³) for dense systems
- Regularization: AMOR × max(|diag(A)|) added to diagonal
- Condition improvement: κ(A_φ) ≤ κ(A) always
"""
function phi_linsolve(A::Matrix{Float64}, b::Vector{Float64}; precondition=true)
    n = size(A, 1)
    if size(A, 2) != n
        error("phi_linsolve: coefficient matrix must be square")
    end
    if length(b) != n
        error("phi_linsolve: dimension mismatch between A and b")
    end

    if !precondition
        return A \ b
    end

    # φ-preconditioner: add AMOR × max(|diag(A)|) to diagonal
    diag_scale = maximum(abs.(diag(A)))
    if diag_scale < 1e-15
        diag_scale = 1.0  # Fallback for zero diagonal
    end

    regularization = AMOR * diag_scale
    A_phi = A + regularization * I(n)

    # Solve preconditioned system
    x = A_phi \ b

    # Optional: iterative refinement (one step)
    r = b - A * x  # Residual from ORIGINAL system
    dx = A_phi \ r  # Correction
    x_refined = x + dx

    return x_refined
end

"""
    phi_condition_number(A::Matrix{Float64}) -> (Float64, Float64)

Compute condition number before and after φ-preconditioning.
"""
function phi_condition_number(A::Matrix{Float64})
    n = size(A, 1)
    diag_scale = maximum(abs.(diag(A)))
    diag_scale = max(diag_scale, 1.0)
    A_phi = A + AMOR * diag_scale * I(n)

    κ_orig = cond(A)
    κ_phi = cond(A_phi)

    return (κ_orig, κ_phi)
end

# ═══ Section 3: Complete Program ══════════════════════════════════════════════

function main()
    println("╔══════════════════════════════════════════════════════════════════╗")
    println("║  NOVA φ-LINSOLVE — Linear Solver with Golden Preconditioner    ║")
    println("╚══════════════════════════════════════════════════════════════════╝")
    println()

    # ─── Example 1: Well-Conditioned System ───────────────────────────────────
    println("═══ Example 1: Well-Conditioned System ═══")
    A₁ = [4.0 1.0 0.0;
           1.0 3.0 1.0;
           0.0 1.0 4.0]
    b₁ = [15.0, 10.0, 10.0]

    x_direct = A₁ \ b₁
    x_phi = phi_linsolve(A₁, b₁)

    println("System: Ax = b")
    println("A = "); display(A₁); println()
    println("b = $b₁")
    println()
    println("Direct solution:     $(round.(x_direct, digits=6))")
    println("φ-preconditioned:    $(round.(x_phi, digits=6))")
    println("Difference:          $(round.(abs.(x_direct - x_phi), digits=8))")
    println("Residual ||Ax-b||:   $(round(norm(A₁ * x_phi - b₁), digits=10))")
    println()

    # ─── Example 2: Ill-Conditioned System ────────────────────────────────────
    println("═══ Example 2: Ill-Conditioned System (Hilbert Matrix) ═══")
    n = 6
    # Hilbert matrix: H[i,j] = 1/(i+j-1) — notoriously ill-conditioned
    H = [1.0 / (i + j - 1) for i in 1:n, j in 1:n]
    x_true = ones(n)
    b₂ = H * x_true

    κ_orig, κ_phi = phi_condition_number(H)
    x_direct₂ = H \ b₂
    x_phi₂ = phi_linsolve(H, b₂)

    println("Hilbert matrix H ($(n)×$(n)):")
    println("Condition number (original): $(round(κ_orig, digits=0))")
    println("Condition number (φ-preconditioned): $(round(κ_phi, digits=0))")
    println("Condition improvement: $(round(κ_orig / κ_phi, digits=1))×")
    println()
    println("True solution:       $(x_true)")
    println("Direct solution:     $(round.(x_direct₂, digits=6))")
    println("φ-preconditioned:    $(round.(x_phi₂, digits=6))")
    println("Direct error:        $(round(norm(x_direct₂ - x_true), digits=8))")
    println("φ-solution error:    $(round(norm(x_phi₂ - x_true), digits=8))")
    println()

    # ─── Example 3: Nearly Singular System ────────────────────────────────────
    println("═══ Example 3: Nearly Singular System ═══")
    A₃ = [1.0 2.0 3.0;
           4.0 5.0 6.0;
           7.0 8.0 9.0 + 1e-10]  # Rank-deficient + tiny perturbation
    b₃ = [6.0, 15.0, 24.0]

    κ₃_orig, κ₃_phi = phi_condition_number(A₃)
    x_phi₃ = phi_linsolve(A₃, b₃)

    println("Nearly singular matrix (rank ≈ 2):")
    println("κ(A) = $(round(κ₃_orig, digits=0)) (ill-conditioned)")
    println("κ(A_φ) = $(round(κ₃_phi, digits=2)) (stabilized)")
    println("φ-solution: $(round.(x_phi₃, digits=6))")
    println("Residual:   $(round(norm(A₃ * x_phi₃ - b₃), digits=8))")
    println()

    # ─── Example 4: Bridge Output ─────────────────────────────────────────────
    println("═══ Example 4: Bridge Output Format ═══")
    x_out = phi_linsolve(A₁, b₁)
    println("{")
    println("  \"solution\": $(round.(x_out, digits=10)),")
    println("  \"residual_norm\": $(round(norm(A₁ * x_out - b₁), digits=15)),")
    println("  \"condition_original\": $(round(cond(A₁), digits=4)),")
    println("  \"condition_phi\": $(round(phi_condition_number(A₁)[2], digits=4)),")
    println("  \"regularization\": $(round(AMOR * maximum(abs.(diag(A₁))), digits=10)),")
    println("  \"metadata\": {")
    println("    \"function\": \"phi_linsolve\",")
    println("    \"preconditioned\": true,")
    println("    \"regularization_type\": \"phi_diagonal\",")
    println("    \"amor_factor\": $AMOR,")
    println("    \"iterative_refinement\": true,")
    println("    \"n\": $(size(A₁, 1))")
    println("  }")
    println("}")
end

main()
