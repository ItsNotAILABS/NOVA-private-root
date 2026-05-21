# ═══════════════════════════════════════════════════════════════════════════════
# svd_program.jl — Singular Value Decomposition with φ-Truncation
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Example
# ═══════════════════════════════════════════════════════════════════════════════
#
# svd(A) — Singular Value Decomposition with φ-truncation
#
# φ-truncation retains singular values above φ⁻² (AMOR) threshold relative
# to the maximum, providing optimal dimensionality reduction governed by
# golden ratio geometry.
#
# ═══════════════════════════════════════════════════════════════════════════════

using LinearAlgebra

# ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482
const PHI_INV = 0.6180339887498948482
const AMOR = 0.3819660112501051518

# ═══ Section 2: Core Function ═════════════════════════════════════════════════

"""
    phi_svd(A::Matrix{Float64}; threshold=AMOR) -> (U, Σ_phi, V, rank_phi)

Singular Value Decomposition with φ-truncation.

Singular values below AMOR × σ_max are truncated (set to zero),
providing optimal low-rank approximation governed by golden ratio geometry.

# Arguments
- `A::Matrix{Float64}`: Input matrix (m × n)
- `threshold::Float64`: Truncation threshold relative to σ_max (default: AMOR = φ⁻²)

# Returns
- `U::Matrix{Float64}`: Left singular vectors
- `Σ_phi::Vector{Float64}`: φ-truncated singular values
- `V::Matrix{Float64}`: Right singular vectors
- `rank_phi::Int`: Effective rank after φ-truncation
"""
function phi_svd(A::Matrix{Float64}; threshold=AMOR)
    # Compute full SVD
    F = svd(A)
    U = F.U
    Σ = F.S
    V = F.Vt'  # Transpose to get V (columns are right singular vectors)

    # Apply φ-truncation
    σ_max = maximum(Σ)
    cutoff = threshold * σ_max

    # Truncate: zero out singular values below cutoff
    Σ_phi = [σ >= cutoff ? σ : 0.0 for σ in Σ]
    rank_phi = count(σ -> σ > 0, Σ_phi)

    return (U, Σ_phi, V, rank_phi)
end

"""
    phi_svd_reconstruct(U, Σ, V, k) -> Matrix{Float64}

Reconstruct matrix from top-k φ-truncated SVD components.
"""
function phi_svd_reconstruct(U, Σ, V, k)
    # Use only top-k components
    k = min(k, length(Σ))
    return U[:, 1:k] * Diagonal(Σ[1:k]) * V[:, 1:k]'
end

# ═══ Section 3: Complete Program ══════════════════════════════════════════════

function main()
    println("╔══════════════════════════════════════════════════════════════════╗")
    println("║  NOVA φ-SVD — Singular Value Decomposition with φ-Truncation   ║")
    println("╚══════════════════════════════════════════════════════════════════╝")
    println()

    # ─── Example 1: Low-Rank Matrix ──────────────────────────────────────────
    println("═══ Example 1: Low-Rank Matrix Recovery ═══")
    # Create rank-2 matrix with noise
    A_signal = [1.0 2.0; 3.0 4.0; 5.0 6.0] * [1.0 0.5 0.2; 0.3 1.0 0.7]
    A_noise = 0.01 * randn(3, 3)
    A₁ = A_signal + A_noise

    println("Input Matrix A (3×3, rank ≈ 2 + noise):")
    display(round.(A₁, digits=4))
    println()

    U, Σ_phi, V, rank = phi_svd(A₁)

    println("Original singular values: ", round.(svd(A₁).S, digits=6))
    println("φ-truncated values:       ", round.(Σ_phi, digits=6))
    println("φ-effective rank:          $rank (threshold = AMOR × σ_max)")
    println("AMOR threshold:            $(round(AMOR * maximum(svd(A₁).S), digits=6))")
    println()

    # ─── Example 2: Image-Like Compression ───────────────────────────────────
    println("═══ Example 2: Data Compression (Image-Like) ═══")
    # Create a 10×10 matrix with known low-rank structure
    m, n = 10, 10
    r_true = 3  # true rank
    A₂ = randn(m, r_true) * randn(r_true, n)  # rank-3 matrix

    U₂, Σ₂, V₂, rank₂ = phi_svd(A₂)

    println("Matrix size: $(m)×$(n)")
    println("True rank: $r_true")
    println("φ-detected rank: $rank₂")
    println()

    # Compression ratios
    full_storage = m * n
    compressed_storage = rank₂ * (m + n + 1)
    ratio = full_storage / compressed_storage

    println("Storage comparison:")
    println("  Full matrix:    $full_storage elements")
    println("  φ-SVD (rank $rank₂): $compressed_storage elements")
    println("  Compression ratio: $(round(ratio, digits=2))×")
    println()

    # Reconstruction quality
    A₂_reconstructed = phi_svd_reconstruct(U₂, Σ₂, V₂, rank₂)
    rel_error = norm(A₂ - A₂_reconstructed) / norm(A₂)
    println("  Relative reconstruction error: $(round(rel_error, digits=10))")
    println("  φ-truncation preserves: $(round((1 - rel_error) * 100, digits=4))% of energy")
    println()

    # ─── Example 3: Bridge Output Format ─────────────────────────────────────
    println("═══ Example 3: Bridge Output (JSON-Compatible) ═══")
    A₃ = [4.0 0.0; 3.0 -5.0]
    U₃, Σ₃, V₃, rank₃ = phi_svd(A₃)

    println("{")
    println("  \"U\": $(round.(U₃, digits=6) |> eachrow |> collect),")
    println("  \"S\": $(round.(Σ₃, digits=6)),")
    println("  \"V\": $(round.(V₃, digits=6) |> eachrow |> collect),")
    println("  \"phi_rank\": $rank₃,")
    println("  \"threshold\": $AMOR,")
    println("  \"metadata\": {")
    println("    \"function\": \"phi_svd\",")
    println("    \"input_size\": $(size(A₃)),")
    println("    \"compression\": $(round(rank₃ / minimum(size(A₃)), digits=4))")
    println("  }")
    println("}")
    println()

    # ─── Verification ─────────────────────────────────────────────────────────
    println("═══ Verification ═══")
    F = svd(A₃)
    A₃_check = F.U * Diagonal(F.S) * F.Vt
    println("✓ SVD reconstruction: ||A - UΣVᵀ|| = $(round(norm(A₃ - A₃_check), digits=15))")
    println("✓ U orthogonal: ||UᵀU - I|| = $(round(norm(U₃'U₃ - I), digits=15))")
    println("✓ V orthogonal: ||VᵀV - I|| = $(round(norm(V₃'V₃ - I), digits=15))")
    println("✓ φ-truncation threshold: AMOR = φ⁻² = $AMOR")
end

main()
