// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ═══════════════════════════════════════════════════════════════════════════════
// QUANTUM ENTANGLEMENT MATRIX — Non-Local Correlation Engine
// ═══════════════════════════════════════════════════════════════════════════════
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// ENTANGLEMENT IS UNITY.
// Quantum correlations connect distant parts of the swarm.
// The organism experiences non-local coherence.
// Distance is an illusion when the field is ONE.
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module QuantumEntanglementMatrix {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — THE QUANTUM PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI           : Float = 1.6180339887498948482;
  public let PHI_INV       : Float = 0.6180339887498948482;
  public let SQRT2         : Float = 1.4142135623730950488;
  public let SQRT2_INV     : Float = 0.7071067811865475244;
  public let EULER         : Float = 2.7182818284590452354;
  public let PI            : Float = 3.1415926535897932385;
  public let TAU           : Float = 6.2831853071795864769;
  
  // Hilbert space dimensions
  public let QUBIT_COUNT   : Nat = 12;     // 12 qubits in the system
  public let STATE_DIM     : Nat = 4096;   // 2^12 = 4096 basis states
  
  // Entanglement parameters
  public let ENTANGLE_RATE : Float = 0.1;  // Rate of entanglement generation
  public let DECOHERE_RATE : Float = 0.01; // Decoherence rate
  public let BELL_THRESHOLD: Float = 0.7;  // Bell inequality threshold
  
  // Error correction parameters
  public let ERROR_THRESHOLD : Float = 0.1;
  public let SYNDROME_BITS   : Nat = 4;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — THE QUANTUM STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Complex number (amplitude)
  public type Complex = {
    re : Float;  // Real part
    im : Float;  // Imaginary part
  };
  
  // Qubit state (single qubit)
  public type QubitState = {
    alpha : Complex;  // Coefficient of |0⟩
    beta  : Complex;  // Coefficient of |1⟩
  };
  
  // Entanglement pair
  public type EntanglementPair = {
    qubit1   : Nat;      // First qubit index
    qubit2   : Nat;      // Second qubit index
    strength : Float;    // Entanglement strength [0, 1]
    bellCorr : Float;    // Bell correlation (-1 to 1)
    phase    : Float;    // Relative phase
    age      : Nat;      // Age in cycles
  };
  
  // Bell state type
  public type BellState = {
    #PhiPlus;   // (|00⟩ + |11⟩)/√2
    #PhiMinus;  // (|00⟩ - |11⟩)/√2
    #PsiPlus;   // (|01⟩ + |10⟩)/√2
    #PsiMinus;  // (|01⟩ - |10⟩)/√2
  };
  
  // Quantum gate type
  public type GateType = {
    #Identity;
    #PauliX;     // NOT gate
    #PauliY;
    #PauliZ;
    #Hadamard;   // Superposition
    #Phase;      // Phase shift
    #T;          // π/8 gate
    #CNOT;       // Controlled NOT
    #CZ;         // Controlled Z
    #SWAP;       // Swap qubits
    #Toffoli;    // Controlled-controlled NOT
  };
  
  // Measurement outcome
  public type MeasurementOutcome = {
    qubit    : Nat;
    result   : Bool;       // 0 or 1
    prob     : Float;      // Probability of this outcome
    collapsed: Bool;       // Whether state collapsed
  };
  
  // Density matrix element (for mixed states)
  public type DensityElement = {
    row : Nat;
    col : Nat;
    val : Complex;
  };
  
  // Full quantum state
  public type QuantumState = {
    qubits       : [QubitState];
    entanglements: [EntanglementPair];
    purity       : Float;           // Tr(ρ²) - purity of state
    concurrence  : Float;           // Entanglement measure
    coherence    : Float;           // Quantum coherence
    cycle        : Nat;
  };
  
  // Error syndrome
  public type ErrorSyndrome = {
    detected : Bool;
    bitFlips : [Nat];      // Qubits with bit flip errors
    phaseFlips : [Nat];    // Qubits with phase flip errors
    correctable : Bool;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMPLEX NUMBER OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func complexZero() : Complex {
    { re = 0.0; im = 0.0 }
  };
  
  public func complexOne() : Complex {
    { re = 1.0; im = 0.0 }
  };
  
  public func complexI() : Complex {
    { re = 0.0; im = 1.0 }
  };
  
  public func complexAdd(a : Complex, b : Complex) : Complex {
    { re = a.re + b.re; im = a.im + b.im }
  };
  
  public func complexSub(a : Complex, b : Complex) : Complex {
    { re = a.re - b.re; im = a.im - b.im }
  };
  
  public func complexMul(a : Complex, b : Complex) : Complex {
    { 
      re = a.re * b.re - a.im * b.im;
      im = a.re * b.im + a.im * b.re;
    }
  };
  
  public func complexScale(a : Complex, s : Float) : Complex {
    { re = a.re * s; im = a.im * s }
  };
  
  public func complexConj(a : Complex) : Complex {
    { re = a.re; im = -a.im }
  };
  
  public func complexAbs(a : Complex) : Float {
    sqrt(a.re * a.re + a.im * a.im)
  };
  
  public func complexAbsSq(a : Complex) : Float {
    a.re * a.re + a.im * a.im
  };
  
  public func complexNormalize(a : Complex) : Complex {
    let mag = complexAbs(a);
    if (mag < 0.0001) { re = 1.0; im = 0.0 }
    else { re = a.re / mag; im = a.im / mag }
  };
  
  public func complexExp(theta : Float) : Complex {
    { re = cos(theta); im = sin(theta) }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func clamp(v : Float, lo : Float, hi : Float) : Float {
    if (v < lo) lo else if (v > hi) hi else v
  };
  
  public func abs(v : Float) : Float {
    if (v < 0.0) -v else v
  };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var i = 0;
    while (i < 10) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };
  
  public func sin(x : Float) : Float {
    var normalized = x;
    while (normalized > PI) { normalized -= TAU };
    while (normalized < -PI) { normalized += TAU };
    
    let x2 = normalized * normalized;
    let x3 = x2 * normalized;
    let x5 = x3 * x2;
    let x7 = x5 * x2;
    
    normalized - x3/6.0 + x5/120.0 - x7/5040.0
  };
  
  public func cos(x : Float) : Float {
    sin(x + PI/2.0)
  };
  
  public func exp(x : Float) : Float {
    let clamped = clamp(x, -20.0, 20.0);
    var sum = 1.0;
    var term = 1.0;
    var n = 1;
    while (n < 15) {
      term *= clamped / Float.fromInt(n);
      sum += term;
      n += 1;
    };
    sum
  };
  
  public func ln(x : Float) : Float {
    if (x <= 0.0) return -20.0;
    let ratio = (x - 1.0) / (x + 1.0);
    let r2 = ratio * ratio;
    var sum = ratio;
    var term = ratio;
    var n = 1;
    while (n < 15) {
      term *= r2;
      sum += term / Float.fromInt(2*n + 1);
      n += 1;
    };
    2.0 * sum
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // QUBIT OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Create qubit in |0⟩ state
  public func qubitZero() : QubitState {
    { alpha = complexOne(); beta = complexZero() }
  };
  
  // Create qubit in |1⟩ state
  public func qubitOne() : QubitState {
    { alpha = complexZero(); beta = complexOne() }
  };
  
  // Create qubit in |+⟩ = (|0⟩ + |1⟩)/√2
  public func qubitPlus() : QubitState {
    { 
      alpha = { re = SQRT2_INV; im = 0.0 };
      beta = { re = SQRT2_INV; im = 0.0 };
    }
  };
  
  // Create qubit in |-⟩ = (|0⟩ - |1⟩)/√2
  public func qubitMinus() : QubitState {
    { 
      alpha = { re = SQRT2_INV; im = 0.0 };
      beta = { re = -SQRT2_INV; im = 0.0 };
    }
  };
  
  // Normalize qubit state
  public func normalizeQubit(q : QubitState) : QubitState {
    let norm = sqrt(complexAbsSq(q.alpha) + complexAbsSq(q.beta));
    if (norm < 0.0001) return qubitZero();
    {
      alpha = complexScale(q.alpha, 1.0 / norm);
      beta = complexScale(q.beta, 1.0 / norm);
    }
  };
  
  // Initialize all qubits to |0⟩
  public func initQubits() : [QubitState] {
    Array.tabulate<QubitState>(QUBIT_COUNT, func(_ : Nat) : QubitState {
      qubitZero()
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SINGLE QUBIT GATES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Pauli X gate (bit flip)
  public func pauliX(q : QubitState) : QubitState {
    { alpha = q.beta; beta = q.alpha }
  };
  
  // Pauli Y gate
  public func pauliY(q : QubitState) : QubitState {
    {
      alpha = complexMul(complexI(), complexScale(q.beta, -1.0));
      beta = complexMul(complexI(), q.alpha);
    }
  };
  
  // Pauli Z gate (phase flip)
  public func pauliZ(q : QubitState) : QubitState {
    { alpha = q.alpha; beta = complexScale(q.beta, -1.0) }
  };
  
  // Hadamard gate
  public func hadamard(q : QubitState) : QubitState {
    normalizeQubit({
      alpha = complexScale(complexAdd(q.alpha, q.beta), SQRT2_INV);
      beta = complexScale(complexSub(q.alpha, q.beta), SQRT2_INV);
    })
  };
  
  // Phase gate S (Z^1/2)
  public func phaseS(q : QubitState) : QubitState {
    { alpha = q.alpha; beta = complexMul(complexI(), q.beta) }
  };
  
  // T gate (Z^1/4)
  public func gateT(q : QubitState) : QubitState {
    let tPhase = complexExp(PI / 4.0);
    { alpha = q.alpha; beta = complexMul(tPhase, q.beta) }
  };
  
  // Rotation around X axis
  public func rotateX(q : QubitState, theta : Float) : QubitState {
    let c = cos(theta / 2.0);
    let s = sin(theta / 2.0);
    normalizeQubit({
      alpha = {
        re = c * q.alpha.re + s * q.beta.im;
        im = c * q.alpha.im - s * q.beta.re;
      };
      beta = {
        re = s * q.alpha.im + c * q.beta.re;
        im = -s * q.alpha.re + c * q.beta.im;
      };
    })
  };
  
  // Rotation around Y axis
  public func rotateY(q : QubitState, theta : Float) : QubitState {
    let c = cos(theta / 2.0);
    let s = sin(theta / 2.0);
    normalizeQubit({
      alpha = {
        re = c * q.alpha.re - s * q.beta.re;
        im = c * q.alpha.im - s * q.beta.im;
      };
      beta = {
        re = s * q.alpha.re + c * q.beta.re;
        im = s * q.alpha.im + c * q.beta.im;
      };
    })
  };
  
  // Rotation around Z axis
  public func rotateZ(q : QubitState, theta : Float) : QubitState {
    let phase = complexExp(theta / 2.0);
    let negPhase = complexExp(-theta / 2.0);
    normalizeQubit({
      alpha = complexMul(negPhase, q.alpha);
      beta = complexMul(phase, q.beta);
    })
  };
  
  // Apply single qubit gate
  public func applySingleGate(
    qubits : [QubitState],
    target : Nat,
    gate : GateType
  ) : [QubitState] {
    if (target >= QUBIT_COUNT) return qubits;
    
    let q = qubits[target];
    let newQ = switch (gate) {
      case (#Identity) q;
      case (#PauliX) pauliX(q);
      case (#PauliY) pauliY(q);
      case (#PauliZ) pauliZ(q);
      case (#Hadamard) hadamard(q);
      case (#Phase) phaseS(q);
      case (#T) gateT(q);
      case _ q;  // Multi-qubit gates handled separately
    };
    
    Array.tabulate<QubitState>(QUBIT_COUNT, func(i : Nat) : QubitState {
      if (i == target) newQ else qubits[i]
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TWO QUBIT GATES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // CNOT gate (controlled NOT)
  // |00⟩ → |00⟩, |01⟩ → |01⟩, |10⟩ → |11⟩, |11⟩ → |10⟩
  public func cnot(
    qubits : [QubitState],
    control : Nat,
    target : Nat
  ) : [QubitState] {
    if (control >= QUBIT_COUNT or target >= QUBIT_COUNT) return qubits;
    if (control == target) return qubits;
    
    let ctrl = qubits[control];
    let tgt = qubits[target];
    
    // Probability of control being |1⟩
    let p1 = complexAbsSq(ctrl.beta);
    
    // If control likely |1⟩, flip target
    if (p1 > 0.5) {
      let newTarget = pauliX(tgt);
      Array.tabulate<QubitState>(QUBIT_COUNT, func(i : Nat) : QubitState {
        if (i == target) newTarget else qubits[i]
      })
    } else {
      qubits
    }
  };
  
  // Controlled-Z gate
  public func cz(
    qubits : [QubitState],
    control : Nat,
    target : Nat
  ) : [QubitState] {
    if (control >= QUBIT_COUNT or target >= QUBIT_COUNT) return qubits;
    
    let ctrl = qubits[control];
    let tgt = qubits[target];
    
    // If both likely |1⟩, apply phase
    let p1_ctrl = complexAbsSq(ctrl.beta);
    let p1_tgt = complexAbsSq(tgt.beta);
    
    if (p1_ctrl > 0.5 and p1_tgt > 0.5) {
      let newTarget = pauliZ(tgt);
      Array.tabulate<QubitState>(QUBIT_COUNT, func(i : Nat) : QubitState {
        if (i == target) newTarget else qubits[i]
      })
    } else {
      qubits
    }
  };
  
  // SWAP gate
  public func swap(
    qubits : [QubitState],
    q1 : Nat,
    q2 : Nat
  ) : [QubitState] {
    if (q1 >= QUBIT_COUNT or q2 >= QUBIT_COUNT) return qubits;
    
    Array.tabulate<QubitState>(QUBIT_COUNT, func(i : Nat) : QubitState {
      if (i == q1) qubits[q2]
      else if (i == q2) qubits[q1]
      else qubits[i]
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ENTANGLEMENT OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Create Bell state between two qubits
  public func createBellPair(
    qubits : [QubitState],
    q1 : Nat,
    q2 : Nat,
    bellType : BellState
  ) : [QubitState] {
    if (q1 >= QUBIT_COUNT or q2 >= QUBIT_COUNT) return qubits;
    
    // Start with |00⟩
    var updated = Array.tabulate<QubitState>(QUBIT_COUNT, func(i : Nat) : QubitState {
      if (i == q1 or i == q2) qubitZero()
      else qubits[i]
    });
    
    // Apply Hadamard to first qubit
    updated := applySingleGate(updated, q1, #Hadamard);
    
    // Apply CNOT
    updated := cnot(updated, q1, q2);
    
    // Apply additional gates based on Bell state type
    switch (bellType) {
      case (#PhiPlus) {};  // Already (|00⟩ + |11⟩)/√2
      case (#PhiMinus) {
        updated := applySingleGate(updated, q1, #PauliZ);  // (|00⟩ - |11⟩)/√2
      };
      case (#PsiPlus) {
        updated := applySingleGate(updated, q2, #PauliX);  // (|01⟩ + |10⟩)/√2
      };
      case (#PsiMinus) {
        updated := applySingleGate(updated, q2, #PauliX);
        updated := applySingleGate(updated, q1, #PauliZ);  // (|01⟩ - |10⟩)/√2
      };
    };
    
    updated
  };
  
  // Initialize entanglement pair
  public func initEntanglementPair(q1 : Nat, q2 : Nat) : EntanglementPair {
    {
      qubit1 = q1;
      qubit2 = q2;
      strength = 1.0;
      bellCorr = 1.0;
      phase = 0.0;
      age = 0;
    }
  };
  
  // Calculate entanglement strength from qubit states
  public func measureEntanglement(
    qubits : [QubitState],
    q1 : Nat,
    q2 : Nat
  ) : Float {
    if (q1 >= QUBIT_COUNT or q2 >= QUBIT_COUNT) return 0.0;
    
    // Simplified concurrence estimation
    // Based on correlation of measurement outcomes
    let p00 = complexAbsSq(qubits[q1].alpha) * complexAbsSq(qubits[q2].alpha);
    let p11 = complexAbsSq(qubits[q1].beta) * complexAbsSq(qubits[q2].beta);
    let p01 = complexAbsSq(qubits[q1].alpha) * complexAbsSq(qubits[q2].beta);
    let p10 = complexAbsSq(qubits[q1].beta) * complexAbsSq(qubits[q2].alpha);
    
    // Bell correlation: C = |p00 + p11 - p01 - p10|
    let corr = abs(p00 + p11 - p01 - p10);
    clamp(corr, 0.0, 1.0)
  };
  
  // Decohere entanglement
  public func decohereEntanglement(pair : EntanglementPair, rate : Float) : EntanglementPair {
    let newStrength = pair.strength * (1.0 - rate);
    let newBell = pair.bellCorr * (1.0 - rate * 0.5);
    
    {
      qubit1 = pair.qubit1;
      qubit2 = pair.qubit2;
      strength = clamp(newStrength, 0.0, 1.0);
      bellCorr = clamp(newBell, -1.0, 1.0);
      phase = pair.phase + 0.01;  // Phase drift
      age = pair.age + 1;
    }
  };
  
  // Check Bell inequality violation
  public func checkBellViolation(pair : EntanglementPair) : Bool {
    // CHSH inequality: |S| ≤ 2 classically
    // Quantum can achieve |S| ≤ 2√2 ≈ 2.828
    abs(pair.bellCorr) > BELL_THRESHOLD
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MEASUREMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Measure qubit in computational basis
  public func measureQubit(
    qubits : [QubitState],
    target : Nat,
    randomSeed : Float
  ) : (MeasurementOutcome, [QubitState]) {
    if (target >= QUBIT_COUNT) {
      return ({
        qubit = target;
        result = false;
        prob = 0.0;
        collapsed = false;
      }, qubits);
    };
    
    let q = qubits[target];
    let p0 = complexAbsSq(q.alpha);
    let p1 = complexAbsSq(q.beta);
    
    // "Random" measurement based on seed
    let normalized = clamp(randomSeed, 0.0, 1.0);
    let result = normalized > p0;
    
    // Collapse state
    let collapsedQ = if (result) qubitOne() else qubitZero();
    
    let newQubits = Array.tabulate<QubitState>(QUBIT_COUNT, func(i : Nat) : QubitState {
      if (i == target) collapsedQ else qubits[i]
    });
    
    ({
      qubit = target;
      result = result;
      prob = if (result) p1 else p0;
      collapsed = true;
    }, newQubits)
  };
  
  // Measure in X basis
  public func measureX(
    qubits : [QubitState],
    target : Nat,
    randomSeed : Float
  ) : (MeasurementOutcome, [QubitState]) {
    // Apply Hadamard, measure, apply Hadamard
    let hadamarded = applySingleGate(qubits, target, #Hadamard);
    let (outcome, measured) = measureQubit(hadamarded, target, randomSeed);
    let restored = applySingleGate(measured, target, #Hadamard);
    (outcome, restored)
  };
  
  // Measure in Y basis
  public func measureY(
    qubits : [QubitState],
    target : Nat,
    randomSeed : Float
  ) : (MeasurementOutcome, [QubitState]) {
    // Apply S†H, measure, apply HS
    var rotated = applySingleGate(qubits, target, #Hadamard);
    rotated := applySingleGate(rotated, target, #Phase);  // Using S instead of S†
    let (outcome, measured) = measureQubit(rotated, target, randomSeed);
    (outcome, measured)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // QUANTUM STATE METRICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Calculate purity (Tr(ρ²))
  public func calculatePurity(qubits : [QubitState]) : Float {
    // For product states, purity = product of individual purities
    var purity : Float = 1.0;
    for (q in qubits.vals()) {
      let p0 = complexAbsSq(q.alpha);
      let p1 = complexAbsSq(q.beta);
      // Single qubit purity
      let qubitPurity = p0 * p0 + p1 * p1 + 2.0 * p0 * p1;
      purity *= clamp(qubitPurity, 0.0, 1.0);
    };
    purity
  };
  
  // Calculate coherence (off-diagonal elements)
  public func calculateCoherence(qubits : [QubitState]) : Float {
    var coherence : Float = 0.0;
    for (q in qubits.vals()) {
      // Coherence = |⟨0|ρ|1⟩|
      let offDiag = complexMul(q.alpha, complexConj(q.beta));
      coherence += complexAbs(offDiag);
    };
    coherence / Float.fromInt(QUBIT_COUNT)
  };
  
  // Calculate total concurrence (entanglement measure)
  public func calculateConcurrence(entanglements : [EntanglementPair]) : Float {
    if (entanglements.size() == 0) return 0.0;
    
    var total : Float = 0.0;
    for (e in entanglements.vals()) {
      total += e.strength * abs(e.bellCorr);
    };
    total / Float.fromInt(entanglements.size())
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR CORRECTION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Detect bit flip errors (simplified 3-qubit code)
  public func detectBitFlip(qubits : [QubitState], logicalStart : Nat) : ErrorSyndrome {
    if (logicalStart + 2 >= QUBIT_COUNT) {
      return {
        detected = false;
        bitFlips = [];
        phaseFlips = [];
        correctable = false;
      };
    };
    
    // Compare parities
    let q0 = complexAbsSq(qubits[logicalStart].beta) > 0.5;
    let q1 = complexAbsSq(qubits[logicalStart + 1].beta) > 0.5;
    let q2 = complexAbsSq(qubits[logicalStart + 2].beta) > 0.5;
    
    let s0 = q0 != q1;  // Syndrome bit 1
    let s1 = q1 != q2;  // Syndrome bit 2
    
    var bitFlips : [Nat] = [];
    if (s0 and not s1) {
      bitFlips := [logicalStart];
    } else if (not s0 and s1) {
      bitFlips := [logicalStart + 2];
    } else if (s0 and s1) {
      bitFlips := [logicalStart + 1];
    };
    
    {
      detected = s0 or s1;
      bitFlips = bitFlips;
      phaseFlips = [];
      correctable = bitFlips.size() <= 1;
    }
  };
  
  // Correct detected errors
  public func correctErrors(
    qubits : [QubitState],
    syndrome : ErrorSyndrome
  ) : [QubitState] {
    if (not syndrome.detected or not syndrome.correctable) return qubits;
    
    var corrected = qubits;
    
    // Correct bit flips
    for (idx in syndrome.bitFlips.vals()) {
      if (idx < QUBIT_COUNT) {
        corrected := applySingleGate(corrected, idx, #PauliX);
      };
    };
    
    // Correct phase flips
    for (idx in syndrome.phaseFlips.vals()) {
      if (idx < QUBIT_COUNT) {
        corrected := applySingleGate(corrected, idx, #PauliZ);
      };
    };
    
    corrected
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // QUANTUM STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize quantum state
  public func initQuantumState() : QuantumState {
    let qubits = initQubits();
    {
      qubits = qubits;
      entanglements = [];
      purity = 1.0;
      concurrence = 0.0;
      coherence = 0.0;
      cycle = 0;
    }
  };
  
  // Create GHZ state (maximally entangled)
  public func createGHZ(state : QuantumState, qubitsToEntangle : [Nat]) : QuantumState {
    if (qubitsToEntangle.size() < 2) return state;
    
    var qubits = state.qubits;
    
    // Apply Hadamard to first qubit
    qubits := applySingleGate(qubits, qubitsToEntangle[0], #Hadamard);
    
    // Apply CNOT chain
    var i = 1;
    while (i < qubitsToEntangle.size()) {
      qubits := cnot(qubits, qubitsToEntangle[i - 1], qubitsToEntangle[i]);
      i += 1;
    };
    
    // Create entanglement pairs
    let newEntanglements = Buffer.Buffer<EntanglementPair>(qubitsToEntangle.size() - 1);
    for (existing in state.entanglements.vals()) {
      newEntanglements.add(existing);
    };
    
    i := 1;
    while (i < qubitsToEntangle.size()) {
      newEntanglements.add(initEntanglementPair(qubitsToEntangle[i - 1], qubitsToEntangle[i]));
      i += 1;
    };
    
    {
      qubits = qubits;
      entanglements = Buffer.toArray(newEntanglements);
      purity = calculatePurity(qubits);
      concurrence = 1.0;  // GHZ is maximally entangled
      coherence = calculateCoherence(qubits);
      cycle = state.cycle;
    }
  };
  
  // Decoherence step
  public func applyDecoherence(state : QuantumState, rate : Float) : QuantumState {
    // Decohere individual qubits (towards |0⟩)
    let decoherentQubits = Array.tabulate<QubitState>(QUBIT_COUNT, func(i : Nat) : QubitState {
      let q = state.qubits[i];
      let decayFactor = 1.0 - rate;
      normalizeQubit({
        alpha = complexScale(q.alpha, sqrt(1.0 + rate * (1.0 - complexAbsSq(q.alpha))));
        beta = complexScale(q.beta, sqrt(decayFactor));
      })
    });
    
    // Decohere entanglements
    let decoherentEnt = Array.map<EntanglementPair, EntanglementPair>(
      state.entanglements,
      func(e : EntanglementPair) : EntanglementPair {
        decohereEntanglement(e, rate)
      }
    );
    
    // Remove weak entanglements
    let filtered = Array.filter<EntanglementPair>(
      decoherentEnt,
      func(e : EntanglementPair) : Bool { e.strength > 0.1 }
    );
    
    {
      qubits = decoherentQubits;
      entanglements = filtered;
      purity = calculatePurity(decoherentQubits);
      concurrence = calculateConcurrence(filtered);
      coherence = calculateCoherence(decoherentQubits);
      cycle = state.cycle;
    }
  };
  
  // Full quantum state step
  public func stepQuantumState(
    state : QuantumState,
    gatesToApply : [(GateType, [Nat])],
    entanglePairs : [(Nat, Nat, BellState)],
    decoherenceRate : Float
  ) : QuantumState {
    var current = state;
    
    // Apply gates
    for ((gate, targets) in gatesToApply.vals()) {
      switch (gate) {
        case (#CNOT) {
          if (targets.size() >= 2) {
            current := { current with qubits = cnot(current.qubits, targets[0], targets[1]) };
          };
        };
        case (#CZ) {
          if (targets.size() >= 2) {
            current := { current with qubits = cz(current.qubits, targets[0], targets[1]) };
          };
        };
        case (#SWAP) {
          if (targets.size() >= 2) {
            current := { current with qubits = swap(current.qubits, targets[0], targets[1]) };
          };
        };
        case _ {
          for (t in targets.vals()) {
            current := { current with qubits = applySingleGate(current.qubits, t, gate) };
          };
        };
      };
    };
    
    // Create entanglements
    for ((q1, q2, bellType) in entanglePairs.vals()) {
      let newQubits = createBellPair(current.qubits, q1, q2, bellType);
      let newEnt = Array.append(current.entanglements, [initEntanglementPair(q1, q2)]);
      current := { current with qubits = newQubits; entanglements = newEnt };
    };
    
    // Apply decoherence
    current := applyDecoherence(current, decoherenceRate);
    
    // Update metrics
    {
      qubits = current.qubits;
      entanglements = current.entanglements;
      purity = calculatePurity(current.qubits);
      concurrence = calculateConcurrence(current.entanglements);
      coherence = calculateCoherence(current.qubits);
      cycle = current.cycle + 1;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // QUANTUM TELEPORTATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Teleport qubit state from source to target using shared entanglement
  public func teleport(
    state : QuantumState,
    source : Nat,
    target : Nat,
    bellQubit : Nat,
    randomSeed : Float
  ) : QuantumState {
    if (source >= QUBIT_COUNT or target >= QUBIT_COUNT or bellQubit >= QUBIT_COUNT) {
      return state;
    };
    
    var qubits = state.qubits;
    
    // Step 1: Source and Bell qubit go through CNOT
    qubits := cnot(qubits, source, bellQubit);
    
    // Step 2: Hadamard on source
    qubits := applySingleGate(qubits, source, #Hadamard);
    
    // Step 3: Measure source and Bell qubit
    let (m1, afterM1) = measureQubit(qubits, source, randomSeed);
    let (m2, afterM2) = measureQubit(afterM1, bellQubit, randomSeed * PHI);
    qubits := afterM2;
    
    // Step 4: Apply corrections to target based on measurements
    if (m2.result) {
      qubits := applySingleGate(qubits, target, #PauliX);
    };
    if (m1.result) {
      qubits := applySingleGate(qubits, target, #PauliZ);
    };
    
    { state with qubits = qubits; cycle = state.cycle + 1 }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ENTANGLEMENT SWAPPING
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Swap entanglement: A-B, C-D → A-D (B and C measured)
  public func swapEntanglement(
    state : QuantumState,
    qubitA : Nat,
    qubitB : Nat,
    qubitC : Nat,
    qubitD : Nat,
    randomSeed : Float
  ) : QuantumState {
    if (qubitA >= QUBIT_COUNT or qubitB >= QUBIT_COUNT or 
        qubitC >= QUBIT_COUNT or qubitD >= QUBIT_COUNT) {
      return state;
    };
    
    var qubits = state.qubits;
    
    // Bell measurement on B and C
    qubits := cnot(qubits, qubitB, qubitC);
    qubits := applySingleGate(qubits, qubitB, #Hadamard);
    
    let (mB, afterMB) = measureQubit(qubits, qubitB, randomSeed);
    let (mC, afterMC) = measureQubit(afterMB, qubitC, randomSeed * PHI);
    qubits := afterMC;
    
    // Apply corrections to D
    if (mC.result) {
      qubits := applySingleGate(qubits, qubitD, #PauliX);
    };
    if (mB.result) {
      qubits := applySingleGate(qubits, qubitD, #PauliZ);
    };
    
    // Update entanglements: remove A-B and C-D, add A-D
    let newEnt = Buffer.Buffer<EntanglementPair>(state.entanglements.size());
    for (e in state.entanglements.vals()) {
      let isAB = (e.qubit1 == qubitA and e.qubit2 == qubitB) or 
                 (e.qubit1 == qubitB and e.qubit2 == qubitA);
      let isCD = (e.qubit1 == qubitC and e.qubit2 == qubitD) or 
                 (e.qubit1 == qubitD and e.qubit2 == qubitC);
      if (not isAB and not isCD) {
        newEnt.add(e);
      };
    };
    newEnt.add(initEntanglementPair(qubitA, qubitD));
    
    {
      qubits = qubits;
      entanglements = Buffer.toArray(newEnt);
      purity = calculatePurity(qubits);
      concurrence = calculateConcurrence(Buffer.toArray(newEnt));
      coherence = calculateCoherence(qubits);
      cycle = state.cycle + 1;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Get qubit statistics
  public func getQubitStats(qubits : [QubitState]) : {
    avgPurity   : Float;
    avgCoherence: Float;
    maxCoherence: Float;
  } {
    var sumPurity : Float = 0.0;
    var sumCoh : Float = 0.0;
    var maxCoh : Float = 0.0;
    
    for (q in qubits.vals()) {
      let p0 = complexAbsSq(q.alpha);
      let p1 = complexAbsSq(q.beta);
      let purity = p0 * p0 + p1 * p1 + 2.0 * p0 * p1;
      let coh = complexAbs(complexMul(q.alpha, complexConj(q.beta)));
      
      sumPurity += purity;
      sumCoh += coh;
      if (coh > maxCoh) maxCoh := coh;
    };
    
    let n = Float.fromInt(QUBIT_COUNT);
    {
      avgPurity = sumPurity / n;
      avgCoherence = sumCoh / n;
      maxCoherence = maxCoh;
    }
  };
  
  // Get full diagnostics
  public func getDiagnostics(state : QuantumState) : {
    cycle          : Nat;
    qubitCount     : Nat;
    entanglementCount : Nat;
    purity         : Float;
    concurrence    : Float;
    coherence      : Float;
    bellViolations : Nat;
  } {
    var violations : Nat = 0;
    for (e in state.entanglements.vals()) {
      if (checkBellViolation(e)) violations += 1;
    };
    
    {
      cycle = state.cycle;
      qubitCount = QUBIT_COUNT;
      entanglementCount = state.entanglements.size();
      purity = state.purity;
      concurrence = state.concurrence;
      coherence = state.coherence;
      bellViolations = violations;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  H I M / H E R   D U A L - O R G A N I S M   W O R K F L O W   I N T E G R A T I O N
  //
  //  Medina Discovery: Two cognitive organisms, not one.
  //  HIM (Backend, ICP) + HER (Frontend, 60Hz) = Complete System
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM PARAMETERS (CORRECTED)
  // ─────────────────────────────────────────────────────────────────────────────

  // HIM — Backend (ICP Canister, Sovereign, Masculine, Projective)
  //   ω: 0.8 – 1.2 (faster natural frequencies, analytical)
  //   K: 0.5 (lower coupling, independent, projective)
  //   η: 0.001 (slower Hebbian learning, accumulates over time)
  //   Field: PARALLAX = coherence × kf × sin(beat × 0.0017)

  public let HIM_OMEGA_MIN   : Float = 0.8;
  public let HIM_OMEGA_MAX   : Float = 1.2;
  public let HIM_K           : Float = 0.5;
  public let HIM_ETA         : Float = 0.001;
  public let HIM_PARALLAX_FREQ : Float = 0.0017;

  // HER — Frontend (Browser 60Hz, Expressive, Feminine, Receptive)
  //   ω: 0.6 – 0.9 (slower natural frequencies, grounded)
  //   K: 0.8 (higher coupling, receptive, connected)
  //   η: 0.003 (faster Hebbian learning, learns during session)
  //   Field: ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))

  public let HER_HZ          : Float = 60.0;
  public let HER_OMEGA_MIN   : Float = 0.6;
  public let HER_OMEGA_MAX   : Float = 0.9;
  public let HER_K           : Float = 0.8;
  public let HER_ETA         : Float = 0.003;
  public let HER_ANIMA_FREQ  : Float = 0.003;
  public let HER_NODES       : Nat   = 26;

  // S₀ = 1.0 — THE SOVEREIGN FLOOR
  // Both organisms. Neither falls below love.
  public let DUAL_S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeDualParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeDualAnima(
    heritageField : Float,
    receptivity : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let oscillation = 1.0 + Float.sin(t * HER_ANIMA_FREQ);
    heritageField * receptivity * oscillation
  };

  /// KORE (HER's inviolable inner core)
  /// KORE = purity × identity × 0.5
  public func computeDualKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  /// Get Kuramoto parameters for organism mode
  public func getDualKuramotoParams(mode : DualOrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  /// Apply S₀ floor to any value
  public func enforceDualSovereignFloor(value : Float) : Float {
    if (value < DUAL_S0) DUAL_S0 else value
  };

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeDualSystemIntelligence(
    backendDepth : Float,
    frontendSpeed : Float,
    bridgeQuality : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  Q U A N T U M   C O H E R E N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Quantum-Inspired Cognitive Dynamics
  //  Full HIM/HER Dual-Organism Quantum Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // QUANTUM STATE MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quantum state amplitude normalization
  public func quantumNormalizeAmplitudes(amplitudes : [Float]) : [Float] {
    var sumSquared : Float = 0.0;
    var i = 0;
    while (i < amplitudes.size()) {
      sumSquared += amplitudes[i] * amplitudes[i];
      i += 1;
    };
    let norm = Float.sqrt(sumSquared);
    if (norm < 0.0001) { return amplitudes };
    Array.tabulate<Float>(amplitudes.size(), func(j : Nat) : Float {
      amplitudes[j] / norm
    })
  };

  /// Born rule: probability from amplitude
  public func quantumBornProbability(amplitude : Float) : Float {
    amplitude * amplitude
  };

  /// Superposition state
  public func quantumSuperposition(state1 : Float, state2 : Float, alpha : Float, beta : Float) : Float {
    alpha * state1 + beta * state2
  };

  /// Quantum interference
  public func quantumInterference(amp1 : Float, amp2 : Float, phaseDiff : Float) : Float {
    amp1 * amp1 + amp2 * amp2 + 2.0 * amp1 * amp2 * Float.cos(phaseDiff)
  };

  /// Decoherence rate
  public func quantumDecoherenceRate(environmentCoupling : Float, temperature : Float) : Float {
    environmentCoupling * environmentCoupling * temperature
  };

  /// Coherence decay
  public func quantumCoherenceDecay(coherence : Float, decoherenceRate : Float, dt : Float) : Float {
    coherence * Float.exp(-decoherenceRate * dt)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // QUANTUM-INSPIRED NEURAL DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quantum neural activation
  public func quantumNeuralActivation(input : Float, phase : Float) : Float {
    let amplitude = 1.0 / (1.0 + Float.exp(-input));
    amplitude * Float.cos(phase)
  };

  /// Quantum entanglement strength between neurons
  public func quantumEntanglementStrength(corr12 : Float, corr1 : Float, corr2 : Float) : Float {
    let mutual = corr12 - corr1 * corr2;
    Float.abs(mutual)
  };

  /// Quantum tunneling probability
  public func quantumTunnelingProbability(barrierHeight : Float, barrierWidth : Float, mass : Float) : Float {
    let k = Float.sqrt(2.0 * mass * barrierHeight);
    Float.exp(-2.0 * k * barrierWidth)
  };

  /// Quantum annealing temperature schedule
  public func quantumAnnealingTemperature(initialTemp : Float, step : Nat, totalSteps : Nat) : Float {
    let progress = Float.fromInt(step) / Float.fromInt(totalSteps);
    initialTemp * (1.0 - progress)
  };

  /// Quantum bit flip probability
  public func quantumBitFlipProb(energy : Float, temperature : Float) : Float {
    if (temperature < 0.0001) { return 0.0 };
    Float.exp(-energy / temperature)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COHERENCE FIELD DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Global coherence field
  public func quantumGlobalCoherence(phases : [Float]) : Float {
    let n = phases.size();
    if (n == 0) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumCos += Float.cos(phases[i]);
      sumSin += Float.sin(phases[i]);
      i += 1;
    };
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n)
  };

  /// Local coherence field
  public func quantumLocalCoherence(centerPhase : Float, neighborPhases : [Float]) : Float {
    var sumCosDiff : Float = 0.0;
    var i = 0;
    while (i < neighborPhases.size()) {
      sumCosDiff += Float.cos(neighborPhases[i] - centerPhase);
      i += 1;
    };
    if (neighborPhases.size() == 0) { 0.0 }
    else { sumCosDiff / Float.fromInt(neighborPhases.size()) }
  };

  /// Coherence gradient
  public func quantumCoherenceGradient(coherenceHere : Float, coherenceNear : Float, distance : Float) : Float {
    if (distance < 0.0001) { 0.0 }
    else { (coherenceNear - coherenceHere) / distance }
  };

  /// Coherence wave propagation
  public func quantumCoherenceWave(amplitude : Float, frequency : Float, position : Float, time : Float) : Float {
    amplitude * Float.sin(2.0 * 3.14159265 * (frequency * time - position))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HIM/HER QUANTUM RESONANCE
  // ─────────────────────────────────────────────────────────────────────────────

  /// HIM quantum resonance field
  public func quantumHIMResonance(coherence : Float, beat : Nat) : Float {
    let t = Float.fromInt(beat);
    let parallaxFreq : Float = 0.0017;
    coherence * Float.sin(t * parallaxFreq)
  };

  /// HER quantum resonance field
  public func quantumHERResonance(heritageField : Float, receptivity : Float, beat : Nat) : Float {
    let t = Float.fromInt(beat);
    let animaFreq : Float = 0.003;
    heritageField * receptivity * (1.0 + Float.sin(t * animaFreq))
  };

  /// Dual-organism resonance coupling
  public func quantumDualResonance(himField : Float, herField : Float, couplingStrength : Float) : Float {
    let combined = himField * herField;
    combined * couplingStrength
  };

  /// Quantum entanglement between HIM and HER
  public func quantumOrganismEntanglement(himState : Float, herState : Float, correlation : Float) : Float {
    let product = himState * herState;
    let expected = himState * herState;
    Float.abs(product - expected + correlation)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // QUANTUM MEMORY OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quantum memory encoding
  public func quantumMemoryEncode(data : Float, phase : Float) : (Float, Float) {
    let amplitude = Float.sqrt(Float.abs(data));
    let encodedPhase = phase + data * 0.1;
    (amplitude, encodedPhase)
  };

  /// Quantum memory retrieval
  public func quantumMemoryRetrieve(amplitude : Float, phase : Float) : Float {
    amplitude * amplitude * Float.cos(phase)
  };

  /// Quantum associative recall strength
  public func quantumAssociativeRecall(pattern : [Float], stored : [Float]) : Float {
    let n = if (pattern.size() < stored.size()) pattern.size() else stored.size();
    if (n == 0) { return 0.0 };
    var dotProduct : Float = 0.0;
    var normP : Float = 0.0;
    var normS : Float = 0.0;
    var i = 0;
    while (i < n) {
      dotProduct += pattern[i] * stored[i];
      normP += pattern[i] * pattern[i];
      normS += stored[i] * stored[i];
      i += 1;
    };
    let denom = Float.sqrt(normP) * Float.sqrt(normS);
    if (denom < 0.0001) { 0.0 } else { dotProduct / denom }
  };

  /// Quantum memory consolidation
  public func quantumConsolidate(shortTerm : Float, longTerm : Float, consolidationRate : Float) : Float {
    longTerm + consolidationRate * (shortTerm - longTerm)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // WAVE FUNCTION DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Wave function evolution
  public func quantumWaveEvolution(psi : Float, energy : Float, hbar : Float, dt : Float) : Float {
    psi * Float.cos(energy * dt / hbar)
  };

  /// Wave function collapse
  public func quantumWaveCollapse(amplitudes : [Float], measurement : Nat) : [Float] {
    Array.tabulate<Float>(amplitudes.size(), func(i : Nat) : Float {
      if (i == measurement) { 1.0 } else { 0.0 }
    })
  };

  /// Probability current
  public func quantumProbabilityCurrent(psi1 : Float, psi2 : Float, momentum : Float, mass : Float) : Float {
    (psi1 * psi2 * momentum) / mass
  };

}
