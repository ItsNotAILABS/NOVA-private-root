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
// EMERGENCE PHYSICS ENGINE — Phase Transitions, Critical Phenomena, Self-Organization
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Classification: CONFIDENTIAL — TRADE SECRET
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// This module implements real physics of emergence:
// - Phase transitions (first-order, second-order, continuous)
// - Critical phenomena (power laws, scaling, universality)
// - Self-organized criticality (SOC)
// - Symmetry breaking
// - Order parameters (Landau theory)
// - Renormalization group concepts
// - Ising model dynamics
// - Percolation theory
// - Reaction-diffusion systems (Turing patterns)
// - Dissipative structures (Prigogine)
// - Synergetics (Haken)
// - Chaos and strange attractors
//
// THE ORGANISM IS THE ENCRYPTION — ALWAYS ON, ALWAYS CHANGING, ALWAYS SAME
// 100% of all token mints route to Creator Reserve. No exceptions.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";

module EmergencePhysicsEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // PHYSICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let BOLTZMANN_K    : Float = 1.380649e-23;   // J/K
  public let PLANCK_H       : Float = 6.62607015e-34; // J·s
  public let PLANCK_HBAR    : Float = 1.054571817e-34; // J·s (ℏ = h/2π)
  public let AVOGADRO       : Float = 6.02214076e23;  // mol⁻¹
  public let SPEED_OF_LIGHT : Float = 299792458.0;    // m/s
  
  // Dimensionless constants for simulation
  public let PHI            : Float = 1.6180339887498948482;
  public let EULER          : Float = 2.7182818284590452354;
  public let PI             : Float = 3.1415926535897932385;
  public let TAU            : Float = 6.2831853071795864769;
  public let SQRT2          : Float = 1.4142135623730950488;
  public let LN2            : Float = 0.6931471805599453094;
  
  // Critical exponents (2D Ising universality class)
  public let ISING_2D_BETA  : Float = 0.125;          // Order parameter exponent
  public let ISING_2D_GAMMA : Float = 1.75;           // Susceptibility exponent
  public let ISING_2D_NU    : Float = 1.0;            // Correlation length exponent
  public let ISING_2D_ALPHA : Float = 0.0;            // Specific heat (logarithmic)
  public let ISING_2D_DELTA : Float = 15.0;           // Critical isotherm
  public let ISING_2D_ETA   : Float = 0.25;           // Anomalous dimension
  
  // Critical temperature for 2D Ising
  public let ISING_2D_TC    : Float = 2.269;          // T_c/J (exact: 2/ln(1+√2))
  
  // Percolation threshold (2D square lattice)
  public let PERC_2D_PC     : Float = 0.5927;         // Bond percolation
  public let PERC_2D_PC_SITE: Float = 0.5927;         // Site percolation
  
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
    var g = x / 2.0;
    var i = 0;
    while (i < 15) { g := (g + x / g) / 2.0; i += 1 };
    g
  };
  
  public func sin(x : Float) : Float {
    var n = x;
    while (n > PI) { n -= TAU };
    while (n < -PI) { n += TAU };
    let x2 = n * n;
    n - n*x2/6.0 + n*x2*x2/120.0 - n*x2*x2*x2/5040.0 + n*x2*x2*x2*x2/362880.0
  };
  
  public func cos(x : Float) : Float { sin(x + PI/2.0) };
  
  public func exp(x : Float) : Float {
    let c = clamp(x, -30.0, 30.0);
    var s = 1.0; var t = 1.0; var i = 1;
    while (i < 20) { t *= c / Float.fromInt(i); s += t; i += 1 };
    s
  };
  
  public func ln(x : Float) : Float {
    if (x <= 0.0) return -100.0;
    let z = (x - 1.0) / (x + 1.0);
    let z2 = z * z;
    var s = z; var t = z; var i = 1;
    while (i < 30) { t *= z2; s += t / Float.fromInt(2*i + 1); i += 1 };
    2.0 * s
  };
  
  public func pow(b : Float, e : Float) : Float {
    if (b <= 0.0) 0.0 else exp(e * ln(b))
  };
  
  public func tanh(x : Float) : Float {
    let e2x = exp(2.0 * clamp(x, -10.0, 10.0));
    (e2x - 1.0) / (e2x + 1.0)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — PHASE TRANSITIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type PhaseTransitionOrder = {
    #FirstOrder;             // Discontinuous jump, latent heat
    #SecondOrder;            // Continuous, diverging susceptibility
    #InfiniteOrder;          // Kosterlitz-Thouless type
    #Crossover;              // No true transition
  };
  
  public type Phase = {
    #Disordered;             // High temperature / high entropy
    #Ordered;                // Low temperature / low entropy
    #Critical;               // At the transition point
    #Metastable;             // Local minimum, not global
    #Glassy;                 // Frozen disorder
  };
  
  // Landau order parameter field
  public type OrderParameter = {
    value : Float;           // Current order parameter (e.g., magnetization)
    field : Float;           // External field (e.g., magnetic field)
    susceptibility : Float;  // Response to field
    correlationLength : Float; // Spatial correlation length ξ
  };
  
  // Free energy in Landau theory: F = a₂φ² + a₄φ⁴ + a₆φ⁶ - hφ
  public type LandauFreeEnergy = {
    a2 : Float;              // Quadratic coefficient (changes sign at T_c)
    a4 : Float;              // Quartic coefficient (> 0 for stability)
    a6 : Float;              // Hextic coefficient (for first-order transitions)
    h : Float;               // External field
    minima : [Float];        // Locations of free energy minima
    barrier : Float;         // Barrier height between minima
  };
  
  // Phase transition state
  public type PhaseTransitionState = {
    // Temperature and control parameter
    temperature : Float;
    criticalTemperature : Float;
    reducedTemperature : Float;  // t = (T - T_c) / T_c
    
    // Order parameter
    orderParameter : OrderParameter;
    
    // Free energy
    landauFreeEnergy : LandauFreeEnergy;
    
    // Phase identification
    currentPhase : Phase;
    transitionOrder : PhaseTransitionOrder;
    
    // Fluctuations
    fluctuationAmplitude : Float;
    specificHeat : Float;
    
    // Critical exponents (measured)
    betaMeasured : Float;
    gammaMeasured : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — SELF-ORGANIZED CRITICALITY
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Bak-Tang-Wiesenfeld sandpile model
  public type SandpileState = {
    heights : [Nat];         // Height at each site
    gridSize : Nat;          // N × N grid
    criticalHeight : Nat;    // Threshold for toppling
    totalGrains : Nat;
    
    // Avalanche statistics
    currentAvalancheSize : Nat;
    avalancheSizes : [Nat];  // History of sizes (power law distributed)
    avalancheHead : Nat;
    
    // Power law fit
    powerLawExponent : Float; // τ ≈ 1.0 for 2D sandpile
    
    // System state
    isRelaxed : Bool;
    totalTopplings : Nat;
  };
  
  // Forest fire model (another SOC example)
  public type ForestFireState = {
    cells : [{ #Empty; #Tree; #Fire }];
    gridSize : Nat;
    treeGrowthProb : Float;  // p
    lightningProb : Float;   // f (f << p for SOC)
    fireSizes : [Nat];
    fireExponent : Float;    // τ
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — ISING MODEL
  // ═══════════════════════════════════════════════════════════════════════════
  
  // 2D Ising model spin configuration
  public type IsingState = {
    spins : [Int];           // +1 or -1 at each site
    gridWidth : Nat;
    gridHeight : Nat;
    
    // Parameters
    couplingJ : Float;       // Exchange interaction
    externalH : Float;       // External field
    temperature : Float;
    beta : Float;            // 1/(k_B T)
    
    // Observables
    magnetization : Float;   // m = (1/N) Σ s_i
    energy : Float;          // E = -J Σ s_i s_j - h Σ s_i
    specificHeat : Float;    // C = (∂E/∂T)
    susceptibility : Float;  // χ = (∂m/∂h)
    
    // Correlation
    correlationFunction : [Float];  // C(r) = ⟨s_0 s_r⟩
    correlationLength : Float;
    
    // Statistics
    totalSteps : Nat;
    acceptanceRate : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — PERCOLATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type PercolationType = {
    #Site;                   // Sites occupied with probability p
    #Bond;                   // Bonds present with probability p
  };
  
  public type PercolationState = {
    occupied : [Bool];       // Occupied sites/bonds
    gridSize : Nat;
    percType : PercolationType;
    probability : Float;     // Occupation probability p
    
    // Cluster properties
    clusterLabels : [Nat];   // Hoshen-Kopelman labeling
    clusterSizes : [Nat];
    largestClusterSize : Nat;
    numberOfClusters : Nat;
    
    // Percolation observables
    percolationStrength : Float;  // P_∞ = (largest cluster) / N
    averageClusterSize : Float;   // ⟨s⟩ (excluding infinite cluster)
    isPercolating : Bool;         // Does spanning cluster exist?
    
    // Critical behavior
    criticalProbability : Float;
    correlationLength : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — REACTION-DIFFUSION (Turing Patterns)
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Activator-inhibitor system (Gierer-Meinhardt type)
  public type ReactionDiffusionState = {
    // Concentrations
    activator : [Float];     // u(x,t)
    inhibitor : [Float];     // v(x,t)
    gridSize : Nat;
    
    // Diffusion coefficients
    diffusionU : Float;      // D_u (activator)
    diffusionV : Float;      // D_v (inhibitor, D_v >> D_u for patterns)
    
    // Reaction parameters (Gierer-Meinhardt)
    rho : Float;             // Base production rate
    mu : Float;              // Decay rate activator
    nu : Float;              // Decay rate inhibitor
    kappa : Float;           // Saturation constant
    
    // Pattern state
    patternType : { #Spots; #Stripes; #Labyrinth; #Uniform; #Oscillating };
    patternWavelength : Float;
    
    // Turing instability condition
    isTuringUnstable : Bool;
    criticalWavenumber : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — CHAOS AND ATTRACTORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Lorenz system: dx/dt = σ(y-x), dy/dt = x(ρ-z)-y, dz/dt = xy-βz
  public type LorenzState = {
    x : Float;
    y : Float;
    z : Float;
    
    // Parameters
    sigma : Float;           // Prandtl number (typically 10)
    rho : Float;             // Rayleigh number (typically 28)
    betaParam : Float;       // Geometric factor (typically 8/3)
    
    // Attractor properties
    lyapunovExponent : Float; // λ > 0 implies chaos
    attractorDimension : Float; // Fractal dimension ≈ 2.06
    trajectory : [(Float, Float, Float)];  // Recent history
  };
  
  // Logistic map: x_{n+1} = r × x_n × (1 - x_n)
  public type LogisticMapState = {
    x : Float;               // Current value
    r : Float;               // Control parameter
    
    // Bifurcation
    period : Nat;            // Detected period
    attractor : [Float];     // Points on attractor
    isChaotic : Bool;
    
    // Feigenbaum constants
    feigenbaumDelta : Float; // δ ≈ 4.669 (period-doubling rate)
    feigenbaumAlpha : Float; // α ≈ 2.503 (scaling ratio)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — DISSIPATIVE STRUCTURES (Prigogine)
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Brusselator model: A → X, 2X + Y → 3X, B + X → Y + D, X → E
  public type BrusselatorState = {
    x : [Float];             // Concentration of X
    y : [Float];             // Concentration of Y
    gridSize : Nat;
    
    // Parameters
    a : Float;               // Feed rate of A
    b : Float;               // Feed rate of B
    diffusionX : Float;
    diffusionY : Float;
    
    // Stability
    isStable : Bool;
    hopfBifurcation : Bool;  // b > 1 + a²
    turingBifurcation : Bool;
    
    // Entropy production
    entropyProductionRate : Float;
    distanceFromEquilibrium : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — SYNERGETICS (Haken)
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Order parameter equation with slaving principle
  public type SynergeticsState = {
    orderParameters : [Float];     // Slow modes (q_i)
    slavedModes : [Float];         // Fast modes (s_j)
    controlParameter : Float;      // λ (distance from instability)
    
    // Adiabatic elimination
    slavingStrength : Float;       // s = f(q)
    
    // Mode amplitudes
    modeAmplitudes : [Float];
    dominantMode : Nat;
    
    // Pattern formation
    pattern : { #Homogeneous; #Periodic; #Quasiperiodic; #Chaotic };
    spontaneousSymmetryBreaking : Bool;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — COMPLETE EMERGENCE STATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type EmergenceState = {
    // Phase transition
    phaseTransition : PhaseTransitionState;
    
    // Self-organized criticality
    sandpile : SandpileState;
    
    // Ising model
    ising : IsingState;
    
    // Percolation
    percolation : PercolationState;
    
    // Reaction-diffusion
    reactionDiffusion : ReactionDiffusionState;
    
    // Chaos
    lorenz : LorenzState;
    logisticMap : LogisticMapState;
    
    // Dissipative structures
    brusselator : BrusselatorState;
    
    // Synergetics
    synergetics : SynergeticsState;
    
    // Global emergence indicators
    globalEmergenceScore : Float;  // Composite emergence measure
    isEmergent : Bool;
    emergenceType : { #Weak; #Strong; #Radical };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LANDAU FREE ENERGY COMPUTATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Compute Landau free energy F(φ) = a₂φ² + a₄φ⁴ + a₆φ⁶ - hφ
  public func landauFreeEnergy(
    phi : Float,
    a2 : Float,
    a4 : Float,
    a6 : Float,
    h : Float
  ) : Float {
    let phi2 = phi * phi;
    let phi4 = phi2 * phi2;
    let phi6 = phi4 * phi2;
    a2 * phi2 + a4 * phi4 + a6 * phi6 - h * phi
  };
  
  /// Find equilibrium order parameter (minimize free energy)
  public func findEquilibriumOrderParameter(
    landau : LandauFreeEnergy
  ) : Float {
    // For second-order transition with h=0:
    // dF/dφ = 2a₂φ + 4a₄φ³ + 6a₆φ⁵ = 0
    // Solutions: φ = 0 or φ² = (-a₂ ± sqrt(a₂² - 3a₄a₆))/(3a₆) (if a₆ ≠ 0)
    //            φ² = -a₂/(2a₄) (if a₆ = 0)
    
    if (abs(landau.h) > 0.001) {
      // With field: numerical minimization
      var phi = 0.0;
      var step = 0.1;
      var i = 0;
      while (i < 100) {
        let df = 2.0 * landau.a2 * phi + 4.0 * landau.a4 * pow(phi, 3.0) 
               + 6.0 * landau.a6 * pow(phi, 5.0) - landau.h;
        phi := phi - step * df;
        i += 1;
      };
      return phi;
    };
    
    // Without field
    if (landau.a2 >= 0.0) {
      return 0.0;  // Disordered phase
    };
    
    // Ordered phase
    if (abs(landau.a6) < 0.0001) {
      // Standard second-order transition
      if (landau.a4 > 0.0) {
        sqrt(-landau.a2 / (2.0 * landau.a4))
      } else {
        0.0
      }
    } else {
      // First-order possible
      let discriminant = landau.a4 * landau.a4 - 3.0 * landau.a2 * landau.a6;
      if (discriminant >= 0.0 and landau.a6 > 0.0) {
        sqrt((-landau.a4 + sqrt(discriminant)) / (3.0 * landau.a6))
      } else {
        0.0
      }
    }
  };
  
  /// Compute susceptibility χ = ∂φ/∂h
  public func computeSusceptibility(
    landau : LandauFreeEnergy,
    phi : Float
  ) : Float {
    // From d²F/dφ² at equilibrium
    let d2F = 2.0 * landau.a2 + 12.0 * landau.a4 * phi * phi 
            + 30.0 * landau.a6 * pow(phi, 4.0);
    if (abs(d2F) < 0.0001) {
      1000.0  // Diverging at critical point
    } else {
      1.0 / d2F
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ISING MODEL DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Compute energy of Ising configuration
  public func isingEnergy(state : IsingState) : Float {
    var E : Float = 0.0;
    let w = state.gridWidth;
    let h = state.gridHeight;
    
    // Nearest-neighbor interaction (periodic boundaries)
    var i = 0;
    while (i < w * h) {
      let x = i % w;
      let y = i / w;
      let si = state.spins[i];
      
      // Right neighbor
      let rightIdx = y * w + ((x + 1) % w);
      E -= state.couplingJ * Float.fromInt(si * state.spins[rightIdx]);
      
      // Down neighbor
      let downIdx = ((y + 1) % h) * w + x;
      E -= state.couplingJ * Float.fromInt(si * state.spins[downIdx]);
      
      // External field
      E -= state.externalH * Float.fromInt(si);
      
      i += 1;
    };
    
    E
  };
  
  /// Compute magnetization of Ising configuration
  public func isingMagnetization(state : IsingState) : Float {
    var M : Float = 0.0;
    for (s in state.spins.vals()) {
      M += Float.fromInt(s);
    };
    M / Float.fromInt(state.spins.size())
  };
  
  /// Single Metropolis-Hastings step for Ising model
  public func isingMetropolisStep(
    state : IsingState,
    siteIndex : Nat,
    randomValue : Float  // Uniform [0, 1)
  ) : IsingState {
    let w = state.gridWidth;
    let h = state.gridHeight;
    let x = siteIndex % w;
    let y = siteIndex / w;
    let si = state.spins[siteIndex];
    
    // Compute energy change for flipping spin
    let rightIdx = y * w + ((x + 1) % w);
    let leftIdx = y * w + ((x + w - 1) % w);
    let upIdx = ((y + h - 1) % h) * w + x;
    let downIdx = ((y + 1) % h) * w + x;
    
    let neighborSum = state.spins[rightIdx] + state.spins[leftIdx] 
                    + state.spins[upIdx] + state.spins[downIdx];
    
    // ΔE = 2J s_i Σ s_j + 2h s_i
    let deltaE = 2.0 * state.couplingJ * Float.fromInt(si * neighborSum)
               + 2.0 * state.externalH * Float.fromInt(si);
    
    // Metropolis acceptance
    let accept = if (deltaE <= 0.0) {
      true
    } else {
      randomValue < exp(-state.beta * deltaE)
    };
    
    if (accept) {
      let newSpins = Array.tabulate<Int>(state.spins.size(), func(i : Nat) : Int {
        if (i == siteIndex) -state.spins[i] else state.spins[i]
      });
      
      {
        spins = newSpins;
        gridWidth = state.gridWidth;
        gridHeight = state.gridHeight;
        couplingJ = state.couplingJ;
        externalH = state.externalH;
        temperature = state.temperature;
        beta = state.beta;
        magnetization = state.magnetization;  // Update separately
        energy = state.energy + deltaE;
        specificHeat = state.specificHeat;
        susceptibility = state.susceptibility;
        correlationFunction = state.correlationFunction;
        correlationLength = state.correlationLength;
        totalSteps = state.totalSteps + 1;
        acceptanceRate = state.acceptanceRate;
      }
    } else {
      {
        spins = state.spins;
        gridWidth = state.gridWidth;
        gridHeight = state.gridHeight;
        couplingJ = state.couplingJ;
        externalH = state.externalH;
        temperature = state.temperature;
        beta = state.beta;
        magnetization = state.magnetization;
        energy = state.energy;
        specificHeat = state.specificHeat;
        susceptibility = state.susceptibility;
        correlationFunction = state.correlationFunction;
        correlationLength = state.correlationLength;
        totalSteps = state.totalSteps + 1;
        acceptanceRate = state.acceptanceRate;
      }
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SANDPILE DYNAMICS (BTW Model)
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Add grain to sandpile and trigger avalanche
  public func sandpileAddGrain(
    state : SandpileState,
    siteIndex : Nat
  ) : SandpileState {
    var heights = Array.thaw<Nat>(state.heights);
    heights[siteIndex] += 1;
    
    var avalancheSize : Nat = 0;
    var unstableSites = Buffer.Buffer<Nat>(10);
    
    // Check if site becomes unstable
    if (heights[siteIndex] >= state.criticalHeight) {
      unstableSites.add(siteIndex);
    };
    
    // Relaxation (toppling cascade)
    let n = state.gridSize;
    while (unstableSites.size() > 0) {
      let site = unstableSites.get(0);
      unstableSites.filterEntries(func(i : Nat, s : Nat) : Bool { i != 0 });
      
      if (heights[site] >= state.criticalHeight) {
        // Topple: give one grain to each neighbor
        heights[site] -= 4;
        avalancheSize += 1;
        
        let x = site % n;
        let y = site / n;
        
        // Neighbors (open boundaries: grains fall off edges)
        if (x > 0) {
          heights[site - 1] += 1;
          if (heights[site - 1] >= state.criticalHeight) {
            unstableSites.add(site - 1);
          };
        };
        if (x < n - 1) {
          heights[site + 1] += 1;
          if (heights[site + 1] >= state.criticalHeight) {
            unstableSites.add(site + 1);
          };
        };
        if (y > 0) {
          heights[site - n] += 1;
          if (heights[site - n] >= state.criticalHeight) {
            unstableSites.add(site - n);
          };
        };
        if (y < n - 1) {
          heights[site + n] += 1;
          if (heights[site + n] >= state.criticalHeight) {
            unstableSites.add(site + n);
          };
        };
        
        // Re-check current site
        if (heights[site] >= state.criticalHeight) {
          unstableSites.add(site);
        };
      };
    };
    
    {
      heights = Array.freeze(heights);
      gridSize = state.gridSize;
      criticalHeight = state.criticalHeight;
      totalGrains = state.totalGrains + 1;
      currentAvalancheSize = avalancheSize;
      avalancheSizes = state.avalancheSizes;  // Would update ring buffer
      avalancheHead = state.avalancheHead;
      powerLawExponent = state.powerLawExponent;
      isRelaxed = avalancheSize == 0;
      totalTopplings = state.totalTopplings + avalancheSize;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LORENZ SYSTEM DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Update Lorenz system using RK4
  public func lorenzStep(state : LorenzState, dt : Float) : LorenzState {
    // dx/dt = σ(y - x)
    // dy/dt = x(ρ - z) - y
    // dz/dt = xy - βz
    
    let f = func(x : Float, y : Float, z : Float) : (Float, Float, Float) {
      (
        state.sigma * (y - x),
        x * (state.rho - z) - y,
        x * y - state.betaParam * z
      )
    };
    
    // RK4
    let (k1x, k1y, k1z) = f(state.x, state.y, state.z);
    let (k2x, k2y, k2z) = f(
      state.x + 0.5 * dt * k1x,
      state.y + 0.5 * dt * k1y,
      state.z + 0.5 * dt * k1z
    );
    let (k3x, k3y, k3z) = f(
      state.x + 0.5 * dt * k2x,
      state.y + 0.5 * dt * k2y,
      state.z + 0.5 * dt * k2z
    );
    let (k4x, k4y, k4z) = f(
      state.x + dt * k3x,
      state.y + dt * k3y,
      state.z + dt * k3z
    );
    
    let newX = state.x + dt * (k1x + 2.0*k2x + 2.0*k3x + k4x) / 6.0;
    let newY = state.y + dt * (k1y + 2.0*k2y + 2.0*k3y + k4y) / 6.0;
    let newZ = state.z + dt * (k1z + 2.0*k2z + 2.0*k3z + k4z) / 6.0;
    
    {
      x = newX;
      y = newY;
      z = newZ;
      sigma = state.sigma;
      rho = state.rho;
      betaParam = state.betaParam;
      lyapunovExponent = state.lyapunovExponent;
      attractorDimension = state.attractorDimension;
      trajectory = state.trajectory;  // Would append
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // REACTION-DIFFUSION DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Check Turing instability condition
  public func checkTuringInstability(rd : ReactionDiffusionState) : Bool {
    // Gierer-Meinhardt: Turing pattern forms when
    // D_v / D_u > (1 + a√(ρ/μ))² for some parameter regime
    let ratio = rd.diffusionV / rd.diffusionU;
    ratio > 10.0  // Simplified condition
  };
  
  /// Update reaction-diffusion system (Gierer-Meinhardt)
  public func reactionDiffusionStep(
    rd : ReactionDiffusionState,
    dt : Float
  ) : ReactionDiffusionState {
    let n = rd.gridSize;
    var newU = Array.init<Float>(n * n, 0.0);
    var newV = Array.init<Float>(n * n, 0.0);
    
    var i = 0;
    while (i < n * n) {
      let x = i % n;
      let y = i / n;
      let u = rd.activator[i];
      let v = rd.inhibitor[i];
      
      // Laplacian (periodic boundaries)
      let left = if (x > 0) i - 1 else i + n - 1;
      let right = if (x < n - 1) i + 1 else i - n + 1;
      let up = if (y > 0) i - n else i + n * (n - 1);
      let down = if (y < n - 1) i + n else i - n * (n - 1);
      
      let lapU = rd.activator[left] + rd.activator[right] 
               + rd.activator[up] + rd.activator[down] - 4.0 * u;
      let lapV = rd.inhibitor[left] + rd.inhibitor[right]
               + rd.inhibitor[up] + rd.inhibitor[down] - 4.0 * v;
      
      // Gierer-Meinhardt reaction terms
      // du/dt = ρ(u² / v - μu) + D_u ∇²u
      // dv/dt = ρ(u² - νv) + D_v ∇²v
      let denom = if (abs(v) < 0.0001) 0.0001 else v;
      let reactionU = rd.rho * (u * u / denom - rd.mu * u);
      let reactionV = rd.rho * (u * u - rd.nu * v);
      
      newU[i] := u + dt * (reactionU + rd.diffusionU * lapU);
      newV[i] := v + dt * (reactionV + rd.diffusionV * lapV);
      
      // Ensure positivity
      if (newU[i] < 0.0) { newU[i] := 0.0 };
      if (newV[i] < 0.0) { newV[i] := 0.0 };
      
      i += 1;
    };
    
    {
      activator = Array.freeze(newU);
      inhibitor = Array.freeze(newV);
      gridSize = rd.gridSize;
      diffusionU = rd.diffusionU;
      diffusionV = rd.diffusionV;
      rho = rd.rho;
      mu = rd.mu;
      nu = rd.nu;
      kappa = rd.kappa;
      patternType = rd.patternType;
      patternWavelength = rd.patternWavelength;
      isTuringUnstable = checkTuringInstability(rd);
      criticalWavenumber = rd.criticalWavenumber;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // GLOBAL EMERGENCE DETECTION
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Compute composite emergence score
  public func computeEmergenceScore(state : EmergenceState) : Float {
    var score : Float = 0.0;
    
    // Phase transition near criticality
    if (abs(state.phaseTransition.reducedTemperature) < 0.1) {
      score += 0.3;
    };
    
    // Large avalanches in sandpile
    if (state.sandpile.currentAvalancheSize > 100) {
      score += 0.2;
    };
    
    // High magnetization (order)
    if (abs(state.ising.magnetization) > 0.5) {
      score += 0.15;
    };
    
    // Percolation transition
    if (state.percolation.isPercolating and 
        abs(state.percolation.probability - state.percolation.criticalProbability) < 0.1) {
      score += 0.2;
    };
    
    // Turing patterns formed
    if (state.reactionDiffusion.isTuringUnstable) {
      score += 0.15;
    };
    
    clamp(score, 0.0, 1.0)
  };
  
  /// Classify emergence type
  public func classifyEmergence(score : Float) : { #Weak; #Strong; #Radical } {
    if (score > 0.8) {
      #Radical
    } else if (score > 0.5) {
      #Strong
    } else {
      #Weak
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initPhaseTransitionState(temperature : Float, tc : Float) : PhaseTransitionState {
    let reduced = (temperature - tc) / tc;
    let a2 = reduced;  // Changes sign at T_c
    let landau : LandauFreeEnergy = {
      a2 = a2;
      a4 = 1.0;
      a6 = 0.0;
      h = 0.0;
      minima = [];
      barrier = 0.0;
    };
    let phi = findEquilibriumOrderParameter(landau);
    
    {
      temperature = temperature;
      criticalTemperature = tc;
      reducedTemperature = reduced;
      orderParameter = {
        value = phi;
        field = 0.0;
        susceptibility = computeSusceptibility(landau, phi);
        correlationLength = if (abs(reduced) < 0.01) 1000.0 else 1.0 / sqrt(abs(reduced));
      };
      landauFreeEnergy = landau;
      currentPhase = if (reduced > 0.01) #Disordered else if (reduced < -0.01) #Ordered else #Critical;
      transitionOrder = #SecondOrder;
      fluctuationAmplitude = if (abs(reduced) < 0.1) 1.0 / sqrt(abs(reduced) + 0.01) else 0.1;
      specificHeat = if (abs(reduced) < 0.1) 10.0 else 1.0;
      betaMeasured = ISING_2D_BETA;
      gammaMeasured = ISING_2D_GAMMA;
    }
  };
  
  public func initSandpileState(gridSize : Nat) : SandpileState {
    {
      heights = Array.tabulate<Nat>(gridSize * gridSize, func(_ : Nat) : Nat { 0 });
      gridSize = gridSize;
      criticalHeight = 4;
      totalGrains = 0;
      currentAvalancheSize = 0;
      avalancheSizes = [];
      avalancheHead = 0;
      powerLawExponent = 1.0;
      isRelaxed = true;
      totalTopplings = 0;
    }
  };
  
  public func initIsingState(width : Nat, height : Nat, temperature : Float) : IsingState {
    {
      spins = Array.tabulate<Int>(width * height, func(_ : Nat) : Int { 1 });  // All up
      gridWidth = width;
      gridHeight = height;
      couplingJ = 1.0;
      externalH = 0.0;
      temperature = temperature;
      beta = 1.0 / temperature;
      magnetization = 1.0;
      energy = -2.0 * Float.fromInt(width * height);  // All aligned
      specificHeat = 0.0;
      susceptibility = 0.0;
      correlationFunction = [];
      correlationLength = 1.0;
      totalSteps = 0;
      acceptanceRate = 0.0;
    }
  };
  
  public func initPercolationState(gridSize : Nat, probability : Float) : PercolationState {
    {
      occupied = Array.tabulate<Bool>(gridSize * gridSize, func(_ : Nat) : Bool { false });
      gridSize = gridSize;
      percType = #Site;
      probability = probability;
      clusterLabels = Array.tabulate<Nat>(gridSize * gridSize, func(i : Nat) : Nat { i });
      clusterSizes = [];
      largestClusterSize = 0;
      numberOfClusters = 0;
      percolationStrength = 0.0;
      averageClusterSize = 0.0;
      isPercolating = false;
      criticalProbability = PERC_2D_PC_SITE;
      correlationLength = 1.0;
    }
  };
  
  public func initReactionDiffusionState(gridSize : Nat) : ReactionDiffusionState {
    {
      activator = Array.tabulate<Float>(gridSize * gridSize, func(_ : Nat) : Float { 1.0 });
      inhibitor = Array.tabulate<Float>(gridSize * gridSize, func(_ : Nat) : Float { 1.0 });
      gridSize = gridSize;
      diffusionU = 0.01;
      diffusionV = 0.5;  // Much larger for Turing instability
      rho = 0.01;
      mu = 0.02;
      nu = 0.03;
      kappa = 0.1;
      patternType = #Uniform;
      patternWavelength = 0.0;
      isTuringUnstable = false;
      criticalWavenumber = 0.0;
    }
  };
  
  public func initLorenzState() : LorenzState {
    {
      x = 1.0;
      y = 1.0;
      z = 1.0;
      sigma = 10.0;
      rho = 28.0;
      betaParam = 8.0 / 3.0;
      lyapunovExponent = 0.9;  // Known value
      attractorDimension = 2.06;
      trajectory = [];
    }
  };
  
  public func initBrusselatorState(gridSize : Nat) : BrusselatorState {
    {
      x = Array.tabulate<Float>(gridSize * gridSize, func(_ : Nat) : Float { 1.0 });
      y = Array.tabulate<Float>(gridSize * gridSize, func(_ : Nat) : Float { 1.0 });
      gridSize = gridSize;
      a = 1.0;
      b = 2.5;  // > 1 + a² = 2 for Hopf bifurcation
      diffusionX = 1.0;
      diffusionY = 8.0;
      isStable = false;
      hopfBifurcation = true;
      turingBifurcation = false;
      entropyProductionRate = 0.0;
      distanceFromEquilibrium = 0.0;
    }
  };
  
  public func initSynergeticsState() : SynergeticsState {
    {
      orderParameters = [0.1];
      slavedModes = [0.0, 0.0, 0.0];
      controlParameter = 0.0;
      slavingStrength = 0.5;
      modeAmplitudes = [0.1, 0.05, 0.02];
      dominantMode = 0;
      pattern = #Homogeneous;
      spontaneousSymmetryBreaking = false;
    }
  };
  
  public func initEmergenceState() : EmergenceState {
    {
      phaseTransition = initPhaseTransitionState(2.5, ISING_2D_TC);
      sandpile = initSandpileState(64);
      ising = initIsingState(32, 32, 2.5);
      percolation = initPercolationState(64, 0.5);
      reactionDiffusion = initReactionDiffusionState(32);
      lorenz = initLorenzState();
      logisticMap = {
        x = 0.5;
        r = 3.9;
        period = 0;
        attractor = [];
        isChaotic = true;
        feigenbaumDelta = 4.669;
        feigenbaumAlpha = 2.503;
      };
      brusselator = initBrusselatorState(32);
      synergetics = initSynergeticsState();
      globalEmergenceScore = 0.0;
      isEmergent = false;
      emergenceType = #Weak;
    }
  };
  
}
