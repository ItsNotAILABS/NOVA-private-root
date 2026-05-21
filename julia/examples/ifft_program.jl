# ═══════════════════════════════════════════════════════════════════════════════
# ifft_program.jl — Inverse FFT with φ-Reconstruction
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Example
# ═══════════════════════════════════════════════════════════════════════════════
#
# ifft(X) — Inverse FFT with φ-reconstruction
#
# Reconstructs time-domain signal from frequency spectrum, applying φ-based
# spectral filtering that retains only components above AMOR threshold.
#
# ═══════════════════════════════════════════════════════════════════════════════

using FFTW
using LinearAlgebra

# ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482
const PHI_INV = 0.6180339887498948482
const AMOR = 0.3819660112501051518

# ═══ Section 2: Core Function ═════════════════════════════════════════════════

"""
    phi_ifft(X::Vector{ComplexF64}; filter=true) -> Vector{Float64}

Inverse FFT with φ-reconstruction.

Before inverse transform, applies φ-spectral filter that zeroes frequency
components with magnitude below AMOR × max_magnitude. This provides
denoising during reconstruction.

# Arguments
- `X::Vector{ComplexF64}`: Frequency-domain spectrum
- `filter::Bool`: Apply φ-spectral filter (default: true)

# Returns
- `x::Vector{Float64}`: Reconstructed time-domain signal
"""
function phi_ifft(X::Vector{ComplexF64}; filter=true)
    if filter
        # Apply φ-spectral filter
        mag = abs.(X)
        max_mag = maximum(mag)
        threshold = AMOR * max_mag

        # Zero components below threshold
        X_filtered = [abs(X[i]) >= threshold ? X[i] : 0.0 + 0.0im for i in eachindex(X)]
        return real(ifft(X_filtered))
    else
        return real(ifft(X))
    end
end

"""
    phi_reconstruct(X::Vector{ComplexF64}, keep_ratio::Float64) -> Vector{Float64}

Reconstruct signal keeping only top `keep_ratio` fraction of spectral energy.
Default keep_ratio = PHI_INV ≈ 0.618 (keep 61.8% of spectral energy).
"""
function phi_reconstruct(X::Vector{ComplexF64}; keep_ratio=PHI_INV)
    mag = abs.(X)
    sorted_mag = sort(mag, rev=true)

    # Find cutoff for desired energy fraction
    total_energy = sum(mag.^2)
    cumulative = 0.0
    cutoff = 0.0

    for s in sorted_mag
        cumulative += s^2
        if cumulative >= keep_ratio * total_energy
            cutoff = s
            break
        end
    end

    # Filter spectrum
    X_kept = [abs(X[i]) >= cutoff ? X[i] : 0.0 + 0.0im for i in eachindex(X)]
    components_kept = count(x -> x != 0.0 + 0.0im, X_kept)

    return real(ifft(X_kept)), components_kept
end

# ═══ Section 3: Complete Program ══════════════════════════════════════════════

function main()
    println("╔══════════════════════════════════════════════════════════════════╗")
    println("║  NOVA φ-IFFT — Inverse FFT with Golden Reconstruction          ║")
    println("╚══════════════════════════════════════════════════════════════════╝")
    println()

    # ─── Example 1: Perfect Reconstruction ────────────────────────────────────
    println("═══ Example 1: Perfect Round-Trip (FFT → IFFT) ═══")
    N = 64
    x_orig = sin.(2π * 5.0 .* collect(0:N-1) ./ N)

    X = fft(x_orig)
    x_reconstructed = phi_ifft(ComplexF64.(X), filter=false)

    error = norm(x_orig - x_reconstructed)
    println("Original signal: sin(2π×5t), N=$N")
    println("FFT → IFFT round-trip error: $(round(error, digits=15))")
    println("Status: ", error < 1e-10 ? "✓ Perfect reconstruction" : "✗ Error detected")
    println()

    # ─── Example 2: Denoising via φ-Filter ───────────────────────────────────
    println("═══ Example 2: Signal Denoising via φ-Spectral Filter ═══")
    # Clean signal + noise
    t = collect(0:N-1) ./ N
    x_clean = sin.(2π * 3.0 .* t) + 0.5 * sin.(2π * 7.0 .* t)
    noise = 0.3 * randn(N)
    x_noisy = x_clean + noise

    # Forward FFT
    X_noisy = fft(x_noisy)

    # φ-filtered reconstruction
    x_denoised = phi_ifft(ComplexF64.(X_noisy), filter=true)

    snr_before = 10 * log10(sum(x_clean.^2) / sum(noise.^2))
    snr_after = 10 * log10(sum(x_clean.^2) / sum((x_denoised - x_clean).^2))

    println("Signal: sin(2π×3t) + 0.5sin(2π×7t)")
    println("Noise level: 0.3 × randn")
    println("SNR before φ-filter: $(round(snr_before, digits=2)) dB")
    println("SNR after φ-filter:  $(round(snr_after, digits=2)) dB")
    println("Improvement:          $(round(snr_after - snr_before, digits=2)) dB")
    println("φ-threshold: AMOR × max(|X|) = $(round(AMOR * maximum(abs.(X_noisy)), digits=4))")
    println()

    # ─── Example 3: φ-Ratio Energy Compression ───────────────────────────────
    println("═══ Example 3: φ-Ratio Energy Compression ═══")
    # Complex signal
    x_complex = sin.(2π * 2 .* t) + PHI_INV * sin.(2π * 5 .* t) +
                AMOR * sin.(2π * 11 .* t) + 0.1 * randn(N)

    X_complex = fft(x_complex)
    x_phi, n_kept = phi_reconstruct(ComplexF64.(X_complex))

    println("Input: multi-frequency signal with φ-scaled amplitudes")
    println("φ-reconstruction (keep $(round(PHI_INV*100, digits=1))% energy):")
    println("  Components retained: $n_kept / $N ($(round(n_kept/N*100, digits=1))%)")
    println("  Reconstruction error: $(round(norm(x_complex - x_phi) / norm(x_complex), digits=6))")
    println("  Energy preserved: $(round(sum(x_phi.^2) / sum(x_complex.^2) * 100, digits=2))%")
    println()

    # ─── Example 4: Bridge Round-Trip Verification ────────────────────────────
    println("═══ Example 4: Bridge Round-Trip (Julia ↔ Motoko) ═══")
    # Simulate what happens when data crosses the bridge
    x_bridge = [1.0, 2.0, 3.0, 4.0, 5.0, 4.0, 3.0, 2.0]  # Simple test signal
    X_bridge = fft(x_bridge)
    x_back = phi_ifft(ComplexF64.(X_bridge), filter=false)

    println("Input signal:  $(x_bridge)")
    println("Reconstructed: $(round.(x_back, digits=10))")
    println("Max error:     $(round(maximum(abs.(x_bridge - x_back)), digits=15))")
    println()

    # JSON-compatible output
    println("Bridge output format:")
    println("{")
    println("  \"real_part\": $(round.(real(X_bridge), digits=6)),")
    println("  \"imag_part\": $(round.(imag(X_bridge), digits=6)),")
    println("  \"reconstructed\": $(round.(x_back, digits=10)),")
    println("  \"phi_filter_applied\": false,")
    println("  \"metadata\": {")
    println("    \"function\": \"phi_ifft\",")
    println("    \"N\": $(length(x_bridge)),")
    println("    \"round_trip_error\": $(maximum(abs.(x_bridge - x_back)))")
    println("  }")
    println("}")
end

main()
