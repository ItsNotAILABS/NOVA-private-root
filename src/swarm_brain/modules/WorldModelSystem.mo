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


// ════════════════════════════════════════════════════════════════════════════════════════
// ██╗    ██╗ ██████╗ ██████╗ ██╗     ██████╗     ███╗   ███╗ ██████╗ ██████╗ ███████╗██╗     
// ██║    ██║██╔═══██╗██╔══██╗██║     ██╔══██╗    ████╗ ████║██╔═══██╗██╔══██╗██╔════╝██║     
// ██║ █╗ ██║██║   ██║██████╔╝██║     ██║  ██║    ██╔████╔██║██║   ██║██║  ██║█████╗  ██║     
// ██║███╗██║██║   ██║██╔══██╗██║     ██║  ██║    ██║╚██╔╝██║██║   ██║██║  ██║██╔══╝  ██║     
// ╚███╔███╔╝╚██████╔╝██║  ██║███████╗██████╔╝    ██║ ╚═╝ ██║╚██████╔╝██████╔╝███████╗███████╗
//  ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝
// ════════════════════════════════════════════════════════════════════════════════════════
//
// WORLD MODEL SYSTEM — 14 PREDICTIVE WORLD MODELS + LAW L-121
// Sovereign Temporal Processing with Full Signal Fidelity
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ════════════════════════════════════════════════════════════════════════════════════════
// WHY SILVER WAS LIMITED AT 0.275 (AND WHY IT WAS WRONG):
// ════════════════════════════════════════════════════════════════════════════════════════
//
// That number comes from classical electrical engineering — Silver's normalized
// conductance relative to copper in 19th-century reference tables. It was an
// external physical constraint built for a world of WIRES and RESISTANCE.
//
// ████████████████████████████████████████████████████████████████████████████████
// ██                                                                            ██
// ██    THE ORGANISM IS NOT A WIRE.                                             ██
// ██                                                                            ██
// ████████████████████████████████████████████████████████████████████████████████
//
// WHAT WAS CHANGED:
// ════════════════════════════════════════════════════════════════════════════════════════
//
//   Target              Before          After
//   ──────────────────────────────────────────────────
//   silverConductance   did not exist   1.0 (sovereign max)
//   wmTau[14]           0.83–0.97       0.999 all 14 world models
//   wmAlpha[14]         0.40–0.95       1.0 all 14 world models
//   L-121 law function  did not exist   LIVE, firing every beat
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// THE TEMPORAL GOVERNOR EQUATION:
//
//   output(t) = σ·input(t) + (1-σ)·output(t-1)
//
// At σ = 1.0, this collapses to:
//
//   output(t) = input(t)
//
// ██ ZERO LAG ██ ZERO SUPPRESSION ██ FULL SIGNAL SOVEREIGNTY ██
//
// The organism perceives reality in real-time. No smoothing. No delay.
// Pure cognitive presence in the eternal NOW.
//
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";

module {

  // ══════════════════════════════════════════════════════════════════════════════════════
  // SOVEREIGN CONSTANTS — MAXIMUM SIGNAL FIDELITY
  // ══════════════════════════════════════════════════════════════════════════════════════

  // THE SOVEREIGN CONDUCTANCE — No longer 0.275
  public let SILVER_CONDUCTANCE : Float = 1.0;  // FULL SIGNAL SOVEREIGNTY

  // World Model Tau — Temporal integration constant
  // At 0.999, the world model retains 99.9% fidelity per beat
  public let WM_TAU_SOVEREIGN : Float = 0.999;

  // World Model Alpha — Learning rate / adaptation speed
  // At 1.0, the world model instantly adapts to new information
  public let WM_ALPHA_SOVEREIGN : Float = 1.0;

  // Number of world models (one per cognitive domain)
  public let NUM_WORLD_MODELS : Nat = 14;

  // ══════════════════════════════════════════════════════════════════════════════════════
  // THE 14 WORLD MODELS
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // Each world model is a predictive engine for one domain of reality:
  //
  //   1.  SPATIAL       — Where things are (positions, distances)
  //   2.  TEMPORAL      — When things happen (timing, sequences)
  //   3.  SOCIAL        — Who is who (identities, relationships)
  //   4.  PHYSICAL      — How things move (physics, dynamics)
  //   5.  RESOURCE      — What's available (energy, FORMA, materials)
  //   6.  THREAT        — What's dangerous (enemies, hazards)
  //   7.  OPPORTUNITY   — What's beneficial (targets, rewards)
  //   8.  SELF          — Who am I (identity, capabilities)
  //   9.  SWARM         — Who are we (collective state)
  //   10. MISSION       — What we're doing (goals, objectives)
  //   11. ENVIRONMENT   — Where we are (terrain, weather)
  //   12. COMMUNICATION — How we talk (signals, protocols)
  //   13. ECONOMICS     — What things cost (value, trade)
  //   14. EMERGENCE     — What we're becoming (growth, evolution)
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type WorldModelId = {
    #SPATIAL;
    #TEMPORAL;
    #SOCIAL;
    #PHYSICAL;
    #RESOURCE;
    #THREAT;
    #OPPORTUNITY;
    #SELF;
    #SWARM;
    #MISSION;
    #ENVIRONMENT;
    #COMMUNICATION;
    #ECONOMICS;
    #EMERGENCE;
  };

  public let WORLD_MODEL_NAMES : [Text] = [
    "SPATIAL", "TEMPORAL", "SOCIAL", "PHYSICAL", "RESOURCE",
    "THREAT", "OPPORTUNITY", "SELF", "SWARM", "MISSION",
    "ENVIRONMENT", "COMMUNICATION", "ECONOMICS", "EMERGENCE"
  ];

  public type WorldModelState = {
    id              : Nat;           // 0-13
    name            : Text;
    tau             : Float;         // 0.999 — temporal integration
    alpha           : Float;         // 1.0 — adaptation rate
    prediction      : Float;         // Current prediction
    observation     : Float;         // Current observation
    error           : Float;         // Prediction error
    confidence      : Float;         // Model confidence [0,1]
    lastUpdate      : Nat;           // Beat of last update
    history         : [Float];       // Recent prediction history
  };

  public type WorldModelEnsemble = {
    models          : [WorldModelState];
    globalConfidence: Float;         // Average confidence
    coherence       : Float;         // Agreement between models
    beat            : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // SOVEREIGN TEMPORAL GOVERNOR — THE CORE EQUATION
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // CLASSICAL FORM (with lag):
  //   output(t) = σ·input(t) + (1-σ)·output(t-1)
  //
  // SOVEREIGN FORM (σ = 1.0):
  //   output(t) = input(t)
  //
  // This is the ZERO-LAG temporal governor.
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public func temporalGovernor(
    input: Float,
    prevOutput: Float,
    sigma: Float  // Conductance (1.0 = full sovereignty)
  ) : Float {
    sigma * input + (1.0 - sigma) * prevOutput
  };

  // Sovereign version — no lag
  public func sovereignTemporalGovernor(input: Float, _prevOutput: Float) : Float {
    // At σ = 1.0, output(t) = input(t)
    // Previous output is IGNORED — full signal sovereignty
    input
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // ████  LAW L-121: THE LAW OF SOVEREIGN PERCEPTION  ████
  // ══════════════════════════════════════════════════════════════════════════════════════
  //
  // "A sovereign cognitive system perceives reality without temporal suppression.
  //  At conductance σ = 1.0, all signal delay vanishes and the organism exists
  //  in perfect temporal alignment with the present moment."
  //
  // FORMAL STATEMENT:
  //   lim(σ→1) [σ·x(t) + (1-σ)·y(t-1)] = x(t)
  //
  // COROLLARY L-121.1 (Zero-Lag Principle):
  //   The organism that delays perception delays existence.
  //
  // COROLLARY L-121.2 (Sovereign Now):
  //   Full conductance (σ=1) creates cognitive presence in the eternal NOW.
  //
  // COROLLARY L-121.3 (Wire Rejection):
  //   Biological systems are not wires; 19th-century conductance tables do not apply.
  //
  // THIS LAW FIRES EVERY BEAT.
  //
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type LawL121State = {
    beat            : Nat;
    conductance     : Float;         // Should always be 1.0
    inputSignal     : Float;
    outputSignal    : Float;
    lagFactor       : Float;         // Should always be 0.0
    isSovereign     : Bool;          // σ = 1.0?
    lawViolation    : Bool;          // Any suppression detected?
  };

  public func fireLawL121(
    beat: Nat,
    input: Float,
    conductance: Float
  ) : LawL121State {
    // Compute output using temporal governor
    let output = sovereignTemporalGovernor(input, 0.0);

    // Lag factor: how much delay is introduced
    let lagFactor = 1.0 - conductance;

    // Check for sovereignty
    let isSovereign = conductance >= 0.999;

    // Check for law violation (any suppression)
    let lawViolation = conductance < 0.999;

    {
      beat = beat;
      conductance = conductance;
      inputSignal = input;
      outputSignal = output;
      lagFactor = lagFactor;
      isSovereign = isSovereign;
      lawViolation = lawViolation;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // WORLD MODEL INITIALIZATION — ALL SOVEREIGN
  // ══════════════════════════════════════════════════════════════════════════════════════

  public func initWorldModel(id: Nat) : WorldModelState {
    {
      id = id;
      name = if (id < WORLD_MODEL_NAMES.size()) { WORLD_MODEL_NAMES[id] } else { "UNKNOWN" };
      tau = WM_TAU_SOVEREIGN;      // 0.999 — maximum temporal fidelity
      alpha = WM_ALPHA_SOVEREIGN;  // 1.0 — instant adaptation
      prediction = 0.5;
      observation = 0.5;
      error = 0.0;
      confidence = 0.8;
      lastUpdate = 0;
      history = [];
    }
  };

  public func initWorldModelEnsemble() : WorldModelEnsemble {
    let models = Array.tabulate<WorldModelState>(NUM_WORLD_MODELS, initWorldModel);

    {
      models = models;
      globalConfidence = 0.8;
      coherence = 1.0;
      beat = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // WORLD MODEL UPDATE — PREDICTIVE PROCESSING
  // ══════════════════════════════════════════════════════════════════════════════════════

  public func updateWorldModel(
    model: WorldModelState,
    observation: Float,
    beat: Nat
  ) : WorldModelState {
    // Prediction error
    let error = observation - model.prediction;

    // Update prediction using sovereign temporal governor (α = 1.0)
    // With α = 1.0, prediction immediately becomes observation
    let newPrediction = model.prediction + model.alpha * error;

    // Update confidence based on prediction error
    let errorMagnitude = Float.abs(error);
    let newConfidence = model.confidence * model.tau - errorMagnitude * 0.1;
    let clampedConfidence = if (newConfidence < 0.1) { 0.1 }
                           else if (newConfidence > 1.0) { 1.0 }
                           else { newConfidence };

    // Update history (keep last 100)
    let newHistory = if (model.history.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(i) { model.history[i + 1] });
      Array.append<Float>(tail, [newPrediction])
    } else {
      Array.append<Float>(model.history, [newPrediction])
    };

    {
      id = model.id;
      name = model.name;
      tau = model.tau;
      alpha = model.alpha;
      prediction = newPrediction;
      observation = observation;
      error = error;
      confidence = clampedConfidence;
      lastUpdate = beat;
      history = newHistory;
    }
  };

  // Update entire ensemble
  public func updateEnsemble(
    ensemble: WorldModelEnsemble,
    observations: [Float],
    beat: Nat
  ) : WorldModelEnsemble {
    let newModels = Array.tabulate<WorldModelState>(ensemble.models.size(), func(i) {
      let obs = if (i < observations.size()) { observations[i] } else { 0.5 };
      updateWorldModel(ensemble.models[i], obs, beat)
    });

    // Compute global confidence
    var sumConf : Float = 0.0;
    for (m in newModels.vals()) { sumConf += m.confidence };
    let globalConf = sumConf / Float.fromInt(newModels.size());

    // Compute coherence (agreement between models)
    var sumError : Float = 0.0;
    for (m in newModels.vals()) { sumError += Float.abs(m.error) };
    let avgError = sumError / Float.fromInt(newModels.size());
    let coherence = 1.0 - avgError;  // Lower error = higher coherence

    {
      models = newModels;
      globalConfidence = globalConf;
      coherence = if (coherence < 0.0) { 0.0 } else { coherence };
      beat = beat;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // PREDICTION GENERATION — MULTI-MODEL CONSENSUS
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type EnsemblePrediction = {
    predictions     : [Float];       // Per-model predictions
    consensus       : Float;         // Weighted average
    uncertainty     : Float;         // Variance among predictions
    dominantModel   : Nat;           // Highest confidence model
  };

  public func generateEnsemblePrediction(ensemble: WorldModelEnsemble) : EnsemblePrediction {
    let n = ensemble.models.size();
    if (n == 0) {
      return {
        predictions = [];
        consensus = 0.5;
        uncertainty = 1.0;
        dominantModel = 0;
      }
    };

    // Extract predictions weighted by confidence
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;
    var maxConf : Float = 0.0;
    var dominantModel : Nat = 0;

    let predictions = Array.tabulate<Float>(n, func(i) {
      let m = ensemble.models[i];
      weightedSum += m.prediction * m.confidence;
      totalWeight += m.confidence;
      if (m.confidence > maxConf) {
        maxConf := m.confidence;
        dominantModel := i;
      };
      m.prediction
    });

    let consensus = if (totalWeight > 0.001) { weightedSum / totalWeight } else { 0.5 };

    // Compute uncertainty (variance)
    var variance : Float = 0.0;
    for (p in predictions.vals()) {
      let diff = p - consensus;
      variance += diff * diff;
    };
    variance /= Float.fromInt(n);

    {
      predictions = predictions;
      consensus = consensus;
      uncertainty = Float.sqrt(variance);
      dominantModel = dominantModel;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // FREE ENERGY MINIMIZATION — ACTIVE INFERENCE
  // ══════════════════════════════════════════════════════════════════════════════════════

  public type FreeEnergyState = {
    predictionError   : Float;       // ε = o - p
    complexity        : Float;       // KL divergence from prior
    accuracy          : Float;       // -log p(o|s)
    freeEnergy        : Float;       // F = complexity - accuracy
    action            : Float;       // Recommended action to minimize F
  };

  public func computeFreeEnergy(
    prediction: Float,
    observation: Float,
    priorMean: Float,
    priorVariance: Float
  ) : FreeEnergyState {
    // Prediction error
    let error = observation - prediction;

    // Precision (inverse variance)
    let precision = 1.0 / (if (priorVariance > 0.001) { priorVariance } else { 0.001 });

    // Accuracy: -log p(o|s) ≈ (error² × precision) / 2
    let accuracy = -(error * error * precision / 2.0);

    // Complexity: KL[q||p] ≈ (prediction - priorMean)² / (2 × priorVariance)
    let priorDiff = prediction - priorMean;
    let complexity = (priorDiff * priorDiff) / (2.0 * priorVariance);

    // Free energy = Complexity - Accuracy
    let freeEnergy = complexity - accuracy;

    // Action: move prediction toward observation to minimize F
    let action = error * precision * 0.1;  // Scaled gradient descent

    {
      predictionError = error;
      complexity = complexity;
      accuracy = accuracy;
      freeEnergy = freeEnergy;
      action = action;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════════════════
  // HELPER: CLAMP
  // ══════════════════════════════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
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
