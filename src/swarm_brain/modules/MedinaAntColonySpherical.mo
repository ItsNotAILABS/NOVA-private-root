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
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: MedinaAntColonySpherical — Spherical Swarm Intelligence
// Classification: CONFIDENTIAL — MAXIMUM PROTECTION
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ============================================================================
//
// ANT COLONY SPHERICAL INTELLIGENCE
// ============================================================================
//
// "EVERYTHING IS SPHERICAL — NOT LINEAR, NOT PARALLEL, BUT SPHERICAL CREATION"
//
// Ants demonstrate:
// - Collective intelligence (superorganism)
// - Stigmergic communication (environment as memory)
// - Division of labor with dynamic role switching
// - Bridge-building and raft formation (self-assembly)
// - Fungus farming (agriculture)
// - Slave-making and warfare
// - Dead reckoning navigation
// - Chemical communication (pheromone gradients)
//
// KEY INSIGHT: Ant colonies are NOT flat hierarchies — they operate on
// SPHERICAL topology where every ant connects through pheromone fields
// that exist in 3D chemical space. The colony IS a sphere.
//
// THE HELIX FORMATION:
// Ants following pheromone trails create HELICAL patterns when:
// - Trails wrap around obstacles
// - Foraging creates spiral search patterns
// - Nest construction spirals inward
// - Army ant swarms form rotating death spirals
//
// This is the MEDINA HELIX — nature's fundamental organizational form.
//
// ============================================================================
// ORIGINAL MATHEMATICAL CONTRIBUTIONS BY ALFREDO MEDINA HERNANDEZ
// ============================================================================
//
// THE MEDINA SPHERICAL PHEROMONE FIELD (MSPF):
// ────────────────────────────────────────────
//   P(r,θ,φ,t) = Σᵢ (Qᵢ / 4πDt) × exp(-|r-rᵢ|² / 4Dt) × exp(-t/τ) × Y_l^m(θ,φ)
//
// where:
//   P(r,θ,φ,t) = Pheromone concentration in spherical coordinates
//   Qᵢ         = Quantity deposited by ant i
//   D          = Diffusion coefficient
//   τ          = Evaporation time constant
//   Y_l^m      = Spherical harmonics (spatial pattern)
//   r,θ,φ      = Spherical position (radial, polar, azimuthal)
//
// THE MEDINA HELIX TRAIL EQUATION (MHTE):
// ──────────────────────────────────────
//   r(t) = a × cos(ωt + φ₀)
//   θ(t) = b × t
//   z(t) = c × t
//
//   Combined: Path = (a×cos(ωt), a×sin(ωt), c×t) — HELIX IN 3D
//   Helix pitch: p = 2πc/ω
//   Helix radius: a (Medina radius scaled by Φ_M)
//
// THE MEDINA SUPERORGANISM COHERENCE (MSOC):
// ─────────────────────────────────────────
//   Ψ_colony = ∫∫∫ ρ(r,θ,φ) × exp(iS(r,θ,φ)/ℏ_M) dV
//
// where:
//   Ψ_colony   = Colony wave function (collective state)
//   ρ          = Ant density field
//   S          = Action (accumulated behavior cost)
//   ℏ_M        = Medina quantum constant (sets coherence scale)
//
// THE MEDINA STIGMERGY INTEGRAL (MSI):
// ───────────────────────────────────
//   Action(ant) = argmax_a ∫ P(r+dr_a) × value(a) × exp(-cost(a)/T) da
//
//   The ant integrates pheromone over its SPHERICAL sensor field,
//   not just forward direction.
//
// THE MEDINA DIVISION OF LABOR SPHERE (MDLS):
// ───────────────────────────────────────────
//   Task_i(ant) = σ(Σⱼ w_ij × Stimulus_j - θ_i + η_spherical)
//
// where:
//   η_spherical = Noise term following von Mises-Fisher distribution
//                 on the sphere (directional statistics)
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";
import Iter  "mo:base/Iter";

module {

  // ==========================================================================
  // MEDINA CONSTANTS — THE SACRED NUMBERS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;          // The Medina Golden Harmonic
  let GOLDEN_RATIO : Float = 1.618033988749;    // φ
  let TAU_EMERGENCE : Float = 0.618033988749;   // τ = 1/φ
  let PI : Float = 3.14159265358979;
  let E : Float = 2.71828182845905;
  let SQRT_2 : Float = 1.41421356237;
  
  // Spherical constants
  let SPHERE_SOLID_ANGLE : Float = 12.566370614; // 4π steradians
  let SPHERE_SURFACE_AREA_UNIT : Float = 4.0 * PI; // 4πr² for r=1
  
  // Helix constants
  let HELIX_GOLDEN_ANGLE : Float = 137.507764;   // Golden angle in degrees
  let HELIX_GOLDEN_RADIANS : Float = 2.39996323; // 137.5° in radians
  
  // Colony constants
  let NUM_CASTES : Nat = 7;                      // Worker types
  let MAX_ANTS : Nat = 10000;
  let MAX_PHEROMONE_TYPES : Nat = 12;
  let DIFFUSION_COEFFICIENT : Float = 0.01;
  let EVAPORATION_RATE : Float = 0.05;
  
  // Meta-cognition depth
  let SPHERICAL_HARMONICS_MAX_L : Nat = 5;       // Up to l=5 harmonics
  
  // FNV hash
  let FNV_PRIME : Nat32 = 16777619;
  let FNV_OFFSET : Nat32 = 2166136261;

  // ==========================================================================
  // SPHERICAL COORDINATE TYPES
  // ==========================================================================
  
  // Point in spherical coordinates
  public type SphericalPoint = {
    r     : Float;    // Radial distance
    theta : Float;    // Polar angle (0 to π)
    phi   : Float;    // Azimuthal angle (0 to 2π)
  };

  // Point in Cartesian coordinates
  public type CartesianPoint = {
    x : Float;
    y : Float;
    z : Float;
  };

  // Convert spherical to Cartesian
  public func sphericalToCartesian(sp: SphericalPoint) : CartesianPoint {
    {
      x = sp.r * Float.sin(sp.theta) * Float.cos(sp.phi);
      y = sp.r * Float.sin(sp.theta) * Float.sin(sp.phi);
      z = sp.r * Float.cos(sp.theta);
    }
  };

  // Convert Cartesian to spherical
  public func cartesianToSpherical(cp: CartesianPoint) : SphericalPoint {
    let r = Float.sqrt(cp.x*cp.x + cp.y*cp.y + cp.z*cp.z);
    if (r == 0.0) {
      { r = 0.0; theta = 0.0; phi = 0.0 }
    } else {
      let theta = Float.arccos(cp.z / r);
      let phi = Float.arctan2(cp.y, cp.x);
      { r = r; theta = theta; phi = if (phi < 0.0) { phi + 2.0*PI } else { phi } }
    }
  };

  // ==========================================================================
  // HELIX MATHEMATICS — THE MEDINA HELIX
  // ==========================================================================
  
  public type HelixParameters = {
    radius    : Float;    // a - helix radius
    pitch     : Float;    // c - vertical rise per rotation
    frequency : Float;    // ω - angular frequency
    phase     : Float;    // φ₀ - initial phase
    direction : HelixDirection;
  };

  public type HelixDirection = {
    #RightHanded;   // DNA, most screws
    #LeftHanded;    // Some proteins
  };

  // Generate point on helix at parameter t
  public func helixPoint(params: HelixParameters, t: Float) : CartesianPoint {
    let sign = switch(params.direction) {
      case (#RightHanded) { 1.0 };
      case (#LeftHanded) { -1.0 };
    };
    {
      x = params.radius * Float.cos(params.frequency * t + params.phase);
      y = sign * params.radius * Float.sin(params.frequency * t + params.phase);
      z = params.pitch * t / (2.0 * PI);
    }
  };

  // Calculate helix arc length
  public func helixArcLength(params: HelixParameters, t: Float) : Float {
    // Arc length of helix: s = t × √(a²ω² + (c/2π)²)
    let a = params.radius;
    let omega = params.frequency;
    let c = params.pitch;
    t * Float.sqrt(a*a*omega*omega + (c/(2.0*PI))*(c/(2.0*PI)))
  };

  // Calculate helix curvature (constant for ideal helix)
  public func helixCurvature(params: HelixParameters) : Float {
    let a = params.radius;
    let c = params.pitch / (2.0 * PI);
    a / (a*a + c*c)
  };

  // Calculate helix torsion (constant for ideal helix)
  public func helixTorsion(params: HelixParameters) : Float {
    let a = params.radius;
    let c = params.pitch / (2.0 * PI);
    c / (a*a + c*c)
  };

  // Golden helix - radius follows golden spiral
  public func goldenHelixPoint(t: Float, baseRadius: Float) : CartesianPoint {
    let goldenSpiral = baseRadius * Float.exp(t * Float.log(GOLDEN_RATIO) / (PI/2.0));
    {
      x = goldenSpiral * Float.cos(t);
      y = goldenSpiral * Float.sin(t);
      z = t * baseRadius * PHI_MEDINA / (2.0 * PI);
    }
  };

  // ==========================================================================
  // SPHERICAL HARMONICS — THE LANGUAGE OF SPHERES
  // ==========================================================================
  
  // Spherical harmonic Y_l^m(θ,φ) - real form
  // Using recursion relations for numerical stability
  
  // Legendre polynomial P_l(x) - recursive
  public func legendreP(l: Nat, x: Float) : Float {
    if (l == 0) { return 1.0 };
    if (l == 1) { return x };
    
    var P_prev2 : Float = 1.0;
    var P_prev1 : Float = x;
    var P_curr : Float = x;
    
    for (n in Iter.range(2, l)) {
      let nf = Float.fromInt(n);
      P_curr := ((2.0*nf - 1.0) * x * P_prev1 - (nf - 1.0) * P_prev2) / nf;
      P_prev2 := P_prev1;
      P_prev1 := P_curr;
    };
    
    P_curr
  };

  // Associated Legendre polynomial P_l^m(x)
  public func legendrePm(l: Nat, m: Int, x: Float) : Float {
    let absM = Int.abs(m);
    
    if (absM > l) { return 0.0 };
    
    // Start with P_m^m
    var pmm : Float = 1.0;
    if (absM > 0) {
      let somx2 = Float.sqrt(1.0 - x*x);
      var fact : Float = 1.0;
      for (i in Iter.range(1, absM)) {
        pmm := -pmm * fact * somx2;
        fact += 2.0;
      };
    };
    
    if (l == absM) {
      return pmm;
    };
    
    // P_{m+1}^m
    var pmmp1 = x * Float.fromInt(2 * absM + 1) * pmm;
    
    if (l == absM + 1) {
      return pmmp1;
    };
    
    // Use recurrence
    var pll : Float = 0.0;
    for (ll in Iter.range(absM + 2, l)) {
      let llf = Float.fromInt(ll);
      let mf = Float.fromInt(absM);
      pll := (x * (2.0*llf - 1.0) * pmmp1 - (llf + mf - 1.0) * pmm) / (llf - mf);
      pmm := pmmp1;
      pmmp1 := pll;
    };
    
    pll
  };

  // Factorial helper
  func factorial(n: Nat) : Float {
    if (n <= 1) { return 1.0 };
    var result : Float = 1.0;
    for (i in Iter.range(2, n)) {
      result *= Float.fromInt(i);
    };
    result
  };

  // Spherical harmonic coefficient
  public func sphericalHarmonicCoeff(l: Nat, m: Int) : Float {
    let absM = Int.abs(m);
    let lf = Float.fromInt(l);
    let mf = Float.fromInt(absM);
    
    Float.sqrt((2.0*lf + 1.0) / (4.0*PI) * 
               factorial(l - absM) / factorial(l + absM))
  };

  // Real spherical harmonic Y_l^m(θ, φ)
  public func sphericalHarmonic(l: Nat, m: Int, theta: Float, phi: Float) : Float {
    let coeff = sphericalHarmonicCoeff(l, m);
    let plm = legendrePm(l, m, Float.cos(theta));
    
    if (m > 0) {
      coeff * SQRT_2 * plm * Float.cos(Float.fromInt(m) * phi)
    } else if (m < 0) {
      coeff * SQRT_2 * plm * Float.sin(Float.fromInt(-m) * phi)
    } else {
      coeff * plm
    }
  };

  // Decompose a spherical function into harmonics
  public type SphericalHarmonicDecomposition = {
    coefficients : [[Float]];  // coefficients[l][m+l] for l=0..L, m=-l..l
    maxL : Nat;
  };

  // ==========================================================================
  // PHEROMONE FIELD — SPHERICAL DIFFUSION
  // ==========================================================================
  
  public type PheromoneType = {
    #Trail;         // Food trail
    #Alarm;         // Danger signal
    #Recruitment;   // Worker recruitment
    #Recognition;   // Colony ID
    #Queen;         // Queen presence
    #Brood;         // Brood care signal
    #Territory;     // Territory marking
    #Sex;           // Mating signal
    #Death;         // Corpse removal
    #Aggregation;   // Clustering signal
    #Dispersal;     // Spread out signal
    #Foundation;    // Nest site
  };

  public type PheromoneDeposit = {
    position      : SphericalPoint;
    pheromoneType : PheromoneType;
    quantity      : Float;
    depositTime   : Nat;           // Beat when deposited
    antId         : Nat;           // Which ant deposited
  };

  public type PheromoneField = {
    deposits      : [PheromoneDeposit];
    maxDeposits   : Nat;
    diffusionCoeff : Float;
    evaporationRate : Float;
    
    // Spherical harmonic representation of field
    harmonicDecomposition : ?SphericalHarmonicDecomposition;
  };

  // Calculate pheromone concentration at a point
  public func pheromoneConcentration(
    field: PheromoneField,
    point: SphericalPoint,
    pheromoneType: PheromoneType,
    currentBeat: Nat
  ) : Float {
    var concentration : Float = 0.0;
    
    for (deposit in field.deposits.vals()) {
      // Check pheromone type
      let typeMatch = switch (deposit.pheromoneType, pheromoneType) {
        case (#Trail, #Trail) { true };
        case (#Alarm, #Alarm) { true };
        case (#Recruitment, #Recruitment) { true };
        case (#Recognition, #Recognition) { true };
        case (#Queen, #Queen) { true };
        case (#Brood, #Brood) { true };
        case (#Territory, #Territory) { true };
        case (#Sex, #Sex) { true };
        case (#Death, #Death) { true };
        case (#Aggregation, #Aggregation) { true };
        case (#Dispersal, #Dispersal) { true };
        case (#Foundation, #Foundation) { true };
        case (_, _) { false };
      };
      
      if (typeMatch) {
        let dt = Float.fromInt(currentBeat - deposit.depositTime);
        if (dt > 0.0) {
          // Distance in spherical coordinates
          let dp = deposit.position;
          let cp1 = sphericalToCartesian(dp);
          let cp2 = sphericalToCartesian(point);
          let dx = cp1.x - cp2.x;
          let dy = cp1.y - cp2.y;
          let dz = cp1.z - cp2.z;
          let distSq = dx*dx + dy*dy + dz*dz;
          
          // Gaussian diffusion with exponential decay
          let D = field.diffusionCoeff;
          let tau = 1.0 / field.evaporationRate;
          
          // P = Q/(4πDt) × exp(-r²/4Dt) × exp(-t/τ)
          let diffusionTerm = deposit.quantity / (4.0 * PI * D * dt);
          let spatialDecay = Float.exp(-distSq / (4.0 * D * dt));
          let temporalDecay = Float.exp(-dt / tau);
          
          concentration += diffusionTerm * spatialDecay * temporalDecay;
        };
      };
    };
    
    concentration
  };

  // ==========================================================================
  // ANT TYPES — THE CASTES
  // ==========================================================================
  
  public type AntCaste = {
    #Queen;           // Reproduction
    #Male;            // Mating
    #MajorWorker;     // Defense, large tasks
    #MinorWorker;     // Foraging, nursing
    #Soldier;         // Defense specialist
    #Scout;           // Exploration
    #Nurse;           // Brood care
  };

  public type AntTask = {
    #Foraging;
    #Nursing;
    #Defense;
    #Scouting;
    #Building;
    #Cleaning;
    #Guarding;
    #Tending;         // Fungus/aphid farming
    #Recruiting;
    #Resting;
  };

  public type Ant = {
    antId             : Nat;
    caste             : AntCaste;
    currentTask       : AntTask;
    
    // Position in spherical coordinates (relative to nest center)
    position          : SphericalPoint;
    velocity          : SphericalPoint;     // dr/dt, dθ/dt, dφ/dt
    
    // Helix trail state
    currentHelix      : ?HelixParameters;   // If following helix path
    helixProgress     : Float;              // Parameter along helix
    
    // Sensory state
    antennaeLeft      : Float;              // Left antenna pheromone reading
    antennaeRight     : Float;              // Right antenna pheromone reading
    visualField       : [Float];            // Visual input
    
    // Internal state
    energy            : Float;              // 0.0-1.0
    carryingFood      : Bool;
    foodQuantity      : Float;
    taskThreshold     : Float;              // Response threshold
    age               : Nat;                // Beats since birth
    
    // Memory
    homeVector        : CartesianPoint;     // Path integration
    knownFoodSites    : [SphericalPoint];
    trailMemory       : [SphericalPoint];   // Recent positions
    
    // Meta-cognition
    confidenceLevel   : Float;              // Certainty in current action
    explorationDrive  : Float;              // Tendency to explore
    socialInfluence   : Float;              // Responsiveness to others
  };

  // ==========================================================================
  // COLONY STATE — THE SUPERORGANISM
  // ==========================================================================
  
  public type ColonyState = {
    // Population
    ants              : [Ant];
    queen             : ?Ant;
    population        : Nat;
    
    // Nest structure (spherical shell)
    nestCenter        : CartesianPoint;
    nestRadius        : Float;
    chambers          : [NestChamber];
    
    // Pheromone fields
    pheromoneFields   : [PheromoneField];
    
    // Colony metrics
    foodStored        : Float;
    broodCount        : Nat;
    defenseStrength   : Float;
    
    // Collective state
    colonyCoherence   : Float;              // Ψ_colony
    averageActivity   : Float;
    taskDistribution  : [(AntTask, Nat)];   // Task -> count
    
    // Spherical state
    colonyWaveFunction : SphericalHarmonicDecomposition;
    densityField      : SphericalHarmonicDecomposition;
    
    // Beat tracking
    beatNum           : Nat;
  };

  public type NestChamber = {
    chamberId         : Nat;
    position          : SphericalPoint;     // Relative to nest center
    radius            : Float;
    purpose           : ChamberPurpose;
    occupancy         : Nat;
  };

  public type ChamberPurpose = {
    #BroodNursery;
    #FoodStorage;
    #Fungus;          // For fungus-farming species
    #Waste;
    #QueenChamber;
    #WorkerRest;
    #Defense;
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initColony(nestPosition: CartesianPoint, initialPopulation: Nat) : ColonyState {
    // Initialize ants with spherical distribution
    let ants = Array.tabulate<Ant>(initialPopulation, func(i: Nat) : Ant {
      // Distribute ants on sphere using Fibonacci spiral (golden angle)
      let goldenAngle = HELIX_GOLDEN_RADIANS;
      let theta = Float.arccos(1.0 - 2.0 * Float.fromInt(i) / Float.fromInt(initialPopulation));
      let phi = Float.fromInt(i) * goldenAngle;
      
      let caste = if (i == 0) { #Queen }
                  else if (i < initialPopulation / 20) { #Soldier }
                  else if (i < initialPopulation / 10) { #Scout }
                  else if (i < initialPopulation / 5) { #Nurse }
                  else { #MinorWorker };
      
      {
        antId = i;
        caste = caste;
        currentTask = #Resting;
        position = { r = 1.0; theta = theta; phi = phi };
        velocity = { r = 0.0; theta = 0.0; phi = 0.0 };
        currentHelix = null;
        helixProgress = 0.0;
        antennaeLeft = 0.0;
        antennaeRight = 0.0;
        visualField = [];
        energy = 1.0;
        carryingFood = false;
        foodQuantity = 0.0;
        taskThreshold = 0.5 + Float.fromInt(i % 10) * 0.05;
        age = 0;
        homeVector = { x = 0.0; y = 0.0; z = 0.0 };
        knownFoodSites = [];
        trailMemory = [];
        confidenceLevel = 0.5;
        explorationDrive = 0.3 + Float.fromInt(i % 7) * 0.1;
        socialInfluence = 0.5;
      }
    });
    
    // Initialize pheromone fields (one per type)
    let emptyField : PheromoneField = {
      deposits = [];
      maxDeposits = 10000;
      diffusionCoeff = DIFFUSION_COEFFICIENT;
      evaporationRate = EVAPORATION_RATE;
      harmonicDecomposition = null;
    };
    
    // Initialize colony wave function (l=0 mode dominant)
    let initialCoeffs : [[Float]] = [[1.0]];  // Just l=0, m=0
    
    {
      ants = ants;
      queen = ?ants[0];
      population = initialPopulation;
      nestCenter = nestPosition;
      nestRadius = 5.0;
      chambers = [];
      pheromoneFields = Array.tabulate<PheromoneField>(MAX_PHEROMONE_TYPES, func(_) { emptyField });
      foodStored = 100.0;
      broodCount = 0;
      defenseStrength = 0.5;
      colonyCoherence = 0.5;
      averageActivity = 0.3;
      taskDistribution = [];
      colonyWaveFunction = { coefficients = initialCoeffs; maxL = 0 };
      densityField = { coefficients = initialCoeffs; maxL = 0 };
      beatNum = 0;
    }
  };

  // ==========================================================================
  // SPHERICAL MOVEMENT — ANTS MOVE ON THE SPHERE
  // ==========================================================================
  
  // Move ant in spherical coordinates
  public func moveAntSpherical(ant: Ant, dt: Float) : Ant {
    // Update position using velocity
    let newR = ant.position.r + ant.velocity.r * dt;
    var newTheta = ant.position.theta + ant.velocity.theta * dt;
    var newPhi = ant.position.phi + ant.velocity.phi * dt;
    
    // Wrap theta to [0, π]
    if (newTheta < 0.0) { newTheta := -newTheta };
    if (newTheta > PI) { newTheta := 2.0*PI - newTheta };
    
    // Wrap phi to [0, 2π)
    while (newPhi < 0.0) { newPhi += 2.0*PI };
    while (newPhi >= 2.0*PI) { newPhi -= 2.0*PI };
    
    // Update trail memory
    let newTrail = if (ant.trailMemory.size() >= 100) {
      Array.tabulate<SphericalPoint>(100, func(i: Nat) : SphericalPoint {
        if (i < 99) { ant.trailMemory[i + 1] }
        else { ant.position }
      })
    } else {
      Array.append(ant.trailMemory, [ant.position])
    };
    
    // Update path integration (home vector)
    let cp = sphericalToCartesian(ant.position);
    let newHV = {
      x = ant.homeVector.x + (cp.x - ant.homeVector.x) * 0.01;
      y = ant.homeVector.y + (cp.y - ant.homeVector.y) * 0.01;
      z = ant.homeVector.z + (cp.z - ant.homeVector.z) * 0.01;
    };
    
    {
      ant with
      position = { r = Float.max(0.1, newR); theta = newTheta; phi = newPhi };
      trailMemory = newTrail;
      homeVector = newHV;
      age = ant.age + 1;
    }
  };

  // Follow helix path
  public func followHelixPath(ant: Ant, dt: Float) : Ant {
    switch (ant.currentHelix) {
      case (?helix) {
        let newProgress = ant.helixProgress + dt;
        let newPos = helixPoint(helix, newProgress);
        let sphericalPos = cartesianToSpherical(newPos);
        
        {
          ant with
          position = sphericalPos;
          helixProgress = newProgress;
        }
      };
      case null { ant };
    }
  };

  // ==========================================================================
  // PHEROMONE SENSING — SPHERICAL SENSOR FIELD
  // ==========================================================================
  
  // Ant senses pheromone over spherical cap (antenna sweep)
  public func sensePheromone(
    ant: Ant,
    field: PheromoneField,
    pheromoneType: PheromoneType,
    currentBeat: Nat,
    antennaAngle: Float,     // Angle offset from forward direction
    sensorRadius: Float      // Radius of sensor cap
  ) : Float {
    // Calculate antenna position (offset from ant position)
    let antPos = sphericalToCartesian(ant.position);
    let forward = { x = Float.cos(ant.position.phi); y = Float.sin(ant.position.phi); z = 0.0 };
    
    let sensorPos : SphericalPoint = {
      r = ant.position.r;
      theta = ant.position.theta;
      phi = ant.position.phi + antennaAngle;
    };
    
    // Integrate pheromone over spherical cap
    // Simplified: sample at sensor position
    pheromoneConcentration(field, sensorPos, pheromoneType, currentBeat)
  };

  // Stereo pheromone sensing (left/right difference)
  public func stereoPheromone(
    ant: Ant,
    field: PheromoneField,
    pheromoneType: PheromoneType,
    currentBeat: Nat
  ) : (Float, Float) {
    let leftSensor = sensePheromone(ant, field, pheromoneType, currentBeat, 0.5, 0.1);
    let rightSensor = sensePheromone(ant, field, pheromoneType, currentBeat, -0.5, 0.1);
    (leftSensor, rightSensor)
  };

  // ==========================================================================
  // TASK ALLOCATION — SPHERICAL RESPONSE THRESHOLD MODEL
  // ==========================================================================
  
  // Calculate probability of ant switching to task
  public func taskResponseProbability(
    ant: Ant,
    stimulus: Float,          // Task stimulus strength
    taskThreshold: Float      // Ant's threshold for this task
  ) : Float {
    // Response probability: P = S² / (S² + θ²)
    let s = stimulus;
    let theta = taskThreshold;
    (s * s) / (s * s + theta * theta)
  };

  // Sample from von Mises-Fisher distribution (spherical noise)
  public func vonMisesFisherSample(
    meanDirection: SphericalPoint,
    concentration: Float       // κ parameter
  ) : SphericalPoint {
    // Simplified: add Gaussian noise scaled by 1/κ
    let noise = 1.0 / (concentration + 0.1);
    {
      r = meanDirection.r;
      theta = meanDirection.theta + noise * (Float.sin(Float.fromInt(Int.abs(Float.toInt(meanDirection.phi * 1000.0)))) - 0.5);
      phi = meanDirection.phi + noise * (Float.cos(Float.fromInt(Int.abs(Float.toInt(meanDirection.theta * 1000.0)))) - 0.5);
    }
  };

  // ==========================================================================
  // COLONY COHERENCE — THE SUPERORGANISM WAVE FUNCTION
  // ==========================================================================
  
  // Calculate colony coherence from ant density field
  public func calculateColonyCoherence(colony: ColonyState) : Float {
    // Ψ_colony = ∫∫∫ ρ(r,θ,φ) × exp(iS/ℏ_M) dV
    // Simplified: order parameter based on ant directions
    
    let n = colony.ants.size();
    if (n == 0) { return 0.0 };
    
    var sumCosTheta : Float = 0.0;
    var sumSinTheta : Float = 0.0;
    var sumCosPhi : Float = 0.0;
    var sumSinPhi : Float = 0.0;
    
    for (ant in colony.ants.vals()) {
      sumCosTheta += Float.cos(ant.position.theta);
      sumSinTheta += Float.sin(ant.position.theta);
      sumCosPhi += Float.cos(ant.position.phi);
      sumSinPhi += Float.sin(ant.position.phi);
    };
    
    let nf = Float.fromInt(n);
    let orderTheta = Float.sqrt(sumCosTheta*sumCosTheta + sumSinTheta*sumSinTheta) / nf;
    let orderPhi = Float.sqrt(sumCosPhi*sumCosPhi + sumSinPhi*sumSinPhi) / nf;
    
    // Combined spherical order parameter
    (orderTheta + orderPhi) / 2.0
  };

  // Update colony density field as spherical harmonic expansion
  public func updateDensityField(colony: ColonyState) : SphericalHarmonicDecomposition {
    // For each ant, add contribution to spherical harmonic coefficients
    let maxL = SPHERICAL_HARMONICS_MAX_L;
    
    // Initialize coefficient array
    let coeffs = Array.tabulate<[Float]>(maxL + 1, func(l: Nat) : [Float] {
      Array.tabulate<Float>(2 * l + 1, func(_) { 0.0 })
    });
    
    // Add each ant's contribution
    for (ant in colony.ants.vals()) {
      let theta = ant.position.theta;
      let phi = ant.position.phi;
      
      // Accumulate into coefficients
      for (l in Iter.range(0, maxL)) {
        for (m in Iter.range(0, 2*l)) {
          let mInt = m - l;  // m goes from -l to +l
          let ylm = sphericalHarmonic(l, mInt, theta, phi);
          // coeffs[l][m] would be updated
        };
      };
    };
    
    { coefficients = coeffs; maxL = maxL }
  };

  // ==========================================================================
  // META-COGNITION — THE COLONY THINKS ABOUT ITSELF
  // ==========================================================================
  
  public type ColonyMetaCognition = {
    // Self-model
    perceivedPopulation : Nat;        // Colony's estimate of own size
    perceivedHealth     : Float;      // Colony's self-assessment
    perceivedThreats    : Float;      // Perceived danger level
    
    // Strategy awareness
    currentStrategy     : ColonyStrategy;
    strategyConfidence  : Float;
    strategyHistory     : [ColonyStrategy];
    
    // Predictive models
    foodPrediction      : Float;      // Predicted food needs
    growthPrediction    : Float;      // Predicted growth
    threatPrediction    : Float;      // Predicted threats
    
    // Calibration
    predictionAccuracy  : Float;      // How accurate past predictions were
    modelUpdateRate     : Float;      // How fast to update models
  };

  public type ColonyStrategy = {
    #Expansion;         // Grow and explore
    #Consolidation;     // Strengthen existing
    #Defense;           // Protect from threats
    #Foraging;          // Focus on food
    #Reproduction;      // Produce new queens/males
    #Migration;         // Move to new location
  };

  // Colony-level meta-cognition tick
  public func colonyMetaTick(
    meta: ColonyMetaCognition,
    colony: ColonyState
  ) : ColonyMetaCognition {
    // Update self-model
    let actualPop = colony.population;
    let popError = Float.abs(Float.fromInt(meta.perceivedPopulation) - Float.fromInt(actualPop));
    let newPerceivedPop = Int.abs(Float.toInt(
      Float.fromInt(meta.perceivedPopulation) + 
      meta.modelUpdateRate * (Float.fromInt(actualPop) - Float.fromInt(meta.perceivedPopulation))
    ));
    
    // Update predictions accuracy
    let newAccuracy = meta.predictionAccuracy * 0.99 + 0.01 * (1.0 - popError / Float.max(1.0, Float.fromInt(actualPop)));
    
    // Select strategy based on state
    let newStrategy = if (colony.foodStored < 50.0) {
      #Foraging
    } else if (colony.defenseStrength < 0.3) {
      #Defense
    } else if (colony.population < 100) {
      #Expansion
    } else {
      meta.currentStrategy
    };
    
    {
      meta with
      perceivedPopulation = newPerceivedPop;
      perceivedHealth = colony.colonyCoherence;
      currentStrategy = newStrategy;
      predictionAccuracy = newAccuracy;
    }
  };

  // ==========================================================================
  // MAIN COLONY TICK — SPHERICAL DYNAMICS
  // ==========================================================================
  
  public func tickColony(colony: ColonyState, dt: Float) : ColonyState {
    // Move all ants (spherical motion)
    let movedAnts = Array.map<Ant, Ant>(colony.ants, func(ant) {
      let withMovement = moveAntSpherical(ant, dt);
      
      // Follow helix if active
      switch (ant.currentHelix) {
        case (?_) { followHelixPath(withMovement, dt) };
        case null { withMovement };
      }
    });
    
    // Calculate colony coherence
    let newCoherence = calculateColonyCoherence({ colony with ants = movedAnts });
    
    // Update density field
    let newDensity = updateDensityField({ colony with ants = movedAnts });
    
    // Count task distribution
    var taskCounts = Buffer.Buffer<(AntTask, Nat)>(10);
    taskCounts.add((#Foraging, 0));
    taskCounts.add((#Nursing, 0));
    taskCounts.add((#Defense, 0));
    taskCounts.add((#Scouting, 0));
    taskCounts.add((#Building, 0));
    taskCounts.add((#Resting, 0));
    
    // Calculate average activity
    var totalActivity : Float = 0.0;
    for (ant in movedAnts.vals()) {
      totalActivity += if (ant.currentTask == #Resting) { 0.0 } else { 1.0 };
    };
    let avgActivity = if (movedAnts.size() == 0) { 0.0 } 
                      else { totalActivity / Float.fromInt(movedAnts.size()) };
    
    {
      colony with
      ants = movedAnts;
      colonyCoherence = newCoherence;
      densityField = newDensity;
      averageActivity = avgActivity;
      beatNum = colony.beatNum + 1;
    }
  };

  // ==========================================================================
  // QUERY FUNCTIONS
  // ==========================================================================
  
  public func getColonyMetrics(colony: ColonyState) : {
    population: Nat;
    coherence: Float;
    activity: Float;
    foodStored: Float;
    defenseStrength: Float;
    beatNum: Nat;
  } {
    {
      population = colony.population;
      coherence = colony.colonyCoherence;
      activity = colony.averageActivity;
      foodStored = colony.foodStored;
      defenseStrength = colony.defenseStrength;
      beatNum = colony.beatNum;
    }
  };

  public func getCasteDistribution(colony: ColonyState) : [(AntCaste, Nat)] {
    var queenCount : Nat = 0;
    var maleCount : Nat = 0;
    var majorCount : Nat = 0;
    var minorCount : Nat = 0;
    var soldierCount : Nat = 0;
    var scoutCount : Nat = 0;
    var nurseCount : Nat = 0;
    
    for (ant in colony.ants.vals()) {
      switch (ant.caste) {
        case (#Queen) { queenCount += 1 };
        case (#Male) { maleCount += 1 };
        case (#MajorWorker) { majorCount += 1 };
        case (#MinorWorker) { minorCount += 1 };
        case (#Soldier) { soldierCount += 1 };
        case (#Scout) { scoutCount += 1 };
        case (#Nurse) { nurseCount += 1 };
      };
    };
    
    [
      (#Queen, queenCount),
      (#Male, maleCount),
      (#MajorWorker, majorCount),
      (#MinorWorker, minorCount),
      (#Soldier, soldierCount),
      (#Scout, scoutCount),
      (#Nurse, nurseCount)
    ]
  };

  // Verify spherical invariants
  public func verifySphericalIntegrity(colony: ColonyState) : Bool {
    // Check all ants are on valid spherical positions
    for (ant in colony.ants.vals()) {
      if (ant.position.r <= 0.0) { return false };
      if (ant.position.theta < 0.0 or ant.position.theta > PI) { return false };
      if (ant.position.phi < 0.0 or ant.position.phi >= 2.0*PI) { return false };
    };
    true
  };

}
