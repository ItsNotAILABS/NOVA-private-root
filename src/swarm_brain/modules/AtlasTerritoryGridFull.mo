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


// ============================================================================
// ATLAS 64×64 TERRITORY GRID + STIGMERGY
// ============================================================================
// PHASE F: 4096 cells with occupancy, pheromone, sovereignty, faction
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Rule: 100% of all value routes to creator reserve
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";

module AtlasTerritoryGridFull {
    
    // ========================================================================
    // ATLAS CONFIGURATION
    // ========================================================================
    // Grid: 64 × 64 = 4096 cells
    // Each cell: occupancy, pheromone, sovereignty, faction
    // Pheromone evaporation: 0.98 per beat
    // Pheromone deposit: proportional to local Shell 3 coherence
    // Occupancy feeds council resource allocation
    // Sovereignty aggregated into Shell 9 world model
    // ========================================================================
    
    public type AtlasCell = {
        occupancy: Float;           // 0-1 occupancy level
        pheromone: Float;           // Stigmergy pheromone level
        sovereignty: Float;         // 0-1 sovereignty claim
        faction: Nat;               // Faction ID (0 = neutral)
        lastUpdate: Nat;            // Beat of last update
    };
    
    public type AtlasState = {
        // 4096 cells (64 × 64 grid)
        cells: [AtlasCell];
        
        // Grid parameters
        gridWidth: Nat;             // 64
        gridHeight: Nat;            // 64
        
        // Pheromone dynamics
        evaporationRate: Float;     // 0.98 per beat
        depositRate: Float;         // Rate of pheromone deposit
        diffusionRate: Float;       // Rate of pheromone spread
        
        // Aggregated metrics
        totalOccupancy: Float;
        totalPheromone: Float;
        totalSovereignty: Float;
        dominantFaction: Nat;
        factionCounts: [Nat];       // Count per faction
        
        // Territory sovereignty for Shell 9
        shell9SovereigntyIndex: Float;
        
        // Beat tracking
        beatCount: Nat;
        lastUpdateBeat: Nat;
    };
    
    // ========================================================================
    // CELL OPERATIONS
    // ========================================================================
    
    // Get cell at (x, y) coordinates
    public func getCell(state: AtlasState, x: Nat, y: Nat) : AtlasCell {
        if (x >= state.gridWidth or y >= state.gridHeight) {
            return { occupancy = 0.0; pheromone = 0.0; sovereignty = 0.0; faction = 0; lastUpdate = 0 };
        };
        let idx = y * state.gridWidth + x;
        if (idx < state.cells.size()) {
            state.cells[idx]
        } else {
            { occupancy = 0.0; pheromone = 0.0; sovereignty = 0.0; faction = 0; lastUpdate = 0 }
        }
    };
    
    // Get cell index from coordinates
    public func getCellIndex(state: AtlasState, x: Nat, y: Nat) : Nat {
        y * state.gridWidth + x
    };
    
    // Get coordinates from cell index
    public func getCoordinates(state: AtlasState, idx: Nat) : (Nat, Nat) {
        let x = idx % state.gridWidth;
        let y = idx / state.gridWidth;
        (x, y)
    };
    
    // Get neighboring cell indices (8-connectivity)
    public func getNeighbors(state: AtlasState, x: Nat, y: Nat) : [Nat] {
        let buffer = Buffer.Buffer<Nat>(8);
        
        // 8 directions: N, NE, E, SE, S, SW, W, NW
        let offsets : [(Int, Int)] = [
            (0, -1), (1, -1), (1, 0), (1, 1),
            (0, 1), (-1, 1), (-1, 0), (-1, -1)
        ];
        
        for ((dx, dy) in offsets.vals()) {
            let nx = Int.abs(Int.fromNat(x) + dx);
            let ny = Int.abs(Int.fromNat(y) + dy);
            if (nx < state.gridWidth and ny < state.gridHeight) {
                buffer.add(getCellIndex(state, nx, ny));
            };
        };
        
        Buffer.toArray(buffer)
    };
    
    // ========================================================================
    // PHEROMONE DYNAMICS
    // ========================================================================
    
    // Evaporate pheromones across grid
    public func evaporatePheromones(state: AtlasState) : [AtlasCell] {
        Array.tabulate<AtlasCell>(state.cells.size(), func(idx: Nat) : AtlasCell {
            let cell = state.cells[idx];
            {
                occupancy = cell.occupancy;
                pheromone = cell.pheromone * state.evaporationRate;
                sovereignty = cell.sovereignty;
                faction = cell.faction;
                lastUpdate = cell.lastUpdate;
            }
        })
    };
    
    // Deposit pheromone at location based on Shell 3 coherence
    public func depositPheromone(
        state: AtlasState,
        x: Nat,
        y: Nat,
        shell3Coherence: Float,
        currentBeat: Nat
    ) : AtlasState {
        if (x >= state.gridWidth or y >= state.gridHeight) {
            return state;
        };
        
        let idx = getCellIndex(state, x, y);
        let depositAmount = shell3Coherence * state.depositRate;
        
        let newCells = Array.tabulate<AtlasCell>(state.cells.size(), func(i: Nat) : AtlasCell {
            if (i == idx) {
                let cell = state.cells[i];
                {
                    occupancy = cell.occupancy;
                    pheromone = Float.min(2.0, cell.pheromone + depositAmount);
                    sovereignty = cell.sovereignty;
                    faction = cell.faction;
                    lastUpdate = currentBeat;
                }
            } else {
                state.cells[i]
            }
        });
        
        {
            cells = newCells;
            gridWidth = state.gridWidth;
            gridHeight = state.gridHeight;
            evaporationRate = state.evaporationRate;
            depositRate = state.depositRate;
            diffusionRate = state.diffusionRate;
            totalOccupancy = state.totalOccupancy;
            totalPheromone = state.totalPheromone;
            totalSovereignty = state.totalSovereignty;
            dominantFaction = state.dominantFaction;
            factionCounts = state.factionCounts;
            shell9SovereigntyIndex = state.shell9SovereigntyIndex;
            beatCount = state.beatCount;
            lastUpdateBeat = currentBeat;
        }
    };
    
    // Diffuse pheromones to neighbors
    public func diffusePheromones(state: AtlasState) : [AtlasCell] {
        // Compute new pheromone values with diffusion
        Array.tabulate<AtlasCell>(state.cells.size(), func(idx: Nat) : AtlasCell {
            let cell = state.cells[idx];
            let (x, y) = getCoordinates(state, idx);
            
            // Get average neighbor pheromone
            let neighbors = getNeighbors(state, x, y);
            var neighborSum : Float = 0.0;
            var neighborCount : Float = 0.0;
            
            for (nIdx in neighbors.vals()) {
                if (nIdx < state.cells.size()) {
                    neighborSum += state.cells[nIdx].pheromone;
                    neighborCount += 1.0;
                };
            };
            
            let neighborAvg = if (neighborCount > 0.0) { 
                neighborSum / neighborCount 
            } else { 
                cell.pheromone 
            };
            
            // Diffusion: mix with neighbors
            let newPheromone = cell.pheromone * (1.0 - state.diffusionRate) + 
                               neighborAvg * state.diffusionRate;
            
            {
                occupancy = cell.occupancy;
                pheromone = newPheromone;
                sovereignty = cell.sovereignty;
                faction = cell.faction;
                lastUpdate = cell.lastUpdate;
            }
        })
    };
    
    // ========================================================================
    // TERRITORY OPERATIONS
    // ========================================================================
    
    // Update occupancy based on activity
    public func updateOccupancy(
        state: AtlasState,
        x: Nat,
        y: Nat,
        occupancyDelta: Float,
        currentBeat: Nat
    ) : AtlasState {
        if (x >= state.gridWidth or y >= state.gridHeight) {
            return state;
        };
        
        let idx = getCellIndex(state, x, y);
        
        let newCells = Array.tabulate<AtlasCell>(state.cells.size(), func(i: Nat) : AtlasCell {
            if (i == idx) {
                let cell = state.cells[i];
                {
                    occupancy = Float.min(1.0, Float.max(0.0, cell.occupancy + occupancyDelta));
                    pheromone = cell.pheromone;
                    sovereignty = cell.sovereignty;
                    faction = cell.faction;
                    lastUpdate = currentBeat;
                }
            } else {
                state.cells[i]
            }
        });
        
        {
            cells = newCells;
            gridWidth = state.gridWidth;
            gridHeight = state.gridHeight;
            evaporationRate = state.evaporationRate;
            depositRate = state.depositRate;
            diffusionRate = state.diffusionRate;
            totalOccupancy = state.totalOccupancy;
            totalPheromone = state.totalPheromone;
            totalSovereignty = state.totalSovereignty;
            dominantFaction = state.dominantFaction;
            factionCounts = state.factionCounts;
            shell9SovereigntyIndex = state.shell9SovereigntyIndex;
            beatCount = state.beatCount;
            lastUpdateBeat = currentBeat;
        }
    };
    
    // Claim sovereignty over cell
    public func claimSovereignty(
        state: AtlasState,
        x: Nat,
        y: Nat,
        faction: Nat,
        claimStrength: Float,
        currentBeat: Nat
    ) : AtlasState {
        if (x >= state.gridWidth or y >= state.gridHeight) {
            return state;
        };
        
        let idx = getCellIndex(state, x, y);
        
        let newCells = Array.tabulate<AtlasCell>(state.cells.size(), func(i: Nat) : AtlasCell {
            if (i == idx) {
                let cell = state.cells[i];
                // Faction with higher claim strength wins
                let newFaction = if (claimStrength > cell.sovereignty) { faction } else { cell.faction };
                let newSovereignty = if (claimStrength > cell.sovereignty) { 
                    claimStrength 
                } else { 
                    cell.sovereignty 
                };
                {
                    occupancy = cell.occupancy;
                    pheromone = cell.pheromone;
                    sovereignty = newSovereignty;
                    faction = newFaction;
                    lastUpdate = currentBeat;
                }
            } else {
                state.cells[i]
            }
        });
        
        {
            cells = newCells;
            gridWidth = state.gridWidth;
            gridHeight = state.gridHeight;
            evaporationRate = state.evaporationRate;
            depositRate = state.depositRate;
            diffusionRate = state.diffusionRate;
            totalOccupancy = state.totalOccupancy;
            totalPheromone = state.totalPheromone;
            totalSovereignty = state.totalSovereignty;
            dominantFaction = state.dominantFaction;
            factionCounts = state.factionCounts;
            shell9SovereigntyIndex = state.shell9SovereigntyIndex;
            beatCount = state.beatCount;
            lastUpdateBeat = currentBeat;
        }
    };
    
    // ========================================================================
    // AGGREGATION AND METRICS
    // ========================================================================
    
    // Compute aggregated metrics
    public func computeAggregates(state: AtlasState) : AtlasState {
        var totalOcc : Float = 0.0;
        var totalPher : Float = 0.0;
        var totalSov : Float = 0.0;
        let factionCounts = Array.init<Nat>(10, 0);  // Support up to 10 factions
        
        for (cell in state.cells.vals()) {
            totalOcc += cell.occupancy;
            totalPher += cell.pheromone;
            totalSov += cell.sovereignty;
            if (cell.faction < 10) {
                factionCounts[cell.faction] += 1;
            };
        };
        
        // Find dominant faction
        var maxCount : Nat = 0;
        var dominant : Nat = 0;
        for (f in factionCounts.keys()) {
            if (factionCounts[f] > maxCount) {
                maxCount := factionCounts[f];
                dominant := f;
            };
        };
        
        // Shell 9 sovereignty index
        let shell9Index = totalSov / Float.fromInt(state.cells.size());
        
        {
            cells = state.cells;
            gridWidth = state.gridWidth;
            gridHeight = state.gridHeight;
            evaporationRate = state.evaporationRate;
            depositRate = state.depositRate;
            diffusionRate = state.diffusionRate;
            totalOccupancy = totalOcc;
            totalPheromone = totalPher;
            totalSovereignty = totalSov;
            dominantFaction = dominant;
            factionCounts = Array.freeze(factionCounts);
            shell9SovereigntyIndex = shell9Index;
            beatCount = state.beatCount;
            lastUpdateBeat = state.lastUpdateBeat;
        }
    };
    
    // Get occupancy for council resource allocation
    public func getOccupancyForCouncil(state: AtlasState, councilIndex: Nat) : Float {
        // Map council indices to grid regions
        // 7 councils → 7 regions
        let regionWidth = state.gridWidth / 7;
        let regionStartX = councilIndex * regionWidth;
        let regionEndX = if (councilIndex == 6) { state.gridWidth } else { regionStartX + regionWidth };
        
        var regionOccupancy : Float = 0.0;
        var regionCells : Float = 0.0;
        
        for (idx in state.cells.keys()) {
            let (x, _) = getCoordinates(state, idx);
            if (x >= regionStartX and x < regionEndX) {
                regionOccupancy += state.cells[idx].occupancy;
                regionCells += 1.0;
            };
        };
        
        if (regionCells > 0.0) { regionOccupancy / regionCells } else { 0.0 }
    };
    
    // ========================================================================
    // FULL ATLAS TICK
    // ========================================================================
    
    public func tickAtlas(
        state: AtlasState,
        shell3Coherence: Float,
        activityLocations: [(Nat, Nat)],  // List of (x, y) where activity occurred
        currentBeat: Nat
    ) : AtlasState {
        
        // 1. Evaporate existing pheromones
        var newCells = evaporatePheromones(state);
        
        // 2. Deposit pheromone at activity locations
        for ((x, y) in activityLocations.vals()) {
            if (x < state.gridWidth and y < state.gridHeight) {
                let idx = y * state.gridWidth + x;
                if (idx < newCells.size()) {
                    let cell = newCells[idx];
                    let depositAmount = shell3Coherence * state.depositRate;
                    newCells := Array.tabulate<AtlasCell>(newCells.size(), func(i: Nat) : AtlasCell {
                        if (i == idx) {
                            {
                                occupancy = Float.min(1.0, cell.occupancy + 0.01);
                                pheromone = Float.min(2.0, cell.pheromone + depositAmount);
                                sovereignty = cell.sovereignty;
                                faction = cell.faction;
                                lastUpdate = currentBeat;
                            }
                        } else {
                            newCells[i]
                        }
                    });
                };
            };
        };
        
        // 3. Diffuse pheromones
        let tempState = {
            cells = newCells;
            gridWidth = state.gridWidth;
            gridHeight = state.gridHeight;
            evaporationRate = state.evaporationRate;
            depositRate = state.depositRate;
            diffusionRate = state.diffusionRate;
            totalOccupancy = state.totalOccupancy;
            totalPheromone = state.totalPheromone;
            totalSovereignty = state.totalSovereignty;
            dominantFaction = state.dominantFaction;
            factionCounts = state.factionCounts;
            shell9SovereigntyIndex = state.shell9SovereigntyIndex;
            beatCount = currentBeat;
            lastUpdateBeat = currentBeat;
        };
        newCells := diffusePheromones(tempState);
        
        // 4. Decay occupancy and sovereignty slowly
        newCells := Array.tabulate<AtlasCell>(newCells.size(), func(i: Nat) : AtlasCell {
            let cell = newCells[i];
            {
                occupancy = cell.occupancy * 0.999;  // Slow decay
                pheromone = cell.pheromone;
                sovereignty = cell.sovereignty * 0.9995;  // Very slow decay
                faction = cell.faction;
                lastUpdate = cell.lastUpdate;
            }
        });
        
        // 5. Compute aggregates
        let finalState = {
            cells = newCells;
            gridWidth = state.gridWidth;
            gridHeight = state.gridHeight;
            evaporationRate = state.evaporationRate;
            depositRate = state.depositRate;
            diffusionRate = state.diffusionRate;
            totalOccupancy = state.totalOccupancy;
            totalPheromone = state.totalPheromone;
            totalSovereignty = state.totalSovereignty;
            dominantFaction = state.dominantFaction;
            factionCounts = state.factionCounts;
            shell9SovereigntyIndex = state.shell9SovereigntyIndex;
            beatCount = currentBeat;
            lastUpdateBeat = currentBeat;
        };
        
        computeAggregates(finalState)
    };
    
    // ========================================================================
    // INITIALIZATION
    // ========================================================================
    
    public func initAtlasState() : AtlasState {
        let emptyCell : AtlasCell = {
            occupancy = 0.0;
            pheromone = 0.0;
            sovereignty = 0.0;
            faction = 0;
            lastUpdate = 0;
        };
        
        {
            cells = Array.tabulate<AtlasCell>(4096, func(_: Nat) : AtlasCell { emptyCell });
            gridWidth = 64;
            gridHeight = 64;
            evaporationRate = 0.98;
            depositRate = 0.1;
            diffusionRate = 0.05;
            totalOccupancy = 0.0;
            totalPheromone = 0.0;
            totalSovereignty = 0.0;
            dominantFaction = 0;
            factionCounts = [4096, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            shell9SovereigntyIndex = 0.0;
            beatCount = 0;
            lastUpdateBeat = 0;
        }
    };
    
    // ========================================================================
    // QUERY FUNCTIONS
    // ========================================================================
    
    // Get heat map of pheromones (8×8 downsampled)
    public func getPheromoneHeatMap(state: AtlasState) : [[Float]] {
        Array.tabulate<[Float]>(8, func(blockY: Nat) : [Float] {
            Array.tabulate<Float>(8, func(blockX: Nat) : Float {
                // Average 8×8 block
                var sum : Float = 0.0;
                var count : Float = 0.0;
                for (dy in Array.keys(Array.tabulate<Nat>(8, func(i: Nat) : Nat { i }))) {
                    for (dx in Array.keys(Array.tabulate<Nat>(8, func(i: Nat) : Nat { i }))) {
                        let x = blockX * 8 + dx;
                        let y = blockY * 8 + dy;
                        if (x < state.gridWidth and y < state.gridHeight) {
                            let idx = y * state.gridWidth + x;
                            if (idx < state.cells.size()) {
                                sum += state.cells[idx].pheromone;
                                count += 1.0;
                            };
                        };
                    };
                };
                if (count > 0.0) { sum / count } else { 0.0 }
            })
        })
    };
    
    // Get faction territory map
    public func getFactionTerritoryMap(state: AtlasState) : [[Nat]] {
        Array.tabulate<[Nat]>(8, func(blockY: Nat) : [Nat] {
            Array.tabulate<Nat>(8, func(blockX: Nat) : Nat {
                // Most common faction in 8×8 block
                let factionCounts = Array.init<Nat>(10, 0);
                for (dy in Array.keys(Array.tabulate<Nat>(8, func(i: Nat) : Nat { i }))) {
                    for (dx in Array.keys(Array.tabulate<Nat>(8, func(i: Nat) : Nat { i }))) {
                        let x = blockX * 8 + dx;
                        let y = blockY * 8 + dy;
                        if (x < state.gridWidth and y < state.gridHeight) {
                            let idx = y * state.gridWidth + x;
                            if (idx < state.cells.size()) {
                                let f = state.cells[idx].faction;
                                if (f < 10) { factionCounts[f] += 1 };
                            };
                        };
                    };
                };
                var maxF : Nat = 0;
                var maxCount : Nat = 0;
                for (f in factionCounts.keys()) {
                    if (factionCounts[f] > maxCount) {
                        maxCount := factionCounts[f];
                        maxF := f;
                    };
                };
                maxF
            })
        })
    };
    
    // Find high-activity regions
    public func findHighActivityRegions(state: AtlasState, threshold: Float) : [(Nat, Nat)] {
        let buffer = Buffer.Buffer<(Nat, Nat)>(100);
        
        for (idx in state.cells.keys()) {
            if (state.cells[idx].pheromone > threshold or state.cells[idx].occupancy > threshold) {
                let (x, y) = getCoordinates(state, idx);
                buffer.add((x, y));
            };
        };
        
        Buffer.toArray(buffer)
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
