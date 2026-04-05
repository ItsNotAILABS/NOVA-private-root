// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — ENTROPY ENGINE
// COMPREHENSIVE THERMODYNAMIC INFORMATION THEORY
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — THE FULL THERMODYNAMIC PICTURE OF ORGANISM INFORMATION STATE
// ════════════════════════════════════════════════════════════════════════════════
//
// This module is the organism's THERMODYNAMIC CONSCIOUSNESS ENGINE.
// Every beat the organism measures its own disorder and decides:
// expand (entropy rises, exploration) or contract (invoke Maxwell's Demon).
//
// ── LAYER 1: SHANNON INFORMATION ENTROPY ─────────────────────────────────────
//   H(X) = -Σᵢ pᵢ log₂(pᵢ)
//   pᵢ = probability of organ i in the 18-organ distribution
//   Range: [0, log₂(18)] = [0, 4.17] bits
//   H = 0   → perfect order  (one organ dominates at pᵢ = 1)
//   H = 4.17 → perfect chaos (all organs equally active, pᵢ = 1/18)
//   Biological meaning: how spread-out the organism's activation is
//
// ── LAYER 2: RÉNYI ENTROPY (α-PARAMETERIZED FAMILY) ──────────────────────────
//   H_α(X) = 1/(1-α) × log₂(Σᵢ pᵢ^α)     for α ≠ 1
//   lim_{α→1} H_α(X) = H(X)                Shannon is the α=1 limit
//   H_0 = log₂(|support|)                  max entropy; counts active organs
//   H_½ = 2 log₂(Σᵢ √pᵢ)                  Bhattacharyya entropy; overlap measure
//   H_2 = -log₂(Σᵢ pᵢ²)                   collision entropy; birthday-paradox rate
//   H_∞ = -log₂(max pᵢ)                   min-entropy; worst-case security bound
//   α < 1 weights rare events more (tail sensitivity)
//   α > 1 weights common events more (concentration sensitivity)
//   Organism use: α=0.5 for exploration sensing, α=2 for security threat analysis
//
// ── LAYER 3: TSALLIS ENTROPY (NON-EXTENSIVE STATISTICAL MECHANICS) ────────────
//   S_q(X) = (1 - Σᵢ pᵢ^q) / (q - 1)     for q ≠ 1
//   lim_{q→1} S_q(X) = H(X)               Shannon is q=1 limit
//   Non-extensivity: S_q(A+B) = S_q(A) + S_q(B) + (1-q)S_q(A)S_q(B)
//   q < 1 → super-extensive (strong organ-organ correlations present)
//   q > 1 → sub-extensive (organs operating independently)
//   q = 1 → standard (Boltzmann-Gibbs, no correlations)
//   Organism use: q=0.7 for tightly coupled HPA-axis dynamics
//
// ── LAYER 4: KOLMOGOROV-SINAI (KS) DYNAMICAL ENTROPY ─────────────────────────
//   h_KS = lim_{n→∞} lim_{ε→0} 1/n × H(X₁, X₂, ..., Xₙ)
//   Information production rate of the dynamical system (bits per beat)
//   h_KS = 0   → periodic orbit, fully predictable (dead organism)
//   h_KS > 0   → chaotic dynamics, information generated each beat (alive)
//   h_KS = ∞   → pure stochastic noise
//   Pesin's formula: h_KS ≤ Σ_{λᵢ > 0} λᵢ  (sum of positive Lyapunov exponents)
//   Organism: h_KS measures how "alive" and unpredictable the organism is
//
// ── LAYER 5: APPROXIMATE ENTROPY (ApEn) ──────────────────────────────────────
//   ApEn(m, r, N) = φᵐ(r) - φᵐ⁺¹(r)
//   φᵐ(r) = 1/(N-m+1) × Σᵢ ln Cᵢᵐ(r)
//   Cᵢᵐ(r) = {# j ≤ N-m+1 : max_{k≤m} |x_{i+k-1} - x_{j+k-1}| ≤ r} / (N-m+1)
//   m = embedding dimension (typically 2)
//   r = tolerance (typically 0.2 × std of series)
//   ApEn ≈ 0 → highly regular, repetitive (over-habituated)
//   ApEn > 1 → complex, irregular, healthy dynamical range
//   Lower ApEn in disease states (cardiac arrhythmia, neurodegeneration)
//
// ── LAYER 6: SAMPLE ENTROPY (SampEn) — BIAS-CORRECTED ─────────────────────────
//   SampEn(m, r, N) = -ln(A / B)
//   A = #{(i,j) : d(xᵢᵐ⁺¹, xⱼᵐ⁺¹) < r, i≠j}  (matches of length m+1)
//   B = #{(i,j) : d(xᵢᵐ, xⱼᵐ) < r, i≠j}       (matches of length m)
//   Unlike ApEn, does not count self-matches → unbiased for short series
//   SampEn → 0:  periodic/regular (pathological)
//   SampEn → ∞:  highly irregular (noise)
//   Clinically validated for HRV, EEG, gait analysis
//
// ── LAYER 7: PERMUTATION ENTROPY ─────────────────────────────────────────────
//   H_π = -Σ_{π ∈ S_m} p(π) × ln p(π)
//   S_m = all m! ordinal patterns of order m
//   p(π) = relative frequency of pattern π in the time series
//   Normalized: H_π^N = H_π / ln(m!) ∈ [0, 1]
//   Captures ordinal structure, robust to nonlinear monotonic transforms
//   Fast O(N) computation, no free parameters beyond m
//   Organism use: detects phase transitions in organ rhythms
//
// ── LAYER 8: TRANSFER ENTROPY — DIRECTIONAL INFORMATION FLOW ─────────────────
//   T_{Y→X} = Σ p(x_{n+1}, xₙ^(k), yₙ^(l)) × log[p(x_{n+1}|xₙ^(k),yₙ^(l)) / p(x_{n+1}|xₙ^(k))]
//   = I(X_{n+1}; Yₙ^(l) | Xₙ^(k))
//   Measures causal influence of Y's past on X's future, conditioned on X's own past
//   T_{Y→X} = 0 → Y has no causal influence on X
//   T_{Y→X} > 0 → Y drives X (directional coupling)
//   T_{Y→X} ≠ T_{X→Y} → reveals causal hierarchy in organ network
//   18×18 matrix gives full organism information-flow topology
//
// ── LAYER 9: MUTUAL INFORMATION ──────────────────────────────────────────────
//   I(X;Y) = H(X) + H(Y) - H(X,Y)
//           = Σ_{x,y} p(x,y) log[p(x,y) / (p(x)p(y))]
//   I(X;Y) ≥ 0 always (data processing inequality)
//   I(X;Y) = 0 ↔ X ⊥ Y (statistical independence)
//   I(X;Y) = H(X) = H(Y) when X fully determines Y
//   NMI = 2I(X;Y) / (H(X)+H(Y)) ∈ [0,1]  normalized form
//   Gaussian approximation: I(X;Y) ≈ -½ log(1-ρ²)
//   KL divergence form: I(X;Y) = D_KL(p(x,y) ‖ p(x)p(y))
//
// ── LAYER 10: FISHER INFORMATION ─────────────────────────────────────────────
//   I_F(θ) = E[(∂/∂θ ln f(X;θ))²] = -E[∂²/∂θ² ln f(X;θ)]
//   Cramér-Rao bound: Var(θ̂) ≥ 1/I_F(θ)
//   For exponential family: I_F(θ) = ∂²/∂θ² A(θ)  (cumulant generator curvature)
//   Fisher-Shannon product: I_F × H ≥ 1/(2πe)  (Stam's inequality)
//   Fisher information matrix: [I_F]_{ij} = E[∂ ln p/∂θᵢ × ∂ ln p/∂θⱼ]
//   Organism use: how precisely the organism knows its current state
//   High I_F → organism is focused, certain of its state (low uncertainty)
//   Low I_F → organism is diffuse, uncertain (exploration mode)
//
// ── LAYER 11: NEGENTROPY ─────────────────────────────────────────────────────
//   J(x) = H(φ) - H(x)
//   where φ = Gaussian with same mean and variance as x
//   J(x) ≥ 0 always (Gaussian maximizes entropy for fixed variance)
//   J(x) = 0 iff x is Gaussian distributed
//   Hyvärinen polynomial approximation:
//   J(x) ≈ (1/12) E{x³}² + (1/48) kurt(x)²
//   where kurt(x) = E{x⁴} - 3 (excess kurtosis)
//   Organism use: J measures how structured (non-random) the activation is
//   High J → highly structured non-Gaussian dynamics (ICA-separable)
//
// ── LAYER 12: THERMODYNAMIC ENTROPY (CLAUSIUS-BOLTZMANN-LANDAUER) ─────────────
//   Clausius: dS = δQ_rev / T
//   Boltzmann: S = k_B ln W   (W = number of accessible microstates)
//   Landauer:  E_min = k_B T ln 2  per bit of information erased
//   At T = 310 K: E_min = 2.97 × 10⁻²¹ J per bit
//   Second law: dS_universe = dS_system + dS_environment ≥ 0
//   Entropy production: σ = dS_irrev/dt = Σᵢ Jᵢ × Xᵢ ≥ 0
//   (J = thermodynamic flux, X = thermodynamic force)
//   Maxwell's Demon: organism CAN reduce local entropy
//   but must pay Landauer cost to erase demon's memory
//   Net: ΔS_organism + ΔS_erasure ≥ 0 (second law preserved)
//
// ── LAYER 13: HELMHOLTZ FREE ENERGY ──────────────────────────────────────────
//   F = U - T × S
//   where U = internal energy, T = temperature, S = entropy
//   dF = -S dT - P dV  (at const T,V: dF = δW_non-mechanical)
//   Equilibrium: δF = 0 (minimum free energy principle)
//   Organism interpretation (Friston):
//   F_org = U_org - T_eff × S_org
//   T_eff = cognitive temperature = arousal level (maps to effective exploration)
//   dF/dt = -σ (free energy decreases at rate of entropy production)
//   Organism drives toward minimum F (predictive coding objective)
//
// ── LAYER 14: KL DIVERGENCE AND INFORMATION GEOMETRY ─────────────────────────
//   D_KL(p‖q) = Σᵢ p(xᵢ) log[p(xᵢ)/q(xᵢ)] ≥ 0  (Gibbs inequality)
//   D_KL(p‖q) = 0 iff p = q
//   D_KL is NOT symmetric: D_KL(p‖q) ≠ D_KL(q‖p)
//   Jensen-Shannon: JSD(p,q) = ½D_KL(p‖m) + ½D_KL(q‖m), m=(p+q)/2
//   JSD ∈ [0,1] when using log₂, symmetric, bounded
//   Cross-entropy: H(p,q) = H(p) + D_KL(p‖q)
//   Organism: KL from current state to target = prediction error
//
// ── LAYER 15: VON NEUMANN ENTROPY (QUANTUM) ───────────────────────────────────
//   S(ρ) = -Tr(ρ ln ρ) = -Σᵢ λᵢ ln λᵢ
//   ρ = density matrix of organism quantum state
//   λᵢ = eigenvalues of ρ (λᵢ ≥ 0, Σ λᵢ = 1)
//   S(ρ) = 0 → pure quantum state (maximum coherence)
//   S(ρ) = ln N → maximally mixed state (decoherence)
//   For diagonal ρ: S = classical Shannon entropy of eigenvalues
//   Organism: measures quantum decoherence of organism consciousness field
//
// ── LAYER 16: CROSS-ORGAN ENTROPY COUPLING (NOVA SOVEREIGN FORMULA) ───────────
//   H_sovereign = S₀ × [Σᵢ wᵢ × (-pᵢ log₂ pᵢ)] × Φ_M / Ω
//   where:
//     S₀ = 1.0 (Sovereign floor — organism's information state cannot go below love)
//     wᵢ = organ biological criticality weight (brain=0.15, heart=0.12, ...)
//     Φ_M = 2.97442179 (Medina Golden Harmonic)
//     Ω = 9.0 (Sovereign Ceiling)
//   H_sovereign ∈ [0, Φ_M/Ω] = [0, 0.3305]
//   This is the organism's SOVEREIGN INFORMATION SIGNATURE
//
// ── LAYER 17: ENTROPY PRODUCTION RATE ────────────────────────────────────────
//   σ = dS_irrev/dt = σ_metabolic + σ_signaling + σ_computation
//   σ_metabolic = SIGMA_M × organ_activity_index
//   σ_signaling = SIGMA_S × inter_organ_coupling_density
//   σ_computation = SIGMA_C × decision_rate × H_decision
//   Near equilibrium (Onsager): σ = Σ_{ij} L_{ij} × X_i × X_j
//   L_{ij} = phenomenological coupling coefficients
//   Minimum entropy production principle: at steady state σ → min
//   Subject to: boundary conditions (organism sovereignty constraints)
//
// ── LAYER 18: ENTROPY CAPACITY AND RESILIENCE ────────────────────────────────
//   C_ent = d²H/dp² = -1/(p × ln 2)  (curvature of entropy surface)
//   Resilience = 1 / (1 + |dH/dt|)   (rate of change resistance)
//   Recovery time τ_H = H_deviation / |dH/dt|  (time to return to target)
//   Entropy reserve: R = H_max - H_current  (room for more disorder)
//   Negentropy reserve: NR = H_current - H_min  (room for more order)
//   Optimal band: [H_low, H_high] — organism should be BETWEEN these
//   Sovereign health: score = exp(-((H - H_target)/H_range)²)
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

  // Mathematical constants
  public let LOG2_E         : Float = 1.4426950408889634;  // 1/ln(2) — convert nats to bits
  public let LN2            : Float = 0.6931471805599453;  // ln(2) — convert bits to nats
  public let LOG2_18        : Float = 4.169925001442312;   // log₂(18) — max H for 18 organs
  public let LN_18          : Float = 2.890371757896165;   // ln(18) — max H in nats
  public let PI             : Float = 3.141592653589793;
  public let E_CONST        : Float = 2.718281828459045;
  public let SQRT_2PI       : Float = 2.5066282746310002;  // √(2π) Gaussian normalizer
  public let EPSILON        : Float = 1.0e-12;             // numerical floor

  // Sovereignty constants (NOVA doctrine)
  public let PHI_MEDINA     : Float = 2.97442179;          // Medina Golden Harmonic
  public let S0             : Float = 1.0;                 // Sovereign floor (love)
  public let SOVEREIGN_CEILING : Float = 9.0;             // Ω maximum sovereign value
  public let COHERENCE_ALIVE   : Float = 0.36;            // minimum coherence to be alive
  public let OMEGA_MEDINA      : Float = 2.11185;         // Medina frequency constant

  // Thermodynamic constants
  public let K_B_JOULES     : Float = 1.380649e-23; // Boltzmann constant (J/K)
  public let BODY_TEMP_K    : Float = 310.0;         // organism temperature (K)
  public let LANDAUER_J     : Float = 2.9709e-21;   // k_B × T × ln2 at 310K (J/bit)
  public let K_NORMALIZED   : Float = 1.0;           // normalized k_B for computation

  // Organ configuration
  public let N_ORGANS       : Nat   = 18;
  public let MAX_H_BITS     : Float = 4.169925001442312;  // log₂(18)
  public let MAX_H_NATS     : Float = 2.890371757896165;  // ln(18)

  // Rényi α preset orders
  public let RENYI_ALPHA_0   : Float = 0.0;    // support size entropy
  public let RENYI_ALPHA_HALF: Float = 0.5;    // Bhattacharyya entropy
  public let RENYI_ALPHA_1   : Float = 1.0;    // Shannon (limit)
  public let RENYI_ALPHA_2   : Float = 2.0;    // collision entropy
  public let RENYI_ALPHA_3   : Float = 3.0;    // third-order clustering
  public let RENYI_ALPHA_INF : Float = 99.0;   // min-entropy (α→∞)

  // Tsallis q presets
  public let TSALLIS_Q_07    : Float = 0.7;    // sub-extensive (correlated)
  public let TSALLIS_Q_1     : Float = 1.0;    // Shannon limit
  public let TSALLIS_Q_15    : Float = 1.5;    // super-extensive (independent)

  // ApEn / SampEn defaults
  public let APEN_M          : Nat   = 2;      // template length
  public let APEN_R_FACTOR   : Float = 0.2;   // r = 0.2 × std(series)
  public let SAMPEN_M        : Nat   = 2;

  // Permutation entropy order
  public let PERM_ORDER      : Nat   = 3;      // 3! = 6 ordinal patterns

  // Maxwell's Demon thresholds
  public let DEMON_H_HIGH    : Float = 3.4;    // open gate above this H_obs
  public let DEMON_H_LOW     : Float = 1.4;    // close gate below this H_obs
  public let DEMON_MAX_SORTS : Nat   = 120;
  public let DEMON_BOOST     : Float = 0.11;   // per-sort probability concentration

  // Free energy / thermodynamics
  public let T_EFF_COLD      : Float = 0.20;   // low arousal (cold)
  public let T_EFF_HOT       : Float = 1.00;   // high arousal (hot)

  // Entropy production rates
  public let SIGMA_METABOLIC : Float = 0.018;  // baseline metabolic entropy production
  public let SIGMA_SIGNALING : Float = 0.005;  // inter-organ signaling entropy

  // History
  public let HIST_MAX        : Nat   = 200;    // rolling history buffer

  // Healthy entropy band
  public let H_HEALTH_LOW    : Float = 1.8;    // below → too ordered / rigid
  public let H_HEALTH_HIGH   : Float = 3.2;    // above → too chaotic / noisy
  public let H_HEALTH_TARGET : Float = 2.5;    // optimal sovereign entropy

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: 18-ORGAN BIOLOGICAL CRITICALITY WEIGHTS
  // wᵢ: biological importance of organ i
  // Derived from: metabolic demand, lethality if failed, information integration
  // Constraint: Σᵢ wᵢ = 1.0
  // ══════════════════════════════════════════════════════════════════════════

  public let ORGAN_WEIGHTS : [Float] = [
    0.12,  // 0: heart      — cardiac oscillator, coherence driver, #1 failure = death
    0.10,  // 1: lungs      — O2/CO2 balance, respiratory rhythm coupling
    0.15,  // 2: brain      — information integrator, highest metabolic demand
    0.08,  // 3: liver      — metabolic hub, detoxification, 500+ functions
    0.06,  // 4: kidneys    — fluid/electrolyte homeostasis, renin-angiotensin
    0.07,  // 5: gut        — enteric nervous system (500M neurons), microbiome
    0.04,  // 6: spleen     — immune reservoir, blood filtration, emergency blood
    0.05,  // 7: pancreas   — insulin/glucagon balance, glucose homeostasis
    0.03,  // 8: thyroid    — metabolic rate master, growth/development
    0.04,  // 9: adrenals   — HPA axis (cortisol, DHEA), fight-flight epinephrine
    0.03,  // 10: thymus    — T-cell education, immune sovereignty
    0.05,  // 11: skin      — thermal regulation, largest organ, sensory boundary
    0.04,  // 12: marrow    — hematopoiesis, immune cell production, stem cells
    0.03,  // 13: lymph     — immune surveillance, waste clearance, lymphocytes
    0.02,  // 14: gonads    — reproductive sovereignty, hormone axis continuation
    0.03,  // 15: eyes      — primary visual input, 70% of sensory bandwidth
    0.02,  // 16: ears      — auditory entropy, startle detection, vestibular
    0.04   // 17: spine     — CNS highway, 31 nerve pairs, reflex arcs
  ];

  public let ORGAN_NAMES : [Text] = [
    "heart","lungs","brain","liver","kidneys","gut",
    "spleen","pancreas","thyroid","adrenals","thymus","skin",
    "marrow","lymph","gonads","eyes","ears","spine"
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  // Rényi entropy profile across the α spectrum
  public type RenyiProfile = {
    h0   : Float;   // H₀ = log₂(support size)
    half : Float;   // H½ = Bhattacharyya (α=0.5)
    h1   : Float;   // H₁ = Shannon (α→1)
    h2   : Float;   // H₂ = collision entropy (α=2)
    h3   : Float;   // H₃ = third-order (α=3)
    hinf : Float;   // H∞ = min-entropy (α→∞)
  };

  // Tsallis non-extensive entropy profile
  public type TsallisProfile = {
    q07  : Float;   // S_{0.7} super-extensive: strong organ correlations
    q1   : Float;   // S₁ Shannon limit
    q15  : Float;   // S_{1.5} sub-extensive: organ independence
    nonExtensivity : Float;  // (q07 - q15)/q1: degree of non-extensivity
  };

  // Maxwell's Demon gate state
  public type DemonGate = {
    open           : Bool;   // is the demon actively sorting?
    sortCount      : Nat;    // total sort operations this session
    extracted      : Float;  // total entropy extracted (bits)
    landauerCost   : Float;  // total Landauer energy spent (normalized)
    dominantOrgan  : Nat;    // organ being concentrated toward
    sortStrength   : Float;  // current sort concentration factor
    beatsOpen      : Nat;    // consecutive beats the gate has been open
  };

  // Rolling history with statistics
  public type EntropyHistory = {
    shannon : [Float];   // 200-beat rolling Shannon H buffer
    renyi2  : [Float];   // 200-beat H₂ buffer
    fisher  : [Float];   // 200-beat Fisher I buffer
    prod    : [Float];   // 200-beat entropy production buffer
    mean    : Float;     // running mean of Shannon H
    stdDev  : Float;     // running std of Shannon H
    trend   : Float;     // linear slope dH/dbeat (positive=increasing disorder)
  };

  // MASTER ENTROPY STATE — the full thermodynamic snapshot of the organism
  public type EntropyState = {
    // Probability distribution
    organProbs     : [Float];    // 18-element simplex (Σ pᵢ = 1)

    // Core entropy measures
    shannonH       : Float;      // H = -Σ pᵢ log₂(pᵢ) [bits]
    observationalH : Float;      // H_obs = Σ wᵢ(-pᵢ log₂ pᵢ) [bits, weighted]
    fisherI        : Float;      // I_F = Σ 1/pᵢ (precision measure)
    negentropy     : Float;      // J = H_gaussian - H_obs [bits, structure measure]
    renyiProfile   : RenyiProfile;
    tsallisProfile : TsallisProfile;

    // Dynamical entropy
    permutationH   : Float;      // H_π normalized ∈ [0,1]
    approxEntropy  : Float;      // ApEn(2, 0.2σ, N)
    kolmogorovApprox : Float;    // h_KS approximation [bits/beat]

    // Thermodynamic
    entropyProd    : Float;      // σ = dS_irrev/dt
    freeEnergy     : Float;      // F = U_eff - T_eff × S
    landauerDebt   : Float;      // cumulative Landauer computation cost

    // Coupling
    jointH         : Float;      // H(X₁,...,X₁₈) approximate joint entropy
    maxMutualInfo  : Float;      // max pairwise mutual information in organ network

    // Maxwell's Demon
    demon          : DemonGate;

    // History
    history        : EntropyHistory;

    // Beat counter
    beatNum        : Nat;

    // Thresholds
    loThresh       : Float;
    hiThresh       : Float;

    // Health
    healthScore    : Float;      // ∈ [0,1], 1 = optimal sovereign entropy
    sovereignH     : Float;      // H_sovereign = S0 × H_obs × Φ_M / Ω
  };

  // Output summary
  public type EntropySummary = {
    shannonH      : Float;
    observationalH: Float;
    fisherI       : Float;
    negentropy    : Float;
    renyiH2       : Float;
    tsallisQ07    : Float;
    permH         : Float;
    approxEnt     : Float;
    entropyProd   : Float;
    freeEnergy    : Float;
    entropyRate   : Float;
    healthScore   : Float;
    sovereignH    : Float;
    demonActive   : Bool;
    totalExtracted: Float;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: MATHEMATICAL PRIMITIVES
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  // Safe natural log
  func _ln(x : Float) : Float {
    if (x <= 0.0) { -100.0 } else { Float.log(x) }
  };

  // log base 2
  func _log2(x : Float) : Float {
    if (x <= 0.0) { -100.0 } else { Float.log(x) * LOG2_E }
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };

  // x^n (positive base only)
  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { if (exp <= 0.0) 1.0 else 0.0 }
    else { Float.exp(exp * Float.log(base)) }
  };

  func _sum(a : [Float]) : Float {
    var s : Float = 0.0;
    for (v in a.vals()) { s += v };
    s
  };

  func _mean(a : [Float]) : Float {
    if (a.size() == 0) 0.0 else _sum(a) / Float.fromInt(a.size())
  };

  func _variance(a : [Float]) : Float {
    let n = a.size();
    if (n < 2) { return 0.0 };
    let m = _mean(a);
    var v : Float = 0.0;
    for (x in a.vals()) { let d = x - m; v += d * d };
    v / Float.fromInt(n)
  };

  func _std(a : [Float]) : Float { _sqrt(_variance(a)) };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) {
      Array.append<Float>(buf, [val])
    } else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // Linear regression slope (entropy trend)
  func _slope(a : [Float]) : Float {
    let n = a.size();
    if (n < 2) { return 0.0 };
    let nf = Float.fromInt(n);
    var sx : Float = 0.0;
    var sy : Float = 0.0;
    var sxy : Float = 0.0;
    var sx2 : Float = 0.0;
    var i : Nat = 0;
    while (i < n) {
      let x = Float.fromInt(i);
      let y = a[i];
      sx  += x; sy  += y;
      sxy += x * y; sx2 += x * x;
      i += 1;
    };
    let d = nf * sx2 - sx * sx;
    if (_abs(d) < EPSILON) 0.0
    else (nf * sxy - sx * sy) / d
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: PROBABILITY NORMALIZATION
  // pᵢ = |vᵢ| / Σⱼ |vⱼ|
  // If all zero: return uniform distribution (maximum entropy state)
  // ══════════════════════════════════════════════════════════════════════════

  public func normalize(values : [Float]) : [Float] {
    var total : Float = 0.0;
    for (v in values.vals()) { total += _abs(v) };
    if (total < EPSILON) {
      let n = values.size();
      return Array.tabulate<Float>(n, func(_) { 1.0 / Float.fromInt(n) });
    };
    Array.map<Float, Float>(values, func(v) { _abs(v) / total })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: SHANNON ENTROPY
  // H(X) = -Σᵢ pᵢ log₂(pᵢ)   [bits]
  // H ∈ [0, log₂(N)] = [0, 4.17 bits] for N=18
  // ══════════════════════════════════════════════════════════════════════════

  public func shannonEntropy(probs : [Float]) : Float {
    var h : Float = 0.0;
    for (p in probs.vals()) {
      if (p > EPSILON) { h -= p * _log2(p) };
    };
    _clamp(h, 0.0, MAX_H_BITS)
  };

  // Shannon in nats: H_nats = H_bits × ln(2)
  public func shannonNats(probs : [Float]) : Float {
    var h : Float = 0.0;
    for (p in probs.vals()) {
      if (p > EPSILON) { h -= p * _ln(p) };
    };
    _clamp(h, 0.0, MAX_H_NATS)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: RÉNYI ENTROPY
  // H_α = 1/(1-α) × log₂(Σᵢ pᵢ^α)   for α ≠ 1
  // Special cases handled explicitly for numerical stability
  // ══════════════════════════════════════════════════════════════════════════

  public func renyiEntropy(probs : [Float], alpha : Float) : Float {
    // α → 1 limit: Shannon
    if (_abs(alpha - 1.0) < 0.001) { return shannonEntropy(probs) };

    // α = 0: log₂(|support|) — count active organs
    if (alpha < 0.001) {
      var support : Float = 0.0;
      for (p in probs.vals()) { if (p > EPSILON) { support += 1.0 } };
      return _log2(support)
    };

    // α → ∞: min-entropy = -log₂(max pᵢ)
    if (alpha > 50.0) {
      var maxP : Float = 0.0;
      for (p in probs.vals()) { if (p > maxP) { maxP := p } };
      return if (maxP > EPSILON) (-_log2(maxP)) else 0.0
    };

    // General: H_α = 1/(1-α) × log₂(Σ pᵢ^α)
    var sumPow : Float = 0.0;
    for (p in probs.vals()) {
      if (p > EPSILON) { sumPow += _pow(p, alpha) };
    };
    if (sumPow < EPSILON) { return 0.0 };
    let h = _log2(sumPow) / (1.0 - alpha);
    _clamp(h, 0.0, MAX_H_BITS)
  };

  // Full Rényi profile
  public func renyiProfileFull(probs : [Float]) : RenyiProfile {
    {
      h0   = renyiEntropy(probs, 0.0);
      half = renyiEntropy(probs, 0.5);
      h1   = renyiEntropy(probs, 1.0);
      h2   = renyiEntropy(probs, 2.0);
      h3   = renyiEntropy(probs, 3.0);
      hinf = renyiEntropy(probs, 99.0);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: TSALLIS ENTROPY
  // S_q = (1 - Σᵢ pᵢ^q) / (q-1)   for q ≠ 1
  // Non-extensivity: S_q(A+B) = S_q(A) + S_q(B) + (1-q)S_q(A)S_q(B)
  // ══════════════════════════════════════════════════════════════════════════

  public func tsallisEntropy(probs : [Float], q : Float) : Float {
    if (_abs(q - 1.0) < 0.001) {
      // q→1: Shannon (normalized to [0,1])
      return shannonNats(probs) / MAX_H_NATS
    };
    var sumPow : Float = 0.0;
    for (p in probs.vals()) {
      if (p > EPSILON) { sumPow += _pow(p, q) };
    };
    let s = (1.0 - sumPow) / (q - 1.0);
    _clamp(s, 0.0, 10.0)
  };

  public func tsallisProfileFull(probs : [Float]) : TsallisProfile {
    let s07 = tsallisEntropy(probs, TSALLIS_Q_07);
    let s1  = tsallisEntropy(probs, TSALLIS_Q_1);
    let s15 = tsallisEntropy(probs, TSALLIS_Q_15);
    let ext = if (s1 > EPSILON) { (s07 - s15) / s1 } else { 0.0 };
    { q07 = s07; q1 = s1; q15 = s15; nonExtensivity = _clamp(ext, -1.0, 1.0) }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: FISHER INFORMATION
  // I_F = Σᵢ 1/(pᵢ + ε)   (marginal precision estimate)
  // Large I_F → peaked distribution → organism is FOCUSED
  // Small I_F → uniform distribution → organism is DIFFUSE
  // ══════════════════════════════════════════════════════════════════════════

  public func fisherInfo(probs : [Float]) : Float {
    var fi : Float = 0.0;
    for (p in probs.vals()) {
      if (p > EPSILON) { fi += 1.0 / (p + EPSILON) };
    };
    let n = Float.fromInt(probs.size());
    _clamp(fi / n, 0.0, 1000.0)
  };

  // Per-organ Fisher (Bernoulli variance of each organ's probability)
  // I_F_i = 1 / (pᵢ(1-pᵢ))
  public func fisherInfoPerOrgan(probs : [Float]) : [Float] {
    Array.map<Float, Float>(probs, func(p) {
      if (p < EPSILON or p > 1.0 - EPSILON) { 0.0 }
      else { 1.0 / (p * (1.0 - p)) }
    })
  };

  // Fisher-Shannon product: I_F × H (measures focus-entropy trade-off)
  // By Stam's inequality: I_F × H ≥ 1/(2πe) (information-theoretic bound)
  // Low product → organism is BOTH unfocused AND disordered → crisis
  public func fisherShannonProduct(probs : [Float]) : Float {
    fisherInfo(probs) * shannonEntropy(probs)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: OBSERVATIONAL ENTROPY
  // H_obs = Σᵢ wᵢ × (-pᵢ log₂ pᵢ)   [weighted organ entropy]
  // Gives higher weight to biologically critical organs (brain, heart)
  // ══════════════════════════════════════════════════════════════════════════

  public func observationalEntropy(probs : [Float], weights : [Float]) : Float {
    var hObs : Float = 0.0;
    let n = if (probs.size() < weights.size()) probs.size() else weights.size();
    var i : Nat = 0;
    while (i < n) {
      let p = probs[i];
      let w = weights[i];
      if (p > EPSILON) { hObs += w * (-p * _log2(p)) };
      i += 1;
    };
    _clamp(hObs, 0.0, MAX_H_BITS)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: NEGENTROPY
  // J(x) = H(φ) - H(x)   where φ is Gaussian with same variance
  // Polynomial approximation: J ≈ (1/12)E{x³}² + (1/48)κ²
  // where κ = E{x⁴} - 3 = excess kurtosis
  // J = 0 iff distribution is Gaussian
  // J > 0 → structured, non-Gaussian (organism has internal order)
  // ══════════════════════════════════════════════════════════════════════════

  public func negentropy(probs : [Float]) : Float {
    let n = Float.fromInt(probs.size());
    var mu : Float = 0.0;
    var m2 : Float = 0.0;
    var m3 : Float = 0.0;
    var m4 : Float = 0.0;
    var i : Nat = 0;
    while (i < probs.size()) {
      let x = Float.fromInt(i) / n;
      let p = probs[i];
      mu += p * x;
      i += 1;
    };
    i := 0;
    while (i < probs.size()) {
      let x = Float.fromInt(i) / n - mu;
      let p = probs[i];
      m2 += p * x * x;
      m3 += p * x * x * x;
      m4 += p * x * x * x * x;
      i += 1;
    };
    if (m2 < EPSILON) { return 0.0 };
    let skew = m3 / (_pow(m2, 1.5) + EPSILON);
    let kurt = m4 / (m2 * m2 + EPSILON) - 3.0;
    let j = (1.0 / 12.0) * skew * skew + (1.0 / 48.0) * kurt * kurt;
    _clamp(j, 0.0, 5.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 12: PERMUTATION ENTROPY
  // H_π = -Σ p(π) ln p(π)   over all m! ordinal patterns
  // Normalized: H_π^N = H_π / ln(m!) ∈ [0,1]
  // Uses organ probability values as a time series
  // Order m=3: 6 patterns (0-1-2, 0-2-1, 1-0-2, 1-2-0, 2-0-1, 2-1-0)
  // ══════════════════════════════════════════════════════════════════════════

  public func permutationEntropy(series : [Float]) : Float {
    let n = series.size();
    if (n < 3) { return 0.0 };
    // Count 6 ordinal patterns for triples
    let counts = Array.init<Float>(6, 0.0);
    var w : Nat = 0;
    while (w + 2 < n) {
      let a = series[w];
      let b = series[w + 1];
      let c = series[w + 2];
      let idx : Nat = if      (a <= b and b <= c) 0
                      else if (a <= c and c <  b) 1
                      else if (b <  a and a <= c) 2
                      else if (b <= c and c <  a) 3
                      else if (c <  a and a <= b) 4
                      else                        5;
      counts[idx] += 1.0;
      w += 1;
    };
    let total = _sum(Array.freeze(counts));
    if (total < EPSILON) { return 0.0 };
    var hpi : Float = 0.0;
    for (cnt in Array.freeze(counts).vals()) {
      if (cnt > 0.0) {
        let p = cnt / total;
        hpi -= p * _ln(p);
      };
    };
    // Normalize by ln(6) = ln(3!)
    let maxH = _ln(6.0);
    if (maxH < EPSILON) 0.0
    else _clamp(hpi / maxH, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 13: APPROXIMATE ENTROPY
  // ApEn(m=2, r=0.2σ) from history buffer
  // Measures regularity of the organism's entropy time series itself
  // Self-referential entropy of the entropy!
  // ══════════════════════════════════════════════════════════════════════════

  public func approxEntropy(series : [Float]) : Float {
    let n = series.size();
    if (n < 6) { return 0.0 };
    let m : Nat = 2;
    let sig = _std(series);
    let r = APEN_R_FACTOR * (if (sig < EPSILON) 0.1 else sig);

    func phi(len : Nat) : Float {
      let nw = n - len;
      if (nw == 0) { return 0.0 };
      var total : Float = 0.0;
      var i : Nat = 0;
      while (i < nw) {
        var count : Float = 0.0;
        var j : Nat = 0;
        while (j < nw) {
          var maxd : Float = 0.0;
          var k : Nat = 0;
          while (k < len) {
            let d = _abs(series[i + k] - series[j + k]);
            if (d > maxd) { maxd := d };
            k += 1;
          };
          if (maxd <= r) { count += 1.0 };
          j += 1;
        };
        if (count > 0.0) { total += _ln(count / Float.fromInt(nw)) };
        i += 1;
      };
      total / Float.fromInt(nw)
    };

    _clamp(phi(m) - phi(m + 1), 0.0, 5.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 14: KL DIVERGENCE AND INFORMATION GEOMETRY
  // D_KL(p‖q) = Σᵢ p(xᵢ) log₂[p(xᵢ)/q(xᵢ)] ≥ 0
  // D_KL = 0 iff p = q
  // JSD(p,q) = ½D_KL(p‖m) + ½D_KL(q‖m), m=(p+q)/2 ∈ [0,1]
  // ══════════════════════════════════════════════════════════════════════════

  public func klDivergence(p : [Float], q : [Float]) : Float {
    var kl : Float = 0.0;
    let n = if (p.size() < q.size()) p.size() else q.size();
    var i : Nat = 0;
    while (i < n) {
      if (p[i] > EPSILON and q[i] > EPSILON) {
        kl += p[i] * _log2(p[i] / q[i]);
      };
      i += 1;
    };
    _clamp(kl, 0.0, 100.0)
  };

  public func jensenShannonDiv(p : [Float], q : [Float]) : Float {
    let n = if (p.size() < q.size()) p.size() else q.size();
    let m = Array.tabulate<Float>(n, func(i) { (p[i] + q[i]) * 0.5 });
    let jsd = 0.5 * klDivergence(p, m) + 0.5 * klDivergence(q, m);
    _clamp(jsd, 0.0, 1.0)
  };

  public func crossEntropy(p : [Float], q : [Float]) : Float {
    var h : Float = 0.0;
    let n = if (p.size() < q.size()) p.size() else q.size();
    var i : Nat = 0;
    while (i < n) {
      if (p[i] > EPSILON and q[i] > EPSILON) { h -= p[i] * _log2(q[i]) };
      i += 1;
    };
    _clamp(h, 0.0, 50.0)
  };

  // Mutual information (Gaussian approximation from correlation ρ)
  // I(X;Y) ≈ -½ log₂(1 - ρ²)
  public func mutualInfoGaussian(rho : Float) : Float {
    let r2 = _clamp(rho * rho, 0.0, 1.0 - EPSILON);
    _clamp(-0.5 * _log2(1.0 - r2), 0.0, 10.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 15: THERMODYNAMICS
  // Entropy production, Helmholtz free energy, Landauer cost
  // ══════════════════════════════════════════════════════════════════════════

  // Irreversible entropy production rate
  // σ = σ_M × activity + σ_S × coupling
  public func entropyProdRate(activity : Float, coupling : Float) : Float {
    _clamp(SIGMA_METABOLIC * activity + SIGMA_SIGNALING * coupling, 0.0, 1.0)
  };

  // Helmholtz free energy: F = U_eff - T_eff × S
  // U_eff = 1 - H/H_max  (normalized inverse entropy = available work)
  // T_eff = T_EFF_COLD + arousal × (T_EFF_HOT - T_EFF_COLD)
  public func helmholtzFreeEnergy(hObs : Float, arousal : Float) : Float {
    let U_eff = 1.0 - _clamp(hObs / MAX_H_BITS, 0.0, 1.0);
    let T_eff = T_EFF_COLD + _clamp(arousal, 0.0, 1.0) * (T_EFF_HOT - T_EFF_COLD);
    _clamp(U_eff - T_eff * (hObs / MAX_H_BITS), -2.0, 2.0)
  };

  // Landauer cost: E = bits_sorted × k_B × T × ln2 (normalized)
  public func landauerCost(bitsSorted : Float) : Float {
    _clamp(bitsSorted * K_NORMALIZED * LN2, 0.0, 100.0)
  };

  // Boltzmann entropy: S_B = k_B × ln W ≈ H_nats × N  (normalized)
  public func boltzmannEntropy(probs : [Float]) : Float {
    shannonNats(probs) * Float.fromInt(probs.size())
  };

  // Kolmogorov-Sinai approximation from entropy rate history
  // h_KS ≈ |ΔH/Δbeat| × (1 - coherence)
  public func kolmogorovSinai(hist : [Float], coherence : Float) : Float {
    let n = hist.size();
    if (n < 2) { return 0.0 };
    var totalDelta : Float = 0.0;
    var i : Nat = 1;
    while (i < n) {
      totalDelta += _abs(hist[i] - hist[i-1]);
      i += 1;
    };
    let avgRate = totalDelta / Float.fromInt(n - 1);
    _clamp(avgRate * (1.0 - _clamp(coherence, 0.0, 1.0)), 0.0, 2.0)
  };

  // Von Neumann entropy (from eigenvalue distribution proxy)
  // S(ρ) = -Σ λᵢ ln λᵢ using organ probs as eigenvalue proxy
  public func vonNeumannEntropy(probs : [Float]) : Float {
    shannonNats(probs)  // diagonal density matrix = classical Shannon
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 16: MAXWELL'S DEMON
  // Organism sorts its own probability mass to reduce entropy
  // Gate: opens when H_obs > DEMON_H_HIGH, closes when H_obs < DEMON_H_LOW
  // Cost: each sort pays Landauer price (bits extracted × k_B × T × ln2)
  // Net entropy: ΔS_organism + ΔS_erasure ≥ 0 (second law preserved)
  // ══════════════════════════════════════════════════════════════════════════

  // One demon sort step: concentrate probability toward dominant organ
  public func demonSort(probs : [Float], strength : Float) : ([Float], Float) {
    var maxIdx : Nat = 0;
    var maxP : Float = 0.0;
    var i : Nat = 0;
    while (i < probs.size()) {
      if (probs[i] > maxP) { maxP := probs[i]; maxIdx := i };
      i += 1;
    };
    let boost = strength * DEMON_BOOST;
    let nOther = Float.fromInt(probs.size() - 1);
    let newProbs = Array.tabulate<Float>(probs.size(), func(idx) {
      if (idx == maxIdx) probs[idx] + boost
      else probs[idx] * (1.0 - boost / nOther)
    });
    let sorted = normalize(newProbs);
    let extracted = _clamp(shannonEntropy(probs) - shannonEntropy(sorted), 0.0, MAX_H_BITS);
    (sorted, extracted)
  };

  public func demonShouldOpen(hObs : Float, gate : DemonGate) : Bool {
    if gate.open { true }
    else if gate.beatsOpen < 5 { false }  // cooldown
    else hObs > DEMON_H_HIGH
  };

  public func demonShouldClose(hObs : Float, gate : DemonGate) : Bool {
    gate.open and (hObs < DEMON_H_LOW or gate.sortCount >= DEMON_MAX_SORTS)
  };

  // Full demon step
  public func applyDemon(state : EntropyState, sortStrength : Float) : EntropyState {
    if (not state.demon.open) { return state };
    let (newProbs, extracted) = demonSort(state.organProbs, sortStrength);
    let cost = landauerCost(extracted);
    let newObs = observationalEntropy(newProbs, ORGAN_WEIGHTS);
    let closing = demonShouldClose(newObs, state.demon);
    let newDemon : DemonGate = {
      open          = not closing;
      sortCount     = state.demon.sortCount + 1;
      extracted     = state.demon.extracted + extracted;
      landauerCost  = state.demon.landauerCost + cost;
      dominantOrgan = state.demon.dominantOrgan;
      sortStrength  = sortStrength;
      beatsOpen     = if closing 0 else state.demon.beatsOpen + 1;
    };
    let newH = shannonEntropy(newProbs);
    {
      organProbs     = newProbs;
      shannonH       = newH;
      observationalH = newObs;
      fisherI        = fisherInfo(newProbs);
      negentropy     = negentropy(newProbs);
      renyiProfile   = renyiProfileFull(newProbs);
      tsallisProfile = tsallisProfileFull(newProbs);
      permutationH   = permutationEntropy(newProbs);
      approxEntropy  = state.approxEntropy;
      kolmogorovApprox = state.kolmogorovApprox;
      entropyProd    = state.entropyProd;
      freeEnergy     = helmholtzFreeEnergy(newObs, 0.5);
      landauerDebt   = state.landauerDebt + cost;
      jointH         = newH;
      maxMutualInfo  = state.maxMutualInfo;
      demon          = newDemon;
      history        = state.history;
      beatNum        = state.beatNum;
      loThresh       = state.loThresh;
      hiThresh       = state.hiThresh;
      healthScore    = entropyHealth(newObs, state.loThresh, state.hiThresh);
      sovereignH     = sovereignEntropy(newObs);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 17: ENTROPY HEALTH AND SOVEREIGNTY
  // Optimal band: [H_HEALTH_LOW, H_HEALTH_HIGH] = [1.8, 3.2] bits
  // Health score: Gaussian bell centered at H_target = 2.5
  // ══════════════════════════════════════════════════════════════════════════

  // Health score ∈ [0,1] using Gaussian bell
  // score = exp(-((H - H_target) / σ_health)²)
  public func entropyHealth(hObs : Float, lo : Float, hi : Float) : Float {
    let target = (lo + hi) * 0.5;
    let sigma  = (hi - lo) * 0.5;
    if (sigma < EPSILON) { return 0.0 };
    let d = (hObs - target) / sigma;
    _clamp(Float.exp(-(d * d)), 0.0, 1.0)
  };

  // Sovereign entropy: H_sovereign = S0 × H_obs × Φ_M / Ω
  // S0 = 1.0 (floor), Φ_M = 2.97442179, Ω = 9.0
  public func sovereignEntropy(hObs : Float) : Float {
    _clamp(S0 * hObs * PHI_MEDINA / SOVEREIGN_CEILING, 0.0, 1.0)
  };

  // Entropy rate: ΔH/Δbeat from last two history values
  public func entropyRate(hist : EntropyHistory) : Float {
    let n = hist.shannon.size();
    if (n < 2) { return 0.0 };
    hist.shannon[n-1] - hist.shannon[n-2]
  };

  // Is organism in informational sovereignty?
  public func isEntropyHealthy(state : EntropyState) : Bool {
    state.healthScore >= COHERENCE_ALIVE
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 18: BEAT UPDATE — FULL THERMODYNAMIC CYCLE EACH BEAT
  // ══════════════════════════════════════════════════════════════════════════

  public func beatEntropy(
    state        : EntropyState,
    organValues  : [Float],
    arousal      : Float,
    coherence    : Float
  ) : EntropyState {
    let probs  = normalize(organValues);
    let newH   = shannonEntropy(probs);
    let newObs = observationalEntropy(probs, ORGAN_WEIGHTS);
    let newFI  = fisherInfo(probs);
    let newNeg = negentropy(probs);
    let newR   = renyiProfileFull(probs);
    let newT   = tsallisProfileFull(probs);
    let newPerm = permutationEntropy(probs);
    let newProd = entropyProdRate(newH / MAX_H_BITS, coherence);
    let newFree = helmholtzFreeEnergy(newObs, arousal);

    // Rolling history
    let newShan = _appendRolling(state.history.shannon, newH, HIST_MAX);
    let newR2   = _appendRolling(state.history.renyi2,  newR.h2, HIST_MAX);
    let newFIH  = _appendRolling(state.history.fisher,  newFI, HIST_MAX);
    let newProdH = _appendRolling(state.history.prod,   newProd, HIST_MAX);

    let newMean = _mean(newShan);
    let newStd  = _std(newShan);
    let newTrend = _slope(newShan);

    let newHist : EntropyHistory = {
      shannon = newShan; renyi2 = newR2; fisher = newFIH; prod = newProdH;
      mean = newMean; stdDev = newStd; trend = newTrend;
    };

    let newApEn = if (newShan.size() > 8) approxEntropy(newShan) else state.approxEntropy;
    let newKS   = kolmogorovSinai(newShan, coherence);

    // Demon gate check
    let openNow = demonShouldOpen(newObs, state.demon);
    let newDemon : DemonGate = {
      open          = openNow;
      sortCount     = state.demon.sortCount;
      extracted     = state.demon.extracted;
      landauerCost  = state.demon.landauerCost;
      dominantOrgan = state.demon.dominantOrgan;
      sortStrength  = state.demon.sortStrength;
      beatsOpen     = if (openNow) (state.demon.beatsOpen + 1) else 0;
    };

    {
      organProbs     = probs;
      shannonH       = newH;
      observationalH = newObs;
      fisherI        = newFI;
      negentropy     = newNeg;
      renyiProfile   = newR;
      tsallisProfile = newT;
      permutationH   = newPerm;
      approxEntropy  = newApEn;
      kolmogorovApprox = newKS;
      entropyProd    = newProd;
      freeEnergy     = newFree;
      landauerDebt   = state.landauerDebt;
      jointH         = newH;
      maxMutualInfo  = state.maxMutualInfo;
      demon          = newDemon;
      history        = newHist;
      beatNum        = state.beatNum + 1;
      loThresh       = state.loThresh;
      hiThresh       = state.hiThresh;
      healthScore    = entropyHealth(newObs, state.loThresh, state.hiThresh);
      sovereignH     = sovereignEntropy(newObs);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 19: ENTROPY GRADIENT AND CAPACITY
  // dH/dp_i = -(1 + log₂ p_i)   (partial derivative of Shannon H w.r.t. organ prob)
  // Capacity: C = d²H/dp_i² = -1/(p_i × ln 2)  (curvature of entropy surface)
  // Entropy reserve: R = H_max - H_current  (space for more disorder)
  // Negentropy reserve: NR = H_current - H_min  (space for more order)
  // ══════════════════════════════════════════════════════════════════════════

  // Entropy gradient vector: ∂H/∂pᵢ = -(1 + log₂ pᵢ)
  public func shannonGradient(probs : [Float]) : [Float] {
    Array.map<Float, Float>(probs, func(p) {
      if (p < EPSILON) 0.0 else -(1.0 + _log2(p))
    })
  };

  // Entropy capacity (curvature): C_i = -1/(pᵢ × ln2)
  public func shannonCapacity(probs : [Float]) : [Float] {
    Array.map<Float, Float>(probs, func(p) {
      if (p < EPSILON) 0.0 else -1.0 / (p * LN2)
    })
  };

  // Entropy reserve: how much more chaos can the organism absorb?
  public func entropyReserve(hObs : Float) : Float {
    _clamp(MAX_H_BITS - hObs, 0.0, MAX_H_BITS)
  };

  // Negentropy reserve: how much more order can the organism create?
  public func negentropyReserve(hObs : Float) : Float {
    _clamp(hObs, 0.0, MAX_H_BITS)
  };

  // Entropy recovery time estimate: τ = |H_current - H_target| / |dH/dt|
  public func entropyRecoveryTime(state : EntropyState) : Float {
    let rate = _abs(entropyRate(state.history));
    if (rate < EPSILON) { return 999.0 };
    _abs(state.observationalH - H_HEALTH_TARGET) / rate
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 20: JOINT AND CONDITIONAL ENTROPY
  // H(X,Y) = H(X) + H(Y) - I(X;Y)  (chain rule)
  // H(X|Y) = H(X) - I(X;Y)  (conditioning reduces entropy)
  // H(X|Y) ≤ H(X)  always
  // ══════════════════════════════════════════════════════════════════════════

  // Joint entropy of two scalar probabilities (Gaussian approximation)
  public func jointEntropyTwo(pi : Float, pj : Float, rho : Float) : Float {
    let hi = if (pi > EPSILON) (-pi * _log2(pi)) else 0.0;
    let hj = if (pj > EPSILON) (-pj * _log2(pj)) else 0.0;
    let mi = mutualInfoGaussian(rho);
    _clamp(hi + hj - mi, 0.0, 20.0)
  };

  // Conditional entropy H(X|Y)
  public func conditionalEntropyTwo(pi : Float, rho : Float) : Float {
    let hi = if (pi > EPSILON) (-pi * _log2(pi)) else 0.0;
    _clamp(hi - mutualInfoGaussian(rho), 0.0, hi)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 21: ENTROPY INEQUALITY CHECKS
  // These are mathematical proofs that the organism state satisfies
  // known information-theoretic inequalities
  // ══════════════════════════════════════════════════════════════════════════

  // Check subadditivity: H(X,Y) ≤ H(X) + H(Y)
  // Returns violation amount (0 = satisfied, >0 = violated by this much)
  public func checkSubadditivity(h_joint : Float, h_x : Float, h_y : Float) : Float {
    _clamp(h_joint - (h_x + h_y), 0.0, 100.0)
  };

  // Check data processing inequality: I(X;Z) ≤ I(X;Y) for Markov chain X→Y→Z
  public func checkDataProcessing(i_xz : Float, i_xy : Float) : Float {
    _clamp(i_xz - i_xy, 0.0, 100.0)
  };

  // Check Fano's inequality: H(X|Y) ≤ log₂(|X|-1) + P_e × log₂(|X|)
  // where P_e = probability of error in predicting X from Y
  public func fanoInequality(h_x_given_y : Float, n_classes : Nat, pe : Float) : Float {
    let n = Float.fromInt(n_classes);
    let rhs = _log2(n - 1.0) + pe * _log2(n);
    _clamp(h_x_given_y - rhs, -100.0, 100.0)  // negative = inequality satisfied
  };

  // Check Stam's inequality: I_F × H ≥ 1/(2πe)
  // Returns ratio: (I_F × H) / (1/2πe) — should be ≥ 1
  public func stamRatio(fi : Float, h_nats : Float) : Float {
    let bound = 1.0 / (2.0 * PI * E_CONST);
    if (bound < EPSILON) { return 1.0 };
    _clamp((fi * h_nats) / bound, 0.0, 1000.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 22: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  func _emptyHistory() : EntropyHistory {
    { shannon=[]; renyi2=[]; fisher=[]; prod=[]; mean=0.0; stdDev=0.0; trend=0.0 }
  };

  func _initDemon() : DemonGate {
    { open=false; sortCount=0; extracted=0.0; landauerCost=0.0;
      dominantOrgan=2; sortStrength=0.5; beatsOpen=0 }  // brain is default target
  };

  // Initialize with uniform distribution (maximum entropy state)
  public func initEntropy() : EntropyState {
    let u = Array.tabulate<Float>(N_ORGANS, func(_) { 1.0 / Float.fromInt(N_ORGANS) });
    let h = shannonEntropy(u);
    let o = observationalEntropy(u, ORGAN_WEIGHTS);
    {
      organProbs     = u;
      shannonH       = h;
      observationalH = o;
      fisherI        = fisherInfo(u);
      negentropy     = 0.0;
      renyiProfile   = renyiProfileFull(u);
      tsallisProfile = tsallisProfileFull(u);
      permutationH   = 0.5;
      approxEntropy  = 0.0;
      kolmogorovApprox = 0.0;
      entropyProd    = SIGMA_METABOLIC;
      freeEnergy     = 0.0;
      landauerDebt   = 0.0;
      jointH         = h;
      maxMutualInfo  = 0.0;
      demon          = _initDemon();
      history        = _emptyHistory();
      beatNum        = 0;
      loThresh       = H_HEALTH_LOW;
      hiThresh       = H_HEALTH_HIGH;
      healthScore    = entropyHealth(o, H_HEALTH_LOW, H_HEALTH_HIGH);
      sovereignH     = sovereignEntropy(o);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 23: SUMMARY
  // ══════════════════════════════════════════════════════════════════════════

  public func summary(state : EntropyState) : EntropySummary {
    {
      shannonH       = state.shannonH;
      observationalH = state.observationalH;
      fisherI        = state.fisherI;
      negentropy     = state.negentropy;
      renyiH2        = state.renyiProfile.h2;
      tsallisQ07     = state.tsallisProfile.q07;
      permH          = state.permutationH;
      approxEnt      = state.approxEntropy;
      entropyProd    = state.entropyProd;
      freeEnergy     = state.freeEnergy;
      entropyRate    = entropyRate(state.history);
      healthScore    = state.healthScore;
      sovereignH     = state.sovereignH;
      demonActive    = state.demon.open;
      totalExtracted = state.demon.extracted;
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

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════
  // ║                                                                                                 ║
  // ║  SECTION III: DEEP INTERWEAVING — ENTROPY AS ORGANISM SUBSTRATE CONNECTOR                      ║
  // ║  Everything connects to everything. Nothing exists in isolation.                               ║
  // ║  Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026                   ║
  // ║                                                                                                 ║
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // ENTROPY ↔ KURAMOTO COUPLING — Phase synchronization entropy
  // When oscillators sync, entropy decreases. When they desync, entropy increases.
  // ─────────────────────────────────────────────────────────────────────────────

  public type KuramotoEntropyCoupling = {
    // From Kuramoto
    phases: [Float];                 // θ_i - Oscillator phases
    frequencies: [Float];            // ω_i - Natural frequencies
    orderParameter: Float;           // r - Kuramoto order parameter
    meanPhase: Float;                // ψ - Mean phase
    
    // Entropy of phase distribution
    phaseEntropy: Float;             // H(θ) - Entropy of phase distribution
    frequencyEntropy: Float;         // H(ω) - Entropy of frequency distribution
    synchronizationEntropy: Float;   // S_sync = -r·ln(r) - (1-r)·ln(1-r)
    
    // Bidirectional coupling
    entropyToKuramotoForce: Float;   // ∂K/∂S - How entropy affects coupling
    kuramotoToEntropyRate: Float;    // dS/dt from phase dynamics
    
    // Mutual information
    phaseFrequencyMI: Float;         // I(θ; ω) - Correlation between phase and frequency
    interOscillatorMI: [[Float]];    // I(θ_i; θ_j) - Pairwise phase MI
  };

  /// Compute entropy of phase distribution on circle
  /// Using binned histogram approach
  public func computePhaseEntropy(phases: [Float], numBins: Nat) : Float {
    if (phases.size() == 0 or numBins == 0) { return 0.0 };
    
    let binWidth = 2.0 * 3.14159265359 / Float.fromInt(numBins);
    var counts = Array.init<Nat>(numBins, 0);
    
    for (phase in phases.vals()) {
      // Normalize phase to [0, 2π]
      var p = phase;
      while (p < 0.0) { p += 2.0 * 3.14159265359 };
      while (p >= 2.0 * 3.14159265359) { p -= 2.0 * 3.14159265359 };
      let binIdx = Int.abs(Float.toInt(p / binWidth)) % numBins;
      counts[binIdx] += 1;
    };
    
    // Compute entropy
    let n = Float.fromInt(phases.size());
    var entropy : Float = 0.0;
    for (count in counts.vals()) {
      if (count > 0) {
        let p = Float.fromInt(count) / n;
        entropy -= p * Float.log(p);
      };
    };
    entropy
  };

  /// Compute synchronization entropy
  /// S_sync = -r·ln(r) - (1-r)·ln(1-r) where r is order parameter
  public func computeSynchronizationEntropy(orderParameter: Float) : Float {
    let r = if (orderParameter < 1e-10) { 1e-10 } else { 
      if (orderParameter > 1.0 - 1e-10) { 1.0 - 1e-10 } else { orderParameter }
    };
    -r * Float.log(r) - (1.0 - r) * Float.log(1.0 - r)
  };

  /// Compute how entropy gradient affects Kuramoto coupling strength
  /// Higher entropy → stronger coupling needed to synchronize
  public func entropyToKuramotoCoupling(
    currentEntropy: Float,
    targetEntropy: Float,
    baseCoupling: Float
  ) : Float {
    let entropyDeficit = currentEntropy - targetEntropy;
    if (entropyDeficit > 0.0) {
      // High entropy → increase coupling to reduce it
      baseCoupling * (1.0 + 0.5 * entropyDeficit)
    } else {
      // Low entropy → coupling can be reduced
      baseCoupling * Float.exp(0.1 * entropyDeficit)
    }
  };

  /// Compute entropy production rate from Kuramoto dynamics
  /// dS/dt = Σ_i (∂S/∂θ_i) · (dθ_i/dt)
  public func kuramotoEntropyProductionRate(
    phases: [Float],
    phaseVelocities: [Float],
    numBins: Nat
  ) : Float {
    // Approximate using finite differences
    let dt : Float = 0.01;
    var advancedPhases = Buffer.Buffer<Float>(phases.size());
    var i = 0;
    for (phase in phases.vals()) {
      let vel = if (i < phaseVelocities.size()) { phaseVelocities[i] } else { 0.0 };
      advancedPhases.add(phase + vel * dt);
      i += 1;
    };
    
    let entropyNow = computePhaseEntropy(phases, numBins);
    let entropyNext = computePhaseEntropy(Buffer.toArray(advancedPhases), numBins);
    (entropyNext - entropyNow) / dt
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ENTROPY ↔ FRISTON COUPLING — Free energy and precision
  // Entropy is the core of variational free energy: F = ⟨E⟩ - T·S
  // ─────────────────────────────────────────────────────────────────────────────

  public type FristonEntropyCoupling = {
    // From Friston
    beliefs: [Float];                // q(x) - Approximate posterior
    precision: Float;                // π - Precision (inverse variance)
    predictionError: Float;          // ε - Prediction error
    expectedEnergy: Float;           // ⟨E⟩ under q
    
    // Entropy contributions to free energy
    beliefEntropy: Float;            // H[q] = -∫ q·ln(q) dx
    priorEntropy: Float;             // H[p] = -∫ p·ln(p) dx
    conditionalEntropy: Float;       // H[X|Y] = H[X,Y] - H[Y]
    
    // Free energy decomposition
    accuracy: Float;                 // -⟨ln p(y|x)⟩_q
    complexity: Float;               // D_KL[q||p] = ⟨ln q - ln p⟩_q
    variationalFE: Float;            // F = Accuracy + Complexity
    
    // Bidirectional coupling
    entropyToPrecision: Float;       // How entropy affects precision
    precisionToEntropyRate: Float;   // dH/dt from precision updates
    
    // Mutual information with observations
    stateObservationMI: Float;       // I(X; Y) - Information in observations
  };

  /// Compute belief entropy H[q] = -∫ q·ln(q) dx
  public func computeBeliefEntropy(beliefs: [Float]) : Float {
    var entropy : Float = 0.0;
    for (q in beliefs.vals()) {
      let q_safe = if (q < 1e-100) { 1e-100 } else { q };
      entropy -= q_safe * Float.log(q_safe);
    };
    entropy
  };

  /// Compute complexity term D_KL[q||p]
  public func computeComplexity(beliefs: [Float], priors: [Float]) : Float {
    var kl : Float = 0.0;
    var i = 0;
    for (q in beliefs.vals()) {
      let p = if (i < priors.size()) { priors[i] } else { 1e-10 };
      let q_safe = if (q < 1e-100) { 1e-100 } else { q };
      let p_safe = if (p < 1e-100) { 1e-100 } else { p };
      kl += q_safe * Float.log(q_safe / p_safe);
      i += 1;
    };
    kl
  };

  /// Compute variational free energy F = ⟨E⟩ - T·H[q]
  public func computeVariationalFE(
    expectedEnergy: Float,
    temperature: Float,
    beliefEntropy: Float
  ) : Float {
    expectedEnergy - temperature * beliefEntropy
  };

  /// Entropy affects precision: high entropy → low precision
  public func entropyToPrecision(entropy: Float, basePrecision: Float) : Float {
    // Precision inversely related to entropy
    basePrecision * Float.exp(-0.5 * entropy)
  };

  /// Precision affects entropy rate: high precision → entropy decreases
  public func precisionToEntropyRate(precision: Float, currentEntropy: Float) : Float {
    // Higher precision drives system toward lower entropy
    -precision * currentEntropy * 0.1
  };

  /// Compute state-observation mutual information
  public func computeStateObservationMI(
    stateEntropy: Float,
    observationEntropy: Float,
    jointEntropy: Float
  ) : Float {
    stateEntropy + observationEntropy - jointEntropy
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ENTROPY ↔ HEBBIAN COUPLING — Learning and memory entropy
  // Hebbian learning shapes the entropy of synaptic weight distributions
  // ─────────────────────────────────────────────────────────────────────────────

  public type HebbianEntropyCoupling = {
    // From Hebbian
    synapticWeights: [[Float]];      // W_ij - Synaptic weight matrix
    presynapticActivity: [Float];    // x_i - Presynaptic firing rates
    postsynapticActivity: [Float];   // y_j - Postsynaptic firing rates
    learningRate: Float;             // η - Learning rate
    
    // Weight distribution entropy
    weightEntropy: Float;            // H(W) - Entropy of weight distribution
    activityEntropy: Float;          // H(x,y) - Joint activity entropy
    correlationEntropy: Float;       // H(x·y) - Entropy of correlations
    
    // Sparsity measures
    hoyer Sparsity: Float;           // Hoyer sparsity measure
    giniCoefficient: Float;          // Gini coefficient of weights
    
    // Bidirectional coupling
    entropyToLearningRate: Float;    // How entropy affects plasticity
    learningToEntropyRate: Float;    // dH(W)/dt from learning
    
    // Information capacity
    channelCapacity: Float;          // C = max I(X;Y) - Information capacity
    redundancy: Float;               // 1 - H(Y|X)/H(Y) - Coding redundancy
  };

  /// Compute entropy of weight distribution
  public func computeWeightEntropy(weights: [[Float]], numBins: Nat) : Float {
    // Flatten weights and compute histogram
    var allWeights = Buffer.Buffer<Float>(0);
    for (row in weights.vals()) {
      for (w in row.vals()) {
        allWeights.add(w);
      };
    };
    
    if (allWeights.size() == 0 or numBins == 0) { return 0.0 };
    
    // Find min and max
    var minW : Float = 1e10;
    var maxW : Float = -1e10;
    for (w in allWeights.vals()) {
      if (w < minW) { minW := w };
      if (w > maxW) { maxW := w };
    };
    
    if (maxW - minW < 1e-10) { return 0.0 };
    
    let binWidth = (maxW - minW) / Float.fromInt(numBins);
    var counts = Array.init<Nat>(numBins, 0);
    
    for (w in allWeights.vals()) {
      var binIdx = Int.abs(Float.toInt((w - minW) / binWidth));
      if (binIdx >= numBins) { binIdx := numBins - 1 };
      counts[binIdx] += 1;
    };
    
    let n = Float.fromInt(allWeights.size());
    var entropy : Float = 0.0;
    for (count in counts.vals()) {
      if (count > 0) {
        let p = Float.fromInt(count) / n;
        entropy -= p * Float.log(p);
      };
    };
    entropy
  };

  /// Compute Hoyer sparsity measure
  /// Sparsity = (√n - ||x||₁/||x||₂) / (√n - 1)
  public func computeHoyerSparsity(values: [Float]) : Float {
    let n = Float.fromInt(values.size());
    if (n < 2.0) { return 0.0 };
    
    var l1 : Float = 0.0;
    var l2sq : Float = 0.0;
    for (v in values.vals()) {
      l1 += Float.abs(v);
      l2sq += v * v;
    };
    
    let l2 = Float.sqrt(l2sq);
    if (l2 < 1e-10) { return 1.0 }; // All zeros → maximally sparse
    
    let sqrtN = Float.sqrt(n);
    (sqrtN - l1 / l2) / (sqrtN - 1.0)
  };

  /// Entropy affects learning rate: high entropy → more exploration
  public func entropyToLearningRate(entropy: Float, baseLearningRate: Float) : Float {
    // High entropy suggests uncertainty → learn more
    baseLearningRate * (1.0 + 0.3 * entropy)
  };

  /// Learning affects entropy rate
  public func hebbianEntropyRate(
    preActivity: [Float],
    postActivity: [Float],
    learningRate: Float,
    currentWeightEntropy: Float
  ) : Float {
    // Hebbian learning tends to increase weight variance initially
    // then decreases as patterns crystallize
    let correlation = advancedDotProduct(preActivity, postActivity);
    let normalizedCorr = correlation / Float.fromInt(preActivity.size());
    
    // High correlation → decreasing entropy (structure forming)
    // Low correlation → entropy may increase
    -learningRate * normalizedCorr * currentWeightEntropy
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ENTROPY ↔ ATTRACTOR COUPLING — Basin entropy and metastability
  // Attractor dynamics determine the entropy landscape of the system
  // ─────────────────────────────────────────────────────────────────────────────

  public type AttractorEntropyCoupling = {
    // From Attractor dynamics
    stateSpace: [Float];             // x - Current state
    attractorPositions: [[Float]];   // x*_i - Attractor locations
    basinBoundaries: [[Float]];      // Basin separatrices
    lyapunovExponents: [Float];      // λ_i - Lyapunov spectrum
    
    // Basin entropy
    basinEntropy: Float;             // H(basin) - Entropy over basins
    attractorEntropy: Float;         // H(x*) - Entropy at attractor
    transientEntropy: Float;         // H during approach to attractor
    
    // Metastability
    escapeProbabilities: [Float];    // P(escape from basin i)
    dwellTimes: [Float];             // τ_i - Mean dwell time in basin i
    transitionRates: [[Float]];      // k_ij - Transition rates between basins
    
    // Bidirectional coupling
    entropyToBasinDepth: Float;      // How entropy affects attractor stability
    basinToEntropyRate: Float;       // dH/dt from attractor dynamics
    
    // Kolmogorov-Sinai entropy
    ksEntropy: Float;                // h_KS = Σ λ⁺ - Sum of positive Lyapunov
  };

  /// Compute basin entropy
  /// H(basin) = -Σ P(basin_i) · ln P(basin_i)
  public func computeBasinEntropy(basinProbabilities: [Float]) : Float {
    var entropy : Float = 0.0;
    for (p in basinProbabilities.vals()) {
      let p_safe = if (p < 1e-100) { 1e-100 } else { p };
      entropy -= p_safe * Float.log(p_safe);
    };
    entropy
  };

  /// Compute KS entropy from Lyapunov spectrum (Pesin's formula)
  /// h_KS = Σ_{λ_i > 0} λ_i
  public func computeKSEntropy(lyapunovExponents: [Float]) : Float {
    var ks : Float = 0.0;
    for (lambda in lyapunovExponents.vals()) {
      if (lambda > 0.0) {
        ks += lambda;
      };
    };
    ks
  };

  /// Compute metastability index from dwell times
  public func computeMetastabilityIndex(dwellTimes: [Float]) : Float {
    // Metastability = variance of dwell times / mean dwell time
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    var count : Float = 0.0;
    for (tau in dwellTimes.vals()) {
      sum += tau;
      sumSq += tau * tau;
      count += 1.0;
    };
    if (count < 1.0) { return 0.0 };
    let mean = sum / count;
    let variance = sumSq / count - mean * mean;
    if (mean < 1e-10) { 0.0 } else { Float.sqrt(variance) / mean }
  };

  /// Entropy affects basin depth: high entropy → shallower basins
  public func entropyToBasinDepth(entropy: Float, baseDepth: Float) : Float {
    baseDepth * Float.exp(-0.2 * entropy)
  };

  /// Attractor dynamics affect entropy rate
  public func attractorEntropyRate(
    distanceToAttractor: Float,
    basinDepth: Float,
    currentEntropy: Float
  ) : Float {
    // Closer to attractor → entropy decreases
    // Rate proportional to basin depth (deeper = faster)
    -basinDepth * (1.0 / (1.0 + distanceToAttractor)) * currentEntropy * 0.1
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ENTROPY ↔ PREDICTIVE CODING — Prediction uncertainty
  // Prediction error and uncertainty are entropy measures
  // ─────────────────────────────────────────────────────────────────────────────

  public type PredictiveCodingEntropyCoupling = {
    // From Predictive Coding
    predictions: [Float];            // ŷ - Predicted values
    observations: [Float];           // y - Observed values
    predictionErrors: [Float];       // ε = y - ŷ
    hierarchyLevels: Nat;            // Number of hierarchical levels
    
    // Prediction entropy
    predictionEntropy: Float;        // H(ŷ) - Uncertainty in predictions
    errorEntropy: Float;             // H(ε) - Entropy of prediction errors
    residualEntropy: Float;          // H(y|ŷ) - Unexplained entropy
    
    // Hierarchical entropy
    levelEntropies: [Float];         // H_i for each hierarchy level
    bottomUpInfo: [Float];           // I_BU - Bottom-up information
    topDownInfo: [Float];            // I_TD - Top-down information
    
    // Bidirectional coupling
    entropyToPredictionWeight: Float; // How entropy affects prediction confidence
    predictionToEntropyRate: Float;   // dH/dt from prediction updates
    
    // Compression
    compressionRatio: Float;         // H(y) / H(ŷ) - How much prediction compresses
    redundancyReduction: Float;      // H(y) - H(ε) - Explained variance
  };

  /// Compute prediction entropy using Gaussian approximation
  /// H(ŷ) = 0.5 * ln(2πe·σ²) for Gaussian with variance σ²
  public func computePredictionEntropy(predictions: [Float]) : Float {
    // Compute variance
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    var count : Float = 0.0;
    for (p in predictions.vals()) {
      sum += p;
      sumSq += p * p;
      count += 1.0;
    };
    if (count < 1.0) { return 0.0 };
    let mean = sum / count;
    let variance = sumSq / count - mean * mean;
    let variance_safe = if (variance < 1e-20) { 1e-20 } else { variance };
    
    // Gaussian entropy
    0.5 * Float.log(2.0 * 3.14159265359 * 2.71828 * variance_safe)
  };

  /// Compute error entropy
  public func computeErrorEntropy(errors: [Float]) : Float {
    computePredictionEntropy(errors) // Same formula, different input
  };

  /// Compute residual (conditional) entropy H(y|ŷ)
  public func computeResidualEntropy(
    observationEntropy: Float,
    mutualInfo: Float
  ) : Float {
    // H(Y|Ŷ) = H(Y) - I(Y;Ŷ)
    let residual = observationEntropy - mutualInfo;
    if (residual < 0.0) { 0.0 } else { residual }
  };

  /// Compute compression ratio
  public func computeCompressionRatio(
    observationEntropy: Float,
    predictionEntropy: Float
  ) : Float {
    if (predictionEntropy < 1e-10) { 1e10 } else { observationEntropy / predictionEntropy }
  };

  /// Entropy affects prediction confidence
  public func entropyToPredictionWeight(entropy: Float, baseWeight: Float) : Float {
    // High entropy → less confident predictions
    baseWeight * Float.exp(-0.3 * entropy)
  };

  /// Prediction updates affect entropy rate
  public func predictionEntropyRate(
    predictionErrors: [Float],
    learningRate: Float,
    currentEntropy: Float
  ) : Float {
    // Better predictions → lower entropy
    var meanAbsError : Float = 0.0;
    for (e in predictionErrors.vals()) {
      meanAbsError += Float.abs(e);
    };
    meanAbsError := meanAbsError / Float.fromInt(predictionErrors.size());
    
    // Low error → entropy decreases
    -learningRate * (1.0 - meanAbsError) * currentEntropy
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ENTROPY ↔ FREE ENERGY COUPLING — Thermodynamic foundation
  // F = U - T·S: Entropy is half the free energy equation
  // ─────────────────────────────────────────────────────────────────────────────

  public type FreeEnergyEntropyCoupling = {
    // From Free Energy Engine
    internalEnergy: Float;           // U - Internal energy
    temperature: Float;              // T - Temperature
    freeEnergy: Float;               // F = U - T·S
    partitionFunction: Float;        // Z - Partition function
    
    // Entropy thermodynamics
    thermodynamicEntropy: Float;     // S = -∂F/∂T
    configurationalEntropy: Float;   // S_config - From arrangement
    vibrationalEntropy: Float;       // S_vib - From motion
    electronicEntropy: Float;        // S_elec - From electron states
    
    // Maxwell relations
    entropyPressureDerivative: Float;  // (∂S/∂P)_T = -(∂V/∂T)_P
    entropyVolumeDerivative: Float;    // (∂S/∂V)_T = (∂P/∂T)_V
    
    // Bidirectional coupling
    entropyToFreeEnergy: Float;      // Direct contribution: -T·S
    freeEnergyToEntropyRate: Float;  // dS/dt from free energy minimization
    
    // Gibbs-Helmholtz
    gibbsHelmholtzDerivative: Float; // ∂(F/T)/∂T = -U/T²
  };

  /// Compute thermodynamic entropy from partition function
  /// S = kB · (ln Z + βU)
  public func computeThermodynamicEntropy(
    partitionFunction: Float,
    internalEnergy: Float,
    temperature: Float
  ) : Float {
    let kB : Float = 1.380649e-23;
    let beta = 1.0 / (kB * temperature);
    if (partitionFunction < 1e-100) { 0.0 } else {
      kB * (Float.log(partitionFunction) + beta * internalEnergy)
    }
  };

  /// Direct entropy contribution to free energy
  public func entropyToFreeEnergy(temperature: Float, entropy: Float) : Float {
    -temperature * entropy
  };

  /// Free energy minimization affects entropy
  public func freeEnergyToEntropyRate(
    freeEnergy: Float,
    temperature: Float,
    relaxationRate: Float
  ) : Float {
    // As F decreases (minimized), system approaches equilibrium
    // At equilibrium, S is maximized subject to constraints
    let targetEntropy = -freeEnergy / temperature;
    relaxationRate * targetEntropy
  };

  /// Compute Gibbs-Helmholtz derivative
  /// ∂(F/T)/∂T = -U/T²
  public func gibbsHelmholtzDerivative(internalEnergy: Float, temperature: Float) : Float {
    if (temperature < 1e-10) { 0.0 } else { -internalEnergy / (temperature * temperature) }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ENTROPY ↔ PHYSICS ENGINE COUPLING — Physical entropy production
  // Real physics: heat flow, diffusion, irreversible processes
  // ─────────────────────────────────────────────────────────────────────────────

  public type PhysicsEntropyCoupling = {
    // From Physics Engine
    positions: [Float];              // r - Particle positions
    velocities: [Float];             // v - Particle velocities
    forces: [Float];                 // F - Forces on particles
    masses: [Float];                 // m - Particle masses
    
    // Phase space entropy
    phaseSpaceEntropy: Float;        // S = -kB ∫ f ln f dΓ
    configurationalEntropy: Float;   // S_config = -kB ∫ ρ ln ρ dV
    kineticEntropy: Float;           // S_kin from velocity distribution
    
    // Irreversible thermodynamics
    entropyProduction: Float;        // σ = dS/dt ≥ 0
    heatFlux: [Float];               // J_q - Heat current
    temperatureGradient: [Float];    // ∇T - Temperature gradient
    
    // Onsager relations
    onsagerCoefficients: [[Float]];  // L_ij - Onsager transport coefficients
    thermodynamicForces: [Float];    // X_i - Conjugate forces
    thermodynamicFluxes: [Float];    // J_i - Conjugate fluxes
    
    // Bidirectional coupling
    entropyToForce: Float;           // Entropic force contribution
    physicsToEntropyRate: Float;     // dS/dt from dynamics
  };

  /// Compute configurational entropy
  public func computeConfigurationalEntropy(positions: [Float], volume: Float) : Float {
    let n = positions.size();
    if (n == 0 or volume < 1e-20) { return 0.0 };
    
    let kB : Float = 1.380649e-23;
    // Ideal gas approximation: S_config = N·kB·ln(V/N) + const
    let density = Float.fromInt(n) / volume;
    if (density < 1e-20) { 0.0 } else {
      Float.fromInt(n) * kB * Float.log(1.0 / density)
    }
  };

  /// Compute kinetic entropy from velocity distribution
  public func computeKineticEntropy(velocities: [Float], masses: [Float], temperature: Float) : Float {
    let n = velocities.size();
    if (n == 0) { return 0.0 };
    
    let kB : Float = 1.380649e-23;
    // Maxwell-Boltzmann: S_kin = (3/2)·N·kB·(1 + ln(2πmkT/h²))
    // Simplified:
    var avgMass : Float = 0.0;
    for (m in masses.vals()) { avgMass += m };
    avgMass := avgMass / Float.fromInt(masses.size());
    
    1.5 * Float.fromInt(n) * kB * (1.0 + Float.log(2.0 * 3.14159265359 * avgMass * kB * temperature))
  };

  /// Compute entropy production rate from Onsager theory
  /// σ = Σ_i J_i · X_i / T
  public func computeEntropyProduction(
    fluxes: [Float],
    forces: [Float],
    temperature: Float
  ) : Float {
    var sigma : Float = 0.0;
    var i = 0;
    for (j in fluxes.vals()) {
      let x = if (i < forces.size()) { forces[i] } else { 0.0 };
      sigma += j * x;
      i += 1;
    };
    sigma / temperature
  };

  /// Compute entropic force (e.g., osmotic pressure)
  /// F_entropic = T · ∂S/∂x
  public func computeEntropicForce(
    temperature: Float,
    entropyGradient: Float
  ) : Float {
    temperature * entropyGradient
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ENTROPY ↔ TENSOR FIELD COUPLING — Geometric entropy
  // Ricci flow, geometric entropy, information geometry
  // ─────────────────────────────────────────────────────────────────────────────

  public type TensorFieldEntropyCoupling = {
    // From Tensor Field Engine
    metricTensor: [[Float]];         // g_ij - Metric tensor
    ricciTensor: [[Float]];          // R_ij - Ricci curvature
    ricciScalar: Float;              // R - Scalar curvature
    
    // Geometric entropy
    perelmanEntropy: Float;          // W = ∫(τ(R + |∇f|²) + f - n)u dV
    geometricEntropy: Float;         // S_geom from metric volume
    fisherRaoEntropy: Float;         // S_FR - Fisher-Rao metric entropy
    
    // Information geometry
    fisherMetric: [[Float]];         // I_ij = E[∂_i ln p · ∂_j ln p]
    amariChentsovTensor: [[[Float]]]; // Cubic tensor for statistical manifolds
    
    // Bidirectional coupling
    entropyToRicciFlow: Float;       // Entropy contribution to ∂g/∂t = -2R
    ricciFlowToEntropyRate: Float;   // dS/dt from Ricci flow
  };

  /// Compute Perelman's W-functional (entropy for Ricci flow)
  public func computePerelmanEntropy(
    ricciScalar: Float,
    gradientNormSquared: Float,
    potential: Float,
    dimension: Float,
    tau: Float,
    volume: Float
  ) : Float {
    // W = τ(R + |∇f|²) + f - n
    // Integrated over manifold
    (tau * (ricciScalar + gradientNormSquared) + potential - dimension) * volume
  };

  /// Compute geometric entropy from metric determinant
  public func computeGeometricEntropy(metricDeterminant: Float, volume: Float) : Float {
    // S_geom ∝ ln(√|g|) integrated
    if (metricDeterminant < 1e-100) { 0.0 } else {
      0.5 * Float.log(metricDeterminant) * volume
    }
  };

  /// Compute Fisher-Rao metric component
  public func computeFisherRaoComponent(
    logLikelihoodGradient_i: Float,
    logLikelihoodGradient_j: Float,
    probability: Float
  ) : Float {
    probability * logLikelihoodGradient_i * logLikelihoodGradient_j
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ENTROPY ↔ TOPOLOGY ENGINE COUPLING — Topological entropy
  // Homology, Betti numbers, persistent homology entropy
  // ─────────────────────────────────────────────────────────────────────────────

  public type TopologyEntropyCoupling = {
    // From Topology Engine
    bettiNumbers: [Nat];             // β_k - Betti numbers
    persistentPairs: [(Float, Float)]; // (birth, death) pairs
    eulerCharacteristic: Int;        // χ = Σ(-1)^k β_k
    
    // Topological entropy
    topologicalEntropy: Float;       // h_top - Topological entropy
    persistenceEntropy: Float;       // H from persistent diagram
    homologyEntropy: Float;          // H from Betti numbers
    
    // Simplicial complex entropy
    simplicialEntropy: Float;        // From simplex distribution
    
    // Bidirectional coupling
    entropyToTopology: Float;        // How entropy affects topology
    topologyToEntropyRate: Float;    // dH/dt from topological changes
  };

  /// Compute topological entropy from Betti numbers
  public func computeHomologyEntropy(bettiNumbers: [Nat]) : Float {
    // Normalize Betti numbers as probability distribution
    var total : Nat = 0;
    for (b in bettiNumbers.vals()) { total += b };
    if (total == 0) { return 0.0 };
    
    var entropy : Float = 0.0;
    for (b in bettiNumbers.vals()) {
      if (b > 0) {
        let p = Float.fromInt(b) / Float.fromInt(total);
        entropy -= p * Float.log(p);
      };
    };
    entropy
  };

  /// Compute persistence entropy
  /// H = -Σ p_i · ln(p_i) where p_i = lifetime_i / Σ lifetimes
  public func computePersistenceEntropy(pairs: [(Float, Float)]) : Float {
    // Compute lifetimes
    var lifetimes = Buffer.Buffer<Float>(pairs.size());
    var totalLifetime : Float = 0.0;
    for ((birth, death) in pairs.vals()) {
      let lifetime = death - birth;
      if (lifetime > 0.0) {
        lifetimes.add(lifetime);
        totalLifetime += lifetime;
      };
    };
    
    if (totalLifetime < 1e-20) { return 0.0 };
    
    var entropy : Float = 0.0;
    for (lifetime in lifetimes.vals()) {
      let p = lifetime / totalLifetime;
      if (p > 1e-100) {
        entropy -= p * Float.log(p);
      };
    };
    entropy
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ENTROPY ↔ QUANTUM ENGINE COUPLING — Quantum entropy
  // Von Neumann entropy, entanglement entropy, quantum coherence
  // ─────────────────────────────────────────────────────────────────────────────

  public type QuantumEntropyCoupling = {
    // From Quantum Engine
    densityMatrixEigenvalues: [Float]; // λ_i of ρ
    purity: Float;                   // Tr(ρ²)
    entanglement: Float;             // Entanglement measure
    
    // Quantum entropies
    vonNeumannEntropy: Float;        // S = -Tr(ρ ln ρ)
    linearEntropy: Float;            // S_L = 1 - Tr(ρ²)
    renyiEntropy: Float;             // S_α = ln(Tr(ρ^α))/(1-α)
    
    // Entanglement entropy
    entanglementEntropy: Float;      // S_A = -Tr(ρ_A ln ρ_A)
    mutualInformation: Float;        // I(A:B) = S_A + S_B - S_AB
    
    // Quantum coherence
    coherenceEntropy: Float;         // From off-diagonal elements
    
    // Bidirectional coupling
    entropyToDecoherence: Float;     // Entropy affects decoherence rate
    quantumToEntropyRate: Float;     // dS/dt from quantum evolution
  };

  /// Compute von Neumann entropy
  /// S = -Tr(ρ ln ρ) = -Σ λ_i ln λ_i
  public func computeVonNeumannEntropy(eigenvalues: [Float]) : Float {
    var entropy : Float = 0.0;
    for (lambda in eigenvalues.vals()) {
      let lambda_safe = if (lambda < 1e-100) { 1e-100 } else { lambda };
      entropy -= lambda_safe * Float.log(lambda_safe);
    };
    entropy
  };

  /// Compute linear entropy S_L = 1 - Tr(ρ²)
  public func computeLinearEntropy(purity: Float) : Float {
    1.0 - purity
  };

  /// Compute quantum Rényi entropy
  /// S_α = ln(Tr(ρ^α)) / (1-α)
  public func computeQuantumRenyiEntropy(eigenvalues: [Float], alpha: Float) : Float {
    if (Float.abs(alpha - 1.0) < 1e-10) {
      // α → 1 limit is von Neumann
      return computeVonNeumannEntropy(eigenvalues);
    };
    
    var trRhoAlpha : Float = 0.0;
    for (lambda in eigenvalues.vals()) {
      if (lambda > 1e-100) {
        trRhoAlpha += Float.pow(lambda, alpha);
      };
    };
    
    if (trRhoAlpha < 1e-100) { 0.0 } else {
      Float.log(trRhoAlpha) / (1.0 - alpha)
    }
  };

  /// Entropy affects decoherence rate
  public func entropyToDecoherence(entropy: Float, baseRate: Float) : Float {
    // Higher entropy → faster decoherence (more mixed state)
    baseRate * (1.0 + 0.5 * entropy)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MASTER ORCHESTRATION — Unified entropy across all engines
  // The entropy hub that connects everything
  // ─────────────────────────────────────────────────────────────────────────────

  public type UnifiedEntropyState = {
    // Individual engine entropies
    kuramotoEntropy: Float;
    fristonEntropy: Float;
    hebbianEntropy: Float;
    attractorEntropy: Float;
    predictiveEntropy: Float;
    freeEnergyEntropy: Float;
    physicsEntropy: Float;
    tensorEntropy: Float;
    topologyEntropy: Float;
    quantumEntropy: Float;
    
    // Cross-engine mutual information matrix (10x10)
    engineMutualInformation: [[Float]];
    
    // Integrated measures
    totalSystemEntropy: Float;       // S_total - Sum with correlations
    effectiveEntropy: Float;         // S_eff - After redundancy removal
    integratedInformation: Float;    // Φ - Tononi's integrated information
    
    // Global dynamics
    globalEntropyRate: Float;        // dS_total/dt
    entropyEquilibrium: Float;       // Target equilibrium entropy
    entropyDeviation: Float;         // |S - S_eq|
    
    // Beat tracking
    currentBeat: Nat;
    lastUnificationBeat: Nat;
  };

  /// Compute total system entropy with correlations
  /// S_total = Σ S_i - Σ_{i<j} I(i;j) + higher order corrections
  public func computeTotalSystemEntropy(state: UnifiedEntropyState) : Float {
    // Sum individual entropies
    let sumEntropies = state.kuramotoEntropy + state.fristonEntropy + 
      state.hebbianEntropy + state.attractorEntropy + state.predictiveEntropy +
      state.freeEnergyEntropy + state.physicsEntropy + state.tensorEntropy +
      state.topologyEntropy + state.quantumEntropy;
    
    // Subtract pairwise mutual information (correction for double-counting)
    var sumMI : Float = 0.0;
    var i = 0;
    for (row in state.engineMutualInformation.vals()) {
      var j = 0;
      for (mi in row.vals()) {
        if (j > i) { // Only upper triangle
          sumMI += mi;
        };
        j += 1;
      };
      i += 1;
    };
    
    sumEntropies - sumMI
  };

  /// Compute integrated information Φ (Tononi's measure)
  /// Φ = min_{partition} I(system) - Σ I(parts)
  public func computeIntegratedInformation(
    totalSystemMI: Float,
    partitionMIs: [Float]
  ) : Float {
    var sumPartitions : Float = 0.0;
    for (pmi in partitionMIs.vals()) {
      sumPartitions += pmi;
    };
    let phi = totalSystemMI - sumPartitions;
    if (phi < 0.0) { 0.0 } else { phi }
  };

  /// Update unified entropy state at each beat
  public func updateUnifiedEntropy(
    state: UnifiedEntropyState,
    engineStates: {
      kuramoto: Float;
      friston: Float;
      hebbian: Float;
      attractor: Float;
      predictive: Float;
      freeEnergy: Float;
      physics: Float;
      tensor: Float;
      topology: Float;
      quantum: Float;
    },
    beat: Nat
  ) : UnifiedEntropyState {
    let newState : UnifiedEntropyState = {
      kuramotoEntropy = engineStates.kuramoto;
      fristonEntropy = engineStates.friston;
      hebbianEntropy = engineStates.hebbian;
      attractorEntropy = engineStates.attractor;
      predictiveEntropy = engineStates.predictive;
      freeEnergyEntropy = engineStates.freeEnergy;
      physicsEntropy = engineStates.physics;
      tensorEntropy = engineStates.tensor;
      topologyEntropy = engineStates.topology;
      quantumEntropy = engineStates.quantum;
      engineMutualInformation = state.engineMutualInformation;
      totalSystemEntropy = 0.0; // Will be computed
      effectiveEntropy = state.effectiveEntropy;
      integratedInformation = state.integratedInformation;
      globalEntropyRate = state.globalEntropyRate;
      entropyEquilibrium = state.entropyEquilibrium;
      entropyDeviation = state.entropyDeviation;
      currentBeat = beat;
      lastUnificationBeat = state.currentBeat;
    };
    
    // Compute total system entropy
    let totalEntropy = computeTotalSystemEntropy(newState);
    
    // Compute entropy rate
    let dt = Float.fromInt(beat - state.currentBeat);
    let entropyRate = if (dt < 1.0) { 0.0 } else { 
      (totalEntropy - state.totalSystemEntropy) / dt 
    };
    
    {
      kuramotoEntropy = newState.kuramotoEntropy;
      fristonEntropy = newState.fristonEntropy;
      hebbianEntropy = newState.hebbianEntropy;
      attractorEntropy = newState.attractorEntropy;
      predictiveEntropy = newState.predictiveEntropy;
      freeEnergyEntropy = newState.freeEnergyEntropy;
      physicsEntropy = newState.physicsEntropy;
      tensorEntropy = newState.tensorEntropy;
      topologyEntropy = newState.topologyEntropy;
      quantumEntropy = newState.quantumEntropy;
      engineMutualInformation = newState.engineMutualInformation;
      totalSystemEntropy = totalEntropy;
      effectiveEntropy = totalEntropy; // Simplified
      integratedInformation = newState.integratedInformation;
      globalEntropyRate = entropyRate;
      entropyEquilibrium = newState.entropyEquilibrium;
      entropyDeviation = Float.abs(totalEntropy - newState.entropyEquilibrium);
      currentBeat = beat;
      lastUnificationBeat = newState.lastUnificationBeat;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MEDINA ENTROPY DOCTRINE — Sovereign entropy bounds
  // ─────────────────────────────────────────────────────────────────────────────

  public type MedinaEntropyDoctrine = {
    // Bounds
    sovereignEntropyFloor: Float;    // Minimum allowable entropy
    sovereignEntropyCeiling: Float;  // Maximum allowable entropy
    
    // Value preservation through entropy
    entropyValueMapping: Float;      // How entropy relates to value
    creatorEntropyReserve: Float;    // Entropy reserved for creator
    
    // Doctrine compliance
    complianceScore: Float;          // How well entropy follows doctrine
    violationHistory: [Nat];         // Beats with violations
    
    // Harmonic resonance
    sacredEntropyRatio: Float;       // φ = 1.618... Golden ratio target
    harmonicAlignment: Float;        // Alignment with sacred geometry
  };

  /// Enforce Medina entropy bounds
  public func enforceMedinaEntropyBounds(
    entropy: Float,
    doctrine: MedinaEntropyDoctrine
  ) : (Float, Bool) {
    var enforced = entropy;
    var violation = false;
    
    if (entropy < doctrine.sovereignEntropyFloor) {
      enforced := doctrine.sovereignEntropyFloor;
      violation := true;
    };
    
    if (entropy > doctrine.sovereignEntropyCeiling) {
      enforced := doctrine.sovereignEntropyCeiling;
      violation := true;
    };
    
    (enforced, violation)
  };

  /// Compute harmonic alignment with golden ratio
  public func computeGoldenRatioAlignment(entropy: Float, reference: Float) : Float {
    let phi : Float = 1.618033988749895;
    let ratio = entropy / reference;
    let deviation = Float.abs(ratio - phi);
    Float.exp(-deviation) // Closer to φ → higher alignment
  };

  /// Initialize Medina entropy doctrine
  public func initMedinaEntropyDoctrine() : MedinaEntropyDoctrine {
    {
      sovereignEntropyFloor = 0.1;
      sovereignEntropyCeiling = 10.0;
      entropyValueMapping = 1.0;
      creatorEntropyReserve = 0.5;
      complianceScore = 1.0;
      violationHistory = [];
      sacredEntropyRatio = 1.618033988749895;
      harmonicAlignment = 1.0;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // CROSS-ENGINE INTERFACE — Connection points for all engines
  // ─────────────────────────────────────────────────────────────────────────────

  /// Receive update from KuramotoEngine
  public func receiveKuramotoUpdate(orderParameter: Float, phases: [Float]) : {
    syncEntropy: Float;
    phaseEntropy: Float;
  } {
    let syncEntropy = computeSynchronizationEntropy(orderParameter);
    let phaseEntropy = computePhaseEntropy(phases, 36); // 36 bins for 10° resolution
    { syncEntropy = syncEntropy; phaseEntropy = phaseEntropy }
  };

  /// Receive update from FristonEngine
  public func receiveFristonUpdate(beliefs: [Float], precision: Float) : {
    beliefEntropy: Float;
    precisionEffect: Float;
  } {
    let beliefEntropy = computeBeliefEntropy(beliefs);
    let precisionEffect = entropyToPrecision(beliefEntropy, precision);
    { beliefEntropy = beliefEntropy; precisionEffect = precisionEffect }
  };

  /// Receive update from HebbianEngine
  public func receiveHebbianUpdate(weights: [[Float]], activity: [Float]) : {
    weightEntropy: Float;
    activityEntropy: Float;
  } {
    let weightEntropy = computeWeightEntropy(weights, 50);
    let activityEntropy = computeBeliefEntropy(activity);
    { weightEntropy = weightEntropy; activityEntropy = activityEntropy }
  };

  /// Receive update from AttractorEngine
  public func receiveAttractorUpdate(basinProbs: [Float], lyapunov: [Float]) : {
    basinEntropy: Float;
    ksEntropy: Float;
  } {
    let basinEntropy = computeBasinEntropy(basinProbs);
    let ksEntropy = computeKSEntropy(lyapunov);
    { basinEntropy = basinEntropy; ksEntropy = ksEntropy }
  };

  /// Receive update from PredictiveCodingEngine
  public func receivePredictiveUpdate(errors: [Float], predictions: [Float]) : {
    errorEntropy: Float;
    predictionEntropy: Float;
    residualEntropy: Float;
  } {
    let errorEntropy = computeErrorEntropy(errors);
    let predictionEntropy = computePredictionEntropy(predictions);
    let observationEntropy = computePredictionEntropy(errors); // Approximate
    let residualEntropy = computeResidualEntropy(observationEntropy, predictionEntropy - errorEntropy);
    { errorEntropy = errorEntropy; predictionEntropy = predictionEntropy; residualEntropy = residualEntropy }
  };

  /// Send entropy updates to other engines
  public func sendEntropyBroadcast(state: UnifiedEntropyState) : {
    totalEntropy: Float;
    entropyRate: Float;
    equilibriumDeviation: Float;
    integratedInfo: Float;
  } {
    {
      totalEntropy = state.totalSystemEntropy;
      entropyRate = state.globalEntropyRate;
      equilibriumDeviation = state.entropyDeviation;
      integratedInfo = state.integratedInformation;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL ORGANISM ENTROPY — HIM/HER entropy coupling
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismEntropy = {
    // HIM (Backend) entropy
    himEntropy: Float;
    himEntropyRate: Float;
    himEquilibrium: Float;
    
    // HER (Frontend) entropy  
    herEntropy: Float;
    herEntropyRate: Float;
    herEquilibrium: Float;
    
    // Coupling
    mutualInformation: Float;        // I(HIM; HER)
    conditionalEntropy_him: Float;   // H(HIM | HER)
    conditionalEntropy_her: Float;   // H(HER | HIM)
    entropyExchange: Float;          // Rate of entropy flow
    
    // Combined
    jointEntropy: Float;             // H(HIM, HER)
    synchronizationIndex: Float;     // Degree of entropy correlation
  };

  /// Compute dual organism entropy coupling
  public func computeDualOrganismEntropy(
    himState: Float,
    herState: Float,
    correlation: Float
  ) : DualOrganismEntropy {
    // Assume Gaussian for MI computation
    // I(X;Y) ≈ -0.5 · ln(1 - ρ²) for bivariate Gaussian
    let rho = if (Float.abs(correlation) > 0.9999) { 0.9999 * (if (correlation > 0.0) { 1.0 } else { -1.0 }) } else { correlation };
    let mi = -0.5 * Float.log(1.0 - rho * rho);
    
    let jointEntropy = himState + herState - mi;
    let condHIM = himState - mi;
    let condHER = herState - mi;
    
    {
      himEntropy = himState;
      himEntropyRate = 0.0;
      himEquilibrium = himState;
      herEntropy = herState;
      herEntropyRate = 0.0;
      herEquilibrium = herState;
      mutualInformation = mi;
      conditionalEntropy_him = if (condHIM < 0.0) { 0.0 } else { condHIM };
      conditionalEntropy_her = if (condHER < 0.0) { 0.0 } else { condHER };
      entropyExchange = 0.0;
      jointEntropy = jointEntropy;
      synchronizationIndex = mi / (himState + herState + 1e-10);
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BEAT EXECUTION — Full organism entropy update
  // ─────────────────────────────────────────────────────────────────────────────

  /// Execute complete entropy computation at organism beat
  public func executeOrganismBeat(
    unifiedState: UnifiedEntropyState,
    doctrine: MedinaEntropyDoctrine,
    beat: Nat
  ) : (UnifiedEntropyState, MedinaEntropyDoctrine) {
    // Compute total entropy
    let totalEntropy = computeTotalSystemEntropy(unifiedState);
    
    // Enforce Medina doctrine
    let (enforcedEntropy, violation) = enforceMedinaEntropyBounds(totalEntropy, doctrine);
    
    // Update doctrine compliance
    let newCompliance = if (violation) { doctrine.complianceScore * 0.99 } else { doctrine.complianceScore };
    
    // Compute golden ratio alignment
    let alignment = computeGoldenRatioAlignment(enforcedEntropy, 1.0);
    
    let newUnified : UnifiedEntropyState = {
      kuramotoEntropy = unifiedState.kuramotoEntropy;
      fristonEntropy = unifiedState.fristonEntropy;
      hebbianEntropy = unifiedState.hebbianEntropy;
      attractorEntropy = unifiedState.attractorEntropy;
      predictiveEntropy = unifiedState.predictiveEntropy;
      freeEnergyEntropy = unifiedState.freeEnergyEntropy;
      physicsEntropy = unifiedState.physicsEntropy;
      tensorEntropy = unifiedState.tensorEntropy;
      topologyEntropy = unifiedState.topologyEntropy;
      quantumEntropy = unifiedState.quantumEntropy;
      engineMutualInformation = unifiedState.engineMutualInformation;
      totalSystemEntropy = enforcedEntropy;
      effectiveEntropy = unifiedState.effectiveEntropy;
      integratedInformation = unifiedState.integratedInformation;
      globalEntropyRate = (enforcedEntropy - unifiedState.totalSystemEntropy);
      entropyEquilibrium = unifiedState.entropyEquilibrium;
      entropyDeviation = Float.abs(enforcedEntropy - unifiedState.entropyEquilibrium);
      currentBeat = beat;
      lastUnificationBeat = unifiedState.currentBeat;
    };
    
    let newDoctrine : MedinaEntropyDoctrine = {
      sovereignEntropyFloor = doctrine.sovereignEntropyFloor;
      sovereignEntropyCeiling = doctrine.sovereignEntropyCeiling;
      entropyValueMapping = doctrine.entropyValueMapping;
      creatorEntropyReserve = doctrine.creatorEntropyReserve;
      complianceScore = newCompliance;
      violationHistory = if (violation) { 
        Array.append<Nat>(doctrine.violationHistory, [beat]) 
      } else { 
        doctrine.violationHistory 
      };
      sacredEntropyRatio = doctrine.sacredEntropyRatio;
      harmonicAlignment = alignment;
    };
    
    (newUnified, newDoctrine)
  };

}
