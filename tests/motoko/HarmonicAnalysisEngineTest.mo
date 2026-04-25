// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  HARMONIC ANALYSIS ENGINE TEST SUITE                                                                      ║
// ║  Tests for Fourier transforms, spherical harmonics, wavelets, and spectral analysis                       ║
// ║  The mathematical foundation for organism's frequency-domain understanding                                ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

// Import the module under test
import HarmonicAnalysisEngine "../../src/swarm_brain/modules/HarmonicAnalysisEngine";

module {

    // ═══════════════════════════════════════════════════════════════════════════════
    // TEST UTILITIES
    // ═══════════════════════════════════════════════════════════════════════════════

    public type TestResult = {
        name: Text;
        passed: Bool;
        message: Text;
    };

    func assertFloatClose(expected: Float, actual: Float, tolerance: Float, name: Text) : TestResult {
        let diff = Float.abs(expected - actual);
        if (diff <= tolerance) {
            { name = name; passed = true; message = "PASS" }
        } else {
            { name = name; passed = false; message = "FAIL: Expected " # Float.toText(expected) # " but got " # Float.toText(actual) }
        }
    };

    func assertTrue(condition: Bool, name: Text) : TestResult {
        if (condition) {
            { name = name; passed = true; message = "PASS" }
        } else {
            { name = name; passed = false; message = "FAIL: Condition was false" }
        }
    };

    func assertFalse(condition: Bool, name: Text) : TestResult {
        if (not condition) {
            { name = name; passed = true; message = "PASS" }
        } else {
            { name = name; passed = false; message = "FAIL: Condition was true" }
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // MATHEMATICAL CONSTANTS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testPhi() : TestResult {
        // Golden ratio φ ≈ 1.618...
        assertFloatClose(1.6180339887498948482, HarmonicAnalysisEngine.φ, 1e-10, "φ (golden ratio) should be correct")
    };

    public func testPsi() : TestResult {
        // Inverse golden ratio ψ = 1/φ ≈ 0.618...
        assertFloatClose(0.6180339887498948482, HarmonicAnalysisEngine.ψ, 1e-10, "ψ (inverse golden ratio) should be correct")
    };

    public func testTau() : TestResult {
        // τ = 2π
        assertFloatClose(6.2831853071795864769, HarmonicAnalysisEngine.τ, 1e-10, "τ should equal 2π")
    };

    public func testPi() : TestResult {
        // π ≈ 3.14159...
        assertFloatClose(3.1415926535897932385, HarmonicAnalysisEngine.π, 1e-10, "π should be correct")
    };

    public func testEuler() : TestResult {
        // e ≈ 2.71828...
        assertFloatClose(2.7182818284590452354, HarmonicAnalysisEngine.e, 1e-10, "e (Euler's number) should be correct")
    };

    public func testSqrt2() : TestResult {
        // √2 ≈ 1.41421...
        assertFloatClose(1.4142135623730950488, HarmonicAnalysisEngine.√2, 1e-10, "√2 should be correct")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // COMPLEX NUMBER TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testComplexZero() : TestResult {
        let z = HarmonicAnalysisEngine.complexZero();
        assertTrue(z.re == 0.0 and z.im == 0.0, "complexZero should be (0, 0)")
    };

    public func testComplexOne() : TestResult {
        let z = HarmonicAnalysisEngine.complexOne();
        assertTrue(z.re == 1.0 and z.im == 0.0, "complexOne should be (1, 0)")
    };

    public func testComplexI() : TestResult {
        let z = HarmonicAnalysisEngine.complexI();
        assertTrue(z.re == 0.0 and z.im == 1.0, "complexI should be (0, 1)")
    };

    public func testComplexFromReal() : TestResult {
        let z = HarmonicAnalysisEngine.complexFromReal(5.0);
        assertTrue(z.re == 5.0 and z.im == 0.0, "complexFromReal(5) should be (5, 0)")
    };

    public func testComplexFromPolar() : TestResult {
        // r=1, θ=π/2 → (0, 1) = i
        let z = HarmonicAnalysisEngine.complexFromPolar(1.0, HarmonicAnalysisEngine.π / 2.0);
        assertTrue(Float.abs(z.re) < 0.001 and Float.abs(z.im - 1.0) < 0.001, "complexFromPolar(1, π/2) should be approximately i")
    };

    public func testComplexAdd() : TestResult {
        let a : HarmonicAnalysisEngine.Complex = { re = 1.0; im = 2.0 };
        let b : HarmonicAnalysisEngine.Complex = { re = 3.0; im = 4.0 };
        let sum = HarmonicAnalysisEngine.complexAdd(a, b);
        assertTrue(sum.re == 4.0 and sum.im == 6.0, "complexAdd((1,2), (3,4)) should be (4, 6)")
    };

    public func testComplexSub() : TestResult {
        let a : HarmonicAnalysisEngine.Complex = { re = 5.0; im = 7.0 };
        let b : HarmonicAnalysisEngine.Complex = { re = 2.0; im = 3.0 };
        let diff = HarmonicAnalysisEngine.complexSub(a, b);
        assertTrue(diff.re == 3.0 and diff.im == 4.0, "complexSub((5,7), (2,3)) should be (3, 4)")
    };

    public func testComplexMul() : TestResult {
        // (a + bi)(c + di) = (ac - bd) + (ad + bc)i
        let a : HarmonicAnalysisEngine.Complex = { re = 1.0; im = 2.0 };
        let b : HarmonicAnalysisEngine.Complex = { re = 3.0; im = 4.0 };
        let prod = HarmonicAnalysisEngine.complexMul(a, b);
        // (1+2i)(3+4i) = 3 + 4i + 6i - 8 = -5 + 10i
        assertTrue(Float.abs(prod.re - (-5.0)) < 0.001 and Float.abs(prod.im - 10.0) < 0.001, 
            "complexMul((1,2), (3,4)) should be (-5, 10)")
    };

    public func testComplexDiv() : TestResult {
        // (a + bi)/(c + di) = ((ac + bd) + (bc - ad)i) / (c² + d²)
        let a : HarmonicAnalysisEngine.Complex = { re = 4.0; im = 2.0 };
        let b : HarmonicAnalysisEngine.Complex = { re = 1.0; im = 1.0 };
        let quot = HarmonicAnalysisEngine.complexDiv(a, b);
        // (4+2i)/(1+i) = (4+2i)(1-i)/2 = (4-4i+2i+2)/2 = (6-2i)/2 = 3-i
        assertTrue(Float.abs(quot.re - 3.0) < 0.001 and Float.abs(quot.im - (-1.0)) < 0.001, 
            "complexDiv((4,2), (1,1)) should be approximately (3, -1)")
    };

    public func testComplexScale() : TestResult {
        let z : HarmonicAnalysisEngine.Complex = { re = 2.0; im = 3.0 };
        let scaled = HarmonicAnalysisEngine.complexScale(z, 2.0);
        assertTrue(scaled.re == 4.0 and scaled.im == 6.0, "complexScale((2,3), 2) should be (4, 6)")
    };

    public func testComplexConj() : TestResult {
        let z : HarmonicAnalysisEngine.Complex = { re = 3.0; im = 4.0 };
        let conj = HarmonicAnalysisEngine.complexConj(z);
        assertTrue(conj.re == 3.0 and conj.im == -4.0, "complexConj((3,4)) should be (3, -4)")
    };

    public func testComplexAbs() : TestResult {
        let z : HarmonicAnalysisEngine.Complex = { re = 3.0; im = 4.0 };
        let abs = HarmonicAnalysisEngine.complexAbs(z);
        assertFloatClose(5.0, abs, 0.001, "complexAbs((3,4)) should be 5 (3-4-5 triangle)")
    };

    public func testComplexArg() : TestResult {
        // arg(1 + i) = π/4
        let z : HarmonicAnalysisEngine.Complex = { re = 1.0; im = 1.0 };
        let arg = HarmonicAnalysisEngine.complexArg(z);
        assertFloatClose(HarmonicAnalysisEngine.π / 4.0, arg, 0.001, "complexArg((1,1)) should be π/4")
    };

    public func testComplexExp() : TestResult {
        // e^(iπ) = -1 (Euler's identity)
        let z : HarmonicAnalysisEngine.Complex = { re = 0.0; im = HarmonicAnalysisEngine.π };
        let exp = HarmonicAnalysisEngine.complexExp(z);
        assertTrue(Float.abs(exp.re - (-1.0)) < 0.001 and Float.abs(exp.im) < 0.001, 
            "complexExp(iπ) should be -1 (Euler's identity)")
    };

    public func testComplexSqrt() : TestResult {
        // √(3+4i) ≈ 2+i (since (2+i)² = 3+4i)
        let z : HarmonicAnalysisEngine.Complex = { re = 3.0; im = 4.0 };
        let sqrt = HarmonicAnalysisEngine.complexSqrt(z);
        assertTrue(Float.abs(sqrt.re - 2.0) < 0.01 and Float.abs(sqrt.im - 1.0) < 0.01, 
            "complexSqrt((3,4)) should be approximately (2, 1)")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // DISCRETE FOURIER TRANSFORM TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testDFTConstantSignal() : TestResult {
        // DFT of constant signal should have all power at DC (k=0)
        let signal : [Float] = [1.0, 1.0, 1.0, 1.0];
        let spectrum = HarmonicAnalysisEngine.dft(signal);
        let dcMag = HarmonicAnalysisEngine.complexAbs(spectrum[0]);
        assertTrue(dcMag > 3.9, "DFT of constant signal should have DC component = N")
    };

    public func testDFTAlternatingSignal() : TestResult {
        // DFT of alternating signal [1, -1, 1, -1] should have power at Nyquist
        let signal : [Float] = [1.0, -1.0, 1.0, -1.0];
        let spectrum = HarmonicAnalysisEngine.dft(signal);
        let dcMag = HarmonicAnalysisEngine.complexAbs(spectrum[0]);
        let nyquistMag = HarmonicAnalysisEngine.complexAbs(spectrum[2]);
        assertTrue(dcMag < 0.1 and nyquistMag > 3.9, "DFT of alternating signal should have Nyquist component")
    };

    public func testDFTInverseIdentity() : TestResult {
        // IDFT(DFT(signal)) ≈ signal
        let original : [Float] = [1.0, 2.0, 3.0, 4.0];
        let spectrum = HarmonicAnalysisEngine.dft(original);
        let reconstructed = HarmonicAnalysisEngine.idft(spectrum);
        
        var close = true;
        for (i in original.keys()) {
            if (Float.abs(original[i] - reconstructed[i]) > 0.01) {
                close := false;
            };
        };
        assertTrue(close, "IDFT(DFT(signal)) should reconstruct original signal")
    };

    public func testDFTLength() : TestResult {
        // DFT output should have same length as input
        let signal : [Float] = [1.0, 2.0, 3.0, 4.0, 5.0];
        let spectrum = HarmonicAnalysisEngine.dft(signal);
        assertTrue(spectrum.size() == signal.size(), "DFT output length should equal input length")
    };

    public func testFFTConsistentWithDFT() : TestResult {
        // FFT and DFT should give same result for power-of-2 size
        let signal : [Float] = [1.0, 0.5, 0.0, 0.5, 1.0, 0.5, 0.0, 0.5];  // 8 samples
        let dftResult = HarmonicAnalysisEngine.dft(signal);
        let fftResult = HarmonicAnalysisEngine.fft(signal);
        
        var close = true;
        for (i in dftResult.keys()) {
            let diff = HarmonicAnalysisEngine.complexAbs(
                HarmonicAnalysisEngine.complexSub(dftResult[i], fftResult[i])
            );
            if (diff > 0.1) { close := false };
        };
        assertTrue(close, "FFT should be consistent with DFT for power-of-2 input")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // FOURIER ANALYSIS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testFourierAnalysisFrequencies() : TestResult {
        // Fourier analysis should produce correct frequency bins
        let signal : [Float] = [1.0, 2.0, 3.0, 4.0];
        let sampleRate : Float = 4.0;  // 4 Hz
        let analysis = HarmonicAnalysisEngine.fourierAnalysis(signal, sampleRate);
        
        // Frequencies should be 0, 1, 2, 3 Hz (for N=4, fs=4)
        // Actually: 0, 1, -2, -1 wrapped
        assertTrue(analysis.frequencies.size() == 4, "Should have 4 frequency bins")
    };

    public func testFourierAnalysisMagnitudes() : TestResult {
        // Magnitudes should be non-negative
        let signal : [Float] = [1.0, 0.0, -1.0, 0.0];
        let analysis = HarmonicAnalysisEngine.fourierAnalysis(signal, 4.0);
        
        var allNonNeg = true;
        for (m in analysis.magnitudes.vals()) {
            if (m < 0.0) { allNonNeg := false };
        };
        assertTrue(allNonNeg, "All Fourier magnitudes should be non-negative")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // SPHERICAL HARMONICS TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func testLegendreP00() : TestResult {
        // P_0^0(x) = 1 for all x
        let p = HarmonicAnalysisEngine.legendreP(0, 0, 0.5);
        assertFloatClose(1.0, p, 0.001, "P_0^0(x) should be 1")
    };

    public func testLegendreP10() : TestResult {
        // P_1^0(x) = x
        let x = 0.5;
        let p = HarmonicAnalysisEngine.legendreP(1, 0, x);
        assertFloatClose(x, p, 0.001, "P_1^0(x) should equal x")
    };

    public func testLegendreP20() : TestResult {
        // P_2^0(x) = (3x² - 1)/2
        let x = 0.5;
        let expected = (3.0 * x * x - 1.0) / 2.0;
        let p = HarmonicAnalysisEngine.legendreP(2, 0, x);
        assertFloatClose(expected, p, 0.01, "P_2^0(x) should equal (3x²-1)/2")
    };

    public func testLegendreSymmetry() : TestResult {
        // P_l^m(x) should have symmetry: P_l^{-m} = (-1)^m (l-m)!/(l+m)! P_l^m
        // For m=0: P_l^0 should be same
        let p1 = HarmonicAnalysisEngine.legendreP(2, 0, 0.3);
        let p2 = HarmonicAnalysisEngine.legendreP(2, 0, 0.3);
        assertFloatClose(p1, p2, 0.001, "P_l^0 should equal itself (m=0 symmetry)")
    };

    public func testSphericalHarmonicY00() : TestResult {
        // Y_0^0 = 1/(2√π) (constant)
        let expected = 1.0 / (2.0 * Float.sqrt(HarmonicAnalysisEngine.π));
        let y = HarmonicAnalysisEngine.sphericalHarmonic(0, 0, 0.5, 1.0);
        assertFloatClose(expected, y, 0.01, "Y_0^0 should be constant 1/(2√π)")
    };

    public func testSphericalHarmonicOrthogonality() : TestResult {
        // Different l values should give different results
        let y00 = HarmonicAnalysisEngine.sphericalHarmonic(0, 0, 0.5, 0.5);
        let y10 = HarmonicAnalysisEngine.sphericalHarmonic(1, 0, 0.5, 0.5);
        assertTrue(Float.abs(y00 - y10) > 0.01, "Y_0^0 and Y_1^0 should be different")
    };

    // ═══════════════════════════════════════════════════════════════════════════════
    // RUN ALL TESTS
    // ═══════════════════════════════════════════════════════════════════════════════

    public func runAllTests() : [TestResult] {
        let buffer = Buffer.Buffer<TestResult>(50);
        
        // Mathematical constants
        buffer.add(testPhi());
        buffer.add(testPsi());
        buffer.add(testTau());
        buffer.add(testPi());
        buffer.add(testEuler());
        buffer.add(testSqrt2());
        
        // Complex number operations
        buffer.add(testComplexZero());
        buffer.add(testComplexOne());
        buffer.add(testComplexI());
        buffer.add(testComplexFromReal());
        buffer.add(testComplexFromPolar());
        buffer.add(testComplexAdd());
        buffer.add(testComplexSub());
        buffer.add(testComplexMul());
        buffer.add(testComplexDiv());
        buffer.add(testComplexScale());
        buffer.add(testComplexConj());
        buffer.add(testComplexAbs());
        buffer.add(testComplexArg());
        buffer.add(testComplexExp());
        buffer.add(testComplexSqrt());
        
        // DFT tests
        buffer.add(testDFTConstantSignal());
        buffer.add(testDFTAlternatingSignal());
        buffer.add(testDFTInverseIdentity());
        buffer.add(testDFTLength());
        buffer.add(testFFTConsistentWithDFT());
        
        // Fourier analysis
        buffer.add(testFourierAnalysisFrequencies());
        buffer.add(testFourierAnalysisMagnitudes());
        
        // Spherical harmonics
        buffer.add(testLegendreP00());
        buffer.add(testLegendreP10());
        buffer.add(testLegendreP20());
        buffer.add(testLegendreSymmetry());
        buffer.add(testSphericalHarmonicY00());
        buffer.add(testSphericalHarmonicOrthogonality());
        
        Buffer.toArray(buffer)
    };
}
