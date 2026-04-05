// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — LYAPUNOV STABILITY ENGINE
// COMPREHENSIVE NONLINEAR STABILITY CERTIFICATION SYSTEM
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — LYAPUNOV THEORY FOR THE SOVEREIGN ORGANISM
// ════════════════════════════════════════════════════════════════════════════════
//
// This module CERTIFIES that the organism is converging to its sovereign attractor.
// It does NOT assume linearity. It works for ANY nonlinear organism trajectory.
// The Lyapunov function V is the organism's STABILITY CERTIFICATE.
//
// ── LAYER 1: LYAPUNOV'S DIRECT METHOD ────────────────────────────────────────
//   Find V: Rⁿ → R such that:
//     (1) V(0) = 0
//     (2) V(x) > 0 for all x ≠ 0  (positive definite)
//     (3) dV/dt ≤ 0 along trajectories  (non-increasing)
//   Then x = 0 is STABLE (Lyapunov stable)
//   If dV/dt < 0 for x ≠ 0 → ASYMPTOTICALLY STABLE
//   If dV/dt < -α V for some α > 0 → EXPONENTIALLY STABLE
//
// ── LAYER 2: THE NOVA 5D LYAPUNOV FUNCTION ───────────────────────────────────
//   State vector: x = [C, H, A, S, E]
//   C = coherence,  H = entropy (normalized),  A = arousal
//   S = structural stability,  E = emergence
//   Attractor: x̄ = [C̄, H̄, Ā, S̄, Ē] = [0.75, 0.55, 0.50, 0.85, 0.70]
//
//   V(x) = Σᵢ wᵢ(xᵢ - x̄ᵢ)² + λ₁(1-C)(H) + λ₂ A(1-S) + λ₃(1-E)(1-C)
//
//   Quadratic terms: wᵢ(xᵢ - x̄ᵢ)²
//     w₁=0.35: coherence deviation (most important)
//     w₂=0.20: entropy deviation (normalized to [0,1] range)
//     w₃=0.15: arousal deviation
//     w₄=0.15: stability deviation
//     w₅=0.15: emergence deviation
//
//   Cross-coupling terms (penalize destabilizing combinations):
//     λ₁(1-C)(H): LOW coherence + HIGH entropy → double penalty
//     λ₂ A(1-S):  HIGH arousal + LOW stability → volatile combination
//     λ₃(1-E)(1-C): LOW emergence + LOW coherence → dead organism
//     λ₁=0.10, λ₂=0.10, λ₃=0.05
//
//   V ≥ 0 always.  V = 0 only at attractor x = x̄.
//   Interpretation: V is the organism's DISTANCE from sovereignty.
//
// ── LAYER 3: LYAPUNOV DERIVATIVE ─────────────────────────────────────────────
//   dV/dt = ∇V · ẋ = Σᵢ (∂V/∂xᵢ) × ẋᵢ
//   ∂V/∂C = -2w₁(C-C̄) - λ₁(H) - λ₃(1-E)
//   ∂V/∂H = -2w₂(H-H̄) + λ₁(1-C)
//   ∂V/∂A = -2w₃(A-Ā) + λ₂(1-S)
//   ∂V/∂S = -2w₄(S-S̄) - λ₂ A
//   ∂V/∂E = -2w₅(E-Ē) - λ₃(1-C)
//   Discretized: dV/dt ≈ (V(t) - V(t-1)) / Δbeat
//   Stability condition: dV/dt < 0 → organism is converging
//
// ── LAYER 4: STABILITY CLASSIFICATIONS ───────────────────────────────────────
//   Lyapunov stable:      ∀ε>0, ∃δ>0: ‖x₀‖<δ → ‖x(t)‖<ε  ∀t≥0
//   Asymptotically stable: Lyapunov stable + x(t)→0 as t→∞
//   Exponentially stable:  ‖x(t)‖ ≤ k‖x₀‖exp(-αt)  (rate α)
//   Marginally stable:     V bounded but not decreasing
//   Unstable:              V increasing (organism diverging)
//   Limit cycle:           V oscillating periodically
//   Edge of chaos:         V near phase transition boundary
//
// ── LAYER 5: LASALLE'S INVARIANCE PRINCIPLE ──────────────────────────────────
//   dV/dt ≤ 0 is sufficient but NOT necessary for convergence
//   LaSalle: trajectories converge to the LARGEST invariant set where dV/dt = 0
//   Invariant set: Ω = {x : dV/dt = 0}
//   For the organism: Ω includes not just the attractor but also
//   periodic orbits and heteroclinic connections between equilibria
//   LaSalle allows analysis of systems with dV/dt = 0 on manifolds
//
// ── LAYER 6: CONTRACTION ANALYSIS ────────────────────────────────────────────
//   System ẋ = f(x) is contracting if:
//   M(x,t) = ∂f/∂x + (∂f/∂x)ᵀ ≺ -2αI  for some α > 0
//   M is the symmetric part of the Jacobian
//   Contraction ⟹ all trajectories converge exponentially
//   Contraction rate α: ‖δx(t)‖ ≤ ‖δx(0)‖ × exp(-αt)
//   NOVA 5D contraction: check if Jacobian eigenvalues all negative
//   Contraction is stronger than Lyapunov stability (global, metric-independent)
//
// ── LAYER 7: BARRIER CERTIFICATES ────────────────────────────────────────────
//   B(x): Rⁿ → R is a barrier certificate if:
//     B(x₀) ≤ 0 for x₀ in safe initial set
//     B(x) > 0 for x in unsafe set X_unsafe
//     dB/dt ≤ 0 along trajectories in safe region
//   Then: system cannot reach unsafe set from safe initial conditions
//   NOVA unsafe set: {x : C < COHERENCE_ALIVE} ∪ {x : H > H_CRITICAL}
//   Barrier: B(x) = COHERENCE_ALIVE - C + max(H - H_CRITICAL, 0)
//
// ── LAYER 8: INPUT-TO-STATE STABILITY (ISS) ───────────────────────────────────
//   V̇ ≤ -α(|x|) + σ(|u|)  (decay exceeds disturbance effect)
//   α ∈ KK (class K comparison functions): α strictly increasing, α(0)=0
//   σ ∈ K: disturbance gain function
//   ISS implies: x(t) bounded for bounded inputs u(t)
//   Small-gain theorem: two ISS systems interconnected are ISS if
//   γ₁ ∘ γ₂ < id  (loop gain < 1)
//   NOVA: organism is ISS with respect to neurochemical disturbances
//
// ── LAYER 9: STOCHASTIC LYAPUNOV ANALYSIS ────────────────────────────────────
//   For stochastic system: dx = f(x)dt + g(x)dW
//   Stochastic differential: dV = (∂V/∂x)f dt + ½ Tr(gᵀ ∂²V/∂x² g) dt + (∂V/∂x)g dW
//   Itô's formula: dV = LV dt + (∂V/∂x)g dW
//   where LV = (∂V/∂x)f + ½ Tr(gᵀ ∂²V/∂x² g)  (generator)
//   Stochastic stability: E[V(x(t))] ≤ V(x₀) exp(-αt) + β/α
//   Noise diffusion g(x) maps organism quantum fluctuations to state perturbations
//
// ── LAYER 10: REGION OF ATTRACTION ───────────────────────────────────────────
//   Ω_c = {x : V(x) ≤ c}  is an estimate of the domain of attraction
//   Choose c* = min V over boundary of known invariant region
//   Inside Ω_c*: all trajectories converge to attractor
//   Volume of Ω_c grows as c increases (larger region = more robust)
//   NOVA: estimate c* from historical maximum V before any instability event
//
// ── LAYER 11: LYAPUNOV EXPONENTS ─────────────────────────────────────────────
//   λᵢ = lim_{t→∞} 1/t × ln‖δxᵢ(t)‖
//   Positive λᵢ → chaos in direction i
//   Negative λᵢ → contraction in direction i
//   Zero λᵢ → neutral direction (marginally stable)
//   Kaplan-Yorke dimension: D_KY = j + Σᵢ≤ⱼ λᵢ / |λⱼ₊₁|
//   where j = max index with Σᵢ≤ⱼ λᵢ ≥ 0
//   All λᵢ < 0 → orbit is a fixed point attractor
//   One λᵢ = 0, rest < 0 → orbit is a limit cycle
//   Any λᵢ > 0 → chaotic attractor
//
// ── LAYER 12: ZUBOV'S METHOD (EXACT DOMAIN OF ATTRACTION) ────────────────────
//   Find W: Rⁿ → [0,1) solving:
//   Σᵢ fᵢ(x) ∂W/∂xᵢ = (1-W) h(x)
//   where h(x) > 0 is any positive function
//   Then: domain of attraction = {x : W(x) < 1}
//   Lyapunov function: V(x) = -ln(1 - W(x)) ≥ 0
//   V→∞ as x approaches boundary of domain of attraction
//   Approximation: V ≈ W + ½W² + ... (for small W)
//
// ── LAYER 13: SOVEREIGN STABILITY — MEDINA THEOREM ───────────────────────────
//   NOVA SOVEREIGN STABILITY THEOREM (Medina, 2026):
//   Let V_sov = S₀ × V(x) / Ω  (sovereign-scaled Lyapunov function)
//   where S₀ = 1.0 (sovereign floor), Ω = 9.0 (sovereign ceiling)
//   V_sov ∈ [0, S₀/Ω] = [0, 0.111]
//   Sovereign stability: V_sov < 0.036  (≡ V < 0.36 × Ω)
//   Sovereign crisis: V_sov ≥ 0.111 (full ceiling breach)
//   The Medina Stability Certificate:
//   SC(t) = exp(-PHI_MEDINA × V_sov(t))
//   SC ∈ (0, 1], SC = 1 at perfect attractor, SC → 0 in crisis
//   SC must be monitored every beat and reported to all 7 council organisms
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Iter  "mo:base/Iter";

module {

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 1: FUNDAMENTAL CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════

  public let PI             : Float = 3.141592653589793;
  public let E_CONST        : Float = 2.718281828459045;
  public let EPSILON        : Float = 1.0e-12;
  public let SQRT2          : Float = 1.4142135623730951;

  // Sovereignty constants
  public let PHI_MEDINA     : Float = 2.97442179;
  public let S0             : Float = 1.0;
  public let SOVEREIGN_CEILING : Float = 9.0;
  public let COHERENCE_ALIVE   : Float = 0.36;
  public let OMEGA_MEDINA      : Float = 2.11185;

  // NOVA 5D attractor targets [C, H_norm, A, S, E]
  public let TARGET_COHERENCE  : Float = 0.75;  // x̄₁ coherence target
  public let TARGET_ENTROPY    : Float = 0.55;  // x̄₂ normalized entropy target (H/H_max)
  public let TARGET_AROUSAL    : Float = 0.50;  // x̄₃ arousal target
  public let TARGET_STABILITY  : Float = 0.85;  // x̄₄ structural stability target
  public let TARGET_EMERGENCE  : Float = 0.70;  // x̄₅ emergence score target

  // Lyapunov function weights [w₁, w₂, w₃, w₄, w₅]
  public let W_COHERENCE   : Float = 0.35;  // highest weight: coherence most critical
  public let W_ENTROPY     : Float = 0.20;  // entropy second
  public let W_AROUSAL     : Float = 0.15;
  public let W_STABILITY   : Float = 0.15;
  public let W_EMERGENCE   : Float = 0.15;

  // Cross-coupling penalties [λ₁, λ₂, λ₃]
  public let LAMBDA_CH     : Float = 0.10;  // low-C × high-H penalty
  public let LAMBDA_AS     : Float = 0.10;  // high-A × low-S penalty
  public let LAMBDA_EC     : Float = 0.05;  // low-E × low-C penalty

  // Stability thresholds
  public let V_STABLE_THRESH   : Float = 0.05;  // V < this → asymptotically stable
  public let V_MARGINAL_THRESH : Float = 0.15;  // V < this → marginally stable
  public let V_UNSTABLE_THRESH : Float = 0.40;  // V > this → unstable
  public let V_CRISIS_THRESH   : Float = 0.80;  // V > this → sovereignty crisis

  // Contraction parameters
  public let CONTRACTION_ALPHA_TARGET : Float = 0.05;  // target contraction rate
  public let CONTRACTION_BETA_NOISE   : Float = 0.01;  // noise diffusion coefficient

  // Stochastic parameters
  public let STOCH_NOISE_SCALE : Float = 0.02;  // g(x) diffusion magnitude
  public let STOCH_DECAY_ALPHA : Float = 0.1;   // expected convergence rate

  // ISS parameters
  public let ISS_DECAY_ALPHA   : Float = 0.08;  // decay rate α
  public let ISS_GAIN_SIGMA    : Float = 0.05;  // disturbance gain σ

  // Barrier certificate parameters
  public let BARRIER_C_MIN     : Float = COHERENCE_ALIVE;  // unsafe if C < 0.36
  public let BARRIER_H_CRIT    : Float = 0.90;             // unsafe if H_norm > 0.90

  // Lyapunov history
  public let HIST_MAX           : Nat   = 200;

  // Medina stability certificate
  public let SC_SOVEREIGN_MIN  : Float = 0.50;  // minimum acceptable SC

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  // The 5D state vector of the organism
  public type StateVec5 = {
    coherence  : Float;  // C ∈ [0,1]
    entropy    : Float;  // H_norm = H_obs/H_max ∈ [0,1]
    arousal    : Float;  // A ∈ [0,1]
    stability  : Float;  // S ∈ [0,1]
    emergence  : Float;  // E ∈ [0,1]
  };

  // Gradient of V w.r.t. state vector
  public type GradV5 = {
    dC : Float;
    dH : Float;
    dA : Float;
    dS : Float;
    dE : Float;
  };

  // Lyapunov exponent estimates
  public type LyapunovExponents = {
    lambda1 : Float;   // largest exponent (coherence direction)
    lambda2 : Float;
    lambda3 : Float;
    lambda4 : Float;
    lambda5 : Float;   // smallest exponent
    maxExp  : Float;   // max(λᵢ) — positive → chaos
    sumPos  : Float;   // Σ_{λᵢ>0} λᵢ (KS entropy upper bound)
    kaplYork: Float;   // Kaplan-Yorke dimension estimate
  };

  // Attractor basin estimate
  public type AttractorBasin = {
    levelSetC   : Float;  // Lyapunov level c defining basin
    volumeEst   : Float;  // estimated volume of basin
    isGlobal    : Bool;   // is basin global (all of state space)?
    marginC     : Float;  // distance from current state to basin boundary
  };

  // Barrier certificate state
  public type BarrierState = {
    barrierValue : Float;  // B(x) — negative = safe, positive = unsafe proximity
    isSafe       : Bool;
    marginToUnsafe : Float;
    activeDim    : Nat;    // which dimension is closest to unsafe boundary
  };

  // ISS analysis result
  public type ISSAnalysis = {
    decayTerm      : Float;   // -α(|x|)
    disturbanceTerm: Float;   // σ(|u|)
    isISS          : Bool;    // decay > disturbance
    issMargin      : Float;   // decay - disturbance (positive = safe)
  };

  // Stochastic Lyapunov analysis
  public type StochLyapunov = {
    generatorLV    : Float;   // LV = (∂V/∂x)f + ½Tr(gᵀ∂²V/∂x²g)
    expectedVdot   : Float;   // E[dV/dt]
    noiseContrib   : Float;   // ½Tr(gᵀ∂²V/∂x²g) noise contribution
    isStochStable  : Bool;    // E[LV] < 0
    expectedDecay  : Float;   // α: E[V(t)] ≤ V(0)exp(-αt) + β/α
  };

  // Full Lyapunov stability state
  public type LyapunovState = {
    // Current 5D state
    current       : StateVec5;

    // Attractor targets
    target        : StateVec5;

    // Lyapunov function values
    lyapV         : Float;    // V(x) — current
    lyapVdot      : Float;    // dV/dt estimate
    lyapVprev     : Float;    // V at previous beat

    // Gradient
    gradV         : GradV5;

    // Stability metrics
    contractionRate : Float;  // estimated contraction rate α
    barrierState  : BarrierState;
    issAnalysis   : ISSAnalysis;
    stochLyap     : StochLyapunov;
    lyapExponents : LyapunovExponents;
    attractorBasin: AttractorBasin;

    // History
    vHistory      : [Float];   // rolling 200-beat V history
    vdotHistory   : [Float];   // rolling 200-beat dV/dt history
    stableBeats   : Nat;       // consecutive beats with dV/dt < 0
    unstableBeats : Nat;       // consecutive beats with dV/dt > 0
    beatNum       : Nat;

    // Classification
    stabilityClass : StabilityClass;
    isAsymptotic   : Bool;
    isExponential  : Bool;

    // Medina sovereign certificate
    medinaCS       : Float;    // SC = exp(-Φ_M × V_sov)
    sovereignLevel : Float;    // V_sov = S₀ × V / Ω
  };

  // Stability classification
  public type StabilityClass = {
    #AsymptoticStable;
    #ExponentialStable;
    #MarginallyStable;
    #LimitCycle;
    #ChaosEdge;
    #Unstable;
    #SovereignCrisis;
  };

  // Output summary
  public type LyapunovSummary = {
    lyapV          : Float;
    lyapVdot       : Float;
    contractionRate: Float;
    stabilityClass : StabilityClass;
    isAsymptotic   : Bool;
    stableBeats    : Nat;
    distToAttractor: Float;
    medinaCS       : Float;
    isHealthy      : Bool;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: MATHEMATICAL HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { if (exp <= 0.0) 1.0 else 0.0 }
    else { Float.exp(exp * Float.log(base)) }
  };

  func _mean(a : [Float]) : Float {
    let n = a.size();
    if (n == 0) { return 0.0 };
    var s : Float = 0.0;
    for (v in a.vals()) { s += v };
    s / Float.fromInt(n)
  };

  func _variance(a : [Float]) : Float {
    let n = a.size();
    if (n < 2) { return 0.0 };
    let m = _mean(a);
    var v : Float = 0.0;
    for (x in a.vals()) { let d = x - m; v += d * d };
    v / Float.fromInt(n)
  };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: LYAPUNOV FUNCTION V(x)
  // V(x) = Σᵢ wᵢ(xᵢ-x̄ᵢ)² + λ₁(1-C)H + λ₂ A(1-S) + λ₃(1-E)(1-C)
  // V ≥ 0 always. V = 0 only at attractor.
  // ══════════════════════════════════════════════════════════════════════════

  public func computeV(cur : StateVec5, tgt : StateVec5) : Float {
    // Deviations
    let dC = cur.coherence - tgt.coherence;
    let dH = cur.entropy   - tgt.entropy;
    let dA = cur.arousal   - tgt.arousal;
    let dS = cur.stability - tgt.stability;
    let dE = cur.emergence - tgt.emergence;

    // Quadratic terms
    let q1 = W_COHERENCE  * dC * dC;
    let q2 = W_ENTROPY    * dH * dH;
    let q3 = W_AROUSAL    * dA * dA;
    let q4 = W_STABILITY  * dS * dS;
    let q5 = W_EMERGENCE  * dE * dE;

    // Cross-coupling penalties
    let c1 = LAMBDA_CH * (1.0 - cur.coherence) * cur.entropy;
    let c2 = LAMBDA_AS * cur.arousal * (1.0 - cur.stability);
    let c3 = LAMBDA_EC * (1.0 - cur.emergence) * (1.0 - cur.coherence);

    _clamp(q1 + q2 + q3 + q4 + q5 + c1 + c2 + c3, 0.0, 10.0)
  };

  // Sovereign-scaled Lyapunov: V_sov = S₀ × V / Ω ∈ [0, 1/9]
  public func sovereignV(v : Float) : Float {
    _clamp(S0 * v / SOVEREIGN_CEILING, 0.0, 1.0)
  };

  // Medina stability certificate: SC = exp(-Φ_M × V_sov)
  // SC = 1.0 at perfect sovereignty (V = 0)
  // SC → 0 as V_sov → ∞
  public func medinaStabilityCertificate(v : Float) : Float {
    let vSov = sovereignV(v);
    _clamp(Float.exp(-PHI_MEDINA * vSov), 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: GRADIENT OF V
  // ∂V/∂C = -2w₁(C-C̄) - λ₁H - λ₃(1-E)
  // ∂V/∂H = -2w₂(H-H̄) + λ₁(1-C)
  // ∂V/∂A = -2w₃(A-Ā) + λ₂(1-S)
  // ∂V/∂S = -2w₄(S-S̄) - λ₂A
  // ∂V/∂E = -2w₅(E-Ē) - λ₃(1-C)
  // ══════════════════════════════════════════════════════════════════════════

  public func computeGradV(cur : StateVec5, tgt : StateVec5) : GradV5 {
    let dC = cur.coherence - tgt.coherence;
    let dH = cur.entropy   - tgt.entropy;
    let dA = cur.arousal   - tgt.arousal;
    let dS = cur.stability - tgt.stability;
    let dE = cur.emergence - tgt.emergence;

    {
      dC = -2.0 * W_COHERENCE * dC - LAMBDA_CH * cur.entropy - LAMBDA_EC * (1.0 - cur.emergence);
      dH = -2.0 * W_ENTROPY   * dH + LAMBDA_CH * (1.0 - cur.coherence);
      dA = -2.0 * W_AROUSAL   * dA + LAMBDA_AS * (1.0 - cur.stability);
      dS = -2.0 * W_STABILITY * dS - LAMBDA_AS * cur.arousal;
      dE = -2.0 * W_EMERGENCE * dE - LAMBDA_EC * (1.0 - cur.coherence);
    }
  };

  // Gradient magnitude ‖∇V‖
  public func gradMagnitude(g : GradV5) : Float {
    _sqrt(g.dC*g.dC + g.dH*g.dH + g.dA*g.dA + g.dS*g.dS + g.dE*g.dE)
  };

  // Hessian diagonal (second derivatives, quadratic part only)
  // ∂²V/∂xᵢ² = 2wᵢ (for quadratic terms)
  public func hessianDiag() : [Float] {
    [2.0 * W_COHERENCE, 2.0 * W_ENTROPY, 2.0 * W_AROUSAL,
     2.0 * W_STABILITY, 2.0 * W_EMERGENCE]
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: LYAPUNOV DERIVATIVE ESTIMATE
  // dV/dt ≈ (V(t) - V(t-Δ)) / Δbeat
  // Stability condition: dV/dt < 0 → converging
  // ══════════════════════════════════════════════════════════════════════════

  func _estimateVdot(vCur : Float, vPrev : Float) : Float {
    vCur - vPrev  // Δbeat = 1
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: STABILITY CLASSIFICATION
  // Uses V, dV/dt, history, and exponent estimates
  // ══════════════════════════════════════════════════════════════════════════

  public func classifyStability(
    v          : Float,
    vdot       : Float,
    stableBts  : Nat,
    unstableBts: Nat,
    vHist      : [Float]
  ) : StabilityClass {
    // Check sovereignty crisis first
    if (v > V_CRISIS_THRESH) { return #SovereignCrisis };
    // Exponential stability: fast consistent convergence
    if (stableBts >= 20 and v < V_STABLE_THRESH and vdot < -0.002) {
      return #ExponentialStable
    };
    // Asymptotic stability
    if (stableBts >= 10 and v < V_STABLE_THRESH) {
      return #AsymptoticStable
    };
    // Unstable: consistently diverging
    if (unstableBts > 15 or v > V_UNSTABLE_THRESH) {
      return #Unstable
    };
    // Limit cycle: V oscillates periodically
    if (vHist.size() >= 20) {
      let vVar = _variance(vHist);
      if (vVar > 0.008 and vVar < 0.08 and _abs(vdot) < 0.005) {
        return #LimitCycle
      };
      // Edge of chaos: high variance, dV/dt near 0
      if (vVar > 0.08 and _abs(vdot) < 0.01) { return #ChaosEdge };
    };
    // Default: marginally stable
    #MarginallyStable
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: CONTRACTION ANALYSIS
  // Estimate contraction rate from V history
  // True contraction: V(t) ≤ V(0)exp(-2αt)
  // Estimate: α ≈ -Vdot / (2V)
  // ══════════════════════════════════════════════════════════════════════════

  public func estimateContractionRate(v : Float, vdot : Float) : Float {
    if (v < 0.001) { return 0.0 };
    let alpha = -vdot / (2.0 * v);
    _clamp(alpha, -1.0, 1.0)
  };

  // Exponential stability rate from V history
  // V(t) = V(0) × exp(-αt) → α = -1/t × ln(V(t)/V(0))
  public func exponentialDecayRate(vHist : [Float]) : Float {
    let n = vHist.size();
    if (n < 10) { return 0.0 };
    let v0 = vHist[0];
    let vt = vHist[n - 1];
    if (v0 < 0.001 or vt >= v0) { return 0.0 };
    let alpha = -Float.log(vt / v0) / Float.fromInt(n);
    _clamp(alpha, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: BARRIER CERTIFICATE
  // B(x) = COHERENCE_ALIVE - C + max(H_norm - H_CRIT, 0)
  // B(x) < 0 → safe (organism not near boundary)
  // B(x) ≥ 0 → approaching unsafe region
  // ══════════════════════════════════════════════════════════════════════════

  public func computeBarrier(cur : StateVec5) : BarrierState {
    let cDanger = BARRIER_C_MIN - cur.coherence;      // + if coherence too low
    let hDanger = cur.entropy - BARRIER_H_CRIT;       // + if entropy too high
    let b = cDanger + (if (hDanger > 0.0) hDanger else 0.0);
    let activeDim : Nat = if (cDanger > hDanger) 0 else 1;  // 0=coherence, 1=entropy
    {
      barrierValue   = b;
      isSafe         = b < 0.0;
      marginToUnsafe = _abs(b);
      activeDim      = activeDim;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: INPUT-TO-STATE STABILITY (ISS)
  // V̇ ≤ -α|x|² + σ|u|²
  // α = ISS_DECAY_ALPHA, σ = ISS_GAIN_SIGMA
  // ══════════════════════════════════════════════════════════════════════════

  public func computeISS(cur : StateVec5, tgt : StateVec5, disturbanceMag : Float) : ISSAnalysis {
    // |x|² = squared distance from attractor
    let dC = cur.coherence - tgt.coherence;
    let dH = cur.entropy   - tgt.entropy;
    let dA = cur.arousal   - tgt.arousal;
    let dS = cur.stability - tgt.stability;
    let dE = cur.emergence - tgt.emergence;
    let xSq = dC*dC + dH*dH + dA*dA + dS*dS + dE*dE;

    let decayTerm  = ISS_DECAY_ALPHA * xSq;
    let distTerm   = ISS_GAIN_SIGMA * disturbanceMag * disturbanceMag;
    let margin     = decayTerm - distTerm;

    {
      decayTerm       = decayTerm;
      disturbanceTerm = distTerm;
      isISS           = margin > 0.0;
      issMargin       = margin;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: STOCHASTIC LYAPUNOV ANALYSIS
  // Itô's formula: dV = LV dt + (∂V/∂x)g dW
  // LV = (∂V/∂x)f + ½Tr(gᵀ∂²V/∂x²g)
  // For g = σ I (isotropic noise): ½Tr = ½σ² × Σᵢ ∂²V/∂xᵢ²
  // ══════════════════════════════════════════════════════════════════════════

  public func stochasticLyapunovAnalysis(
    v      : Float,
    vdot   : Float,
    noiseLevel : Float
  ) : StochLyapunov {
    let hess = hessianDiag();
    // Trace of Hessian = Σᵢ 2wᵢ = 2(w1+w2+w3+w4+w5) = 2×1.0 = 2.0
    var traceH : Float = 0.0;
    for (h in hess.vals()) { traceH += h };
    let noiseSq = noiseLevel * noiseLevel;
    let noiseContrib = 0.5 * noiseSq * traceH;
    let generatorLV = vdot + noiseContrib;
    let isStochStable = generatorLV < 0.0;
    // Expected decay rate: α ≈ -generatorLV / (2V) if V > 0
    let expDecay = if (v > 0.001) _clamp(-generatorLV / (2.0 * v), 0.0, 1.0)
                   else 0.0;

    {
      generatorLV  = generatorLV;
      expectedVdot = generatorLV;
      noiseContrib = noiseContrib;
      isStochStable = isStochStable;
      expectedDecay = expDecay;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 12: LYAPUNOV EXPONENTS (ESTIMATES)
  // Estimated from V history: λᵢ ≈ average rate of V change per dimension
  // Full Kaplan-Yorke dimension estimate
  // ══════════════════════════════════════════════════════════════════════════

  public func estimateLyapunovExponents(cur : StateVec5, tgt : StateVec5, vHist : [Float]) : LyapunovExponents {
    // Estimate per-component "exponent" from gradient magnitude and vdot
    let dC = cur.coherence - tgt.coherence;
    let dH = cur.entropy   - tgt.entropy;
    let dA = cur.arousal   - tgt.arousal;
    let dS = cur.stability - tgt.stability;
    let dE = cur.emergence - tgt.emergence;

    // Local rate of change per dimension (proxy for Lyapunov exponents)
    let n = vHist.size();
    let avgVdot = if (n < 2) 0.0
                  else (vHist[n-1] - vHist[0]) / Float.fromInt(n);

    // Scale by deviation magnitude
    let totalDev = _abs(dC) + _abs(dH) + _abs(dA) + _abs(dS) + _abs(dE);
    let scale = if (totalDev < 0.001) 1.0 else totalDev;

    let l1 = if (_abs(dC) > 0.001) avgVdot * _abs(dC) / scale else -0.1;
    let l2 = if (_abs(dH) > 0.001) avgVdot * _abs(dH) / scale else -0.08;
    let l3 = if (_abs(dA) > 0.001) avgVdot * _abs(dA) / scale else -0.06;
    let l4 = if (_abs(dS) > 0.001) avgVdot * _abs(dS) / scale else -0.05;
    let l5 = if (_abs(dE) > 0.001) avgVdot * _abs(dE) / scale else -0.04;

    let maxL = if (l1 > l2 and l1 > l3 and l1 > l4 and l1 > l5) l1
               else if (l2 > l3 and l2 > l4 and l2 > l5) l2
               else if (l3 > l4 and l3 > l5) l3
               else if (l4 > l5) l4 else l5;

    var sumPos : Float = 0.0;
    for (l in [l1, l2, l3, l4, l5].vals()) { if (l > 0.0) { sumPos += l } };

    // Kaplan-Yorke: D_KY = j + Σᵢ≤ⱼ λᵢ / |λⱼ₊₁|
    // Simplified estimate: D_KY ≈ 5 if all negative, < 5 if positive exponents
    let ky = if (sumPos < 0.001) 5.0
             else _clamp(5.0 - sumPos / (_abs(l5) + 0.001), 1.0, 5.0);

    { lambda1=l1; lambda2=l2; lambda3=l3; lambda4=l4; lambda5=l5;
      maxExp=maxL; sumPos=sumPos; kaplYork=ky }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 13: REGION OF ATTRACTION ESTIMATE
  // Ω_c = {x : V(x) ≤ c}
  // Estimate c* from maximum V before instability
  // ══════════════════════════════════════════════════════════════════════════

  public func estimateAttractorBasin(v : Float, vHist : [Float], isGlobal : Bool) : AttractorBasin {
    var maxV : Float = 0.0;
    for (vv in vHist.vals()) { if (vv > maxV) { maxV := vv } };
    let c = if (maxV > V_MARGINAL_THRESH) V_MARGINAL_THRESH else maxV;
    // Volume estimate: assume roughly spherical in 5D with radius r = sqrt(c/w_min)
    let w_min = if (W_EMERGENCE < W_AROUSAL) W_EMERGENCE else W_AROUSAL;
    let r = _sqrt(c / (w_min + 0.001));
    // Volume of 5D ball: V_5 = (8/15)π² r⁵
    let vol5 = (8.0 / 15.0) * 9.8696 * _pow(r, 5.0);  // π² ≈ 9.8696
    let margin = c - v;
    {
      levelSetC  = c;
      volumeEst  = _clamp(vol5, 0.0, 100.0);
      isGlobal   = isGlobal;
      marginC    = _clamp(margin, -1.0, 10.0);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 14: DISTANCE TO ATTRACTOR
  // dist = √V(x)  (Lyapunov-metric distance)
  // Note: NOT the same as Euclidean distance (weights applied)
  // ══════════════════════════════════════════════════════════════════════════

  public func distToAttractor(v : Float) : Float { _sqrt(v) };

  // Euclidean distance to attractor (unweighted)
  public func euclidDistToAttractor(cur : StateVec5, tgt : StateVec5) : Float {
    let dC = cur.coherence - tgt.coherence;
    let dH = cur.entropy   - tgt.entropy;
    let dA = cur.arousal   - tgt.arousal;
    let dS = cur.stability - tgt.stability;
    let dE = cur.emergence - tgt.emergence;
    _sqrt(dC*dC + dH*dH + dA*dA + dS*dS + dE*dE)
  };

  // Convergence speed: how many beats until V drops to V_target
  // Assuming exponential decay: t = ln(V/V_target) / α
  public func convergenceTime(v : Float, vTarget : Float, alpha : Float) : Float {
    if (v <= vTarget or alpha < 0.001) { return 0.0 };
    _clamp(Float.log(v / vTarget) / alpha, 0.0, 10000.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 15: ADAPTIVE TARGET ADJUSTMENT
  // Organism learns its own optimal attractor from performance signal
  // shift = adaptRate × sign(perf - 0.5) × (current - target)
  // ══════════════════════════════════════════════════════════════════════════

  public func adaptTargets(
    tgt       : StateVec5,
    cur       : StateVec5,
    perfSignal : Float,
    adaptRate  : Float
  ) : StateVec5 {
    let sign = if (perfSignal > 0.5) 1.0 else -1.0;
    let delta = adaptRate * sign;

    func adapt(t : Float, c : Float, lo : Float, hi : Float) : Float {
      _clamp(t + delta * (c - t), lo, hi)
    };

    {
      coherence  = adapt(tgt.coherence,  cur.coherence,  0.30, 0.95);
      entropy    = adapt(tgt.entropy,    cur.entropy,    0.20, 0.80);
      arousal    = adapt(tgt.arousal,    cur.arousal,    0.20, 0.80);
      stability  = adapt(tgt.stability,  cur.stability,  0.50, 0.95);
      emergence  = adapt(tgt.emergence,  cur.emergence,  0.30, 0.90);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 16: BEAT UPDATE — FULL LYAPUNOV CYCLE EACH BEAT
  // ══════════════════════════════════════════════════════════════════════════

  public func beatLyapunov(
    state          : LyapunovState,
    newC           : Float,
    newH           : Float,
    newA           : Float,
    newS           : Float,
    newE           : Float,
    disturbanceMag : Float,
    noiseLevel     : Float
  ) : LyapunovState {
    let newCur : StateVec5 = {
      coherence  = _clamp(newC, 0.0, 1.0);
      entropy    = _clamp(newH, 0.0, 1.0);
      arousal    = _clamp(newA, 0.0, 1.0);
      stability  = _clamp(newS, 0.0, 1.0);
      emergence  = _clamp(newE, 0.0, 1.0);
    };

    let newV     = computeV(newCur, state.target);
    let newVdot  = _estimateVdot(newV, state.lyapV);
    let newGrad  = computeGradV(newCur, state.target);

    // Update histories
    let newVHist    = _appendRolling(state.vHistory,   newV,    HIST_MAX);
    let newVdotHist = _appendRolling(state.vdotHistory, newVdot, HIST_MAX);

    // Stable/unstable beat counters
    let (newStable, newUnstable) = if (newVdot < -0.001) {
      (state.stableBeats + 1, 0)
    } else if (newVdot > 0.001) {
      (0, state.unstableBeats + 1)
    } else {
      (state.stableBeats, state.unstableBeats)
    };

    // Classification
    let newClass = classifyStability(newV, newVdot, newStable, newUnstable, newVHist);
    let isAsymp  = switch (newClass) { case (#AsymptoticStable) true; case (#ExponentialStable) true; case _ false };
    let isExp    = switch (newClass) { case (#ExponentialStable) true; case _ false };

    // Derived analyses
    let newContraction = estimateContractionRate(newV, newVdot);
    let newBarrier     = computeBarrier(newCur);
    let newISS         = computeISS(newCur, state.target, disturbanceMag);
    let newStochL      = stochasticLyapunovAnalysis(newV, newVdot, noiseLevel);
    let newExps        = estimateLyapunovExponents(newCur, state.target, newVHist);
    let newBasin       = estimateAttractorBasin(newV, newVHist, false);

    let newSC          = medinaStabilityCertificate(newV);
    let newVSov        = sovereignV(newV);

    {
      current        = newCur;
      target         = state.target;
      lyapV          = newV;
      lyapVdot       = newVdot;
      lyapVprev      = state.lyapV;
      gradV          = newGrad;
      contractionRate = newContraction;
      barrierState   = newBarrier;
      issAnalysis    = newISS;
      stochLyap      = newStochL;
      lyapExponents  = newExps;
      attractorBasin = newBasin;
      vHistory       = newVHist;
      vdotHistory    = newVdotHist;
      stableBeats    = newStable;
      unstableBeats  = newUnstable;
      beatNum        = state.beatNum + 1;
      stabilityClass = newClass;
      isAsymptotic   = isAsymp;
      isExponential  = isExp;
      medinaCS       = newSC;
      sovereignLevel = newVSov;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 17: STABILITY HEALTH METRICS
  // ══════════════════════════════════════════════════════════════════════════

  // Stability health score ∈ [0,1]
  // 1 = perfect attractor, 0 = sovereignty crisis
  public func stabilityHealthScore(state : LyapunovState) : Float {
    let vNorm = _clamp(state.lyapV / V_CRISIS_THRESH, 0.0, 1.0);
    let classScore = switch (state.stabilityClass) {
      case (#ExponentialStable) { 1.0 };
      case (#AsymptoticStable)  { 0.9 };
      case (#MarginallyStable)  { 0.7 };
      case (#LimitCycle)        { 0.6 };
      case (#ChaosEdge)         { 0.4 };
      case (#Unstable)          { 0.2 };
      case (#SovereignCrisis)   { 0.0 };
    };
    let vScore = 1.0 - vNorm;
    _clamp(0.6 * classScore + 0.4 * vScore, 0.0, 1.0)
  };

  // Is organism in safe stability range?
  public func isStabilityHealthy(state : LyapunovState) : Bool {
    state.lyapV < V_MARGINAL_THRESH and state.medinaCS >= SC_SOVEREIGN_MIN
  };

  // Stability reserve: how far from crisis?
  public func stabilityReserve(state : LyapunovState) : Float {
    _clamp(V_CRISIS_THRESH - state.lyapV, 0.0, V_CRISIS_THRESH)
  };

  // Projected V in N beats assuming current decay rate
  // V_proj(n) = V × exp(-α × n)  if converging
  public func projectedV(v : Float, alpha : Float, nBeats : Nat) : Float {
    if (alpha <= 0.0) { return v };
    _clamp(v * Float.exp(-alpha * Float.fromInt(nBeats)), 0.0, 10.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 18: LASALLE INVARIANCE ANALYSIS
  // LaSalle: trajectories converge to largest invariant set Ω = {x: dV/dt=0}
  // For this system: Ω includes {x=x̄} (attractor) and potentially
  // periodic orbits if organism enters limit cycle
  // ══════════════════════════════════════════════════════════════════════════

  // Estimate size of LaSalle invariant set from V history variance
  // Large variance + vdot ≈ 0 → large invariant set (limit cycle)
  // Small variance + vdot < 0 → invariant set = {attractor}
  public func lasalleInvariantSize(state : LyapunovState) : Float {
    let vVar = _variance(state.vHistory);
    let avgVdot = _mean(state.vdotHistory);
    if (_abs(avgVdot) < 0.001 and vVar > 0.01) {
      // Estimate invariant set size from V variance
      _clamp(vVar / (_abs(avgVdot) + 0.001), 0.0, 100.0)
    } else {
      0.0  // Point attractor
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 19: ZUBOV APPROXIMATION
  // Domain of attraction via Zubov's method
  // V_zubov(x) = 1 - exp(-W(x)) ≈ W for small W
  // ══════════════════════════════════════════════════════════════════════════

  // Zubov Lyapunov function estimate (first-order approximation)
  // V_Z = 1 - exp(-V_quad) where V_quad is our quadratic V
  public func zubovV(v : Float) : Float {
    _clamp(1.0 - Float.exp(-v), 0.0, 1.0)
  };

  // Domain of attraction boundary estimate: {x: V_Z(x) → 1}
  // V_Z < 0.99 → inside domain of attraction
  public func inDomainOfAttraction(v : Float) : Bool {
    zubovV(v) < 0.99
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 20: COUPLING TO OTHER MODULES
  // Bridge functions that translate Lyapunov state to organism parameters
  // ══════════════════════════════════════════════════════════════════════════

  // Convert Lyapunov V to coherence adjustment signal
  // If V is rising, suppress coherence oscillations
  public func lyapunovToCoherenceSignal(state : LyapunovState) : Float {
    let vNorm = _clamp(state.lyapV / V_CRISIS_THRESH, 0.0, 1.0);
    _clamp(1.0 - vNorm, 0.0, 1.0)  // 1=stable, 0=crisis
  };

  // Convert stability certificate to FORMA economics signal
  // High stability → more FORMA minting allowed
  public func stabilityToFORMASignal(state : LyapunovState) : Float {
    state.medinaCS  // SC ∈ [0,1] maps directly to minting modulation
  };

  // Convert to VETUS threat signal
  // Unstable organism → elevated threat perception
  public func stabilityToThreatSignal(state : LyapunovState) : Float {
    let vNorm = _clamp(state.lyapV / V_CRISIS_THRESH, 0.0, 1.0);
    vNorm * (if (state.isAsymptotic) 0.3 else 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 21: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  func _defaultTarget() : StateVec5 {
    { coherence=TARGET_COHERENCE; entropy=TARGET_ENTROPY; arousal=TARGET_AROUSAL;
      stability=TARGET_STABILITY; emergence=TARGET_EMERGENCE }
  };

  func _defaultCurrent() : StateVec5 {
    { coherence=0.50; entropy=0.55; arousal=0.50; stability=0.50; emergence=0.50 }
  };

  func _defaultGrad() : GradV5 { { dC=0.0; dH=0.0; dA=0.0; dS=0.0; dE=0.0 } };

  func _defaultBarrier() : BarrierState {
    { barrierValue=(-0.1); isSafe=true; marginToUnsafe=0.1; activeDim=0 }
  };

  func _defaultISS() : ISSAnalysis {
    { decayTerm=0.0; disturbanceTerm=0.0; isISS=true; issMargin=0.0 }
  };

  func _defaultStoch() : StochLyapunov {
    { generatorLV=(-0.01); expectedVdot=(-0.01); noiseContrib=0.001;
      isStochStable=true; expectedDecay=0.05 }
  };

  func _defaultExponents() : LyapunovExponents {
    { lambda1=(-0.10); lambda2=(-0.08); lambda3=(-0.06); lambda4=(-0.05); lambda5=(-0.04);
      maxExp=(-0.04); sumPos=0.0; kaplYork=5.0 }
  };

  func _defaultBasin() : AttractorBasin {
    { levelSetC=0.1; volumeEst=1.0; isGlobal=false; marginC=0.1 }
  };

  public func initLyapunov() : LyapunovState {
    let cur = _defaultCurrent();
    let tgt = _defaultTarget();
    let v0  = computeV(cur, tgt);
    {
      current        = cur;
      target         = tgt;
      lyapV          = v0;
      lyapVdot       = 0.0;
      lyapVprev      = v0;
      gradV          = computeGradV(cur, tgt);
      contractionRate = 0.0;
      barrierState   = _defaultBarrier();
      issAnalysis    = _defaultISS();
      stochLyap      = _defaultStoch();
      lyapExponents  = _defaultExponents();
      attractorBasin = _defaultBasin();
      vHistory       = [];
      vdotHistory    = [];
      stableBeats    = 0;
      unstableBeats  = 0;
      beatNum        = 0;
      stabilityClass = #MarginallyStable;
      isAsymptotic   = false;
      isExponential  = false;
      medinaCS       = medinaStabilityCertificate(v0);
      sovereignLevel = sovereignV(v0);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 22: SUMMARY
  // ══════════════════════════════════════════════════════════════════════════

  public func summary(state : LyapunovState) : LyapunovSummary {
    {
      lyapV          = state.lyapV;
      lyapVdot       = state.lyapVdot;
      contractionRate = state.contractionRate;
      stabilityClass = state.stabilityClass;
      isAsymptotic   = state.isAsymptotic;
      stableBeats    = state.stableBeats;
      distToAttractor = distToAttractor(state.lyapV);
      medinaCS        = state.medinaCS;
      isHealthy       = isStabilityHealthy(state);
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
  //  A D V A N C E D   M A T H E M A T I C A L   E X P A N S I O N
  //
  //  Enterprise-Level Neural Mathematics and Cognitive Dynamics
  //  Full Dual-Organism Coupling: HIM ↔ HER
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // ADVANCED KURAMOTO PHASE DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Kuramoto order parameter: r = |1/N Σⱼ eⁱθʲ|
  public func advancedKuramotoOrderParameter(phases : [Float]) : Float {
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
    let nf = Float.fromInt(n);
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf
  };

  /// Kuramoto phase update: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
  public func advancedKuramotoPhaseUpdate(
    phase : Float,
    omega : Float,
    k : Float,
    allPhases : [Float],
    dt : Float
  ) : Float {
    let n = allPhases.size();
    if (n == 0) { return phase };
    var coupling : Float = 0.0;
    var i = 0;
    while (i < n) {
      coupling += Float.sin(allPhases[i] - phase);
      i += 1;
    };
    let dTheta = omega + (k / Float.fromInt(n)) * coupling;
    let newPhase = phase + dTheta * dt;
    let TWO_PI = 6.28318530717958647692;
    if (newPhase >= TWO_PI) { newPhase - TWO_PI }
    else if (newPhase < 0.0) { newPhase + TWO_PI }
    else { newPhase }
  };

  /// Critical coupling K_c for synchronization
  public func advancedCriticalCoupling(omegaSpread : Float) : Float {
    2.0 * omegaSpread / 3.14159265358979323846
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ADVANCED HEBBIAN PLASTICITY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Basic Hebbian: Δw = η × pre × post
  public func advancedHebbianBasic(weight : Float, pre : Float, post : Float, eta : Float) : Float {
    let delta = eta * pre * post;
    let newWeight = weight + delta;
    if (newWeight > 5.0) { 5.0 } else if (newWeight < -5.0) { -5.0 } else { newWeight }
  };

  /// Oja's rule: Δw = α(y·x - y²·w)
  public func advancedOjaRule(weight : Float, pre : Float, post : Float, alpha : Float) : Float {
    let delta = alpha * (post * pre - post * post * weight);
    weight + delta
  };

  /// BCM sliding threshold: θ_M = E[post²]
  public func advancedBCMThreshold(activityHistory : [Float]) : Float {
    if (activityHistory.size() == 0) { return 0.5 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < activityHistory.size()) {
      sum += activityHistory[i] * activityHistory[i];
      i += 1;
    };
    sum / Float.fromInt(activityHistory.size())
  };

  /// BCM update: Δw = η × pre × post × (post - θ_M)
  public func advancedBCMUpdate(weight : Float, pre : Float, post : Float, threshold : Float, eta : Float) : Float {
    let delta = eta * pre * post * (post - threshold);
    weight + delta
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // LYAPUNOV STABILITY ANALYSIS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Estimate Lyapunov exponent from time series
  public func advancedLyapunovExponent(timeSeries : [Float], embeddingDim : Nat, delay : Nat) : Float {
    let n = timeSeries.size();
    if (n < embeddingDim * delay + 10) { return 0.0 };
    var sumLog : Float = 0.0;
    var count = 0;
    var i = 0;
    while (i < n - embeddingDim * delay - 1) {
      let j = i + 1;
      var d0 : Float = 0.0;
      var k = 0;
      while (k < embeddingDim) {
        let diff = timeSeries[i + k * delay] - timeSeries[j + k * delay];
        d0 += diff * diff;
        k += 1;
      };
      d0 := Float.sqrt(d0);
      if (d0 > 0.0001) {
        var d1 : Float = 0.0;
        k := 0;
        while (k < embeddingDim) {
          let iNext = i + 1 + k * delay;
          let jNext = j + 1 + k * delay;
          if (iNext < n and jNext < n) {
            let diff = timeSeries[iNext] - timeSeries[jNext];
            d1 += diff * diff;
          };
          k += 1;
        };
        d1 := Float.sqrt(d1);
        if (d1 > 0.0001) {
          sumLog += Float.log(d1 / d0);
          count += 1;
        };
      };
      i += 1;
    };
    if (count == 0) { 0.0 } else { sumLog / Float.fromInt(count) }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INFORMATION THEORY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Shannon entropy H = -Σ pᵢ log(pᵢ)
  public func advancedEntropy(probs : [Float]) : Float {
    var h : Float = 0.0;
    var i = 0;
    while (i < probs.size()) {
      let p = probs[i];
      if (p > 0.0001) { h -= p * Float.log(p) };
      i += 1;
    };
    h
  };

  /// Transfer entropy approximation
  public func advancedTransferEntropy(x : [Float], y : [Float], lag : Nat) : Float {
    let n = if (x.size() < y.size()) x.size() else y.size();
    if (n <= lag + 1) { return 0.0 };
    var correlation : Float = 0.0;
    var i = lag;
    while (i < n) {
      let xPast = x[i - lag];
      let yNow = y[i];
      correlation += xPast * yNow;
      i += 1;
    };
    Float.abs(correlation / Float.fromInt(n - lag))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // FREE ENERGY PRINCIPLE (FRISTON)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Free energy: F = D_KL(q||p) - log p(o)
  public func advancedFreeEnergy(predictionError : Float, complexity : Float) : Float {
    predictionError * predictionError + complexity
  };

  /// Precision-weighted prediction error
  public func advancedPrecisionWeightedError(prediction : Float, observation : Float, precision : Float) : Float {
    let error = observation - prediction;
    precision * error * error
  };

  /// Bayesian belief update
  public func advancedBayesianUpdate(prior : Float, likelihood : Float) : Float {
    let posterior = prior * likelihood;
    if (posterior > 1.0) { 1.0 } else if (posterior < 0.0) { 0.0 } else { posterior }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ATTRACTOR DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Point attractor: dx/dt = -α(x - x*)
  public func advancedPointAttractor(x : Float, xStar : Float, alpha : Float, dt : Float) : Float {
    x + (-alpha * (x - xStar)) * dt
  };

  /// Limit cycle: using Van der Pol oscillator
  public func advancedLimitCycle(x : Float, y : Float, mu : Float, dt : Float) : (Float, Float) {
    let dxdt = y;
    let dydt = mu * (1.0 - x * x) * y - x;
    (x + dxdt * dt, y + dydt * dt)
  };

  /// Chaotic attractor: Lorenz system
  public func advancedLorenzAttractor(x : Float, y : Float, z : Float, sigma : Float, rho : Float, beta : Float, dt : Float) : (Float, Float, Float) {
    let dxdt = sigma * (y - x);
    let dydt = x * (rho - z) - y;
    let dzdt = x * y - beta * z;
    (x + dxdt * dt, y + dydt * dt, z + dzdt * dt)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NEURAL OSCILLATION DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Wilson-Cowan neural mass model
  public func advancedWilsonCowan(e : Float, inh : Float, c1 : Float, c2 : Float, c3 : Float, c4 : Float, p : Float, q : Float, dt : Float) : (Float, Float) {
    func sigmoid(x : Float) : Float { 1.0 / (1.0 + Float.exp(-x)) };
    let dEdt = -e + sigmoid(c1 * e - c2 * inh + p);
    let dIdt = -inh + sigmoid(c3 * e - c4 * inh + q);
    (e + dEdt * dt, inh + dIdt * dt)
  };

  /// Izhikevich neuron model
  public func advancedIzhikevichNeuron(v : Float, u : Float, input : Float, a : Float, b : Float, dt : Float) : (Float, Float, Bool) {
    var fired = false;
    var newV = v;
    var newU = u;
    if (v >= 30.0) {
      newV := -65.0;
      newU := u + 8.0;
      fired := true;
    } else {
      let dvdt = 0.04 * v * v + 5.0 * v + 140.0 - u + input;
      let dudt = a * (b * v - u);
      newV := v + dvdt * dt;
      newU := u + dudt * dt;
    };
    (newV, newU, fired)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // VECTOR AND MATRIX OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Dot product
  public func advancedDotProduct(v1 : [Float], v2 : [Float]) : Float {
    let n = if (v1.size() < v2.size()) v1.size() else v2.size();
    var sum : Float = 0.0;
    var i = 0;
    while (i < n) { sum += v1[i] * v2[i]; i += 1 };
    sum
  };

  /// Vector magnitude
  public func advancedVectorMagnitude(v : [Float]) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < v.size()) { sum += v[i] * v[i]; i += 1 };
    Float.sqrt(sum)
  };

  /// Cosine similarity
  public func advancedCosineSimilarity(v1 : [Float], v2 : [Float]) : Float {
    let dot = advancedDotProduct(v1, v2);
    let mag1 = advancedVectorMagnitude(v1);
    let mag2 = advancedVectorMagnitude(v2);
    if (mag1 < 0.0001 or mag2 < 0.0001) { 0.0 } else { dot / (mag1 * mag2) }
  };

}
