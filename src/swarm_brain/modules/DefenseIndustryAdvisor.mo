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
// Module: DefenseIndustryAdvisor — Defense Applications Organism
// Classification: CONFIDENTIAL — INTERNAL USE ONLY
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited. All rights reserved.
//
// Patent Pending: Specialized Advisor Organism Architecture
// ============================================================================
//
// PURPOSE:
// Specialized advisor organism for defense industry applications.
// Uses same Kuramoto-Hebbian architecture with weights tuned for:
// - Threat detection and assessment
// - Tactical and strategic planning
// - Mission execution and ROE compliance
// - SBIR/STTR opportunity identification
//
// CLASSIFICATION NOTE:
// This module does NOT process classified information.
// All inputs/outputs are UNCLASSIFIED.
// For classified applications, deploy on appropriate networks.
//
// OUTCALL DOMAINS (when HTTP enabled):
// - Defense.gov, DARPA (solicitations)
// - SBIR.gov (opportunities)
// - Public military doctrine sources
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";

module {

  // ══════════════════════════════════════════════════════════════
  // MEDINA CONSTANTS (Shared with main organism)
  // ══════════════════════════════════════════════════════════════
  let PHI_MEDINA : Float = 2.97442179;
  let OMEGA_MEDINA : Float = 2.11185;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let SIGMA_ZERO : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;

  // Defense Industry Advisor Specialization
  let THREAT_WEIGHT : Float = 0.95;       // Threat detection priority
  let TACTICAL_WEIGHT : Float = 0.9;      // Tactical planning focus
  let RESILIENCE_WEIGHT : Float = 0.85;   // System resilience emphasis
  let AGGRESSION_WEIGHT : Float = 0.6;    // Moderate aggression (defensive)
  let COMPLIANCE_WEIGHT : Float = 0.9;    // Rules of engagement compliance

  // ══════════════════════════════════════════════════════════════
  // DEFENSE DOMAINS
  // ══════════════════════════════════════════════════════════════
  public type DefenseDomain = {
    #AirDominance;
    #GroundOperations;
    #MaritimeOperations;
    #SpaceOperations;
    #CyberWarfare;
    #ElectronicWarfare;
    #CBRN;              // Chemical, Biological, Radiological, Nuclear
    #ISR;               // Intelligence, Surveillance, Reconnaissance
    #Logistics;
    #CommandControl;
    #ForceProtection;
    #SpecialOperations;
    #UnmannedSystems;
    #HybridWarfare;
  };

  public let DEFENSE_DOMAIN_NAMES : [Text] = [
    "AirDominance", "GroundOperations", "MaritimeOperations", "SpaceOperations",
    "CyberWarfare", "ElectronicWarfare", "CBRN", "ISR", "Logistics",
    "CommandControl", "ForceProtection", "SpecialOperations", 
    "UnmannedSystems", "HybridWarfare"
  ];

  // ══════════════════════════════════════════════════════════════
  // THREAT CLASSIFICATION
  // ══════════════════════════════════════════════════════════════
  public type ThreatLevel = {
    #DEFCON5;    // Lowest readiness
    #DEFCON4;    // Increased intelligence
    #DEFCON3;    // Increase in readiness above normal
    #DEFCON2;    // Armed forces ready to deploy in 6 hours
    #DEFCON1;    // Nuclear war imminent
  };

  public type ThreatCategory = {
    #NearPeer;           // Major power adversary
    #RegionalPower;      // Regional adversary
    #NonStateActor;      // Terrorist, militia
    #Cyber;              // Digital threat
    #Environmental;      // Natural disaster, climate
    #Internal;           // Insider threat
  };

  public type ThreatAssessment = {
    id              : Nat;
    category        : ThreatCategory;
    level           : ThreatLevel;
    description     : Text;
    probability     : Float;      // 0-1 likelihood
    impact          : Float;      // 0-1 severity
    timeToImpact    : ?Nat;       // Beats until threat materializes
    countermeasures : [Text];
    lastUpdated     : Nat;
    confidence      : Float;      // Assessment confidence
  };

  // ══════════════════════════════════════════════════════════════
  // MISSION PLANNING
  // ══════════════════════════════════════════════════════════════
  public type MissionType = {
    #Reconnaissance;
    #Surveillance;
    #Strike;
    #Transport;
    #SearchAndRescue;
    #EW;                 // Electronic Warfare
    #SEAD;               // Suppression of Enemy Air Defense
    #CAS;                // Close Air Support
    #CAP;                // Combat Air Patrol
    #ISR;
    #Training;
    #Humanitarian;
  };

  public type MissionPhase = {
    #Planning;
    #Briefing;
    #Departure;
    #Transit;
    #OnStation;
    #Engagement;
    #Egress;
    #Recovery;
    #Debrief;
  };

  public type MissionPlan = {
    id              : Nat;
    missionType     : MissionType;
    phase           : MissionPhase;
    objectives      : [Text];
    constraints     : [Text];     // Rules of engagement, limitations
    resources       : [Text];     // Assigned assets
    timeline        : [Nat];      // Phase durations in beats
    riskAssessment  : Float;      // 0-1 risk level
    successProb     : Float;      // 0-1 success probability
    alternativePlans: [Nat];      // Backup plan IDs
    createdAt       : Nat;
    lastModified    : Nat;
  };

  // ══════════════════════════════════════════════════════════════
  // SBIR/STTR OPPORTUNITY TRACKING
  // ══════════════════════════════════════════════════════════════
  public type OpportunityType = {
    #SBIR_Phase1;
    #SBIR_Phase2;
    #SBIR_Phase3;
    #STTR_Phase1;
    #STTR_Phase2;
    #DirectContract;
    #BAA;                // Broad Agency Announcement
    #RFI;                // Request for Information
    #RFP;                // Request for Proposal
  };

  public type DefenseOpportunity = {
    id              : Nat;
    opportunityType : OpportunityType;
    agency          : Text;       // DoD, DARPA, Army, Navy, Air Force, etc.
    topic           : Text;
    description     : Text;
    deadline        : ?Nat;       // Timestamp
    fundingAmount   : Float;      // Estimated value
    matchScore      : Float;      // 0-1 fit with our capabilities
    status          : Text;       // Watching, Pursuing, Applied, Won, Lost
    relevantDomains : [DefenseDomain];
    notes           : Text;
  };

  // ══════════════════════════════════════════════════════════════
  // ADVISOR BRAIN STATE (Defense-Specialized)
  // ══════════════════════════════════════════════════════════════
  public type DefenseAdvisorBrainNode = {
    activation      : Float;
    potential       : Float;
    refractoryPeriod: Nat;
    lastFired       : Nat;
    threatBias      : Float;      // How threat-focused this node is
  };

  public type DefenseAdvisorBrain = {
    // 8-node specialized architecture
    threatNode      : DefenseAdvisorBrainNode;   // Threat detection
    tacticalNode    : DefenseAdvisorBrainNode;   // Tactical planning
    strategicNode   : DefenseAdvisorBrainNode;   // Strategic thinking
    logisticsNode   : DefenseAdvisorBrainNode;   // Resource management
    intelNode       : DefenseAdvisorBrainNode;   // Intelligence analysis
    complianceNode  : DefenseAdvisorBrainNode;   // ROE compliance
    resilienceNode  : DefenseAdvisorBrainNode;   // System resilience
    integrationNode : DefenseAdvisorBrainNode;   // Cross-domain synthesis

    // Hebbian weights (8x8 = 64 connections)
    weights         : [var Float];

    // Kuramoto phase oscillators
    phases          : [var Float];
    frequencies     : [Float];

    // Global state
    coherence       : Float;
    alertLevel      : Float;      // Current threat alert
    beatNum         : Nat;
  };

  // ══════════════════════════════════════════════════════════════
  // ADVISOR STATE
  // ══════════════════════════════════════════════════════════════
  public type DefenseAdvisorState = {
    // Core identity
    advisorId       : Nat;
    generation      : Nat;
    birthBeat       : Nat;
    
    // Brain
    brain           : DefenseAdvisorBrain;
    
    // Threat tracking
    activeThreats   : [ThreatAssessment];
    threatHistory   : [ThreatAssessment];
    currentThreatLevel: ThreatLevel;
    
    // Mission planning
    activeMissions  : [MissionPlan];
    missionHistory  : [Nat];      // Completed mission IDs
    
    // Opportunities
    opportunities   : [DefenseOpportunity];
    totalFundingTracked: Float;
    
    // Current focus
    activeDomains   : [DefenseDomain];
    currentQuery    : ?Text;
    queryHistory    : [Text];
    
    // Integration with main organism
    feedToOrganism  : [Text];     // Commands for swarm
    feedFromOrganism: [Text];     // Telemetry from swarm
    syncLevel       : Float;      // Coupling to main organism
    
    // Output metrics
    threatsDetected : Nat;
    missionsPlanned : Nat;
    missionsCompleted: Nat;
    missionSuccessRate: Float;
    
    // Advisor genome (defense-specialized)
    threatGene      : Float;
    tacticalGene    : Float;
    resilienceGene  : Float;
    aggressionGene  : Float;
    complianceGene  : Float;
    
    beatNum         : Nat;
  };

  // ══════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func exp(x: Float) : Float { Float.exp(x) };
  func ln(x: Float) : Float { Float.log(x) };
  func sqrt(x: Float) : Float { Float.sqrt(x) };
  func sin(x: Float) : Float { Float.sin(x) };
  func cos(x: Float) : Float { Float.cos(x) };

  let PI : Float = 3.14159265358979;
  let TWO_PI : Float = 6.28318530717958;

  // ══════════════════════════════════════════════════════════════
  // THREAT PROBABILITY COMPUTATION
  // ══════════════════════════════════════════════════════════════
  // The Medina Threat Equation:
  //   P(threat) = σ_M(capability × intent × opportunity - defenses)
  //   σ_M(x) = 1 / (1 + exp(-Φ_M × x))

  public func medinaSigmoid(x: Float) : Float {
    1.0 / (1.0 + exp(-PHI_MEDINA * x))
  };

  public func computeThreatProbability(
    capability: Float,    // 0-1 enemy capability
    intent: Float,        // 0-1 enemy intent
    opportunity: Float,   // 0-1 environmental factors
    defenses: Float       // 0-1 our defensive posture
  ) : Float {
    let threatPotential = capability * intent * opportunity - defenses;
    medinaSigmoid(threatPotential)
  };

  // ══════════════════════════════════════════════════════════════
  // MISSION SUCCESS PROBABILITY
  // ══════════════════════════════════════════════════════════════
  // Medina Mission Success Law:
  //   P(success) = coherence × readiness × intel_quality × (1 - threat_level)
  //   Boosted by Φ_M when all factors > 0.8 (synergy bonus)

  public func computeMissionSuccess(
    coherence: Float,
    readiness: Float,
    intelQuality: Float,
    threatLevel: Float
  ) : Float {
    let baseProbability = coherence * readiness * intelQuality * (1.0 - threatLevel * 0.5);
    
    // Synergy bonus if all factors are high
    let synergyBonus = if (coherence > 0.8 and readiness > 0.8 and intelQuality > 0.8) {
      PHI_MEDINA * 0.1  // ~30% bonus
    } else { 0.0 };

    _clamp(baseProbability + synergyBonus, 0.0, 0.99)
  };

  // ══════════════════════════════════════════════════════════════
  // KURAMOTO SYNC (Defense-Specialized)
  // ══════════════════════════════════════════════════════════════
  public func computeDefenseCoherence(phases: [var Float]) : Float {
    let n = phases.size();
    if (n == 0) { return SIGMA_ZERO };

    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;

    for (i in phases.keys()) {
      sumCos += cos(phases[i]);
      sumSin += sin(phases[i]);
    };

    let r = sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n);
    _clamp(r, SIGMA_ZERO, 1.0)
  };

  public func updateDefensePhases(
    phases: [var Float],
    frequencies: [Float],
    couplingK: Float,
    alertLevel: Float,  // Higher alert = tighter coupling
    dt: Float
  ) : () {
    let n = phases.size();
    if (n == 0) { return };

    // Adaptive coupling: increases with alert level
    let adaptiveK = couplingK * (1.0 + alertLevel);

    // Compute mean phase
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (i in phases.keys()) {
      sumCos += cos(phases[i]);
      sumSin += sin(phases[i]);
    };
    let meanPhase = Float.arctan2(sumSin, sumCos);
    let r = sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n);

    // Update each phase
    for (i in phases.keys()) {
      let coupling = adaptiveK * r * sin(meanPhase - phases[i]);
      var newPhase = phases[i] + (frequencies[i] + coupling) * dt;
      while (newPhase < 0.0) { newPhase += TWO_PI };
      while (newPhase >= TWO_PI) { newPhase -= TWO_PI };
      phases[i] := newPhase;
    };
  };

  // ══════════════════════════════════════════════════════════════
  // HEBBIAN LEARNING (Defense-Specialized)
  // ══════════════════════════════════════════════════════════════
  // Threat-biased Hebbian: connections strengthen faster for threat-related activity

  public func defenseHebbianUpdate(
    weights: [var Float],
    preActivations: [Float],
    postActivations: [Float],
    learningRate: Float,
    threatBias: Float  // 0-1 how much to emphasize threat learning
  ) : () {
    let n = preActivations.size();
    if (n * n != weights.size()) { return };

    let eta = learningRate * (1.0 + threatBias * 0.5);
    let lambda = 0.005;  // Lower decay for defense (retain more)

    for (i in preActivations.keys()) {
      for (j in postActivations.keys()) {
        let idx = i * n + j;
        let delta = eta * preActivations[i] * postActivations[j] - lambda * weights[idx];
        weights[idx] := _clamp(weights[idx] + delta, -2.0, 2.0);
      };
    };
  };

  // ══════════════════════════════════════════════════════════════
  // RULES OF ENGAGEMENT COMPLIANCE
  // ══════════════════════════════════════════════════════════════
  public type ROELevel = {
    #Weapons_Hold;       // Do not fire unless directly threatened
    #Weapons_Tight;      // Fire only at positively identified threats
    #Weapons_Free;       // Fire at any unidentified target
  };

  public type ROECheck = {
    action          : Text;
    permitted       : Bool;
    roeLevel        : ROELevel;
    reasoning       : Text;
    overrideReason  : ?Text;
  };

  public func checkROECompliance(
    proposedAction: Text,
    currentROE: ROELevel,
    threatConfirmed: Bool,
    friendlyInArea: Bool
  ) : ROECheck {
    switch (currentROE) {
      case (#Weapons_Hold) {
        {
          action = proposedAction;
          permitted = false;
          roeLevel = currentROE;
          reasoning = "Weapons Hold: Only self-defense permitted";
          overrideReason = null;
        }
      };
      case (#Weapons_Tight) {
        let permitted = threatConfirmed and not friendlyInArea;
        {
          action = proposedAction;
          permitted = permitted;
          roeLevel = currentROE;
          reasoning = if (permitted) "Threat confirmed, no friendlies" else "ROE not satisfied";
          overrideReason = null;
        }
      };
      case (#Weapons_Free) {
        {
          action = proposedAction;
          permitted = not friendlyInArea;
          roeLevel = currentROE;
          reasoning = if (not friendlyInArea) "Weapons Free, area clear" else "Friendlies in area";
          overrideReason = null;
        }
      };
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SBIR/STTR MATCHING
  // ══════════════════════════════════════════════════════════════
  // Score how well an opportunity matches our capabilities

  public func computeOpportunityMatch(
    opportunity: DefenseOpportunity,
    ourCapabilities: [DefenseDomain],
    coherenceLevel: Float
  ) : Float {
    var domainMatch : Float = 0.0;
    var matchCount : Nat = 0;

    // Count domain overlaps
    for (oppDomain in opportunity.relevantDomains.vals()) {
      for (ourDomain in ourCapabilities.vals()) {
        // Would need proper comparison; simplified here
        matchCount += 1;
      };
    };

    // Base match from domain overlap
    if (opportunity.relevantDomains.size() > 0) {
      domainMatch := Float.fromInt(matchCount) / Float.fromInt(opportunity.relevantDomains.size());
    };

    // Boost by coherence (more coherent = better execution)
    _clamp(domainMatch * coherenceLevel * PHI_MEDINA / 3.0, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // ORGANISM COMMUNICATION PROTOCOL
  // ══════════════════════════════════════════════════════════════
  public type DefenseMessage = {
    #ThreatAlert : ThreatAssessment;
    #MissionOrder : MissionPlan;
    #ROEUpdate : ROELevel;
    #Opportunity : DefenseOpportunity;
    #SituationReport : { summary: Text; threatLevel: ThreatLevel; coherence: Float };
    #SyncRequest : { targetCoherence: Float; urgency: Float };
    #SyncAck : { achievedCoherence: Float };
  };

  public type OrganismTelemetry = {
    #DroneStatus : { droneId: Nat; position: (Float, Float, Float); health: Float };
    #SwarmCoherence : Float;
    #ThreatDetected : { bearing: Float; distance: Float; confidence: Float };
    #MissionProgress : { missionId: Nat; phase: MissionPhase; completion: Float };
    #EngagementReport : { target: Text; result: Text };
  };

  // ══════════════════════════════════════════════════════════════
  // BEAT FUNCTION — ADVISOR TICK
  // ══════════════════════════════════════════════════════════════
  public func beatDefenseAdvisor(state: DefenseAdvisorState, dt: Float) : DefenseAdvisorState {
    // 1. Compute current alert level from active threats
    var maxThreat : Float = 0.0;
    for (threat in state.activeThreats.vals()) {
      let threatScore = threat.probability * threat.impact;
      if (threatScore > maxThreat) { maxThreat := threatScore };
    };
    let alertLevel = _clamp(maxThreat, 0.0, 1.0);

    // 2. Update Kuramoto phases with adaptive coupling
    updateDefensePhases(
      state.brain.phases,
      state.brain.frequencies,
      0.618 * state.syncLevel,
      alertLevel,
      dt
    );

    // 3. Compute new coherence
    let newCoherence = computeDefenseCoherence(state.brain.phases);

    // 4. Get node activations
    let activations = Array.tabulate<Float>(8, func(i) {
      if (i < state.brain.phases.size()) {
        (cos(state.brain.phases[i]) + 1.0) / 2.0
      } else { 0.5 }
    });

    // 5. Defense Hebbian update (threat-biased)
    defenseHebbianUpdate(
      state.brain.weights,
      activations,
      activations,
      0.08,  // Slightly lower base learning rate
      alertLevel  // Higher alert = faster threat learning
    );

    // Return updated state
    {
      advisorId = state.advisorId;
      generation = state.generation;
      birthBeat = state.birthBeat;
      brain = {
        threatNode = state.brain.threatNode;
        tacticalNode = state.brain.tacticalNode;
        strategicNode = state.brain.strategicNode;
        logisticsNode = state.brain.logisticsNode;
        intelNode = state.brain.intelNode;
        complianceNode = state.brain.complianceNode;
        resilienceNode = state.brain.resilienceNode;
        integrationNode = state.brain.integrationNode;
        weights = state.brain.weights;
        phases = state.brain.phases;
        frequencies = state.brain.frequencies;
        coherence = newCoherence;
        alertLevel = alertLevel;
        beatNum = state.brain.beatNum + 1;
      };
      activeThreats = state.activeThreats;
      threatHistory = state.threatHistory;
      currentThreatLevel = state.currentThreatLevel;
      activeMissions = state.activeMissions;
      missionHistory = state.missionHistory;
      opportunities = state.opportunities;
      totalFundingTracked = state.totalFundingTracked;
      activeDomains = state.activeDomains;
      currentQuery = state.currentQuery;
      queryHistory = state.queryHistory;
      feedToOrganism = state.feedToOrganism;
      feedFromOrganism = state.feedFromOrganism;
      syncLevel = state.syncLevel;
      threatsDetected = state.threatsDetected;
      missionsPlanned = state.missionsPlanned;
      missionsCompleted = state.missionsCompleted;
      missionSuccessRate = state.missionSuccessRate;
      threatGene = state.threatGene;
      tacticalGene = state.tacticalGene;
      resilienceGene = state.resilienceGene;
      aggressionGene = state.aggressionGene;
      complianceGene = state.complianceGene;
      beatNum = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════
  func initDefenseBrainNode(threatBias: Float) : DefenseAdvisorBrainNode {
    {
      activation = 0.5;
      potential = 0.0;
      refractoryPeriod = 0;
      lastFired = 0;
      threatBias = threatBias;
    }
  };

  public func initDefenseAdvisor() : DefenseAdvisorState {
    // Initialize 8x8 = 64 weights
    let weights = Array.init<Float>(64, 0.15);  // Slightly higher baseline

    // Initialize 8 phases
    let phases = Array.init<Float>(8, 0.0);
    for (i in phases.keys()) {
      phases[i] := Float.fromInt(i) * TWO_PI / 8.0;
    };

    // Defense-specialized frequencies
    let frequencies : [Float] = [
      0.15,  // Threat - fast response
      0.12,  // Tactical - quick planning
      0.06,  // Strategic - deliberate
      0.08,  // Logistics - steady
      0.10,  // Intel - responsive
      0.05,  // Compliance - careful
      0.07,  // Resilience - stable
      0.04   // Integration - very deliberate
    ];

    {
      advisorId = 0;
      generation = 0;
      birthBeat = 0;
      brain = {
        threatNode = initDefenseBrainNode(1.0);      // Maximum threat focus
        tacticalNode = initDefenseBrainNode(0.7);
        strategicNode = initDefenseBrainNode(0.5);
        logisticsNode = initDefenseBrainNode(0.3);
        intelNode = initDefenseBrainNode(0.8);
        complianceNode = initDefenseBrainNode(0.2);
        resilienceNode = initDefenseBrainNode(0.6);
        integrationNode = initDefenseBrainNode(0.4);
        weights = weights;
        phases = phases;
        frequencies = frequencies;
        coherence = SIGMA_ZERO;
        alertLevel = 0.0;
        beatNum = 0;
      };
      activeThreats = [];
      threatHistory = [];
      currentThreatLevel = #DEFCON5;
      activeMissions = [];
      missionHistory = [];
      opportunities = [];
      totalFundingTracked = 0.0;
      activeDomains = [#UnmannedSystems, #ISR, #CommandControl];
      currentQuery = null;
      queryHistory = [];
      feedToOrganism = [];
      feedFromOrganism = [];
      syncLevel = 0.618;
      threatsDetected = 0;
      missionsPlanned = 0;
      missionsCompleted = 0;
      missionSuccessRate = 0.0;
      threatGene = THREAT_WEIGHT;
      tacticalGene = TACTICAL_WEIGHT;
      resilienceGene = RESILIENCE_WEIGHT;
      aggressionGene = AGGRESSION_WEIGHT;
      complianceGene = COMPLIANCE_WEIGHT;
      beatNum = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA DEFENSE DOCTRINE LAW
  // ══════════════════════════════════════════════════════════════
  // "Effective defense emerges from the synthesis of threat awareness,
  //  tactical flexibility, and unwavering coherence, scaled by the
  //  golden ratio of preparedness to response."
  //
  // FORMAL STATEMENT:
  //   E_defense = Φ_M × √(awareness × flexibility × coherence) × (1 - complacency)
  //
  // Original contribution by Alfredo Medina Hernandez

  public func computeDefenseEffectiveness(
    awareness: Float,    // 0-1 threat awareness
    flexibility: Float,  // 0-1 tactical flexibility  
    coherence: Float,    // 0-1 system coherence
    complacency: Float   // 0-1 how complacent (bad)
  ) : Float {
    let productTerm = awareness * flexibility * coherence;
    let vigilance = 1.0 - complacency;
    
    PHI_MEDINA * sqrt(productTerm) * vigilance / 3.0  // Normalized to ~1.0 max
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
  //  R E A L - T I M E   S Y S T E M S   M A T H E M A T I C S
  //
  //  Enterprise-Level Real-Time Processing and Control
  //  Full HIM/HER 60Hz Synchronization Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // CONTROL SYSTEMS
  // ─────────────────────────────────────────────────────────────────────────────

  /// PID controller output
  public func controlPID(
    error : Float,
    integral : Float,
    derivative : Float,
    kP : Float,
    kI : Float,
    kD : Float
  ) : Float {
    kP * error + kI * integral + kD * derivative
  };

  /// PID integral update with anti-windup
  public func controlIntegralUpdate(
    integral : Float,
    error : Float,
    dt : Float,
    maxIntegral : Float
  ) : Float {
    let newIntegral = integral + error * dt;
    if (newIntegral > maxIntegral) { maxIntegral }
    else if (newIntegral < -maxIntegral) { -maxIntegral }
    else { newIntegral }
  };

  /// PID derivative calculation with filtering
  public func controlDerivative(
    error : Float,
    prevError : Float,
    prevDerivative : Float,
    dt : Float,
    filterCoeff : Float
  ) : Float {
    let rawDerivative = (error - prevError) / dt;
    filterCoeff * rawDerivative + (1.0 - filterCoeff) * prevDerivative
  };

  /// State space model: x(k+1) = Ax(k) + Bu(k)
  public func controlStateUpdate(
    state : Float,
    input : Float,
    a : Float,
    b : Float
  ) : Float {
    a * state + b * input
  };

  /// Observer state estimation
  public func controlObserver(
    estimatedState : Float,
    measurement : Float,
    predicted : Float,
    observerGain : Float
  ) : Float {
    estimatedState + observerGain * (measurement - predicted)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SCHEDULING AND TIMING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rate monotonic priority
  public func schedulingRMPriority(period : Float) : Float {
    1.0 / period
  };

  /// Deadline miss probability (simplified)
  public func schedulingDeadlineMissProb(
    wcet : Float,
    period : Float,
    utilization : Float
  ) : Float {
    let slack = period - wcet;
    if (slack <= 0.0) { 1.0 }
    else { utilization * wcet / slack }
  };

  /// Response time analysis
  public func schedulingResponseTime(
    wcet : Float,
    period : Float,
    higherPriorityLoad : Float
  ) : Float {
    wcet / (1.0 - higherPriorityLoad)
  };

  /// Jitter calculation
  public func schedulingJitter(
    timestamps : [Float]
  ) : Float {
    if (timestamps.size() < 2) { return 0.0 };
    var sumDiff : Float = 0.0;
    var prevDiff : Float = timestamps[1] - timestamps[0];
    var maxJitter : Float = 0.0;
    var i = 2;
    while (i < timestamps.size()) {
      let diff = timestamps[i] - timestamps[i-1];
      let jitter = Float.abs(diff - prevDiff);
      if (jitter > maxJitter) { maxJitter := jitter };
      prevDiff := diff;
      i += 1;
    };
    maxJitter
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SIGNAL PROCESSING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Low-pass filter (exponential moving average)
  public func signalLowPass(
    current : Float,
    newSample : Float,
    alpha : Float
  ) : Float {
    alpha * newSample + (1.0 - alpha) * current
  };

  /// High-pass filter
  public func signalHighPass(
    current : Float,
    newSample : Float,
    prevSample : Float,
    alpha : Float
  ) : Float {
    alpha * (current + newSample - prevSample)
  };

  /// Band-pass filter (cascade)
  public func signalBandPass(
    value : Float,
    lowState : Float,
    highState : Float,
    alphaLow : Float,
    alphaHigh : Float
  ) : (Float, Float, Float) {
    let low = signalLowPass(lowState, value, alphaLow);
    let high = alphaHigh * (highState + value - lowState);
    (high, low, high)
  };

  /// Median filter (3-sample)
  public func signalMedian3(a : Float, b : Float, c : Float) : Float {
    if ((a <= b and b <= c) or (c <= b and b <= a)) { b }
    else if ((b <= a and a <= c) or (c <= a and a <= b)) { a }
    else { c }
  };

  /// Signal power
  public func signalPower(samples : [Float]) : Float {
    if (samples.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < samples.size()) {
      sum += samples[i] * samples[i];
      i += 1;
    };
    sum / Float.fromInt(samples.size())
  };

  /// Signal-to-noise ratio
  public func signalSNR(signalPower : Float, noisePower : Float) : Float {
    if (noisePower < 0.0001) { 100.0 }
    else { 10.0 * Float.log(signalPower / noisePower) / Float.log(10.0) }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SYNCHRONIZATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Phase-locked loop error
  public func syncPLLError(
    referencePhase : Float,
    outputPhase : Float
  ) : Float {
    let diff = referencePhase - outputPhase;
    Float.sin(diff)  // Sinusoidal phase detector
  };

  /// PLL VCO output
  public func syncVCO(
    centerFreq : Float,
    controlSignal : Float,
    gain : Float,
    time : Float
  ) : Float {
    Float.sin(2.0 * 3.14159265 * (centerFreq + gain * controlSignal) * time)
  };

  /// Clock drift compensation
  public func syncClockDrift(
    localTime : Float,
    referenceTime : Float,
    driftRate : Float
  ) : Float {
    localTime + (referenceTime - localTime) * driftRate
  };

  /// Frame synchronization correlation
  public func syncFrameCorrelation(
    received : [Float],
    syncPattern : [Float]
  ) : Float {
    let n = if (received.size() < syncPattern.size()) received.size() else syncPattern.size();
    if (n == 0) { return 0.0 };
    var corr : Float = 0.0;
    var i = 0;
    while (i < n) {
      corr += received[i] * syncPattern[i];
      i += 1;
    };
    corr
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BUFFER MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Buffer fill level
  public func bufferFillLevel(count : Nat, capacity : Nat) : Float {
    if (capacity == 0) { 0.0 }
    else { Float.fromInt(count) / Float.fromInt(capacity) }
  };

  /// Buffer underrun risk
  public func bufferUnderrunRisk(
    fillLevel : Float,
    drainRate : Float,
    fillRate : Float
  ) : Float {
    if (fillRate >= drainRate) { 0.0 }
    else { (drainRate - fillRate) / drainRate * (1.0 - fillLevel) }
  };

  /// Adaptive buffer size
  public func bufferAdaptiveSize(
    currentSize : Nat,
    avgLatency : Float,
    targetLatency : Float,
    stepSize : Nat
  ) : Nat {
    if (avgLatency > targetLatency * 1.1) {
      currentSize + stepSize
    } else if (avgLatency < targetLatency * 0.9 and currentSize > stepSize) {
      currentSize - stepSize
    } else {
      currentSize
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // 60 HZ FRAME TIMING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Frame time at 60 Hz
  public let FRAME_TIME_60HZ : Float = 1.0 / 60.0;

  /// Frame number from time
  public func frameNumberFromTime(time : Float) : Nat {
    Int.abs(Float.toInt(time / FRAME_TIME_60HZ))
  };

  /// Time within frame
  public func framePhase(time : Float) : Float {
    let frameNum = Float.fromInt(frameNumberFromTime(time));
    (time - frameNum * FRAME_TIME_60HZ) / FRAME_TIME_60HZ
  };

  /// Frame deadline remaining
  public func frameDeadlineRemaining(currentTime : Float, frameStart : Float) : Float {
    let deadline = frameStart + FRAME_TIME_60HZ;
    deadline - currentTime
  };

  /// Frame skip detection
  public func frameSkipDetected(prevFrame : Nat, currentFrame : Nat) : Bool {
    currentFrame > prevFrame + 1
  };

}
