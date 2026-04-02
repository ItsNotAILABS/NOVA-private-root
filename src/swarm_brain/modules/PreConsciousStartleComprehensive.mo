// ════════════════════════════════════════════════════════════════════════════════
// PRE-CONSCIOUS MECHANISM 19: STARTLE / BRAINSTEM SHORT-CIRCUIT
// COMPREHENSIVE IMPLEMENTATION — FULL INTEGRATION WITH ALL 12 LAYERS
//
// This is NOT a standalone module. It integrates with:
//   - LAYER 2: 64-node Hz spectrum (nodes 7, 9, 11, 16, 21 directly wired)
//   - LAYER 2: 8 quantum operators (PARALLAX, CHRONO, QMEM affected)
//   - LAYER 3: All 12 shells (Shell 3 directly stimulated, Shell 6 organs read)
//   - LAYER 4: Cognitive pipeline (BYPASSES perceptionCore when triggered)
//   - LAYER 5: 21 neurochemicals (NE, ADRENALINE, CORT, SUBP directly injected)
//   - LAYER 6: 7 council organisms (VETUS threat vectors escalated)
//   - LAYER 7: Token economics (affects FORMA compound rate via stability)
//   - LAYER 8: Security (AEGIS membrane, VETUS vectors, ANIMA chain)
//   - LAYER 9: Memory (high-salience startle events auto-write to LTM)
//   - LAYER 10: Animal engines (affects predator/prey trait activations)
//   - LAYER 11: Sovereignty (affects VECTOR convergence gate)
//
// Mathematical Model — FULL COMPOUNDING EQUATIONS:
//
// STARTLE MAGNITUDE (master equation):
//   M = S × G × (1 - H) × (1 + F) × (1 - PPI) × (1 + Sens) × Q_mod
//   where:
//     S = integrated stimulus intensity across all sensory modalities
//     G = reticular formation gain (dynamic, affected by arousal)
//     H = habituation factor (short-term + long-term, exponential decay)
//     F = fear potentiation (amygdala + BNST activation)
//     PPI = prepulse inhibition (Gaussian window around 100ms lead)
//     Sens = sensitization (acute + sustained threat exposure)
//     Q_mod = quantum modulation (CHRONO Fisher information scaling)
//
// HABITUATION DYNAMICS:
//   H_st(n) = H_max × (1 - exp(-n/τ_st))     // Short-term
//   H_lt(n) = H_lt_prev × 0.9999 + 0.005     // Long-term accumulation
//   H_total = min(H_max, H_st + H_lt)
//   τ_st = 50 trials, H_max = 0.85
//
// SENSITIZATION DYNAMICS:
//   Sens_acute(t) = Sens_0 × exp(-t/τ_sens) + Sens_baseline
//   Sens_sustained = Sens_sustained × 0.999 + threat × 0.1
//   Sens_total = clamp(Sens_acute + Sens_sustained, 0, 1)
//   τ_sens = 100 beats
//
// PREPULSE INHIBITION:
//   PPI(Δt) = PPI_max × exp(-(Δt - 100)²/(2×σ²)) × PPI_efficiency
//   σ = 30ms, PPI_max = 0.8, PPI_efficiency = individual variation [0.5, 0.9]
//
// FEAR POTENTIATION:
//   F_cued = amygdala_CeA × 0.8
//   F_contextual = BNST × 0.6
//   F_total = 1 + (F_cued + F_contextual) × (1 + CORT/2)
//   Clamped to [1.0, 2.5]
//
// RETICULAR FORMATION MODEL (12 giant neurons):
//   For each neuron i:
//     dV_i/dt = -V_i/τ_m + Σ_j(w_ij × S_j) + I_external
//     If V_i > θ_i: fire, V_i = V_reset, enter refractory
//     Output = Σ_i(firing_rate_i × output_strength_i) / N
//
// MOTOR PATHWAY ACTIVATION:
//   7 muscle groups with different latencies:
//     Eyeblink: 3 beats, HeadRetraction: 5, ShoulderElevation: 6
//     ArmFlexion: 7, TrunkFlexion: 8, LegFlexion: 10, GlobalPosture: 12
//   Activation decays exponentially after peak
//
// NEUROCHEMICAL INJECTION:
//   NE += M × 0.4 × (1 - NE)           // Norepinephrine surge
//   ADRENALINE += M × 0.5 × (1 - ADRENALINE)
//   CORT += M × 0.2 × (1 - CORT)       // Cortisol (slower)
//   SUBP += M × 0.3 × pain_signal      // Substance P if pain present
//   GLU += M × 0.35                    // Glutamate excitation
//   DA -= M × 0.1 × CORT               // Dopamine suppressed by CORT
//
// SHELL 3 STIMULATION:
//   For nodes in threat-detection cluster (indices 20-27):
//     eng_hzStim[i] += M × 0.2 × (1 + sensitization)
//   For nodes in motor preparation cluster (indices 10-17):
//     eng_hzStim[i] += M × 0.15
//
// Hz SPECTRUM ACTIVATION:
//   Node 16 (RAS-LOCUS): +M × 0.5 (arousal)
//   Node 21 (AMYGDALA-RIFT): +M × 0.4 (threat tagging)
//   Node 11 (MEDULLA-PULSE): +M × 0.3 (vital rhythm)
//   Node 9 (THALAMIC-RELAY): -M × 0.2 (sensory gating engaged)
//
// QUANTUM OPERATOR EFFECTS:
//   CHRONO Fisher: temporal precision boosted during startle
//   PARALLAX: 5-path evaluation compressed (faster decision)
//   QMEM: fidelity spike (high-salience encoding)
//
// VETUS THREAT VECTOR ESCALATION:
//   v1 (external threat): += M × 0.3
//   v6 (prediction error): += M × 0.2 (startle = prediction failure)
//   v10 (sovereignty membrane): += M × 0.1 (integrity check)
//
// AEGIS MEMBRANE EFFECTS:
//   Strand 1 (Sovereignty): temporary boost from successful defense
//   Strand 3 (Emergence): dip during startle (processing disrupted)
//   Strand 7 (Quantum): boost from CHRONO activation
//
// MEMORY WRITE:
//   If M > 0.5: write high-salience event to memoryBuf
//   salience = M × (1 + fear_potentiation)
//   emotional_charge = M × sign(threat - 0.5)
//
// DRIVE MODULATION:
//   threatResponse += M × 0.5
//   bodyIntegrity += M × 0.3 × pain_signal
//   exploration -= M × 0.4 (suppress during startle)
//   socialEngagement -= M × 0.3
//
// ANIMAL TRAIT ACTIVATION:
//   Predatory animals: suppressed during own startle
//   Prey animals: enhanced escape drive
//   Tardigrade: cryptobiosis trigger if M > 0.9
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Int   "mo:base/Int";
import Bool  "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Option "mo:base/Option";

module {

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 1: FUNDAMENTAL CONSTANTS AND MATHEMATICAL PRIMITIVES
  // ══════════════════════════════════════════════════════════════════════════════
  
  // Sacred mathematical constants
  public let PHI : Float = 1.618033988749895;
  public let PHI_INV : Float = 0.618033988749895;
  public let PHI_MEDINA : Float = 2.97442179;
  public let OMEGA_MEDINA : Float = 2.11185;
  public let TAU : Float = 6.283185307179586;
  public let PI : Float = 3.141592653589793;
  public let E : Float = 2.718281828459045;
  public let SQRT2 : Float = 1.4142135623730951;
  public let LN2 : Float = 0.6931471805599453;
  
  // Sovereignty constants
  public let S0 : Float = 1.0;                      // Sovereignty floor - NEVER below love
  public let SOVEREIGN_CEILING : Float = 9.0;       // Maximum sovereign value
  public let COHERENCE_ALIVE : Float = 0.36;        // Minimum to be considered alive
  
  // Startle timing constants (in beats, where 1 beat ≈ 1ms equivalent in organism time)
  public let STARTLE_LATENCY_BEATS : Nat = 8;       // 8ms biological latency - brainstem
  public let STARTLE_LATENCY_ACOUSTIC : Nat = 6;    // Acoustic startle is fastest
  public let STARTLE_LATENCY_TACTILE : Nat = 8;
  public let STARTLE_LATENCY_VESTIBULAR : Nat = 10;
  public let STARTLE_LATENCY_VISUAL : Nat = 12;     // Visual startle is slowest
  public let REFRACTORY_PERIOD_BASE : Nat = 500;    // 500ms base refractory period
  public let REFRACTORY_PERIOD_MAX : Nat = 1000;    // Maximum refractory after strong startle
  public let PPI_OPTIMAL_LEAD_TIME : Float = 100.0; // 100ms optimal prepulse lead time
  public let PPI_WINDOW_SIGMA : Float = 30.0;       // Gaussian width for PPI window
  public let PPI_WINDOW_MIN : Float = 30.0;         // Minimum effective lead time
  public let PPI_WINDOW_MAX : Float = 500.0;        // Maximum effective lead time
  
  // Habituation constants
  public let HABITUATION_TAU_ST : Float = 50.0;     // Short-term habituation time constant
  public let HABITUATION_TAU_LT : Float = 500.0;    // Long-term habituation time constant
  public let HABITUATION_MAX : Float = 0.85;        // Maximum habituation (never 100%)
  public let HABITUATION_RECOVERY_TAU : Float = 300.0; // Recovery time constant
  public let HABITUATION_LT_INCREMENT : Float = 0.005; // Per-trial long-term increment
  public let HABITUATION_LT_DECAY : Float = 0.9999; // Long-term decay per beat
  public let DISHABITUATION_THRESHOLD : Float = 0.5; // Recovery needed for dishabituation
  public let DISHABITUATION_RESET_FACTOR : Float = 0.3; // How much ST hab is reset
  
  // Sensitization constants
  public let SENSITIZATION_TAU : Float = 100.0;     // Sensitization decay time constant
  public let SENSITIZATION_BASELINE : Float = 0.0;  // Baseline sensitization
  public let SENSITIZATION_ACUTE_MAX : Float = 1.0; // Maximum acute sensitization
  public let SENSITIZATION_SUSTAINED_MAX : Float = 0.5; // Maximum sustained
  public let SENSITIZATION_SUSTAINED_DECAY : Float = 0.999; // Sustained decay per beat
  public let SENSITIZATION_SUSTAINED_INCREMENT : Float = 0.1; // Per-threat increment
  public let SENSITIZATION_THREAT_THRESHOLD : Float = 0.5; // Threat level to trigger
  
  // Fear potentiation constants
  public let FEAR_POTENTIATION_MIN : Float = 1.0;   // Baseline (no potentiation)
  public let FEAR_POTENTIATION_MAX : Float = 2.5;   // Maximum fear potentiation (250%)
  public let FEAR_CEA_WEIGHT : Float = 0.8;         // Central amygdala contribution
  public let FEAR_BNST_WEIGHT : Float = 0.6;        // Bed nucleus contribution
  public let FEAR_CORT_MODULATION : Float = 0.5;    // CORT amplifies fear
  public let FEAR_DECAY_RATE_CUED : Float = 0.05;   // Cued fear decays faster
  public let FEAR_DECAY_RATE_CONTEXTUAL : Float = 0.02; // Contextual fear persists
  
  // Reticular formation constants
  public let RETICULAR_NEURON_COUNT : Nat = 12;     // Giant neurons of PnC
  public let RETICULAR_TAU_MEMBRANE : Float = 10.0; // Membrane time constant
  public let RETICULAR_THRESHOLD_BASE : Float = 0.6; // Base firing threshold
  public let RETICULAR_THRESHOLD_VAR : Float = 0.15; // Threshold variation
  public let RETICULAR_REFRACTORY : Nat = 5;        // 5-beat neuron refractory
  public let RETICULAR_GAIN_BASE : Float = 1.0;     // Base gain
  public let RETICULAR_GAIN_MAX : Float = 3.0;      // Maximum gain
  public let RETICULAR_GAIN_AROUSAL_FACTOR : Float = 0.5; // Arousal contribution to gain
  public let RETICULAR_OUTPUT_WEIGHT_MIN : Float = 0.7;
  public let RETICULAR_OUTPUT_WEIGHT_MAX : Float = 1.0;
  public let RETICULAR_POPULATION_BONUS : Float = 0.3; // Population coding bonus
  
  // Sensory thresholds
  public let THRESHOLD_ACOUSTIC : Float = 0.65;     // ~65dB equivalent
  public let THRESHOLD_TACTILE : Float = 0.70;      // Touch startle threshold
  public let THRESHOLD_VESTIBULAR : Float = 0.80;   // Balance disruption threshold
  public let THRESHOLD_VISUAL : Float = 0.75;       // Looming visual threshold
  public let THRESHOLD_TRIGEMINAL : Float = 0.60;   // Air puff threshold (most sensitive)
  public let MULTIMODAL_BONUS_PER_CHANNEL : Float = 0.1; // Bonus per additional active channel
  public let SENSORY_ADAPTATION_RATE : Float = 0.01; // Adaptation buildup rate
  public let SENSORY_ADAPTATION_MAX : Float = 0.5;  // Maximum adaptation
  public let SENSORY_ADAPTATION_DECAY : Float = 0.005; // Adaptation recovery rate
  
  // Motor pathway constants
  public let MOTOR_PATHWAY_COUNT : Nat = 7;         // 7 muscle groups
  public let MOTOR_DECAY_BASE : Float = 0.1;        // Base decay rate
  public let MOTOR_DECAY_INCREMENT : Float = 0.02;  // Increment per muscle group
  public let MOTOR_ACTIVATION_THRESHOLD : Float = 0.3; // Minimum for activation report
  
  // Neurochemical injection rates (per unit magnitude)
  public let NEUROCHEMICAL_NE_RATE : Float = 0.4;   // Norepinephrine
  public let NEUROCHEMICAL_ADRENALINE_RATE : Float = 0.5;
  public let NEUROCHEMICAL_CORT_RATE : Float = 0.2; // Cortisol (slower)
  public let NEUROCHEMICAL_SUBP_RATE : Float = 0.3; // Substance P (pain-dependent)
  public let NEUROCHEMICAL_GLU_RATE : Float = 0.35; // Glutamate
  public let NEUROCHEMICAL_DA_SUPPRESSION : Float = 0.1; // Dopamine suppression
  public let NEUROCHEMICAL_GABA_RATE : Float = 0.15; // GABA (inhibitory rebound)
  public let NEUROCHEMICAL_5HT_RATE : Float = 0.05; // Serotonin (slow stabilization)
  
  // Shell 3 stimulation parameters
  public let SHELL3_THREAT_CLUSTER_START : Nat = 20;
  public let SHELL3_THREAT_CLUSTER_END : Nat = 27;
  public let SHELL3_MOTOR_CLUSTER_START : Nat = 10;
  public let SHELL3_MOTOR_CLUSTER_END : Nat = 17;
  public let SHELL3_STIM_THREAT_RATE : Float = 0.2;
  public let SHELL3_STIM_MOTOR_RATE : Float = 0.15;
  public let SHELL3_STIM_SENSITIZATION_BONUS : Float = 1.0;
  
  // Hz spectrum node indices (from Layer 2 specification)
  public let HZ_NODE_KORE : Nat = 7;                // 500kHz - deepest doctrine
  public let HZ_NODE_THALAMIC_RELAY : Nat = 9;      // 60MHz - sensory gating
  public let HZ_NODE_CEREBELLUM_EXEC : Nat = 10;    // 85MHz - precision execution
  public let HZ_NODE_MEDULLA_PULSE : Nat = 11;      // 40MHz - vital rhythm
  public let HZ_NODE_PONS_BRIDGE : Nat = 12;        // 30MHz - cross-hemisphere
  public let HZ_NODE_PINEAL_CHRONO : Nat = 13;      // 100kHz - celestial clock
  public let HZ_NODE_SEPTAL_MERI : Nat = 15;        // 20MHz - emotional regulation
  public let HZ_NODE_RAS_LOCUS : Nat = 16;          // 120MHz - arousal/alertness
  public let HZ_NODE_SUBTHALAMIC_DURA : Nat = 17;   // 18MHz - motor/decision gate
  public let HZ_NODE_BASAL_SOMA : Nat = 18;         // 15MHz - reward/habit
  public let HZ_NODE_FRONTAL_APEX : Nat = 19;       // 250MHz - executive
  public let HZ_NODE_OCCIPITAL_PRISM : Nat = 20;    // 180MHz - pattern recognition
  public let HZ_NODE_AMYGDALA_RIFT : Nat = 21;      // 100MHz - threat tagging
  public let HZ_NODE_DORSAL_STREAM : Nat = 22;      // 160MHz - where/how pathway
  public let HZ_NODE_VAEL : Nat = 23;               // 800MHz - peak expression gate
  
  // Hz spectrum activation rates during startle
  public let HZ_RAS_LOCUS_RATE : Float = 0.5;       // Arousal boost
  public let HZ_AMYGDALA_RIFT_RATE : Float = 0.4;   // Threat tagging
  public let HZ_MEDULLA_PULSE_RATE : Float = 0.3;   // Vital rhythm
  public let HZ_THALAMIC_RELAY_SUPPRESSION : Float = 0.2; // Sensory gating
  public let HZ_CEREBELLUM_EXEC_RATE : Float = 0.25; // Motor precision
  public let HZ_FRONTAL_APEX_SUPPRESSION : Float = 0.15; // Executive suppressed
  
  // VETUS threat vector indices
  public let VETUS_V1_EXTERNAL_THREAT : Nat = 0;
  public let VETUS_V2_DOCTRINE_DRIFT : Nat = 1;
  public let VETUS_V3_COHERENCE_COLLAPSE : Nat = 2;
  public let VETUS_V4_COUNCIL_MINIMUM : Nat = 3;
  public let VETUS_V5_QUANTUM_THREAT : Nat = 4;
  public let VETUS_V6_PREDICTION_ERROR : Nat = 5;
  public let VETUS_V7_ECDSA_RISK : Nat = 6;
  public let VETUS_V8_FINGERPRINT_BREACH : Nat = 7;
  public let VETUS_V9_SHELL3_COLLAPSE : Nat = 8;
  public let VETUS_V10_SOVEREIGNTY_BREACH : Nat = 9;
  
  // VETUS escalation rates during startle
  public let VETUS_V1_RATE : Float = 0.3;           // External threat
  public let VETUS_V6_RATE : Float = 0.2;           // Prediction error (startle = surprise)
  public let VETUS_V10_RATE : Float = 0.1;          // Sovereignty check
  
  // AEGIS strand indices
  public let AEGIS_SOVEREIGNTY : Nat = 0;
  public let AEGIS_COHERENCE : Nat = 1;
  public let AEGIS_EMERGENCE : Nat = 2;
  public let AEGIS_MEMORY : Nat = 3;
  public let AEGIS_ATTRIBUTION : Nat = 4;
  public let AEGIS_TEMPORAL : Nat = 5;
  public let AEGIS_QUANTUM : Nat = 6;
  
  // Drive dimension indices
  public let DRIVE_THREAT_RESPONSE : Nat = 0;
  public let DRIVE_BODY_INTEGRITY : Nat = 1;
  public let DRIVE_EXPLORATION : Nat = 2;
  public let DRIVE_SOCIAL_ENGAGEMENT : Nat = 3;
  public let DRIVE_GOAL_PURSUIT : Nat = 4;
  public let DRIVE_ENERGY_CONSERVATION : Nat = 5;
  public let DRIVE_CURIOSITY : Nat = 6;
  public let DRIVE_PLAY : Nat = 7;
  public let DRIVE_DOMINANCE : Nat = 8;
  public let DRIVE_AFFILIATION : Nat = 9;
  
  // Drive modulation rates during startle
  public let DRIVE_THREAT_BOOST : Float = 0.5;
  public let DRIVE_BODY_INTEGRITY_BOOST : Float = 0.3;
  public let DRIVE_EXPLORATION_SUPPRESSION : Float = 0.4;
  public let DRIVE_SOCIAL_SUPPRESSION : Float = 0.3;
  public let DRIVE_GOAL_SUPPRESSION : Float = 0.2;
  public let DRIVE_CURIOSITY_SUPPRESSION : Float = 0.35;
  
  // Organism integration thresholds
  public let SKIP_PIPELINE_THRESHOLD : Float = 0.7;  // Startle magnitude to skip cognitive pipeline
  public let FORCE_EMERGENCY_THRESHOLD : Float = 0.8; // Force Q_EMERGENCY mode
  public let SUPPRESS_EXPRESSION_THRESHOLD : Float = 0.6; // Suppress expression output
  public let MEMORY_WRITE_THRESHOLD : Float = 0.5;   // Write to LTM
  public let QUANTUM_MODULATION_THRESHOLD : Float = 0.4; // Affect quantum operators
  
  // Token economics effects
  public let FORMA_STABILITY_IMPACT : Float = 0.1;  // Startle temporarily reduces FORMA rate
  public let ANT_STREAK_RISK : Float = 0.2;         // Risk of breaking ANT streak
  
  // Animal trait modulation
  public let PREDATOR_SUPPRESSION_FACTOR : Float = 0.3; // Predatory traits suppressed
  public let PREY_ESCAPE_BOOST : Float = 0.4;       // Prey escape traits boosted
  public let TARDIGRADE_CRYPTOBIOSIS_THRESHOLD : Float = 0.9; // Extreme startle triggers

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 2: MATHEMATICAL HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════════
  
  /// Clamp float to range [lo, hi]
  public func fclamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };
  
  /// Absolute value
  public func fabs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };
  
  /// Safe division (avoid divide by zero)
  public func fdiv(num: Float, den: Float) : Float {
    if (fabs(den) < 1e-10) { 0.0 } else { num / den }
  };
  
  /// Exponential function
  public func fexp(x: Float) : Float {
    // Clamp input to prevent overflow
    let clamped = fclamp(x, -50.0, 50.0);
    Float.exp(clamped)
  };
  
  /// Natural logarithm (safe)
  public func flog(x: Float) : Float {
    if (x <= 0.0) { -50.0 } else { Float.log(x) }
  };
  
  /// Square root (safe)
  public func fsqrt(x: Float) : Float {
    if (x <= 0.0) { 0.0 } else { Float.sqrt(x) }
  };
  
  /// Power function
  public func fpow(base: Float, exp: Float) : Float {
    if (base <= 0.0) { 0.0 } else { Float.pow(base, exp) }
  };
  
  /// Sine function
  public func fsin(x: Float) : Float {
    Float.sin(x)
  };
  
  /// Cosine function
  public func fcos(x: Float) : Float {
    Float.cos(x)
  };
  
  /// Tangent function (safe)
  public func ftan(x: Float) : Float {
    let c = fcos(x);
    if (fabs(c) < 1e-10) { 0.0 } else { fsin(x) / c }
  };
  
  /// Gaussian function: exp(-(x-μ)²/(2σ²))
  public func gaussian(x: Float, mu: Float, sigma: Float) : Float {
    if (sigma <= 0.0) { return 0.0 };
    let exponent = -((x - mu) * (x - mu)) / (2.0 * sigma * sigma);
    fexp(exponent)
  };
  
  /// Sigmoid function: 1 / (1 + exp(-x))
  public func sigmoid(x: Float) : Float {
    1.0 / (1.0 + fexp(-x))
  };
  
  /// Logistic function with offset: 1 / (1 + exp(-k(x - x0)))
  public func logistic(x: Float, k: Float, x0: Float) : Float {
    1.0 / (1.0 + fexp(-k * (x - x0)))
  };
  
  /// Exponential moving average update
  public func ema(current: Float, newValue: Float, alpha: Float) : Float {
    current * (1.0 - alpha) + newValue * alpha
  };
  
  /// Leaky integrator update: dx/dt = -x/τ + input
  public func leakyIntegrate(x: Float, input: Float, tau: Float, dt: Float) : Float {
    if (tau <= 0.0) { return input };
    x + (-x / tau + input) * dt
  };
  
  /// Linear interpolation
  public func lerp(a: Float, b: Float, t: Float) : Float {
    a + (b - a) * fclamp(t, 0.0, 1.0)
  };
  
  /// Smooth step (cubic Hermite interpolation)
  public func smoothstep(edge0: Float, edge1: Float, x: Float) : Float {
    let t = fclamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
    t * t * (3.0 - 2.0 * t)
  };
  
  /// Map value from one range to another
  public func mapRange(value: Float, inMin: Float, inMax: Float, outMin: Float, outMax: Float) : Float {
    let t = fdiv(value - inMin, inMax - inMin);
    lerp(outMin, outMax, t)
  };
  
  /// Compute geometric mean of array
  public func geometricMean(values: [Float]) : Float {
    if (values.size() == 0) { return 0.0 };
    var logSum : Float = 0.0;
    var count : Nat = 0;
    for (v in values.vals()) {
      if (v > 0.0) {
        logSum += flog(v);
        count += 1;
      };
    };
    if (count == 0) { return 0.0 };
    fexp(logSum / Float.fromInt(count))
  };
  
  /// Compute arithmetic mean of array
  public func arithmeticMean(values: [Float]) : Float {
    if (values.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    for (v in values.vals()) {
      sum += v;
    };
    sum / Float.fromInt(values.size())
  };
  
  /// Compute standard deviation
  public func standardDeviation(values: [Float]) : Float {
    if (values.size() < 2) { return 0.0 };
    let mean = arithmeticMean(values);
    var sumSqDiff : Float = 0.0;
    for (v in values.vals()) {
      let diff = v - mean;
      sumSqDiff += diff * diff;
    };
    fsqrt(sumSqDiff / Float.fromInt(values.size() - 1))
  };
  
  /// Compute weighted sum
  public func weightedSum(values: [Float], weights: [Float]) : Float {
    let n = Nat.min(values.size(), weights.size());
    var sum : Float = 0.0;
    var i = 0;
    while (i < n) {
      sum += values[i] * weights[i];
      i += 1;
    };
    sum
  };
  
  /// Normalize array to sum to 1
  public func normalizeArray(values: [Float]) : [Float] {
    var sum : Float = 0.0;
    for (v in values.vals()) {
      sum += fabs(v);
    };
    if (sum < 1e-10) {
      return Array.tabulate<Float>(values.size(), func(_) { 1.0 / Float.fromInt(values.size()) });
    };
    Array.map<Float, Float>(values, func(v) { v / sum })
  };
  
  /// Softmax function
  public func softmax(values: [Float]) : [Float] {
    // Find max for numerical stability
    var maxVal : Float = -1e10;
    for (v in values.vals()) {
      if (v > maxVal) { maxVal := v };
    };
    
    // Compute exp(x - max) for each
    var expSum : Float = 0.0;
    let expValues = Array.map<Float, Float>(values, func(v) {
      let e = fexp(v - maxVal);
      expSum += e;
      e
    });
    
    // Normalize
    if (expSum < 1e-10) {
      return Array.tabulate<Float>(values.size(), func(_) { 1.0 / Float.fromInt(values.size()) });
    };
    Array.map<Float, Float>(expValues, func(e) { e / expSum })
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 3: TYPE DEFINITIONS — SENSORY SYSTEM
  // ══════════════════════════════════════════════════════════════════════════════

  /// Sensory modality for startle input
  public type StartleModality = {
    #Acoustic;          // Sudden loud sound (fastest pathway)
    #Tactile;           // Unexpected touch
    #Vestibular;        // Sudden movement/loss of balance
    #Visual;            // Looming visual stimulus (slowest pathway)
    #Trigeminal;        // Air puff to face (most sensitive)
    #MultiModal;        // Combined sensory input (strongest startle)
    #Proprioceptive;    // Unexpected body position change
    #Nociceptive;       // Pain signal
  };
  
  /// Sensory channel frequency characteristics
  public type SensoryFrequencyBand = {
    #Delta;             // 0.5-4 Hz - deep processing
    #Theta;             // 4-8 Hz - memory encoding
    #Alpha;             // 8-12 Hz - relaxed alertness
    #Beta;              // 12-30 Hz - active processing
    #Gamma;             // 30-100 Hz - high-level integration
    #HighGamma;         // 100+ Hz - ultra-fast signaling
  };

  /// Individual sensory channel state
  public type SensoryChannel = {
    // Identity
    modality          : StartleModality;
    channelId         : Nat;
    
    // Current input processing
    rawInput          : Float;          // 0-1 raw sensory input
    currentIntensity  : Float;          // 0-1 after adaptation
    peakIntensity     : Float;          // Peak in recent window
    riseRate          : Float;          // Rate of intensity increase
    
    // Thresholds and gain
    threshold         : Float;          // Detection threshold
    baseThreshold     : Float;          // Original threshold
    adaptiveThreshold : Float;          // Adapted threshold
    gain              : Float;          // Channel gain (1.0 = normal)
    
    // Adaptation state
    adaptation        : Float;          // Current adaptation level (0-1)
    adaptationTau     : Float;          // Adaptation time constant
    
    // Temporal characteristics
    latency           : Nat;            // Response latency in beats
    duration          : Nat;            // Typical response duration
    lastActivation    : Nat;            // Beat of last activation
    activationCount   : Nat;            // Total activations lifetime
    
    // Frequency coupling
    frequencyBand     : SensoryFrequencyBand;
    frequencyPower    : Float;          // Power in this band
    
    // Cross-modal interactions
    crossModalGain    : [Float];        // Gain from other modalities (8 values)
    crossModalInhibit : [Float];        // Inhibition from other modalities
    
    // History (last 10 values)
    recentHistory     : [Float];
    historyIndex      : Nat;
  };

  /// Sensory integration state
  public type SensoryIntegration = {
    // Integrated signals
    integratedIntensity : Float;        // Combined intensity
    dominantModality    : ?StartleModality;
    activeChannelCount  : Nat;
    multiModalBonus     : Float;
    
    // Rise time detection (sudden onset is more startling)
    riseTimeMs          : Float;        // Time to rise to threshold
    isRapidOnset        : Bool;         // Rapid onset detected
    onsetBonus          : Float;        // Bonus for rapid onset
    
    // Spatial integration
    spatialCoherence    : Float;        // How coherent across space
    spatialOrigin       : (Float, Float, Float); // Estimated origin
    
    // Temporal integration
    temporalCoherence   : Float;        // How coherent across time
    interstimInterval   : Float;        // Time since last stimulus
    
    // Cross-modal enhancement
    crossModalEnhancement : Float;      // Enhancement from multiple modalities
    
    // Final output
    startleEligible     : Bool;         // Does this trigger startle?
    startleProbability  : Float;        // Probability of startle
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 4: TYPE DEFINITIONS — RETICULAR FORMATION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Individual reticular neuron state
  public type ReticularNeuron = {
    // Identity
    neuronId          : Nat;
    neuronType        : ReticularNeuronType;
    
    // Membrane dynamics
    membranePotential : Float;          // -70mV to +30mV normalized to 0-1
    restingPotential  : Float;          // 0.3 typical
    threshold         : Float;          // Firing threshold
    resetPotential    : Float;          // Post-spike reset
    
    // Firing state
    isFiring          : Bool;           // Currently in spike
    firingRate        : Float;          // Current firing rate (Hz equivalent)
    lastSpikeTime     : Nat;            // Beat of last spike
    spikeCount        : Nat;            // Total spikes lifetime
    
    // Refractory period
    isRefractory      : Bool;
    refractoryRemaining : Nat;          // Beats remaining in refractory
    absoluteRefractory : Nat;           // Absolute refractory duration
    relativeRefractory : Nat;           // Relative refractory duration
    
    // Input weights (one per sensory channel)
    inputWeights      : [Float];        // 8 weights (one per modality)
    inputWeightsLearned : [Float];      // Learned modifications
    
    // Lateral connections
    lateralWeights    : [Float];        // Connections to other reticular neurons
    lateralInhibition : Float;          // Total inhibition from others
    
    // Output
    outputStrength    : Float;          // Contribution to motor output
    outputTarget      : [Nat];          // Which motor pathways this drives
    
    // Modulation
    sensitization     : Float;          // Sensitization level
    habituation       : Float;          // Habituation level
    arousalModulation : Float;          // Arousal modulation
    
    // Bursting properties
    burstMode         : Bool;           // In burst firing mode
    burstSpikesRemaining : Nat;         // Spikes left in current burst
    interBurstInterval : Nat;           // Beats between bursts
    
    // Neuromodulation
    neModulation      : Float;          // Norepinephrine effect
    achModulation     : Float;          // Acetylcholine effect
    daModulation      : Float;          // Dopamine effect
  };

  /// Types of reticular neurons
  public type ReticularNeuronType = {
    #GiantNeuronPnC;    // Pontine reticular nucleus, caudal - main startle
    #GiantNeuronPnO;    // Pontine reticular nucleus, oral - prepulse
    #Interneuron;       // Local inhibitory interneuron
    #ProjectionNeuron;  // Projects to motor nuclei
    #ModulatoryNeuron;  // Receives descending modulation
  };

  /// Reticular formation state
  public type ReticularFormation = {
    // Neurons
    neurons           : [ReticularNeuron];
    neuronCount       : Nat;
    
    // Population activity
    populationRate    : Float;          // Average firing rate
    populationSync    : Float;          // Population synchrony
    firingNeuronCount : Nat;            // Currently firing
    
    // Output
    totalOutput       : Float;          // Combined motor output
    outputConfidence  : Float;          // Confidence in output
    
    // Gain control
    globalGain        : Float;          // Global gain (affected by arousal)
    gainHistory       : [Float];        // Recent gain values
    
    // Lateral inhibition
    lateralInhibitionStrength : Float;  // Overall inhibition strength
    winnerTakeAllActive : Bool;         // WTA dynamics active
    
    // Descending modulation
    descendingInput   : Float;          // From higher brain areas
    amygdalaInput     : Float;          // From amygdala (fear)
    corticalInput     : Float;          // From cortex (cognitive)
    
    // Ascending output
    ascendingOutput   : Float;          // To higher areas (alerting)
    
    // Timing
    lastUpdateBeat    : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 5: TYPE DEFINITIONS — MOTOR SYSTEM
  // ══════════════════════════════════════════════════════════════════════════════

  /// Motor target muscle groups
  public type MotorTarget = {
    #Eyeblink;          // Orbicularis oculi - fastest (3 beats)
    #HeadRetraction;    // Neck muscles (5 beats)
    #ShoulderElevation; // Trapezius (6 beats)
    #ArmFlexion;        // Biceps (7 beats)
    #TrunkFlexion;      // Core muscles (8 beats)
    #LegFlexion;        // Knee flexion (10 beats)
    #GlobalPosture;     // Whole-body crouch (12 beats)
  };

  /// Motor pathway state
  public type MotorPathway = {
    // Identity
    pathwayId         : Nat;
    targetMuscleGroup : MotorTarget;
    
    // Activation
    activationLevel   : Float;          // 0-1 activation
    targetActivation  : Float;          // Target activation level
    peakActivation    : Float;          // Peak achieved
    
    // Timing
    latency           : Nat;            // Base latency for this muscle
    latencyRemaining  : Nat;            // Beats until response
    duration          : Nat;            // Response duration
    timeToTarget      : Nat;            // Beats to reach target
    
    // Response phase
    phase             : MotorPhase;
    peakReached       : Bool;           // Has peak been reached
    peakTime          : Nat;            // When peak was reached
    
    // Dynamics
    riseRate          : Float;          // How fast activation rises
    decayRate         : Float;          // How fast it decays
    sustainLevel      : Float;          // Sustained activation level
    
    // Inhibition
    inhibitionLevel   : Float;          // Current inhibition
    inhibitionSource  : ?MotorTarget;   // Source of inhibition
    
    // EMG-like properties
    emgAmplitude      : Float;          // EMG signal amplitude
    emgFrequency      : Float;          // EMG frequency
    
    // History
    activationHistory : [Float];        // Last 20 values
    historyIndex      : Nat;
  };

  /// Motor response phase
  public type MotorPhase = {
    #Idle;              // No activation
    #Latency;           // Waiting for latency
    #Rising;            // Activation rising
    #Peak;              // At peak
    #Plateau;           // Sustained
    #Decay;             // Decaying
    #Recovery;          // Post-response recovery
  };

  /// Complete motor output state
  public type MotorOutput = {
    // Pathways
    pathways          : [MotorPathway];
    
    // Global state
    totalActivation   : Float;          // Sum of all pathways
    dominantTarget    : ?MotorTarget;   // Most active target
    
    // Pattern
    patternType       : StartlePattern;
    patternStrength   : Float;
    patternCoherence  : Float;
    
    // Timing
    overallLatency    : Nat;            // Earliest response
    overallDuration   : Nat;            // Total response duration
    
    // History
    lastResponseBeat  : Nat;
    totalResponses    : Nat;
  };

  /// Startle motor pattern types
  public type StartlePattern = {
    #None;              // No startle
    #EyeblinkOnly;      // Minimal startle
    #HeadAndShoulder;   // Moderate startle
    #UpperBody;         // Strong startle
    #WholeBody;         // Maximum startle
    #Protective;        // Defensive pattern
    #Orienting;         // Orienting pattern (different from startle)
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 6: TYPE DEFINITIONS — MODULATORY SYSTEMS
  // ══════════════════════════════════════════════════════════════════════════════

  /// Prepulse inhibition state
  public type PPIState = {
    // Prepulse detection
    prepulseDetected  : Bool;           // Was a prepulse detected
    prepulseTime      : Nat;            // When prepulse occurred
    prepulseIntensity : Float;          // Intensity of prepulse
    prepulseModality  : ?StartleModality; // Which modality
    
    // Inhibition computation
    leadTimeMs        : Float;          // Time between prepulse and pulse
    inhibitionLevel   : Float;          // Current PPI level (0-1)
    maxInhibition     : Float;          // Maximum possible inhibition
    
    // Individual variation
    ppiEfficiency     : Float;          // Individual PPI efficiency (0.5-0.9)
    ppiVariability    : Float;          // Trial-to-trial variability
    
    // Window parameters
    optimalLeadTime   : Float;          // Optimal prepulse lead (100ms)
    windowSigma       : Float;          // Gaussian width
    windowMin         : Float;          // Minimum effective lead
    windowMax         : Float;          // Maximum effective lead
    
    // Modulation
    dopamineModulation : Float;         // DA affects PPI
    attentionModulation : Float;        // Attention affects PPI
    
    // History
    ppiHistory        : [Float];        // Last 20 PPI values
    averagePPI        : Float;          // Running average
    
    // Clinical relevance
    ppiDeficit        : Bool;           // PPI deficit detected
    deficitSeverity   : Float;          // Severity of deficit
  };

  /// Fear potentiation state
  public type FearPotentiationState = {
    // Fear sources
    cuedFear          : Float;          // Fear from specific cue (0-1)
    contextualFear    : Float;          // Fear from context (0-1)
    innateFeear       : Float;          // Innate fear (predator, etc.)
    learnedFear       : Float;          // Conditioned fear
    
    // Neural substrates
    amygdalaActivation : Float;         // Central amygdala (CeA)
    basalAmygdala     : Float;          // Basal amygdala
    lateralAmygdala   : Float;          // Lateral amygdala
    bedNucleusSTActivation : Float;     // BNST (sustained anxiety)
    
    // Potentiation computation
    totalPotentiation : Float;          // Combined potentiation (1.0-2.5)
    potentiationHistory : [Float];      // Recent values
    
    // Modulation
    cortModulation    : Float;          // Cortisol amplifies fear
    serotoninModulation : Float;        // 5-HT modulates fear
    
    // Temporal dynamics
    fearOnsetTime     : Nat;            // When fear started
    fearDuration      : Nat;            // How long fear active
    fearDecayRate     : Float;          // Current decay rate
    lastFearUpdate    : Nat;
    
    // Conditioning
    csIntensity       : Float;          // Conditioned stimulus
    usIntensity       : Float;          // Unconditioned stimulus
    csUsInterval      : Nat;            // CS-US interval
    
    // Extinction
    extinctionProgress : Float;         // Progress toward extinction
    extinctionTrials  : Nat;            // Extinction trials
    extinctionResistance : Float;       // Resistance to extinction
    
    // Safety signals
    safetySignalPresent : Bool;         // Safety signal detected
    safetyInhibition  : Float;          // Inhibition from safety
  };

  /// Habituation state
  public type HabituationState = {
    // Multi-timescale habituation
    shortTermHabituation : Float;       // Fast (seconds-minutes)
    mediumTermHabituation : Float;      // Medium (minutes-hours)
    longTermHabituation : Float;        // Slow (hours-days)
    totalHabituation  : Float;          // Combined
    
    // Trial tracking
    habituationTrials : Nat;            // Number of startle trials
    trialsSinceRecovery : Nat;          // Trials since last recovery
    interTrialInterval : Float;         // Average inter-trial interval
    
    // Time constants
    tauShortTerm      : Float;          // ST time constant
    tauMediumTerm     : Float;          // MT time constant
    tauLongTerm       : Float;          // LT time constant
    tauRecovery       : Float;          // Recovery time constant
    
    // Recovery
    recoveryProgress  : Float;          // Progress toward recovery
    lastStartleBeat   : Nat;            // When last startle occurred
    timeSinceStartle  : Nat;            // Beats since last startle
    
    // Dishabituation
    dishabituationReady : Bool;         // Can be dishabituated
    dishabituationThreshold : Float;    // Threshold for dishabituation
    lastDishabituation : Nat;           // When last dishabituated
    
    // Stimulus specificity
    stimulusSpecific  : Bool;           // Is habituation stimulus-specific
    stimulusMemory    : [Float];        // Memory of recent stimuli
    
    // Modulation
    arousalModulation : Float;          // Arousal affects habituation
    sleepModulation   : Float;          // Sleep affects habituation
  };

  /// Sensitization state
  public type SensitizationState = {
    // Multi-timescale sensitization
    acuteSensitization : Float;         // Immediate (seconds)
    sustainedSensitization : Float;     // Prolonged (minutes-hours)
    chronicSensitization : Float;       // Long-lasting (days+)
    totalSensitization : Float;         // Combined
    
    // Threat tracking
    threatExposure    : Float;          // Cumulative threat exposure
    threatIntensity   : Float;          // Current threat level
    threatDuration    : Nat;            // Duration of threat
    lastThreatBeat    : Nat;            // When last threat
    
    // Time constants
    tauAcute          : Float;          // Acute decay constant
    tauSustained      : Float;          // Sustained decay constant
    tauChronic        : Float;          // Chronic decay constant
    
    // Peak tracking
    peakSensitization : Float;          // Peak level reached
    peakTime          : Nat;            // When peak occurred
    
    // Neural mechanisms
    locusCoeruleusActivation : Float;   // LC drives sensitization
    centralAmygdalaActivation : Float;  // CeA contributes
    
    // Stress hormones
    cortLevel         : Float;          // Cortisol level
    neLevel           : Float;          // Norepinephrine level
    crhLevel          : Float;          // CRH level
    
    // Context
    contextualSensitization : Float;    // Context-specific
    generalizedSensitization : Float;   // Generalized
    
    // Modulation
    sleepDeprivation  : Float;          // Sleep deprivation increases
    priorTrauma       : Float;          // Prior trauma increases
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 7: TYPE DEFINITIONS — ORGANISM INTEGRATION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Shell 3 stimulation pattern
  public type Shell3Stimulation = {
    // Cluster stimulations
    threatClusterStim : [Float];        // Nodes 20-27
    motorClusterStim  : [Float];        // Nodes 10-17
    arousalClusterStim : [Float];       // Nodes 0-7
    integrationClusterStim : [Float];   // Nodes 56-63
    
    // Global effects
    globalStimulation : Float;          // Overall Shell 3 stim
    globalInhibition  : Float;          // Overall inhibition
    
    // Phase effects
    phaseReset        : Bool;           // Reset Kuramoto phases
    phasePerturbation : Float;          // Phase perturbation amount
    
    // Coherence effects
    coherenceTarget   : Float;          // Target coherence
    coherenceUrgency  : Float;          // How urgently to reach target
  };

  /// Hz spectrum activation pattern
  public type HzSpectrumActivation = {
    // Node activations (delta from baseline)
    nodeActivations   : [Float];        // All 64 nodes
    
    // Key node effects
    rasLocusBoost     : Float;          // Node 16 - arousal
    amygdalaRiftBoost : Float;          // Node 21 - threat
    medullaPulseBoost : Float;          // Node 11 - vital rhythm
    thalamicRelaySuppress : Float;      // Node 9 - sensory gate
    cerebellumExecBoost : Float;        // Node 10 - motor precision
    frontalApexSuppress : Float;        // Node 19 - executive suppress
    
    // Tier effects
    tier1Effect       : Float;          // Foundation nodes
    tier2Effect       : Float;          // Cognitive nodes
    tier3Effect       : Float;          // Expression nodes
    tier4Effect       : Float;          // Carrier nodes
  };

  /// Quantum operator effects
  public type QuantumOperatorEffects = {
    // PARALLAX - 5-path evaluation
    parallaxCompression : Float;        // Path evaluation compression
    parallaxUrgency   : Float;          // Decision urgency
    
    // CHRONO - temporal precision
    chronoBoost       : Float;          // Fisher information boost
    temporalResolution : Float;         // Enhanced temporal precision
    
    // QMEM - memory fidelity
    qmemSalienceSpike : Float;          // High-salience encoding
    qmemFidelityBoost : Float;          // Memory fidelity boost
    
    // ENTANGLA - correlation
    entanglaDisruption : Float;         // Correlation disruption
    
    // BYPASS - decision
    bypassTemperature : Float;          // Annealing temperature shift
    bypassUrgency     : Float;          // Decision urgency
    
    // VERITAS - error correction
    veritasAlert      : Float;          // Error detection alert
    
    // RESONEX - collective
    resonexDisruption : Float;          // Collective disruption
    
    // QSOV - sovereignty
    qsovImpact        : Float;          // Sovereignty impact
  };

  /// Neurochemical injection pattern
  public type NeurochemicalInjection = {
    // Fast signaling
    neInjection       : Float;          // Norepinephrine
    adrenalineInjection : Float;        // Adrenaline
    gluInjection      : Float;          // Glutamate
    subpInjection     : Float;          // Substance P
    
    // Medium signaling
    cortInjection     : Float;          // Cortisol
    daModulation      : Float;          // Dopamine (usually suppressed)
    gabaInjection     : Float;          // GABA (rebound)
    achModulation     : Float;          // Acetylcholine
    
    // Slow signaling
    serotonin5htModulation : Float;     // Serotonin
    
    // All 21 chemicals (indexed)
    allInjections     : [Float];        // Delta for all 21
  };

  /// VETUS threat vector escalation
  public type VetusThreatEscalation = {
    // Individual vectors
    v1Escalation      : Float;          // External threat
    v6Escalation      : Float;          // Prediction error
    v10Escalation     : Float;          // Sovereignty
    
    // All 10 vectors
    allEscalations    : [Float];
    
    // Trigger check
    triggersAresRollback : Bool;        // Should trigger ARES?
    aresRollbackVector : ?Nat;          // Which vector triggered
  };

  /// AEGIS membrane effects
  public type AegisMembraneEffects = {
    // Strand effects (indexed 0-6)
    strandEffects     : [Float];        // Delta for each strand
    
    // Key strands
    sovereigntyBoost  : Float;          // Strand 0 - successful defense
    coherenceDip      : Float;          // Strand 1 - processing disruption
    emergenceDip      : Float;          // Strand 2 - emergence disruption
    memoryBoost       : Float;          // Strand 3 - high-salience encoding
    temporalBoost     : Float;          // Strand 5 - temporal precision
    quantumBoost      : Float;          // Strand 6 - quantum activation
    
    // Membrane overall
    membranePerturbation : Float;       // Overall perturbation
    suppressionRisk   : Bool;           // Risk of AEGIS suppression
  };

  /// Drive modulation pattern
  public type DriveModulation = {
    // Individual drives (indexed 0-9)
    driveDeltas       : [Float];        // Delta for each drive
    
    // Key drives
    threatResponseBoost : Float;        // Drive 0
    bodyIntegrityBoost : Float;         // Drive 1
    explorationSuppress : Float;        // Drive 2
    socialSuppress    : Float;          // Drive 3
    goalPursuitSuppress : Float;        // Drive 4
    energyConservationBoost : Float;    // Drive 5
    curiositySuppress : Float;          // Drive 6
    
    // Mode effects
    forcedMode        : ?Text;          // Force specific mode (Q_EMERGENCY)
    modeUrgency       : Float;          // How urgently to switch
  };

  /// Council organism effects
  public type CouncilEffects = {
    // Individual councils
    cognusEffect      : Float;          // Cognitive disruption
    nexusEffect       : Float;          // Social field disruption
    aurumEffect       : Float;          // Economic impact
    lexisEffect       : Float;          // Doctrine check
    solusEffect       : Float;          // Spawning pause
    vetusEffect       : Float;          // Threat amplification
    meridianEffect    : Float;          // Template update
    
    // Token minting effects
    mintingPaused     : Bool;           // Pause token minting
    formaRateImpact   : Float;          // Impact on FORMA rate
  };

  /// Animal trait modulation
  public type AnimalTraitModulation = {
    // Predator traits
    predatorSuppression : Float;        // Suppress predatory traits
    
    // Prey traits
    preyEscapeBoost   : Float;          // Boost escape traits
    
    // Specific animals
    tardigradeActivation : Float;       // Cryptobiosis trigger
    octopusArmFreeze  : Float;          // Arm coordination disruption
    dolphinHemisphereAlert : Float;     // Wake both hemispheres
    wolfPackAlert     : Float;          // Pack coordination
    
    // All 22 animals
    animalModulations : [Float];
  };

  /// Memory write event
  public type StartleMemoryEvent = {
    // Timing
    beatOccurred      : Nat;
    timestamp         : Int;            // Wall clock time
    
    // Stimulus
    stimulusIntensity : Float;
    stimulusModality  : StartleModality;
    stimulusLocation  : (Float, Float, Float);
    
    // Response
    responseMagnitude : Float;
    responseLatency   : Nat;
    responsePattern   : StartlePattern;
    
    // Modulation state
    habituationAtTime : Float;
    sensitizationAtTime : Float;
    fearPotentiationAtTime : Float;
    ppiActiveAtTime   : Bool;
    
    // Context
    threatLevelAtTime : Float;
    arousalAtTime     : Float;
    coherenceAtTime   : Float;
    
    // Salience
    salience          : Float;
    emotionalCharge   : Float;
    memoryPriority    : Float;
    
    // Outcome
    pipelineSkipped   : Bool;
    emergencyModeForced : Bool;
    expressionSuppressed : Bool;
  };

  /// Complete startle response record
  public type StartleResponse = {
    // Core response
    magnitude         : Float;          // Overall startle magnitude (0-1)
    latency           : Nat;            // Response latency in beats
    duration          : Nat;            // Response duration in beats
    peakTime          : Nat;            // Time of peak response
    
    // Stimulus info
    modalityTriggered : StartleModality;
    stimulusIntensity : Float;
    stimulusRiseTime  : Float;
    
    // Motor pattern
    motorPatternActivated : [MotorTarget];
    motorPatternType  : StartlePattern;
    
    // Modulation
    habituationApplied : Float;
    sensitizationApplied : Float;
    fearPotentiationApplied : Float;
    ppiApplied        : Float;
    
    // Modulation flags
    wasInhibited      : Bool;           // Was PPI active
    wasPotentiated    : Bool;           // Was fear-potentiated
    wasSensitized     : Bool;           // Was sensitized
    wasHabituated     : Bool;           // Was habituated
    
    // Organism effects
    pipelineSkipped   : Bool;
    emergencyModeForced : Bool;
    expressionSuppressed : Bool;
    
    // Integration outputs
    shell3Stimulation : Shell3Stimulation;
    hzActivation      : HzSpectrumActivation;
    quantumEffects    : QuantumOperatorEffects;
    neurochemicalInjection : NeurochemicalInjection;
    vetusThreatEscalation : VetusThreatEscalation;
    aegisEffects      : AegisMembraneEffects;
    driveModulation   : DriveModulation;
    councilEffects    : CouncilEffects;
    animalModulation  : AnimalTraitModulation;
    
    // Memory
    memoryEvent       : StartleMemoryEvent;
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 8: MASTER STATE TYPE — COMPLETE STARTLE SYSTEM
  // ══════════════════════════════════════════════════════════════════════════════

  /// Processing phase of startle system
  public type StartlePhase = {
    #Idle;                              // Waiting for input
    #SensoryDetection;                  // Processing sensory input
    #PrepulseDetection;                 // Checking for prepulse
    #ReticularIntegration;              // Reticular formation processing
    #ModulationComputation;             // Computing all modulations
    #MagnitudeComputation;              // Computing final magnitude
    #MotorPreparation;                  // Preparing motor output
    #MotorExecution;                    // Executing startle response
    #OrganismIntegration;               // Integrating with organism
    #MemoryWrite;                       // Writing to memory
    #Recovery;                          // Post-startle recovery
  };

  /// Complete startle system state
  public type StartleSystemState = {
    // ══════════════════════════════════════════════════════════════════════════
    // CORE SYSTEM STATE
    // ══════════════════════════════════════════════════════════════════════════
    
    // System status
    isActive          : Bool;           // Startle system active
    isInitialized     : Bool;           // System initialized
    currentPhase      : StartlePhase;   // Current processing phase
    
    // Timing
    beatNum           : Nat;            // Current beat number
    lastStartleBeat   : Nat;            // Beat of last startle
    refractoryRemaining : Nat;          // Remaining refractory beats
    systemUptime      : Nat;            // Total beats since init
    
    // ══════════════════════════════════════════════════════════════════════════
    // SENSORY SYSTEM
    // ══════════════════════════════════════════════════════════════════════════
    
    // Sensory channels (8 channels)
    sensoryChannels   : [SensoryChannel];
    sensoryIntegration : SensoryIntegration;
    
    // Integrated sensory state
    integratedInput   : Float;          // Combined sensory input
    dominantModality  : ?StartleModality;
    sensoryConfidence : Float;          // Confidence in sensory detection
    
    // ══════════════════════════════════════════════════════════════════════════
    // RETICULAR FORMATION
    // ══════════════════════════════════════════════════════════════════════════
    
    // Reticular state
    reticularFormation : ReticularFormation;
    reticularOutput   : Float;          // Total reticular output
    reticularConfidence : Float;        // Confidence in output
    
    // ══════════════════════════════════════════════════════════════════════════
    // MOTOR SYSTEM
    // ══════════════════════════════════════════════════════════════════════════
    
    // Motor state
    motorOutput       : MotorOutput;
    motorCommandPending : Bool;         // Motor command waiting
    motorPattern      : StartlePattern; // Current pattern
    
    // ══════════════════════════════════════════════════════════════════════════
    // MODULATORY SYSTEMS
    // ══════════════════════════════════════════════════════════════════════════
    
    // Prepulse inhibition
    ppi               : PPIState;
    
    // Fear potentiation
    fearPotentiation  : FearPotentiationState;
    
    // Habituation
    habituation       : HabituationState;
    
    // Sensitization
    sensitization     : SensitizationState;
    
    // ══════════════════════════════════════════════════════════════════════════
    // CURRENT RESPONSE
    // ══════════════════════════════════════════════════════════════════════════
    
    currentResponse   : ?StartleResponse;
    lastResponse      : ?StartleResponse;
    
    // ══════════════════════════════════════════════════════════════════════════
    // HISTORY AND STATISTICS
    // ══════════════════════════════════════════════════════════════════════════
    
    // Event history (last 100 events)
    eventHistory      : [StartleMemoryEvent];
    historyMaxSize    : Nat;
    
    // Statistics
    totalStartleCount : Nat;            // Lifetime startle count
    averageMagnitude  : Float;          // Running average magnitude
    averageLatency    : Float;          // Running average latency
    magnitudeVariance : Float;          // Magnitude variance
    
    // Recent statistics (last 20)
    recentMagnitudes  : [Float];
    recentLatencies   : [Float];
    recentModalities  : [StartleModality];
    
    // ══════════════════════════════════════════════════════════════════════════
    // ORGANISM INTEGRATION FLAGS
    // ══════════════════════════════════════════════════════════════════════════
    
    // Pipeline control
    skipFullPipeline  : Bool;           // Short-circuit flag
    forceEmergencyMode : Bool;          // Force Q_EMERGENCY
    suppressExpression : Bool;          // Block expression
    
    // Integration requests
    pendingShell3Stim : ?Shell3Stimulation;
    pendingHzActivation : ?HzSpectrumActivation;
    pendingQuantumEffects : ?QuantumOperatorEffects;
    pendingNeurochemicals : ?NeurochemicalInjection;
    pendingVetusEscalation : ?VetusThreatEscalation;
    pendingAegisEffects : ?AegisMembraneEffects;
    pendingDriveModulation : ?DriveModulation;
    pendingCouncilEffects : ?CouncilEffects;
    pendingAnimalModulation : ?AnimalTraitModulation;
    pendingMemoryWrite : ?StartleMemoryEvent;
    
    // ══════════════════════════════════════════════════════════════════════════
    // EXTERNAL INPUTS (updated each beat from organism state)
    // ══════════════════════════════════════════════════════════════════════════
    
    // From interoCore
    currentArousal    : Float;
    currentFatigue    : Float;
    currentDamage     : Float;
    currentOverload   : Float;
    
    // From agent model
    currentAgentThreat : Float;
    currentContextThreat : Float;
    
    // From immune system
    currentImmuneActivation : Float;
    currentImmuneThreatMemory : Float;
    
    // From neurochemical layer
    currentNE         : Float;
    currentCORT       : Float;
    currentDA         : Float;
    current5HT        : Float;
    
    // From Shell 3
    currentShell3Mean : Float;
    currentKfEng      : Float;          // Kuramoto order parameter
    
    // From Hz spectrum
    currentHzAct      : [Float];        // All 64 Hz activations
    
    // ══════════════════════════════════════════════════════════════════════════
    // CONFIGURATION
    // ══════════════════════════════════════════════════════════════════════════
    
    // Enable/disable features
    enablePPI         : Bool;
    enableFearPotentiation : Bool;
    enableHabituation : Bool;
    enableSensitization : Bool;
    enableOrganismIntegration : Bool;
    
    // Tuning parameters
    globalSensitivity : Float;          // Overall sensitivity (0.5-2.0)
    globalThresholdBias : Float;        // Threshold adjustment
    globalGainBias    : Float;          // Gain adjustment
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 9: INITIALIZATION FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════════

  /// Initialize a single sensory channel
  public func initSensoryChannel(modality: StartleModality, channelId: Nat) : SensoryChannel {
    let (threshold, latency, freqBand) = switch (modality) {
      case (#Acoustic) { (THRESHOLD_ACOUSTIC, STARTLE_LATENCY_ACOUSTIC, #Gamma) };
      case (#Tactile) { (THRESHOLD_TACTILE, STARTLE_LATENCY_TACTILE, #Beta) };
      case (#Vestibular) { (THRESHOLD_VESTIBULAR, STARTLE_LATENCY_VESTIBULAR, #Alpha) };
      case (#Visual) { (THRESHOLD_VISUAL, STARTLE_LATENCY_VISUAL, #Beta) };
      case (#Trigeminal) { (THRESHOLD_TRIGEMINAL, STARTLE_LATENCY_ACOUSTIC, #Gamma) };
      case (#MultiModal) { (0.50, STARTLE_LATENCY_ACOUSTIC, #HighGamma) };
      case (#Proprioceptive) { (0.70, 10, #Alpha) };
      case (#Nociceptive) { (0.60, 8, #Beta) };
    };
    
    {
      modality = modality;
      channelId = channelId;
      rawInput = 0.0;
      currentIntensity = 0.0;
      peakIntensity = 0.0;
      riseRate = 0.0;
      threshold = threshold;
      baseThreshold = threshold;
      adaptiveThreshold = threshold;
      gain = 1.0;
      adaptation = 0.0;
      adaptationTau = 100.0;
      latency = latency;
      duration = 50;
      lastActivation = 0;
      activationCount = 0;
      frequencyBand = freqBand;
      frequencyPower = 0.5;
      crossModalGain = Array.tabulate<Float>(8, func(_) { 1.0 });
      crossModalInhibit = Array.tabulate<Float>(8, func(_) { 0.0 });
      recentHistory = Array.tabulate<Float>(10, func(_) { 0.0 });
      historyIndex = 0;
    }
  };

  /// Initialize all sensory channels
  public func initAllSensoryChannels() : [SensoryChannel] {
    let modalities : [StartleModality] = [
      #Acoustic, #Tactile, #Vestibular, #Visual,
      #Trigeminal, #MultiModal, #Proprioceptive, #Nociceptive
    ];
    
    Array.tabulate<SensoryChannel>(modalities.size(), func(i) {
      initSensoryChannel(modalities[i], i)
    })
  };

  /// Initialize sensory integration state
  public func initSensoryIntegration() : SensoryIntegration {
    {
      integratedIntensity = 0.0;
      dominantModality = null;
      activeChannelCount = 0;
      multiModalBonus = 0.0;
      riseTimeMs = 0.0;
      isRapidOnset = false;
      onsetBonus = 0.0;
      spatialCoherence = 1.0;
      spatialOrigin = (0.0, 0.0, 0.0);
      temporalCoherence = 1.0;
      interstimInterval = 1000.0;
      crossModalEnhancement = 0.0;
      startleEligible = false;
      startleProbability = 0.0;
    }
  };

  /// Initialize a single reticular neuron
  public func initReticularNeuron(neuronId: Nat) : ReticularNeuron {
    // Vary properties based on neuron ID for heterogeneity
    let neuronType : ReticularNeuronType = switch (neuronId % 5) {
      case 0 { #GiantNeuronPnC };
      case 1 { #GiantNeuronPnO };
      case 2 { #Interneuron };
      case 3 { #ProjectionNeuron };
      case _ { #ModulatoryNeuron };
    };
    
    let thresholdVar = RETICULAR_THRESHOLD_VAR * Float.fromInt(neuronId % 7) / 7.0;
    let outputVar = (RETICULAR_OUTPUT_WEIGHT_MAX - RETICULAR_OUTPUT_WEIGHT_MIN) * 
                    Float.fromInt((neuronId * 3) % 11) / 11.0;
    
    {
      neuronId = neuronId;
      neuronType = neuronType;
      membranePotential = 0.3;
      restingPotential = 0.3;
      threshold = RETICULAR_THRESHOLD_BASE + thresholdVar;
      resetPotential = 0.1;
      isFiring = false;
      firingRate = 0.0;
      lastSpikeTime = 0;
      spikeCount = 0;
      isRefractory = false;
      refractoryRemaining = 0;
      absoluteRefractory = 3;
      relativeRefractory = 5;
      inputWeights = Array.tabulate<Float>(8, func(i) {
        0.5 + Float.fromInt((neuronId + i) % 5) * 0.1
      });
      inputWeightsLearned = Array.tabulate<Float>(8, func(_) { 0.0 });
      lateralWeights = Array.tabulate<Float>(RETICULAR_NEURON_COUNT, func(j) {
        if (j == neuronId) { 0.0 }
        else { -0.1 - Float.fromInt((neuronId + j) % 3) * 0.05 }
      });
      lateralInhibition = 0.0;
      outputStrength = RETICULAR_OUTPUT_WEIGHT_MIN + outputVar;
      outputTarget = [neuronId % MOTOR_PATHWAY_COUNT];
      sensitization = 0.0;
      habituation = 0.0;
      arousalModulation = 1.0;
      burstMode = false;
      burstSpikesRemaining = 0;
      interBurstInterval = 20;
      neModulation = 1.0;
      achModulation = 1.0;
      daModulation = 1.0;
    }
  };

  /// Initialize reticular formation
  public func initReticularFormation() : ReticularFormation {
    {
      neurons = Array.tabulate<ReticularNeuron>(RETICULAR_NEURON_COUNT, initReticularNeuron);
      neuronCount = RETICULAR_NEURON_COUNT;
      populationRate = 0.0;
      populationSync = 0.0;
      firingNeuronCount = 0;
      totalOutput = 0.0;
      outputConfidence = 0.0;
      globalGain = RETICULAR_GAIN_BASE;
      gainHistory = Array.tabulate<Float>(10, func(_) { RETICULAR_GAIN_BASE });
      lateralInhibitionStrength = 0.5;
      winnerTakeAllActive = false;
      descendingInput = 0.0;
      amygdalaInput = 0.0;
      corticalInput = 0.0;
      ascendingOutput = 0.0;
      lastUpdateBeat = 0;
    }
  };

  /// Initialize motor pathway
  public func initMotorPathway(pathwayId: Nat) : MotorPathway {
    let targets : [MotorTarget] = [
      #Eyeblink, #HeadRetraction, #ShoulderElevation,
      #ArmFlexion, #TrunkFlexion, #LegFlexion, #GlobalPosture
    ];
    
    let target = if (pathwayId < targets.size()) { targets[pathwayId] } else { #GlobalPosture };
    
    let latency = switch (target) {
      case (#Eyeblink) { 3 };
      case (#HeadRetraction) { 5 };
      case (#ShoulderElevation) { 6 };
      case (#ArmFlexion) { 7 };
      case (#TrunkFlexion) { 8 };
      case (#LegFlexion) { 10 };
      case (#GlobalPosture) { 12 };
    };
    
    {
      pathwayId = pathwayId;
      targetMuscleGroup = target;
      activationLevel = 0.0;
      targetActivation = 0.0;
      peakActivation = 0.0;
      latency = latency;
      latencyRemaining = 0;
      duration = 50;
      timeToTarget = 5;
      phase = #Idle;
      peakReached = false;
      peakTime = 0;
      riseRate = 0.3;
      decayRate = MOTOR_DECAY_BASE + Float.fromInt(pathwayId) * MOTOR_DECAY_INCREMENT;
      sustainLevel = 0.0;
      inhibitionLevel = 0.0;
      inhibitionSource = null;
      emgAmplitude = 0.0;
      emgFrequency = 50.0;
      activationHistory = Array.tabulate<Float>(20, func(_) { 0.0 });
      historyIndex = 0;
    }
  };

  /// Initialize motor output system
  public func initMotorOutput() : MotorOutput {
    {
      pathways = Array.tabulate<MotorPathway>(MOTOR_PATHWAY_COUNT, initMotorPathway);
      totalActivation = 0.0;
      dominantTarget = null;
      patternType = #None;
      patternStrength = 0.0;
      patternCoherence = 1.0;
      overallLatency = 0;
      overallDuration = 0;
      lastResponseBeat = 0;
      totalResponses = 0;
    }
  };

  /// Initialize PPI state
  public func initPPIState() : PPIState {
    {
      prepulseDetected = false;
      prepulseTime = 0;
      prepulseIntensity = 0.0;
      prepulseModality = null;
      leadTimeMs = 0.0;
      inhibitionLevel = 0.0;
      maxInhibition = 0.8;
      ppiEfficiency = 0.7;
      ppiVariability = 0.1;
      optimalLeadTime = PPI_OPTIMAL_LEAD_TIME;
      windowSigma = PPI_WINDOW_SIGMA;
      windowMin = PPI_WINDOW_MIN;
      windowMax = PPI_WINDOW_MAX;
      dopamineModulation = 1.0;
      attentionModulation = 1.0;
      ppiHistory = Array.tabulate<Float>(20, func(_) { 0.0 });
      averagePPI = 0.0;
      ppiDeficit = false;
      deficitSeverity = 0.0;
    }
  };

  /// Initialize fear potentiation state
  public func initFearPotentiationState() : FearPotentiationState {
    {
      cuedFear = 0.0;
      contextualFear = 0.0;
      innateFeear = 0.0;
      learnedFear = 0.0;
      amygdalaActivation = 0.0;
      basalAmygdala = 0.0;
      lateralAmygdala = 0.0;
      bedNucleusSTActivation = 0.0;
      totalPotentiation = FEAR_POTENTIATION_MIN;
      potentiationHistory = Array.tabulate<Float>(20, func(_) { 1.0 });
      cortModulation = 0.0;
      serotoninModulation = 0.0;
      fearOnsetTime = 0;
      fearDuration = 0;
      fearDecayRate = FEAR_DECAY_RATE_CUED;
      lastFearUpdate = 0;
      csIntensity = 0.0;
      usIntensity = 0.0;
      csUsInterval = 0;
      extinctionProgress = 0.0;
      extinctionTrials = 0;
      extinctionResistance = 0.5;
      safetySignalPresent = false;
      safetyInhibition = 0.0;
    }
  };

  /// Initialize habituation state
  public func initHabituationState() : HabituationState {
    {
      shortTermHabituation = 0.0;
      mediumTermHabituation = 0.0;
      longTermHabituation = 0.0;
      totalHabituation = 0.0;
      habituationTrials = 0;
      trialsSinceRecovery = 0;
      interTrialInterval = 1000.0;
      tauShortTerm = HABITUATION_TAU_ST;
      tauMediumTerm = 200.0;
      tauLongTerm = HABITUATION_TAU_LT;
      tauRecovery = HABITUATION_RECOVERY_TAU;
      recoveryProgress = 1.0;
      lastStartleBeat = 0;
      timeSinceStartle = 0;
      dishabituationReady = true;
      dishabituationThreshold = DISHABITUATION_THRESHOLD;
      lastDishabituation = 0;
      stimulusSpecific = true;
      stimulusMemory = Array.tabulate<Float>(10, func(_) { 0.0 });
      arousalModulation = 1.0;
      sleepModulation = 1.0;
    }
  };

  /// Initialize sensitization state
  public func initSensitizationState() : SensitizationState {
    {
      acuteSensitization = 0.0;
      sustainedSensitization = 0.0;
      chronicSensitization = 0.0;
      totalSensitization = 0.0;
      threatExposure = 0.0;
      threatIntensity = 0.0;
      threatDuration = 0;
      lastThreatBeat = 0;
      tauAcute = SENSITIZATION_TAU;
      tauSustained = 500.0;
      tauChronic = 5000.0;
      peakSensitization = 0.0;
      peakTime = 0;
      locusCoeruleusActivation = 0.0;
      centralAmygdalaActivation = 0.0;
      cortLevel = 0.0;
      neLevel = 0.0;
      crhLevel = 0.0;
      contextualSensitization = 0.0;
      generalizedSensitization = 0.0;
      sleepDeprivation = 0.0;
      priorTrauma = 0.0;
    }
  };

  /// Initialize complete startle system state
  public func initStartleSystemState() : StartleSystemState {
    {
      // Core system state
      isActive = true;
      isInitialized = true;
      currentPhase = #Idle;
      beatNum = 0;
      lastStartleBeat = 0;
      refractoryRemaining = 0;
      systemUptime = 0;
      
      // Sensory system
      sensoryChannels = initAllSensoryChannels();
      sensoryIntegration = initSensoryIntegration();
      integratedInput = 0.0;
      dominantModality = null;
      sensoryConfidence = 0.0;
      
      // Reticular formation
      reticularFormation = initReticularFormation();
      reticularOutput = 0.0;
      reticularConfidence = 0.0;
      
      // Motor system
      motorOutput = initMotorOutput();
      motorCommandPending = false;
      motorPattern = #None;
      
      // Modulatory systems
      ppi = initPPIState();
      fearPotentiation = initFearPotentiationState();
      habituation = initHabituationState();
      sensitization = initSensitizationState();
      
      // Current response
      currentResponse = null;
      lastResponse = null;
      
      // History and statistics
      eventHistory = [];
      historyMaxSize = 100;
      totalStartleCount = 0;
      averageMagnitude = 0.0;
      averageLatency = 0.0;
      magnitudeVariance = 0.0;
      recentMagnitudes = [];
      recentLatencies = [];
      recentModalities = [];
      
      // Organism integration flags
      skipFullPipeline = false;
      forceEmergencyMode = false;
      suppressExpression = false;
      
      // Integration requests
      pendingShell3Stim = null;
      pendingHzActivation = null;
      pendingQuantumEffects = null;
      pendingNeurochemicals = null;
      pendingVetusEscalation = null;
      pendingAegisEffects = null;
      pendingDriveModulation = null;
      pendingCouncilEffects = null;
      pendingAnimalModulation = null;
      pendingMemoryWrite = null;
      
      // External inputs
      currentArousal = 0.5;
      currentFatigue = 0.0;
      currentDamage = 0.0;
      currentOverload = 0.0;
      currentAgentThreat = 0.0;
      currentContextThreat = 0.0;
      currentImmuneActivation = 0.0;
      currentImmuneThreatMemory = 0.0;
      currentNE = 0.5;
      currentCORT = 0.3;
      currentDA = 0.5;
      current5HT = 0.5;
      currentShell3Mean = 1.0;
      currentKfEng = 0.5;
      currentHzAct = Array.tabulate<Float>(64, func(_) { 0.5 });
      
      // Configuration
      enablePPI = true;
      enableFearPotentiation = true;
      enableHabituation = true;
      enableSensitization = true;
      enableOrganismIntegration = true;
      globalSensitivity = 1.0;
      globalThresholdBias = 0.0;
      globalGainBias = 0.0;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 10: SENSORY PROCESSING FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════════

  /// Update a single sensory channel with new input
  public func updateSensoryChannel(
    channel: SensoryChannel,
    input: Float,
    currentBeat: Nat,
    globalSensitivity: Float,
    globalThresholdBias: Float
  ) : SensoryChannel {
    // Store previous intensity for rise rate calculation
    let prevIntensity = channel.currentIntensity;
    
    // Apply adaptation (sensory fatigue for sustained stimuli)
    let adaptedInput = input * (1.0 - channel.adaptation);
    
    // Apply channel gain and global sensitivity
    let gainedInput = adaptedInput * channel.gain * globalSensitivity;
    
    // Compute rise rate (important for startle - rapid onset is more startling)
    let riseRate = gainedInput - prevIntensity;
    
    // Update peak if new high
    let newPeak = if (gainedInput > channel.peakIntensity) { gainedInput } 
                  else { channel.peakIntensity * 0.99 }; // Slow decay of peak
    
    // Update adaptation
    let targetAdaptation = if (input > 0.3) {
      fclamp(channel.adaptation + SENSORY_ADAPTATION_RATE, 0.0, SENSORY_ADAPTATION_MAX)
    } else {
      fclamp(channel.adaptation - SENSORY_ADAPTATION_DECAY, 0.0, SENSORY_ADAPTATION_MAX)
    };
    
    // Adaptive threshold (rises with repeated activation)
    let newAdaptiveThreshold = channel.adaptiveThreshold * 0.99 + channel.baseThreshold * 0.01;
    
    // Effective threshold with global bias
    let effectiveThreshold = newAdaptiveThreshold + globalThresholdBias;
    
    // Check activation
    let isActivated = gainedInput > effectiveThreshold;
    let newActivationCount = if (isActivated) { channel.activationCount + 1 } else { channel.activationCount };
    let newLastActivation = if (isActivated) { currentBeat } else { channel.lastActivation };
    
    // Update history ring buffer
    let newHistory = Array.tabulate<Float>(10, func(i) {
      if (i == channel.historyIndex) { gainedInput }
      else { channel.recentHistory[i] }
    });
    let newHistoryIndex = (channel.historyIndex + 1) % 10;
    
    {
      modality = channel.modality;
      channelId = channel.channelId;
      rawInput = input;
      currentIntensity = fclamp(gainedInput, 0.0, 1.0);
      peakIntensity = newPeak;
      riseRate = riseRate;
      threshold = effectiveThreshold;
      baseThreshold = channel.baseThreshold;
      adaptiveThreshold = newAdaptiveThreshold;
      gain = channel.gain;
      adaptation = targetAdaptation;
      adaptationTau = channel.adaptationTau;
      latency = channel.latency;
      duration = channel.duration;
      lastActivation = newLastActivation;
      activationCount = newActivationCount;
      frequencyBand = channel.frequencyBand;
      frequencyPower = channel.frequencyPower;
      crossModalGain = channel.crossModalGain;
      crossModalInhibit = channel.crossModalInhibit;
      recentHistory = newHistory;
      historyIndex = newHistoryIndex;
    }
  };

  /// Integrate all sensory channels into unified signal
  public func integrateSensoryChannels(
    channels: [SensoryChannel],
    lastIntegration: SensoryIntegration,
    currentBeat: Nat
  ) : SensoryIntegration {
    var maxIntensity : Float = 0.0;
    var dominantModality : ?StartleModality = null;
    var activeCount : Nat = 0;
    var sumIntensity : Float = 0.0;
    var maxRiseRate : Float = 0.0;
    
    // First pass: find active channels and max values
    for (channel in channels.vals()) {
      if (channel.currentIntensity > channel.threshold) {
        activeCount += 1;
        sumIntensity += channel.currentIntensity;
        
        if (channel.currentIntensity > maxIntensity) {
          maxIntensity := channel.currentIntensity;
          dominantModality := ?channel.modality;
        };
        
        if (channel.riseRate > maxRiseRate) {
          maxRiseRate := channel.riseRate;
        };
      };
    };
    
    // Multi-modal summation bonus (more channels = stronger startle)
    let multiModalBonus = if (activeCount > 1) {
      MULTIMODAL_BONUS_PER_CHANNEL * Float.fromInt(activeCount - 1)
    } else { 0.0 };
    
    // Rapid onset bonus (fast rise rate = more startling)
    let isRapidOnset = maxRiseRate > 0.3;
    let onsetBonus = if (isRapidOnset) { maxRiseRate * 0.2 } else { 0.0 };
    
    // Cross-modal enhancement
    let crossModalEnhancement = if (activeCount > 2) {
      0.15 * (sumIntensity / Float.fromInt(activeCount))
    } else { 0.0 };
    
    // Integrated intensity
    let integrated = fclamp(
      maxIntensity + multiModalBonus + onsetBonus + crossModalEnhancement,
      0.0, 1.0
    );
    
    // Update dominant modality if multiple strong channels
    let finalModality = if (activeCount > 2) {
      ?#MultiModal
    } else {
      dominantModality
    };
    
    // Compute inter-stimulus interval
    let isi = Float.fromInt(currentBeat - lastIntegration.interstimInterval : Int);
    
    // Startle eligibility
    let startleThreshold = 0.65;
    let startleEligible = integrated > startleThreshold;
    
    // Startle probability (higher for sudden, intense, multimodal)
    let startleProbability = if (startleEligible) {
      let baseProb = logistic(integrated, 4.0, startleThreshold);
      let onsetMod = if (isRapidOnset) { 1.2 } else { 1.0 };
      let multiMod = 1.0 + Float.fromInt(activeCount) * 0.1;
      fclamp(baseProb * onsetMod * multiMod, 0.0, 1.0)
    } else { 0.0 };
    
    {
      integratedIntensity = integrated;
      dominantModality = finalModality;
      activeChannelCount = activeCount;
      multiModalBonus = multiModalBonus;
      riseTimeMs = if (maxRiseRate > 0.0) { 1.0 / maxRiseRate } else { 1000.0 };
      isRapidOnset = isRapidOnset;
      onsetBonus = onsetBonus;
      spatialCoherence = 1.0;  // Simplified for now
      spatialOrigin = (0.0, 0.0, 0.0);
      temporalCoherence = 1.0;
      interstimInterval = Float.fromInt(currentBeat);
      crossModalEnhancement = crossModalEnhancement;
      startleEligible = startleEligible;
      startleProbability = startleProbability;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 11: RETICULAR FORMATION PROCESSING
  // ══════════════════════════════════════════════════════════════════════════════

  /// Update single reticular neuron
  public func updateReticularNeuron(
    neuron: ReticularNeuron,
    sensoryInputs: [Float],
    lateralInputs: [Float],
    globalGain: Float,
    sensitization: Float,
    habituation: Float,
    arousal: Float
  ) : ReticularNeuron {
    // Check refractory period
    if (neuron.isRefractory) {
      let newRefrac = if (neuron.refractoryRemaining > 0) { 
        neuron.refractoryRemaining - 1 
      } else { 0 };
      
      if (newRefrac == 0) {
        return {
          neuron with
          isRefractory = false;
          refractoryRemaining = 0;
          firingRate = neuron.firingRate * 0.5;
        };
      } else {
        return {
          neuron with
          refractoryRemaining = newRefrac;
          membranePotential = neuron.restingPotential;
        };
      };
    };
    
    // Compute weighted sensory input
    var totalInput : Float = 0.0;
    var i = 0;
    while (i < neuron.inputWeights.size() and i < sensoryInputs.size()) {
      let baseWeight = neuron.inputWeights[i];
      let learnedMod = if (i < neuron.inputWeightsLearned.size()) { 
        neuron.inputWeightsLearned[i] 
      } else { 0.0 };
      totalInput += sensoryInputs[i] * (baseWeight + learnedMod);
      i += 1;
    };
    
    // Compute lateral inhibition
    var lateralInhib : Float = 0.0;
    i := 0;
    while (i < neuron.lateralWeights.size() and i < lateralInputs.size()) {
      lateralInhib += neuron.lateralWeights[i] * lateralInputs[i];
      i += 1;
    };
    
    // Apply modulations
    let sensitizationMod = 1.0 + sensitization * 0.5;
    let habituationMod = 1.0 - habituation * 0.5;
    let arousalMod = 0.5 + arousal * 0.5;
    let neMod = neuron.neModulation;
    
    // Total input with all modulations
    let modulatedInput = totalInput * sensitizationMod * habituationMod * arousalMod * 
                         neMod * globalGain + lateralInhib;
    
    // Leaky integrate membrane
    let tau = RETICULAR_TAU_MEMBRANE;
    let newMembrane = leakyIntegrate(neuron.membranePotential, modulatedInput, tau, 1.0);
    let clampedMembrane = fclamp(newMembrane, 0.0, 1.0);
    
    // Check for spike
    let effectiveThreshold = neuron.threshold * (1.0 - arousal * 0.1);
    let fires = clampedMembrane > effectiveThreshold;
    
    if (fires) {
      // Spike!
      let newFiringRate = 1.0;
      let newSpikeCount = neuron.spikeCount + 1;
      
      // Check for burst mode
      let enterBurst = neuron.neModulation > 1.3 and not neuron.burstMode;
      let burstSpikes = if (enterBurst) { 3 } else { 0 };
      
      return {
        neuron with
        membranePotential = neuron.resetPotential;
        isFiring = true;
        firingRate = newFiringRate;
        lastSpikeTime = 0;  // Would need currentBeat parameter
        spikeCount = newSpikeCount;
        isRefractory = true;
        refractoryRemaining = neuron.absoluteRefractory;
        sensitization = sensitization;
        habituation = habituation;
        arousalModulation = arousalMod;
        burstMode = enterBurst or neuron.burstMode;
        burstSpikesRemaining = burstSpikes;
        lateralInhibition = lateralInhib;
      };
    } else {
      // No spike - continue integration
      return {
        neuron with
        membranePotential = clampedMembrane;
        isFiring = false;
        firingRate = neuron.firingRate * 0.9;  // Decay
        sensitization = sensitization;
        habituation = habituation;
        arousalModulation = arousalMod;
        lateralInhibition = lateralInhib;
      };
    };
  };

  /// Process complete reticular formation
  public func processReticularFormation(
    rf: ReticularFormation,
    sensoryChannels: [SensoryChannel],
    sensitization: Float,
    habituation: Float,
    arousal: Float,
    amygdalaInput: Float,
    corticalInput: Float
  ) : ReticularFormation {
    // Extract sensory intensities
    let sensoryInputs = Array.map<SensoryChannel, Float>(sensoryChannels, func(c) {
      c.currentIntensity
    });
    
    // Compute global gain based on arousal and descending inputs
    let arousalGain = RETICULAR_GAIN_BASE + arousal * RETICULAR_GAIN_AROUSAL_FACTOR;
    let amygdalaBoost = amygdalaInput * 0.3;
    let corticalMod = 1.0 - corticalInput * 0.2;  // Cortex can inhibit
    let globalGain = fclamp(arousalGain + amygdalaBoost * corticalMod, 
                            RETICULAR_GAIN_BASE, RETICULAR_GAIN_MAX);
    
    // Get current firing rates for lateral inhibition
    let lateralInputs = Array.map<ReticularNeuron, Float>(rf.neurons, func(n) {
      n.firingRate
    });
    
    // Update all neurons
    let updatedNeurons = Array.tabulate<ReticularNeuron>(rf.neuronCount, func(i) {
      updateReticularNeuron(
        rf.neurons[i],
        sensoryInputs,
        lateralInputs,
        globalGain,
        sensitization,
        habituation,
        arousal
      )
    });
    
    // Compute population statistics
    var firingCount : Nat = 0;
    var totalOutput : Float = 0.0;
    var sumRate : Float = 0.0;
    
    for (neuron in updatedNeurons.vals()) {
      if (neuron.isFiring or neuron.firingRate > 0.5) {
        firingCount += 1;
        totalOutput += neuron.firingRate * neuron.outputStrength;
      };
      sumRate += neuron.firingRate;
    };
    
    let populationRate = sumRate / Float.fromInt(rf.neuronCount);
    
    // Population coding bonus
    let populationBonus = Float.fromInt(firingCount) / Float.fromInt(rf.neuronCount) * 
                          RETICULAR_POPULATION_BONUS;
    
    // Final output
    let finalOutput = fclamp(
      totalOutput / Float.fromInt(rf.neuronCount) + populationBonus,
      0.0, 1.0
    );
    
    // Output confidence based on synchrony
    let outputConfidence = if (firingCount > 0) {
      Float.fromInt(firingCount) / Float.fromInt(rf.neuronCount)
    } else { 0.0 };
    
    // Update gain history
    let newGainHistory = Array.tabulate<Float>(10, func(i) {
      if (i == 0) { globalGain }
      else if (i < rf.gainHistory.size()) { rf.gainHistory[i - 1] }
      else { globalGain }
    });
    
    {
      neurons = updatedNeurons;
      neuronCount = rf.neuronCount;
      populationRate = populationRate;
      populationSync = outputConfidence;
      firingNeuronCount = firingCount;
      totalOutput = finalOutput;
      outputConfidence = outputConfidence;
      globalGain = globalGain;
      gainHistory = newGainHistory;
      lateralInhibitionStrength = rf.lateralInhibitionStrength;
      winnerTakeAllActive = firingCount > 0 and firingCount < rf.neuronCount / 2;
      descendingInput = corticalInput;
      amygdalaInput = amygdalaInput;
      corticalInput = corticalInput;
      ascendingOutput = finalOutput * 0.5;  // Send alerting signal up
      lastUpdateBeat = rf.lastUpdateBeat + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 12: MODULATORY SYSTEM UPDATES
  // ══════════════════════════════════════════════════════════════════════════════

  /// Update prepulse inhibition state
  public func updatePPI(
    ppi: PPIState,
    sensoryIntensity: Float,
    currentBeat: Nat,
    dopamineLevel: Float,
    attentionLevel: Float
  ) : PPIState {
    // Check for prepulse (weak stimulus that precedes startle)
    let isPrepulse = sensoryIntensity > 0.2 and sensoryIntensity < 0.5;
    
    var newPrepulseDetected = ppi.prepulseDetected;
    var newPrepulseTime = ppi.prepulseTime;
    var newPrepulseIntensity = ppi.prepulseIntensity;
    
    if (isPrepulse and not ppi.prepulseDetected) {
      newPrepulseDetected := true;
      newPrepulseTime := currentBeat;
      newPrepulseIntensity := sensoryIntensity;
    };
    
    // Compute lead time
    let leadTime = Float.fromInt(currentBeat - newPrepulseTime);
    
    // PPI window: maximal at ~100ms, falls off on either side (Gaussian)
    let ppiGaussian = if (newPrepulseDetected and leadTime > ppi.windowMin and 
                          leadTime < ppi.windowMax) {
      gaussian(leadTime, ppi.optimalLeadTime, ppi.windowSigma)
    } else { 0.0 };
    
    // Modulation by dopamine (DA disrupts PPI - relevant to schizophrenia)
    let daModulation = 1.0 - (dopamineLevel - 0.5) * 0.3;
    
    // Modulation by attention
    let attentionMod = 0.8 + attentionLevel * 0.4;
    
    // Final PPI level
    let ppiLevel = fclamp(
      ppiGaussian * newPrepulseIntensity * ppi.ppiEfficiency * daModulation * attentionMod,
      0.0, ppi.maxInhibition
    );
    
    // Clear prepulse if too old
    if (leadTime > ppi.windowMax) {
      newPrepulseDetected := false;
    };
    
    // Update history
    let newHistory = Array.tabulate<Float>(20, func(i) {
      if (i == 0) { ppiLevel }
      else if (i < ppi.ppiHistory.size()) { ppi.ppiHistory[i - 1] }
      else { 0.0 }
    });
    
    // Running average
    var sum : Float = 0.0;
    for (v in newHistory.vals()) { sum += v };
    let newAverage = sum / 20.0;
    
    // PPI deficit detection (clinical relevance)
    let ppiDeficit = newAverage < 0.2 and ppi.ppiEfficiency > 0.5;
    let deficitSeverity = if (ppiDeficit) { 
      (0.5 - newAverage) / 0.5 
    } else { 0.0 };
    
    {
      prepulseDetected = newPrepulseDetected;
      prepulseTime = newPrepulseTime;
      prepulseIntensity = newPrepulseIntensity;
      prepulseModality = ppi.prepulseModality;
      leadTimeMs = leadTime;
      inhibitionLevel = ppiLevel;
      maxInhibition = ppi.maxInhibition;
      ppiEfficiency = ppi.ppiEfficiency;
      ppiVariability = ppi.ppiVariability;
      optimalLeadTime = ppi.optimalLeadTime;
      windowSigma = ppi.windowSigma;
      windowMin = ppi.windowMin;
      windowMax = ppi.windowMax;
      dopamineModulation = daModulation;
      attentionModulation = attentionMod;
      ppiHistory = newHistory;
      averagePPI = newAverage;
      ppiDeficit = ppiDeficit;
      deficitSeverity = deficitSeverity;
    }
  };

  /// Update fear potentiation state
  public func updateFearPotentiation(
    fear: FearPotentiationState,
    threatLevel: Float,
    contextThreat: Float,
    cortisol: Float,
    serotonin: Float,
    currentBeat: Nat
  ) : FearPotentiationState {
    let timeSinceUpdate = Float.fromInt(currentBeat - fear.lastFearUpdate);
    
    // Decay existing fear
    let cuedDecay = fexp(-timeSinceUpdate * FEAR_DECAY_RATE_CUED);
    let contextDecay = fexp(-timeSinceUpdate * FEAR_DECAY_RATE_CONTEXTUAL);
    
    let decayedCued = fear.cuedFear * cuedDecay;
    let decayedContextual = fear.contextualFear * contextDecay;
    
    // Add new fear from current threats
    let newCued = fclamp(decayedCued + threatLevel * 0.4, 0.0, 1.0);
    let newContextual = fclamp(decayedContextual + contextThreat * 0.3, 0.0, 1.0);
    
    // Amygdala activation (central nucleus)
    let ceaActivation = fclamp((newCued + newContextual) * 0.8, 0.0, 1.0);
    
    // Bed nucleus of stria terminalis (sustained anxiety)
    let bnstActivation = fclamp(newContextual * 0.6, 0.0, 1.0);
    
    // Cortisol modulation (stress hormones amplify fear)
    let cortMod = 1.0 + (cortisol - 0.3) * FEAR_CORT_MODULATION;
    
    // Serotonin modulation (5-HT reduces fear)
    let serotoninMod = 1.0 - (serotonin - 0.5) * 0.2;
    
    // Total potentiation
    let potentiation = FEAR_POTENTIATION_MIN + 
                       ceaActivation * FEAR_CEA_WEIGHT + 
                       bnstActivation * FEAR_BNST_WEIGHT;
    let modulatedPotentiation = potentiation * cortMod * serotoninMod;
    let clampedPotentiation = fclamp(modulatedPotentiation, 
                                      FEAR_POTENTIATION_MIN, FEAR_POTENTIATION_MAX);
    
    // Safety signal check
    let safetyActive = threatLevel < 0.1 and contextThreat < 0.1;
    let safetyInhibition = if (safetyActive) { 0.3 } else { 0.0 };
    let finalPotentiation = clampedPotentiation * (1.0 - safetyInhibition);
    
    // Update history
    let newHistory = Array.tabulate<Float>(20, func(i) {
      if (i == 0) { finalPotentiation }
      else if (i < fear.potentiationHistory.size()) { fear.potentiationHistory[i - 1] }
      else { 1.0 }
    });
    
    // Fear duration tracking
    let newFearDuration = if (finalPotentiation > 1.1) {
      fear.fearDuration + 1
    } else { 0 };
    
    {
      cuedFear = newCued;
      contextualFear = newContextual;
      innateFeear = fear.innateFeear;
      learnedFear = fear.learnedFear;
      amygdalaActivation = ceaActivation;
      basalAmygdala = fear.basalAmygdala;
      lateralAmygdala = fear.lateralAmygdala;
      bedNucleusSTActivation = bnstActivation;
      totalPotentiation = finalPotentiation;
      potentiationHistory = newHistory;
      cortModulation = cortMod;
      serotoninModulation = serotoninMod;
      fearOnsetTime = fear.fearOnsetTime;
      fearDuration = newFearDuration;
      fearDecayRate = fear.fearDecayRate;
      lastFearUpdate = currentBeat;
      csIntensity = fear.csIntensity;
      usIntensity = fear.usIntensity;
      csUsInterval = fear.csUsInterval;
      extinctionProgress = fear.extinctionProgress;
      extinctionTrials = fear.extinctionTrials;
      extinctionResistance = fear.extinctionResistance;
      safetySignalPresent = safetyActive;
      safetyInhibition = safetyInhibition;
    }
  };

  /// Update habituation state
  public func updateHabituation(
    hab: HabituationState,
    startleOccurred: Bool,
    stimulusIntensity: Float,
    currentBeat: Nat,
    arousal: Float
  ) : HabituationState {
    let timeSinceStartle = currentBeat - hab.lastStartleBeat;
    
    if (startleOccurred) {
      // Increment trial count
      let newTrials = hab.habituationTrials + 1;
      let newTrialsSinceRecovery = hab.trialsSinceRecovery + 1;
      
      // Short-term habituation: H_st(n) = H_max × (1 - exp(-n/τ))
      let stHab = HABITUATION_MAX * (1.0 - fexp(-Float.fromInt(newTrialsSinceRecovery) / 
                                                 hab.tauShortTerm));
      
      // Medium-term (accumulates more slowly)
      let mtHab = hab.mediumTermHabituation + 0.01;
      
      // Long-term (very slow accumulation)
      let ltHab = hab.longTermHabituation * HABITUATION_LT_DECAY + HABITUATION_LT_INCREMENT;
      
      // Arousal modulation (high arousal reduces habituation)
      let arousalMod = 1.0 - arousal * 0.3;
      
      // Total habituation (capped at maximum)
      let total = fclamp(
        (stHab + mtHab + ltHab) * arousalMod,
        0.0, HABITUATION_MAX
      );
      
      return {
        shortTermHabituation = fclamp(stHab, 0.0, HABITUATION_MAX);
        mediumTermHabituation = fclamp(mtHab, 0.0, 0.3);
        longTermHabituation = fclamp(ltHab, 0.0, 0.5);
        totalHabituation = total;
        habituationTrials = newTrials;
        trialsSinceRecovery = newTrialsSinceRecovery;
        interTrialInterval = Float.fromInt(timeSinceStartle);
        tauShortTerm = hab.tauShortTerm;
        tauMediumTerm = hab.tauMediumTerm;
        tauLongTerm = hab.tauLongTerm;
        tauRecovery = hab.tauRecovery;
        recoveryProgress = 0.0;
        lastStartleBeat = currentBeat;
        timeSinceStartle = 0;
        dishabituationReady = false;
        dishabituationThreshold = hab.dishabituationThreshold;
        lastDishabituation = hab.lastDishabituation;
        stimulusSpecific = hab.stimulusSpecific;
        stimulusMemory = hab.stimulusMemory;
        arousalModulation = arousalMod;
        sleepModulation = hab.sleepModulation;
      };
    };
    
    // No startle - recovery phase
    let recoveryRate = 1.0 / hab.tauRecovery;
    let newRecovery = fclamp(hab.recoveryProgress + recoveryRate, 0.0, 1.0);
    
    // Short-term habituation recovers with time
    let stRecovered = hab.shortTermHabituation * (1.0 - newRecovery * 0.02);
    
    // Medium-term recovers more slowly
    let mtRecovered = hab.mediumTermHabituation * 0.999;
    
    // Long-term is very persistent
    let ltRecovered = hab.longTermHabituation * 0.99995;
    
    // Can be dishabituated after sufficient recovery
    let canDishabituate = newRecovery > hab.dishabituationThreshold;
    
    // Reset trials since recovery if fully recovered
    let resetTrials = if (newRecovery > 0.95) { 0 } else { hab.trialsSinceRecovery };
    
    {
      hab with
      shortTermHabituation = fclamp(stRecovered, 0.0, HABITUATION_MAX);
      mediumTermHabituation = fclamp(mtRecovered, 0.0, 0.3);
      longTermHabituation = fclamp(ltRecovered, 0.0, 0.5);
      totalHabituation = fclamp(stRecovered + mtRecovered + ltRecovered, 0.0, HABITUATION_MAX);
      trialsSinceRecovery = resetTrials;
      recoveryProgress = newRecovery;
      timeSinceStartle = timeSinceStartle;
      dishabituationReady = canDishabituate;
    }
  };

  /// Update sensitization state
  public func updateSensitization(
    sens: SensitizationState,
    threatLevel: Float,
    norepinephrine: Float,
    cortisol: Float,
    currentBeat: Nat
  ) : SensitizationState {
    let timeSinceThreat = Float.fromInt(currentBeat - sens.lastThreatBeat);
    
    // Decay existing sensitization
    let acuteDecayed = sens.acuteSensitization * fexp(-timeSinceThreat / sens.tauAcute);
    let sustainedDecayed = sens.sustainedSensitization * SENSITIZATION_SUSTAINED_DECAY;
    let chronicDecayed = sens.chronicSensitization * 0.9999;
    
    // Check for new threat
    if (threatLevel > SENSITIZATION_THREAT_THRESHOLD) {
      let threatBoost = (threatLevel - SENSITIZATION_THREAT_THRESHOLD) * 2.0;
      
      // Norepinephrine amplifies sensitization
      let neMod = 1.0 + (norepinephrine - 0.5) * 0.5;
      
      // Cortisol contributes to sustained sensitization
      let cortMod = 1.0 + (cortisol - 0.3) * 0.3;
      
      let newAcute = fclamp(acuteDecayed + threatBoost * neMod * 0.5, 
                            0.0, SENSITIZATION_ACUTE_MAX);
      let newSustained = fclamp(sustainedDecayed + threatBoost * cortMod * 
                                SENSITIZATION_SUSTAINED_INCREMENT, 
                                0.0, SENSITIZATION_SUSTAINED_MAX);
      let newChronic = fclamp(chronicDecayed + threatBoost * 0.01, 0.0, 0.3);
      
      let newTotal = fclamp(newAcute + newSustained + newChronic, 0.0, 1.0);
      let newPeak = Float.max(sens.peakSensitization, newTotal);
      let newExposure = sens.threatExposure + threatLevel * 0.01;
      
      return {
        acuteSensitization = newAcute;
        sustainedSensitization = newSustained;
        chronicSensitization = newChronic;
        totalSensitization = newTotal;
        threatExposure = fclamp(newExposure, 0.0, 10.0);
        threatIntensity = threatLevel;
        threatDuration = sens.threatDuration + 1;
        lastThreatBeat = currentBeat;
        tauAcute = sens.tauAcute;
        tauSustained = sens.tauSustained;
        tauChronic = sens.tauChronic;
        peakSensitization = newPeak;
        peakTime = if (newTotal == newPeak) { currentBeat } else { sens.peakTime };
        locusCoeruleusActivation = norepinephrine;
        centralAmygdalaActivation = sens.centralAmygdalaActivation;
        cortLevel = cortisol;
        neLevel = norepinephrine;
        crhLevel = sens.crhLevel;
        contextualSensitization = sens.contextualSensitization;
        generalizedSensitization = newSustained;
        sleepDeprivation = sens.sleepDeprivation;
        priorTrauma = sens.priorTrauma;
      };
    };
    
    // No threat - just decay
    {
      sens with
      acuteSensitization = acuteDecayed;
      sustainedSensitization = sustainedDecayed;
      chronicSensitization = chronicDecayed;
      totalSensitization = fclamp(acuteDecayed + sustainedDecayed + chronicDecayed, 0.0, 1.0);
      threatDuration = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 13: STARTLE MAGNITUDE COMPUTATION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute final startle magnitude using master equation
  /// M = S × G × (1 - H) × (1 + F - 1) × (1 - PPI) × (1 + Sens) × Q_mod
  public func computeStartleMagnitude(
    stimulusIntensity: Float,
    reticularGain: Float,
    habituation: Float,
    fearPotentiation: Float,
    ppiInhibition: Float,
    sensitization: Float,
    quantumModulation: Float,
    globalSensitivity: Float
  ) : Float {
    // Clamp all inputs
    let s = fclamp(stimulusIntensity, 0.0, 1.0);
    let g = fclamp(reticularGain, RETICULAR_GAIN_BASE, RETICULAR_GAIN_MAX);
    let h = fclamp(habituation, 0.0, HABITUATION_MAX);
    let f = fclamp(fearPotentiation, FEAR_POTENTIATION_MIN, FEAR_POTENTIATION_MAX);
    let ppi = fclamp(ppiInhibition, 0.0, 0.8);
    let sens = fclamp(sensitization, 0.0, 1.0);
    let qMod = fclamp(quantumModulation, 0.8, 1.2);
    let gSens = fclamp(globalSensitivity, 0.5, 2.0);
    
    // Master equation
    let magnitude = s * g * (1.0 - h) * f * (1.0 - ppi) * (1.0 + sens) * qMod * gSens;
    
    fclamp(magnitude, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 14: ORGANISM INTEGRATION — SHELL 3 STIMULATION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute Shell 3 stimulation pattern from startle
  public func computeShell3Stimulation(
    magnitude: Float,
    sensitization: Float,
    dominantModality: ?StartleModality
  ) : Shell3Stimulation {
    let baseStim = magnitude * SHELL3_STIM_THREAT_RATE;
    let sensitizationBonus = sensitization * SHELL3_STIM_SENSITIZATION_BONUS;
    let totalStim = baseStim * (1.0 + sensitizationBonus);
    
    // Threat cluster (nodes 20-27) - primary startle activation
    let threatStim = Array.tabulate<Float>(8, func(i) {
      let nodeWeight = 1.0 - Float.fromInt(i) * 0.05;  // Decreasing weights
      totalStim * nodeWeight
    });
    
    // Motor cluster (nodes 10-17) - motor preparation
    let motorStim = Array.tabulate<Float>(8, func(i) {
      let nodeWeight = 0.8 + Float.fromInt((i + 3) % 4) * 0.1;
      magnitude * SHELL3_STIM_MOTOR_RATE * nodeWeight
    });
    
    // Arousal cluster (nodes 0-7) - general arousal
    let arousalStim = Array.tabulate<Float>(8, func(i) {
      magnitude * 0.1 * (1.0 - Float.fromInt(i) * 0.1)
    });
    
    // Integration cluster (nodes 56-63) - higher integration
    let integrationStim = Array.tabulate<Float>(8, func(i) {
      // Integration is suppressed during startle (focus on survival)
      -magnitude * 0.05
    });
    
    // Global effects
    let globalStim = magnitude * 0.15;
    let globalInhib = magnitude * 0.1;  // Some global inhibition
    
    // Phase effects (startle can reset Kuramoto phases)
    let phaseReset = magnitude > 0.8;
    let phasePerturbation = magnitude * 0.3;
    
    // Coherence target (startle disrupts coherence temporarily)
    let coherenceTarget = 0.5 - magnitude * 0.2;
    let coherenceUrgency = magnitude;
    
    {
      threatClusterStim = threatStim;
      motorClusterStim = motorStim;
      arousalClusterStim = arousalStim;
      integrationClusterStim = integrationStim;
      globalStimulation = globalStim;
      globalInhibition = globalInhib;
      phaseReset = phaseReset;
      phasePerturbation = phasePerturbation;
      coherenceTarget = coherenceTarget;
      coherenceUrgency = coherenceUrgency;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 15: ORGANISM INTEGRATION — Hz SPECTRUM ACTIVATION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute Hz spectrum activation pattern
  public func computeHzSpectrumActivation(
    magnitude: Float,
    sensitization: Float,
    fearPotentiation: Float
  ) : HzSpectrumActivation {
    // Initialize all 64 nodes to zero delta
    var nodeActivations = Array.init<Float>(64, 0.0);
    
    // RAS-LOCUS (Node 16) - arousal/alertness BOOST
    let rasBoost = magnitude * HZ_RAS_LOCUS_RATE * (1.0 + sensitization * 0.3);
    nodeActivations[HZ_NODE_RAS_LOCUS] := rasBoost;
    
    // AMYGDALA-RIFT (Node 21) - threat tagging BOOST
    let amygdalaBoost = magnitude * HZ_AMYGDALA_RIFT_RATE * fearPotentiation;
    nodeActivations[HZ_NODE_AMYGDALA_RIFT] := amygdalaBoost;
    
    // MEDULLA-PULSE (Node 11) - vital rhythm BOOST
    let medullaBoost = magnitude * HZ_MEDULLA_PULSE_RATE;
    nodeActivations[HZ_NODE_MEDULLA_PULSE] := medullaBoost;
    
    // THALAMIC-RELAY (Node 9) - sensory gating SUPPRESS
    let thalamicSuppress = -magnitude * HZ_THALAMIC_RELAY_SUPPRESSION;
    nodeActivations[HZ_NODE_THALAMIC_RELAY] := thalamicSuppress;
    
    // CEREBELLUM-EXEC (Node 10) - motor precision BOOST
    let cerebellumBoost = magnitude * HZ_CEREBELLUM_EXEC_RATE;
    nodeActivations[HZ_NODE_CEREBELLUM_EXEC] := cerebellumBoost;
    
    // FRONTAL-APEX (Node 19) - executive SUPPRESS (no time to think)
    let frontalSuppress = -magnitude * HZ_FRONTAL_APEX_SUPPRESSION;
    nodeActivations[HZ_NODE_FRONTAL_APEX] := frontalSuppress;
    
    // Additional nodes
    nodeActivations[HZ_NODE_PONS_BRIDGE] := magnitude * 0.2;  // Cross-hemisphere coordination
    nodeActivations[HZ_NODE_BASAL_SOMA] := -magnitude * 0.1; // Habit system pause
    nodeActivations[HZ_NODE_DORSAL_STREAM] := magnitude * 0.15; // Where/how pathway
    
    // Tier effects
    let tier1Effect = magnitude * 0.1;  // Foundation - slight boost
    let tier2Effect = magnitude * 0.2;  // Cognitive - moderate boost
    let tier3Effect = -magnitude * 0.1; // Expression - slight suppress
    let tier4Effect = magnitude * 0.05; // Carrier - minimal
    
    {
      nodeActivations = Array.freeze(nodeActivations);
      rasLocusBoost = rasBoost;
      amygdalaRiftBoost = amygdalaBoost;
      medullaPulseBoost = medullaBoost;
      thalamicRelaySuppress = -thalamicSuppress;  // Store as positive suppress amount
      cerebellumExecBoost = cerebellumBoost;
      frontalApexSuppress = -frontalSuppress;
      tier1Effect = tier1Effect;
      tier2Effect = tier2Effect;
      tier3Effect = tier3Effect;
      tier4Effect = tier4Effect;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 16: ORGANISM INTEGRATION — QUANTUM OPERATOR EFFECTS
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute quantum operator effects from startle
  public func computeQuantumOperatorEffects(
    magnitude: Float,
    ppiActive: Bool,
    stimulusRiseTime: Float
  ) : QuantumOperatorEffects {
    // PARALLAX - faster path evaluation during emergency
    let parallaxCompression = magnitude * 0.3;  // Compress evaluation
    let parallaxUrgency = magnitude * 0.5;      // Increase urgency
    
    // CHRONO - enhanced temporal precision during startle
    // Fisher information boost: F_Q = 4×Var(dKf/dt) increases
    let chronoBoost = magnitude * 0.4;
    let temporalResolution = 1.0 + magnitude * 0.3;
    
    // QMEM - high-salience encoding (startle events are memorable)
    let qmemSalienceSpike = magnitude * 0.6;
    let qmemFidelityBoost = magnitude * 0.2;
    
    // ENTANGLA - correlation disruption during startle
    let entanglaDisruption = magnitude * 0.2;
    
    // BYPASS - decision temperature shift
    let bypassTemperature = 1.0 - magnitude * 0.3;  // Lower temp = faster decision
    let bypassUrgency = magnitude * 0.5;
    
    // VERITAS - error detection alert
    let veritasAlert = magnitude * 0.3;
    
    // RESONEX - collective disruption
    let resonexDisruption = magnitude * 0.15;
    
    // QSOV - sovereignty impact (startle is a sovereignty challenge)
    let qsovImpact = -magnitude * 0.1;  // Slight negative impact
    
    {
      parallaxCompression = parallaxCompression;
      parallaxUrgency = parallaxUrgency;
      chronoBoost = chronoBoost;
      temporalResolution = temporalResolution;
      qmemSalienceSpike = qmemSalienceSpike;
      qmemFidelityBoost = qmemFidelityBoost;
      entanglaDisruption = entanglaDisruption;
      bypassTemperature = bypassTemperature;
      bypassUrgency = bypassUrgency;
      veritasAlert = veritasAlert;
      resonexDisruption = resonexDisruption;
      qsovImpact = qsovImpact;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 17: ORGANISM INTEGRATION — NEUROCHEMICAL INJECTION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute neurochemical injection pattern
  public func computeNeurochemicalInjection(
    magnitude: Float,
    painSignal: Float,
    currentNE: Float,
    currentCORT: Float,
    currentDA: Float
  ) : NeurochemicalInjection {
    // Norepinephrine surge (arousal/threat)
    let neInjection = magnitude * NEUROCHEMICAL_NE_RATE * (1.0 - currentNE);
    
    // Adrenaline surge (fight/flight)
    let adrenalineInjection = magnitude * NEUROCHEMICAL_ADRENALINE_RATE;
    
    // Glutamate spike (excitation)
    let gluInjection = magnitude * NEUROCHEMICAL_GLU_RATE;
    
    // Substance P (pain-dependent)
    let subpInjection = magnitude * NEUROCHEMICAL_SUBP_RATE * painSignal;
    
    // Cortisol (slower stress response)
    let cortInjection = magnitude * NEUROCHEMICAL_CORT_RATE * (1.0 - currentCORT);
    
    // Dopamine suppression (CORT suppresses DA)
    let daModulation = -magnitude * NEUROCHEMICAL_DA_SUPPRESSION * (1.0 + currentCORT);
    
    // GABA rebound (inhibitory, comes after initial excitation)
    let gabaInjection = magnitude * NEUROCHEMICAL_GABA_RATE * 0.5;  // Delayed
    
    // Acetylcholine (attention/learning)
    let achModulation = magnitude * 0.15;
    
    // Serotonin (slow stabilization)
    let serotoninMod = magnitude * NEUROCHEMICAL_5HT_RATE;
    
    // Build full 21-chemical array
    // Order: DA, 5HT, NE, ADRENALINE, ACh, GABA, GLY, GLU, OT, VASO, 
    //        ENDO, SUBP, NPY, ADENOSINE, ANANDAMIDE, 2-AG, NO, BDNF, NGF, CORT, TEST
    var allInjections = Array.init<Float>(21, 0.0);
    allInjections[0] := daModulation;      // DA
    allInjections[1] := serotoninMod;      // 5HT
    allInjections[2] := neInjection;       // NE
    allInjections[3] := adrenalineInjection; // ADRENALINE
    allInjections[4] := achModulation;     // ACh
    allInjections[5] := gabaInjection;     // GABA
    allInjections[7] := gluInjection;      // GLU
    allInjections[11] := subpInjection;    // SUBP
    allInjections[19] := cortInjection;    // CORT
    
    {
      neInjection = neInjection;
      adrenalineInjection = adrenalineInjection;
      gluInjection = gluInjection;
      subpInjection = subpInjection;
      cortInjection = cortInjection;
      daModulation = daModulation;
      gabaInjection = gabaInjection;
      achModulation = achModulation;
      serotonin5htModulation = serotoninMod;
      allInjections = Array.freeze(allInjections);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 18: ORGANISM INTEGRATION — VETUS THREAT VECTORS
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute VETUS threat vector escalation
  public func computeVetusThreatEscalation(
    magnitude: Float,
    pipelineSkipped: Bool
  ) : VetusThreatEscalation {
    // Build all 10 vectors
    var allEscalations = Array.init<Float>(10, 0.0);
    
    // v1: External threat - startle indicates external threat
    let v1Escalation = magnitude * VETUS_V1_RATE;
    allEscalations[VETUS_V1_EXTERNAL_THREAT] := v1Escalation;
    
    // v6: Prediction error - startle = prediction failure (surprised)
    let v6Escalation = magnitude * VETUS_V6_RATE;
    allEscalations[VETUS_V6_PREDICTION_ERROR] := v6Escalation;
    
    // v10: Sovereignty breach check
    let v10Escalation = magnitude * VETUS_V10_RATE;
    allEscalations[VETUS_V10_SOVEREIGNTY_BREACH] := v10Escalation;
    
    // v9: Shell 3 collapse check (only if very strong startle)
    let v9Escalation = if (magnitude > 0.9) { 0.1 } else { 0.0 };
    allEscalations[VETUS_V9_SHELL3_COLLAPSE] := v9Escalation;
    
    // Check for ARES rollback trigger (v9 > 0.5 triggers ARES)
    let triggersAres = v9Escalation > 0.5;
    let aresVector = if (triggersAres) { ?VETUS_V9_SHELL3_COLLAPSE } else { null };
    
    {
      v1Escalation = v1Escalation;
      v6Escalation = v6Escalation;
      v10Escalation = v10Escalation;
      allEscalations = Array.freeze(allEscalations);
      triggersAresRollback = triggersAres;
      aresRollbackVector = aresVector;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 19: ORGANISM INTEGRATION — AEGIS MEMBRANE
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute AEGIS membrane effects
  public func computeAegisMembraneEffects(
    magnitude: Float,
    chronoBoost: Float,
    memoryBoost: Float
  ) : AegisMembraneEffects {
    // Build all 7 strands
    var strandEffects = Array.init<Float>(7, 0.0);
    
    // Strand 0: Sovereignty - slight boost from successful defense response
    let sovereigntyBoost = magnitude * 0.05;
    strandEffects[AEGIS_SOVEREIGNTY] := sovereigntyBoost;
    
    // Strand 1: Coherence - dip during startle (processing disrupted)
    let coherenceDip = -magnitude * 0.1;
    strandEffects[AEGIS_COHERENCE] := coherenceDip;
    
    // Strand 2: Emergence - dip (emergence requires calm)
    let emergenceDip = -magnitude * 0.08;
    strandEffects[AEGIS_EMERGENCE] := emergenceDip;
    
    // Strand 3: Memory - boost (high-salience event)
    let memBoost = magnitude * 0.15 + memoryBoost;
    strandEffects[AEGIS_MEMORY] := memBoost;
    
    // Strand 4: Attribution - unchanged
    strandEffects[AEGIS_ATTRIBUTION] := 0.0;
    
    // Strand 5: Temporal - boost from CHRONO activation
    let temporalBoost = chronoBoost * 0.5;
    strandEffects[AEGIS_TEMPORAL] := temporalBoost;
    
    // Strand 6: Quantum - boost from quantum operator activation
    let quantumBoost = magnitude * 0.1;
    strandEffects[AEGIS_QUANTUM] := quantumBoost;
    
    // Overall membrane perturbation
    let membranePerturbation = magnitude * 0.2;
    
    // Suppression risk (only if very strong startle)
    let suppressionRisk = magnitude > 0.9;
    
    {
      strandEffects = Array.freeze(strandEffects);
      sovereigntyBoost = sovereigntyBoost;
      coherenceDip = -coherenceDip;  // Store as positive dip amount
      emergenceDip = -emergenceDip;
      memoryBoost = memBoost;
      temporalBoost = temporalBoost;
      quantumBoost = quantumBoost;
      membranePerturbation = membranePerturbation;
      suppressionRisk = suppressionRisk;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 20: ORGANISM INTEGRATION — DRIVE MODULATION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute drive modulation pattern
  public func computeDriveModulation(
    magnitude: Float,
    painSignal: Float,
    forceEmergency: Bool
  ) : DriveModulation {
    // Build all 10 drives
    var driveDeltas = Array.init<Float>(10, 0.0);
    
    // Drive 0: Threat response - BOOST
    let threatBoost = magnitude * DRIVE_THREAT_BOOST;
    driveDeltas[DRIVE_THREAT_RESPONSE] := threatBoost;
    
    // Drive 1: Body integrity - BOOST (especially with pain)
    let bodyBoost = magnitude * DRIVE_BODY_INTEGRITY_BOOST * (1.0 + painSignal);
    driveDeltas[DRIVE_BODY_INTEGRITY] := bodyBoost;
    
    // Drive 2: Exploration - SUPPRESS
    let explorationSuppress = -magnitude * DRIVE_EXPLORATION_SUPPRESSION;
    driveDeltas[DRIVE_EXPLORATION] := explorationSuppress;
    
    // Drive 3: Social engagement - SUPPRESS
    let socialSuppress = -magnitude * DRIVE_SOCIAL_SUPPRESSION;
    driveDeltas[DRIVE_SOCIAL_ENGAGEMENT] := socialSuppress;
    
    // Drive 4: Goal pursuit - SUPPRESS
    let goalSuppress = -magnitude * DRIVE_GOAL_SUPPRESSION;
    driveDeltas[DRIVE_GOAL_PURSUIT] := goalSuppress;
    
    // Drive 5: Energy conservation - BOOST (freeze response)
    let energyBoost = magnitude * 0.2;
    driveDeltas[DRIVE_ENERGY_CONSERVATION] := energyBoost;
    
    // Drive 6: Curiosity - SUPPRESS
    let curiositySuppress = -magnitude * DRIVE_CURIOSITY_SUPPRESSION;
    driveDeltas[DRIVE_CURIOSITY] := curiositySuppress;
    
    // Drive 7: Play - STRONGLY SUPPRESS
    driveDeltas[DRIVE_PLAY] := -magnitude * 0.5;
    
    // Drive 8: Dominance - context-dependent
    driveDeltas[DRIVE_DOMINANCE] := -magnitude * 0.1;
    
    // Drive 9: Affiliation - SUPPRESS
    driveDeltas[DRIVE_AFFILIATION] := -magnitude * 0.2;
    
    // Forced mode
    let forcedMode : ?Text = if (forceEmergency) { ?"Q_EMERGENCY" } else { null };
    let modeUrgency = magnitude;
    
    {
      driveDeltas = Array.freeze(driveDeltas);
      threatResponseBoost = threatBoost;
      bodyIntegrityBoost = bodyBoost;
      explorationSuppress = -explorationSuppress;
      socialSuppress = -socialSuppress;
      goalPursuitSuppress = -goalSuppress;
      energyConservationBoost = energyBoost;
      curiositySuppress = -curiositySuppress;
      forcedMode = forcedMode;
      modeUrgency = modeUrgency;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 21: ORGANISM INTEGRATION — COUNCIL EFFECTS
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute council organism effects
  public func computeCouncilEffects(
    magnitude: Float
  ) : CouncilEffects {
    // COGNUS - cognitive disruption during startle
    let cognusEffect = -magnitude * 0.2;
    
    // NEXUS - social field disruption
    let nexusEffect = -magnitude * 0.15;
    
    // AURUM - economic activity pause
    let aurumEffect = -magnitude * 0.1;
    
    // LEXIS - doctrine check (is this response compliant?)
    let lexisEffect = magnitude * 0.05;
    
    // SOLUS - spawning pause (no new organisms during threat)
    let solusEffect = -magnitude * 0.3;
    
    // VETUS - threat amplification
    let vetusEffect = magnitude * 0.4;
    
    // MERIDIAN - template update
    let meridianEffect = magnitude * 0.1;
    
    // Token minting effects
    let mintingPaused = magnitude > 0.7;
    let formaRateImpact = -magnitude * FORMA_STABILITY_IMPACT;
    
    {
      cognusEffect = cognusEffect;
      nexusEffect = nexusEffect;
      aurumEffect = aurumEffect;
      lexisEffect = lexisEffect;
      solusEffect = solusEffect;
      vetusEffect = vetusEffect;
      meridianEffect = meridianEffect;
      mintingPaused = mintingPaused;
      formaRateImpact = formaRateImpact;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 22: ORGANISM INTEGRATION — ANIMAL TRAITS
  // ══════════════════════════════════════════════════════════════════════════════

  /// Compute animal trait modulation
  public func computeAnimalTraitModulation(
    magnitude: Float
  ) : AnimalTraitModulation {
    // Predator traits suppressed (can't hunt while startled)
    let predatorSuppression = magnitude * PREDATOR_SUPPRESSION_FACTOR;
    
    // Prey escape traits boosted
    let preyEscapeBoost = magnitude * PREY_ESCAPE_BOOST;
    
    // Specific animals
    let tardigradeActivation = if (magnitude > TARDIGRADE_CRYPTOBIOSIS_THRESHOLD) {
      (magnitude - TARDIGRADE_CRYPTOBIOSIS_THRESHOLD) * 5.0
    } else { 0.0 };
    
    let octopusArmFreeze = magnitude * 0.3;  // Arm coordination disrupted
    let dolphinHemisphereAlert = magnitude * 0.5;  // Wake both hemispheres
    let wolfPackAlert = magnitude * 0.4;  // Alert pack
    
    // All 22 animals (simplified)
    var animalMods = Array.init<Float>(22, 0.0);
    
    // Index by animal position in Gen 3/4 list
    animalMods[0] := magnitude * 0.3;   // Peregrine - freeze
    animalMods[1] := magnitude * 0.2;   // Bat - echolocation burst
    animalMods[2] := 0.0;               // Pistol Shrimp - no effect
    animalMods[3] := magnitude * 0.1;   // Platypus - electroreception boost
    animalMods[4] := preyEscapeBoost;   // Eagle - escape/alert
    animalMods[5] := wolfPackAlert;     // Ant - colony alert
    animalMods[12] := octopusArmFreeze; // Octopus
    animalMods[13] := dolphinHemisphereAlert; // Dolphin
    animalMods[14] := wolfPackAlert;    // Wolf
    animalMods[7] := tardigradeActivation; // Tardigrade
    
    {
      predatorSuppression = predatorSuppression;
      preyEscapeBoost = preyEscapeBoost;
      tardigradeActivation = tardigradeActivation;
      octopusArmFreeze = octopusArmFreeze;
      dolphinHemisphereAlert = dolphinHemisphereAlert;
      wolfPackAlert = wolfPackAlert;
      animalModulations = Array.freeze(animalMods);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════
  // SECTION 23: MEMORY EVENT CREATION
  // ══════════════════════════════════════════════════════════════════════════════

  /// Create memory event for startle
  public func createStartleMemoryEvent(
    currentBeat: Nat,
    stimulusIntensity: Float,
    stimulusModality: StartleModality,
    responseMagnitude: Float,
    responseLatency: Nat,
    responsePattern: StartlePattern,
    habituation: Float,
    sensitization: Float,
    fearPotentiation: Float,
    ppiActive: Bool,
    threatLevel: Float,
    arousal: Float,
    coherence: Float,
    pipelineSkipped: Bool,
    emergencyModeForced: Bool,
    expressionSuppressed: Bool
  ) : StartleMemoryEvent {
    // Compute salience (high for strong, unexpected startles)
    let baseSalience = responseMagnitude;
    let surpriseFactor = 1.0 - habituation;
    let fearFactor = fearPotentiation - 1.0;
    let salience = fclamp(baseSalience * surpriseFactor * (1.0 + fearFactor), 0.0, 1.0);
    
    // Emotional charge (negative for threat, positive for relief after)
    let emotionalCharge = -responseMagnitude * (0.5 + threatLevel * 0.5);
    
    // Memory priority
    let memoryPriority = salience * (1.0 + fearFactor);
    
    {
      beatOccurred = currentBeat;
      timestamp = 0;  // Would need actual time
      stimulusIntensity = stimulusIntensity;
      stimulusModality = stimulusModality;
      stimulusLocation = (0.0, 0.0, 0.0);
      responseMagnitude = responseMagnitude;
      responseLatency = responseLatency;
      responsePattern = responsePattern;
      habituationAtTime = habituation;
      sensitizationAtTime = sensitization;
      fearPotentiationAtTime = fearPotentiation;
      ppiActiveAtTime = ppiActive;
      threatLevelAtTime = threatLevel;
      arousalAtTime = arousal;
      coherenceAtTime = coherence;
      salience = salience;
      emotionalCharge = emotionalCharge;
      memoryPriority = memoryPriority;
      pipelineSkipped = pipelineSkipped;
      emergencyModeForced = emergencyModeForced;
      expressionSuppressed = expressionSuppressed;
    }
  };
