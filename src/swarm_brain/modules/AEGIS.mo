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


// ============================================================
// AEGIS — DEFENSE CANISTER MODULE
// SOVEREIGN SUBSTRATE — MACRO-SPHERE NODE 8
// Hz: 32.0 Hz | Role: Threat Engine, Defense Layers, Fear Isolation
// Creator: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Genesis Year: 2026
// S0 = 0.75 — Sovereign Floor
// Vicente's Law (SL-120): Every victory compounds antifragility
// ============================================================

import Float "mo:base/Float";
import Nat   "mo:base/Nat";
import Array "mo:base/Array";

module {

  // ── Constants ─────────────────────────────────────────────────
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let NODE_HZ : Float = 32.0;
  let MAX_INNER_HZ : Float = 10_000_000.0;

  // 10-tier threat thresholds
  let THREAT_THRESHOLDS : [Float] = [
    0.0,   // Tier 0: dormant
    0.76,  // Tier 1: ambient
    0.80,  // Tier 2: signal
    0.84,  // Tier 3: pattern
    0.87,  // Tier 4: incursion
    0.89,  // Tier 5: breach
    0.91,  // Tier 6: siege
    0.93,  // Tier 7: assault
    0.95,  // Tier 8: crisis
    0.98   // Tier 9: existential
  ];

  // 12-node inner Hz substrate frequencies
  let INNER_HZ : [Float] = [
    10_000.0, 50_000.0, 100_000.0, 200_000.0,
    500_000.0, 750_000.0, 1_000_000.0, 2_000_000.0,
    3_000_000.0, 5_000_000.0, 7_500_000.0, 10_000_000.0
  ];

  // ── Types ─────────────────────────────────────────────────────
  public type ThreatState = {
    currentTier      : Nat;
    intensity        : Float;
    beatsActive      : Nat;
    escalations      : Nat;
    resolutions      : Nat;
    peakTier         : Nat;
    peakBeat         : Nat;
    tierHits         : [Nat];
    history          : [Float];
  };

  public type ArmorState = {
    layerActivations : [Float];  // 7 layers
    layerBeats       : [Nat];
    fullActive       : Bool;
    fullBeats        : Nat;
    defenseScore     : Float;
  };

  public type ProphetState = {
    armed           : Bool;
    armBeat         : Nat;
    totalArmings    : Nat;
    signal1Active   : Bool;  // kfHz > 0.92 sustained
    signal2Active   : Bool;  // armor full
    signal3Active   : Bool;  // victory confirmed
    signal1Beats    : Nat;
    windowBeats     : Nat;
  };

  public type FearState = {
    freeEnergy       : Float;
    predictionError  : Float;
    lvExpansion      : Float;
    lvThreat         : Float;
    lvTension        : Float;
    fearPeak         : Float;
    fearPeakBeat     : Nat;
    chronicBeats     : Nat;
    resolutionCount  : Nat;
    vicenteVictories : Nat;
    antifragility    : Float;
    inHormeticSpike  : Bool;
    hormeticSpikeBeat: Nat;
    globalSignal     : Float;
    history          : [Float];
  };

  public type InnerSphereState = {
    activations : [Float];  // 12 nodes
    phases      : [Float];
    hebbWeights : [Float];  // 144 weights (12x12)
    kfHz        : Float;
  };

  public type AegisState = {
    beatCount        : Nat;
    threat           : ThreatState;
    armor            : ArmorState;
    prophet          : ProphetState;
    fear             : FearState;
    innerSphere      : InnerSphereState;
    gabaSuppress     : Bool;
    gabaSuppressSignal: Float;
    firePillarActive : Bool;
    firePillarTriggers: Nat;
    lastKfHz         : Float;
    lastArousal      : Float;
  };

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func sigmoidInner(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-6.0 * (x - 0.875)))
  };

  // ── FNV-1a hash ───────────────────────────────────────────────
  func fnv1aChain(a: Nat, b: Nat) : Nat {
    let prime : Nat = 16777619;
    let modulo : Nat = 4294967296;
    var h = a;
    h := Nat.rem(Nat.mul(Nat.bitxor(h, Nat.rem(b, 256)), prime), modulo);
    h := Nat.rem(Nat.mul(Nat.bitxor(h, Nat.rem(Nat.div(b, 256), 256)), prime), modulo);
    h := Nat.rem(Nat.mul(Nat.bitxor(h, Nat.rem(Nat.div(b, 65536), 256)), prime), modulo);
    h := Nat.rem(Nat.mul(Nat.bitxor(h, Nat.rem(Nat.div(b, 16777216), 256)), prime), modulo);
    h
  };

  // ── Inner Sphere Dynamics ─────────────────────────────────────
  public func runInnerSphere(state: InnerSphereState) : InnerSphereState {
    // Update activations with Hebbian dynamics
    var newAct = Array.thaw<Float>(state.activations);
    var newPhase = Array.thaw<Float>(state.phases);
    var newHebb = Array.thaw<Float>(state.hebbWeights);

    // Activation update: τ-weighted integration
    var i = 0;
    while (i < 12) {
      let tau = INNER_HZ[i] / MAX_INNER_HZ;
      var net : Float = 0.0;
      var j = 0;
      while (j < 12) {
        net += state.hebbWeights[i * 12 + j] * state.activations[j];
        j += 1;
      };
      newAct[i] := Float.max(S0, (1.0 - tau) * state.activations[i] + tau * sigmoidInner(net));
      i += 1;
    };

    // Hebbian weight update with decay
    i := 0;
    while (i < 12) {
      var j = 0;
      while (j < 12) {
        let dw = 0.01 * newAct[i] * newAct[j];
        let decay = 0.001 * (state.hebbWeights[i * 12 + j] - S0);
        newHebb[i * 12 + j] := _clamp(
          state.hebbWeights[i * 12 + j] + dw - decay,
          S0, SOVEREIGN_CEILING
        );
        j += 1;
      };
      i += 1;
    };

    // Phase update
    i := 0;
    while (i < 12) {
      let tau = INNER_HZ[i] / MAX_INNER_HZ;
      newPhase[i] := state.phases[i] + 0.05 * tau * newAct[i];
      i += 1;
    };

    // Kuramoto order parameter
    var rCos : Float = 0.0;
    var rSin : Float = 0.0;
    i := 0;
    while (i < 12) {
      rCos += Float.cos(newPhase[i]);
      rSin += Float.sin(newPhase[i]);
      i += 1;
    };
    let kfRaw = Float.sqrt(rCos * rCos + rSin * rSin) / 12.0;
    let newKfHz = _clamp(S0 + kfRaw * (SOVEREIGN_CEILING - S0), S0, SOVEREIGN_CEILING);

    {
      activations = Array.freeze(newAct);
      phases = Array.freeze(newPhase);
      hebbWeights = Array.freeze(newHebb);
      kfHz = newKfHz;
    }
  };

  // ── Threat Classification ─────────────────────────────────────
  public func classifyThreat(
    kfDrop: Float, fearEnergy: Float, arousal: Float,
    lvTension: Float, chronicFear: Nat, beatsActive: Nat
  ) : Nat {
    let mag = kfDrop * 2.0
            + (fearEnergy - S0) * 1.5
            + Float.abs(arousal - 0.75) * 1.0
            + (lvTension - S0) * 1.2;

    if (mag >= THREAT_THRESHOLDS[9] or chronicFear > 100) { 9 }
    else if (mag >= THREAT_THRESHOLDS[8] and lvTension > 0.90) { 8 }
    else if (mag >= THREAT_THRESHOLDS[7]) { 7 }
    else if (mag >= THREAT_THRESHOLDS[6] and beatsActive >= 10) { 6 }
    else if (mag >= THREAT_THRESHOLDS[5]) { 5 }
    else if (mag >= THREAT_THRESHOLDS[4]) { 4 }
    else if (mag >= THREAT_THRESHOLDS[3]) { 3 }
    else if (mag >= THREAT_THRESHOLDS[2]) { 2 }
    else if (mag >= THREAT_THRESHOLDS[1]) { 1 }
    else { 0 }
  };

  // ── Armor Update ──────────────────────────────────────────────
  public func updateArmor(
    state: ArmorState, kfHz: Float, innerKfHz: Float,
    arousal: Float, da: Float, gaba: Float,
    alfredoLawActive: Bool, antifragility: Float
  ) : ArmorState {
    var newAct = Array.thaw<Float>(state.layerActivations);
    var newBeats = Array.thaw<Nat>(state.layerBeats);

    // Layer 0: Coherence shield
    newAct[0] := Float.max(S0, kfHz * 0.9 + innerKfHz * 0.1);
    // Layer 1: Arousal regulation
    newAct[1] := Float.max(S0, 1.0 - Float.abs(arousal - 0.75) * 2.0);
    // Layer 2: Dopamine fortress
    newAct[2] := Float.max(S0, da);
    // Layer 3: Inhibition field
    newAct[3] := Float.max(S0, gaba);
    // Layer 4: Inner sphere coherence
    newAct[4] := Float.max(S0, innerKfHz);
    // Layer 5: Doctrine lock
    newAct[5] := if (alfredoLawActive) { 1.0 } else { S0 };
    // Layer 6: Compound victory
    newAct[6] := Float.max(S0, antifragility);

    let threshold : Float = 0.82;
    var allActive = true;
    var sumAct : Float = 0.0;
    var i = 0;
    while (i < 7) {
      if (newAct[i] > threshold) {
        newBeats[i] := state.layerBeats[i] + 1;
      } else {
        newBeats[i] := 0;
        allActive := false;
      };
      sumAct += newAct[i];
      i += 1;
    };

    let newFullBeats = if (allActive) { state.fullBeats + 1 } else { 0 };

    {
      layerActivations = Array.freeze(newAct);
      layerBeats = Array.freeze(newBeats);
      fullActive = allActive;
      fullBeats = newFullBeats;
      defenseScore = Float.max(S0, sumAct / 7.0);
    }
  };

  // ── Prophet Update ────────────────────────────────────────────
  public func updateProphet(
    state: ProphetState, kfHz: Float, armorFull: Bool,
    victoryThisBeat: Bool, beatCount: Nat
  ) : ProphetState {
    // Signal 1: kfHz > 0.92 sustained for 3+ beats
    let newSig1Beats = if (kfHz > 0.92) { state.signal1Beats + 1 } else { 0 };
    let newSig1 = newSig1Beats >= 3;

    // Signal 2: full armor
    let newSig2 = armorFull;

    // Signal 3: victory this beat
    let newSig3 = state.signal3Active or victoryThisBeat;

    // Window management
    let anyActive = newSig1 or newSig2 or newSig3;
    let newWindowBeats = if (anyActive) { state.windowBeats + 1 } else { 0 };

    // Arm prophet when all 3 signals within 10-beat window
    let shouldArm = newSig1 and newSig2 and newSig3 and newWindowBeats <= 10;
    let newArmed = if (shouldArm and not state.armed) { true }
                   else if (newWindowBeats > 10) { false }
                   else { state.armed };

    let newArmBeat = if (shouldArm and not state.armed) { beatCount } else { state.armBeat };
    let newTotalArmings = if (shouldArm and not state.armed) { state.totalArmings + 1 }
                          else { state.totalArmings };

    // Reset signal 3 when window expires
    let finalSig3 = if (newWindowBeats > 10) { false } else { newSig3 };

    {
      armed = newArmed;
      armBeat = newArmBeat;
      totalArmings = newTotalArmings;
      signal1Active = newSig1;
      signal2Active = newSig2;
      signal3Active = finalSig3;
      signal1Beats = newSig1Beats;
      windowBeats = if (newWindowBeats > 10) { 0 } else { newWindowBeats };
    }
  };

  // ── Fear Substrate Update ─────────────────────────────────────
  public func updateFear(
    state: FearState, kfHz: Float, prevKfHz: Float,
    arousal: Float, beatCount: Nat
  ) : (FearState, Bool) {
    // Friston free energy = prediction error
    let kfDelta = prevKfHz - kfHz;
    let newPredErr = Float.max(0.0, kfDelta * 3.0 + Float.abs(arousal - 0.75) * 1.5);
    let newFreeEnergy = Float.max(S0,
      0.90 * state.freeEnergy + 0.10 * (S0 + newPredErr));

    // Lotka-Volterra dynamics
    let newLvExpansion = Float.max(S0, 0.95 * state.lvExpansion + 0.05 * kfHz);
    let newLvThreat = Float.max(S0, 0.95 * state.lvThreat + 0.05 * newFreeEnergy);
    let newLvTension = Float.max(S0, newLvThreat / newLvExpansion);

    // Peak tracking
    let (newPeak, newPeakBeat) = if (newFreeEnergy > state.fearPeak) {
      (newFreeEnergy, beatCount)
    } else {
      (state.fearPeak, state.fearPeakBeat)
    };

    // Chronic fear and hormetic resolution
    var newChronicBeats = state.chronicBeats;
    var newResolutions = state.resolutionCount;
    var newVicente = state.vicenteVictories;
    var newAntifrag = state.antifragility;
    var newInSpike = state.inHormeticSpike;
    var newSpikeBeat = state.hormeticSpikeBeat;
    var victoryThisBeat = false;

    if (newFreeEnergy > 0.88) {
      newChronicBeats += 1;
    } else {
      if (state.inHormeticSpike and beatCount - state.hormeticSpikeBeat <= 50) {
        // Hormetic resolution — Vicente's Law fires
        newResolutions += 1;
        newVicente += 1;
        newAntifrag := Float.min(SOVEREIGN_CEILING, state.antifragility + 0.02);
        newInSpike := false;
        victoryThisBeat := true;
      };
      newChronicBeats := 0;
    };

    // Detect new hormetic spike
    if (newFreeEnergy > 0.92 and not state.inHormeticSpike) {
      newInSpike := true;
      newSpikeBeat := beatCount;
    };

    let newGlobalSignal = _clamp(
      0.90 * state.globalSignal + 0.10 * newFreeEnergy,
      0.0, 1.0
    );

    // Update history
    let newHistory = if (state.history.size() >= 100) {
      let tail = Array.tabulate<Float>(99, func(i) { state.history[i + 1] });
      Array.append<Float>(tail, [newFreeEnergy])
    } else {
      Array.append<Float>(state.history, [newFreeEnergy])
    };

    ({
      freeEnergy = newFreeEnergy;
      predictionError = newPredErr;
      lvExpansion = newLvExpansion;
      lvThreat = newLvThreat;
      lvTension = newLvTension;
      fearPeak = newPeak;
      fearPeakBeat = newPeakBeat;
      chronicBeats = newChronicBeats;
      resolutionCount = newResolutions;
      vicenteVictories = newVicente;
      antifragility = newAntifrag;
      inHormeticSpike = newInSpike;
      hormeticSpikeBeat = newSpikeBeat;
      globalSignal = newGlobalSignal;
      history = newHistory;
    }, victoryThisBeat)
  };

  // ── Fire Pillar Emergency Reset ───────────────────────────────
  public func checkFirePillar(
    kfHz: Float, driftError: Float, predErr: Float,
    currentAntifrag: Float, beatCount: Nat
  ) : (Bool, Float) {
    if (kfHz < 0.30 and driftError > 0.60 and predErr > 0.50) {
      // Emergency reset: boost antifragility
      (true, Float.min(SOVEREIGN_CEILING, currentAntifrag + 0.05))
    } else {
      (false, currentAntifrag)
    }
  };

  // ── Defense Amplifier ─────────────────────────────────────────
  public func defenseAmplifier(prophetArmed: Bool, armorFull: Bool) : Float {
    if (prophetArmed) { 1.25 }
    else if (armorFull) { 1.10 }
    else { 1.0 }
  };

  // ── GABA Suppression ──────────────────────────────────────────
  public func updateGabaSuppress(chronicBeats: Nat) : (Bool, Float) {
    if (chronicBeats >= 50) {
      (true, Float.min(1.0, Float.fromInt(chronicBeats) * 0.005))
    } else {
      (false, 0.0)
    }
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initAegis() : AegisState {
    {
      beatCount = 0;
      threat = {
        currentTier = 0;
        intensity = S0;
        beatsActive = 0;
        escalations = 0;
        resolutions = 0;
        peakTier = 0;
        peakBeat = 0;
        tierHits = Array.tabulate<Nat>(10, func(_) { 0 });
        history = [];
      };
      armor = {
        layerActivations = Array.tabulate<Float>(7, func(_) { S0 });
        layerBeats = Array.tabulate<Nat>(7, func(_) { 0 });
        fullActive = false;
        fullBeats = 0;
        defenseScore = S0;
      };
      prophet = {
        armed = false;
        armBeat = 0;
        totalArmings = 0;
        signal1Active = false;
        signal2Active = false;
        signal3Active = false;
        signal1Beats = 0;
        windowBeats = 0;
      };
      fear = {
        freeEnergy = S0;
        predictionError = 0.0;
        lvExpansion = S0;
        lvThreat = S0;
        lvTension = S0;
        fearPeak = S0;
        fearPeakBeat = 0;
        chronicBeats = 0;
        resolutionCount = 0;
        vicenteVictories = 0;
        antifragility = S0;
        inHormeticSpike = false;
        hormeticSpikeBeat = 0;
        globalSignal = S0;
        history = [];
      };
      innerSphere = {
        activations = Array.tabulate<Float>(12, func(_) { S0 });
        phases = Array.tabulate<Float>(12, func(i) { Float.fromInt(i) * 0.5236 });
        hebbWeights = Array.tabulate<Float>(144, func(_) { S0 });
        kfHz = S0;
      };
      gabaSuppress = false;
      gabaSuppressSignal = 0.0;
      firePillarActive = false;
      firePillarTriggers = 0;
      lastKfHz = S0;
      lastArousal = S0;
    }
  };

  // ── Full Beat Update ──────────────────────────────────────────
  public func beatAegis(
    state: AegisState, kfHz: Float, arousal: Float,
    da: Float, gaba: Float, driftError: Float, predErr: Float
  ) : AegisState {
    let safeKfHz = Float.max(S0, kfHz);
    let safeArousal = Float.max(S0, arousal);
    let safeDa = Float.max(S0, da);
    let safeGaba = Float.max(S0, gaba);

    // Run inner sphere
    let newInner = runInnerSphere(state.innerSphere);

    // Update fear substrate
    let (newFear, victoryThisBeat) = updateFear(
      state.fear, safeKfHz, state.lastKfHz, safeArousal, state.beatCount + 1
    );

    // GABA suppression
    let (newGabaSuppress, newGabaSuppressSignal) = updateGabaSuppress(newFear.chronicBeats);

    // Update armor
    let newArmor = updateArmor(
      state.armor, safeKfHz, newInner.kfHz,
      safeArousal, safeDa, safeGaba, true, newFear.antifragility
    );

    // Update prophet
    let newProphet = updateProphet(
      state.prophet, safeKfHz, newArmor.fullActive,
      victoryThisBeat, state.beatCount + 1
    );

    // Fire pillar check
    let (pillarActive, boostedAntifrag) = checkFirePillar(
      safeKfHz, driftError, predErr, newFear.antifragility, state.beatCount + 1
    );

    // Threat classification
    let kfDrop = Float.max(0.0, 0.88 - safeKfHz);
    let newTier = classifyThreat(
      kfDrop, newFear.freeEnergy, safeArousal,
      newFear.lvTension, newFear.chronicBeats, state.threat.beatsActive
    );

    // Threat state update
    let amp = defenseAmplifier(newProphet.armed, newArmor.fullActive);
    let newIntensity = Float.max(S0,
      Float.min(1.0, (Float.fromInt(newTier) / 9.0 + kfDrop) * amp));

    let newEscalations = if (newTier > state.threat.currentTier) {
      state.threat.escalations + 1
    } else { state.threat.escalations };

    let newResolutions = if (newTier < state.threat.currentTier) {
      state.threat.resolutions + 1
    } else { state.threat.resolutions };

    let newBeatsActive = if (newTier > 0) { state.threat.beatsActive + 1 } else { 0 };

    let (newPeakTier, newPeakBeat) = if (newTier > state.threat.peakTier) {
      (newTier, state.beatCount + 1)
    } else {
      (state.threat.peakTier, state.threat.peakBeat)
    };

    // Update tier hits
    var newTierHits = Array.thaw<Nat>(state.threat.tierHits);
    newTierHits[newTier] := state.threat.tierHits[newTier] + 1;

    // Update threat history
    let newThreatHistory = if (state.threat.history.size() >= 50) {
      let tail = Array.tabulate<Float>(49, func(i) { state.threat.history[i + 1] });
      Array.append<Float>(tail, [newIntensity])
    } else {
      Array.append<Float>(state.threat.history, [newIntensity])
    };

    // Final fear state with boosted antifragility if fire pillar triggered
    let finalFear = if (pillarActive) {
      {
        freeEnergy = S0;  // Reset on fire pillar
        predictionError = newFear.predictionError;
        lvExpansion = newFear.lvExpansion;
        lvThreat = newFear.lvThreat;
        lvTension = newFear.lvTension;
        fearPeak = newFear.fearPeak;
        fearPeakBeat = newFear.fearPeakBeat;
        chronicBeats = 0;  // Reset chronic
        resolutionCount = newFear.resolutionCount;
        vicenteVictories = newFear.vicenteVictories;
        antifragility = boostedAntifrag;
        inHormeticSpike = false;
        hormeticSpikeBeat = newFear.hormeticSpikeBeat;
        globalSignal = newFear.globalSignal;
        history = newFear.history;
      }
    } else { newFear };

    {
      beatCount = state.beatCount + 1;
      threat = {
        currentTier = newTier;
        intensity = newIntensity;
        beatsActive = newBeatsActive;
        escalations = newEscalations;
        resolutions = newResolutions;
        peakTier = newPeakTier;
        peakBeat = newPeakBeat;
        tierHits = Array.freeze(newTierHits);
        history = newThreatHistory;
      };
      armor = newArmor;
      prophet = newProphet;
      fear = finalFear;
      innerSphere = newInner;
      gabaSuppress = newGabaSuppress;
      gabaSuppressSignal = newGabaSuppressSignal;
      firePillarActive = pillarActive;
      firePillarTriggers = if (pillarActive) { state.firePillarTriggers + 1 }
                           else { state.firePillarTriggers };
      lastKfHz = safeKfHz;
      lastArousal = safeArousal;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type AegisSummary = {
    threatTier       : Nat;
    threatIntensity  : Float;
    armorActive      : Bool;
    armorScore       : Float;
    prophetArmed     : Bool;
    fearEnergy       : Float;
    lvTension        : Float;
    chronicFearBeats : Nat;
    vicenteVictories : Nat;
    antifragility    : Float;
    gabaSuppress     : Bool;
    firePillarActive : Bool;
    innerKfHz        : Float;
    globalFearSignal : Float;
  };

  public func summary(state: AegisState) : AegisSummary {
    {
      threatTier = state.threat.currentTier;
      threatIntensity = state.threat.intensity;
      armorActive = state.armor.fullActive;
      armorScore = state.armor.defenseScore;
      prophetArmed = state.prophet.armed;
      fearEnergy = state.fear.freeEnergy;
      lvTension = state.fear.lvTension;
      chronicFearBeats = state.fear.chronicBeats;
      vicenteVictories = state.fear.vicenteVictories;
      antifragility = state.fear.antifragility;
      gabaSuppress = state.gabaSuppress;
      firePillarActive = state.firePillarActive;
      innerKfHz = state.innerSphere.kfHz;
      globalFearSignal = state.fear.globalSignal;
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
