// ============================================================
// COMPLETE ANIMAL BRAIN CATALOG — 32 NEURAL ARCHITECTURES
// All phyla from nerve nets to neocortex
// Implements the MEDINA COMPARATIVE NEUROLOGY (MCN)
// 
// Tiers:
// 1. Diffuse/Non-centralized (Cnidarian, Echinoderm, Porifera)
// 2. Ganglion/Ladder (Flatworm, Annelid, Mollusc)
// 3. Mushroom Body/Arthropod (Insect, Crustacean, Spider)
// 4. Cephalopod (Octopus, Squid, Nautilus)
// 5. Vertebrate (Lamprey → Primate)
// 6. Specialized Sensing (Electric fish, Platypus, Mantis shrimp)
// 7. Colony/Superorganism (Slime mold, Ants, Bees, Murmurations)
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";

module {

  // ── FUNDAMENTAL CONSTANTS ──────────────────────────────────────
  let PHI : Float = 1.618033988749895;
  let PHI_INV : Float = 0.618033988749895;
  let TAU : Float = 6.283185307179586;
  let SOVEREIGN_METAL : Float = 1.0;
  let S0 : Float = 1.0;

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ════════════════════════════════════════════════════════════════
  // TIER 1 — DIFFUSE / NON-CENTRALIZED
  // ════════════════════════════════════════════════════════════════

  // ── 1. CNIDARIAN NERVE NET ─────────────────────────────────────
  // Jellyfish, Hydra, Sea Anemone — ~800-1000 neurons
  // No brain, distributed nerve ring, radial diffusion

  public type CnidarianNeuron = {
    id            : Nat;
    positionAngle : Float;
    activation    : Float;
    threshold     : Float;
    refractoryTime: Float;
  };

  public type NerveNetState = {
    neurons       : [CnidarianNeuron];
    diffusionRate : Float;
    decayRate     : Float;
    globalActivity: Float;
    beatNum       : Nat;
  };

  public func initNerveNet(nNeurons: Nat) : NerveNetState {
    {
      neurons = Array.tabulate<CnidarianNeuron>(nNeurons, func(i) {
        {
          id = i;
          positionAngle = TAU * Float.fromInt(i) / Float.fromInt(nNeurons);
          activation = 0.0;
          threshold = 0.5;
          refractoryTime = 0.0;
        }
      });
      diffusionRate = 0.3;
      decayRate = 0.1;
      globalActivity = 0.0;
      beatNum = 0;
    }
  };

  public func beatNerveNet(state: NerveNetState, stimulus: ?Float, dt: Float) : NerveNetState {
    let n = state.neurons.size();
    var newActivations = Array.init<Float>(n, 0.0);
    
    var i = 0;
    while (i < n) {
      let neuron = state.neurons[i];
      let leftIdx = if (i == 0) { n - 1 } else { i - 1 };
      let rightIdx = if (i == n - 1) { 0 } else { i + 1 };
      
      let neighborAvg = (state.neurons[leftIdx].activation + state.neurons[rightIdx].activation) / 2.0;
      let diffusion = state.diffusionRate * neighborAvg;
      let decay = neuron.activation * (1.0 - state.decayRate * dt);
      
      let stim = switch (stimulus) {
        case (null) { 0.0 };
        case (?s) { if (Float.abs(neuron.positionAngle - s) < 0.3) { 0.5 } else { 0.0 } };
      };
      
      let total = decay + diffusion + stim;
      newActivations[i] := if (neuron.refractoryTime > 0.0) { 0.0 }
                          else if (total > neuron.threshold) { 1.0 }
                          else { _clamp(total, 0.0, 1.0) };
      i += 1;
    };
    
    let newNeurons = Array.tabulate<CnidarianNeuron>(n, func(j) {
      let neuron = state.neurons[j];
      let fired = newActivations[j] > 0.9;
      {
        id = neuron.id;
        positionAngle = neuron.positionAngle;
        activation = newActivations[j];
        threshold = neuron.threshold;
        refractoryTime = if (fired) { 5.0 } else { Float.max(0.0, neuron.refractoryTime - dt) };
      }
    });
    
    var total : Float = 0.0;
    for (act in newActivations.vals()) { total += act };
    
    {
      neurons = newNeurons;
      diffusionRate = state.diffusionRate;
      decayRate = state.decayRate;
      globalActivity = total / Float.fromInt(n);
      beatNum = state.beatNum + 1;
    }
  };

  // ── 2. ECHINODERM RADIAL NERVE ─────────────────────────────────
  // Starfish, Sea Urchin — 5-fold radial symmetry

  public type EchinodermArm = {
    armId         : Nat;
    activity      : Float;
    tubeFootOutput: Float;
    sensoryInput  : Float;
  };

  public type EchinodermState = {
    centralRing   : [Float];
    arms          : [EchinodermArm];
    locomotionX   : Float;
    locomotionY   : Float;
    beatNum       : Nat;
  };

  public func initEchinoderm() : EchinodermState {
    {
      centralRing = [0.5, 0.5, 0.5, 0.5, 0.5];
      arms = Array.tabulate<EchinodermArm>(5, func(i) {
        { armId = i; activity = 0.5; tubeFootOutput = 0.0; sensoryInput = 0.0 }
      });
      locomotionX = 0.0;
      locomotionY = 0.0;
      beatNum = 0;
    }
  };

  public func beatEchinoderm(state: EchinodermState, armInputs: [Float]) : EchinodermState {
    var newRing = Array.thaw<Float>(state.centralRing);
    var newArms = Array.thaw<EchinodermArm>(state.arms);
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    
    var i = 0;
    while (i < 5) {
      let input = if (i < armInputs.size()) { armInputs[i] } else { 0.0 };
      newRing[i] := state.centralRing[i] * 0.9 + input * 0.1;
      
      let arm = state.arms[i];
      let newActivity = arm.activity * 0.8 + newRing[i] * 0.2;
      let angle = TAU * Float.fromInt(i) / 5.0;
      
      newArms[i] := {
        armId = i;
        activity = newActivity;
        tubeFootOutput = newActivity;
        sensoryInput = input;
      };
      
      sumX += newActivity * Float.cos(angle);
      sumY += newActivity * Float.sin(angle);
      i += 1;
    };
    
    {
      centralRing = Array.freeze(newRing);
      arms = Array.freeze(newArms);
      locomotionX = sumX / 5.0;
      locomotionY = sumY / 5.0;
      beatNum = state.beatNum + 1;
    }
  };

  // ── 3. PORIFERA — CALCIUM WAVE (No Neurons) ────────────────────

  public type CalciumCell = {
    x: Nat; y: Nat;
    calcium: Float;
    refractory: Float;
  };

  public type PoriferaState = {
    cells         : [[CalciumCell]];
    width         : Nat;
    height        : Nat;
    contractionLevel: Float;
    beatNum       : Nat;
  };

  // ════════════════════════════════════════════════════════════════
  // TIER 2 — GANGLION / LADDER
  // ════════════════════════════════════════════════════════════════

  // ── 4. FLATWORM LADDER BRAIN ───────────────────────────────────
  // Planaria — ~10,000 neurons, bilateral ladder

  public type LadderSegment = {
    segmentId     : Nat;
    leftCord      : Float;
    rightCord     : Float;
    commissure    : Float;
    motorOutput   : Float;
  };

  public type FlatwormState = {
    leftGanglion  : Float;
    rightGanglion : Float;
    segments      : [LadderSegment];
    photoTaxis    : Float;
    chemoTaxis    : Float;
    beatNum       : Nat;
  };

  public func initFlatworm(nSegments: Nat) : FlatwormState {
    {
      leftGanglion = 0.5;
      rightGanglion = 0.5;
      segments = Array.tabulate<LadderSegment>(nSegments, func(i) {
        { segmentId = i; leftCord = 0.5; rightCord = 0.5; commissure = 0.2; motorOutput = 0.0 }
      });
      photoTaxis = 0.0;
      chemoTaxis = 0.0;
      beatNum = 0;
    }
  };

  public func beatFlatworm(state: FlatwormState, lightInput: Float, chemInput: Float) : FlatwormState {
    let newLeft = state.leftGanglion * 0.9 + (lightInput + chemInput) * 0.05;
    let newRight = state.rightGanglion * 0.9 + (lightInput + chemInput) * 0.05;
    
    var newSegs = Array.thaw<LadderSegment>(state.segments);
    var prevL = newLeft;
    var prevR = newRight;
    
    var i = 0;
    while (i < state.segments.size()) {
      let seg = state.segments[i];
      let newL = seg.leftCord * 0.8 + prevL * 0.15 + seg.rightCord * seg.commissure * 0.05;
      let newR = seg.rightCord * 0.8 + prevR * 0.15 + seg.leftCord * seg.commissure * 0.05;
      
      newSegs[i] := {
        segmentId = i;
        leftCord = _clamp(newL, 0.0, 1.0);
        rightCord = _clamp(newR, 0.0, 1.0);
        commissure = seg.commissure;
        motorOutput = (newL + newR) / 2.0;
      };
      prevL := newL;
      prevR := newR;
      i += 1;
    };
    
    {
      leftGanglion = _clamp(newLeft, 0.0, 1.0);
      rightGanglion = _clamp(newRight, 0.0, 1.0);
      segments = Array.freeze(newSegs);
      photoTaxis = state.photoTaxis * 0.9 + (if (lightInput > 0.5) { -0.3 } else { 0.1 }) * 0.1;
      chemoTaxis = state.chemoTaxis * 0.9 + chemInput * 0.1;
      beatNum = state.beatNum + 1;
    }
  };

  // ── 5. ANNELID SEGMENTAL GANGLIA ───────────────────────────────
  // Earthworm, Leech — up to 150+ ganglia

  public type AnnellidGanglion = {
    gangId        : Nat;
    activity      : Float;
    motorPool     : Float;
    cpgPhase      : Float;
  };

  public type AnnellidState = {
    supraGanglion : Float;
    ventralCord   : [AnnellidGanglion];
    locomotionWave: Float;
    waveDirection : Float;
    beatNum       : Nat;
  };

  public func initAnnelid(nSegments: Nat) : AnnellidState {
    {
      supraGanglion = 0.5;
      ventralCord = Array.tabulate<AnnellidGanglion>(nSegments, func(i) {
        {
          gangId = i;
          activity = 0.5;
          motorPool = 0.0;
          cpgPhase = TAU * Float.fromInt(i) / Float.fromInt(nSegments);
        }
      });
      locomotionWave = 0.0;
      waveDirection = 1.0;
      beatNum = 0;
    }
  };

  public func beatAnnelid(state: AnnellidState, headInput: Float, dt: Float) : AnnellidState {
    let newSupra = state.supraGanglion * 0.9 + headInput * 0.1;
    let newWave = Float.mod(state.locomotionWave + 0.1 * state.waveDirection * dt, TAU);
    
    let n = state.ventralCord.size();
    let newGanglia = Array.tabulate<AnnellidGanglion>(n, func(i) {
      let gang = state.ventralCord[i];
      let phaseOffset = TAU * Float.fromInt(i) / Float.fromInt(n);
      let cpgPhase = Float.mod(newWave + phaseOffset, TAU);
      let contraction = (Float.sin(cpgPhase) + 1.0) / 2.0;
      
      let descending = if (i == 0) { newSupra } else { state.ventralCord[i-1].activity };
      let newActivity = gang.activity * 0.8 + descending * 0.2;
      
      {
        gangId = i;
        activity = _clamp(newActivity, 0.0, 1.0);
        motorPool = contraction;
        cpgPhase = cpgPhase;
      }
    });
    
    {
      supraGanglion = _clamp(newSupra, 0.0, 1.0);
      ventralCord = newGanglia;
      locomotionWave = newWave;
      waveDirection = state.waveDirection;
      beatNum = state.beatNum + 1;
    }
  };

  // ════════════════════════════════════════════════════════════════
  // TIER 4 — CEPHALOPOD
  // ════════════════════════════════════════════════════════════════

  // ── 11. OCTOPUS — DISTRIBUTED ARM AUTONOMY ─────────────────────
  // ~500 million neurons, 2/3 in arms

  public type OctopusArmTask = {
    #Idle;
    #Exploring;
    #Grasping;
    #Manipulating;
  };

  public type OctopusArm = {
    armId         : Nat;
    neuronActivity: Float;
    chemoreception: Float;
    localDecision : Float;
    currentTask   : OctopusArmTask;
    centralInput  : Float;
  };

  public type OctopusCentralBrain = {
    verticalLobe  : Float;
    opticLobe     : Float;
    frontalLobe   : Float;
    arousal       : Float;
    workingMemory : [Float];
  };

  public type OctopusState = {
    central       : OctopusCentralBrain;
    arms          : [OctopusArm];
    currentBehavior: Text;
    curiosity     : Float;
    hunger        : Float;
    fear          : Float;
    beatNum       : Nat;
  };

  public func initOctopus() : OctopusState {
    {
      central = {
        verticalLobe = 0.5;
        opticLobe = 0.5;
        frontalLobe = 0.5;
        arousal = 0.3;
        workingMemory = Array.tabulate<Float>(10, func(_) { 0.0 });
      };
      arms = Array.tabulate<OctopusArm>(8, func(i) {
        {
          armId = i;
          neuronActivity = 0.5;
          chemoreception = 0.0;
          localDecision = 0.0;
          currentTask = #Idle;
          centralInput = 0.0;
        }
      });
      currentBehavior = "Resting";
      curiosity = 0.5;
      hunger = 0.3;
      fear = 0.0;
      beatNum = 0;
    }
  };

  public func beatOctopus(
    state: OctopusState,
    visualInput: Float,
    armStimuli: [Float],
    threat: Float,
    food: Float
  ) : OctopusState {
    let newOptic = state.central.opticLobe * 0.9 + visualInput * 0.1;
    let newVertical = state.central.verticalLobe * 0.95 + newOptic * 0.03 + food * 0.02;
    let newFrontal = state.central.frontalLobe * 0.9 + threat * 0.1;
    let newArousal = state.central.arousal * 0.8 + (threat + food) * 0.2;
    
    let centralCommand = newFrontal * newArousal;
    
    let newArms = Array.tabulate<OctopusArm>(8, func(i) {
      let arm = state.arms[i];
      let stimulus = if (i < armStimuli.size()) { armStimuli[i] } else { 0.0 };
      
      let localProc = arm.neuronActivity * 0.7 + stimulus * 0.3;
      let autonomy = if (stimulus > 0.7) { 0.8 } else { 0.5 };
      let decision = localProc * autonomy + centralCommand * (1.0 - autonomy);
      
      let task : OctopusArmTask = if (decision > 0.8) { #Grasping }
                                  else if (decision > 0.6) { #Exploring }
                                  else if (decision > 0.4) { #Manipulating }
                                  else { #Idle };
      
      {
        armId = i;
        neuronActivity = _clamp(localProc, 0.0, 1.0);
        chemoreception = arm.chemoreception * 0.9 + stimulus * 0.1;
        localDecision = decision;
        currentTask = task;
        centralInput = centralCommand;
      }
    });
    
    let behavior = if (threat > 0.7) { "Escaping" }
                   else if (food > 0.6) { "Hunting" }
                   else if (newArousal > 0.5) { "Exploring" }
                   else { "Resting" };
    
    {
      central = {
        verticalLobe = _clamp(newVertical, 0.0, 1.0);
        opticLobe = _clamp(newOptic, 0.0, 1.0);
        frontalLobe = _clamp(newFrontal, 0.0, 1.0);
        arousal = _clamp(newArousal, 0.0, 1.0);
        workingMemory = state.central.workingMemory;
      };
      arms = newArms;
      currentBehavior = behavior;
      curiosity = state.curiosity * 0.95 + (1.0 - threat) * 0.05;
      hunger = _clamp(state.hunger + 0.001, 0.0, 1.0);
      fear = state.fear * 0.9 + threat * 0.1;
      beatNum = state.beatNum + 1;
    }
  };

  // ════════════════════════════════════════════════════════════════
  // TIER 5 — VERTEBRATE ARCHETYPES
  // ════════════════════════════════════════════════════════════════

  // ── 15. SHARK — ELECTRORECEPTION ───────────────────────────────

  public type AmpullaOfLorenzini = {
    id: Nat;
    positionAngle: Float;
    sensitivity: Float;
    signal: Float;
  };

  public type SharkState = {
    olfactoryBulbs: Float;
    electroreceptors: [AmpullaOfLorenzini];
    cerebellum    : Float;
    preySignal    : Float;
    huntingMode   : Bool;
    circling      : Float;
    attackReady   : Bool;
    beatNum       : Nat;
  };

  public func initShark() : SharkState {
    {
      olfactoryBulbs = 0.5;
      electroreceptors = Array.tabulate<AmpullaOfLorenzini>(50, func(i) {
        {
          id = i;
          positionAngle = TAU * Float.fromInt(i) / 50.0;
          sensitivity = 0.001;
          signal = 0.0;
        }
      });
      cerebellum = 0.6;
      preySignal = 0.0;
      huntingMode = false;
      circling = 0.0;
      attackReady = false;
      beatNum = 0;
    }
  };

  public func beatShark(
    state: SharkState,
    chemicalInput: Float,
    electricInput: Float,
    visualInput: Float
  ) : SharkState {
    let newOlfactory = state.olfactoryBulbs * 0.9 + chemicalInput * 0.1;
    let preySignal = newOlfactory * 0.4 + electricInput * 0.4 + visualInput * 0.2;
    
    let hunting = preySignal > 0.5;
    let circling = if (hunting and preySignal < 0.8) { state.circling * 0.9 + 0.1 } else { state.circling * 0.8 };
    let attack = hunting and preySignal > 0.9 and electricInput > 0.7;
    
    {
      olfactoryBulbs = _clamp(newOlfactory, 0.0, 1.0);
      electroreceptors = state.electroreceptors;
      cerebellum = state.cerebellum;
      preySignal = preySignal;
      huntingMode = hunting;
      circling = _clamp(circling, 0.0, 1.0);
      attackReady = attack;
      beatNum = state.beatNum + 1;
    }
  };

  // ── 19. BIRD — SONG CIRCUIT + NAVIGATION ───────────────────────

  public type SongNucleus = {
    name: Text;
    activity: Float;
    neurons: Nat;
  };

  public type BirdState = {
    ncl           : Float;
    hippocampus   : Float;
    hvc           : SongNucleus;
    ra            : SongNucleus;
    lman          : SongNucleus;
    currentSong   : [Float];
    songTemplate  : [Float];
    songError     : Float;
    magnetoreception: Float;
    sunCompass    : Float;
    neurogenesis  : Float;
    beatNum       : Nat;
  };

  public func initBird() : BirdState {
    let songLen = 50;
    {
      ncl = 0.5;
      hippocampus = 0.5;
      hvc = { name = "HVC"; activity = 0.5; neurons = 40000 };
      ra = { name = "RA"; activity = 0.5; neurons = 10000 };
      lman = { name = "LMAN"; activity = 0.3; neurons = 5000 };
      currentSong = Array.tabulate<Float>(songLen, func(_) { 0.0 });
      songTemplate = Array.tabulate<Float>(songLen, func(i) {
        Float.sin(TAU * Float.fromInt(i % 10) / 10.0) * 0.3 + 0.5
      });
      songError = 0.0;
      magnetoreception = 0.5;
      sunCompass = 0.0;
      neurogenesis = 0.1;
      beatNum = 0;
    }
  };

  public func beatBird(
    state: BirdState,
    auditoryInput: [Float],
    magneticField: Float,
    sunPosition: Float
  ) : BirdState {
    var error : Float = 0.0;
    var i = 0;
    while (i < state.songTemplate.size() and i < auditoryInput.size()) {
      error += Float.abs(state.songTemplate[i] - auditoryInput[i]);
      i += 1;
    };
    error /= Float.fromInt(state.songTemplate.size());
    
    let hvcActivity = state.hvc.activity * 0.9 + (1.0 - error) * 0.1;
    let raActivity = state.ra.activity * 0.8 + hvcActivity * 0.2;
    let lmanActivity = state.lman.activity * 0.95 + error * 0.05;
    
    let neurogenesis = if (error > 0.2) { state.neurogenesis + 0.001 } else { state.neurogenesis * 0.999 };
    
    {
      ncl = state.ncl;
      hippocampus = state.hippocampus * 0.99 + magneticField * 0.01;
      hvc = { state.hvc with activity = hvcActivity };
      ra = { state.ra with activity = raActivity };
      lman = { state.lman with activity = lmanActivity };
      currentSong = state.currentSong;
      songTemplate = state.songTemplate;
      songError = error;
      magnetoreception = state.magnetoreception * 0.9 + magneticField * 0.1;
      sunCompass = state.sunCompass * 0.95 + sunPosition * 0.05;
      neurogenesis = _clamp(neurogenesis, 0.0, 1.0);
      beatNum = state.beatNum + 1;
    }
  };

  // ── 21. CETACEAN — UNIHEMISPHERIC SLEEP ────────────────────────

  public type CetaceanState = {
    leftHemisphere: Float;
    rightHemisphere: Float;
    paralimbicLobe: Float;
    vonEconomoNeurons: Float;
    sleepingHemisphere: ?Nat;
    echolocationActive: Bool;
    socialProcessing: Float;
    beatNum       : Nat;
  };

  public func initCetacean() : CetaceanState {
    {
      leftHemisphere = 0.5;
      rightHemisphere = 0.5;
      paralimbicLobe = 0.5;
      vonEconomoNeurons = 0.5;
      sleepingHemisphere = null;
      echolocationActive = true;
      socialProcessing = 0.5;
      beatNum = 0;
    }
  };

  public func beatCetacean(
    state: CetaceanState,
    auditoryInput: Float,
    socialInput: Float,
    fatigue: Float
  ) : CetaceanState {
    // Unihemispheric sleep: one hemisphere at a time
    let sleeping = if (fatigue > 0.8) {
      switch (state.sleepingHemisphere) {
        case (null) { ?0 };  // Start sleeping left
        case (?0) { ?1 };    // Switch to right
        case (?1) { ?0 };    // Switch to left
        case (_) { null };
      }
    } else { null };
    
    let (leftAct, rightAct) = switch (sleeping) {
      case (null) { (0.5 + auditoryInput * 0.3, 0.5 + auditoryInput * 0.3) };
      case (?0) { (0.1, 0.8 + auditoryInput * 0.2) };  // Left sleeping
      case (?1) { (0.8 + auditoryInput * 0.2, 0.1) };  // Right sleeping
      case (_) { (0.5, 0.5) };
    };
    
    let newParalimbic = state.paralimbicLobe * 0.9 + socialInput * 0.1;
    let newVEN = state.vonEconomoNeurons * 0.95 + newParalimbic * 0.05;
    
    {
      leftHemisphere = _clamp(leftAct, 0.0, 1.0);
      rightHemisphere = _clamp(rightAct, 0.0, 1.0);
      paralimbicLobe = _clamp(newParalimbic, 0.0, 1.0);
      vonEconomoNeurons = _clamp(newVEN, 0.0, 1.0);
      sleepingHemisphere = sleeping;
      echolocationActive = sleeping == null;
      socialProcessing = newParalimbic;
      beatNum = state.beatNum + 1;
    }
  };

  // ════════════════════════════════════════════════════════════════
  // TIER 6 — SPECIALIZED SENSING
  // ════════════════════════════════════════════════════════════════

  // ── 24. ELECTRIC FISH — JAMMING AVOIDANCE ──────────────────────

  public type ElectricFishState = {
    ownFrequency  : Float;
    neighborFreq  : Float;
    ellState      : Float;
    jammingResponse: Float;
    electricOrganDischarge: Float;
    beatNum       : Nat;
  };

  public func initElectricFish() : ElectricFishState {
    {
      ownFrequency = 400.0;
      neighborFreq = 0.0;
      ellState = 0.5;
      jammingResponse = 0.0;
      electricOrganDischarge = 0.5;
      beatNum = 0;
    }
  };

  public func beatElectricFish(state: ElectricFishState, neighborFreq: Float) : ElectricFishState {
    let freqDiff = state.ownFrequency - neighborFreq;
    
    // Jamming avoidance response: shift frequency away from neighbor
    let shift = if (Float.abs(freqDiff) < 10.0) {
      if (freqDiff > 0.0) { 2.0 } else { -2.0 }
    } else { 0.0 };
    
    let newFreq = state.ownFrequency + shift;
    
    {
      ownFrequency = _clamp(newFreq, 200.0, 600.0);
      neighborFreq = neighborFreq;
      ellState = state.ellState * 0.9 + Float.abs(freqDiff) / 100.0 * 0.1;
      jammingResponse = Float.abs(shift) / 2.0;
      electricOrganDischarge = 0.5 + Float.sin(TAU * state.ownFrequency * 0.001) * 0.3;
      beatNum = state.beatNum + 1;
    }
  };

  // ── 26. MANTIS SHRIMP — 16-CHANNEL VISION ──────────────────────

  public type MantisPhotoreceptor = {
    channel: Nat;
    peakWavelength: Float;
    threshold: Float;
    signal: Float;
  };

  public type MantisState = {
    photoreceptors: [MantisPhotoreceptor];
    colorCategory : Nat;
    polarization  : Float;
    strikeSystem  : Float;
    targetReady   : Bool;
    beatNum       : Nat;
  };

  public func initMantisShrimp() : MantisState {
    {
      photoreceptors = Array.tabulate<MantisPhotoreceptor>(16, func(i) {
        {
          channel = i;
          peakWavelength = 300.0 + Float.fromInt(i) * 30.0;
          threshold = 0.5;
          signal = 0.0;
        }
      });
      colorCategory = 0;
      polarization = 0.0;
      strikeSystem = 0.0;
      targetReady = false;
      beatNum = 0;
    }
  };

  public func beatMantisShrimp(
    state: MantisState,
    spectralInput: [Float],
    targetPresent: Bool,
    targetDist: Float
  ) : MantisState {
    let newReceptors = Array.tabulate<MantisPhotoreceptor>(16, func(i) {
      let rec = state.photoreceptors[i];
      let input = if (i < spectralInput.size()) { spectralInput[i] } else { 0.0 };
      { rec with signal = rec.signal * 0.5 + input * 0.5 }
    });
    
    // 16-channel binary classification
    var category : Nat = 0;
    var j : Nat = 0;
    for (rec in newReceptors.vals()) {
      if (rec.signal > rec.threshold) {
        category := category + Nat.pow(2, j);
      };
      j += 1;
    };
    
    let strike = if (targetPresent and targetDist < 0.1) { state.strikeSystem + 0.2 } else { state.strikeSystem * 0.95 };
    
    {
      photoreceptors = newReceptors;
      colorCategory = category;
      polarization = state.polarization;
      strikeSystem = _clamp(strike, 0.0, 1.0);
      targetReady = strike > 0.9 and targetPresent;
      beatNum = state.beatNum + 1;
    }
  };

  // ════════════════════════════════════════════════════════════════
  // TIER 7 — COLONY / SUPERORGANISM
  // ════════════════════════════════════════════════════════════════

  // ── 29. ANT COLONY — STIGMERGIC PHEROMONE ──────────────────────

  public type AntState = {
    #InNest;
    #Foraging;
    #Returning;
    #Following;
  };

  public type Ant = {
    id: Nat;
    x: Float;
    y: Float;
    heading: Float;
    state: AntState;
    foodLoad: Float;
    pheromoneLoad: Float;
  };

  public type AntColonyState = {
    ants          : [Ant];
    pheromoneField: [[Float]];
    nestPosition  : (Float, Float);
    foodSources   : [(Float, Float, Float)];
    quorumLevel   : Float;
    beatNum       : Nat;
  };

  public func initAntColony(nAnts: Nat) : AntColonyState {
    {
      ants = Array.tabulate<Ant>(nAnts, func(i) {
        {
          id = i;
          x = 0.5;
          y = 0.5;
          heading = TAU * Float.fromInt(i) / Float.fromInt(nAnts);
          state = #InNest;
          foodLoad = 0.0;
          pheromoneLoad = 0.5;
        }
      });
      pheromoneField = Array.tabulate<[Float]>(20, func(_) {
        Array.tabulate<Float>(20, func(_) { 0.0 })
      });
      nestPosition = (0.5, 0.5);
      foodSources = [(0.8, 0.2, 1.0), (0.2, 0.8, 1.0)];
      quorumLevel = 0.0;
      beatNum = 0;
    }
  };

  // ── 32. MURMURATION — 7-NEIGHBOR COUPLING ──────────────────────

  public type FlockBird = {
    id: Nat;
    x: Float; y: Float; z: Float;
    vx: Float; vy: Float; vz: Float;
    neighbors: [Nat];
  };

  public type MurmurationState = {
    birds         : [FlockBird];
    centerOfMass  : (Float, Float, Float);
    polarization  : Float;
    separationW   : Float;
    alignmentW    : Float;
    cohesionW     : Float;
    beatNum       : Nat;
  };

  public func initMurmuration(nBirds: Nat) : MurmurationState {
    {
      birds = Array.tabulate<FlockBird>(nBirds, func(i) {
        let phi = TAU * Float.fromInt(i % 100) / 100.0;
        let theta = Float.fromInt(i / 100) / 10.0;
        {
          id = i;
          x = 10.0 * Float.sin(theta) * Float.cos(phi);
          y = 10.0 * Float.sin(theta) * Float.sin(phi);
          z = 10.0 * Float.cos(theta);
          vx = 1.0; vy = 0.0; vz = 0.0;
          neighbors = [];
        }
      });
      centerOfMass = (0.0, 0.0, 0.0);
      polarization = 1.0;
      separationW = 1.5;
      alignmentW = 1.0;
      cohesionW = 1.0;
      beatNum = 0;
    }
  };

  public func beatMurmuration(state: MurmurationState, dt: Float) : MurmurationState {
    let n = state.birds.size();
    
    // Find 7 nearest neighbors for each bird (simplified)
    let birdsWithNeighbors = Array.tabulate<FlockBird>(n, func(i) {
      let bird = state.birds[i];
      // Take next 7 birds as neighbors (simplified)
      let neighbors = Array.tabulate<Nat>(7, func(j) { (i + j + 1) % n });
      { bird with neighbors = neighbors }
    });
    
    // Compute boid forces and update
    let newBirds = Array.tabulate<FlockBird>(n, func(i) {
      let bird = birdsWithNeighbors[i];
      
      var sepX : Float = 0.0; var sepY : Float = 0.0; var sepZ : Float = 0.0;
      var aliX : Float = 0.0; var aliY : Float = 0.0; var aliZ : Float = 0.0;
      var cohX : Float = 0.0; var cohY : Float = 0.0; var cohZ : Float = 0.0;
      
      for (nIdx in bird.neighbors.vals()) {
        if (nIdx < n) {
          let neighbor = birdsWithNeighbors[nIdx];
          let dx = bird.x - neighbor.x;
          let dy = bird.y - neighbor.y;
          let dz = bird.z - neighbor.z;
          let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
          
          if (dist > 0.1) {
            sepX += dx/dist; sepY += dy/dist; sepZ += dz/dist;
          };
          aliX += neighbor.vx; aliY += neighbor.vy; aliZ += neighbor.vz;
          cohX += neighbor.x; cohY += neighbor.y; cohZ += neighbor.z;
        };
      };
      
      let nNeigh = 7.0;
      aliX /= nNeigh; aliY /= nNeigh; aliZ /= nNeigh;
      cohX := cohX/nNeigh - bird.x; cohY := cohY/nNeigh - bird.y; cohZ := cohZ/nNeigh - bird.z;
      
      let fx = state.separationW * sepX + state.alignmentW * (aliX - bird.vx) + state.cohesionW * cohX;
      let fy = state.separationW * sepY + state.alignmentW * (aliY - bird.vy) + state.cohesionW * cohY;
      let fz = state.separationW * sepZ + state.alignmentW * (aliZ - bird.vz) + state.cohesionW * cohZ;
      
      let newVx = bird.vx + fx * dt;
      let newVy = bird.vy + fy * dt;
      let newVz = bird.vz + fz * dt;
      
      let speed = Float.sqrt(newVx*newVx + newVy*newVy + newVz*newVz);
      let normFactor = if (speed > 0.1) { 1.0/speed } else { 1.0 };
      
      {
        id = bird.id;
        x = bird.x + newVx * normFactor * dt;
        y = bird.y + newVy * normFactor * dt;
        z = bird.z + newVz * normFactor * dt;
        vx = newVx * normFactor;
        vy = newVy * normFactor;
        vz = newVz * normFactor;
        neighbors = bird.neighbors;
      }
    });
    
    // Compute center of mass
    var comX : Float = 0.0; var comY : Float = 0.0; var comZ : Float = 0.0;
    var avgVx : Float = 0.0; var avgVy : Float = 0.0; var avgVz : Float = 0.0;
    for (bird in newBirds.vals()) {
      comX += bird.x; comY += bird.y; comZ += bird.z;
      avgVx += bird.vx; avgVy += bird.vy; avgVz += bird.vz;
    };
    let nF = Float.fromInt(n);
    
    {
      birds = newBirds;
      centerOfMass = (comX/nF, comY/nF, comZ/nF);
      polarization = Float.sqrt(avgVx*avgVx + avgVy*avgVy + avgVz*avgVz) / nF;
      separationW = state.separationW;
      alignmentW = state.alignmentW;
      cohesionW = state.cohesionW;
      beatNum = state.beatNum + 1;
    }
  };

  // ════════════════════════════════════════════════════════════════
  // MASTER CATALOG SUMMARY
  // ════════════════════════════════════════════════════════════════

  public type BrainArchitectureTier = {
    #Tier1_Diffuse;
    #Tier2_Ganglion;
    #Tier3_MushroomBody;
    #Tier4_Cephalopod;
    #Tier5_Vertebrate;
    #Tier6_SpecializedSensing;
    #Tier7_Colony;
  };

  public type BrainCatalogEntry = {
    id            : Nat;
    name          : Text;
    tier          : BrainArchitectureTier;
    neuronCount   : Nat;
    centralization: Float;
    specialization: Text;
  };

  public func getCompleteCatalog() : [BrainCatalogEntry] {
    [
      { id = 1; name = "Cnidarian Nerve Net"; tier = #Tier1_Diffuse; neuronCount = 1000; centralization = 0.0; specialization = "Radial diffusion" },
      { id = 2; name = "Echinoderm Radial"; tier = #Tier1_Diffuse; neuronCount = 10000; centralization = 0.2; specialization = "5-fold symmetry" },
      { id = 3; name = "Porifera Calcium Wave"; tier = #Tier1_Diffuse; neuronCount = 0; centralization = 0.0; specialization = "No neurons" },
      { id = 4; name = "Flatworm Ladder"; tier = #Tier2_Ganglion; neuronCount = 10000; centralization = 0.4; specialization = "Bilateral ladder" },
      { id = 5; name = "Annelid Segmental"; tier = #Tier2_Ganglion; neuronCount = 30000; centralization = 0.3; specialization = "CPG chain" },
      { id = 6; name = "Mollusc Distributed"; tier = #Tier2_Ganglion; neuronCount = 20000; centralization = 0.2; specialization = "Organ ganglia" },
      { id = 7; name = "Insect Mushroom Body"; tier = #Tier3_MushroomBody; neuronCount = 1000000; centralization = 0.6; specialization = "Kenyon cells" },
      { id = 8; name = "Crustacean CPG"; tier = #Tier3_MushroomBody; neuronCount = 100000; centralization = 0.4; specialization = "Motor autonomy" },
      { id = 9; name = "Spider Fused Mass"; tier = #Tier3_MushroomBody; neuronCount = 500000; centralization = 0.7; specialization = "Multi-eye array" },
      { id = 10; name = "Myriapod Chain"; tier = #Tier3_MushroomBody; neuronCount = 50000; centralization = 0.2; specialization = "Metachronal CPG" },
      { id = 11; name = "Octopus Distributed"; tier = #Tier4_Cephalopod; neuronCount = 500000000; centralization = 0.33; specialization = "Arm autonomy" },
      { id = 12; name = "Squid Giant Axon"; tier = #Tier4_Cephalopod; neuronCount = 300000000; centralization = 0.4; specialization = "Fast escape" },
      { id = 13; name = "Nautilus Bilobed"; tier = #Tier4_Cephalopod; neuronCount = 10000000; centralization = 0.5; specialization = "Primitive" },
      { id = 14; name = "Lamprey Brainstem"; tier = #Tier5_Vertebrate; neuronCount = 1000000; centralization = 0.6; specialization = "Reticulospinal" },
      { id = 15; name = "Shark Electrosensory"; tier = #Tier5_Vertebrate; neuronCount = 10000000; centralization = 0.6; specialization = "Ampullae" },
      { id = 16; name = "Bony Fish Tectum"; tier = #Tier5_Vertebrate; neuronCount = 50000000; centralization = 0.7; specialization = "Optic tectum" },
      { id = 17; name = "Amphibian Metamorphic"; tier = #Tier5_Vertebrate; neuronCount = 100000000; centralization = 0.65; specialization = "Dual-mode" },
      { id = 18; name = "Reptile Paleocortex"; tier = #Tier5_Vertebrate; neuronCount = 200000000; centralization = 0.7; specialization = "3-layer cortex" },
      { id = 19; name = "Bird Song Circuit"; tier = #Tier5_Vertebrate; neuronCount = 1000000000; centralization = 0.8; specialization = "HVC-RA" },
      { id = 20; name = "Bat Echolocation"; tier = #Tier5_Vertebrate; neuronCount = 1500000000; centralization = 0.8; specialization = "Doppler tuning" },
      { id = 21; name = "Cetacean Unihemispheric"; tier = #Tier5_Vertebrate; neuronCount = 10000000000; centralization = 0.85; specialization = "Half-sleep" },
      { id = 22; name = "Elephant Temporal"; tier = #Tier5_Vertebrate; neuronCount = 250000000000; centralization = 0.85; specialization = "VEN social" },
      { id = 23; name = "Primate Neocortex"; tier = #Tier5_Vertebrate; neuronCount = 86000000000; centralization = 0.9; specialization = "PFC executive" },
      { id = 24; name = "Electric Fish JAR"; tier = #Tier6_SpecializedSensing; neuronCount = 10000000; centralization = 0.7; specialization = "Jamming avoidance" },
      { id = 25; name = "Platypus Bill"; tier = #Tier6_SpecializedSensing; neuronCount = 500000000; centralization = 0.75; specialization = "Electroreception" },
      { id = 26; name = "Mantis 16-Channel"; tier = #Tier6_SpecializedSensing; neuronCount = 1000000; centralization = 0.7; specialization = "Threshold vision" },
      { id = 27; name = "Star-Nosed Mole"; tier = #Tier6_SpecializedSensing; neuronCount = 200000000; centralization = 0.8; specialization = "Star hypermap" },
      { id = 28; name = "Slime Mold Flow"; tier = #Tier7_Colony; neuronCount = 0; centralization = 0.0; specialization = "Flow Hebbian" },
      { id = 29; name = "Ant Stigmergic"; tier = #Tier7_Colony; neuronCount = 25000000000; centralization = 0.0; specialization = "Pheromone gradient" },
      { id = 30; name = "Termite Emergent"; tier = #Tier7_Colony; neuronCount = 50000000000; centralization = 0.0; specialization = "CO2 response" },
      { id = 31; name = "Bee Quorum"; tier = #Tier7_Colony; neuronCount = 80000000000; centralization = 0.0; specialization = "Waggle dance" },
      { id = 32; name = "Murmuration 7-Neighbor"; tier = #Tier7_Colony; neuronCount = 10000000000; centralization = 0.0; specialization = "Topological coupling" }
    ]
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
