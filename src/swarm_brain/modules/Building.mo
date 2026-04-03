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
// ║    - Load distribution follows φ ratios                                  ║
// ║    - Column spacing at φ intervals                                       ║
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
  
  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let π : Float = 3.1415926535897932385;
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

}
