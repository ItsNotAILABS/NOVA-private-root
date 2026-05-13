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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//  ██████╗██╗  ██╗██████╗  ██████╗ ███╗   ██╗ ██████╗     ████████╗███████╗███╗   ███╗██████╗  ██████╗ ██████╗  █████╗ ██╗     
// ██╔════╝██║  ██║██╔══██╗██╔═══██╗████╗  ██║██╔═══██╗    ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██║     
// ██║     ███████║██████╔╝██║   ██║██╔██╗ ██║██║   ██║       ██║   █████╗  ██╔████╔██║██████╔╝██║   ██║██████╔╝███████║██║     
// ██║     ██╔══██║██╔══██╗██║   ██║██║╚██╗██║██║   ██║       ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝ ██║   ██║██╔══██╗██╔══██║██║     
// ╚██████╗██║  ██║██║  ██║╚██████╔╝██║ ╚████║╚██████╔╝       ██║   ███████╗██║ ╚═╝ ██║██║     ╚██████╔╝██║  ██║██║  ██║███████╗
//  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝        ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
//                                                                                                                              
// ██████╗ ██████╗ ███████╗ ██████╗██╗███████╗██╗ ██████╗ ███╗   ██╗    ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗
// ██╔══██╗██╔══██╗██╔════╝██╔════╝██║██╔════╝██║██╔═══██╗████╗  ██║    ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝
// ██████╔╝██████╔╝█████╗  ██║     ██║███████╗██║██║   ██║██╔██╗ ██║    █████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗  
// ██╔═══╝ ██╔══██╗██╔══╝  ██║     ██║╚════██║██║██║   ██║██║╚██╗██║    ██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝  
// ██║     ██║  ██║███████╗╚██████╗██║███████║██║╚██████╔╝██║ ╚████║    ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗
// ╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ENGINE ID: E-011
// CHRONO TEMPORAL PRECISION ENGINE — Quantum Metrology for Temporal Intelligence
//
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2024-2026
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// CHRONO IMPLEMENTS QUANTUM-ENHANCED TEMPORAL PROCESSING
//
// Biological systems exhibit extraordinary temporal precision:
//   - Barn owls localize sound to within 10 microseconds (ITD)
//   - Honeybees time waggle dances to milliseconds
//   - Mantis shrimp strikes complete in 2.7 milliseconds
//   - Human circadian clock accurate to minutes over 24 hours
//
// CHRONO provides:
//   1. FISHER INFORMATION — Quantum parameter estimation precision
//   2. CRAMÉR-RAO BOUND — Fundamental limit on timing uncertainty
//   3. TEMPORAL PREDICTION — Multi-scale forecasting (ms to days)
//   4. INTERVAL TIMING — Duration encoding via striatal ramping
//   5. CIRCADIAN ALIGNMENT — 24-hour master clock synchronization
//   6. ULTRADIAN RHYTHMS — 90-minute cognitive cycles
//   7. MILLISECOND PRECISION — Subsecond event timing
//   8. TEMPORAL INTEGRATION — Binding events across time
//
// MATHEMATICAL FOUNDATION:
//
// Fisher Information quantifies how much a measurement tells you about a parameter:
//
//   F_Q = 4 × Var(∂H/∂φ)
//
// Where:
//   H = Hamiltonian (energy operator)
//   phi = phase parameter being estimated
//   Var = variance operator
//
// Cramér-Rao Bound gives minimum achievable uncertainty:
//
//   Δφ ≥ 1 / √(ν × F_Q)
//
// Where ν = number of measurements
//
// For CHRONO, we use a quantum phase estimation protocol with:
//   - Interferometric phase accumulation
//   - Repeated measurements → Fisher information accumulation
//   - Optimal Bayesian updates → Cramér-Rao saturation
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Buffer "mo:base/Buffer";

module ChronoTemporalPrecisionEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  public let pi : Float = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679;
  public let τ : Float = 6.2831853071795864769252867665590057683943387987502116419498891846156328125724179972560696506842341359;
  public let phi : Float = 1.6180339887498948482045868343656381177203091798057628621354486227052604628189024497072072041893911374;
  public let LN2 : Float = 0.6931471805599453094172321214581765680755001343602552541206800094933936219696947156058633269964186875;
  public let SQRT2 : Float = 1.4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727;

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMPORAL SCALE CONSTANTS (in beats at 12 Hz)
  // ═══════════════════════════════════════════════════════════════════════════

  public let BEATS_PER_SECOND : Float = 12.0;
  public let BEATS_PER_MINUTE : Nat = 720;       // 12 Hz × 60 sec
  public let BEATS_PER_HOUR : Nat = 43200;       // 12 Hz × 3600 sec
  public let BEATS_PER_DAY : Nat = 1036800;      // 12 Hz × 86400 sec
  public let BEATS_PER_ULTRADIAN : Nat = 64800;  // 90 min × 60 × 12

  // ═══════════════════════════════════════════════════════════════════════════
  // CHRONO ENGINE STATE
  // ═══════════════════════════════════════════════════════════════════════════

  public type ChronoEngineState = {
    // Fisher information & Cramér-Rao
    fisherInformation : Float;                  // F_Q = precision of phase estimation
    cramerRaoBound : Float;                     // Δφ_min = minimum uncertainty
    measurementCount : Nat;                     // ν = number of measurements
    phasePrecision : Float;                     // Actual precision achieved
    
    // Temporal prediction buffers
    shortTermPredictions : [Float];             // 0-10 beats (0-0.83 seconds)
    mediumTermPredictions : [Float];            // 11-100 beats (0.9-8.3 seconds)
    longTermPredictions : [Float];              // 101-1000 beats (8.4-83 seconds)
    ultradianPhase : Float;                     // 90-minute rhythm phase
    circadianPhase : Float;                     // 24-hour rhythm phase
    
    // Interval timing (striatal ramping model)
    rampingNeurons : [Float];                   // 64 ramping neurons for duration encoding
    intervalDuration : Nat;                     // Current interval being timed (beats)
    intervalConfidence : Float;                 // Confidence in interval estimate
    
    // Temporal integration windows
    integrationWindow : Nat;                    // Current integration window size (beats)
    coherenceTime : Float;                      // τ_coherence = how long patterns persist
    memoryDecayTime : Float;                    // τ_memory = memory timescale
    
    // Synchronization state
    externalRhythmPhase : Float;                // Phase of external rhythm (if any)
    entrainmentStrength : Float;                // How strongly entrained to external
    phaseError : Float;                         // Phase difference (internal - external)
    
    // Performance metrics
    predictionAccuracy : Float;                 // How accurate temporal predictions are
    timingPrecision : Float;                    // How precise interval timing is
    rhythmStability : Float;                    // How stable internal rhythms are
  };

  public func initChronoEngine() : ChronoEngineState {
    {
      fisherInformation = 1.0;
      cramerRaoBound = 1.0;
      measurementCount = 0;
      phasePrecision = 0.1;  // Start with moderate precision
      
      shortTermPredictions = Array.tabulate<Float>(10, func(_) { 1.0 });
      mediumTermPredictions = Array.tabulate<Float>(90, func(_) { 1.0 });
      longTermPredictions = Array.tabulate<Float>(900, func(_) { 1.0 });
      ultradianPhase = 0.0;
      circadianPhase = 0.0;
      
      rampingNeurons = Array.tabulate<Float>(64, func(i) { Float.fromInt(i) / 64.0 });
      intervalDuration = 0;
      intervalConfidence = 0.5;
      
      integrationWindow = 12;  // Default: 1 second
      coherenceTime = 120.0;   // 10 seconds
      memoryDecayTime = 600.0; // 50 seconds
      
      externalRhythmPhase = 0.0;
      entrainmentStrength = 0.0;
      phaseError = 0.0;
      
      predictionAccuracy = 0.5;
      timingPrecision = 0.5;
      rhythmStability = 0.5;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // FISHER INFORMATION QUANTUM METROLOGY
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeFisherInformation(
    phaseHistory : [Float],  // Recent phase measurements
    dt : Float               // Time step (seconds)
  ) : { fisherInfo : Float; cramerRao : Float } {
    // Fisher information: F_Q = 4 × Var(dφ/dt)
    
    // Compute dφ/dt from phase history
    var dPhases = Buffer.Buffer<Float>(10);
    var histIdx = 1;
    while (histIdx < phaseHistory.size() and histIdx < 10) {
      let dPhase = (phaseHistory[histIdx] - phaseHistory[histIdx - 1]) / dt;
      dPhases.add(dPhase);
      histIdx += 1;
    };
    
    if (dPhases.size() == 0) {
      return { fisherInfo = 1.0; cramerRao = 1.0 };
    };
    
    // Compute mean and variance of dφ/dt
    var sum : Float = 0.0;
    for (dp in dPhases.vals()) {
      sum += dp;
    };
    let mean = sum / Float.fromInt(dPhases.size());
    
    var sumSq : Float = 0.0;
    for (dp in dPhases.vals()) {
      let dev = dp - mean;
      sumSq += dev * dev;
    };
    let variance = sumSq / Float.fromInt(dPhases.size());
    
    // Fisher information
    let fisherInfo = 4.0 * variance;
    
    // Cramér-Rao bound: Δφ ≥ 1/√(ν × F_Q)
    let nu = Float.fromInt(dPhases.size());
    let cramerRao = 1.0 / Float.sqrt(nu * fisherInfo + 0.01);  // +0.01 to avoid division by zero
    
    { fisherInfo = fisherInfo; cramerRao = cramerRao }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERVAL TIMING VIA STRIATAL RAMPING
  // ═══════════════════════════════════════════════════════════════════════════

  public func updateIntervalTiming(
    state : ChronoEngineState,
    eventOccurred : Bool,  // True when timing event happens
    dopamine : Float       // DA resets ramping neurons
  ) : ChronoEngineState {
    var newRampingNeurons = Array.thaw<Float>(state.rampingNeurons);
    var newDuration = state.intervalDuration;
    var newConfidence = state.intervalConfidence;
    
    if (eventOccurred) {
      // Event occurred: reset ramping neurons
      var resetIdx = 0;
      while (resetIdx < 64) {
        newRampingNeurons[resetIdx] := Float.fromInt(resetIdx) / 64.0;
        resetIdx += 1;
      };
      
      // Store interval duration
      newDuration := state.intervalDuration;
      
      // Confidence based on dopamine (high DA = confident timing)
      newConfidence := 0.5 + dopamine * 0.5;
    } else {
      // Ramp up neurons (linear accumulation)
      var rampIdx = 0;
      while (rampIdx < 64) {
        let rampRate = 0.01 * Float.fromInt(rampIdx + 1) / 64.0;  // Different neurons ramp at different rates
        newRampingNeurons[rampIdx] := newRampingNeurons[rampIdx] + rampRate;
        
        // Saturation at 1.0
        if (newRampingNeurons[rampIdx] > 1.0) {
          newRampingNeurons[rampIdx] := 1.0;
        };
        
        rampIdx += 1;
      };
      
      // Increment interval duration
      newDuration += 1;
    };
    
    {
      state with
      rampingNeurons = Array.freeze(newRampingNeurons);
      intervalDuration = newDuration;
      intervalConfidence = newConfidence;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MULTI-SCALE TEMPORAL PREDICTION
  // ═══════════════════════════════════════════════════════════════════════════

  public func updateTemporalPredictions(
    state : ChronoEngineState,
    currentValue : Float,  // Current observation
    learningRate : Float   // ACh-modulated learning rate
  ) : ChronoEngineState {
    // Update short-term predictions (0-10 beats = 0-0.83 seconds)
    var newShort = Array.thaw<Float>(state.shortTermPredictions);
    var shortIdx = 0;
    while (shortIdx < 10) {
      if (shortIdx == 0) {
        // 1-beat-ahead prediction
        let predicted = newShort[0];
        let error = currentValue - predicted;
        newShort[0] := predicted + learningRate * error;
      } else {
        // Multi-step prediction (shift + decay)
        newShort[shortIdx] := newShort[shortIdx - 1] * 0.95;
      };
      shortIdx += 1;
    };
    
    // Update medium-term predictions (11-100 beats = 0.9-8.3 seconds)
    var newMedium = Array.thaw<Float>(state.mediumTermPredictions);
    var medIdx = 0;
    while (medIdx < 90) {
      if (medIdx == 0) {
        // Transfer from short-term
        newMedium[0] := newShort[9] * 0.9 + currentValue * 0.1;
      } else {
        // Exponential decay
        newMedium[medIdx] := newMedium[medIdx - 1] * 0.98;
      };
      medIdx += 1;
    };
    
    // Update long-term predictions (101-1000 beats = 8.4-83 seconds)
    var newLong = Array.thaw<Float>(state.longTermPredictions);
    var longIdx = 0;
    while (longIdx < 900) {
      if (longIdx == 0) {
        // Transfer from medium-term
        newLong[0] := newMedium[89] * 0.95 + currentValue * 0.05;
      } else {
        // Slow decay
        newLong[longIdx] := newLong[longIdx - 1] * 0.995;
      };
      longIdx += 1;
    };
    
    {
      state with
      shortTermPredictions = Array.freeze(newShort);
      mediumTermPredictions = Array.freeze(newMedium);
      longTermPredictions = Array.freeze(newLong);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // CIRCADIAN & ULTRADIAN RHYTHM TRACKING
  // ═══════════════════════════════════════════════════════════════════════════

  public func updateCircadianRhythms(
    state : ChronoEngineState,
    beat : Nat,
    melatonin : Float,    // MEL is circadian marker
    cortisol : Float      // CORT has circadian rhythm
  ) : ChronoEngineState {
    // Update circadian phase (24-hour cycle)
    let circadianOmega = τ / Float.fromInt(BEATS_PER_DAY);  // Radians per beat
    var newCircadianPhase = state.circadianPhase + circadianOmega;
    
    // Wrap to [0, τ)
    if (newCircadianPhase >= τ) {
      newCircadianPhase := newCircadianPhase - τ;
    };
    
    // Update ultradian phase (90-minute cycle)
    let ultradianOmega = τ / Float.fromInt(BEATS_PER_ULTRADIAN);
    var newUltradianPhase = state.ultradianPhase + ultradianOmega;
    
    if (newUltradianPhase >= τ) {
      newUltradianPhase := newUltradianPhase - τ;
    };
    
    // Entrainment: use melatonin to phase-lock circadian rhythm
    // Expected melatonin = high at night (phase π to 2π), low during day (phase 0 to π)
    let expectedMelatonin = if (newCircadianPhase > π) {
      1.5  // Night: high melatonin
    } else {
      0.6  // Day: low melatonin
    };
    
    let melatoninError = melatonin - expectedMelatonin;
    let phaseCorrection = melatoninError * 0.001;  // Small phase shift based on error
    
    newCircadianPhase := newCircadianPhase + phaseCorrection;
    
    {
      state with
      circadianPhase = newCircadianPhase;
      ultradianPhase = newUltradianPhase;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMPORAL INTEGRATION WINDOWS
  // Integrate information over adaptive time windows
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeIntegrationWindow(
    coherenceTime : Float,       // τ_coherence (how long patterns stay coherent)
    predictionError : Float,     // Current prediction error
    norepinephrine : Float       // NE modulates window size
  ) : Nat {
    // Window size inversely proportional to prediction error
    // High error = short window (volatile environment)
    // Low error = long window (stable environment)
    
    let errorFactor = 1.0 / (predictionError + 0.1);
    
    // Norepinephrine increases window size (arousal → broader temporal integration)
    let neFactor = 1.0 + norepinephrine * 0.5;
    
    // Coherence time sets maximum window
    let maxWindow = Float.toInt(coherenceTime);
    
    // Compute window
    let windowSize = Float.toInt(errorFactor * neFactor * 12.0);  // Base: 12 beats = 1 second
    
    Nat.min(maxWindow, Nat.max(1, windowSize))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMPORAL BINDING ACROSS EVENTS
  // Determine if two events are temporally bound (part of same percept)
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeTemporalBinding(
    event1Beat : Nat,
    event2Beat : Nat,
    integrationWindow : Nat,
    chronoPrecision : Float
  ) : Bool {
    // Events are bound if they fall within integration window
    let timeDiff = if (event2Beat > event1Beat) {
      event2Beat - event1Beat
    } else {
      event1Beat - event2Beat
    };
    
    // Precision modulates effective window size
    let effectiveWindow = Float.fromInt(integrationWindow) * chronoPrecision;
    
    Float.fromInt(timeDiff) <= effectiveWindow
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // EXTERNAL RHYTHM ENTRAINMENT
  // Synchronize internal rhythms to external pacemakers
  // ═══════════════════════════════════════════════════════════════════════════

  public func entrainToExternalRhythm(
    state : ChronoEngineState,
    externalPhase : Float,       // External rhythm phase
    externalStrength : Float     // How strong the external signal is
  ) : ChronoEngineState {
    // Compute phase error
    let phaseError = externalPhase - state.circadianPhase;
    
    // Kuramoto-style entrainment
    let entrainmentRate = externalStrength * 0.01;
    let phaseCorrection = Float.sin(phaseError) * entrainmentRate;
    
    // Apply phase correction
    let newCircadianPhase = state.circadianPhase + phaseCorrection;
    
    // Update entrainment strength (EMA)
    let newEntrainmentStrength = state.entrainmentStrength * 0.95 + externalStrength * 0.05;
    
    {
      state with
      circadianPhase = newCircadianPhase;
      entrainmentStrength = newEntrainmentStrength;
      phaseError = phaseError;
      externalRhythmPhase = externalPhase;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MASTER CHRONO UPDATE FUNCTION
  // Called every beat to update all temporal processing
  // ═══════════════════════════════════════════════════════════════════════════

  public func updateChronoEngine(
    state : ChronoEngineState,
    beat : Nat,
    currentValue : Float,       // Current observation
    dopamine : Float,            // DA for interval timing
    norepinephrine : Float,      // NE for arousal
    acetylcholine : Float,       // ACh for learning rate
    melatonin : Float,           // MEL for circadian
    cortisol : Float,            // CORT for circadian
    predictionError : Float,     // Prediction error
    eventOccurred : Bool         // Whether a timing event occurred
  ) : ChronoEngineState {
    let dt = 1.0 / BEATS_PER_SECOND;  // 0.0833 seconds per beat
    
    // Step 1: Update Fisher information
    // Create phase history from beat number
    let phaseHistory = Array.tabulate<Float>(10, func(i) {
      Float.fromInt(beat - (9 - i)) * τ / 1000.0  // Wrap every 1000 beats
    });
    let fisherResult = computeFisherInformation(phaseHistory, dt);
    
    // Step 2: Update interval timing
    let stateWithTiming = updateIntervalTiming(state, eventOccurred, dopamine);
    
    // Step 3: Update temporal predictions
    let stateWithPredictions = updateTemporalPredictions(
      stateWithTiming,
      currentValue,
      acetylcholine * 0.1  // ACh learning rate
    );
    
    // Step 4: Update circadian rhythms
    let stateWithRhythms = updateCircadianRhythms(
      stateWithPredictions,
      beat,
      melatonin,
      cortisol
    );
    
    // Step 5: Update integration window
    let newWindow = computeIntegrationWindow(
      state.coherenceTime,
      predictionError,
      norepinephrine
    );
    
    // Step 6: Update performance metrics
    // Prediction accuracy (compare short-term prediction to actual)
    let predictedValue = stateWithRhythms.shortTermPredictions[0];
    let predError = Float.abs(currentValue - predictedValue);
    let newAccuracy = state.predictionAccuracy * 0.95 + (1.0 - predError) * 0.05;
    
    // Timing precision from interval confidence
    let newTimingPrecision = stateWithRhythms.intervalConfidence;
    
    // Rhythm stability from Fisher information (high Fisher = stable rhythm)
    let newRhythmStability = 1.0 / (fisherResult.cramerRao + 1.0);
    
    // Increment measurement count
    let newMeasurementCount = state.measurementCount + 1;
    
    // Compute phase precision
    let newPhasePrecision = fisherResult.cramerRao;
    
    {
      stateWithRhythms with
      fisherInformation = fisherResult.fisherInfo;
      cramerRaoBound = fisherResult.cramerRao;
      measurementCount = newMeasurementCount;
      phasePrecision = newPhasePrecision;
      integrationWindow = newWindow;
      predictionAccuracy = newAccuracy;
      timingPrecision = newTimingPrecision;
      rhythmStability = newRhythmStability;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // CHRONO-MODULATED LEARNING WINDOWS
  // Temporal precision affects STDP windows, consolidation windows, etc.
  // ═══════════════════════════════════════════════════════════════════════════

  public func getSTDPWindow(chronoPrecision : Float) : {
    tauPlus : Float;   // LTP time constant
    tauMinus : Float;  // LTD time constant
  } {
    // High precision = narrow window (precise timing required)
    // Low precision = wide window (loose timing acceptable)
    
    let baseTau = 20.0;  // 20 beats = 1.67 seconds
    let precisionFactor = 1.0 / chronoPrecision;
    
    let tauPlus = baseTau * precisionFactor;
    let tauMinus = baseTau * precisionFactor;
    
    { tauPlus = tauPlus; tauMinus = tauMinus }
  };

  public func getConsolidationWindow(chronoPrecision : Float, melatonin : Float) : Nat {
    // Consolidation window: when to transfer working → long-term memory
    // High precision + high melatonin = frequent consolidation
    
    let basePeriod = 50;  // 50 beats = 4.17 seconds
    let precisionFactor = chronoPrecision;
    let sleepFactor = melatonin;
    
    let period = Float.toInt(Float.fromInt(basePeriod) / (precisionFactor * sleepFactor + 0.1));
    
    Nat.max(10, Nat.min(100, period))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMPORAL RESOLUTION CALCULATION
  // How finely can the organism resolve temporal events?
  // ═══════════════════════════════════════════════════════════════════════════

  public func getTemporalResolution(chronoPrecision : Float) : {
    resolutionBeats : Nat;      // Minimum distinguishable interval (beats)
    resolutionSeconds : Float;  // Minimum distinguishable interval (seconds)
    resolutionMs : Float;       // Minimum distinguishable interval (milliseconds)
  } {
    // Temporal resolution limited by Cramér-Rao bound
    let minResolutionBeats = Float.toInt(chronoPrecision * 12.0);  // At 12 Hz
    let resBeats = Nat.max(1, minResolutionBeats);
    let resSeconds = Float.fromInt(resBeats) / BEATS_PER_SECOND;
    let resMs = resSeconds * 1000.0;
    
    {
      resolutionBeats = resBeats;
      resolutionSeconds = resSeconds;
      resolutionMs = resMs;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUBSECOND TIMING PRECISION (Mantis/Bee Level)
  // For strike timing, evasion, waggle dance encoding
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeSubsecondPrecision(
    state : ChronoEngineState,
    mantisActivation : Float,    // MANTIS animal engine (precision specialist)
    beeActivation : Float,       // BEE waggle dance timing
    glutamate : Float,           // Glu enables fast processing
    acetylcholine : Float        // ACh attention
  ) : Float {
    // Base subsecond precision from Fisher information
    let basePrecision = 1.0 / (state.cramerRaoBound + 0.1);
    
    // Animal boosts
    let mantisPrecisionBoost = (mantisActivation - 1.0) * 0.5;  // Mantis strike = extreme precision
    let beePrecisionBoost = (beeActivation - 1.0) * 0.3;        // Bee waggle = high precision
    
    // Neurochemical boosts
    let glutamateFastProcessing = (glutamate - 1.0) * 0.2;      // Glu enables fast neural processing
    let achAttentionBoost = (acetylcholine - 1.0) * 0.25;      // ACh attention to timing
    
    // Total precision
    let totalPrecision = basePrecision * (1.0 + mantisPrecisionBoost + beePrecisionBoost + 
                                          glutamateFastProcessing + achAttentionBoost);
    
    Float.max(0.1, Float.min(10.0, totalPrecision))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMPORAL CONTEXT WINDOWS FOR DECISION MAKING
  // Different decisions require different temporal contexts
  // ═══════════════════════════════════════════════════════════════════════════

  public type TemporalContextWindows = {
    reflexWindow : Nat;         // Reflex decisions (1-5 beats = 83-417 ms)
    tacticalWindow : Nat;       // Tactical decisions (10-50 beats = 0.83-4.17 seconds)
    strategicWindow : Nat;      // Strategic decisions (100-1000 beats = 8.3-83 seconds)
    planningWindow : Nat;       // Planning decisions (1000-10000 beats = 83-833 seconds)
  };

  public func getTemporalContextWindows(
    state : ChronoEngineState,
    cnidarianActivation : Float,   // CNIDARIAN = reflexes
    sharkActivation : Float,        // SHARK = tactical
    ravenActivation : Float,        // RAVEN = strategic
    elephantActivation : Float      // ELEPHANT = long-term planning
  ) : TemporalContextWindows {
    // Reflex window (cnidarian nerve net)
    let reflexBase = 3;  // 3 beats = 250 ms
    let reflexWindow = Float.toInt(Float.fromInt(reflexBase) * cnidarianActivation);
    
    // Tactical window (shark strike calculation)
    let tacticalBase = 30;  // 30 beats = 2.5 seconds
    let tacticalWindow = Float.toInt(Float.fromInt(tacticalBase) * sharkActivation);
    
    // Strategic window (raven multi-step planning)
    let strategicBase = 300;  // 300 beats = 25 seconds
    let strategicWindow = Float.toInt(Float.fromInt(strategicBase) * ravenActivation);
    
    // Planning window (elephant long-term memory)
    let planningBase = 3000;  // 3000 beats = 250 seconds
    let planningWindow = Float.toInt(Float.fromInt(planningBase) * elephantActivation);
    
    {
      reflexWindow = Nat.max(1, reflexWindow);
      tacticalWindow = Nat.max(10, tacticalWindow);
      strategicWindow = Nat.max(100, strategicWindow);
      planningWindow = Nat.max(1000, planningWindow);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMPORAL ANOMALY DETECTION
  // Detect violations of expected temporal patterns
  // ═══════════════════════════════════════════════════════════════════════════

  public func detectTemporalAnomaly(
    state : ChronoEngineState,
    currentValue : Float,
    beat : Nat
  ) : { isAnomaly : Bool; anomalyScore : Float; anomalyType : Text } {
    // Check short-term prediction
    let shortPredicted = state.shortTermPredictions[0];
    let shortError = Float.abs(currentValue - shortPredicted);
    
    // Check medium-term prediction
    let mediumPredicted = state.mediumTermPredictions[0];
    let mediumError = Float.abs(currentValue - mediumPredicted);
    
    // Check circadian expectation
    let circadianExpected = 1.0 + 0.2 * Float.sin(state.circadianPhase);
    let circadianError = Float.abs(currentValue - circadianExpected);
    
    // Anomaly if any prediction fails significantly
    let shortAnomaly = shortError > 0.5;
    let mediumAnomaly = mediumError > 0.4;
    let circadianAnomaly = circadianError > 0.6;
    
    let isAnomaly = shortAnomaly or mediumAnomaly or circadianAnomaly;
    
    let anomalyScore = shortError * 0.4 + mediumError * 0.3 + circadianError * 0.3;
    
    let anomalyType = if (shortAnomaly and not mediumAnomaly) {
      "TRANSIENT"  // Short-term anomaly
    } else if (mediumAnomaly and not circadianAnomaly) {
      "SUSTAINED"  // Medium-term anomaly
    } else if (circadianAnomaly) {
      "SYSTEMIC"   // Circadian disruption
    } else {
      "NONE"
    };
    
    {
      isAnomaly = isAnomaly;
      anomalyScore = anomalyScore;
      anomalyType = anomalyType;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // CHRONO DIAGNOSTIC FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  public func diagnoseChronoState(state : ChronoEngineState) : {
    overallHealth : Text;
    fisherInfoStatus : Text;
    predictionStatus : Text;
    rhythmStatus : Text;
    warnings : [Text];
  } {
    var warnings = Buffer.Buffer<Text>(5);
    
    // Fisher information assessment
    let fisherStatus = if (state.fisherInformation > 5.0) {
      "EXCELLENT - high temporal precision"
    } else if (state.fisherInformation > 2.0) {
      "GOOD - moderate precision"
    } else if (state.fisherInformation > 0.5) {
      "FAIR - low precision"
    } else {
      warnings.add("LOW FISHER INFORMATION - temporal precision degraded");
      "POOR - very low precision"
    };
    
    // Prediction assessment
    let predStatus = if (state.predictionAccuracy > 0.8) {
      "EXCELLENT - accurate predictions"
    } else if (state.predictionAccuracy > 0.6) {
      "GOOD - moderate accuracy"
    } else {
      warnings.add("LOW PREDICTION ACCURACY - temporal model degraded");
      "POOR - low accuracy"
    };
    
    // Rhythm assessment
    let rhythmStatus = if (state.rhythmStability > 0.8) {
      "STABLE - rhythms coherent"
    } else if (state.rhythmStability > 0.5) {
      "MODERATE - some rhythm drift"
    } else {
      warnings.add("RHYTHM INSTABILITY - internal clocks desynchronized");
      "UNSTABLE - rhythm breakdown"
    };
    
    // Overall health
    let healthScore = (state.fisherInformation / 5.0 + state.predictionAccuracy + state.rhythmStability) / 3.0;
    let overallHealth = if (healthScore > 0.8) {
      "HEALTHY"
    } else if (healthScore > 0.6) {
      "MODERATE"
    } else {
      "IMPAIRED"
    };
    
    // Additional warnings
    if (state.cramerRaoBound > 1.0) {
      warnings.add("HIGH CRAMÉR-RAO BOUND - timing uncertainty elevated");
    };
    if (Float.abs(state.phaseError) > 0.5) {
      warnings.add("PHASE ERROR - internal/external rhythm mismatch");
    };
    
    {
      overallHealth = overallHealth;
      fisherInfoStatus = fisherStatus;
      predictionStatus = predStatus;
      rhythmStatus = rhythmStatus;
      warnings = Buffer.toArray(warnings);
    }
  };

};
