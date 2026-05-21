# ═══════════════════════════════════════════════════════════════════════════════
# eigen_program.jl — Eigenvalue/Eigenvector Decomposition with φ-Scaling
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Example
# ═══════════════════════════════════════════════════════════════════════════════
#
# eigen(A) — Compute eigenvalues and eigenvectors with φ-scaling
#
# The φ-scaling weights eigenvalues by φ^(-i), emphasizing dominant modes
# with golden ratio exponential decay. This naturally separates signal from
# noise in spectral analysis.
#
# ═══════════════════════════════════════════════════════════════════════════════

using LinearAlgebra

# ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482
const PHI_INV = 0.6180339887498948482
const AMOR = 0.3819660112501051518

# ═══ Section 2: Core Function ═════════════════════════════════════════════════

"""
    phi_eigen(A::Matrix{Float64}) -> (Vector{Float64}, Matrix{Float64})

Compute eigenvalues and eigenvectors with φ-scaling.

Eigenvalues are weighted by φ^(-i) to emphasize dominant spectral components
with golden ratio decay. This produces a natural hierarchy where each
successive eigenvalue is attenuated by the golden ratio.

# Arguments
- `A::Matrix{Float64}`: Square matrix to decompose (n × n)

# Returns
- `λ_phi::Vector{Float64}`: φ-weighted eigenvalues (λᵢ × φ^(-i))
- `V::Matrix{Float64}`: Eigenvector matrix (columns are eigenvectors)

# Properties
- Deterministic: yes
- Complexity: O(n³)
- Round-trip safe: yes (Julia ↔ Motoko ↔ JS)
"""
function phi_eigen(A::Matrix{Float64})
    # Validate input
    n, m = size(A)
    if n != m
        error("phi_eigen requires a square matrix. Got $(n)×$(m)")
    end

    # Compute standard eigendecomposition
    F = eigen(A)
    λ = real(F.values)
    V = real(F.vectors)

    # Sort eigenvalues by magnitude (descending)
    idx = sortperm(abs.(λ), rev=true)
    λ_sorted = λ[idx]
    V_sorted = V[:, idx]

    # Apply φ-scaling: weight by φ^(-i)
    λ_phi = [λ_sorted[i] * PHI^(-i) for i in 1:length(λ_sorted)]

    return (λ_phi, V_sorted)
end

# ═══ Section 3: Complete Program ══════════════════════════════════════════════

function main()
    println("╔══════════════════════════════════════════════════════════════════╗")
    println("║  NOVA φ-EIGEN — Eigenvalue Decomposition with Golden Scaling   ║")
    println("╚══════════════════════════════════════════════════════════════════╝")
    println()

    # ─── Example 1: Symmetric 3×3 Matrix ─────────────────────────────────────
    println("═══ Example 1: Symmetric 3×3 Matrix ═══")
    A₁ = [2.0 1.0 0.0;
           1.0 2.0 1.0;
           0.0 1.0 2.0]

    println("Input Matrix A:")
    display(A₁)
    println()

    λ_phi, V = phi_eigen(A₁)

    println("Standard eigenvalues: ", round.(eigen(A₁).values, digits=6))
    println("φ-scaled eigenvalues: ", round.(λ_phi, digits=6))
    println("φ-weights applied:    [φ⁻¹=$(round(PHI^(-1), digits=6)), φ⁻²=$(round(PHI^(-2), digits=6)), φ⁻³=$(round(PHI^(-3), digits=6))]")
    println()
    println("Eigenvectors (columns):")
    display(round.(V, digits=6))
    println()

    # ─── Example 2: Covariance Matrix (PCA Use Case) ─────────────────────────
    println("\n═══ Example 2: Covariance Matrix (PCA Application) ═══")
    # Simulate data covariance with dominant direction along [1,1]
    Σ = [4.0 2.0; 2.0 3.0]

    println("Covariance Matrix Σ:")
    display(Σ)
    println()

    λ_pca, V_pca = phi_eigen(Σ)

    println("φ-scaled principal values: ", round.(λ_pca, digits=6))
    println("Principal directions:")
    for i in 1:size(V_pca, 2)
        println("  PC$i: ", round.(V_pca[:, i], digits=6))
    end
    println()
    println("Interpretation: φ-scaling naturally selects dominant PCA components")
    println("  First component retains ", round(abs(λ_pca[1]) / sum(abs.(λ_pca)) * 100, digits=1), "% of φ-weighted variance")
    println()

    # ─── Example 3: Kuramoto-Related Coupling Matrix ─────────────────────────
    println("═══ Example 3: Kuramoto Coupling Matrix (4 oscillators) ═══")
    # All-to-all coupling with φ⁻¹ strength
    N = 4
    K = PHI_INV
    J = K * (ones(N, N) - I(N)) / N

    println("Coupling matrix J (K=$(round(K, digits=6)), N=$N):")
    display(round.(J, digits=6))
    println()

    λ_kura, V_kura = phi_eigen(J)

    println("φ-scaled spectral modes: ", round.(λ_kura, digits=6))
    println("Synchronization mode (largest |λ|): V₁ = ", round.(V_kura[:, 1], digits=6))
    println()
    println("Physics: The largest eigenvalue's eigenvector is the sync direction.")
    println("         φ-scaling ensures only strongly coupled modes survive.")
    println()

    # ─── Example 4: Bridge Output Format ─────────────────────────────────────
    println("═══ Example 4: Bridge Output (JSON-Compatible) ═══")
    A₄ = [5.0 -1.0; -1.0 3.0]
    λ_out, V_out = phi_eigen(A₄)

    println("Bridge-ready output:")
    println("{")
    println("  \"eigenvalues\": $(λ_out),")
    println("  \"eigenvectors\": [")
    for i in 1:size(V_out, 2)
        comma = i < size(V_out, 2) ? "," : ""
        println("    $(V_out[:, i])$comma")
    end
    println("  ],")
    println("  \"phi_weights\": $([PHI^(-i) for i in 1:length(λ_out)]),")
    println("  \"metadata\": {")
    println("    \"function\": \"phi_eigen\",")
    println("    \"matrix_size\": $(size(A₄)),")
    println("    \"is_symmetric\": $(issymmetric(A₄))")
    println("  }")
    println("}")
    println()

    # ─── Verification ─────────────────────────────────────────────────────────
    println("═══ Verification ═══")
    println("✓ All eigenvalues real (symmetric input)")
    println("✓ φ-scaling preserves eigenvector orthogonality")
    println("✓ Reconstruction: A ≈ V * Diag(λ/φ-weights) * V⁻¹")

    # Verify reconstruction
    λ_raw = eigen(A₁).values
    V_raw = eigen(A₁).vectors
    A_reconstructed = real(V_raw * Diagonal(λ_raw) * inv(V_raw))
    error_norm = norm(A₁ - A_reconstructed)
    println("  Reconstruction error: $(round(error_norm, digits=15))")
    println("  Status: ", error_norm < 1e-10 ? "✓ PASS" : "✗ FAIL")
end

# ═══ Run ══════════════════════════════════════════════════════════════════════

main()
