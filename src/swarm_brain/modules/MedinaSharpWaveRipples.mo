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
// Module: MedinaSharpWaveRipples — Memory Consolidation from Neuroscience
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
// SHARP-WAVE RIPPLES — MEMORY CONSOLIDATION SYSTEM
// ============================================================================
//
// Based on Paper 1: Hippocampal Sharp-Wave Ripples, Dentate Spikes, Bilateral Synchrony
//
// KEY FINDINGS IMPLEMENTED:
// - SPW-Rs support memory consolidation
// - They fire in bouts when parasympathetic tone is high (slow breathing = calm state)
// - Roughly 90% of Dentate Spikes are unilateral
// - Half of SPW-Rs are unilateral
// - Bilateral synchrony is state-dependent: high when calm, disrupted when alert
//
// APPLICATION TO ORGANISM:
// The agent system has two modes:
// 1. ACTIVE EXECUTION STATE: Many open tasks, high workload
//    - Agents operate independently per department (unilateral, specialized)
// 2. CONSOLIDATION STATE: End of day, project phase completion, low activity
//    - Agents synchronize across departments
//    - Share learnings
//    - Generate cross-departmental summaries and artifacts
//
// This is the memory consolidation rhythm of the organism.
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";
import Iter  "mo:base/Iter";
import Time  "mo:base/Time";

module {

  // ==========================================================================
  // CONSTANTS — FROM NEUROSCIENCE RESEARCH
  // ==========================================================================
  
  // SPW-R characteristics
  let SPW_R_FREQUENCY_HZ : Float = 150.0;        // Sharp-wave ripple frequency
  let SPW_R_DURATION_MS : Float = 80.0;          // Typical duration
  let DENTATE_SPIKE_UNILATERAL_RATE : Float = 0.9; // 90% unilateral
  let SPW_R_UNILATERAL_RATE : Float = 0.5;        // 50% unilateral
  
  // State thresholds
  let CALM_STATE_THRESHOLD : Float = 0.3;         // Parasympathetic dominance
  let ALERT_STATE_THRESHOLD : Float = 0.7;        // Sympathetic dominance
  let CONSOLIDATION_ACTIVITY_THRESHOLD : Float = 0.2; // Low activity threshold
  
  // Synchrony parameters
  let MAX_BILATERAL_SYNCHRONY : Float = 0.95;
  let MIN_BILATERAL_SYNCHRONY : Float = 0.1;
  let ACETYLCHOLINE_DISRUPTION_FACTOR : Float = 0.6;
  
  // Memory consolidation
  let CONSOLIDATION_BOOST : Float = 1.5;
  let REPLAY_COMPRESSION_FACTOR : Float = 20.0;   // Time compression during replay
  
  // Medina constants
  let PHI_MEDINA : Float = 2.97442179;
  let GOLDEN_RATIO : Float = 1.618033988749;
  
  // FNV hash
  let FNV_PRIME : Nat32 = 16777619;
  let FNV_OFFSET : Nat32 = 2166136261;

  // ==========================================================================
  // ORGANISM STATE TYPES
  // ==========================================================================
  
  public type OrganismActivityState = {
    #ActiveExecution;   // High workload, agents work independently
    #Consolidation;     // Low activity, agents synchronize
    #Transition;        // Moving between states
  };

  public type DepartmentActivity = {
    departmentId    : Nat;
    departmentName  : Text;
    openTasks       : Nat;
    completedTasks  : Nat;
    activityLevel   : Float;          // 0.0-1.0
    lastActiveTime  : Int;
    agentCount      : Nat;
  };

  // ==========================================================================
  // SHARP-WAVE RIPPLE EVENT TYPES
  // ==========================================================================
  
  public type RippleEvent = {
    rippleId        : Nat;
    timestamp       : Int;
    duration_ms     : Float;
    frequency_hz    : Float;
    amplitude       : Float;
    isUnilateral    : Bool;
    departmentId    : ?Nat;           // Which department if unilateral
    memoriesReplayed : Nat;
    consolidationStrength : Float;
  };

  public type DentateSpike = {
    spikeId         : Nat;
    timestamp       : Int;
    isUnilateral    : Bool;
    targetDepartment : ?Nat;
    triggerStrength : Float;
    associatedRipple : ?Nat;          // Which ripple it triggered
  };

  // ==========================================================================
  // MEMORY TRACE TYPES
  // ==========================================================================
  
  public type MemoryTrace = {
    traceId         : Nat;
    creationTime    : Int;
    content         : MemoryContent;
    strength        : Float;          // 0.0-1.0 how strong the memory
    consolidationCount : Nat;         // How many times consolidated
    lastReplayTime  : Int;
    departmentOrigin : Nat;
    crossDepartmental : Bool;         // Involves multiple departments
    linkedTraces    : [Nat];          // Related memories
  };

  public type MemoryContent = {
    #TaskCompletion : { taskId: Nat; outcome: Text; duration: Nat };
    #Decision : { decisionId: Nat; context: Text; choice: Text; result: Text };
    #Pattern : { patternId: Nat; description: Text; occurrences: Nat };
    #CrossDepartment : { departments: [Nat]; interaction: Text; outcome: Text };
    #Learning : { lesson: Text; source: Text; applicability: Float };
  };

  // ==========================================================================
  // BILATERAL SYNCHRONY STATE
  // ==========================================================================
  
  public type BilateralSynchronyState = {
    currentSynchrony : Float;         // 0.0-1.0 how synchronized
    targetSynchrony  : Float;
    autonomicTone    : Float;         // -1 (parasympathetic) to +1 (sympathetic)
    acetylcholineLevel : Float;       // 0.0-1.0
    synchronyHistory : [Float];       // Recent synchrony values
    lastUpdateTime   : Int;
  };

  // ==========================================================================
  // CONSOLIDATION SESSION
  // ==========================================================================
  
  public type ConsolidationSession = {
    sessionId       : Nat;
    startTime       : Int;
    endTime         : ?Int;
    rippleEvents    : [RippleEvent];
    dentateSpikes   : [DentateSpike];
    memoriesProcessed : Nat;
    crossDepartmentalSummaries : [CrossDepartmentSummary];
    learningsGenerated : [Learning];
    state           : ConsolidationSessionState;
  };

  public type ConsolidationSessionState = {
    #Active;
    #Completed;
    #Interrupted;
  };

  public type CrossDepartmentSummary = {
    summaryId       : Nat;
    departments     : [Nat];
    keyInsights     : [Text];
    sharedPatterns  : [Nat];          // Pattern trace IDs
    recommendations : [Text];
    generatedAt     : Int;
  };

  public type Learning = {
    learningId      : Nat;
    description     : Text;
    sourceDepartments : [Nat];
    applicableTo    : [Nat];          // Which departments can use this
    confidence      : Float;
    generatedAt     : Int;
  };

  // ==========================================================================
  // MAIN STATE TYPE
  // ==========================================================================
  
  public type SharpWaveRipplesState = {
    // Current state
    activityState   : OrganismActivityState;
    synchronyState  : BilateralSynchronyState;
    
    // Departments
    departments     : [DepartmentActivity];
    
    // Memory storage
    memoryTraces    : [MemoryTrace];
    maxTraces       : Nat;
    traceWriteIndex : Nat;
    
    // Event history
    rippleHistory   : [RippleEvent];
    spikeHistory    : [DentateSpike];
    maxEvents       : Nat;
    rippleWriteIndex : Nat;
    spikeWriteIndex : Nat;
    
    // Consolidation sessions
    currentSession  : ?ConsolidationSession;
    pastSessions    : [ConsolidationSession];
    
    // Metrics
    totalRipples    : Nat;
    totalSpikes     : Nat;
    totalConsolidations : Nat;
    beatNum         : Nat;
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initSharpWaveRipples(departmentNames: [Text]) : SharpWaveRipplesState {
    let departments = Array.tabulate<DepartmentActivity>(departmentNames.size(), func(i: Nat) : DepartmentActivity {
      {
        departmentId = i;
        departmentName = departmentNames[i];
        openTasks = 0;
        completedTasks = 0;
        activityLevel = 0.5;
        lastActiveTime = Time.now();
        agentCount = 3;  // Default agent count
      }
    });
    
    {
      activityState = #Transition;
      synchronyState = {
        currentSynchrony = 0.5;
        targetSynchrony = 0.5;
        autonomicTone = 0.0;
        acetylcholineLevel = 0.5;
        synchronyHistory = [];
        lastUpdateTime = Time.now();
      };
      departments = departments;
      memoryTraces = [];
      maxTraces = 10000;
      traceWriteIndex = 0;
      rippleHistory = [];
      spikeHistory = [];
      maxEvents = 1000;
      rippleWriteIndex = 0;
      spikeWriteIndex = 0;
      currentSession = null;
      pastSessions = [];
      totalRipples = 0;
      totalSpikes = 0;
      totalConsolidations = 0;
      beatNum = 0;
    }
  };

  // ==========================================================================
  // ACTIVITY STATE DETECTION
  // ==========================================================================
  
  // Calculate overall organism activity level
  public func calculateActivityLevel(departments: [DepartmentActivity]) : Float {
    if (departments.size() == 0) { return 0.5 };
    
    var totalActivity : Float = 0.0;
    var totalWeight : Float = 0.0;
    
    for (dept in departments.vals()) {
      let weight = Float.fromInt(dept.agentCount);
      totalActivity += dept.activityLevel * weight;
      totalWeight += weight;
    };
    
    if (totalWeight == 0.0) { 0.5 }
    else { totalActivity / totalWeight }
  };

  // Determine if organism should be in consolidation mode
  public func shouldConsolidate(
    activityLevel: Float,
    autonomicTone: Float,
    timeSinceLastConsolidation: Int
  ) : Bool {
    // Low activity
    let lowActivity = activityLevel < CONSOLIDATION_ACTIVITY_THRESHOLD;
    
    // Parasympathetic dominance (calm state)
    let calmState = autonomicTone < CALM_STATE_THRESHOLD;
    
    // Enough time has passed (at least 1 hour = 3.6e12 nanoseconds)
    let enoughTime = timeSinceLastConsolidation > 3_600_000_000_000;
    
    lowActivity and calmState and enoughTime
  };

  // Update activity state
  public func updateActivityState(
    state: SharpWaveRipplesState,
    currentTime: Int
  ) : SharpWaveRipplesState {
    let activityLevel = calculateActivityLevel(state.departments);
    
    let lastConsolidationTime = switch (state.currentSession) {
      case (?session) { session.startTime };
      case null { 
        if (state.pastSessions.size() > 0) {
          switch (state.pastSessions[state.pastSessions.size() - 1].endTime) {
            case (?t) { t };
            case null { 0 };
          }
        } else { 0 }
      };
    };
    
    let timeSinceLastConsolidation = currentTime - lastConsolidationTime;
    
    let shouldBeConsolidating = shouldConsolidate(
      activityLevel,
      state.synchronyState.autonomicTone,
      timeSinceLastConsolidation
    );
    
    let newState = if (shouldBeConsolidating) {
      #Consolidation
    } else if (activityLevel > ALERT_STATE_THRESHOLD) {
      #ActiveExecution
    } else {
      #Transition
    };
    
    { state with activityState = newState }
  };

  // ==========================================================================
  // BILATERAL SYNCHRONY DYNAMICS
  // ==========================================================================
  
  // Calculate target synchrony based on autonomic state
  public func calculateTargetSynchrony(
    autonomicTone: Float,
    acetylcholineLevel: Float
  ) : Float {
    // High parasympathetic (negative tone) = high synchrony
    // High sympathetic (positive tone) = low synchrony
    // High acetylcholine disrupts synchrony
    
    let baseTarget = (1.0 - autonomicTone) / 2.0;  // Convert -1/+1 to 1.0/0.0
    let acDisruption = acetylcholineLevel * ACETYLCHOLINE_DISRUPTION_FACTOR;
    
    Float.max(MIN_BILATERAL_SYNCHRONY, 
      Float.min(MAX_BILATERAL_SYNCHRONY, baseTarget - acDisruption))
  };

  // Update synchrony state
  public func updateSynchrony(
    state: BilateralSynchronyState,
    dt: Float
  ) : BilateralSynchronyState {
    let targetSynchrony = calculateTargetSynchrony(
      state.autonomicTone,
      state.acetylcholineLevel
    );
    
    // Smoothly move toward target
    let syncRate = 0.1;
    let newSynchrony = state.currentSynchrony + syncRate * (targetSynchrony - state.currentSynchrony) * dt;
    
    // Update history
    let newHistory = if (state.synchronyHistory.size() >= 100) {
      Array.tabulate<Float>(100, func(i: Nat) : Float {
        if (i < 99) { state.synchronyHistory[i + 1] }
        else { newSynchrony }
      })
    } else {
      Array.append(state.synchronyHistory, [newSynchrony])
    };
    
    {
      state with
      currentSynchrony = Float.max(0.0, Float.min(1.0, newSynchrony));
      targetSynchrony = targetSynchrony;
      synchronyHistory = newHistory;
      lastUpdateTime = Time.now();
    }
  };

  // ==========================================================================
  // SHARP-WAVE RIPPLE GENERATION
  // ==========================================================================
  
  // Check if conditions are right for ripple generation
  public func shouldGenerateRipple(
    activityState: OrganismActivityState,
    synchrony: Float,
    autonomicTone: Float
  ) : Bool {
    switch (activityState) {
      case (#Consolidation) {
        // More likely during consolidation, especially with high synchrony
        synchrony > 0.6 and autonomicTone < 0.0
      };
      case (_) {
        // Can still occur during other states, but less likely
        synchrony > 0.8 and autonomicTone < -0.3
      };
    }
  };

  // Generate a ripple event
  public func generateRipple(
    state: SharpWaveRipplesState,
    currentTime: Int
  ) : (SharpWaveRipplesState, RippleEvent) {
    // Determine if unilateral based on state
    let isUnilateral = if (state.synchronyState.currentSynchrony < 0.5) {
      true  // Low synchrony = more likely unilateral
    } else {
      // 50% chance as per research
      (state.totalRipples % 2) == 0
    };
    
    // If unilateral, pick a department
    let targetDept : ?Nat = if (isUnilateral) {
      if (state.departments.size() > 0) {
        ?(state.totalRipples % state.departments.size())
      } else { null }
    } else { null };
    
    // Calculate replay count based on synchrony and consolidation state
    let baseReplayCount = switch (state.activityState) {
      case (#Consolidation) { 10 };
      case (#Transition) { 5 };
      case (#ActiveExecution) { 2 };
    };
    let memoriesReplayed = Int.abs(Float.toInt(Float.fromInt(baseReplayCount) * state.synchronyState.currentSynchrony * CONSOLIDATION_BOOST));
    
    let ripple : RippleEvent = {
      rippleId = state.totalRipples;
      timestamp = currentTime;
      duration_ms = SPW_R_DURATION_MS * (0.8 + state.synchronyState.currentSynchrony * 0.4);
      frequency_hz = SPW_R_FREQUENCY_HZ;
      amplitude = state.synchronyState.currentSynchrony;
      isUnilateral = isUnilateral;
      departmentId = targetDept;
      memoriesReplayed = memoriesReplayed;
      consolidationStrength = state.synchronyState.currentSynchrony * CONSOLIDATION_BOOST;
    };
    
    let newHistory = Array.append(state.rippleHistory, [ripple]);
    let trimmedHistory = if (newHistory.size() > state.maxEvents) {
      Array.tabulate<RippleEvent>(state.maxEvents, func(i: Nat) : RippleEvent {
        newHistory[newHistory.size() - state.maxEvents + i]
      })
    } else { newHistory };
    
    let newState : SharpWaveRipplesState = {
      state with
      rippleHistory = trimmedHistory;
      rippleWriteIndex = (state.rippleWriteIndex + 1) % state.maxEvents;
      totalRipples = state.totalRipples + 1;
    };
    
    (newState, ripple)
  };

  // ==========================================================================
  // DENTATE SPIKE GENERATION
  // ==========================================================================
  
  public func generateDentateSpike(
    state: SharpWaveRipplesState,
    currentTime: Int,
    triggeredRipple: ?Nat
  ) : (SharpWaveRipplesState, DentateSpike) {
    // 90% unilateral as per research
    let isUnilateral = (state.totalSpikes % 10) != 0;
    
    let targetDept : ?Nat = if (isUnilateral) {
      if (state.departments.size() > 0) {
        ?(state.totalSpikes % state.departments.size())
      } else { null }
    } else { null };
    
    let spike : DentateSpike = {
      spikeId = state.totalSpikes;
      timestamp = currentTime;
      isUnilateral = isUnilateral;
      targetDepartment = targetDept;
      triggerStrength = 0.5 + state.synchronyState.currentSynchrony * 0.5;
      associatedRipple = triggeredRipple;
    };
    
    let newHistory = Array.append(state.spikeHistory, [spike]);
    let trimmedHistory = if (newHistory.size() > state.maxEvents) {
      Array.tabulate<DentateSpike>(state.maxEvents, func(i: Nat) : DentateSpike {
        newHistory[newHistory.size() - state.maxEvents + i]
      })
    } else { newHistory };
    
    let newState : SharpWaveRipplesState = {
      state with
      spikeHistory = trimmedHistory;
      spikeWriteIndex = (state.spikeWriteIndex + 1) % state.maxEvents;
      totalSpikes = state.totalSpikes + 1;
    };
    
    (newState, spike)
  };

  // ==========================================================================
  // MEMORY TRACE MANAGEMENT
  // ==========================================================================
  
  public func addMemoryTrace(
    state: SharpWaveRipplesState,
    content: MemoryContent,
    departmentOrigin: Nat
  ) : SharpWaveRipplesState {
    let isCrossDepartmental = switch (content) {
      case (#CrossDepartment(_)) { true };
      case (_) { false };
    };
    
    let trace : MemoryTrace = {
      traceId = state.traceWriteIndex;
      creationTime = Time.now();
      content = content;
      strength = 1.0;
      consolidationCount = 0;
      lastReplayTime = Time.now();
      departmentOrigin = departmentOrigin;
      crossDepartmental = isCrossDepartmental;
      linkedTraces = [];
    };
    
    let newTraces = Array.append(state.memoryTraces, [trace]);
    let trimmedTraces = if (newTraces.size() > state.maxTraces) {
      Array.tabulate<MemoryTrace>(state.maxTraces, func(i: Nat) : MemoryTrace {
        newTraces[newTraces.size() - state.maxTraces + i]
      })
    } else { newTraces };
    
    {
      state with
      memoryTraces = trimmedTraces;
      traceWriteIndex = (state.traceWriteIndex + 1) % state.maxTraces;
    }
  };

  // Consolidate memories during ripple
  public func consolidateMemories(
    state: SharpWaveRipplesState,
    ripple: RippleEvent
  ) : SharpWaveRipplesState {
    // Select memories to consolidate based on ripple properties
    let memoriesToProcess = ripple.memoriesReplayed;
    
    let consolidatedTraces = Array.tabulate<MemoryTrace>(state.memoryTraces.size(), func(i: Nat) : MemoryTrace {
      let trace = state.memoryTraces[i];
      
      // Consolidate if:
      // 1. Recent (created in last consolidation period)
      // 2. Matches ripple department (if unilateral)
      // 3. Or is cross-departmental (if bilateral ripple)
      let shouldConsolidate = 
        i >= state.memoryTraces.size() - memoriesToProcess and
        (not ripple.isUnilateral or 
         trace.crossDepartmental or
         switch (ripple.departmentId) {
           case (?deptId) { trace.departmentOrigin == deptId };
           case null { true };
         });
      
      if (shouldConsolidate) {
        {
          trace with
          strength = Float.min(1.0, trace.strength + 0.1 * ripple.consolidationStrength);
          consolidationCount = trace.consolidationCount + 1;
          lastReplayTime = ripple.timestamp;
        }
      } else { trace }
    });
    
    {
      state with
      memoryTraces = consolidatedTraces;
      totalConsolidations = state.totalConsolidations + 1;
    }
  };

  // ==========================================================================
  // CONSOLIDATION SESSION MANAGEMENT
  // ==========================================================================
  
  public func startConsolidationSession(
    state: SharpWaveRipplesState,
    currentTime: Int
  ) : SharpWaveRipplesState {
    let session : ConsolidationSession = {
      sessionId = state.pastSessions.size();
      startTime = currentTime;
      endTime = null;
      rippleEvents = [];
      dentateSpikes = [];
      memoriesProcessed = 0;
      crossDepartmentalSummaries = [];
      learningsGenerated = [];
      state = #Active;
    };
    
    { state with currentSession = ?session }
  };

  public func endConsolidationSession(
    state: SharpWaveRipplesState,
    currentTime: Int
  ) : SharpWaveRipplesState {
    switch (state.currentSession) {
      case (?session) {
        let completedSession : ConsolidationSession = {
          session with
          endTime = ?currentTime;
          state = #Completed;
        };
        
        {
          state with
          currentSession = null;
          pastSessions = Array.append(state.pastSessions, [completedSession]);
        }
      };
      case null { state };
    }
  };

  // Generate cross-departmental summary during consolidation
  public func generateCrossDepartmentalSummary(
    state: SharpWaveRipplesState,
    currentTime: Int
  ) : (SharpWaveRipplesState, ?CrossDepartmentSummary) {
    // Only generate during consolidation with high synchrony
    switch (state.activityState) {
      case (#Consolidation) {
        if (state.synchronyState.currentSynchrony > 0.7) {
          // Find cross-departmental memories
          let crossDeptMemories = Array.filter<MemoryTrace>(state.memoryTraces, func(t) { t.crossDepartmental });
          
          if (crossDeptMemories.size() > 0) {
            // Extract departments involved
            let deptSet = Buffer.Buffer<Nat>(state.departments.size());
            for (i in Iter.range(0, state.departments.size() - 1)) {
              deptSet.add(i);
            };
            
            let summary : CrossDepartmentSummary = {
              summaryId = switch (state.currentSession) {
                case (?session) { session.crossDepartmentalSummaries.size() };
                case null { 0 };
              };
              departments = Buffer.toArray(deptSet);
              keyInsights = ["Cross-departmental patterns detected", "Synchrony achieved"];
              sharedPatterns = [];
              recommendations = ["Continue cross-department collaboration"];
              generatedAt = currentTime;
            };
            
            // Add to current session
            let newState = switch (state.currentSession) {
              case (?session) {
                let updatedSession : ConsolidationSession = {
                  session with
                  crossDepartmentalSummaries = Array.append(session.crossDepartmentalSummaries, [summary]);
                };
                { state with currentSession = ?updatedSession }
              };
              case null { state };
            };
            
            (newState, ?summary)
          } else {
            (state, null)
          }
        } else {
          (state, null)
        }
      };
      case (_) { (state, null) };
    }
  };

  // ==========================================================================
  // MAIN TICK FUNCTION
  // ==========================================================================
  
  public func tick(state: SharpWaveRipplesState, dt: Float) : SharpWaveRipplesState {
    let currentTime = Time.now();
    
    // Step 1: Update activity state
    var newState = updateActivityState(state, currentTime);
    
    // Step 2: Update synchrony
    newState := { newState with synchronyState = updateSynchrony(newState.synchronyState, dt) };
    
    // Step 3: Handle consolidation session
    switch (newState.activityState) {
      case (#Consolidation) {
        switch (newState.currentSession) {
          case null {
            // Start new session
            newState := startConsolidationSession(newState, currentTime);
          };
          case (?_) { /* Session ongoing */ };
        };
      };
      case (_) {
        switch (newState.currentSession) {
          case (?_) {
            // End session if not in consolidation
            newState := endConsolidationSession(newState, currentTime);
          };
          case null { /* No session to end */ };
        };
      };
    };
    
    // Step 4: Generate ripples if conditions are right
    if (shouldGenerateRipple(newState.activityState, newState.synchronyState.currentSynchrony, newState.synchronyState.autonomicTone)) {
      let (stateAfterRipple, ripple) = generateRipple(newState, currentTime);
      newState := stateAfterRipple;
      
      // Consolidate memories during ripple
      newState := consolidateMemories(newState, ripple);
      
      // Generate dentate spike
      let (stateAfterSpike, _) = generateDentateSpike(newState, currentTime, ?ripple.rippleId);
      newState := stateAfterSpike;
      
      // Generate cross-departmental summary if appropriate
      let (stateAfterSummary, _) = generateCrossDepartmentalSummary(newState, currentTime);
      newState := stateAfterSummary;
    };
    
    // Step 5: Increment beat
    { newState with beatNum = newState.beatNum + 1 }
  };

  // ==========================================================================
  // QUERY FUNCTIONS
  // ==========================================================================
  
  public func getConsolidationMetrics(state: SharpWaveRipplesState) : {
    activityState: Text;
    currentSynchrony: Float;
    totalRipples: Nat;
    totalSpikes: Nat;
    totalConsolidations: Nat;
    memoryCount: Nat;
    sessionCount: Nat;
    isConsolidating: Bool;
  } {
    let stateText = switch (state.activityState) {
      case (#ActiveExecution) { "Active Execution" };
      case (#Consolidation) { "Consolidation" };
      case (#Transition) { "Transition" };
    };
    
    {
      activityState = stateText;
      currentSynchrony = state.synchronyState.currentSynchrony;
      totalRipples = state.totalRipples;
      totalSpikes = state.totalSpikes;
      totalConsolidations = state.totalConsolidations;
      memoryCount = state.memoryTraces.size();
      sessionCount = state.pastSessions.size();
      isConsolidating = switch (state.currentSession) { case (?_) { true }; case null { false } };
    }
  };

  public func getDepartmentSynchronyStatus(state: SharpWaveRipplesState) : [{
    departmentId: Nat;
    departmentName: Text;
    activityLevel: Float;
    isSynchronized: Bool;
  }] {
    Array.map<DepartmentActivity, { departmentId: Nat; departmentName: Text; activityLevel: Float; isSynchronized: Bool }>(
      state.departments,
      func(dept) {
        {
          departmentId = dept.departmentId;
          departmentName = dept.departmentName;
          activityLevel = dept.activityLevel;
          isSynchronized = state.synchronyState.currentSynchrony > 0.7;
        }
      }
    )
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
  //  L E A R N I N G   &   M E M O R Y   M A T H E M A T I C S
  //
  //  Enterprise-Level Learning and Memory Algorithms
  //  Full HIM/HER Dual-Organism Memory Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // MEMORY CONSOLIDATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Ebbinghaus forgetting curve
  public func memoryForgettingCurve(
    initialStrength : Float,
    timePassed : Float,
    decayRate : Float
  ) : Float {
    initialStrength * Float.exp(-decayRate * timePassed)
  };

  /// Spaced repetition optimal interval
  public func memorySpacedRepetitionInterval(
    previousInterval : Float,
    easeFactor : Float,
    performance : Float
  ) : Float {
    let adjustedEase = easeFactor + 0.1 - (5.0 - performance) * 0.08;
    let newEase = if (adjustedEase < 1.3) 1.3 else adjustedEase;
    previousInterval * newEase
  };

  /// Memory strength update
  public func memoryStrengthUpdate(
    currentStrength : Float,
    rehearsal : Bool,
    decayRate : Float,
    boostAmount : Float
  ) : Float {
    let decayed = currentStrength * (1.0 - decayRate);
    if (rehearsal) { Float.min(decayed + boostAmount, 1.0) }
    else { decayed }
  };

  /// Sleep consolidation effect
  public func memorySleepConsolidation(
    hippocampalStrength : Float,
    corticalStrength : Float,
    sleepQuality : Float,
    transferRate : Float
  ) : (Float, Float) {
    let transfer = hippocampalStrength * sleepQuality * transferRate;
    (hippocampalStrength - transfer, corticalStrength + transfer)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ASSOCIATIVE LEARNING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rescorla-Wagner learning rule
  public func memoryRescorlaWagner(
    association : Float,
    learningRate : Float,
    reward : Float,
    maxAssociation : Float
  ) : Float {
    let predictionError = reward - association;
    association + learningRate * predictionError * (maxAssociation - association)
  };

  /// Temporal difference error
  public func memoryTDError(
    reward : Float,
    currentValue : Float,
    nextValue : Float,
    discountFactor : Float
  ) : Float {
    reward + discountFactor * nextValue - currentValue
  };

  /// Eligibility trace update
  public func memoryEligibilityTrace(
    trace : Float,
    decayRate : Float,
    visited : Bool
  ) : Float {
    let decayed = trace * decayRate;
    if (visited) { decayed + 1.0 } else { decayed }
  };

  /// Q-learning update
  public func memoryQLearningUpdate(
    qValue : Float,
    learningRate : Float,
    reward : Float,
    maxNextQ : Float,
    discountFactor : Float
  ) : Float {
    let target = reward + discountFactor * maxNextQ;
    qValue + learningRate * (target - qValue)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // PATTERN COMPLETION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Hopfield network energy
  public func memoryHopfieldEnergy(
    state : [Float],
    weights : [[Float]]
  ) : Float {
    let n = state.size();
    var energy : Float = 0.0;
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n) {
        if (i != j) {
          energy -= 0.5 * weights[i][j] * state[i] * state[j];
        };
        j += 1;
      };
      i += 1;
    };
    energy
  };

  /// Pattern completion update
  public func memoryPatternCompletion(
    state : Float,
    weights : [Float],
    inputs : [Float],
    threshold : Float
  ) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < weights.size() and i < inputs.size()) {
      sum += weights[i] * inputs[i];
      i += 1;
    };
    if (sum > threshold) { 1.0 } else if (sum < -threshold) { -1.0 } else { state }
  };

  /// Sparse coding activation
  public func memorySparseCoding(
    input : Float,
    dictionary : [Float],
    sparsityPenalty : Float
  ) : [Float] {
    Array.tabulate<Float>(dictionary.size(), func(i : Nat) : Float {
      let activation = input * dictionary[i];
      let penalized = activation - sparsityPenalty;
      if (penalized > 0.0) { penalized } else { 0.0 }
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // EPISODIC MEMORY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Episode binding strength
  public func memoryEpisodeBinding(
    contextualSimilarity : Float,
    temporalProximity : Float,
    emotionalSalience : Float
  ) : Float {
    contextualSimilarity * temporalProximity * (1.0 + emotionalSalience)
  };

  /// Temporal context update
  public func memoryTemporalContext(
    currentContext : Float,
    input : Float,
    driftRate : Float
  ) : Float {
    (1.0 - driftRate) * currentContext + driftRate * input
  };

  /// Recollection probability
  public func memoryRecollectionProbability(
    cueStrength : Float,
    memoryStrength : Float,
    noise : Float
  ) : Float {
    let signal = cueStrength * memoryStrength;
    1.0 / (1.0 + Float.exp(-(signal - noise) / 0.5))
  };

  /// Familiarity signal
  public func memoryFamiliarity(
    featureMatch : Float,
    priorExposure : Float
  ) : Float {
    featureMatch * (1.0 + Float.log(priorExposure + 1.0))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // CURRICULUM LEARNING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Task difficulty assessment
  public func memoryTaskDifficulty(
    complexity : Float,
    novelty : Float,
    performance : Float
  ) : Float {
    complexity * (1.0 + novelty) / (performance + 0.1)
  };

  /// Optimal learning zone
  public func memoryOptimalLearningZone(
    currentSkill : Float,
    taskDifficulty : Float,
    zoneWidth : Float
  ) : Float {
    let diff = Float.abs(taskDifficulty - currentSkill);
    if (diff < zoneWidth) { 1.0 - diff / zoneWidth } else { 0.0 }
  };

  /// Skill progression rate
  public func memorySkillProgression(
    practice : Float,
    difficulty : Float,
    currentSkill : Float
  ) : Float {
    let challenge = difficulty - currentSkill;
    if (challenge > 0.0) {
      practice * challenge * Float.exp(-challenge * challenge)
    } else {
      practice * 0.1  // Minimal progress if too easy
    }
  };

  /// Knowledge transfer coefficient
  public func memoryKnowledgeTransfer(
    sourceSkill : Float,
    targetSimilarity : Float
  ) : Float {
    sourceSkill * targetSimilarity * targetSimilarity
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // METACOGNITION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Confidence calibration
  public func memoryConfidenceCalibration(
    predicted : Float,
    actual : Float,
    history : [Float]
  ) : Float {
    let currentError = Float.abs(predicted - actual);
    var avgError : Float = 0.0;
    var i = 0;
    while (i < history.size()) {
      avgError += history[i];
      i += 1;
    };
    if (history.size() > 0) {
      avgError /= Float.fromInt(history.size());
    };
    1.0 - (currentError + avgError) / 2.0
  };

  /// Feeling of knowing
  public func memoryFeelingOfKnowing(
    partialRetrieval : Float,
    relatedActivation : Float
  ) : Float {
    (partialRetrieval + relatedActivation) / 2.0
  };

  /// Judgment of learning
  public func memoryJudgmentOfLearning(
    fluency : Float,
    effort : Float,
    priorKnowledge : Float
  ) : Float {
    let fluencyWeight = 0.4;
    let effortWeight = 0.3;
    let priorWeight = 0.3;
    fluencyWeight * fluency + effortWeight * (1.0 - effort) + priorWeight * priorKnowledge
  };

}
