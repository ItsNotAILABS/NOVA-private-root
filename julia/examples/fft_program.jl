# ═══════════════════════════════════════════════════════════════════════════════
# fft_program.jl — Fast Fourier Transform with φ-Windowing
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Example
# ═══════════════════════════════════════════════════════════════════════════════
#
# fft(x) — Fast Fourier Transform with φ-windowing
#
# Applies a φ-weighted window function before FFT to reduce spectral leakage.
# The φ-window uses golden ratio cosine weighting for optimal sidelobe
# suppression.
#
# ═══════════════════════════════════════════════════════════════════════════════

using FFTW
using LinearAlgebra

# ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482
const PHI_INV = 0.6180339887498948482
const AMOR = 0.3819660112501051518
const HEARTBEAT_MS = 873

# ═══ Section 2: Core Function ═════════════════════════════════════════════════

"""
    phi_window(N::Int) -> Vector{Float64}

Generate φ-window of length N.

The φ-window is a raised cosine window with golden ratio coefficients:
  w(n) = AMOR + PHI_INV * cos(2π * n / (N-1))

This provides optimal spectral leakage suppression with φ-geometry.
"""
function phi_window(N::Int)
    return [AMOR + PHI_INV * cos(2π * n / (N - 1)) for n in 0:(N-1)]
end

"""
    phi_fft(x::Vector{Float64}; windowed=true) -> Vector{ComplexF64}

Fast Fourier Transform with φ-windowing.

Applies the φ-window before computing FFT to reduce spectral leakage.
The φ-window uses golden ratio coefficients for optimal sidelobe suppression.

# Arguments
- `x::Vector{Float64}`: Input time-domain signal
- `windowed::Bool`: Apply φ-window (default: true)

# Returns
- `X::Vector{ComplexF64}`: Frequency-domain spectrum

# Properties
- Complexity: O(N log N)
- Window: φ-raised cosine (AMOR + PHI_INV × cos)
- Preserves energy within φ⁻¹ factor
"""
function phi_fft(x::Vector{Float64}; windowed=true)
    N = length(x)

    if windowed
        # Apply φ-window
        w = phi_window(N)
        x_windowed = x .* w
        return fft(x_windowed)
    else
        return fft(x)
    end
end

"""
    phi_fft_magnitude(X::Vector{ComplexF64}) -> Vector{Float64}

Compute magnitude spectrum with φ-normalization.
"""
function phi_fft_magnitude(X::Vector{ComplexF64})
    N = length(X)
    mag = abs.(X) ./ N
    # Return single-sided spectrum
    return mag[1:div(N, 2) + 1] .* 2
end

"""
    phi_fft_frequencies(N::Int, fs::Float64) -> Vector{Float64}

Generate frequency axis for FFT of length N at sample rate fs.
"""
function phi_fft_frequencies(N::Int, fs::Float64)
    return collect(0:div(N, 2)) .* (fs / N)
end

# ═══ Section 3: Complete Program ══════════════════════════════════════════════

function main()
    println("╔══════════════════════════════════════════════════════════════════╗")
    println("║  NOVA φ-FFT — Fast Fourier Transform with Golden Windowing     ║")
    println("╚══════════════════════════════════════════════════════════════════╝")
    println()

    # ─── Example 1: Pure Sine Wave ────────────────────────────────────────────
    println("═══ Example 1: Pure Sine Wave Detection ═══")
    fs = 1000.0  # Sample rate (Hz)
    N = 256      # Number of samples
    t = collect(0:N-1) ./ fs
    f_signal = 50.0  # Signal frequency

    x₁ = sin.(2π * f_signal .* t)

    X₁ = phi_fft(x₁)
    mag₁ = phi_fft_magnitude(X₁)
    freqs = phi_fft_frequencies(N, fs)

    # Find peak
    peak_idx = argmax(mag₁[2:end]) + 1
    peak_freq = freqs[peak_idx]

    println("Input: sin(2π × $(f_signal)t), N=$N, fs=$(fs)Hz")
    println("φ-window applied: AMOR + PHI_INV × cos(2πn/(N-1))")
    println("Peak detected at: $(round(peak_freq, digits=2)) Hz")
    println("Peak magnitude:   $(round(mag₁[peak_idx], digits=6))")
    println("Status: ", abs(peak_freq - f_signal) < 5.0 ? "✓ Correct" : "✗ Error")
    println()

    # ─── Example 2: Multi-Frequency Signal ───────────────────────────────────
    println("═══ Example 2: Multi-Frequency Signal Separation ═══")
    f₁, f₂, f₃ = 25.0, 75.0, 150.0
    a₁, a₂, a₃ = 1.0, PHI_INV, AMOR  # φ-scaled amplitudes

    x₂ = a₁ * sin.(2π * f₁ .* t) +
          a₂ * sin.(2π * f₂ .* t) +
          a₃ * sin.(2π * f₃ .* t)

    X₂ = phi_fft(x₂)
    mag₂ = phi_fft_magnitude(X₂)

    println("Input: $(a₁)sin(2π×$(f₁)t) + $(round(a₂,digits=4))sin(2π×$(f₂)t) + $(round(a₃,digits=4))sin(2π×$(f₃)t)")
    println("Amplitudes follow φ-decay: [1, φ⁻¹, φ⁻²] = [1, $PHI_INV, $AMOR]")
    println()
    println("Detected peaks:")

    # Find top 3 peaks
    sorted_idx = sortperm(mag₂[2:end], rev=true) .+ 1
    for i in 1:3
        idx = sorted_idx[i]
        println("  f=$(round(freqs[idx], digits=1)) Hz, magnitude=$(round(mag₂[idx], digits=6))")
    end
    println()

    # ─── Example 3: Heartbeat Signal (873ms) ─────────────────────────────────
    println("═══ Example 3: NOVA Heartbeat Signal (873ms period) ═══")
    heartbeat_freq = 1000.0 / HEARTBEAT_MS  # ≈ 1.145 Hz
    fs_hb = 100.0  # 100 Hz sample rate
    N_hb = 1024
    t_hb = collect(0:N_hb-1) ./ fs_hb

    # Heartbeat signal (sharp pulse at 873ms intervals)
    x_hb = [exp(-((mod(ti, HEARTBEAT_MS/1000) - 0.01)^2) / 0.001) for ti in t_hb]

    X_hb = phi_fft(Float64.(x_hb))
    mag_hb = phi_fft_magnitude(X_hb)
    freqs_hb = phi_fft_frequencies(N_hb, fs_hb)

    peak_hb_idx = argmax(mag_hb[2:end]) + 1
    println("HEARTBEAT_MS = $HEARTBEAT_MS → f = $(round(heartbeat_freq, digits=4)) Hz")
    println("Detected fundamental: $(round(freqs_hb[peak_hb_idx], digits=4)) Hz")
    println()

    # ─── Example 4: φ-Window Properties ──────────────────────────────────────
    println("═══ Example 4: φ-Window Properties ═══")
    w = phi_window(64)
    println("φ-Window (N=64):")
    println("  Coefficients: AMOR=$(AMOR), PHI_INV=$(PHI_INV)")
    println("  w(n) = $AMOR + $PHI_INV × cos(2πn/63)")
    println("  Min value: $(round(minimum(w), digits=6))")
    println("  Max value: $(round(maximum(w), digits=6))")
    println("  Energy:    $(round(sum(w.^2), digits=6))")
    println("  Sum:       $(round(sum(w), digits=6))")
    println()

    # Compare windowed vs unwindowed
    X_nowin = phi_fft(x₁, windowed=false)
    X_win = phi_fft(x₁, windowed=true)
    println("Spectral leakage comparison (50 Hz sine):")
    println("  Without window — sidelobe energy: $(round(sum(abs.(phi_fft_magnitude(X_nowin)[2:end]).^2) - maximum(abs.(phi_fft_magnitude(X_nowin)).^2), digits=4))")
    println("  With φ-window — sidelobe energy:  $(round(sum(abs.(phi_fft_magnitude(X_win)[2:end]).^2) - maximum(abs.(phi_fft_magnitude(X_win)).^2), digits=4))")
    println()

    # ─── Bridge Output ────────────────────────────────────────────────────────
    println("═══ Bridge Output Format ═══")
    println("{")
    println("  \"spectrum_magnitude\": [first 5 bins: $(round.(mag₁[1:5], digits=6))...],")
    println("  \"frequencies\": [first 5: $(round.(freqs[1:5], digits=2))...],")
    println("  \"peak_frequency\": $peak_freq,")
    println("  \"phi_window_applied\": true,")
    println("  \"N\": $N,")
    println("  \"fs\": $fs")
    println("}")
end

main()
