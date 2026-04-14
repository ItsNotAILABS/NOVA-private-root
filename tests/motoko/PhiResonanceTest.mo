// ═══════════════════════════════════════════════════════════════════════════════
// PHI RESONANCE ARCHITECTURE TEST
// Validates all frequency calculations and phi-resonance relationships
// Owner: Alfredo Medina Hernandez | Dallas TX | 2024-2026
// ═══════════════════════════════════════════════════════════════════════════════

import PhiResonanceArchitecture "../../../src/swarm_brain/modules/PhiResonanceArchitecture";
import Float "mo:base/Float";
import Debug "mo:base/Debug";
import Array "mo:base/Array";

actor PhiResonanceTest {

  // Test tolerance for floating point comparisons
  let EPSILON : Float = 0.001;

  func abs(x : Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func assertNear(actual : Float, expected : Float, tolerance : Float, testName : Text) {
    let diff = abs(actual - expected);
    if (diff > tolerance) {
      Debug.print("FAIL: " # testName);
      Debug.print("  Expected: " # Float.toText(expected));
      Debug.print("  Actual:   " # Float.toText(actual));
      Debug.print("  Diff:     " # Float.toText(diff));
      assert false;
    } else {
      Debug.print("PASS: " # testName);
    };
  };

  func assertEquals(actual : Float, expected : Float, testName : Text) {
    assertNear(actual, expected, EPSILON, testName);
  };

  public func runAllTests() : async Text {
    Debug.print("\n╔══════════════════════════════════════════════════════════════════╗");
    Debug.print("║  PHI RESONANCE ARCHITECTURE — COMPREHENSIVE TEST SUITE           ║");
    Debug.print("╚══════════════════════════════════════════════════════════════════╝\n");

    // Test 1: Golden Ratio Properties
    testGoldenRatioProperties();

    // Test 2: Schumann Resonances
    testSchumannResonances();

    // Test 3: Fibonacci Boundaries
    testFibonacciBoundaries();

    // Test 4: Phi-Scaled Frequency Nodes
    testPhiScaledNodes();

    // Test 5: Brain Wave Boundaries
    testBrainWaveBoundaries();

    // Test 6: Heartbeat Derivation
    testHeartbeatDerivation();

    // Test 7: Kuramoto Order Parameter
    testKuramotoOrderParameter();

    // Test 8: Phi Frequency Scaling
    testPhiFrequencyScaling();

    // Test 9: Cyber Defense Frequencies
    testCyberDefenseFrequencies();

    // Test 10: Frequency Band Classification
    testFrequencyBandClassification();

    Debug.print("\n╔══════════════════════════════════════════════════════════════════╗");
    Debug.print("║  ALL TESTS PASSED ✓                                             ║");
    Debug.print("╚══════════════════════════════════════════════════════════════════╝\n");

    "All phi resonance tests passed"
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST 1: GOLDEN RATIO PROPERTIES
  // ═══════════════════════════════════════════════════════════════════════════

  func testGoldenRatioProperties() {
    Debug.print("TEST 1: Golden Ratio Properties");
    Debug.print("──────────────────────────────────────────────────────────────────");

    // φ² = φ + 1
    let phi = PhiResonanceArchitecture.φ;
    let phiSquared = PhiResonanceArchitecture.φ²;
    assertNear(phiSquared, phi + 1.0, 0.000001, "φ² = φ + 1");

    // φ × ψ = 1 (where ψ = 1/φ)
    let psi = PhiResonanceArchitecture.ψ;
    assertNear(phi * psi, 1.0, 0.000001, "φ × ψ = 1");

    // φ - 1 = ψ
    assertNear(phi - 1.0, psi, 0.000001, "φ - 1 = ψ");

    // φ = (1 + √5) / 2
    let sqrt5 = PhiResonanceArchitecture.√5;
    assertNear(phi, (1.0 + sqrt5) / 2.0, 0.000001, "φ = (1 + √5) / 2");

    Debug.print("");
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST 2: SCHUMANN RESONANCES
  // ═══════════════════════════════════════════════════════════════════════════

  func testSchumannResonances() {
    Debug.print("TEST 2: Schumann Resonances");
    Debug.print("──────────────────────────────────────────────────────────────────");

    // Fundamental Schumann resonance
    assertEquals(PhiResonanceArchitecture.SCHUMANN_1, 7.83, "Schumann fundamental = 7.83 Hz");

    // Harmonics should be properly spaced
    let s1 = PhiResonanceArchitecture.SCHUMANN_1;
    let s2 = PhiResonanceArchitecture.SCHUMANN_2;
    let s3 = PhiResonanceArchitecture.SCHUMANN_3;

    // Check that harmonics are in ascending order
    assert (s2 > s1);
    assert (s3 > s2);

    Debug.print("  Schumann 1: " # Float.toText(s1) # " Hz");
    Debug.print("  Schumann 2: " # Float.toText(s2) # " Hz");
    Debug.print("  Schumann 3: " # Float.toText(s3) # " Hz");

    // Schumann harmonic formula: f_n ≈ 7.83 × √(n(n+1))
    let s2_calculated = PhiResonanceArchitecture.schumannHarmonic(2);
    assertNear(s2_calculated, 14.3, 0.5, "Schumann 2nd harmonic calculation");

    Debug.print("");
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST 3: FIBONACCI BOUNDARIES
  // ═══════════════════════════════════════════════════════════════════════════

  func testFibonacciBoundaries() {
    Debug.print("TEST 3: Fibonacci Boundaries");
    Debug.print("──────────────────────────────────────────────────────────────────");

    // F(6) = 8 Hz — Theta/Alpha boundary
    assertEquals(PhiResonanceArchitecture.fibonacciHz(6), 8.0, "F(6) = 8 Hz (Theta/Alpha)");

    // F(7) = 13 Hz — Alpha/Beta boundary
    assertEquals(PhiResonanceArchitecture.fibonacciHz(7), 13.0, "F(7) = 13 Hz (Alpha/Beta)");

    // F(9) = 34 Hz — Beta/Gamma boundary
    assertEquals(PhiResonanceArchitecture.fibonacciHz(9), 34.0, "F(9) = 34 Hz (Beta/Gamma)");

    // F(10) = 55 Hz — Gamma/Mid boundary
    assertEquals(PhiResonanceArchitecture.fibonacciHz(10), 55.0, "F(10) = 55 Hz (Gamma/Mid)");

    // F(11) = 89 Hz — Gamma ceiling
    assertEquals(PhiResonanceArchitecture.fibonacciHz(11), 89.0, "F(11) = 89 Hz (Gamma ceiling)");

    // Test boundary detection
    let is8Fib = PhiResonanceArchitecture.isFibonacciBoundary(8.0, 0.1);
    assert is8Fib;
    Debug.print("  8 Hz correctly identified as Fibonacci boundary ✓");

    Debug.print("");
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST 4: PHI-SCALED FREQUENCY NODES
  // ═══════════════════════════════════════════════════════════════════════════

  func testPhiScaledNodes() {
    Debug.print("TEST 4: Phi-Scaled Frequency Nodes (12 nodes)");
    Debug.print("──────────────────────────────────────────────────────────────────");

    // NODE 0: CHRONO
    assertEquals(PhiResonanceArchitecture.CHRONO_HZ, 0.001, "CHRONO = 0.001 Hz");

    // NODE 1: VERITAS
    assertEquals(PhiResonanceArchitecture.VERITAS_HZ, 0.1, "VERITAS = 0.1 Hz");

    // NODE 2: SCHUMANN (PRIMARY COUPLING LAW)
    assertEquals(PhiResonanceArchitecture.SCHUMANN_HZ, 7.83, "SCHUMANN = 7.83 Hz");

    // NODE 3: FLUX = 7.83 × φ^0.8 ≈ 12.67
    let flux = PhiResonanceArchitecture.FLUX_HZ;
    assertNear(flux, 12.67, 0.5, "FLUX ≈ 12.67 Hz");

    // NODE 4: RESONEX = 7.83 × φ ≈ 20.5
    let resonex = PhiResonanceArchitecture.RESONEX_HZ;
    assertNear(resonex, 7.83 * PhiResonanceArchitecture.φ, 2.0, "RESONEX ≈ 7.83 × φ");

    // NODE 5: QMEM = 7.83 × φ² ≈ 33.1
    let qmem = PhiResonanceArchitecture.QMEM_HZ;
    assertNear(qmem, 7.83 * PhiResonanceArchitecture.φ², 2.0, "QMEM ≈ 7.83 × φ²");

    // NODE 6: AXIS = 40 Hz (GAMMA BINDING)
    assertEquals(PhiResonanceArchitecture.AXIS_HZ, 40.0, "AXIS = 40 Hz (Gamma binding)");

    // NODE 7: AEGIS = 7.83 × φ³ ≈ 53.6
    let aegis = PhiResonanceArchitecture.AEGIS_HZ;
    assertNear(aegis, 7.83 * PhiResonanceArchitecture.φ³, 5.0, "AEGIS ≈ 7.83 × φ³");

    // NODE 8: ENTANGLA = 7.83 × φ⁴ ≈ 86.7
    let entangla = PhiResonanceArchitecture.ENTANGLA_HZ;
    assertNear(entangla, 7.83 * PhiResonanceArchitecture.φ⁴, 5.0, "ENTANGLA ≈ 7.83 × φ⁴");

    // NODE 9: PARALLAX = 111 Hz (HEMISPHERE SHIFT)
    assertEquals(PhiResonanceArchitecture.PARALLAX_HZ, 111.0, "PARALLAX = 111 Hz");

    // NODE 10: MERIDIAN = 111 × φ ≈ 179.6
    let meridian = PhiResonanceArchitecture.MERIDIAN_HZ;
    assertNear(meridian, 111.0 * PhiResonanceArchitecture.φ, 5.0, "MERIDIAN ≈ 111 × φ");

    // NODE 11: NOVA = 432 Hz (ACOUSTIC ANCHOR)
    assertEquals(PhiResonanceArchitecture.NOVA_HZ, 432.0, "NOVA = 432 Hz (A=432)");

    Debug.print("");
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST 5: BRAIN WAVE BOUNDARIES
  // ═══════════════════════════════════════════════════════════════════════════

  func testBrainWaveBoundaries() {
    Debug.print("TEST 5: Brain Wave Boundaries");
    Debug.print("──────────────────────────────────────────────────────────────────");

    // Theta/Alpha boundary = 8 Hz = F(6)
    assertEquals(PhiResonanceArchitecture.THETA_MAX, 8.0, "Theta max = 8 Hz");
    assertEquals(PhiResonanceArchitecture.ALPHA_MIN, 8.0, "Alpha min = 8 Hz");

    // Alpha/Beta boundary = 13 Hz = F(7)
    assertEquals(PhiResonanceArchitecture.ALPHA_MAX, 13.0, "Alpha max = 13 Hz");
    assertEquals(PhiResonanceArchitecture.BETA_MIN, 13.0, "Beta min = 13 Hz");

    // Gamma boundaries at Fibonacci numbers
    assertEquals(PhiResonanceArchitecture.GAMMA_BOUNDARY_1, 34.0, "Gamma boundary 1 = 34 Hz (F(9))");
    assertEquals(PhiResonanceArchitecture.GAMMA_BOUNDARY_2, 55.0, "Gamma boundary 2 = 55 Hz (F(10))");
    assertEquals(PhiResonanceArchitecture.GAMMA_CEILING, 89.0, "Gamma ceiling = 89 Hz (F(11))");

    // Test band classification
    let thetaName = PhiResonanceArchitecture.getFrequencyBandName(6.0);
    assert (thetaName == "Theta");
    Debug.print("  6 Hz correctly classified as Theta ✓");

    let gammaName = PhiResonanceArchitecture.getFrequencyBandName(40.0);
    assert (gammaName == "Gamma");
    Debug.print("  40 Hz correctly classified as Gamma ✓");

    Debug.print("");
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST 6: HEARTBEAT DERIVATION
  // ═══════════════════════════════════════════════════════════════════════════

  func testHeartbeatDerivation() {
    Debug.print("TEST 6: Heartbeat Derivation (φ⁴ × Schumann)");
    Debug.print("──────────────────────────────────────────────────────────────────");

    // Schumann period = 1/7.83 ≈ 127.7 ms
    let schumannPeriod = PhiResonanceArchitecture.SCHUMANN_PERIOD_MS;
    assertNear(schumannPeriod, 1000.0 / 7.83, 1.0, "Schumann period ≈ 127.7 ms");

    // Heartbeat = φ⁴ × Schumann period ≈ 875.3 ms
    let phi4 = PhiResonanceArchitecture.φ⁴;
    let expectedHeartbeat = schumannPeriod * phi4;
    let actualHeartbeat = PhiResonanceArchitecture.HEARTBEAT_MS;
    assertNear(actualHeartbeat, expectedHeartbeat, 10.0, "Heartbeat = φ⁴ × Schumann period");

    // Heartbeat BPM = 60000 / 875.3 ≈ 68.5 BPM
    let bpm = 60000.0 / actualHeartbeat;
    assertNear(bpm, PhiResonanceArchitecture.HEARTBEAT_BPM, 1.0, "Heartbeat ≈ 68.5 BPM");

    Debug.print("  Schumann period: " # Float.toText(schumannPeriod) # " ms");
    Debug.print("  φ⁴ = " # Float.toText(phi4));
    Debug.print("  Heartbeat: " # Float.toText(actualHeartbeat) # " ms");
    Debug.print("  BPM: " # Float.toText(bpm));

    // Test other phi-spaced windows
    let sensoryWindow = PhiResonanceArchitecture.SENSORY_WINDOW_MS;
    assertNear(sensoryWindow, schumannPeriod * PhiResonanceArchitecture.φ², 5.0, "Sensory window = φ² × Schumann");

    let workingMemory = PhiResonanceArchitecture.WORKING_MEMORY_MS;
    assertNear(workingMemory, schumannPeriod * PhiResonanceArchitecture.φ³, 10.0, "Working memory = φ³ × Schumann");

    Debug.print("");
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST 7: KURAMOTO ORDER PARAMETER
  // ═══════════════════════════════════════════════════════════════════════════

  func testKuramotoOrderParameter() {
    Debug.print("TEST 7: Kuramoto Order Parameter");
    Debug.print("──────────────────────────────────────────────────────────────────");

    // Test perfect synchrony: all phases = 0
    let synced : [Float] = [0.0, 0.0, 0.0, 0.0, 0.0];
    let (r1, psi1) = PhiResonanceArchitecture.computeOrderParameter(synced);
    assertNear(r1, 1.0, 0.001, "Perfect sync: R = 1.0");

    // Test complete desynchrony: evenly spaced phases
    let tau = PhiResonanceArchitecture.τ;
    let desynced : [Float] = [0.0, tau/5.0, 2.0*tau/5.0, 3.0*tau/5.0, 4.0*tau/5.0];
    let (r2, psi2) = PhiResonanceArchitecture.computeOrderParameter(desynced);
    assertNear(r2, 0.0, 0.1, "Complete desync: R ≈ 0.0");

    // Test partial synchrony: 3 synced, 2 desynced
    let partial : [Float] = [0.0, 0.1, 0.15, 2.0, 2.5];
    let (r3, psi3) = PhiResonanceArchitecture.computeOrderParameter(partial);
    assert (r3 > 0.3 and r3 < 0.8);
    Debug.print("  Partial sync: R = " # Float.toText(r3) # " ✓");

    Debug.print("");
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST 8: PHI FREQUENCY SCALING
  // ═══════════════════════════════════════════════════════════════════════════

  func testPhiFrequencyScaling() {
    Debug.print("TEST 8: Phi Frequency Scaling");
    Debug.print("──────────────────────────────────────────────────────────────────");

    // scaleByPhi(7.83, 0) = 7.83
    let scaled0 = PhiResonanceArchitecture.scaleByPhi(7.83, 0);
    assertNear(scaled0, 7.83, 0.01, "scaleByPhi(7.83, 0) = 7.83");

    // scaleByPhi(7.83, 1) = 7.83 × φ ≈ 12.67
    let scaled1 = PhiResonanceArchitecture.scaleByPhi(7.83, 1);
    assertNear(scaled1, 7.83 * PhiResonanceArchitecture.φ, 0.1, "scaleByPhi(7.83, 1) = 7.83 × φ");

    // scaleByPhi(7.83, 2) = 7.83 × φ² ≈ 20.5
    let scaled2 = PhiResonanceArchitecture.scaleByPhi(7.83, 2);
    assertNear(scaled2, 7.83 * PhiResonanceArchitecture.φ², 0.1, "scaleByPhi(7.83, 2) = 7.83 × φ²");

    // scaleByPhi(7.83, 3) = 7.83 × φ³ ≈ 33.1
    let scaled3 = PhiResonanceArchitecture.scaleByPhi(7.83, 3);
    assertNear(scaled3, 7.83 * PhiResonanceArchitecture.φ³, 0.5, "scaleByPhi(7.83, 3) = 7.83 × φ³");

    Debug.print("  7.83 × φ¹ = " # Float.toText(scaled1));
    Debug.print("  7.83 × φ² = " # Float.toText(scaled2));
    Debug.print("  7.83 × φ³ = " # Float.toText(scaled3));

    Debug.print("");
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST 9: CYBER DEFENSE FREQUENCIES
  // ═══════════════════════════════════════════════════════════════════════════

  func testCyberDefenseFrequencies() {
    Debug.print("TEST 9: Cyber Defense/Offense Frequencies");
    Debug.print("──────────────────────────────────────────────────────────────────");

    // VAEL fear substrate: 0.5-2 Hz
    assertEquals(PhiResonanceArchitecture.VAEL_FEAR_MIN_HZ, 0.5, "VAEL fear min = 0.5 Hz");
    assertEquals(PhiResonanceArchitecture.VAEL_FEAR_MAX_HZ, 2.0, "VAEL fear max = 2.0 Hz");

    // SENTINEL detection: 40 Hz (gamma binding)
    assertEquals(PhiResonanceArchitecture.SENTINEL_DETECT_HZ, 40.0, "SENTINEL = 40 Hz");

    // AEGIS lock: 53.6 Hz (7.83 × φ³)
    assertEquals(PhiResonanceArchitecture.AEGIS_LOCK_HZ, 53.6, "AEGIS = 53.6 Hz");

    // PARALLAX shift: 111 Hz (hemisphere shift)
    assertEquals(PhiResonanceArchitecture.PARALLAX_SHIFT_HZ, 111.0, "PARALLAX = 111 Hz");

    // VERITAS accumulation: 0.1 Hz (slow truth weapon)
    assertEquals(PhiResonanceArchitecture.VERITAS_ACCUMULATE_HZ, 0.1, "VERITAS = 0.1 Hz");

    // Cyber warfare extensions
    let packetMHz = PhiResonanceArchitecture.NETWORK_PACKET_MHZ;
    assertEquals(packetMHz, 1000000.0, "Network packet timing = 1 MHz");

    Debug.print("  Defense frequencies validated ✓");
    Debug.print("  Offense frequencies validated ✓");
    Debug.print("  Cyber warfare extensions validated ✓");

    Debug.print("");
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEST 10: FREQUENCY BAND CLASSIFICATION
  // ═══════════════════════════════════════════════════════════════════════════

  func testFrequencyBandClassification() {
    Debug.print("TEST 10: Frequency Band Classification");
    Debug.print("──────────────────────────────────────────────────────────────────");

    // Test various frequencies
    assert (PhiResonanceArchitecture.getFrequencyBandName(2.0) == "Delta");
    assert (PhiResonanceArchitecture.getFrequencyBandName(6.0) == "Theta");
    assert (PhiResonanceArchitecture.getFrequencyBandName(10.0) == "Alpha");
    assert (PhiResonanceArchitecture.getFrequencyBandName(20.0) == "Beta");
    assert (PhiResonanceArchitecture.getFrequencyBandName(40.0) == "Gamma");
    assert (PhiResonanceArchitecture.getFrequencyBandName(100.0) == "High Gamma");

    Debug.print("  All frequency band classifications correct ✓");

    // Test Schumann harmonic detection
    let is783Schumann = PhiResonanceArchitecture.isSchumannHarmonic(7.83, 0.1);
    assert is783Schumann;
    Debug.print("  7.83 Hz correctly identified as Schumann harmonic ✓");

    let is143Schumann = PhiResonanceArchitecture.isSchumannHarmonic(14.3, 0.1);
    assert is143Schumann;
    Debug.print("  14.3 Hz correctly identified as Schumann harmonic ✓");

    Debug.print("");
  };

}
