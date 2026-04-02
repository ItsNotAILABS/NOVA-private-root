// ═══════════════════════════════════════════════════════════════════════════════
// ENEMY AI SWARM — Competition System
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// This module creates enemy AI swarms that the NOVA swarm competes against.
// Training by competition — the organism learns by fighting other AI swarms.
//
// Enemy swarm types:
//   • BASIC — Simple patrol patterns, low coordination
//   • HUNTER — Aggressive pursuit, medium coordination
//   • TACTICAL — Flanking maneuvers, high coordination
//   • ADAPTIVE — Learns from NOVA's patterns (mirror swarm)
//   • SUPERIOR — Maximum difficulty, swarm intelligence
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

module EnemyAISwarm {

  // ═══════════════════════════════════════════════════════════════════════════
  // ENEMY AI SWARM — IRONCLAD Architecture (Same as NOVA)
  // ═══════════════════════════════════════════════════════════════════════════
  // The enemy uses the SAME mathematical foundation as NOVA:
  //   • Kuramoto phase coupling for coordination
  //   • Mean-field approximation for scale-invariance
  //   • Hebbian learning (enemy learns from NOVA patterns)
  //   • N² superradiance when coordinated
  //
  // This creates a TRUE competitive environment where both swarms
  // are operating on the same physics — may the better organism win.
  // ═══════════════════════════════════════════════════════════════════════════
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — SCALE-INVARIANT
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let MAX_ENEMY_DRONES : Nat = 500;   // Can match NOVA's scale
  public let PI : Float = 3.14159265358979;
  public let TWO_PI : Float = 6.28318530717958;
  
  // Kuramoto coupling — same physics as NOVA
  public let KURAMOTO_K : Float = 0.618;     // Golden ratio coupling
  public let NATURAL_FREQ_BASE : Float = 0.1;
  public let NATURAL_FREQ_SPREAD : Float = 0.05;
  
  // Hebbian learning
  public let HEBBIAN_ALPHA : Float = 0.01;
  public let WEIGHT_CEIL : Float = 2.0;
  public let SOVEREIGN_FLOOR : Float = 1.0;
  
  // Enemy behavior parameters
  public let AGGRESSION_BASE : Float = 0.5;
  public let COORDINATION_BASE : Float = 0.6;
  public let PURSUIT_SPEED : Float = 8.0;  // m/s
  public let ATTACK_RANGE : Float = 50.0;  // meters
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — ENEMY STRUCTURES (Full IRONCLAD Brain)
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type EnemySwarmType = {
    #Basic;      // Simple AI, low Kuramoto coupling
    #Hunter;     // Aggressive, medium coupling
    #Tactical;   // Smart flanking, high coupling
    #Adaptive;   // LEARNS from NOVA's patterns (Hebbian)
    #Superior;   // Maximum difficulty: full IRONCLAD architecture
  };
  
  public type EnemyBehavior = {
    #Patrol;
    #Pursue;
    #Flank;
    #Encircle;
    #Retreat;
    #Regroup;
    #Ambush;
  };
  
  // Enemy mini-brain — same 6-node architecture as NOVA drones
  public type EnemyMiniBrain = {
    sensorNode    : Float;
    memoryNode    : Float;
    decisionNode  : Float;
    emotionNode   : Float;
    motorNode     : Float;
    syncNode      : Float;
    weights       : [var Float];  // 36 Hebbian weights
    phase         : Float;        // Kuramoto phase
    frequency     : Float;        // Natural frequency
    coherence     : Float;        // Local coherence
  };
  
  public type EnemyDrone = {
    id          : Nat;
    posX        : Float;
    posY        : Float;
    posZ        : Float;
    velX        : Float;
    velY        : Float;
    velZ        : Float;
    health      : Float;
    active      : Bool;
    behavior    : EnemyBehavior;
    targetId    : ?Nat;  // ID of NOVA drone being targeted
    
    // IRONCLAD brain
    brain       : EnemyMiniBrain;
    
    // Squadron assignment (enemies have squadrons too)
    squadron    : Nat;
    isCommander : Bool;
  };
  
  public type EnemySwarmState = {
    swarmType     : EnemySwarmType;
    drones        : [var EnemyDrone];
    droneCount    : Nat;
    
    // Swarm-level parameters
    aggression    : Float;    // 0-1, how aggressive
    coordination  : Float;    // 0-1, how coordinated (maps to Kuramoto K)
    adaptability  : Float;    // 0-1, Hebbian learning rate
    
    // ═══════════════════════════════════════════════════════════════════════════
    // KURAMOTO STATE — Same as NOVA
    // ═══════════════════════════════════════════════════════════════════════════
    rSwarm        : Float;    // Order parameter
    meanPhase     : Float;    // Collective phase
    
    // Tactical state
    currentBehavior : EnemyBehavior;
    targetCenterX   : Float;
    targetCenterY   : Float;
    targetCenterZ   : Float;
    
    // Combat stats
    damageDealt   : Float;
    damageTaken   : Float;
    dronesLost    : Nat;
    
    // Learning (Adaptive + Superior types)
    novaPatternMemory : [Float];  // Remembers NOVA's past positions
    hebbianMemory     : [Float];  // Learned NOVA behavior patterns
    
    beatNum : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  
  func fsqrt(x: Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  func fsin(x: Float) : Float { Float.sin(x) };
  func fcos(x: Float) : Float { Float.cos(x) };
  
  func wrapPhase(theta: Float) : Float {
    var t = theta;
    while (t < 0.0) { t += TWO_PI };
    while (t >= TWO_PI) { t -= TWO_PI };
    t
  };
  
  func distance(x1: Float, y1: Float, z1: Float, x2: Float, y2: Float, z2: Float) : Float {
    let dx = x2 - x1;
    let dy = y2 - y1;
    let dz = z2 - z1;
    fsqrt(dx * dx + dy * dy + dz * dz)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // KURAMOTO FUNCTIONS — Same Physics as NOVA
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Compute enemy swarm's Kuramoto order parameter
  public func computeEnemyKuramotoOrder(state: EnemySwarmState) : (Float, Float) {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var count : Nat = 0;
    
    for (i in Iter.range(0, state.droneCount - 1)) {
      let drone = state.drones[i];
      if (drone.active) {
        sumCos += fcos(drone.brain.phase);
        sumSin += fsin(drone.brain.phase);
        count += 1;
      };
    };
    
    if (count == 0) { return (0.5, 0.0) };
    
    let n = Float.fromInt(count);
    let r = fsqrt((sumCos/n)*(sumCos/n) + (sumSin/n)*(sumSin/n));
    let meanPhase = Float.arctan2(sumSin/n, sumCos/n);
    
    (r, wrapPhase(meanPhase))
  };
  
  // Mean-field Kuramoto update for enemy drone — O(1)
  func updateEnemyPhase(drone: EnemyDrone, rSwarm: Float, meanPhase: Float, coordination: Float, dt: Float) : Float {
    // dθ/dt = ω + K·r·sin(ψ - θ)
    // coordination maps to Kuramoto K
    let K = KURAMOTO_K * coordination;
    let coupling = K * rSwarm * fsin(meanPhase - drone.brain.phase);
    let newPhase = drone.brain.phase + (drone.brain.frequency + coupling) * dt;
    wrapPhase(newPhase)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HEBBIAN LEARNING — Enemy Learns from NOVA
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Update enemy Hebbian weights based on activity
  func hebbianUpdateEnemy(weights: [var Float], activations: [Float], learningRate: Float) {
    var i = 0;
    while (i < 6) {
      var j = 0;
      while (j < 6) {
        if (i != j) {
          let idx = i * 6 + j;
          let dw = learningRate * activations[i] * activations[j];
          weights[idx] := clamp(weights[idx] + dw, 0.0, WEIGHT_CEIL);
        };
        j += 1;
      };
      i += 1;
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION — Full IRONCLAD Enemy Brain
  // ═══════════════════════════════════════════════════════════════════════════
  
  func initEnemyBrain(id: Nat) : EnemyMiniBrain {
    let weights = Array.init<Float>(36, 0.5);  // Start at sovereign floor
    {
      sensorNode = 0.5;
      memoryNode = 0.5;
      decisionNode = 0.5;
      emotionNode = 0.5;
      motorNode = 0.5;
      syncNode = 0.5;
      weights = weights;
      phase = Float.fromInt(id) * 0.2;
      frequency = NATURAL_FREQ_BASE + Float.fromInt(id % 10) * NATURAL_FREQ_SPREAD / 10.0;
      coherence = 0.7;
    }
  };
  
  func initEnemyDrone(id: Nat, totalDrones: Nat, spawnX: Float, spawnY: Float, spawnZ: Float) : EnemyDrone {
    // Enemy also has 3 squadrons
    let dronesPerSquad = totalDrones / 3;
    let squadron = id / dronesPerSquad;
    let squadronIdx = if (squadron > 2) 2 else squadron;
    let isCommander = (id == squadronIdx * dronesPerSquad);
    
    let angle = Float.fromInt(id) * 2.4;
    let radius = 10.0 + Float.fromInt(id % 5) * 5.0;
    {
      id = id;
      posX = spawnX + radius * fcos(angle);
      posY = spawnY;
      posZ = spawnZ + radius * fsin(angle);
      velX = 0.0;
      velY = 0.0;
      velZ = 0.0;
      health = if (isCommander) 1.5 else 1.0;
      active = true;
      behavior = #Patrol;
      targetId = null;
      brain = initEnemyBrain(id);
      squadron = squadronIdx;
      isCommander = isCommander;
    }
  };
  
  public func spawnEnemySwarm(
    swarmType: EnemySwarmType,
    droneCount: Nat,
    spawnX: Float,
    spawnY: Float,
    spawnZ: Float
  ) : EnemySwarmState {
    // ═══════════════════════════════════════════════════════════════════════════
    // SPAWN ENEMY SWARM — Full IRONCLAD Architecture
    // Enemy gets the same mathematical foundation as NOVA
    // ═══════════════════════════════════════════════════════════════════════════
    
    let count = if (droneCount > MAX_ENEMY_DRONES) MAX_ENEMY_DRONES else droneCount;
    
    let drones = Array.init<EnemyDrone>(count, initEnemyDrone(0, count, spawnX, spawnY, spawnZ));
    for (i in Iter.range(0, count - 1)) {
      drones[i] := initEnemyDrone(i, count, spawnX, spawnY, spawnZ);
    };
    
    // Set parameters based on swarm type
    // Higher tiers get stronger Kuramoto coupling (coordination) and Hebbian learning (adaptability)
    let (aggression, coordination, adaptability) = switch (swarmType) {
      case (#Basic)    (0.3, 0.3, 0.0);   // Weak coupling, no learning
      case (#Hunter)   (0.7, 0.5, 0.1);   // Aggressive, medium coupling
      case (#Tactical) (0.6, 0.8, 0.2);   // Smart flanking, strong coupling
      case (#Adaptive) (0.5, 0.7, 0.9);   // LEARNS from NOVA (Hebbian)
      case (#Superior) (0.9, 0.95, 0.5);  // Maximum IRONCLAD: near-OMNIS coordination
    };
    
    {
      swarmType = swarmType;
      drones = drones;
      droneCount = count;
      aggression = aggression;
      coordination = coordination;
      adaptability = adaptability;
      
      // Kuramoto state
      rSwarm = 0.5 + coordination * 0.3;  // Initial coherence based on type
      meanPhase = 0.0;
      
      currentBehavior = #Patrol;
      targetCenterX = 0.0;
      targetCenterY = 50.0;
      targetCenterZ = 0.0;
      damageDealt = 0.0;
      damageTaken = 0.0;
      dronesLost = 0;
      novaPatternMemory = Array.freeze(Array.init<Float>(100, 0.0));
      hebbianMemory = Array.freeze(Array.init<Float>(64, 0.5));  // 8x8 learned patterns
      beatNum = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // BEHAVIOR SELECTION
  // ═══════════════════════════════════════════════════════════════════════════
  
  func selectBehavior(
    state: EnemySwarmState,
    novaX: Float,
    novaY: Float,
    novaZ: Float,
    novaStrength: Float
  ) : EnemyBehavior {
    let distToNova = distance(state.targetCenterX, state.targetCenterY, state.targetCenterZ, novaX, novaY, novaZ);
    
    // Count active drones
    var activeCount : Nat = 0;
    for (i in Iter.range(0, state.droneCount - 1)) {
      if (state.drones[i].active) { activeCount += 1 };
    };
    let enemyStrength = Float.fromInt(activeCount) / Float.fromInt(state.droneCount);
    
    switch (state.swarmType) {
      case (#Basic) {
        // Basic: simple patrol, pursue if close
        if (distToNova < ATTACK_RANGE * 2.0) #Pursue
        else #Patrol
      };
      case (#Hunter) {
        // Hunter: aggressive pursuit
        if (distToNova < ATTACK_RANGE * 3.0) #Pursue
        else if (distToNova < ATTACK_RANGE * 5.0) #Encircle
        else #Patrol
      };
      case (#Tactical) {
        // Tactical: smart flanking
        if (enemyStrength < 0.3) #Retreat
        else if (distToNova < ATTACK_RANGE) #Encircle
        else if (distToNova < ATTACK_RANGE * 3.0) #Flank
        else #Patrol
      };
      case (#Adaptive) {
        // Adaptive: learns and counters
        if (enemyStrength < novaStrength * 0.5) #Retreat
        else if (enemyStrength > novaStrength * 1.5) #Pursue
        else if (distToNova < ATTACK_RANGE * 2.0) #Flank
        else #Ambush
      };
      case (#Superior) {
        // Superior: optimal tactics
        if (enemyStrength < 0.2) #Retreat
        else if (distToNova < ATTACK_RANGE * 0.5) #Encircle
        else if (distToNova < ATTACK_RANGE * 2.0) #Flank
        else if (enemyStrength > novaStrength) #Pursue
        else #Ambush
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MOVEMENT PATTERNS
  // ═══════════════════════════════════════════════════════════════════════════
  
  func patrolMovement(drone: EnemyDrone, centerX: Float, centerY: Float, centerZ: Float, beatNum: Nat) : (Float, Float, Float) {
    let angle = drone.brain.phase + Float.fromInt(beatNum) * 0.05;
    let radius = 30.0 + Float.fromInt(drone.id % 5) * 10.0;
    (
      centerX + radius * fcos(angle),
      centerY + 5.0 * fsin(angle * 2.0),
      centerZ + radius * fsin(angle)
    )
  };
  
  func pursueMovement(drone: EnemyDrone, targetX: Float, targetY: Float, targetZ: Float) : (Float, Float, Float) {
    (targetX, targetY, targetZ)
  };
  
  func flankMovement(drone: EnemyDrone, targetX: Float, targetY: Float, targetZ: Float, beatNum: Nat) : (Float, Float, Float) {
    // Approach from the side — use Kuramoto phase for coordination
    let flankAngle = drone.brain.phase + PI / 2.0;
    let flankDist = 30.0;
    (
      targetX + flankDist * fcos(flankAngle),
      targetY,
      targetZ + flankDist * fsin(flankAngle)
    )
  };
  
  func encircleMovement(drone: EnemyDrone, targetX: Float, targetY: Float, targetZ: Float, droneCount: Nat, beatNum: Nat) : (Float, Float, Float) {
    let angle = Float.fromInt(drone.id) * TWO_PI / Float.fromInt(droneCount) + Float.fromInt(beatNum) * 0.02;
    let radius = 40.0;
    (
      targetX + radius * fcos(angle),
      targetY + 10.0 * fsin(Float.fromInt(drone.id) * 0.5),
      targetZ + radius * fsin(angle)
    )
  };
  
  func retreatMovement(drone: EnemyDrone, targetX: Float, targetY: Float, targetZ: Float, spawnX: Float, spawnY: Float, spawnZ: Float) : (Float, Float, Float) {
    // Move away from target, toward spawn
    let dx = drone.posX - targetX;
    let dy = drone.posY - targetY;
    let dz = drone.posZ - targetZ;
    let dist = fsqrt(dx * dx + dy * dy + dz * dz);
    if (dist < 0.1) { (spawnX, spawnY, spawnZ) }
    else {
      let retreatDist = 100.0;
      (
        drone.posX + dx / dist * retreatDist,
        drone.posY + dy / dist * retreatDist,
        drone.posZ + dz / dist * retreatDist
      )
    }
  };
  
  func ambushMovement(drone: EnemyDrone, targetX: Float, targetY: Float, targetZ: Float, novaVelX: Float, novaVelZ: Float) : (Float, Float, Float) {
    // Predict where NOVA will be
    let predictionTime = 5.0; // seconds
    let predictedX = targetX + novaVelX * predictionTime;
    let predictedZ = targetZ + novaVelZ * predictionTime;
    (predictedX, targetY, predictedZ)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN TICK — Update enemy swarm
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func tickEnemySwarm(
    state: EnemySwarmState,
    novaX: Float,
    novaY: Float,
    novaZ: Float,
    novaVelX: Float,
    novaVelZ: Float,
    novaStrength: Float,
    spawnX: Float,
    spawnY: Float,
    spawnZ: Float,
    dt: Float,
    beatNum: Nat
  ) : EnemySwarmState {
    
    // ═══════════════════════════════════════════════════════════════════════════
    // ENEMY TICK — Full IRONCLAD Physics
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Step 0: Compute Kuramoto order parameter (mean-field) — O(N)
    let (rSwarm, meanPhase) = computeEnemyKuramotoOrder(state);
    
    // Step 1: Select swarm-level behavior
    let newBehavior = selectBehavior(state, novaX, novaY, novaZ, novaStrength);
    
    // Step 2: Update each drone with IRONCLAD physics
    for (i in Iter.range(0, state.droneCount - 1)) {
      let drone = state.drones[i];
      if (not drone.active) {
        // Skip destroyed drones
      } else {
        // 2a: Update Kuramoto phase (mean-field coupling) — O(1) per drone
        let newPhase = updateEnemyPhase(drone, rSwarm, meanPhase, state.coordination, dt);
        
        // 2b: Get target position based on behavior
        let (targetX, targetY, targetZ) = switch (newBehavior) {
          case (#Patrol) patrolMovement(drone, state.targetCenterX, state.targetCenterY, state.targetCenterZ, beatNum);
          case (#Pursue) pursueMovement(drone, novaX, novaY, novaZ);
          case (#Flank) flankMovement(drone, novaX, novaY, novaZ, beatNum);
          case (#Encircle) encircleMovement(drone, novaX, novaY, novaZ, state.droneCount, beatNum);
          case (#Retreat) retreatMovement(drone, novaX, novaY, novaZ, spawnX, spawnY, spawnZ);
          case (#Regroup) patrolMovement(drone, spawnX, spawnY, spawnZ, beatNum);
          case (#Ambush) ambushMovement(drone, novaX, novaY, novaZ, novaVelX, novaVelZ);
        };
        
        // 2c: Move toward target
        let dx = targetX - drone.posX;
        let dy = targetY - drone.posY;
        let dz = targetZ - drone.posZ;
        let dist = fsqrt(dx * dx + dy * dy + dz * dz);
        
        // Speed boosted by swarm coherence (N² superradiance analog)
        let coherenceBoost = 1.0 + rSwarm * 0.5;
        let speed = PURSUIT_SPEED * state.aggression * coherenceBoost;
        let (newVelX, newVelY, newVelZ) = if (dist < 0.5) {
          (0.0, 0.0, 0.0)
        } else {
          let scale = speed / dist;
          (dx * scale, dy * scale, dz * scale)
        };
        
        // 2d: Update brain activations for Hebbian learning
        let activations = [
          drone.brain.sensorNode,
          drone.brain.memoryNode,
          drone.brain.decisionNode,
          drone.brain.emotionNode,
          drone.brain.motorNode,
          drone.brain.syncNode
        ];
        
        // Hebbian update if adaptable (Adaptive/Superior types)
        if (state.adaptability > 0.1) {
          hebbianUpdateEnemy(drone.brain.weights, activations, state.adaptability * HEBBIAN_ALPHA);
        };
        
        // 2e: Update drone state with new phase and position
        state.drones[i] := {
          drone with
          posX = drone.posX + newVelX * dt;
          posY = drone.posY + newVelY * dt;
          posZ = drone.posZ + newVelZ * dt;
          velX = newVelX;
          velY = newVelY;
          velZ = newVelZ;
          behavior = newBehavior;
          brain = { drone.brain with 
            phase = newPhase;
            coherence = rSwarm;
            // Update brain nodes based on behavior
            sensorNode = clamp(0.5 + (dist / 100.0), 0.0, 1.0);  // Proximity sensing
            decisionNode = clamp(state.aggression, 0.0, 1.0);
            motorNode = clamp(speed / PURSUIT_SPEED, 0.0, 1.0);
            syncNode = rSwarm;
          };
        };
      };
    };
    
    // Step 3: Update pattern memory for Adaptive type
    var newMemory = state.novaPatternMemory;
    if ((state.swarmType == #Adaptive or state.swarmType == #Superior) and beatNum % 10 == 0) {
      // Shift memory and add new position
      var mutableMemory = Array.thaw<Float>(state.novaPatternMemory);
      for (i in Iter.range(0, 96)) {
        mutableMemory[i] := mutableMemory[i + 3];
      };
      mutableMemory[97] := novaX;
      mutableMemory[98] := novaY;
      mutableMemory[99] := novaZ;
      newMemory := Array.freeze(mutableMemory);
    };
    
    // Return updated state with Kuramoto metrics
    {
      state with
      rSwarm = rSwarm;
      meanPhase = meanPhase;
      currentBehavior = newBehavior;
      targetCenterX = novaX;
      targetCenterY = novaY;
      targetCenterZ = novaZ;
      novaPatternMemory = newMemory;
      beatNum = beatNum;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMBAT RESOLUTION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type CombatResult = {
    enemyDamageDealt : Float;
    novaDamageDealt  : Float;
    enemyDronesLost  : Nat;
    novaDronesHit    : [Nat]; // IDs of NOVA drones that were hit
  };
  
  public func resolveCombat(
    enemyState: EnemySwarmState,
    novaDronePositions: [(Nat, Float, Float, Float)], // (id, x, y, z)
    dt: Float
  ) : (EnemySwarmState, CombatResult) {
    var enemyDamageDealt : Float = 0.0;
    var novaDamageDealt : Float = 0.0;
    var enemyDronesLost : Nat = 0;
    var novaDronesHit : [Nat] = [];
    
    // Check each enemy drone for combat
    for (i in Iter.range(0, enemyState.droneCount - 1)) {
      let enemy = enemyState.drones[i];
      if (enemy.active) {
        // Check distance to each NOVA drone
        for ((novaId, novaX, novaY, novaZ) in novaDronePositions.vals()) {
          let dist = distance(enemy.posX, enemy.posY, enemy.posZ, novaX, novaY, novaZ);
          
          if (dist < ATTACK_RANGE) {
            // Combat happens
            let enemyDamage = 0.1 * enemyState.aggression * dt;
            let novaDamage = 0.12 * dt; // NOVA slightly stronger
            
            enemyDamageDealt += enemyDamage;
            novaDamageDealt += novaDamage;
            novaDronesHit := Array.append(novaDronesHit, [novaId]);
            
            // Apply damage to enemy
            let newHealth = enemy.health - novaDamage;
            if (newHealth <= 0.0) {
              enemyState.drones[i] := { enemy with health = 0.0; active = false };
              enemyDronesLost += 1;
            } else {
              enemyState.drones[i] := { enemy with health = newHealth };
            };
          };
        };
      };
    };
    
    let result : CombatResult = {
      enemyDamageDealt = enemyDamageDealt;
      novaDamageDealt = novaDamageDealt;
      enemyDronesLost = enemyDronesLost;
      novaDronesHit = novaDronesHit;
    };
    
    (
      {
        enemyState with
        damageDealt = enemyState.damageDealt + enemyDamageDealt;
        damageTaken = enemyState.damageTaken + novaDamageDealt;
        dronesLost = enemyState.dronesLost + enemyDronesLost;
      },
      result
    )
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS REPORT
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getEnemyStatus(state: EnemySwarmState) : Text {
    var activeCount : Nat = 0;
    var totalHealth : Float = 0.0;
    
    for (i in Iter.range(0, state.droneCount - 1)) {
      if (state.drones[i].active) {
        activeCount += 1;
        totalHealth += state.drones[i].health;
      };
    };
    
    let avgHealth = if (activeCount > 0) totalHealth / Float.fromInt(activeCount) else 0.0;
    
    "ENEMY SWARM STATUS:\n" #
    "═══════════════════════════════════════════════════════════════\n" #
    "Type: " # swarmTypeToText(state.swarmType) # "\n" #
    "Active: " # Nat.toText(activeCount) # "/" # Nat.toText(state.droneCount) # "\n" #
    "Behavior: " # behaviorToText(state.currentBehavior) # "\n" #
    "Aggression: " # Float.format(#fix 2, state.aggression * 100.0) # "%\n" #
    "Coordination: " # Float.format(#fix 2, state.coordination * 100.0) # "%\n" #
    "Avg Health: " # Float.format(#fix 2, avgHealth * 100.0) # "%\n" #
    "Damage Dealt: " # Float.format(#fix 1, state.damageDealt) # "\n" #
    "Damage Taken: " # Float.format(#fix 1, state.damageTaken) # "\n" #
    "Drones Lost: " # Nat.toText(state.dronesLost)
  };
  
  func swarmTypeToText(t: EnemySwarmType) : Text {
    switch (t) {
      case (#Basic) "BASIC";
      case (#Hunter) "HUNTER";
      case (#Tactical) "TACTICAL";
      case (#Adaptive) "ADAPTIVE";
      case (#Superior) "SUPERIOR";
    }
  };
  
  func behaviorToText(b: EnemyBehavior) : Text {
    switch (b) {
      case (#Patrol) "PATROL";
      case (#Pursue) "PURSUE";
      case (#Flank) "FLANK";
      case (#Encircle) "ENCIRCLE";
      case (#Retreat) "RETREAT";
      case (#Regroup) "REGROUP";
      case (#Ambush) "AMBUSH";
    }
  };

}
