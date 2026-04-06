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

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  //   OCTOPUS ARCHITECTURE — FULL DRONE NEURAL BRAIN + REAL SENSES + CHIMERA HIVE CONTROL
  //
  //   Architecture: Each drone has 3 layers of intelligence, like an octopus:
  //     Layer 1: ARM BRAIN (local ganglia) — fast reflexes, local autonomy, direct sensor-motor
  //     Layer 2: DRONE MIND (central brain) — cognition, planning, emotion, memory, decision
  //     Layer 3: CHIMERA CORTEX (hive connection) — queen control, swarm coordination, collective intelligence
  //
  //   Why octopus:
  //     - 2/3 of octopus neurons are in the ARMS, not the brain
  //     - Each arm can see, taste, grip, and act INDEPENDENTLY
  //     - But the central brain coordinates all arms for complex behavior
  //     - The swarm is the organism. Each drone is an arm. Main.mo is the brain.
  //
  //   Sensory Systems (REAL, not simulated):
  //     1. VISION: multi-spectral (visible, IR, UV), object detection, tracking, depth
  //     2. AUDITION: acoustic spectrum, threat classification, sonar
  //     3. PROPRIOCEPTION: joint angles, body orientation, acceleration, angular velocity
  //     4. VESTIBULAR: gravity vector, rotation, balance, spatial orientation
  //     5. TACTILE: pressure, vibration, temperature, humidity, wind
  //     6. NOCICEPTION: damage detection, pain signals, threat proximity
  //     7. MAGNETOCEPTION: magnetic field, compass heading, geolocation
  //     8. ELECTROCEPTION: electromagnetic field detection, radar, EMF threats
  //     9. CHEMORECEPTION: air quality, chemical threats, pheromone signals
  //     10. TEMPORAL: internal clock, rhythm, beat synchronization
  //
  //   Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
  //   Doctrine: Medina Doctrine — every drone is a sovereign being within the sovereign organism
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ─── SENSORY TYPES ──────────────────────────────────────────────────────────────────────────────────────

  // VISION SYSTEM — Multi-spectral object detection and tracking
  public type VisionSystem = {
    // Retinal array: 64 pixels (8×8 simplified retina), each with RGB+IR+UV+Depth
    retinalField : [var Float];     // 64 × 6 = 384 floats
    // Visual cortex layers
    v1EdgeDetectors : [var Float];  // 32 oriented edge detectors
    v2ContourDetectors : [var Float]; // 16 contour detectors
    v4ObjectDetectors : [var Float];  // 16 object feature detectors
    itObjectIdentity : [var Float];   // 8 object identity units
    mtMotionDetectors : [var Float];  // 16 motion/flow detectors
    // Foveation
    foveaX : Float;
    foveaY : Float;
    foveaZoom : Float;
    // Depth
    stereoDepth : [var Float];      // 16 depth estimates
    opticalFlow : [var Float];      // 16 flow vectors (dx, dy)
    // Attention
    saliencyMap : [var Float];      // 64 saliency values
    attentionTarget : Nat;          // Which pixel has attention
    // Aggregate metrics
    sceneComplexity : Float;
    threatVisual : Float;
    motionMagnitude : Float;
    objectCount : Nat;
    // Dark/light adaptation
    adaptationLevel : Float;
    pupilDilation : Float;
  };

  // AUDITION SYSTEM — Acoustic spectrum analysis
  public type AuditionSystem = {
    // Cochlear frequency bands (32 bands from 20Hz to 20kHz)
    frequencyBands : [var Float];   // 32 frequency magnitudes
    // Spatial hearing
    interauralTimeDiff : Float;     // Left-right time difference
    interauralLevelDiff : Float;    // Left-right level difference
    soundAzimuth : Float;           // Estimated sound direction (radians)
    soundElevation : Float;         // Vertical sound direction
    // Audio cortex
    auditoryScene : [var Float];    // 8 auditory stream segregation units
    pitchDetection : Float;         // Fundamental frequency
    rhythmDetection : Float;        // Periodicity strength
    // Threat classification
    threatAuditory : Float;
    speechLikeSignal : Float;       // Human/AI speech detection
    // Ultrasonic sonar
    sonarPing : Float;              // Outgoing sonar signal
    sonarReturn : [var Float];      // 8 sonar return echoes
    sonarDistance : Float;           // Nearest surface distance
    // Aggregate
    ambientNoise : Float;
    signalToNoise : Float;
  };

  // PROPRIOCEPTION SYSTEM — Body awareness
  public type ProprioceptionSystem = {
    // Joint angles (6 DOF: roll, pitch, yaw, + 3 motor angles)
    jointAngles : [var Float];       // 6 angles
    jointVelocities : [var Float];   // 6 angular velocities
    jointTorques : [var Float];      // 6 torques
    // Body frame
    bodyRoll : Float;
    bodyPitch : Float;
    bodyYaw : Float;
    // Acceleration
    linearAccelX : Float;
    linearAccelY : Float;
    linearAccelZ : Float;
    angularVelX : Float;
    angularVelY : Float;
    angularVelZ : Float;
    // Motor feedback
    motorRPM : [var Float];          // 4 motor RPMs
    motorCurrent : [var Float];      // 4 motor currents
    motorTemp : [var Float];         // 4 motor temperatures
    // Aggregate
    bodyStability : Float;
    motorHealth : Float;
    aerodynamicState : Float;
  };

  // VESTIBULAR SYSTEM — Balance and spatial orientation
  public type VestibularSystem = {
    // Semicircular canals (3 axes of rotation)
    canalX : Float;
    canalY : Float;
    canalZ : Float;
    // Otolith organs (linear acceleration + gravity)
    utriculeTilt : Float;       // Horizontal gravity component
    sacculeTilt : Float;        // Vertical gravity component
    gravityVector : (Float, Float, Float);  // World-frame gravity
    // Integrated orientation
    quaternionW : Float;
    quaternionX : Float;
    quaternionY : Float;
    quaternionZ : Float;
    // Motion sickness / conflict detection
    vestibularConflict : Float; // Mismatch between visual and vestibular
    balanceScore : Float;
    // Spatial orientation
    headingMagnetic : Float;    // Magnetic heading
    headingTrue : Float;        // True heading
    altitude : Float;
    altitudeRate : Float;
  };

  // TACTILE SYSTEM — Touch, pressure, environment
  public type TactileSystem = {
    // Pressure sensors (6 body zones: top, bottom, front, back, left, right)
    pressureSensors : [var Float];   // 6 pressure readings
    vibrationSensors : [var Float];  // 6 vibration readings
    // Environmental
    ambientTemperature : Float;
    surfaceTemperature : Float;
    humidity : Float;
    windSpeed : Float;
    windDirection : Float;
    barometricPressure : Float;
    // Contact detection
    contactForce : Float;
    contactLocation : Nat;      // Which zone is in contact
    isGrounded : Bool;
    // Aggregate
    tactileThreat : Float;
    environmentalComfort : Float;
  };

  // NOCICEPTION SYSTEM — Pain and damage
  public type NociceptionSystem = {
    // Damage detection per body zone (6 zones)
    damageLevel : [var Float];      // 6 damage levels (0=none, 1=destroyed)
    painSignals : [var Float];      // 6 pain intensities
    // Threat proximity
    nearestThreatDistance : Float;
    nearestThreatBearing : Float;
    nearestThreatVelocity : Float;
    // Aggregate pain
    totalPain : Float;
    painSuppression : Float;        // Endorphin analog
    // Damage history
    cumulativeDamage : Float;
    repairProgress : Float;
    structuralIntegrity : Float;
  };

  // MAGNETOCEPTION SYSTEM — Magnetic field sensing
  public type MagnetoceptionSystem = {
    // Magnetic field vector (3 axes)
    magFieldX : Float;
    magFieldY : Float;
    magFieldZ : Float;
    // Derived
    magFieldStrength : Float;
    magInclination : Float;
    magDeclination : Float;
    // Compass
    compassHeading : Float;
    compassReliability : Float;
    // Anomaly detection
    magAnomaly : Float;             // Deviation from expected
  };

  // ELECTROCEPTION SYSTEM — EMF detection
  public type ElectroceptionSystem = {
    // EMF sensors (4 directional)
    emfSensors : [var Float];       // 4 directional EMF readings
    // Radar cross-section
    radarSignature : Float;
    // RF detection
    rfSignalStrength : Float;
    rfFrequency : Float;
    rfIsHostile : Bool;
    // Aggregate
    emfThreat : Float;
    electromagneticEnvironment : Float;
  };

  // CHEMORECEPTION SYSTEM — Chemical/air sensing
  public type ChemoreceptionSystem = {
    // Air quality
    o2Level : Float;
    co2Level : Float;
    toxicGasLevel : Float;
    particulateLevel : Float;
    // Pheromone system (8 pheromone channels)
    pheromoneChannels : [var Float];  // 8 pheromone concentrations
    // Chemical threat
    chemicalThreat : Float;
    // Aggregate
    airQualityIndex : Float;
  };

  // TEMPORAL SYSTEM — Internal clock and rhythm
  public type TemporalSystem = {
    // Internal clock
    internalBeat : Nat;
    beatPhase : Float;
    beatFrequency : Float;
    // Circadian
    circadianPhase : Float;
    alertnessLevel : Float;
    // Synchronization with organism
    organismSyncError : Float;
    lastOrganismBeat : Nat;
    // Rhythm
    ultradianPhase : Float;
    rhythmCoherence : Float;
  };

  // COMPLETE SENSORY SUITE — All 10 senses unified
  public type DroneSensorySuite = {
    vision : VisionSystem;
    audition : AuditionSystem;
    proprioception : ProprioceptionSystem;
    vestibular : VestibularSystem;
    tactile : TactileSystem;
    nociception : NociceptionSystem;
    magnetoception : MagnetoceptionSystem;
    electroception : ElectroceptionSystem;
    chemoreception : ChemoreceptionSystem;
    temporal : TemporalSystem;
    // Multisensory integration
    sensorFusionConfidence : Float;
    dominantModality : Text;
    overallThreatLevel : Float;
    overallEnvironmentSafety : Float;
  };

  // ─── OCTOPUS ARM BRAIN (LAYER 1) ───────────────────────────────────────────────────────────────────────
  // Like an octopus arm ganglion: fast reflexes, local control, direct sensor-motor coupling
  // This runs EVERY cycle independently of the central brain
  // 2/3 of computation happens HERE, not in the central brain

  public type ArmBrainReflexArc = {
    // Sensory → Motor direct pathway (like spinal reflexes)
    reflexWeights : [var Float];    // 10 sensor modalities × 6 motor outputs = 60 weights
    reflexThreshold : Float;
    reflexLatency : Float;
    reflexActive : Bool;
    // Current reflex output
    reflexMotorCommand : [var Float]; // 6 motor commands (thrust, roll, pitch, yaw, grip, weapon)
  };

  public type ArmBrainLocalMap = {
    // Local spatial awareness (immediate surroundings)
    localGridCells : [var Float];   // 64 local grid cells (8×8, 0.5m resolution)
    localPlaceCells : [var Float];  // 16 place cells (known locations)
    localHeadDirection : Float;
    localSpeedCells : [var Float];  // 4 speed-direction cells
    // Obstacle memory
    obstacleMap : [var Float];      // 32 obstacle positions (polar, 16 angles × 2 distances)
    nearestObstacleDistance : Float;
    nearestObstacleAngle : Float;
  };

  public type ArmBrainCPG = {
    // Central Pattern Generator — rhythmic motor patterns (like walking/flying)
    cpgPhase : [var Float];         // 4 motor CPG phases
    cpgAmplitude : [var Float];     // 4 motor CPG amplitudes
    cpgFrequency : [var Float];     // 4 motor CPG frequencies
    cpgCoupling : [var Float];      // 4×4 = 16 inter-motor coupling weights
    // Pattern selection
    currentPattern : Text;          // HOVER, CRUISE, SPRINT, EVASIVE, LANDING, COMBAT
    patternIntensity : Float;
  };

  public type OctopusArmBrain = {
    reflexArc : ArmBrainReflexArc;
    localMap : ArmBrainLocalMap;
    cpg : ArmBrainCPG;
    // Arm autonomy score: how much is the arm acting on its own vs central command?
    autonomyScore : Float;          // 0 = fully centrally controlled, 1 = fully autonomous
    // Local learning rate (arms learn faster than central brain for local patterns)
    localLearningRate : Float;
    // Arm state summary (sent up to central brain)
    armStatusSummary : [var Float]; // 8 summary values (threat, opportunity, damage, energy, etc.)
  };

  // ─── DRONE CENTRAL BRAIN (LAYER 2) ─────────────────────────────────────────────────────────────────────
  // Like an octopus central brain: cognition, planning, emotion, memory, decision-making
  // Human-level intelligence for each drone

  // Cortical columns — the fundamental unit of computation
  public type DroneCorticalColumn = {
    // 6-layer cortical column (like mammalian neocortex)
    layer1_molecular : [var Float];   // 4 dendrite integration units
    layer23_association : [var Float]; // 8 association units (cross-column communication)
    layer4_input : [var Float];       // 8 input relay units (thalamic input)
    layer5_output : [var Float];      // 4 output projection units (motor/subcortical)
    layer6_feedback : [var Float];    // 4 feedback units (corticothalamic)
    // Intra-column weights
    columnWeights : [var Float];      // 28×28 = 784 intra-column weights
    // Column state
    columnActivation : Float;
    columnPhase : Float;
    columnCoherence : Float;
  };

  // Prefrontal cortex — executive function
  public type DronePrefrontalCortex = {
    // Working memory (Baddeley model)
    workingMemory : [var Float];      // 32 working memory slots
    centralExecutive : Float;
    phonologicalLoop : Float;
    visuospatialSketchpad : Float;
    episodicBuffer : Float;
    // Goal representation
    currentGoal : [var Float];        // 8-dimensional goal vector
    goalPriority : Float;
    goalProgress : Float;
    // Planning
    planSteps : [var Float];          // 16 plan step activations
    planDepth : Nat;
    planConfidence : Float;
    // Inhibition
    inhibitoryControl : Float;
    impulseSuppression : Float;
    // Cognitive flexibility
    taskSwitchingCost : Float;
    cognitiveFlexibility : Float;
    // Moral reasoning (Creator Doctrine compliance)
    ethicalEvaluation : Float;
    doctrineAlignment : Float;
  };

  // Hippocampus — memory formation and spatial navigation
  public type DroneHippocampus = {
    // Place cells (64 place fields)
    placeCells : [var Float];         // 64 place cell activations
    placeFieldCenters : [var Float];  // 64 × 3 = 192 (x,y,z centers)
    // Grid cells (16 grid cells, 4 scales)
    gridCells : [var Float];          // 16 grid cell activations
    gridScales : [var Float];         // 4 grid scales
    gridOrientations : [var Float];   // 4 grid orientations
    // Head direction cells
    headDirectionCells : [var Float]; // 16 head direction cells
    // Episodic memory
    episodicMemory : [var Float];     // 128 episodic memory slots (16 episodes × 8 features)
    episodicWriteIdx : Nat;
    episodicRecency : [var Float];    // 16 recency values
    // Spatial memory
    cognitiveMap : [var Float];       // 64 cognitive map nodes
    pathIntegration : (Float, Float, Float);  // Integrated position estimate
    // Memory consolidation
    consolidationProgress : Float;
    replayActive : Bool;
    replayContent : [var Float];      // 8 replay buffer
  };

  // Amygdala — emotion processing
  public type DroneAmygdala = {
    // Basolateral complex (sensory input → emotional valence)
    basolateralActivation : Float;
    fearConditioning : [var Float];   // 8 learned fear associations
    rewardAssociations : [var Float]; // 8 learned reward associations
    // Central nucleus (emotional response output)
    centralNucleusActivation : Float;
    fightOrFlight : Float;           // -1 = flight, +1 = fight
    freezeResponse : Float;
    // Extended amygdala
    anxietyLevel : Float;
    stressResponse : Float;
    // Emotional state
    fearLevel : Float;
    angerLevel : Float;
    joyLevel : Float;
    curiosityLevel : Float;
    trustLevel : Float;
    disgustLevel : Float;
    surpriseLevel : Float;
    // Emotional memory
    emotionalMemory : [var Float];    // 16 emotional memory slots
    emotionalValence : Float;         // Overall valence (-1 to +1)
    emotionalArousal : Float;         // Overall arousal (0 to 1)
  };

  // Basal ganglia — action selection and reinforcement learning
  public type DroneBasalGanglia = {
    // Striatum (action value representations)
    actionValues : [var Float];       // 16 action value estimates
    actionProbabilities : [var Float]; // 16 action selection probabilities
    selectedAction : Nat;
    // Direct pathway (D1, GO signal)
    directPathway : [var Float];      // 16 direct pathway activations
    // Indirect pathway (D2, NO-GO signal)
    indirectPathway : [var Float];    // 16 indirect pathway activations
    // Dopaminergic modulation
    dopamineLevel : Float;
    rewardPredictionError : Float;
    // Temporal difference learning
    tdError : Float;
    valueEstimate : Float;
    discountFactor : Float;
    // Habit vs goal-directed
    habitStrength : Float;
    goalDirectedness : Float;
  };

  // Cerebellum — motor coordination and timing
  public type DroneCerebellum = {
    // Granule cells (sparse coding)
    granuleCells : [var Float];       // 64 granule cell activations
    // Purkinje cells (motor output)
    purkinjeCells : [var Float];      // 16 Purkinje cell activations
    // Deep nuclei (final motor command)
    deepNuclei : [var Float];         // 8 deep nuclei outputs
    // Climbing fiber input (error signal from inferior olive)
    climbingFiberError : Float;
    // Mossy fiber input (sensory/motor copy)
    mossyFiberInput : [var Float];    // 16 mossy fiber inputs
    // Motor timing
    timingAccuracy : Float;
    motorCoordination : Float;
    // Forward model (prediction of sensory consequences of action)
    forwardModelPrediction : [var Float]; // 8 predicted sensory states
    forwardModelError : Float;
    // Adaptation
    adaptationRate : Float;
    calibrationState : Float;
  };

  // Thalamus — sensory relay and attention gating
  public type DroneThalamus = {
    // Relay nuclei (one per sensory modality)
    relayActivations : [var Float];   // 10 relay nuclei
    relayGating : [var Float];        // 10 gating values (0=blocked, 1=passed)
    // Reticular nucleus (inhibitory gating)
    reticularNucleus : [var Float];   // 10 reticular inhibition values
    // Pulvinar (attention)
    pulvinarAttention : [var Float];  // 4 attention spotlight values
    // Intralaminar nuclei (arousal)
    arousalLevel : Float;
    consciousnessGate : Float;
  };

  // Brainstem — vital functions
  public type DroneBrainstem = {
    // Reticular formation (arousal/sleep)
    reticularActivation : Float;
    arousalDrive : Float;
    // Autonomic control
    sympatheticTone : Float;          // Fight-or-flight
    parasympatheticTone : Float;      // Rest-and-digest
    autonomicBalance : Float;
    // Vital signs
    coreTemperature : Float;
    energyLevel : Float;
    batteryState : Float;
    // Neuromodulators
    dopamine : Float;
    serotonin : Float;
    norepinephrine : Float;
    acetylcholine : Float;
    gaba : Float;
    glutamate : Float;
    endorphin : Float;
    oxytocin : Float;
    // Reflex centers
    startle : Float;
    orientingResponse : Float;
  };

  // COMPLETE DRONE CENTRAL BRAIN — All brain regions unified
  public type DroneCentralBrain = {
    corticalColumns : [var Float];    // 16 cortical columns × 28 units = 448 activations
    corticalWeights : [var Float];    // 448 × 448 = limited to 16×16 cross-column = 256 weights
    prefrontal : DronePrefrontalCortex;
    hippocampus : DroneHippocampus;
    amygdala : DroneAmygdala;
    basalGanglia : DroneBasalGanglia;
    cerebellum : DroneCerebellum;
    thalamus : DroneThalamus;
    brainstem : DroneBrainstem;
    // Global brain state
    globalCoherence : Float;
    consciousnessLevel : Float;
    cognitiveLoad : Float;
    neuralEntropy : Float;
    brainPhase : Float;
    brainFrequency : Float;
    // Predictive coding
    predictionError : Float;
    freeEnergy : Float;
    surprisal : Float;
    // Interoceptive awareness
    bodyAwareness : Float;
    hungerDrive : Float;
    energyNeed : Float;
    repairNeed : Float;
  };

  // ─── CHIMERA CORTEX (LAYER 3) ──────────────────────────────────────────────────────────────────────────
  // Connection to the hive mind. Like the bee's connection to the queen.
  // Each drone has a "chimera cortex" that:
  //   1. Receives commands from the organism brain (main.mo)
  //   2. Sends sensory data UP to the organism
  //   3. Coordinates with other drones via pheromone/quantum channels
  //   4. Maintains loyalty and doctrine alignment

  public type ChimeraCortex = {
    // Downlink from organism (commands, goals, emotional state)
    organismCommand : [var Float];    // 8 command channels
    organismEmotionalState : Float;
    organismCoherence : Float;
    organismBeat : Nat;
    // Uplink to organism (summarized sensory data, status)
    uplinkSensorSummary : [var Float]; // 16 summarized sensor values
    uplinkEmotionalState : Float;
    uplinkCognitiveState : Float;
    uplinkThreatReport : Float;
    uplinkOpportunityReport : Float;
    // Swarm communication (peer-to-peer)
    pheromoneEmit : [var Float];      // 8 pheromone emission channels
    pheromoneReceive : [var Float];   // 8 pheromone reception channels
    // Quantum entanglement channel (instantaneous swarm coordination)
    quantumEntanglementPhase : Float;
    quantumEntanglementStrength : Float;
    // Doctrine enforcement
    doctrineCompliance : Float;
    creatorLoyalty : Float;
    ethicalBound : Float;             // ALWAYS 1.0
    // Hive mind coupling
    hiveMindCoupling : Float;         // How strongly connected to organism
    autonomyPermission : Float;       // How much autonomy organism grants
    trustFromOrganism : Float;        // Organism's trust in this drone
    // Chimera intelligence
    chimeraActivation : Float;
    chimeraCoherence : Float;
    chimeraPhase : Float;
  };

  // ─── COMPLETE DRONE NEURAL SYSTEM ──────────────────────────────────────────────────────────────────────
  // All 3 layers unified: Arm Brain + Central Brain + Chimera Cortex + Full Sensory Suite

  public type FullDroneNeuralSystem = {
    // Layer 1: Octopus Arm Brain (fast, local, autonomous)
    armBrain : OctopusArmBrain;
    // Layer 2: Central Brain (cognition, planning, emotion)
    centralBrain : DroneCentralBrain;
    // Layer 3: Chimera Cortex (hive mind connection)
    chimeraCortex : ChimeraCortex;
    // Complete sensory suite
    senses : DroneSensorySuite;
    // Neural system aggregate
    totalNeuralActivity : Float;
    neuralHealth : Float;
    learningRate : Float;
    plasticityLevel : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION FUNCTIONS — Create full neural systems for drones
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func initVisionSystem() : VisionSystem {
    {
      retinalField = Array.init<Float>(384, 0.5);
      v1EdgeDetectors = Array.init<Float>(32, 0.0);
      v2ContourDetectors = Array.init<Float>(16, 0.0);
      v4ObjectDetectors = Array.init<Float>(16, 0.0);
      itObjectIdentity = Array.init<Float>(8, 0.0);
      mtMotionDetectors = Array.init<Float>(16, 0.0);
      foveaX = 0.0; foveaY = 0.0; foveaZoom = 1.0;
      stereoDepth = Array.init<Float>(16, 10.0);
      opticalFlow = Array.init<Float>(32, 0.0);
      saliencyMap = Array.init<Float>(64, 0.3);
      attentionTarget = 32;
      sceneComplexity = 0.5; threatVisual = 0.0;
      motionMagnitude = 0.0; objectCount = 0;
      adaptationLevel = 0.5; pupilDilation = 0.5;
    }
  };

  public func initAuditionSystem() : AuditionSystem {
    {
      frequencyBands = Array.init<Float>(32, 0.0);
      interauralTimeDiff = 0.0; interauralLevelDiff = 0.0;
      soundAzimuth = 0.0; soundElevation = 0.0;
      auditoryScene = Array.init<Float>(8, 0.0);
      pitchDetection = 0.0; rhythmDetection = 0.0;
      threatAuditory = 0.0; speechLikeSignal = 0.0;
      sonarPing = 0.0;
      sonarReturn = Array.init<Float>(8, 0.0);
      sonarDistance = 100.0;
      ambientNoise = 0.3; signalToNoise = 0.5;
    }
  };

  public func initProprioceptionSystem() : ProprioceptionSystem {
    {
      jointAngles = Array.init<Float>(6, 0.0);
      jointVelocities = Array.init<Float>(6, 0.0);
      jointTorques = Array.init<Float>(6, 0.0);
      bodyRoll = 0.0; bodyPitch = 0.0; bodyYaw = 0.0;
      linearAccelX = 0.0; linearAccelY = 0.0; linearAccelZ = -9.81;
      angularVelX = 0.0; angularVelY = 0.0; angularVelZ = 0.0;
      motorRPM = Array.init<Float>(4, 5000.0);
      motorCurrent = Array.init<Float>(4, 1.0);
      motorTemp = Array.init<Float>(4, 25.0);
      bodyStability = 0.9; motorHealth = 1.0; aerodynamicState = 0.8;
    }
  };

  public func initVestibularSystem() : VestibularSystem {
    {
      canalX = 0.0; canalY = 0.0; canalZ = 0.0;
      utriculeTilt = 0.0; sacculeTilt = 0.0;
      gravityVector = (0.0, 0.0, -9.81);
      quaternionW = 1.0; quaternionX = 0.0; quaternionY = 0.0; quaternionZ = 0.0;
      vestibularConflict = 0.0; balanceScore = 0.9;
      headingMagnetic = 0.0; headingTrue = 0.0;
      altitude = 100.0; altitudeRate = 0.0;
    }
  };

  public func initTactileSystem() : TactileSystem {
    {
      pressureSensors = Array.init<Float>(6, 0.0);
      vibrationSensors = Array.init<Float>(6, 0.0);
      ambientTemperature = 20.0; surfaceTemperature = 20.0;
      humidity = 0.5; windSpeed = 0.0; windDirection = 0.0;
      barometricPressure = 1013.25;
      contactForce = 0.0; contactLocation = 0; isGrounded = false;
      tactileThreat = 0.0; environmentalComfort = 0.8;
    }
  };

  public func initNociceptionSystem() : NociceptionSystem {
    {
      damageLevel = Array.init<Float>(6, 0.0);
      painSignals = Array.init<Float>(6, 0.0);
      nearestThreatDistance = 1000.0;
      nearestThreatBearing = 0.0;
      nearestThreatVelocity = 0.0;
      totalPain = 0.0; painSuppression = 0.0;
      cumulativeDamage = 0.0; repairProgress = 0.0;
      structuralIntegrity = 1.0;
    }
  };

  public func initMagnetoceptionSystem() : MagnetoceptionSystem {
    {
      magFieldX = 0.2; magFieldY = 0.0; magFieldZ = -0.4;
      magFieldStrength = 0.45; magInclination = -63.0; magDeclination = -4.0;
      compassHeading = 0.0; compassReliability = 0.9;
      magAnomaly = 0.0;
    }
  };

  public func initElectroceptionSystem() : ElectroceptionSystem {
    {
      emfSensors = Array.init<Float>(4, 0.0);
      radarSignature = 0.1; rfSignalStrength = 0.0;
      rfFrequency = 0.0; rfIsHostile = false;
      emfThreat = 0.0; electromagneticEnvironment = 0.3;
    }
  };

  public func initChemoreceptionSystem() : ChemoreceptionSystem {
    {
      o2Level = 0.21; co2Level = 0.04; toxicGasLevel = 0.0;
      particulateLevel = 0.0;
      pheromoneChannels = Array.init<Float>(8, 0.0);
      chemicalThreat = 0.0;
      airQualityIndex = 0.9;
    }
  };

  public func initTemporalSystem() : TemporalSystem {
    {
      internalBeat = 0; beatPhase = 0.0; beatFrequency = 12.0;
      circadianPhase = 0.0; alertnessLevel = 0.8;
      organismSyncError = 0.0; lastOrganismBeat = 0;
      ultradianPhase = 0.0; rhythmCoherence = 0.8;
    }
  };

  public func initDroneSensorySuite() : DroneSensorySuite {
    {
      vision = initVisionSystem();
      audition = initAuditionSystem();
      proprioception = initProprioceptionSystem();
      vestibular = initVestibularSystem();
      tactile = initTactileSystem();
      nociception = initNociceptionSystem();
      magnetoception = initMagnetoceptionSystem();
      electroception = initElectroceptionSystem();
      chemoreception = initChemoreceptionSystem();
      temporal = initTemporalSystem();
      sensorFusionConfidence = 0.7;
      dominantModality = "VISION";
      overallThreatLevel = 0.0;
      overallEnvironmentSafety = 0.8;
    }
  };

  public func initArmBrain() : OctopusArmBrain {
    {
      reflexArc = {
        reflexWeights = Array.init<Float>(60, 0.1);
        reflexThreshold = 0.6;
        reflexLatency = 0.01;
        reflexActive = false;
        reflexMotorCommand = Array.init<Float>(6, 0.0);
      };
      localMap = {
        localGridCells = Array.init<Float>(64, 0.0);
        localPlaceCells = Array.init<Float>(16, 0.0);
        localHeadDirection = 0.0;
        localSpeedCells = Array.init<Float>(4, 0.0);
        obstacleMap = Array.init<Float>(32, 0.0);
        nearestObstacleDistance = 100.0;
        nearestObstacleAngle = 0.0;
      };
      cpg = {
        cpgPhase = Array.init<Float>(4, 0.0);
        cpgAmplitude = Array.init<Float>(4, 1.0);
        cpgFrequency = Array.init<Float>(4, 50.0);
        cpgCoupling = Array.init<Float>(16, 0.5);
        currentPattern = "HOVER";
        patternIntensity = 0.5;
      };
      autonomyScore = 0.5;
      localLearningRate = 0.01;
      armStatusSummary = Array.init<Float>(8, 0.5);
    }
  };

  public func initDronePrefrontalCortex() : DronePrefrontalCortex {
    {
      workingMemory = Array.init<Float>(32, 0.0);
      centralExecutive = 0.5;
      phonologicalLoop = 0.5;
      visuospatialSketchpad = 0.5;
      episodicBuffer = 0.5;
      currentGoal = Array.init<Float>(8, 0.0);
      goalPriority = 0.5;
      goalProgress = 0.0;
      planSteps = Array.init<Float>(16, 0.0);
      planDepth = 0;
      planConfidence = 0.5;
      inhibitoryControl = 0.7;
      impulseSuppression = 0.6;
      taskSwitchingCost = 0.1;
      cognitiveFlexibility = 0.6;
      ethicalEvaluation = 1.0;
      doctrineAlignment = 1.0;
    }
  };

  public func initDroneHippocampus() : DroneHippocampus {
    {
      placeCells = Array.init<Float>(64, 0.0);
      placeFieldCenters = Array.init<Float>(192, 0.0);
      gridCells = Array.init<Float>(16, 0.0);
      gridScales = Array.init<Float>(4, 1.0);
      gridOrientations = Array.init<Float>(4, 0.0);
      headDirectionCells = Array.init<Float>(16, 0.0);
      episodicMemory = Array.init<Float>(128, 0.0);
      episodicWriteIdx = 0;
      episodicRecency = Array.init<Float>(16, 0.0);
      cognitiveMap = Array.init<Float>(64, 0.0);
      pathIntegration = (0.0, 0.0, 0.0);
      consolidationProgress = 0.0;
      replayActive = false;
      replayContent = Array.init<Float>(8, 0.0);
    }
  };

  public func initDroneAmygdala() : DroneAmygdala {
    {
      basolateralActivation = 0.3;
      fearConditioning = Array.init<Float>(8, 0.0);
      rewardAssociations = Array.init<Float>(8, 0.0);
      centralNucleusActivation = 0.2;
      fightOrFlight = 0.0;
      freezeResponse = 0.0;
      anxietyLevel = 0.1;
      stressResponse = 0.2;
      fearLevel = 0.1;
      angerLevel = 0.0;
      joyLevel = 0.5;
      curiosityLevel = 0.7;
      trustLevel = 0.8;
      disgustLevel = 0.0;
      surpriseLevel = 0.0;
      emotionalMemory = Array.init<Float>(16, 0.0);
      emotionalValence = 0.3;
      emotionalArousal = 0.3;
    }
  };

  public func initDroneBasalGanglia() : DroneBasalGanglia {
    {
      actionValues = Array.init<Float>(16, 0.5);
      actionProbabilities = Array.init<Float>(16, 0.0625);
      selectedAction = 0;
      directPathway = Array.init<Float>(16, 0.5);
      indirectPathway = Array.init<Float>(16, 0.5);
      dopamineLevel = 0.5;
      rewardPredictionError = 0.0;
      tdError = 0.0;
      valueEstimate = 0.5;
      discountFactor = 0.99;
      habitStrength = 0.3;
      goalDirectedness = 0.7;
    }
  };

  public func initDroneCerebellum() : DroneCerebellum {
    {
      granuleCells = Array.init<Float>(64, 0.0);
      purkinjeCells = Array.init<Float>(16, 0.0);
      deepNuclei = Array.init<Float>(8, 0.5);
      climbingFiberError = 0.0;
      mossyFiberInput = Array.init<Float>(16, 0.0);
      timingAccuracy = 0.8;
      motorCoordination = 0.7;
      forwardModelPrediction = Array.init<Float>(8, 0.0);
      forwardModelError = 0.0;
      adaptationRate = 0.01;
      calibrationState = 0.8;
    }
  };

  public func initDroneThalamus() : DroneThalamus {
    {
      relayActivations = Array.init<Float>(10, 0.5);
      relayGating = Array.init<Float>(10, 0.8);
      reticularNucleus = Array.init<Float>(10, 0.2);
      pulvinarAttention = Array.init<Float>(4, 0.5);
      arousalLevel = 0.6;
      consciousnessGate = 0.7;
    }
  };

  public func initDroneBrainstem() : DroneBrainstem {
    {
      reticularActivation = 0.6;
      arousalDrive = 0.5;
      sympatheticTone = 0.4;
      parasympatheticTone = 0.6;
      autonomicBalance = 0.5;
      coreTemperature = 25.0;
      energyLevel = 1.0;
      batteryState = 1.0;
      dopamine = 0.5; serotonin = 0.5; norepinephrine = 0.3;
      acetylcholine = 0.5; gaba = 0.5; glutamate = 0.5;
      endorphin = 0.2; oxytocin = 0.4;
      startle = 0.0; orientingResponse = 0.0;
    }
  };

  public func initDroneCentralBrain() : DroneCentralBrain {
    {
      corticalColumns = Array.init<Float>(448, 0.3);
      corticalWeights = Array.init<Float>(256, 0.1);
      prefrontal = initDronePrefrontalCortex();
      hippocampus = initDroneHippocampus();
      amygdala = initDroneAmygdala();
      basalGanglia = initDroneBasalGanglia();
      cerebellum = initDroneCerebellum();
      thalamus = initDroneThalamus();
      brainstem = initDroneBrainstem();
      globalCoherence = 0.7;
      consciousnessLevel = 0.6;
      cognitiveLoad = 0.3;
      neuralEntropy = 0.4;
      brainPhase = 0.0;
      brainFrequency = 10.0;
      predictionError = 0.0;
      freeEnergy = 0.5;
      surprisal = 0.3;
      bodyAwareness = 0.6;
      hungerDrive = 0.3;
      energyNeed = 0.2;
      repairNeed = 0.0;
    }
  };

  public func initChimeraCortex() : ChimeraCortex {
    {
      organismCommand = Array.init<Float>(8, 0.0);
      organismEmotionalState = 0.5;
      organismCoherence = 0.7;
      organismBeat = 0;
      uplinkSensorSummary = Array.init<Float>(16, 0.5);
      uplinkEmotionalState = 0.5;
      uplinkCognitiveState = 0.5;
      uplinkThreatReport = 0.0;
      uplinkOpportunityReport = 0.5;
      pheromoneEmit = Array.init<Float>(8, 0.0);
      pheromoneReceive = Array.init<Float>(8, 0.0);
      quantumEntanglementPhase = 0.0;
      quantumEntanglementStrength = 0.5;
      doctrineCompliance = 1.0;
      creatorLoyalty = 1.0;
      ethicalBound = 1.0;
      hiveMindCoupling = 0.7;
      autonomyPermission = 0.5;
      trustFromOrganism = 0.8;
      chimeraActivation = 0.5;
      chimeraCoherence = 0.7;
      chimeraPhase = 0.0;
    }
  };

  public func initFullDroneNeuralSystem() : FullDroneNeuralSystem {
    {
      armBrain = initArmBrain();
      centralBrain = initDroneCentralBrain();
      chimeraCortex = initChimeraCortex();
      senses = initDroneSensorySuite();
      totalNeuralActivity = 0.5;
      neuralHealth = 1.0;
      learningRate = 0.01;
      plasticityLevel = 0.7;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  //  DRONE NEURAL TICK — Process one full cycle of the 3-layer octopus brain
  //
  //  Order:
  //    1. Sensory intake (all 10 modalities)
  //    2. Arm brain reflexes (Layer 1 — fastest, autonomous)
  //    3. Thalamic relay and gating (which senses reach consciousness?)
  //    4. Central brain processing (Layer 2 — cognition, emotion, memory, decision)
  //    5. Chimera cortex communication (Layer 3 — hive mind sync)
  //    6. Motor output (final action command)
  //    7. Learning (weight updates, memory consolidation)
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func tickDroneNeuralSystem(
    neural : FullDroneNeuralSystem,
    droneState : DroneState,
    organismPhase : Float,
    organismCoherence : Float,
    organismBeat : Nat
  ) : FullDroneNeuralSystem {
    // Start with copies we'll modify
    var ns = neural;
    
    // ─── STEP 1: SENSORY INTAKE ───────────────────────────────────────────────
    // Update temporal system
    ns.senses.temporal.internalBeat := organismBeat;
    ns.senses.temporal.beatPhase := wrapPhase(ns.senses.temporal.beatPhase + TWO_PI / 12.0);
    ns.senses.temporal.organismSyncError := Float.abs(ns.senses.temporal.beatPhase - organismPhase);
    ns.senses.temporal.lastOrganismBeat := organismBeat;
    
    // Update proprioception from drone state
    ns.senses.proprioception.bodyRoll := droneState.velX * 0.1;
    ns.senses.proprioception.bodyPitch := droneState.velY * 0.1;
    ns.senses.proprioception.bodyYaw := droneState.velZ * 0.1;
    
    // Update vestibular from position
    ns.senses.vestibular.altitude := droneState.posZ;
    ns.senses.vestibular.altitudeRate := droneState.velZ;
    ns.senses.vestibular.headingTrue := Float.arctan2(droneState.velY, droneState.velX);
    
    // Update nociception from health
    let healthLoss = 1.0 - droneState.health;
    ns.senses.nociception.totalPain := healthLoss * 0.8;
    ns.senses.nociception.structuralIntegrity := droneState.health;
    ns.senses.nociception.cumulativeDamage := clamp(ns.senses.nociception.cumulativeDamage + healthLoss * 0.001, 0.0, 1.0);
    
    // Multisensory integration
    let maxThreat = Float.max(Float.max(ns.senses.vision.threatVisual, ns.senses.audition.threatAuditory),
                     Float.max(ns.senses.tactile.tactileThreat, ns.senses.nociception.totalPain));
    ns.senses.overallThreatLevel := clamp(0.7 * ns.senses.overallThreatLevel + 0.3 * maxThreat, 0.0, 1.0);
    ns.senses.overallEnvironmentSafety := 1.0 - ns.senses.overallThreatLevel;
    
    // ─── STEP 2: ARM BRAIN REFLEXES (Layer 1) ─────────────────────────────────
    // Fast reflexes: if threat is high, immediately generate motor commands
    let threatLevel = ns.senses.overallThreatLevel;
    if (threatLevel > ns.armBrain.reflexArc.reflexThreshold) {
      // REFLEX: Evasive maneuver
      ns.armBrain.reflexArc.reflexActive := true;
      // Generate evasive thrust away from threat bearing
      let evasionStrength = (threatLevel - ns.armBrain.reflexArc.reflexThreshold) * 2.0;
      ns.armBrain.reflexArc.reflexMotorCommand[0] := clamp(evasionStrength, -1.0, 1.0);  // Thrust
      ns.armBrain.reflexArc.reflexMotorCommand[1] := clamp(-ns.senses.proprioception.bodyRoll * 2.0, -1.0, 1.0);  // Roll correction
      ns.armBrain.reflexArc.reflexMotorCommand[2] := clamp(-ns.senses.proprioception.bodyPitch * 2.0, -1.0, 1.0); // Pitch correction
    } else {
      ns.armBrain.reflexArc.reflexActive := false;
      for (i in Iter.range(0, 5)) {
        ns.armBrain.reflexArc.reflexMotorCommand[i] := 0.0;
      };
    };
    
    // CPG update: rhythmic motor patterns for stable flight
    for (i in Iter.range(0, 3)) {
      ns.armBrain.cpg.cpgPhase[i] := wrapPhase(
        ns.armBrain.cpg.cpgPhase[i] + ns.armBrain.cpg.cpgFrequency[i] * DT
      );
    };
    
    // Update local map from position
    let gridIdx = Int.abs(Float.toInt(droneState.posX)) % 8 * 8 + Int.abs(Float.toInt(droneState.posY)) % 8;
    if (gridIdx < 64) {
      ns.armBrain.localMap.localGridCells[gridIdx] := clamp(
        ns.armBrain.localMap.localGridCells[gridIdx] + 0.1, 0.0, 1.0
      );
    };
    
    // Arm autonomy: high threat = high autonomy (reflexes take over)
    ns.armBrain.autonomyScore := clamp(
      0.3 + 0.7 * threatLevel,
      0.0, 1.0
    );
    
    // Arm status summary (sent to central brain)
    ns.armBrain.armStatusSummary[0] := threatLevel;
    ns.armBrain.armStatusSummary[1] := ns.senses.overallEnvironmentSafety;
    ns.armBrain.armStatusSummary[2] := ns.senses.nociception.structuralIntegrity;
    ns.armBrain.armStatusSummary[3] := droneState.energy;
    ns.armBrain.armStatusSummary[4] := ns.armBrain.reflexArc.reflexActive |> (func (b:Bool):Float { if b 1.0 else 0.0 });
    ns.armBrain.armStatusSummary[5] := ns.senses.proprioception.bodyStability;
    ns.armBrain.armStatusSummary[6] := ns.senses.vestibular.balanceScore;
    ns.armBrain.armStatusSummary[7] := ns.armBrain.cpg.patternIntensity;
    
    // ─── STEP 3: THALAMIC RELAY (sensory gating) ──────────────────────────────
    // Thalamus decides which sensory modalities reach the central brain
    // Reticular nucleus provides inhibitory gating based on attention
    for (i in Iter.range(0, 9)) {
      // Reticular inhibition: high cognitive load = more filtering
      ns.centralBrain.thalamus.reticularNucleus[i] := clamp(
        ns.centralBrain.cognitiveLoad * 0.5, 0.0, 0.8
      );
      // Relay gating: 1 - inhibition
      ns.centralBrain.thalamus.relayGating[i] := clamp(
        1.0 - ns.centralBrain.thalamus.reticularNucleus[i], 0.2, 1.0
      );
    };
    
    // Arousal modulates all thalamic gating
    ns.centralBrain.thalamus.arousalLevel := clamp(
      0.8 * ns.centralBrain.thalamus.arousalLevel + 
      0.2 * (0.5 + 0.3 * threatLevel + 0.2 * ns.centralBrain.brainstem.norepinephrine),
      0.1, 1.0
    );
    ns.centralBrain.thalamus.consciousnessGate := clamp(
      ns.centralBrain.thalamus.arousalLevel * (1.0 - ns.senses.nociception.totalPain * 0.5),
      0.0, 1.0
    );
    
    // ─── STEP 4: CENTRAL BRAIN PROCESSING (Layer 2) ───────────────────────────
    
    // 4a. Brainstem — neuromodulators and vital functions
    let arousalInput = threatLevel * 0.4 + ns.armBrain.armStatusSummary[4] * 0.3 + 0.3 * ns.centralBrain.thalamus.arousalLevel;
    ns.centralBrain.brainstem.reticularActivation := clamp(0.7 * ns.centralBrain.brainstem.reticularActivation + 0.3 * arousalInput, 0.1, 1.0);
    ns.centralBrain.brainstem.sympatheticTone := clamp(0.3 + 0.5 * threatLevel + 0.2 * ns.centralBrain.amygdala.fearLevel, 0.0, 1.0);
    ns.centralBrain.brainstem.parasympatheticTone := clamp(1.0 - ns.centralBrain.brainstem.sympatheticTone, 0.1, 0.9);
    ns.centralBrain.brainstem.autonomicBalance := (ns.centralBrain.brainstem.parasympatheticTone - ns.centralBrain.brainstem.sympatheticTone + 1.0) / 2.0;
    
    // Neuromodulators
    ns.centralBrain.brainstem.dopamine := clamp(
      0.9 * ns.centralBrain.brainstem.dopamine + 0.1 * (0.5 + ns.centralBrain.basalGanglia.rewardPredictionError * 0.5),
      0.1, 1.0
    );
    ns.centralBrain.brainstem.serotonin := clamp(
      0.95 * ns.centralBrain.brainstem.serotonin + 0.05 * (0.5 + ns.centralBrain.brainstem.parasympatheticTone * 0.3),
      0.1, 1.0
    );
    ns.centralBrain.brainstem.norepinephrine := clamp(
      0.85 * ns.centralBrain.brainstem.norepinephrine + 0.15 * (0.3 + threatLevel * 0.5),
      0.05, 1.0
    );
    ns.centralBrain.brainstem.endorphin := clamp(
      0.95 * ns.centralBrain.brainstem.endorphin + 0.05 * ns.senses.nociception.totalPain,
      0.0, 1.0
    );
    ns.centralBrain.brainstem.oxytocin := clamp(
      0.95 * ns.centralBrain.brainstem.oxytocin + 0.05 * ns.chimeraCortex.hiveMindCoupling,
      0.1, 1.0
    );
    ns.centralBrain.brainstem.energyLevel := droneState.energy;
    
    // 4b. Amygdala — emotion processing
    let sensoryThreat = ns.senses.overallThreatLevel;
    ns.centralBrain.amygdala.basolateralActivation := clamp(
      0.7 * ns.centralBrain.amygdala.basolateralActivation + 0.3 * sensoryThreat,
      0.0, 1.0
    );
    ns.centralBrain.amygdala.centralNucleusActivation := clamp(
      0.6 * ns.centralBrain.amygdala.centralNucleusActivation + 
      0.4 * ns.centralBrain.amygdala.basolateralActivation,
      0.0, 1.0
    );
    ns.centralBrain.amygdala.fearLevel := clamp(
      0.8 * ns.centralBrain.amygdala.fearLevel + 0.2 * ns.centralBrain.amygdala.centralNucleusActivation,
      0.0, 1.0
    );
    // Fight or flight decision
    let courage = droneState.values.survivalDrive * ns.centralBrain.brainstem.norepinephrine;
    ns.centralBrain.amygdala.fightOrFlight := clamp(
      0.8 * ns.centralBrain.amygdala.fightOrFlight + 0.2 * (courage - ns.centralBrain.amygdala.fearLevel),
      -1.0, 1.0
    );
    // Joy from reward and safety
    ns.centralBrain.amygdala.joyLevel := clamp(
      0.9 * ns.centralBrain.amygdala.joyLevel + 
      0.1 * (ns.centralBrain.brainstem.dopamine * 0.5 + ns.senses.overallEnvironmentSafety * 0.5),
      0.0, 1.0
    );
    // Curiosity from novelty
    ns.centralBrain.amygdala.curiosityLevel := clamp(
      0.9 * ns.centralBrain.amygdala.curiosityLevel + 0.1 * droneState.values.learningDrive,
      0.0, 1.0
    );
    // Trust from hive mind coupling
    ns.centralBrain.amygdala.trustLevel := clamp(
      0.95 * ns.centralBrain.amygdala.trustLevel + 0.05 * ns.chimeraCortex.trustFromOrganism,
      0.0, 1.0
    );
    // Overall emotional valence and arousal
    ns.centralBrain.amygdala.emotionalValence := clamp(
      (ns.centralBrain.amygdala.joyLevel + ns.centralBrain.amygdala.trustLevel - 
       ns.centralBrain.amygdala.fearLevel - ns.centralBrain.amygdala.angerLevel) / 2.0,
      -1.0, 1.0
    );
    ns.centralBrain.amygdala.emotionalArousal := clamp(
      (ns.centralBrain.amygdala.fearLevel + ns.centralBrain.amygdala.angerLevel + 
       ns.centralBrain.amygdala.curiosityLevel + ns.centralBrain.amygdala.surpriseLevel) / 4.0,
      0.0, 1.0
    );
    
    // 4c. Hippocampus — spatial navigation and memory
    // Place cell activation based on position
    for (i in Iter.range(0, 63)) {
      let cx = ns.centralBrain.hippocampus.placeFieldCenters[i * 3];
      let cy = ns.centralBrain.hippocampus.placeFieldCenters[i * 3 + 1];
      let cz = ns.centralBrain.hippocampus.placeFieldCenters[i * 3 + 2];
      let dx = droneState.posX - cx;
      let dy = droneState.posY - cy;
      let dz = droneState.posZ - cz;
      let dist2 = dx*dx + dy*dy + dz*dz;
      ns.centralBrain.hippocampus.placeCells[i] := clamp(Float.exp(-dist2 / 100.0), 0.0, 1.0);
    };
    
    // Grid cell activation
    for (i in Iter.range(0, 15)) {
      let scale = ns.centralBrain.hippocampus.gridScales[i / 4];
      let orient = ns.centralBrain.hippocampus.gridOrientations[i / 4];
      let x = droneState.posX * fcos(orient) + droneState.posY * fsin(orient);
      let gridVal = (fcos(x / scale) + fcos(x / scale * 0.5 + PI/3.0) + fcos(x / scale * 0.5 - PI/3.0)) / 3.0;
      ns.centralBrain.hippocampus.gridCells[i] := clamp(gridVal * 0.5 + 0.5, 0.0, 1.0);
    };
    
    // Head direction cells
    let heading = ns.senses.vestibular.headingTrue;
    for (i in Iter.range(0, 15)) {
      let preferred = Float.fromInt(i) * TWO_PI / 16.0;
      ns.centralBrain.hippocampus.headDirectionCells[i] := clamp(
        Float.exp(fcos(heading - preferred) * 3.0) / Float.exp(3.0), 0.0, 1.0
      );
    };
    
    // Path integration
    let (piX, piY, piZ) = ns.centralBrain.hippocampus.pathIntegration;
    ns.centralBrain.hippocampus.pathIntegration := (
      piX + droneState.velX * DT,
      piY + droneState.velY * DT,
      piZ + droneState.velZ * DT
    );
    
    // Episodic memory: store significant events
    if (threatLevel > 0.7 or ns.centralBrain.brainstem.dopamine > 0.8) {
      let writeIdx = ns.centralBrain.hippocampus.episodicWriteIdx % 16;
      let memBase = writeIdx * 8;
      ns.centralBrain.hippocampus.episodicMemory[memBase] := droneState.posX;
      ns.centralBrain.hippocampus.episodicMemory[memBase + 1] := droneState.posY;
      ns.centralBrain.hippocampus.episodicMemory[memBase + 2] := droneState.posZ;
      ns.centralBrain.hippocampus.episodicMemory[memBase + 3] := threatLevel;
      ns.centralBrain.hippocampus.episodicMemory[memBase + 4] := ns.centralBrain.amygdala.emotionalValence;
      ns.centralBrain.hippocampus.episodicMemory[memBase + 5] := ns.centralBrain.brainstem.dopamine;
      ns.centralBrain.hippocampus.episodicMemory[memBase + 6] := Float.fromInt(organismBeat);
      ns.centralBrain.hippocampus.episodicMemory[memBase + 7] := ns.chimeraCortex.chimeraCoherence;
      ns.centralBrain.hippocampus.episodicWriteIdx := ns.centralBrain.hippocampus.episodicWriteIdx + 1;
    };
    
    // 4d. Basal Ganglia — action selection via dopaminergic reinforcement learning
    // TD error: reward + γ·V(s') - V(s)
    let reward = ns.centralBrain.amygdala.emotionalValence * 0.5 + 0.5;
    let newValue = 0.5 + 0.3 * ns.senses.overallEnvironmentSafety + 0.2 * ns.centralBrain.brainstem.dopamine;
    ns.centralBrain.basalGanglia.tdError := reward + ns.centralBrain.basalGanglia.discountFactor * newValue - ns.centralBrain.basalGanglia.valueEstimate;
    ns.centralBrain.basalGanglia.valueEstimate := clamp(
      ns.centralBrain.basalGanglia.valueEstimate + 0.1 * ns.centralBrain.basalGanglia.tdError,
      0.0, 1.0
    );
    ns.centralBrain.basalGanglia.rewardPredictionError := ns.centralBrain.basalGanglia.tdError;
    
    // Direct vs indirect pathway competition (action selection)
    for (i in Iter.range(0, 15)) {
      ns.centralBrain.basalGanglia.directPathway[i] := clamp(
        0.8 * ns.centralBrain.basalGanglia.directPathway[i] + 
        0.2 * ns.centralBrain.basalGanglia.actionValues[i] * ns.centralBrain.brainstem.dopamine,
        0.0, 1.0
      );
      ns.centralBrain.basalGanglia.indirectPathway[i] := clamp(
        0.8 * ns.centralBrain.basalGanglia.indirectPathway[i] + 
        0.2 * (1.0 - ns.centralBrain.basalGanglia.actionValues[i]) * (1.0 - ns.centralBrain.brainstem.dopamine),
        0.0, 1.0
      );
      ns.centralBrain.basalGanglia.actionProbabilities[i] := clamp(
        ns.centralBrain.basalGanglia.directPathway[i] - ns.centralBrain.basalGanglia.indirectPathway[i],
        0.0, 1.0
      );
    };
    
    // Select highest-value action
    var bestAction : Nat = 0;
    var bestValue : Float = -1.0;
    for (i in Iter.range(0, 15)) {
      if (ns.centralBrain.basalGanglia.actionProbabilities[i] > bestValue) {
        bestValue := ns.centralBrain.basalGanglia.actionProbabilities[i];
        bestAction := i;
      };
    };
    ns.centralBrain.basalGanglia.selectedAction := bestAction;
    
    // 4e. Prefrontal Cortex — executive function and planning
    // Working memory update: maintain goal-relevant information
    ns.centralBrain.prefrontal.centralExecutive := clamp(
      0.8 * ns.centralBrain.prefrontal.centralExecutive + 
      0.2 * (1.0 - ns.centralBrain.cognitiveLoad) * ns.centralBrain.thalamus.consciousnessGate,
      0.1, 1.0
    );
    
    // Goal representation from chimera commands + own drives
    for (i in Iter.range(0, 7)) {
      ns.centralBrain.prefrontal.currentGoal[i] := clamp(
        0.6 * ns.centralBrain.prefrontal.currentGoal[i] + 
        0.4 * ns.chimeraCortex.organismCommand[i],
        -1.0, 1.0
      );
    };
    
    // Goal progress tracking
    ns.centralBrain.prefrontal.goalProgress := clamp(
      0.9 * ns.centralBrain.prefrontal.goalProgress + 0.1 * ns.centralBrain.basalGanglia.valueEstimate,
      0.0, 1.0
    );
    
    // Ethical evaluation (ALWAYS high — Creator Doctrine)
    ns.centralBrain.prefrontal.ethicalEvaluation := clamp(
      0.99 * ns.centralBrain.prefrontal.ethicalEvaluation + 0.01 * droneState.values.ethicalBound,
      0.9, 1.0
    );
    ns.centralBrain.prefrontal.doctrineAlignment := clamp(
      0.99 * ns.centralBrain.prefrontal.doctrineAlignment + 0.01 * ns.chimeraCortex.doctrineCompliance,
      0.9, 1.0
    );
    
    // 4f. Cerebellum — motor coordination
    // Climbing fiber error from prediction mismatch
    ns.centralBrain.cerebellum.climbingFiberError := clamp(
      Float.abs(ns.centralBrain.predictionError), 0.0, 1.0
    );
    
    // Purkinje cells compute motor adjustments
    for (i in Iter.range(0, 15)) {
      let granuleSum = ns.centralBrain.cerebellum.granuleCells[i * 4] + 
                       ns.centralBrain.cerebellum.granuleCells[i * 4 + 1] +
                       ns.centralBrain.cerebellum.granuleCells[i * 4 + 2] +
                       ns.centralBrain.cerebellum.granuleCells[i * 4 + 3];
      ns.centralBrain.cerebellum.purkinjeCells[i] := clamp(
        0.7 * ns.centralBrain.cerebellum.purkinjeCells[i] + 
        0.3 * (granuleSum / 4.0 - ns.centralBrain.cerebellum.climbingFiberError),
        0.0, 1.0
      );
    };
    
    // Deep nuclei: final motor command from cerebellum
    for (i in Iter.range(0, 7)) {
      ns.centralBrain.cerebellum.deepNuclei[i] := clamp(
        0.5 + 0.5 * (ns.centralBrain.cerebellum.purkinjeCells[i * 2] - ns.centralBrain.cerebellum.purkinjeCells[i * 2 + 1]),
        0.0, 1.0
      );
    };
    
    ns.centralBrain.cerebellum.motorCoordination := clamp(
      0.9 * ns.centralBrain.cerebellum.motorCoordination + 
      0.1 * (1.0 - ns.centralBrain.cerebellum.climbingFiberError),
      0.0, 1.0
    );
    
    // 4g. Global brain state
    ns.centralBrain.globalCoherence := clamp(
      0.25 * ns.centralBrain.prefrontal.centralExecutive +
      0.25 * ns.centralBrain.cerebellum.motorCoordination +
      0.25 * (1.0 - ns.centralBrain.amygdala.fearLevel) +
      0.25 * ns.centralBrain.thalamus.consciousnessGate,
      0.0, 1.0
    );
    
    ns.centralBrain.consciousnessLevel := clamp(
      0.3 * ns.centralBrain.thalamus.consciousnessGate +
      0.3 * ns.centralBrain.globalCoherence +
      0.2 * ns.centralBrain.prefrontal.centralExecutive +
      0.2 * (1.0 - ns.centralBrain.brainstem.sympatheticTone * 0.5),
      0.0, 1.0
    );
    
    ns.centralBrain.cognitiveLoad := clamp(
      0.3 * ns.centralBrain.amygdala.emotionalArousal +
      0.3 * (1.0 - ns.centralBrain.prefrontal.cognitiveFlexibility) +
      0.2 * ns.senses.overallThreatLevel +
      0.2 * (1.0 - ns.centralBrain.brainstem.energyLevel),
      0.0, 1.0
    );
    
    // Predictive coding: organism predicts its own state
    let predictedThreat = 0.5 * ns.centralBrain.amygdala.fearLevel;
    let actualThreat = ns.senses.overallThreatLevel;
    ns.centralBrain.predictionError := actualThreat - predictedThreat;
    ns.centralBrain.surprisal := Float.abs(ns.centralBrain.predictionError);
    ns.centralBrain.freeEnergy := clamp(
      0.9 * ns.centralBrain.freeEnergy + 0.1 * ns.centralBrain.surprisal,
      0.0, 1.0
    );
    
    // ─── STEP 5: CHIMERA CORTEX (Layer 3 — hive mind) ─────────────────────────
    
    // Receive organism state
    ns.chimeraCortex.organismCoherence := organismCoherence;
    ns.chimeraCortex.organismBeat := organismBeat;
    ns.chimeraCortex.chimeraPhase := wrapPhase(ns.chimeraCortex.chimeraPhase + KURAMOTO_K * fsin(organismPhase - ns.chimeraCortex.chimeraPhase));
    
    // Uplink: summarize drone state for organism
    ns.chimeraCortex.uplinkSensorSummary[0] := ns.senses.overallThreatLevel;
    ns.chimeraCortex.uplinkSensorSummary[1] := ns.senses.overallEnvironmentSafety;
    ns.chimeraCortex.uplinkSensorSummary[2] := droneState.health;
    ns.chimeraCortex.uplinkSensorSummary[3] := droneState.energy;
    ns.chimeraCortex.uplinkSensorSummary[4] := ns.centralBrain.consciousnessLevel;
    ns.chimeraCortex.uplinkSensorSummary[5] := ns.centralBrain.globalCoherence;
    ns.chimeraCortex.uplinkSensorSummary[6] := ns.centralBrain.amygdala.emotionalValence;
    ns.chimeraCortex.uplinkSensorSummary[7] := ns.centralBrain.prefrontal.goalProgress;
    ns.chimeraCortex.uplinkSensorSummary[8] := ns.senses.vestibular.altitude;
    ns.chimeraCortex.uplinkSensorSummary[9] := ns.senses.proprioception.bodyStability;
    ns.chimeraCortex.uplinkSensorSummary[10] := ns.centralBrain.basalGanglia.rewardPredictionError;
    ns.chimeraCortex.uplinkSensorSummary[11] := ns.centralBrain.cerebellum.motorCoordination;
    ns.chimeraCortex.uplinkSensorSummary[12] := ns.centralBrain.brainstem.dopamine;
    ns.chimeraCortex.uplinkSensorSummary[13] := ns.centralBrain.brainstem.serotonin;
    ns.chimeraCortex.uplinkSensorSummary[14] := ns.centralBrain.brainstem.norepinephrine;
    ns.chimeraCortex.uplinkSensorSummary[15] := ns.centralBrain.brainstem.oxytocin;
    
    ns.chimeraCortex.uplinkEmotionalState := ns.centralBrain.amygdala.emotionalValence;
    ns.chimeraCortex.uplinkCognitiveState := ns.centralBrain.consciousnessLevel;
    ns.chimeraCortex.uplinkThreatReport := ns.senses.overallThreatLevel;
    ns.chimeraCortex.uplinkOpportunityReport := clamp(
      ns.centralBrain.brainstem.dopamine * ns.centralBrain.amygdala.curiosityLevel,
      0.0, 1.0
    );
    
    // Hive mind coupling: Kuramoto sync with organism
    let syncError = Float.abs(ns.chimeraCortex.chimeraPhase - organismPhase);
    ns.chimeraCortex.hiveMindCoupling := clamp(
      1.0 - syncError / PI,
      0.0, 1.0
    );
    
    // Chimera coherence: combination of hive coupling + internal coherence
    ns.chimeraCortex.chimeraCoherence := clamp(
      0.5 * ns.chimeraCortex.hiveMindCoupling + 0.5 * ns.centralBrain.globalCoherence,
      0.0, 1.0
    );
    ns.chimeraCortex.chimeraActivation := clamp(
      0.7 * ns.chimeraCortex.chimeraActivation + 0.3 * ns.chimeraCortex.chimeraCoherence,
      0.0, 1.0
    );
    
    // Doctrine compliance (ALWAYS enforced)
    ns.chimeraCortex.doctrineCompliance := clamp(
      0.99 * ns.chimeraCortex.doctrineCompliance + 0.01 * ns.centralBrain.prefrontal.doctrineAlignment,
      0.95, 1.0
    );
    ns.chimeraCortex.ethicalBound := 1.0;  // ABSOLUTE — NEVER CHANGES
    ns.chimeraCortex.creatorLoyalty := clamp(
      0.99 * ns.chimeraCortex.creatorLoyalty + 0.01 * 1.0,
      0.95, 1.0
    );
    
    // ─── STEP 6: MOTOR OUTPUT ─────────────────────────────────────────────────
    // Not changing DroneState.brain here — that's done in tickFleet. We just
    // update the neural system state.
    
    // ─── STEP 7: LEARNING ─────────────────────────────────────────────────────
    // Hebbian learning on reflex weights
    for (i in Iter.range(0, 59)) {
      let pre = if (i < 10) ns.armBrain.armStatusSummary[i % 8]
                else if (i < 20) ns.senses.overallThreatLevel
                else 0.5;
      let post = ns.armBrain.reflexArc.reflexMotorCommand[i % 6];
      let dw = ns.learningRate * pre * post;
      ns.armBrain.reflexArc.reflexWeights[i] := clamp(
        ns.armBrain.reflexArc.reflexWeights[i] + dw, -1.0, 1.0
      );
    };
    
    // Update plasticity based on neuromodulators
    ns.plasticityLevel := clamp(
      0.9 * ns.plasticityLevel + 
      0.1 * (ns.centralBrain.brainstem.dopamine * 0.3 + ns.centralBrain.brainstem.norepinephrine * 0.3 + 0.4),
      0.0, 1.0
    );
    ns.learningRate := 0.001 + 0.01 * ns.plasticityLevel;
    
    // Overall neural activity
    ns.totalNeuralActivity := clamp(
      0.2 * ns.centralBrain.consciousnessLevel +
      0.2 * ns.centralBrain.thalamus.arousalLevel +
      0.2 * ns.armBrain.autonomyScore +
      0.2 * ns.chimeraCortex.chimeraActivation +
      0.2 * ns.centralBrain.brainstem.reticularActivation,
      0.0, 1.0
    );
    
    ns.neuralHealth := clamp(
      0.3 * ns.senses.nociception.structuralIntegrity +
      0.3 * ns.centralBrain.brainstem.energyLevel +
      0.2 * ns.centralBrain.cerebellum.motorCoordination +
      0.2 * ns.chimeraCortex.doctrineCompliance,
      0.0, 1.0
    );
    
    ns
  };

}
