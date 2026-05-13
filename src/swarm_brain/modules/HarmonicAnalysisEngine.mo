// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: HarmonicAnalysisEngine — Complete Harmonic and Fourier Analysis
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║              HARMONIC ANALYSIS ENGINE                                    ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  This engine implements complete harmonic and spectral analysis:         ║
// ║    • Fourier series and transforms                                       ║
// ║    • Spherical harmonics Y_l^m complete implementation                   ║
// ║    • Wavelet transforms (Haar, Daubechies, Morlet)                       ║
// ║    • Spectral decomposition                                              ║
// ║    • Convolution and correlation                                         ║
// ║    • Power spectral density                                              ║
// ║    • Hilbert transform                                                   ║
// ║    • Laplace transforms                                                  ║
// ║    • Legendre and Chebyshev polynomials                                  ║
// ║    • Bessel and Hankel functions                                         ║
// ║    • Zernike polynomials                                                 ║
// ║                                                                          ║
// ║  MULTIPLE RESPONSIBILITIES:                                              ║
// ║    1. Spectral decomposition                                             ║
// ║    2. Frequency analysis                                                 ║
// ║    3. Harmonic synthesis                                                 ║
// ║    4. Filter design                                                      ║
// ║    5. Signal processing                                                  ║
// ║    6. Pattern extraction                                                 ║
// ║    7. Basis transformation                                               ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MATHEMATICAL CONSTANTS                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public let phi : Float = 1.6180339887498948482;
  public let psi : Float = 0.6180339887498948482;
  public let τ : Float = 6.2831853071795864769;
  public let pi : Float = 3.1415926535897932385;
  public let e : Float = 2.7182818284590452354;
  public let √2 : Float = 1.4142135623730950488;
  public let √π : Float = 1.7724538509055160273;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COMPLEX NUMBER TYPE                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type Complex = {
    re : Float;
    im : Float;
  };

  public func complexZero() : Complex { { re = 0.0; im = 0.0 } };
  public func complexOne() : Complex { { re = 1.0; im = 0.0 } };
  public func complexI() : Complex { { re = 0.0; im = 1.0 } };

  public func complexFromReal(x : Float) : Complex { { re = x; im = 0.0 } };
  public func complexFromPolar(r : Float, theta : Float) : Complex {
    { re = r * Float.cos(theta); im = r * Float.sin(theta) }
  };

  public func complexAdd(a : Complex, b : Complex) : Complex {
    { re = a.re + b.re; im = a.im + b.im }
  };

  public func complexSub(a : Complex, b : Complex) : Complex {
    { re = a.re - b.re; im = a.im - b.im }
  };

  public func complexMul(a : Complex, b : Complex) : Complex {
    { re = a.re * b.re - a.im * b.im; im = a.re * b.im + a.im * b.re }
  };

  public func complexDiv(a : Complex, b : Complex) : Complex {
    let denom = b.re * b.re + b.im * b.im;
    if (denom < 1e-20) { return complexZero() };
    { re = (a.re * b.re + a.im * b.im) / denom; im = (a.im * b.re - a.re * b.im) / denom }
  };

  public func complexScale(c : Complex, s : Float) : Complex {
    { re = c.re * s; im = c.im * s }
  };

  public func complexConj(c : Complex) : Complex {
    { re = c.re; im = -c.im }
  };

  public func complexAbs(c : Complex) : Float {
    Float.sqrt(c.re * c.re + c.im * c.im)
  };

  public func complexArg(c : Complex) : Float {
    Float.arctan2(c.im, c.re)
  };

  public func complexExp(c : Complex) : Complex {
    let r = Float.exp(c.re);
    { re = r * Float.cos(c.im); im = r * Float.sin(c.im) }
  };

  public func complexLog(c : Complex) : Complex {
    { re = Float.log(complexAbs(c)); im = complexArg(c) }
  };

  public func complexPow(c : Complex, n : Float) : Complex {
    let r = Float.pow(complexAbs(c), n);
    let theta = n * complexArg(c);
    { re = r * Float.cos(theta); im = r * Float.sin(theta) }
  };

  public func complexSqrt(c : Complex) : Complex {
    let r = Float.sqrt(complexAbs(c));
    let theta = complexArg(c) / 2.0;
    { re = r * Float.cos(theta); im = r * Float.sin(theta) }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DISCRETE FOURIER TRANSFORM                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type FourierSpectrum = {
    frequencies : [Float];
    magnitudes : [Float];
    phases : [Float];
    complexCoeffs : [Complex];
  };

  // DFT: X[k] = Σ x[n] e^(-2πikn/N)
  public func dft(signal : [Float]) : [Complex] {
    let N = signal.size();
    
    Array.tabulate<Complex>(N, func(k : Nat) : Complex {
      var sum = complexZero();
      for (n in Iter.range(0, N - 1)) {
        let angle = -τ * Float.fromInt(k) * Float.fromInt(n) / Float.fromInt(N);
        let twiddle = complexFromPolar(1.0, angle);
        sum := complexAdd(sum, complexScale(twiddle, signal[n]));
      };
      sum
    })
  };

  // Inverse DFT: x[n] = (1/N) Σ X[k] e^(2πikn/N)
  public func idft(spectrum : [Complex]) : [Float] {
    let N = spectrum.size();
    
    Array.tabulate<Float>(N, func(n : Nat) : Float {
      var sum = complexZero();
      for (k in Iter.range(0, N - 1)) {
        let angle = τ * Float.fromInt(k) * Float.fromInt(n) / Float.fromInt(N);
        let twiddle = complexFromPolar(1.0, angle);
        sum := complexAdd(sum, complexMul(spectrum[k], twiddle));
      };
      sum.re / Float.fromInt(N)
    })
  };

  // Compute full spectrum with frequencies
  public func fourierAnalysis(signal : [Float], sampleRate : Float) : FourierSpectrum {
    let N = signal.size();
    let coeffs = dft(signal);
    
    let frequencies = Array.tabulate<Float>(N, func(k : Nat) : Float {
      if (k <= N / 2) {
        Float.fromInt(k) * sampleRate / Float.fromInt(N)
      } else {
        (Float.fromInt(k) - Float.fromInt(N)) * sampleRate / Float.fromInt(N)
      }
    });
    
    let magnitudes = Array.map<Complex, Float>(coeffs, complexAbs);
    let phases = Array.map<Complex, Float>(coeffs, complexArg);
    
    {
      frequencies = frequencies;
      magnitudes = magnitudes;
      phases = phases;
      complexCoeffs = coeffs;
    }
  };

  // FFT (Cooley-Tukey radix-2) - requires power-of-2 size
  public func fft(signal : [Float]) : [Complex] {
    let N = signal.size();
    
    // Base case
    if (N <= 1) {
      return [complexFromReal(if (N == 1) { signal[0] } else { 0.0 })];
    };
    
    // Ensure power of 2
    if (N % 2 != 0) {
      // Pad with zeros
      return dft(signal);
    };
    
    // Split into even/odd
    let even = Array.tabulate<Float>(N / 2, func(i : Nat) : Float { signal[2 * i] });
    let odd = Array.tabulate<Float>(N / 2, func(i : Nat) : Float { signal[2 * i + 1] });
    
    // Recursive FFT
    let evenFFT = fft(even);
    let oddFFT = fft(odd);
    
    // Combine
    Array.tabulate<Complex>(N, func(k : Nat) : Complex {
      let angle = -τ * Float.fromInt(k) / Float.fromInt(N);
      let twiddle = complexFromPolar(1.0, angle);
      
      let kMod = k % (N / 2);
      
      if (k < N / 2) {
        complexAdd(evenFFT[kMod], complexMul(twiddle, oddFFT[kMod]))
      } else {
        complexSub(evenFFT[kMod], complexMul(twiddle, oddFFT[kMod]))
      }
    })
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FOURIER SERIES                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type FourierSeries = {
    a0 : Float;          // DC component
    an : [Float];        // Cosine coefficients
    bn : [Float];        // Sine coefficients
    period : Float;
  };

  // Compute Fourier series coefficients
  public func fourierSeriesCoeffs(
    func_ : (Float) -> Float,
    period : Float,
    numTerms : Nat,
    numSamples : Nat
  ) : FourierSeries {
    let L = period / 2.0;
    let dx = period / Float.fromInt(numSamples);
    
    // a0 = (1/L) ∫ f(x) dx
    var a0 : Float = 0.0;
    for (i in Iter.range(0, numSamples - 1)) {
      let x = -L + Float.fromInt(i) * dx;
      a0 += func_(x) * dx;
    };
    a0 /= period;
    
    // an = (2/L) ∫ f(x) cos(nπx/L) dx
    let an = Array.tabulate<Float>(numTerms, func(n : Nat) : Float {
      if (n == 0) { return 0.0 };
      
      var coeff : Float = 0.0;
      for (i in Iter.range(0, numSamples - 1)) {
        let x = -L + Float.fromInt(i) * dx;
        coeff += func_(x) * Float.cos(Float.fromInt(n) * π * x / L) * dx;
      };
      2.0 * coeff / period
    });
    
    // bn = (2/L) ∫ f(x) sin(nπx/L) dx
    let bn = Array.tabulate<Float>(numTerms, func(n : Nat) : Float {
      if (n == 0) { return 0.0 };
      
      var coeff : Float = 0.0;
      for (i in Iter.range(0, numSamples - 1)) {
        let x = -L + Float.fromInt(i) * dx;
        coeff += func_(x) * Float.sin(Float.fromInt(n) * π * x / L) * dx;
      };
      2.0 * coeff / period
    });
    
    { a0 = a0; an = an; bn = bn; period = period }
  };

  // Evaluate Fourier series at point
  public func evaluateFourierSeries(series : FourierSeries, x : Float) : Float {
    let L = series.period / 2.0;
    
    var result = series.a0;
    for (n in Iter.range(1, series.an.size() - 1)) {
      result += series.an[n] * Float.cos(Float.fromInt(n) * π * x / L);
      result += series.bn[n] * Float.sin(Float.fromInt(n) * π * x / L);
    };
    
    result
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SPHERICAL HARMONICS                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Associated Legendre polynomial P_l^m(x)
  public func legendreP(l : Nat, m : Int, x : Float) : Float {
    let absM = Int.abs(m);
    
    if (absM > l) { return 0.0 };
    
    // P_m^m(x) = (-1)^m (2m-1)!! (1-x²)^(m/2)
    var pmm : Float = 1.0;
    if (absM > 0) {
      let somx2 = Float.sqrt((1.0 - x) * (1.0 + x));
      var fact : Float = 1.0;
      for (_i in Iter.range(1, absM)) {
        pmm *= -fact * somx2;
        fact += 2.0;
      };
    };
    
    if (l == absM) { return pmm };
    
    // P_{m+1}^m(x) = x(2m+1)P_m^m(x)
    var pmmp1 = x * Float.fromInt(2 * absM + 1) * pmm;
    if (l == absM + 1) { return pmmp1 };
    
    // Recurrence
    var pll : Float = 0.0;
    for (ll in Iter.range(absM + 2, l)) {
      pll := (x * Float.fromInt(2 * ll - 1) * pmmp1 - Float.fromInt(ll + absM - 1) * pmm) / Float.fromInt(ll - absM);
      pmm := pmmp1;
      pmmp1 := pll;
    };
    
    pll
  };

  // Factorial
  func factorial(n : Nat) : Float {
    var result : Float = 1.0;
    for (i in Iter.range(2, n)) {
      result *= Float.fromInt(i);
    };
    result
  };

  // Real spherical harmonic Y_l^m(θ, φ)
  public func sphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : Float {
    let absM = Int.abs(m);
    
    // Normalization
    let norm = Float.sqrt(
      Float.fromInt(2 * l + 1) / (4.0 * π) *
      factorial(l - absM) / factorial(l + absM)
    );
    
    let plm = legendreP(l, m, Float.cos(theta));
    
    if (m > 0) {
      norm * √2 * Float.cos(Float.fromInt(m) * phi) * plm
    } else if (m < 0) {
      norm * √2 * Float.sin(Float.fromInt(-m) * phi) * plm
    } else {
      norm * plm
    }
  };

  // Complex spherical harmonic
  public func complexSphericalHarmonic(l : Nat, m : Int, theta : Float, phi : Float) : Complex {
    let absM = Int.abs(m);
    
    let norm = Float.sqrt(
      Float.fromInt(2 * l + 1) / (4.0 * π) *
      factorial(l - absM) / factorial(l + absM)
    );
    
    let plm = legendreP(l, m, Float.cos(theta));
    let mPhi = Float.fromInt(m) * phi;
    
    {
      re = norm * plm * Float.cos(mPhi);
      im = norm * plm * Float.sin(mPhi);
    }
  };

  // Decompose function into spherical harmonics
  public func sphericalHarmonicDecomposition(
    func_ : (Float, Float) -> Float,  // f(θ, φ)
    maxL : Nat,
    thetaSamples : Nat,
    phiSamples : Nat
  ) : [[Float]] {
    // Coefficients c_l^m
    Array.tabulate<[Float]>(maxL + 1, func(l : Nat) : [Float] {
      Array.tabulate<Float>(2 * l + 1, func(mIdx : Nat) : Float {
        let m = Int.sub(mIdx, l);
        
        // c_l^m = ∫∫ f(θ,φ) Y_l^m(θ,φ) sin(θ) dθ dφ
        var integral : Float = 0.0;
        let dTheta = π / Float.fromInt(thetaSamples);
        let dPhi = τ / Float.fromInt(phiSamples);
        
        for (i in Iter.range(0, thetaSamples - 1)) {
          let theta = Float.fromInt(i) * dTheta + dTheta / 2.0;
          for (j in Iter.range(0, phiSamples - 1)) {
            let phi = Float.fromInt(j) * dPhi;
            
            let fVal = func_(theta, phi);
            let ylm = sphericalHarmonic(l, m, theta, phi);
            let weight = Float.sin(theta) * dTheta * dPhi;
            
            integral += fVal * ylm * weight;
          };
        };
        
        integral
      })
    })
  };

  // Reconstruct function from spherical harmonic coefficients
  public func reconstructFromSphericalHarmonics(
    coeffs : [[Float]],
    theta : Float,
    phi : Float
  ) : Float {
    var result : Float = 0.0;
    
    for (l in Iter.range(0, coeffs.size() - 1)) {
      for (mIdx in Iter.range(0, coeffs[l].size() - 1)) {
        let m = Int.sub(mIdx, l);
        let ylm = sphericalHarmonic(l, m, theta, phi);
        result += coeffs[l][mIdx] * ylm;
      };
    };
    
    result
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WAVELET TRANSFORMS                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type WaveletCoeffs = {
    approximation : [Float];
    details : [[Float]];
    levels : Nat;
  };

  // Haar wavelet decomposition
  public func haarDecomposition(signal : [Float], levels : Nat) : WaveletCoeffs {
    var approx = signal;
    let details = Buffer.Buffer<[Float]>(levels);
    
    for (_level in Iter.range(0, levels - 1)) {
      let n = approx.size();
      if (n < 2) { break };
      
      let newN = n / 2;
      var newApprox = Buffer.Buffer<Float>(newN);
      var detail = Buffer.Buffer<Float>(newN);
      
      for (i in Iter.range(0, newN - 1)) {
        let a = approx[2 * i];
        let b = approx[2 * i + 1];
        newApprox.add((a + b) / √2);
        detail.add((a - b) / √2);
      };
      
      approx := Buffer.toArray(newApprox);
      details.add(Buffer.toArray(detail));
    };
    
    {
      approximation = approx;
      details = Buffer.toArray(details);
      levels = details.size();
    }
  };

  // Haar wavelet reconstruction
  public func haarReconstruction(coeffs : WaveletCoeffs) : [Float] {
    var signal = coeffs.approximation;
    
    // Go backwards through detail levels
    var level = coeffs.levels;
    while (level > 0) {
      level -= 1;
      let detail = coeffs.details[level];
      let n = signal.size();
      
      var newSignal = Buffer.Buffer<Float>(2 * n);
      for (i in Iter.range(0, n - 1)) {
        let a = signal[i];
        let d = detail[i];
        newSignal.add((a + d) / √2);
        newSignal.add((a - d) / √2);
      };
      
      signal := Buffer.toArray(newSignal);
    };
    
    signal
  };

  // Daubechies D4 wavelet coefficients
  let d4_h0 : Float = (1.0 + Float.sqrt(3.0)) / (4.0 * √2);
  let d4_h1 : Float = (3.0 + Float.sqrt(3.0)) / (4.0 * √2);
  let d4_h2 : Float = (3.0 - Float.sqrt(3.0)) / (4.0 * √2);
  let d4_h3 : Float = (1.0 - Float.sqrt(3.0)) / (4.0 * √2);

  // Daubechies D4 decomposition
  public func daubechiesD4Decomposition(signal : [Float], levels : Nat) : WaveletCoeffs {
    var approx = signal;
    let details = Buffer.Buffer<[Float]>(levels);
    
    for (_level in Iter.range(0, levels - 1)) {
      let n = approx.size();
      if (n < 4) { break };
      
      let newN = n / 2;
      var newApprox = Buffer.Buffer<Float>(newN);
      var detail = Buffer.Buffer<Float>(newN);
      
      for (i in Iter.range(0, newN - 1)) {
        let idx = 2 * i;
        
        // Low-pass (approximation)
        var low : Float = 0.0;
        low += d4_h0 * approx[idx % n];
        low += d4_h1 * approx[(idx + 1) % n];
        low += d4_h2 * approx[(idx + 2) % n];
        low += d4_h3 * approx[(idx + 3) % n];
        newApprox.add(low);
        
        // High-pass (detail)
        var high : Float = 0.0;
        high += d4_h3 * approx[idx % n];
        high += -d4_h2 * approx[(idx + 1) % n];
        high += d4_h1 * approx[(idx + 2) % n];
        high += -d4_h0 * approx[(idx + 3) % n];
        detail.add(high);
      };
      
      approx := Buffer.toArray(newApprox);
      details.add(Buffer.toArray(detail));
    };
    
    {
      approximation = approx;
      details = Buffer.toArray(details);
      levels = details.size();
    }
  };

  // Morlet wavelet ψ(t) = π^(-1/4) e^(iω₀t) e^(-t²/2)
  public func morletWavelet(t : Float, omega0 : Float) : Complex {
    let envelope = Float.pow(π, -0.25) * Float.exp(-t * t / 2.0);
    {
      re = envelope * Float.cos(omega0 * t);
      im = envelope * Float.sin(omega0 * t);
    }
  };

  // Continuous wavelet transform with Morlet
  public func morletCWT(
    signal : [Float],
    scales : [Float],
    omega0 : Float
  ) : [[Complex]] {
    let N = signal.size();
    
    Array.tabulate<[Complex]>(scales.size(), func(scaleIdx : Nat) : [Complex] {
      let scale = scales[scaleIdx];
      
      Array.tabulate<Complex>(N, func(b : Nat) : Complex {
        // W(a,b) = (1/√a) Σ x[n] ψ*((n-b)/a)
        var sum = complexZero();
        
        for (n in Iter.range(0, N - 1)) {
          let t = (Float.fromInt(n) - Float.fromInt(b)) / scale;
          let wavelet = morletWavelet(t, omega0);
          let conj = complexConj(wavelet);
          sum := complexAdd(sum, complexScale(conj, signal[n]));
        };
        
        complexScale(sum, 1.0 / Float.sqrt(scale))
      })
    })
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     POWER SPECTRAL DENSITY                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type PowerSpectrum = {
    frequencies : [Float];
    power : [Float];
    totalPower : Float;
    dominantFreq : Float;
  };

  // Periodogram PSD estimate
  public func periodogram(signal : [Float], sampleRate : Float) : PowerSpectrum {
    let N = signal.size();
    let spectrum = dft(signal);
    
    let frequencies = Array.tabulate<Float>(N / 2, func(k : Nat) : Float {
      Float.fromInt(k) * sampleRate / Float.fromInt(N)
    });
    
    let power = Array.tabulate<Float>(N / 2, func(k : Nat) : Float {
      let mag = complexAbs(spectrum[k]);
      mag * mag / Float.fromInt(N)
    });
    
    var totalPower : Float = 0.0;
    var maxPower : Float = 0.0;
    var dominantFreq : Float = 0.0;
    
    for (k in Iter.range(0, power.size() - 1)) {
      totalPower += power[k];
      if (power[k] > maxPower) {
        maxPower := power[k];
        dominantFreq := frequencies[k];
      };
    };
    
    {
      frequencies = frequencies;
      power = power;
      totalPower = totalPower;
      dominantFreq = dominantFreq;
    }
  };

  // Welch's method for smoother PSD
  public func welchPSD(
    signal : [Float],
    sampleRate : Float,
    segmentSize : Nat,
    overlap : Float
  ) : PowerSpectrum {
    let N = signal.size();
    let step = Int.abs(Float.toInt(Float.fromInt(segmentSize) * (1.0 - overlap)));
    let numSegments = (N - segmentSize) / step + 1;
    
    // Hann window
    let window = Array.tabulate<Float>(segmentSize, func(n : Nat) : Float {
      0.5 * (1.0 - Float.cos(τ * Float.fromInt(n) / Float.fromInt(segmentSize - 1)))
    });
    
    // Accumulate power spectra
    var avgPower = Array.tabulate<Float>(segmentSize / 2, func(_ : Nat) : Float { 0.0 });
    
    for (seg in Iter.range(0, numSegments - 1)) {
      let start = seg * step;
      
      // Extract and window segment
      let segment = Array.tabulate<Float>(segmentSize, func(n : Nat) : Float {
        if (start + n < N) {
          signal[start + n] * window[n]
        } else { 0.0 }
      });
      
      let spectrum = dft(segment);
      
      // Add power
      avgPower := Array.tabulate<Float>(segmentSize / 2, func(k : Nat) : Float {
        let mag = complexAbs(spectrum[k]);
        avgPower[k] + mag * mag
      });
    };
    
    // Average
    let power = Array.map<Float, Float>(avgPower, func(p : Float) : Float {
      p / Float.fromInt(numSegments * segmentSize)
    });
    
    let frequencies = Array.tabulate<Float>(segmentSize / 2, func(k : Nat) : Float {
      Float.fromInt(k) * sampleRate / Float.fromInt(segmentSize)
    });
    
    var totalPower : Float = 0.0;
    var maxPower : Float = 0.0;
    var dominantFreq : Float = 0.0;
    
    for (k in Iter.range(0, power.size() - 1)) {
      totalPower += power[k];
      if (power[k] > maxPower) {
        maxPower := power[k];
        dominantFreq := frequencies[k];
      };
    };
    
    {
      frequencies = frequencies;
      power = power;
      totalPower = totalPower;
      dominantFreq = dominantFreq;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HILBERT TRANSFORM                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type AnalyticSignal = {
    amplitude : [Float];     // Instantaneous amplitude
    phase : [Float];         // Instantaneous phase
    frequency : [Float];     // Instantaneous frequency
    signal : [Complex];      // Complex analytic signal
  };

  // Hilbert transform: H[x](t) = (1/π) P.V. ∫ x(τ)/(t-τ) dτ
  public func hilbertTransform(signal : [Float]) : [Float] {
    let N = signal.size();
    let spectrum = dft(signal);
    
    // Multiply positive frequencies by -i, negative by +i
    let hilbertSpectrum = Array.tabulate<Complex>(N, func(k : Nat) : Complex {
      if (k == 0 or k == N / 2) {
        spectrum[k]  // DC and Nyquist unchanged
      } else if (k < N / 2) {
        // Positive freq: multiply by -i
        { re = spectrum[k].im; im = -spectrum[k].re }
      } else {
        // Negative freq: multiply by +i
        { re = -spectrum[k].im; im = spectrum[k].re }
      }
    });
    
    idft(hilbertSpectrum)
  };

  // Compute analytic signal and instantaneous properties
  public func analyticSignal(signal : [Float], sampleRate : Float) : AnalyticSignal {
    let hilbert = hilbertTransform(signal);
    let N = signal.size();
    
    let complexSignal = Array.tabulate<Complex>(N, func(n : Nat) : Complex {
      { re = signal[n]; im = hilbert[n] }
    });
    
    let amplitude = Array.map<Complex, Float>(complexSignal, complexAbs);
    let phase = Array.map<Complex, Float>(complexSignal, complexArg);
    
    // Instantaneous frequency = (1/2π) dφ/dt
    let frequency = Array.tabulate<Float>(N, func(n : Nat) : Float {
      if (n == 0 or n == N - 1) {
        0.0
      } else {
        var dPhase = phase[n + 1] - phase[n - 1];
        // Unwrap phase
        while (dPhase > π) { dPhase -= τ };
        while (dPhase < -π) { dPhase += τ };
        dPhase * sampleRate / (τ * 2.0)
      }
    });
    
    {
      amplitude = amplitude;
      phase = phase;
      frequency = frequency;
      signal = complexSignal;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ORTHOGONAL POLYNOMIALS                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Chebyshev polynomial T_n(x)
  public func chebyshevT(n : Nat, x : Float) : Float {
    if (n == 0) { return 1.0 };
    if (n == 1) { return x };
    
    var t0 : Float = 1.0;
    var t1 : Float = x;
    var tn : Float = x;
    
    for (_k in Iter.range(2, n)) {
      tn := 2.0 * x * t1 - t0;
      t0 := t1;
      t1 := tn;
    };
    
    tn
  };

  // Chebyshev polynomial U_n(x) (second kind)
  public func chebyshevU(n : Nat, x : Float) : Float {
    if (n == 0) { return 1.0 };
    if (n == 1) { return 2.0 * x };
    
    var u0 : Float = 1.0;
    var u1 : Float = 2.0 * x;
    var un : Float = 2.0 * x;
    
    for (_k in Iter.range(2, n)) {
      un := 2.0 * x * u1 - u0;
      u0 := u1;
      u1 := un;
    };
    
    un
  };

  // Hermite polynomial H_n(x)
  public func hermite(n : Nat, x : Float) : Float {
    if (n == 0) { return 1.0 };
    if (n == 1) { return 2.0 * x };
    
    var h0 : Float = 1.0;
    var h1 : Float = 2.0 * x;
    var hn : Float = 2.0 * x;
    
    for (k in Iter.range(2, n)) {
      hn := 2.0 * x * h1 - 2.0 * Float.fromInt(k - 1) * h0;
      h0 := h1;
      h1 := hn;
    };
    
    hn
  };

  // Laguerre polynomial L_n(x)
  public func laguerre(n : Nat, x : Float) : Float {
    if (n == 0) { return 1.0 };
    if (n == 1) { return 1.0 - x };
    
    var l0 : Float = 1.0;
    var l1 : Float = 1.0 - x;
    var ln : Float = 1.0 - x;
    
    for (k in Iter.range(2, n)) {
      let kf = Float.fromInt(k);
      ln := ((2.0 * kf - 1.0 - x) * l1 - (kf - 1.0) * l0) / kf;
      l0 := l1;
      l1 := ln;
    };
    
    ln
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BESSEL FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Bessel function of first kind J_n(x) via series
  public func besselJ(n : Nat, x : Float) : Float {
    var sum : Float = 0.0;
    let xHalf = x / 2.0;
    
    for (m in Iter.range(0, 50)) {
      let sign = if (m % 2 == 0) { 1.0 } else { -1.0 };
      let term = sign * Float.pow(xHalf, Float.fromInt(2 * m + n)) / 
                (factorial(m) * factorial(m + n));
      sum += term;
      if (Float.abs(term) < 1e-15) { break };
    };
    
    sum
  };

  // Bessel function of second kind Y_n(x) (Neumann function)
  public func besselY(n : Nat, x : Float) : Float {
    // Use relation: Y_n(x) = [J_n(x)cos(nπ) - J_{-n}(x)] / sin(nπ)
    // For integer n, use limiting form
    
    let gamma = 0.5772156649015329;  // Euler-Mascheroni constant
    
    if (n == 0) {
      // Y_0(x) = (2/π)[J_0(x)(ln(x/2) + γ) + series]
      let j0 = besselJ(0, x);
      (2.0 / π) * (j0 * (Float.log(x / 2.0) + gamma))
    } else {
      // Numerical approximation
      let h = 0.01;
      (besselJ(n, x + h) - besselJ(n, x - h)) / (2.0 * h * Float.cos(Float.fromInt(n) * π))
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ZERNIKE POLYNOMIALS                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Zernike radial polynomial R_n^m(ρ)
  public func zernikeRadial(n : Nat, m : Nat, rho : Float) : Float {
    if ((n - m) % 2 != 0) { return 0.0 };
    
    var sum : Float = 0.0;
    let numTerms = (n - m) / 2;
    
    for (k in Iter.range(0, numTerms)) {
      let sign = if (k % 2 == 0) { 1.0 } else { -1.0 };
      let num = sign * factorial(n - k);
      let den = factorial(k) * factorial((n + m) / 2 - k) * factorial((n - m) / 2 - k);
      sum += num / den * Float.pow(rho, Float.fromInt(n - 2 * k));
    };
    
    sum
  };

  // Zernike polynomial Z_n^m(ρ, θ)
  public func zernike(n : Nat, m : Int, rho : Float, theta : Float) : Float {
    let absM = Int.abs(m);
    let R = zernikeRadial(n, absM, rho);
    
    if (m >= 0) {
      R * Float.cos(Float.fromInt(absM) * theta)
    } else {
      R * Float.sin(Float.fromInt(absM) * theta)
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONVOLUTION AND CORRELATION                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Linear convolution (f * g)[n] = Σ f[k] g[n-k]
  public func convolve(f : [Float], g : [Float]) : [Float] {
    let N = f.size();
    let M = g.size();
    let L = N + M - 1;
    
    Array.tabulate<Float>(L, func(n : Nat) : Float {
      var sum : Float = 0.0;
      for (k in Iter.range(0, N - 1)) {
        let idx = Int.sub(n, k);
        if (idx >= 0 and idx < M) {
          sum += f[k] * g[Int.abs(idx)];
        };
      };
      sum
    })
  };

  // Cross-correlation (f ⋆ g)[n] = Σ f*[k] g[n+k]
  public func crossCorrelation(f : [Float], g : [Float]) : [Float] {
    let N = f.size();
    let M = g.size();
    let L = N + M - 1;
    
    Array.tabulate<Float>(L, func(n : Nat) : Float {
      var sum : Float = 0.0;
      let shift = Int.sub(n, N - 1);
      
      for (k in Iter.range(0, N - 1)) {
        let idx = Int.add(shift, k);
        if (idx >= 0 and idx < M) {
          sum += f[k] * g[Int.abs(idx)];
        };
      };
      sum
    })
  };

  // Autocorrelation
  public func autocorrelation(signal : [Float]) : [Float] {
    crossCorrelation(signal, signal)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FILTER DESIGN                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type Filter = {
    coefficients : [Float];
    filterType : FilterType;
    cutoffFreq : Float;
  };

  public type FilterType = {
    #LowPass;
    #HighPass;
    #BandPass;
    #BandStop;
  };

  // Sinc function
  func sinc(x : Float) : Float {
    if (Float.abs(x) < 1e-10) { 1.0 } else { Float.sin(π * x) / (π * x) }
  };

  // FIR low-pass filter using windowed sinc
  public func designLowPassFIR(cutoff : Float, sampleRate : Float, numTaps : Nat) : Filter {
    let fc = cutoff / sampleRate;  // Normalized cutoff
    let M = numTaps - 1;
    
    let coeffs = Array.tabulate<Float>(numTaps, func(n : Nat) : Float {
      let x = Float.fromInt(n) - Float.fromInt(M) / 2.0;
      
      // Ideal impulse response
      let h = 2.0 * fc * sinc(2.0 * fc * x);
      
      // Hamming window
      let w = 0.54 - 0.46 * Float.cos(τ * Float.fromInt(n) / Float.fromInt(M));
      
      h * w
    });
    
    { coefficients = coeffs; filterType = #LowPass; cutoffFreq = cutoff }
  };

  // Apply FIR filter
  public func applyFilter(filter : Filter, signal : [Float]) : [Float] {
    convolve(signal, filter.coefficients)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ENGINE RESPONSIBILITIES                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type HarmonicResponsibility = {
    #SpectralDecomposition;
    #FrequencyAnalysis;
    #HarmonicSynthesis;
    #FilterDesign;
    #SignalProcessing;
    #PatternExtraction;
    #BasisTransformation;
  };

  public type HarmonicAnalysisEngine = {
    id : Nat;
    responsibilities : [HarmonicResponsibility];
    currentSpectrum : ?FourierSpectrum;
    currentWavelets : ?WaveletCoeffs;
    state : HarmonicState;
  };

  public type HarmonicState = {
    dominantFrequency : Float;
    spectralEntropy : Float;
    energy : Float;
    coherence : Float;
  };

  public func createHarmonicEngine(id : Nat) : HarmonicAnalysisEngine {
    {
      id = id;
      responsibilities = [
        #SpectralDecomposition,
        #FrequencyAnalysis,
        #HarmonicSynthesis,
        #FilterDesign,
        #SignalProcessing,
        #PatternExtraction,
        #BasisTransformation
      ];
      currentSpectrum = null;
      currentWavelets = null;
      state = {
        dominantFrequency = 0.0;
        spectralEntropy = 0.0;
        energy = 1.0;
        coherence = 1.0;
      };
    }
  };

  // Execute all responsibilities
  public func executeAllResponsibilities(
    engine : HarmonicAnalysisEngine,
    signal : [Float],
    sampleRate : Float
  ) : (HarmonicAnalysisEngine, [Float]) {
    let outputs = Buffer.Buffer<Float>(engine.responsibilities.size());
    
    let spectrum = fourierAnalysis(signal, sampleRate);
    let wavelets = haarDecomposition(signal, 4);
    
    for (resp in engine.responsibilities.vals()) {
      let output = executeResponsibility(resp, signal, spectrum, wavelets, sampleRate);
      outputs.add(output);
    };
    
    // Compute spectral entropy
    var totalPower : Float = 0.0;
    for (p in spectrum.magnitudes.vals()) {
      totalPower += p * p;
    };
    
    var entropy : Float = 0.0;
    if (totalPower > 0.0) {
      for (p in spectrum.magnitudes.vals()) {
        let prob = p * p / totalPower;
        if (prob > 0.0) {
          entropy -= prob * Float.log(prob);
        };
      };
    };
    
    let newEngine : HarmonicAnalysisEngine = {
      id = engine.id;
      responsibilities = engine.responsibilities;
      currentSpectrum = ?spectrum;
      currentWavelets = ?wavelets;
      state = {
        dominantFrequency = findDominantFrequency(spectrum);
        spectralEntropy = entropy;
        energy = totalPower;
        coherence = engine.state.coherence;
      };
    };
    
    (newEngine, Buffer.toArray(outputs))
  };

  func executeResponsibility(
    resp : HarmonicResponsibility,
    signal : [Float],
    spectrum : FourierSpectrum,
    wavelets : WaveletCoeffs,
    sampleRate : Float
  ) : Float {
    switch (resp) {
      case (#SpectralDecomposition) {
        // Return number of significant frequency components
        var count : Nat = 0;
        let threshold = maxMagnitude(spectrum.magnitudes) * 0.1;
        for (mag in spectrum.magnitudes.vals()) {
          if (mag > threshold) { count += 1 };
        };
        Float.fromInt(count)
      };
      case (#FrequencyAnalysis) {
        findDominantFrequency(spectrum)
      };
      case (#HarmonicSynthesis) {
        // Return quality of reconstruction
        let reconstructed = idft(spectrum.complexCoeffs);
        var error : Float = 0.0;
        for (i in Iter.range(0, signal.size() - 1)) {
          let diff = signal[i] - reconstructed[i];
          error += diff * diff;
        };
        1.0 / (1.0 + Float.sqrt(error))
      };
      case (#FilterDesign) {
        // Return suggested cutoff based on spectrum
        findDominantFrequency(spectrum) * 2.0
      };
      case (#SignalProcessing) {
        // Return signal-to-noise estimate
        let psd = periodogram(signal, sampleRate);
        psd.totalPower
      };
      case (#PatternExtraction) {
        // Return wavelet energy concentration
        var totalEnergy : Float = 0.0;
        for (d in wavelets.details.vals()) {
          for (c in d.vals()) {
            totalEnergy += c * c;
          };
        };
        for (a in wavelets.approximation.vals()) {
          totalEnergy += a * a;
        };
        totalEnergy
      };
      case (#BasisTransformation) {
        // Return basis completeness measure
        Float.fromInt(spectrum.frequencies.size())
      };
    }
  };

  func findDominantFrequency(spectrum : FourierSpectrum) : Float {
    var maxMag : Float = 0.0;
    var domFreq : Float = 0.0;
    
    for (i in Iter.range(1, spectrum.magnitudes.size() - 1)) {
      if (spectrum.magnitudes[i] > maxMag) {
        maxMag := spectrum.magnitudes[i];
        domFreq := spectrum.frequencies[i];
      };
    };
    
    domFreq
  };

  func maxMagnitude(mags : [Float]) : Float {
    var max : Float = 0.0;
    for (m in mags.vals()) {
      if (m > max) { max := m };
    };
    max
  };

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║     CROSS-ENGINE COUPLING ARCHITECTURE — EVERYTHING INTERWEAVES          ║
  // ╠══════════════════════════════════════════════════════════════════════════╣
  // ║  Harmonic ↔ Kuramoto ↔ Friston ↔ Hebbian ↔ Physics ↔ Entropy ↔ Quantum   ║
  // ║  Spectral ↔ Attractor ↔ Predictive ↔ Tensor ↔ Topology ↔ FreeEnergy      ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  // ============================================================================
  // KURAMOTO COUPLING — Phase oscillators meet harmonic analysis
  // ============================================================================

  public type KuramotoCoupling = {
    phaseSpectrum : FourierSpectrum;
    orderParameterSpectrum : [Float];
    synchronizationFrequencies : [Float];
    phaseLocking : Float;
    harmonicOrderParameter : Float;
    spectralCoherence : Float;
    kuramotoHarmonics : [Float];
    circularMoments : [Complex];
  };

  public func initKuramotoCoupling(numOscillators : Nat) : KuramotoCoupling {
    {
      phaseSpectrum = {
        frequencies = Array.tabulate<Float>(numOscillators, func(i : Nat) : Float {
          Float.fromInt(i) / Float.fromInt(numOscillators)
        });
        magnitudes = Array.tabulate<Float>(numOscillators, func(_ : Nat) : Float { 0.5 });
        phases = Array.tabulate<Float>(numOscillators, func(i : Nat) : Float {
          Float.fromInt(i) * τ / Float.fromInt(numOscillators)
        });
        complexCoeffs = Array.tabulate<Complex>(numOscillators, func(i : Nat) : Complex {
          complexFromPolar(0.5, Float.fromInt(i) * τ / Float.fromInt(numOscillators))
        });
      };
      orderParameterSpectrum = Array.tabulate<Float>(numOscillators, func(_ : Nat) : Float { 0.0 });
      synchronizationFrequencies = Array.tabulate<Float>(5, func(i : Nat) : Float {
        Float.fromInt(i + 1)
      });
      phaseLocking = 0.0;
      harmonicOrderParameter = 0.0;
      spectralCoherence = 0.0;
      kuramotoHarmonics = Array.tabulate<Float>(10, func(_ : Nat) : Float { 0.0 });
      circularMoments = Array.tabulate<Complex>(5, func(_ : Nat) : Complex { complexZero() });
    }
  };

  // Compute Fourier transform of Kuramoto phases
  public func kuramotoPhaseSpectrum(phases : [Float], sampleRate : Float) : FourierSpectrum {
    let signal = Array.map<Float, Float>(phases, func(phase : Float) : Float {
      Float.cos(phase)
    });
    dft(signal, sampleRate)
  };

  // Circular harmonics - Fourier on the circle
  public func circularHarmonics(phases : [Float], maxHarmonic : Nat) : [Complex] {
    Array.tabulate<Complex>(maxHarmonic, func(n : Nat) : Complex {
      var sum = complexZero();
      for (phase in phases.vals()) {
        let term = complexFromPolar(1.0 / Float.fromInt(phases.size()), Float.fromInt(n + 1) * phase);
        sum := complexAdd(sum, term);
      };
      sum
    })
  };

  // Harmonic order parameters r_n = |Z_n|
  public func harmonicOrderParameters(phases : [Float], maxHarmonic : Nat) : [Float] {
    let harmonics = circularHarmonics(phases, maxHarmonic);
    Array.map<Complex, Float>(harmonics, func(z : Complex) : Float {
      complexMagnitude(z)
    })
  };

  // Spectral coherence between oscillators
  public func kuramotoSpectralCoherence(coupling : KuramotoCoupling) : Float {
    var totalCoherence : Float = 0.0;
    let n = coupling.phaseSpectrum.complexCoeffs.size();
    
    for (i in Iter.range(0, n - 2)) {
      for (j in Iter.range(i + 1, n - 1)) {
        let crossSpectrum = complexMul(coupling.phaseSpectrum.complexCoeffs[i],
                                       complexConj(coupling.phaseSpectrum.complexCoeffs[j]));
        let coherence = complexMagnitude(crossSpectrum);
        totalCoherence += coherence;
      };
    };
    
    if (n > 1) { 2.0 * totalCoherence / Float.fromInt(n * (n - 1)) } else { 0.0 }
  };

  // ============================================================================
  // FRISTON FREE ENERGY COUPLING — Spectral free energy minimization
  // ============================================================================

  public type FristonCoupling = {
    beliefSpectrum : FourierSpectrum;
    predictionSpectrum : FourierSpectrum;
    errorSpectrum : FourierSpectrum;
    spectralFreeEnergy : Float;
    spectralPrecision : [Float];
    frequencyBeliefs : [Float];
    harmonicPriors : [Complex];
    spectralSurprise : Float;
  };

  public func initFristonCoupling(dim : Nat) : FristonCoupling {
    let zeroSpectrum = {
      frequencies = Array.tabulate<Float>(dim, func(i : Nat) : Float { Float.fromInt(i) });
      magnitudes = Array.tabulate<Float>(dim, func(_ : Nat) : Float { 0.0 });
      phases = Array.tabulate<Float>(dim, func(_ : Nat) : Float { 0.0 });
      complexCoeffs = Array.tabulate<Complex>(dim, func(_ : Nat) : Complex { complexZero() });
    };
    
    {
      beliefSpectrum = zeroSpectrum;
      predictionSpectrum = zeroSpectrum;
      errorSpectrum = zeroSpectrum;
      spectralFreeEnergy = 0.0;
      spectralPrecision = Array.tabulate<Float>(dim, func(_ : Nat) : Float { 1.0 });
      frequencyBeliefs = Array.tabulate<Float>(dim, func(_ : Nat) : Float { 0.5 });
      harmonicPriors = Array.tabulate<Complex>(dim, func(_ : Nat) : Complex { complexOne() });
      spectralSurprise = 0.0;
    }
  };

  // Compute spectral free energy F = Σ_ω π(ω) |ε(ω)|²
  public func computeSpectralFreeEnergy(coupling : FristonCoupling) : Float {
    var F : Float = 0.0;
    for (i in Iter.range(0, coupling.errorSpectrum.magnitudes.size() - 1)) {
      let precision = coupling.spectralPrecision[i];
      let errorMag = coupling.errorSpectrum.magnitudes[i];
      F += precision * errorMag * errorMag;
    };
    F / 2.0
  };

  // Spectral prediction error
  public func spectralPredictionError(observation : FourierSpectrum, prediction : FourierSpectrum) : FourierSpectrum {
    let n = observation.complexCoeffs.size();
    {
      frequencies = observation.frequencies;
      magnitudes = Array.tabulate<Float>(n, func(i : Nat) : Float {
        let obsCoeff = observation.complexCoeffs[i];
        let predCoeff = prediction.complexCoeffs[i];
        let error = complexSub(obsCoeff, predCoeff);
        complexMagnitude(error)
      });
      phases = Array.tabulate<Float>(n, func(i : Nat) : Float {
        let obsCoeff = observation.complexCoeffs[i];
        let predCoeff = prediction.complexCoeffs[i];
        let error = complexSub(obsCoeff, predCoeff);
        complexPhase(error)
      });
      complexCoeffs = Array.tabulate<Complex>(n, func(i : Nat) : Complex {
        complexSub(observation.complexCoeffs[i], prediction.complexCoeffs[i])
      });
    }
  };

  // Update beliefs in frequency domain
  public func spectralBeliefUpdate(coupling : FristonCoupling, learningRate : Float) : FristonCoupling {
    let n = coupling.beliefSpectrum.complexCoeffs.size();
    
    let newBeliefCoeffs = Array.tabulate<Complex>(n, func(i : Nat) : Complex {
      let belief = coupling.beliefSpectrum.complexCoeffs[i];
      let error = coupling.errorSpectrum.complexCoeffs[i];
      let precision = coupling.spectralPrecision[i];
      
      // Gradient descent on spectral free energy
      let gradientStep = complexScale(error, learningRate * precision);
      complexAdd(belief, gradientStep)
    });
    
    {
      beliefSpectrum = {
        frequencies = coupling.beliefSpectrum.frequencies;
        magnitudes = Array.map<Complex, Float>(newBeliefCoeffs, complexMagnitude);
        phases = Array.map<Complex, Float>(newBeliefCoeffs, complexPhase);
        complexCoeffs = newBeliefCoeffs;
      };
      predictionSpectrum = coupling.predictionSpectrum;
      errorSpectrum = coupling.errorSpectrum;
      spectralFreeEnergy = computeSpectralFreeEnergy(coupling);
      spectralPrecision = coupling.spectralPrecision;
      frequencyBeliefs = coupling.frequencyBeliefs;
      harmonicPriors = coupling.harmonicPriors;
      spectralSurprise = coupling.spectralSurprise;
    }
  };

  // ============================================================================
  // HEBBIAN PLASTICITY COUPLING — Spectral learning rules
  // ============================================================================

  public type HebbianCoupling = {
    spectralWeights : [[Complex]];
    frequencyCorrelations : [[Float]];
    spectralLearningRate : Float;
    crossSpectrumMemory : [[Complex]];
    coherencePlasticity : Float;
    spectralSTDP : [Float];
  };

  public func initHebbianCoupling(inputDim : Nat, outputDim : Nat) : HebbianCoupling {
    {
      spectralWeights = Array.tabulate<[Complex]>(outputDim, func(_ : Nat) : [Complex] {
        Array.tabulate<Complex>(inputDim, func(_ : Nat) : Complex {
          complexFromReal(0.1)
        })
      });
      frequencyCorrelations = Array.tabulate<[Float]>(inputDim, func(_ : Nat) : [Float] {
        Array.tabulate<Float>(inputDim, func(_ : Nat) : Float { 0.0 })
      });
      spectralLearningRate = 0.01;
      crossSpectrumMemory = Array.tabulate<[Complex]>(outputDim, func(_ : Nat) : [Complex] {
        Array.tabulate<Complex>(inputDim, func(_ : Nat) : Complex { complexZero() })
      });
      coherencePlasticity = 0.5;
      spectralSTDP = Array.tabulate<Float>(inputDim, func(_ : Nat) : Float { 0.0 });
    }
  };

  // Cross-spectral Hebbian learning: ΔW_ij(ω) = η · S_xy(ω)
  public func spectralHebbianUpdate(
    coupling : HebbianCoupling,
    inputSpectrum : FourierSpectrum,
    outputSpectrum : FourierSpectrum
  ) : HebbianCoupling {
    let inDim = inputSpectrum.complexCoeffs.size();
    let outDim = outputSpectrum.complexCoeffs.size();
    let eta = coupling.spectralLearningRate;
    
    let newWeights = Array.tabulate<[Complex]>(outDim, func(i : Nat) : [Complex] {
      Array.tabulate<Complex>(inDim, func(j : Nat) : Complex {
        let oldW = coupling.spectralWeights[i][j];
        let inCoeff = inputSpectrum.complexCoeffs[j];
        let outCoeff = outputSpectrum.complexCoeffs[i];
        
        // Cross-spectrum: S_xy(ω) = X*(ω) · Y(ω)
        let crossSpectrum = complexMul(complexConj(inCoeff), outCoeff);
        let update = complexScale(crossSpectrum, eta);
        
        complexAdd(oldW, update)
      })
    });
    
    {
      spectralWeights = newWeights;
      frequencyCorrelations = coupling.frequencyCorrelations;
      spectralLearningRate = eta;
      crossSpectrumMemory = coupling.crossSpectrumMemory;
      coherencePlasticity = coupling.coherencePlasticity;
      spectralSTDP = coupling.spectralSTDP;
    }
  };

  // Frequency-dependent STDP (Spike-Timing Dependent Plasticity)
  public func spectralSTDP(preSpectrum : FourierSpectrum, postSpectrum : FourierSpectrum, tau : Float) : [Float] {
    let n = preSpectrum.frequencies.size();
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      let prePhase = preSpectrum.phases[i];
      let postPhase = postSpectrum.phases[i];
      let phaseDiff = postPhase - prePhase;
      
      // STDP window in frequency domain
      Float.exp(-Float.abs(phaseDiff) / tau) * Float.cos(phaseDiff)
    })
  };

  // ============================================================================
  // ATTRACTOR DYNAMICS COUPLING — Spectral attractors
  // ============================================================================

  public type AttractorCoupling = {
    attractorSpectra : [FourierSpectrum];
    basinSpectralSignatures : [[Float]];
    spectralBasinEnergy : Float;
    dominantAttractorFrequency : Float;
    spectralMetastability : Float;
    attractorHarmonics : [[Float]];
  };

  public func initAttractorCoupling(numAttractors : Nat, spectrumSize : Nat) : AttractorCoupling {
    {
      attractorSpectra = Array.tabulate<FourierSpectrum>(numAttractors, func(i : Nat) : FourierSpectrum {
        {
          frequencies = Array.tabulate<Float>(spectrumSize, func(j : Nat) : Float { Float.fromInt(j) });
          magnitudes = Array.tabulate<Float>(spectrumSize, func(j : Nat) : Float {
            Float.exp(-Float.fromInt(j * j) / (2.0 * Float.fromInt((i + 1) * (i + 1))))
          });
          phases = Array.tabulate<Float>(spectrumSize, func(_ : Nat) : Float { 0.0 });
          complexCoeffs = Array.tabulate<Complex>(spectrumSize, func(j : Nat) : Complex {
            complexFromReal(Float.exp(-Float.fromInt(j * j) / (2.0 * Float.fromInt((i + 1) * (i + 1)))))
          });
        }
      });
      basinSpectralSignatures = Array.tabulate<[Float]>(numAttractors, func(_ : Nat) : [Float] {
        Array.tabulate<Float>(spectrumSize, func(_ : Nat) : Float { 0.0 })
      });
      spectralBasinEnergy = 0.0;
      dominantAttractorFrequency = 1.0;
      spectralMetastability = 0.5;
      attractorHarmonics = Array.tabulate<[Float]>(numAttractors, func(_ : Nat) : [Float] {
        Array.tabulate<Float>(10, func(_ : Nat) : Float { 0.0 })
      });
    }
  };

  // Spectral distance between signal and attractor
  public func spectralAttractorDistance(signal : FourierSpectrum, attractor : FourierSpectrum) : Float {
    var dist : Float = 0.0;
    let n = Float.min(Float.fromInt(signal.complexCoeffs.size()), 
                      Float.fromInt(attractor.complexCoeffs.size()));
    let nInt = Int.abs(Float.toInt(n));
    
    for (i in Iter.range(0, nInt - 1)) {
      let diff = complexSub(signal.complexCoeffs[i], attractor.complexCoeffs[i]);
      dist += complexMagnitude(diff) * complexMagnitude(diff);
    };
    
    Float.sqrt(dist)
  };

  // Identify closest attractor in spectral space
  public func findClosestSpectralAttractor(signal : FourierSpectrum, attractors : [FourierSpectrum]) : Nat {
    var minDist : Float = Float.infinity;
    var closest : Nat = 0;
    
    for (i in Iter.range(0, attractors.size() - 1)) {
      let dist = spectralAttractorDistance(signal, attractors[i]);
      if (dist < minDist) {
        minDist := dist;
        closest := i;
      };
    };
    
    closest
  };

  // ============================================================================
  // PHYSICS ENGINE COUPLING — Spectral mechanics
  // ============================================================================

  public type PhysicsCoupling = {
    modalSpectrum : FourierSpectrum;
    normalModes : [FourierSpectrum];
    spectralEnergy : Float;
    dispersionRelation : [Float];
    groupVelocity : [Float];
    phaseVelocity : [Float];
    wavePacketWidth : Float;
  };

  public func initPhysicsCoupling(numModes : Nat) : PhysicsCoupling {
    {
      modalSpectrum = {
        frequencies = Array.tabulate<Float>(numModes, func(i : Nat) : Float {
          Float.sqrt(Float.fromInt(i + 1))  // ω_n ∝ √n for harmonic oscillator
        });
        magnitudes = Array.tabulate<Float>(numModes, func(_ : Nat) : Float { 0.0 });
        phases = Array.tabulate<Float>(numModes, func(_ : Nat) : Float { 0.0 });
        complexCoeffs = Array.tabulate<Complex>(numModes, func(_ : Nat) : Complex { complexZero() });
      };
      normalModes = Array.tabulate<FourierSpectrum>(numModes, func(i : Nat) : FourierSpectrum {
        {
          frequencies = Array.tabulate<Float>(numModes, func(_ : Nat) : Float { Float.sqrt(Float.fromInt(i + 1)) });
          magnitudes = Array.tabulate<Float>(numModes, func(j : Nat) : Float {
            if (i == j) { 1.0 } else { 0.0 }
          });
          phases = Array.tabulate<Float>(numModes, func(_ : Nat) : Float { 0.0 });
          complexCoeffs = Array.tabulate<Complex>(numModes, func(j : Nat) : Complex {
            if (i == j) { complexOne() } else { complexZero() }
          });
        }
      });
      spectralEnergy = 0.0;
      dispersionRelation = Array.tabulate<Float>(numModes, func(i : Nat) : Float {
        Float.sqrt(Float.fromInt(i + 1))
      });
      groupVelocity = Array.tabulate<Float>(numModes, func(i : Nat) : Float {
        0.5 / Float.sqrt(Float.fromInt(i + 1) + 0.1)
      });
      phaseVelocity = Array.tabulate<Float>(numModes, func(i : Nat) : Float {
        Float.sqrt(Float.fromInt(i + 1))
      });
      wavePacketWidth = 1.0;
    }
  };

  // Spectral energy E = Σ_ω ℏω |a_ω|²
  public func computeSpectralEnergy(coupling : PhysicsCoupling) : Float {
    var E : Float = 0.0;
    for (i in Iter.range(0, coupling.modalSpectrum.frequencies.size() - 1)) {
      let omega = coupling.modalSpectrum.frequencies[i];
      let amplitude = coupling.modalSpectrum.magnitudes[i];
      E += omega * amplitude * amplitude;  // ℏ = 1
    };
    E
  };

  // Wave packet from spectral components
  public func synthesizeWavePacket(coupling : PhysicsCoupling, x : Float, t : Float) : Float {
    var psi : Float = 0.0;
    for (i in Iter.range(0, coupling.modalSpectrum.frequencies.size() - 1)) {
      let k = Float.fromInt(i);
      let omega = coupling.dispersionRelation[i];
      let amplitude = coupling.modalSpectrum.magnitudes[i];
      let phase = coupling.modalSpectrum.phases[i];
      
      psi += amplitude * Float.cos(k * x - omega * t + phase);
    };
    psi
  };

  // ============================================================================
  // ENTROPY ENGINE COUPLING — Spectral entropy
  // ============================================================================

  public type EntropyCoupling = {
    spectralEntropy : Float;
    frequencyDistribution : [Float];
    informationRate : Float;
    spectralMutualInformation : [[Float]];
    entropySpectrum : [Float];
    renyiSpectralEntropy : Float;
  };

  public func initEntropyCoupling(spectrumSize : Nat) : EntropyCoupling {
    {
      spectralEntropy = 0.0;
      frequencyDistribution = Array.tabulate<Float>(spectrumSize, func(_ : Nat) : Float {
        1.0 / Float.fromInt(spectrumSize)
      });
      informationRate = 0.0;
      spectralMutualInformation = Array.tabulate<[Float]>(spectrumSize, func(_ : Nat) : [Float] {
        Array.tabulate<Float>(spectrumSize, func(_ : Nat) : Float { 0.0 })
      });
      entropySpectrum = Array.tabulate<Float>(spectrumSize, func(_ : Nat) : Float { 0.0 });
      renyiSpectralEntropy = 0.0;
    }
  };

  // Spectral entropy H = -Σ_ω p(ω) log p(ω)
  public func computeSpectralEntropy(spectrum : FourierSpectrum) : Float {
    // Convert magnitudes to probability distribution
    var totalPower : Float = 0.0;
    for (mag in spectrum.magnitudes.vals()) {
      totalPower += mag * mag;
    };
    
    if (totalPower < 1e-10) { return 0.0 };
    
    var H : Float = 0.0;
    for (mag in spectrum.magnitudes.vals()) {
      let p = (mag * mag) / totalPower;
      if (p > 1e-10) {
        H -= p * Float.log(p);
      };
    };
    
    H
  };

  // Rényi spectral entropy H_α = (1/(1-α)) log Σ_ω p(ω)^α
  public func renyiSpectralEntropy(spectrum : FourierSpectrum, alpha : Float) : Float {
    if (Float.abs(alpha - 1.0) < 1e-6) {
      return computeSpectralEntropy(spectrum);
    };
    
    var totalPower : Float = 0.0;
    for (mag in spectrum.magnitudes.vals()) {
      totalPower += mag * mag;
    };
    
    if (totalPower < 1e-10) { return 0.0 };
    
    var sum : Float = 0.0;
    for (mag in spectrum.magnitudes.vals()) {
      let p = (mag * mag) / totalPower;
      if (p > 1e-10) {
        sum += Float.pow(p, alpha);
      };
    };
    
    Float.log(sum) / (1.0 - alpha)
  };

  // Spectral mutual information between two signals
  public func spectralMutualInformation(spec1 : FourierSpectrum, spec2 : FourierSpectrum) : Float {
    let H1 = computeSpectralEntropy(spec1);
    let H2 = computeSpectralEntropy(spec2);
    
    // Joint spectrum (simplified as element-wise product)
    let jointMags = Array.tabulate<Float>(spec1.magnitudes.size(), func(i : Nat) : Float {
      spec1.magnitudes[i] * spec2.magnitudes[i]
    });
    
    var totalJoint : Float = 0.0;
    for (m in jointMags.vals()) {
      totalJoint += m;
    };
    
    var HJoint : Float = 0.0;
    if (totalJoint > 1e-10) {
      for (m in jointMags.vals()) {
        let p = m / totalJoint;
        if (p > 1e-10) {
          HJoint -= p * Float.log(p);
        };
      };
    };
    
    H1 + H2 - HJoint
  };

  // ============================================================================
  // TENSOR FIELD COUPLING — Spectral tensors
  // ============================================================================

  public type TensorCoupling = {
    spectralTensor : [[[Complex]]];
    tensorSpectrum : FourierSpectrum;
    spectralMetric : [[Float]];
    tensorHarmonics : [[[Float]]];
    spectralCurvature : Float;
  };

  public func initTensorCoupling(dim : Nat, spectrumSize : Nat) : TensorCoupling {
    {
      spectralTensor = Array.tabulate<[[Complex]]>(spectrumSize, func(_ : Nat) : [[Complex]] {
        Array.tabulate<[Complex]>(dim, func(_ : Nat) : [Complex] {
          Array.tabulate<Complex>(dim, func(_ : Nat) : Complex { complexZero() })
        })
      });
      tensorSpectrum = {
        frequencies = Array.tabulate<Float>(spectrumSize, func(i : Nat) : Float { Float.fromInt(i) });
        magnitudes = Array.tabulate<Float>(spectrumSize, func(_ : Nat) : Float { 0.0 });
        phases = Array.tabulate<Float>(spectrumSize, func(_ : Nat) : Float { 0.0 });
        complexCoeffs = Array.tabulate<Complex>(spectrumSize, func(_ : Nat) : Complex { complexZero() });
      };
      spectralMetric = Array.tabulate<[Float]>(dim, func(i : Nat) : [Float] {
        Array.tabulate<Float>(dim, func(j : Nat) : Float {
          if (i == j) { 1.0 } else { 0.0 }
        })
      });
      tensorHarmonics = Array.tabulate<[[Float]]>(spectrumSize, func(_ : Nat) : [[Float]] {
        Array.tabulate<[Float]>(dim, func(_ : Nat) : [Float] {
          Array.tabulate<Float>(dim, func(_ : Nat) : Float { 0.0 })
        })
      });
      spectralCurvature = 0.0;
    }
  };

  // Fourier transform of tensor field
  public func tensorFourierTransform(tensor : [[Float]], sampleRate : Float) : [[[Complex]]] {
    let rows = tensor.size();
    let cols = if (rows > 0) { tensor[0].size() } else { 0 };
    
    // Transform each component
    Array.tabulate<[[Complex]]>(rows, func(i : Nat) : [[Complex]] {
      Array.tabulate<[Complex]>(cols, func(j : Nat) : [Complex] {
        let signal = [tensor[i][j]];
        let spec = dft(signal, sampleRate);
        spec.complexCoeffs
      })
    })
  };

  // ============================================================================
  // TOPOLOGICAL FIELD COUPLING — Spectral topology
  // ============================================================================

  public type TopologyCoupling = {
    persistentHomologySpectrum : [Float];
    spectralBettiNumbers : [Nat];
    spectralWinding : Float;
    topologicalFrequencies : [Float];
    spectralConnectedness : Float;
  };

  public func initTopologyCoupling(maxDim : Nat) : TopologyCoupling {
    {
      persistentHomologySpectrum = Array.tabulate<Float>(maxDim, func(_ : Nat) : Float { 0.0 });
      spectralBettiNumbers = Array.tabulate<Nat>(maxDim, func(_ : Nat) : Nat { 0 });
      spectralWinding = 0.0;
      topologicalFrequencies = Array.tabulate<Float>(maxDim, func(_ : Nat) : Float { 0.0 });
      spectralConnectedness = 1.0;
    }
  };

  // Winding number from phase spectrum
  public func spectralWindingNumber(phases : [Float]) : Float {
    var totalWinding : Float = 0.0;
    for (i in Iter.range(0, phases.size() - 2)) {
      var diff = phases[i + 1] - phases[i];
      // Normalize to [-π, π]
      while (diff > π) { diff -= τ };
      while (diff < -π) { diff += τ };
      totalWinding += diff;
    };
    totalWinding / τ
  };

  // ============================================================================
  // FREE ENERGY ENGINE COUPLING — Thermodynamic spectroscopy
  // ============================================================================

  public type FreeEnergyCoupling = {
    partitionSpectrum : [Float];
    spectralFreeEnergy : Float;
    spectralTemperature : Float;
    boltzmannSpectrum : [Float];
    spectralHeatCapacity : Float;
  };

  public func initFreeEnergyCoupling(spectrumSize : Nat) : FreeEnergyCoupling {
    {
      partitionSpectrum = Array.tabulate<Float>(spectrumSize, func(i : Nat) : Float {
        Float.exp(-Float.fromInt(i))
      });
      spectralFreeEnergy = 0.0;
      spectralTemperature = 1.0;
      boltzmannSpectrum = Array.tabulate<Float>(spectrumSize, func(i : Nat) : Float {
        Float.exp(-Float.fromInt(i))
      });
      spectralHeatCapacity = 1.0;
    }
  };

  // Spectral partition function Z(T) = Σ_ω exp(-E(ω)/kT)
  public func spectralPartitionFunction(energySpectrum : [Float], temperature : Float) : Float {
    var Z : Float = 0.0;
    let beta = 1.0 / temperature;
    
    for (E in energySpectrum.vals()) {
      Z += Float.exp(-beta * E);
    };
    
    Z
  };

  // Spectral free energy F = -kT log Z
  public func spectralFreeEnergyFromPartition(coupling : FreeEnergyCoupling, energySpectrum : [Float]) : Float {
    let Z = spectralPartitionFunction(energySpectrum, coupling.spectralTemperature);
    -coupling.spectralTemperature * Float.log(Z + 1e-10)
  };

  // ============================================================================
  // QUANTUM COUPLING — Quantum spectroscopy
  // ============================================================================

  public type QuantumCoupling = {
    energyEigenspectrum : [Float];
    wavefunctionSpectrum : [Complex];
    transitionAmplitudes : [[Complex]];
    spectralDensityOfStates : [Float];
    quantumSpectralEntropy : Float;
    levelSpacingDistribution : [Float];
  };

  public func initQuantumCoupling(numLevels : Nat) : QuantumCoupling {
    {
      energyEigenspectrum = Array.tabulate<Float>(numLevels, func(i : Nat) : Float {
        Float.fromInt(i * i)  // Quantum harmonic oscillator-like
      });
      wavefunctionSpectrum = Array.tabulate<Complex>(numLevels, func(_ : Nat) : Complex {
        complexFromReal(1.0 / Float.sqrt(Float.fromInt(numLevels)))
      });
      transitionAmplitudes = Array.tabulate<[Complex]>(numLevels, func(i : Nat) : [Complex] {
        Array.tabulate<Complex>(numLevels, func(j : Nat) : Complex {
          if (Int.abs(i - j) == 1) { complexFromReal(1.0) } else { complexZero() }
        })
      });
      spectralDensityOfStates = Array.tabulate<Float>(numLevels, func(_ : Nat) : Float { 1.0 });
      quantumSpectralEntropy = Float.log(Float.fromInt(numLevels));
      levelSpacingDistribution = Array.tabulate<Float>(numLevels - 1, func(i : Nat) : Float {
        Float.fromInt(2 * i + 1)
      });
    }
  };

  // Quantum spectral entropy from energy spectrum
  public func quantumSpectralEntropy(energies : [Float], temperature : Float) : Float {
    let Z = spectralPartitionFunction(energies, temperature);
    let beta = 1.0 / temperature;
    
    var S : Float = 0.0;
    for (E in energies.vals()) {
      let p = Float.exp(-beta * E) / Z;
      if (p > 1e-10) {
        S -= p * Float.log(p);
      };
    };
    
    S
  };

  // ============================================================================
  // PREDICTIVE CODING COUPLING — Spectral prediction
  // ============================================================================

  public type PredictiveCoupling = {
    predictionSpectrum : FourierSpectrum;
    errorSpectrum : FourierSpectrum;
    hierarchicalSpectra : [FourierSpectrum];
    spectralPredictionError : Float;
    frequencyPrecision : [Float];
    spectralSurprise : Float;
  };

  public func initPredictiveCoupling(spectrumSize : Nat, levels : Nat) : PredictiveCoupling {
    let emptySpectrum = {
      frequencies = Array.tabulate<Float>(spectrumSize, func(i : Nat) : Float { Float.fromInt(i) });
      magnitudes = Array.tabulate<Float>(spectrumSize, func(_ : Nat) : Float { 0.0 });
      phases = Array.tabulate<Float>(spectrumSize, func(_ : Nat) : Float { 0.0 });
      complexCoeffs = Array.tabulate<Complex>(spectrumSize, func(_ : Nat) : Complex { complexZero() });
    };
    
    {
      predictionSpectrum = emptySpectrum;
      errorSpectrum = emptySpectrum;
      hierarchicalSpectra = Array.tabulate<FourierSpectrum>(levels, func(_ : Nat) : FourierSpectrum {
        emptySpectrum
      });
      spectralPredictionError = 0.0;
      frequencyPrecision = Array.tabulate<Float>(spectrumSize, func(_ : Nat) : Float { 1.0 });
      spectralSurprise = 0.0;
    }
  };

  // Compute spectral prediction error
  public func computeSpectralPredictionError(prediction : FourierSpectrum, observation : FourierSpectrum) : Float {
    var error : Float = 0.0;
    let n = Float.min(Float.fromInt(prediction.complexCoeffs.size()),
                      Float.fromInt(observation.complexCoeffs.size()));
    let nInt = Int.abs(Float.toInt(n));
    
    for (i in Iter.range(0, nInt - 1)) {
      let diff = complexSub(observation.complexCoeffs[i], prediction.complexCoeffs[i]);
      error += complexMagnitude(diff) * complexMagnitude(diff);
    };
    
    Float.sqrt(error)
  };

  // ============================================================================
  // UNIFIED ORCHESTRATION STATE — Everything interconnected
  // ============================================================================

  public type UnifiedHarmonicState = {
    kuramoto : KuramotoCoupling;
    friston : FristonCoupling;
    hebbian : HebbianCoupling;
    attractor : AttractorCoupling;
    physics : PhysicsCoupling;
    entropy : EntropyCoupling;
    tensor : TensorCoupling;
    topology : TopologyCoupling;
    freeEnergy : FreeEnergyCoupling;
    quantum : QuantumCoupling;
    predictive : PredictiveCoupling;
    
    globalSpectralEntropy : Float;
    globalSpectralEnergy : Float;
    globalCoherence : Float;
    globalPredictability : Float;
    
    kuramotoFristonCorrelation : Float;
    physicsEntropyCorrelation : Float;
    tensorTopologyCorrelation : Float;
    quantumClassicalCorrelation : Float;
  };

  public func initUnifiedHarmonicState() : UnifiedHarmonicState {
    {
      kuramoto = initKuramotoCoupling(10);
      friston = initFristonCoupling(20);
      hebbian = initHebbianCoupling(10, 10);
      attractor = initAttractorCoupling(4, 20);
      physics = initPhysicsCoupling(10);
      entropy = initEntropyCoupling(20);
      tensor = initTensorCoupling(3, 20);
      topology = initTopologyCoupling(3);
      freeEnergy = initFreeEnergyCoupling(20);
      quantum = initQuantumCoupling(10);
      predictive = initPredictiveCoupling(20, 3);
      
      globalSpectralEntropy = 0.0;
      globalSpectralEnergy = 0.0;
      globalCoherence = 0.0;
      globalPredictability = 1.0;
      
      kuramotoFristonCorrelation = 0.0;
      physicsEntropyCorrelation = 0.0;
      tensorTopologyCorrelation = 0.0;
      quantumClassicalCorrelation = 0.0;
    }
  };

  // Execute unified harmonic beat
  public func executeUnifiedHarmonicBeat(state : UnifiedHarmonicState, signal : [Float], sampleRate : Float) : UnifiedHarmonicState {
    // Compute spectrum from input signal
    let spectrum = dft(signal, sampleRate);
    
    // Update all couplings
    let spectralEntropy = computeSpectralEntropy(spectrum);
    let spectralEnergy = computeSpectralEnergy(state.physics);
    let coherence = kuramotoSpectralCoherence(state.kuramoto);
    let predError = computeSpectralPredictionError(state.predictive.predictionSpectrum, spectrum);
    
    {
      kuramoto = state.kuramoto;
      friston = state.friston;
      hebbian = state.hebbian;
      attractor = state.attractor;
      physics = state.physics;
      entropy = { 
        spectralEntropy = spectralEntropy;
        frequencyDistribution = state.entropy.frequencyDistribution;
        informationRate = spectralEntropy / (1.0 + Float.log(sampleRate));
        spectralMutualInformation = state.entropy.spectralMutualInformation;
        entropySpectrum = state.entropy.entropySpectrum;
        renyiSpectralEntropy = renyiSpectralEntropy(spectrum, 2.0);
      };
      tensor = state.tensor;
      topology = state.topology;
      freeEnergy = state.freeEnergy;
      quantum = state.quantum;
      predictive = state.predictive;
      
      globalSpectralEntropy = spectralEntropy;
      globalSpectralEnergy = spectralEnergy;
      globalCoherence = coherence;
      globalPredictability = 1.0 / (1.0 + predError);
      
      kuramotoFristonCorrelation = coherence * state.friston.spectralFreeEnergy;
      physicsEntropyCorrelation = spectralEnergy * spectralEntropy;
      tensorTopologyCorrelation = state.topology.spectralConnectedness;
      quantumClassicalCorrelation = state.quantum.quantumSpectralEntropy / (spectralEntropy + 0.01);
    }
  };

  // ============================================================================
  // MEDINA DOCTRINE ENFORCEMENT — Sovereign spectral bounds
  // ============================================================================

  public type MedinaDoctrine = {
    sovereignFloor : Float;
    entropyLimit : Float;
    energyThreshold : Float;
    coherenceMinimum : Float;
    informationBound : Float;
  };

  public let MEDINA_HARMONIC_DOCTRINE : MedinaDoctrine = {
    sovereignFloor = 0.01;
    entropyLimit = 100.0;
    energyThreshold = 1000.0;
    coherenceMinimum = 0.0;
    informationBound = 1000.0;
  };

  public func enforceMedinaDoctrine(state : UnifiedHarmonicState) : UnifiedHarmonicState {
    let clampedEntropy = Float.min(MEDINA_HARMONIC_DOCTRINE.entropyLimit, state.globalSpectralEntropy);
    let clampedEnergy = Float.min(MEDINA_HARMONIC_DOCTRINE.energyThreshold, state.globalSpectralEnergy);
    let clampedCoherence = Float.max(MEDINA_HARMONIC_DOCTRINE.coherenceMinimum, state.globalCoherence);
    
    {
      kuramoto = state.kuramoto;
      friston = state.friston;
      hebbian = state.hebbian;
      attractor = state.attractor;
      physics = state.physics;
      entropy = state.entropy;
      tensor = state.tensor;
      topology = state.topology;
      freeEnergy = state.freeEnergy;
      quantum = state.quantum;
      predictive = state.predictive;
      
      globalSpectralEntropy = clampedEntropy;
      globalSpectralEnergy = clampedEnergy;
      globalCoherence = clampedCoherence;
      globalPredictability = state.globalPredictability;
      
      kuramotoFristonCorrelation = state.kuramotoFristonCorrelation;
      physicsEntropyCorrelation = state.physicsEntropyCorrelation;
      tensorTopologyCorrelation = state.tensorTopologyCorrelation;
      quantumClassicalCorrelation = state.quantumClassicalCorrelation;
    }
  };

  // ============================================================================
  // DUAL ORGANISM COUPLING — HIM/HER spectral synchronization
  // ============================================================================

  public type DualOrganismHarmonic = {
    himHarmonicState : UnifiedHarmonicState;
    herHarmonicState : UnifiedHarmonicState;
    spectralSynchronization : Float;
    entropyCorrelation : Float;
    energyBalance : Float;
    coherenceMatch : Float;
  };

  public func initDualOrganismHarmonic() : DualOrganismHarmonic {
    {
      himHarmonicState = initUnifiedHarmonicState();
      herHarmonicState = initUnifiedHarmonicState();
      spectralSynchronization = 0.0;
      entropyCorrelation = 0.0;
      energyBalance = 1.0;
      coherenceMatch = 0.0;
    }
  };

  public func executeDualOrganismHarmonicBeat(
    dual : DualOrganismHarmonic,
    himSignal : [Float],
    herSignal : [Float],
    sampleRate : Float
  ) : DualOrganismHarmonic {
    let himUpdated = executeUnifiedHarmonicBeat(dual.himHarmonicState, himSignal, sampleRate);
    let herUpdated = executeUnifiedHarmonicBeat(dual.herHarmonicState, herSignal, sampleRate);
    
    // Compute cross-spectrum for synchronization
    let himSpec = dft(himSignal, sampleRate);
    let herSpec = dft(herSignal, sampleRate);
    let mutualInfo = spectralMutualInformation(himSpec, herSpec);
    
    {
      himHarmonicState = enforceMedinaDoctrine(himUpdated);
      herHarmonicState = enforceMedinaDoctrine(herUpdated);
      spectralSynchronization = mutualInfo;
      entropyCorrelation = Float.min(himUpdated.globalSpectralEntropy, herUpdated.globalSpectralEntropy) /
                          Float.max(himUpdated.globalSpectralEntropy, herUpdated.globalSpectralEntropy);
      energyBalance = Float.min(himUpdated.globalSpectralEnergy, herUpdated.globalSpectralEnergy) /
                     (Float.max(himUpdated.globalSpectralEnergy, herUpdated.globalSpectralEnergy) + 0.01);
      coherenceMatch = Float.min(himUpdated.globalCoherence, herUpdated.globalCoherence) /
                      (Float.max(himUpdated.globalCoherence, herUpdated.globalCoherence) + 0.01);
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  PHASE 213: DEEP HARMONIC ANALYSIS — WAVELETS, SPECTRAL GEOMETRY
  //
  //  Harmonic analysis decomposes ANYTHING into oscillatory components.
  //  Fourier: decompose into sines/cosines (eternal oscillations)
  //  Wavelets: decompose into localized oscillations (finite bursts)
  //
  //  The organism IS a harmonic decomposition of reality.
  //  Each node oscillates at a frequency. The ensemble IS the spectrum.
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════


  // ═══════════════════════════════════════════════════════════════════════════════
  // CONTINUOUS WAVELET TRANSFORM ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // CWT: W(a,b) = ∫ f(t) ψ*_{a,b}(t) dt
  // where ψ_{a,b}(t) = (1/√a) ψ((t-b)/a)
  //   a = scale (frequency), b = position (time)
  //
  // Unlike Fourier (global), wavelets are LOCAL in both time and frequency.
  // Heisenberg uncertainty: Δt · Δf ≥ 1/(4π)
  // Wavelets optimize this tradeoff at each scale.
  //
  // Mother wavelets:
  //   Morlet: ψ(t) = e^(iω₀t) e^(-t²/2) (Gaussian-windowed oscillation)
  //   Mexican hat: ψ(t) = (1 - t²) e^(-t²/2) (second derivative of Gaussian)
  //   Haar: ψ(t) = 1 for 0≤t<1/2, -1 for 1/2≤t<1 (simplest wavelet)
  // ═══════════════════════════════════════════════════════════════════════════════

  public type WaveletState = {
    coefficients : [Float];          // wavelet coefficients W(a,b)
    scales : [Float];                // a values (frequencies)
    positions : [Float];             // b values (times)
    scaleCount : Nat;                // number of scales
    positionCount : Nat;             // number of positions
    dominantScale : Float;           // scale with maximum energy
    scaleogram : [Float];            // energy at each scale
    ridgeValues : [Float];           // wavelet ridge (instantaneous frequency)
    totalEnergy : Float;
    motherWavelet : Text;            // which mother wavelet
  };

  /// Morlet wavelet: ψ(t) = π^(-1/4) e^(iω₀t) e^(-t²/2)
  public func morletWavelet(t : Float, omega0 : Float) : Float {
    let envelope = Float.exp(-t * t / 2.0);
    let oscillation = Float.cos(omega0 * t); // real part of e^(iωt)
    let normalization = Float.pow(3.14159265358979, -0.25);
    normalization * envelope * oscillation
  };

  /// Mexican hat wavelet: ψ(t) = (2/√3) π^(-1/4) (1-t²) e^(-t²/2)
  public func mexicanHatWavelet(t : Float) : Float {
    let norm = 2.0 / (Float.sqrt(3.0) * Float.pow(3.14159265358979, 0.25));
    norm * (1.0 - t * t) * Float.exp(-t * t / 2.0)
  };

  /// Haar wavelet: simplest orthogonal wavelet
  public func haarWavelet(t : Float) : Float {
    if (t >= 0.0 and t < 0.5) { 1.0 }
    else if (t >= 0.5 and t < 1.0) { -1.0 }
    else { 0.0 }
  };

  /// Compute continuous wavelet transform at single (scale, position)
  /// W(a,b) = (1/√a) ∫ f(t) ψ((t-b)/a) dt
  public func waveletTransformPoint(
    signal : [Float],
    scale : Float,
    position : Float,
    sampleRate : Float,
    waveletType : Text
  ) : Float {
    if (scale < 1.0e-10) { return 0.0 };
    let norm = 1.0 / Float.sqrt(scale);
    var sum : Float = 0.0;
    var i = 0;
    while (i < signal.size()) {
      let t = Float.fromInt(i) / sampleRate;
      let arg = (t - position) / scale;
      let psiVal = switch (waveletType) {
        case ("morlet") { morletWavelet(arg, 6.0) };
        case ("mexican_hat") { mexicanHatWavelet(arg) };
        case ("haar") { haarWavelet(arg) };
        case (_) { morletWavelet(arg, 6.0) };
      };
      sum += signal[i] * psiVal;
      i += 1;
    };
    norm * sum / sampleRate
  };

  /// Compute scaleogram (energy at each scale)
  /// E(a) = ∫ |W(a,b)|² db
  public func computeScaleogram(
    signal : [Float],
    scales : [Float],
    sampleRate : Float
  ) : [Float] {
    let nPos = signal.size();
    Array.tabulate<Float>(scales.size(), func(si : Nat) : Float {
      let a = scales[si];
      var energy : Float = 0.0;
      var j = 0;
      while (j < nPos) {
        let b = Float.fromInt(j) / sampleRate;
        let w = waveletTransformPoint(signal, a, b, sampleRate, "morlet");
        energy += w * w;
        j += 4; // subsample for speed
      };
      energy / sampleRate
    })
  };

  /// Find dominant scale (frequency with maximum energy)
  public func findDominantScale(scaleogram : [Float], scales : [Float]) : Float {
    var maxEnergy : Float = 0.0;
    var bestScale : Float = 1.0;
    var i = 0;
    while (i < scaleogram.size() and i < scales.size()) {
      if (scaleogram[i] > maxEnergy) {
        maxEnergy := scaleogram[i];
        bestScale := scales[i];
      };
      i += 1;
    };
    bestScale
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // MODE COUPLING AND RESONANCE DETECTION
  // ═══════════════════════════════════════════════════════════════════════════════
  // When oscillatory modes are coupled, energy transfers between them.
  // Resonance: energy transfer is maximized when frequencies match.
  //
  // Three-wave coupling: f₁ ± f₂ = f₃ (sum/difference frequencies)
  // Parametric resonance: periodic modulation of parameters
  // Autoparametric resonance: internal coupling between modes
  //
  // In the organism: mode coupling IS how information flows between
  // different frequency bands. Kuramoto synchronization IS mode coupling
  // in the strong-coupling limit.
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Three-wave resonance condition: |f₁ ± f₂ - f₃| < ε
  public func threeWaveResonance(f1 : Float, f2 : Float, f3 : Float, epsilon : Float) : Bool {
    Float.abs(f1 + f2 - f3) < epsilon or Float.abs(f1 - f2 - f3) < epsilon or
    Float.abs(f2 - f1 - f3) < epsilon
  };

  /// Mode coupling coefficient
  /// C(f₁,f₂,f₃) = ∫ ψ₁(t) ψ₂(t) ψ₃(t) dt (overlap integral)
  public func modeCouplingCoefficient(
    mode1 : [Float], mode2 : [Float], mode3 : [Float]
  ) : Float {
    let n = mode1.size();
    var integral : Float = 0.0;
    var i = 0;
    while (i < n) {
      let v1 = if (i < mode1.size()) { mode1[i] } else { 0.0 };
      let v2 = if (i < mode2.size()) { mode2[i] } else { 0.0 };
      let v3 = if (i < mode3.size()) { mode3[i] } else { 0.0 };
      integral += v1 * v2 * v3;
      i += 1;
    };
    integral / Float.fromInt(n)
  };

  /// Bispectrum: B(f₁,f₂) = ⟨X(f₁) X(f₂) X*(f₁+f₂)⟩
  /// Measures phase coupling between frequencies (not just amplitude)
  public func bispectrumPoint(
    spectrum : [Float],  // complex spectrum (alternating real/imag)
    f1idx : Nat,
    f2idx : Nat
  ) : Float {
    let f3idx = f1idx + f2idx;
    let x1 = if (2*f1idx < spectrum.size()) { spectrum[2*f1idx] } else { 0.0 };
    let x2 = if (2*f2idx < spectrum.size()) { spectrum[2*f2idx] } else { 0.0 };
    let x3 = if (2*f3idx < spectrum.size()) { spectrum[2*f3idx] } else { 0.0 };
    x1 * x2 * x3
  };

  /// Bicoherence: normalized bispectrum ∈ [0, 1]
  /// High bicoherence = strong nonlinear (phase) coupling
  public func bicoherence(bispectrumValue : Float, powerProduct : Float) : Float {
    if (powerProduct < 1.0e-10) { return 0.0 };
    Float.abs(bispectrumValue) / powerProduct
  };

}
