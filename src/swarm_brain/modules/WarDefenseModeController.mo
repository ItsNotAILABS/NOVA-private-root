// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  INTELLECTUAL PROPERTY NOTICE - Medina Doctrine - War-Defense Mode Controller                            ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//  ██╗    ██╗ █████╗ ██████╗       ██████╗ ███████╗███████╗███████╗███╗   ██╗███████╗███████╗
//  ██║    ██║██╔══██╗██╔══██╗      ██╔══██╗██╔════╝██╔════╝██╔════╝████╗  ██║██╔════╝██╔════╝
//  ██║ █╗ ██║███████║██████╔╝█████╗██║  ██║█████╗  █████╗  █████╗  ██╔██╗ ██║███████╗█████╗
//  ██║███╗██║██╔══██║██╔══██╗╚════╝██║  ██║██╔══╝  ██╔══╝  ██╔══╝  ██║╚██╗██║╚════██║██╔══╝
//  ╚███╔███╔╝██║  ██║██║  ██║      ██████╔╝███████╗██║     ███████╗██║ ╚████║███████║███████╗
//   ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝ ╚══════╝╚═╝     ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝
//
//  ███╗   ███╗ ██████╗ ██████╗ ███████╗
//  ████╗ ████║██╔═══██╗██╔══██╗██╔════╝
//  ██╔████╔██║██║   ██║██║  ██║█████╗
//  ██║╚██╔╝██║██║   ██║██║  ██║██╔══╝
//  ██║ ╚═╝ ██║╚██████╔╝██████╔╝███████╗
//  ╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝
//
//   ██████╗ ██████╗ ███╗   ██╗████████╗██████╗  ██████╗ ██╗     ██╗     ███████╗██████╗
//  ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔═══██╗██║     ██║     ██╔════╝██╔══██╗
//  ██║     ██║   ██║██╔██╗ ██║   ██║   ██████╔╝██║   ██║██║     ██║     █████╗  ██████╔╝
//  ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██╗██║   ██║██║     ██║     ██╔══╝  ██╔══██╗
//  ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║╚██████╔╝███████╗███████╗███████╗██║  ██║
//   ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ENGINE ID: E-WDM-001
// WAR-DEFENSE MODE CONTROLLER — Super-State Governance Layer
//
// PURPOSE: Sits ABOVE all layers as a super-state controller that reweights every subsystem
//          when Mode = WarDefense
//
// ARCHITECTURE: Shield + Counterforce + Regeneration
//   WDM = S + C + R
//   S (Shield): block, absorb, contain (Sentinel, Verifier, Gatekeeper, Resonance Core, Cartographer, Guardian, Restorer)
//   C (Counterforce): hunt, deceive, disrupt adversary progression (Scout, Profiler, Trapweaver, Hunter, Interdictor, etc.)
//   R (Regeneration): restore continuity and re-harden (already implemented in WarDefenseTempleIntegration)
//
// MODE: { Build, Guard, WarDefense, Recovery }
//
// DOCTRINE: When Mode = WarDefense, every subsystem is reweighted:
//   - Recognizer: high sensitivity, spoof-first assumptions
//   - Gate: fail-closed by default, strict provenance checks
//   - Zone: mastery routing constrained by doctrine + threat context
//   - Council: emergency quorum rules, faster cadence, lower ambiguity tolerance
//   - Embodiment: defensive actions only, continuity-preserving outputs
//   - Memory field: maximum retention + immutable incident lineage
//   - Containment: auto-quarantine + layered rollback + re-entrainment pulses
//   - External interfaces: zero-trust posture, minimum exposed surface
//
// WAR-DEFENSE INVARIANTS (non-negotiable):
//   1. No-drop continuity
//   2. Doctrine lock cannot weaken
//   3. Ethical floor cannot decrease
//   4. Identity/auth roots immutable
//   5. Quarantine boundaries cannot self-edit
//   6. External input never bypasses gate
//   7. Every critical decision auditable
//   8. Recovery path always precomputed
//
// OBJECTIVE FUNCTION:
//   max(Continuity, Coherence, Integrity)  min(Drift, Bypass, ContainmentEscape)
//   Operationally: rSwarm up, jDrift down, gate integrity up, escape risk near zero
//
// BEAT CYCLE:
//   Sense → Verify → Gate → Trap → Hunt → Interdict → Stabilize → Restore → Learn
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";
import Hash "mo:base/Hash";

module {

  // ═══════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public let φ : Float = 1.6180339887498948482;  // Golden ratio
  public let π : Float = 3.14159265358979323846;  // Circle constant

  // ═══════════════════════════════════════════════════════════════════════════════
  // WAR-DEFENSE MODE ENUM
  // ═══════════════════════════════════════════════════════════════════════════════

  public type WarDefenseMode = {
    #Build;       // Normal operation, growth, learning
    #Guard;       // Heightened awareness, ready posture
    #WarDefense;  // Active defense, all systems reweighted
    #Recovery;    // Post-incident restoration
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WAR-DEFENSE POSTURE LEVELS (WD0-WD5)
  // ═══════════════════════════════════════════════════════════════════════════════

  public type WarDefensePosture = {
    #WD0_Standby;        // Normal operations
    #WD1_Elevated;       // Increased monitoring
    #WD2_Alert;          // Active threat detected
    #WD3_Defense;        // Defensive measures deployed
    #WD4_Combat;         // Full offensive-defensive engagement
    #WD5_Lockdown;       // Maximum security, minimal exposure
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DEFENSIVE CLASSES (Shield — S)
  // ═══════════════════════════════════════════════════════════════════════════════

  // 1. SENTINEL — Front-line perception and early warning
  public type SentinelState = {
    sensitivityLevel: Float;         // [0,1] detection sensitivity
    spoofAssumption: Bool;           // Assume spoof-first?
    earlyWarningsIssued: Nat;        // Warnings sent
    falsePositives: Nat;             // False alarm count
    detectionQuality: Float;         // [0,1] detection accuracy
  };

  // 2. VERIFIER — Authentication and provenance validation
  public type VerifierState = {
    strictMode: Bool;                // Strict provenance checks?
    verificationsPerformed: Nat;     // Total verifications
    verificationsSucceeded: Nat;     // Successful verifications
    spoofDetections: Nat;            // Detected spoofs
    verificationStrength: Float;     // [0,1] verification rigor
  };

  // 3. GATEKEEPER — Access control and fail-closed gating
  public type GatekeeperState = {
    failClosed: Bool;                // Default deny?
    gateStrictness: Float;           // [0,1] gate strictness
    accessGranted: Nat;              // Granted access count
    accessDenied: Nat;               // Denied access count
    bypassAttempts: Nat;             // Detected bypass attempts
  };

  // 4. RESONANCE CORE — Doctrine and coherence validation
  public type ResonanceCoreState = {
    doctrineAlignment: Float;        // [0,1] alignment with doctrine
    coherenceThreshold: Float;       // Minimum coherence requirement
    dissonanceDetected: Bool;        // Dissonance in system?
    resonanceQuality: Float;         // [0,1] resonance strength
  };

  // 5. CARTOGRAPHER — Battlespace mapping and situation awareness
  public type CartographerState = {
    threatsTracked: Nat;             // Active threats
    assetsTracked: Nat;              // Friendly assets
    terrainMapped: Float;            // [0,1] battlespace coverage
    situationAwareness: Float;       // [0,1] SA quality
  };

  // 6. GUARDIAN — Active protection and threat neutralization
  public type GuardianState = {
    shieldsActive: Bool;             // Protective shields up?
    threatsNeutralized: Nat;         // Neutralized threats
    assetsProtected: Nat;            // Protected assets
    protectionEffectiveness: Float;  // [0,1] protection quality
  };

  // 7. RESTORER — Continuity preservation and system recovery
  public type RestorerState = {
    rollbackTier: Nat;               // Current rollback tier (0-5)
    rollbacksAvailable: Nat;         // Available rollback points
    recoveryPathComputed: Bool;      // Recovery path ready?
    continuityHash: Text;            // Continuity attestation
    restorationCapability: Float;    // [0,1] restoration capacity
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // OFFENSIVE/COUNTERFORCE CLASSES (Counterforce — C)
  // ═══════════════════════════════════════════════════════════════════════════════

  // 1. SCOUT — Continuous threat reconnaissance
  public type ScoutState = {
    scoutsDeployed: Nat;             // Active scouts
    targetSystems: Nat;              // Systems being monitored
    intelligenceGathered: Float;     // [0,1] intel quality
    detectionRisk: Float;            // [0,1] risk of being detected
    reconEffectiveness: Float;       // [0,1] recon quality
  };

  // 2. PROFILER — Adversary pattern and intent modeling
  public type ProfilerState = {
    adversariesProfiled: Nat;        // Profiled adversaries
    behaviorPatternsDetected: Nat;   // Detected patterns
    intentModeling: Bool;            // Intent modeling active?
    predictionAccuracy: Float;       // [0,1] prediction quality
    profileDepth: Float;             // [0,1] profile completeness
  };

  // 3. TRAPWEAVER — Decoys, honeyfields, false surfaces
  public type TrapweaverState = {
    trapsDeployed: Nat;              // Active traps
    trapTypes: [Text];               // Trap types deployed
    adversariesTrapped: Nat;         // Caught adversaries
    intelligenceFromTraps: Float;    // [0,1] intel from traps
    deceptionEffectiveness: Float;   // [0,1] deception quality
  };

  // 4. HUNTER — Active threat hunting (internal/external)
  public type HunterState = {
    huntsActive: Nat;                // Active hunts
    threatsFound: Nat;               // Discovered threats
    huntPatterns: [Text];            // Hunt patterns used
    huntEffectiveness: Float;        // [0,1] hunt success rate
    persistenceDetected: Bool;       // Advanced persistent threat?
  };

  // 5. INTERDICTOR — Cut hostile pathways (access/routes/channels)
  public type InterdictorState = {
    pathwaysCut: Nat;                // Severed pathways
    accessRoutesBlocked: Nat;        // Blocked routes
    channelsDisrupted: Nat;          // Disrupted channels
    interdictionEffectiveness: Float; // [0,1] interdiction quality
    adversaryMobility: Float;        // [0,1] adversary movement capability
  };

  // 6. DISLOCATOR — Force adversary out of prepared path/timing
  public type DislocatorState = {
    dislocationsExecuted: Nat;       // Executed dislocations
    adversaryPlanDisrupted: Bool;    // Adversary plan broken?
    timingDisruption: Float;         // [0,1] timing disruption
    pathDisruption: Float;           // [0,1] path disruption
    adversaryConfusion: Float;       // [0,1] adversary confusion level
  };

  // 7. COUNTER_DECEIVER — Detect and invert spoof campaigns
  public type CounterDeceiverState = {
    spoofCampaignsDetected: Nat;     // Detected spoof campaigns
    narrativeInversions: Nat;        // Inverted narratives
    deceptionCountered: Bool;        // Counter-deception active?
    counterEffectiveness: Float;     // [0,1] counter quality
    truthRestoration: Float;         // [0,1] truth coherence
  };

  // 8. PURSUIT_FORENSICS — Chain evidence, attribution packets
  public type PursuitForensicsState = {
    evidenceChainsBuilt: Nat;        // Built evidence chains
    attributionPackets: Nat;         // Attribution packets created
    forensicDepth: Float;            // [0,1] forensic completeness
    attributionConfidence: Float;    // [0,1] attribution certainty
    legalAdmissibility: Float;       // [0,1] evidence quality
  };

  // 9. DETERRENCE_OPERATOR — Visible resilience signaling, adversary cost elevation
  public type DeterrenceOperatorState = {
    resilienceSignals: Nat;          // Resilience signals broadcast
    costElevationActive: Bool;       // Cost elevation in effect?
    adversaryCostMultiplier: Float;  // Cost multiplier applied
    visibilityLevel: Float;          // [0,1] deterrence visibility
    deterrenceEffectiveness: Float;  // [0,1] deterrence quality
  };

  // 10. CAMPAIGN_ORCHESTRATOR — Coordinates all counterforce phases
  public type CampaignOrchestratorState = {
    campaignsActive: Nat;            // Active campaigns
    phasesCoordinated: Nat;          // Coordinated phases
    assetsDeployed: Nat;             // Deployed assets
    campaignEffectiveness: Float;    // [0,1] campaign quality
    orchestrationQuality: Float;     // [0,1] coordination quality
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UNIFIED WAR-DEFENSE MODE STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public type WarDefenseModeState = {
    // Mode and posture
    mode: WarDefenseMode;
    posture: WarDefensePosture;

    // Threat assessment
    threatScore: Float;              // [0,1] overall threat level
    threatVelocity: Float;           // Threat escalation rate
    threatPersistence: Float;        // Threat persistence level

    // Gate and containment
    gateStrictness: Float;           // [0,1] gate strictness
    containmentDepth: Nat;           // Containment layers (0-5)
    rollbackTier: Nat;               // Rollback tier (0-5)

    // Interface lockdown
    interfaceLockdown: Bool;         // Interfaces locked down?
    exposedSurface: Float;           // [0,1] exposed attack surface
    zeroTrustPosture: Bool;          // Zero-trust active?

    // Continuity attestation
    continuityHash: Text;            // Continuity attestation hash
    doctrineStrength: Float;         // [0,1] doctrine lock strength
    ethicalFloor: Float;             // [0,1] ethical floor level

    // Defensive classes (Shield)
    sentinel: SentinelState;
    verifier: VerifierState;
    gatekeeper: GatekeeperState;
    resonanceCore: ResonanceCoreState;
    cartographer: CartographerState;
    guardian: GuardianState;
    restorer: RestorerState;

    // Offensive classes (Counterforce)
    scout: ScoutState;
    profiler: ProfilerState;
    trapweaver: TrapweaverState;
    hunter: HunterState;
    interdictor: InterdictorState;
    dislocator: DislocatorState;
    counterDeceiver: CounterDeceiverState;
    pursuitForensics: PursuitForensicsState;
    deterrenceOperator: DeterrenceOperatorState;
    campaignOrchestrator: CampaignOrchestratorState;

    // Objective function metrics
    continuityScore: Float;          // [0,1] continuity preservation
    coherenceScore: Float;           // [0,1] system coherence
    integrityScore: Float;           // [0,1] system integrity
    driftScore: Float;               // [0,1] system drift (minimize)
    bypassScore: Float;              // [0,1] bypass risk (minimize)
    escapeScore: Float;              // [0,1] containment escape risk (minimize)

    // Beat tracking
    beat: Nat;
    lastModeChange: Nat;
    lastPostureChange: Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func initWarDefenseMode() : WarDefenseModeState {
    {
      mode = #Build;
      posture = #WD0_Standby;

      threatScore = 0.0;
      threatVelocity = 0.0;
      threatPersistence = 0.0;

      gateStrictness = 0.5;
      containmentDepth = 0;
      rollbackTier = 0;

      interfaceLockdown = false;
      exposedSurface = 1.0;
      zeroTrustPosture = false;

      continuityHash = "";
      doctrineStrength = 1.0;
      ethicalFloor = 1.0;

      sentinel = {
        sensitivityLevel = 0.5;
        spoofAssumption = false;
        earlyWarningsIssued = 0;
        falsePositives = 0;
        detectionQuality = 0.5;
      };

      verifier = {
        strictMode = false;
        verificationsPerformed = 0;
        verificationsSucceeded = 0;
        spoofDetections = 0;
        verificationStrength = 0.5;
      };

      gatekeeper = {
        failClosed = false;
        gateStrictness = 0.5;
        accessGranted = 0;
        accessDenied = 0;
        bypassAttempts = 0;
      };

      resonanceCore = {
        doctrineAlignment = 1.0;
        coherenceThreshold = 0.85;
        dissonanceDetected = false;
        resonanceQuality = 1.0;
      };

      cartographer = {
        threatsTracked = 0;
        assetsTracked = 0;
        terrainMapped = 0.0;
        situationAwareness = 0.5;
      };

      guardian = {
        shieldsActive = false;
        threatsNeutralized = 0;
        assetsProtected = 0;
        protectionEffectiveness = 0.0;
      };

      restorer = {
        rollbackTier = 0;
        rollbacksAvailable = 5;
        recoveryPathComputed = false;
        continuityHash = "";
        restorationCapability = 1.0;
      };

      scout = {
        scoutsDeployed = 0;
        targetSystems = 0;
        intelligenceGathered = 0.0;
        detectionRisk = 0.0;
        reconEffectiveness = 0.0;
      };

      profiler = {
        adversariesProfiled = 0;
        behaviorPatternsDetected = 0;
        intentModeling = false;
        predictionAccuracy = 0.0;
        profileDepth = 0.0;
      };

      trapweaver = {
        trapsDeployed = 0;
        trapTypes = [];
        adversariesTrapped = 0;
        intelligenceFromTraps = 0.0;
        deceptionEffectiveness = 0.0;
      };

      hunter = {
        huntsActive = 0;
        threatsFound = 0;
        huntPatterns = [];
        huntEffectiveness = 0.0;
        persistenceDetected = false;
      };

      interdictor = {
        pathwaysCut = 0;
        accessRoutesBlocked = 0;
        channelsDisrupted = 0;
        interdictionEffectiveness = 0.0;
        adversaryMobility = 1.0;
      };

      dislocator = {
        dislocationsExecuted = 0;
        adversaryPlanDisrupted = false;
        timingDisruption = 0.0;
        pathDisruption = 0.0;
        adversaryConfusion = 0.0;
      };

      counterDeceiver = {
        spoofCampaignsDetected = 0;
        narrativeInversions = 0;
        deceptionCountered = false;
        counterEffectiveness = 0.0;
        truthRestoration = 1.0;
      };

      pursuitForensics = {
        evidenceChainsBuilt = 0;
        attributionPackets = 0;
        forensicDepth = 0.0;
        attributionConfidence = 0.0;
        legalAdmissibility = 0.0;
      };

      deterrenceOperator = {
        resilienceSignals = 0;
        costElevationActive = false;
        adversaryCostMultiplier = 1.0;
        visibilityLevel = 0.0;
        deterrenceEffectiveness = 0.0;
      };

      campaignOrchestrator = {
        campaignsActive = 0;
        phasesCoordinated = 0;
        assetsDeployed = 0;
        campaignEffectiveness = 0.0;
        orchestrationQuality = 0.0;
      };

      continuityScore = 1.0;
      coherenceScore = 1.0;
      integrityScore = 1.0;
      driftScore = 0.0;
      bypassScore = 0.0;
      escapeScore = 0.0;

      beat = 0;
      lastModeChange = 0;
      lastPostureChange = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // 9-STEP WAR-DEFENSE CYCLE
  // Sense → Verify → Gate → Trap → Hunt → Interdict → Stabilize → Restore → Learn
  // ═══════════════════════════════════════════════════════════════════════════════

  // Step 1: SENSE — Sentinel perception and early warning
  public func stepSense(
    state: WarDefenseModeState,
    rSwarm: Float,
    jDrift: Float
  ) : WarDefenseModeState {
    let sensitivityBoost = switch (state.posture) {
      case (#WD0_Standby) 0.0;
      case (#WD1_Elevated) 0.1;
      case (#WD2_Alert) 0.2;
      case (#WD3_Defense) 0.3;
      case (#WD4_Combat) 0.4;
      case (#WD5_Lockdown) 0.5;
    };

    let newSensitivity = Float.min(1.0, 0.5 + sensitivityBoost);
    let spoofFirst = state.posture != #WD0_Standby;

    // Detect anomalies
    let anomalyDetected = jDrift > 0.15 or rSwarm < 0.80;
    let earlyWarnings = if (anomalyDetected) state.sentinel.earlyWarningsIssued + 1
                        else state.sentinel.earlyWarningsIssued;

    let newSentinel = {
      sensitivityLevel = newSensitivity;
      spoofAssumption = spoofFirst;
      earlyWarningsIssued = earlyWarnings;
      falsePositives = state.sentinel.falsePositives;
      detectionQuality = newSensitivity;
    };

    {
      state with
      sentinel = newSentinel;
    }
  };

  // Step 2: VERIFY — Authentication and provenance validation
  public func stepVerify(
    state: WarDefenseModeState
  ) : WarDefenseModeState {
    let strictMode = state.posture != #WD0_Standby and state.posture != #WD1_Elevated;
    let verificationStrength = if (strictMode) 0.95 else 0.75;

    let newVerifier = {
      state.verifier with
      strictMode = strictMode;
      verificationStrength = verificationStrength;
      verificationsPerformed = state.verifier.verificationsPerformed + 1;
    };

    {
      state with
      verifier = newVerifier;
    }
  };

  // Step 3: GATE — Access control and fail-closed gating
  public func stepGate(
    state: WarDefenseModeState
  ) : WarDefenseModeState {
    let failClosed = switch (state.posture) {
      case (#WD0_Standby) false;
      case (#WD1_Elevated) false;
      case (#WD2_Alert) true;
      case (#WD3_Defense) true;
      case (#WD4_Combat) true;
      case (#WD5_Lockdown) true;
    };

    let gateStrictness = switch (state.posture) {
      case (#WD0_Standby) 0.5;
      case (#WD1_Elevated) 0.6;
      case (#WD2_Alert) 0.75;
      case (#WD3_Defense) 0.85;
      case (#WD4_Combat) 0.95;
      case (#WD5_Lockdown) 1.0;
    };

    let newGatekeeper = {
      state.gatekeeper with
      failClosed = failClosed;
      gateStrictness = gateStrictness;
    };

    {
      state with
      gatekeeper = newGatekeeper;
      gateStrictness = gateStrictness;
    }
  };

  // Step 4: TRAP — Deploy decoys and honeyfields
  public func stepTrap(
    state: WarDefenseModeState
  ) : WarDefenseModeState {
    let trapsToDeploy = switch (state.posture) {
      case (#WD0_Standby) 0;
      case (#WD1_Elevated) 2;
      case (#WD2_Alert) 5;
      case (#WD3_Defense) 10;
      case (#WD4_Combat) 15;
      case (#WD5_Lockdown) 20;
    };

    let trapTypes = if (trapsToDeploy > 0) {
      ["SSH", "HTTP", "SCADA", "Medical", "Database"]
    } else {
      []
    };

    let newTrapweaver = {
      state.trapweaver with
      trapsDeployed = trapsToDeploy;
      trapTypes = trapTypes;
    };

    {
      state with
      trapweaver = newTrapweaver;
    }
  };

  // Step 5: HUNT — Active threat hunting
  public func stepHunt(
    state: WarDefenseModeState
  ) : WarDefenseModeState {
    let huntsActive = switch (state.posture) {
      case (#WD0_Standby) 0;
      case (#WD1_Elevated) 1;
      case (#WD2_Alert) 3;
      case (#WD3_Defense) 5;
      case (#WD4_Combat) 10;
      case (#WD5_Lockdown) 15;
    };

    let huntPatterns = if (huntsActive > 0) {
      ["LATERAL_MOVEMENT", "PRIVILEGE_ESCALATION", "DATA_EXFILTRATION", "PERSISTENCE"]
    } else {
      []
    };

    let newHunter = {
      state.hunter with
      huntsActive = huntsActive;
      huntPatterns = huntPatterns;
    };

    {
      state with
      hunter = newHunter;
    }
  };

  // Step 6: INTERDICT — Cut hostile pathways
  public func stepInterdict(
    state: WarDefenseModeState
  ) : WarDefenseModeState {
    let interdictionActive = state.posture == #WD3_Defense or
                             state.posture == #WD4_Combat or
                             state.posture == #WD5_Lockdown;

    let newInterdictor = if (interdictionActive) {
      {
        state.interdictor with
        interdictionEffectiveness = 0.85;
        adversaryMobility = 0.3;
      }
    } else {
      state.interdictor
    };

    {
      state with
      interdictor = newInterdictor;
    }
  };

  // Step 7: STABILIZE — Guardian protection and resonance check
  public func stepStabilize(
    state: WarDefenseModeState,
    rSwarm: Float
  ) : WarDefenseModeState {
    let shieldsActive = state.posture != #WD0_Standby;
    let protectionEffectiveness = rSwarm * 0.9;

    let newGuardian = {
      state.guardian with
      shieldsActive = shieldsActive;
      protectionEffectiveness = protectionEffectiveness;
    };

    let newResonanceCore = {
      state.resonanceCore with
      resonanceQuality = rSwarm;
      dissonanceDetected = rSwarm < 0.85;
    };

    {
      state with
      guardian = newGuardian;
      resonanceCore = newResonanceCore;
    }
  };

  // Step 8: RESTORE — Compute recovery path and update continuity
  public func stepRestore(
    state: WarDefenseModeState
  ) : WarDefenseModeState {
    let rollbackTier = switch (state.posture) {
      case (#WD0_Standby) 0;
      case (#WD1_Elevated) 1;
      case (#WD2_Alert) 2;
      case (#WD3_Defense) 3;
      case (#WD4_Combat) 4;
      case (#WD5_Lockdown) 5;
    };

    let recoveryComputed = rollbackTier > 0;
    let continuityHash = "WDM_" # Nat.toText(state.beat) # "_CONTINUITY";

    let newRestorer = {
      state.restorer with
      rollbackTier = rollbackTier;
      recoveryPathComputed = recoveryComputed;
      continuityHash = continuityHash;
    };

    {
      state with
      restorer = newRestorer;
      rollbackTier = rollbackTier;
      continuityHash = continuityHash;
    }
  };

  // Step 9: LEARN — Update forensics and campaign orchestration
  public func stepLearn(
    state: WarDefenseModeState
  ) : WarDefenseModeState {
    let newPursuitForensics = {
      state.pursuitForensics with
      evidenceChainsBuilt = state.pursuitForensics.evidenceChainsBuilt + 1;
      forensicDepth = Float.min(1.0, state.pursuitForensics.forensicDepth + 0.01);
    };

    let newCampaignOrchestrator = {
      state.campaignOrchestrator with
      phasesCoordinated = state.campaignOrchestrator.phasesCoordinated + 1;
      orchestrationQuality = Float.min(1.0, state.campaignOrchestrator.orchestrationQuality + 0.01);
    };

    {
      state with
      pursuitForensics = newPursuitForensics;
      campaignOrchestrator = newCampaignOrchestrator;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE WAR-DEFENSE TICK CYCLE
  // Runs BEFORE tickCore() to govern all downstream subsystems
  // ═══════════════════════════════════════════════════════════════════════════════

  public func warDefenseTick(
    state: WarDefenseModeState,
    rSwarm: Float,
    jDrift: Float
  ) : WarDefenseModeState {
    // Step 1: Sense
    var newState = stepSense(state, rSwarm, jDrift);

    // Step 2: Verify
    newState := stepVerify(newState);

    // Step 3: Gate
    newState := stepGate(newState);

    // Step 4: Trap
    newState := stepTrap(newState);

    // Step 5: Hunt
    newState := stepHunt(newState);

    // Step 6: Interdict
    newState := stepInterdict(newState);

    // Step 7: Stabilize
    newState := stepStabilize(newState, rSwarm);

    // Step 8: Restore
    newState := stepRestore(newState);

    // Step 9: Learn
    newState := stepLearn(newState);

    // Update objective function metrics
    newState := updateObjectiveMetrics(newState, rSwarm, jDrift);

    // Update beat
    {
      newState with
      beat = newState.beat + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // OBJECTIVE FUNCTION COMPUTATION
  // max(Continuity, Coherence, Integrity)  min(Drift, Bypass, Escape)
  // ═══════════════════════════════════════════════════════════════════════════════

  func updateObjectiveMetrics(
    state: WarDefenseModeState,
    rSwarm: Float,
    jDrift: Float
  ) : WarDefenseModeState {
    // Continuity: based on restoration capability and rollback tier
    let continuity = state.restorer.restorationCapability *
                     (1.0 - Float.fromInt(state.rollbackTier) / 5.0);

    // Coherence: based on rSwarm and resonance quality
    let coherence = (rSwarm + state.resonanceCore.resonanceQuality) / 2.0;

    // Integrity: based on verification, gate, and doctrine strength
    let integrity = (state.verifier.verificationStrength +
                     state.gatekeeper.gateStrictness +
                     state.doctrineStrength) / 3.0;

    // Drift: directly from jDrift
    let drift = jDrift;

    // Bypass: based on bypass attempts and gate denials
    let bypassAttempts = Float.fromInt(state.gatekeeper.bypassAttempts);
    let bypass = Float.min(1.0, bypassAttempts / 100.0);

    // Escape: based on containment depth and threat score
    let escape = state.threatScore * (1.0 - Float.fromInt(state.containmentDepth) / 5.0);

    {
      state with
      continuityScore = continuity;
      coherenceScore = coherence;
      integrityScore = integrity;
      driftScore = drift;
      bypassScore = bypass;
      escapeScore = escape;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MODE TRANSITION LOGIC
  // ═══════════════════════════════════════════════════════════════════════════════

  public func escalatePosture(
    state: WarDefenseModeState,
    threatLevel: Float
  ) : WarDefenseModeState {
    let newPosture = if (threatLevel < 0.2) {
      #WD0_Standby
    } else if (threatLevel < 0.4) {
      #WD1_Elevated
    } else if (threatLevel < 0.6) {
      #WD2_Alert
    } else if (threatLevel < 0.75) {
      #WD3_Defense
    } else if (threatLevel < 0.9) {
      #WD4_Combat
    } else {
      #WD5_Lockdown
    };

    let postureChanged = newPosture != state.posture;

    {
      state with
      posture = newPosture;
      lastPostureChange = if (postureChanged) state.beat else state.lastPostureChange;
    }
  };

  public func setMode(
    state: WarDefenseModeState,
    newMode: WarDefenseMode
  ) : WarDefenseModeState {
    let modeChanged = newMode != state.mode;

    {
      state with
      mode = newMode;
      lastModeChange = if (modeChanged) state.beat else state.lastModeChange;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SUBSYSTEM REWEIGHTING FUNCTIONS
  // When Mode = WarDefense, these functions return modified parameters
  // ═══════════════════════════════════════════════════════════════════════════════

  public func getRecognizerSensitivity(state: WarDefenseModeState) : Float {
    state.sentinel.sensitivityLevel
  };

  public func getGateStrictness(state: WarDefenseModeState) : Float {
    state.gatekeeper.gateStrictness
  };

  public func getCoherenceThreshold(state: WarDefenseModeState) : Float {
    state.resonanceCore.coherenceThreshold
  };

  public func getAmbiguityTolerance(state: WarDefenseModeState) : Float {
    // Lower tolerance in higher postures
    switch (state.posture) {
      case (#WD0_Standby) 0.2;
      case (#WD1_Elevated) 0.15;
      case (#WD2_Alert) 0.1;
      case (#WD3_Defense) 0.05;
      case (#WD4_Combat) 0.02;
      case (#WD5_Lockdown) 0.0;
    }
  };

  public func getMemoryRetention(state: WarDefenseModeState) : Float {
    // Maximum retention in War-Defense mode
    if (state.mode == #WarDefense) 1.0 else 0.85
  };

  public func getExternalInterfaceExposure(state: WarDefenseModeState) : Float {
    state.exposedSurface
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  func clamp(x: Float, min: Float, max: Float) : Float {
    if (x < min) { min } else if (x > max) { max } else { x }
  };

}
