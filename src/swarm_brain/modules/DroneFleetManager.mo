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


// ═══════════════════════════════════════════════════════════════════════════════
// DRONE FLEET MANAGER — Swarm Coordination & Mini-Mind Integration
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// This module manages the entire drone fleet:
//   • Initialize N drones with mini-minds (DroneAvatar)
//   • Kuramoto phase synchronization across the swarm
//   • Value propagation from organism to drones
//   • Command dispatch to individual drones
//   • Formation control (sphere, wedge, grid, etc.)
//   • Competition against enemy AI swarms
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

module DroneFleetManager {

  // ═══════════════════════════════════════════════════════════════════════════
  // SELF-COMPOUNDING SCALE-INVARIANT ARCHITECTURE
  // ═══════════════════════════════════════════════════════════════════════════
  // 
  // THE FUNDAMENTAL TRUTH: The math doesn't change. Ever.
  // N = 50, N = 500, N = 500,000 — SAME EQUATIONS.
  //
  // KURAMOTO MEAN-FIELD (O(N)):
  //   dθᵢ/dt = ωᵢ + K·r·sin(ψ - θᵢ)
  //   where r·e^(iψ) = (1/N)Σⱼ e^(iθⱼ)
  //
  // This equation doesn't care about N. It computes the same way regardless.
  //
  // SQUADRON COUNT — Derived from N, not hardcoded:
  //   squadronCount = ceil(sqrt(N / 20))
  //   This gives natural scaling: N=100 → 3 squads, N=500 → 5 squads, 
  //   N=2000 → 10 squads, N=50000 → 50 squads
  //
  // DRONE TYPE — Pattern unfolds from golden angle:
  //   typeIndex = (id × φ) mod 13  where φ = 1.618...
  //   The golden ratio ensures uniform distribution across all types
  //
  // POSITION — Fibonacci sphere packing:
  //   θ = id × 2.39996 (golden angle)
  //   z = 1 - (2×id + 1)/N
  //   r = sqrt(1 - z²)
  //   (x, y, z) = (r×cos(θ), r×sin(θ), z)
  //
  // NO IF STATEMENTS. NO HARDCODED LIMITS. PURE MATH.
  // ═══════════════════════════════════════════════════════════════════════════
  
  // These are NOT limits — they are default starting values
  public let DEFAULT_FLEET_SIZE : Nat = 500;
  
  // Kuramoto synchronization — SCALE-INVARIANT
  public let KURAMOTO_K : Float = 0.618;         // Golden ratio coupling
  public let NATURAL_FREQ_BASE : Float = 0.1;    // ω₀
  public let NATURAL_FREQ_SPREAD : Float = 0.05; // Δω
  
  // Value propagation
  public let VALUE_INHERITANCE_RATE : Float = 0.95;
  public let ETHICAL_BOUND_ABSOLUTE : Float = 1.0;
  
  // PARALLAX self-funding economics
  public let CYCLE_COST_PER_DRONE_PER_BEAT : Float = 0.000001;
  public let FORMA_TO_CYCLE_RATE : Float = 0.01;
  public let COHERENCE_FORMA_THRESHOLD : Float = 0.5;
  
  // Mathematical constants
  public let PI : Float = 3.14159265358979;
  public let TWO_PI : Float = 6.28318530717958;
  public let PHI : Float = 1.6180339887;  // Golden ratio
  public let GOLDEN_ANGLE : Float = 2.39996322972865;  // 2π/φ² radians
  public let DT : Float = 0.0833;  // 1/12 Hz = 83.3ms
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PURE MATH FUNCTIONS — SELF-COMPOUNDING SCALE-INVARIANT DERIVATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  // These functions derive ALL structural parameters from N.
  // NO conditionals. NO hardcoded limits. PURE mathematical relationships.
  //
  // The pattern UNFOLDS from the math as N increases:
  //   N=50   → 2 squadrons, 25 drones each
  //   N=500  → 5 squadrons, 100 drones each  
  //   N=5000 → 16 squadrons, ~312 drones each
  //   N=50000 → 50 squadrons, 1000 drones each
  //
  // The equations are CONTINUOUS — they work for ANY N.
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Squadron count: ceil(sqrt(N / 20))
  // This gives ~20 drones minimum per squadron at any scale
  public func deriveSquadronCount(N: Nat) : Nat {
    let n = Float.fromInt(N);
    let sqrtN = Float.sqrt(n / 20.0);
    let count = Float.ceil(sqrtN);
    let result = Int.abs(Float.toInt(count));
    if (result < 1) 1 else result
  };
  
  // Drones per squadron: floor(N / squadronCount)
  public func deriveDronesPerSquadron(N: Nat, squadronCount: Nat) : Nat {
    N / squadronCount
  };
  
  // Squadron assignment for drone id: floor(id / dronesPerSquadron)
  public func deriveSquadron(id: Nat, N: Nat) : Nat {
    let squadCount = deriveSquadronCount(N);
    let perSquad = deriveDronesPerSquadron(N, squadCount);
    let squad = id / perSquad;
    if (squad >= squadCount) (squadCount - 1) else squad
  };
  
  // Is this drone a Sovereign? First drone of each squadron
  public func deriveSovereignStatus(id: Nat, N: Nat) : Bool {
    let squadCount = deriveSquadronCount(N);
    let perSquad = deriveDronesPerSquadron(N, squadCount);
    let squad = deriveSquadron(id, N);
    id == squad * perSquad
  };
  
  // Drone type: Golden ratio distribution across 13 types
  // typeIndex = floor((id × φ) mod 13)
  // This ensures uniform distribution regardless of N
  public func deriveDroneTypeIndex(id: Nat, N: Nat) : Nat {
    // Sovereigns are always type 11 (index for #Sovereign)
    if (deriveSovereignStatus(id, N)) { return 11 };
    
    // Golden ratio distribution for non-sovereigns
    let idFloat = Float.fromInt(id);
    let raw = idFloat * PHI;
    let modded = raw - Float.floor(raw / 13.0) * 13.0;
    let index = Int.abs(Float.toInt(Float.floor(modded)));
    // Skip index 11 (Sovereign) for non-sovereigns
    if (index >= 11) { (index + 1) % 13 } else { index }
  };
  
  // Fibonacci sphere position for drone id within fleet of N
  // This is optimal uniform sphere packing for ANY N
  public func deriveFibonacciSpherePosition(id: Nat, N: Nat, radius: Float) : (Float, Float, Float) {
    let i = Float.fromInt(id);
    let n = Float.fromInt(N);
    
    // z coordinate: linear distribution from +1 to -1
    let z = 1.0 - (2.0 * i + 1.0) / n;
    
    // radius at this z level
    let rZ = Float.sqrt(1.0 - z * z);
    
    // angle: golden angle spiral
    let theta = i * GOLDEN_ANGLE;
    
    // Cartesian coordinates on unit sphere, scaled by radius
    let x = radius * rZ * Float.cos(theta);
    let y = radius * rZ * Float.sin(theta);
    let zScaled = radius * z;
    
    (x, y, zScaled)
  };
  
  // Squadron center position: evenly distributed on circle
  // angle = squadron × (2π / squadronCount)
  public func deriveSquadronCenter(squadronIdx: Nat, squadronCount: Nat, orbitRadius: Float) : (Float, Float, Float) {
    let angle = Float.fromInt(squadronIdx) * TWO_PI / Float.fromInt(squadronCount);
    let x = orbitRadius * Float.cos(angle);
    let z = orbitRadius * Float.sin(angle);
    let y = 60.0;  // Base altitude
    (x, y, z)
  };
  
  // Drone altitude based on type (continuous function)
  // altitude = 30 + 50 × (typeParams.stealthFactor + typeParams.sensorRange/10000)
  public func deriveAltitude(typeParams: DroneTypeParams) : Float {
    30.0 + 50.0 * (typeParams.stealthFactor + typeParams.sensorRange / 10000.0)
  };
  
  // Natural frequency for drone: ω = ω₀ + Δω × sin(id × golden_angle)
  // This spreads frequencies smoothly regardless of N
  public func deriveNaturalFrequency(id: Nat) : Float {
    let idFloat = Float.fromInt(id);
    NATURAL_FREQ_BASE + NATURAL_FREQ_SPREAD * Float.sin(idFloat * GOLDEN_ANGLE)
  };
  
  // Initial phase: uniformly distributed around unit circle
  // θ = (id × golden_angle) mod 2π
  public func deriveInitialPhase(id: Nat) : Float {
    let raw = Float.fromInt(id) * GOLDEN_ANGLE;
    raw - Float.floor(raw / TWO_PI) * TWO_PI
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — DRONE STRUCTURES (10 SPECIALIZED TYPES FOR FUTURISTIC WARFARE)
  // ═══════════════════════════════════════════════════════════════════════════
  // Each drone type has different:
  //   • Speed, range, payload
  //   • Kuramoto coupling strength (how much it syncs)
  //   • Combat role
  //   • Energy consumption
  //
  // The math is the same for all types — only parameters differ.
  // This is how we build for 200,000 drones without code changes.
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type DroneClass = {
    // ═══════════════════════════════════════════════════════════════════════
    // TIER 1: RECONNAISSANCE & INTELLIGENCE
    // ═══════════════════════════════════════════════════════════════════════
    #Scout;         // Fast, small, long-range sensors, high stealth
                    // Speed: 120 km/h, Range: 50km, Payload: 0kg
                    // Role: Find enemies, map terrain, early warning
    
    #Recon;         // Medium speed, advanced sensors, SIGINT capability
                    // Speed: 80 km/h, Range: 30km, Payload: 2kg (sensors)
                    // Role: Electronic intelligence, comm intercept
    
    // ═══════════════════════════════════════════════════════════════════════
    // TIER 2: STRIKE & ATTACK
    // ═══════════════════════════════════════════════════════════════════════
    #Strike;        // Armed attack drone, precision munitions
                    // Speed: 100 km/h, Range: 25km, Payload: 10kg
                    // Role: Surgical strikes, high-value targets
    
    #Hunter;        // Anti-drone hunter-killer, fast & agile
                    // Speed: 150 km/h, Range: 15km, Payload: 2kg
                    // Role: Intercept enemy drones, dogfighting
    
    #Kamikaze;      // One-way explosive drone, maximum damage
                    // Speed: 200 km/h, Range: 100km, Payload: 20kg explosive
                    // Role: Destroy hardened targets, sacrifice for swarm
                    // Note: When sacrificed, triggers FORMA SACRIFICE_BONUS
    
    // ═══════════════════════════════════════════════════════════════════════
    // TIER 3: ELECTRONIC WARFARE & SUPPORT
    // ═══════════════════════════════════════════════════════════════════════
    #Jammer;        // Electronic warfare, disrupts enemy comms & sensors
                    // Speed: 60 km/h, Range: 20km, Payload: 15kg (EW gear)
                    // Role: Blind enemy swarm, break their Kuramoto sync
    
    #Relay;         // Communication backbone, mesh network node
                    // Speed: 70 km/h, Range: 40km, Payload: 5kg
                    // Role: Extend swarm range, backup Sovereign link
    
    #Decoy;         // Fake signature generator, draws fire
                    // Speed: 90 km/h, Range: 30km, Payload: 3kg
                    // Role: Distract enemy, absorb missiles, protect Sovereigns
    
    // ═══════════════════════════════════════════════════════════════════════
    // TIER 4: LOGISTICS & SUPPORT
    // ═══════════════════════════════════════════════════════════════════════
    #Carrier;       // Deploys micro-drones, mobile launch platform
                    // Speed: 50 km/h, Range: 20km, Payload: 50kg (10 micro-drones)
                    // Role: Expand swarm mid-mission, surprise attacks
    
    #Logistics;     // Resupply, battery swap, field repair
                    // Speed: 60 km/h, Range: 15km, Payload: 30kg
                    // Role: Keep other drones alive, energy injection
    
    #Medic;         // Emergency extraction, wounded pilot recovery
                    // Speed: 100 km/h, Range: 25km, Payload: 80kg
                    // Role: Save human operators, high ethical priority
    
    // ═══════════════════════════════════════════════════════════════════════
    // TIER 5: COMMAND & CONTROL
    // ═══════════════════════════════════════════════════════════════════════
    #Sovereign;     // Squadron commander, highest compute, strongest sync
                    // Speed: 80 km/h, Range: 30km, Payload: 20kg
                    // Role: Lead squadron, inter-squadron Kuramoto coupling
                    // Only 1 per squadron (5 total in 500-drone fleet)
    
    #MicroDrone;    // Tiny (10cm), deployed from Carrier, swarm-in-swarm
                    // Speed: 40 km/h, Range: 2km, Payload: 0.1kg
                    // Role: Infiltrate, overwhelm, N² superradiance at close range
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRONE TYPE PARAMETERS — The math that makes each type unique
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type DroneTypeParams = {
    speed           : Float;    // m/s
    range           : Float;    // meters
    payload         : Float;    // kg
    stealthFactor   : Float;    // 0-1 (1 = invisible)
    kuramotoK       : Float;    // Coupling strength
    energyRate      : Float;    // Energy consumption per beat
    combatPower     : Float;    // Damage output
    armorFactor     : Float;    // Damage reduction
    sensorRange     : Float;    // Detection range (meters)
    cyclesCostMult  : Float;    // ICP cycle cost multiplier
  };
  
  public func getDroneTypeParams(droneClass: DroneClass) : DroneTypeParams {
    switch (droneClass) {
      case (#Scout) {
        speed = 33.3; range = 50000.0; payload = 0.0; stealthFactor = 0.9;
        kuramotoK = 0.5; energyRate = 0.001; combatPower = 0.0; armorFactor = 0.1;
        sensorRange = 5000.0; cyclesCostMult = 0.5;
      };
      case (#Recon) {
        speed = 22.2; range = 30000.0; payload = 2.0; stealthFactor = 0.7;
        kuramotoK = 0.6; energyRate = 0.002; combatPower = 0.0; armorFactor = 0.2;
        sensorRange = 8000.0; cyclesCostMult = 0.8;
      };
      case (#Strike) {
        speed = 27.8; range = 25000.0; payload = 10.0; stealthFactor = 0.3;
        kuramotoK = 0.7; energyRate = 0.003; combatPower = 1.0; armorFactor = 0.4;
        sensorRange = 3000.0; cyclesCostMult = 1.0;
      };
      case (#Hunter) {
        speed = 41.7; range = 15000.0; payload = 2.0; stealthFactor = 0.5;
        kuramotoK = 0.8; energyRate = 0.004; combatPower = 0.8; armorFactor = 0.3;
        sensorRange = 4000.0; cyclesCostMult = 1.2;
      };
      case (#Kamikaze) {
        speed = 55.6; range = 100000.0; payload = 20.0; stealthFactor = 0.2;
        kuramotoK = 0.9; energyRate = 0.005; combatPower = 10.0; armorFactor = 0.1;
        sensorRange = 2000.0; cyclesCostMult = 0.3;  // Cheap — expendable
      };
      case (#Jammer) {
        speed = 16.7; range = 20000.0; payload = 15.0; stealthFactor = 0.1;
        kuramotoK = 0.4; energyRate = 0.006; combatPower = 0.0; armorFactor = 0.3;
        sensorRange = 10000.0; cyclesCostMult = 1.5;  // High compute for jamming
      };
      case (#Relay) {
        speed = 19.4; range = 40000.0; payload = 5.0; stealthFactor = 0.6;
        kuramotoK = 0.95; energyRate = 0.002; combatPower = 0.0; armorFactor = 0.2;
        sensorRange = 2000.0; cyclesCostMult = 0.7;
      };
      case (#Decoy) {
        speed = 25.0; range = 30000.0; payload = 3.0; stealthFactor = 0.0;  // Maximum visibility!
        kuramotoK = 0.3; energyRate = 0.002; combatPower = 0.0; armorFactor = 0.5;
        sensorRange = 500.0; cyclesCostMult = 0.4;
      };
      case (#Carrier) {
        speed = 13.9; range = 20000.0; payload = 50.0; stealthFactor = 0.4;
        kuramotoK = 0.7; energyRate = 0.008; combatPower = 0.2; armorFactor = 0.6;
        sensorRange = 3000.0; cyclesCostMult = 2.0;  // Expensive — carries micro-drones
      };
      case (#Logistics) {
        speed = 16.7; range = 15000.0; payload = 30.0; stealthFactor = 0.5;
        kuramotoK = 0.6; energyRate = 0.003; combatPower = 0.0; armorFactor = 0.4;
        sensorRange = 2000.0; cyclesCostMult = 0.8;
      };
      case (#Medic) {
        speed = 27.8; range = 25000.0; payload = 80.0; stealthFactor = 0.6;
        kuramotoK = 0.7; energyRate = 0.004; combatPower = 0.0; armorFactor = 0.5;
        sensorRange = 3000.0; cyclesCostMult = 1.0;
      };
      case (#Sovereign) {
        speed = 22.2; range = 30000.0; payload = 20.0; stealthFactor = 0.5;
        kuramotoK = 1.0; energyRate = 0.010; combatPower = 0.5; armorFactor = 0.8;
        sensorRange = 6000.0; cyclesCostMult = 3.0;  // Highest compute — brain of squadron
      };
      case (#MicroDrone) {
        speed = 11.1; range = 2000.0; payload = 0.1; stealthFactor = 0.95;
        kuramotoK = 0.3; energyRate = 0.0001; combatPower = 0.05; armorFactor = 0.0;
        sensorRange = 100.0; cyclesCostMult = 0.01;  // Tiny cost — swarm of thousands
      };
    }
  };
  
  public type CoreValues = {
    survivalDrive     : Float;
    missionCommitment : Float;
    swarmLoyalty      : Float;
    ethicalBound      : Float;  // ALWAYS 1.0 — ABSOLUTE
    learningDrive     : Float;
    truthSeeking      : Float;
  };
  
  public type MiniBrainNode = {
    activation : Float;
    potential  : Float;
    threshold  : Float;
  };
  
  public type MiniBrain = {
    sensorNode    : MiniBrainNode;
    memoryNode    : MiniBrainNode;
    decisionNode  : MiniBrainNode;
    emotionNode   : MiniBrainNode;
    motorNode     : MiniBrainNode;
    syncNode      : MiniBrainNode;
    weights       : [var Float];  // 6×6 = 36 Hebbian weights
    phase         : Float;
    frequency     : Float;
    coherence     : Float;
  };
  
  public type DroneState = {
    id            : Nat;
    droneClass    : DroneClass;
    brain         : MiniBrain;
    values        : CoreValues;
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SQUADRON ASSIGNMENT — Each drone belongs to Alpha, Beta, or Gamma
    // ═══════════════════════════════════════════════════════════════════════════
    squadron      : Nat;          // 0=Alpha, 1=Beta, 2=Gamma
    isSquadronCommander : Bool;   // True if this drone is the Sovereign for its squadron
    
    // Position & motion
    posX          : Float;
    posY          : Float;
    posZ          : Float;
    velX          : Float;
    velY          : Float;
    velZ          : Float;
    
    // Status
    energy        : Float;
    health        : Float;
    active        : Bool;
    sacrificed    : Bool;
    
    // Sync with organism
    organismPhase : Float;
    syncStrength  : Float;
    syncDrift     : Float;
    valueAlignment: Float;
    
    // Task
    currentTask   : ?Text;
    targetX       : Float;
    targetY       : Float;
    targetZ       : Float;
    
    lastBeat      : Nat;
  };
  
  public type Formation = {
    #Sphere;
    #Wedge;
    #Grid;
    #Line;
    #Scatter;
    #Orbit;
    #Custom;
  };
  
  public type FleetState = {
    drones        : [var DroneState];
    droneCount    : Nat;
    formation     : Formation;
    
    // Swarm-level metrics
    rSwarm        : Float;        // Kuramoto order parameter
    meanPhase     : Float;        // Mean phase angle
    jasmineScore  : Float;        // Jasmine's Law value for swarm
    swarmCoherence: Float;
    
    // Center of mass
    centerX       : Float;
    centerY       : Float;
    centerZ       : Float;
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SQUADRON STATE — 3 semi-autonomous squadrons
    // ═══════════════════════════════════════════════════════════════════════════
    squadronRSwarm     : [Float];   // Kuramoto r for each squadron [3]
    squadronMeanPhase  : [Float];   // Mean phase for each squadron [3]
    squadronCenterX    : [Float];   // Squadron centers [3]
    squadronCenterY    : [Float];
    squadronCenterZ    : [Float];
    squadronCommanders : [Nat];     // Drone IDs of the 3 Sovereigns
    
    // Organism values (to propagate)
    organismValues: CoreValues;
    
    // Competition
    enemySwarmActive : Bool;
    enemyCount       : Nat;
    combatMode       : Bool;
    
    beatNum       : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SQUADRON TYPE — Per-squadron state for internal coupling
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type SquadronState = {
    squadronId    : Nat;          // 0=Alpha, 1=Beta, 2=Gamma
    name          : Text;         // "ALPHA", "BETA", "GAMMA"
    commanderId   : Nat;          // Drone ID of Sovereign
    droneIds      : [Nat];        // All drone IDs in this squadron
    rSwarm        : Float;        // Squadron's internal coherence
    meanPhase     : Float;        // Squadron's mean phase
    centerX       : Float;        // Squadron center of mass
    centerY       : Float;
    centerZ       : Float;
    currentMission: Text;         // "PATROL", "ATTACK", "DEFEND", etc.
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  
  func wrapPhase(theta: Float) : Float {
    var t = theta;
    while (t < 0.0) { t += TWO_PI };
    while (t >= TWO_PI) { t -= TWO_PI };
    t
  };
  
  func fsin(x: Float) : Float { Float.sin(x) };
  func fcos(x: Float) : Float { Float.cos(x) };
  func fsqrt(x: Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  func initNode() : MiniBrainNode {
    { activation = 0.5; potential = 0.0; threshold = 0.7 }
  };
  
  func initBrain(droneId: Nat) : MiniBrain {
    let weights = Array.init<Float>(36, 0.1);
    {
      sensorNode = initNode();
      memoryNode = initNode();
      decisionNode = initNode();
      emotionNode = initNode();
      motorNode = initNode();
      syncNode = initNode();
      weights = weights;
      phase = Float.fromInt(droneId) * 0.1;  // Spread initial phases
      frequency = NATURAL_FREQ_BASE + Float.fromInt(droneId % 10) * NATURAL_FREQ_SPREAD / 10.0;
      coherence = 0.75;
    }
  };
  
  func initValues() : CoreValues {
    {
      survivalDrive = 0.7;
      missionCommitment = 0.85;
      swarmLoyalty = 0.9;
      ethicalBound = ETHICAL_BOUND_ABSOLUTE;  // ALWAYS 1.0
      learningDrive = 0.8;
      truthSeeking = 0.9;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PURE MATH: INDEX TO DRONE CLASS
  // ═══════════════════════════════════════════════════════════════════════════
  // Maps type index (0-12) to DroneClass. No conditionals on N.
  // The same mapping works for N=50 or N=500,000.
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func indexToDroneClass(typeIndex: Nat) : DroneClass {
    switch (typeIndex % 13) {
      case 0  #Scout;
      case 1  #Recon;
      case 2  #Strike;
      case 3  #Hunter;
      case 4  #Kamikaze;
      case 5  #Jammer;
      case 6  #Relay;
      case 7  #Decoy;
      case 8  #Carrier;
      case 9  #Logistics;
      case 10 #Medic;
      case 11 #Sovereign;
      case _  #MicroDrone;
    }
  };

  func initDrone(id: Nat, totalDrones: Nat) : DroneState {
    // ═══════════════════════════════════════════════════════════════════════════
    // SELF-COMPOUNDING DRONE INITIALIZATION — PURE MATH
    // ═══════════════════════════════════════════════════════════════════════════
    // ALL parameters derived from (id, N) using mathematical functions.
    // NO conditionals on fleet size. Same code for N=50 or N=500,000.
    //
    // The structure UNFOLDS from the math:
    //   • Squadron = deriveSquadron(id, N)
    //   • Type = indexToDroneClass(deriveDroneTypeIndex(id, N))
    //   • Position = Fibonacci sphere packing
    //   • Frequency = Golden ratio distribution
    // ═══════════════════════════════════════════════════════════════════════════
    
    let N = totalDrones;
    
    // Derive squadron structure from N
    let squadronCount = deriveSquadronCount(N);
    let dronesPerSquad = deriveDronesPerSquadron(N, squadronCount);
    let squadron = deriveSquadron(id, N);
    let isCommander = deriveSovereignStatus(id, N);
    let localId = id - squadron * dronesPerSquad;
    
    // Derive drone type from golden ratio distribution
    let typeIndex = deriveDroneTypeIndex(id, N);
    let droneClass = indexToDroneClass(typeIndex);
    let typeParams = getDroneTypeParams(droneClass);
    
    // Derive position: Squadron center + local offset
    // Squadron centers on circle, local positions on Fibonacci sphere
    let orbitRadius = 50.0 * Float.sqrt(Float.fromInt(N) / 100.0);  // Scales with sqrt(N)
    let localRadius = 20.0 * Float.sqrt(Float.fromInt(dronesPerSquad) / 20.0);  // Scales with sqrt(dronesPerSquad)
    
    let (squadCenterX, squadCenterY, squadCenterZ) = deriveSquadronCenter(squadron, squadronCount, orbitRadius);
    let (localX, localY, localZ) = deriveFibonacciSpherePosition(localId, dronesPerSquad, localRadius);
    
    // Altitude varies by type
    let typeAltitude = deriveAltitude(typeParams);
    
    // Derive phase and frequency from golden angle
    let phase = deriveInitialPhase(id);
    let frequency = deriveNaturalFrequency(id);
    
    {
      id = id;
      droneClass = droneClass;
      brain = initBrainWithPhaseFreq(id, phase, frequency);
      values = initValues();
      squadron = squadron;
      isSquadronCommander = isCommander;
      posX = squadCenterX + localX;
      posY = typeAltitude + localY * 0.3;  // Vertical spread scaled
      posZ = squadCenterZ + localZ;
      velX = 0.0;
      velY = 0.0;
      velZ = 0.0;
      energy = 1.0;
      health = typeParams.armorFactor + 0.5;  // Health based on armor
      active = true;
      sacrificed = false;
      organismPhase = phase;
      syncStrength = typeParams.kuramotoK;    // Type-specific coupling
      syncDrift = 0.0;
      valueAlignment = 1.0;
      currentTask = null;
      targetX = squadCenterX;
      targetY = typeAltitude;
      targetZ = squadCenterZ;
      lastBeat = 0;
    }
  };
  
  // Helper for initDrone with derived phase/frequency
  func initBrainWithPhaseFreq(droneId: Nat, phase: Float, frequency: Float) : MiniBrain {
    let weights = Array.init<Float>(36, 0.1);
    {
      sensorNode = initNode();
      memoryNode = initNode();
      decisionNode = initNode();
      emotionNode = initNode();
      motorNode = initNode();
      syncNode = initNode();
      weights = weights;
      phase = phase;
      frequency = frequency;
      coherence = 0.75;
    }
  };
  
  public func initFleet(droneCount: Nat) : FleetState {
    // ═══════════════════════════════════════════════════════════════════════════
    // SELF-COMPOUNDING FLEET INITIALIZATION — PURE MATH
    // ═══════════════════════════════════════════════════════════════════════════
    // ALL structure derived from N using mathematical functions.
    // NO conditionals on fleet size. Same code for N=50 or N=500,000.
    //
    // Squadron count = ceil(sqrt(N / 20))
    //   N=50    → ceil(sqrt(2.5))  = 2 squadrons
    //   N=500   → ceil(sqrt(25))   = 5 squadrons
    //   N=5000  → ceil(sqrt(250))  = 16 squadrons
    //   N=50000 → ceil(sqrt(2500)) = 50 squadrons
    //
    // PARALLAX ECONOMICS (wired into architecture):
    // - Fleet coherence (rSwarm) drives FORMA minting
    // - FORMA pays for ICP cycles
    // - Higher coherence → more FORMA → more compute → higher coherence
    // - This is the self-funding loop that runs ANY size fleet
    // ═══════════════════════════════════════════════════════════════════════════
    
    let N = droneCount;
    
    // Derive squadron structure from pure math
    let squadronCount = deriveSquadronCount(N);
    let dronesPerSquad = deriveDronesPerSquadron(N, squadronCount);
    let orbitRadius = 50.0 * Float.sqrt(Float.fromInt(N) / 100.0);
    
    // Initialize all drones
    let drones = Array.init<DroneState>(N, initDrone(0, N));
    for (i in Iter.range(0, N - 1)) {
      drones[i] := initDrone(i, N);
    };
    
    // Derive squadron commanders (first drone of each squadron)
    let commanders = Array.tabulate<Nat>(squadronCount, func(i: Nat) : Nat {
      i * dronesPerSquad
    });
    
    // Derive squadron centers from deriveSquadronCenter
    let squadCentersX = Array.tabulate<Float>(squadronCount, func(i: Nat) : Float {
      let (x, _, _) = deriveSquadronCenter(i, squadronCount, orbitRadius);
      x
    });
    let squadCentersY = Array.tabulate<Float>(squadronCount, func(i: Nat) : Float {
      let (_, y, _) = deriveSquadronCenter(i, squadronCount, orbitRadius);
      y
    });
    let squadCentersZ = Array.tabulate<Float>(squadronCount, func(i: Nat) : Float {
      let (_, _, z) = deriveSquadronCenter(i, squadronCount, orbitRadius);
      z
    });
    
    // Initial phases: evenly distributed around unit circle
    let squadPhases = Array.tabulate<Float>(squadronCount, func(i: Nat) : Float {
      Float.fromInt(i) * (TWO_PI / Float.fromInt(squadronCount))
    });
    
    // Initial coherence: same for all squadrons (will diverge naturally)
    let squadRSwarm = Array.tabulate<Float>(squadronCount, func(_: Nat) : Float { 0.85 });
    
    {
      drones = drones;
      droneCount = N;
      formation = #Sphere;
      rSwarm = 0.88;
      meanPhase = 0.0;
      jasmineScore = 0.75;
      swarmCoherence = 0.85;
      centerX = 0.0;
      centerY = 60.0;
      centerZ = 0.0;
      
      // Squadron state — all derived from N
      squadronRSwarm = squadRSwarm;
      squadronMeanPhase = squadPhases;
      squadronCenterX = squadCentersX;
      squadronCenterY = squadCentersY;
      squadronCenterZ = squadCentersZ;
      squadronCommanders = commanders;
      
      organismValues = initValues();
      enemySwarmActive = false;
      enemyCount = 0;
      combatMode = false;
      beatNum = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SQUADRON-LEVEL KURAMOTO — Compute r and ψ for each squadron
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func computeSquadronOrder(state: FleetState, squadronId: Nat) : (Float, Float) {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var count : Nat = 0;
    
    for (i in Iter.range(0, state.droneCount - 1)) {
      let drone = state.drones[i];
      if (drone.squadron == squadronId and drone.active and not drone.sacrificed) {
        sumCos += fcos(drone.brain.phase);
        sumSin += fsin(drone.brain.phase);
        count += 1;
      };
    };
    
    if (count == 0) { return (0.85, 0.0) };
    
    let n = Float.fromInt(count);
    let r = fsqrt((sumCos/n)*(sumCos/n) + (sumSin/n)*(sumSin/n));
    let meanPhase = Float.arctan2(sumSin/n, sumCos/n);
    
    (r, wrapPhase(meanPhase))
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // KURAMOTO SYNCHRONIZATION — Swarm Phase Coupling
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Compute Kuramoto order parameter r and mean phase
  public func computeKuramotoOrder(state: FleetState) : (Float, Float) {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var count : Nat = 0;
    
    for (i in Iter.range(0, state.droneCount - 1)) {
      let drone = state.drones[i];
      if (drone.active and not drone.sacrificed) {
        sumCos += fcos(drone.brain.phase);
        sumSin += fsin(drone.brain.phase);
        count += 1;
      };
    };
    
    if (count == 0) { return (0.0, 0.0) };
    
    let n = Float.fromInt(count);
    let meanCos = sumCos / n;
    let meanSin = sumSin / n;
    
    let r = fsqrt(meanCos * meanCos + meanSin * meanSin);
    let meanPhase = Float.arctan2(meanSin, meanCos);
    
    (r, wrapPhase(meanPhase))
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SCALE-INVARIANT MEAN-FIELD KURAMOTO
  // ═══════════════════════════════════════════════════════════════════════════
  // For massive fleets (2,000 - 40,000 drones), we use MEAN-FIELD:
  //   dθᵢ/dt = ωᵢ + K·r·sin(ψ - θᵢ)
  // Each drone couples to the COLLECTIVE (r, ψ), not to every neighbor.
  // This is O(1) per drone instead of O(N).
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Mean-field phase sync: drone couples to organism + collective — O(1)
  func syncDronePhaseMeanField(
    drone: DroneState,
    organismPhase: Float,
    collectiveR: Float,
    collectivePsi: Float,
    dt: Float
  ) : Float {
    // Mean-field Kuramoto: dθ/dt = ω + K·r·sin(ψ - θ)
    var coupling : Float = 0.0;
    
    // Couple to organism phase (strong — the organism IS the collective mind)
    coupling += drone.syncStrength * fsin(organismPhase - drone.brain.phase);
    
    // Couple to collective mean field (the swarm's r·e^(iψ))
    coupling += 0.5 * drone.syncStrength * collectiveR * fsin(collectivePsi - drone.brain.phase);
    
    let newPhase = drone.brain.phase + (drone.brain.frequency + coupling) * dt;
    wrapPhase(newPhase)
  };
  
  // Legacy neighbor-based sync (for small fleets where richer dynamics are wanted)
  func syncDronePhase(
    drone: DroneState,
    organismPhase: Float,
    neighborPhases: [Float],
    dt: Float
  ) : Float {
    // Kuramoto model: dθ/dt = ω + K/N × Σ sin(θⱼ - θᵢ)
    var coupling : Float = 0.0;
    
    // Couple to organism phase (strong)
    coupling += drone.syncStrength * fsin(organismPhase - drone.brain.phase);
    
    // Couple to neighbors (weaker)
    for (neighborPhase in neighborPhases.vals()) {
      coupling += 0.3 * drone.syncStrength * fsin(neighborPhase - drone.brain.phase);
    };
    
    let newPhase = drone.brain.phase + (drone.brain.frequency + coupling) * dt;
    wrapPhase(newPhase)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // VALUE PROPAGATION — Organism Values → Drones
  // ═══════════════════════════════════════════════════════════════════════════
  
  func inheritValues(local: CoreValues, organism: CoreValues, rate: Float) : CoreValues {
    let r = rate;
    let l = 1.0 - r;
    {
      survivalDrive = local.survivalDrive * l + organism.survivalDrive * r;
      missionCommitment = local.missionCommitment * l + organism.missionCommitment * r;
      swarmLoyalty = local.swarmLoyalty * l + organism.swarmLoyalty * r;
      ethicalBound = ETHICAL_BOUND_ABSOLUTE;  // NEVER changes, ALWAYS 1.0
      learningDrive = local.learningDrive * l + organism.learningDrive * r;
      truthSeeking = local.truthSeeking * l + organism.truthSeeking * r;
    }
  };
  
  func computeValueAlignment(local: CoreValues, organism: CoreValues) : Float {
    let diffs = [
      Float.abs(local.survivalDrive - organism.survivalDrive),
      Float.abs(local.missionCommitment - organism.missionCommitment),
      Float.abs(local.swarmLoyalty - organism.swarmLoyalty),
      Float.abs(local.learningDrive - organism.learningDrive),
      Float.abs(local.truthSeeking - organism.truthSeeking)
    ];
    var totalDiff : Float = 0.0;
    for (d in diffs.vals()) { totalDiff += d };
    clamp(1.0 - totalDiff / 5.0, 0.0, 1.0)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HEBBIAN LEARNING — Local Brain Adaptation
  // ═══════════════════════════════════════════════════════════════════════════
  
  func hebbianUpdate(
    weights: [var Float],
    activations: [Float],
    learningRate: Float
  ) {
    let n = activations.size();
    if (n * n != weights.size()) { return };
    
    let eta = learningRate;
    let decay = 0.01;
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        let idx = i * n + j;
        let delta = eta * activations[i] * activations[j] - decay * weights[idx];
        weights[idx] := clamp(weights[idx] + delta, -2.0, 2.0);
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FORMATION CONTROL
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getFormationTarget(
    droneId: Nat,
    formation: Formation,
    droneCount: Nat,
    centerX: Float,
    centerY: Float,
    centerZ: Float
  ) : (Float, Float, Float) {
    let i = Float.fromInt(droneId);
    let n = Float.fromInt(droneCount);
    
    switch (formation) {
      case (#Sphere) {
        // Fibonacci sphere
        let goldenRatio = 1.618033988749;
        let phi = 2.0 * PI * i / goldenRatio;
        let theta = Float.arccos(1.0 - 2.0 * (i + 0.5) / n);
        let r = SPHERE_RADIUS_BASE;
        (
          centerX + r * fsin(theta) * fcos(phi),
          centerY + r * fcos(theta),
          centerZ + r * fsin(theta) * fsin(phi)
        )
      };
      case (#Wedge) {
        let row = Float.floor(fsqrt(i * 2.0));
        let col = i - Float.floor(row * (row + 1.0) / 2.0);
        (
          centerX + (col - row / 2.0) * FORMATION_SPACING,
          centerY,
          centerZ - row * FORMATION_SPACING * 0.866
        )
      };
      case (#Grid) {
        let side = Float.ceil(fsqrt(n));
        let row = Float.floor(i / side);
        let col = i - row * side;
        (
          centerX + (col - side / 2.0) * FORMATION_SPACING,
          centerY,
          centerZ + (row - side / 2.0) * FORMATION_SPACING
        )
      };
      case (#Line) {
        (
          centerX + (i - n / 2.0) * FORMATION_SPACING,
          centerY,
          centerZ
        )
      };
      case (#Scatter) {
        // Random-ish scatter using golden ratio
        let angle = i * 2.4;
        let radius = 20.0 + (i * 0.618) - Float.floor(i * 0.618 / 50.0) * 50.0;
        (
          centerX + radius * fcos(angle),
          centerY + (i * 0.1) - Float.floor(i * 0.1 / 20.0) * 20.0,
          centerZ + radius * fsin(angle)
        )
      };
      case (#Orbit) {
        let angle = i * TWO_PI / n;
        let radius = SPHERE_RADIUS_BASE + (i * 0.5);
        (
          centerX + radius * fcos(angle),
          centerY,
          centerZ + radius * fsin(angle)
        )
      };
      case (#Custom) {
        (centerX, centerY, centerZ)
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DRONE MOVEMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  func moveDroneToTarget(drone: DroneState, dt: Float) : DroneState {
    let dx = drone.targetX - drone.posX;
    let dy = drone.targetY - drone.posY;
    let dz = drone.targetZ - drone.posZ;
    let dist = fsqrt(dx * dx + dy * dy + dz * dz);
    
    if (dist < 0.5) {
      // Close enough, stop
      { drone with velX = 0.0; velY = 0.0; velZ = 0.0 }
    } else {
      // Move toward target
      let speed = 10.0 * drone.energy;  // Max 10 m/s, scaled by energy
      let scale = if (dist > speed * dt) speed / dist else 1.0 / dt;
      
      let newVelX = dx * scale;
      let newVelY = dy * scale;
      let newVelZ = dz * scale;
      
      {
        drone with
        posX = drone.posX + newVelX * dt;
        posY = drone.posY + newVelY * dt;
        posZ = drone.posZ + newVelZ * dt;
        velX = newVelX;
        velY = newVelY;
        velZ = newVelZ;
      }
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN FLEET BEAT — Called from masterHeartbeat
  // ═══════════════════════════════════════════════════════════════════════════
  // SCALE-INVARIANT: Works for 50 drones or 50,000 drones.
  // Uses mean-field Kuramoto for large fleets.
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func tickFleet(
    state: FleetState,
    organismPhase: Float,
    organismValues: CoreValues,
    beatNum: Nat
  ) : FleetState {
    
    // Step 0: Compute collective mean field ONCE — O(N)
    // This is the key to scale-invariance
    let (collectiveR, collectivePsi) = computeKuramotoOrder(state);
    
    // Determine if we use mean-field (large fleet) or neighbor-based (small fleet)
    let useMeanField = state.droneCount > 500;
    
    // Step 1: Update each drone — O(N) total with mean-field, O(N²) otherwise
    for (i in Iter.range(0, state.droneCount - 1)) {
      let drone = state.drones[i];
      if (not drone.active or drone.sacrificed) {
        // Skip inactive drones
      } else {
        // Update phase using appropriate method
        let newPhase = if (useMeanField) {
          // Mean-field: O(1) per drone — scales to 40,000+
          syncDronePhaseMeanField(drone, organismPhase, collectiveR, collectivePsi, DT)
        } else {
          // Neighbor-based: richer dynamics for small fleets
          var neighborPhases : [Float] = [];
          for (j in Iter.range(0, Nat.min(5, state.droneCount - 1))) {
            if (i != j and state.drones[j].active) {
              neighborPhases := Array.append(neighborPhases, [state.drones[j].brain.phase]);
            };
          };
          syncDronePhase(drone, organismPhase, neighborPhases, DT)
        };
        
        // Inherit values — O(1)
        let newValues = inheritValues(drone.values, organismValues, VALUE_INHERITANCE_RATE * DT);
        
        // Compute alignment — O(1)
        let alignment = computeValueAlignment(newValues, organismValues);
        
        // Get formation target — O(1)
        let (targetX, targetY, targetZ) = getFormationTarget(
          i, state.formation, state.droneCount,
          state.centerX, state.centerY, state.centerZ
        );
        
        // Get brain activations for Hebbian update
        let activations = [
          drone.brain.sensorNode.activation,
          drone.brain.memoryNode.activation,
          drone.brain.decisionNode.activation,
          drone.brain.emotionNode.activation,
          drone.brain.motorNode.activation,
          drone.brain.syncNode.activation
        ];
        
        // Update Hebbian weights — O(1) internal brain
        hebbianUpdate(drone.brain.weights, activations, newValues.learningDrive * 0.1);
        
        // Update drone state
        let updatedDrone : DroneState = {
          drone with
          brain = { drone.brain with phase = newPhase; coherence = collectiveR };
          values = newValues;
          organismPhase = organismPhase;
          syncDrift = Float.abs(newPhase - organismPhase);
          valueAlignment = alignment;
          targetX = targetX;
          targetY = targetY;
          targetZ = targetZ;
          lastBeat = beatNum;
        };
        
        // Move drone
        let movedDrone = moveDroneToTarget(updatedDrone, DT);
        state.drones[i] := movedDrone;
      };
    };
    
    // Step 2: Compute swarm-level metrics
    let (rSwarm, meanPhase) = computeKuramotoOrder(state);
    
    // Step 3: Compute Jasmine score for swarm
    // J = r × √(N × σ_H × (1 - H))
    // Use average Hebbian weight std dev and entropy estimate
    var weightSum : Float = 0.0;
    var weightSqSum : Float = 0.0;
    var weightCount : Nat = 0;
    for (i in Iter.range(0, state.droneCount - 1)) {
      let drone = state.drones[i];
      if (drone.active) {
        for (w in drone.brain.weights.vals()) {
          weightSum += w;
          weightSqSum += w * w;
          weightCount += 1;
        };
      };
    };
    let meanWeight = if (weightCount > 0) weightSum / Float.fromInt(weightCount) else 0.5;
    let varWeight = if (weightCount > 0) weightSqSum / Float.fromInt(weightCount) - meanWeight * meanWeight else 0.25;
    let sigmaH = fsqrt(Float.abs(varWeight));
    
    // Estimate entropy from phase variance
    var phaseVar : Float = 0.0;
    for (i in Iter.range(0, state.droneCount - 1)) {
      if (state.drones[i].active) {
        let diff = state.drones[i].brain.phase - meanPhase;
        phaseVar += diff * diff;
      };
    };
    let entropy = clamp(phaseVar / Float.fromInt(state.droneCount) / PI, 0.0, 1.0);
    
    let jasmineScore = rSwarm * fsqrt(Float.fromInt(state.droneCount) * sigmaH * (1.0 - entropy));
    
    // Step 4: Compute center of mass
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumZ : Float = 0.0;
    var activeCount : Nat = 0;
    for (i in Iter.range(0, state.droneCount - 1)) {
      let drone = state.drones[i];
      if (drone.active and not drone.sacrificed) {
        sumX += drone.posX;
        sumY += drone.posY;
        sumZ += drone.posZ;
        activeCount += 1;
      };
    };
    let n = Float.fromInt(activeCount);
    let centerX = if (activeCount > 0) sumX / n else 0.0;
    let centerY = if (activeCount > 0) sumY / n else 50.0;
    let centerZ = if (activeCount > 0) sumZ / n else 0.0;
    
    // Return updated state
    {
      state with
      rSwarm = rSwarm;
      meanPhase = meanPhase;
      jasmineScore = jasmineScore;
      swarmCoherence = rSwarm * (1.0 - entropy);
      centerX = centerX;
      centerY = centerY;
      centerZ = centerZ;
      organismValues = organismValues;
      beatNum = beatNum;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMMAND DISPATCH
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type Command = {
    #SetFormation : Formation;
    #MoveTo : { x: Float; y: Float; z: Float };
    #Attack : { targetX: Float; targetY: Float; targetZ: Float };
    #Defend : { centerX: Float; centerY: Float; centerZ: Float };
    #Scatter;
    #Regroup;
    #SetAltitude : Float;
  };
  
  public func dispatchCommand(state: FleetState, cmd: Command) : FleetState {
    switch (cmd) {
      case (#SetFormation(f)) {
        { state with formation = f }
      };
      case (#MoveTo(target)) {
        { state with centerX = target.x; centerY = target.y; centerZ = target.z }
      };
      case (#Attack(target)) {
        { state with 
          combatMode = true; 
          formation = #Wedge;
          centerX = target.targetX;
          centerY = target.targetY;
          centerZ = target.targetZ;
        }
      };
      case (#Defend(center)) {
        { state with 
          combatMode = true; 
          formation = #Sphere;
          centerX = center.centerX;
          centerY = center.centerY;
          centerZ = center.centerZ;
        }
      };
      case (#Scatter) {
        { state with formation = #Scatter }
      };
      case (#Regroup) {
        { state with formation = #Sphere; combatMode = false }
      };
      case (#SetAltitude(alt)) {
        { state with centerY = alt }
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FLEET STATUS REPORT
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getFleetStatus(state: FleetState) : Text {
    var activeCount : Nat = 0;
    var totalEnergy : Float = 0.0;
    var totalHealth : Float = 0.0;
    
    for (i in Iter.range(0, state.droneCount - 1)) {
      let drone = state.drones[i];
      if (drone.active and not drone.sacrificed) {
        activeCount += 1;
        totalEnergy += drone.energy;
        totalHealth += drone.health;
      };
    };
    
    let n = Float.fromInt(activeCount);
    let avgEnergy = if (activeCount > 0) totalEnergy / n else 0.0;
    let avgHealth = if (activeCount > 0) totalHealth / n else 0.0;
    
    "DRONE FLEET STATUS (Beat " # Nat.toText(state.beatNum) # "):\n" #
    "═══════════════════════════════════════════════════════════════\n" #
    "Active Drones: " # Nat.toText(activeCount) # "/" # Nat.toText(state.droneCount) # "\n" #
    "Formation: " # formationToText(state.formation) # "\n" #
    "Combat Mode: " # (if (state.combatMode) "ACTIVE" else "PEACEFUL") # "\n" #
    "═══════════════════════════════════════════════════════════════\n" #
    "SWARM METRICS:\n" #
    "  r_Swarm (Kuramoto): " # Float.format(#fix 4, state.rSwarm) # "\n" #
    "  Jasmine Score: " # Float.format(#fix 4, state.jasmineScore) # "\n" #
    "  Swarm Coherence: " # Float.format(#fix 4, state.swarmCoherence) # "\n" #
    "  Mean Phase: " # Float.format(#fix 3, state.meanPhase) # " rad\n" #
    "═══════════════════════════════════════════════════════════════\n" #
    "SWARM CENTER: (" # 
      Float.format(#fix 1, state.centerX) # ", " #
      Float.format(#fix 1, state.centerY) # ", " #
      Float.format(#fix 1, state.centerZ) # ")\n" #
    "Avg Energy: " # Float.format(#fix 2, avgEnergy * 100.0) # "%\n" #
    "Avg Health: " # Float.format(#fix 2, avgHealth * 100.0) # "%"
  };
  
  func formationToText(f: Formation) : Text {
    switch (f) {
      case (#Sphere) "SPHERE";
      case (#Wedge) "WEDGE";
      case (#Grid) "GRID";
      case (#Line) "LINE";
      case (#Scatter) "SCATTER";
      case (#Orbit) "ORBIT";
      case (#Custom) "CUSTOM";
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
  //  D E F E N S E   &   S E C U R I T Y   M A T H E M A T I C S
  //
  //  Enterprise-Level Security Algorithms and Threat Response
  //  Full HIM/HER Dual-Organism Protection Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // THREAT DETECTION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Anomaly score using Mahalanobis distance
  public func defenseAnomalyScore(
    observation : [Float],
    mean : [Float],
    invCovariance : [[Float]]
  ) : Float {
    let n = observation.size();
    if (n == 0 or mean.size() != n) { return 0.0 };
    
    var score : Float = 0.0;
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n) {
        let diff_i = observation[i] - mean[i];
        let diff_j = observation[j] - mean[j];
        score += diff_i * invCovariance[i][j] * diff_j;
        j += 1;
      };
      i += 1;
    };
    Float.sqrt(Float.abs(score))
  };

  /// Exponential moving average for baseline
  public func defenseEMABaseline(
    current : Float,
    observation : Float,
    alpha : Float
  ) : Float {
    alpha * observation + (1.0 - alpha) * current
  };

  /// Z-score anomaly detection
  public func defenseZScoreAnomaly(
    value : Float,
    mean : Float,
    stdDev : Float
  ) : Float {
    if (stdDev < 0.0001) { 0.0 }
    else { Float.abs((value - mean) / stdDev) }
  };

  /// Threat probability from multiple indicators
  public func defenseThreatProbability(
    indicators : [Float],
    weights : [Float]
  ) : Float {
    let n = if (indicators.size() < weights.size()) indicators.size() else weights.size();
    if (n == 0) { return 0.0 };
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;
    var i = 0;
    while (i < n) {
      weightedSum += indicators[i] * weights[i];
      totalWeight += weights[i];
      i += 1;
    };
    if (totalWeight < 0.0001) { 0.0 }
    else { weightedSum / totalWeight }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESPONSE COORDINATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Priority queue score
  public func defenseResponsePriority(
    threatLevel : Float,
    urgency : Float,
    resources : Float
  ) : Float {
    threatLevel * urgency / (resources + 0.1)
  };

  /// Resource allocation optimization
  public func defenseResourceAllocation(
    available : Float,
    demands : [Float]
  ) : [Float] {
    var totalDemand : Float = 0.0;
    var i = 0;
    while (i < demands.size()) {
      totalDemand += demands[i];
      i += 1;
    };
    if (totalDemand < 0.0001) {
      return Array.tabulate<Float>(demands.size(), func(_ : Nat) : Float { 0.0 });
    };
    Array.tabulate<Float>(demands.size(), func(j : Nat) : Float {
      available * demands[j] / totalDemand
    })
  };

  /// Cascade failure probability
  public func defenseCascadeFailureProb(
    nodeFailProb : Float,
    connectivity : Float,
    loadFactor : Float
  ) : Float {
    let amplified = nodeFailProb * (1.0 + connectivity * loadFactor);
    if (amplified > 1.0) { 1.0 } else { amplified }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // CRYPTOGRAPHIC PRIMITIVES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Hash chain verification
  public func defenseHashChainVerify(
    expectedHash : Nat,
    computedHash : Nat,
    tolerance : Nat
  ) : Bool {
    let diff = if (expectedHash > computedHash) 
               expectedHash - computedHash 
               else computedHash - expectedHash;
    diff <= tolerance
  };

  /// Key derivation strength
  public func defenseKeyStrength(
    entropy : Float,
    iterations : Nat
  ) : Float {
    entropy * Float.log(Float.fromInt(iterations + 1))
  };

  /// Time-based token window
  public func defenseTokenWindow(
    currentTime : Nat,
    windowSize : Nat,
    secret : Nat
  ) : Nat {
    let window = currentTime / windowSize;
    (window * secret) % 1000000
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NETWORK SECURITY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rate limiting token bucket
  public func defenseTokenBucket(
    tokens : Float,
    maxTokens : Float,
    refillRate : Float,
    requested : Float,
    dt : Float
  ) : (Float, Bool) {
    let refilled = Float.min(tokens + refillRate * dt, maxTokens);
    if (refilled >= requested) {
      (refilled - requested, true)
    } else {
      (refilled, false)
    }
  };

  /// Connection trust score
  public func defenseTrustScore(
    successfulInteractions : Nat,
    failedInteractions : Nat,
    age : Nat
  ) : Float {
    let total = successfulInteractions + failedInteractions;
    if (total == 0) { return 0.5 };
    let successRate = Float.fromInt(successfulInteractions) / Float.fromInt(total);
    let ageFactor = Float.log(Float.fromInt(age + 1)) / 10.0;
    (successRate + ageFactor) / 2.0
  };

  /// DDoS detection metric
  public func defenseDDoSMetric(
    requestRate : Float,
    baseline : Float,
    variance : Float
  ) : Float {
    let deviation = (requestRate - baseline) / (Float.sqrt(variance) + 0.01);
    Float.abs(deviation)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SOVEREIGNTY PROTECTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Sovereignty assertion strength
  public func defenseSovereigntyStrength(
    autonomyLevel : Float,
    resourceControl : Float,
    decisionLatency : Float
  ) : Float {
    let efficiency = 1.0 / (decisionLatency + 0.01);
    autonomyLevel * resourceControl * efficiency
  };

  /// Integrity verification score
  public func defenseIntegrityScore(
    originalHash : Nat,
    currentHash : Nat,
    mutations : Nat
  ) : Float {
    let match = if (originalHash == currentHash) 1.0 else 0.0;
    let mutationPenalty = 1.0 / (Float.fromInt(mutations + 1));
    (match + mutationPenalty) / 2.0
  };

  /// Rollback safety margin
  public func defenseRollbackMargin(
    currentState : Float,
    checkpoint : Float,
    volatility : Float
  ) : Float {
    let diff = Float.abs(currentState - checkpoint);
    diff / (volatility + 0.01)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ADAPTIVE IMMUNE RESPONSE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Antibody-antigen affinity
  public func defenseAffinity(
    antibody : [Float],
    antigen : [Float]
  ) : Float {
    let n = if (antibody.size() < antigen.size()) antibody.size() else antigen.size();
    if (n == 0) { return 0.0 };
    var matchScore : Float = 0.0;
    var i = 0;
    while (i < n) {
      matchScore += 1.0 - Float.abs(antibody[i] - antigen[i]);
      i += 1;
    };
    matchScore / Float.fromInt(n)
  };

  /// Clonal selection probability
  public func defenseClonalSelection(
    affinity : Float,
    temperature : Float
  ) : Float {
    Float.exp(affinity / (temperature + 0.01))
  };

  /// Memory cell formation rate
  public func defenseMemoryCellRate(
    exposureCount : Nat,
    affinitySum : Float
  ) : Float {
    let exposureFactor = Float.log(Float.fromInt(exposureCount + 1));
    affinitySum * exposureFactor
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 15: REAL-WORLD DRONE INTEGRATION — PHYSICAL DRONE SYSTEMS
  // ═══════════════════════════════════════════════════════════════════════════════
  // Integration with actual drone hardware through MAVLink protocol
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Physical drone hardware state (from MAVLink telemetry)
  public type HardwareTelemetry = {
    // System identification
    systemId      : Nat;
    componentId   : Nat;
    autopilotType : Nat;        // 3=ArduPilot, 12=PX4
    vehicleType   : Nat;        // 2=Quadcopter, 13=Hexarotor
    
    // GPS position (WGS84)
    latitude      : Float;      // degrees × 10^7 (MAVLink format)
    longitude     : Float;
    altitude      : Float;      // mm above MSL
    relativeAlt   : Float;      // mm above home
    
    // Velocity NED (m/s × 100)
    vx            : Float;
    vy            : Float;
    vz            : Float;
    groundSpeed   : Float;
    
    // Attitude (radians)
    roll          : Float;
    pitch         : Float;
    yaw           : Float;
    
    // Angular rates (rad/s)
    rollspeed     : Float;
    pitchspeed    : Float;
    yawspeed      : Float;
    
    // Battery
    voltage       : Float;      // mV
    current       : Float;      // cA (10*mA)
    remaining     : Nat;        // %
    
    // Status
    mode          : Nat;        // Flight mode
    armed         : Bool;
    ekfOk         : Bool;
    gpsFixType    : Nat;
    satCount      : Nat;
    
    // Timestamp
    bootTime      : Nat;        // ms since boot
    timestamp     : Nat;        // Unix timestamp
  };

  /// Command to send to drone
  public type DroneCommand = {
    #Arm;
    #Disarm;
    #Takeoff : { altitude : Float };
    #Land;
    #ReturnToLaunch;
    #GoTo : { lat : Float; lon : Float; alt : Float };
    #SetMode : { mode : Nat };
    #SetYaw : { yawAngle : Float; yawRate : Float; direction : Int };
    #SetVelocity : { vx : Float; vy : Float; vz : Float; yawRate : Float };
    #Loiter : { lat : Float; lon : Float; alt : Float; radius : Float };
    #Mission : { waypoints : [{ lat : Float; lon : Float; alt : Float; holdTime : Float }] };
    #EmergencyStop;
  };

  /// Command result
  public type CommandResult = {
    #Success;
    #Pending : { timeout : Nat };
    #Failed : { errorCode : Nat; message : Text };
    #Rejected : { reason : Text };
  };

  /// Serialize command for MAVLink transmission
  public func serializeCommand(cmd: DroneCommand, targetSystem: Nat) : [Nat8] {
    // Simplified MAVLink command encoding
    var bytes : [Nat8] = [];
    
    switch (cmd) {
      case (#Arm) {
        // MAV_CMD_COMPONENT_ARM_DISARM (400), param1 = 1 (arm)
        bytes := [0xFD, 21, 0, 0, Nat8.fromNat(targetSystem), 0, 76, 0,
                  0, 0, 0, 0, 0x80, 0x3F,  // param1 = 1.0 (arm)
                  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                  0x90, 0x01];  // command 400
      };
      case (#Disarm) {
        bytes := [0xFD, 21, 0, 0, Nat8.fromNat(targetSystem), 0, 76, 0,
                  0, 0, 0, 0, 0, 0, 0, 0,  // param1 = 0.0 (disarm)
                  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                  0x90, 0x01];
      };
      case (#Takeoff(params)) {
        // MAV_CMD_NAV_TAKEOFF (22)
        let altBytes = floatToBytes(params.altitude);
        bytes := [0xFD, 21, 0, 0, Nat8.fromNat(targetSystem), 0, 76, 0,
                  0, 0, 0, 0, 0, 0, 0, 0,
                  0, 0, 0, 0, 0, 0, 0, 0,
                  altBytes[0], altBytes[1], altBytes[2], altBytes[3],
                  0, 0, 0, 0, 0x16, 0x00];
      };
      case (#Land) {
        bytes := [0xFD, 21, 0, 0, Nat8.fromNat(targetSystem), 0, 76, 0,
                  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                  0, 0, 0, 0, 0, 0, 0, 0, 0x15, 0x00];  // command 21
      };
      case (#ReturnToLaunch) {
        bytes := [0xFD, 21, 0, 0, Nat8.fromNat(targetSystem), 0, 76, 0,
                  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                  0, 0, 0, 0, 0, 0, 0, 0, 0x14, 0x00];  // command 20
      };
      case (#GoTo(pos)) {
        let latBytes = floatToBytes(Float.fromInt(Float.toInt(pos.lat * 1e7)));
        let lonBytes = floatToBytes(Float.fromInt(Float.toInt(pos.lon * 1e7)));
        let altBytes = floatToBytes(pos.alt);
        bytes := Array.append(bytes, [0xFD, 37, 0, 0, Nat8.fromNat(targetSystem), 0, 84, 0]);
        bytes := Array.append(bytes, latBytes);
        bytes := Array.append(bytes, lonBytes);
        bytes := Array.append(bytes, altBytes);
      };
      case _ {
        bytes := [];
      };
    };
    
    bytes
  };

  /// Convert float to 4 bytes (little endian IEEE 754)
  func floatToBytes(f: Float) : [Nat8] {
    // Simplified - in production use proper IEEE 754 conversion
    let asInt = Float.toInt(f * 1000.0);
    [
      Nat8.fromNat(Int.abs(asInt) % 256),
      Nat8.fromNat((Int.abs(asInt) / 256) % 256),
      Nat8.fromNat((Int.abs(asInt) / 65536) % 256),
      Nat8.fromNat((Int.abs(asInt) / 16777216) % 256)
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 16: SWARM FORMATION ALGORITHMS
  // ═══════════════════════════════════════════════════════════════════════════════
  // Advanced formation control with collision avoidance
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Reynolds flocking parameters
  public type FlockingParams = {
    separationWeight : Float;    // Avoid crowding neighbors
    alignmentWeight  : Float;    // Steer toward average heading
    cohesionWeight   : Float;    // Steer toward center of mass
    separationRadius : Float;    // Distance for separation
    neighborRadius   : Float;    // Distance for alignment/cohesion
    maxSpeed         : Float;    // Maximum velocity
    maxForce         : Float;    // Maximum steering force
  };

  /// Default flocking parameters
  public let defaultFlockingParams : FlockingParams = {
    separationWeight = 1.5;
    alignmentWeight = 1.0;
    cohesionWeight = 1.0;
    separationRadius = 10.0;
    neighborRadius = 50.0;
    maxSpeed = 15.0;
    maxForce = 5.0;
  };

  /// Compute Reynolds flocking steering
  public func computeFlockingSteering(
    dronePos: { x: Float; y: Float; z: Float },
    droneVel: { x: Float; y: Float; z: Float },
    neighbors: [{ pos: { x: Float; y: Float; z: Float }; vel: { x: Float; y: Float; z: Float } }],
    params: FlockingParams
  ) : { ax: Float; ay: Float; az: Float } {
    var separationX : Float = 0.0;
    var separationY : Float = 0.0;
    var separationZ : Float = 0.0;
    var separationCount : Nat = 0;
    
    var alignmentX : Float = 0.0;
    var alignmentY : Float = 0.0;
    var alignmentZ : Float = 0.0;
    var alignmentCount : Nat = 0;
    
    var cohesionX : Float = 0.0;
    var cohesionY : Float = 0.0;
    var cohesionZ : Float = 0.0;
    var cohesionCount : Nat = 0;
    
    for (neighbor in neighbors.vals()) {
      let dx = dronePos.x - neighbor.pos.x;
      let dy = dronePos.y - neighbor.pos.y;
      let dz = dronePos.z - neighbor.pos.z;
      let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
      
      // Separation: repel if too close
      if (dist > 0.1 and dist < params.separationRadius) {
        let repelStrength = 1.0 / dist;
        separationX += dx * repelStrength;
        separationY += dy * repelStrength;
        separationZ += dz * repelStrength;
        separationCount += 1;
      };
      
      // Alignment and cohesion: if within neighbor radius
      if (dist < params.neighborRadius) {
        alignmentX += neighbor.vel.x;
        alignmentY += neighbor.vel.y;
        alignmentZ += neighbor.vel.z;
        alignmentCount += 1;
        
        cohesionX += neighbor.pos.x;
        cohesionY += neighbor.pos.y;
        cohesionZ += neighbor.pos.z;
        cohesionCount += 1;
      };
    };
    
    var steerX : Float = 0.0;
    var steerY : Float = 0.0;
    var steerZ : Float = 0.0;
    
    // Separation steering
    if (separationCount > 0) {
      let n = Float.fromInt(separationCount);
      steerX += (separationX / n) * params.separationWeight;
      steerY += (separationY / n) * params.separationWeight;
      steerZ += (separationZ / n) * params.separationWeight;
    };
    
    // Alignment steering
    if (alignmentCount > 0) {
      let n = Float.fromInt(alignmentCount);
      let avgVx = alignmentX / n;
      let avgVy = alignmentY / n;
      let avgVz = alignmentZ / n;
      steerX += (avgVx - droneVel.x) * params.alignmentWeight;
      steerY += (avgVy - droneVel.y) * params.alignmentWeight;
      steerZ += (avgVz - droneVel.z) * params.alignmentWeight;
    };
    
    // Cohesion steering
    if (cohesionCount > 0) {
      let n = Float.fromInt(cohesionCount);
      let centerX = cohesionX / n;
      let centerY = cohesionY / n;
      let centerZ = cohesionZ / n;
      steerX += (centerX - dronePos.x) * params.cohesionWeight * 0.01;
      steerY += (centerY - dronePos.y) * params.cohesionWeight * 0.01;
      steerZ += (centerZ - dronePos.z) * params.cohesionWeight * 0.01;
    };
    
    // Limit steering force
    let steerMag = Float.sqrt(steerX*steerX + steerY*steerY + steerZ*steerZ);
    if (steerMag > params.maxForce) {
      let scale = params.maxForce / steerMag;
      steerX := steerX * scale;
      steerY := steerY * scale;
      steerZ := steerZ * scale;
    };
    
    { ax = steerX; ay = steerY; az = steerZ }
  };

  /// Obstacle avoidance (potential field method)
  public func computeObstacleAvoidance(
    dronePos: { x: Float; y: Float; z: Float },
    obstacles: [{ x: Float; y: Float; z: Float; radius: Float }],
    avoidanceGain: Float,
    avoidanceRange: Float
  ) : { ax: Float; ay: Float; az: Float } {
    var totalForceX : Float = 0.0;
    var totalForceY : Float = 0.0;
    var totalForceZ : Float = 0.0;
    
    for (obs in obstacles.vals()) {
      let dx = dronePos.x - obs.x;
      let dy = dronePos.y - obs.y;
      let dz = dronePos.z - obs.z;
      let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
      
      // Only repel if within avoidance range
      if (dist < avoidanceRange + obs.radius and dist > 0.01) {
        let penetration = avoidanceRange + obs.radius - dist;
        let repelStrength = avoidanceGain * penetration / dist;
        totalForceX += dx * repelStrength;
        totalForceY += dy * repelStrength;
        totalForceZ += dz * repelStrength;
      };
    };
    
    { ax = totalForceX; ay = totalForceY; az = totalForceZ }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 17: MISSION PLANNING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Autonomous mission planning with task allocation
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Mission types
  public type MissionType = {
    #Patrol : { waypoints: [{ lat: Float; lon: Float; alt: Float }]; loopForever: Bool };
    #Search : { area: { minLat: Float; maxLat: Float; minLon: Float; maxLon: Float }; pattern: Text };
    #Strike : { targets: [{ lat: Float; lon: Float; priority: Float }] };
    #Escort : { assetId: Nat; offset: { x: Float; y: Float; z: Float } };
    #Reconnaissance : { points: [{ lat: Float; lon: Float }]; dwellTime: Float };
    #Defend : { center: { lat: Float; lon: Float }; radius: Float };
  };

  /// Mission state
  public type MissionState = {
    missionId    : Nat;
    missionType  : MissionType;
    status       : Text;          // "planning", "executing", "paused", "complete", "aborted"
    assignedDrones : [Nat];
    currentWaypoint : Nat;
    progress     : Float;
    startTime    : Nat;
    estimatedEnd : Nat;
    priority     : Float;
  };

  /// Generate search pattern waypoints
  public func generateSearchPattern(
    area: { minLat: Float; maxLat: Float; minLon: Float; maxLon: Float },
    pattern: Text,
    altitude: Float,
    spacing: Float
  ) : [{ lat: Float; lon: Float; alt: Float }] {
    var waypoints : [{ lat: Float; lon: Float; alt: Float }] = [];
    
    let latRange = area.maxLat - area.minLat;
    let lonRange = area.maxLon - area.minLon;
    
    // Spacing in degrees (approximate)
    let latSpacing = spacing / 111000.0;
    let lonSpacing = spacing / (111000.0 * Float.cos((area.minLat + area.maxLat) / 2.0 * PI / 180.0));
    
    switch (pattern) {
      case "lawnmower" {
        // Back-and-forth pattern
        var lat = area.minLat;
        var direction = 1;
        while (lat <= area.maxLat) {
          if (direction == 1) {
            var lon = area.minLon;
            while (lon <= area.maxLon) {
              waypoints := Array.append(waypoints, [{ lat = lat; lon = lon; alt = altitude }]);
              lon += lonSpacing;
            };
          } else {
            var lon = area.maxLon;
            while (lon >= area.minLon) {
              waypoints := Array.append(waypoints, [{ lat = lat; lon = lon; alt = altitude }]);
              lon -= lonSpacing;
            };
          };
          lat += latSpacing;
          direction := -direction;
        };
      };
      
      case "spiral" {
        // Expanding spiral from center
        let centerLat = (area.minLat + area.maxLat) / 2.0;
        let centerLon = (area.minLon + area.maxLon) / 2.0;
        let maxRadius = Float.max(latRange, lonRange) / 2.0;
        
        var angle : Float = 0.0;
        var radius : Float = 0.0;
        while (radius < maxRadius) {
          let lat = centerLat + radius * Float.cos(angle) / latSpacing * latSpacing;
          let lon = centerLon + radius * Float.sin(angle) / lonSpacing * lonSpacing;
          if (lat >= area.minLat and lat <= area.maxLat and lon >= area.minLon and lon <= area.maxLon) {
            waypoints := Array.append(waypoints, [{ lat = lat; lon = lon; alt = altitude }]);
          };
          angle += 0.3;
          radius += latSpacing * 0.05;
        };
      };
      
      case _ {
        // Default: simple grid
        var lat = area.minLat;
        while (lat <= area.maxLat) {
          var lon = area.minLon;
          while (lon <= area.maxLon) {
            waypoints := Array.append(waypoints, [{ lat = lat; lon = lon; alt = altitude }]);
            lon += lonSpacing;
          };
          lat += latSpacing;
        };
      };
    };
    
    waypoints
  };

  /// Assign drones to mission optimally (Hungarian algorithm simplified)
  public func assignDronesToMission(
    availableDrones: [{ id: Nat; lat: Float; lon: Float; battery: Float }],
    missionWaypoints: [{ lat: Float; lon: Float; alt: Float }],
    dronesNeeded: Nat
  ) : [Nat] {
    // Score each drone by distance to first waypoint and battery
    var scores : [(Nat, Float)] = [];
    
    for (drone in availableDrones.vals()) {
      if (missionWaypoints.size() > 0) {
        let wp = missionWaypoints[0];
        let dist = Float.sqrt((drone.lat - wp.lat)**2.0 + (drone.lon - wp.lon)**2.0) * 111000.0;
        let distScore = 1.0 / (1.0 + dist / 1000.0);
        let batteryScore = drone.battery / 100.0;
        let totalScore = distScore * 0.6 + batteryScore * 0.4;
        scores := Array.append(scores, [(drone.id, totalScore)]);
      };
    };
    
    // Sort by score (descending) - simple bubble sort
    let mutableScores = Array.thaw<(Nat, Float)>(scores);
    for (i in Iter.range(0, Int.abs(scores.size() - 2))) {
      for (j in Iter.range(0, Int.abs(scores.size() - 2 - i))) {
        if (mutableScores[j].1 < mutableScores[j + 1].1) {
          let temp = mutableScores[j];
          mutableScores[j] := mutableScores[j + 1];
          mutableScores[j + 1] := temp;
        };
      };
    };
    scores := Array.freeze(mutableScores);
    
    // Take top N drones
    var assigned : [Nat] = [];
    var count = 0;
    for ((id, _) in scores.vals()) {
      if (count < dronesNeeded) {
        assigned := Array.append(assigned, [id]);
        count += 1;
      };
    };
    
    assigned
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 18: COLLISION AVOIDANCE SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════
  // Multi-level collision avoidance for swarm safety
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Collision risk assessment
  public type CollisionRisk = {
    droneA         : Nat;
    droneB         : Nat;
    timeToCollision : Float;       // seconds
    minSeparation  : Float;        // meters
    riskLevel      : Float;        // 0-1
    resolutionVec  : { x: Float; y: Float; z: Float };
  };

  /// Detect potential collisions
  public func detectCollisionRisks(
    drones: [{ id: Nat; pos: { x: Float; y: Float; z: Float }; vel: { x: Float; y: Float; z: Float } }],
    minSeparation: Float,
    lookAheadTime: Float
  ) : [CollisionRisk] {
    var risks : [CollisionRisk] = [];
    
    for (i in Iter.range(0, Int.abs(drones.size() - 1))) {
      for (j in Iter.range(i + 1, Int.abs(drones.size() - 1))) {
        if (j < drones.size()) {
          let droneA = drones[i];
          let droneB = drones[j];
          
          // Relative position and velocity
          let relPosX = droneB.pos.x - droneA.pos.x;
          let relPosY = droneB.pos.y - droneA.pos.y;
          let relPosZ = droneB.pos.z - droneA.pos.z;
          
          let relVelX = droneB.vel.x - droneA.vel.x;
          let relVelY = droneB.vel.y - droneA.vel.y;
          let relVelZ = droneB.vel.z - droneA.vel.z;
          
          // Current separation
          let currentSep = Float.sqrt(relPosX*relPosX + relPosY*relPosY + relPosZ*relPosZ);
          
          // Time to closest approach
          let relVelMag = Float.sqrt(relVelX*relVelX + relVelY*relVelY + relVelZ*relVelZ);
          let closingRate = -(relPosX*relVelX + relPosY*relVelY + relPosZ*relVelZ) / (currentSep + 0.01);
          
          let timeToClosest = if (closingRate > 0.0 and relVelMag > 0.1) {
            currentSep / closingRate
          } else { lookAheadTime + 1.0 };  // Not closing
          
          // Predicted minimum separation
          let predPosX = relPosX + relVelX * timeToClosest;
          let predPosY = relPosY + relVelY * timeToClosest;
          let predPosZ = relPosZ + relVelZ * timeToClosest;
          let predSep = Float.sqrt(predPosX*predPosX + predPosY*predPosY + predPosZ*predPosZ);
          
          let minSep = Float.min(currentSep, predSep);
          
          // Risk assessment
          if (minSep < minSeparation * 2.0 and timeToClosest < lookAheadTime) {
            let riskLevel = (1.0 - minSep / (minSeparation * 2.0)) * (1.0 - timeToClosest / lookAheadTime);
            
            // Resolution vector (perpendicular to closing direction)
            let resX = if (currentSep > 0.01) { relPosX / currentSep } else { 1.0 };
            let resY = if (currentSep > 0.01) { relPosY / currentSep } else { 0.0 };
            let resZ = if (currentSep > 0.01) { relPosZ / currentSep } else { 0.0 };
            
            risks := Array.append(risks, [{
              droneA = droneA.id;
              droneB = droneB.id;
              timeToCollision = timeToClosest;
              minSeparation = minSep;
              riskLevel = riskLevel;
              resolutionVec = { x = resX; y = resY; z = resZ };
            }]);
          };
        };
      };
    };
    
    risks
  };

  /// Compute collision avoidance maneuver
  public func computeAvoidanceManeuver(
    risk: CollisionRisk,
    droneId: Nat,
    maxAccel: Float
  ) : { ax: Float; ay: Float; az: Float } {
    // Direction to avoid (away from other drone)
    let isA = droneId == risk.droneA;
    let direction = if (isA) { -1.0 } else { 1.0 };
    
    // Urgency based on risk level
    let urgency = risk.riskLevel * 2.0;
    
    {
      ax = direction * risk.resolutionVec.x * maxAccel * urgency;
      ay = direction * risk.resolutionVec.y * maxAccel * urgency;
      az = direction * risk.resolutionVec.z * maxAccel * urgency;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 19: SWARM COMMUNICATION NETWORK
  // ═══════════════════════════════════════════════════════════════════════════════
  // Mesh network for swarm coordination
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Communication link state
  public type CommLink = {
    nodeA          : Nat;
    nodeB          : Nat;
    signalStrength : Float;       // dBm
    latency        : Float;       // ms
    bandwidth      : Float;       // kbps
    packetLoss     : Float;       // 0-1
    isActive       : Bool;
  };

  /// Network topology
  public type NetworkTopology = {
    nodes          : [Nat];        // Drone IDs
    links          : [CommLink];
    meshDensity    : Float;        // Average connections per node
    networkDiameter : Nat;         // Max hops between any two nodes
    partitions     : Nat;          // Number of disconnected subgraphs
  };

  /// Compute network topology
  public func computeNetworkTopology(
    drones: [{ id: Nat; pos: { x: Float; y: Float; z: Float } }],
    maxCommRange: Float,
    minSignalStrength: Float
  ) : NetworkTopology {
    var links : [CommLink] = [];
    var connectionCounts = Array.tabulate<Nat>(drones.size(), func(_) { 0 });
    
    for (i in Iter.range(0, Int.abs(drones.size() - 1))) {
      for (j in Iter.range(i + 1, Int.abs(drones.size() - 1))) {
        if (j < drones.size()) {
          let droneA = drones[i];
          let droneB = drones[j];
          
          let dx = droneB.pos.x - droneA.pos.x;
          let dy = droneB.pos.y - droneA.pos.y;
          let dz = droneB.pos.z - droneA.pos.z;
          let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
          
          if (dist < maxCommRange) {
            // Free space path loss model
            let signalStrength = -20.0 * Float.log(dist + 1.0) / Float.log(10.0) - 20.0;
            
            if (signalStrength > minSignalStrength) {
              let latency = dist / 300000000.0 * 1000.0;  // Light speed in ms
              let bandwidth = 1000.0 * (1.0 - dist / maxCommRange);  // Simple model
              let packetLoss = (dist / maxCommRange) ** 2.0 * 0.1;
              
              links := Array.append(links, [{
                nodeA = droneA.id;
                nodeB = droneB.id;
                signalStrength = signalStrength;
                latency = latency;
                bandwidth = bandwidth;
                packetLoss = packetLoss;
                isActive = true;
              }]);
              
              let countsMut = Array.thaw<Nat>(connectionCounts);
              countsMut[i] := countsMut[i] + 1;
              countsMut[j] := countsMut[j] + 1;
              connectionCounts := Array.freeze(countsMut);
            };
          };
        };
      };
    };
    
    // Compute mesh density
    var totalConnections : Nat = 0;
    for (c in connectionCounts.vals()) {
      totalConnections += c;
    };
    let density = Float.fromInt(totalConnections) / Float.fromInt(drones.size() * 2);
    
    {
      nodes = Array.tabulate<Nat>(drones.size(), func(i) { drones[i].id });
      links = links;
      meshDensity = density;
      networkDiameter = 1;  // Simplified
      partitions = 1;       // Simplified
    }
  };

  /// Route message through mesh
  public func routeMessage(
    source: Nat,
    destination: Nat,
    topology: NetworkTopology,
    maxHops: Nat
  ) : ?[Nat] {
    // Simple BFS routing
    var visited = Array.tabulate<Bool>(topology.nodes.size(), func(_) { false });
    var parent = Array.tabulate<?Nat>(topology.nodes.size(), func(_) { null });
    var queue : [Nat] = [source];
    
    // Mark source as visited
    for (i in Iter.range(0, Int.abs(topology.nodes.size() - 1))) {
      if (topology.nodes[i] == source) {
        let visitedMut = Array.thaw<Bool>(visited);
        visitedMut[i] := true;
        visited := Array.freeze(visitedMut);
      };
    };
    
    var found = false;
    var hops = 0;
    
    while (queue.size() > 0 and not found and hops < maxHops) {
      let current = queue[0];
      queue := Array.tabulate<Nat>(queue.size() - 1, func(i) { queue[i + 1] });
      
      if (current == destination) {
        found := true;
      } else {
        // Find neighbors
        for (link in topology.links.vals()) {
          let neighbor = if (link.nodeA == current) { ?link.nodeB }
                        else if (link.nodeB == current) { ?link.nodeA }
                        else { null };
          
          switch (neighbor) {
            case (?n) {
              // Find index of neighbor
              for (i in Iter.range(0, Int.abs(topology.nodes.size() - 1))) {
                if (topology.nodes[i] == n and not visited[i]) {
                  let visitedMut = Array.thaw<Bool>(visited);
                  visitedMut[i] := true;
                  visited := Array.freeze(visitedMut);
                  
                  let parentMut = Array.thaw<?Nat>(parent);
                  parentMut[i] := ?current;
                  parent := Array.freeze(parentMut);
                  
                  queue := Array.append(queue, [n]);
                };
              };
            };
            case null { };
          };
        };
      };
      
      hops += 1;
    };
    
    if (found) {
      // Reconstruct path
      var path : [Nat] = [destination];
      var current = destination;
      
      for (_ in Iter.range(0, maxHops)) {
        for (i in Iter.range(0, Int.abs(topology.nodes.size() - 1))) {
          if (topology.nodes[i] == current) {
            switch (parent[i]) {
              case (?p) {
                path := Array.append([p], path);
                current := p;
              };
              case null { };
            };
          };
        };
        if (current == source) { return ?path };
      };
      
      ?path
    } else { null }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 20: COMPLETE FLEET ORCHESTRATOR
  // ═══════════════════════════════════════════════════════════════════════════════
  // Master coordinator for the entire drone fleet
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Complete fleet state
  public type FleetState = {
    // Drones
    drones          : [HardwareTelemetry];
    droneCount      : Nat;
    activeDrones    : Nat;
    
    // Formation
    currentFormation : Text;
    formationCenter : { lat: Float; lon: Float; alt: Float };
    formationQuality : Float;
    
    // Missions
    activeMissions  : [MissionState];
    completedMissions : Nat;
    
    // Network
    networkTopology : NetworkTopology;
    commHealth      : Float;
    
    // Synchronization
    kuramotoPhase   : Float;
    kuramotoR       : Float;
    
    // Safety
    collisionRisks  : [CollisionRisk];
    alertLevel      : Float;
    
    // Timing
    beatNum         : Nat;
  };

  /// Initialize fleet state
  public func initFleetState(numDrones: Nat, baseLat: Float, baseLon: Float, baseAlt: Float) : FleetState {
    // Initialize drones in formation
    let drones = Array.tabulate<HardwareTelemetry>(numDrones, func(i) {
      let goldenAngle = PI * (3.0 - Float.sqrt(5.0));
      let theta = goldenAngle * Float.fromInt(i);
      let z = 1.0 - (2.0 * Float.fromInt(i) + 1.0) / Float.fromInt(numDrones);
      let radius = Float.sqrt(1.0 - z * z) * 0.0001;
      
      {
        systemId = i + 1;
        componentId = 1;
        autopilotType = 3;
        vehicleType = 2;
        latitude = baseLat + radius * Float.cos(theta);
        longitude = baseLon + radius * Float.sin(theta);
        altitude = baseAlt + z * 20.0;
        relativeAlt = z * 20.0;
        vx = 0.0; vy = 0.0; vz = 0.0;
        groundSpeed = 0.0;
        roll = 0.0; pitch = 0.0; yaw = theta;
        rollspeed = 0.0; pitchspeed = 0.0; yawspeed = 0.0;
        voltage = 16800.0;
        current = 0.0;
        remaining = 100;
        mode = 0;
        armed = false;
        ekfOk = true;
        gpsFixType = 3;
        satCount = 12;
        bootTime = 0;
        timestamp = 0;
      }
    });
    
    {
      drones = drones;
      droneCount = numDrones;
      activeDrones = numDrones;
      currentFormation = "fibonacci";
      formationCenter = { lat = baseLat; lon = baseLon; alt = baseAlt };
      formationQuality = 1.0;
      activeMissions = [];
      completedMissions = 0;
      networkTopology = { nodes = []; links = []; meshDensity = 0.0; networkDiameter = 0; partitions = 1 };
      commHealth = 1.0;
      kuramotoPhase = 0.0;
      kuramotoR = 0.5;
      collisionRisks = [];
      alertLevel = 0.0;
      beatNum = 0;
    }
  };

  /// Execute one tick of fleet management
  public func tickFleet(state: FleetState, dt: Float) : FleetState {
    // 1. Update Kuramoto synchronization
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    let n = state.drones.size();
    
    for (drone in state.drones.vals()) {
      let phase = drone.yaw;  // Use yaw as phase
      sumCos += Float.cos(phase);
      sumSin += Float.sin(phase);
    };
    
    let meanPhase = Float.arctan2(sumSin, sumCos);
    let coherence = Float.sqrt(sumCos*sumCos + sumSin*sumSin) / Float.fromInt(n);
    
    // 2. Check collision risks
    let dronePositions = Array.map<HardwareTelemetry, { id: Nat; pos: { x: Float; y: Float; z: Float }; vel: { x: Float; y: Float; z: Float } }>(
      state.drones,
      func(d) {
        { 
          id = d.systemId;
          pos = { x = d.longitude * 111000.0; y = d.latitude * 111000.0; z = d.altitude / 1000.0 };
          vel = { x = d.vx / 100.0; y = d.vy / 100.0; z = d.vz / 100.0 };
        }
      }
    );
    let risks = detectCollisionRisks(dronePositions, 10.0, 5.0);
    
    // 3. Compute formation quality
    var formationError : Float = 0.0;
    let centerLat = state.formationCenter.lat;
    let centerLon = state.formationCenter.lon;
    
    for (drone in state.drones.vals()) {
      let dLat = drone.latitude - centerLat;
      let dLon = drone.longitude - centerLon;
      formationError += Float.sqrt(dLat*dLat + dLon*dLon);
    };
    let formationQuality = 1.0 / (1.0 + formationError * 1000.0);
    
    // 4. Update alert level
    var alertLevel : Float = 0.0;
    for (risk in risks.vals()) {
      if (risk.riskLevel > alertLevel) { alertLevel := risk.riskLevel };
    };
    
    {
      drones = state.drones;
      droneCount = state.droneCount;
      activeDrones = state.activeDrones;
      currentFormation = state.currentFormation;
      formationCenter = state.formationCenter;
      formationQuality = formationQuality;
      activeMissions = state.activeMissions;
      completedMissions = state.completedMissions;
      networkTopology = state.networkTopology;
      commHealth = state.commHealth;
      kuramotoPhase = meanPhase;
      kuramotoR = coherence;
      collisionRisks = risks;
      alertLevel = alertLevel;
      beatNum = state.beatNum + 1;
    }
  };

  /// Generate fleet output for organism integration
  public type FleetOutput = {
    droneCount       : Nat;
    activeDrones     : Nat;
    swarmCoherence   : Float;
    formationQuality : Float;
    missionProgress  : Float;
    commHealth       : Float;
    alertLevel       : Float;
    centerLat        : Float;
    centerLon        : Float;
    centerAlt        : Float;
    beatNum          : Nat;
  };

  public func generateFleetOutput(state: FleetState) : FleetOutput {
    var missionProgress : Float = 0.0;
    if (state.activeMissions.size() > 0) {
      for (mission in state.activeMissions.vals()) {
        missionProgress += mission.progress;
      };
      missionProgress := missionProgress / Float.fromInt(state.activeMissions.size());
    };
    
    {
      droneCount = state.droneCount;
      activeDrones = state.activeDrones;
      swarmCoherence = state.kuramotoR;
      formationQuality = state.formationQuality;
      missionProgress = missionProgress;
      commHealth = state.commHealth;
      alertLevel = state.alertLevel;
      centerLat = state.formationCenter.lat;
      centerLon = state.formationCenter.lon;
      centerAlt = state.formationCenter.alt;
      beatNum = state.beatNum;
    }
  };

}
