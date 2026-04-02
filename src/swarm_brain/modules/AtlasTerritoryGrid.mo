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
};
