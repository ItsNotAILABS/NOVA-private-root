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
  // CONSTANTS — SCALE-INVARIANT ARCHITECTURE
  // ═══════════════════════════════════════════════════════════════════════════
  // The organism is PURE MATH. The Kuramoto coupling equation:
  //   dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  // works for N = 50 or N = 50,000. The math doesn't care about limits.
  //
  // With MEAN-FIELD APPROXIMATION, we replace the O(N²) pairwise coupling with:
  //   dθᵢ/dt = ωᵢ + K·r·sin(ψ - θᵢ)
  // where r·e^(iψ) = (1/N)Σⱼ e^(iθⱼ) is the order parameter.
  // This is O(N) — scales to ANY fleet size.
  //
  // SPHERICAL ORGANIZATION: Drones are points on an expanding sphere.
  // More drones = larger sphere, same coupling strength per unit solid angle.
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let MAX_DRONES : Nat = 65536;      // 2^16 — can handle 65K drones
  public let MIN_DRONES : Nat = 1;          // Even 1 drone is valid
  public let DEFAULT_FLEET_SIZE : Nat = 64; // Starting point, but not a limit
  
  // Kuramoto synchronization — SCALE-INVARIANT
  public let KURAMOTO_K : Float = 0.618;        // Coupling strength (golden ratio)
  public let NATURAL_FREQ_BASE : Float = 0.1;   // Base natural frequency
  public let NATURAL_FREQ_SPREAD : Float = 0.05; // Frequency variation
  
  // Value propagation
  public let VALUE_INHERITANCE_RATE : Float = 0.95;
  public let ETHICAL_BOUND_ABSOLUTE : Float = 1.0;
  
  // Formation parameters
  public let FORMATION_SPACING : Float = 10.0;  // meters
  public let SPHERE_RADIUS_BASE : Float = 50.0;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SQUADRON ORGANIZATION — 250 Drones in 3 Squadrons
  // ═══════════════════════════════════════════════════════════════════════════
  // Each squadron has ~83 drones + 1 Sovereign commander
  // Squadrons are semi-autonomous: internal Kuramoto coupling + 
  // inter-squadron coupling through Sovereign command link
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let DEFAULT_FLEET_SIZE_250 : Nat = 250;
  public let SQUADRON_COUNT : Nat = 3;
  public let DRONES_PER_SQUADRON : Nat = 83;  // 250 / 3 ≈ 83
  
  // Squadron names
  public let SQUADRON_ALPHA : Nat = 0;
  public let SQUADRON_BETA : Nat = 1;
  public let SQUADRON_GAMMA : Nat = 2;
  
  // Physics
  public let PI : Float = 3.14159265358979;
  public let TWO_PI : Float = 6.28318530717958;
  public let DT : Float = 0.0833;  // 1/12 Hz = 83.3ms
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — DRONE STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type DroneClass = {
    #Scout;       // Fast, low payload, high sensors
    #Striker;     // Attack-focused, medium speed
    #Guardian;    // Defensive, high durability
    #Relay;       // Communication hub
    #Medic;       // Repair/support
    #Sovereign;   // Command drone (1 per swarm)
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
  
  func initDrone(id: Nat, totalDrones: Nat) : DroneState {
    // ═══════════════════════════════════════════════════════════════════════════
    // SQUADRON ASSIGNMENT — Distribute drones across 3 squadrons
    // Squadron 0 (Alpha): drones 0-82 + Sovereign at 0
    // Squadron 1 (Beta):  drones 83-165 + Sovereign at 83
    // Squadron 2 (Gamma): drones 166-249 + Sovereign at 166
    // ═══════════════════════════════════════════════════════════════════════════
    
    let dronesPerSquad = totalDrones / 3;
    let squadron = id / dronesPerSquad;
    let squadronIdx = if (squadron > 2) 2 else squadron;  // Cap at 2
    
    // First drone of each squadron is the Sovereign commander
    let isCommander = (id == squadronIdx * dronesPerSquad);
    
    // Assign class: commanders are Sovereign, others distributed
    let droneClass : DroneClass = if (isCommander) {
      #Sovereign
    } else {
      switch ((id - 1) % 5) {  // Distribute non-commanders across other classes
        case 0 #Scout;
        case 1 #Striker;
        case 2 #Guardian;
        case 3 #Relay;
        case _ #Medic;
      }
    };
    
    // Initial position: squadrons form separate spheres
    // Alpha at (-100, 50, 0), Beta at (0, 50, 0), Gamma at (100, 50, 0)
    let squadronOffset = Float.fromInt(squadronIdx) * 100.0 - 100.0;
    let localId = id - squadronIdx * dronesPerSquad;
    let angle1 = Float.fromInt(localId) * 2.4; // Golden angle
    let angle2 = Float.fromInt(localId) * 0.5;
    let radius = 15.0 + Float.fromInt(localId % 10) * 3.0;
    
    {
      id = id;
      droneClass = droneClass;
      brain = initBrain(id);
      values = initValues();
      squadron = squadronIdx;
      isSquadronCommander = isCommander;
      posX = squadronOffset + radius * fcos(angle1) * fcos(angle2);
      posY = 50.0 + radius * fsin(angle2);  // Base altitude 50m
      posZ = radius * fsin(angle1) * fcos(angle2);
      velX = 0.0;
      velY = 0.0;
      velZ = 0.0;
      energy = 1.0;
      health = if (isCommander) 1.5 else 1.0;  // Sovereigns are tougher
      active = true;
      sacrificed = false;
      organismPhase = 0.0;
      syncStrength = if (isCommander) KURAMOTO_K * 1.5 else KURAMOTO_K;  // Commanders sync stronger
      syncDrift = 0.0;
      valueAlignment = 1.0;
      currentTask = null;
      targetX = squadronOffset;
      targetY = 50.0;
      targetZ = 0.0;
      lastBeat = 0;
    }
  };
  
  public func initFleet(droneCount: Nat) : FleetState {
    // ═══════════════════════════════════════════════════════════════════════════
    // 250 DRONE FLEET — 3 SQUADRONS (Alpha, Beta, Gamma)
    // Each squadron has ~83 drones + 1 Sovereign commander
    // ═══════════════════════════════════════════════════════════════════════════
    
    let count = if (droneCount > MAX_DRONES) MAX_DRONES 
                else if (droneCount < MIN_DRONES) MIN_DRONES 
                else droneCount;
    
    let drones = Array.init<DroneState>(count, initDrone(0, count));
    for (i in Iter.range(0, count - 1)) {
      drones[i] := initDrone(i, count);
    };
    
    // Calculate squadron commanders (first drone of each squadron)
    let dronesPerSquad = count / 3;
    let commanders : [Nat] = [0, dronesPerSquad, dronesPerSquad * 2];
    
    // Initialize squadron centers
    let squadCentersX : [Float] = [-100.0, 0.0, 100.0];  // Alpha left, Beta center, Gamma right
    let squadCentersY : [Float] = [50.0, 50.0, 50.0];
    let squadCentersZ : [Float] = [0.0, 0.0, 0.0];
    
    {
      drones = drones;
      droneCount = count;
      formation = #Sphere;
      rSwarm = 0.88;
      meanPhase = 0.0;
      jasmineScore = 0.75;
      swarmCoherence = 0.85;
      centerX = 0.0;
      centerY = 50.0;
      centerZ = 0.0;
      
      // Squadron state
      squadronRSwarm = [0.85, 0.85, 0.85];
      squadronMeanPhase = [0.0, 2.094, 4.189];  // Spread by 120° (2π/3)
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
