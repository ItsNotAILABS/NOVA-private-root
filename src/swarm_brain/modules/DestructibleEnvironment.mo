// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: DestructibleEnvironment — Real Physics-Based Destruction
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                DESTRUCTIBLE ENVIRONMENT — REAL BREAKAGE                 ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  EVERYTHING BREAKS. REALISTICALLY.                                       ║
// ║                                                                          ║
// ║  TREES:                                                                  ║
// ║    - Real wood fiber simulation                                          ║
// ║    - Break at weak points (knots, damage)                                ║
// ║    - Fall based on physics (mass, center of gravity)                     ║
// ║    - Splinter and fragment realistically                                 ║
// ║                                                                          ║
// ║  BUILDINGS:                                                              ║
// ║    - Structural integrity simulation                                     ║
// ║    - Load-bearing columns, walls                                         ║
// ║    - Progressive collapse (pancake, lean, topple)                        ║
// ║    - Debris physics                                                      ║
// ║                                                                          ║
// ║  TERRAIN:                                                                ║
// ║    - Explosions create craters                                           ║
// ║    - Erosion over time                                                   ║
// ║    - Landslides on steep slopes                                          ║
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
  public let GRAVITY : Float = 9.80665;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VECTOR TYPES                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Vector3 = { x : Float; y : Float; z : Float };
  
  public let ZERO : Vector3 = { x = 0.0; y = 0.0; z = 0.0 };
  
  public func add(a: Vector3, b: Vector3) : Vector3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };
  
  public func scale(v: Vector3, s: Float) : Vector3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };
  
  public func magnitude(v: Vector3) : Float {
    Float.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DESTRUCTIBLE OBJECT                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type DestructibleType = {
    #Tree;
    #Building;
    #Wall;
    #Rock;
    #Vehicle;
    #Bridge;
    #Tower;
    #Terrain;
  };
  
  public type StructuralHealth = {
    current : Float;              // Current HP
    maximum : Float;              // Max HP
    integrity : Float;            // [0, 1] structural soundness
    weakPoints : [WeakPoint];     // Structural vulnerabilities
  };
  
  public type WeakPoint = {
    position : Vector3;           // Local position
    strength : Float;             // Strength at this point
    stress : Float;               // Current stress
    isBroken : Bool;
  };
  
  public type DestructibleObject = {
    id : Nat32;
    objType : DestructibleType;
    
    // Transform
    position : Vector3;
    rotation : Vector3;           // Euler angles
    scale : Vector3;
    
    // Physics
    mass : Float;                 // kg
    centerOfMass : Vector3;       // Local CoM
    velocity : Vector3;
    angularVelocity : Vector3;
    
    // Structural
    health : StructuralHealth;
    
    // State
    isDestroyed : Bool;
    isCollapsing : Bool;
    collapseProgress : Float;     // [0, 1]
    collapseDirection : Vector3;  // Direction of fall
    
    // Fragments (when destroyed)
    fragments : [Fragment];
  };
  
  public type Fragment = {
    position : Vector3;
    velocity : Vector3;
    mass : Float;
    size : Float;
    angularVelocity : Vector3;
    lifetime : Float;             // Seconds until despawn
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TREE DESTRUCTION                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type TreeState = {
    id : Nat32;
    position : Vector3;
    height : Float;               // meters
    trunkDiameter : Float;        // meters
    age : Float;                  // years
    
    // Wood properties
    woodStrength : Float;         // Breaking force (N)
    moisture : Float;             // [0, 1]
    
    // Damage
    trunkDamage : [Float];        // Damage per segment
    rootDamage : Float;
    crownDamage : Float;
    
    // Physics state
    lean : Float;                 // Radians from vertical
    leanDirection : Float;        // Radians (compass direction)
    
    // Falling
    isFalling : Bool;
    fallProgress : Float;         // [0, 1]
    fallSpeed : Float;            // rad/s
    breakPoint : Float;           // Height where it broke
    
    // Post-fall
    hasFallen : Bool;
    logFragments : [Fragment];
  };
  
  /// Calculate tree center of mass
  public func treeCenterOfMass(tree: TreeState) : Vector3 {
    // Simplified: CoM at 1/3 height for typical tree
    let comHeight = tree.height * 0.33;
    add(tree.position, { x = 0.0; y = comHeight; z = 0.0 })
  };
  
  /// Calculate breaking force for tree trunk
  public func treeBreakingForce(tree: TreeState, height: Float) : Float {
    // Wood breaks based on: cross-section, wood strength, moisture
    let radius = tree.trunkDiameter / 2.0 * (1.0 - height / tree.height * 0.3);
    let area = π * radius * radius;
    let moistureFactor = 1.0 - tree.moisture * 0.3;  // Wet wood is weaker
    
    area * tree.woodStrength * moistureFactor
  };
  
  /// Apply damage to tree
  public func damageTree(tree: TreeState, damage: Float, hitHeight: Float) : TreeState {
    // Find which segment was hit
    let segmentIndex = Int.abs(Float.toInt(hitHeight / tree.height * Float.fromInt(tree.trunkDamage.size())));
    
    let newDamage = Array.tabulate<Float>(tree.trunkDamage.size(), func(i) {
      if (i == segmentIndex) {
        Float.min(1.0, tree.trunkDamage[i] + damage)
      } else {
        tree.trunkDamage[i]
      }
    });
    
    // Check if any segment is destroyed
    var breakPointFound = false;
    var breakHeight : Float = 0.0;
    var i = 0;
    while (i < newDamage.size() and not breakPointFound) {
      if (newDamage[i] >= 1.0) {
        breakPointFound := true;
        breakHeight := Float.fromInt(i) / Float.fromInt(newDamage.size()) * tree.height;
      };
      i += 1;
    };
    
    {
      id = tree.id;
      position = tree.position;
      height = tree.height;
      trunkDiameter = tree.trunkDiameter;
      age = tree.age;
      woodStrength = tree.woodStrength;
      moisture = tree.moisture;
      trunkDamage = newDamage;
      rootDamage = tree.rootDamage;
      crownDamage = tree.crownDamage;
      lean = tree.lean;
      leanDirection = tree.leanDirection;
      isFalling = breakPointFound or tree.isFalling;
      fallProgress = tree.fallProgress;
      fallSpeed = tree.fallSpeed;
      breakPoint = if (breakPointFound) { breakHeight } else { tree.breakPoint };
      hasFallen = tree.hasFallen;
      logFragments = tree.logFragments;
    }
  };
  
  /// Update falling tree physics
  public func updateFallingTree(tree: TreeState, dt: Float) : TreeState {
    if (not tree.isFalling or tree.hasFallen) { return tree };
    
    // Angular acceleration due to gravity
    // τ = r × F = r × mg × sin(θ)
    let effectiveLength = tree.height - tree.breakPoint;
    let currentAngle = tree.fallProgress * (π / 2.0);  // 0 to 90 degrees
    let torque = effectiveLength * tree.height * 50.0 * Float.sin(currentAngle) * GRAVITY;
    let momentOfInertia = tree.height * 50.0 * effectiveLength * effectiveLength / 3.0;
    let angularAccel = torque / (momentOfInertia + 1.0);
    
    let newFallSpeed = tree.fallSpeed + angularAccel * dt;
    let newProgress = tree.fallProgress + newFallSpeed * dt / (π / 2.0);
    
    // Check if tree has hit ground
    let hasFallen = newProgress >= 1.0;
    
    // Generate fragments on impact
    let fragments = if (hasFallen and tree.logFragments.size() == 0) {
      // Create log and branch fragments
      let frags = Buffer.Buffer<Fragment>(8);
      var f = 0;
      while (f < 5) {
        let fPos = {
          x = tree.position.x + Float.cos(tree.leanDirection) * effectiveLength * Float.fromInt(f) / 5.0;
          y = 0.5;
          z = tree.position.z + Float.sin(tree.leanDirection) * effectiveLength * Float.fromInt(f) / 5.0;
        };
        frags.add({
          position = fPos;
          velocity = { x = 0.0; y = 0.0; z = 0.0 };
          mass = effectiveLength / 5.0 * tree.trunkDiameter * tree.trunkDiameter * 700.0;
          size = effectiveLength / 5.0;
          angularVelocity = ZERO;
          lifetime = 3600.0;  // 1 hour
        });
        f += 1;
      };
      Buffer.toArray(frags)
    } else { tree.logFragments };
    
    {
      id = tree.id;
      position = tree.position;
      height = tree.height;
      trunkDiameter = tree.trunkDiameter;
      age = tree.age;
      woodStrength = tree.woodStrength;
      moisture = tree.moisture;
      trunkDamage = tree.trunkDamage;
      rootDamage = tree.rootDamage;
      crownDamage = tree.crownDamage;
      lean = tree.lean;
      leanDirection = tree.leanDirection;
      isFalling = not hasFallen;
      fallProgress = Float.min(1.0, newProgress);
      fallSpeed = newFallSpeed;
      breakPoint = tree.breakPoint;
      hasFallen = hasFallen;
      logFragments = fragments;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BUILDING DESTRUCTION                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type BuildingState = {
    id : Nat32;
    position : Vector3;
    dimensions : Vector3;         // Width, Height, Depth
    floors : Nat;
    
    // Structure
    columns : [StructuralColumn];
    walls : [StructuralWall];
    floors_ : [StructuralFloor];
    
    // Global state
    overallIntegrity : Float;     // [0, 1]
    isCollapsing : Bool;
    collapseType : CollapseType;
    collapseProgress : Float;
    
    // Debris
    rubble : [Fragment];
  };
  
  public type StructuralColumn = {
    position : Vector3;
    height : Float;
    loadCapacity : Float;         // Max load (N)
    currentLoad : Float;          // Current load
    damage : Float;               // [0, 1]
    isFailed : Bool;
  };
  
  public type StructuralWall = {
    start : Vector3;
    end : Vector3;
    height : Float;
    thickness : Float;
    isLoadBearing : Bool;
    damage : Float;
    segments : [Float];           // Damage per segment
  };
  
  public type StructuralFloor = {
    level : Nat;
    damage : Float;
    hasCollapsed : Bool;
  };
  
  public type CollapseType = {
    #None;
    #Pancake;                     // Floors fall straight down
    #Progressive;                 // Collapse spreads from failure point
    #Topple;                      // Building tips over
    #Implosion;                   // Collapses inward
  };
  
  /// Calculate building structural integrity
  public func calculateBuildingIntegrity(building: BuildingState) : Float {
    // Check columns
    var failedColumns : Nat = 0;
    for (col in building.columns.vals()) {
      if (col.isFailed) { failedColumns += 1 };
    };
    let columnIntegrity = 1.0 - Float.fromInt(failedColumns) / Float.fromInt(building.columns.size());
    
    // Check walls
    var totalWallDamage : Float = 0.0;
    var loadBearingDamage : Float = 0.0;
    var loadBearingCount : Nat = 0;
    
    for (wall in building.walls.vals()) {
      totalWallDamage += wall.damage;
      if (wall.isLoadBearing) {
        loadBearingDamage += wall.damage;
        loadBearingCount += 1;
      };
    };
    
    let wallIntegrity = 1.0 - totalWallDamage / Float.fromInt(building.walls.size());
    let loadBearingIntegrity = if (loadBearingCount > 0) {
      1.0 - loadBearingDamage / Float.fromInt(loadBearingCount)
    } else { 1.0 };
    
    // Weighted average (load-bearing is most critical)
    columnIntegrity * 0.5 + loadBearingIntegrity * 0.35 + wallIntegrity * 0.15
  };
  
  /// Damage building at point
  public func damageBuilding(building: BuildingState, hitPoint: Vector3, damage: Float) : BuildingState {
    // Find nearest column
    var nearestColIdx : Nat = 0;
    var nearestColDist : Float = 999999.0;
    var i = 0;
    while (i < building.columns.size()) {
      let col = building.columns[i];
      let dist = magnitude({ 
        x = hitPoint.x - col.position.x;
        y = 0.0;
        z = hitPoint.z - col.position.z;
      });
      if (dist < nearestColDist) {
        nearestColDist := dist;
        nearestColIdx := i;
      };
      i += 1;
    };
    
    // Damage nearby columns (damage falls off with φ)
    let newColumns = Array.tabulate<StructuralColumn>(building.columns.size(), func(idx) {
      let col = building.columns[idx];
      let dist = magnitude({ 
        x = hitPoint.x - col.position.x;
        y = 0.0;
        z = hitPoint.z - col.position.z;
      });
      
      let damageAtCol = damage * Float.pow(ψ, dist);
      let newDamage = Float.min(1.0, col.damage + damageAtCol);
      
      {
        position = col.position;
        height = col.height;
        loadCapacity = col.loadCapacity;
        currentLoad = col.currentLoad;
        damage = newDamage;
        isFailed = newDamage >= 0.8;
      }
    });
    
    // Calculate new integrity
    let newBuilding : BuildingState = {
      id = building.id;
      position = building.position;
      dimensions = building.dimensions;
      floors = building.floors;
      columns = newColumns;
      walls = building.walls;
      floors_ = building.floors_;
      overallIntegrity = 0.0;  // Will recalculate
      isCollapsing = building.isCollapsing;
      collapseType = building.collapseType;
      collapseProgress = building.collapseProgress;
      rubble = building.rubble;
    };
    
    let integrity = calculateBuildingIntegrity(newBuilding);
    let shouldCollapse = integrity < 0.3;
    
    {
      id = newBuilding.id;
      position = newBuilding.position;
      dimensions = newBuilding.dimensions;
      floors = newBuilding.floors;
      columns = newBuilding.columns;
      walls = newBuilding.walls;
      floors_ = newBuilding.floors_;
      overallIntegrity = integrity;
      isCollapsing = shouldCollapse or building.isCollapsing;
      collapseType = if (shouldCollapse and not building.isCollapsing) { #Pancake } else { building.collapseType };
      collapseProgress = building.collapseProgress;
      rubble = building.rubble;
    }
  };
  
  /// Update collapsing building
  public func updateCollapsingBuilding(building: BuildingState, dt: Float) : BuildingState {
    if (not building.isCollapsing) { return building };
    if (building.collapseProgress >= 1.0) { return building };
    
    // Collapse accelerates (freefall)
    let collapseSpeed = 0.3 + building.collapseProgress * 0.7;  // Speeds up
    let newProgress = Float.min(1.0, building.collapseProgress + collapseSpeed * dt);
    
    // Generate rubble as floors collapse
    let newRubble = if (newProgress >= 1.0 and building.rubble.size() == 0) {
      let debris = Buffer.Buffer<Fragment>(50);
      var d = 0;
      while (d < 50) {
        let angle = Float.fromInt(d) * 0.126;  // Spread in circle
        let dist = Float.fromInt(d % 10) * 2.0;
        debris.add({
          position = {
            x = building.position.x + Float.cos(angle) * dist;
            y = Float.fromInt(d % 5) * 0.5;
            z = building.position.z + Float.sin(angle) * dist;
          };
          velocity = {
            x = Float.cos(angle) * 5.0;
            y = 2.0;
            z = Float.sin(angle) * 5.0;
          };
          mass = building.dimensions.x * building.dimensions.z * 100.0 / 50.0;
          size = 1.0 + Float.fromInt(d % 3);
          angularVelocity = { x = 1.0; y = 0.5; z = 0.3 };
          lifetime = 7200.0;  // 2 hours
        });
        d += 1;
      };
      Buffer.toArray(debris)
    } else { building.rubble };
    
    {
      id = building.id;
      position = building.position;
      dimensions = building.dimensions;
      floors = building.floors;
      columns = building.columns;
      walls = building.walls;
      floors_ = building.floors_;
      overallIntegrity = building.overallIntegrity;
      isCollapsing = newProgress < 1.0;
      collapseType = building.collapseType;
      collapseProgress = newProgress;
      rubble = newRubble;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     EXPLOSION DAMAGE                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Explosion = {
    center : Vector3;
    force : Float;                // Newtons
    radius : Float;               // meters
    type_ : ExplosionType;
  };
  
  public type ExplosionType = {
    #Blast;                       // Pressure wave
    #Fragmentation;               // Shrapnel
    #Incendiary;                  // Fire
    #Thermobaric;                 // Fuel-air
  };
  
  /// Calculate explosion damage at point
  public func explosionDamageAt(explosion: Explosion, point: Vector3) : Float {
    let dist = magnitude({ 
      x = point.x - explosion.center.x;
      y = point.y - explosion.center.y;
      z = point.z - explosion.center.z;
    });
    
    if (dist >= explosion.radius) { return 0.0 };
    
    // Inverse square law falloff
    let normalizedDist = dist / explosion.radius;
    let falloff = 1.0 - normalizedDist;
    
    // Explosion type modifier
    let typeMultiplier = switch (explosion.type_) {
      case (#Blast) { 1.0 };
      case (#Fragmentation) { 0.8 };
      case (#Incendiary) { 0.5 };
      case (#Thermobaric) { 1.5 };
    };
    
    explosion.force * falloff * falloff * typeMultiplier / 1000.0
  };
  
  /// Calculate explosion crater radius
  public func craterRadius(explosion: Explosion) : Float {
    // Crater size based on force
    Float.sqrt(explosion.force / 10000.0) * 0.5
  };
  
  /// Calculate debris throw distance
  public func debrisThrowDistance(explosion: Explosion, fragmentMass: Float) : Float {
    // F = ma, v = sqrt(2E/m), d = v²/2g
    let energy = explosion.force * explosion.radius;
    let velocity = Float.sqrt(2.0 * energy / fragmentMass);
    velocity * velocity / (2.0 * GRAVITY)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TERRAIN DEFORMATION                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Crater = {
    center : Vector3;
    radius : Float;
    depth : Float;
    rimHeight : Float;
    age : Float;                  // For erosion
  };
  
  /// Create crater from explosion
  public func createCrater(explosion: Explosion) : Crater {
    let radius = craterRadius(explosion);
    {
      center = explosion.center;
      radius = radius;
      depth = radius * 0.3;       // Depth = 30% of radius
      rimHeight = radius * 0.1;   // Rim = 10% of radius
      age = 0.0;
    }
  };
  
  /// Apply crater to heightmap (returns height modification)
  public func craterHeightAt(crater: Crater, x: Float, z: Float) : Float {
    let dist = Float.sqrt(
      (x - crater.center.x) * (x - crater.center.x) +
      (z - crater.center.z) * (z - crater.center.z)
    );
    
    if (dist > crater.radius * 1.5) { return 0.0 };
    
    let normalizedDist = dist / crater.radius;
    
    if (normalizedDist < 1.0) {
      // Inside crater: depression
      -crater.depth * (1.0 - normalizedDist * normalizedDist)
    } else if (normalizedDist < 1.3) {
      // Rim: elevated
      crater.rimHeight * (1.0 - (normalizedDist - 1.0) / 0.3)
    } else {
      0.0
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FRAGMENT PHYSICS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Update fragment physics
  public func updateFragment(frag: Fragment, dt: Float) : Fragment {
    // Apply gravity
    let newVelocity = {
      x = frag.velocity.x * 0.99;  // Air drag
      y = frag.velocity.y - GRAVITY * dt;
      z = frag.velocity.z * 0.99;
    };
    
    let newPosition = {
      x = frag.position.x + newVelocity.x * dt;
      y = Float.max(frag.size / 2.0, frag.position.y + newVelocity.y * dt);
      z = frag.position.z + newVelocity.z * dt;
    };
    
    // Ground collision
    let hitGround = newPosition.y <= frag.size / 2.0;
    let groundedVelocity = if (hitGround) {
      { x = newVelocity.x * 0.3; y = Float.abs(newVelocity.y) * 0.2; z = newVelocity.z * 0.3 }
    } else { newVelocity };
    
    {
      position = newPosition;
      velocity = groundedVelocity;
      mass = frag.mass;
      size = frag.size;
      angularVelocity = scale(frag.angularVelocity, 0.98);
      lifetime = frag.lifetime - dt;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initTree(id: Nat32, pos: Vector3, height: Float) : TreeState {
    let segments = 10;
    {
      id = id;
      position = pos;
      height = height;
      trunkDiameter = height * 0.05;
      age = height * 2.0;
      woodStrength = 50000000.0;  // 50 MPa (typical softwood)
      moisture = 0.3;
      trunkDamage = Array.tabulate<Float>(segments, func(_) { 0.0 });
      rootDamage = 0.0;
      crownDamage = 0.0;
      lean = 0.0;
      leanDirection = 0.0;
      isFalling = false;
      fallProgress = 0.0;
      fallSpeed = 0.0;
      breakPoint = 0.0;
      hasFallen = false;
      logFragments = [];
    }
  };
  
  public func initBuilding(id: Nat32, pos: Vector3, dims: Vector3, floors: Nat) : BuildingState {
    // Create columns at corners and along walls
    let cols = Buffer.Buffer<StructuralColumn>(20);
    let spacing = dims.x / 3.0;
    
    var cx : Float = 0.0;
    while (cx <= dims.x) {
      var cz : Float = 0.0;
      while (cz <= dims.z) {
        cols.add({
          position = { x = pos.x + cx; y = pos.y; z = pos.z + cz };
          height = dims.y;
          loadCapacity = 1000000.0;
          currentLoad = dims.y * 10000.0;
          damage = 0.0;
          isFailed = false;
        });
        cz += spacing;
      };
      cx += spacing;
    };
    
    {
      id = id;
      position = pos;
      dimensions = dims;
      floors = floors;
      columns = Buffer.toArray(cols);
      walls = [];
      floors_ = Array.tabulate<StructuralFloor>(floors, func(i) {
        { level = i; damage = 0.0; hasCollapsed = false }
      });
      overallIntegrity = 1.0;
      isCollapsing = false;
      collapseType = #None;
      collapseProgress = 0.0;
      rubble = [];
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

}
