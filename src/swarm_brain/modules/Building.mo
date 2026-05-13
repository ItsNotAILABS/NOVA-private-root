// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: Building — Fibonacci Structural Physics Engine
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    BUILDING ENGINE — REAL STRUCTURAL PHYSICS             ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  Buildings are REAL structures with REAL physics.                        ║
// ║  Not HP bars. STRUCTURAL NODES that propagate damage.                    ║
// ║                                                                          ║
// ║  FIBONACCI IN ARCHITECTURE:                                              ║
// ║    - Load distribution follows phi ratios                                  ║
// ║    - Column spacing at phi intervals                                       ║
// ║    - Floor heights decrease by φ⁻¹ each level                           ║
// ║    - Window proportions are golden rectangles                           ║
// ║    - Buildings placed in Fibonacci spirals                              ║
// ║                                                                          ║
// ║  DAMAGE MODEL:                                                           ║
// ║    - Impact propagates via φ^(-distance)                                 ║
// ║    - Cascade failure when node < threshold                              ║
// ║    - Collapse direction toward damaged side                             ║
// ║    - Debris arc follows logarithmic spiral                              ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONSTANTS                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let phi : Float = 1.6180339887498948482;
  public let psi : Float = 0.6180339887498948482;
  public let pi : Float = 3.1415926535897932385;
  public let GOLDEN_ANGLE : Float = 2.3999632297286533;
  
  // Fibonacci sequence
  public let F : [Nat] = [
    0, 1, 1, 2, 3, 5, 8, 13, 21, 34,
    55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181
  ];
  
  // Max buildings per biome
  public let MAX_BUILDINGS_PER_BIOME : Nat = 21;  // F[8]
  
  // Max structural nodes per building
  public let MAX_NODES : Nat = 13;  // F[7]

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BUILDING TYPES                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type BuildingId = Nat32;
  
  public type BuildingType = {
    #Outpost;         // Tier 1: 1 cell, 8 HP — basic presence
    #Watchtower;      // Tier 2: 1 cell, 13 HP — surveillance
    #Barracks;        // Tier 3: 2 cells, 21 HP — unit production
    #Armory;          // Tier 4: 3 cells, 34 HP — equipment
    #Factory;         // Tier 5: 5 cells, 55 HP — heavy production
    #Fortress;        // Tier 6: 8 cells, 89 HP — major defense
    #Citadel;         // Tier 7: 13 cells, 144 HP — capital
  };
  
  public type BuildingStatus = {
    #Standing;        // Fully operational
    #Damaged;         // Reduced effectiveness
    #Critical;        // Cascade imminent
    #Collapsing;      // In collapse animation
    #Collapsed;       // Destroyed, debris remains
    #Rubble;          // Cleared for rebuild
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     STRUCTURAL NODE                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Buildings are made of structural NODES, not just HP bars.
  // Each node has position, HP, and connections to adjacent nodes.
  // Damage propagates through the structure realistically.
  //
  public type StructuralNode = {
    nodeIndex : Nat;
    
    // Position within building (local coordinates)
    localX : Float;
    localZ : Float;
    localY : Float;           // Height/floor
    
    // Structural properties
    hp : Float;               // Current HP
    maxHP : Float;            // Maximum HP (F[tier+5])
    loadBearing : Float;      // [0, 1] how critical to structure
    
    // Connection to other nodes
    connectedNodes : [Nat];   // Indices of connected nodes
    connectionStrength : Float; // [0, 1] how strong connections are
    
    // Damage state
    damaged : Bool;
    cascadeFired : Bool;      // Has this node triggered cascade?
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BUILDING RECORD                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type BuildingRecord = {
    id : BuildingId;
    buildingType : BuildingType;
    tier : Nat;               // 1-7
    
    // Location
    biomeId : Nat;
    factionOwner : Nat;       // 0-3 for 4 factions
    position : Position3D;
    rotation : Float;         // Facing direction (radians)
    
    // Structural
    nodes : [StructuralNode];
    totalHP : Float;
    maxHP : Float;
    status : BuildingStatus;
    structuralIntegrity : Float;  // [0, 1] overall health
    
    // Collapse physics
    collapseDirection : Float;    // radians
    collapseProgress : Float;     // [0, 1] how far collapsed
    debrisField : [Position3D];   // Where debris landed
    
    // Metadata
    constructedAt : Nat;          // Beat number
    lastDamaged : Nat;
    lastRepaired : Nat;
    
    // Production (for factories, barracks)
    productionType : ?ProductionType;
    productionProgress : Float;
  };
  
  public type Position3D = {
    x : Float;
    y : Float;
    z : Float;
  };
  
  public type ProductionType = {
    #Units;
    #Equipment;
    #Resources;
    #Research;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BUILDING TIER FUNCTIONS                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Get tier from building type
  public func getTier(buildingType: BuildingType) : Nat {
    switch (buildingType) {
      case (#Outpost) { 1 };
      case (#Watchtower) { 2 };
      case (#Barracks) { 3 };
      case (#Armory) { 4 };
      case (#Factory) { 5 };
      case (#Fortress) { 6 };
      case (#Citadel) { 7 };
    }
  };
  
  /// Get building type from tier
  public func typeFromTier(tier: Nat) : BuildingType {
    switch (tier) {
      case (1) { #Outpost };
      case (2) { #Watchtower };
      case (3) { #Barracks };
      case (4) { #Armory };
      case (5) { #Factory };
      case (6) { #Fortress };
      case (7) { #Citadel };
      case (_) { #Outpost };
    }
  };
  
  /// Get cell count for tier (F[tier])
  public func tierCells(tier: Nat) : Nat {
    if (tier < F.size()) { F[tier] } else { F[F.size() - 1] }
  };
  
  /// Get HP for tier (F[tier+5])
  public func tierHP(tier: Nat) : Float {
    let index = tier + 5;
    if (index < F.size()) { Float.fromInt(F[index]) } else { Float.fromInt(F[F.size() - 1]) }
  };
  
  /// Get cascade threshold (F[tier+3])
  public func cascadeThreshold(tier: Nat) : Float {
    let index = tier + 3;
    if (index < F.size()) { Float.fromInt(F[index]) } else { Float.fromInt(F[3]) }
  };
  
  /// Get cascade damage (F[tier+2])
  public func cascadeDamageAmount(tier: Nat) : Float {
    let index = tier + 2;
    if (index < F.size()) { Float.fromInt(F[index]) } else { Float.fromInt(F[2]) }
  };
  
  /// Get node count for tier
  public func tierNodeCount(tier: Nat) : Nat {
    // Nodes = 3 + tier (minimum 3, maximum 13)
    Nat.min(MAX_NODES, 3 + tier)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SPAWN BUILDING                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Generate Fibonacci spiral position within biome
  public func spiralPosition(
    biomeCenterX: Float,
    biomeCenterZ: Float,
    shellIndex: Nat
  ) : Position3D {
    let shellF = Float.fromInt(shellIndex);
    
    // Position in Fibonacci spiral
    let angle = shellF * GOLDEN_ANGLE;
    let radius = Float.fromInt(F[Nat.min(shellIndex + 3, F.size() - 1)]) * 0.5;
    
    let x = biomeCenterX + radius * Float.cos(angle);
    let z = biomeCenterZ + radius * Float.sin(angle);
    
    { x = x; y = 0.0; z = z }
  };
  
  /// Generate structural nodes for a building
  public func generateNodes(tier: Nat, position: Position3D) : [StructuralNode] {
    let nodeCount = tierNodeCount(tier);
    let baseHP = tierHP(tier);
    
    let nodes = Buffer.Buffer<StructuralNode>(nodeCount);
    
    // Generate nodes in golden-angle arrangement
    var i : Nat = 0;
    while (i < nodeCount) {
      let angle = Float.fromInt(i) * GOLDEN_ANGLE;
      let radius = Float.fromInt(i + 1) * 0.5;
      let floor = i / 4;  // 4 nodes per floor
      
      // Load bearing: center nodes bear more load
      let loadBearing = if (i < 2) { 0.9 } 
                        else if (i < 5) { 0.7 }
                        else { 0.5 };
      
      // Connect to adjacent nodes
      let connections = Buffer.Buffer<Nat>(4);
      if (i > 0) { connections.add(i - 1) };
      if (i < nodeCount - 1) { connections.add(i + 1) };
      if (i >= 4) { connections.add(i - 4) };  // Node below
      if (i + 4 < nodeCount) { connections.add(i + 4) };  // Node above
      
      nodes.add({
        nodeIndex = i;
        localX = radius * Float.cos(angle);
        localZ = radius * Float.sin(angle);
        localY = Float.fromInt(floor) * (5.0 * Float.pow(ψ, Float.fromInt(floor)));
        hp = baseHP;
        maxHP = baseHP;
        loadBearing = loadBearing;
        connectedNodes = Buffer.toArray(connections);
        connectionStrength = 1.0;
        damaged = false;
        cascadeFired = false;
      });
      
      i += 1;
    };
    
    Buffer.toArray(nodes)
  };
  
  /// Spawn a new building
  public func spawnBuilding(
    nextId: BuildingId,
    biomeId: Nat,
    tier: Nat,
    factionOwner: Nat,
    biomeCenterX: Float,
    biomeCenterZ: Float,
    shellIndex: Nat,
    currentBeat: Nat
  ) : BuildingRecord {
    let position = spiralPosition(biomeCenterX, biomeCenterZ, shellIndex);
    let nodes = generateNodes(tier, position);
    let maxHP = tierHP(tier) * Float.fromInt(nodes.size());
    
    {
      id = nextId;
      buildingType = typeFromTier(tier);
      tier = tier;
      biomeId = biomeId;
      factionOwner = factionOwner;
      position = position;
      rotation = Float.fromInt(shellIndex) * GOLDEN_ANGLE;
      nodes = nodes;
      totalHP = maxHP;
      maxHP = maxHP;
      status = #Standing;
      structuralIntegrity = 1.0;
      collapseDirection = 0.0;
      collapseProgress = 0.0;
      debrisField = [];
      constructedAt = currentBeat;
      lastDamaged = 0;
      lastRepaired = currentBeat;
      productionType = null;
      productionProgress = 0.0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DAMAGE SYSTEM                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Apply damage to a building at specific impact point
  public func applyDamage(
    building: BuildingRecord,
    impactX: Float,
    impactZ: Float,
    impactForce: Float,
    currentBeat: Nat
  ) : BuildingRecord {
    if (building.status == #Collapsed or building.status == #Rubble) {
      return building;  // Can't damage destroyed building
    };
    
    // Calculate damage to each node based on distance from impact
    let newNodes = Buffer.Buffer<StructuralNode>(building.nodes.size());
    var cascadeTriggered = false;
    var damagedNodeIndices = Buffer.Buffer<Nat>(building.nodes.size());
    
    for (node in building.nodes.vals()) {
      // Distance from impact (in local coordinates)
      let dx = node.localX - (impactX - building.position.x);
      let dz = node.localZ - (impactZ - building.position.z);
      let distance = Float.sqrt(dx * dx + dz * dz);
      
      // Damage = force × φ^(-distance)
      let damageAtNode = impactForce * Float.pow(ψ, distance);
      let newHP = Float.max(0.0, node.hp - damageAtNode);
      
      // Check for cascade
      let threshold = cascadeThreshold(building.tier);
      let shouldCascade = newHP < threshold and not node.cascadeFired;
      
      if (shouldCascade) {
        cascadeTriggered := true;
        damagedNodeIndices.add(node.nodeIndex);
      };
      
      newNodes.add({
        nodeIndex = node.nodeIndex;
        localX = node.localX;
        localZ = node.localZ;
        localY = node.localY;
        hp = newHP;
        maxHP = node.maxHP;
        loadBearing = node.loadBearing;
        connectedNodes = node.connectedNodes;
        connectionStrength = if (shouldCascade) { node.connectionStrength * 0.5 } else { node.connectionStrength };
        damaged = newHP < node.maxHP * 0.9;
        cascadeFired = node.cascadeFired or shouldCascade;
      });
    };
    
    // Apply cascade damage to connected nodes
    if (cascadeTriggered) {
      let cascadeDmg = cascadeDamageAmount(building.tier);
      
      for (idx in damagedNodeIndices.vals()) {
        let damagedNode = newNodes.get(idx);
        for (connIdx in damagedNode.connectedNodes.vals()) {
          if (connIdx < newNodes.size()) {
            let connNode = newNodes.get(connIdx);
            let newConnHP = Float.max(0.0, connNode.hp - cascadeDmg);
            newNodes.put(connIdx, {
              nodeIndex = connNode.nodeIndex;
              localX = connNode.localX;
              localZ = connNode.localZ;
              localY = connNode.localY;
              hp = newConnHP;
              maxHP = connNode.maxHP;
              loadBearing = connNode.loadBearing;
              connectedNodes = connNode.connectedNodes;
              connectionStrength = connNode.connectionStrength * 0.8;
              damaged = true;
              cascadeFired = connNode.cascadeFired;
            });
          };
        };
      };
    };
    
    // Calculate new totals
    var totalHP : Float = 0.0;
    let finalNodes = Buffer.toArray(newNodes);
    for (node in finalNodes.vals()) {
      totalHP += node.hp;
    };
    
    let integrity = totalHP / building.maxHP;
    
    // Determine new status
    let newStatus = if (integrity <= 0.0) {
      #Collapsed
    } else if (integrity < 0.2) {
      #Critical
    } else if (integrity < 0.7) {
      #Damaged
    } else {
      #Standing
    };
    
    // Calculate collapse direction (toward most damaged side)
    let collapseDir = calculateCollapseDirection(finalNodes);
    
    {
      id = building.id;
      buildingType = building.buildingType;
      tier = building.tier;
      biomeId = building.biomeId;
      factionOwner = building.factionOwner;
      position = building.position;
      rotation = building.rotation;
      nodes = finalNodes;
      totalHP = totalHP;
      maxHP = building.maxHP;
      status = newStatus;
      structuralIntegrity = integrity;
      collapseDirection = collapseDir;
      collapseProgress = if (newStatus == #Collapsed) { 1.0 } else { building.collapseProgress };
      debrisField = building.debrisField;
      constructedAt = building.constructedAt;
      lastDamaged = currentBeat;
      lastRepaired = building.lastRepaired;
      productionType = building.productionType;
      productionProgress = building.productionProgress;
    }
  };
  
  /// Calculate collapse direction (toward most damaged nodes)
  func calculateCollapseDirection(nodes: [StructuralNode]) : Float {
    var weightedX : Float = 0.0;
    var weightedZ : Float = 0.0;
    var totalDamage : Float = 0.0;
    
    for (node in nodes.vals()) {
      let damage = node.maxHP - node.hp;
      weightedX += node.localX * damage;
      weightedZ += node.localZ * damage;
      totalDamage += damage;
    };
    
    if (totalDamage > 0.001) {
      let avgX = weightedX / totalDamage;
      let avgZ = weightedZ / totalDamage;
      Float.arctan2(avgZ, avgX)
    } else {
      0.0
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COLLAPSE BUILDING                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Trigger building collapse
  public func collapseBuilding(
    building: BuildingRecord,
    currentBeat: Nat
  ) : BuildingRecord {
    // Generate debris field following logarithmic spiral
    let debrisBuffer = Buffer.Buffer<Position3D>(8);
    
    var i : Nat = 0;
    while (i < 8) {
      let theta = Float.fromInt(i) * GOLDEN_ANGLE;
      // r = φ^(θ/π) — logarithmic spiral
      let radius = Float.pow(φ, theta / π) * 2.0;
      
      // Debris falls in collapse direction
      let debrisAngle = building.collapseDirection + theta * 0.5;
      
      debrisBuffer.add({
        x = building.position.x + radius * Float.cos(debrisAngle);
        y = 0.0;
        z = building.position.z + radius * Float.sin(debrisAngle);
      });
      
      i += 1;
    };
    
    {
      id = building.id;
      buildingType = building.buildingType;
      tier = building.tier;
      biomeId = building.biomeId;
      factionOwner = building.factionOwner;
      position = building.position;
      rotation = building.rotation;
      nodes = building.nodes;
      totalHP = 0.0;
      maxHP = building.maxHP;
      status = #Collapsed;
      structuralIntegrity = 0.0;
      collapseDirection = building.collapseDirection;
      collapseProgress = 1.0;
      debrisField = Buffer.toArray(debrisBuffer);
      constructedAt = building.constructedAt;
      lastDamaged = currentBeat;
      lastRepaired = building.lastRepaired;
      productionType = null;
      productionProgress = 0.0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     REPAIR SYSTEM                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Repair building over time
  public func repairBuilding(
    building: BuildingRecord,
    repairAmount: Float,
    currentBeat: Nat
  ) : BuildingRecord {
    if (building.status == #Collapsed or building.status == #Rubble) {
      return building;  // Can't repair destroyed building
    };
    
    // Repair nodes proportionally
    let newNodes = Buffer.Buffer<StructuralNode>(building.nodes.size());
    var totalHP : Float = 0.0;
    
    for (node in building.nodes.vals()) {
      let repairShare = repairAmount / Float.fromInt(building.nodes.size());
      let newHP = Float.min(node.maxHP, node.hp + repairShare);
      
      newNodes.add({
        nodeIndex = node.nodeIndex;
        localX = node.localX;
        localZ = node.localZ;
        localY = node.localY;
        hp = newHP;
        maxHP = node.maxHP;
        loadBearing = node.loadBearing;
        connectedNodes = node.connectedNodes;
        connectionStrength = Float.min(1.0, node.connectionStrength + 0.01);
        damaged = newHP < node.maxHP * 0.9;
        cascadeFired = if (newHP > cascadeThreshold(building.tier)) { false } else { node.cascadeFired };
      });
      
      totalHP += newHP;
    };
    
    let integrity = totalHP / building.maxHP;
    let newStatus = if (integrity > 0.9) { #Standing }
                    else if (integrity > 0.5) { #Damaged }
                    else { #Critical };
    
    {
      id = building.id;
      buildingType = building.buildingType;
      tier = building.tier;
      biomeId = building.biomeId;
      factionOwner = building.factionOwner;
      position = building.position;
      rotation = building.rotation;
      nodes = Buffer.toArray(newNodes);
      totalHP = totalHP;
      maxHP = building.maxHP;
      status = newStatus;
      structuralIntegrity = integrity;
      collapseDirection = building.collapseDirection;
      collapseProgress = building.collapseProgress;
      debrisField = building.debrisField;
      constructedAt = building.constructedAt;
      lastDamaged = building.lastDamaged;
      lastRepaired = currentBeat;
      productionType = building.productionType;
      productionProgress = building.productionProgress;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SUMMARY                                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type BuildingSummary = {
    id : BuildingId;
    tier : Nat;
    status : BuildingStatus;
    integrity : Float;
    position : Position3D;
  };
  
  public func summarize(building: BuildingRecord) : BuildingSummary {
    {
      id = building.id;
      tier = building.tier;
      status = building.status;
      integrity = building.structuralIntegrity;
      position = building.position;
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
  //  W O R L D   S I M U L A T I O N   M A T H E M A T I C S
  //
  //  Enterprise-Level World Modeling and Physics
  //  Full HIM/HER Integration for Virtual Environments
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // PHYSICS SIMULATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Newtonian mechanics: F = ma
  public func worldForceToAcceleration(force : Float, mass : Float) : Float {
    if (mass < 0.0001) { 0.0 } else { force / mass }
  };

  /// Velocity update: v = v0 + a*t
  public func worldVelocityUpdate(v0 : Float, acceleration : Float, dt : Float) : Float {
    v0 + acceleration * dt
  };

  /// Position update: x = x0 + v*t + 0.5*a*t²
  public func worldPositionUpdate(x0 : Float, velocity : Float, acceleration : Float, dt : Float) : Float {
    x0 + velocity * dt + 0.5 * acceleration * dt * dt
  };

  /// Gravitational force: F = G*m1*m2/r²
  public func worldGravitationalForce(m1 : Float, m2 : Float, distance : Float, g : Float) : Float {
    if (distance < 0.0001) { 0.0 }
    else { g * m1 * m2 / (distance * distance) }
  };

  /// Drag force: F = 0.5*rho*v²*Cd*A
  public func worldDragForce(density : Float, velocity : Float, dragCoeff : Float, area : Float) : Float {
    0.5 * density * velocity * velocity * dragCoeff * area
  };

  /// Spring force: F = -k*x
  public func worldSpringForce(springConstant : Float, displacement : Float) : Float {
    -springConstant * displacement
  };

  /// Friction force: F = μ*N
  public func worldFrictionForce(frictionCoeff : Float, normalForce : Float) : Float {
    frictionCoeff * normalForce
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COLLISION DETECTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// AABB collision test
  public func worldAABBCollision(
    ax1 : Float, ay1 : Float, ax2 : Float, ay2 : Float,
    bx1 : Float, by1 : Float, bx2 : Float, by2 : Float
  ) : Bool {
    ax1 <= bx2 and ax2 >= bx1 and ay1 <= by2 and ay2 >= by1
  };

  /// Circle collision test
  public func worldCircleCollision(
    x1 : Float, y1 : Float, r1 : Float,
    x2 : Float, y2 : Float, r2 : Float
  ) : Bool {
    let dx = x2 - x1;
    let dy = y2 - y1;
    let dist = Float.sqrt(dx * dx + dy * dy);
    dist < (r1 + r2)
  };

  /// Point in triangle test
  public func worldPointInTriangle(
    px : Float, py : Float,
    ax : Float, ay : Float,
    bx : Float, by : Float,
    cx : Float, cy : Float
  ) : Bool {
    func sign(p1x : Float, p1y : Float, p2x : Float, p2y : Float, p3x : Float, p3y : Float) : Float {
      (p1x - p3x) * (p2y - p3y) - (p2x - p3x) * (p1y - p3y)
    };
    let d1 = sign(px, py, ax, ay, bx, by);
    let d2 = sign(px, py, bx, by, cx, cy);
    let d3 = sign(px, py, cx, cy, ax, ay);
    let hasNeg = (d1 < 0.0) or (d2 < 0.0) or (d3 < 0.0);
    let hasPos = (d1 > 0.0) or (d2 > 0.0) or (d3 > 0.0);
    not (hasNeg and hasPos)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // TERRAIN GENERATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Simple noise function (pseudo-random)
  public func worldSimpleNoise(x : Nat, y : Nat, seed : Nat) : Float {
    let n = x + y * 57 + seed * 131;
    let m = ((n * (n * n * 15731 + 789221) + 1376312589) % 2147483648);
    Float.fromInt(m % 1000000) / 1000000.0
  };

  /// Linear interpolation
  public func worldLerp(a : Float, b : Float, t : Float) : Float {
    a + t * (b - a)
  };

  /// Smooth interpolation
  public func worldSmoothStep(t : Float) : Float {
    t * t * (3.0 - 2.0 * t)
  };

  /// Height map sample
  public func worldHeightMapSample(
    x : Float, y : Float,
    octaves : Nat,
    persistence : Float,
    lacunarity : Float,
    seed : Nat
  ) : Float {
    var total : Float = 0.0;
    var amplitude : Float = 1.0;
    var frequency : Float = 1.0;
    var maxVal : Float = 0.0;
    var i = 0;
    while (i < octaves) {
      let xi = Int.abs(Float.toInt(x * frequency));
      let yi = Int.abs(Float.toInt(y * frequency));
      total += worldSimpleNoise(xi, yi, seed + i) * amplitude;
      maxVal += amplitude;
      amplitude *= persistence;
      frequency *= lacunarity;
      i += 1;
    };
    total / maxVal
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // WEATHER SIMULATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Temperature model
  public func worldTemperature(
    baseTemp : Float,
    latitude : Float,
    altitude : Float,
    timeOfDay : Float
  ) : Float {
    let latFactor = Float.cos(latitude * 3.14159265 / 180.0) * 30.0;
    let altFactor = -altitude * 0.0065;
    let diurnalFactor = 5.0 * Float.sin((timeOfDay - 6.0) * 3.14159265 / 12.0);
    baseTemp + latFactor + altFactor + diurnalFactor
  };

  /// Wind speed from pressure gradient
  public func worldWindSpeed(
    pressureGradient : Float,
    coriolisFactor : Float,
    friction : Float
  ) : Float {
    pressureGradient / (coriolisFactor + friction + 0.01)
  };

  /// Precipitation probability
  public func worldPrecipitationProb(
    humidity : Float,
    temperature : Float,
    pressure : Float
  ) : Float {
    let saturation = humidity / (1.0 + Float.exp(-0.1 * (temperature - 10.0)));
    let instability = 1.0 / (pressure + 0.01);
    Float.min(saturation * instability * 2.0, 1.0)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESOURCE DISTRIBUTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Resource density based on terrain
  public func worldResourceDensity(
    terrainType : Nat,
    height : Float,
    moisture : Float
  ) : Float {
    let baseDensity = Float.fromInt(terrainType % 10) / 10.0;
    let heightFactor = 1.0 - Float.abs(height - 0.5);
    let moistureFactor = moisture;
    baseDensity * heightFactor * moistureFactor
  };

  /// Population growth model
  public func worldPopulationGrowth(
    population : Float,
    resources : Float,
    capacity : Float,
    growthRate : Float
  ) : Float {
    let resourceFactor = resources / (resources + 1.0);
    let carryingFactor = 1.0 - population / capacity;
    population * growthRate * resourceFactor * carryingFactor
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SPATIAL INDEXING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Grid cell index from position
  public func worldGridIndex(x : Float, y : Float, cellSize : Float) : (Nat, Nat) {
    let ix = Int.abs(Float.toInt(x / cellSize));
    let iy = Int.abs(Float.toInt(y / cellSize));
    (ix, iy)
  };

  /// Distance between grid cells
  public func worldGridDistance(x1 : Nat, y1 : Nat, x2 : Nat, y2 : Nat) : Float {
    let dx = Float.fromInt(if (x1 > x2) x1 - x2 else x2 - x1);
    let dy = Float.fromInt(if (y1 > y2) y1 - y2 else y2 - y1);
    Float.sqrt(dx * dx + dy * dy)
  };

  /// Morton code for Z-order curve
  public func worldMortonCode(x : Nat, y : Nat) : Nat {
    var mx = x;
    var my = y;
    var code : Nat = 0;
    var bit : Nat = 0;
    while (bit < 16) {
      code += ((mx % 2) * 2 + (my % 2)) * (4 ** bit);
      mx /= 2;
      my /= 2;
      bit += 1;
    };
    code
  };

}
