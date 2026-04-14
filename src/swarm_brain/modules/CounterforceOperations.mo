// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  INTELLECTUAL PROPERTY NOTICE - Medina Doctrine - Counterforce Operations                                ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//   ██████╗ ██████╗ ██╗   ██╗███╗   ██╗████████╗███████╗██████╗ ███████╗ ██████╗ ██████╗  ██████╗███████╗
//  ██╔════╝██╔═══██╗██║   ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔════╝
//  ██║     ██║   ██║██║   ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝█████╗  ██║   ██║██████╔╝██║     █████╗
//  ██║     ██║   ██║██║   ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██╔══╝  ██║   ██║██╔══██╗██║     ██╔══╝
//  ╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║   ██║   ███████╗██║  ██║██║     ╚██████╔╝██║  ██║╚██████╗███████╗
//   ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝
//
//   ██████╗ ██████╗ ███████╗██████╗  █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
//  ██╔═══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
//  ██║   ██║██████╔╝█████╗  ██████╔╝███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
//  ██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
//  ╚██████╔╝██║     ███████╗██║  ██║██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
//   ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ENGINE ID: E-CFO-001
// COUNTERFORCE OPERATIONS — 10 Specialized Warfare Classes
//
// PURPOSE: Advanced offensive/defensive operators for continuous threat hunting,
//          adversary disruption, deception operations, and campaign orchestration
//
// CLASSES:
//   1. Scout           — Continuous threat reconnaissance
//   2. Profiler        — Adversary pattern/intent modeling
//   3. Trapweaver      — Decoys, honeyfields, false surfaces
//   4. Hunter          — Active threat hunting across internal/external signals
//   5. Interdictor     — Cut hostile pathways (access/routes/channels)
//   6. Dislocator      — Force adversary out of prepared path/timing
//   7. Counter-Deceiver— Detect and invert spoof campaigns
//   8. Pursuit Forensics— Chain evidence, attribution packets
//   9. Deterrence Operator— Visible resilience signaling, adversary cost elevation
//  10. Campaign Orchestrator— Coordinates all counterforce phases
//
// DOCTRINE: "Hunt, disrupt, attribute, deter — never let the adversary settle"
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";

module {

  // ═══════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public let φ : Float = 1.6180339887498948482;
  public let π : Float = 3.14159265358979323846;
  public let SCHUMANN_HZ : Float = 7.83;

  // ═══════════════════════════════════════════════════════════════════════════════
  // CLASS 1: SCOUT — Continuous Threat Reconnaissance
  // Purpose: Persistent monitoring, early warning, reconnaissance
  // ═══════════════════════════════════════════════════════════════════════════════

  public type ScoutState = {
    scoutsDeployed: Nat;               // Active scouts in field
    coverageArea: Float;               // [0,1] area coverage
    threatsDetected: Nat;              // Total threats found
    earlyWarnings: Nat;                // Early warning signals
    reconQuality: Float;               // [0,1] reconnaissance quality
    stealthLevel: Float;               // [0,1] scout stealth
    lastScanBeat: Nat;                 // Last scan beat
    continuousScan: Bool;              // Continuous scanning active
  };

  public func initScout() : ScoutState {
    {
      scoutsDeployed = 0;
      coverageArea = 0.0;
      threatsDetected = 0;
      earlyWarnings = 0;
      reconQuality = 0.0;
      stealthLevel = 1.0;  // Start with max stealth
      lastScanBeat = 0;
      continuousScan = false;
    }
  };

  public func deployScouts(
    state: ScoutState,
    scoutCount: Nat,
    continuous: Bool
  ) : ScoutState {
    {
      state with
      scoutsDeployed = scoutCount;
      coverageArea = Float.min(Float.fromInt(scoutCount) / 100.0, 1.0);  // Max 100 scouts for full coverage
      continuousScan = continuous;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CLASS 2: PROFILER — Adversary Pattern/Intent Modeling
  // Purpose: Build behavioral models of adversaries, predict intent
  // ═══════════════════════════════════════════════════════════════════════════════

  public type AdversaryProfile = {
    adversaryId: Text;                 // Unique adversary identifier
    observedActions: Nat;              // Number of observed actions
    patternConfidence: Float;          // [0,1] confidence in pattern
    predictedIntent: Text;             // Predicted adversary goal
    threatLevel: Float;                // [0,1] threat assessment
    sophisticationLevel: Float;        // [0,1] adversary skill
    lastActivityBeat: Nat;             // Last observed activity
  };

  public type ProfilerState = {
    activeProfiles: [AdversaryProfile]; // Known adversaries
    modelAccuracy: Float;              // [0,1] prediction accuracy
    patternsIdentified: Nat;           // Unique patterns found
    intentPredictions: Nat;            // Intent predictions made
    correctPredictions: Nat;           // Correct predictions
    profilingDepth: Float;             // [0,1] analysis depth
  };

  public func initProfiler() : ProfilerState {
    {
      activeProfiles = [];
      modelAccuracy = 0.0;
      patternsIdentified = 0;
      intentPredictions = 0;
      correctPredictions = 0;
      profilingDepth = 0.5;
    }
  };

  public func createAdversaryProfile(
    adversaryId: Text,
    initialThreat: Float
  ) : AdversaryProfile {
    {
      adversaryId = adversaryId;
      observedActions = 0;
      patternConfidence = 0.0;
      predictedIntent = "UNKNOWN";
      threatLevel = initialThreat;
      sophisticationLevel = 0.5;
      lastActivityBeat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CLASS 3: TRAPWEAVER — Decoys, Honeyfields, False Surfaces
  // Purpose: Create convincing deceptions to waste adversary resources
  // ═══════════════════════════════════════════════════════════════════════════════

  public type TrapType = {
    #Honeypot;       // Traditional honeypot
    #Honeyfield;     // Large-scale deceptive environment
    #FalseSurface;   // Fake attack surface
    #DecoyData;      // Deceptive data
    #FakeVulnerability; // Planted vulnerability
  };

  public type Trap = {
    trapId: Nat;                       // Unique trap identifier
    trapType: TrapType;                // Type of trap
    believability: Float;              // [0,1] how convincing
    resourceCost: Float;               // [0,1] resource investment
    attackersTrapped: Nat;             // Adversaries caught
    intelligenceGained: Float;         // [0,1] intel from trap
    active: Bool;                      // Trap active?
    deployedBeat: Nat;                 // When deployed
  };

  public type TrapweaverState = {
    trapsDeployed: [Trap];             // Active traps
    totalAttackersTrapped: Nat;        // Total adversaries caught
    adversaryTimeWasted: Float;        // Estimated adversary time wasted
    deceptionEffectiveness: Float;     // [0,1] overall deception quality
    trapComplexity: Float;             // [0,1] trap sophistication
  };

  public func initTrapweaver() : TrapweaverState {
    {
      trapsDeployed = [];
      totalAttackersTrapped = 0;
      adversaryTimeWasted = 0.0;
      deceptionEffectiveness = 0.0;
      trapComplexity = 0.5;
    }
  };

  public func deployTrap(
    trapType: TrapType,
    believability: Float,
    resourceCost: Float,
    trapId: Nat,
    beat: Nat
  ) : Trap {
    {
      trapId = trapId;
      trapType = trapType;
      believability = believability;
      resourceCost = resourceCost;
      attackersTrapped = 0;
      intelligenceGained = 0.0;
      active = true;
      deployedBeat = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CLASS 4: HUNTER — Active Threat Hunting
  // Purpose: Proactive threat discovery across internal/external signals
  // ═══════════════════════════════════════════════════════════════════════════════

  public type HuntMission = {
    missionId: Nat;                    // Unique mission identifier
    hypothesis: Text;                  // What we're hunting for
    signalsAnalyzed: Nat;              // Signals processed
    threatsFound: Nat;                 // Threats discovered
    falsePositives: Nat;               // False alarms
    huntEfficiency: Float;             // [0,1] efficiency metric
    active: Bool;                      // Mission active?
    startBeat: Nat;                    // Mission start
  };

  public type HunterState = {
    activeMissions: [HuntMission];     // Active hunt missions
    totalThreatsFound: Nat;            // Cumulative threats found
    huntSuccess Rate: Float;           // [0,1] success rate
    signalCoverage: Float;             // [0,1] signal space covered
    hunterAggressiveness: Float;       // [0,1] how aggressive
    internalHunts: Nat;                // Internal threat hunts
    externalHunts: Nat;                // External threat hunts
  };

  public func initHunter() : HunterState {
    {
      activeMissions = [];
      totalThreatsFound = 0;
      huntSuccessRate = 0.0;
      signalCoverage = 0.0;
      hunterAggressiveness = 0.7;  // Default moderate-high
      internalHunts = 0;
      externalHunts = 0;
    }
  };

  public func launchHuntMission(
    missionId: Nat,
    hypothesis: Text,
    beat: Nat
  ) : HuntMission {
    {
      missionId = missionId;
      hypothesis = hypothesis;
      signalsAnalyzed = 0;
      threatsFound = 0;
      falsePositives = 0;
      huntEfficiency = 0.0;
      active = true;
      startBeat = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CLASS 5: INTERDICTOR — Cut Hostile Pathways
  // Purpose: Block, cut, or disrupt adversary access routes and channels
  // ═══════════════════════════════════════════════════════════════════════════════

  public type PathwayType = {
    #NetworkRoute;      // Network path
    #AccessChannel;     // Access channel
    #CommunicationLink; // Communication link
    #DataFlow;          // Data flow path
    #CommandControl;    // C2 channel
  };

  public type InterdictionAction = {
    actionId: Nat;                     // Unique action identifier
    pathwayType: PathwayType;          // What we're cutting
    targetPath: Text;                  // Target pathway
    interdictionMethod: Text;          // How we're cutting it
    successProbability: Float;         // [0,1] estimated success
    adversaryImpact: Float;            // [0,1] damage to adversary
    collateralRisk: Float;             // [0,1] risk to legitimate traffic
    executed: Bool;                    // Action executed?
    executionBeat: Nat;                // When executed
  };

  public type InterdictorState = {
    activeInterdictions: [InterdictionAction];
    pathwaysCut: Nat;                  // Total pathways severed
    adversariesBlocked: Nat;           // Adversaries interdicted
    interdictionEffectiveness: Float;  // [0,1] overall effectiveness
    collateralDamage: Float;           // [0,1] unintended impact
  };

  public func initInterdictor() : InterdictorState {
    {
      activeInterdictions = [];
      pathwaysCut = 0;
      adversariesBlocked = 0;
      interdictionEffectiveness = 0.0;
      collateralDamage = 0.0;
    }
  };

  public func createInterdiction(
    actionId: Nat,
    pathwayType: PathwayType,
    targetPath: Text,
    method: Text,
    successProb: Float,
    beat: Nat
  ) : InterdictionAction {
    {
      actionId = actionId;
      pathwayType = pathwayType;
      targetPath = targetPath;
      interdictionMethod = method;
      successProbability = successProb;
      adversaryImpact = 0.0;
      collateralRisk = 0.1;  // Default low risk
      executed = false;
      executionBeat = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CLASS 6: DISLOCATOR — Force Adversary Out of Path/Timing
  // Purpose: Disrupt adversary preparation, force reactive scrambling
  // ═══════════════════════════════════════════════════════════════════════════════

  public type DislocationTactic = {
    #TimingDisruption;    // Break adversary timing
    #PathRedirection;     // Force path change
    #ResourceDenial;      // Deny expected resources
    #SurpriseAction;      // Unexpected countermove
    #EnvironmentChange;   // Change attack surface
  };

  public type DislocationOperation = {
    operationId: Nat;                  // Unique operation identifier
    tactic: DislocationTactic;         // Dislocation method
    targetAdversary: Text;             // Target adversary
    dislocationPower: Float;           // [0,1] disruption strength
    adversaryConfusion: Float;         // [0,1] induced confusion
    timelineImpact: Float;             // [0,1] timeline disruption
    executed: Bool;                    // Operation executed?
    executionBeat: Nat;                // When executed
  };

  public type DislocatorState = {
    activeOperations: [DislocationOperation];
    totalDislocations: Nat;            // Total dislocation ops
    adversariesDisrupted: Nat;         // Adversaries affected
    dislocationEffectiveness: Float;   // [0,1] overall effectiveness
    adversaryRecoveryTime: Float;      // Estimated adversary recovery time
  };

  public func initDislocator() : DislocatorState {
    {
      activeOperations = [];
      totalDislocations = 0;
      adversariesDisrupted = 0;
      dislocationEffectiveness = 0.0;
      adversaryRecoveryTime = 0.0;
    }
  };

  public func createDislocation(
    operationId: Nat,
    tactic: DislocationTactic,
    targetAdversary: Text,
    power: Float,
    beat: Nat
  ) : DislocationOperation {
    {
      operationId = operationId;
      tactic = tactic;
      targetAdversary = targetAdversary;
      dislocationPower = power;
      adversaryConfusion = 0.0;
      timelineImpact = 0.0;
      executed = false;
      executionBeat = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CLASS 7: COUNTER-DECEIVER — Detect and Invert Spoof Campaigns
  // Purpose: Identify adversary deception, turn it against them
  // ═══════════════════════════════════════════════════════════════════════════════

  public type DeceptionCampaign = {
    campaignId: Text;                  // Unique campaign identifier
    deceptionType: Text;               // Type of deception detected
    sourceAdversary: Text;             // Source of deception
    confidence: Float;                 // [0,1] detection confidence
    inverted: Bool;                    // Deception inverted?
    inversionEffect: Float;            // [0,1] inversion damage to adversary
    detectedBeat: Nat;                 // When detected
  };

  public type CounterDeceiverState = {
    detectedCampaigns: [DeceptionCampaign];
    totalDeceptionsFound: Nat;         // Total deceptions detected
    successfulInversions: Nat;         // Successful counter-deceptions
    detectionAccuracy: Float;          // [0,1] detection accuracy
    inversionPower: Float;             // [0,1] inversion capability
    adversaryDeceptionRate: Float;     // [0,1] observed adversary deception
  };

  public func initCounterDeceiver() : CounterDeceiverState {
    {
      detectedCampaigns = [];
      totalDeceptionsFound = 0;
      successfulInversions = 0;
      detectionAccuracy = 0.0;
      inversionPower = 0.5;
      adversaryDeceptionRate = 0.0;
    }
  };

  public func detectDeception(
    campaignId: Text,
    deceptionType: Text,
    sourceAdversary: Text,
    confidence: Float,
    beat: Nat
  ) : DeceptionCampaign {
    {
      campaignId = campaignId;
      deceptionType = deceptionType;
      sourceAdversary = sourceAdversary;
      confidence = confidence;
      inverted = false;
      inversionEffect = 0.0;
      detectedBeat = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CLASS 8: PURSUIT FORENSICS — Chain Evidence, Attribution Packets
  // Purpose: Build attribution chains, connect attack packets to adversaries
  // ═══════════════════════════════════════════════════════════════════════════════

  public type EvidencePacket = {
    packetId: Nat;                     // Unique packet identifier
    evidenceType: Text;                // Type of evidence
    timestamp: Nat;                    // When collected
    source: Text;                      // Evidence source
    confidence: Float;                 // [0,1] evidence quality
    linkedTo: [Nat];                   // Linked evidence packets
  };

  public type AttributionChain = {
    chainId: Nat;                      // Unique chain identifier
    targetAdversary: Text;             // Attributed adversary
    evidencePackets: [EvidencePacket]; // Evidence chain
    attributionConfidence: Float;      // [0,1] attribution confidence
    chainComplete: Bool;               // Chain complete?
    actionableAttribution: Bool;       // Ready for action?
  };

  public type PursuitForensicsState = {
    attributionChains: [AttributionChain];
    totalEvidencePackets: Nat;         // Total evidence collected
    completedAttributions: Nat;        // Completed attribution chains
    attributionAccuracy: Float;        // [0,1] attribution accuracy
    forensicDepth: Float;              // [0,1] analysis depth
  };

  public func initPursuitForensics() : PursuitForensicsState {
    {
      attributionChains = [];
      totalEvidencePackets = 0;
      completedAttributions = 0;
      attributionAccuracy = 0.0;
      forensicDepth = 0.7;
    }
  };

  public func createEvidencePacket(
    packetId: Nat,
    evidenceType: Text,
    source: Text,
    confidence: Float,
    beat: Nat
  ) : EvidencePacket {
    {
      packetId = packetId;
      evidenceType = evidenceType;
      timestamp = beat;
      source = source;
      confidence = confidence;
      linkedTo = [];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CLASS 9: DETERRENCE OPERATOR — Visible Resilience Signaling
  // Purpose: Elevate adversary costs, signal capability, demonstrate resilience
  // ═══════════════════════════════════════════════════════════════════════════════

  public type DeterrenceSignal = {
    signalId: Nat;                     // Unique signal identifier
    signalType: Text;                  // Type of deterrence signal
    visibility: Float;                 // [0,1] how visible to adversary
    credibility: Float;                // [0,1] signal credibility
    costElevation: Float;              // [0,1] estimated cost increase to adversary
    targetAudience: Text;              // Target adversary or group
    broadcasted: Bool;                 // Signal broadcasted?
    broadcastBeat: Nat;                // When broadcasted
  };

  public type DeterrenceOperatorState = {
    activeSignals: [DeterrenceSignal]; // Active deterrence signals
    totalSignalsBroadcasted: Nat;      // Total signals sent
    adversaryCostMultiplier: Float;    // Estimated adversary cost multiplier
    deterrenceEffectiveness: Float;    // [0,1] overall effectiveness
    resilienceScore: Float;            // [0,1] demonstrated resilience
    adversaryWithdrawals: Nat;         // Adversaries deterred/withdrawn
  };

  public func initDeterrenceOperator() : DeterrenceOperatorState {
    {
      activeSignals = [];
      totalSignalsBroadcasted = 0;
      adversaryCostMultiplier = 1.0;  // Base cost (no elevation)
      deterrenceEffectiveness = 0.0;
      resilienceScore = 0.5;
      adversaryWithdrawals = 0;
    }
  };

  public func createDeterrenceSignal(
    signalId: Nat,
    signalType: Text,
    visibility: Float,
    credibility: Float,
    targetAudience: Text,
    beat: Nat
  ) : DeterrenceSignal {
    {
      signalId = signalId;
      signalType = signalType;
      visibility = visibility;
      credibility = credibility;
      costElevation = visibility * credibility;  // Cost elevation = visibility × credibility
      targetAudience = targetAudience;
      broadcasted = false;
      broadcastBeat = beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CLASS 10: CAMPAIGN ORCHESTRATOR — Coordinates All Counterforce Phases
  // Purpose: Unified command and control for all counterforce operations
  // ═══════════════════════════════════════════════════════════════════════════════

  public type CampaignPhase = {
    #Reconnaissance;    // Scout phase
    #Profiling;         // Adversary analysis
    #Deception;         // Trap deployment
    #Hunting;           // Active hunting
    #Interdiction;      // Pathway cutting
    #Dislocation;       // Adversary disruption
    #CounterDeception;  // Deception inversion
    #Attribution;       // Forensic analysis
    #Deterrence;        // Cost elevation
    #Termination;       // Campaign end
  };

  public type Campaign = {
    campaignId: Nat;                   // Unique campaign identifier
    campaignName: Text;                // Campaign name
    currentPhase: CampaignPhase;       // Current phase
    startBeat: Nat;                    // Campaign start
    phasesCompleted: [CampaignPhase];  // Completed phases
    targetAdversaries: [Text];         // Target adversaries
    overallEffectiveness: Float;       // [0,1] campaign effectiveness
    active: Bool;                      // Campaign active?
  };

  public type CampaignOrchestratorState = {
    activeCampaigns: [Campaign];       // Active campaigns
    totalCampaigns: Nat;               // Total campaigns launched
    successfulCampaigns: Nat;          // Successful campaigns
    orchestrationQuality: Float;       // [0,1] coordination quality
    multiPhaseCampaigns: Nat;          // Campaigns using multiple phases
    adversariesNeutralized: Nat;       // Total adversaries neutralized
  };

  public func initCampaignOrchestrator() : CampaignOrchestratorState {
    {
      activeCampaigns = [];
      totalCampaigns = 0;
      successfulCampaigns = 0;
      orchestrationQuality = 0.0;
      multiPhaseCampaigns = 0;
      adversariesNeutralized = 0;
    }
  };

  public func launchCampaign(
    campaignId: Nat,
    campaignName: Text,
    initialPhase: CampaignPhase,
    targets: [Text],
    beat: Nat
  ) : Campaign {
    {
      campaignId = campaignId;
      campaignName = campaignName;
      currentPhase = initialPhase;
      startBeat = beat;
      phasesCompleted = [];
      targetAdversaries = targets;
      overallEffectiveness = 0.0;
      active = true;
    }
  };

  public func advanceCampaignPhase(
    campaign: Campaign,
    nextPhase: CampaignPhase
  ) : Campaign {
    let updatedCompleted = Array.append(campaign.phasesCompleted, [campaign.currentPhase]);
    {
      campaign with
      currentPhase = nextPhase;
      phasesCompleted = updatedCompleted;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UNIFIED COUNTERFORCE STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public type CounterforceState = {
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

    // Unified metrics
    overallEffectiveness: Float;       // [0,1] overall counterforce effectiveness
    adversaryPressure: Float;          // [0,1] pressure on adversaries
    operationalTempo: Float;           // [0,1] operation speed
    coordinationQuality: Float;        // [0,1] coordination between classes
    beat: Nat;                         // Current beat
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func initCounterforce() : CounterforceState {
    {
      scout = initScout();
      profiler = initProfiler();
      trapweaver = initTrapweaver();
      hunter = initHunter();
      interdictor = initInterdictor();
      dislocator = initDislocator();
      counterDeceiver = initCounterDeceiver();
      pursuitForensics = initPursuitForensics();
      deterrenceOperator = initDeterrenceOperator();
      campaignOrchestrator = initCampaignOrchestrator();
      overallEffectiveness = 0.0;
      adversaryPressure = 0.0;
      operationalTempo = 0.5;
      coordinationQuality = 0.0;
      beat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPUTE OVERALL EFFECTIVENESS
  // ═══════════════════════════════════════════════════════════════════════════════

  public func computeCounterforceEffectiveness(state: CounterforceState) : Float {
    let scoutWeight = 0.10;
    let profilerWeight = 0.10;
    let trapweaverWeight = 0.10;
    let hunterWeight = 0.15;
    let interdictorWeight = 0.10;
    let dislocatorWeight = 0.10;
    let counterDeceiverWeight = 0.10;
    let forensicsWeight = 0.10;
    let deterrenceWeight = 0.10;
    let orchestratorWeight = 0.05;

    (state.scout.reconQuality * scoutWeight) +
    (state.profiler.modelAccuracy * profilerWeight) +
    (state.trapweaver.deceptionEffectiveness * trapweaverWeight) +
    (state.hunter.huntSuccessRate * hunterWeight) +
    (state.interdictor.interdictionEffectiveness * interdictorWeight) +
    (state.dislocator.dislocationEffectiveness * dislocatorWeight) +
    (state.counterDeceiver.detectionAccuracy * counterDeceiverWeight) +
    (state.pursuitForensics.attributionAccuracy * forensicsWeight) +
    (state.deterrenceOperator.deterrenceEffectiveness * deterrenceWeight) +
    (state.campaignOrchestrator.orchestrationQuality * orchestratorWeight)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  func clamp(x: Float, min: Float, max: Float) : Float {
    if (x < min) { min } else if (x > max) { max } else { x }
  };

}
