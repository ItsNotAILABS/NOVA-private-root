// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: swarmBrainActor.ts — REAL Canister Connection to Backend Organism
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// THIS FILE CONNECTS THE FRONTEND TO THE REAL BACKEND.
// NO MOCKS. NO FAKES. REAL CANISTER CALLS.
//
// ═══════════════════════════════════════════════════════════════════════════════

import { Actor, HttpAgent } from '@dfinity/agent';
import { Principal } from '@dfinity/principal';
import { IDL } from '@dfinity/candid';

// ═══════════════════════════════════════════════════════════════════════════════
// CANISTER IDS — From dfx.json
// ═══════════════════════════════════════════════════════════════════════════════

// These are set during dfx deploy - read from environment or use defaults
const getCanisterId = (): string => {
  // Try Vite env
  if (typeof import.meta !== 'undefined' && import.meta.env?.VITE_SWARM_BRAIN_CANISTER_ID) {
    return import.meta.env.VITE_SWARM_BRAIN_CANISTER_ID;
  }
  // Try process.env
  if (typeof process !== 'undefined' && process.env?.SWARM_BRAIN_CANISTER_ID) {
    return process.env.SWARM_BRAIN_CANISTER_ID;
  }
  // Local default
  return 'bkyz2-fmaaa-aaaaa-qaaaq-cai';
};

const SWARM_BRAIN_CANISTER_ID = getCanisterId();

// ═══════════════════════════════════════════════════════════════════════════════
// SWARM SNAPSHOT TYPE — Matches main.mo getSwarmSnapshot() exactly
// ═══════════════════════════════════════════════════════════════════════════════

export interface SwarmSnapshot {
  droneCount: number;
  rSwarm: number;
  jDrift: number;
  beat: number;
  phases: number[];
  signals: number[];
  positionsX: number[];
  positionsY: number[];
  positionsZ: number[];
  cortisolLevels: number[];
  sacrificed: boolean[];
  classes: string[];
  qChannelsAlpha: number[];
  qChannelsBeta: number[];
  qChannelsGamma: number[];
  qChannelsDelta: number[];
  qConvergence: number[];
  qCoherence: number[];
  nowAttention: number[];
}

export interface SwarmQMetrics {
  swarmQCoherence: number;
  swarmConvergence: number;
  swarmNowIndex: number;
}

export interface QuantumHeartbeatState {
  quantumBeatNumber: number;
  quantumPhase: number;
  quantumCoherence: number;
  cardiacCoherence: number;
  circadianPhase: number;
  fibonacciBeatNumber: number;
  parallaxWinnerPath: number;
  parallaxScore: number;
  parallaxPathAmplitudes: number[];
  chronoFisherInfo: number;
  chronoCramerRao: number;
  chronoScore: number;
  entanglaSValue: number;
  entanglaEMA: number;
  entanglaViolationBonus: number;
  entanglaScore: number;
  qmemFidelity: number;
  qmemT2Time: number;
  qmemTimeSinceReset: number;
  qmemScore: number;
  veritasStabilizers: number[];
  veritasParityScore: number;
  veritasScore: number;
  bypassSelectedRhythm: number;
  bypassTemperature: number;
  bypassScore: number;
  resonexParticipants: number;
  resonexAmplitude: number;
  resonexCascadeActive: boolean;
  resonexScore: number;
  qsovScore: number;
  qsovGeometricMean: number;
  totalHeartbeats: number;
  averageCoherence: number;
  heartbeatVariability: number;
  circadianAlignment: number;
  cardioCerebralResonance: number;
  cardioCerebralPhaseLag: number;
  cardioCerebralPropulsion: number;
  cardioCerebralAlignment: number;
  cardioCerebralPushEffectiveness: number;
}

export interface CardioCerebralState {
  resonance: number;
  phaseLag: number;
  directionX: number;
  directionY: number;
  directionZ: number;
  propulsion: number;
  alignment: number;
  pushEffectiveness: number;
  beatNum: number;
  resonanceHistory: number[];
  propulsionHistory: number[];
}

export interface GeoResonanceProtectionState {
  beat: number;
  fieldEnergy: number;
  hotspotScore: number;
  protectionScore: number;
  threatScore: number;
  serviceReadiness: number;
  fieldDirectionX: number;
  fieldDirectionY: number;
  fieldDirectionZ: number;
  sevenHeritageNodes: number[];
  serviceOpportunity: number[];
  defenseServiceOpportunity: number[];
  memoryServiceOpportunity: number[];
  worldServiceOpportunity: number[];
  fieldHistory: number[];
  hotspotHistory: number[];
  protectionHistory: number[];
}

export interface CardioNeuralConversionOrganState {
  beat: number;
  coupling: number;
  oxygenFlow: number;
  perfusionFlow: number;
  conversionGain: number;
  gateOpen: boolean;
  helixBarrier: number;
  shieldIntegrity: number;
  thoughtThroughput: number;
  outputCoherence: number;
  outputDirectionX: number;
  outputDirectionY: number;
  outputDirectionZ: number;
  throughputHistory: number[];
  shieldHistory: number[];
  couplingHistory: number[];
}

export interface AutonomousAnalystTeamState {
  beat: number;
  learningScore: number;
  adaptationScore: number;
  emergencySignal: number;
  recommendationPriority: number;
  narrativeSummary: string;
  heartNarrative: string;
  brainNarrative: string;
  middleOrganNarrative: string;
  defenseNarrative: string;
  growthNarrative: string;
  topRecommendations: string[];
}

export interface MemoryTempleState {
  beat: number;
  continuityWeave: number;
  resonanceField: number;
  cognitiveLoad: number;
  memoryRetention: number;
  recallReadiness: number;
  memoryCognitionCoupling: number;
  iotCouplingScore: number;
  deviceTwinIntegrity: number;
  phantomIntegrity: number;
  agentWorkCapacity: number;
  artifactReadiness: number;
  directionX: number;
  directionY: number;
  directionZ: number;
  pedestalNames: string[];
  pedestalCouplings: number[];
  narrativeSummary: string;
  recommendations: string[];
  continuityHistory: number[];
  resonanceHistory: number[];
  couplingHistory: number[];
}

export interface ConstantFeedbackCognitionState {
  beat: number;
  cognitivePressure: number;
  loopClosureScore: number;
  reinjectionIntegrity: number;
  multiGroupCoherence: number;
  multiOrganismCoherence: number;
  cognitionReadiness: number;
  arbitrationReadiness: number;
  governanceStability: number;
  recommendationPriority: number;
  lawContinuityScore: number;
  defensePostureScore: number;
  economicResilienceScore: number;
  workforceCoherenceScore: number;
  memoryIntegrityScore: number;
  meshResonanceScore: number;
  sovereignAlignmentScore: number;
  riskContainmentScore: number;
  narrativeSummary: string;
  topActions: string[];
  pressureHistory: number[];
  closureHistory: number[];
  reinjectionHistory: number[];
  multiGroupHistory: number[];
  multiOrganismHistory: number[];
  lawHistory: number[];
  defenseHistory: number[];
  economyHistory: number[];
  workforceHistory: number[];
  meshHistory: number[];
  sovereignHistory: number[];
}

export interface TickResult {
  rSwarm: number;
  jDrift: number;
  beat: number;
}

export interface OrganismState {
  mode: string;
  beat: number;
  coherence: number;
  morale: number;
  energy: number;
  lastHeartbeat: number;
  continuityScore: number;
  trustScore: number;
  anomalyScore: number;
  simConfidence: number;
  emergencyActive: boolean;
}

export interface ExtendedSnapshot {
  droneCount: number;
  rSwarm: number;
  jDrift: number;
  beat: number;
  architectSignal: number;
  omnisActive: boolean;
  omnisCount: number;
  frequencyTier: string;
  hz: number;
  saceU: number;
  complianceScore: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// IDL FACTORY — Candid interface for swarm_brain canister
// ═══════════════════════════════════════════════════════════════════════════════

const swarmBrainIDLFactory = ({ IDL }: { IDL: typeof IDL }) => {
  return IDL.Service({
    // Core state queries
    getSwarmSnapshot: IDL.Func([], [IDL.Record({
      droneCount: IDL.Nat,
      rSwarm: IDL.Float64,
      jDrift: IDL.Float64,
      beat: IDL.Nat,
      phases: IDL.Vec(IDL.Float64),
      signals: IDL.Vec(IDL.Float64),
      positionsX: IDL.Vec(IDL.Float64),
      positionsY: IDL.Vec(IDL.Float64),
      positionsZ: IDL.Vec(IDL.Float64),
      cortisolLevels: IDL.Vec(IDL.Float64),
      sacrificed: IDL.Vec(IDL.Bool),
      classes: IDL.Vec(IDL.Text),
      qChannelsAlpha: IDL.Vec(IDL.Float64),
      qChannelsBeta: IDL.Vec(IDL.Float64),
      qChannelsGamma: IDL.Vec(IDL.Float64),
      qChannelsDelta: IDL.Vec(IDL.Float64),
      qConvergence: IDL.Vec(IDL.Float64),
      qCoherence: IDL.Vec(IDL.Float64),
      nowAttention: IDL.Vec(IDL.Float64),
    })], ['query']),
    
    getExtendedSnapshot: IDL.Func([], [IDL.Record({
      droneCount: IDL.Nat,
      rSwarm: IDL.Float64,
      jDrift: IDL.Float64,
      beat: IDL.Nat,
      architectSignal: IDL.Float64,
      omnisActive: IDL.Bool,
      omnisCount: IDL.Nat,
      frequencyTier: IDL.Text,
      hz: IDL.Float64,
      saceU: IDL.Float64,
      complianceScore: IDL.Float64,
    })], ['query']),
    
    getSwarmQMetrics: IDL.Func([], [IDL.Record({
      swarmQCoherence: IDL.Float64,
      swarmConvergence: IDL.Float64,
      swarmNowIndex: IDL.Float64,
    })], ['query']),

    getQuantumHeartbeatState: IDL.Func([], [IDL.Record({
      quantumBeatNumber: IDL.Nat,
      quantumPhase: IDL.Float64,
      quantumCoherence: IDL.Float64,
      cardiacCoherence: IDL.Float64,
      circadianPhase: IDL.Float64,
      fibonacciBeatNumber: IDL.Nat,
      parallaxWinnerPath: IDL.Nat,
      parallaxScore: IDL.Float64,
      parallaxPathAmplitudes: IDL.Vec(IDL.Float64),
      chronoFisherInfo: IDL.Float64,
      chronoCramerRao: IDL.Float64,
      chronoScore: IDL.Float64,
      entanglaSValue: IDL.Float64,
      entanglaEMA: IDL.Float64,
      entanglaViolationBonus: IDL.Float64,
      entanglaScore: IDL.Float64,
      qmemFidelity: IDL.Float64,
      qmemT2Time: IDL.Float64,
      qmemTimeSinceReset: IDL.Nat,
      qmemScore: IDL.Float64,
      veritasStabilizers: IDL.Vec(IDL.Float64),
      veritasParityScore: IDL.Float64,
      veritasScore: IDL.Float64,
      bypassSelectedRhythm: IDL.Nat,
      bypassTemperature: IDL.Float64,
      bypassScore: IDL.Float64,
      resonexParticipants: IDL.Nat,
      resonexAmplitude: IDL.Float64,
      resonexCascadeActive: IDL.Bool,
      resonexScore: IDL.Float64,
      qsovScore: IDL.Float64,
      qsovGeometricMean: IDL.Float64,
      totalHeartbeats: IDL.Nat,
      averageCoherence: IDL.Float64,
      heartbeatVariability: IDL.Float64,
      circadianAlignment: IDL.Float64,
      cardioCerebralResonance: IDL.Float64,
      cardioCerebralPhaseLag: IDL.Float64,
      cardioCerebralPropulsion: IDL.Float64,
      cardioCerebralAlignment: IDL.Float64,
      cardioCerebralPushEffectiveness: IDL.Float64,
    })], ['query']),

    getCardioCerebralState: IDL.Func([], [IDL.Record({
      resonance: IDL.Float64,
      phaseLag: IDL.Float64,
      directionX: IDL.Float64,
      directionY: IDL.Float64,
      directionZ: IDL.Float64,
      propulsion: IDL.Float64,
      alignment: IDL.Float64,
      pushEffectiveness: IDL.Float64,
      beatNum: IDL.Nat,
      resonanceHistory: IDL.Vec(IDL.Float64),
      propulsionHistory: IDL.Vec(IDL.Float64),
    })], ['query']),

    getGeoResonanceProtectionState: IDL.Func([], [IDL.Record({
      beat: IDL.Nat,
      fieldEnergy: IDL.Float64,
      hotspotScore: IDL.Float64,
      protectionScore: IDL.Float64,
      threatScore: IDL.Float64,
      serviceReadiness: IDL.Float64,
      fieldDirectionX: IDL.Float64,
      fieldDirectionY: IDL.Float64,
      fieldDirectionZ: IDL.Float64,
      sevenHeritageNodes: IDL.Vec(IDL.Float64),
      serviceOpportunity: IDL.Vec(IDL.Float64),
      defenseServiceOpportunity: IDL.Vec(IDL.Float64),
      memoryServiceOpportunity: IDL.Vec(IDL.Float64),
      worldServiceOpportunity: IDL.Vec(IDL.Float64),
      fieldHistory: IDL.Vec(IDL.Float64),
      hotspotHistory: IDL.Vec(IDL.Float64),
      protectionHistory: IDL.Vec(IDL.Float64),
    })], ['query']),

    getCardioNeuralConversionOrganState: IDL.Func([], [IDL.Record({
      beat: IDL.Nat,
      coupling: IDL.Float64,
      oxygenFlow: IDL.Float64,
      perfusionFlow: IDL.Float64,
      conversionGain: IDL.Float64,
      gateOpen: IDL.Bool,
      helixBarrier: IDL.Float64,
      shieldIntegrity: IDL.Float64,
      thoughtThroughput: IDL.Float64,
      outputCoherence: IDL.Float64,
      outputDirectionX: IDL.Float64,
      outputDirectionY: IDL.Float64,
      outputDirectionZ: IDL.Float64,
      throughputHistory: IDL.Vec(IDL.Float64),
      shieldHistory: IDL.Vec(IDL.Float64),
      couplingHistory: IDL.Vec(IDL.Float64),
    })], ['query']),

    getAutonomousAnalystTeamState: IDL.Func([], [IDL.Record({
      beat: IDL.Nat,
      learningScore: IDL.Float64,
      adaptationScore: IDL.Float64,
      emergencySignal: IDL.Float64,
      recommendationPriority: IDL.Float64,
      narrativeSummary: IDL.Text,
      heartNarrative: IDL.Text,
      brainNarrative: IDL.Text,
      middleOrganNarrative: IDL.Text,
      defenseNarrative: IDL.Text,
      growthNarrative: IDL.Text,
      topRecommendations: IDL.Vec(IDL.Text),
    })], ['query']),

    getMemoryTempleState: IDL.Func([], [IDL.Record({
      beat: IDL.Nat,
      continuityWeave: IDL.Float64,
      resonanceField: IDL.Float64,
      cognitiveLoad: IDL.Float64,
      memoryRetention: IDL.Float64,
      recallReadiness: IDL.Float64,
      memoryCognitionCoupling: IDL.Float64,
      iotCouplingScore: IDL.Float64,
      deviceTwinIntegrity: IDL.Float64,
      phantomIntegrity: IDL.Float64,
      agentWorkCapacity: IDL.Float64,
      artifactReadiness: IDL.Float64,
      directionX: IDL.Float64,
      directionY: IDL.Float64,
      directionZ: IDL.Float64,
      pedestalNames: IDL.Vec(IDL.Text),
      pedestalCouplings: IDL.Vec(IDL.Float64),
      narrativeSummary: IDL.Text,
      recommendations: IDL.Vec(IDL.Text),
      continuityHistory: IDL.Vec(IDL.Float64),
      resonanceHistory: IDL.Vec(IDL.Float64),
      couplingHistory: IDL.Vec(IDL.Float64),
    })], ['query']),

    getConstantFeedbackCognitionState: IDL.Func([], [IDL.Record({
      beat: IDL.Nat,
      cognitivePressure: IDL.Float64,
      loopClosureScore: IDL.Float64,
      reinjectionIntegrity: IDL.Float64,
      multiGroupCoherence: IDL.Float64,
      multiOrganismCoherence: IDL.Float64,
      cognitionReadiness: IDL.Float64,
      arbitrationReadiness: IDL.Float64,
      governanceStability: IDL.Float64,
      recommendationPriority: IDL.Float64,
      lawContinuityScore: IDL.Float64,
      defensePostureScore: IDL.Float64,
      economicResilienceScore: IDL.Float64,
      workforceCoherenceScore: IDL.Float64,
      memoryIntegrityScore: IDL.Float64,
      meshResonanceScore: IDL.Float64,
      sovereignAlignmentScore: IDL.Float64,
      riskContainmentScore: IDL.Float64,
      narrativeSummary: IDL.Text,
      topActions: IDL.Vec(IDL.Text),
      pressureHistory: IDL.Vec(IDL.Float64),
      closureHistory: IDL.Vec(IDL.Float64),
      reinjectionHistory: IDL.Vec(IDL.Float64),
      multiGroupHistory: IDL.Vec(IDL.Float64),
      multiOrganismHistory: IDL.Vec(IDL.Float64),
      lawHistory: IDL.Vec(IDL.Float64),
      defenseHistory: IDL.Vec(IDL.Float64),
      economyHistory: IDL.Vec(IDL.Float64),
      workforceHistory: IDL.Vec(IDL.Float64),
      meshHistory: IDL.Vec(IDL.Float64),
      sovereignHistory: IDL.Vec(IDL.Float64),
    })], ['query']),
    
    getDroneCount: IDL.Func([], [IDL.Nat], ['query']),
    getRSwarm: IDL.Func([], [IDL.Float64], ['query']),
    getJDrift: IDL.Func([], [IDL.Float64], ['query']),
    getCurrentBeat: IDL.Func([], [IDL.Nat], ['query']),
    getArchitectSignalLevel: IDL.Func([], [IDL.Float64], ['query']),
    getComplianceScore: IDL.Func([], [IDL.Float64], ['query']),
    getFrequencyTier: IDL.Func([], [IDL.Record({ tier: IDL.Text, hz: IDL.Float64 })], ['query']),
    getOmnisFired: IDL.Func([], [IDL.Bool], ['query']),
    getOmnisCount: IDL.Func([], [IDL.Nat], ['query']),
    
    getOrganismState: IDL.Func([], [IDL.Record({
      mode: IDL.Text,
      beat: IDL.Nat,
      coherence: IDL.Float64,
      morale: IDL.Float64,
      energy: IDL.Float64,
      lastHeartbeat: IDL.Nat,
      continuityScore: IDL.Float64,
      trustScore: IDL.Float64,
      anomalyScore: IDL.Float64,
      simConfidence: IDL.Float64,
      emergencyActive: IDL.Bool,
    })], ['query']),
    
    // Control functions
    tick: IDL.Func([], [IDL.Record({
      rSwarm: IDL.Float64,
      jDrift: IDL.Float64,
      beat: IDL.Nat,
    })], []),
    
    masterHeartbeat: IDL.Func([], [], []),
    
    setArchitectSignalLevel: IDL.Func([IDL.Float64], [], []),
    
    addDrone: IDL.Func([IDL.Text, IDL.Float64, IDL.Float64, IDL.Float64, IDL.Float64], [IDL.Nat], []),
    
    executeSacrifice: IDL.Func([IDL.Nat], [IDL.Bool], []),
    
    updatePosition: IDL.Func([IDL.Nat, IDL.Float64, IDL.Float64, IDL.Float64], [], []),
    
    broadcastNeurochemical: IDL.Func([IDL.Text, IDL.Float64], [], []),

    // ═══ DEFENSE DOMAIN ═══
    getAEGISState: IDL.Func([], [IDL.Record({
      threatLevel: IDL.Float64,
      defenseActive: IDL.Bool,
      lastAlertBeat: IDL.Nat,
      protectedValues: IDL.Vec(IDL.Float64),
    })], ['query']),

    getWarDefenseModeState: IDL.Func([], [IDL.Record({
      mode: IDL.Text,
      posture: IDL.Nat,
      threatScore: IDL.Float64,
      gateStrictness: IDL.Float64,
      containmentDepth: IDL.Nat,
      rollbackTier: IDL.Nat,
      interfaceLockdown: IDL.Bool,
      continuityScore: IDL.Float64,
      coherenceScore: IDL.Float64,
      integrityScore: IDL.Float64,
      driftScore: IDL.Float64,
      bypassScore: IDL.Float64,
      escapeScore: IDL.Float64,
      sentinelSensitivity: IDL.Float64,
      verifierStrength: IDL.Float64,
      gatekeeperStrictness: IDL.Float64,
      resonanceQuality: IDL.Float64,
      cartographerThreatsTracked: IDL.Nat,
      guardianShieldsActive: IDL.Bool,
      restorerRecoveryReady: IDL.Bool,
      scoutsDeployed: IDL.Nat,
      adversariesProfiled: IDL.Nat,
      trapsDeployed: IDL.Nat,
      huntsActive: IDL.Nat,
      pathwaysCut: IDL.Nat,
      dislocationsExecuted: IDL.Nat,
      spoofCampaignsDetected: IDL.Nat,
      evidenceChainsBuilt: IDL.Nat,
      resilienceSignals: IDL.Nat,
      campaignsActive: IDL.Nat,
    })], ['query']),

    getCounterforceStatus: IDL.Func([], [IDL.Record({
      overallEffectiveness: IDL.Float64,
      adversaryPressure: IDL.Float64,
      coordinationQuality: IDL.Float64,
      scoutCoverage: IDL.Float64,
      profilerAccuracy: IDL.Float64,
      hunterSuccessRate: IDL.Float64,
      activeCampaigns: IDL.Nat,
      totalThreatsFound: IDL.Nat,
    })], ['query']),

    getOffenseDefenseStatus: IDL.Func([], [IDL.Record({
      architectureFlowIntegrity: IDL.Float64,
      offensivePower: IDL.Float64,
      defensivePower: IDL.Float64,
      intelligenceQuality: IDL.Float64,
      offenseDefenseBalance: IDL.Float64,
      coordinationQuality: IDL.Float64,
      energized: IDL.Bool,
      dronesDeployed: IDL.Nat,
      cyberAttackVectors: IDL.Nat,
      honeypotsActive: IDL.Nat,
      shieldStrength: IDL.Float64,
      threatsActive: IDL.Nat,
    })], ['query']),

    // ═══ MEMORY DOMAIN ═══
    getMemorySystemState: IDL.Func([], [IDL.Record({
      qmemFidelity: IDL.Float64,
      qmemT2Time: IDL.Float64,
      timeSinceReset: IDL.Nat,
      dreamCycleActive: IDL.Bool,
      consolidationThreshold: IDL.Float64,
      replayFrequency: IDL.Nat,
      isRestState: IDL.Bool,
      bdnfLevel: IDL.Float64,
      ngfLevel: IDL.Float64,
      memoryPotentiation: IDL.Float64,
      plasticityRate: IDL.Float64,
      shell3ActiveNodes: IDL.Nat,
      shell3AverageActivation: IDL.Float64,
      shell3MaxActivation: IDL.Float64,
      shell12ActiveNodes: IDL.Nat,
      shell12AverageActivation: IDL.Float64,
      shell12MaxActivation: IDL.Float64,
      shell3ToShell12TransferRate: IDL.Float64,
      shell12ToShell3RetrievalRate: IDL.Float64,
      emotionalMemoryBoost: IDL.Float64,
    })], ['query']),

    getMemoryState: IDL.Func([], [IDL.Record({
      traceCount: IDL.Nat,
      responseWeights: IDL.Vec(IDL.Float64),
    })], ['query']),

    // ═══ GOVERNANCE DOMAIN ═══
    getLawComplianceState: IDL.Func([], [IDL.Record({
      lawGroup0Compliance: IDL.Float64,
      lawGroup1Compliance: IDL.Float64,
      lawGroup2Compliance: IDL.Float64,
      lawGroup3Compliance: IDL.Float64,
      lawGroup4Compliance: IDL.Float64,
      overallCompliance: IDL.Float64,
      veritasStabilizers: IDL.Vec(IDL.Float64),
      veritasSyndromes: IDL.Vec(IDL.Float64),
      highRiskLaws: IDL.Vec(IDL.Nat),
      violationCount: IDL.Nat,
      totalReEntrainments: IDL.Nat,
      quantumLawCompliance: IDL.Vec(IDL.Float64),
      quantumViolationRisks: IDL.Vec(IDL.Float64),
    })], ['query']),

    getLawsSnapshot: IDL.Func([], [IDL.Record({
      scores: IDL.Vec(IDL.Float64),
      compliance: IDL.Float64,
      passing: IDL.Nat,
      fingerprint: IDL.Nat32,
      jacobsRung: IDL.Nat,
      multiplier: IDL.Float64,
    })], ['query']),

    getSecurityStatus: IDL.Func([], [IDL.Record({
      lockdownActive: IDL.Bool,
      lockdownLevel: IDL.Text,
      securityScore: IDL.Float64,
      encryptionCoverage: IDL.Float64,
      fleetExpanded: IDL.Bool,
      readyForLaunch: IDL.Bool,
      modelsUpdated: IDL.Nat,
      totalExposures: IDL.Nat,
      remediatedExposures: IDL.Nat,
    })], ['query']),

    // ═══ NEURAL DOMAIN ═══
    getNeuralCoreState: IDL.Func([], [IDL.Record({
      coreActivations: IDL.Vec(IDL.Float64),
      coreOutputs: IDL.Vec(IDL.Float64),
      corePhases: IDL.Vec(IDL.Float64),
      corePlasticity: IDL.Vec(IDL.Float64),
      globalSynchrony: IDL.Float64,
      coreNeuroDynamics: IDL.Float64,
      animalIntelligence: IDL.Float64,
      emergenceStack: IDL.Float64,
      cognitiveStack: IDL.Float64,
      defenseStack: IDL.Float64,
      productionStack: IDL.Float64,
      neuralStatus: IDL.Text,
    })], ['query']),

    getBrainRegionStates: IDL.Func([], [IDL.Record({
      prefrontalControl: IDL.Float64,
      basalGangliaSelection: IDL.Float64,
      thalamusRelay: IDL.Float64,
      hippocampusMemory: IDL.Float64,
      amygdalaSalience: IDL.Float64,
      cerebellumTiming: IDL.Float64,
      workingMemoryLoad: IDL.Nat,
      selectedAction: IDL.Nat,
      fearResponse: IDL.Float64,
      rewardResponse: IDL.Float64,
    })], ['query']),

    getNeurotransmitterState: IDL.Func([], [IDL.Record({
      gaba: IDL.Float64,
      glutamate: IDL.Float64,
      endorphin: IDL.Float64,
      oxytocin: IDL.Float64,
      cortisol: IDL.Float64,
      adrenaline: IDL.Float64,
      melatonin: IDL.Float64,
      histamine: IDL.Float64,
      substanceP: IDL.Float64,
      adenosine: IDL.Float64,
      anandamide: IDL.Float64,
      dynorphin: IDL.Float64,
      vasopressin: IDL.Float64,
      npy: IDL.Float64,
      orexin: IDL.Float64,
      bdnf: IDL.Float64,
      ngf: IDL.Float64,
      stressLevel: IDL.Float64,
      rewardLevel: IDL.Float64,
      eiRatio: IDL.Float64,
      arousalLevel: IDL.Float64,
      memoryPotentiation: IDL.Float64,
      balanceIndex: IDL.Float64,
      plasticityRate: IDL.Float64,
      totalUpdates: IDL.Nat,
    })], ['query']),

    // ═══ QUANTUM DOMAIN ═══
    getQuantumOperatorStates: IDL.Func([], [IDL.Record({
      superposition: IDL.Float64,
      entanglement: IDL.Float64,
      interference: IDL.Float64,
      tunneling: IDL.Float64,
      decoherence: IDL.Float64,
      measurement: IDL.Float64,
      zeno: IDL.Float64,
      quantumWalk: IDL.Float64,
      bellViolation: IDL.Float64,
      purity: IDL.Float64,
    })], ['query']),

    getSphericalQuantumState: IDL.Func([], [IDL.Record({
      sphericalIntegrity: IDL.Float64,
      organismVitality: IDL.Float64,
      hzKore: IDL.Float64,
      hzThalamic: IDL.Float64,
      hzRASLocus: IDL.Float64,
      hzVael: IDL.Float64,
      shellPhases: IDL.Vec(IDL.Float64),
      shellCoherences: IDL.Vec(IDL.Float64),
      shellEnergies: IDL.Vec(IDL.Float64),
      animalWeights: IDL.Vec(IDL.Float64),
      beeSwarmBoost: IDL.Float64,
      elephantMemoryFidelity: IDL.Float64,
      sharkPredatorPath: IDL.Float64,
      crowCognitionDecision: IDL.Float64,
      lawComplianceScores: IDL.Vec(IDL.Float64),
      lawViolationRisks: IDL.Vec(IDL.Float64),
      overallCompliance: IDL.Float64,
      councilKuramotoR: IDL.Vec(IDL.Float64),
      councilBellViolations: IDL.Vec(IDL.Float64),
      councilQSOVContributions: IDL.Vec(IDL.Float64),
      vetusDefenseBoosts: IDL.Vec(IDL.Float64),
      vetusEvasionPaths: IDL.Vec(IDL.Nat),
      vetusResponseTimes: IDL.Vec(IDL.Float64),
      aegisIntegrities: IDL.Vec(IDL.Float64),
      aegisSovereignty: IDL.Float64,
      aegisCoherence: IDL.Float64,
      aegisMemory: IDL.Float64,
      formaMintModulation: IDL.Float64,
      formaBurnModulation: IDL.Float64,
      formaCompoundModulation: IDL.Float64,
      formaStabilityIndex: IDL.Float64,
      formaTreasuryHealth: IDL.Float64,
      formaCreatorReserveIntegrity: IDL.Float64,
    })], ['query']),

    // ═══ ECONOMIC DOMAIN ═══
    getEconomicState: IDL.Func([], [IDL.Record({
      mintAccumulator: IDL.Float64,
      totalMinted: IDL.Float64,
      economicMultiplier: IDL.Float64,
    })], ['query']),

    getEconomicSystemState: IDL.Func([], [IDL.Record({
      formaBalance: IDL.Float64,
      mrcBalance: IDL.Float64,
      kntBalance: IDL.Float64,
      masterAccumulator: IDL.Float64,
      jacobsLevel: IDL.Nat,
      jacobsMultiplier: IDL.Float64,
      formaMintMod: IDL.Float64,
      formaBurnMod: IDL.Float64,
      formaCompoundMod: IDL.Float64,
      formaStabilityIdx: IDL.Float64,
      treasuryHealth: IDL.Float64,
      creatorReserveIntegrity: IDL.Float64,
      greedIndex: IDL.Float64,
      fearIndex: IDL.Float64,
      greedFearRatio: IDL.Float64,
      marketCorrelation: IDL.Float64,
      cascadeRisk: IDL.Float64,
      liquidityRouting: IDL.Nat,
      mintConsensus: IDL.Float64,
      burnConsensus: IDL.Float64,
      holdConsensus: IDL.Float64,
      economicLawCompliance: IDL.Float64,
    })], ['query']),

    getTokenOrganismStats: IDL.Func([], [IDL.Record({
      currentBeat: IDL.Nat,
      totalTokensGenerated: IDL.Nat,
      activeTokens: IDL.Nat,
      emergenceCount: IDL.Nat,
      globalCoherence: IDL.Float64,
      orderParameter: IDL.Float64,
      crossDimensionalFlow: IDL.Float64,
      heartbeatPhase: IDL.Float64,
      synchronizationIndex: IDL.Float64,
      microCoherence: IDL.Float64,
      mesoCoherence: IDL.Float64,
      macroCoherence: IDL.Float64,
    })], ['query']),

    // ═══ COGNITIVE DOMAIN ═══
    getPredictionSystemState: IDL.Func([], [IDL.Record({
      predictionError: IDL.Float64,
      predictionAccuracy: IDL.Float64,
      kalmanGain: IDL.Float64,
      achModulation: IDL.Float64,
      freeEnergy: IDL.Float64,
      complexityCost: IDL.Float64,
      accuracyCost: IDL.Float64,
      sparsityLevel: IDL.Float64,
      beeSparsification: IDL.Float64,
      shortTermError: IDL.Float64,
      mediumTermError: IDL.Float64,
      longTermError: IDL.Float64,
      chronoPrecisionFactor: IDL.Float64,
      predictionHorizon: IDL.Nat,
    })], ['query']),

    getLearningSystemState: IDL.Func([], [IDL.Record({
      tdError: IDL.Float64,
      valueFunctionV: IDL.Float64,
      learningRate: IDL.Float64,
      hebbianRate: IDL.Float64,
      stdpEnabled: IDL.Bool,
      bdnfScaling: IDL.Float64,
      ngfScaling: IDL.Float64,
      eiRatio: IDL.Float64,
      eiLearningModulation: IDL.Float64,
      glutamateLevel: IDL.Float64,
      gabaLevel: IDL.Float64,
      metaplasticityFactor: IDL.Float64,
      predictionErrorVariance: IDL.Float64,
      salienceLevel: IDL.Float64,
      achGating: IDL.Float64,
      neArousalGating: IDL.Float64,
      consolidationModulation: IDL.Float64,
      cortisolLevel: IDL.Float64,
      oxytocinLevel: IDL.Float64,
      vasopressinLevel: IDL.Float64,
      socialLearningBoost: IDL.Float64,
    })], ['query']),

    // ═══ SENSOR DOMAIN ═══
    getEcologicalState: IDL.Func([], [IDL.Record({
      lvPrey: IDL.Float64,
      lvPredator: IDL.Float64,
      stressLevel: IDL.Float64,
      hormeticZone: IDL.Bool,
      antifragility: IDL.Float64,
      victories: IDL.Nat,
    })], ['query']),

    getOrganismHealthReport: IDL.Func([], [IDL.Record({
      organismVitality: IDL.Float64,
      sphericalIntegrity: IDL.Float64,
      neuralHealth: IDL.Float64,
      neurochemicalHealth: IDL.Float64,
      quantumHealth: IDL.Float64,
      memoryHealth: IDL.Float64,
      learningHealth: IDL.Float64,
      economicHealth: IDL.Float64,
      socialHealth: IDL.Float64,
      defenseHealth: IDL.Float64,
      criticalWarnings: IDL.Vec(IDL.Text),
      coherenceScore: IDL.Float64,
      sovereigntyScore: IDL.Float64,
      jasmineScore: IDL.Float64,
      entropyLevel: IDL.Float64,
      beat: IDL.Nat,
      uptime: IDL.Nat,
      droneCount: IDL.Nat,
      sacrificeCount: IDL.Nat,
    })], ['query']),

    // ═══ FREQUENCY DOMAIN ═══
    getHzSpectrumState: IDL.Func([], [IDL.Record({
      hzModulations: IDL.Vec(IDL.Float64),
      koreFrequency: IDL.Float64,
      thalamicFrequency: IDL.Float64,
      rasLocusFrequency: IDL.Float64,
      vaelFrequency: IDL.Float64,
      spectrumPeakFrequency: IDL.Float64,
      spectrumAverageModulation: IDL.Float64,
      spectrumVariance: IDL.Float64,
    })], ['query']),

    getCircadianState: IDL.Func([], [IDL.Record({
      circadianPhase: IDL.Float64,
      timeOfDay: IDL.Float64,
      isNight: IDL.Bool,
      isDay: IDL.Bool,
      melatoninLevel: IDL.Float64,
      cortisolLevel: IDL.Float64,
      orexinLevel: IDL.Float64,
      adenosineLevel: IDL.Float64,
      sleepPressure: IDL.Float64,
      sleepMode: IDL.Bool,
      alignment: IDL.Float64,
      melatoninDeviation: IDL.Float64,
      cortisolDeviation: IDL.Float64,
      beatsUntilDreamCycle: IDL.Nat,
    })], ['query']),

    getKuramotoState: IDL.Func([], [IDL.Record({
      orderParam: IDL.Float64,
      meanPhase: IDL.Float64,
      globalK: IDL.Float64,
      chimera: IDL.Bool,
      phases: IDL.Vec(IDL.Float64),
    })], ['query']),

    // ═══ SOVEREIGNTY DOMAIN ═══
    getSovereigntyState: IDL.Func([], [IDL.Record({
      missionLock: IDL.Bool,
      courage: IDL.Float64,
      grounded: IDL.Float64,
      fear: IDL.Float64,
      missionPersistence: IDL.Float64,
      surrenderFloor: IDL.Float64,
      permanentFloor: IDL.Float64,
      streakMultiplier: IDL.Float64,
    })], ['query']),

    getCoreStates: IDL.Func([], [IDL.Record({
      totalCores: IDL.Nat,
      cipherSpikes: IDL.Vec(IDL.Bool),
      meanActivation: IDL.Float64,
      pheromoneLevel: IDL.Float64,
    })], ['query']),

    getDoctrineFingerprint: IDL.Func([], [IDL.Nat32], ['query']),

    // ═══ INTEGRATION DOMAIN ═══
    getShellIntegrationState: IDL.Func([], [IDL.Record({
      shell3ActiveNodes: IDL.Nat,
      shell3AverageActivation: IDL.Float64,
      shell3MaxActivation: IDL.Float64,
      shell3TotalWeightSum: IDL.Float64,
      shell3QuantumPhase: IDL.Float64,
      shell3QuantumCoherence: IDL.Float64,
      shell12ActiveNodes: IDL.Nat,
      shell12AverageActivation: IDL.Float64,
      shell12MaxActivation: IDL.Float64,
      shell12QuantumPhase: IDL.Float64,
      shell12QuantumCoherence: IDL.Float64,
      allShellPhases: IDL.Vec(IDL.Float64),
      allShellCoherences: IDL.Vec(IDL.Float64),
      allShellEnergies: IDL.Vec(IDL.Float64),
    })], ['query']),

    getAnimalIntelligenceOutputs: IDL.Func([], [IDL.Record({
      crow: IDL.Float64,
      octopus: IDL.Float64,
      elephant: IDL.Float64,
      bee: IDL.Float64,
      dolphin: IDL.Float64,
      mantis: IDL.Float64,
      spider: IDL.Float64,
      owl: IDL.Float64,
      shark: IDL.Float64,
      orca: IDL.Float64,
      wolf: IDL.Float64,
      eagle: IDL.Float64,
      totalAnimalContribution: IDL.Float64,
      status: IDL.Text,
    })], ['query']),

    getShellStates: IDL.Func([], [IDL.Record({
      shell1Coherence: IDL.Float64,
      shell2BasalTone: IDL.Float64,
      shell3MeanActivation: IDL.Float64,
      shell4Control: IDL.Float64,
      shell5Decision: IDL.Float64,
      shell6Yield: IDL.Float64,
      shell7Entropy: IDL.Float64,
      shell8Quantum: IDL.Float64,
      shell9MatriarchCoherence: IDL.Float64,
      shell10LineageDepth: IDL.Nat,
      shell11Mood: IDL.Float64,
    })], ['query']),

    // ═══ INTELLIGENCE DOMAIN ═══
    getAutonomousTeamStatus: IDL.Func([], [IDL.Record({
      backendHz: IDL.Float64,
      frontendHz: IDL.Float64,
      heartBrainSync: IDL.Float64,
      regulationQuality: IDL.Float64,
      emergencyDetected: IDL.Bool,
      brainCoherence: IDL.Float64,
      brainState: IDL.Text,
      dominantFrequency: IDL.Float64,
      deltaPower: IDL.Float64,
      thetaPower: IDL.Float64,
      alphaPower: IDL.Float64,
      betaPower: IDL.Float64,
      gammaPower: IDL.Float64,
      oxygenLevel: IDL.Float64,
      nutrientLevel: IDL.Float64,
      sphericalIntegrity: IDL.Float64,
      helixProtection: IDL.Float64,
      mergePower: IDL.Float64,
      learningRate: IDL.Float64,
      adaptationSpeed: IDL.Float64,
      cognitiveLoad: IDL.Float64,
      attentionLevel: IDL.Float64,
      consciousnessLevel: IDL.Float64,
      emotionalState: IDL.Text,
      teamActive: IDL.Bool,
      beatsActive: IDL.Nat,
      analysisQuality: IDL.Float64,
      reportsGenerated: IDL.Nat,
      nextReportBeat: IDL.Nat,
    })], ['query']),

    getOrganismTeamsState: IDL.Func([], [IDL.Record({
      archonCoherence: IDL.Float64,
      archonConsensus: IDL.Float64,
      archonVotes: IDL.Vec(IDL.Float64),
      archonMemberNames: IDL.Vec(IDL.Text),
      vectorConvergence: IDL.Float64,
      vectorSignals: IDL.Vec(IDL.Float64),
      vectorMemberNames: IDL.Vec(IDL.Text),
      vectorPassing: IDL.Bool,
      lumenWorldModelAccuracy: IDL.Float64,
      lumenActivations: IDL.Vec(IDL.Float64),
      forgeExecutionCapacity: IDL.Float64,
      forgeLabStates: IDL.Vec(IDL.Float64),
      forgeLabNames: IDL.Vec(IDL.Text),
    })], ['query']),

    // ═══ MATH DOMAIN ═══
    getUnifiedFieldState: IDL.Func([], [IDL.Record({
      psiCoherence: IDL.Float64,
      psiFear: IDL.Float64,
      psiEconomy: IDL.Float64,
      psiMemory: IDL.Float64,
      psiSovereignty: IDL.Float64,
      goldenRatio: IDL.Float64,
      fibonacciCurrent: IDL.Nat,
      primeCount: IDL.Nat,
      permanentFloor: IDL.Float64,
      ancientLawCompliance: IDL.Float64,
    })], ['query']),
  });
};

// ═══════════════════════════════════════════════════════════════════════════════
// DOMAIN TYPE INTERFACES
// ═══════════════════════════════════════════════════════════════════════════════

// ═══ DEFENSE TYPES ═══
export interface AEGISState {
  threatLevel: number;
  defenseActive: boolean;
  lastAlertBeat: number;
  protectedValues: number[];
}

export interface WarDefenseModeState {
  mode: string;
  posture: number;
  threatScore: number;
  gateStrictness: number;
  containmentDepth: number;
  rollbackTier: number;
  interfaceLockdown: boolean;
  continuityScore: number;
  coherenceScore: number;
  integrityScore: number;
  driftScore: number;
  bypassScore: number;
  escapeScore: number;
  sentinelSensitivity: number;
  verifierStrength: number;
  gatekeeperStrictness: number;
  resonanceQuality: number;
  cartographerThreatsTracked: number;
  guardianShieldsActive: boolean;
  restorerRecoveryReady: boolean;
  scoutsDeployed: number;
  adversariesProfiled: number;
  trapsDeployed: number;
  huntsActive: number;
  pathwaysCut: number;
  dislocationsExecuted: number;
  spoofCampaignsDetected: number;
  evidenceChainsBuilt: number;
  resilienceSignals: number;
  campaignsActive: number;
}

export interface CounterforceStatus {
  overallEffectiveness: number;
  adversaryPressure: number;
  coordinationQuality: number;
  scoutCoverage: number;
  profilerAccuracy: number;
  hunterSuccessRate: number;
  activeCampaigns: number;
  totalThreatsFound: number;
}

export interface OffenseDefenseStatus {
  architectureFlowIntegrity: number;
  offensivePower: number;
  defensivePower: number;
  intelligenceQuality: number;
  offenseDefenseBalance: number;
  coordinationQuality: number;
  energized: boolean;
  dronesDeployed: number;
  cyberAttackVectors: number;
  honeypotsActive: number;
  shieldStrength: number;
  threatsActive: number;
}

// ═══ MEMORY TYPES ═══
export interface MemorySystemState {
  qmemFidelity: number;
  qmemT2Time: number;
  timeSinceReset: number;
  dreamCycleActive: boolean;
  consolidationThreshold: number;
  replayFrequency: number;
  isRestState: boolean;
  bdnfLevel: number;
  ngfLevel: number;
  memoryPotentiation: number;
  plasticityRate: number;
  shell3ActiveNodes: number;
  shell3AverageActivation: number;
  shell3MaxActivation: number;
  shell12ActiveNodes: number;
  shell12AverageActivation: number;
  shell12MaxActivation: number;
  shell3ToShell12TransferRate: number;
  shell12ToShell3RetrievalRate: number;
  emotionalMemoryBoost: number;
}

export interface MemoryState {
  traceCount: number;
  responseWeights: number[];
}

// ═══ GOVERNANCE TYPES ═══
export interface LawComplianceState {
  lawGroup0Compliance: number;
  lawGroup1Compliance: number;
  lawGroup2Compliance: number;
  lawGroup3Compliance: number;
  lawGroup4Compliance: number;
  overallCompliance: number;
  veritasStabilizers: number[];
  veritasSyndromes: number[];
  highRiskLaws: number[];
  violationCount: number;
  totalReEntrainments: number;
  quantumLawCompliance: number[];
  quantumViolationRisks: number[];
}

export interface LawsSnapshot {
  scores: number[];
  compliance: number;
  passing: number;
  fingerprint: number;
  jacobsRung: number;
  multiplier: number;
}

export interface SecurityStatus {
  lockdownActive: boolean;
  lockdownLevel: string;
  securityScore: number;
  encryptionCoverage: number;
  fleetExpanded: boolean;
  readyForLaunch: boolean;
  modelsUpdated: number;
  totalExposures: number;
  remediatedExposures: number;
}

// ═══ NEURAL TYPES ═══
export interface NeuralCoreState {
  coreActivations: number[];
  coreOutputs: number[];
  corePhases: number[];
  corePlasticity: number[];
  globalSynchrony: number;
  coreNeuroDynamics: number;
  animalIntelligence: number;
  emergenceStack: number;
  cognitiveStack: number;
  defenseStack: number;
  productionStack: number;
  neuralStatus: string;
}

export interface BrainRegionStates {
  prefrontalControl: number;
  basalGangliaSelection: number;
  thalamusRelay: number;
  hippocampusMemory: number;
  amygdalaSalience: number;
  cerebellumTiming: number;
  workingMemoryLoad: number;
  selectedAction: number;
  fearResponse: number;
  rewardResponse: number;
}

export interface NeurotransmitterState {
  gaba: number;
  glutamate: number;
  endorphin: number;
  oxytocin: number;
  cortisol: number;
  adrenaline: number;
  melatonin: number;
  histamine: number;
  substanceP: number;
  adenosine: number;
  anandamide: number;
  dynorphin: number;
  vasopressin: number;
  npy: number;
  orexin: number;
  bdnf: number;
  ngf: number;
  stressLevel: number;
  rewardLevel: number;
  eiRatio: number;
  arousalLevel: number;
  memoryPotentiation: number;
  balanceIndex: number;
  plasticityRate: number;
  totalUpdates: number;
}

// ═══ QUANTUM TYPES ═══
export interface QuantumOperatorStates {
  superposition: number;
  entanglement: number;
  interference: number;
  tunneling: number;
  decoherence: number;
  measurement: number;
  zeno: number;
  quantumWalk: number;
  bellViolation: number;
  purity: number;
}

export interface SphericalQuantumState {
  sphericalIntegrity: number;
  organismVitality: number;
  hzKore: number;
  hzThalamic: number;
  hzRASLocus: number;
  hzVael: number;
  shellPhases: number[];
  shellCoherences: number[];
  shellEnergies: number[];
  animalWeights: number[];
  beeSwarmBoost: number;
  elephantMemoryFidelity: number;
  sharkPredatorPath: number;
  crowCognitionDecision: number;
  lawComplianceScores: number[];
  lawViolationRisks: number[];
  overallCompliance: number;
  councilKuramotoR: number[];
  councilBellViolations: number[];
  councilQSOVContributions: number[];
  vetusDefenseBoosts: number[];
  vetusEvasionPaths: number[];
  vetusResponseTimes: number[];
  aegisIntegrities: number[];
  aegisSovereignty: number;
  aegisCoherence: number;
  aegisMemory: number;
  formaMintModulation: number;
  formaBurnModulation: number;
  formaCompoundModulation: number;
  formaStabilityIndex: number;
  formaTreasuryHealth: number;
  formaCreatorReserveIntegrity: number;
}

// ═══ ECONOMIC TYPES ═══
export interface EconomicState {
  mintAccumulator: number;
  totalMinted: number;
  economicMultiplier: number;
}

export interface EconomicSystemState {
  formaBalance: number;
  mrcBalance: number;
  kntBalance: number;
  masterAccumulator: number;
  jacobsLevel: number;
  jacobsMultiplier: number;
  formaMintMod: number;
  formaBurnMod: number;
  formaCompoundMod: number;
  formaStabilityIdx: number;
  treasuryHealth: number;
  creatorReserveIntegrity: number;
  greedIndex: number;
  fearIndex: number;
  greedFearRatio: number;
  marketCorrelation: number;
  cascadeRisk: number;
  liquidityRouting: number;
  mintConsensus: number;
  burnConsensus: number;
  holdConsensus: number;
  economicLawCompliance: number;
}

export interface TokenOrganismStats {
  currentBeat: number;
  totalTokensGenerated: number;
  activeTokens: number;
  emergenceCount: number;
  globalCoherence: number;
  orderParameter: number;
  crossDimensionalFlow: number;
  heartbeatPhase: number;
  synchronizationIndex: number;
  microCoherence: number;
  mesoCoherence: number;
  macroCoherence: number;
}

// ═══ COGNITIVE TYPES ═══
export interface PredictionSystemState {
  predictionError: number;
  predictionAccuracy: number;
  kalmanGain: number;
  achModulation: number;
  freeEnergy: number;
  complexityCost: number;
  accuracyCost: number;
  sparsityLevel: number;
  beeSparsification: number;
  shortTermError: number;
  mediumTermError: number;
  longTermError: number;
  chronoPrecisionFactor: number;
  predictionHorizon: number;
}

export interface LearningSystemState {
  tdError: number;
  valueFunctionV: number;
  learningRate: number;
  hebbianRate: number;
  stdpEnabled: boolean;
  bdnfScaling: number;
  ngfScaling: number;
  eiRatio: number;
  eiLearningModulation: number;
  glutamateLevel: number;
  gabaLevel: number;
  metaplasticityFactor: number;
  predictionErrorVariance: number;
  salienceLevel: number;
  achGating: number;
  neArousalGating: number;
  consolidationModulation: number;
  cortisolLevel: number;
  oxytocinLevel: number;
  vasopressinLevel: number;
  socialLearningBoost: number;
}

// ═══ SENSOR TYPES ═══
export interface EcologicalState {
  lvPrey: number;
  lvPredator: number;
  stressLevel: number;
  hormeticZone: boolean;
  antifragility: number;
  victories: number;
}

export interface OrganismHealthReport {
  organismVitality: number;
  sphericalIntegrity: number;
  neuralHealth: number;
  neurochemicalHealth: number;
  quantumHealth: number;
  memoryHealth: number;
  learningHealth: number;
  economicHealth: number;
  socialHealth: number;
  defenseHealth: number;
  criticalWarnings: string[];
  coherenceScore: number;
  sovereigntyScore: number;
  jasmineScore: number;
  entropyLevel: number;
  beat: number;
  uptime: number;
  droneCount: number;
  sacrificeCount: number;
}

// ═══ FREQUENCY TYPES ═══
export interface HzSpectrumState {
  hzModulations: number[];
  koreFrequency: number;
  thalamicFrequency: number;
  rasLocusFrequency: number;
  vaelFrequency: number;
  spectrumPeakFrequency: number;
  spectrumAverageModulation: number;
  spectrumVariance: number;
}

export interface CircadianState {
  circadianPhase: number;
  timeOfDay: number;
  isNight: boolean;
  isDay: boolean;
  melatoninLevel: number;
  cortisolLevel: number;
  orexinLevel: number;
  adenosineLevel: number;
  sleepPressure: number;
  sleepMode: boolean;
  alignment: number;
  melatoninDeviation: number;
  cortisolDeviation: number;
  beatsUntilDreamCycle: number;
}

export interface KuramotoState {
  orderParam: number;
  meanPhase: number;
  globalK: number;
  chimera: boolean;
  phases: number[];
}

// ═══ SOVEREIGNTY TYPES ═══
export interface SovereigntyState {
  missionLock: boolean;
  courage: number;
  grounded: number;
  fear: number;
  missionPersistence: number;
  surrenderFloor: number;
  permanentFloor: number;
  streakMultiplier: number;
}

export interface CoreStates {
  totalCores: number;
  cipherSpikes: boolean[];
  meanActivation: number;
  pheromoneLevel: number;
}

// ═══ INTEGRATION TYPES ═══
export interface ShellIntegrationState {
  shell3ActiveNodes: number;
  shell3AverageActivation: number;
  shell3MaxActivation: number;
  shell3TotalWeightSum: number;
  shell3QuantumPhase: number;
  shell3QuantumCoherence: number;
  shell12ActiveNodes: number;
  shell12AverageActivation: number;
  shell12MaxActivation: number;
  shell12QuantumPhase: number;
  shell12QuantumCoherence: number;
  allShellPhases: number[];
  allShellCoherences: number[];
  allShellEnergies: number[];
}

export interface AnimalIntelligenceOutputs {
  crow: number;
  octopus: number;
  elephant: number;
  bee: number;
  dolphin: number;
  mantis: number;
  spider: number;
  owl: number;
  shark: number;
  orca: number;
  wolf: number;
  eagle: number;
  totalAnimalContribution: number;
  status: string;
}

export interface ShellStates {
  shell1Coherence: number;
  shell2BasalTone: number;
  shell3MeanActivation: number;
  shell4Control: number;
  shell5Decision: number;
  shell6Yield: number;
  shell7Entropy: number;
  shell8Quantum: number;
  shell9MatriarchCoherence: number;
  shell10LineageDepth: number;
  shell11Mood: number;
}

// ═══ INTELLIGENCE TYPES ═══
export interface AutonomousTeamStatus {
  backendHz: number;
  frontendHz: number;
  heartBrainSync: number;
  regulationQuality: number;
  emergencyDetected: boolean;
  brainCoherence: number;
  brainState: string;
  dominantFrequency: number;
  deltaPower: number;
  thetaPower: number;
  alphaPower: number;
  betaPower: number;
  gammaPower: number;
  oxygenLevel: number;
  nutrientLevel: number;
  sphericalIntegrity: number;
  helixProtection: number;
  mergePower: number;
  learningRate: number;
  adaptationSpeed: number;
  cognitiveLoad: number;
  attentionLevel: number;
  consciousnessLevel: number;
  emotionalState: string;
  teamActive: boolean;
  beatsActive: number;
  analysisQuality: number;
  reportsGenerated: number;
  nextReportBeat: number;
}

export interface OrganismTeamsState {
  archonCoherence: number;
  archonConsensus: number;
  archonVotes: number[];
  archonMemberNames: string[];
  vectorConvergence: number;
  vectorSignals: number[];
  vectorMemberNames: string[];
  vectorPassing: boolean;
  lumenWorldModelAccuracy: number;
  lumenActivations: number[];
  forgeExecutionCapacity: number;
  forgeLabStates: number[];
  forgeLabNames: string[];
}

// ═══ MATH TYPES ═══
export interface UnifiedFieldState {
  psiCoherence: number;
  psiFear: number;
  psiEconomy: number;
  psiMemory: number;
  psiSovereignty: number;
  goldenRatio: number;
  fibonacciCurrent: number;
  primeCount: number;
  permanentFloor: number;
  ancientLawCompliance: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SWARM BRAIN ACTOR INTERFACE
// ═══════════════════════════════════════════════════════════════════════════════

export interface SwarmBrainActor {
  // Queries
  getSwarmSnapshot: () => Promise<SwarmSnapshot>;
  getExtendedSnapshot: () => Promise<ExtendedSnapshot>;
  getSwarmQMetrics: () => Promise<SwarmQMetrics>;
  getQuantumHeartbeatState: () => Promise<QuantumHeartbeatState>;
  getCardioCerebralState: () => Promise<CardioCerebralState>;
  getGeoResonanceProtectionState: () => Promise<GeoResonanceProtectionState>;
  getCardioNeuralConversionOrganState: () => Promise<CardioNeuralConversionOrganState>;
  getAutonomousAnalystTeamState: () => Promise<AutonomousAnalystTeamState>;
  getMemoryTempleState: () => Promise<MemoryTempleState>;
  getConstantFeedbackCognitionState: () => Promise<ConstantFeedbackCognitionState>;
  getDroneCount: () => Promise<bigint>;
  getRSwarm: () => Promise<number>;
  getJDrift: () => Promise<number>;
  getCurrentBeat: () => Promise<bigint>;
  getArchitectSignalLevel: () => Promise<number>;
  getComplianceScore: () => Promise<number>;
  getFrequencyTier: () => Promise<{ tier: string; hz: number }>;
  getOmnisFired: () => Promise<boolean>;
  getOmnisCount: () => Promise<bigint>;
  getOrganismState: () => Promise<OrganismState>;
  
  // ═══ DEFENSE ═══
  getAEGISState: () => Promise<AEGISState>;
  getWarDefenseModeState: () => Promise<WarDefenseModeState>;
  getCounterforceStatus: () => Promise<CounterforceStatus>;
  getOffenseDefenseStatus: () => Promise<OffenseDefenseStatus>;
  // ═══ MEMORY ═══
  getMemorySystemState: () => Promise<MemorySystemState>;
  getMemoryState: () => Promise<MemoryState>;
  // ═══ GOVERNANCE ═══
  getLawComplianceState: () => Promise<LawComplianceState>;
  getLawsSnapshot: () => Promise<LawsSnapshot>;
  getSecurityStatus: () => Promise<SecurityStatus>;
  // ═══ NEURAL ═══
  getNeuralCoreState: () => Promise<NeuralCoreState>;
  getBrainRegionStates: () => Promise<BrainRegionStates>;
  getNeurotransmitterState: () => Promise<NeurotransmitterState>;
  // ═══ QUANTUM ═══
  getQuantumOperatorStates: () => Promise<QuantumOperatorStates>;
  getSphericalQuantumState: () => Promise<SphericalQuantumState>;
  // ═══ ECONOMIC ═══
  getEconomicState: () => Promise<EconomicState>;
  getEconomicSystemState: () => Promise<EconomicSystemState>;
  getTokenOrganismStats: () => Promise<TokenOrganismStats>;
  // ═══ COGNITIVE ═══
  getPredictionSystemState: () => Promise<PredictionSystemState>;
  getLearningSystemState: () => Promise<LearningSystemState>;
  // ═══ SENSOR ═══
  getEcologicalState: () => Promise<EcologicalState>;
  getOrganismHealthReport: () => Promise<OrganismHealthReport>;
  // ═══ FREQUENCY ═══
  getHzSpectrumState: () => Promise<HzSpectrumState>;
  getCircadianState: () => Promise<CircadianState>;
  getKuramotoState: () => Promise<KuramotoState>;
  // ═══ SOVEREIGNTY ═══
  getSovereigntyState: () => Promise<SovereigntyState>;
  getCoreStates: () => Promise<CoreStates>;
  getDoctrineFingerprint: () => Promise<number>;
  // ═══ INTEGRATION ═══
  getShellIntegrationState: () => Promise<ShellIntegrationState>;
  getAnimalIntelligenceOutputs: () => Promise<AnimalIntelligenceOutputs>;
  getShellStates: () => Promise<ShellStates>;
  // ═══ INTELLIGENCE ═══
  getAutonomousTeamStatus: () => Promise<AutonomousTeamStatus>;
  getOrganismTeamsState: () => Promise<OrganismTeamsState>;
  // ═══ MATH ═══
  getUnifiedFieldState: () => Promise<UnifiedFieldState>;
  
  // Control
  tick: () => Promise<TickResult>;
  masterHeartbeat: () => Promise<void>;
  setArchitectSignalLevel: (level: number) => Promise<void>;
  addDrone: (droneClass: string, omega: number, x: number, y: number, z: number) => Promise<bigint>;
  executeSacrifice: (id: bigint) => Promise<boolean>;
  updatePosition: (id: bigint, x: number, y: number, z: number) => Promise<void>;
  broadcastNeurochemical: (kind: string, amount: number) => Promise<void>;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SINGLETON ACTOR INSTANCE
// ═══════════════════════════════════════════════════════════════════════════════

let swarmBrainActor: SwarmBrainActor | null = null;
let agent: HttpAgent | null = null;
let connectionPromise: Promise<SwarmBrainActor> | null = null;

/**
 * Get or create the HTTP agent for canister communication
 */
async function getAgent(): Promise<HttpAgent> {
  if (agent) return agent;
  
  // Determine host based on environment
  const isLocal = typeof import.meta !== 'undefined' && 
    (import.meta.env?.DEV || import.meta.env?.MODE === 'development');
  const host = isLocal ? 'http://127.0.0.1:8000' : 'https://ic0.app';
  
  agent = new HttpAgent({ host });
  
  // Fetch root key for local development (NOT for production!)
  if (isLocal) {
    await agent.fetchRootKey();
  }
  
  return agent;
}

/**
 * Connect to the swarm_brain canister and return the actor
 * This is the REAL connection - no mocks
 */
export async function connectSwarmBrain(): Promise<SwarmBrainActor> {
  // Return existing actor if connected
  if (swarmBrainActor) return swarmBrainActor;
  
  // Return in-progress connection if one exists
  if (connectionPromise) return connectionPromise;
  
  // Start new connection
  connectionPromise = (async () => {
    try {
      console.log('[SwarmBrainActor] Connecting to canister:', SWARM_BRAIN_CANISTER_ID);
      
      const httpAgent = await getAgent();
      
      swarmBrainActor = Actor.createActor(swarmBrainIDLFactory, {
        agent: httpAgent,
        canisterId: Principal.fromText(SWARM_BRAIN_CANISTER_ID),
      }) as unknown as SwarmBrainActor;
      
      // Test connection
      const beat = await swarmBrainActor.getCurrentBeat();
      console.log('[SwarmBrainActor] Connected! Current beat:', beat.toString());
      
      return swarmBrainActor;
    } catch (error) {
      console.error('[SwarmBrainActor] Connection failed:', error);
      swarmBrainActor = null;
      throw error;
    } finally {
      connectionPromise = null;
    }
  })();
  
  return connectionPromise;
}

/**
 * Get the current actor instance (may be null if not connected)
 */
export function getSwarmBrainActor(): SwarmBrainActor | null {
  return swarmBrainActor;
}

/**
 * Check if connected to backend
 */
export function isConnectedToBackend(): boolean {
  return swarmBrainActor !== null;
}

/**
 * Disconnect from backend
 */
export function disconnectSwarmBrain(): void {
  swarmBrainActor = null;
  agent = null;
  console.log('[SwarmBrainActor] Disconnected');
}

// ═══════════════════════════════════════════════════════════════════════════════
// CONVENIENCE FUNCTIONS — Direct canister calls
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Fetch the full swarm snapshot from backend
 * This is the primary way to get organism state
 */
export async function fetchSwarmSnapshot(): Promise<SwarmSnapshot | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.getSwarmSnapshot();
  } catch (error) {
    console.error('[SwarmBrainActor] fetchSwarmSnapshot failed:', error);
    return null;
  }
}

/**
 * Fetch extended snapshot with OMNIS and frequency tier
 */
export async function fetchExtendedSnapshot(): Promise<ExtendedSnapshot | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.getExtendedSnapshot();
  } catch (error) {
    console.error('[SwarmBrainActor] fetchExtendedSnapshot failed:', error);
    return null;
  }
}

/**
 * Fetch organism-level state
 */
export async function fetchOrganismState(): Promise<OrganismState | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.getOrganismState();
  } catch (error) {
    console.error('[SwarmBrainActor] fetchOrganismState failed:', error);
    return null;
  }
}

/**
 * Fetch geo-resonance protection engine state
 */
export async function fetchGeoResonanceProtectionState(): Promise<GeoResonanceProtectionState | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.getGeoResonanceProtectionState();
  } catch (error) {
    console.error('[SwarmBrainActor] fetchGeoResonanceProtectionState failed:', error);
    return null;
  }
}

/**
 * Fetch cardio-neural conversion organ state
 */
export async function fetchCardioNeuralConversionOrganState(): Promise<CardioNeuralConversionOrganState | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.getCardioNeuralConversionOrganState();
  } catch (error) {
    console.error('[SwarmBrainActor] fetchCardioNeuralConversionOrganState failed:', error);
    return null;
  }
}

/**
 * Fetch autonomous analyst team state
 */
export async function fetchAutonomousAnalystTeamState(): Promise<AutonomousAnalystTeamState | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.getAutonomousAnalystTeamState();
  } catch (error) {
    console.error('[SwarmBrainActor] fetchAutonomousAnalystTeamState failed:', error);
    return null;
  }
}

/**
 * Fetch memory temple state
 */
export async function fetchMemoryTempleState(): Promise<MemoryTempleState | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.getMemoryTempleState();
  } catch (error) {
    console.error('[SwarmBrainActor] fetchMemoryTempleState failed:', error);
    return null;
  }
}

/**
 * Fetch constant feedback cognition state
 */
export async function fetchConstantFeedbackCognitionState(): Promise<ConstantFeedbackCognitionState | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.getConstantFeedbackCognitionState();
  } catch (error) {
    console.error('[SwarmBrainActor] fetchConstantFeedbackCognitionState failed:', error);
    return null;
  }
}

/**
 * Trigger a backend tick
 */
export async function triggerTick(): Promise<TickResult | null> {
  try {
    const actor = await connectSwarmBrain();
    return await actor.tick();
  } catch (error) {
    console.error('[SwarmBrainActor] triggerTick failed:', error);
    return null;
  }
}

/**
 * Trigger master heartbeat
 */
export async function triggerHeartbeat(): Promise<void> {
  try {
    const actor = await connectSwarmBrain();
    await actor.masterHeartbeat();
  } catch (error) {
    console.error('[SwarmBrainActor] triggerHeartbeat failed:', error);
  }
}

/**
 * Set architect signal level
 */
export async function setArchitectSignal(level: number): Promise<void> {
  try {
    const actor = await connectSwarmBrain();
    await actor.setArchitectSignalLevel(level);
  } catch (error) {
    console.error('[SwarmBrainActor] setArchitectSignal failed:', error);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORT DEFAULT
// ═══════════════════════════════════════════════════════════════════════════════

export default {
  connect: connectSwarmBrain,
  getActor: getSwarmBrainActor,
  isConnected: isConnectedToBackend,
  disconnect: disconnectSwarmBrain,
  fetchSwarmSnapshot,
  fetchExtendedSnapshot,
  fetchOrganismState,
  fetchGeoResonanceProtectionState,
  fetchCardioNeuralConversionOrganState,
  fetchAutonomousAnalystTeamState,
  fetchMemoryTempleState,
  fetchConstantFeedbackCognitionState,
  triggerTick,
  triggerHeartbeat,
  setArchitectSignal,
};
