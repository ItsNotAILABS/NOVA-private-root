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
}
