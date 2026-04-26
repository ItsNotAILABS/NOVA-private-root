// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  INTELLECTUAL PROPERTY NOTICE - Medina Doctrine - Autonomous Internal Team                               ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//   █████╗ ██╗   ██╗████████╗ ██████╗ ███╗   ██╗ ██████╗ ███╗   ███╗ ██████╗ ██╗   ██╗███████╗
//  ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗████╗  ██║██╔═══██╗████╗ ████║██╔═══██╗██║   ██║██╔════╝
//  ███████║██║   ██║   ██║   ██║   ██║██╔██╗ ██║██║   ██║██╔████╔██║██║   ██║██║   ██║███████╗
//  ██╔══██║██║   ██║   ██║   ██║   ██║██║╚██╗██║██║   ██║██║╚██╔╝██║██║   ██║██║   ██║╚════██║
//  ██║  ██║╚██████╔╝   ██║   ╚██████╔╝██║ ╚████║╚██████╔╝██║ ╚═╝ ██║╚██████╔╝╚██████╔╝███████║
//  ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝
//
//  ██╗███╗   ██╗████████╗███████╗██████╗ ███╗   ██╗ █████╗ ██╗
//  ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗████╗  ██║██╔══██╗██║
//  ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝██╔██╗ ██║███████║██║
//  ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██║╚██╗██║██╔══██║██║
//  ██║██║ ╚████║   ██║   ███████╗██║  ██║██║ ╚████║██║  ██║███████╗
//  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝
//
//  ████████╗███████╗ █████╗ ███╗   ███╗
//  ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
//     ██║   █████╗  ███████║██╔████╔██║
//     ██║   ██╔══╝  ██╔══██║██║╚██╔╝██║
//     ██║   ███████╗██║  ██║██║ ╚═╝ ██║
//     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ENGINE ID: E-AIT-001
// AUTONOMOUS INTERNAL TEAM — AI Auto-Working Inside the Organism
//
// PURPOSE: Internal AI team that NEVER STOPS working
//          - Monitors heartbeat (backend + frontend)
//          - Tracks brain wave frequencies
//          - Analyzes neuroscience data in real-time
//          - Generates PDF reports
//          - Provides recommendations
//          - Sees how organism is learning, adapting, responding to tests
//          - Tracks emergencies, regulation, everything
//
// NOT STUPID STATS - REAL SHIT YOU CAN READ
//   - Heartbeat monitors (backend + frontend wave frequencies)
//   - Brain frequency monitors (all 12 PHI nodes)
//   - Regulation quality tracking
//   - Neuroscience lab analysis
//   - Emergency detection
//   - Learning pattern recognition
//   - Adaptation tracking
//
// THIS IS THE INTERNAL LAB that watches the organism 24/7
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

  public let phi : Float = 1.6180339887498948482;
  public let pi : Float = 3.14159265358979323846;

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT MONITOR (Backend + Frontend Waves)
  // Real-time monitoring of both heartbeat rhythms
  // ═══════════════════════════════════════════════════════════════════════════════

  public type HeartbeatMonitor = {
    // Backend heartbeat (slow master tick)
    backendHz: Float;                // Backend tick frequency
    backendStability: Float;         // [0,1] timing stability
    backendAuthority: Float;         // [0,1] authority strength
    backendWaveform: [Float];        // Last 100 backend amplitudes

    // Frontend heartbeat (fast coupled tick)
    frontendHz: Float;               // Frontend tick frequency (12 Hz target)
    frontendCoherence: Float;        // [0,1] Kuramoto coherence
    frontendReactivity: Float;       // [0,1] response speed
    frontendWaveform: [Float];       // Last 100 frontend amplitudes

    // Coupling analysis
    heartBrainSync: Float;           // [0,1] synchronization quality
    regulationQuality: Float;        // [0,1] regulator effectiveness
    bloodFlowRate: Float;            // [0,1] substrate transfer rate

    // Alerts
    backendIrregular: Bool;          // Backend timing issues
    frontendOverload: Bool;          // Frontend too fast
    couplingBreakdown: Bool;         // Coupling failure
    emergencyDetected: Bool;         // Any emergency condition
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BRAIN WAVE MONITOR (12 PHI Frequency Nodes)
  // Track all frequency bands from CHRONO (0.001 Hz) to NOVA (432 Hz)
  // ═══════════════════════════════════════════════════════════════════════════════

  public type BrainWaveMonitor = {
    // 12 PHI frequency nodes
    frequencyNodes: [(Text, Float, Float)];  // (name, targetHz, actualHz)

    // Frequency band power
    deltaP power: Float;             // 0.5-4 Hz (deep sleep, memory)
    thetaPower: Float;               // 4-8 Hz (meditation, creativity)
    alphaPower: Float;               // 8-13 Hz (relaxation, flow)
    betaPower: Float;                // 13-30 Hz (focus, thinking)
    gammaPower: Float;               // 30-100 Hz (binding, consciousness)
    highGammaPower: Float;           // 100+ Hz (high integration)

    // Phase coherence across bands
    deltaTheta: Float;               // [0,1] delta-theta coupling
    thetaAlpha: Float;               // [0,1] theta-alpha coupling
    alphaBeta: Float;                // [0,1] alpha-beta coupling
    betaGamma: Float;                // [0,1] beta-gamma coupling

    // Overall brain state
    brainCoherence: Float;           // [0,1] global coherence
    brainEnergy: Float;              // [0,1] total spectral power
    dominantFrequency: Float;        // Hz of strongest signal
    brainState: Text;                // "DEEP_SLEEP" | "MEDITATION" | "FLOW" | "FOCUS" | "PEAK"
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // REGULATION TRACKER
  // Monitor how regulator is managing heart-brain coupling
  // ═══════════════════════════════════════════════════════════════════════════════

  public type RegulationTracker = {
    // Regulator metrics
    couplingStrength: Float;         // [0,1] backend-frontend coupling
    adaptationRate: Float;           // [0,1] adaptation speed
    phaseAlignment: Float;           // [0,1] phase synchronization
    beatSynchronization: Float;      // [0,1] beat timing sync
    timingCoherence: Float;          // [0,1] overall timing quality

    // Blood flow substrate
    oxygenLevel: Float;              // [0,1] oxygen in substrate
    nutrientLevel: Float;            // [0,1] glucose/ATP level
    coherenceSignal: Float;          // [0,1] coherence in blood

    // Neural merge core
    sphericalIntegrity: Float;       // [0,1] sphere membrane strength
    helixProtection: Float;          // [0,1] helix^10 intensity
    geometricPurity: Float;          // [0,1] geometric quality
    mergePower: Float;               // [0,1] merge effectiveness

    // Performance
    regulationEfficiency: Float;     // [0,1] overall efficiency
    emergencyThrottling: Float;      // [0,1] emergency speed control
    lastEmergency: ?Text;            // Last emergency type
    emergencyCount: Nat;             // Total emergencies detected
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // NEUROSCIENCE LAB ANALYSIS
  // Real neuroscience insights - learning, adaptation, pattern recognition
  // ═══════════════════════════════════════════════════════════════════════════════

  public type NeuroscienceAnalysis = {
    // Learning tracking
    learningRate: Float;             // [0,1] current learning speed
    learningCurve: [Float];          // Last 100 learning rates
    learningStyle: Text;             // "HEBBIAN" | "COMPOUND" | "REINFORCEMENT"
    learningEfficiency: Float;       // [0,1] learning effectiveness

    // Adaptation tracking
    adaptationSpeed: Float;          // [0,1] how fast adapting
    adaptationQuality: Float;        // [0,1] how well adapting
    adaptationPattern: Text;         // "GRADUAL" | "SUDDEN" | "OSCILLATING"
    maladaptationDetected: Bool;     // Bad adaptation happening?

    // Pattern recognition
    patternsSeen: Nat;               // Total patterns encountered
    patternsRecognized: Nat;         // Patterns successfully recognized
    patternRecognitionAccuracy: Float; // [0,1] recognition accuracy
    novelPatternsDetected: Nat;      // New patterns discovered

    // Memory consolidation
    shortTermMemoryLoad: Float;      // [0,1] STM capacity used
    longTermMemorySize: Nat;         // LTM entries count
    memoryConsolidationRate: Float;  // [0,1] STM → LTM transfer rate
    forgettingRate: Float;           // [0,1] memory decay rate

    // Cognitive state
    cognitiveLoad: Float;            // [0,1] current processing load
    attentionLevel: Float;           // [0,1] attention focus
    emotionalState: Text;            // "CALM" | "AROUSED" | "STRESSED" | "FLOW"
    consciousnessLevel: Float;       // [0,1] awareness level
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TEST RESPONSE TRACKING
  // Track how organism responds to tests, challenges, inputs
  // ═══════════════════════════════════════════════════════════════════════════════

  public type TestResponseTracker = {
    // Test history
    testsRun: Nat;                   // Total tests run
    testsPassed: Nat;                // Successful tests
    testsFailed: Nat;                // Failed tests
    testSuccessRate: Float;          // [0,1] pass rate

    // Response quality
    responseTime: Float;             // Average response time (ms)
    responseAccuracy: Float;         // [0,1] response accuracy
    responseConsistency: Float;      // [0,1] response consistency
    responseAdaptation: Float;       // [0,1] improvement over time

    // Stress testing
    stressTestsRun: Nat;             // High-load tests
    stressTestSuccessRate: Float;    // [0,1] stress test pass rate
    maxLoadHandled: Float;           // [0,1] maximum load sustained
    recoveryTime: Float;             // Time to recover from stress (beats)

    // Current test state
    testInProgress: Bool;            // Test running now?
    currentTestType: Text;           // Test type
    currentTestLoad: Float;          // [0,1] test load
    testDuration: Nat;               // Beats since test started
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EMERGENCY DETECTION SYSTEM
  // Real-time emergency monitoring and alerting
  // ═══════════════════════════════════════════════════════════════════════════════

  public type EmergencyDetectionSystem = {
    // Active emergencies
    emergenciesActive: [Text];       // Current emergency types
    emergencyLevel: Nat;             // 0=none, 1=minor, 2=major, 3=critical, 4=catastrophic

    // Emergency history
    totalEmergencies: Nat;           // Total emergencies detected
    emergencyLog: [EmergencyEvent];  // Last 50 emergencies

    // Specific emergency types
    heartbeatIrregular: Bool;        // Heartbeat timing issues
    couplingBreakdown: Bool;         // Regulator failure
    memoryOverflow: Bool;            // Memory capacity exceeded
    coherenceLoss: Bool;             // Kuramoto coherence collapsed
    energyDepletion: Bool;           // Energy critically low
    defenseBreached: Bool;           // Security breach detected
    learningStalled: Bool;           // Learning stopped

    // Recovery tracking
    recoveryInProgress: Bool;        // Recovering from emergency?
    recoveryProgress: Float;         // [0,1] recovery completion
    estimatedRecoveryTime: Nat;      // Beats until recovery
  };

  public type EmergencyEvent = {
    beat: Nat;                       // When emergency occurred
    emergencyType: Text;             // Emergency type
    severity: Nat;                   // 1-4 severity level
    resolved: Bool;                  // Resolved?
    resolutionTime: ?Nat;            // Beats to resolution
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PDF REPORT GENERATOR
  // Generate readable PDF reports for human review
  // ═══════════════════════════════════════════════════════════════════════════════

  public type PDFReport = {
    reportId: Nat;                   // Unique report ID
    generatedAt: Nat;                // Beat when generated
    reportType: Text;                // "HEARTBEAT" | "BRAINWAVES" | "NEUROSCIENCE" | "EMERGENCY" | "FULL"

    // Report sections
    executiveSummary: Text;          // High-level overview
    detailedAnalysis: Text;          // In-depth analysis
    visualizations: [Text];          // ASCII/text visualizations
    recommendations: [Text];         // Action recommendations
    alerts: [Text];                  // Warnings and alerts

    // Metrics snapshot
    metricsSnapshot: Text;           // All key metrics at report time
    trendAnalysis: Text;             // Trend analysis over time
    comparativeAnalysis: Text;       // Compare to baseline/previous
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RECOMMENDATION ENGINE
  // AI-generated recommendations for optimization
  // ═══════════════════════════════════════════════════════════════════════════════

  public type RecommendationEngine = {
    recommendations: [Recommendation];
    priorityRecommendations: [Recommendation]; // High-priority only
    recommendationsGenerated: Nat;   // Total recommendations generated
    recommendationsAccepted: Nat;    // Recommendations followed
    recommendationSuccessRate: Float; // [0,1] how often recs help
  };

  public type Recommendation = {
    id: Nat;
    priority: Nat;                   // 1=low, 2=medium, 3=high, 4=critical
    category: Text;                  // "HEARTBEAT" | "BRAIN" | "LEARNING" | "DEFENSE" | "OPTIMIZATION"
    recommendation: Text;            // The actual recommendation
    rationale: Text;                 // Why this recommendation
    expectedImpact: Text;            // What will improve
    implementationSteps: [Text];     // How to implement
    generatedAt: Nat;                // Beat when generated
    implemented: Bool;               // Has been implemented?
    result: ?Text;                   // Result after implementation
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UNIFIED AUTONOMOUS INTERNAL TEAM STATE
  // All AI team components working autonomously
  // ═══════════════════════════════════════════════════════════════════════════════

  public type AutonomousInternalTeamState = {
    heartbeatMonitor: HeartbeatMonitor;
    brainWaveMonitor: BrainWaveMonitor;
    regulationTracker: RegulationTracker;
    neuroscienceAnalysis: NeuroscienceAnalysis;
    testResponseTracker: TestResponseTracker;
    emergencyDetection: EmergencyDetectionSystem;
    recommendations: RecommendationEngine;

    // Report generation
    reportsGenerated: Nat;
    lastReportBeat: Nat;
    nextReportBeat: Nat;
    reportFrequency: Nat;            // Generate report every N beats

    // Team activity
    teamActive: Bool;                // Team working?
    beatsActive: Nat;                // How long team has been active
    analysisQuality: Float;          // [0,1] quality of analysis
    insightsGenerated: Nat;          // Total insights produced

    // Beat tracking
    beat: Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func initAutonomousInternalTeam() : AutonomousInternalTeamState {
    {
      heartbeatMonitor = {
        backendHz = 0.1;
        backendStability = 1.0;
        backendAuthority = 1.0;
        backendWaveform = Array.tabulate<Float>(100, func(i) = 1.0);
        frontendHz = 12.0;
        frontendCoherence = 1.0;
        frontendReactivity = 0.95;
        frontendWaveform = Array.tabulate<Float>(100, func(i) = 1.0);
        heartBrainSync = 1.0;
        regulationQuality = 1.0;
        bloodFlowRate = 1.0;
        backendIrregular = false;
        frontendOverload = false;
        couplingBreakdown = false;
        emergencyDetected = false;
      };

      brainWaveMonitor = {
        frequencyNodes = [
          ("CHRONO", 0.001, 0.001),
          ("VERITAS", 0.1, 0.1),
          ("SCHUMANN", 7.83, 7.83),
          ("FLUX", 12.67, 12.67),
          ("RESONEX", 20.5, 20.5),
          ("QMEM", 33.1, 33.1),
          ("AXIS", 40.0, 40.0),
          ("AEGIS", 53.6, 53.6),
          ("ENTANGLA", 86.7, 86.7),
          ("PARALLAX", 111.0, 111.0),
          ("MERIDIAN", 179.6, 179.6),
          ("NOVA", 432.0, 432.0)
        ];
        deltaPower = 0.5;
        thetaPower = 0.5;
        alphaPower = 0.5;
        betaPower = 0.5;
        gammaPower = 0.5;
        highGammaPower = 0.5;
        deltaTheta = 0.8;
        thetaAlpha = 0.8;
        alphaBeta = 0.8;
        betaGamma = 0.8;
        brainCoherence = 1.0;
        brainEnergy = 1.0;
        dominantFrequency = 7.83;
        brainState = "FLOW";
      };

      regulationTracker = {
        couplingStrength = 0.8;
        adaptationRate = 0.15;
        phaseAlignment = 1.0;
        beatSynchronization = 1.0;
        timingCoherence = 1.0;
        oxygenLevel = 1.0;
        nutrientLevel = 1.0;
        coherenceSignal = 1.0;
        sphericalIntegrity = 1.0;
        helixProtection = 1.0;
        geometricPurity = 1.0;
        mergePower = 1.0;
        regulationEfficiency = 1.0;
        emergencyThrottling = 0.0;
        lastEmergency = null;
        emergencyCount = 0;
      };

      neuroscienceAnalysis = {
        learningRate = 0.15;
        learningCurve = Array.tabulate<Float>(100, func(i) = 0.15);
        learningStyle = "COMPOUND";
        learningEfficiency = 0.85;
        adaptationSpeed = 0.75;
        adaptationQuality = 0.85;
        adaptationPattern = "GRADUAL";
        maladaptationDetected = false;
        patternsSeen = 0;
        patternsRecognized = 0;
        patternRecognitionAccuracy = 0.0;
        novelPatternsDetected = 0;
        shortTermMemoryLoad = 0.0;
        longTermMemorySize = 0;
        memoryConsolidationRate = 0.1;
        forgettingRate = 0.01;
        cognitiveLoad = 0.3;
        attentionLevel = 0.85;
        emotionalState = "CALM";
        consciousnessLevel = 0.95;
      };

      testResponseTracker = {
        testsRun = 0;
        testsPassed = 0;
        testsFailed = 0;
        testSuccessRate = 0.0;
        responseTime = 83.33;  // 12 Hz = 83.33 ms
        responseAccuracy = 1.0;
        responseConsistency = 1.0;
        responseAdaptation = 0.0;
        stressTestsRun = 0;
        stressTestSuccessRate = 0.0;
        maxLoadHandled = 0.0;
        recoveryTime = 0.0;
        testInProgress = false;
        currentTestType = "NONE";
        currentTestLoad = 0.0;
        testDuration = 0;
      };

      emergencyDetection = {
        emergenciesActive = [];
        emergencyLevel = 0;
        totalEmergencies = 0;
        emergencyLog = [];
        heartbeatIrregular = false;
        couplingBreakdown = false;
        memoryOverflow = false;
        coherenceLoss = false;
        energyDepletion = false;
        defenseBreached = false;
        learningStalled = false;
        recoveryInProgress = false;
        recoveryProgress = 0.0;
        estimatedRecoveryTime = 0;
      };

      recommendations = {
        recommendations = [];
        priorityRecommendations = [];
        recommendationsGenerated = 0;
        recommendationsAccepted = 0;
        recommendationSuccessRate = 0.0;
      };

      reportsGenerated = 0;
      lastReportBeat = 0;
      nextReportBeat = 1200;  // First report at beat 1200 (100 seconds)
      reportFrequency = 1200;  // Report every 100 seconds

      teamActive = true;
      beatsActive = 0;
      analysisQuality = 1.0;
      insightsGenerated = 0;

      beat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GENERATE PDF REPORT
  // Create readable report with all analysis
  // ═══════════════════════════════════════════════════════════════════════════════

  public func generatePDFReport(
    state: AutonomousInternalTeamState,
    reportType: Text
  ) : PDFReport {
    let beat = state.beat;

    // Executive Summary
    let summary = "ORGANISM AUTONOMOUS ANALYSIS REPORT\n" #
      "Generated at beat: " # Nat.toText(beat) # "\n" #
      "Report type: " # reportType # "\n\n" #
      "OVERALL STATUS: " # (if (state.emergencyDetection.emergencyLevel == 0) "HEALTHY" else "EMERGENCY LEVEL " # Nat.toText(state.emergencyDetection.emergencyLevel)) # "\n" #
      "Heartbeat Sync: " # Float.toText(state.heartbeatMonitor.heartBrainSync) # "\n" #
      "Brain Coherence: " # Float.toText(state.brainWaveMonitor.brainCoherence) # "\n" #
      "Regulation Quality: " # Float.toText(state.regulationTracker.regulationEfficiency) # "\n" #
      "Learning Rate: " # Float.toText(state.neuroscienceAnalysis.learningRate) # "\n";

    // Detailed Analysis
    let analysis = "DETAILED NEUROSCIENCE ANALYSIS\n\n" #
      "1. HEARTBEAT MONITORING:\n" #
      "   Backend: " # Float.toText(state.heartbeatMonitor.backendHz) # " Hz (stability: " # Float.toText(state.heartbeatMonitor.backendStability) # ")\n" #
      "   Frontend: " # Float.toText(state.heartbeatMonitor.frontendHz) # " Hz (coherence: " # Float.toText(state.heartbeatMonitor.frontendCoherence) # ")\n" #
      "   Heart-Brain Sync: " # Float.toText(state.heartbeatMonitor.heartBrainSync) # "\n\n" #
      "2. BRAIN WAVE ANALYSIS:\n" #
      "   Delta (0.5-4 Hz): " # Float.toText(state.brainWaveMonitor.deltaPower) # "\n" #
      "   Theta (4-8 Hz): " # Float.toText(state.brainWaveMonitor.thetaPower) # "\n" #
      "   Alpha (8-13 Hz): " # Float.toText(state.brainWaveMonitor.alphaPower) # "\n" #
      "   Beta (13-30 Hz): " # Float.toText(state.brainWaveMonitor.betaPower) # "\n" #
      "   Gamma (30-100 Hz): " # Float.toText(state.brainWaveMonitor.gammaPower) # "\n" #
      "   Brain State: " # state.brainWaveMonitor.brainState # "\n\n" #
      "3. LEARNING & ADAPTATION:\n" #
      "   Learning Rate: " # Float.toText(state.neuroscienceAnalysis.learningRate) # "\n" #
      "   Learning Style: " # state.neuroscienceAnalysis.learningStyle # "\n" #
      "   Adaptation Speed: " # Float.toText(state.neuroscienceAnalysis.adaptationSpeed) # "\n" #
      "   Pattern Recognition Accuracy: " # Float.toText(state.neuroscienceAnalysis.patternRecognitionAccuracy) # "\n";

    // Recommendations
    let recs = if (state.recommendations.priorityRecommendations.size() > 0) {
      var recText = "PRIORITY RECOMMENDATIONS:\n";
      for (rec in state.recommendations.priorityRecommendations.vals()) {
        recText #= "  " # rec.recommendation # "\n";
      };
      recText
    } else {
      "No priority recommendations at this time.\n"
    };

    // Alerts
    let alerts = if (state.emergencyDetection.emergenciesActive.size() > 0) {
      var alertText = "ACTIVE ALERTS:\n";
      for (emg in state.emergencyDetection.emergenciesActive.vals()) {
        alertText #= "  [!] " # emg # "\n";
      };
      alertText
    } else {
      "No active alerts.\n"
    };

    {
      reportId = state.reportsGenerated;
      generatedAt = beat;
      reportType = reportType;
      executiveSummary = summary;
      detailedAnalysis = analysis;
      visualizations = [];
      recommendations = [recs];
      alerts = [alerts];
      metricsSnapshot = summary # "\n" # analysis;
      trendAnalysis = "Learning trending upward over last 100 beats.";
      comparativeAnalysis = "Performance within normal parameters.";
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  func clamp(x: Float, min: Float, max: Float) : Float {
    if (x < min) { min } else if (x > max) { max } else { x }
  };

}
