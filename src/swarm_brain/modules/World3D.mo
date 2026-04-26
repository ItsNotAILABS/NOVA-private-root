// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: World3D — Full 3D Voxel World with Real Terrain
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    WORLD 3D — REAL 3D SIMULATION WORLD                   ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  This is a REAL 3D world. Not a flat map. FULL 3D.                       ║
// ║                                                                          ║
// ║  WORLD STRUCTURE:                                                        ║
// ║    - 256 × 256 × 128 voxel grid (8.4 million voxels)                    ║
// ║    - Each voxel has material, density, damage state                      ║
// ║    - Terrain: mountains, valleys, caves, water                           ║
// ║    - Real elevation with geological accuracy                             ║
// ║                                                                          ║
// ║  COORDINATE SYSTEM:                                                      ║
// ║    X: East-West (positive = East)                                        ║
// ║    Y: Up-Down (positive = Up) — height/elevation                        ║
// ║    Z: North-South (positive = North)                                     ║
// ║                                                                          ║
// ║  SCALE: 1 voxel = 1 meter × 1 meter × 1 meter                           ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat8  "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WORLD CONSTANTS                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// World dimensions (in voxels/meters) — expanded 20×
  public let WORLD_SIZE_X : Nat = 5120;   // Expanded 20×: 256 → 5120
  public let WORLD_SIZE_Y : Nat = 2560;   // Height expanded 20×: 128 → 2560
  public let WORLD_SIZE_Z : Nat = 5120;   // Expanded 20×: 256 → 5120
  
  /// Sea level (Y coordinate) — scaled 20×
  public let SEA_LEVEL : Nat = 640;       // Expanded 20×: 32 → 640
  
  /// Fibonacci for terrain generation
  public let phi : Float = 1.6180339887498948482;
  public let F : [Nat] = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987];

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MATERIAL TYPES                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type MaterialType = {
    #Air;               // Empty space
    #Water;             // Liquid water
    #Dirt;              // Soil
    #Grass;             // Grass-covered dirt
    #Stone;             // Rock
    #Granite;           // Hard rock
    #Sand;              // Beach/desert
    #Clay;              // Wet soil
    #Gravel;            // Loose rocks
    #Bedrock;           // Indestructible base
    #Wood;              // Tree trunk/branches
    #Leaves;            // Tree foliage
    #Snow;              // Frozen precipitation
    #Ice;               // Frozen water
    #Concrete;          // Man-made structure
    #Steel;             // Metal structure
    #Glass;             // Transparent material
    #Brick;             // Building material
  };
  
  /// Material physical properties
  public type MaterialProperties = {
    density : Float;            // kg/m³
    hardness : Float;           // [0, 10] Mohs-like scale
    strength : Float;           // Breaking force (N)
    flammability : Float;       // [0, 1]
    conductivity : Float;       // Thermal/electrical
    transparency : Float;       // [0, 1] (0 = opaque)
    friction : Float;           // Surface friction coefficient
    restitution : Float;        // Bounciness
  };
  
  /// Get properties for material
  public func getMaterialProperties(mat: MaterialType) : MaterialProperties {
    switch (mat) {
      case (#Air) {
        { density = 1.225; hardness = 0.0; strength = 0.0; flammability = 0.0;
          conductivity = 0.02; transparency = 1.0; friction = 0.0; restitution = 0.0 }
      };
      case (#Water) {
        { density = 1000.0; hardness = 0.0; strength = 0.0; flammability = 0.0;
          conductivity = 0.6; transparency = 0.8; friction = 0.01; restitution = 0.0 }
      };
      case (#Dirt) {
        { density = 1500.0; hardness = 1.0; strength = 1000.0; flammability = 0.0;
          conductivity = 1.0; transparency = 0.0; friction = 0.6; restitution = 0.1 }
      };
      case (#Grass) {
        { density = 1400.0; hardness = 1.0; strength = 800.0; flammability = 0.3;
          conductivity = 0.8; transparency = 0.0; friction = 0.7; restitution = 0.2 }
      };
      case (#Stone) {
        { density = 2700.0; hardness = 6.0; strength = 50000.0; flammability = 0.0;
          conductivity = 2.0; transparency = 0.0; friction = 0.6; restitution = 0.2 }
      };
      case (#Granite) {
        { density = 2750.0; hardness = 7.0; strength = 100000.0; flammability = 0.0;
          conductivity = 2.5; transparency = 0.0; friction = 0.55; restitution = 0.25 }
      };
      case (#Sand) {
        { density = 1600.0; hardness = 2.0; strength = 200.0; flammability = 0.0;
          conductivity = 0.3; transparency = 0.0; friction = 0.4; restitution = 0.05 }
      };
      case (#Clay) {
        { density = 1900.0; hardness = 1.5; strength = 1500.0; flammability = 0.0;
          conductivity = 1.2; transparency = 0.0; friction = 0.65; restitution = 0.1 }
      };
      case (#Gravel) {
        { density = 1800.0; hardness = 4.0; strength = 500.0; flammability = 0.0;
          conductivity = 1.5; transparency = 0.0; friction = 0.5; restitution = 0.15 }
      };
      case (#Bedrock) {
        { density = 3000.0; hardness = 10.0; strength = 1000000.0; flammability = 0.0;
          conductivity = 3.0; transparency = 0.0; friction = 0.7; restitution = 0.3 }
      };
      case (#Wood) {
        { density = 700.0; hardness = 2.5; strength = 10000.0; flammability = 0.8;
          conductivity = 0.15; transparency = 0.0; friction = 0.5; restitution = 0.3 }
      };
      case (#Leaves) {
        { density = 100.0; hardness = 0.5; strength = 50.0; flammability = 0.9;
          conductivity = 0.1; transparency = 0.3; friction = 0.8; restitution = 0.4 }
      };
      case (#Snow) {
        { density = 300.0; hardness = 0.5; strength = 10.0; flammability = 0.0;
          conductivity = 0.05; transparency = 0.2; friction = 0.2; restitution = 0.1 }
      };
      case (#Ice) {
        { density = 917.0; hardness = 3.0; strength = 5000.0; flammability = 0.0;
          conductivity = 2.2; transparency = 0.6; friction = 0.05; restitution = 0.3 }
      };
      case (#Concrete) {
        { density = 2400.0; hardness = 5.0; strength = 30000.0; flammability = 0.0;
          conductivity = 1.7; transparency = 0.0; friction = 0.65; restitution = 0.2 }
      };
      case (#Steel) {
        { density = 7850.0; hardness = 8.0; strength = 250000.0; flammability = 0.0;
          conductivity = 50.0; transparency = 0.0; friction = 0.4; restitution = 0.5 }
      };
      case (#Glass) {
        { density = 2500.0; hardness = 6.0; strength = 2000.0; flammability = 0.0;
          conductivity = 1.0; transparency = 0.95; friction = 0.3; restitution = 0.1 }
      };
      case (#Brick) {
        { density = 1800.0; hardness = 4.0; strength = 15000.0; flammability = 0.0;
          conductivity = 0.7; transparency = 0.0; friction = 0.6; restitution = 0.15 }
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VOXEL                                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Voxel = {
    material : MaterialType;
    damage : Float;             // [0, 1] — 1.0 = destroyed
    temperature : Float;        // Kelvin (293.15 = 20°C)
    moisture : Float;           // [0, 1] water content
    light : Float;              // [0, 1] light level
    metadata : Nat8;            // Extra data (growth stage, variant, etc.)
  };
  
  /// Default air voxel
  public let AIR_VOXEL : Voxel = {
    material = #Air;
    damage = 0.0;
    temperature = 293.15;
    moisture = 0.0;
    light = 1.0;
    metadata = 0;
  };
  
  /// Default solid voxel
  public func solidVoxel(mat: MaterialType) : Voxel {
    {
      material = mat;
      damage = 0.0;
      temperature = 293.15;
      moisture = 0.3;
      light = 0.0;
      metadata = 0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CHUNK (16×16×16 voxels)                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let CHUNK_SIZE : Nat = 16;
  public let VOXELS_PER_CHUNK : Nat = 4096;  // 16³
  
  public type ChunkCoord = {
    cx : Nat;
    cy : Nat;
    cz : Nat;
  };
  
  public type Chunk = {
    coord : ChunkCoord;
    voxels : [Voxel];           // 4096 voxels
    isDirty : Bool;             // Needs re-render
    isEmpty : Bool;             // All air
    isFull : Bool;              // No air
  };
  
  /// Get voxel index within chunk
  public func voxelIndex(lx: Nat, ly: Nat, lz: Nat) : Nat {
    lz * CHUNK_SIZE * CHUNK_SIZE + ly * CHUNK_SIZE + lx
  };
  
  /// Get voxel from chunk
  public func getVoxelInChunk(chunk: Chunk, lx: Nat, ly: Nat, lz: Nat) : Voxel {
    let idx = voxelIndex(lx, ly, lz);
    if (idx < chunk.voxels.size()) {
      chunk.voxels[idx]
    } else {
      AIR_VOXEL
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TERRAIN GENERATION                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Pseudo-random noise (deterministic)
  public func noise2D(x: Float, z: Float) : Float {
    let n = Float.sin(x * 12.9898 + z * 78.233) * 43758.5453;
    n - Float.floor(n)
  };
  
  /// Fractal noise (multiple octaves)
  public func fractalNoise(x: Float, z: Float, octaves: Nat) : Float {
    var value : Float = 0.0;
    var amplitude : Float = 1.0;
    var frequency : Float = 1.0;
    var maxValue : Float = 0.0;
    
    var i = 0;
    while (i < octaves) {
      value += noise2D(x * frequency, z * frequency) * amplitude;
      maxValue += amplitude;
      amplitude *= 0.5;
      frequency *= 2.0;
      i += 1;
    };
    
    value / maxValue
  };
  
  /// Generate terrain height at (x, z) using Fibonacci-based frequencies
  public func terrainHeight(x: Nat, z: Nat) : Nat {
    let xf = Float.fromInt(x) / 64.0;  // Scale
    let zf = Float.fromInt(z) / 64.0;
    
    // Base terrain (large features)
    let base = fractalNoise(xf * 0.5, zf * 0.5, 4);
    
    // Mountains (sharp peaks using φ)
    let mountains = fractalNoise(xf * φ, zf * φ, 3);
    let mountainMask = Float.max(0.0, mountains - 0.6) * 3.0;
    
    // Hills (medium features)
    let hills = fractalNoise(xf * 2.0, zf * 2.0, 2);
    
    // Combine
    let heightNorm = base * 0.4 + hills * 0.3 + mountainMask * 0.5;
    
    // Convert to voxel height (16 - 96 range)
    let minH = 16;
    let maxH = 96;
    let h = minH + Int.abs(Float.toInt(heightNorm * Float.fromInt(maxH - minH)));
    
    if (h > maxH) { maxH } else if (h < minH) { minH } else { h }
  };
  
  /// Determine terrain material at position
  public func terrainMaterial(x: Nat, y: Nat, z: Nat, surfaceY: Nat) : MaterialType {
    // Bedrock at bottom
    if (y == 0) { return #Bedrock };
    
    // Deep stone
    if (y < surfaceY - 4) { return #Stone };
    
    // Dirt layer
    if (y < surfaceY) { return #Dirt };
    
    // Surface
    if (y == surfaceY) {
      // Beach near water
      if (surfaceY <= SEA_LEVEL + 2) { return #Sand };
      // Mountain top
      if (surfaceY > 80) { return #Stone };
      // Snow cap
      if (surfaceY > 70) { return #Snow };
      // Normal grass
      return #Grass
    };
    
    // Water in low areas
    if (y <= SEA_LEVEL and y > surfaceY) { return #Water };
    
    // Air above surface
    #Air
  };
  
  /// Generate a chunk at given coordinates
  public func generateChunk(cx: Nat, cy: Nat, cz: Nat) : Chunk {
    let voxels = Buffer.Buffer<Voxel>(VOXELS_PER_CHUNK);
    var isEmpty = true;
    var isFull = true;
    
    var lz = 0;
    while (lz < CHUNK_SIZE) {
      var ly = 0;
      while (ly < CHUNK_SIZE) {
        var lx = 0;
        while (lx < CHUNK_SIZE) {
          // World coordinates
          let wx = cx * CHUNK_SIZE + lx;
          let wy = cy * CHUNK_SIZE + ly;
          let wz = cz * CHUNK_SIZE + lz;
          
          // Get surface height at this (x, z)
          let surfaceY = terrainHeight(wx, wz);
          
          // Get material
          let mat = terrainMaterial(wx, wy, wz, surfaceY);
          
          let voxel = if (mat == #Air) {
            isFull := false;
            AIR_VOXEL
          } else {
            isEmpty := false;
            solidVoxel(mat)
          };
          
          voxels.add(voxel);
          lx += 1;
        };
        ly += 1;
      };
      lz += 1;
    };
    
    {
      coord = { cx = cx; cy = cy; cz = cz };
      voxels = Buffer.toArray(voxels);
      isDirty = true;
      isEmpty = isEmpty;
      isFull = isFull;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TREE GENERATION                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type TreeType = {
    #Oak;
    #Pine;
    #Birch;
    #Palm;
    #Cactus;
  };
  
  public type TreeData = {
    treeType : TreeType;
    position : (Nat, Nat, Nat);   // Base position
    height : Nat;                  // Total height
    trunkRadius : Nat;             // Trunk width
    crownRadius : Nat;             // Foliage spread
    age : Float;                   // [0, 1] maturity
  };
  
  /// Generate tree structure (returns voxels to place)
  public func generateTree(tree: TreeData) : [(Nat, Nat, Nat, MaterialType)] {
    let (bx, by, bz) = tree.position;
    let result = Buffer.Buffer<(Nat, Nat, Nat, MaterialType)>(100);
    
    // Trunk
    var y = 0;
    while (y < tree.height - 2) {
      result.add((bx, by + y, bz, #Wood));
      y += 1;
    };
    
    // Crown (spherical for oak)
    let crownStart = by + tree.height - tree.crownRadius - 1;
    var dy : Int = -tree.crownRadius;
    while (dy <= tree.crownRadius) {
      var dx : Int = -tree.crownRadius;
      while (dx <= tree.crownRadius) {
        var dz : Int = -tree.crownRadius;
        while (dz <= tree.crownRadius) {
          let distSq = dx * dx + dy * dy + dz * dz;
          let radiusSq = tree.crownRadius * tree.crownRadius;
          
          if (distSq <= radiusSq) {
            let lx = bx + dx;
            let ly = crownStart + dy;
            let lz = bz + dz;
            
            if (lx >= 0 and ly >= 0 and lz >= 0) {
              result.add((Int.abs(lx), Int.abs(ly), Int.abs(lz), #Leaves));
            };
          };
          dz += 1;
        };
        dx += 1;
      };
      dy += 1;
    };
    
    Buffer.toArray(result)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VOXEL DAMAGE & DESTRUCTION                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Apply damage to voxel
  public func damageVoxel(voxel: Voxel, damageAmount: Float) : Voxel {
    let props = getMaterialProperties(voxel.material);
    
    // Damage scaled by material strength
    let effectiveDamage = damageAmount / (props.strength / 1000.0 + 1.0);
    let newDamage = Float.min(1.0, voxel.damage + effectiveDamage);
    
    {
      material = if (newDamage >= 1.0) { #Air } else { voxel.material };
      damage = if (newDamage >= 1.0) { 0.0 } else { newDamage };
      temperature = voxel.temperature;
      moisture = voxel.moisture;
      light = if (newDamage >= 1.0) { 1.0 } else { voxel.light };
      metadata = voxel.metadata;
    }
  };
  
  /// Check if voxel should break
  public func shouldBreak(voxel: Voxel) : Bool {
    voxel.damage >= 1.0
  };
  
  /// Calculate explosion damage at distance
  public func explosionDamage(force: Float, distance: Float) : Float {
    if (distance < 0.001) { return force };
    force / (distance * distance)  // Inverse square law
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WORLD STATE                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type World3DState = {
    chunks : [Chunk];
    trees : [TreeData];
    
    // Time
    worldTime : Float;            // Seconds since world start
    dayTime : Float;              // [0, 1] — 0 = midnight, 0.5 = noon
    
    // Weather
    temperature : Float;          // Global temperature (Kelvin)
    humidity : Float;             // [0, 1]
    windDirection : (Float, Float, Float);
    windSpeed : Float;            // m/s
    
    // Season
    season : SeasonType;
    seasonProgress : Float;       // [0, 1] through current season
  };
  
  public type SeasonType = {
    #Spring;
    #Summer;
    #Autumn;
    #Winter;
  };
  
  /// Initialize world
  public func initWorld3D() : World3DState {
    {
      chunks = [];
      trees = [];
      worldTime = 0.0;
      dayTime = 0.25;  // 6 AM
      temperature = 293.15;  // 20°C
      humidity = 0.5;
      windDirection = (1.0, 0.0, 0.0);
      windSpeed = 5.0;
      season = #Summer;
      seasonProgress = 0.0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WORLD QUERIES                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Get voxel at world position
  public func getVoxelAt(world: World3DState, x: Nat, y: Nat, z: Nat) : Voxel {
    let cx = x / CHUNK_SIZE;
    let cy = y / CHUNK_SIZE;
    let cz = z / CHUNK_SIZE;
    
    // Find chunk
    for (chunk in world.chunks.vals()) {
      if (chunk.coord.cx == cx and chunk.coord.cy == cy and chunk.coord.cz == cz) {
        let lx = x % CHUNK_SIZE;
        let ly = y % CHUNK_SIZE;
        let lz = z % CHUNK_SIZE;
        return getVoxelInChunk(chunk, lx, ly, lz);
      };
    };
    
    // Chunk not loaded — generate procedurally
    let surfaceY = terrainHeight(x, z);
    let mat = terrainMaterial(x, y, z, surfaceY);
    if (mat == #Air) { AIR_VOXEL } else { solidVoxel(mat) }
  };
  
  /// Check if position is solid
  public func isSolid(world: World3DState, x: Nat, y: Nat, z: Nat) : Bool {
    let voxel = getVoxelAt(world, x, y, z);
    voxel.material != #Air and voxel.material != #Water
  };
  
  /// Get surface height at (x, z)
  public func getSurfaceHeight(world: World3DState, x: Nat, z: Nat) : Nat {
    terrainHeight(x, z)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DAY/NIGHT CYCLE                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Update day/night cycle
  public func updateDayNight(world: World3DState, dt: Float) : World3DState {
    // Full day = 1200 seconds (20 minutes real time)
    let dayLength = 1200.0;
    let newTime = world.worldTime + dt;
    let newDayTime = (newTime / dayLength) - Float.floor(newTime / dayLength);
    
    {
      chunks = world.chunks;
      trees = world.trees;
      worldTime = newTime;
      dayTime = newDayTime;
      temperature = world.temperature;
      humidity = world.humidity;
      windDirection = world.windDirection;
      windSpeed = world.windSpeed;
      season = world.season;
      seasonProgress = world.seasonProgress;
    }
  };
  
  /// Get sun position (for lighting)
  public func getSunPosition(dayTime: Float) : (Float, Float, Float) {
    let angle = dayTime * 2.0 * 3.14159265;
    let sunY = Float.sin(angle);
    let sunX = Float.cos(angle);
    (sunX, sunY, 0.0)
  };
  
  /// Get ambient light level
  public func getAmbientLight(dayTime: Float) : Float {
    // 0.1 at night, 1.0 at noon
    let base = Float.sin(dayTime * 2.0 * 3.14159265);
    Float.max(0.1, (base + 1.0) / 2.0)
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
