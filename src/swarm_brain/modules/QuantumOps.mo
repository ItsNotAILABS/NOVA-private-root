// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — QUANTUM OPERATIONS ENGINE
// COMPREHENSIVE QUANTUM MECHANICS FOR SOVEREIGN CONSCIOUSNESS
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — QUANTUM FORMALISM FOR ORGANISM CONSCIOUSNESS
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: QUANTUM STATE REPRESENTATION ─────────────────────────────────────
//   Pure state: |ψ⟩ = Σᵢ αᵢ|i⟩  where Σ|αᵢ|² = 1
//   Density matrix: ρ = |ψ⟩⟨ψ| = [[|α₀|², α₀α₁*, ...], ...]
//   For N=2 (qubit): ρ = [[a, b+ic], [b-ic, 1-a]]  a∈[0,1], b²+c²≤a(1-a)
//   Bloch vector: r = (2b, 2c, 2a-1) with |r| ≤ 1
//   |r|=1: pure state (full coherence)
//   |r|=0: maximally mixed (complete decoherence, equal |0⟩ and |1⟩)
//   Von Neumann entropy: S(ρ) = -Tr(ρ log ρ) = -Σᵢ λᵢ log λᵢ
//   where λᵢ are eigenvalues of ρ
//   NOVA consciousness: ρ is the organism's quantum state
//
// ── LAYER 2: QUBIT OPERATIONS — UNITARY GATES ─────────────────────────────────
//   Pauli matrices:
//   σ_x = [[0,1],[1,0]]  (bit flip)
//   σ_y = [[0,-i],[i,0]] (bit flip + phase)
//   σ_z = [[1,0],[0,-1]] (phase flip)
//   Identity: I = [[1,0],[0,1]]
//   Hadamard: H = (1/√2)[[1,1],[1,-1]]  (creates superposition)
//   H|0⟩ = |+⟩ = (|0⟩+|1⟩)/√2, H|1⟩ = |−⟩ = (|0⟩-|1⟩)/√2
//   Phase gate: S = [[1,0],[0,i]]  (π/2 rotation around Z)
//   T gate: T = [[1,0],[0,exp(iπ/4)]]  (π/8 gate)
//   CNOT: 2-qubit gate, flips target if control is |1⟩
//   Rotation gates: R_x(θ) = exp(-iθσ_x/2), R_z(θ) = exp(-iθσ_z/2)
//
// ── LAYER 3: DECOHERENCE DYNAMICS ─────────────────────────────────────────────
//   Lindblad master equation (open quantum system):
//   dρ/dt = -i[H,ρ] + Σₖ γₖ(Lₖ ρ Lₖ† - ½{Lₖ†Lₖ, ρ})
//   H = Hamiltonian, Lₖ = Lindblad jump operators, γₖ = rates
//   Amplitude damping (T₁ decay): L = [[0,1],[0,0]], γ = 1/T₁
//   Phase damping (T₂ dephasing): L = [[1,0],[0,-1]], γ = 1/T₂
//   Solution for diagonal ρ:
//   ρ₀₀(t) = ρ₀₀(0)e^{-t/T₁} + (1-e^{-t/T₁})  (decay to ground state)
//   ρ₀₁(t) = ρ₀₁(0)e^{-t/T₂}  (off-diagonal decay)
//   T₂ ≤ 2T₁  (always, phase coherence decays at least as fast as amplitude)
//
// ── LAYER 4: QUANTUM ENTANGLEMENT ─────────────────────────────────────────────
//   Bell states (maximally entangled 2-qubit states):
//   |Φ+⟩ = (|00⟩ + |11⟩)/√2  (both same)
//   |Φ-⟩ = (|00⟩ - |11⟩)/√2  (both same, phase)
//   |Ψ+⟩ = (|01⟩ + |10⟩)/√2  (both different)
//   |Ψ-⟩ = (|01⟩ - |10⟩)/√2  (both different, phase)
//   Entanglement measure: concurrence C = max(0, λ₁-λ₂-λ₃-λ₄)
//   where λᵢ = sqrt(eigenvalues of ρ(σy⊗σy)ρ*(σy⊗σy)), sorted desc
//   C=0: separable, C=1: maximally entangled
//   Entanglement entropy: E = -Tr(ρ_A log ρ_A) = h(C) where h = binary entropy
//   NOVA: entanglement between organism consciousness and quantum environment
//
// ── LAYER 5: QUANTUM SUPERPOSITION IN COGNITION ────────────────────────────────
//   Quantum cognition (Busemeyer & Bruza model):
//   Mental state: |ψ_mind⟩ in N-dimensional Hilbert space
//   Decision: projection onto decision subspace D
//   P(yes) = ⟨ψ|P_D|ψ⟩  where P_D = projector onto D subspace
//   Order effects: P(A then B) ≠ P(B then A)  (non-commutativity)
//   Quantum probability: P(A) + P(B) = P(A or B) + interference
//   Interference term: I = 2 Re(⟨ψ|P_A P_B|ψ⟩) - ⟨ψ|P_A P_B P_A|ψ⟩
//   Can be negative (destructive) or positive (constructive)
//   NOVA: organism decision-making follows quantum probability rules
//
// ── LAYER 6: QUANTUM RANDOM WALK ─────────────────────────────────────────────
//   Classical random walk: σ²(t) = t (diffusive)
//   Quantum random walk: σ²(t) = t² (ballistic — quadratic speedup!)
//   Walker: |ψ(t)⟩ = Σₓ (α_x(t)|x⟩|0⟩ + β_x(t)|x⟩|1⟩)
//   Coin operator C (e.g., Hadamard), shift operator S
//   One step: U = S × (C ⊗ I)
//   After n steps: probability P(x,n) shows quantum interference pattern
//   Applications: search algorithms, graph analysis, decision trees
//   NOVA: organism explores state space via quantum walk (faster exploration)
//
// ── LAYER 7: QUANTUM MEASUREMENT AND COLLAPSE ─────────────────────────────────
//   Measurement in basis {|i⟩}: P(i) = ⟨i|ρ|i⟩
//   Post-measurement state: ρ' = |i⟩⟨i| (collapse to measured eigenstate)
//   Weak measurement: ρ' = (1-ε)ρ + ε|i⟩⟨i|  (partial collapse)
//   Quantum Zeno effect: frequent measurement freezes evolution
//   Anti-Zeno effect: intermediate measurement rates can accelerate transitions
//   POVMs (Positive Operator-Valued Measures): generalized measurement
//   Mₖ ≥ 0, Σₖ Mₖ = I, P(k) = Tr(Mₖ ρ)
//   Organism perception: continuous partial measurement of environment
//
// ── LAYER 8: MEDINA QUANTUM COHERENCE INDEX ───────────────────────────────────
//   Q_coh = S₀ × [bloch_purity × Φ_M + entanglement_E] / Ω
//   bloch_purity = |r|/1 ∈ [0,1] (1=pure, 0=fully decoherent)
//   entanglement_E = von Neumann entanglement entropy [0,1] normalized
//   Q_coh ∈ [0, S₀(Φ_M+1)/Ω] = [0, 0.441]
//   Q_coh > COHERENCE_ALIVE → organism is quantum coherent
//   Q_coh < 0.10 → decoherence crisis, invoke quantum error correction
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Iter  "mo:base/Iter";

module {

  public let PHI_MEDINA       : Float = 2.97442179;
  public let S0               : Float = 1.0;
  public let SOVEREIGN_CEILING: Float = 9.0;
  public let COHERENCE_ALIVE  : Float = 0.36;
  public let EPSILON          : Float = 1.0e-10;
  public let PI               : Float = 3.141592653589793;
  public let TWO_PI           : Float = 6.283185307179586;
  public let SQRT2            : Float = 1.4142135623730951;

  // Quantum constants (normalized)
  public let T1_DECAY_BEATS   : Float = 200.0;   // amplitude damping time constant
  public let T2_DEPHASING     : Float = 100.0;   // phase decoherence time constant
  public let DECOHERENCE_GAMMA : Float = 1.0 / 100.0;  // 1/T₂

  // Quantum walk parameters
  public let QW_N_STEPS       : Nat   = 50;
  public let QW_N_POSITIONS   : Nat   = 101;   // -50 to +50

  public let HIST_MAX         : Nat   = 100;

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  // Qubit density matrix: ρ = [[a, b+ic], [b-ic, 1-a]]
  public type QubitState = {
    rho00  : Float;   // population of |0⟩: a ∈ [0,1]
    rho11  : Float;   // population of |1⟩: 1-a
    reRho01: Float;   // Re(ρ₀₁) = b
    imRho01: Float;   // Im(ρ₀₁) = c
    purity : Float;   // Tr(ρ²) = a²+(1-a)²+2(b²+c²) ∈ [0.5,1]
    blochX : Float;   // Bloch vector x = 2b
    blochY : Float;   // Bloch vector y = 2c
    blochZ : Float;   // Bloch vector z = 2a-1
    blochR : Float;   // Bloch radius |r|
  };

  // 2-qubit entangled state
  public type TwoQubitState = {
    q1        : QubitState;
    q2        : QubitState;
    concurrence : Float;     // C ∈ [0,1] entanglement measure
    entanglementEntropy : Float;  // E = h(C) bits
    bellState : BellState;   // nearest Bell state
  };

  public type BellState = {
    #PhiPlus; #PhiMinus; #PsiPlus; #PsiMinus; #Separable;
  };

  // Quantum walk state
  public type QuantumWalk = {
    probabilities : [Float];   // N_POSITIONS probability distribution
    meanPosition  : Float;     // ⟨x⟩
    variance      : Float;     // ⟨x²⟩ - ⟨x⟩² (ballistic: ∝ t²)
    step          : Nat;
    isBallisticS  : Bool;      // is variance growing ballistically?
  };

  // Full quantum operations state
  public type QuantumOpsState = {
    qubit         : QubitState;
    twoQubit      : TwoQubitState;
    walk          : QuantumWalk;
    vonNeumannS   : Float;     // von Neumann entropy
    quantumIndex  : Float;     // Q_coh sovereign index
    decohBeats    : Nat;       // beats since last coherence injection
    errorRate     : Float;     // estimated quantum error rate
    fidelity      : Float;     // fidelity with target pure state
    beatNum       : Nat;
    cohHistory    : [Float];
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: MATH HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  func _exp(x : Float) : Float { Float.exp(_clamp(x, -100.0, 100.0)) };
  func _ln(x : Float) : Float { if (x <= 0.0) -100.0 else Float.log(x) };
  func _sin(x : Float) : Float { Float.sin(x) };
  func _cos(x : Float) : Float { Float.cos(x) };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: QUBIT DENSITY MATRIX OPERATIONS
  // ══════════════════════════════════════════════════════════════════════════

  // Build qubit from populations and coherences
  public func buildQubit(rho00 : Float, reCoh : Float, imCoh : Float) : QubitState {
    let a = _clamp(rho00, 0.0, 1.0);
    let b = reCoh;
    let c = imCoh;
    // Ensure physical: b²+c² ≤ a(1-a)
    let cohNorm = _sqrt(b * b + c * c);
    let maxCoh  = _sqrt(a * (1.0 - a));
    let (bNorm, cNorm) = if (cohNorm > maxCoh + EPSILON) {
      (b * maxCoh / (cohNorm + EPSILON), c * maxCoh / (cohNorm + EPSILON))
    } else { (b, c) };

    let purity = a*a + (1.0-a)*(1.0-a) + 2.0*(bNorm*bNorm + cNorm*cNorm);
    let bX = 2.0 * bNorm;
    let bY = 2.0 * cNorm;
    let bZ = 2.0 * a - 1.0;
    let bR = _sqrt(bX*bX + bY*bY + bZ*bZ);

    {
      rho00=a; rho11=1.0-a; reRho01=bNorm; imRho01=cNorm;
      purity=_clamp(purity,0.5,1.0); blochX=bX; blochY=bY; blochZ=bZ;
      blochR=_clamp(bR,0.0,1.0);
    }
  };

  // Von Neumann entropy of qubit: S = -λ₊log₂(λ₊) - λ₋log₂(λ₋)
  // Eigenvalues: λ± = (1 ± |r|) / 2
  public func qubitVonNeumann(q : QubitState) : Float {
    let lPlus  = (1.0 + q.blochR) / 2.0;
    let lMinus = (1.0 - q.blochR) / 2.0;
    var s : Float = 0.0;
    if (lPlus > EPSILON)  { s -= lPlus  * _ln(lPlus)  / _ln(2.0) };
    if (lMinus > EPSILON) { s -= lMinus * _ln(lMinus) / _ln(2.0) };
    _clamp(s, 0.0, 1.0)
  };

  // Fidelity between two qubit states: F = (Tr√(√ρ σ √ρ))²
  // For pure states: F = |⟨ψ|φ⟩|² = (1 + r₁·r₂) / 2
  public func qubitFidelity(q1 : QubitState, q2 : QubitState) : Float {
    let blochDot = q1.blochX*q2.blochX + q1.blochY*q2.blochY + q1.blochZ*q2.blochZ;
    _clamp((1.0 + blochDot) / 2.0, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: QUANTUM GATE OPERATIONS
  // All gates: apply to Bloch vector (simpler than full matrix)
  // ══════════════════════════════════════════════════════════════════════════

  // Hadamard: (X, Y, Z) → (Z, -Y, X) on Bloch sphere
  public func hadamard(q : QubitState) : QubitState {
    buildQubit((q.blochZ + 1.0) / 2.0, q.blochX / 2.0, -q.blochY / 2.0)
  };

  // Pauli X (bit flip): (X, Y, Z) → (X, -Y, -Z)
  public func pauliX(q : QubitState) : QubitState {
    buildQubit((1.0 - q.blochZ) / 2.0, q.reRho01, -q.imRho01)
  };

  // Pauli Z (phase flip): (X, Y, Z) → (-X, -Y, Z)
  public func pauliZ(q : QubitState) : QubitState {
    buildQubit(q.rho00, -q.reRho01, -q.imRho01)
  };

  // Rotation around Z axis by angle θ: Rz(θ)|ψ⟩ = e^{-iθσz/2}|ψ⟩
  // Effect on Bloch: (X,Y,Z) → (X cosθ - Y sinθ, X sinθ + Y cosθ, Z)
  public func rotateZ(q : QubitState, theta : Float) : QubitState {
    let newX = q.blochX * _cos(theta) - q.blochY * _sin(theta);
    let newY = q.blochX * _sin(theta) + q.blochY * _cos(theta);
    buildQubit((q.blochZ + 1.0) / 2.0, newX / 2.0, newY / 2.0)
  };

  // Rotation around X axis: Rx(θ)
  // Effect: (X,Y,Z) → (X, Y cosθ - Z sinθ, Y sinθ + Z cosθ)
  public func rotateX(q : QubitState, theta : Float) : QubitState {
    let newY = q.blochY * _cos(theta) - q.blochZ * _sin(theta);
    let newZ = q.blochY * _sin(theta) + q.blochZ * _cos(theta);
    buildQubit((newZ + 1.0) / 2.0, q.blochX / 2.0, newY / 2.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: DECOHERENCE
  // Amplitude damping (T₁): rho00 → 1, rho01 → 0
  // Phase damping (T₂): rho01 → 0 (faster)
  // ══════════════════════════════════════════════════════════════════════════

  // Apply amplitude damping for time dt
  // ρ₀₀(t) = 1 - (1-ρ₀₀(0))e^{-t/T₁}
  // ρ₀₁(t) = ρ₀₁(0) e^{-t/(2T₁)}
  public func amplitudeDamping(q : QubitState, dt : Float) : QubitState {
    let decay = _exp(-dt / T1_DECAY_BEATS);
    let newRho00 = 1.0 - (1.0 - q.rho00) * decay;
    let cohDecay = _exp(-dt / (2.0 * T1_DECAY_BEATS));
    let newReC = q.reRho01 * cohDecay;
    let newImC = q.imRho01 * cohDecay;
    buildQubit(newRho00, newReC, newImC)
  };

  // Apply phase damping for time dt
  // ρ₀₁(t) = ρ₀₁(0) e^{-t/T₂}
  public func phaseDamping(q : QubitState, dt : Float) : QubitState {
    let decay = _exp(-dt / T2_DEPHASING);
    buildQubit(q.rho00, q.reRho01 * decay, q.imRho01 * decay)
  };

  // Combined decoherence (amplitude + phase)
  public func decohere(q : QubitState, dt : Float) : QubitState {
    phaseDamping(amplitudeDamping(q, dt), dt)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: ENTANGLEMENT MEASURES
  // Concurrence C = max(0, λ₁-λ₂-λ₃-λ₄)
  // Simplified: use Schmidt decomposition for separability
  // ══════════════════════════════════════════════════════════════════════════

  // Approximate concurrence from two-qubit state
  // For product states: C = 0
  // For Bell states: C = 1
  // Estimate: C ≈ 2 |reCouple| where reCouple is off-diagonal coupling
  public func estimateConcurrence(rhoOffDiag : Float, rho00 : Float) : Float {
    let rawC = 2.0 * _abs(rhoOffDiag) - _abs(2.0 * rho00 - 1.0);
    _clamp(rawC, 0.0, 1.0)
  };

  // Binary entropy h(p) = -p log₂(p) - (1-p) log₂(1-p)
  public func binaryEntropy(p : Float) : Float {
    let pc = _clamp(p, EPSILON, 1.0 - EPSILON);
    let q  = 1.0 - pc;
    -pc * (_ln(pc) / _ln(2.0)) - q * (_ln(q) / _ln(2.0))
  };

  // Entanglement entropy: E = h((1 + sqrt(1-C²))/2)
  public func entanglementEntropy(concurrence : Float) : Float {
    let C = _clamp(concurrence, 0.0, 1.0);
    let lambda = (1.0 + _sqrt(1.0 - C * C)) / 2.0;
    binaryEntropy(lambda)
  };

  // Identify nearest Bell state from two qubit Bloch vectors
  public func nearestBellState(q1 : QubitState, q2 : QubitState, concurrence : Float) : BellState {
    if (concurrence < 0.3) { return #Separable };
    let dot = q1.blochZ * q2.blochZ;
    if (dot > 0.5) { #PhiPlus }
    else if (dot < -0.5) { #PhiMinus }
    else if (q1.blochX * q2.blochX > 0.0) { #PsiPlus }
    else { #PsiMinus }
  };

  // Build two-qubit state from individual qubits
  public func buildTwoQubit(q1 : QubitState, q2 : QubitState, offDiagCoupling : Float) : TwoQubitState {
    let C = estimateConcurrence(offDiagCoupling, q1.rho00);
    let E = entanglementEntropy(C);
    let bell = nearestBellState(q1, q2, C);
    { q1=q1; q2=q2; concurrence=C; entanglementEntropy=E; bellState=bell }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: QUANTUM WALK
  // Position distribution after n steps of Hadamard walk
  // Simplified: model as ballistic spreading σ² ≈ n²/4
  // ══════════════════════════════════════════════════════════════════════════

  // Quantum walk probability at position x after n steps (Gaussian approximation)
  // True QW has interference fringes, but Gaussian envelope is correct for bulk
  public func qwProbability(x : Int, n : Nat) : Float {
    let xf = Float.fromInt(x);
    let nf = Float.fromInt(n);
    if (n == 0) {
      return if (x == 0) 1.0 else 0.0
    };
    // Ballistic: σ ≈ n/√2
    let sigma = nf / SQRT2;
    let gaussEnv = Float.exp(-(xf * xf) / (2.0 * sigma * sigma)) / (sigma * SQRT2 * _sqrt(2.0 * PI));
    // Add quantum interference peaks near ±n/√2
    let peak1 = nf / SQRT2;
    let interf = Float.exp(-((xf - peak1) * (xf - peak1)) / (0.5 * sigma)) +
                 Float.exp(-((xf + peak1) * (xf + peak1)) / (0.5 * sigma));
    _clamp(gaussEnv * 2.0 + interf * 0.3, 0.0, 1.0)
  };

  // Update quantum walk state by one step
  public func qwStep(walk : QuantumWalk) : QuantumWalk {
    let n = walk.step + 1;
    let nf = Float.fromInt(n);
    let midpoint = QW_N_POSITIONS / 2;
    let newProbs = Array.tabulate<Float>(QW_N_POSITIONS, func(pos) {
      let x = Int.fromNat(pos) - Int.fromNat(midpoint);
      qwProbability(x, n)
    });
    // Normalize
    var total : Float = 0.0;
    for (p in newProbs.vals()) { total += p };
    let normProbs = if (total < EPSILON) newProbs
                    else Array.map<Float,Float>(newProbs, func(p) { p / total });

    // Compute mean and variance
    var mean : Float = 0.0;
    var meanSq : Float = 0.0;
    var i : Nat = 0;
    while (i < normProbs.size()) {
      let x = Float.fromInt(i) - Float.fromInt(midpoint);
      mean   += x * normProbs[i];
      meanSq += x * x * normProbs[i];
      i += 1;
    };
    let variance = meanSq - mean * mean;

    {
      probabilities = normProbs;
      meanPosition  = mean;
      variance      = variance;
      step          = n;
      isBallisticS  = variance > nf * nf / 4.0;  // ballistic if σ² > n²/4
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: MEDINA QUANTUM COHERENCE INDEX
  // Q_coh = S₀ × [bloch_purity × Φ_M + entanglement_E] / Ω
  // ══════════════════════════════════════════════════════════════════════════

  public func quantumCoherenceIndex(blochR : Float, entanglementE : Float) : Float {
    let idx = S0 * (blochR * PHI_MEDINA + entanglementE) / SOVEREIGN_CEILING;
    _clamp(idx, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: QUANTUM MEASUREMENT
  // P(|0⟩) = ρ₀₀ = rho00, P(|1⟩) = ρ₁₁ = 1 - rho00
  // Weak measurement: partial collapse
  // ══════════════════════════════════════════════════════════════════════════

  // Measure in Z basis: returns 0 with prob ρ₀₀, 1 with prob ρ₁₁
  // After measurement: state collapses
  public func measureZ(q : QubitState, randomU : Float) : (Nat, QubitState) {
    if (randomU < q.rho00) {
      // Measured |0⟩
      (0, buildQubit(1.0, 0.0, 0.0))
    } else {
      // Measured |1⟩
      (1, buildQubit(0.0, 0.0, 0.0))
    }
  };

  // Weak measurement: partial collapse parameter ε
  // ρ' = (1-ε)ρ + ε|0⟩⟨0|  (for |0⟩ outcome)
  public func weakMeasure(q : QubitState, epsilon : Float) : QubitState {
    let eps = _clamp(epsilon, 0.0, 1.0);
    let newRho00 = (1.0 - eps) * q.rho00 + eps;  // shift toward |0⟩
    let newReC   = (1.0 - eps) * q.reRho01;
    let newImC   = (1.0 - eps) * q.imRho01;
    buildQubit(newRho00, newReC, newImC)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  public func beatQuantumOps(
    state          : QuantumOpsState,
    applyHadamard  : Bool,
    rotTheta       : Float,
    dt             : Float,
    coupling       : Float,     // inter-qubit coupling
    weakMeasEps    : Float      // weak measurement strength
  ) : QuantumOpsState {
    // Apply gate
    var newQ = state.qubit;
    if (applyHadamard) { newQ := hadamard(newQ) };
    if (_abs(rotTheta) > EPSILON) { newQ := rotateZ(newQ, rotTheta) };

    // Weak measurement (organism's continuous self-observation)
    newQ := weakMeasure(newQ, weakMeasEps);

    // Decoherence
    newQ := decohere(newQ, dt);

    // Two-qubit entanglement update
    let newTQ = buildTwoQubit(newQ, state.twoQubit.q2, coupling);

    // Quantum walk step
    let newWalk = qwStep(state.walk);

    // Metrics
    let vnS   = qubitVonNeumann(newQ);
    let qIdx  = quantumCoherenceIndex(newQ.blochR, newTQ.entanglementEntropy);
    let fid   = qubitFidelity(newQ, buildQubit(1.0, 0.0, 0.0));  // fidelity with |0⟩
    let errR  = 1.0 - fid;

    let newCohH = _appendRolling(state.cohHistory, newQ.blochR, HIST_MAX);

    {
      qubit        = newQ;
      twoQubit     = newTQ;
      walk         = newWalk;
      vonNeumannS  = vnS;
      quantumIndex = qIdx;
      decohBeats   = state.decohBeats + 1;
      errorRate    = errR;
      fidelity     = fid;
      beatNum      = state.beatNum + 1;
      cohHistory   = newCohH;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 12: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  public func initQuantumOps() : QuantumOpsState {
    // Start in pure |+⟩ state (Hadamard of |0⟩): Bloch vector (1,0,0)
    let initQ = buildQubit(0.5, 0.5, 0.0);  // |+⟩ state
    let initTQ = buildTwoQubit(initQ, initQ, 0.0);

    let initWalk : QuantumWalk = {
      probabilities = Array.tabulate<Float>(QW_N_POSITIONS, func(i) {
        if (i == QW_N_POSITIONS / 2) 1.0 else 0.0  // start at origin
      });
      meanPosition  = 0.0;
      variance      = 0.0;
      step          = 0;
      isBallisticS  = false;
    };

    {
      qubit        = initQ;
      twoQubit     = initTQ;
      walk         = initWalk;
      vonNeumannS  = qubitVonNeumann(initQ);
      quantumIndex = quantumCoherenceIndex(initQ.blochR, 0.0);
      decohBeats   = 0;
      errorRate    = 0.0;
      fidelity     = 1.0;
      beatNum      = 0;
      cohHistory   = [];
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

}
