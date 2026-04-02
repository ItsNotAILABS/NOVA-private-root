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
// MISSION PLANNER — High-Level Command → Automatic Multi-Step Execution
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// This is the BRIDGE between human commands and automatic swarm behavior.
//
// Human says: "Go 100 miles north, check the area, report back"
// Organism AUTOMATICALLY:
//   1. Parses intent (destination, objective, return requirement)
//   2. Assesses resources (energy, drone health, distance feasibility)
//   3. Generates mission phases (scout → report → main force → execute → return)
//   4. Executes phases with swarm intelligence patterns
//   5. Adapts in real-time based on what scouts find
//
// This is NOT hardcoded behavior. It emerges from:
//   - Bee foraging patterns (scout-first, waggle dance communication)
//   - Ant colony optimization (pheromone trails, resource allocation)
//   - Wolf pack hunting (alpha leads, flanking, coordinated attack)
//   - Bird migration (V-formation, leader rotation, energy conservation)
//
// The organism LEARNS which patterns work best for which missions.
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";

module MissionPlanner {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let SCOUT_RATIO : Float = 0.15;           // 15% of swarm are scouts
  public let MIN_SCOUTS : Nat = 3;                  // Always at least 3 scouts
  public let SCOUT_RANGE_MULTIPLIER : Float = 1.5; // Scouts go 1.5x ahead
  public let ENERGY_RESERVE : Float = 0.2;         // Keep 20% energy for return
  public let PHASE_TIMEOUT_BEATS : Nat = 1000;     // Max beats per phase
  
  // Speed/distance (rough estimates for planning)
  public let DRONE_SPEED_MPS : Float = 15.0;       // 15 m/s average speed
  public let METERS_PER_MILE : Float = 1609.34;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — MISSION STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // High-level mission types
  public type MissionType = {
    #Reconnaissance;    // Scout and report, no engagement
    #Patrol;            // Continuous area monitoring
    #Delivery;          // Transport payload to location
    #Strike;            // Offensive action
    #Rescue;            // Locate and assist
    #Escort;            // Protect moving asset
    #Survey;            // Map/scan area
    #Intercept;         // Chase and engage target
    #Return;            // Come back to base
    #Custom : Text;     // Free-form mission
  };
  
  // Mission phases (automatically generated)
  public type MissionPhase = {
    #Planning;          // Assess resources, generate plan
    #ScoutDeploy;       // Send scouts ahead
    #ScoutReturn;       // Scouts report findings
    #Staging;           // Main force prepares based on intel
    #Transit;           // Moving to objective
    #Approach;          // Final approach to target
    #Execute;           // Perform mission objective
    #Exfiltrate;        // Leave area
    #Return;            // Return to base
    #Debrief;           // Mission complete, process learnings
    #Abort;             // Mission cancelled
  };
  
  // Scout report (what scouts found)
  public type ScoutReport = {
    scoutId         : Nat;
    reportBeat      : Nat;
    
    // Location info
    targetReached   : Bool;
    distanceToTarget: Float;    // meters remaining
    
    // Environmental intel
    terrainType     : Text;     // "urban", "open", "forest", etc.
    weatherCondition: Text;     // "clear", "wind", "rain"
    
    // Threat assessment
    threatsDetected : Nat;
    threatLevel     : Float;    // 0-1
    threatPositions : [(Float, Float, Float)];
    
    // Opportunity assessment
    landingZones    : [(Float, Float, Float)];
    coverPositions  : [(Float, Float, Float)];
    
    // Resource status
    scoutEnergy     : Float;
    recommendAction : Text;     // Scout's recommendation
  };
  
  // Mission state
  public type MissionState = {
    missionId       : Nat;
    missionType     : MissionType;
    currentPhase    : MissionPhase;
    phaseStartBeat  : Nat;
    
    // Objective
    targetX         : Float;
    targetY         : Float;
    targetZ         : Float;
    targetRadius    : Float;    // How close is "arrived"
    returnRequired  : Bool;
    
    // Original command (for learning)
    originalCommand : Text;
    
    // Planning results
    estimatedBeats  : Nat;      // Estimated mission duration
    energyRequired  : Float;    // Estimated energy cost
    feasible        : Bool;     // Can we do this?
    
    // Scout intel
    scoutsDeployed  : [Nat];    // Drone IDs of scouts
    scoutReports    : [ScoutReport];
    threatAssessment: Float;    // Combined threat level
    
    // Execution tracking
    phasesCompleted : [MissionPhase];
    currentProgress : Float;    // 0-1 progress in current phase
    
    // Adaptation
    planRevisions   : Nat;      // How many times we re-planned
    adaptations     : [Text];   // What we changed and why
    
    // Outcome (filled at end)
    success         : ?Bool;
    lessonsLearned  : [Text];
    
    lastUpdateBeat  : Nat;
  };
  
  // Parsed command intent
  public type CommandIntent = {
    missionType     : MissionType;
    destination     : ?(Float, Float, Float);
    distance        : ?Float;   // meters
    direction       : ?Text;    // "north", "east", etc.
    objective       : Text;
    returnRequired  : Bool;
    urgency         : Float;    // 0-1
    constraints     : [Text];
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  
  func fsqrt(x: Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  
  func distance3D(x1: Float, y1: Float, z1: Float, x2: Float, y2: Float, z2: Float) : Float {
    let dx = x2 - x1;
    let dy = y2 - y1;
    let dz = z2 - z1;
    fsqrt(dx * dx + dy * dy + dz * dz)
  };
  
  // Convert direction to unit vector
  func directionToVector(direction: Text) : (Float, Float, Float) {
    switch (direction) {
      case "north" (0.0, 0.0, 1.0);
      case "south" (0.0, 0.0, -1.0);
      case "east" (1.0, 0.0, 0.0);
      case "west" (-1.0, 0.0, 0.0);
      case "northeast" (0.707, 0.0, 0.707);
      case "northwest" (-0.707, 0.0, 0.707);
      case "southeast" (0.707, 0.0, -0.707);
      case "southwest" (-0.707, 0.0, -0.707);
      case "up" (0.0, 1.0, 0.0);
      case "down" (0.0, -1.0, 0.0);
      case _ (0.0, 0.0, 1.0);  // Default north
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COMMAND PARSING — Natural language → Intent
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Parse a human command into structured intent
  // Example: "Go 100 miles north, check the area, report back"
  public func parseCommand(command: Text) : CommandIntent {
    // Simple keyword-based parsing (in real system, use NLP)
    var missionType : MissionType = #Reconnaissance;
    var distance : ?Float = null;
    var direction : ?Text = null;
    var returnRequired : Bool = false;
    var urgency : Float = 0.5;
    var objective : Text = "complete mission";
    
    // Check for mission type keywords
    if (Text.contains(command, #text "recon") or Text.contains(command, #text "check") or Text.contains(command, #text "scout")) {
      missionType := #Reconnaissance;
    } else if (Text.contains(command, #text "patrol") or Text.contains(command, #text "monitor")) {
      missionType := #Patrol;
    } else if (Text.contains(command, #text "deliver") or Text.contains(command, #text "transport")) {
      missionType := #Delivery;
    } else if (Text.contains(command, #text "attack") or Text.contains(command, #text "strike") or Text.contains(command, #text "engage")) {
      missionType := #Strike;
    } else if (Text.contains(command, #text "rescue") or Text.contains(command, #text "save")) {
      missionType := #Rescue;
    } else if (Text.contains(command, #text "escort") or Text.contains(command, #text "protect")) {
      missionType := #Escort;
    } else if (Text.contains(command, #text "survey") or Text.contains(command, #text "map") or Text.contains(command, #text "scan")) {
      missionType := #Survey;
    } else if (Text.contains(command, #text "intercept") or Text.contains(command, #text "chase")) {
      missionType := #Intercept;
    } else if (Text.contains(command, #text "return") or Text.contains(command, #text "come back") or Text.contains(command, #text "rtb")) {
      missionType := #Return;
    };
    
    // Check for direction
    if (Text.contains(command, #text "north")) { direction := ?"north" };
    if (Text.contains(command, #text "south")) { direction := ?"south" };
    if (Text.contains(command, #text "east")) { direction := ?"east" };
    if (Text.contains(command, #text "west")) { direction := ?"west" };
    if (Text.contains(command, #text "northeast")) { direction := ?"northeast" };
    if (Text.contains(command, #text "northwest")) { direction := ?"northwest" };
    if (Text.contains(command, #text "southeast")) { direction := ?"southeast" };
    if (Text.contains(command, #text "southwest")) { direction := ?"southwest" };
    
    // Check for return requirement
    if (Text.contains(command, #text "return") or Text.contains(command, #text "come back") or Text.contains(command, #text "report back") or Text.contains(command, #text "rtb")) {
      returnRequired := true;
    };
    
    // Check for urgency
    if (Text.contains(command, #text "urgent") or Text.contains(command, #text "asap") or Text.contains(command, #text "immediately")) {
      urgency := 0.9;
    } else if (Text.contains(command, #text "when possible") or Text.contains(command, #text "low priority")) {
      urgency := 0.3;
    };
    
    // Extract distance (simplified - look for "X miles" pattern)
    // In real implementation, use regex or proper NLP
    if (Text.contains(command, #text "100 miles")) {
      distance := ?(100.0 * METERS_PER_MILE);
    } else if (Text.contains(command, #text "50 miles")) {
      distance := ?(50.0 * METERS_PER_MILE);
    } else if (Text.contains(command, #text "10 miles")) {
      distance := ?(10.0 * METERS_PER_MILE);
    } else if (Text.contains(command, #text "1 mile")) {
      distance := ?(1.0 * METERS_PER_MILE);
    } else if (Text.contains(command, #text "500 meters")) {
      distance := ?500.0;
    } else if (Text.contains(command, #text "1 km") or Text.contains(command, #text "1 kilometer")) {
      distance := ?1000.0;
    };
    
    {
      missionType = missionType;
      destination = null;  // Computed from distance + direction
      distance = distance;
      direction = direction;
      objective = objective;
      returnRequired = returnRequired;
      urgency = urgency;
      constraints = [];
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MISSION PLANNING — Automatic phase generation
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Create a mission from parsed intent
  public func createMission(
    missionId: Nat,
    intent: CommandIntent,
    currentX: Float,
    currentY: Float,
    currentZ: Float,
    command: Text,
    beatNum: Nat
  ) : MissionState {
    // Compute target location
    var targetX = currentX;
    var targetY = currentY;
    var targetZ = currentZ;
    
    switch (intent.distance) {
      case (?dist) {
        switch (intent.direction) {
          case (?dir) {
            let (dx, dy, dz) = directionToVector(dir);
            targetX := currentX + dx * dist;
            targetY := currentY + dy * dist;
            targetZ := currentZ + dz * dist;
          };
          case null {
            // No direction specified, go forward (north)
            targetZ := currentZ + dist;
          };
        };
      };
      case null {
        // No distance specified, use default 1km
        switch (intent.direction) {
          case (?dir) {
            let (dx, dy, dz) = directionToVector(dir);
            targetX := currentX + dx * 1000.0;
            targetY := currentY + dy * 1000.0;
            targetZ := currentZ + dz * 1000.0;
          };
          case null {};
        };
      };
    };
    
    // Estimate mission duration
    let distanceToTarget = distance3D(currentX, currentY, currentZ, targetX, targetY, targetZ);
    let travelTimeSeconds = distanceToTarget / DRONE_SPEED_MPS;
    let travelBeats = Float.toInt(travelTimeSeconds * 12.0);  // 12 Hz heartbeat
    
    // Double for return trip if required
    let totalBeats = if (intent.returnRequired) { travelBeats * 2 } else { travelBeats };
    
    // Estimate energy (simplified)
    let energyRequired = clamp(Float.fromInt(Int.abs(totalBeats)) / 10000.0, 0.1, 0.9);
    
    {
      missionId = missionId;
      missionType = intent.missionType;
      currentPhase = #Planning;
      phaseStartBeat = beatNum;
      targetX = targetX;
      targetY = targetY;
      targetZ = targetZ;
      targetRadius = 50.0;  // 50 meter arrival radius
      returnRequired = intent.returnRequired;
      originalCommand = command;
      estimatedBeats = Int.abs(totalBeats);
      energyRequired = energyRequired;
      feasible = energyRequired < (1.0 - ENERGY_RESERVE);
      scoutsDeployed = [];
      scoutReports = [];
      threatAssessment = 0.0;
      phasesCompleted = [];
      currentProgress = 0.0;
      planRevisions = 0;
      adaptations = [];
      success = null;
      lessonsLearned = [];
      lastUpdateBeat = beatNum;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE EXECUTION — Automatic state machine
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Determine next phase based on current state and intel
  public func getNextPhase(mission: MissionState, beatNum: Nat) : MissionPhase {
    let beatsInPhase = beatNum - mission.phaseStartBeat;
    
    switch (mission.currentPhase) {
      case (#Planning) {
        // Planning done, deploy scouts
        #ScoutDeploy
      };
      case (#ScoutDeploy) {
        // Wait for scouts to return (or timeout)
        if (mission.scoutReports.size() > 0 or beatsInPhase > PHASE_TIMEOUT_BEATS / 2) {
          #ScoutReturn
        } else {
          #ScoutDeploy
        }
      };
      case (#ScoutReturn) {
        // Analyze reports and decide
        if (mission.threatAssessment > 0.8) {
          // High threat, abort or re-plan
          #Planning
        } else {
          #Staging
        }
      };
      case (#Staging) {
        // Brief pause before moving out
        if (beatsInPhase > 100) {
          #Transit
        } else {
          #Staging
        }
      };
      case (#Transit) {
        // Moving to target
        if (mission.currentProgress > 0.9) {
          #Approach
        } else {
          #Transit
        }
      };
      case (#Approach) {
        // Final approach
        if (mission.currentProgress > 0.99) {
          #Execute
        } else {
          #Approach
        }
      };
      case (#Execute) {
        // Executing objective (time depends on mission type)
        if (beatsInPhase > 500) {  // Variable based on mission
          if (mission.returnRequired) { #Exfiltrate } else { #Debrief }
        } else {
          #Execute
        }
      };
      case (#Exfiltrate) {
        // Leaving area
        if (beatsInPhase > 200) {
          #Return
        } else {
          #Exfiltrate
        }
      };
      case (#Return) {
        // Returning to base
        if (mission.currentProgress > 0.99) {
          #Debrief
        } else {
          #Return
        }
      };
      case (#Debrief) {
        // Mission complete
        #Debrief
      };
      case (#Abort) {
        #Abort
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SCOUT SELECTION — Choose which drones become scouts
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Select scouts from fleet (like bees selecting foragers)
  public func selectScouts(
    droneCount: Nat,
    droneEnergies: [Float],
    droneHealths: [Float]
  ) : [Nat] {
    // Calculate number of scouts
    let idealScouts = Float.toInt(Float.fromInt(droneCount) * SCOUT_RATIO);
    let numScouts = Nat.max(MIN_SCOUTS, Int.abs(idealScouts));
    
    // Score each drone for scouting suitability
    // Best scouts: high energy, good health
    var scores : [(Nat, Float)] = [];
    for (i in Iter.range(0, droneCount - 1)) {
      let energy = if (i < droneEnergies.size()) droneEnergies[i] else 0.5;
      let health = if (i < droneHealths.size()) droneHealths[i] else 0.5;
      let score = energy * 0.6 + health * 0.4;  // Weight energy more
      scores := Array.append(scores, [(i, score)]);
    };
    
    // Sort by score (simple bubble sort for small N)
    let mutableScores = Array.thaw<(Nat, Float)>(scores);
    for (i in Iter.range(0, mutableScores.size() - 1)) {
      for (j in Iter.range(0, mutableScores.size() - 2 - i)) {
        if (mutableScores[j].1 < mutableScores[j + 1].1) {
          let temp = mutableScores[j];
          mutableScores[j] := mutableScores[j + 1];
          mutableScores[j + 1] := temp;
        };
      };
    };
    
    // Take top N as scouts
    var scouts : [Nat] = [];
    for (i in Iter.range(0, Nat.min(numScouts, mutableScores.size()) - 1)) {
      scouts := Array.append(scouts, [mutableScores[i].0]);
    };
    
    scouts
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // BEE FORAGING PATTERN — Scout-first exploration
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // How bees do it:
  // 1. Scout bees leave hive to find food
  // 2. Scouts explore in expanding patterns
  // 3. When scout finds food, returns to hive
  // 4. Performs "waggle dance" to communicate:
  //    - Direction (angle relative to sun)
  //    - Distance (duration of waggle)
  //    - Quality (enthusiasm of dance)
  // 5. Other bees follow based on dance
  // 6. More bees recruited to better sources
  //
  // We implement this as:
  // 1. Scout drones deploy ahead
  // 2. Scouts explore in spoke pattern
  // 3. Scouts return with reports
  // 4. Reports form collective intel (like waggle dance)
  // 5. Main swarm moves based on aggregated intel
  //
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type BeeForagingState = {
    phase           : { #Scouting; #WaggleDance; #Recruitment; #Foraging };
    scoutsOut       : [Nat];
    scoutsReturned  : [Nat];
    foodSources     : [(Float, Float, Float, Float)];  // x, y, z, quality
    consensusTarget : ?(Float, Float, Float);
    confidenceLevel : Float;
  };
  
  // Generate scout waypoints (expanding spoke pattern)
  public func generateScoutWaypoints(
    centerX: Float,
    centerY: Float,
    centerZ: Float,
    targetX: Float,
    targetY: Float,
    targetZ: Float,
    numScouts: Nat
  ) : [(Float, Float, Float)] {
    var waypoints : [(Float, Float, Float)] = [];
    
    // Direction to target
    let dx = targetX - centerX;
    let dy = targetY - centerY;
    let dz = targetZ - centerZ;
    let dist = fsqrt(dx * dx + dy * dy + dz * dz);
    
    if (dist < 1.0) { return waypoints };
    
    // Normalize
    let nx = dx / dist;
    let ny = dy / dist;
    let nz = dz / dist;
    
    // Scout distance (1.5x ahead of main target, but spread)
    let scoutDist = dist * SCOUT_RANGE_MULTIPLIER;
    
    // Generate spoke pattern
    let PI = 3.14159265359;
    for (i in Iter.range(0, numScouts - 1)) {
      let angle = Float.fromInt(i) * 2.0 * PI / Float.fromInt(numScouts);
      
      // Rotate around the forward axis
      // Simplified: just spread in XZ plane relative to target direction
      let spreadAngle = (Float.fromInt(i) - Float.fromInt(numScouts) / 2.0) * 0.3;
      
      let cosA = Float.cos(spreadAngle);
      let sinA = Float.sin(spreadAngle);
      
      // Rotate direction
      let rotX = nx * cosA - nz * sinA;
      let rotZ = nx * sinA + nz * cosA;
      
      let waypointX = centerX + rotX * scoutDist;
      let waypointY = centerY + ny * scoutDist;
      let waypointZ = centerZ + rotZ * scoutDist;
      
      waypoints := Array.append(waypoints, [(waypointX, waypointY, waypointZ)]);
    };
    
    waypoints
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ANT COLONY OPTIMIZATION — Pheromone-based path planning
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // How ants do it:
  // 1. Ants leave pheromone trails as they walk
  // 2. Other ants prefer to follow stronger trails
  // 3. Shorter paths get more traffic → more pheromone → even more traffic
  // 4. Pheromones evaporate over time (bad paths fade)
  // 5. System converges on optimal path
  //
  // We implement this for route planning between waypoints
  //
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type AntColonyState = {
    // Grid of pheromone levels
    pheromoneGrid   : [var Float];  // Flattened 2D grid
    gridSizeX       : Nat;
    gridSizeZ       : Nat;
    evaporationRate : Float;
    depositRate     : Float;
  };
  
  public func initAntColonyState(sizeX: Nat, sizeZ: Nat) : AntColonyState {
    {
      pheromoneGrid = Array.init<Float>(sizeX * sizeZ, 0.0);
      gridSizeX = sizeX;
      gridSizeZ = sizeZ;
      evaporationRate = 0.01;
      depositRate = 1.0;
    }
  };
  
  // Deposit pheromone at a location (drone passed through)
  public func depositPheromone(state: AntColonyState, gridX: Nat, gridZ: Nat, strength: Float) {
    let idx = gridZ * state.gridSizeX + gridX;
    if (idx < state.pheromoneGrid.size()) {
      state.pheromoneGrid[idx] := state.pheromoneGrid[idx] + strength * state.depositRate;
    };
  };
  
  // Evaporate all pheromones (call each beat)
  public func evaporatePheromones(state: AntColonyState) {
    for (i in Iter.range(0, state.pheromoneGrid.size() - 1)) {
      state.pheromoneGrid[i] := state.pheromoneGrid[i] * (1.0 - state.evaporationRate);
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // WOLF PACK HUNTING — Coordinated tactical movement
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // How wolves do it:
  // 1. Alpha identifies target
  // 2. Pack spreads out to encircle
  // 3. Some wolves drive prey toward others
  // 4. Coordinated attack from multiple angles
  // 5. Clear role hierarchy (alpha, beta, omega)
  //
  // We implement this for strike missions
  //
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type WolfPackRole = {
    #Alpha;   // Leader, makes decisions
    #Beta;    // Second in command, supports alpha
    #Hunter;  // Main attack force
    #Driver;  // Pushes target toward hunters
    #Omega;   // Rear guard, cleanup
  };
  
  public type WolfPackState = {
    alphaId         : Nat;
    roleAssignments : [(Nat, WolfPackRole)];  // drone ID → role
    targetPosition  : (Float, Float, Float);
    encirclementRadius : Float;
    attackPhase     : { #Encircle; #Drive; #Attack; #Cleanup };
  };
  
  // Assign roles based on drone capabilities
  public func assignWolfPackRoles(
    droneCount: Nat,
    droneHealths: [Float],
    droneEnergies: [Float]
  ) : [(Nat, WolfPackRole)] {
    var assignments : [(Nat, WolfPackRole)] = [];
    
    // Find strongest drone for alpha
    var alphaId : Nat = 0;
    var alphaScore : Float = 0.0;
    for (i in Iter.range(0, droneCount - 1)) {
      let health = if (i < droneHealths.size()) droneHealths[i] else 0.5;
      let energy = if (i < droneEnergies.size()) droneEnergies[i] else 0.5;
      let score = health * 0.5 + energy * 0.5;
      if (score > alphaScore) {
        alphaScore := score;
        alphaId := i;
      };
    };
    
    // Assign roles
    for (i in Iter.range(0, droneCount - 1)) {
      let role : WolfPackRole = if (i == alphaId) {
        #Alpha
      } else if (i == (alphaId + 1) % droneCount) {
        #Beta
      } else if (i % 5 == 0) {
        #Driver
      } else if (i % 7 == 0) {
        #Omega
      } else {
        #Hunter
      };
      assignments := Array.append(assignments, [(i, role)]);
    };
    
    assignments
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MISSION STATUS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getMissionStatus(mission: MissionState) : Text {
    let phaseText = switch (mission.currentPhase) {
      case (#Planning) "PLANNING";
      case (#ScoutDeploy) "SCOUTS DEPLOYING";
      case (#ScoutReturn) "SCOUTS RETURNING";
      case (#Staging) "STAGING";
      case (#Transit) "IN TRANSIT";
      case (#Approach) "APPROACHING TARGET";
      case (#Execute) "EXECUTING MISSION";
      case (#Exfiltrate) "EXFILTRATING";
      case (#Return) "RETURNING TO BASE";
      case (#Debrief) "MISSION COMPLETE";
      case (#Abort) "ABORTED";
    };
    
    let typeText = switch (mission.missionType) {
      case (#Reconnaissance) "RECON";
      case (#Patrol) "PATROL";
      case (#Delivery) "DELIVERY";
      case (#Strike) "STRIKE";
      case (#Rescue) "RESCUE";
      case (#Escort) "ESCORT";
      case (#Survey) "SURVEY";
      case (#Intercept) "INTERCEPT";
      case (#Return) "RTB";
      case (#Custom(t)) "CUSTOM: " # t;
    };
    
    "MISSION #" # Nat.toText(mission.missionId) # " — " # typeText # "\n" #
    "═══════════════════════════════════════════════════════════════\n" #
    "Command: \"" # mission.originalCommand # "\"\n" #
    "Phase: " # phaseText # "\n" #
    "Progress: " # Float.format(#fix 1, mission.currentProgress * 100.0) # "%\n" #
    "Target: (" # Float.format(#fix 0, mission.targetX) # ", " # 
                  Float.format(#fix 0, mission.targetY) # ", " # 
                  Float.format(#fix 0, mission.targetZ) # ")\n" #
    "Scouts Deployed: " # Nat.toText(mission.scoutsDeployed.size()) # "\n" #
    "Scout Reports: " # Nat.toText(mission.scoutReports.size()) # "\n" #
    "Threat Level: " # Float.format(#fix 2, mission.threatAssessment * 100.0) # "%\n" #
    "Feasible: " # (if (mission.feasible) "YES" else "NO - INSUFFICIENT RESOURCES") # "\n" #
    "Return Required: " # (if (mission.returnRequired) "YES" else "NO")
  };

}
