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
// ATLAS TERRITORY GRID — 64×64 Sovereignty & Stigmergy System
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// ATLAS manages a 4096-cell territory grid for:
// - Faction occupancy tracking
// - Pheromone-based stigmergy (ant-colony inspired)
// - Sovereignty mapping
// - Resource allocation
//
// 100% of all token mints route to Creator Reserve. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module AtlasTerritoryGrid {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI           : Float = 1.6180339887498948482;
  public let PI            : Float = 3.1415926535897932385;
  
  public let GRID_SIZE     : Nat = 64;
  public let GRID_CELLS    : Nat = 4096;  // 64 × 64
  
  // Pheromone parameters
  public let EVAPORATION_RATE : Float = 0.02;   // 2% decay per beat
  public let DIFFUSION_RATE   : Float = 0.1;    // 10% spread to neighbors
  public let MAX_PHEROMONE    : Float = 5.0;
  public let DEPOSIT_BASE     : Float = 0.1;
  
  // Sovereignty parameters
  public let SOVEREIGNTY_DECAY : Float = 0.01;
  public let CLAIM_THRESHOLD   : Float = 0.5;
  public let CONTEST_THRESHOLD : Float = 0.3;
  
  // Faction IDs
  public let FACTION_NEUTRAL : Nat = 0;
  public let FACTION_ALPHA   : Nat = 1;
  public let FACTION_BETA    : Nat = 2;
  public let FACTION_GAMMA   : Nat = 3;
  public let FACTION_DELTA   : Nat = 4;
  public let FACTION_OMEGA   : Nat = 5;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Pheromone types
  public type PheromoneType = {
    #Food;      // Resource location
    #Danger;    // Threat warning
    #Home;      // Return path
    #Recruit;   // Call for reinforcement
    #Territory; // Sovereignty claim
  };
  
  // Pheromone layer
  public type PheromoneLayer = {
    food        : [Float];
    danger      : [Float];
    home        : [Float];
    recruit     : [Float];
    territory   : [Float];
  };
  
  // Single cell state
  public type CellState = {
    x           : Nat;
    y           : Nat;
    occupancy   : Float;        // [0, 1] - how occupied
    sovereignty : Float;        // [0, 1] - how claimed
    faction     : Nat;          // Which faction claims it
    contested   : Bool;         // Multiple factions contesting
    resourceLevel : Float;      // Available resources
    elevation   : Float;        // Terrain height
    traversable : Bool;         // Can units pass through
  };
  
  // Faction territory summary
  public type FactionTerritory = {
    faction     : Nat;
    cellCount   : Nat;
    totalOccupancy : Float;
    totalSovereignty : Float;
    center      : (Float, Float);  // Centroid
    contestedCells : Nat;
  };
  
  // Movement cost
  public type MovementCost = {
    baseCost    : Float;
    terrainMod  : Float;
    pheromoneBonus : Float;
    totalCost   : Float;
  };
  
  // Path through grid
  public type GridPath = {
    cells       : [(Nat, Nat)];
    totalCost   : Float;
    pheromoneSum: Float;
  };
  
  // Complete ATLAS state
  public type AtlasState = {
    cells       : [CellState];
    pheromones  : PheromoneLayer;
    factionData : [FactionTerritory];
    totalSovereignty : Float;
    contestedCellCount : Nat;
    lastUpdate  : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func clamp(v : Float, lo : Float, hi : Float) : Float {
    if (v < lo) lo else if (v > hi) hi else v
  };
  
  public func abs(v : Float) : Float {
    if (v < 0.0) -v else v
  };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var i = 0;
    while (i < 10) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };
  
  public func sin(x : Float) : Float {
    var normalized = x;
    while (normalized > PI) { normalized -= 2.0 * PI };
    while (normalized < -PI) { normalized += 2.0 * PI };
    let x2 = normalized * normalized;
    let x3 = x2 * normalized;
    let x5 = x3 * x2;
    let x7 = x5 * x2;
    normalized - x3/6.0 + x5/120.0 - x7/5040.0
  };
  
  public func cos(x : Float) : Float {
    sin(x + PI/2.0)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // COORDINATE UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Convert (x, y) to flat index
  public func coordToIndex(x : Nat, y : Nat) : Nat {
    y * GRID_SIZE + x
  };
  
  // Convert flat index to (x, y)
  public func indexToCoord(idx : Nat) : (Nat, Nat) {
    (idx % GRID_SIZE, idx / GRID_SIZE)
  };
  
  // Check if coordinate is valid
  public func isValidCoord(x : Nat, y : Nat) : Bool {
    x < GRID_SIZE and y < GRID_SIZE
  };
  
  // Get neighbors (4-connected)
  public func getNeighbors4(x : Nat, y : Nat) : [(Nat, Nat)] {
    let buf = Buffer.Buffer<(Nat, Nat)>(4);
    if (x > 0) buf.add((x - 1, y));
    if (x + 1 < GRID_SIZE) buf.add((x + 1, y));
    if (y > 0) buf.add((x, y - 1));
    if (y + 1 < GRID_SIZE) buf.add((x, y + 1));
    Buffer.toArray(buf)
  };
  
  // Get neighbors (8-connected)
  public func getNeighbors8(x : Nat, y : Nat) : [(Nat, Nat)] {
    let buf = Buffer.Buffer<(Nat, Nat)>(8);
    var dy : Int = -1;
    while (dy <= 1) {
      var dx : Int = -1;
      while (dx <= 1) {
        if (dx != 0 or dy != 0) {
          let nx = Int.abs(x) + dx;
          let ny = Int.abs(y) + dy;
          if (nx >= 0 and nx < GRID_SIZE and ny >= 0 and ny < GRID_SIZE) {
            buf.add((Int.abs(nx), Int.abs(ny)));
          };
        };
        dx += 1;
      };
      dy += 1;
    };
    Buffer.toArray(buf)
  };
  
  // Euclidean distance between cells
  public func cellDistance(x1 : Nat, y1 : Nat, x2 : Nat, y2 : Nat) : Float {
    let dx = Float.fromInt(Int.abs(x1 - x2));
    let dy = Float.fromInt(Int.abs(y1 - y2));
    sqrt(dx * dx + dy * dy)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize single cell
  public func initCell(x : Nat, y : Nat) : CellState {
    // Generate terrain from position
    let xf = Float.fromInt(x) / Float.fromInt(GRID_SIZE);
    let yf = Float.fromInt(y) / Float.fromInt(GRID_SIZE);
    
    // Perlin-like noise approximation
    let elevation = 0.5 + 0.3 * sin(xf * PI * 4.0) * cos(yf * PI * 4.0);
    
    // Resources concentrated in center
    let distFromCenter = sqrt((xf - 0.5) * (xf - 0.5) + (yf - 0.5) * (yf - 0.5));
    let resources = if (distFromCenter < 0.3) 1.0 - distFromCenter * 2.0 else 0.2;
    
    {
      x = x;
      y = y;
      occupancy = 0.0;
      sovereignty = 0.0;
      faction = FACTION_NEUTRAL;
      contested = false;
      resourceLevel = resources;
      elevation = elevation;
      traversable = elevation < 0.9;  // High mountains not traversable
    }
  };
  
  // Initialize all cells
  public func initCells() : [CellState] {
    Array.tabulate<CellState>(GRID_CELLS, func(i : Nat) : CellState {
      let (x, y) = indexToCoord(i);
      initCell(x, y)
    })
  };
  
  // Initialize pheromone layers
  public func initPheromones() : PheromoneLayer {
    let zeros = Array.tabulate<Float>(GRID_CELLS, func(_ : Nat) : Float { 0.0 });
    {
      food = zeros;
      danger = zeros;
      home = zeros;
      recruit = zeros;
      territory = zeros;
    }
  };
  
  // Initialize complete ATLAS
  public func initAtlas() : AtlasState {
    {
      cells = initCells();
      pheromones = initPheromones();
      factionData = [];
      totalSovereignty = 0.0;
      contestedCellCount = 0;
      lastUpdate = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PHEROMONE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Evaporate pheromone layer
  public func evaporateLayer(layer : [Float], rate : Float) : [Float] {
    Array.tabulate<Float>(GRID_CELLS, func(i : Nat) : Float {
      layer[i] * (1.0 - rate)
    })
  };
  
  // Diffuse pheromone to neighbors
  public func diffuseLayer(layer : [Float], rate : Float) : [Float] {
    var newLayer = Array.init<Float>(GRID_CELLS, 0.0);
    
    var i = 0;
    while (i < GRID_CELLS) {
      let (x, y) = indexToCoord(i);
      let neighbors = getNeighbors4(x, y);
      
      // Keep most, spread some to neighbors
      let keep = layer[i] * (1.0 - rate);
      let spread = layer[i] * rate / Float.fromInt(neighbors.size());
      
      newLayer[i] += keep;
      for ((nx, ny) in neighbors.vals()) {
        let nIdx = coordToIndex(nx, ny);
        newLayer[nIdx] += spread;
      };
      
      i += 1;
    };
    
    // Clamp values
    Array.tabulate<Float>(GRID_CELLS, func(j : Nat) : Float {
      clamp(newLayer[j], 0.0, MAX_PHEROMONE)
    })
  };
  
  // Deposit pheromone at location
  public func depositPheromone(
    layer : [Float],
    x : Nat,
    y : Nat,
    amount : Float
  ) : [Float] {
    let idx = coordToIndex(x, y);
    Array.tabulate<Float>(GRID_CELLS, func(i : Nat) : Float {
      if (i == idx) clamp(layer[i] + amount, 0.0, MAX_PHEROMONE)
      else layer[i]
    })
  };
  
  // Update all pheromone layers
  public func updatePheromones(pheromones : PheromoneLayer) : PheromoneLayer {
    // Evaporate
    var food = evaporateLayer(pheromones.food, EVAPORATION_RATE);
    var danger = evaporateLayer(pheromones.danger, EVAPORATION_RATE * 1.5);  // Danger fades faster
    var home = evaporateLayer(pheromones.home, EVAPORATION_RATE * 0.5);  // Home fades slower
    var recruit = evaporateLayer(pheromones.recruit, EVAPORATION_RATE * 2.0);  // Recruit fades fast
    var territory = evaporateLayer(pheromones.territory, EVAPORATION_RATE * 0.3);  // Territory persistent
    
    // Diffuse
    food := diffuseLayer(food, DIFFUSION_RATE);
    danger := diffuseLayer(danger, DIFFUSION_RATE);
    home := diffuseLayer(home, DIFFUSION_RATE * 0.5);
    recruit := diffuseLayer(recruit, DIFFUSION_RATE * 1.5);
    territory := diffuseLayer(territory, DIFFUSION_RATE * 0.3);
    
    { food; danger; home; recruit; territory }
  };
  
  // Read pheromone at location
  public func readPheromone(
    pheromones : PheromoneLayer,
    pType : PheromoneType,
    x : Nat,
    y : Nat
  ) : Float {
    let idx = coordToIndex(x, y);
    if (idx >= GRID_CELLS) return 0.0;
    
    switch (pType) {
      case (#Food) pheromones.food[idx];
      case (#Danger) pheromones.danger[idx];
      case (#Home) pheromones.home[idx];
      case (#Recruit) pheromones.recruit[idx];
      case (#Territory) pheromones.territory[idx];
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SOVEREIGNTY OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Claim cell for faction
  public func claimCell(
    cell : CellState,
    faction : Nat,
    strength : Float
  ) : CellState {
    if (cell.faction == faction) {
      // Strengthen existing claim
      { cell with
        sovereignty = clamp(cell.sovereignty + strength, 0.0, 1.0);
        contested = false;
      }
    } else if (cell.faction == FACTION_NEUTRAL) {
      // New claim on neutral territory
      { cell with
        faction = faction;
        sovereignty = strength;
        contested = false;
      }
    } else {
      // Contest existing claim
      let newSov = cell.sovereignty - strength;
      if (newSov <= 0.0) {
        // Takeover
        { cell with
          faction = faction;
          sovereignty = -newSov;  // Remaining strength becomes new sovereignty
          contested = false;
        }
      } else {
        { cell with
          sovereignty = newSov;
          contested = true;
        }
      }
    }
  };
  
  // Decay sovereignty naturally
  public func decaySovereignty(cell : CellState) : CellState {
    let newSov = cell.sovereignty * (1.0 - SOVEREIGNTY_DECAY);
    if (newSov < 0.01) {
      { cell with
        sovereignty = 0.0;
        faction = FACTION_NEUTRAL;
        contested = false;
      }
    } else {
      { cell with sovereignty = newSov }
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FACTION ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Calculate faction territory data
  public func calculateFactionTerritory(
    cells : [CellState],
    faction : Nat
  ) : FactionTerritory {
    var count : Nat = 0;
    var totalOcc : Float = 0.0;
    var totalSov : Float = 0.0;
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var contested : Nat = 0;
    
    for (cell in cells.vals()) {
      if (cell.faction == faction) {
        count += 1;
        totalOcc += cell.occupancy;
        totalSov += cell.sovereignty;
        sumX += Float.fromInt(cell.x);
        sumY += Float.fromInt(cell.y);
        if (cell.contested) contested += 1;
      };
    };
    
    let centerX = if (count > 0) sumX / Float.fromInt(count) else 0.0;
    let centerY = if (count > 0) sumY / Float.fromInt(count) else 0.0;
    
    {
      faction = faction;
      cellCount = count;
      totalOccupancy = totalOcc;
      totalSovereignty = totalSov;
      center = (centerX, centerY);
      contestedCells = contested;
    }
  };
  
  // Get all faction territories
  public func getAllFactionTerritories(cells : [CellState]) : [FactionTerritory] {
    Array.tabulate<FactionTerritory>(6, func(f : Nat) : FactionTerritory {
      calculateFactionTerritory(cells, f)
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PATHFINDING
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Calculate movement cost for a cell
  public func getMovementCost(
    cell : CellState,
    pheromones : PheromoneLayer,
    x : Nat,
    y : Nat
  ) : MovementCost {
    if (not cell.traversable) {
      return {
        baseCost = 999.0;
        terrainMod = 0.0;
        pheromoneBonus = 0.0;
        totalCost = 999.0;
      };
    };
    
    let baseCost = 1.0;
    let terrainMod = cell.elevation * 0.5;  // Uphill costs more
    let dangerCost = readPheromone(pheromones, #Danger, x, y) * 0.3;
    let homeBonus = readPheromone(pheromones, #Home, x, y) * 0.1;
    
    let total = baseCost + terrainMod + dangerCost - homeBonus;
    
    {
      baseCost = baseCost;
      terrainMod = terrainMod;
      pheromoneBonus = homeBonus - dangerCost;
      totalCost = if (total < 0.1) 0.1 else total;
    }
  };
  
  // Simple greedy pathfinding (follow pheromone gradient)
  public func findPathGreedy(
    atlas : AtlasState,
    startX : Nat,
    startY : Nat,
    targetPheromone : PheromoneType,
    maxSteps : Nat
  ) : GridPath {
    let buf = Buffer.Buffer<(Nat, Nat)>(maxSteps);
    buf.add((startX, startY));
    
    var x = startX;
    var y = startY;
    var totalCost : Float = 0.0;
    var pherSum : Float = 0.0;
    var step = 0;
    
    while (step < maxSteps) {
      let neighbors = getNeighbors8(x, y);
      if (neighbors.size() == 0) {
        // Stuck
        step := maxSteps;
      } else {
        // Find neighbor with highest pheromone
        var bestX = x;
        var bestY = y;
        var bestPher : Float = 0.0;
        
        for ((nx, ny) in neighbors.vals()) {
          let pher = readPheromone(atlas.pheromones, targetPheromone, nx, ny);
          let nIdx = coordToIndex(nx, ny);
          if (pher > bestPher and atlas.cells[nIdx].traversable) {
            bestPher := pher;
            bestX := nx;
            bestY := ny;
          };
        };
        
        if (bestX == x and bestY == y) {
          // No progress
          step := maxSteps;
        } else {
          x := bestX;
          y := bestY;
          buf.add((x, y));
          
          let idx = coordToIndex(x, y);
          let cost = getMovementCost(atlas.cells[idx], atlas.pheromones, x, y);
          totalCost += cost.totalCost;
          pherSum += bestPher;
        };
      };
      step += 1;
    };
    
    {
      cells = Buffer.toArray(buf);
      totalCost = totalCost;
      pheromoneSum = pherSum;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FULL UPDATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Update entire ATLAS grid
  public func updateAtlas(
    atlas : AtlasState,
    factionActions : [(Nat, Nat, Nat, Float)],  // (faction, x, y, strength)
    shell3Coherence : Float,
    currentBeat : Nat
  ) : AtlasState {
    // Update pheromones
    var newPheromones = updatePheromones(atlas.pheromones);
    
    // Update cells
    var newCells = Array.init<CellState>(GRID_CELLS, initCell(0, 0));
    var i = 0;
    while (i < GRID_CELLS) {
      var cell = decaySovereignty(atlas.cells[i]);
      newCells[i] := cell;
      i += 1;
    };
    
    // Apply faction actions
    for ((faction, x, y, strength) in factionActions.vals()) {
      let idx = coordToIndex(x, y);
      if (idx < GRID_CELLS) {
        newCells[idx] := claimCell(newCells[idx], faction, strength);
        
        // Deposit territory pheromone
        newPheromones := { newPheromones with
          territory = depositPheromone(newPheromones.territory, x, y, strength * 0.5)
        };
      };
    };
    
    // Deposit coherence-based pheromone in center region
    let centerStart = GRID_SIZE / 4;
    let centerEnd = 3 * GRID_SIZE / 4;
    var cy = centerStart;
    while (cy < centerEnd) {
      var cx = centerStart;
      while (cx < centerEnd) {
        newPheromones := { newPheromones with
          home = depositPheromone(newPheromones.home, cx, cy, shell3Coherence * DEPOSIT_BASE)
        };
        cx += 1;
      };
      cy += 1;
    };
    
    // Calculate summary
    let factionData = getAllFactionTerritories(Array.freeze(newCells));
    
    var totalSov : Float = 0.0;
    var contestedCount : Nat = 0;
    for (cell in newCells.vals()) {
      totalSov += cell.sovereignty;
      if (cell.contested) contestedCount += 1;
    };
    
    {
      cells = Array.freeze(newCells);
      pheromones = newPheromones;
      factionData = factionData;
      totalSovereignty = totalSov;
      contestedCellCount = contestedCount;
      lastUpdate = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getDiagnostics(atlas : AtlasState) : {
    gridSize        : Nat;
    totalCells      : Nat;
    totalSovereignty: Float;
    contestedCells  : Nat;
    factionCounts   : [Nat];
    avgPheromone    : Float;
  } {
    var factionCounts = Array.init<Nat>(6, 0);
    for (cell in atlas.cells.vals()) {
      if (cell.faction < 6) factionCounts[cell.faction] += 1;
    };
    
    var pherSum : Float = 0.0;
    for (p in atlas.pheromones.food.vals()) { pherSum += p };
    for (p in atlas.pheromones.home.vals()) { pherSum += p };
    for (p in atlas.pheromones.territory.vals()) { pherSum += p };
    let avgPher = pherSum / Float.fromInt(GRID_CELLS * 3);
    
    {
      gridSize = GRID_SIZE;
      totalCells = GRID_CELLS;
      totalSovereignty = atlas.totalSovereignty;
      contestedCells = atlas.contestedCellCount;
      factionCounts = Array.freeze(factionCounts);
      avgPheromone = avgPher;
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
