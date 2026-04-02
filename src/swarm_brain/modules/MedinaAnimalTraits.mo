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


// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: MedinaAnimalTraits — 12 Species Cognitive Architecture
// Classification: CONFIDENTIAL — MAXIMUM PROTECTION
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited. All rights reserved.
//
// ============================================================================
//
// ANIMAL TRAIT ARCHITECTURE
// ============================================================================
//
// The organism is not a simulation of life. It is life — running the same
// mathematics that govern all complex adaptive systems: Kuramoto synchrony,
// Lyapunov stability, Lotka-Volterra tension, Friston free energy, Hebbian
// plasticity. Every organism from a single Sentinel to the macro sphere is
// the same architecture at a different scale.
//
// 12 SPECIES — Each provides a unique cognitive capability:
//
//   BEE/HIVE    — Mission lock. Q_hive. Swarm salience. Waggle encoding.
//   ORCA        — Pod memory sharing. Sonar precision. Family continuity.
//   OCTOPUS     — Distributed control. No central bottleneck. Parallel limb autonomy.
//   DOLPHIN     — Echolocation. Signal clarity through noise. Social coordination.
//   CROW        — Causal reasoning. CORV implements. Tool use = multi-step inference.
//   WOLF PACK   — Distributed coordination. No single leader. Pack convergence before action.
//   EAGLE       — Precision from altitude. Long-range world model. Stillness before strike.
//   ELEPHANT    — Long-term memory. Never forgets a formation event. Herd continuity.
//   SHARK       — Electroreception. Sensing fields, not just objects.
//   BIRD        — Migration pattern. Magnetic field navigation. Temporal orientation.
//   MAMMAL      — Baseline mammalian homeostasis. Temperature regulation analog.
//   PREDATOR    — Focus state. Stalking = patient coherence building before strike.
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";

module {

  // ==========================================================================
  // CONSTANTS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let PI : Float = 3.14159265358979;
  let TWO_PI : Float = 6.28318530717958;

  // ==========================================================================
  // 1. BEE/HIVE — Mission Lock & Swarm Salience
  // ==========================================================================
  
  public type BeeHiveState = {
    // Q_hive: collective decision value
    qHive                   : Float;
    
    // Mission lock
    missionLocked           : Bool;
    missionTarget           : ?Text;
    missionStartBeat        : Nat;
    missionProgress         : Float;
    
    // Swarm salience
    salienceMap             : [Float];      // Per-goal salience
    topSalienceIdx          : Nat;
    salienceConvergence     : Float;
    
    // Waggle dance encoding (communication signal)
    waggleAngle             : Float;        // Direction encoded
    waggleIntensity         : Float;        // Distance/importance encoded
    waggleDuration          : Nat;          // Signal duration
    
    // Collective state
    workerActivation        : Float;
    queenSignal             : Float;
    hiveCoherence           : Float;
    
    beatNum                 : Nat;
  };

  public func computeQHive(
    workerActivations: [Float],
    queenSignal: Float,
    hiveCoherence: Float
  ) : Float {
    var sum : Float = 0.0;
    for (w in workerActivations.vals()) {
      sum += w;
    };
    let avgWorker = if (workerActivations.size() > 0) {
      sum / Float.fromInt(workerActivations.size())
    } else { 0.0 };
    
    // Q_hive = average worker × queen signal × coherence
    avgWorker * queenSignal * hiveCoherence
  };

  public func tickBeeHive(
    state: BeeHiveState,
    workerActivations: [Float],
    queenSignal: Float,
    goalSaliences: [Float]
  ) : BeeHiveState {
    let newQHive = computeQHive(workerActivations, queenSignal, state.hiveCoherence);
    
    // Find top salience
    var topIdx : Nat = 0;
    var topVal : Float = 0.0;
    for (i in Array.keys(goalSaliences)) {
      if (goalSaliences[i] > topVal) {
        topVal := goalSaliences[i];
        topIdx := i;
      };
    };
    
    // Compute salience convergence (how much agreement on goal)
    var varianceSum : Float = 0.0;
    let mean = topVal;
    for (s in goalSaliences.vals()) {
      varianceSum += (s - mean) * (s - mean);
    };
    let variance = if (goalSaliences.size() > 0) {
      varianceSum / Float.fromInt(goalSaliences.size())
    } else { 0.0 };
    let convergence = 1.0 - Float.sqrt(variance);
    
    // Mission lock when convergence is high
    let shouldLock = convergence > 0.8 and newQHive > 0.6;
    
    // Update waggle encoding
    let newWaggleAngle = Float.fromInt(topIdx) * TWO_PI / Float.fromInt(goalSaliences.size() + 1);
    let newWaggleIntensity = topVal;
    
    // Compute hive coherence
    var avgWorker : Float = 0.0;
    for (w in workerActivations.vals()) {
      avgWorker += w;
    };
    avgWorker := if (workerActivations.size() > 0) {
      avgWorker / Float.fromInt(workerActivations.size())
    } else { 0.0 };
    let newHiveCoherence = avgWorker * convergence;
    
    {
      qHive = newQHive;
      missionLocked = shouldLock or state.missionLocked;
      missionTarget = if (shouldLock and state.missionTarget == null) {
        ?("goal_" # Nat.toText(topIdx))
      } else { state.missionTarget };
      missionStartBeat = if (shouldLock and not state.missionLocked) { state.beatNum } else { state.missionStartBeat };
      missionProgress = if (state.missionLocked) { clamp(state.missionProgress + 0.01, 0.0, 1.0) } else { 0.0 };
      salienceMap = goalSaliences;
      topSalienceIdx = topIdx;
      salienceConvergence = convergence;
      waggleAngle = newWaggleAngle;
      waggleIntensity = newWaggleIntensity;
      waggleDuration = if (topVal > 0.5) { state.waggleDuration + 1 } else { 0 };
      workerActivation = avgWorker;
      queenSignal = queenSignal;
      hiveCoherence = newHiveCoherence;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // 2. ORCA — Pod Memory & Sonar Precision
  // ==========================================================================
  
  public type OrcaState = {
    // Pod memory (shared across pod members)
    podMemory               : [MemoryEntry];
    podMemoryCapacity       : Nat;
    
    // Sonar precision (signal detection)
    sonarPrecision          : Float;
    sonarRange              : Float;
    echoStrength            : Float;
    
    // Family continuity
    podSize                 : Nat;
    matriarchSignal         : Float;       // Elder guidance
    podCohesion             : Float;
    
    // Communication
    callPattern             : [Float];      // Unique pod identifier
    responseLatency         : Float;
    
    // Hunting coordination
    huntingFormation        : HuntingFormation;
    preyTracking            : Float;
    
    beatNum                 : Nat;
  };

  public type MemoryEntry = {
    entryId     : Nat;
    content     : Text;
    importance  : Float;
    timestamp   : Nat;
    sharedBy    : Nat;          // Which pod member shared
  };

  public type HuntingFormation = {
    #Carousel;      // Circling prey
    #Wave;          // Creating waves to wash prey
    #Herding;       // Driving prey to surface
    #Ambush;        // Wait and strike
    #Dispersed;     // Searching
  };

  public func tickOrca(
    state: OrcaState,
    newSignal: Float,
    matriarchGuidance: Float,
    preyDistance: Float
  ) : OrcaState {
    // Update sonar
    let echoReturn = if (preyDistance > 0.0) {
      newSignal / (preyDistance * preyDistance + 1.0)
    } else { 0.0 };
    let newPrecision = clamp(state.sonarPrecision + echoReturn * 0.01 - 0.005, 0.0, 1.0);
    
    // Pod cohesion follows matriarch
    let newCohesion = clamp(
      state.podCohesion * 0.95 + matriarchGuidance * 0.05,
      0.0, 1.0
    );
    
    // Hunting formation selection based on prey tracking
    let newFormation = if (state.preyTracking > 0.8) { #Carousel }
                       else if (state.preyTracking > 0.6) { #Wave }
                       else if (state.preyTracking > 0.4) { #Herding }
                       else if (state.preyTracking > 0.2) { #Ambush }
                       else { #Dispersed };
    
    // Prey tracking update
    let newTracking = clamp(
      state.preyTracking + echoReturn * 0.1 - 0.02,
      0.0, 1.0
    );
    
    {
      podMemory = state.podMemory;
      podMemoryCapacity = state.podMemoryCapacity;
      sonarPrecision = newPrecision;
      sonarRange = state.sonarRange;
      echoStrength = echoReturn;
      podSize = state.podSize;
      matriarchSignal = matriarchGuidance;
      podCohesion = newCohesion;
      callPattern = state.callPattern;
      responseLatency = state.responseLatency;
      huntingFormation = newFormation;
      preyTracking = newTracking;
      beatNum = state.beatNum + 1;
    }
  };

  // Share memory across pod
  public func shareOrcaMemory(
    state: OrcaState,
    entry: MemoryEntry
  ) : OrcaState {
    if (state.podMemory.size() >= state.podMemoryCapacity) {
      // Remove oldest low-importance entry
      var newMemory : [MemoryEntry] = [];
      var skipped = false;
      for (e in state.podMemory.vals()) {
        if (not skipped and e.importance < 0.3) {
          skipped := true;
        } else {
          newMemory := Array.append(newMemory, [e]);
        };
      };
      newMemory := Array.append(newMemory, [entry]);
      { state with podMemory = newMemory }
    } else {
      { state with podMemory = Array.append(state.podMemory, [entry]) }
    }
  };

  // ==========================================================================
  // 3. OCTOPUS — Distributed Control
  // ==========================================================================
  
  public type OctopusState = {
    // 8 semi-autonomous arms
    armStates               : [ArmState];
    
    // Central brain (minimal)
    centralCoordination     : Float;
    centralOverrideActive   : Bool;
    
    // Distributed processing
    parallelProcessingCount : Nat;
    conflictResolutionMode  : ConflictMode;
    
    // Camouflage (environmental adaptation)
    camouflageActive        : Bool;
    patternComplexity       : Float;
    colorAdaptation         : Float;
    
    // Ink cloud (defensive)
    inkReserve              : Float;
    inkDeployed             : Bool;
    
    beatNum                 : Nat;
  };

  public type ArmState = {
    armId           : Nat;
    activation      : Float;
    localGoal       : ?Text;
    sensorInput     : Float;
    motorOutput     : Float;
    autonomyLevel   : Float;     // How independent from central
  };

  public type ConflictMode = {
    #MajorityVote;
    #HighestActivation;
    #CentralOverride;
    #Negotiation;
  };

  public func tickOctopus(state: OctopusState, sensorInputs: [Float]) : OctopusState {
    // Update each arm independently
    var newArms : [ArmState] = [];
    var conflictDetected = false;
    var activeCount : Nat = 0;
    
    for (i in Array.keys(state.armStates)) {
      let arm = state.armStates[i];
      let input = if (i < sensorInputs.size()) { sensorInputs[i] } else { 0.0 };
      
      // Arm processes independently
      let newActivation = clamp(arm.activation * 0.9 + input * 0.1, 0.0, 1.0);
      let newMotor = newActivation * arm.autonomyLevel;
      
      if (newActivation > 0.5) { activeCount += 1 };
      
      let updatedArm = {
        arm with
        activation = newActivation;
        sensorInput = input;
        motorOutput = newMotor;
      };
      newArms := Array.append(newArms, [updatedArm]);
    };
    
    // Conflict detection: multiple arms with high activation but different goals
    conflictDetected := activeCount > 3;
    
    // Central coordination only when needed
    let newCentralCoord = if (conflictDetected) {
      clamp(state.centralCoordination + 0.1, 0.0, 1.0)
    } else {
      clamp(state.centralCoordination - 0.05, 0.0, 1.0)
    };
    
    // Camouflage updates with environment
    var avgInput : Float = 0.0;
    for (s in sensorInputs.vals()) { avgInput += s };
    avgInput := if (sensorInputs.size() > 0) { avgInput / Float.fromInt(sensorInputs.size()) } else { 0.0 };
    let newPattern = clamp(state.patternComplexity + avgInput * 0.01, 0.0, 1.0);
    
    {
      armStates = newArms;
      centralCoordination = newCentralCoord;
      centralOverrideActive = conflictDetected and newCentralCoord > 0.7;
      parallelProcessingCount = activeCount;
      conflictResolutionMode = if (conflictDetected) { #HighestActivation } else { #MajorityVote };
      camouflageActive = state.camouflageActive;
      patternComplexity = newPattern;
      colorAdaptation = avgInput;
      inkReserve = clamp(state.inkReserve + 0.001, 0.0, 1.0);
      inkDeployed = false;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // 4. DOLPHIN — Echolocation & Social Coordination
  // ==========================================================================
  
  public type DolphinState = {
    // Echolocation system
    echoFrequency           : Float;
    echoAmplitude           : Float;
    returnSignal            : Float;
    signalToNoiseRatio      : Float;
    
    // Social coordination
    podPosition             : Nat;          // Position in social hierarchy
    socialBonds             : [Float];      // Bond strength with each pod member
    synchronizedSwimming    : Bool;
    
    // Play behavior (learning through play)
    playfulness             : Float;
    playPartner             : ?Nat;
    skillsFromPlay          : Float;
    
    // Communication
    whistleSignature        : [Float];      // Individual identifier
    clickTrainRate          : Float;
    
    // Bubble creation (tool use)
    bubbleRingActive        : Bool;
    
    beatNum                 : Nat;
  };

  public func tickDolphin(
    state: DolphinState,
    environmentNoise: Float,
    podSignals: [Float]
  ) : DolphinState {
    // Echolocation update
    let returnStrength = state.echoAmplitude / (environmentNoise + 0.1);
    let newSNR = clamp(returnStrength, 0.0, 10.0);
    
    // Social bond updates
    var newBonds : [Float] = [];
    for (i in Array.keys(state.socialBonds)) {
      let bond = state.socialBonds[i];
      let signal = if (i < podSignals.size()) { podSignals[i] } else { 0.0 };
      // Bonds strengthen with positive interaction
      let newBond = clamp(bond * 0.99 + signal * 0.01, 0.0, 1.0);
      newBonds := Array.append(newBonds, [newBond]);
    };
    
    // Synchronized swimming when bonds are strong
    var avgBond : Float = 0.0;
    for (b in newBonds.vals()) { avgBond += b };
    avgBond := if (newBonds.size() > 0) { avgBond / Float.fromInt(newBonds.size()) } else { 0.0 };
    let synchronized = avgBond > 0.7;
    
    // Playfulness inversely related to stress (using SNR as proxy)
    let newPlayfulness = clamp(state.playfulness + newSNR * 0.01 - 0.005, 0.0, 1.0);
    
    // Skills accumulate from play
    let skillGain = if (state.playfulness > 0.5) { 0.001 } else { 0.0 };
    let newSkills = clamp(state.skillsFromPlay + skillGain, 0.0, 1.0);
    
    {
      echoFrequency = state.echoFrequency;
      echoAmplitude = state.echoAmplitude;
      returnSignal = returnStrength;
      signalToNoiseRatio = newSNR;
      podPosition = state.podPosition;
      socialBonds = newBonds;
      synchronizedSwimming = synchronized;
      playfulness = newPlayfulness;
      playPartner = state.playPartner;
      skillsFromPlay = newSkills;
      whistleSignature = state.whistleSignature;
      clickTrainRate = state.clickTrainRate;
      bubbleRingActive = newPlayfulness > 0.8;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // 5. CROW — Causal Reasoning & Tool Use
  // ==========================================================================
  
  public type CrowState = {
    // Causal reasoning
    causalModel             : [CausalLink];
    causalInferenceScore    : Float;
    
    // Tool use
    currentTool             : ?ToolType;
    toolProficiency         : Float;
    toolCreationAbility     : Float;
    
    // Multi-step planning
    planSteps               : [PlanStep];
    currentStepIdx          : Nat;
    planSuccess             : Float;
    
    // Memory for faces/threats
    faceMemory              : [FaceMemoryEntry];
    threatAssessment        : Float;
    
    // Social learning
    observationalLearning   : Float;
    socialRank              : Nat;
    
    beatNum                 : Nat;
  };

  public type CausalLink = {
    cause   : Text;
    effect  : Text;
    strength: Float;
    observed: Nat;
  };

  public type ToolType = {
    #Stick;
    #Hook;
    #Leaf;
    #Stone;
    #CustomMade;
  };

  public type PlanStep = {
    stepId      : Nat;
    action      : Text;
    prerequisite: ?Nat;
    completed   : Bool;
  };

  public type FaceMemoryEntry = {
    faceId      : Nat;
    threat      : Bool;
    lastSeen    : Nat;
    interactions: Nat;
  };

  public func tickCrow(
    state: CrowState,
    environmentInput: Float,
    toolNeeded: Bool,
    observedAction: ?Text
  ) : CrowState {
    // Update causal inference score based on successful predictions
    let newCausalScore = clamp(
      state.causalInferenceScore + environmentInput * 0.01 - 0.005,
      0.0, 1.0
    );
    
    // Tool selection if needed
    let newTool = if (toolNeeded and state.toolProficiency > 0.3) {
      ?#Stick
    } else {
      state.currentTool
    };
    
    // Tool proficiency grows with use
    let newProficiency = if (toolNeeded) {
      clamp(state.toolProficiency + 0.01, 0.0, 1.0)
    } else {
      state.toolProficiency
    };
    
    // Plan progress
    var newStepIdx = state.currentStepIdx;
    var newPlanSuccess = state.planSuccess;
    if (state.planSteps.size() > 0 and newStepIdx < state.planSteps.size()) {
      // Check if current step completed
      if (environmentInput > 0.7) {
        newStepIdx += 1;
        newPlanSuccess := clamp(newPlanSuccess + 0.1, 0.0, 1.0);
      };
    };
    
    // Observational learning
    let newObsLearning = switch (observedAction) {
      case (?_) { clamp(state.observationalLearning + 0.02, 0.0, 1.0) };
      case null { state.observationalLearning };
    };
    
    // Threat assessment decays without new threats
    let newThreat = clamp(state.threatAssessment * 0.99, 0.0, 1.0);
    
    {
      causalModel = state.causalModel;
      causalInferenceScore = newCausalScore;
      currentTool = newTool;
      toolProficiency = newProficiency;
      toolCreationAbility = clamp(newProficiency * newCausalScore, 0.0, 1.0);
      planSteps = state.planSteps;
      currentStepIdx = newStepIdx;
      planSuccess = newPlanSuccess;
      faceMemory = state.faceMemory;
      threatAssessment = newThreat;
      observationalLearning = newObsLearning;
      socialRank = state.socialRank;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // 6. WOLF PACK — Distributed Coordination
  // ==========================================================================
  
  public type WolfPackState = {
    // Pack structure
    packSize                : Nat;
    alphaSignal             : Float;
    betaSignals             : [Float];
    
    // Convergence before action
    packConvergence         : Float;
    consensusReached        : Bool;
    consensusThreshold      : Float;
    
    // Hunting coordination
    chaseFormation          : ChaseFormation;
    preyFocus               : Float;
    
    // Communication
    howlIntensity           : Float;
    howlFrequency           : Float;
    packIdentitySignal      : [Float];
    
    // Territory
    territoryPatrol         : Float;
    borderMarking           : Float;
    
    beatNum                 : Nat;
  };

  public type ChaseFormation = {
    #Flanking;
    #Pursuit;
    #Ambush;
    #Relay;
    #Dispersed;
  };

  public func tickWolfPack(
    state: WolfPackState,
    memberSignals: [Float],
    preyDetected: Bool
  ) : WolfPackState {
    // Compute pack convergence (how aligned are members)
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    for (s in memberSignals.vals()) {
      sum += s;
      sumSq += s * s;
    };
    let n = Float.fromInt(memberSignals.size() + 1);
    let mean = sum / n;
    let variance = (sumSq / n) - (mean * mean);
    let convergence = 1.0 - Float.sqrt(Float.abs(variance));
    
    // Consensus reached when convergence exceeds threshold
    let consensus = convergence > state.consensusThreshold;
    
    // Alpha signal is highest member signal
    var maxSignal : Float = 0.0;
    for (s in memberSignals.vals()) {
      if (s > maxSignal) { maxSignal := s };
    };
    
    // Formation selection
    let formation = if (not preyDetected) { #Dispersed }
                    else if (convergence > 0.8) { #Flanking }
                    else if (convergence > 0.6) { #Pursuit }
                    else if (convergence > 0.4) { #Relay }
                    else { #Ambush };
    
    // Prey focus increases with detection
    let newFocus = if (preyDetected) {
      clamp(state.preyFocus + 0.05, 0.0, 1.0)
    } else {
      clamp(state.preyFocus - 0.02, 0.0, 1.0)
    };
    
    // Howl intensity for communication
    let newHowl = if (preyDetected and consensus) {
      1.0
    } else if (convergence < 0.5) {
      0.7  // Call to regroup
    } else {
      clamp(state.howlIntensity - 0.1, 0.0, 1.0)
    };
    
    {
      packSize = state.packSize;
      alphaSignal = maxSignal;
      betaSignals = memberSignals;
      packConvergence = convergence;
      consensusReached = consensus;
      consensusThreshold = state.consensusThreshold;
      chaseFormation = formation;
      preyFocus = newFocus;
      howlIntensity = newHowl;
      howlFrequency = state.howlFrequency;
      packIdentitySignal = state.packIdentitySignal;
      territoryPatrol = state.territoryPatrol;
      borderMarking = state.borderMarking;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // 7. EAGLE — Precision & Altitude
  // ==========================================================================
  
  public type EagleState = {
    // Visual system
    visualAcuity            : Float;        // 8× human
    altitudeLevel           : Float;        // Higher = wider view
    fovealFocus             : (Float, Float); // Target coordinates
    
    // World model
    worldModelRange         : Float;
    detectedTargets         : [TargetEntry];
    
    // Stillness before strike
    stillnessLevel          : Float;
    strikeReadiness         : Float;
    
    // Thermals (energy efficiency)
    thermalRiding           : Bool;
    energyConservation      : Float;
    
    // Strike execution
    divingSpeed             : Float;
    strikeAccuracy          : Float;
    
    beatNum                 : Nat;
  };

  public type TargetEntry = {
    targetId    : Nat;
    position    : (Float, Float);
    velocity    : (Float, Float);
    threat      : Float;
    value       : Float;
  };

  public func tickEagle(
    state: EagleState,
    altitude: Float,
    targets: [TargetEntry]
  ) : EagleState {
    // Visual acuity improves with altitude (up to point)
    let optimalAltitude = 0.7;
    let altitudeFactor = 1.0 - Float.abs(altitude - optimalAltitude);
    let newAcuity = clamp(state.visualAcuity * 0.9 + altitudeFactor * 0.1, 0.0, 1.0);
    
    // World model range increases with altitude
    let newRange = altitude * 10.0;
    
    // Stillness builds when observing (not moving)
    let newStillness = if (state.thermalRiding) {
      clamp(state.stillnessLevel + 0.02, 0.0, 1.0)
    } else {
      clamp(state.stillnessLevel - 0.05, 0.0, 1.0)
    };
    
    // Strike readiness requires stillness + target
    let hasTarget = targets.size() > 0;
    let newReadiness = if (hasTarget and newStillness > 0.8) {
      clamp(state.strikeReadiness + 0.1, 0.0, 1.0)
    } else {
      clamp(state.strikeReadiness - 0.02, 0.0, 1.0)
    };
    
    // Energy conservation while riding thermals
    let newConservation = if (state.thermalRiding) {
      clamp(state.energyConservation + 0.01, 0.0, 1.0)
    } else {
      clamp(state.energyConservation - 0.02, 0.0, 1.0)
    };
    
    // Strike accuracy depends on stillness and acuity
    let newAccuracy = newStillness * newAcuity;
    
    {
      visualAcuity = newAcuity;
      altitudeLevel = altitude;
      fovealFocus = state.fovealFocus;
      worldModelRange = newRange;
      detectedTargets = targets;
      stillnessLevel = newStillness;
      strikeReadiness = newReadiness;
      thermalRiding = altitude > 0.5;  // Thermals at higher altitude
      energyConservation = newConservation;
      divingSpeed = state.divingSpeed;
      strikeAccuracy = newAccuracy;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // 8. ELEPHANT — Long-term Memory & Herd Continuity
  // ==========================================================================
  
  public type ElephantState = {
    // Long-term memory (never forgets)
    longTermMemory          : [LTMemoryEntry];
    memoryCapacity          : Nat;
    oldestMemoryAge         : Nat;
    
    // Herd structure
    herdSize                : Nat;
    matriarchWisdom         : Float;
    herdCohesion            : Float;
    
    // Emotional memory
    emotionalMemory         : [EmotionalMemoryEntry];
    griefLevel              : Float;
    joyLevel                : Float;
    
    // Path memory (migration routes)
    pathMemory              : [(Float, Float)];
    currentWaypoint         : Nat;
    
    // Communication (infrasound)
    infrasoundSignal        : Float;
    infrasoundRange         : Float;
    
    beatNum                 : Nat;
  };

  public type LTMemoryEntry = {
    memoryId        : Nat;
    content         : Text;
    emotionalWeight : Float;
    formationBeat   : Nat;
    lastAccessed    : Nat;
    accessCount     : Nat;
  };

  public type EmotionalMemoryEntry = {
    eventId     : Nat;
    emotion     : EmotionType;
    intensity   : Float;
    timestamp   : Nat;
    trigger     : Text;
  };

  public type EmotionType = {
    #Joy;
    #Grief;
    #Fear;
    #Anger;
    #Curiosity;
  };

  public func tickElephant(
    state: ElephantState,
    herdSignals: [Float],
    newEvent: ?EmotionalMemoryEntry
  ) : ElephantState {
    // Herd cohesion from signals
    var avgSignal : Float = 0.0;
    for (s in herdSignals.vals()) { avgSignal += s };
    avgSignal := if (herdSignals.size() > 0) { avgSignal / Float.fromInt(herdSignals.size()) } else { 0.0 };
    let newCohesion = clamp(state.herdCohesion * 0.95 + avgSignal * 0.05, 0.0, 1.0);
    
    // Matriarch wisdom grows with memory size
    let newWisdom = clamp(
      Float.fromInt(state.longTermMemory.size()) / Float.fromInt(state.memoryCapacity),
      0.0, 1.0
    );
    
    // Process emotional event
    var newGrief = state.griefLevel * 0.99;  // Slow decay
    var newJoy = state.joyLevel * 0.95;
    var newEmotionalMemory = state.emotionalMemory;
    
    switch (newEvent) {
      case (?event) {
        newEmotionalMemory := Array.append(newEmotionalMemory, [event]);
        switch (event.emotion) {
          case (#Grief) { newGrief := clamp(newGrief + event.intensity * 0.3, 0.0, 1.0) };
          case (#Joy) { newJoy := clamp(newJoy + event.intensity * 0.2, 0.0, 1.0) };
          case _ {};
        };
      };
      case null {};
    };
    
    // Infrasound signal for herd communication
    let newInfrasound = if (state.griefLevel > 0.5) {
      0.8  // Grief call
    } else if (newCohesion < 0.4) {
      0.6  // Rally call
    } else {
      0.3  // Normal communication
    };
    
    {
      longTermMemory = state.longTermMemory;
      memoryCapacity = state.memoryCapacity;
      oldestMemoryAge = state.oldestMemoryAge + 1;
      herdSize = state.herdSize;
      matriarchWisdom = newWisdom;
      herdCohesion = newCohesion;
      emotionalMemory = newEmotionalMemory;
      griefLevel = newGrief;
      joyLevel = newJoy;
      pathMemory = state.pathMemory;
      currentWaypoint = state.currentWaypoint;
      infrasoundSignal = newInfrasound;
      infrasoundRange = state.infrasoundRange;
      beatNum = state.beatNum + 1;
    }
  };

  // Never forgets - memory persists forever
  public func elephantRemember(
    state: ElephantState,
    entry: LTMemoryEntry
  ) : ElephantState {
    // Elephant NEVER forgets - just add to memory
    { state with longTermMemory = Array.append(state.longTermMemory, [entry]) }
  };

  // ==========================================================================
  // 9. SHARK — Electroreception & Field Sensing
  // ==========================================================================
  
  public type SharkState = {
    // Electroreception (ampullae of Lorenzini)
    electricFieldSensitivity: Float;
    detectedFields          : [ElectricField];
    
    // Lateral line (water movement)
    lateralLineActivation   : Float;
    waterFlowDetection      : Float;
    
    // Hunting state
    huntingDrive            : Float;
    feedingFrenzy           : Bool;
    
    // Movement
    cruisingSpeed           : Float;
    burstCapacity           : Float;
    
    // Sensing
    smellTrail              : Float;
    soundDetection          : Float;
    
    beatNum                 : Nat;
  };

  public type ElectricField = {
    fieldId     : Nat;
    strength    : Float;
    direction   : Float;
    source      : Text;
  };

  public func tickShark(
    state: SharkState,
    electricFields: [ElectricField],
    waterMovement: Float,
    smellIntensity: Float
  ) : SharkState {
    // Process electric fields
    var maxField : Float = 0.0;
    for (f in electricFields.vals()) {
      if (f.strength > maxField) { maxField := f.strength };
    };
    let newSensitivity = clamp(state.electricFieldSensitivity + maxField * 0.01, 0.0, 1.0);
    
    // Lateral line responds to water movement
    let newLateralLine = clamp(waterMovement, 0.0, 1.0);
    
    // Hunting drive increases with sensory input
    let sensorySum = maxField + waterMovement + smellIntensity;
    let newHuntingDrive = clamp(state.huntingDrive + sensorySum * 0.02 - 0.01, 0.0, 1.0);
    
    // Feeding frenzy when multiple strong signals
    let frenzy = newHuntingDrive > 0.9 and electricFields.size() > 3;
    
    // Burst capacity recovers when not in frenzy
    let newBurst = if (frenzy) {
      clamp(state.burstCapacity - 0.05, 0.0, 1.0)
    } else {
      clamp(state.burstCapacity + 0.01, 0.0, 1.0)
    };
    
    {
      electricFieldSensitivity = newSensitivity;
      detectedFields = electricFields;
      lateralLineActivation = newLateralLine;
      waterFlowDetection = waterMovement;
      huntingDrive = newHuntingDrive;
      feedingFrenzy = frenzy;
      cruisingSpeed = state.cruisingSpeed;
      burstCapacity = newBurst;
      smellTrail = smellIntensity;
      soundDetection = state.soundDetection;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // 10. BIRD — Migration & Magnetic Navigation
  // ==========================================================================
  
  public type BirdState = {
    // Magnetic sense
    magneticFieldX          : Float;
    magneticFieldY          : Float;
    magneticFieldZ          : Float;
    compassHeading          : Float;
    
    // Migration
    migrationActive         : Bool;
    migrationPhase          : MigrationPhase;
    migrationProgress       : Float;
    homeCoordinates         : (Float, Float);
    
    // Temporal awareness
    seasonalAwareness       : Float;
    dayLengthSensing        : Float;
    
    // Flock dynamics
    flockPosition           : Nat;
    formationRole           : FormationRole;
    flockCoherence          : Float;
    
    // Navigation memory
    landmarkMemory          : [(Float, Float)];
    sunCompassCalibration   : Float;
    
    beatNum                 : Nat;
  };

  public type MigrationPhase = {
    #Preparation;
    #Departure;
    #Transit;
    #Stopover;
    #Arrival;
    #Breeding;
    #NonMigratory;
  };

  public type FormationRole = {
    #Leader;
    #Follower;
    #Rotating;
    #Scout;
  };

  public func tickBird(
    state: BirdState,
    magneticField: (Float, Float, Float),
    dayLength: Float,
    flockSignals: [Float]
  ) : BirdState {
    // Update magnetic sensing
    let (mx, my, mz) = magneticField;
    let newHeading = Float.atan2(my, mx);
    
    // Seasonal awareness from day length
    let newSeasonal = clamp(dayLength / 24.0, 0.0, 1.0);
    
    // Migration triggered by seasonal cues
    let shouldMigrate = (newSeasonal > 0.6 and state.migrationPhase == #NonMigratory) or
                        (newSeasonal < 0.4 and state.migrationPhase == #Breeding);
    
    let newPhase = if (shouldMigrate and not state.migrationActive) {
      #Preparation
    } else if (state.migrationActive and state.migrationProgress > 0.95) {
      #Arrival
    } else {
      state.migrationPhase
    };
    
    // Flock coherence
    var avgFlockSignal : Float = 0.0;
    for (s in flockSignals.vals()) { avgFlockSignal += s };
    avgFlockSignal := if (flockSignals.size() > 0) { avgFlockSignal / Float.fromInt(flockSignals.size()) } else { 0.0 };
    let newCoherence = clamp(state.flockCoherence * 0.9 + avgFlockSignal * 0.1, 0.0, 1.0);
    
    // Migration progress
    let newProgress = if (state.migrationActive) {
      clamp(state.migrationProgress + 0.001 * newCoherence, 0.0, 1.0)
    } else { 0.0 };
    
    {
      magneticFieldX = mx;
      magneticFieldY = my;
      magneticFieldZ = mz;
      compassHeading = newHeading;
      migrationActive = state.migrationActive or shouldMigrate;
      migrationPhase = newPhase;
      migrationProgress = newProgress;
      homeCoordinates = state.homeCoordinates;
      seasonalAwareness = newSeasonal;
      dayLengthSensing = dayLength;
      flockPosition = state.flockPosition;
      formationRole = state.formationRole;
      flockCoherence = newCoherence;
      landmarkMemory = state.landmarkMemory;
      sunCompassCalibration = state.sunCompassCalibration;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // 11. MAMMAL — Baseline Homeostasis
  // ==========================================================================
  
  public type MammalState = {
    // Temperature regulation
    coreTemperature         : Float;
    targetTemperature       : Float;
    thermoregulationActive  : Bool;
    
    // Metabolic state
    metabolicRate           : Float;
    energyReserves          : Float;
    
    // Sleep-wake cycle
    sleepDrive              : Float;
    wakefulness             : Float;
    circadianPhase          : Float;
    
    // Stress response
    cortisolLevel           : Float;
    adrenalineLevel         : Float;
    
    // Social bonding
    oxytocinLevel           : Float;
    attachmentBonds         : [Float];
    
    beatNum                 : Nat;
  };

  public func tickMammal(
    state: MammalState,
    environmentTemp: Float,
    stressInput: Float,
    socialInput: Float
  ) : MammalState {
    // Temperature regulation
    let tempDiff = state.targetTemperature - environmentTemp;
    let newMetabolic = if (tempDiff > 0.1) {
      clamp(state.metabolicRate + 0.02, 0.0, 1.0)  // Heat production
    } else if (tempDiff < -0.1) {
      clamp(state.metabolicRate - 0.01, 0.0, 1.0)  // Reduce heat
    } else {
      state.metabolicRate
    };
    
    let newCoreTemp = clamp(
      state.coreTemperature + (state.targetTemperature - state.coreTemperature) * 0.1,
      0.0, 1.0
    );
    
    // Energy reserves depleted by metabolic rate
    let newEnergy = clamp(state.energyReserves - newMetabolic * 0.01 + 0.005, 0.0, 1.0);
    
    // Sleep drive accumulates with wakefulness
    let newSleepDrive = clamp(state.sleepDrive + state.wakefulness * 0.001, 0.0, 1.0);
    
    // Circadian phase advances
    let newCircadian = (state.circadianPhase + 0.01);
    let wrappedCircadian = if (newCircadian > 1.0) { newCircadian - 1.0 } else { newCircadian };
    
    // Stress hormones
    let newCortisol = clamp(state.cortisolLevel + stressInput * 0.1 - 0.02, 0.0, 1.0);
    let newAdrenaline = clamp(state.adrenalineLevel + stressInput * 0.2 - 0.05, 0.0, 1.0);
    
    // Oxytocin from social bonding
    let newOxytocin = clamp(state.oxytocinLevel + socialInput * 0.1 - 0.01, 0.0, 1.0);
    
    {
      coreTemperature = newCoreTemp;
      targetTemperature = state.targetTemperature;
      thermoregulationActive = Float.abs(tempDiff) > 0.05;
      metabolicRate = newMetabolic;
      energyReserves = newEnergy;
      sleepDrive = newSleepDrive;
      wakefulness = 1.0 - newSleepDrive;
      circadianPhase = wrappedCircadian;
      cortisolLevel = newCortisol;
      adrenalineLevel = newAdrenaline;
      oxytocinLevel = newOxytocin;
      attachmentBonds = state.attachmentBonds;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // 12. PREDATOR — Focus State & Patient Stalking
  // ==========================================================================
  
  public type PredatorState = {
    // Focus state
    focusLevel              : Float;
    focusTarget             : ?TargetEntry;
    focusDuration           : Nat;
    
    // Stalking behavior
    stalkingActive          : Bool;
    stalkingDistance        : Float;
    stalkingPatience        : Float;
    
    // Coherence building
    coherenceAccumulation   : Float;
    strikeCoherence         : Float;
    
    // Energy management
    restState               : Bool;
    burstEnergy             : Float;
    sustainedEnergy         : Float;
    
    // Strike decision
    strikeConfidence        : Float;
    strikeWindow            : Bool;
    
    beatNum                 : Nat;
  };

  public func tickPredator(
    state: PredatorState,
    targetVisible: Bool,
    targetDistance: Float,
    targetVulnerability: Float
  ) : PredatorState {
    // Focus increases with target visibility
    let newFocus = if (targetVisible) {
      clamp(state.focusLevel + 0.02, 0.0, 1.0)
    } else {
      clamp(state.focusLevel - 0.05, 0.0, 1.0)
    };
    
    // Stalking requires sustained focus
    let shouldStalk = newFocus > 0.6 and targetDistance > 0.3;
    
    // Patience builds during stalking
    let newPatience = if (shouldStalk) {
      clamp(state.stalkingPatience + 0.01, 0.0, 1.0)
    } else {
      clamp(state.stalkingPatience - 0.02, 0.0, 1.0)
    };
    
    // Coherence accumulation (patient stalking builds strike power)
    let newCoherenceAcc = if (shouldStalk and newPatience > 0.5) {
      clamp(state.coherenceAccumulation + 0.02, 0.0, 1.0)
    } else {
      state.coherenceAccumulation * 0.95
    };
    
    // Strike coherence = accumulated coherence × focus
    let newStrikeCoherence = newCoherenceAcc * newFocus;
    
    // Strike window opens when conditions are right
    let strikeWindow = targetDistance < 0.5 and 
                       targetVulnerability > 0.6 and 
                       newStrikeCoherence > 0.7 and
                       state.burstEnergy > 0.5;
    
    // Strike confidence
    let newConfidence = newStrikeCoherence * targetVulnerability;
    
    // Energy management
    let newBurst = if (state.restState) {
      clamp(state.burstEnergy + 0.02, 0.0, 1.0)
    } else if (state.stalkingActive) {
      clamp(state.burstEnergy - 0.005, 0.0, 1.0)
    } else {
      state.burstEnergy
    };
    
    {
      focusLevel = newFocus;
      focusTarget = state.focusTarget;
      focusDuration = if (targetVisible) { state.focusDuration + 1 } else { 0 };
      stalkingActive = shouldStalk;
      stalkingDistance = targetDistance;
      stalkingPatience = newPatience;
      coherenceAccumulation = newCoherenceAcc;
      strikeCoherence = newStrikeCoherence;
      restState = not targetVisible and newFocus < 0.3;
      burstEnergy = newBurst;
      sustainedEnergy = state.sustainedEnergy;
      strikeConfidence = newConfidence;
      strikeWindow = strikeWindow;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // COMPOSITE ANIMAL TRAITS STATE
  // ==========================================================================
  
  public type AnimalTraitsState = {
    bee         : BeeHiveState;
    orca        : OrcaState;
    octopus     : OctopusState;
    dolphin     : DolphinState;
    crow        : CrowState;
    wolfPack    : WolfPackState;
    eagle       : EagleState;
    elephant    : ElephantState;
    shark       : SharkState;
    bird        : BirdState;
    mammal      : MammalState;
    predator    : PredatorState;
    
    // Dominant trait currently active
    dominantTrait: DominantTrait;
    traitBlend  : [Float];          // Blend weights for each trait
    
    beatNum     : Nat;
  };

  public type DominantTrait = {
    #Bee;
    #Orca;
    #Octopus;
    #Dolphin;
    #Crow;
    #WolfPack;
    #Eagle;
    #Elephant;
    #Shark;
    #Bird;
    #Mammal;
    #Predator;
  };

  // ==========================================================================
  // UTILITY
  // ==========================================================================
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initAnimalTraits() : AnimalTraitsState {
    {
      bee = {
        qHive = 0.5; missionLocked = false; missionTarget = null;
        missionStartBeat = 0; missionProgress = 0.0;
        salienceMap = []; topSalienceIdx = 0; salienceConvergence = 0.0;
        waggleAngle = 0.0; waggleIntensity = 0.0; waggleDuration = 0;
        workerActivation = 0.5; queenSignal = 0.5; hiveCoherence = 0.5;
        beatNum = 0;
      };
      orca = {
        podMemory = []; podMemoryCapacity = 100;
        sonarPrecision = 0.5; sonarRange = 100.0; echoStrength = 0.0;
        podSize = 5; matriarchSignal = 0.5; podCohesion = 0.7;
        callPattern = []; responseLatency = 0.1;
        huntingFormation = #Dispersed; preyTracking = 0.0;
        beatNum = 0;
      };
      octopus = {
        armStates = Array.tabulate<ArmState>(8, func(i) {
          { armId = i; activation = 0.5; localGoal = null;
            sensorInput = 0.0; motorOutput = 0.0; autonomyLevel = 0.7 }
        });
        centralCoordination = 0.3; centralOverrideActive = false;
        parallelProcessingCount = 0; conflictResolutionMode = #MajorityVote;
        camouflageActive = false; patternComplexity = 0.0; colorAdaptation = 0.0;
        inkReserve = 1.0; inkDeployed = false;
        beatNum = 0;
      };
      dolphin = {
        echoFrequency = 100.0; echoAmplitude = 0.5; returnSignal = 0.0;
        signalToNoiseRatio = 1.0;
        podPosition = 0; socialBonds = []; synchronizedSwimming = false;
        playfulness = 0.5; playPartner = null; skillsFromPlay = 0.0;
        whistleSignature = []; clickTrainRate = 10.0;
        bubbleRingActive = false;
        beatNum = 0;
      };
      crow = {
        causalModel = []; causalInferenceScore = 0.5;
        currentTool = null; toolProficiency = 0.3; toolCreationAbility = 0.0;
        planSteps = []; currentStepIdx = 0; planSuccess = 0.0;
        faceMemory = []; threatAssessment = 0.0;
        observationalLearning = 0.3; socialRank = 0;
        beatNum = 0;
      };
      wolfPack = {
        packSize = 6; alphaSignal = 0.7; betaSignals = [];
        packConvergence = 0.5; consensusReached = false; consensusThreshold = 0.7;
        chaseFormation = #Dispersed; preyFocus = 0.0;
        howlIntensity = 0.0; howlFrequency = 1.0; packIdentitySignal = [];
        territoryPatrol = 0.5; borderMarking = 0.3;
        beatNum = 0;
      };
      eagle = {
        visualAcuity = 0.9; altitudeLevel = 0.5; fovealFocus = (0.0, 0.0);
        worldModelRange = 5.0; detectedTargets = [];
        stillnessLevel = 0.5; strikeReadiness = 0.0;
        thermalRiding = false; energyConservation = 0.5;
        divingSpeed = 0.0; strikeAccuracy = 0.5;
        beatNum = 0;
      };
      elephant = {
        longTermMemory = []; memoryCapacity = 10000; oldestMemoryAge = 0;
        herdSize = 10; matriarchWisdom = 0.5; herdCohesion = 0.7;
        emotionalMemory = []; griefLevel = 0.0; joyLevel = 0.3;
        pathMemory = []; currentWaypoint = 0;
        infrasoundSignal = 0.3; infrasoundRange = 10.0;
        beatNum = 0;
      };
      shark = {
        electricFieldSensitivity = 0.8; detectedFields = [];
        lateralLineActivation = 0.5; waterFlowDetection = 0.0;
        huntingDrive = 0.3; feedingFrenzy = false;
        cruisingSpeed = 0.3; burstCapacity = 1.0;
        smellTrail = 0.0; soundDetection = 0.5;
        beatNum = 0;
      };
      bird = {
        magneticFieldX = 0.0; magneticFieldY = 0.0; magneticFieldZ = 0.0;
        compassHeading = 0.0;
        migrationActive = false; migrationPhase = #NonMigratory; migrationProgress = 0.0;
        homeCoordinates = (0.0, 0.0);
        seasonalAwareness = 0.5; dayLengthSensing = 12.0;
        flockPosition = 0; formationRole = #Follower; flockCoherence = 0.5;
        landmarkMemory = []; sunCompassCalibration = 0.5;
        beatNum = 0;
      };
      mammal = {
        coreTemperature = 0.5; targetTemperature = 0.5; thermoregulationActive = false;
        metabolicRate = 0.5; energyReserves = 0.7;
        sleepDrive = 0.3; wakefulness = 0.7; circadianPhase = 0.0;
        cortisolLevel = 0.2; adrenalineLevel = 0.1;
        oxytocinLevel = 0.3; attachmentBonds = [];
        beatNum = 0;
      };
      predator = {
        focusLevel = 0.5; focusTarget = null; focusDuration = 0;
        stalkingActive = false; stalkingDistance = 0.0; stalkingPatience = 0.5;
        coherenceAccumulation = 0.0; strikeCoherence = 0.0;
        restState = false; burstEnergy = 1.0; sustainedEnergy = 0.7;
        strikeConfidence = 0.0; strikeWindow = false;
        beatNum = 0;
      };
      dominantTrait = #Mammal;
      traitBlend = [0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.08, 0.12];
      beatNum = 0;
    }
  };

}
