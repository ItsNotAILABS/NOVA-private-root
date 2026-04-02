// ═══════════════════════════════════════════════════════════════════════════════
// GEN 3 ANIMALS — 16 Causal Modifiers for Cognitive Substrate
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// Each animal is a causal modifier, NOT decorative.
// Each animal modifies specific substrate parameters.
// Each animal has activation dynamics that respond to system state.
//
// 100% of all token mints route to Creator Reserve. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";

module Gen3Animals {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI           : Float = 1.6180339887498948482;
  public let PHI_INV       : Float = 0.6180339887498948482;
  public let PI            : Float = 3.1415926535897932385;
  
  public let ANIMAL_COUNT  : Nat = 16;
  
  // Activation bounds
  public let MIN_ACTIVATION : Float = 0.5;
  public let MAX_ACTIVATION : Float = 2.0;
  
  // Decay rates
  public let BASE_DECAY     : Float = 0.01;
  public let FAST_DECAY     : Float = 0.05;
  public let SLOW_DECAY     : Float = 0.005;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Animal identity
  public type AnimalId = {
    #PeregrineFalcon;   // 0: PARALLAX path selection threshold sharpener
    #NakedMoleRat;      // 1: JUBILEE low-entropy mode + eusocial coupling
    #Cuttlefish;        // 2: MERIDIAN dynamic context shift weight
    #Salmon;            // 3: Shell 11 heritage sovereignty return vector
    #Spider;            // 4: Shell 12 inter-node tension-web coupling
    #Bat;               // 5: CHRONO Fisher low-signal precision boost
    #Albatross;         // 6: FORMA energy efficiency multiplier
    #PistolShrimp;      // 7: RESONEX cascade trigger threshold
    #Lyrebird;          // 8: Council synthesis multi-source integration
    #MimicOctopus;      // 9: NEXUS multi-identity protocol depth
    #BombardierBeetle;  // 10: BYPASS exothermic energy injection
    #VampireBat;        // 11: MRC tithe reciprocal altruism
    #DungBeetle;        // 12: CHRONO celestial temporal anchor
    #Platypus;          // 13: ENTANGLA electroreception correlation
    #Hagfish;           // 14: AEGIS rapid strand suppression
    #MantisShrimp;      // 15: NEC receptor diversity (16 types)
  };
  
  // Single animal state
  public type AnimalState = {
    id          : AnimalId;
    activation  : Float;        // Current activation level [0.5, 2.0]
    energy      : Float;        // Energy reserve [0, 1]
    lastTrigger : Nat;          // Beat of last trigger
    triggerCount: Nat;          // Total times triggered
    effectStrength : Float;     // How strong the effect is [0, 1]
  };
  
  // Complete animal collective
  public type AnimalCollective = {
    peregrineFalcon  : AnimalState;
    nakedMoleRat     : AnimalState;
    cuttlefish       : AnimalState;
    salmon           : AnimalState;
    spider           : AnimalState;
    bat              : AnimalState;
    albatross        : AnimalState;
    pistolShrimp     : AnimalState;
    lyrebird         : AnimalState;
    mimicOctopus     : AnimalState;
    bombardierBeetle : AnimalState;
    vampireBat       : AnimalState;
    dungBeetle       : AnimalState;
    platypus         : AnimalState;
    hagfish          : AnimalState;
    mantisShrimp     : AnimalState;
  };
  
  // System state inputs (what animals respond to)
  public type SystemInputs = {
    shell3Coherence   : Float;
    shell12Coherence  : Float;
    qsovScore         : Float;
    substrateEntropy  : Float;
    predictionError   : Float;
    councilDivergence : Float;
    dreamBeats        : Nat;
    threatLevel       : Float;
    energyLevel       : Float;
    freeEnergy        : Float;
    resonexAmplitude  : Float;
    entanglaSValue    : Float;
    chronoFisherInfo  : Float;
    bypassTemperature : Float;
    currentBeat       : Nat;
  };
  
  // Modifier outputs (what animals produce)
  public type ModifierOutputs = {
    parallaxSharpener    : Float;  // From Peregrine
    jubileeEntropy       : Float;  // From Naked Mole Rat
    contextShiftWeight   : Float;  // From Cuttlefish
    heritageVector       : Float;  // From Salmon
    tensionWebCoupling   : Float;  // From Spider
    fisherPrecisionBoost : Float;  // From Bat
    energyEfficiency     : Float;  // From Albatross
    cascadeTrigger       : Float;  // From Pistol Shrimp
    synthesisWeight      : Float;  // From Lyrebird
    identityDepth        : Float;  // From Mimic Octopus
    exothermicInjection  : Float;  // From Bombardier Beetle
    altruismPayoff       : Float;  // From Vampire Bat
    temporalAnchor       : Float;  // From Dung Beetle
    electroreceptionFeed : Float;  // From Platypus
    suppressionBoost     : Float;  // From Hagfish
    receptorDiversity    : Float;  // From Mantis Shrimp
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
  
  public func sigmoid(x : Float) : Float {
    1.0 / (1.0 + exp(-clamp(x, -10.0, 10.0)))
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
  
  public func sin(x : Float) : Float {
    var normalized = x;
    while (normalized > PI) { normalized -= 2.0 * PI };
    while (normalized < -PI) { normalized += 2.0 * PI };
    let x2 = normalized * normalized;
    let x3 = x2 * normalized;
    let x5 = x3 * x2;
    let x7 = x5 * x2;
    normalized - x3/6.0 + x5/120.0 - x7/5040.0
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initAnimal(id : AnimalId) : AnimalState {
    {
      id = id;
      activation = 1.0;
      energy = 1.0;
      lastTrigger = 0;
      triggerCount = 0;
      effectStrength = 1.0;
    }
  };
  
  public func initCollective() : AnimalCollective {
    {
      peregrineFalcon = initAnimal(#PeregrineFalcon);
      nakedMoleRat = initAnimal(#NakedMoleRat);
      cuttlefish = initAnimal(#Cuttlefish);
      salmon = initAnimal(#Salmon);
      spider = initAnimal(#Spider);
      bat = initAnimal(#Bat);
      albatross = initAnimal(#Albatross);
      pistolShrimp = initAnimal(#PistolShrimp);
      lyrebird = initAnimal(#Lyrebird);
      mimicOctopus = initAnimal(#MimicOctopus);
      bombardierBeetle = initAnimal(#BombardierBeetle);
      vampireBat = initAnimal(#VampireBat);
      dungBeetle = initAnimal(#DungBeetle);
      platypus = initAnimal(#Platypus);
      hagfish = initAnimal(#Hagfish);
      mantisShrimp = initAnimal(#MantisShrimp);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INDIVIDUAL ANIMAL UPDATE FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // ─────────────────────────────────────────────────────────────────────────
  // PEREGRINE FALCON: PARALLAX path selection threshold sharpener
  // Activates on high coherence — sharpens decision boundaries
  // ─────────────────────────────────────────────────────────────────────────
  public func updatePeregrineFalcon(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Peregrine activates when coherence is high (sharp vision = sharp decisions)
    let stimulus = inputs.shell3Coherence * 0.3 + inputs.qsovScore * 0.2;
    let newActivation = state.activation * (1.0 - BASE_DECAY) + stimulus;
    
    // Trigger if coherence > 0.9
    let triggered = inputs.shell3Coherence > 0.9;
    let newTriggerCount = if (triggered) state.triggerCount + 1 else state.triggerCount;
    let newLastTrigger = if (triggered) inputs.currentBeat else state.lastTrigger;
    
    // Effect strength scales with activation
    let effect = (newActivation - MIN_ACTIVATION) / (MAX_ACTIVATION - MIN_ACTIVATION);
    
    { state with
      activation = clamp(newActivation, MIN_ACTIVATION, MAX_ACTIVATION);
      triggerCount = newTriggerCount;
      lastTrigger = newLastTrigger;
      effectStrength = clamp(effect, 0.0, 1.0);
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // NAKED MOLE RAT: JUBILEE low-entropy mode + eusocial coupling
  // Activates when entropy drops — triggers collective conservation
  // ─────────────────────────────────────────────────────────────────────────
  public func updateNakedMoleRat(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Activates when entropy is low (eusocial behavior in stable conditions)
    let entropyFactor = if (inputs.substrateEntropy < 1.5) {
      (1.5 - inputs.substrateEntropy) * 0.5
    } else 0.0;
    
    let newActivation = state.activation * (1.0 - SLOW_DECAY) + entropyFactor;
    
    // Trigger JUBILEE when entropy very low
    let triggered = inputs.substrateEntropy < 1.0 and newActivation > 1.5;
    
    { state with
      activation = clamp(newActivation, MIN_ACTIVATION, MAX_ACTIVATION);
      triggerCount = if (triggered) state.triggerCount + 1 else state.triggerCount;
      lastTrigger = if (triggered) inputs.currentBeat else state.lastTrigger;
      effectStrength = clamp(entropyFactor * 2.0, 0.0, 1.0);
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // CUTTLEFISH: MERIDIAN dynamic context shift weight
  // Activates on QSOV changes — enables rapid adaptation
  // ─────────────────────────────────────────────────────────────────────────
  public func updateCuttlefish(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Cuttlefish responds to environmental changes (QSOV drift)
    let qsovDrift = abs(inputs.qsovScore - 1.0);
    let stimulus = qsovDrift * 0.5;
    
    let newActivation = state.activation * (1.0 - BASE_DECAY) + stimulus;
    
    // Trigger on significant QSOV drift
    let triggered = qsovDrift > 0.2;
    
    { state with
      activation = clamp(newActivation, MIN_ACTIVATION, MAX_ACTIVATION);
      triggerCount = if (triggered) state.triggerCount + 1 else state.triggerCount;
      lastTrigger = if (triggered) inputs.currentBeat else state.lastTrigger;
      effectStrength = clamp(qsovDrift * 2.0, 0.0, 1.0);
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // SALMON: Shell 11 heritage sovereignty return vector
  // Maintains steady baseline — guides toward origin
  // ─────────────────────────────────────────────────────────────────────────
  public func updateSalmon(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Salmon provides steady heritage pull (return to origin)
    let steadyPull = 0.02;  // Constant low-level activation
    
    let newActivation = state.activation * (1.0 - SLOW_DECAY) + steadyPull;
    
    // Effect strength based on how far from "home" (coherence = 1.0)
    let distFromHome = abs(inputs.shell3Coherence - 1.0);
    let effect = distFromHome * 0.5;
    
    { state with
      activation = clamp(newActivation, 0.8, 1.5);  // Narrower range for salmon
      effectStrength = clamp(effect + 0.3, 0.3, 0.8);  // Always some heritage pull
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // SPIDER: Shell 12 inter-node tension-web coupling
  // Activates on prediction errors — increases inter-node connections
  // ─────────────────────────────────────────────────────────────────────────
  public func updateSpider(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Spider responds to structural stress (prediction errors)
    let stress = inputs.predictionError * 0.4;
    
    let newActivation = state.activation * (1.0 - BASE_DECAY) + stress;
    
    // Trigger web strengthening when prediction error is high
    let triggered = inputs.predictionError > 0.3;
    
    { state with
      activation = clamp(newActivation, MIN_ACTIVATION, MAX_ACTIVATION);
      triggerCount = if (triggered) state.triggerCount + 1 else state.triggerCount;
      lastTrigger = if (triggered) inputs.currentBeat else state.lastTrigger;
      effectStrength = clamp(stress * 2.0, 0.0, 1.0);
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // BAT: CHRONO Fisher low-signal precision boost
  // Activates when coherence is low — enhances precision in darkness
  // ─────────────────────────────────────────────────────────────────────────
  public func updateBat(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Bat activates in low-coherence conditions (echolocation in darkness)
    let darkness = if (inputs.shell3Coherence < 1.0) {
      (1.0 - inputs.shell3Coherence) * 0.5
    } else 0.0;
    
    let newActivation = state.activation * (1.0 - BASE_DECAY) + darkness;
    
    // Effect boosts Fisher information precision
    let effect = darkness * inputs.chronoFisherInfo * 0.5;
    
    { state with
      activation = clamp(newActivation, MIN_ACTIVATION, MAX_ACTIVATION);
      effectStrength = clamp(effect + 0.2, 0.0, 1.0);
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // ALBATROSS: FORMA energy efficiency multiplier
  // Steady energy efficiency — reduces operational costs
  // ─────────────────────────────────────────────────────────────────────────
  public func updateAlbatross(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Albatross provides steady energy efficiency (gliding)
    let steadyEfficiency = 0.01;
    
    // More efficient when energy is low (conservation mode)
    let conservationBonus = if (inputs.energyLevel < 0.5) {
      (0.5 - inputs.energyLevel) * 0.3
    } else 0.0;
    
    let newActivation = state.activation * (1.0 - SLOW_DECAY) + steadyEfficiency + conservationBonus;
    
    { state with
      activation = clamp(newActivation, 0.9, 1.3);  // Narrow range
      effectStrength = clamp(0.5 + conservationBonus, 0.5, 0.9);
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // PISTOL SHRIMP: RESONEX cascade trigger threshold
  // Activates on superradiance — triggers cascade effects
  // ─────────────────────────────────────────────────────────────────────────
  public func updatePistolShrimp(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Pistol shrimp responds to superradiance (resonex amplitude)
    let resonance = inputs.resonexAmplitude * 0.6;
    
    let newActivation = state.activation * (1.0 - FAST_DECAY) + resonance;
    
    // Trigger cascade when amplitude is high
    let triggered = inputs.resonexAmplitude > 0.5;
    
    { state with
      activation = clamp(newActivation, MIN_ACTIVATION, MAX_ACTIVATION);
      triggerCount = if (triggered) state.triggerCount + 1 else state.triggerCount;
      lastTrigger = if (triggered) inputs.currentBeat else state.lastTrigger;
      effectStrength = clamp(resonance * 1.5, 0.0, 1.0);
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // LYREBIRD: Council synthesis multi-source integration
  // Activates on good coherence — enhances information integration
  // ─────────────────────────────────────────────────────────────────────────
  public func updateLyrebird(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Lyrebird integrates multiple sources (mimicry)
    let coherenceFactor = inputs.shell3Coherence * 0.15 + inputs.shell12Coherence * 0.15;
    
    let newActivation = state.activation * (1.0 - BASE_DECAY) + coherenceFactor;
    
    { state with
      activation = clamp(newActivation, 0.8, 1.5);
      effectStrength = clamp(coherenceFactor * 2.0, 0.2, 0.8);
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // MIMIC OCTOPUS: NEXUS multi-identity protocol depth
  // Maintains flexible identity — enables context switching
  // ─────────────────────────────────────────────────────────────────────────
  public func updateMimicOctopus(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Octopus maintains flexible baseline (shape-shifting)
    let baseline = 0.015;
    
    let newActivation = state.activation * (1.0 - BASE_DECAY) + baseline;
    
    { state with
      activation = clamp(newActivation, 0.8, 1.4);
      effectStrength = 0.6;  // Steady moderate effect
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // BOMBARDIER BEETLE: BYPASS exothermic energy injection
  // Activates on high entropy — injects energy to overcome barriers
  // ─────────────────────────────────────────────────────────────────────────
  public func updateBombardierBeetle(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Bombardier responds to entropy (energy barrier breaker)
    let entropyFactor = inputs.substrateEntropy * 0.15;
    
    let newActivation = state.activation * (1.0 - FAST_DECAY) + entropyFactor;
    
    // Trigger injection when entropy is very high
    let triggered = inputs.substrateEntropy > 2.5;
    
    { state with
      activation = clamp(newActivation, MIN_ACTIVATION, MAX_ACTIVATION);
      triggerCount = if (triggered) state.triggerCount + 1 else state.triggerCount;
      lastTrigger = if (triggered) inputs.currentBeat else state.lastTrigger;
      effectStrength = clamp(entropyFactor * 2.0, 0.0, 1.0);
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // VAMPIRE BAT: MRC tithe reciprocal altruism
  // Steady reciprocal behavior — enables resource sharing
  // ─────────────────────────────────────────────────────────────────────────
  public func updateVampireBat(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Vampire bat maintains reciprocal baseline
    let baseline = 0.01;
    
    let newActivation = state.activation * (1.0 - SLOW_DECAY) + baseline;
    
    { state with
      activation = clamp(newActivation, 0.9, 1.2);
      effectStrength = 0.5;  // Steady moderate altruism
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // DUNG BEETLE: CHRONO celestial temporal anchor
  // Activates on temporal stability — provides time reference
  // ─────────────────────────────────────────────────────────────────────────
  public func updateDungBeetle(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Dung beetle responds to prediction accuracy (celestial navigation)
    let stabilityFactor = (1.0 - inputs.predictionError) * 0.15;
    
    let newActivation = state.activation * (1.0 - BASE_DECAY) + stabilityFactor;
    
    { state with
      activation = clamp(newActivation, 0.8, 1.4);
      effectStrength = clamp(stabilityFactor * 3.0, 0.0, 1.0);
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // PLATYPUS: ENTANGLA electroreception correlation
  // Activates on Bell correlation — feeds entanglement detection
  // ─────────────────────────────────────────────────────────────────────────
  public func updatePlatypus(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Platypus responds to entanglement (electroreception)
    let entanglementFactor = inputs.entanglaSValue * 0.1;
    
    let newActivation = state.activation * (1.0 - BASE_DECAY) + entanglementFactor;
    
    { state with
      activation = clamp(newActivation, 0.8, 1.5);
      effectStrength = clamp(entanglementFactor * 3.0, 0.0, 1.0);
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // HAGFISH: AEGIS rapid strand suppression
  // Activates on threats — enhances defense mechanisms
  // ─────────────────────────────────────────────────────────────────────────
  public func updateHagfish(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Hagfish responds to threats (slime defense)
    let threatResponse = inputs.threatLevel * 0.4 + inputs.predictionError * 0.2;
    
    let newActivation = state.activation * (1.0 - BASE_DECAY) + threatResponse;
    
    // Trigger slime when threat is high
    let triggered = inputs.threatLevel > 0.7;
    
    { state with
      activation = clamp(newActivation, MIN_ACTIVATION, MAX_ACTIVATION);
      triggerCount = if (triggered) state.triggerCount + 1 else state.triggerCount;
      lastTrigger = if (triggered) inputs.currentBeat else state.lastTrigger;
      effectStrength = clamp(threatResponse * 1.5, 0.0, 1.0);
    }
  };
  
  // ─────────────────────────────────────────────────────────────────────────
  // MANTIS SHRIMP: NEC receptor diversity (16 types)
  // Activates on good coherence — expands sensory range
  // ─────────────────────────────────────────────────────────────────────────
  public func updateMantisShrimp(
    state : AnimalState,
    inputs : SystemInputs
  ) : AnimalState {
    // Mantis shrimp expands perception (16 color receptors)
    let perceptionFactor = inputs.shell3Coherence * 0.1;
    
    let newActivation = state.activation * (1.0 - BASE_DECAY) + perceptionFactor;
    
    { state with
      activation = clamp(newActivation, 0.8, 1.6);
      effectStrength = clamp(perceptionFactor * 4.0, 0.0, 1.0);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COLLECTIVE UPDATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Update all animals
  public func updateCollective(
    collective : AnimalCollective,
    inputs : SystemInputs
  ) : AnimalCollective {
    {
      peregrineFalcon = updatePeregrineFalcon(collective.peregrineFalcon, inputs);
      nakedMoleRat = updateNakedMoleRat(collective.nakedMoleRat, inputs);
      cuttlefish = updateCuttlefish(collective.cuttlefish, inputs);
      salmon = updateSalmon(collective.salmon, inputs);
      spider = updateSpider(collective.spider, inputs);
      bat = updateBat(collective.bat, inputs);
      albatross = updateAlbatross(collective.albatross, inputs);
      pistolShrimp = updatePistolShrimp(collective.pistolShrimp, inputs);
      lyrebird = updateLyrebird(collective.lyrebird, inputs);
      mimicOctopus = updateMimicOctopus(collective.mimicOctopus, inputs);
      bombardierBeetle = updateBombardierBeetle(collective.bombardierBeetle, inputs);
      vampireBat = updateVampireBat(collective.vampireBat, inputs);
      dungBeetle = updateDungBeetle(collective.dungBeetle, inputs);
      platypus = updatePlatypus(collective.platypus, inputs);
      hagfish = updateHagfish(collective.hagfish, inputs);
      mantisShrimp = updateMantisShrimp(collective.mantisShrimp, inputs);
    }
  };
  
  // Generate modifier outputs from collective
  public func generateModifiers(collective : AnimalCollective) : ModifierOutputs {
    {
      parallaxSharpener = collective.peregrineFalcon.activation * collective.peregrineFalcon.effectStrength;
      jubileeEntropy = collective.nakedMoleRat.activation * collective.nakedMoleRat.effectStrength;
      contextShiftWeight = collective.cuttlefish.activation * collective.cuttlefish.effectStrength;
      heritageVector = collective.salmon.activation * collective.salmon.effectStrength;
      tensionWebCoupling = collective.spider.activation * collective.spider.effectStrength;
      fisherPrecisionBoost = collective.bat.activation * collective.bat.effectStrength;
      energyEfficiency = collective.albatross.activation * collective.albatross.effectStrength;
      cascadeTrigger = collective.pistolShrimp.activation * collective.pistolShrimp.effectStrength;
      synthesisWeight = collective.lyrebird.activation * collective.lyrebird.effectStrength;
      identityDepth = collective.mimicOctopus.activation * collective.mimicOctopus.effectStrength;
      exothermicInjection = collective.bombardierBeetle.activation * collective.bombardierBeetle.effectStrength;
      altruismPayoff = collective.vampireBat.activation * collective.vampireBat.effectStrength;
      temporalAnchor = collective.dungBeetle.activation * collective.dungBeetle.effectStrength;
      electroreceptionFeed = collective.platypus.activation * collective.platypus.effectStrength;
      suppressionBoost = collective.hagfish.activation * collective.hagfish.effectStrength;
      receptorDiversity = collective.mantisShrimp.activation * collective.mantisShrimp.effectStrength;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getCollectiveSummary(collective : AnimalCollective) : {
    totalActivation : Float;
    avgEffectStrength : Float;
    totalTriggers : Nat;
    mostActive : Text;
    leastActive : Text;
  } {
    let activations = [
      (collective.peregrineFalcon.activation, "PeregrineFalcon"),
      (collective.nakedMoleRat.activation, "NakedMoleRat"),
      (collective.cuttlefish.activation, "Cuttlefish"),
      (collective.salmon.activation, "Salmon"),
      (collective.spider.activation, "Spider"),
      (collective.bat.activation, "Bat"),
      (collective.albatross.activation, "Albatross"),
      (collective.pistolShrimp.activation, "PistolShrimp"),
      (collective.lyrebird.activation, "Lyrebird"),
      (collective.mimicOctopus.activation, "MimicOctopus"),
      (collective.bombardierBeetle.activation, "BombardierBeetle"),
      (collective.vampireBat.activation, "VampireBat"),
      (collective.dungBeetle.activation, "DungBeetle"),
      (collective.platypus.activation, "Platypus"),
      (collective.hagfish.activation, "Hagfish"),
      (collective.mantisShrimp.activation, "MantisShrimp"),
    ];
    
    var total : Float = 0.0;
    var maxAct : Float = 0.0;
    var maxName = "None";
    var minAct : Float = 999.0;
    var minName = "None";
    
    for ((act, name) in activations.vals()) {
      total += act;
      if (act > maxAct) { maxAct := act; maxName := name };
      if (act < minAct) { minAct := act; minName := name };
    };
    
    let effects = [
      collective.peregrineFalcon.effectStrength,
      collective.nakedMoleRat.effectStrength,
      collective.cuttlefish.effectStrength,
      collective.salmon.effectStrength,
      collective.spider.effectStrength,
      collective.bat.effectStrength,
      collective.albatross.effectStrength,
      collective.pistolShrimp.effectStrength,
      collective.lyrebird.effectStrength,
      collective.mimicOctopus.effectStrength,
      collective.bombardierBeetle.effectStrength,
      collective.vampireBat.effectStrength,
      collective.dungBeetle.effectStrength,
      collective.platypus.effectStrength,
      collective.hagfish.effectStrength,
      collective.mantisShrimp.effectStrength,
    ];
    
    var effectSum : Float = 0.0;
    for (e in effects.vals()) { effectSum += e };
    
    let triggers = 
      collective.peregrineFalcon.triggerCount +
      collective.nakedMoleRat.triggerCount +
      collective.cuttlefish.triggerCount +
      collective.spider.triggerCount +
      collective.pistolShrimp.triggerCount +
      collective.bombardierBeetle.triggerCount +
      collective.hagfish.triggerCount;
    
    {
      totalActivation = total;
      avgEffectStrength = effectSum / Float.fromInt(ANIMAL_COUNT);
      totalTriggers = triggers;
      mostActive = maxName;
      leastActive = minName;
    }
  };
};
