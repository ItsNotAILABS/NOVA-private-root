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


// ============================================================
// SPIDER WEB — VIBRATION ANALYSIS & TENSION MAPPING
// Extended phenotype sensing, prey localization
// Frequency analysis (10-1000 Hz), tension field mapping
// References: Vollrath (1992), Masters & Markl (1981)
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Constants ─────────────────────────────────────────────────
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let NUM_RADIALS : Nat = 24;      // Radial threads
  let NUM_SPIRALS : Nat = 30;      // Spiral threads
  let WEB_NODES : Nat = 720;       // Total intersection points

  // ── Types ─────────────────────────────────────────────────────
  public type WebThread = {
    id          : Nat;
    threadType  : ThreadType;
    tension     : Float;       // 0-1 normalized tension
    integrity   : Float;       // 0-1 thread health
    vibrating   : Bool;
    vibrationFreq: Float;      // Hz
    vibrationAmp : Float;      // Amplitude
    lastRepair  : Nat;         // Beat of last repair
  };

  public type ThreadType = {
    #Radial;        // Structural (non-sticky)
    #Spiral;        // Capture spiral (sticky)
    #Frame;         // Outer frame
    #Hub;           // Central hub
    #Signal;        // Dedicated signal thread
  };

  public type VibrationEvent = {
    sourceNode  : Nat;         // Node index
    frequency   : Float;       // Hz
    amplitude   : Float;       // Strength
    timestamp   : Nat;         // Beat detected
    eventType   : VibrationEventType;
    direction   : Float;       // Angle from hub (degrees)
    distance    : Float;       // Distance from hub (normalized)
  };

  public type VibrationEventType = {
    #Prey;          // Struggling insect
    #Wind;          // Environmental
    #Courtship;     // Male approach
    #Predator;      // Threat
    #Damage;        // Web damage
    #Unknown;
  };

  public type WebTensionMap = {
    nodes       : [Float];     // Tension at each node
    gradient    : [Float];     // Tension gradient direction
    uniformity  : Float;       // How uniform is tension
    integrity   : Float;       // Overall web health
  };

  public type SpiderState = {
    // Web structure
    threads     : [WebThread];
    tensionMap  : WebTensionMap;
    webAge      : Nat;         // Beats since construction
    webQuality  : Float;       // Overall web condition

    // Vibration sensing
    recentVibrations : [VibrationEvent];
    vibrationBuffer  : [Float];    // Recent amplitudes (time series)
    frequencySpectrum: [Float];    // FFT-like frequency bins

    // Prey detection
    preyDetected     : Bool;
    preyLocation     : ?Nat;       // Node index
    preySize         : Float;      // Estimated from vibration
    preyState        : PreyState;

    // Position and behavior
    spiderPosition   : Nat;        // Current node (usually hub)
    orientationAngle : Float;      // Body orientation
    legPositions     : [Float];    // 8 leg positions on threads

    // Decision state
    alertLevel       : Float;      // 0-1 vigilance
    hungerLevel      : Float;      // Motivation to catch prey
    repairUrgency    : Float;      // Need to repair web

    // Learning
    preyPatterns     : [Float];    // Learned prey vibration signatures
    falseAlarmRate   : Float;      // Wind/other false positives

    beatNum          : Nat;
  };

  public type PreyState = {
    #None;
    #Detected;
    #Approaching;
    #Capturing;
    #Wrapping;
    #Consuming;
  };

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x: Float) : Float { if (x < 0.0) { -x } else { x } };
  func sqrt(x: Float) : Float { Float.sqrt(x) };

  // ══════════════════════════════════════════════════════════════
  // VIBRATION ANALYSIS
  // Detect and classify vibrations on web
  // ══════════════════════════════════════════════════════════════

  // Classify vibration type from frequency and amplitude
  public func classifyVibration(freq: Float, amp: Float, duration: Float) : VibrationEventType {
    // Prey: 10-100 Hz, intermittent, high amplitude
    // Wind: low frequency (< 20 Hz), continuous, variable amplitude
    // Courtship: specific frequency patterns (species-dependent)
    // Damage: sudden high amplitude, then decay

    if (freq < 15.0 and duration > 10.0) {
      #Wind
    } else if (freq > 20.0 and freq < 200.0 and amp > 0.3) {
      #Prey
    } else if (freq > 200.0 and amp < 0.2) {
      #Courtship
    } else if (amp > 0.8) {
      #Damage
    } else {
      #Unknown
    }
  };

  // Localize vibration source using timing across legs
  public func localizeVibration(
    legTimings: [Float],  // 8 arrival times at legs
    tensionMap: WebTensionMap
  ) : (Float, Float) {
    // Triangulate based on time differences
    // Returns (angle, distance)

    // Find first arrival (closest leg)
    var minTime : Float = legTimings[0];
    var minLeg : Nat = 0;
    var i = 1;
    while (i < 8 and i < legTimings.size()) {
      if (legTimings[i] < minTime) {
        minTime := legTimings[i];
        minLeg := i;
      };
      i += 1;
    };

    // Angle based on which leg detected first
    let angle = Float.fromInt(minLeg) * 45.0;

    // Distance from timing spread
    var maxTime : Float = 0.0;
    for (t in legTimings.vals()) {
      if (t > maxTime) { maxTime := t };
    };
    let timeSpread = maxTime - minTime;
    let distance = _clamp(timeSpread * 10.0, 0.0, 1.0);

    (angle, distance)
  };

  // Estimate prey size from vibration characteristics
  public func estimatePreySize(freq: Float, amp: Float) : Float {
    // Larger prey: lower frequency, higher amplitude
    let freqFactor = 1.0 - _clamp(freq / 200.0, 0.0, 1.0);
    let ampFactor = _clamp(amp, 0.0, 1.0);
    (freqFactor + ampFactor) / 2.0
  };

  // ══════════════════════════════════════════════════════════════
  // WEB TENSION MAPPING
  // Monitor and maintain web structural integrity
  // ══════════════════════════════════════════════════════════════

  // Compute tension uniformity (important for sensitivity)
  public func computeTensionUniformity(tensions: [Float]) : Float {
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    let n = Float.fromInt(tensions.size());

    for (t in tensions.vals()) {
      sum += t;
      sumSq += t * t;
    };

    let mean = sum / n;
    let variance = sumSq / n - mean * mean;
    let stdDev = sqrt(variance);

    // Low standard deviation = high uniformity
    _clamp(1.0 - stdDev * 2.0, 0.0, 1.0)
  };

  // Identify weak points in web
  public func findWeakPoints(threads: [WebThread]) : [Nat] {
    var weakPoints : [Nat] = [];
    var i = 0;
    for (t in threads.vals()) {
      if (t.integrity < 0.5 or t.tension < 0.3) {
        weakPoints := Array.append<Nat>(weakPoints, [i]);
      };
      i += 1;
    };
    weakPoints
  };

  // Update tension map based on vibration
  public func propagateVibration(
    tensionMap: WebTensionMap,
    sourceNode: Nat,
    amplitude: Float
  ) : WebTensionMap {
    // Vibration attenuates with distance from source
    var newNodes = Array.thaw<Float>(tensionMap.nodes);

    var i = 0;
    while (i < tensionMap.nodes.size()) {
      // Distance from source (simplified)
      let dist = abs(Float.fromInt(i) - Float.fromInt(sourceNode)) / Float.fromInt(tensionMap.nodes.size());
      let attenuation = Float.exp(-dist * 3.0);
      newNodes[i] := _clamp(tensionMap.nodes[i] + amplitude * attenuation, 0.0, 1.0);
      i += 1;
    };

    {
      nodes = Array.freeze(newNodes);
      gradient = tensionMap.gradient;
      uniformity = computeTensionUniformity(Array.freeze(newNodes));
      integrity = tensionMap.integrity;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // FREQUENCY ANALYSIS
  // Simple frequency decomposition of vibration signal
  // ══════════════════════════════════════════════════════════════

  public func analyzeFrequencies(signal: [Float]) : [Float] {
    // Simplified frequency analysis (not true FFT)
    // Returns energy in 10 frequency bins
    let numBins = 10;
    var bins = Array.init<Float>(numBins, 0.0);

    // Compute zero-crossings for rough frequency estimate
    var zeroCrossings : Nat = 0;
    var i = 1;
    while (i < signal.size()) {
      if ((signal[i - 1] < 0.0 and signal[i] >= 0.0) or
          (signal[i - 1] >= 0.0 and signal[i] < 0.0)) {
        zeroCrossings += 1;
      };
      i += 1;
    };

    // Estimate dominant frequency bin
    let dominantBin = Nat.min(numBins - 1, zeroCrossings / 10);

    // Distribute energy around dominant bin
    var j = 0;
    while (j < numBins) {
      let dist = abs(Float.fromInt(j) - Float.fromInt(dominantBin));
      bins[j] := Float.exp(-dist * 0.5);
      j += 1;
    };

    Array.freeze(bins)
  };

  // ══════════════════════════════════════════════════════════════
  // PREY CAPTURE DECISION
  // Decide whether to pursue detected vibration
  // ══════════════════════════════════════════════════════════════

  public func shouldPursue(
    event: VibrationEvent,
    hunger: Float,
    falseAlarmRate: Float
  ) : Bool {
    switch (event.eventType) {
      case (#Prey) {
        // Higher hunger = lower threshold
        let threshold = 0.3 - hunger * 0.2 + falseAlarmRate * 0.1;
        event.amplitude > threshold
      };
      case (_) { false };
    }
  };

  // ══════════════════════════════════════════════════════════════
  // WEB REPAIR LOGIC
  // ══════════════════════════════════════════════════════════════

  public func computeRepairUrgency(threads: [WebThread]) : Float {
    var totalDamage : Float = 0.0;
    var criticalDamage : Float = 0.0;

    for (t in threads.vals()) {
      let damage = 1.0 - t.integrity;
      totalDamage += damage;
      
      // Critical threads (radials, frame) weighted more
      switch (t.threadType) {
        case (#Radial) { criticalDamage += damage * 2.0 };
        case (#Frame) { criticalDamage += damage * 3.0 };
        case (_) { criticalDamage += damage };
      };
    };

    let avgDamage = totalDamage / Float.fromInt(threads.size());
    let weightedDamage = criticalDamage / Float.fromInt(threads.size() * 2);

    _clamp((avgDamage + weightedDamage) / 2.0, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════
  // FULL BEAT UPDATE
  // ══════════════════════════════════════════════════════════════

  public func beatSpider(
    state: SpiderState,
    vibrationInput: Float,
    legTimings: [Float],
    windLevel: Float
  ) : SpiderState {
    // 1. Update vibration buffer
    let newBuffer = if (state.vibrationBuffer.size() >= 100) {
      let shifted = Array.tabulate<Float>(99, func(i) { state.vibrationBuffer[i + 1] });
      Array.append<Float>(shifted, [vibrationInput])
    } else {
      Array.append<Float>(state.vibrationBuffer, [vibrationInput])
    };

    // 2. Analyze frequencies
    let newSpectrum = analyzeFrequencies(newBuffer);

    // 3. Detect vibration events
    let eventThreshold = 0.2 + windLevel * 0.3;  // Higher threshold in wind
    var newVibrations = state.recentVibrations;
    var newPreyDetected = state.preyDetected;
    var newPreyLocation = state.preyLocation;
    var newPreySize = state.preySize;
    var newPreyState = state.preyState;

    if (vibrationInput > eventThreshold) {
      // Localize
      let (angle, distance) = localizeVibration(legTimings, state.tensionMap);

      // Estimate frequency from spectrum
      var maxBin : Nat = 0;
      var maxEnergy : Float = 0.0;
      var i = 0;
      for (e in newSpectrum.vals()) {
        if (e > maxEnergy) {
          maxEnergy := e;
          maxBin := i;
        };
        i += 1;
      };
      let estFreq = Float.fromInt(maxBin) * 100.0 + 10.0;

      // Classify
      let eventType = classifyVibration(estFreq, vibrationInput, 1.0);

      // Create event
      let newEvent : VibrationEvent = {
        sourceNode = Nat.min(WEB_NODES - 1, Int.abs(Float.toInt(distance * Float.fromInt(WEB_NODES))));
        frequency = estFreq;
        amplitude = vibrationInput;
        timestamp = state.beatNum + 1;
        eventType = eventType;
        direction = angle;
        distance = distance;
      };

      newVibrations := if (state.recentVibrations.size() >= 20) {
        let shifted = Array.tabulate<VibrationEvent>(19, func(j) { state.recentVibrations[j + 1] });
        Array.append<VibrationEvent>(shifted, [newEvent])
      } else {
        Array.append<VibrationEvent>(state.recentVibrations, [newEvent])
      };

      // Update prey state
      switch (eventType) {
        case (#Prey) {
          newPreyDetected := true;
          newPreyLocation := ?newEvent.sourceNode;
          newPreySize := estimatePreySize(estFreq, vibrationInput);
          newPreyState := #Detected;
        };
        case (_) {};
      };
    };

    // 4. Update tension map
    let newTensionMap = if (vibrationInput > 0.1) {
      switch (newPreyLocation) {
        case (?loc) { propagateVibration(state.tensionMap, loc, vibrationInput) };
        case (null) { state.tensionMap };
      }
    } else {
      // Tension relaxes
      {
        nodes = Array.map<Float, Float>(state.tensionMap.nodes, func(n) { n * 0.99 });
        gradient = state.tensionMap.gradient;
        uniformity = state.tensionMap.uniformity;
        integrity = state.tensionMap.integrity;
      }
    };

    // 5. Update thread integrity (slow decay)
    let newThreads = Array.map<WebThread, WebThread>(state.threads, func(t) {
      {
        id = t.id;
        threadType = t.threadType;
        tension = t.tension * 0.9999;
        integrity = t.integrity * 0.9999;
        vibrating = vibrationInput > 0.1;
        vibrationFreq = if (vibrationInput > 0.1) { 50.0 } else { 0.0 };
        vibrationAmp = vibrationInput;
        lastRepair = t.lastRepair;
      }
    });

    // 6. Update repair urgency
    let newRepairUrgency = computeRepairUrgency(newThreads);

    // 7. Update web quality
    var totalIntegrity : Float = 0.0;
    for (t in newThreads.vals()) { totalIntegrity += t.integrity };
    let newWebQuality = totalIntegrity / Float.fromInt(newThreads.size());

    // 8. Update alert level
    let newAlertLevel = _clamp(
      state.alertLevel * 0.95 + vibrationInput * 0.1,
      0.0, 1.0
    );

    // 9. Update hunger (slowly increases)
    let newHunger = _clamp(state.hungerLevel + 0.0001, 0.0, 1.0);

    // 10. Update false alarm rate (learning)
    let newFalseAlarmRate = if (vibrationInput > eventThreshold) {
      switch (classifyVibration(50.0, vibrationInput, 1.0)) {
        case (#Wind) { _clamp(state.falseAlarmRate + 0.01, 0.0, 0.5) };
        case (#Unknown) { _clamp(state.falseAlarmRate + 0.005, 0.0, 0.5) };
        case (_) { _clamp(state.falseAlarmRate - 0.001, 0.0, 0.5) };
      }
    } else { state.falseAlarmRate };

    {
      threads = newThreads;
      tensionMap = newTensionMap;
      webAge = state.webAge + 1;
      webQuality = newWebQuality;
      recentVibrations = newVibrations;
      vibrationBuffer = newBuffer;
      frequencySpectrum = newSpectrum;
      preyDetected = newPreyDetected;
      preyLocation = newPreyLocation;
      preySize = newPreySize;
      preyState = newPreyState;
      spiderPosition = state.spiderPosition;
      orientationAngle = state.orientationAngle;
      legPositions = state.legPositions;
      alertLevel = newAlertLevel;
      hungerLevel = newHunger;
      repairUrgency = newRepairUrgency;
      preyPatterns = state.preyPatterns;
      falseAlarmRate = newFalseAlarmRate;
      beatNum = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  public func initSpider() : SpiderState {
    // Create initial threads (simplified)
    let threads = Array.tabulate<WebThread>(NUM_RADIALS + NUM_SPIRALS, func(i) {
      {
        id = i;
        threadType = if (i < NUM_RADIALS) { #Radial } else { #Spiral };
        tension = 0.7;
        integrity = 1.0;
        vibrating = false;
        vibrationFreq = 0.0;
        vibrationAmp = 0.0;
        lastRepair = 0;
      }
    });

    {
      threads = threads;
      tensionMap = {
        nodes = Array.tabulate<Float>(WEB_NODES, func(_) { 0.7 });
        gradient = Array.tabulate<Float>(WEB_NODES, func(_) { 0.0 });
        uniformity = 0.9;
        integrity = 1.0;
      };
      webAge = 0;
      webQuality = 1.0;
      recentVibrations = [];
      vibrationBuffer = [];
      frequencySpectrum = Array.tabulate<Float>(10, func(_) { 0.0 });
      preyDetected = false;
      preyLocation = null;
      preySize = 0.0;
      preyState = #None;
      spiderPosition = 0;  // Hub
      orientationAngle = 0.0;
      legPositions = Array.tabulate<Float>(8, func(i) { Float.fromInt(i) * 45.0 });
      alertLevel = 0.3;
      hungerLevel = 0.5;
      repairUrgency = 0.0;
      preyPatterns = [];
      falseAlarmRate = 0.1;
      beatNum = 0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════

  public type SpiderSummary = {
    webQuality       : Float;
    alertLevel       : Float;
    preyDetected     : Bool;
    preySize         : Float;
    repairUrgency    : Float;
    tensionUniformity: Float;
    recentVibrations : Nat;
  };

  public func summary(state: SpiderState) : SpiderSummary {
    {
      webQuality = state.webQuality;
      alertLevel = state.alertLevel;
      preyDetected = state.preyDetected;
      preySize = state.preySize;
      repairUrgency = state.repairUrgency;
      tensionUniformity = state.tensionMap.uniformity;
      recentVibrations = state.recentVibrations.size();
    }
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
  //  A N I M A L   I N T E L L I G E N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Biomimetic Cognitive Algorithms
  //  Full HIM/HER Integration with Animal Brain Dynamics
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SWARM INTELLIGENCE MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reynolds flocking: Separation force
  public func animalSeparationForce(
    position : (Float, Float),
    neighbors : [(Float, Float)],
    separationRadius : Float
  ) : (Float, Float) {
    var forceX : Float = 0.0;
    var forceY : Float = 0.0;
    var i = 0;
    while (i < neighbors.size()) {
      let (nx, ny) = neighbors[i];
      let dx = position.0 - nx;
      let dy = position.1 - ny;
      let dist = Float.sqrt(dx * dx + dy * dy);
      if (dist > 0.0001 and dist < separationRadius) {
        let strength = (separationRadius - dist) / separationRadius;
        forceX += (dx / dist) * strength;
        forceY += (dy / dist) * strength;
      };
      i += 1;
    };
    (forceX, forceY)
  };

  /// Reynolds flocking: Alignment force
  public func animalAlignmentForce(
    velocity : (Float, Float),
    neighborVelocities : [(Float, Float)]
  ) : (Float, Float) {
    if (neighborVelocities.size() == 0) { return (0.0, 0.0) };
    var avgVx : Float = 0.0;
    var avgVy : Float = 0.0;
    var i = 0;
    while (i < neighborVelocities.size()) {
      let (vx, vy) = neighborVelocities[i];
      avgVx += vx;
      avgVy += vy;
      i += 1;
    };
    let n = Float.fromInt(neighborVelocities.size());
    avgVx /= n;
    avgVy /= n;
    (avgVx - velocity.0, avgVy - velocity.1)
  };

  /// Reynolds flocking: Cohesion force
  public func animalCohesionForce(
    position : (Float, Float),
    neighbors : [(Float, Float)]
  ) : (Float, Float) {
    if (neighbors.size() == 0) { return (0.0, 0.0) };
    var centerX : Float = 0.0;
    var centerY : Float = 0.0;
    var i = 0;
    while (i < neighbors.size()) {
      let (nx, ny) = neighbors[i];
      centerX += nx;
      centerY += ny;
      i += 1;
    };
    let n = Float.fromInt(neighbors.size());
    centerX /= n;
    centerY /= n;
    (centerX - position.0, centerY - position.1)
  };

  /// Ant colony pheromone update
  public func animalPheromoneUpdate(
    current : Float,
    deposit : Float,
    evaporationRate : Float,
    dt : Float
  ) : Float {
    (current + deposit) * (1.0 - evaporationRate * dt)
  };

  /// Ant path probability
  public func animalAntPathProbability(
    pheromone : Float,
    distance : Float,
    alpha : Float,
    beta : Float
  ) : Float {
    let pheromoneFactor = Float.pow(pheromone + 0.01, alpha);
    let distanceFactor = Float.pow(1.0 / (distance + 0.01), beta);
    pheromoneFactor * distanceFactor
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ECHOLOCATION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Doppler shift for moving target
  public func animalDopplerShift(
    emittedFreq : Float,
    targetVelocity : Float,
    soundSpeed : Float
  ) : Float {
    emittedFreq * (soundSpeed + targetVelocity) / soundSpeed
  };

  /// Echo time-of-flight to distance
  public func animalEchoDistance(timeOfFlight : Float, soundSpeed : Float) : Float {
    (timeOfFlight * soundSpeed) / 2.0
  };

  /// Echo intensity decay
  public func animalEchoIntensity(
    sourceIntensity : Float,
    distance : Float,
    attenuation : Float
  ) : Float {
    sourceIntensity * Float.exp(-attenuation * distance) / (distance * distance + 0.01)
  };

  /// Azimuth from interaural time difference
  public func animalAzimuthFromITD(itd : Float, headRadius : Float, soundSpeed : Float) : Float {
    Float.asin(itd * soundSpeed / headRadius)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // VISUAL PROCESSING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Retinal ganglion cell receptive field (DoG)
  public func animalDoGReceptiveField(
    x : Float,
    y : Float,
    sigmaCenter : Float,
    sigmaSurround : Float,
    centerStrength : Float,
    surroundStrength : Float
  ) : Float {
    let rSquared = x * x + y * y;
    let center = centerStrength * Float.exp(-rSquared / (2.0 * sigmaCenter * sigmaCenter));
    let surround = surroundStrength * Float.exp(-rSquared / (2.0 * sigmaSurround * sigmaSurround));
    center - surround
  };

  /// Gabor filter response
  public func animalGaborResponse(
    x : Float,
    y : Float,
    wavelength : Float,
    orientation : Float,
    sigma : Float,
    aspectRatio : Float
  ) : Float {
    let xTheta = x * Float.cos(orientation) + y * Float.sin(orientation);
    let yTheta = -x * Float.sin(orientation) + y * Float.cos(orientation);
    let gaussian = Float.exp(-(xTheta * xTheta + aspectRatio * aspectRatio * yTheta * yTheta) / (2.0 * sigma * sigma));
    let sinusoid = Float.cos(2.0 * 3.14159265 * xTheta / wavelength);
    gaussian * sinusoid
  };

  /// Motion energy from V1 simple cells
  public func animalMotionEnergy(
    leftwardResponse : Float,
    rightwardResponse : Float
  ) : Float {
    leftwardResponse * leftwardResponse - rightwardResponse * rightwardResponse
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NAVIGATION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Magnetic field sensing (magnetoreception)
  public func animalMagneticHeading(
    fieldX : Float,
    fieldY : Float
  ) : Float {
    Float.atan2(fieldY, fieldX)
  };

  /// Polarized light sensing
  public func animalPolarizationAngle(
    intensity0 : Float,
    intensity45 : Float,
    intensity90 : Float
  ) : Float {
    0.5 * Float.atan2(intensity45 - intensity90, intensity0 - intensity90)
  };

  /// Path integration
  public func animalPathIntegration(
    currentX : Float,
    currentY : Float,
    velocity : Float,
    heading : Float,
    dt : Float
  ) : (Float, Float) {
    let dx = velocity * Float.cos(heading) * dt;
    let dy = velocity * Float.sin(heading) * dt;
    (currentX + dx, currentY + dy)
  };

  /// Grid cell firing pattern
  public func animalGridCellFiring(
    x : Float,
    y : Float,
    gridSpacing : Float,
    gridOrientation : Float
  ) : Float {
    let theta1 : Float = gridOrientation;
    let theta2 : Float = gridOrientation + 1.0472;  // +60 degrees
    let theta3 : Float = gridOrientation + 2.0944;  // +120 degrees
    let k = 4.0 * 3.14159265 / (gridSpacing * Float.sqrt(3.0));
    let u1 = Float.cos(k * (x * Float.cos(theta1) + y * Float.sin(theta1)));
    let u2 = Float.cos(k * (x * Float.cos(theta2) + y * Float.sin(theta2)));
    let u3 = Float.cos(k * (x * Float.cos(theta3) + y * Float.sin(theta3)));
    (u1 + u2 + u3) / 3.0
  };

  /// Place cell firing
  public func animalPlaceCellFiring(
    x : Float,
    y : Float,
    centerX : Float,
    centerY : Float,
    fieldRadius : Float
  ) : Float {
    let dx = x - centerX;
    let dy = y - centerY;
    let distSquared = dx * dx + dy * dy;
    Float.exp(-distSquared / (2.0 * fieldRadius * fieldRadius))
  };

  /// Head direction cell
  public func animalHeadDirectionFiring(
    currentHeading : Float,
    preferredHeading : Float,
    tuningWidth : Float
  ) : Float {
    let diff = currentHeading - preferredHeading;
    Float.exp(-diff * diff / (2.0 * tuningWidth * tuningWidth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // DECISION MAKING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Drift-diffusion model
  public func animalDriftDiffusion(
    evidence : Float,
    drift : Float,
    noise : Float,
    threshold : Float,
    dt : Float
  ) : (Float, Bool) {
    let newEvidence = evidence + drift * dt + noise * Float.sqrt(dt);
    let decided = Float.abs(newEvidence) >= threshold;
    (newEvidence, decided)
  };

  /// Winner-take-all competition
  public func animalWinnerTakeAll(
    activities : [Float],
    inhibition : Float
  ) : [Float] {
    var maxActivity : Float = 0.0;
    var i = 0;
    while (i < activities.size()) {
      if (activities[i] > maxActivity) { maxActivity := activities[i] };
      i += 1;
    };
    Array.tabulate<Float>(activities.size(), func(j : Nat) : Float {
      let diff = activities[j] - maxActivity;
      if (diff < -inhibition) { 0.0 } else { activities[j] }
    })
  };

  /// Urgency signal
  public func animalUrgencySignal(time : Float, gain : Float, offset : Float) : Float {
    offset + gain * time
  };

}
