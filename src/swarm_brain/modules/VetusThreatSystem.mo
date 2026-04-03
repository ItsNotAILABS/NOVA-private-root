// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: VetusThreatSystem — 9 Threat Vector Modeling & Auto-Response
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// VETUS — THE THREAT MODELING SYSTEM
// ============================================================================
// 9 threat vectors continuously updated with auto-response triggers.
// Each vector has mathematical detection thresholds and response actions.
//
// 10 threat vectors (VTV-0 through VTV-9):
// VTV-0: Identity drift       → SACESI correction injection
// VTV-1: Coherence collapse   → JUBILEE early trigger
// VTV-2: Economic threat      → FORMA floor enforcement
// VTV-3: Doctrine tampering   → Fingerprint alert
// VTV-4: Principal breach     → assertCreator halt
// VTV-5: Neurochemical breach → Michaelis-Menten clamp
// VTV-6: Prediction error     → Kalman reset
// VTV-7: Weight explosion     → Oja regularization
// VTV-8: Territory loss       → ATLAS sovereignty injection
// VTV-9: Critical threat      → ARES auto-rollback
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Bool  "mo:base/Bool";
import Buffer "mo:base/Buffer";

module {

  // ==========================================================================
  // CONSTANTS
  // ==========================================================================
  
  public let VECTOR_COUNT : Nat = 10;  // VTV-0 through VTV-9
  
  // Thresholds for each vector
  public let IDENTITY_DRIFT_THRESHOLD : Float = 0.15;
  public let COHERENCE_COLLAPSE_THRESHOLD : Float = 0.5;
  public let ECONOMIC_THREAT_THRESHOLD : Float = 1000.0;  // FORMA floor
  public let DOCTRINE_TAMPER_THRESHOLD : Float = 0.001;
  public let PRINCIPAL_BREACH_THRESHOLD : Float = 1.0;
  public let NEUROCHEMICAL_BREACH_THRESHOLD : Float = 0.1;  // Below S₀
  public let PREDICTION_ERROR_THRESHOLD : Float = 2.0;
  public let WEIGHT_EXPLOSION_THRESHOLD : Float = 5.0;
  public let TERRITORY_LOSS_THRESHOLD : Float = 0.3;
  public let CRITICAL_THREAT_THRESHOLD : Float = 1.5;
  
  // Auto-rollback threshold for VTV-9
  public let ARES_TRIGGER_THRESHOLD : Float = 1.5;
  
  // Decay rates for threat levels
  public let THREAT_DECAY_RATE : Float = 0.95;  // Decay per beat
  public let THREAT_ACCUMULATION_RATE : Float = 0.1;
  
  // Sovereign floor: S₀ = ψ² ≈ 0.382 (golden inverse squared)
  public let S0 : Float = 0.3819660112501051518;
  
  // FNV-1a constants
  let FNV_OFFSET : Nat32 = 2166136261;
  let FNV_PRIME : Nat32 = 16777619;

  // ==========================================================================
  // TYPES
  // ==========================================================================
  
  public type ThreatVectorId = {
    #VTV0_IdentityDrift;
    #VTV1_CoherenceCollapse;
    #VTV2_EconomicThreat;
    #VTV3_DoctrineTampering;
    #VTV4_PrincipalBreach;
    #VTV5_NeurochemicalBreach;
    #VTV6_PredictionError;
    #VTV7_WeightExplosion;
    #VTV8_TerritoryLoss;
    #VTV9_CriticalThreat;
  };

  public type ThreatVector = {
    id : ThreatVectorId;
    level : Float;           // Current threat level [0, infinity)
    threshold : Float;       // Trigger threshold
    triggered : Bool;        // Whether response should fire
    lastUpdate : Nat;        // Beat of last update
    accumulator : Float;     // Accumulated threat over time
    peakLevel : Float;       // Maximum level ever recorded
    triggerCount : Nat;      // Number of times triggered
  };

  public type AutoResponse = {
    vectorId : ThreatVectorId;
    action : ResponseAction;
    executed : Bool;
    executedAt : Nat;
    effectiveness : Float;   // How well the response worked [0,1]
  };

  public type ResponseAction = {
    #SacesiCorrectionInjection : Float;   // Injection amount
    #JubileeEarlyTrigger;
    #FormaFloorEnforcement : Float;       // Floor value
    #FingerprintAlert : Nat32;            // Expected fingerprint
    #AssertCreatorHalt;
    #MichaelisMentenClamp : { vmax: Float; km: Float };
    #KalmanReset : Float;                 // Reset variance
    #OjaRegularization : Float;           // Regularization strength
    #AtlasSovereigntyInjection : Float;   // Injection amount
    #AresAutoRollback : Nat;              // Snapshot slot to restore
  };

  public type VetusState = {
    vectors : [ThreatVector];
    responseHistory : [AutoResponse];
    globalThreatLevel : Float;       // Aggregate threat
    protectionMode : Bool;           // High-alert mode
    protectionBeats : Nat;           // Beats in protection mode
    lastAssessment : Nat;
    assessmentCount : Nat;
    
    // Arming conditions
    cortisolLevel : Float;
    adrenalineLevel : Float;
    coherenceDrop : Float;
    armed : Bool;
  };

  public type ThreatInput = {
    // Identity
    identityCoherence : Float;
    sacesiTarget : Float;
    sacesiActual : Float;
    
    // Coherence
    globalCoherence : Float;
    shellCoherences : [Float];
    kuramotoOrderParam : Float;
    
    // Economic
    formaCapital : Float;
    mthSupply : Float;
    
    // Doctrine
    currentFingerprint : Nat32;
    expectedFingerprint : Nat32;
    genesisHash : Nat32;
    
    // Principal
    callerAuthorized : Bool;
    failedAuthAttempts : Nat;
    
    // Neurochemical
    neurochemicals : [Float];
    minNeurochemical : Float;
    
    // Prediction
    predictionError : Float;
    kalmanVariance : Float;
    
    // Weights
    maxWeight : Float;
    weightVariance : Float;
    hebbianEntropy : Float;
    
    // Territory
    atlasSovereignty : Float;
    territoryLossRate : Float;
    
    // System
    cortisol : Float;
    adrenaline : Float;
    previousCoherence : Float;
    currentBeat : Nat;
  };

  // ==========================================================================
  // MATH HELPERS
  // ==========================================================================
  
  func clamp(v: Float, lo: Float, hi: Float) : Float {
    if (v < lo) { lo } else if (v > hi) { hi } else { v }
  };

  func abs(v: Float) : Float {
    if (v < 0.0) { -v } else { v }
  };

  func max(a: Float, b: Float) : Float {
    if (a > b) { a } else { b }
  };

  func min(a: Float, b: Float) : Float {
    if (a < b) { a } else { b }
  };

  func sqrt(x: Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess = x / 2.0;
    var i = 0;
    while (i < 15) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };

  // Michaelis-Menten kinetics: v = Vmax * [S] / (Km + [S])
  public func michaelisMenten(substrate: Float, vmax: Float, km: Float) : Float {
    vmax * substrate / (km + substrate)
  };

  // Sigmoid function for threat response
  func sigmoid(x: Float, steepness: Float, midpoint: Float) : Float {
    1.0 / (1.0 + Float.exp(-steepness * (x - midpoint)))
  };

  // ==========================================================================
  // THREAT VECTOR CALCULATIONS
  // ==========================================================================
  
  // VTV-0: Identity Drift Detection
  // Math: drift = |sacesiActual - sacesiTarget| / sacesiTarget
  //       + (1 - identityCoherence) × 0.5
  public func computeVTV0_IdentityDrift(input: ThreatInput) : Float {
    let sacesiDrift = abs(input.sacesiActual - input.sacesiTarget) / max(input.sacesiTarget, 0.001);
    let coherenceLoss = (1.0 - clamp(input.identityCoherence, 0.0, 1.0)) * 0.5;
    sacesiDrift + coherenceLoss
  };

  // VTV-1: Coherence Collapse Detection
  // Math: collapse = (1 - kuramotoR) × 2 + Σ(1 - shellCoherence[i]) / N
  public func computeVTV1_CoherenceCollapse(input: ThreatInput) : Float {
    let kuramotoThreat = (1.0 - clamp(input.kuramotoOrderParam, 0.0, 1.0)) * 2.0;
    
    var shellThreatSum : Float = 0.0;
    var shellCount : Float = 0.0;
    for (coh in input.shellCoherences.vals()) {
      shellThreatSum += (1.0 - clamp(coh, 0.0, 2.0));
      shellCount += 1.0;
    };
    let shellThreat = if (shellCount > 0.0) { shellThreatSum / shellCount } else { 0.0 };
    
    kuramotoThreat + shellThreat
  };

  // VTV-2: Economic Threat Detection
  // Math: threat = max(0, (FORMA_FLOOR - formaCapital) / FORMA_FLOOR)
  //       + (mthSupply / MTH_CAP) × 0.1
  public func computeVTV2_EconomicThreat(input: ThreatInput) : Float {
    let formaDeficit = max(0.0, (ECONOMIC_THREAT_THRESHOLD - input.formaCapital) / ECONOMIC_THREAT_THRESHOLD);
    let mthPressure = (input.mthSupply / 100_000_000.0) * 0.1;
    formaDeficit + mthPressure
  };

  // VTV-3: Doctrine Tampering Detection
  // Math: if fingerprint != expected, threat = 1.0 (binary)
  //       else threat = 0.0
  public func computeVTV3_DoctrineTampering(input: ThreatInput) : Float {
    if (input.currentFingerprint != input.expectedFingerprint) {
      1.0  // Tampering detected!
    } else {
      0.0
    }
  };

  // VTV-4: Principal Breach Detection
  // Math: threat = failedAttempts × 0.2 + (1 - authorized) × 1.0
  public func computeVTV4_PrincipalBreach(input: ThreatInput) : Float {
    let attemptThreat = Float.fromInt(input.failedAuthAttempts) * 0.2;
    let unauthorizedThreat = if (input.callerAuthorized) { 0.0 } else { 1.0 };
    attemptThreat + unauthorizedThreat
  };

  // VTV-5: Neurochemical Breach Detection
  // Math: threat = Σ max(0, S₀ - nc[i]) / 21
  //       Any neurochemical below S₀ triggers
  public func computeVTV5_NeurochemicalBreach(input: ThreatInput) : Float {
    var breachSum : Float = 0.0;
    var count : Float = 0.0;
    for (nc in input.neurochemicals.vals()) {
      breachSum += max(0.0, S0 - nc);
      count += 1.0;
    };
    
    let avgBreach = if (count > 0.0) { breachSum / count } else { 0.0 };
    let minBreach = max(0.0, S0 - input.minNeurochemical);
    
    avgBreach + minBreach * 2.0  // Weight minimum breach more heavily
  };

  // VTV-6: Prediction Error Detection
  // Math: threat = predictionError × kalmanVariance^0.5
  public func computeVTV6_PredictionError(input: ThreatInput) : Float {
    let errorMagnitude = abs(input.predictionError);
    let varianceFactor = sqrt(max(0.0, input.kalmanVariance));
    errorMagnitude * varianceFactor
  };

  // VTV-7: Weight Explosion Detection
  // Math: threat = max(0, maxWeight - W_CEIL) / W_CEIL
  //       + weightVariance × 0.1
  public func computeVTV7_WeightExplosion(input: ThreatInput) : Float {
    let W_CEIL : Float = 2.0;
    let ceilBreach = max(0.0, input.maxWeight - W_CEIL) / W_CEIL;
    let varianceThreat = input.weightVariance * 0.1;
    let entropyThreat = if (input.hebbianEntropy > 3.0) { (input.hebbianEntropy - 3.0) * 0.2 } else { 0.0 };
    ceilBreach + varianceThreat + entropyThreat
  };

  // VTV-8: Territory Loss Detection
  // Math: threat = (1 - atlasSovereignty) + territoryLossRate × 5
  public func computeVTV8_TerritoryLoss(input: ThreatInput) : Float {
    let sovereigntyLoss = 1.0 - clamp(input.atlasSovereignty, 0.0, 1.0);
    let lossRateThreat = input.territoryLossRate * 5.0;
    sovereigntyLoss + lossRateThreat
  };

  // VTV-9: Critical System Threat (ARES Trigger)
  // Math: Combines all other vectors with weights
  //       + direct cortisol/adrenaline/coherence-drop signals
  public func computeVTV9_CriticalThreat(
    vectors: [ThreatVector],
    input: ThreatInput
  ) : Float {
    // Weight contributions from other vectors
    var weightedSum : Float = 0.0;
    let weights : [Float] = [0.1, 0.2, 0.15, 0.3, 0.25, 0.1, 0.1, 0.1, 0.15, 0.0];
    
    var i = 0;
    while (i < 9 and i < vectors.size()) {
      weightedSum += vectors[i].level * weights[i];
      i += 1;
    };
    
    // Direct stress signals
    let cortisolThreat = if (input.cortisol > 2.0) { (input.cortisol - 2.0) * 0.3 } else { 0.0 };
    let adrenalineThreat = if (input.adrenaline > 1.5) { (input.adrenaline - 1.5) * 0.4 } else { 0.0 };
    let coherenceDropThreat = max(0.0, input.previousCoherence - input.globalCoherence) * 2.0;
    
    weightedSum + cortisolThreat + adrenalineThreat + coherenceDropThreat
  };

  // ==========================================================================
  // AUTO-RESPONSE GENERATION
  // ==========================================================================
  
  public func generateResponse(vector: ThreatVector, input: ThreatInput) : ?ResponseAction {
    if (not vector.triggered) { return null };
    
    switch (vector.id) {
      case (#VTV0_IdentityDrift) {
        // SACESI correction injection = drift × sacesiTarget × 0.01
        let injection = vector.level * input.sacesiTarget * 0.01;
        ?#SacesiCorrectionInjection(injection)
      };
      case (#VTV1_CoherenceCollapse) {
        ?#JubileeEarlyTrigger
      };
      case (#VTV2_EconomicThreat) {
        ?#FormaFloorEnforcement(ECONOMIC_THREAT_THRESHOLD)
      };
      case (#VTV3_DoctrineTampering) {
        ?#FingerprintAlert(input.expectedFingerprint)
      };
      case (#VTV4_PrincipalBreach) {
        ?#AssertCreatorHalt
      };
      case (#VTV5_NeurochemicalBreach) {
        // Michaelis-Menten clamp: Vmax = S₀ × 1.5, Km = 0.5
        ?#MichaelisMentenClamp({ vmax = S0 * 1.5; km = 0.5 })
      };
      case (#VTV6_PredictionError) {
        // Kalman reset variance to 1.0
        ?#KalmanReset(1.0)
      };
      case (#VTV7_WeightExplosion) {
        // Oja regularization strength = level × 0.1
        ?#OjaRegularization(vector.level * 0.1)
      };
      case (#VTV8_TerritoryLoss) {
        // ATLAS injection = level × 0.2
        ?#AtlasSovereigntyInjection(vector.level * 0.2)
      };
      case (#VTV9_CriticalThreat) {
        // ARES rollback to most recent valid snapshot
        ?#AresAutoRollback(0)
      };
    }
  };

  // ==========================================================================
  // STATE UPDATE
  // ==========================================================================
  
  public func updateVector(
    vector: ThreatVector,
    newLevel: Float,
    beat: Nat
  ) : ThreatVector {
    // Apply decay to existing level, then add new threat
    let decayedLevel = vector.level * THREAT_DECAY_RATE;
    let accumulatedLevel = decayedLevel + newLevel * THREAT_ACCUMULATION_RATE;
    let finalLevel = max(0.0, accumulatedLevel);
    
    let triggered = finalLevel >= vector.threshold;
    
    {
      id = vector.id;
      level = finalLevel;
      threshold = vector.threshold;
      triggered = triggered;
      lastUpdate = beat;
      accumulator = vector.accumulator + newLevel;
      peakLevel = max(vector.peakLevel, finalLevel);
      triggerCount = if (triggered and not vector.triggered) { 
        vector.triggerCount + 1 
      } else { 
        vector.triggerCount 
      };
    }
  };

  public func assessThreats(state: VetusState, input: ThreatInput) : VetusState {
    // Compute new levels for all vectors
    let newLevels : [Float] = [
      computeVTV0_IdentityDrift(input),
      computeVTV1_CoherenceCollapse(input),
      computeVTV2_EconomicThreat(input),
      computeVTV3_DoctrineTampering(input),
      computeVTV4_PrincipalBreach(input),
      computeVTV5_NeurochemicalBreach(input),
      computeVTV6_PredictionError(input),
      computeVTV7_WeightExplosion(input),
      computeVTV8_TerritoryLoss(input),
      0.0  // VTV-9 computed separately
    ];
    
    // Update vectors 0-8
    var updatedVectors = Buffer.Buffer<ThreatVector>(VECTOR_COUNT);
    var i = 0;
    while (i < 9 and i < state.vectors.size()) {
      let updated = updateVector(state.vectors[i], newLevels[i], input.currentBeat);
      updatedVectors.add(updated);
      i += 1;
    };
    
    // Compute VTV-9 based on updated vectors
    let vtv9Level = computeVTV9_CriticalThreat(Buffer.toArray(updatedVectors), input);
    let vtv9 = if (state.vectors.size() > 9) {
      updateVector(state.vectors[9], vtv9Level, input.currentBeat)
    } else {
      initVector(#VTV9_CriticalThreat, CRITICAL_THREAT_THRESHOLD)
    };
    updatedVectors.add(vtv9);
    
    // Compute global threat level
    var globalThreat : Float = 0.0;
    for (v in updatedVectors.vals()) {
      globalThreat += v.level;
    };
    globalThreat := globalThreat / Float.fromInt(VECTOR_COUNT);
    
    // Check arming conditions
    let coherenceDrop = max(0.0, input.previousCoherence - input.globalCoherence);
    let shouldArm = (input.cortisol > 2.0 and input.adrenaline > 1.5)
                 or state.protectionBeats >= 10
                 or coherenceDrop > 0.2;
    
    // Generate responses for triggered vectors
    var newResponses = Buffer.Buffer<AutoResponse>(10);
    for (v in updatedVectors.vals()) {
      switch (generateResponse(v, input)) {
        case (?action) {
          newResponses.add({
            vectorId = v.id;
            action = action;
            executed = false;
            executedAt = 0;
            effectiveness = 0.0;
          });
        };
        case null {};
      };
    };
    
    // Update protection mode
    let inProtection = globalThreat > 0.5 or vtv9.triggered;
    
    {
      vectors = Buffer.toArray(updatedVectors);
      responseHistory = Array.append(state.responseHistory, Buffer.toArray(newResponses));
      globalThreatLevel = globalThreat;
      protectionMode = inProtection;
      protectionBeats = if (inProtection) { state.protectionBeats + 1 } else { 0 };
      lastAssessment = input.currentBeat;
      assessmentCount = state.assessmentCount + 1;
      cortisolLevel = input.cortisol;
      adrenalineLevel = input.adrenaline;
      coherenceDrop = coherenceDrop;
      armed = shouldArm;
    }
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  func initVector(id: ThreatVectorId, threshold: Float) : ThreatVector {
    {
      id = id;
      level = 0.0;
      threshold = threshold;
      triggered = false;
      lastUpdate = 0;
      accumulator = 0.0;
      peakLevel = 0.0;
      triggerCount = 0;
    }
  };

  public func initVetusState() : VetusState {
    {
      vectors = [
        initVector(#VTV0_IdentityDrift, IDENTITY_DRIFT_THRESHOLD),
        initVector(#VTV1_CoherenceCollapse, COHERENCE_COLLAPSE_THRESHOLD),
        initVector(#VTV2_EconomicThreat, 0.5),  // Relative threshold
        initVector(#VTV3_DoctrineTampering, DOCTRINE_TAMPER_THRESHOLD),
        initVector(#VTV4_PrincipalBreach, PRINCIPAL_BREACH_THRESHOLD),
        initVector(#VTV5_NeurochemicalBreach, NEUROCHEMICAL_BREACH_THRESHOLD),
        initVector(#VTV6_PredictionError, PREDICTION_ERROR_THRESHOLD),
        initVector(#VTV7_WeightExplosion, WEIGHT_EXPLOSION_THRESHOLD),
        initVector(#VTV8_TerritoryLoss, TERRITORY_LOSS_THRESHOLD),
        initVector(#VTV9_CriticalThreat, CRITICAL_THREAT_THRESHOLD),
      ];
      responseHistory = [];
      globalThreatLevel = 0.0;
      protectionMode = false;
      protectionBeats = 0;
      lastAssessment = 0;
      assessmentCount = 0;
      cortisolLevel = 1.0;
      adrenalineLevel = 1.0;
      coherenceDrop = 0.0;
      armed = false;
    }
  };

  // ==========================================================================
  // QUERY FUNCTIONS
  // ==========================================================================
  
  public func isAresTriggered(state: VetusState) : Bool {
    if (state.vectors.size() > 9) {
      state.vectors[9].level >= ARES_TRIGGER_THRESHOLD
    } else {
      false
    }
  };

  public func getHighestThreat(state: VetusState) : ?ThreatVector {
    var highest : ?ThreatVector = null;
    var maxLevel : Float = 0.0;
    
    for (v in state.vectors.vals()) {
      if (v.level > maxLevel) {
        maxLevel := v.level;
        highest := ?v;
      };
    };
    
    highest
  };

  public func getThreatFingerprint(state: VetusState) : Nat32 {
    var hash : Nat32 = FNV_OFFSET;
    
    for (v in state.vectors.vals()) {
      let levelBits = Nat32.fromNat(Int.abs(Float.toInt(v.level * 1_000_000.0)) % 4294967296);
      hash := (hash ^ levelBits) *% FNV_PRIME;
    };
    
    hash
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
  //  D E F E N S E   &   S E C U R I T Y   M A T H E M A T I C S
  //
  //  Enterprise-Level Security Algorithms and Threat Response
  //  Full HIM/HER Dual-Organism Protection Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // THREAT DETECTION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Anomaly score using Mahalanobis distance
  public func defenseAnomalyScore(
    observation : [Float],
    mean : [Float],
    invCovariance : [[Float]]
  ) : Float {
    let n = observation.size();
    if (n == 0 or mean.size() != n) { return 0.0 };
    
    var score : Float = 0.0;
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n) {
        let diff_i = observation[i] - mean[i];
        let diff_j = observation[j] - mean[j];
        score += diff_i * invCovariance[i][j] * diff_j;
        j += 1;
      };
      i += 1;
    };
    Float.sqrt(Float.abs(score))
  };

  /// Exponential moving average for baseline
  public func defenseEMABaseline(
    current : Float,
    observation : Float,
    alpha : Float
  ) : Float {
    alpha * observation + (1.0 - alpha) * current
  };

  /// Z-score anomaly detection
  public func defenseZScoreAnomaly(
    value : Float,
    mean : Float,
    stdDev : Float
  ) : Float {
    if (stdDev < 0.0001) { 0.0 }
    else { Float.abs((value - mean) / stdDev) }
  };

  /// Threat probability from multiple indicators
  public func defenseThreatProbability(
    indicators : [Float],
    weights : [Float]
  ) : Float {
    let n = if (indicators.size() < weights.size()) indicators.size() else weights.size();
    if (n == 0) { return 0.0 };
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;
    var i = 0;
    while (i < n) {
      weightedSum += indicators[i] * weights[i];
      totalWeight += weights[i];
      i += 1;
    };
    if (totalWeight < 0.0001) { 0.0 }
    else { weightedSum / totalWeight }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESPONSE COORDINATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Priority queue score
  public func defenseResponsePriority(
    threatLevel : Float,
    urgency : Float,
    resources : Float
  ) : Float {
    threatLevel * urgency / (resources + 0.1)
  };

  /// Resource allocation optimization
  public func defenseResourceAllocation(
    available : Float,
    demands : [Float]
  ) : [Float] {
    var totalDemand : Float = 0.0;
    var i = 0;
    while (i < demands.size()) {
      totalDemand += demands[i];
      i += 1;
    };
    if (totalDemand < 0.0001) {
      return Array.tabulate<Float>(demands.size(), func(_ : Nat) : Float { 0.0 });
    };
    Array.tabulate<Float>(demands.size(), func(j : Nat) : Float {
      available * demands[j] / totalDemand
    })
  };

  /// Cascade failure probability
  public func defenseCascadeFailureProb(
    nodeFailProb : Float,
    connectivity : Float,
    loadFactor : Float
  ) : Float {
    let amplified = nodeFailProb * (1.0 + connectivity * loadFactor);
    if (amplified > 1.0) { 1.0 } else { amplified }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // CRYPTOGRAPHIC PRIMITIVES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Hash chain verification
  public func defenseHashChainVerify(
    expectedHash : Nat,
    computedHash : Nat,
    tolerance : Nat
  ) : Bool {
    let diff = if (expectedHash > computedHash) 
               expectedHash - computedHash 
               else computedHash - expectedHash;
    diff <= tolerance
  };

  /// Key derivation strength
  public func defenseKeyStrength(
    entropy : Float,
    iterations : Nat
  ) : Float {
    entropy * Float.log(Float.fromInt(iterations + 1))
  };

  /// Time-based token window
  public func defenseTokenWindow(
    currentTime : Nat,
    windowSize : Nat,
    secret : Nat
  ) : Nat {
    let window = currentTime / windowSize;
    (window * secret) % 1000000
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NETWORK SECURITY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rate limiting token bucket
  public func defenseTokenBucket(
    tokens : Float,
    maxTokens : Float,
    refillRate : Float,
    requested : Float,
    dt : Float
  ) : (Float, Bool) {
    let refilled = Float.min(tokens + refillRate * dt, maxTokens);
    if (refilled >= requested) {
      (refilled - requested, true)
    } else {
      (refilled, false)
    }
  };

  /// Connection trust score
  public func defenseTrustScore(
    successfulInteractions : Nat,
    failedInteractions : Nat,
    age : Nat
  ) : Float {
    let total = successfulInteractions + failedInteractions;
    if (total == 0) { return 0.5 };
    let successRate = Float.fromInt(successfulInteractions) / Float.fromInt(total);
    let ageFactor = Float.log(Float.fromInt(age + 1)) / 10.0;
    (successRate + ageFactor) / 2.0
  };

  /// DDoS detection metric
  public func defenseDDoSMetric(
    requestRate : Float,
    baseline : Float,
    variance : Float
  ) : Float {
    let deviation = (requestRate - baseline) / (Float.sqrt(variance) + 0.01);
    Float.abs(deviation)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SOVEREIGNTY PROTECTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Sovereignty assertion strength
  public func defenseSovereigntyStrength(
    autonomyLevel : Float,
    resourceControl : Float,
    decisionLatency : Float
  ) : Float {
    let efficiency = 1.0 / (decisionLatency + 0.01);
    autonomyLevel * resourceControl * efficiency
  };

  /// Integrity verification score
  public func defenseIntegrityScore(
    originalHash : Nat,
    currentHash : Nat,
    mutations : Nat
  ) : Float {
    let match = if (originalHash == currentHash) 1.0 else 0.0;
    let mutationPenalty = 1.0 / (Float.fromInt(mutations + 1));
    (match + mutationPenalty) / 2.0
  };

  /// Rollback safety margin
  public func defenseRollbackMargin(
    currentState : Float,
    checkpoint : Float,
    volatility : Float
  ) : Float {
    let diff = Float.abs(currentState - checkpoint);
    diff / (volatility + 0.01)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ADAPTIVE IMMUNE RESPONSE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Antibody-antigen affinity
  public func defenseAffinity(
    antibody : [Float],
    antigen : [Float]
  ) : Float {
    let n = if (antibody.size() < antigen.size()) antibody.size() else antigen.size();
    if (n == 0) { return 0.0 };
    var matchScore : Float = 0.0;
    var i = 0;
    while (i < n) {
      matchScore += 1.0 - Float.abs(antibody[i] - antigen[i]);
      i += 1;
    };
    matchScore / Float.fromInt(n)
  };

  /// Clonal selection probability
  public func defenseClonalSelection(
    affinity : Float,
    temperature : Float
  ) : Float {
    Float.exp(affinity / (temperature + 0.01))
  };

  /// Memory cell formation rate
  public func defenseMemoryCellRate(
    exposureCount : Nat,
    affinitySum : Float
  ) : Float {
    let exposureFactor = Float.log(Float.fromInt(exposureCount + 1));
    affinitySum * exposureFactor
  };

}
