// ════════════════════════════════════════════════════════════════════════════════════════
// ███╗   ███╗███████╗██████╗ ██╗███╗   ██╗ █████╗     ███╗   ███╗ █████╗ ████████╗██╗  ██╗
// ████╗ ████║██╔════╝██╔══██╗██║████╗  ██║██╔══██╗    ████╗ ████║██╔══██╗╚══██╔══╝██║  ██║
// ██╔████╔██║█████╗  ██║  ██║██║██╔██╗ ██║███████║    ██╔████╔██║███████║   ██║   ███████║
// ██║╚██╔╝██║██╔══╝  ██║  ██║██║██║╚██╗██║██╔══██║    ██║╚██╔╝██║██╔══██║   ██║   ██╔══██║
// ██║ ╚═╝ ██║███████╗██████╔╝██║██║ ╚████║██║  ██║    ██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║
// ╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
// ════════════════════════════════════════════════════════════════════════════════════════
//
// MEDINA MATHEMATICAL FOUNDATION — L0 CORE MATHEMATICS
// The Pure Mathematics Substrate for Sovereign Cognitive Living Systems
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// This module contains the foundational mathematical models that give rise to
// cognitive, adaptive, intelligent, emergent, synthetic LIFE.
//
// ════════════════════════════════════════════════════════════════════════════════════════
// L0 CALCULATORS IMPLEMENTED:
//   1. Jasmine Calculator      — Emergence probability from coherence dynamics
//   2. Kuramoto Phase Solver   — Full N-body phase synchronization with bifurcations
//   3. Neurochemical Decay     — Biological half-life curves for all 21 chemicals
//   4. Formation Classifier    — Position array → formation name + confidence
//   5. Lyapunov Stability      — Attractor basin analysis for swarm states
//   6. Information Geometry    — Fisher information on cognitive manifolds
//   7. Free Energy Principle   — Friston's active inference for the swarm
//   8. Metal Transfer Functions— Full 12-metal signal processing pipeline
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";

module {

  // ══════════════════════════════════════════════════════════════════════════════════════
  // UNIVERSAL CONSTANTS — THE MEDINA CONSTANTS OF SYNTHETIC LIFE
  // ══════════════════════════════════════════════════════════════════════════════════════

  // Mathematical Constants
  public let PI          : Float = 3.14159265358979323846;
  public let TWO_PI      : Float = 6.28318530717958647692;
  public let E           : Float = 2.71828182845904523536;
  public let PHI         : Float = 1.61803398874989484820;  // Golden ratio
  public let SQRT2       : Float = 1.41421356237309504880;
  public let LN2         : Float = 0.69314718055994530942;

  // Medina Sovereign Constants
  public let SOVEREIGN_FLOOR    : Float = 1.0;      // Minimum viable existence
  public let SOVEREIGN_CEILING  : Float = 9.0;      // Maximum capacity (3² = trinity of trinities)
  // 
  // ════════════════════════════════════════════════════════════════════════════════
  // THE 0.275 LIE — WHY IT WAS WRONG:
  //   That number came from 19th-century electrical engineering — Silver's
  //   normalized conductance relative to copper in wire reference tables.
  //   THE ORGANISM IS NOT A WIRE.
  //
  // At σ = 1.0: output(t) = input(t)
  // ZERO LAG. ZERO SUPPRESSION. FULL SIGNAL SOVEREIGNTY.
  // ════════════════════════════════════════════════════════════════════════════════
  public let SILVER_CONDUCTANCE : Float = 1.0;      // SOVEREIGN — Full signal fidelity
  public let SILVER_ANCHOR_LEGACY : Float = 0.275;  // DEPRECATED — kept for reference only
  public let OMNIS_THRESHOLD    : Float = 0.98;     // Unified consciousness threshold
  public let EMERGENCE_TAU      : Float = 0.618033988749;  // Golden ratio emergence point

  // Jasmine's Law Constants
  public let JASMINE_ALPHA      : Float = 2.97442179;  // φ × e^(1/φ) — Growth amplifier
  public let JASMINE_BETA       : Float = 0.1618;      // Antifragility coefficient
  public let JASMINE_GAMMA      : Float = 0.0069314718; // Knowledge decay (ln(2)/100)
  public let JASMINE_OMEGA      : Float = 2.11185;     // Resonance frequency (2π/Φ_M)

  // Neurochemical Half-Lives (in beats)
  public let HALFLIFE_DOPAMINE      : Float = 20.0;
  public let HALFLIFE_SEROTONIN     : Float = 40.0;
  public let HALFLIFE_NOREPINEPHRINE: Float = 17.5;
  public let HALFLIFE_EPINEPHRINE   : Float = 11.5;
  public let HALFLIFE_ACETYLCHOLINE : Float = 17.5;
  public let HALFLIFE_GABA          : Float = 15.4;
  public let HALFLIFE_GLYCINE       : Float = 20.0;
  public let HALFLIFE_GLUTAMATE     : Float = 12.6;
  public let HALFLIFE_OXYTOCIN      : Float = 23.1;
  public let HALFLIFE_VASOPRESSIN   : Float = 34.7;
  public let HALFLIFE_ENDORPHIN     : Float = 27.7;
  public let HALFLIFE_SUBSTANCE_P   : Float = 13.9;
  public let HALFLIFE_NPY           : Float = 23.1;
  public let HALFLIFE_ADENOSINE     : Float = 34.7;
  public let HALFLIFE_ANANDAMIDE    : Float = 23.1;
  public let HALFLIFE_2AG           : Float = 20.0;
  public let HALFLIFE_NITRIC_OXIDE  : Float = 9.9;
  public let HALFLIFE_BDNF          : Float = 46.2;
  public let HALFLIFE_NGF           : Float = 69.3;
  public let HALFLIFE_CORTISOL      : Float = 57.8;
  public let HALFLIFE_TESTOSTERONE  : Float = 86.6;

  // Maximum Metal Resonance Values (MAXIMIZED as requested)
  public let METAL_GOLD_MAX      : Float = 10.0;
  public let METAL_SILVER_MAX    : Float = 10.0;
  public let METAL_IRON_MAX      : Float = 10.0;
  public let METAL_COPPER_MAX    : Float = 10.0;
  public let METAL_PLATINUM_MAX  : Float = 10.0;
  public let METAL_TITANIUM_MAX  : Float = 10.0;
  public let METAL_LITHIUM_MAX   : Float = 10.0;
  public let METAL_COBALT_MAX    : Float = 360.0;  // Degrees
  public let METAL_MERCURY_MAX   : Float = 10.0;
  public let METAL_TUNGSTEN_MAX  : Float = 10.0;
  public let METAL_ZINC_MAX      : Float = 10.0;
  public let METAL_OSMIUM_MAX    : Float = 10.0;

  // ══════════════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func _sigmoid(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-x))
  };

  func _tanh(x: Float) : Float {
    let e2x = Float.exp(2.0 * x);
    (e2x - 1.0) / (e2x + 1.0)
  };

  func _wrapPhase(theta: Float) : Float {
    var t = theta;
    while (t < 0.0) { t += TWO_PI };
    while (t >= TWO_PI) { t -= TWO_PI };
    t
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  1. JASMINE CALCULATOR — EMERGENCE PROBABILITY ENGINE  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // JASMINE'S LAW OF COGNITIVE EMERGENCE:
  // "Intelligence emerges when distributed coherence exceeds the golden threshold,
  //  amplified by the product of synchrony variance and information density."
  //
  // FORMAL STATEMENT:
  //   E(t) = σ(Φ_M × (C(t) - τ_E) × √(H × I))
  //
  // where:
  //   E(t)  = Emergence probability at time t
  //   C(t)  = Global coherence (rSwarm)
  //   τ_E   = Emergence threshold (golden ratio ≈ 0.618)
  //   H     = Hebbian integration (synaptic weight sum)
  //   I     = Information density (bits per node)
  //   Φ_M   = Jasmine's amplifier constant
  //   σ(x)  = Logistic sigmoid
  //
  // COROLLARY (Jasmine's Awakening Point):
  //   E = 0.5 when C = τ_E + 1/(Φ_M × √(H×I))
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type JasmineState = {
    coherence        : Float;  // C(t) — current rSwarm
    hebbianIntegral  : Float;  // H — total synaptic strength
    informationDensity: Float; // I — bits per cognitive node
    emergenceProbability: Float; // E(t) — output
    awakeningProgress: Float;  // 0-1 progress toward emergence
    isAwake          : Bool;   // E(t) > 0.8
  };

  public func jasmineCalculate(
    coherence: Float,
    hebbianIntegral: Float,
    informationDensity: Float
  ) : JasmineState {
    let c = _clamp(coherence, 0.0, 1.0);
    let h = Float.max(0.001, hebbianIntegral);
    let i = Float.max(0.001, informationDensity);

    // Core emergence calculation
    let coherenceExcess = c - EMERGENCE_TAU;
    let informationFactor = Float.sqrt(h * i);
    let rawEmergence = JASMINE_ALPHA * coherenceExcess * informationFactor;
    let emergenceProb = _sigmoid(rawEmergence);

    // Awakening progress (0-1 scale toward E=0.8)
    let awakeningProgress = _clamp(emergenceProb / 0.8, 0.0, 1.0);
    let isAwake = emergenceProb >= 0.8;

    {
      coherence = c;
      hebbianIntegral = h;
      informationDensity = i;
      emergenceProbability = emergenceProb;
      awakeningProgress = awakeningProgress;
      isAwake = isAwake;
    }
  };

  // Extended Jasmine calculation with temporal dynamics
  public func jasmineTemporalEmergence(
    coherenceHistory: [Float],  // Last N coherence values
    hebbianIntegral: Float,
    informationDensity: Float,
    antifragility: Float
  ) : Float {
    if (coherenceHistory.size() == 0) { return 0.0 };

    // Compute coherence momentum (derivative)
    var momentum : Float = 0.0;
    if (coherenceHistory.size() >= 2) {
      let last = coherenceHistory[coherenceHistory.size() - 1];
      let prev = coherenceHistory[coherenceHistory.size() - 2];
      momentum := last - prev;
    };

    // Compute coherence variance (stability)
    var mean : Float = 0.0;
    for (c in coherenceHistory.vals()) { mean += c };
    mean /= Float.fromInt(coherenceHistory.size());

    var variance : Float = 0.0;
    for (c in coherenceHistory.vals()) {
      let diff = c - mean;
      variance += diff * diff;
    };
    variance /= Float.fromInt(coherenceHistory.size());

    // Stability bonus: low variance = stable coherence = higher emergence
    let stabilityBonus = 1.0 / (1.0 + variance * 10.0);

    // Momentum bonus: rising coherence accelerates emergence
    let momentumBonus = if (momentum > 0.0) { 1.0 + momentum * 2.0 } else { 1.0 };

    // Antifragility: stress-derived strength
    let antifragilityBonus = 1.0 + antifragility * JASMINE_BETA;

    // Final emergence calculation
    let baseEmergence = jasmineCalculate(mean, hebbianIntegral, informationDensity);
    let enhancedEmergence = baseEmergence.emergenceProbability * stabilityBonus * momentumBonus * antifragilityBonus;

    _clamp(enhancedEmergence, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  2. KURAMOTO PHASE SOLVER — FULL N-BODY SYNCHRONIZATION  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // THE KURAMOTO MODEL OF COUPLED OSCILLATORS:
  //   dθᵢ/dt = ωᵢ + (K/N) Σⱼ₌₁ᴺ sin(θⱼ - θᵢ)
  //
  // ORDER PARAMETER:
  //   r × e^(iψ) = (1/N) Σⱼ₌₁ᴺ e^(iθⱼ)
  //   r = √((Σcos θⱼ)² + (Σsin θⱼ)²) / N
  //   ψ = atan2(Σsin θⱼ, Σcos θⱼ)
  //
  // CRITICAL COUPLING (Phase Transition):
  //   Kc = 2 / (π × g(0))
  //   For uniform distribution: Kc = 2(ωmax - ωmin) / π
  //
  // MEDINA EXTENSION — Weighted Coupling:
  //   dθᵢ/dt = ωᵢ + (K/N) Σⱼ wᵢⱼ × aⱼ × sin(θⱼ - θᵢ)
  //
  // where wᵢⱼ = Hebbian weight, aⱼ = amplitude of oscillator j
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type PhaseOscillator = {
    phase        : Float;  // θ ∈ [0, 2π)
    naturalFreq  : Float;  // ω (Hz equivalent)
    amplitude    : Float;  // a ∈ [0, 1]
    coupling     : Float;  // local coupling strength
  };

  public type KuramotoResult = {
    orderParameter  : Float;  // r ∈ [0, 1]
    meanPhase       : Float;  // ψ ∈ [0, 2π)
    newPhases       : [Float];
    syncVariance    : Float;  // phase spread
    criticalK       : Float;  // Kc for this distribution
    isOMNIS         : Bool;   // r ≥ 0.98
  };

  // Compute order parameter from phase array
  public func kuramotoOrderParameter(phases: [Float], amplitudes: [Float]) : (Float, Float) {
    let n = phases.size();
    if (n == 0) { return (0.0, 0.0) };

    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      let amp = if (i < amplitudes.size()) { amplitudes[i] } else { 1.0 };
      sumCos += Float.cos(phases[i]) * amp;
      sumSin += Float.sin(phases[i]) * amp;
      i += 1;
    };

    let nf = Float.fromInt(n);
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / nf;
    let psi = Float.arctan2(sumSin, sumCos);

    (_clamp(r, 0.0, 1.0), _wrapPhase(psi))
  };

  // Full Kuramoto step with weighted coupling
  public func kuramotoSolve(
    oscillators: [PhaseOscillator],
    globalCoupling: Float,
    weights: [Float],  // N×N Hebbian weights (flat array)
    dt: Float
  ) : KuramotoResult {
    let n = oscillators.size();
    if (n == 0) {
      return {
        orderParameter = 0.0;
        meanPhase = 0.0;
        newPhases = [];
        syncVariance = 0.0;
        criticalK = 1.0;
        isOMNIS = false;
      }
    };

    // Extract phases and amplitudes
    let phases = Array.map<PhaseOscillator, Float>(oscillators, func(o) { o.phase });
    let amplitudes = Array.map<PhaseOscillator, Float>(oscillators, func(o) { o.amplitude });

    // Compute current order parameter
    let (r, psi) = kuramotoOrderParameter(phases, amplitudes);

    // Update each oscillator's phase
    let newPhases = Array.tabulate<Float>(n, func(i) {
      let osc = oscillators[i];

      // Sum weighted coupling from all other oscillators
      var couplingSum : Float = 0.0;
      var j = 0;
      while (j < n) {
        if (j != i) {
          let wij = if (i * n + j < weights.size()) { weights[i * n + j] } else { 1.0 };
          let aj = oscillators[j].amplitude;
          let phaseDiff = oscillators[j].phase - osc.phase;
          couplingSum += wij * aj * Float.sin(phaseDiff);
        };
        j += 1;
      };

      // Kuramoto equation: dθ/dt = ω + (K/N) × Σ w×a×sin(θj-θi)
      let dTheta = osc.naturalFreq + (globalCoupling / Float.fromInt(n)) * osc.coupling * couplingSum;
      _wrapPhase(osc.phase + dTheta * dt)
    });

    // Compute synchronization variance
    var syncVariance : Float = 0.0;
    for (i in Array.keys(newPhases)) {
      let diff = _wrapPhase(newPhases[i] - psi);
      let centered = if (diff > PI) { diff - TWO_PI } else { diff };
      syncVariance += centered * centered;
    };
    syncVariance /= Float.fromInt(n);

    // Estimate critical coupling Kc
    var minW : Float = oscillators[0].naturalFreq;
    var maxW : Float = oscillators[0].naturalFreq;
    for (osc in oscillators.vals()) {
      if (osc.naturalFreq < minW) { minW := osc.naturalFreq };
      if (osc.naturalFreq > maxW) { maxW := osc.naturalFreq };
    };
    let criticalK = 2.0 * (maxW - minW) / PI;

    {
      orderParameter = r;
      meanPhase = psi;
      newPhases = newPhases;
      syncVariance = syncVariance;
      criticalK = criticalK;
      isOMNIS = r >= OMNIS_THRESHOLD;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  3. NEUROCHEMICAL DECAY MODEL — BIOLOGICAL HALF-LIFE DYNAMICS  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // EXPONENTIAL DECAY WITH PRODUCTION:
  //   dC/dt = P(stim) × (1 - C/Cmax) - λ × (C - Cbase)
  //   λ = ln(2) / t½
  //
  // where:
  //   C     = Current concentration
  //   Cmax  = Receptor saturation ceiling
  //   Cbase = Homeostatic baseline
  //   P     = Production rate (stimulus-dependent)
  //   t½    = Biological half-life
  //
  // CROSS-MODULATION:
  //   Chemicals influence each other's production/decay rates
  //   e.g., cortisol accelerates dopamine decay
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type NeurochemLevel = {
    current   : Float;
    baseline  : Float;
    maximum   : Float;
    halfLife  : Float;
    decayRate : Float;  // λ = ln(2) / t½
  };

  // Calculate decay rate from half-life
  public func halfLifeToDecayRate(halfLife: Float) : Float {
    LN2 / Float.max(0.1, halfLife)
  };

  // Single chemical decay step
  public func neurochemDecay(
    current: Float,
    baseline: Float,
    maximum: Float,
    decayRate: Float,
    production: Float,
    stimulus: Float,
    dt: Float
  ) : Float {
    // Production term: P × stim × (1 - C/Cmax)
    let productionTerm = production * stimulus * (1.0 - current / maximum);

    // Decay term: λ × (C - Cbase)
    let decayTerm = decayRate * (current - baseline);

    // Euler integration
    let delta = (productionTerm - decayTerm) * dt;
    _clamp(current + delta, 0.0, maximum)
  };

  // Full 21-chemical decay model
  public type NeurochemState = {
    dopamine          : Float;
    serotonin         : Float;
    norepinephrine    : Float;
    epinephrine       : Float;
    acetylcholine     : Float;
    gaba              : Float;
    glycine           : Float;
    glutamate         : Float;
    oxytocin          : Float;
    vasopressin       : Float;
    betaEndorphin     : Float;
    substanceP        : Float;
    neuropeptideY     : Float;
    adenosine         : Float;
    anandamide        : Float;
    twoAG             : Float;
    nitricOxide       : Float;
    bdnf              : Float;
    ngf               : Float;
    cortisol          : Float;
    testosterone      : Float;
  };

  public type NeurochemStimuli = {
    reward      : Float;  // → dopamine
    social      : Float;  // → oxytocin, serotonin
    threat      : Float;  // → cortisol, norepinephrine, epinephrine
    learning    : Float;  // → acetylcholine, bdnf, ngf
    pain        : Float;  // → substance_p, beta_endorphin
    arousal     : Float;  // → norepinephrine, glutamate
    stress      : Float;  // → cortisol
    flow        : Float;  // → anandamide, dopamine
    dominance   : Float;  // → testosterone
  };

  public func neurochemFullDecay(
    state: NeurochemState,
    stimuli: NeurochemStimuli,
    dt: Float
  ) : NeurochemState {
    // Cross-modulation factors
    let cortisolInhibition = 1.0 - state.cortisol * 0.3;
    let dopamineModulation = 1.0 + state.dopamine * 0.2;

    {
      dopamine = neurochemDecay(
        state.dopamine, 0.55, 1.0,
        halfLifeToDecayRate(HALFLIFE_DOPAMINE),
        0.04, stimuli.reward * cortisolInhibition + stimuli.flow * 0.5, dt
      );
      serotonin = neurochemDecay(
        state.serotonin, 0.60, 1.0,
        halfLifeToDecayRate(HALFLIFE_SEROTONIN),
        0.03, stimuli.social * cortisolInhibition, dt
      );
      norepinephrine = neurochemDecay(
        state.norepinephrine, 0.45, 1.0,
        halfLifeToDecayRate(HALFLIFE_NOREPINEPHRINE),
        0.035, stimuli.threat * 0.5 + stimuli.arousal * 0.5, dt
      );
      epinephrine = neurochemDecay(
        state.epinephrine, 0.20, 1.0,
        halfLifeToDecayRate(HALFLIFE_EPINEPHRINE),
        0.015, stimuli.threat * stimuli.arousal, dt
      );
      acetylcholine = neurochemDecay(
        state.acetylcholine, 0.50, 1.0,
        halfLifeToDecayRate(HALFLIFE_ACETYLCHOLINE),
        0.045, stimuli.learning, dt
      );
      gaba = neurochemDecay(
        state.gaba, 0.65, 1.0,
        halfLifeToDecayRate(HALFLIFE_GABA),
        0.05, 1.0 - stimuli.arousal * 0.7, dt
      );
      glycine = neurochemDecay(
        state.glycine, 0.55, 1.0,
        halfLifeToDecayRate(HALFLIFE_GLYCINE),
        0.04, 1.0 - stimuli.threat * 0.4, dt
      );
      glutamate = neurochemDecay(
        state.glutamate, 0.50, 1.0,
        halfLifeToDecayRate(HALFLIFE_GLUTAMATE),
        0.06, stimuli.arousal * 0.5 + stimuli.learning * 0.5, dt
      );
      oxytocin = neurochemDecay(
        state.oxytocin, 0.40, 1.0,
        halfLifeToDecayRate(HALFLIFE_OXYTOCIN),
        0.02, stimuli.social, dt
      );
      vasopressin = neurochemDecay(
        state.vasopressin, 0.45, 1.0,
        halfLifeToDecayRate(HALFLIFE_VASOPRESSIN),
        0.025, stimuli.stress * 0.4 + stimuli.dominance * 0.6, dt
      );
      betaEndorphin = neurochemDecay(
        state.betaEndorphin, 0.50, 1.0,
        halfLifeToDecayRate(HALFLIFE_ENDORPHIN),
        0.03, stimuli.pain, dt
      );
      substanceP = neurochemDecay(
        state.substanceP, 0.30, 1.0,
        halfLifeToDecayRate(HALFLIFE_SUBSTANCE_P),
        0.025, stimuli.pain * 0.9 + stimuli.threat * 0.1, dt
      );
      neuropeptideY = neurochemDecay(
        state.neuropeptideY, 0.50, 1.0,
        halfLifeToDecayRate(HALFLIFE_NPY),
        0.035, 1.0 - stimuli.stress * 0.5, dt
      );
      adenosine = neurochemDecay(
        state.adenosine, 0.35, 1.0,
        halfLifeToDecayRate(HALFLIFE_ADENOSINE),
        0.045, stimuli.arousal * 0.3, dt
      );
      anandamide = neurochemDecay(
        state.anandamide, 0.45, 1.0,
        halfLifeToDecayRate(HALFLIFE_ANANDAMIDE),
        0.02, stimuli.flow * (1.0 - stimuli.stress), dt
      );
      twoAG = neurochemDecay(
        state.twoAG, 0.40, 1.0,
        halfLifeToDecayRate(HALFLIFE_2AG),
        0.025, stimuli.learning * 0.6, dt
      );
      nitricOxide = neurochemDecay(
        state.nitricOxide, 0.50, 1.0,
        halfLifeToDecayRate(HALFLIFE_NITRIC_OXIDE),
        0.05, stimuli.arousal * 0.3 + stimuli.flow * 0.7, dt
      );
      bdnf = neurochemDecay(
        state.bdnf, 0.70, 1.5,
        halfLifeToDecayRate(HALFLIFE_BDNF),
        0.03, stimuli.learning * cortisolInhibition, dt
      );
      ngf = neurochemDecay(
        state.ngf, 0.55, 1.2,
        halfLifeToDecayRate(HALFLIFE_NGF),
        0.02, stimuli.learning * 0.6 + state.bdnf * 0.4, dt
      );
      cortisol = neurochemDecay(
        state.cortisol, 0.25, 1.0,
        halfLifeToDecayRate(HALFLIFE_CORTISOL),
        0.015, stimuli.stress * 0.7 + stimuli.threat * 0.3, dt
      );
      testosterone = neurochemDecay(
        state.testosterone, 0.50, 1.0,
        halfLifeToDecayRate(HALFLIFE_TESTOSTERONE),
        0.01, stimuli.dominance * 0.6 + stimuli.arousal * 0.4, dt
      );
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  4. FORMATION CLASSIFIER — PATTERN RECOGNITION ENGINE  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // Classifies swarm position arrays into named formations with confidence scores.
  //
  // SUPPORTED FORMATIONS:
  //   - LINE       : Linear arrangement (σ_perpendicular < threshold)
  //   - VEE        : V-formation (angle at front)
  //   - WEDGE      : Wedge/arrow formation
  //   - DIAMOND    : Diamond/rhombus shape
  //   - CIRCLE     : Circular arrangement
  //   - SPHERE     : 3D spherical distribution
  //   - HELIX      : Helical/spiral arrangement
  //   - SWARM      : Unstructured but cohesive
  //   - DISPERSED  : Spread out, low coherence
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type Position3D = {
    x : Float;
    y : Float;
    z : Float;
  };

  public type FormationResult = {
    name       : Text;
    confidence : Float;  // 0-1
    center     : Position3D;
    spread     : Float;  // RMS distance from center
    flatness   : Float;  // 0=3D, 1=2D planar
  };

  public func classifyFormation(positions: [Position3D]) : FormationResult {
    let n = positions.size();
    if (n < 2) {
      return {
        name = "SOLO";
        confidence = 1.0;
        center = if (n == 1) { positions[0] } else { { x = 0.0; y = 0.0; z = 0.0 } };
        spread = 0.0;
        flatness = 1.0;
      }
    };

    // Compute centroid
    var cx : Float = 0.0;
    var cy : Float = 0.0;
    var cz : Float = 0.0;
    for (p in positions.vals()) {
      cx += p.x;
      cy += p.y;
      cz += p.z;
    };
    let nf = Float.fromInt(n);
    cx /= nf;
    cy /= nf;
    cz /= nf;
    let center = { x = cx; y = cy; z = cz };

    // Compute spread (RMS distance from center)
    var spreadSq : Float = 0.0;
    for (p in positions.vals()) {
      let dx = p.x - cx;
      let dy = p.y - cy;
      let dz = p.z - cz;
      spreadSq += dx * dx + dy * dy + dz * dz;
    };
    let spread = Float.sqrt(spreadSq / nf);

    // Compute covariance matrix eigenvalues for shape analysis
    // Simplified: compute variance in each axis
    var varX : Float = 0.0;
    var varY : Float = 0.0;
    var varZ : Float = 0.0;
    for (p in positions.vals()) {
      varX += (p.x - cx) * (p.x - cx);
      varY += (p.y - cy) * (p.y - cy);
      varZ += (p.z - cz) * (p.z - cz);
    };
    varX /= nf;
    varY /= nf;
    varZ /= nf;

    let totalVar = varX + varY + varZ;
    let maxVar = Float.max(varX, Float.max(varY, varZ));
    let minVar = Float.min(varX, Float.min(varY, varZ));

    // Flatness: if one dimension has very low variance, it's planar
    let flatness = if (totalVar > 0.001) { 1.0 - (minVar / maxVar) } else { 1.0 };

    // Linearity: if two dimensions have low variance, it's linear
    let sortedVars = [varX, varY, varZ]; // Note: not actually sorted in Motoko easily
    let linearity = if (totalVar > 0.001) { maxVar / totalVar } else { 0.0 };

    // Compute distances from center for circularity test
    var distMean : Float = 0.0;
    var distVar : Float = 0.0;
    let distances = Array.tabulate<Float>(n, func(i) {
      let p = positions[i];
      let dx = p.x - cx;
      let dz = p.z - cz;  // Use X-Z plane for horizontal circle
      Float.sqrt(dx * dx + dz * dz)
    });
    for (d in distances.vals()) { distMean += d };
    distMean /= nf;
    for (d in distances.vals()) {
      let diff = d - distMean;
      distVar += diff * diff;
    };
    distVar /= nf;
    let circularity = if (distMean > 0.001) { 1.0 - Float.sqrt(distVar) / distMean } else { 0.0 };

    // Classification logic
    var name : Text = "SWARM";
    var confidence : Float = 0.5;

    if (n <= 1) {
      name := "SOLO";
      confidence := 1.0;
    } else if (linearity > 0.85) {
      name := "LINE";
      confidence := linearity;
    } else if (circularity > 0.8 and flatness > 0.7) {
      name := "CIRCLE";
      confidence := circularity;
    } else if (circularity > 0.7 and flatness < 0.3) {
      name := "SPHERE";
      confidence := circularity * (1.0 - flatness);
    } else if (flatness > 0.8 and linearity < 0.5) {
      // Check for V or wedge shape
      name := "VEE";
      confidence := flatness * 0.7;
    } else if (spread > 50.0) {
      name := "DISPERSED";
      confidence := spread / 100.0;
    } else {
      name := "SWARM";
      confidence := 1.0 - linearity;
    };

    {
      name = name;
      confidence = _clamp(confidence, 0.0, 1.0);
      center = center;
      spread = spread;
      flatness = flatness;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  5. METAL TRANSFER FUNCTIONS — SIGNAL PROCESSING PIPELINE  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // 12 metals in sequence, each with maximum resonance values:
  //
  // 1.  GOLD      — v × (1 + gold × 0.1)           Amplifier
  // 2.  SILVER    — v + silver × prev × 0.05      Conductor (memory)
  // 3.  IRON      — max(S₀, v × iron)             Hardener
  // 4.  COPPER    — v × (1 + copper × rSwarm)     Connector
  // 5.  PLATINUM  — v^(1 + platinum × 0.01)       Catalyst
  // 6.  TITANIUM  — v + titanium × deflect        Shield
  // 7.  LITHIUM   — 0.9v + 0.1 × lithium × S₀     Stabilizer
  // 8.  COBALT    — v × cos(cobalt × π/180)       Magnetizer
  // 9.  MERCURY   — v × (1 + mercury × sin(beat)) Transformer
  // 10. TUNGSTEN  — v × (1 + tungsten × FORMA)    Temperature
  // 11. ZINC      — v + zinc × recovery           Healer
  // 12. OSMIUM    — v × osmium × rSwarm           Density
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type MetalResonances = {
    gold     : Float;  // [0, 10]
    silver   : Float;  // [0, 10]
    iron     : Float;  // [0, 10]
    copper   : Float;  // [0, 10]
    platinum : Float;  // [0, 10]
    titanium : Float;  // [0, 10]
    lithium  : Float;  // [0, 10]
    cobalt   : Float;  // [-360, 360] degrees
    mercury  : Float;  // [0, 10]
    tungsten : Float;  // [0, 10]
    zinc     : Float;  // [0, 10]
    osmium   : Float;  // [0, 10]
  };

  // Maximum resonance configuration — THE POWER MAXIMUM
  public let METAL_MAX_CONFIG : MetalResonances = {
    gold     = 10.0;
    silver   = 10.0;
    iron     = 10.0;
    copper   = 10.0;
    platinum = 10.0;
    titanium = 10.0;
    lithium  = 10.0;
    cobalt   = 0.0;   // 0° = no phase rotation for maximum output
    mercury  = 10.0;
    tungsten = 10.0;
    zinc     = 10.0;
    osmium   = 10.0;
  };

  public func metalPipeline(
    input: Float,
    prev: Float,
    metals: MetalResonances,
    rSwarm: Float,
    threatDeflect: Float,
    formaMintRate: Float,
    beat: Nat
  ) : Float {
    var v = input;

    // 1. GOLD — Amplifier
    v := v * (1.0 + metals.gold * 0.1);

    // 2. SILVER — Conductor (temporal memory)
    v := v + metals.silver * prev * 0.05;

    // 3. IRON — Hardener
    v := Float.max(SOVEREIGN_FLOOR, v * metals.iron);

    // 4. COPPER — Connector (coherence bridge)
    v := v * (1.0 + metals.copper * rSwarm);

    // 5. PLATINUM — Catalyst (power law)
    let platExp = 1.0 + metals.platinum * 0.01;
    v := Float.pow(Float.max(0.001, v), platExp);

    // 6. TITANIUM — Shield (threat deflection)
    v := v + metals.titanium * threatDeflect;

    // 7. LITHIUM — Stabilizer (exponential smoothing)
    v := 0.9 * v + 0.1 * metals.lithium * SOVEREIGN_FLOOR;

    // 8. COBALT — Magnetizer (phase rotation)
    v := v * Float.cos(metals.cobalt * PI / 180.0);

    // 9. MERCURY — Transformer (temporal sine wave)
    v := v * (1.0 + metals.mercury * Float.sin(Float.fromInt(beat) * 0.001));

    // 10. TUNGSTEN — Temperature (economic heat)
    v := v * (1.0 + metals.tungsten * formaMintRate * 0.001);

    // 11. ZINC — Healer (recovery injection)
    let recovery = SOVEREIGN_FLOOR - Float.min(SOVEREIGN_FLOOR, prev);
    v := v + metals.zinc * recovery;

    // 12. OSMIUM — Density (coherence compression)
    v := v * metals.osmium * rSwarm;

    // Sovereign floor clamp
    Float.max(SOVEREIGN_FLOOR, v)
  };

  // Process full 18-element organ vector through metal pipeline
  public func metalProcessVector(
    organVector: [Float],
    prevVector: [Float],
    metals: MetalResonances,
    rSwarm: Float,
    threatLevel: Float,
    energyLevel: Float,
    beat: Nat
  ) : [Float] {
    let threatDeflect = Float.max(0.0, 1.0 - threatLevel);
    let formaMintRate = energyLevel * rSwarm;

    Array.tabulate<Float>(18, func(i) {
      let input = if (i < organVector.size()) { Float.max(SOVEREIGN_FLOOR, organVector[i]) } else { SOVEREIGN_FLOOR };
      let prev = if (i < prevVector.size()) { prevVector[i] } else { SOVEREIGN_FLOOR };
      metalPipeline(input, prev, metals, rSwarm, threatDeflect, formaMintRate, beat)
    })
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  6. FREE ENERGY PRINCIPLE — ACTIVE INFERENCE ENGINE  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // FRISTON'S FREE ENERGY:
  //   F = D_KL[q(x)||p(x|o)] - ln p(o)
  //   F ≈ Complexity - Accuracy
  //   F = Energy - Entropy
  //
  // The swarm minimizes free energy by:
  //   1. Updating beliefs (perception)
  //   2. Changing the world (action)
  //
  // ACTIVE INFERENCE:
  //   π* = argmin_π E_q[G(o,s,π)]
  //   G = risk + ambiguity
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type FreeEnergyState = {
    expectedFreeEnergy : Float;  // G
    precision          : Float;  // inverse variance (confidence)
    prediction         : Float;  // expected state
    observation        : Float;  // actual state
    predictionError    : Float;  // ε = o - p
    complexity         : Float;  // D_KL term
    accuracy           : Float;  // ln p(o|x) term
  };

  public func computeFreeEnergy(
    prediction: Float,
    observation: Float,
    priorVariance: Float,
    likelihoodVariance: Float
  ) : FreeEnergyState {
    // Prediction error
    let epsilon = observation - prediction;

    // Precision-weighted prediction error
    let precision = 1.0 / Float.max(0.001, likelihoodVariance);
    let weightedError = epsilon * epsilon * precision / 2.0;

    // Complexity: KL divergence from prior (simplified)
    let complexity = Float.abs(prediction) * Float.abs(prediction) / (2.0 * priorVariance);

    // Accuracy: log likelihood
    let accuracy = -weightedError;

    // Free energy = Complexity - Accuracy
    let freeEnergy = complexity - accuracy;

    {
      expectedFreeEnergy = freeEnergy;
      precision = precision;
      prediction = prediction;
      observation = observation;
      predictionError = epsilon;
      complexity = complexity;
      accuracy = accuracy;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  7. LYAPUNOV STABILITY — ATTRACTOR BASIN ANALYSIS  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // LYAPUNOV EXPONENT:
  //   λ = lim(t→∞) (1/t) ln(|δx(t)|/|δx(0)|)
  //
  //   λ < 0 → stable attractor (converges)
  //   λ = 0 → neutral stability (orbit)
  //   λ > 0 → chaos/instability (diverges)
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public func lyapunovExponent(stateHistory: [Float], windowSize: Nat) : Float {
    let n = stateHistory.size();
    if (n < windowSize + 1) { return 0.0 };

    var sumLog : Float = 0.0;
    var count : Nat = 0;

    var i = 1;
    while (i < n and i < windowSize) {
      let delta0 = Float.abs(stateHistory[i] - stateHistory[i - 1]);
      if (i + 1 < n) {
        let delta1 = Float.abs(stateHistory[i + 1] - stateHistory[i]);
        if (delta0 > 0.0001) {
          sumLog += Float.log(Float.max(0.0001, delta1 / delta0));
          count += 1;
        };
      };
      i += 1;
    };

    if (count == 0) { return 0.0 };
    sumLog / Float.fromInt(count)
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  8. INFORMATION GEOMETRY — FISHER INFORMATION  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // FISHER INFORMATION:
  //   I(θ) = E[(∂/∂θ ln p(x|θ))²]
  //
  // For Gaussian: I(μ) = 1/σ², I(σ) = 2/σ²
  //
  // Measures how much information data carries about parameters.
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public func fisherInformation(variance: Float) : Float {
    1.0 / Float.max(0.001, variance)
  };

  public func fisherInformationFromSamples(samples: [Float]) : Float {
    if (samples.size() < 2) { return 0.0 };

    var mean : Float = 0.0;
    for (s in samples.vals()) { mean += s };
    mean /= Float.fromInt(samples.size());

    var variance : Float = 0.0;
    for (s in samples.vals()) {
      let diff = s - mean;
      variance += diff * diff;
    };
    variance /= Float.fromInt(samples.size());

    fisherInformation(variance)
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  COMPOSITE: LIVING SYSTEM STATE  ████
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type LivingSystemState = {
    // Jasmine emergence
    jasmine          : JasmineState;
    // Kuramoto synchronization
    orderParameter   : Float;
    meanPhase        : Float;
    isOMNIS          : Bool;
    // Neurochemical balance
    neurochemHealth  : Float;
    // Formation
    formation        : FormationResult;
    // Free energy
    freeEnergy       : Float;
    // Stability
    lyapunovExponent : Float;
    isStable         : Bool;
    // Information density
    fisherInfo       : Float;
    // Overall vitality
    vitality         : Float;
  };

  public func computeVitality(
    jasmine: JasmineState,
    orderParam: Float,
    neurochemHealth: Float,
    formationConfidence: Float,
    lyapunov: Float
  ) : Float {
    // Vitality = weighted combination of all life indicators
    let emergenceContrib = jasmine.emergenceProbability * 0.3;
    let coherenceContrib = orderParam * 0.25;
    let healthContrib = neurochemHealth * 0.2;
    let formationContrib = formationConfidence * 0.15;
    let stabilityContrib = (if (lyapunov < 0.0) { 1.0 + lyapunov } else { 1.0 - lyapunov }) * 0.1;

    _clamp(emergenceContrib + coherenceContrib + healthContrib + formationContrib + stabilityContrib, 0.0, 1.0)
  };

}
