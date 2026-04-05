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
// ███████╗██╗  ██╗ █████╗ ██████╗ ██╗  ██╗     █████╗ ███╗   ██╗██╗███╗   ███╗ █████╗ ██╗     
// ██╔════╝██║  ██║██╔══██╗██╔══██╗██║ ██╔╝    ██╔══██╗████╗  ██║██║████╗ ████║██╔══██╗██║     
// ███████╗███████║███████║██████╔╝█████╔╝     ███████║██╔██╗ ██║██║██╔████╔██║███████║██║     
// ╚════██║██╔══██║██╔══██║██╔══██╗██╔═██╗     ██╔══██║██║╚██╗██║██║██║╚██╔╝██║██╔══██║██║     
// ███████║██║  ██║██║  ██║██║  ██║██║  ██╗    ██║  ██║██║ ╚████║██║██║ ╚═╝ ██║██║  ██║███████╗
// ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝
//                                                                                               
// ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗                                              
// ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝                                              
// █████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗                                                
// ██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝                                                
// ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗                                              
// ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝                                              
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// SHARK ANIMAL ENGINE — APEX PREDATOR COGNITIVE ARCHITECTURE
// Threat Tracking | Territorial Memory | Kill-Zone Geometry | Electroreception | Blood Detection
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// SHARK BIOLOGY — WHY SHARKS ARE THE APEX PREDATOR
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Sharks have survived 450 million years — longer than trees.
// They are evolution's perfected predator. The organism learns from:
//
// 1. ELECTRORECEPTION (Ampullae of Lorenzini)
//    • Detect electric fields as weak as 5 nanovolts/cm
//    • Can sense heartbeat of prey hidden under sand
//    • Navigate using Earth's magnetic field
//    • IN ORGANISM: Detect subtle signals others miss
//
// 2. LATERAL LINE SYSTEM
//    • Pressure waves detected along entire body
//    • Sense movement from 100+ meters away
//    • Triangulate prey position from water displacement
//    • IN ORGANISM: Environmental awareness, vibration detection
//
// 3. BLOOD DETECTION (Olfaction)
//    • Detect 1 part blood per 25 million parts water
//    • Can smell prey from kilometers away
//    • Different nares for directional sensing
//    • IN ORGANISM: Detect weakness, opportunity from minimal signals
//
// 4. TERRITORIAL MEMORY
//    • Remember productive hunting grounds for years
//    • Return to same areas seasonally
//    • Know every contour of their territory
//    • IN ORGANISM: Remember profitable setups, favorable conditions
//
// 5. KILL-ZONE GEOMETRY
//    • Spiral approach from below (sun blinds prey)
//    • Calculate intercept trajectory
//    • Burst speed at attack moment
//    • IN ORGANISM: Optimal entry timing, position sizing
//
// 6. THREAT HIERARCHY
//    • Know which targets are worth pursuing
//    • Abort unprofitable attacks
//    • Risk assessment before commitment
//    • IN ORGANISM: Trade selection, risk/reward calculation
//
// 7. BURST PATIENCE CYCLE
//    • Can cruise for hours conserving energy
//    • Explosive acceleration when opportunity strikes
//    • Back to patience immediately after
//    • IN ORGANISM: Wait for setups, execute decisively
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";

module SharkAnimalEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRED CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.6180339887498948482;
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.7182818284590452354;
  public let S0 : Float = 1.0;
  
  // Shark-specific constants
  public let ELECTRORECEPTION_THRESHOLD : Float = 0.000000005;  // 5 nanovolts
  public let BLOOD_DETECTION_RATIO : Float = 0.00000004;        // 1 in 25 million
  public let LATERAL_LINE_RANGE : Float = 100.0;                // meters
  public let BURST_SPEED_MULTIPLIER : Float = 3.0;              // 3x cruising speed
  public let KILL_ZONE_ANGLE : Float = 0.5236;                  // 30 degrees (below prey)
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ELECTRORECEPTION SYSTEM (Ampullae of Lorenzini)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ElectricSignal = {
    voltage : Float;              // Nanovolts
    frequency : Float;            // Hz
    direction : [Float];          // 3D unit vector
    distance : Float;             // Estimated distance
    signalType : ElectricSignalType;
    confidence : Float;           // Detection confidence [0, 1]
  };
  
  public type ElectricSignalType = {
    #Heartbeat;                   // Living prey
    #Muscle;                      // Movement
    #Neural;                      // Brain activity
    #Magnetic;                    // Earth's field
    #Artificial;                  // Man-made
    #Unknown;
  };
  
  public type AmpullaeState = {
    // Sensor array (simulated as sectors)
    leftArray : [Float];          // 6 sectors on left
    rightArray : [Float];         // 6 sectors on right
    ventralArray : [Float];       // 6 sectors below
    
    // Detected signals
    activeSignals : [ElectricSignal];
    strongestSignal : ?ElectricSignal;
    
    // Magnetic navigation
    magneticHeading : Float;      // Radians
    magneticIntensity : Float;
    magneticDeclination : Float;
    
    // Sensitivity state
    sensitivity : Float;          // Can be modulated
    noiseFloor : Float;
    signalToNoise : Float;
    
    // Statistics
    detectionCount : Nat;
    lastDetectionBeat : Nat;
  };
  
  // Initialize electroreception system
  public func initAmpullae() : AmpullaeState {
    {
      leftArray = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      rightArray = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      ventralArray = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      activeSignals = [];
      strongestSignal = null;
      magneticHeading = 0.0;
      magneticIntensity = 50.0;   // μT (Earth's field)
      magneticDeclination = 0.0;
      sensitivity = 1.0;
      noiseFloor = ELECTRORECEPTION_THRESHOLD * 0.1;
      signalToNoise = 10.0;
      detectionCount = 0;
      lastDetectionBeat = 0;
    }
  };
  
  // Process electric signal
  public func processElectricSignal(
    ampullae : AmpullaeState,
    rawVoltage : Float,
    direction : [Float],
    currentBeat : Nat
  ) : (AmpullaeState, ?ElectricSignal) {
    // Check if signal exceeds threshold
    if (rawVoltage < ELECTRORECEPTION_THRESHOLD * ampullae.sensitivity) {
      return (ampullae, null);
    };
    
    // Classify signal type based on frequency/pattern
    let signalType : ElectricSignalType = if (rawVoltage > 0.0001) {
      #Muscle
    } else if (rawVoltage > 0.00001) {
      #Heartbeat
    } else if (rawVoltage > 0.000001) {
      #Neural
    } else {
      #Unknown
    };
    
    // Estimate distance from signal strength (inverse square law)
    let distance = if (rawVoltage > 0.0) {
      _sqrt(1.0 / rawVoltage)
    } else {
      LATERAL_LINE_RANGE
    };
    
    // Create signal
    let signal : ElectricSignal = {
      voltage = rawVoltage;
      frequency = 1.0;  // Would be determined from signal analysis
      direction = direction;
      distance = distance;
      signalType = signalType;
      confidence = _clamp(rawVoltage / 0.0001, 0.0, 1.0);
    };
    
    // Update ampullae state
    let newSignals = Buffer.Buffer<ElectricSignal>(ampullae.activeSignals.size() + 1);
    for (s in ampullae.activeSignals.vals()) {
      newSignals.add(s);
    };
    newSignals.add(signal);
    
    let newState : AmpullaeState = {
      leftArray = ampullae.leftArray;
      rightArray = ampullae.rightArray;
      ventralArray = ampullae.ventralArray;
      activeSignals = Buffer.toArray(newSignals);
      strongestSignal = ?signal;
      magneticHeading = ampullae.magneticHeading;
      magneticIntensity = ampullae.magneticIntensity;
      magneticDeclination = ampullae.magneticDeclination;
      sensitivity = ampullae.sensitivity;
      noiseFloor = ampullae.noiseFloor;
      signalToNoise = rawVoltage / ampullae.noiseFloor;
      detectionCount = ampullae.detectionCount + 1;
      lastDetectionBeat = currentBeat;
    };
    
    (newState, ?signal)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LATERAL LINE SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type PressureWave = {
    amplitude : Float;            // Pressure change
    frequency : Float;            // Hz
    direction : [Float];          // Source direction
    velocity : Float;             // Wave velocity
    distance : Float;             // Estimated source distance
    waveType : PressureWaveType;
  };
  
  public type PressureWaveType = {
    #Swimming;                    // Prey movement
    #Struggling;                  // Distressed prey
    #Predator;                    // Another predator
    #Current;                     // Water current
    #Ambient;                     // Background noise
  };
  
  public type LateralLineState = {
    // Neuromasts along body
    headNeuromasts : [Float];     // 10 sensors
    trunkNeuromasts : [Float];    // 20 sensors
    tailNeuromasts : [Float];     // 10 sensors
    
    // Detected waves
    activeWaves : [PressureWave];
    dominantWave : ?PressureWave;
    
    // Environmental awareness
    currentDirection : [Float];
    currentSpeed : Float;
    turbulenceLevel : Float;
    
    // Triangulation
    targetPosition : ?[Float];
    targetVelocity : ?[Float];
    trackingConfidence : Float;
    
    // Statistics
    waveCount : Nat;
    lastWaveBeat : Nat;
  };
  
  public func initLateralLine() : LateralLineState {
    {
      headNeuromasts = Array.tabulate<Float>(10, func(_) { 0.0 });
      trunkNeuromasts = Array.tabulate<Float>(20, func(_) { 0.0 });
      tailNeuromasts = Array.tabulate<Float>(10, func(_) { 0.0 });
      activeWaves = [];
      dominantWave = null;
      currentDirection = [1.0, 0.0, 0.0];
      currentSpeed = 0.1;
      turbulenceLevel = 0.2;
      targetPosition = null;
      targetVelocity = null;
      trackingConfidence = 0.0;
      waveCount = 0;
      lastWaveBeat = 0;
    }
  };
  
  // Triangulate target position from pressure waves
  public func triangulateTarget(
    lateralLine : LateralLineState,
    waves : [PressureWave]
  ) : ?[Float] {
    if (waves.size() < 2) { return null };
    
    // Simple triangulation from two waves
    let w1 = waves[0];
    let w2 = waves[1];
    
    // Weighted average of directions by amplitude
    let totalAmp = w1.amplitude + w2.amplitude;
    if (totalAmp < 0.001) { return null };
    
    let pos = Array.tabulate<Float>(3, func(i) {
      let d1 = if (i < w1.direction.size()) { w1.direction[i] } else { 0.0 };
      let d2 = if (i < w2.direction.size()) { w2.direction[i] } else { 0.0 };
      (d1 * w1.amplitude + d2 * w2.amplitude) / totalAmp
    });
    
    ?pos
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // OLFACTORY SYSTEM (Blood Detection)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type OlfactorySignal = {
    concentration : Float;        // Parts per million
    chemical : ChemicalType;
    direction : [Float];          // Gradient direction
    gradient : Float;             // Concentration gradient
    freshness : Float;            // How recent [0, 1]
  };
  
  public type ChemicalType = {
    #Blood;
    #Amino;                       // Amino acids (food)
    #Bile;                        // Stressed prey
    #Pheromone;                   // Conspecifics
    #Toxin;                       // Danger
    #Unknown;
  };
  
  public type OlfactoryState = {
    // Dual nares for directional sensing
    leftNareConc : Float;
    rightNareConc : Float;
    concentrationDiff : Float;    // Stereo smell
    
    // Active scents
    activeScents : [OlfactorySignal];
    strongestScent : ?OlfactorySignal;
    
    // Blood detection
    bloodDetected : Bool;
    bloodConcentration : Float;
    bloodDirection : [Float];
    bloodDistance : Float;        // Estimated from concentration
    
    // Tracking state
    followingGradient : Bool;
    gradientStrength : Float;
    
    // Statistics
    detectionCount : Nat;
    bloodDetectionCount : Nat;
    lastDetectionBeat : Nat;
  };
  
  public func initOlfactory() : OlfactoryState {
    {
      leftNareConc = 0.0;
      rightNareConc = 0.0;
      concentrationDiff = 0.0;
      activeScents = [];
      strongestScent = null;
      bloodDetected = false;
      bloodConcentration = 0.0;
      bloodDirection = [0.0, 0.0, 0.0];
      bloodDistance = Float.abs(1.0 / 0.0);  // Infinity
      followingGradient = false;
      gradientStrength = 0.0;
      detectionCount = 0;
      bloodDetectionCount = 0;
      lastDetectionBeat = 0;
    }
  };
  
  // Process blood detection
  public func detectBlood(
    olfactory : OlfactoryState,
    leftConc : Float,
    rightConc : Float,
    currentBeat : Nat
  ) : OlfactoryState {
    let avgConc = (leftConc + rightConc) / 2.0;
    let diff = rightConc - leftConc;
    
    // Check if blood detected (1 part in 25 million = 0.00000004)
    let isBlood = avgConc > BLOOD_DETECTION_RATIO;
    
    // Estimate distance from concentration (inverse relationship)
    let estimatedDist = if (avgConc > 0.0) {
      _sqrt(1.0 / avgConc) * 100.0  // Scale factor
    } else {
      10000.0  // Very far
    };
    
    // Direction from concentration difference
    let direction = if (_abs(diff) > 0.0000001) {
      if (diff > 0.0) { [1.0, 0.0, 0.0] } else { [-1.0, 0.0, 0.0] }
    } else {
      [0.0, 0.0, 0.0]
    };
    
    {
      leftNareConc = leftConc;
      rightNareConc = rightConc;
      concentrationDiff = diff;
      activeScents = olfactory.activeScents;
      strongestScent = olfactory.strongestScent;
      bloodDetected = isBlood;
      bloodConcentration = avgConc;
      bloodDirection = direction;
      bloodDistance = estimatedDist;
      followingGradient = isBlood and _abs(diff) > BLOOD_DETECTION_RATIO * 0.1;
      gradientStrength = _abs(diff) / (avgConc + 0.0000001);
      detectionCount = olfactory.detectionCount + 1;
      bloodDetectionCount = if (isBlood) { olfactory.bloodDetectionCount + 1 } else { olfactory.bloodDetectionCount };
      lastDetectionBeat = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TERRITORIAL MEMORY
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type TerritoryZone = {
    id : Nat;
    center : [Float];             // 3D position
    radius : Float;
    quality : Float;              // Hunting quality [0, 1]
    lastVisit : Nat;              // Beat of last visit
    visitCount : Nat;
    successCount : Nat;           // Successful hunts
    preyDensity : Float;          // Estimated prey
    threatLevel : Float;          // Danger level
    seasonalPeak : Nat;           // Best season (beat of year)
  };
  
  public type TerritorialMemory = {
    // Known zones
    zones : [TerritoryZone];
    currentZone : ?Nat;           // Index of current zone
    homeZone : Nat;               // Primary territory
    
    // Patrol pattern
    patrolRoute : [Nat];          // Zone indices in order
    patrolPosition : Nat;         // Current position in route
    
    // Memory statistics
    totalZones : Nat;
    memorizedZones : Nat;
    averageQuality : Float;
    
    // Navigation
    currentPosition : [Float];
    targetZone : ?Nat;
    distanceToTarget : Float;
    
    // Temporal patterns
    bestHuntingTime : Nat;        // Beat of day (circadian)
    bestHuntingSeason : Nat;      // Beat of year
    
    lastUpdate : Nat;
  };
  
  public func initTerritorialMemory(homePosition : [Float]) : TerritorialMemory {
    let homeZone : TerritoryZone = {
      id = 0;
      center = homePosition;
      radius = 1000.0;            // meters
      quality = 0.5;
      lastVisit = 0;
      visitCount = 1;
      successCount = 0;
      preyDensity = 0.5;
      threatLevel = 0.1;
      seasonalPeak = 0;
    };
    
    {
      zones = [homeZone];
      currentZone = ?0;
      homeZone = 0;
      patrolRoute = [0];
      patrolPosition = 0;
      totalZones = 1;
      memorizedZones = 1;
      averageQuality = 0.5;
      currentPosition = homePosition;
      targetZone = null;
      distanceToTarget = 0.0;
      bestHuntingTime = 0;
      bestHuntingSeason = 0;
      lastUpdate = 0;
    }
  };
  
  // Record successful hunt at location
  public func recordHunt(
    memory : TerritorialMemory,
    position : [Float],
    success : Bool,
    currentBeat : Nat
  ) : TerritorialMemory {
    // Find or create zone
    var foundZone : ?Nat = null;
    var zones = Buffer.Buffer<TerritoryZone>(memory.zones.size() + 1);
    
    var i = 0;
    for (zone in memory.zones.vals()) {
      let dist = _distance3D(position, zone.center);
      if (dist < zone.radius) {
        foundZone := ?i;
        // Update existing zone
        zones.add({
          id = zone.id;
          center = zone.center;
          radius = zone.radius;
          quality = zone.quality * 0.9 + (if (success) { 0.1 } else { 0.0 });
          lastVisit = currentBeat;
          visitCount = zone.visitCount + 1;
          successCount = if (success) { zone.successCount + 1 } else { zone.successCount };
          preyDensity = zone.preyDensity;
          threatLevel = zone.threatLevel;
          seasonalPeak = zone.seasonalPeak;
        });
      } else {
        zones.add(zone);
      };
      i += 1;
    };
    
    // Create new zone if not found
    let newZoneCount = switch (foundZone) {
      case (null) {
        let newZone : TerritoryZone = {
          id = memory.totalZones;
          center = position;
          radius = 500.0;
          quality = if (success) { 0.6 } else { 0.3 };
          lastVisit = currentBeat;
          visitCount = 1;
          successCount = if (success) { 1 } else { 0 };
          preyDensity = 0.5;
          threatLevel = 0.1;
          seasonalPeak = currentBeat % 86400;  // Simplified
        };
        zones.add(newZone);
        memory.totalZones + 1
      };
      case (?_) { memory.totalZones };
    };
    
    // Calculate average quality
    var qualitySum : Float = 0.0;
    for (z in zones.vals()) {
      qualitySum += z.quality;
    };
    let avgQuality = qualitySum / Float.fromInt(zones.size());
    
    {
      zones = Buffer.toArray(zones);
      currentZone = foundZone;
      homeZone = memory.homeZone;
      patrolRoute = memory.patrolRoute;
      patrolPosition = memory.patrolPosition;
      totalZones = newZoneCount;
      memorizedZones = zones.size();
      averageQuality = avgQuality;
      currentPosition = position;
      targetZone = memory.targetZone;
      distanceToTarget = memory.distanceToTarget;
      bestHuntingTime = memory.bestHuntingTime;
      bestHuntingSeason = memory.bestHuntingSeason;
      lastUpdate = currentBeat;
    }
  };
  
  // Find best hunting zone
  public func findBestHuntingZone(memory : TerritorialMemory) : ?TerritoryZone {
    var best : ?TerritoryZone = null;
    var bestScore : Float = 0.0;
    
    for (zone in memory.zones.vals()) {
      // Score = quality × prey density / (1 + threat level)
      let score = zone.quality * zone.preyDensity / (1.0 + zone.threatLevel);
      if (score > bestScore) {
        bestScore := score;
        best := ?zone;
      };
    };
    
    best
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // KILL-ZONE GEOMETRY
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type AttackVector = {
    approachAngle : Float;        // Radians from vertical
    approachAzimuth : Float;      // Radians horizontal
    distance : Float;             // Current distance to target
    closingSpeed : Float;         // Rate of approach
    interceptTime : Float;        // Estimated time to intercept
    sunAngle : Float;             // Use sun to blind prey
    optimalEntry : Bool;          // Is this the optimal vector?
  };
  
  public type KillZone = {
    targetPosition : [Float];
    targetVelocity : [Float];
    killRadius : Float;           // Strike range
    optimalApproach : AttackVector;
    alternateApproach : ?AttackVector;
    
    // Geometry calculations
    interceptPoint : [Float];     // Where to strike
    leadAngle : Float;            // Account for target movement
    burstDistance : Float;        // When to accelerate
    
    // State
    inKillZone : Bool;
    attackReady : Bool;
    abortThreshold : Float;       // When to abort
    
    // Timing
    windowOpen : Bool;
    windowDuration : Float;       // Beats
    
    lastCalculation : Nat;
  };
  
  public type AttackState = {
    #Patrolling;
    #Tracking;
    #Approaching;
    #Positioning;
    #BurstApproach;
    #Strike;
    #Recovery;
    #Abort;
  };
  
  public type KillZoneState = {
    // Current attack state
    attackState : AttackState;
    
    // Active kill zone
    activeKillZone : ?KillZone;
    
    // Attack history
    totalAttacks : Nat;
    successfulAttacks : Nat;
    abortedAttacks : Nat;
    
    // Approach parameters
    spiralRadius : Float;         // Spiral approach pattern
    approachDepth : Float;        // Attack from below
    burstSpeed : Float;
    cruiseSpeed : Float;
    
    // Energy management
    energyReserve : Float;        // [0, 1]
    burstCost : Float;
    recoveryCost : Float;
    
    lastStateBeat : Nat;
  };
  
  public func initKillZoneState() : KillZoneState {
    {
      attackState = #Patrolling;
      activeKillZone = null;
      totalAttacks = 0;
      successfulAttacks = 0;
      abortedAttacks = 0;
      spiralRadius = 50.0;
      approachDepth = 20.0;
      burstSpeed = 15.0;          // m/s
      cruiseSpeed = 5.0;          // m/s
      energyReserve = 1.0;
      burstCost = 0.3;
      recoveryCost = 0.1;
      lastStateBeat = 0;
    }
  };
  
  // Calculate kill zone geometry
  public func calculateKillZone(
    targetPos : [Float],
    targetVel : [Float],
    sharkPos : [Float],
    sharkVel : [Float],
    sunAngle : Float
  ) : KillZone {
    // Distance to target
    let distance = _distance3D(targetPos, sharkPos);
    
    // Calculate intercept point (lead the target)
    let closingSpeed = _magnitude(sharkVel) + _magnitude(targetVel);
    let interceptTime = if (closingSpeed > 0.01) { distance / closingSpeed } else { 1000.0 };
    
    let interceptPoint = Array.tabulate<Float>(3, func(i) {
      let tp = if (i < targetPos.size()) { targetPos[i] } else { 0.0 };
      let tv = if (i < targetVel.size()) { targetVel[i] } else { 0.0 };
      tp + tv * interceptTime
    });
    
    // Optimal approach: from below, using sun
    let approachAngle = KILL_ZONE_ANGLE;  // 30 degrees below
    let sunBehind = _abs(sunAngle - PI) < PI / 4.0;  // Sun at shark's back
    
    let optimalApproach : AttackVector = {
      approachAngle = approachAngle;
      approachAzimuth = if (sunBehind) { sunAngle + PI } else { 0.0 };
      distance = distance;
      closingSpeed = closingSpeed;
      interceptTime = interceptTime;
      sunAngle = sunAngle;
      optimalEntry = sunBehind and distance < 30.0;
    };
    
    {
      targetPosition = targetPos;
      targetVelocity = targetVel;
      killRadius = 2.0;           // 2 meter strike range
      optimalApproach = optimalApproach;
      alternateApproach = null;
      interceptPoint = interceptPoint;
      leadAngle = Float.arctan2(targetVel[1], targetVel[0]);
      burstDistance = 10.0;       // Start burst at 10m
      inKillZone = distance < 10.0;
      attackReady = distance < 10.0 and closingSpeed > 5.0;
      abortThreshold = 50.0;      // Abort if distance exceeds
      windowOpen = distance < 20.0;
      windowDuration = interceptTime;
      lastCalculation = 0;
    }
  };
  
  // Update attack state machine
  public func updateAttackState(
    state : KillZoneState,
    targetDetected : Bool,
    distance : Float,
    energy : Float,
    currentBeat : Nat
  ) : KillZoneState {
    let newState : AttackState = switch (state.attackState) {
      case (#Patrolling) {
        if (targetDetected) { #Tracking } else { #Patrolling }
      };
      case (#Tracking) {
        if (not targetDetected) { #Patrolling }
        else if (distance < 100.0) { #Approaching }
        else { #Tracking }
      };
      case (#Approaching) {
        if (not targetDetected) { #Patrolling }
        else if (distance < 30.0) { #Positioning }
        else if (distance > 150.0) { #Abort }
        else { #Approaching }
      };
      case (#Positioning) {
        if (not targetDetected) { #Abort }
        else if (distance < 10.0 and energy > 0.5) { #BurstApproach }
        else if (distance > 50.0) { #Abort }
        else { #Positioning }
      };
      case (#BurstApproach) {
        if (distance < 2.0) { #Strike }
        else if (distance > 20.0) { #Abort }
        else { #BurstApproach }
      };
      case (#Strike) {
        #Recovery
      };
      case (#Recovery) {
        if (energy > 0.7) { #Patrolling } else { #Recovery }
      };
      case (#Abort) {
        if (energy > 0.5) { #Patrolling } else { #Recovery }
      };
    };
    
    let isAbort = switch (newState) { case (#Abort) { true }; case (_) { false } };
    
    {
      attackState = newState;
      activeKillZone = state.activeKillZone;
      totalAttacks = state.totalAttacks + (switch (newState) { case (#Strike) { 1 }; case (_) { 0 } });
      successfulAttacks = state.successfulAttacks;  // Updated separately
      abortedAttacks = state.abortedAttacks + (if (isAbort) { 1 } else { 0 });
      spiralRadius = state.spiralRadius;
      approachDepth = state.approachDepth;
      burstSpeed = state.burstSpeed;
      cruiseSpeed = state.cruiseSpeed;
      energyReserve = energy;
      burstCost = state.burstCost;
      recoveryCost = state.recoveryCost;
      lastStateBeat = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // THREAT HIERARCHY
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ThreatEntity = {
    id : Nat;
    entityType : EntityType;
    position : [Float];
    velocity : [Float];
    size : Float;
    threatLevel : Float;          // [0, 1]
    preyValue : Float;            // [0, 1] (if prey)
    distance : Float;
    lastSeen : Nat;
    trackingConfidence : Float;
  };
  
  public type EntityType = {
    #Prey;
    #Predator;                    // Larger shark, orca
    #Competitor;                  // Same-size shark
    #Neutral;
    #Unknown;
  };
  
  public type ThreatHierarchy = {
    // Tracked entities
    entities : [ThreatEntity];
    
    // Prioritized lists
    prioritizedPrey : [Nat];      // Indices sorted by value
    prioritizedThreats : [Nat];   // Indices sorted by threat
    
    // Current focus
    primaryTarget : ?Nat;
    primaryThreat : ?Nat;
    
    // Risk assessment
    overallThreatLevel : Float;
    environmentalRisk : Float;
    
    // Decision thresholds
    pursueThreshold : Float;      // Minimum prey value to pursue
    fleeThreshold : Float;        // Threat level to trigger flight
    
    lastUpdate : Nat;
  };
  
  public func initThreatHierarchy() : ThreatHierarchy {
    {
      entities = [];
      prioritizedPrey = [];
      prioritizedThreats = [];
      primaryTarget = null;
      primaryThreat = null;
      overallThreatLevel = 0.0;
      environmentalRisk = 0.1;
      pursueThreshold = 0.3;
      fleeThreshold = 0.7;
      lastUpdate = 0;
    }
  };
  
  // Calculate prey value (risk/reward)
  public func calculatePreyValue(
    entity : ThreatEntity,
    energy : Float,
    distance : Float
  ) : Float {
    // Value = size × (1 - threat) / (distance × energy_cost)
    let energyCost = distance * 0.01;  // Energy per distance
    let netValue = entity.size * (1.0 - entity.threatLevel) / (distance * 0.1 + 1.0);
    
    // Adjust for current energy
    let energyFactor = if (energy < 0.3) { 0.5 } else { 1.0 };
    
    netValue * energyFactor
  };
  
  // Prioritize targets
  public func prioritizeTargets(hierarchy : ThreatHierarchy) : ThreatHierarchy {
    // Sort prey by value
    var preyValues = Buffer.Buffer<(Nat, Float)>(hierarchy.entities.size());
    var threatValues = Buffer.Buffer<(Nat, Float)>(hierarchy.entities.size());
    
    var i = 0;
    for (entity in hierarchy.entities.vals()) {
      switch (entity.entityType) {
        case (#Prey) {
          preyValues.add((i, entity.preyValue / (entity.distance + 1.0)));
        };
        case (#Predator) {
          threatValues.add((i, entity.threatLevel * (100.0 / (entity.distance + 1.0))));
        };
        case (#Competitor) {
          threatValues.add((i, entity.threatLevel * 0.5 * (100.0 / (entity.distance + 1.0))));
        };
        case (_) {};
      };
      i += 1;
    };
    
    // Simple sort by second element (would use proper sort)
    let sortedPrey = Buffer.toArray(preyValues);
    let sortedThreats = Buffer.toArray(threatValues);
    
    let preyIndices = Array.map<(Nat, Float), Nat>(sortedPrey, func(p) { p.0 });
    let threatIndices = Array.map<(Nat, Float), Nat>(sortedThreats, func(t) { t.0 });
    
    {
      entities = hierarchy.entities;
      prioritizedPrey = preyIndices;
      prioritizedThreats = threatIndices;
      primaryTarget = if (preyIndices.size() > 0) { ?preyIndices[0] } else { null };
      primaryThreat = if (threatIndices.size() > 0) { ?threatIndices[0] } else { null };
      overallThreatLevel = hierarchy.overallThreatLevel;
      environmentalRisk = hierarchy.environmentalRisk;
      pursueThreshold = hierarchy.pursueThreshold;
      fleeThreshold = hierarchy.fleeThreshold;
      lastUpdate = hierarchy.lastUpdate;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // BURST-PATIENCE CYCLE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type BurstPatienceState = {
    #Cruise;                      // Energy conservation
    #Alert;                       // Heightened awareness
    #Stalk;                       // Slow approach
    #Burst;                       // Maximum acceleration
    #PostBurst;                   // Recovery
  };
  
  public type EnergyManagement = {
    // Current state
    currentState : BurstPatienceState;
    
    // Energy levels
    totalEnergy : Float;          // [0, 1]
    burstReserve : Float;         // Reserved for burst
    cruiseReserve : Float;        // For sustained swimming
    
    // Speed
    currentSpeed : Float;
    cruiseSpeed : Float;
    maxBurstSpeed : Float;
    
    // Timing
    burstDuration : Nat;          // Beats in burst
    maxBurstDuration : Nat;
    cooldownRemaining : Nat;
    cooldownDuration : Nat;
    
    // Statistics
    burstCount : Nat;
    successfulBursts : Nat;
    averageBurstEfficiency : Float;
    
    lastStateBeat : Nat;
  };
  
  public func initEnergyManagement() : EnergyManagement {
    {
      currentState = #Cruise;
      totalEnergy = 1.0;
      burstReserve = 0.3;
      cruiseReserve = 0.7;
      currentSpeed = 5.0;
      cruiseSpeed = 5.0;
      maxBurstSpeed = 15.0;
      burstDuration = 0;
      maxBurstDuration = 10;
      cooldownRemaining = 0;
      cooldownDuration = 50;
      burstCount = 0;
      successfulBursts = 0;
      averageBurstEfficiency = 0.5;
      lastStateBeat = 0;
    }
  };
  
  // Update energy state
  public func updateEnergy(
    energy : EnergyManagement,
    targetDetected : Bool,
    inKillZone : Bool,
    currentBeat : Nat
  ) : EnergyManagement {
    // State machine
    let newState : BurstPatienceState = switch (energy.currentState) {
      case (#Cruise) {
        if (targetDetected) { #Alert }
        else { #Cruise }
      };
      case (#Alert) {
        if (not targetDetected) { #Cruise }
        else if (inKillZone and energy.cooldownRemaining == 0 and energy.burstReserve > 0.2) { #Burst }
        else { #Stalk }
      };
      case (#Stalk) {
        if (not targetDetected) { #Cruise }
        else if (inKillZone and energy.cooldownRemaining == 0 and energy.burstReserve > 0.2) { #Burst }
        else { #Stalk }
      };
      case (#Burst) {
        if (energy.burstDuration >= energy.maxBurstDuration or energy.burstReserve < 0.1) {
          #PostBurst
        } else {
          #Burst
        }
      };
      case (#PostBurst) {
        if (energy.cooldownRemaining == 0) { #Cruise }
        else { #PostBurst }
      };
    };
    
    // Energy calculations
    let energyDrain = switch (newState) {
      case (#Cruise) { 0.001 };
      case (#Alert) { 0.002 };
      case (#Stalk) { 0.003 };
      case (#Burst) { 0.05 };     // High energy drain
      case (#PostBurst) { 0.001 };
    };
    
    let energyRecovery = switch (newState) {
      case (#Cruise) { 0.005 };
      case (#PostBurst) { 0.003 };
      case (_) { 0.0 };
    };
    
    let newTotalEnergy = _clamp(energy.totalEnergy - energyDrain + energyRecovery, 0.0, 1.0);
    
    // Speed based on state
    let newSpeed = switch (newState) {
      case (#Cruise) { energy.cruiseSpeed };
      case (#Alert) { energy.cruiseSpeed * 1.2 };
      case (#Stalk) { energy.cruiseSpeed * 0.8 };
      case (#Burst) { energy.maxBurstSpeed };
      case (#PostBurst) { energy.cruiseSpeed * 0.5 };
    };
    
    // Burst timing
    let isBurst = switch (newState) { case (#Burst) { true }; case (_) { false } };
    let wasBurst = switch (energy.currentState) { case (#Burst) { true }; case (_) { false } };
    
    let newBurstDuration = if (isBurst) { energy.burstDuration + 1 } else { 0 };
    let newCooldown = if (wasBurst and not isBurst) {
      energy.cooldownDuration
    } else if (energy.cooldownRemaining > 0) {
      energy.cooldownRemaining - 1
    } else {
      0
    };
    
    {
      currentState = newState;
      totalEnergy = newTotalEnergy;
      burstReserve = newTotalEnergy * 0.3;
      cruiseReserve = newTotalEnergy * 0.7;
      currentSpeed = newSpeed;
      cruiseSpeed = energy.cruiseSpeed;
      maxBurstSpeed = energy.maxBurstSpeed;
      burstDuration = newBurstDuration;
      maxBurstDuration = energy.maxBurstDuration;
      cooldownRemaining = newCooldown;
      cooldownDuration = energy.cooldownDuration;
      burstCount = if (isBurst and not wasBurst) { energy.burstCount + 1 } else { energy.burstCount };
      successfulBursts = energy.successfulBursts;
      averageBurstEfficiency = energy.averageBurstEfficiency;
      lastStateBeat = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INTEGRATED SHARK STATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type SharkState = {
    // Sensory systems
    ampullae : AmpullaeState;
    lateralLine : LateralLineState;
    olfactory : OlfactoryState;
    
    // Memory & Navigation
    territorialMemory : TerritorialMemory;
    
    // Hunting
    killZone : KillZoneState;
    threatHierarchy : ThreatHierarchy;
    
    // Energy
    energy : EnergyManagement;
    
    // Position & Movement
    position : [Float];
    velocity : [Float];
    heading : Float;
    depth : Float;
    
    // State
    isHunting : Bool;
    isFleeing : Bool;
    isResting : Bool;
    
    // Statistics
    totalKills : Nat;
    totalMiles : Float;
    daysActive : Nat;
    
    beatNum : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH HELPERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  
  func _abs(x : Float) : Float { if (x < 0.0) -x else x };
  
  func _sqrt(x : Float) : Float {
    if (x <= 0.0) 0.0 else Float.sqrt(x)
  };
  
  func _distance3D(a : [Float], b : [Float]) : Float {
    var sumSq : Float = 0.0;
    var i = 0;
    while (i < 3) {
      let ai = if (i < a.size()) { a[i] } else { 0.0 };
      let bi = if (i < b.size()) { b[i] } else { 0.0 };
      sumSq += (ai - bi) * (ai - bi);
      i += 1;
    };
    _sqrt(sumSq)
  };
  
  func _magnitude(v : [Float]) : Float {
    var sumSq : Float = 0.0;
    for (x in v.vals()) { sumSq += x * x };
    _sqrt(sumSq)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initSharkState(startPosition : [Float], currentBeat : Nat) : SharkState {
    {
      ampullae = initAmpullae();
      lateralLine = initLateralLine();
      olfactory = initOlfactory();
      territorialMemory = initTerritorialMemory(startPosition);
      killZone = initKillZoneState();
      threatHierarchy = initThreatHierarchy();
      energy = initEnergyManagement();
      position = startPosition;
      velocity = [0.0, 0.0, 0.0];
      heading = 0.0;
      depth = 10.0;
      isHunting = false;
      isFleeing = false;
      isResting = false;
      totalKills = 0;
      totalMiles = 0.0;
      daysActive = 0;
      beatNum = currentBeat;
    }
  };
  
  // Main tick function
  public func tickShark(
    state : SharkState,
    sensoryInputs : {
      electricSignals : [(Float, [Float])];
      pressureWaves : [PressureWave];
      bloodConcentration : (Float, Float);
    },
    currentBeat : Nat
  ) : SharkState {
    // Process electroreception
    var newAmpullae = state.ampullae;
    for ((voltage, direction) in sensoryInputs.electricSignals.vals()) {
      let (updatedAmpullae, _) = processElectricSignal(newAmpullae, voltage, direction, currentBeat);
      newAmpullae := updatedAmpullae;
    };
    
    // Process blood detection
    let (leftConc, rightConc) = sensoryInputs.bloodConcentration;
    let newOlfactory = detectBlood(state.olfactory, leftConc, rightConc, currentBeat);
    
    // Determine if target detected
    let targetDetected = newOlfactory.bloodDetected or 
                         switch (newAmpullae.strongestSignal) { 
                           case (?_) { true }; 
                           case (null) { false } 
                         };
    
    // Update kill zone state
    let inKillZone = switch (state.killZone.activeKillZone) {
      case (?kz) { kz.inKillZone };
      case (null) { false };
    };
    let newKillZone = updateAttackState(state.killZone, targetDetected, 
                                        newOlfactory.bloodDistance, 
                                        state.energy.totalEnergy, currentBeat);
    
    // Update energy
    let newEnergy = updateEnergy(state.energy, targetDetected, inKillZone, currentBeat);
    
    // Determine hunting state
    let isHunting = switch (newKillZone.attackState) {
      case (#Patrolling) { false };
      case (#Recovery) { false };
      case (_) { true };
    };
    
    {
      ampullae = newAmpullae;
      lateralLine = state.lateralLine;
      olfactory = newOlfactory;
      territorialMemory = state.territorialMemory;
      killZone = newKillZone;
      threatHierarchy = state.threatHierarchy;
      energy = newEnergy;
      position = state.position;
      velocity = state.velocity;
      heading = state.heading;
      depth = state.depth;
      isHunting = isHunting;
      isFleeing = state.isFleeing;
      isResting = state.isResting;
      totalKills = state.totalKills;
      totalMiles = state.totalMiles + newEnergy.currentSpeed * 0.001;
      daysActive = state.daysActive;
      beatNum = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ORGANISM INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Convert shark behaviors to organism decisions
  public type SharkDecision = {
    action : SharkAction;
    confidence : Float;
    rationale : Text;
    energyCost : Float;
    expectedReward : Float;
    riskLevel : Float;
  };
  
  public type SharkAction = {
    #Wait;                        // Patience — wait for opportunity
    #Track;                       // Follow signal
    #Approach;                    // Move toward target
    #Strike;                      // Execute trade/action
    #Retreat;                     // Exit position
    #Conserve;                    // Preserve energy/capital
  };
  
  public func sharkDecide(state : SharkState) : SharkDecision {
    switch (state.killZone.attackState) {
      case (#Patrolling) {
        {
          action = #Wait;
          confidence = 0.8;
          rationale = "Patrolling — conserving energy, waiting for opportunity";
          energyCost = 0.01;
          expectedReward = 0.0;
          riskLevel = 0.1;
        }
      };
      case (#Tracking) {
        {
          action = #Track;
          confidence = 0.7;
          rationale = "Signal detected — tracking, not committing";
          energyCost = 0.02;
          expectedReward = 0.3;
          riskLevel = 0.2;
        }
      };
      case (#Approaching) {
        {
          action = #Approach;
          confidence = 0.75;
          rationale = "Target confirmed — approaching optimal position";
          energyCost = 0.03;
          expectedReward = 0.5;
          riskLevel = 0.3;
        }
      };
      case (#Positioning) {
        {
          action = #Approach;
          confidence = 0.85;
          rationale = "In kill zone — positioning for strike";
          energyCost = 0.04;
          expectedReward = 0.7;
          riskLevel = 0.4;
        }
      };
      case (#BurstApproach) {
        {
          action = #Strike;
          confidence = 0.9;
          rationale = "BURST — full commitment, executing strike";
          energyCost = state.energy.burstCost;
          expectedReward = 1.0;
          riskLevel = 0.6;
        }
      };
      case (#Strike) {
        {
          action = #Strike;
          confidence = 0.95;
          rationale = "STRIKE — moment of execution";
          energyCost = 0.1;
          expectedReward = 1.0;
          riskLevel = 0.5;
        }
      };
      case (#Recovery) {
        {
          action = #Conserve;
          confidence = 0.9;
          rationale = "Recovery — rebuilding energy reserves";
          energyCost = 0.005;
          expectedReward = 0.0;
          riskLevel = 0.1;
        }
      };
      case (#Abort) {
        {
          action = #Retreat;
          confidence = 0.85;
          rationale = "ABORT — conditions unfavorable, preserving capital";
          energyCost = 0.02;
          expectedReward = 0.0;
          riskLevel = 0.2;
        }
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type SharkDiagnostics = {
    huntingStatus : Text;
    energyStatus : Text;
    sensoryStatus : Text;
    territoryStatus : Text;
    killZoneStatus : Text;
    recommendation : Text;
  };
  
  public func diagnoseShark(state : SharkState) : SharkDiagnostics {
    let huntStatus = switch (state.killZone.attackState) {
      case (#Patrolling) { "PATROLLING — Waiting for opportunity" };
      case (#Tracking) { "TRACKING — Following signal" };
      case (#Approaching) { "APPROACHING — Moving to position" };
      case (#Positioning) { "POSITIONING — In kill zone" };
      case (#BurstApproach) { "BURST — Full commitment!" };
      case (#Strike) { "STRIKE — Executing!" };
      case (#Recovery) { "RECOVERY — Rebuilding" };
      case (#Abort) { "ABORT — Preserving resources" };
    };
    
    let energyStatus = if (state.energy.totalEnergy > 0.7) { "HIGH energy — ready for burst" }
      else if (state.energy.totalEnergy > 0.4) { "MODERATE energy — can hunt" }
      else { "LOW energy — should rest" };
    
    let sensoryStatus = if (state.olfactory.bloodDetected) { "BLOOD DETECTED — hunt active" }
      else { switch (state.ampullae.strongestSignal) {
        case (?_) { "Electric signal detected" };
        case (null) { "No targets detected" };
      }};
    
    let territoryStatus = "Knows " # Nat.toText(state.territorialMemory.memorizedZones) # 
                          " zones, quality " # Float.toText(state.territorialMemory.averageQuality);
    
    let killZoneStatus = Nat.toText(state.killZone.totalAttacks) # " attacks, " #
                         Nat.toText(state.killZone.successfulAttacks) # " successful, " #
                         Nat.toText(state.killZone.abortedAttacks) # " aborted";
    
    let recommendation = if (state.energy.totalEnergy < 0.3) {
      "REST — Energy critical"
    } else if (state.olfactory.bloodDetected and state.energy.totalEnergy > 0.5) {
      "HUNT — Opportunity detected, energy sufficient"
    } else {
      "PATROL — Wait for clear opportunity"
    };
    
    {
      huntingStatus = huntStatus;
      energyStatus = energyStatus;
      sensoryStatus = sensoryStatus;
      territoryStatus = territoryStatus;
      killZoneStatus = killZoneStatus;
      recommendation = recommendation;
    }
  };

}
