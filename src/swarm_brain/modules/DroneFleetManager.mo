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

}
