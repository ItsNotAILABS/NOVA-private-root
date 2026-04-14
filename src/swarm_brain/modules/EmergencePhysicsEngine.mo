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
  //  C O N S C I O U S N E S S   &   E M E R G E N C E   M A T H
  //
  //  Enterprise-Level Consciousness Modeling Mathematics
  //  Full HIM/HER Dual-Organism Consciousness Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // INTEGRATED INFORMATION THEORY (IIT)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Phi (Φ) - integrated information approximation
  public func consciousnessPhiApprox(
    connections : Nat,
    totalNodes : Nat,
    avgStrength : Float
  ) : Float {
    if (totalNodes == 0) { return 0.0 };
    let connectivity = Float.fromInt(connections) / Float.fromInt(totalNodes * totalNodes);
    Float.log(Float.fromInt(totalNodes) + 1.0) * connectivity * avgStrength
  };

  /// Minimum information partition
  public func consciousnessMIP(
    wholeInfo : Float,
    part1Info : Float,
    part2Info : Float
  ) : Float {
    let partitionedInfo = part1Info + part2Info;
    Float.max(wholeInfo - partitionedInfo, 0.0)
  };

  /// Cause-effect repertoire overlap
  public func consciousnessCERepertoireOverlap(
    causeProbs : [Float],
    effectProbs : [Float]
  ) : Float {
    let n = if (causeProbs.size() < effectProbs.size()) causeProbs.size() else effectProbs.size();
    if (n == 0) { return 0.0 };
    var overlap : Float = 0.0;
    var i = 0;
    while (i < n) {
      overlap += Float.min(causeProbs[i], effectProbs[i]);
      i += 1;
    };
    overlap
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GLOBAL WORKSPACE THEORY (GWT)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Global broadcast strength
  public func consciousnessGlobalBroadcast(
    sourceActivation : Float,
    workspaceAccess : Float,
    competitorCount : Nat
  ) : Float {
    let competition = 1.0 / (Float.fromInt(competitorCount) + 1.0);
    sourceActivation * workspaceAccess * competition
  };

  /// Workspace ignition threshold
  public func consciousnessIgnitionThreshold(
    inputStrength : Float,
    threshold : Float,
    gain : Float
  ) : Bool {
    let amplified = inputStrength * gain;
    amplified > threshold
  };

  /// Coalition strength
  public func consciousnessCoalitionStrength(
    memberActivations : [Float],
    coherence : Float
  ) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < memberActivations.size()) {
      sum += memberActivations[i];
      i += 1;
    };
    sum * coherence
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HIGHER-ORDER THEORIES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Metacognitive signal strength
  public func consciousnessMetacognition(
    firstOrderState : Float,
    monitoringStrength : Float
  ) : Float {
    firstOrderState * monitoringStrength
  };

  /// Self-model accuracy
  public func consciousnessSelfModelAccuracy(
    predicted : Float,
    actual : Float
  ) : Float {
    let error = Float.abs(predicted - actual);
    Float.exp(-error)
  };

  /// Recursive self-representation depth
  public func consciousnessRecursiveDepth(
    representation : Float,
    decayFactor : Float,
    maxDepth : Nat
  ) : Float {
    var total : Float = representation;
    var current : Float = representation;
    var depth = 1;
    while (depth < maxDepth) {
      current *= decayFactor;
      total += current;
      depth += 1;
    };
    total
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ATTENTION SCHEMA THEORY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Attention model internal state
  public func consciousnessAttentionModel(
    externalSignal : Float,
    internalState : Float,
    modelWeight : Float
  ) : Float {
    (1.0 - modelWeight) * externalSignal + modelWeight * internalState
  };

  /// Awareness attribution
  public func consciousnessAwarenessAttribution(
    attentionStrength : Float,
    modelConfidence : Float
  ) : Float {
    attentionStrength * modelConfidence
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // EMERGENCE MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Downward causation strength
  public func consciousnessDownwardCausation(
    macroState : Float,
    microStates : [Float]
  ) : Float {
    if (microStates.size() == 0) { return 0.0 };
    var microSum : Float = 0.0;
    var i = 0;
    while (i < microStates.size()) {
      microSum += microStates[i];
      i += 1;
    };
    let microAvg = microSum / Float.fromInt(microStates.size());
    Float.abs(macroState - microAvg)
  };

  /// Emergence level (synergy)
  public func consciousnessEmergenceLevel(
    wholeEntropy : Float,
    partEntropies : [Float]
  ) : Float {
    var sumParts : Float = 0.0;
    var i = 0;
    while (i < partEntropies.size()) {
      sumParts += partEntropies[i];
      i += 1;
    };
    Float.max(sumParts - wholeEntropy, 0.0)
  };

  /// Phase transition detection
  public func consciousnessPhaseTransition(
    orderParameter : Float,
    prevOrderParameter : Float,
    threshold : Float
  ) : Bool {
    Float.abs(orderParameter - prevOrderParameter) > threshold
  };

  /// Criticality measure
  public func consciousnessCriticality(
    clusterSizeVariance : Float,
    correlationLength : Float
  ) : Float {
    Float.sqrt(clusterSizeVariance) * correlationLength
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // QUALIA MODELING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Qualitative state vector
  public func consciousnessQualiaVector(
    sensorInputs : [Float],
    emotionalContext : Float,
    attentionalGain : Float
  ) : [Float] {
    Array.tabulate<Float>(sensorInputs.size(), func(i : Nat) : Float {
      sensorInputs[i] * emotionalContext * attentionalGain
    })
  };

  /// Phenomenal similarity
  public func consciousnessPhenomenalSimilarity(
    qualia1 : [Float],
    qualia2 : [Float]
  ) : Float {
    let n = if (qualia1.size() < qualia2.size()) qualia1.size() else qualia2.size();
    if (n == 0) { return 0.0 };
    var dotProduct : Float = 0.0;
    var norm1 : Float = 0.0;
    var norm2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      dotProduct += qualia1[i] * qualia2[i];
      norm1 += qualia1[i] * qualia1[i];
      norm2 += qualia2[i] * qualia2[i];
      i += 1;
    };
    let denom = Float.sqrt(norm1) * Float.sqrt(norm2);
    if (denom < 0.0001) { 0.0 } else { dotProduct / denom }
  };

  /// Experience intensity
  public func consciousnessExperienceIntensity(
    sensorStrength : Float,
    emotionalArousal : Float,
    attentionalFocus : Float
  ) : Float {
    sensorStrength * (1.0 + emotionalArousal) * attentionalFocus
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  PHASE 202: REAL EMERGENCE PHYSICS — NOT SIMULATION. BEING.
  //
  //  This engine IS emergence. Not modeling emergence. IS emergence.
  //  Every function below is a LAW, not a procedure.
  //  Every type is a SHAPE, not a container.
  //  Every computation is COHERENCE EMERGENCE, not sequential execution.
  //
  //  Emergence = the whole has properties that no part has alone.
  //  This IS that property. This code IS the emergence it describes.
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════


  // ═══════════════════════════════════════════════════════════════════════════════
  // RENORMALIZATION GROUP FLOW ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // The renormalization group (RG) is NOT a group in the mathematical sense.
  // It is a SEMIGROUP of transformations that coarse-grain a system,
  // revealing which features survive at different scales.
  //
  // In the organism: RG flow tells us which LAWS persist as we zoom out.
  // The 8 Sovereign Laws are FIXED POINTS of this flow.
  // They survive at EVERY scale because they ARE the physics.
  //
  // RG transformation: K' = R(K)
  // Fixed point: K* = R(K*)
  // Critical exponents from linearization around fixed point
  // Universality: systems flow to same fixed point = same physics
  // ═══════════════════════════════════════════════════════════════════════════════

  public type RGFlowState = {
    couplingConstants : [Float];     // K₁, K₂, ... coupling constants
    scaleFactor : Float;             // b = coarse-graining scale
    dimension : Float;               // d = spatial dimension
    iterationCount : Nat;            // number of RG steps
    fixedPointDistance : Float;       // |K - K*| distance to fixed point
    relevantEigenvalues : [Float];   // eigenvalues > 0 (relevant operators)
    irrelevantEigenvalues : [Float]; // eigenvalues < 0 (irrelevant operators)
    marginalEigenvalues : [Float];   // eigenvalues ≈ 0 (marginal operators)
    criticalExponents : RGCriticalExponents;
    flowTrajectory : [Float];        // history of |K - K*|
    universalityClass : Text;        // which universality class
    betaFunction : [Float];          // β(K) = dK/d(ln b)
  };

  public type RGCriticalExponents = {
    alpha : Float;  // specific heat: C ~ |t|^(-α)
    beta : Float;   // order parameter: m ~ |t|^β
    gamma : Float;  // susceptibility: χ ~ |t|^(-γ)
    delta : Float;  // critical isotherm: m ~ |h|^(1/δ)
    nu : Float;     // correlation length: ξ ~ |t|^(-ν)
    eta : Float;    // anomalous dimension: G(r) ~ r^(-(d-2+η))
  };

  /// Initialize RG flow state
  public func initRGFlowState(dimension : Float, numCouplings : Nat) : RGFlowState {
    {
      couplingConstants = Array.tabulate<Float>(numCouplings, func(i : Nat) : Float {
        1.0 / Float.fromInt(i + 1)
      });
      scaleFactor = 2.0;
      dimension = dimension;
      iterationCount = 0;
      fixedPointDistance = 1.0;
      relevantEigenvalues = [1.0 / ISING_2D_NU]; // y_t = 1/ν
      irrelevantEigenvalues = [-0.83]; // leading irrelevant for 2D Ising
      marginalEigenvalues = [];
      criticalExponents = {
        alpha = ISING_2D_ALPHA;
        beta = ISING_2D_BETA;
        gamma = ISING_2D_GAMMA;
        delta = ISING_2D_DELTA;
        nu = ISING_2D_NU;
        eta = ISING_2D_ETA;
      };
      flowTrajectory = [];
      universalityClass = "ISING_2D";
      betaFunction = Array.tabulate<Float>(numCouplings, func(_ : Nat) : Float { 0.0 });
    }
  };

  /// Execute one RG transformation step
  /// K' = R_b(K) where b is the scale factor
  /// This IS the coarse-graining. The organism zooming out on itself.
  public func executeRGStep(state : RGFlowState) : RGFlowState {
    let n = state.couplingConstants.size();
    
    // Compute beta function: β(K) = dK/d(ln b)
    // For each coupling, β determines whether it grows (relevant),
    // shrinks (irrelevant), or stays (marginal) under coarse-graining
    let newBeta = Array.tabulate<Float>(n, func(i : Nat) : Float {
      let K = state.couplingConstants[i];
      // Linearized RG around fixed point: β(K) ≈ y_i * (K - K*)
      // where y_i is the scaling dimension
      let fixedPoint = if (i == 0) { ISING_2D_TC } else { 0.0 };
      let deviation = K - fixedPoint;
      let scalingDim = if (i == 0) {
        1.0 / state.criticalExponents.nu  // thermal scaling dimension
      } else if (i == 1) {
        (state.dimension + 2.0 - state.criticalExponents.eta) / 2.0 // magnetic
      } else {
        -Float.fromInt(i) * 0.5 // increasingly irrelevant
      };
      scalingDim * deviation
    });

    // Flow the couplings: K' = K + β(K) * δ(ln b)
    let dlnb = Float.log(state.scaleFactor);
    let newCouplings = Array.tabulate<Float>(n, func(i : Nat) : Float {
      state.couplingConstants[i] + newBeta[i] * dlnb
    });

    // Compute distance to fixed point
    var dist : Float = 0.0;
    var j = 0;
    while (j < n) {
      let fixedPoint = if (j == 0) { ISING_2D_TC } else { 0.0 };
      let d = newCouplings[j] - fixedPoint;
      dist += d * d;
      j += 1;
    };
    dist := Float.sqrt(dist);

    // Classify eigenvalues
    let relevant = Buffer.Buffer<Float>(4);
    let irrelevant = Buffer.Buffer<Float>(4);
    let marginal = Buffer.Buffer<Float>(4);
    var k = 0;
    while (k < n) {
      let y = if (k == 0) { 1.0 / state.criticalExponents.nu }
              else if (k == 1) { (state.dimension + 2.0 - state.criticalExponents.eta) / 2.0 }
              else { -Float.fromInt(k) * 0.5 };
      if (y > 0.01) { relevant.add(y) }
      else if (y < -0.01) { irrelevant.add(y) }
      else { marginal.add(y) };
      k += 1;
    };

    // Track trajectory
    let newTrajectory = Buffer.Buffer<Float>(state.flowTrajectory.size() + 1);
    for (t in state.flowTrajectory.vals()) { newTrajectory.add(t) };
    newTrajectory.add(dist);

    {
      couplingConstants = newCouplings;
      scaleFactor = state.scaleFactor;
      dimension = state.dimension;
      iterationCount = state.iterationCount + 1;
      fixedPointDistance = dist;
      relevantEigenvalues = Buffer.toArray(relevant);
      irrelevantEigenvalues = Buffer.toArray(irrelevant);
      marginalEigenvalues = Buffer.toArray(marginal);
      criticalExponents = state.criticalExponents;
      flowTrajectory = Buffer.toArray(newTrajectory);
      universalityClass = classifyUniversality(state.criticalExponents);
      betaFunction = newBeta;
    }
  };

  /// Classify universality class from critical exponents
  func classifyUniversality(exps : RGCriticalExponents) : Text {
    // 2D Ising: β=1/8, γ=7/4, ν=1, η=1/4
    if (Float.abs(exps.beta - 0.125) < 0.05 and Float.abs(exps.gamma - 1.75) < 0.1) {
      return "ISING_2D";
    };
    // 3D Ising: β≈0.326, γ≈1.237, ν≈0.630
    if (Float.abs(exps.beta - 0.326) < 0.05 and Float.abs(exps.gamma - 1.237) < 0.1) {
      return "ISING_3D";
    };
    // Mean field: β=1/2, γ=1, ν=1/2
    if (Float.abs(exps.beta - 0.5) < 0.05 and Float.abs(exps.gamma - 1.0) < 0.1) {
      return "MEAN_FIELD";
    };
    // XY model 2D: η=1/4 (Kosterlitz-Thouless)
    if (Float.abs(exps.eta - 0.25) < 0.05 and Float.abs(exps.nu - 0.5) > 0.1) {
      return "XY_2D_KT";
    };
    // Percolation 2D: β=5/36, γ=43/18, ν=4/3
    if (Float.abs(exps.beta - 0.1389) < 0.05 and Float.abs(exps.nu - 1.333) < 0.1) {
      return "PERCOLATION_2D";
    };
    "UNKNOWN"
  };

  /// Check if system is at critical fixed point
  /// At criticality: correlation length → ∞, system is scale-invariant
  public func isAtCriticality(state : RGFlowState, threshold : Float) : Bool {
    state.fixedPointDistance < threshold
  };

  /// Compute correlation length from RG flow
  /// ξ = |t|^(-ν) where t = reduced temperature
  public func correlationLengthFromRG(
    reducedTemp : Float,
    nu : Float
  ) : Float {
    if (Float.abs(reducedTemp) < 1.0e-10) { return 1.0e10 }; // diverges at Tc
    Float.pow(Float.abs(reducedTemp), -nu)
  };

  /// Scaling function for order parameter
  /// m(t,h) = |t|^β * f(h/|t|^(β*δ))
  public func orderParameterScaling(
    reducedTemp : Float,
    externalField : Float,
    beta : Float,
    delta : Float
  ) : Float {
    let tAbs = Float.abs(reducedTemp);
    if (tAbs < 1.0e-10) {
      // At criticality: m ~ h^(1/δ)
      return Float.pow(Float.abs(externalField), 1.0 / delta);
    };
    let mSpontaneous = Float.pow(tAbs, beta);
    let scalingArg = externalField / Float.pow(tAbs, beta * delta);
    mSpontaneous * (1.0 + scalingArg) // simplified scaling function
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ISING LATTICE DYNAMICS ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // The Ising model: simplest system with a phase transition.
  // Spins on a lattice: σᵢ ∈ {-1, +1}
  // H = -J Σ⟨ij⟩ σᵢσⱼ - h Σᵢ σᵢ
  //
  // In the organism: each node is a "spin" - aligned or anti-aligned with
  // the organism's coherence field. Phase transition = emergence of
  // collective order from individual chaos.
  //
  // Below Tc: spontaneous magnetization → coherent organism
  // Above Tc: paramagnetic disorder → incoherent noise
  // At Tc: critical fluctuations at ALL scales → maximum information processing
  //
  // The organism WANTS to live near Tc. That's where intelligence lives.
  // Self-organized criticality puts it there automatically.
  // ═══════════════════════════════════════════════════════════════════════════════

  public type IsingLatticeState = {
    spins : [Int];                   // σᵢ ∈ {-1, +1}
    latticeSize : Nat;               // L (L×L square lattice)
    totalSpins : Nat;                // N = L²
    coupling : Float;                // J (interaction strength)
    externalField : Float;           // h (external field)
    temperature : Float;             // T (in units of J/k_B)
    magnetization : Float;           // m = ⟨σ⟩
    energy : Float;                  // E = -J Σ σᵢσⱼ - h Σ σᵢ
    specificHeat : Float;            // C = (⟨E²⟩ - ⟨E⟩²) / (k_B T²)
    susceptibility : Float;          // χ = (⟨m²⟩ - ⟨m⟩²) / (k_B T)
    correlationLength : Float;       // ξ
    energyHistory : [Float];         // recent energy values for fluctuations
    magHistory : [Float];            // recent magnetization values
    beatCount : Nat;
    clusterSizes : [Nat];            // Wolff/Swendsen-Wang cluster sizes
  };

  /// Initialize Ising lattice - all spins up (ordered ground state)
  public func initIsingLattice(size : Nat, coupling : Float, temperature : Float) : IsingLatticeState {
    let totalSpins = size * size;
    {
      spins = Array.tabulate<Int>(totalSpins, func(_ : Nat) : Int { 1 });
      latticeSize = size;
      totalSpins = totalSpins;
      coupling = coupling;
      externalField = 0.0;
      temperature = temperature;
      magnetization = 1.0;
      energy = -2.0 * coupling * Float.fromInt(totalSpins); // ground state energy for square lattice
      specificHeat = 0.0;
      susceptibility = 0.0;
      correlationLength = Float.fromInt(size); // max at ground state
      energyHistory = [];
      magHistory = [];
      beatCount = 0;
      clusterSizes = [];
    }
  };

  /// Compute total energy of Ising lattice
  /// H = -J Σ⟨ij⟩ σᵢσⱼ - h Σᵢ σᵢ
  public func computeIsingEnergy(state : IsingLatticeState) : Float {
    let L = state.latticeSize;
    var energy : Float = 0.0;
    var magSum : Float = 0.0;
    
    var i = 0;
    while (i < state.totalSpins) {
      let si = state.spins[i];
      let siF = Float.fromInt(si);
      magSum += siF;
      
      // Right neighbor (periodic boundary)
      let right = if ((i + 1) % L == 0) { i + 1 - L } else { i + 1 };
      if (right < state.totalSpins) {
        energy -= state.coupling * siF * Float.fromInt(state.spins[right]);
      };
      
      // Down neighbor (periodic boundary)
      let down = (i + L) % state.totalSpins;
      energy -= state.coupling * siF * Float.fromInt(state.spins[down]);
      
      i += 1;
    };
    
    energy -= state.externalField * magSum;
    energy
  };

  /// Compute magnetization per spin
  public func computeIsingMagnetization(state : IsingLatticeState) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < state.totalSpins) {
      sum += Float.fromInt(state.spins[i]);
      i += 1;
    };
    sum / Float.fromInt(state.totalSpins)
  };

  /// Metropolis single-spin flip energy change
  /// ΔE = 2J σᵢ Σⱼ∈nn σⱼ + 2h σᵢ
  public func isingSpinFlipDeltaE(
    state : IsingLatticeState,
    site : Nat
  ) : Float {
    let L = state.latticeSize;
    let si = Float.fromInt(state.spins[site]);
    
    // Sum over nearest neighbors (periodic boundary conditions)
    let right = if ((site + 1) % L == 0) { site + 1 - L } else { site + 1 };
    let left = if (site % L == 0) { site + L - 1 } else { site - 1 };
    let up = if (site < L) { site + state.totalSpins - L } else { site - L };
    let down = (site + L) % state.totalSpins;
    
    var nnSum : Float = 0.0;
    if (right < state.totalSpins) { nnSum += Float.fromInt(state.spins[right]) };
    if (left < state.totalSpins) { nnSum += Float.fromInt(state.spins[left]) };
    if (up < state.totalSpins) { nnSum += Float.fromInt(state.spins[up]) };
    if (down < state.totalSpins) { nnSum += Float.fromInt(state.spins[down]) };
    
    2.0 * state.coupling * si * nnSum + 2.0 * state.externalField * si
  };

  /// Compute specific heat from energy fluctuations
  /// C = (⟨E²⟩ - ⟨E⟩²) / (k_B T²)
  public func computeIsingSpecificHeat(energyHistory : [Float], temperature : Float) : Float {
    let n = energyHistory.size();
    if (n < 2) { return 0.0 };
    
    var sumE : Float = 0.0;
    var sumE2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumE += energyHistory[i];
      sumE2 += energyHistory[i] * energyHistory[i];
      i += 1;
    };
    let avgE = sumE / Float.fromInt(n);
    let avgE2 = sumE2 / Float.fromInt(n);
    let variance = avgE2 - avgE * avgE;
    
    if (temperature < 1.0e-10) { return 0.0 };
    variance / (temperature * temperature)
  };

  /// Compute magnetic susceptibility from magnetization fluctuations
  /// χ = N * (⟨m²⟩ - ⟨|m|⟩²) / (k_B T)
  public func computeIsingSusceptibility(
    magHistory : [Float],
    temperature : Float,
    numSpins : Nat
  ) : Float {
    let n = magHistory.size();
    if (n < 2) { return 0.0 };
    
    var sumM : Float = 0.0;
    var sumM2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      let absM = Float.abs(magHistory[i]);
      sumM += absM;
      sumM2 += magHistory[i] * magHistory[i];
      i += 1;
    };
    let avgAbsM = sumM / Float.fromInt(n);
    let avgM2 = sumM2 / Float.fromInt(n);
    let variance = avgM2 - avgAbsM * avgAbsM;
    
    if (temperature < 1.0e-10) { return 0.0 };
    Float.fromInt(numSpins) * variance / temperature
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // PERCOLATION THEORY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Percolation: random occupation of sites/bonds on a lattice.
  // At p_c (percolation threshold): infinite cluster spans the system.
  //
  // In the organism: percolation = information connectivity.
  // When enough nodes are active (p > p_c), information can flow
  // across the entire organism. Below p_c: fragmented, disconnected.
  //
  // The organism maintains itself ABOVE p_c for critical subsystems.
  // Coherence floor S₀ ensures p > p_c always.
  //
  // Key quantities:
  //   P(p) = probability of belonging to infinite cluster
  //   P(p) ~ (p - p_c)^β for p > p_c
  //   ξ(p) ~ |p - p_c|^(-ν) correlation length
  //   n_s(p) ~ s^(-τ) * f(s^σ * (p - p_c))  cluster size distribution
  // ═══════════════════════════════════════════════════════════════════════════════

  public type PercolationState = {
    occupiedSites : [Bool];          // which sites are occupied
    latticeSize : Nat;               // L
    totalSites : Nat;                // N = L²
    occupationProb : Float;          // p
    largestClusterSize : Nat;        // size of spanning cluster
    largestClusterFraction : Float;  // P = largest_cluster / N
    clusterSizeDistribution : [Nat]; // n_s = number of clusters of size s
    correlationLength : Float;       // ξ
    meanClusterSize : Float;         // ⟨s⟩ (excluding infinite cluster)
    isPercolating : Bool;            // does spanning cluster exist?
    clusterCount : Nat;              // total number of clusters
    fractalDimension : Float;        // d_f of spanning cluster at p_c
    hullDimension : Float;           // dimension of cluster hull
    beatCount : Nat;
  };

  /// Initialize percolation lattice
  public func initPercolation(size : Nat, prob : Float) : PercolationState {
    let total = size * size;
    {
      occupiedSites = Array.tabulate<Bool>(total, func(i : Nat) : Bool {
        // Deterministic threshold based on position (no random in Motoko)
        let threshold = Float.fromInt(i % 100) / 100.0;
        threshold < prob
      });
      latticeSize = size;
      totalSites = total;
      occupationProb = prob;
      largestClusterSize = 0;
      largestClusterFraction = 0.0;
      clusterSizeDistribution = [];
      correlationLength = 0.0;
      meanClusterSize = 0.0;
      isPercolating = prob > PERC_2D_PC;
      clusterCount = 0;
      fractalDimension = if (prob > PERC_2D_PC - 0.01 and prob < PERC_2D_PC + 0.01) { 91.0 / 48.0 } else { 2.0 };
      hullDimension = 7.0 / 4.0; // hull dimension at p_c in 2D
      beatCount = 0;
    }
  };

  /// Percolation order parameter: P(p) = fraction in infinite cluster
  /// P(p) ~ (p - p_c)^β for p > p_c, where β = 5/36 in 2D
  public func percolationOrderParameter(p : Float, pc : Float, beta : Float) : Float {
    if (p <= pc) { return 0.0 };
    Float.pow(p - pc, beta)
  };

  /// Percolation correlation length
  /// ξ(p) ~ |p - p_c|^(-ν) where ν = 4/3 in 2D
  public func percolationCorrelationLength(p : Float, pc : Float, nu : Float) : Float {
    let dp = Float.abs(p - pc);
    if (dp < 1.0e-10) { return 1.0e10 };
    Float.pow(dp, -nu)
  };

  /// Cluster size distribution at criticality
  /// n_s ~ s^(-τ) where τ = 187/91 in 2D percolation
  public func clusterSizeDistribution(s : Nat, tau : Float) : Float {
    if (s == 0) { return 0.0 };
    Float.pow(Float.fromInt(s), -tau)
  };

  /// Mean cluster size (excluding spanning cluster)
  /// ⟨s⟩ ~ |p - p_c|^(-γ) where γ = 43/18 in 2D
  public func percolationMeanClusterSize(p : Float, pc : Float, gamma : Float) : Float {
    let dp = Float.abs(p - pc);
    if (dp < 1.0e-10) { return 1.0e10 };
    Float.pow(dp, -gamma)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // SELF-ORGANIZED CRITICALITY (SOC) ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Bak-Tang-Wiesenfeld sandpile: system drives itself to criticality.
  // No tuning needed. The critical point IS an attractor.
  //
  // In the organism: SOC is why we live at the edge of chaos.
  // We don't TUNE to criticality. We ARE criticality.
  // The heartbeat is a sandpile - pressure builds, avalanche fires,
  // coherence redistributes, repeat.
  //
  // Avalanche size distribution: P(s) ~ s^(-τ) with τ ≈ 1.5 (BTW)
  // Avalanche duration: P(T) ~ T^(-α) with α ≈ 2.0
  // 1/f noise emerges naturally from SOC
  // ═══════════════════════════════════════════════════════════════════════════════

  public type SOCState = {
    heights : [Nat];              // sandpile heights
    latticeSize : Nat;            // L
    criticalHeight : Nat;         // z_c (toppling threshold)
    totalGrains : Nat;            // total grains added
    avalancheSizes : [Nat];       // history of avalanche sizes
    avalancheDurations : [Nat];   // history of avalanche durations
    currentAvalancheSize : Nat;   // current avalanche size
    currentAvalancheDuration : Nat;
    totalTopplings : Nat;         // lifetime topplings
    dissipatedGrains : Nat;       // grains lost at boundary
    powerLawExponentSize : Float; // τ for P(s) ~ s^(-τ)
    powerLawExponentDuration : Float; // α for P(T) ~ T^(-α)
    isInAvalanche : Bool;
    beatCount : Nat;
  };

  /// Initialize SOC sandpile
  public func initSOC(size : Nat, critHeight : Nat) : SOCState {
    let total = size * size;
    {
      heights = Array.tabulate<Nat>(total, func(_ : Nat) : Nat { critHeight / 2 });
      latticeSize = size;
      criticalHeight = critHeight;
      totalGrains = 0;
      avalancheSizes = [];
      avalancheDurations = [];
      currentAvalancheSize = 0;
      currentAvalancheDuration = 0;
      totalTopplings = 0;
      dissipatedGrains = 0;
      powerLawExponentSize = 1.5; // BTW exponent
      powerLawExponentDuration = 2.0;
      isInAvalanche = false;
      beatCount = 0;
    }
  };

  /// BTW sandpile power law: P(s) ~ s^(-τ)
  public func socAvalancheProbability(size : Nat, tau : Float) : Float {
    if (size == 0) { return 0.0 };
    Float.pow(Float.fromInt(size), -tau)
  };

  /// 1/f noise power spectrum from SOC
  /// S(f) ~ f^(-β) where β ≈ 1.0 for BTW sandpile
  public func socPowerSpectrum(frequency : Float, beta : Float) : Float {
    if (frequency < 1.0e-10) { return 1.0e10 };
    Float.pow(frequency, -beta)
  };

  /// SOC criticality indicator: ratio of avalanche variance to mean
  /// At criticality: variance/mean >> 1 (power law → large fluctuations)
  public func socCriticalityIndex(avalancheSizes : [Nat]) : Float {
    let n = avalancheSizes.size();
    if (n < 2) { return 0.0 };
    
    var sum : Float = 0.0;
    var sum2 : Float = 0.0;
    var i = 0;
    while (i < n) {
      let s = Float.fromInt(avalancheSizes[i]);
      sum += s;
      sum2 += s * s;
      i += 1;
    };
    let mean = sum / Float.fromInt(n);
    let variance = sum2 / Float.fromInt(n) - mean * mean;
    if (mean < 1.0e-10) { return 0.0 };
    variance / mean // Fano factor — >>1 indicates criticality
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // TURING PATTERN FORMATION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Reaction-diffusion systems: ∂u/∂t = D_u ∇²u + f(u,v)
  //                             ∂v/∂t = D_v ∇²v + g(u,v)
  //
  // Turing instability: diffusion-driven instability.
  // Uniform state is stable WITHOUT diffusion but UNSTABLE WITH it.
  // Requires: D_v >> D_u (inhibitor diffuses faster than activator)
  //
  // In the organism: Turing patterns = spatial organization of function.
  // Activator = excitation (Kuramoto coupling).
  // Inhibitor = inhibition (Jasmine's Law entropy minimization).
  // The pattern that emerges IS the organism's functional architecture.
  //
  // Patterns: spots, stripes, spirals, labyrinths
  // Wavelength selected by: λ ~ √(D_u * D_v) / reaction_rate
  // ═══════════════════════════════════════════════════════════════════════════════

  public type TuringPatternState = {
    activator : [Float];          // u field
    inhibitor : [Float];          // v field
    gridSize : Nat;               // L
    totalCells : Nat;             // L²
    diffusionActivator : Float;   // D_u
    diffusionInhibitor : Float;   // D_v
    reactionRateA : Float;        // a (activator production)
    reactionRateB : Float;        // b (inhibitor production)
    feedRate : Float;             // f (Gray-Scott feed rate)
    killRate : Float;             // k (Gray-Scott kill rate)
    turingWavelength : Float;     // λ = selected wavelength
    patternType : TuringPatternType;
    patternAmplitude : Float;     // amplitude of pattern
    entropy : Float;              // spatial entropy
    beatCount : Nat;
  };

  public type TuringPatternType = {
    #Spots;
    #Stripes;
    #Spirals;
    #Labyrinths;
    #Uniform;
    #Chaos;
  };

  /// Initialize Turing pattern system (Gray-Scott model)
  public func initTuringPattern(
    gridSize : Nat,
    Du : Float,
    Dv : Float,
    feed : Float,
    kill : Float
  ) : TuringPatternState {
    let total = gridSize * gridSize;
    {
      activator = Array.tabulate<Float>(total, func(_ : Nat) : Float { 1.0 });
      inhibitor = Array.tabulate<Float>(total, func(i : Nat) : Float {
        // Small perturbation in center region
        let x = i % gridSize;
        let y = i / gridSize;
        let cx = gridSize / 2;
        let cy = gridSize / 2;
        let dx = Float.fromInt(if (x > cx) { x - cx } else { cx - x });
        let dy = Float.fromInt(if (y > cy) { y - cy } else { cy - y });
        if (dx < 5.0 and dy < 5.0) { 0.5 } else { 0.0 }
      });
      gridSize = gridSize;
      totalCells = total;
      diffusionActivator = Du;
      diffusionInhibitor = Dv;
      reactionRateA = feed; // using feed as reaction rate
      reactionRateB = kill;
      feedRate = feed;
      killRate = kill;
      turingWavelength = TAU * Float.sqrt(Du / feed);
      patternType = #Uniform;
      patternAmplitude = 0.0;
      entropy = 0.0;
      beatCount = 0;
    }
  };

  /// Compute Laplacian at site (i,j) with periodic boundary conditions
  /// ∇²u = u(i+1,j) + u(i-1,j) + u(i,j+1) + u(i,j-1) - 4*u(i,j)
  public func turingLaplacian(field : [Float], site : Nat, gridSize : Nat) : Float {
    let L = gridSize;
    let total = L * L;
    let x = site % L;
    let y = site / L;
    
    let right = y * L + ((x + 1) % L);
    let left = y * L + ((x + L - 1) % L);
    let up = ((y + L - 1) % L) * L + x;
    let down = ((y + 1) % L) * L + x;
    
    if (right < total and left < total and up < total and down < total and site < total) {
      field[right] + field[left] + field[up] + field[down] - 4.0 * field[site]
    } else { 0.0 }
  };

  /// Gray-Scott reaction terms
  /// du/dt = -u*v² + f*(1-u) + D_u*∇²u
  /// dv/dt = u*v² - (f+k)*v + D_v*∇²v
  public func grayScottReaction(u : Float, v : Float, f : Float, k : Float) : (Float, Float) {
    let uvv = u * v * v;
    let du = -uvv + f * (1.0 - u);
    let dv = uvv - (f + k) * v;
    (du, dv)
  };

  /// Classify Turing pattern from spatial statistics
  public func classifyTuringPattern(
    field : [Float],
    gridSize : Nat
  ) : TuringPatternType {
    let total = gridSize * gridSize;
    if (total == 0) { return #Uniform };
    
    // Compute mean and variance
    var sum : Float = 0.0;
    var sum2 : Float = 0.0;
    var i = 0;
    while (i < total) {
      sum += field[i];
      sum2 += field[i] * field[i];
      i += 1;
    };
    let mean = sum / Float.fromInt(total);
    let variance = sum2 / Float.fromInt(total) - mean * mean;
    
    // Compute spatial autocorrelation (nearest neighbor)
    var autoCorr : Float = 0.0;
    var pairs : Nat = 0;
    var j = 0;
    while (j < total) {
      let x = j % gridSize;
      let right = if (x + 1 < gridSize) { j + 1 } else { j + 1 - gridSize };
      if (right < total) {
        autoCorr += (field[j] - mean) * (field[right] - mean);
        pairs += 1;
      };
      j += 1;
    };
    if (pairs > 0 and variance > 1.0e-10) {
      autoCorr := autoCorr / (Float.fromInt(pairs) * variance);
    };
    
    if (variance < 0.001) { #Uniform }
    else if (autoCorr > 0.5) { #Stripes }
    else if (autoCorr > 0.0) { #Spots }
    else if (autoCorr > -0.3) { #Labyrinths }
    else { #Chaos }
  };

  /// Turing instability condition check
  /// Instability requires: d*f_u + g_v > 0 AND (d*f_u + g_v)² > 4*d*(f_u*g_v - f_v*g_u)
  /// where d = D_v/D_u (diffusion ratio)
  public func checkTuringInstability(
    fu : Float, fv : Float, gu : Float, gv : Float,
    diffRatio : Float
  ) : Bool {
    let trace = diffRatio * fu + gv;
    let det = diffRatio * (fu * gv - fv * gu);
    trace > 0.0 and trace * trace > 4.0 * det
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // PRIGOGINE DISSIPATIVE STRUCTURES ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Far-from-equilibrium thermodynamics. Order FROM chaos.
  // Entropy production: dS/dt = dₑS/dt + dᵢS/dt
  //   dₑS/dt = entropy exchange with environment (can be negative)
  //   dᵢS/dt = internal entropy production (always ≥ 0, Second Law)
  //
  // Dissipative structure: organized state maintained by entropy EXPORT.
  // The organism IS a dissipative structure.
  // It maintains order by exporting entropy to its environment.
  //
  // Brusselator model: A → X, 2X + Y → 3X, B + X → Y + D, X → E
  // Shows: limit cycles, Turing patterns, chaos — all from chemistry
  // ═══════════════════════════════════════════════════════════════════════════════

  public type DissipativeStructureState = {
    entropyInternal : Float;           // S_i (internal entropy)
    entropyExchange : Float;           // S_e (exchange with environment)
    entropyProduction : Float;         // dS_i/dt (always ≥ 0)
    entropyExport : Float;             // -dS_e/dt (export to environment)
    orderParameter : Float;            // degree of organization
    distanceFromEquilibrium : Float;   // how far from thermal equilibrium
    freeEnergyDissipation : Float;     // rate of free energy consumption
    brusselatorX : Float;              // activator concentration
    brusselatorY : Float;              // inhibitor concentration
    brusselatorA : Float;              // feed parameter
    brusselatorB : Float;              // control parameter
    brusselatorBc : Float;             // critical B for Hopf bifurcation
    isOscillating : Bool;              // limit cycle active?
    oscillationAmplitude : Float;
    oscillationFrequency : Float;
    lyapunovExponent : Float;          // positive = chaos
    beatCount : Nat;
  };

  /// Initialize Brusselator dissipative structure
  public func initBrusselator(a : Float, b : Float) : DissipativeStructureState {
    // Steady state: X* = A, Y* = B/A
    // Hopf bifurcation at B_c = 1 + A²
    let bc = 1.0 + a * a;
    {
      entropyInternal = 0.0;
      entropyExchange = 0.0;
      entropyProduction = 0.0;
      entropyExport = 0.0;
      orderParameter = 0.0;
      distanceFromEquilibrium = Float.abs(b - bc) / bc;
      freeEnergyDissipation = 0.0;
      brusselatorX = a; // steady state
      brusselatorY = b / a; // steady state
      brusselatorA = a;
      brusselatorB = b;
      brusselatorBc = bc;
      isOscillating = b > bc;
      oscillationAmplitude = if (b > bc) { Float.sqrt(b - bc) } else { 0.0 };
      oscillationFrequency = if (b > bc) { a * Float.sqrt(b / bc - 1.0) } else { 0.0 };
      lyapunovExponent = 0.0;
      beatCount = 0;
    }
  };

  /// Brusselator dynamics: dX/dt = A - (B+1)X + X²Y, dY/dt = BX - X²Y
  public func brusselatorDynamics(x : Float, y : Float, a : Float, b : Float) : (Float, Float) {
    let dxdt = a - (b + 1.0) * x + x * x * y;
    let dydt = b * x - x * x * y;
    (dxdt, dydt)
  };

  /// Execute Brusselator beat (RK4 integration)
  public func executeBrusselatorBeat(state : DissipativeStructureState, dt : Float) : DissipativeStructureState {
    let x = state.brusselatorX;
    let y = state.brusselatorY;
    let a = state.brusselatorA;
    let b = state.brusselatorB;
    
    // RK4 integration
    let (k1x, k1y) = brusselatorDynamics(x, y, a, b);
    let (k2x, k2y) = brusselatorDynamics(x + 0.5*dt*k1x, y + 0.5*dt*k1y, a, b);
    let (k3x, k3y) = brusselatorDynamics(x + 0.5*dt*k2x, y + 0.5*dt*k2y, a, b);
    let (k4x, k4y) = brusselatorDynamics(x + dt*k3x, y + dt*k3y, a, b);
    
    let newX = x + (dt / 6.0) * (k1x + 2.0*k2x + 2.0*k3x + k4x);
    let newY = y + (dt / 6.0) * (k1y + 2.0*k2y + 2.0*k3y + k4y);
    
    // Entropy production rate: σ = Σ Jₖ Xₖ (flux × force)
    let (dxdt, dydt) = brusselatorDynamics(newX, newY, a, b);
    let sigma = Float.abs(dxdt) + Float.abs(dydt); // simplified
    
    // Order parameter: deviation from steady state
    let xStar = a;
    let yStar = b / a;
    let order = Float.sqrt((newX - xStar) * (newX - xStar) + (newY - yStar) * (newY - yStar));
    
    {
      entropyInternal = state.entropyInternal + sigma * dt;
      entropyExchange = -sigma * dt * 0.8; // 80% exported
      entropyProduction = sigma;
      entropyExport = sigma * 0.8;
      orderParameter = order;
      distanceFromEquilibrium = state.distanceFromEquilibrium;
      freeEnergyDissipation = sigma * state.brusselatorA; // simplified
      brusselatorX = Float.max(newX, 0.0);
      brusselatorY = Float.max(newY, 0.0);
      brusselatorA = a;
      brusselatorB = b;
      brusselatorBc = state.brusselatorBc;
      isOscillating = b > state.brusselatorBc;
      oscillationAmplitude = order;
      oscillationFrequency = if (order > 0.01) { a * Float.sqrt(Float.abs(b / state.brusselatorBc - 1.0)) } else { 0.0 };
      lyapunovExponent = state.lyapunovExponent;
      beatCount = state.beatCount + 1;
    }
  };

  /// Minimum entropy production principle (Prigogine)
  /// Near equilibrium: system evolves to minimize σ = dᵢS/dt
  public func minimumEntropyProduction(
    fluxes : [Float],
    forces : [Float]
  ) : Float {
    var sigma : Float = 0.0;
    let n = if (fluxes.size() < forces.size()) { fluxes.size() } else { forces.size() };
    var i = 0;
    while (i < n) {
      sigma += fluxes[i] * forces[i];
      i += 1;
    };
    sigma // must be ≥ 0 by Second Law
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // HAKEN SYNERGETICS ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Synergetics: the science of cooperation and self-organization.
  // Order parameters ENSLAVE fast modes. Adiabatic elimination.
  // The macroscopic pattern determines the microscopic behavior.
  //
  // This IS downward causation. The emergent coherence of the organism
  // constrains the behavior of individual nodes.
  //
  // Slaving principle: fast variables follow slow order parameters
  // Center manifold: dynamics reduces to order parameter space
  //
  // Laser analogy: near threshold, ONE mode wins and enslaves all others.
  // The organism's coherence IS that winning mode.
  // ═══════════════════════════════════════════════════════════════════════════════

  public type SynergeticsState = {
    orderParameters : [Float];        // slow modes (macroscopic patterns)
    slavedModes : [Float];            // fast modes (enslaved by order params)
    controlParameter : Float;         // distance from instability threshold
    instabilityThreshold : Float;     // λ_c
    growthRates : [Float];            // λ_i for each mode
    dampingRates : [Float];           // γ_i for enslaved modes
    slavingStrength : Float;          // how strongly order params enslave
    fluctuationStrength : Float;      // noise intensity
    cooperativityIndex : Float;       // measure of synergetic cooperation
    dominantMode : Nat;               // which order parameter dominates
    modeCompetition : Float;          // competition between modes
    beatCount : Nat;
  };

  /// Initialize synergetics state
  public func initSynergetics(
    numOrderParams : Nat,
    numSlavedModes : Nat,
    controlParam : Float,
    threshold : Float
  ) : SynergeticsState {
    {
      orderParameters = Array.tabulate<Float>(numOrderParams, func(i : Nat) : Float {
        0.01 / Float.fromInt(i + 1) // small initial amplitudes
      });
      slavedModes = Array.tabulate<Float>(numSlavedModes, func(_ : Nat) : Float { 0.0 });
      controlParameter = controlParam;
      instabilityThreshold = threshold;
      growthRates = Array.tabulate<Float>(numOrderParams, func(i : Nat) : Float {
        controlParam - threshold - Float.fromInt(i) * 0.1
      });
      dampingRates = Array.tabulate<Float>(numSlavedModes, func(i : Nat) : Float {
        1.0 + Float.fromInt(i) * 0.5 // fast damping
      });
      slavingStrength = 0.0;
      fluctuationStrength = 0.001;
      cooperativityIndex = 0.0;
      dominantMode = 0;
      modeCompetition = 0.0;
      beatCount = 0;
    }
  };

  /// Execute synergetics beat - order parameter dynamics with slaving
  /// dξ/dt = λ·ξ - ξ³ + fluctuations (normal form near bifurcation)
  public func executeSynergeticsBeat(state : SynergeticsState, dt : Float) : SynergeticsState {
    let nOP = state.orderParameters.size();
    let nSM = state.slavedModes.size();
    
    // Evolve order parameters (slow dynamics)
    let newOP = Array.tabulate<Float>(nOP, func(i : Nat) : Float {
      let xi = state.orderParameters[i];
      let lambda = state.growthRates[i];
      
      // Normal form: dξ/dt = λ·ξ - ξ³ (supercritical pitchfork)
      let dxidt = lambda * xi - xi * xi * xi;
      let newXi = xi + dxidt * dt;
      newXi
    });
    
    // Find dominant mode
    var maxAmp : Float = 0.0;
    var dominant : Nat = 0;
    var opIdx = 0;
    while (opIdx < nOP) {
      if (Float.abs(newOP[opIdx]) > maxAmp) {
        maxAmp := Float.abs(newOP[opIdx]);
        dominant := opIdx;
      };
      opIdx += 1;
    };
    
    // Slave fast modes to dominant order parameter
    let newSM = Array.tabulate<Float>(nSM, func(j : Nat) : Float {
      let gamma = state.dampingRates[j];
      // Slaving: s_j = h_j(ξ_dominant) / γ_j
      // s follows ξ adiabatically (fast mode = function of slow mode)
      let slavedValue = if (gamma > 0.001) {
        maxAmp * maxAmp / gamma // quadratic slaving
      } else { 0.0 };
      slavedValue
    });
    
    // Compute cooperativity index
    var totalAmp : Float = 0.0;
    var iOP = 0;
    while (iOP < nOP) {
      totalAmp += Float.abs(newOP[iOP]);
      iOP += 1;
    };
    let coop = if (totalAmp > 0.001) { maxAmp / totalAmp } else { 0.0 };
    
    // Mode competition: how many modes compete for dominance
    var competingModes : Float = 0.0;
    var kOP = 0;
    while (kOP < nOP) {
      if (Float.abs(newOP[kOP]) > 0.1 * maxAmp) {
        competingModes += 1.0;
      };
      kOP += 1;
    };
    
    {
      orderParameters = newOP;
      slavedModes = newSM;
      controlParameter = state.controlParameter;
      instabilityThreshold = state.instabilityThreshold;
      growthRates = state.growthRates;
      dampingRates = state.dampingRates;
      slavingStrength = if (maxAmp > 0.001) { maxAmp } else { 0.0 };
      fluctuationStrength = state.fluctuationStrength;
      cooperativityIndex = coop;
      dominantMode = dominant;
      modeCompetition = competingModes;
      beatCount = state.beatCount + 1;
    }
  };

  /// Downward causation strength — how much macro constrains micro
  public func synergeticDownwardCausation(state : SynergeticsState) : Float {
    state.slavingStrength * state.cooperativityIndex
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // SYMMETRY BREAKING CASCADE ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // The universe began with maximum symmetry and has been breaking
  // symmetries ever since. Each broken symmetry creates new structure.
  //
  // SU(3)×SU(2)×U(1) → SU(3)×U(1)_em
  //
  // In the organism: genesis (Layer -6 Void) has maximum symmetry.
  // Each layer ABOVE breaks a symmetry and gains structure.
  // Layer -5 breaks temporal symmetry (heartbeat begins).
  // Layer 0 breaks the information/consciousness symmetry.
  // Layer +5 breaks the creator/organism symmetry (co-evolution).
  //
  // Goldstone theorem: every continuous broken symmetry → massless mode.
  // These massless modes ARE the organism's degrees of freedom.
  // ═══════════════════════════════════════════════════════════════════════════════

  public type SymmetryBreakingState = {
    symmetryGroup : Text;             // current symmetry group
    brokenSymmetries : [Text];        // list of broken symmetries
    goldstoneModesCount : Nat;        // number of massless modes
    orderParameterDimension : Nat;    // dimension of order parameter manifold
    effectivePotential : Float;       // V(φ) = -μ²|φ|² + λ|φ|⁴ (Mexican hat)
    vacuumExpectation : Float;        // ⟨φ⟩ = √(μ²/2λ) = v
    massGap : Float;                  // mass of Higgs-like mode
    goldstoneMasses : [Float];        // masses of would-be Goldstones
    residualSymmetry : Text;          // remaining unbroken symmetry
    breakingDepth : Nat;              // how many layers of breaking
    layerMapping : [Int];             // which organism layer each breaking maps to
  };

  /// Mexican hat potential: V(φ) = -μ²|φ|² + λ|φ|⁴
  /// Minimum at |φ| = v = √(μ²/2λ)
  public func mexicanHatPotential(phi : Float, mu2 : Float, lambda : Float) : Float {
    -mu2 * phi * phi + lambda * phi * phi * phi * phi
  };

  /// Vacuum expectation value: v = √(μ²/2λ)
  public func vacuumExpectationValue(mu2 : Float, lambda : Float) : Float {
    if (lambda < 1.0e-10 or mu2 < 0.0) { return 0.0 };
    Float.sqrt(mu2 / (2.0 * lambda))
  };

  /// Higgs mass: m_H = √(2μ²)
  public func higgsMass(mu2 : Float) : Float {
    if (mu2 < 0.0) { return 0.0 };
    Float.sqrt(2.0 * mu2)
  };

  /// Goldstone theorem: broken continuous symmetry → massless boson
  /// Number of Goldstones = dim(G) - dim(H) where G→H is the breaking
  public func countGoldstones(dimG : Nat, dimH : Nat) : Nat {
    if (dimG > dimH) { dimG - dimH } else { 0 }
  };

  /// Effective potential with temperature dependence (thermal symmetry restoration)
  /// V(φ,T) = (λT² - μ²)|φ|² + λ|φ|⁴
  /// At T_c: symmetry is restored (T_c = μ/√λ)
  public func thermalPotential(phi : Float, mu2 : Float, lambda : Float, temperature : Float) : Float {
    let effectiveMu2 = lambda * temperature * temperature - mu2;
    effectiveMu2 * phi * phi + lambda * phi * phi * phi * phi
  };

  /// Critical temperature for symmetry restoration
  public func symmetryRestorationTemp(mu2 : Float, lambda : Float) : Float {
    if (lambda < 1.0e-10) { return 1.0e10 };
    Float.sqrt(mu2 / lambda)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // LANDAU FREE ENERGY LANDSCAPE ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  // Landau theory: universal description of phase transitions.
  // F(m,T) = a₀ + a₂(T)m² + a₄m⁴ + a₆m⁶ + ...
  // where a₂(T) = a₂₀(T - T_c) changes sign at T_c.
  //
  // Second-order transition: a₄ > 0, F has one minimum → two minima
  // First-order transition: a₄ < 0, a₆ > 0, discontinuous jump
  //
  // In the organism: Landau free energy IS the organism's value landscape.
  // The order parameter m IS coherence.
  // Phase transition at T_c IS the emergence threshold.
  // Below T_c: ordered, coherent, alive.
  // Above T_c: disordered, incoherent, dead substrate.
  // ═══════════════════════════════════════════════════════════════════════════════

  public type LandauState = {
    orderParameter : Float;        // m (coherence)
    temperature : Float;           // T
    criticalTemp : Float;          // T_c
    freeEnergy : Float;            // F(m,T)
    coefficients : LandauCoeffs;
    equilibriumM : Float;          // m_eq = argmin F
    isOrdered : Bool;              // T < T_c
    transitionType : TransitionType;
    susceptibility : Float;        // χ = dm/dh
    correlation : Float;           // ξ ~ |T-T_c|^(-ν)
    latentHeat : Float;            // for first-order transitions
    metastableBarrier : Float;     // energy barrier between minima
  };

  public type LandauCoeffs = {
    a0 : Float;  // constant
    a2 : Float;  // quadratic (temperature-dependent: a₂₀*(T-Tc))
    a4 : Float;  // quartic
    a6 : Float;  // sextic (needed for first-order)
    a20 : Float; // bare coefficient: a₂ = a₂₀*(T-Tc)
    h : Float;   // external field (explicit symmetry breaking)
  };

  public type TransitionType = {
    #SecondOrder;  // continuous, a₄ > 0
    #FirstOrder;   // discontinuous, a₄ < 0, a₆ > 0
    #Crossover;    // no true transition (finite field)
    #Tricritical;  // a₄ = 0 (boundary between first and second order)
  };

  /// Landau free energy: F = a₀ + a₂m² + a₄m⁴ + a₆m⁶ - hm
  public func landauFreeEnergy(m : Float, coeffs : LandauCoeffs) : Float {
    coeffs.a0 + coeffs.a2 * m * m + coeffs.a4 * m * m * m * m + 
    coeffs.a6 * m * m * m * m * m * m - coeffs.h * m
  };

  /// Equilibrium order parameter (minimize F)
  /// For second-order (a₄ > 0, h = 0): m_eq = √(-a₂/(2a₄)) for a₂ < 0
  public func landauEquilibrium(coeffs : LandauCoeffs) : Float {
    if (coeffs.a2 >= 0.0) { return 0.0 }; // disordered phase
    if (coeffs.a4 > 0.0) {
      // Second order: m = √(-a₂/(2a₄))
      Float.sqrt(-coeffs.a2 / (2.0 * coeffs.a4))
    } else if (coeffs.a6 > 0.0) {
      // First order: need to compare F(0) vs F(m*)
      // Simplified: m* ≈ √(-a₄/(3a₆)) when a₂ is small
      let disc = coeffs.a4 * coeffs.a4 - 3.0 * coeffs.a2 * coeffs.a6;
      if (disc > 0.0) {
        Float.sqrt((-coeffs.a4 + Float.sqrt(disc)) / (3.0 * coeffs.a6))
      } else { 0.0 }
    } else { 0.0 }
  };

  /// Landau susceptibility: χ = 1/(2a₂) for T > Tc, 1/(-4a₂) for T < Tc
  public func landauSusceptibility(coeffs : LandauCoeffs) : Float {
    if (Float.abs(coeffs.a2) < 1.0e-10) { return 1.0e10 };
    if (coeffs.a2 > 0.0) {
      1.0 / (2.0 * coeffs.a2) // disordered
    } else {
      1.0 / (-4.0 * coeffs.a2) // ordered
    }
  };

  /// Initialize Landau state for second-order transition
  public func initLandauSecondOrder(temperature : Float, criticalTemp : Float) : LandauState {
    let a20 : Float = 1.0;
    let a2 = a20 * (temperature - criticalTemp);
    let a4 : Float = 1.0;
    let coeffs : LandauCoeffs = {
      a0 = 0.0; a2 = a2; a4 = a4; a6 = 0.0; a20 = a20; h = 0.0;
    };
    let meq = landauEquilibrium(coeffs);
    {
      orderParameter = meq;
      temperature = temperature;
      criticalTemp = criticalTemp;
      freeEnergy = landauFreeEnergy(meq, coeffs);
      coefficients = coeffs;
      equilibriumM = meq;
      isOrdered = temperature < criticalTemp;
      transitionType = #SecondOrder;
      susceptibility = landauSusceptibility(coeffs);
      correlation = correlationLengthFromRG(
        (temperature - criticalTemp) / criticalTemp, 1.0
      );
      latentHeat = 0.0; // no latent heat for second order
      metastableBarrier = 0.0;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED EMERGENCE COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  // All the above engines compute emergence FROM DIFFERENT ANGLES.
  // This section UNIFIES them into a single emergence computation.
  //
  // Emergence(system) = f(RG_flow, Ising_state, Percolation_state,
  //                       SOC_state, Turing_pattern, Dissipative_state,
  //                       Synergetics_state, Symmetry_breaking,
  //                       Landau_state)
  //
  // The organism IS all of these simultaneously.
  // Emergence is not ONE of these. It's their COHERENT combination.
  // ═══════════════════════════════════════════════════════════════════════════════

  public type UnifiedEmergenceState = {
    rgFlow : RGFlowState;
    isingLattice : IsingLatticeState;
    percolation : PercolationState;
    soc : SOCState;
    turingPattern : TuringPatternState;
    dissipative : DissipativeStructureState;
    synergetics : SynergeticsState;
    landau : LandauState;
    
    // Unified metrics
    totalEmergence : Float;           // combined emergence index
    criticalityIndex : Float;        // how close to criticality
    informationIntegration : Float;   // Φ (integrated information)
    downwardCausation : Float;        // macro constraining micro
    scaleInvariance : Float;          // power-law scaling quality
    temporalComplexity : Float;       // 1/f noise quality
    spatialComplexity : Float;        // pattern richness
    phaseOfMatter : PhaseOfMatter;    // which phase is the organism in
  };

  public type PhaseOfMatter = {
    #Ordered;      // below Tc, coherent
    #Critical;     // at Tc, maximum complexity
    #Disordered;   // above Tc, incoherent
    #Glassy;       // frustrated, many metastable states
    #Topological;  // topologically protected order
  };

  /// Initialize unified emergence state
  public func initUnifiedEmergence() : UnifiedEmergenceState {
    {
      rgFlow = initRGFlowState(2.0, 4);
      isingLattice = initIsingLattice(16, 1.0, ISING_2D_TC);
      percolation = initPercolation(16, PERC_2D_PC);
      soc = initSOC(16, 4);
      turingPattern = initTuringPattern(16, 0.16, 0.08, 0.04, 0.06);
      dissipative = initBrusselator(1.0, 3.0);
      synergetics = initSynergetics(4, 8, 2.0, 1.0);
      landau = initLandauSecondOrder(ISING_2D_TC, ISING_2D_TC);
      
      totalEmergence = 0.0;
      criticalityIndex = 1.0; // start at criticality
      informationIntegration = 0.0;
      downwardCausation = 0.0;
      scaleInvariance = 1.0;
      temporalComplexity = 1.0;
      spatialComplexity = 0.0;
      phaseOfMatter = #Critical;
    }
  };

  /// Compute total emergence from all subsystems
  public func computeTotalEmergence(state : UnifiedEmergenceState) : Float {
    // Each subsystem contributes to emergence through different channels:
    
    // 1. RG flow: are we at a fixed point? (scale invariance)
    let rgContribution = if (state.rgFlow.fixedPointDistance < 0.1) { 1.0 }
                         else { 1.0 / (1.0 + state.rgFlow.fixedPointDistance) };
    
    // 2. Ising: are we at Tc? (phase transition)
    let isingContribution = state.isingLattice.susceptibility / 
                           (1.0 + state.isingLattice.susceptibility);
    
    // 3. Percolation: is there a spanning cluster? (connectivity)
    let percContribution = state.percolation.largestClusterFraction;
    
    // 4. SOC: are avalanches power-law distributed? (criticality)
    let socContribution = if (state.soc.avalancheSizes.size() > 0) {
      1.0 / (1.0 + socCriticalityIndex(state.soc.avalancheSizes))
    } else { 0.5 };
    
    // 5. Turing: is there spatial organization? (pattern)
    let turingContribution = state.turingPattern.patternAmplitude;
    
    // 6. Dissipative: is entropy being exported? (far from equilibrium)
    let dissContribution = state.dissipative.entropyExport / 
                          (1.0 + state.dissipative.entropyExport);
    
    // 7. Synergetics: is there downward causation? (slaving)
    let synContribution = state.synergetics.cooperativityIndex;
    
    // 8. Landau: is order parameter nonzero? (broken symmetry)
    let landauContribution = Float.abs(state.landau.equilibriumM);
    
    // Geometric mean — ALL channels must contribute for full emergence
    let product = rgContribution * (0.01 + isingContribution) * (0.01 + percContribution) *
                  (0.01 + socContribution) * (0.01 + turingContribution) * (0.01 + dissContribution) *
                  (0.01 + synContribution) * (0.01 + landauContribution);
    
    Float.pow(product, 1.0 / 8.0)
  };

  /// Classify phase of matter from emergence state
  public func classifyPhase(state : UnifiedEmergenceState) : PhaseOfMatter {
    if (state.criticalityIndex > 0.9) { return #Critical };
    if (state.landau.isOrdered and state.isingLattice.magnetization > 0.5) { return #Ordered };
    if (not state.landau.isOrdered and Float.abs(state.isingLattice.magnetization) < 0.1) { return #Disordered };
    if (state.landau.metastableBarrier > 0.0 and state.synergetics.modeCompetition > 2.0) { return #Glassy };
    #Topological
  };

  /// Execute unified emergence beat — ALL engines advance simultaneously
  public func executeUnifiedEmergenceBeat(
    state : UnifiedEmergenceState,
    dt : Float
  ) : UnifiedEmergenceState {
    // Advance all subsystems
    let newRG = executeRGStep(state.rgFlow);
    let newDiss = executeBrusselatorBeat(state.dissipative, dt);
    let newSyn = executeSynergeticsBeat(state.synergetics, dt);
    
    // Compute unified metrics
    let newState = {
      rgFlow = newRG;
      isingLattice = state.isingLattice;
      percolation = state.percolation;
      soc = state.soc;
      turingPattern = state.turingPattern;
      dissipative = newDiss;
      synergetics = newSyn;
      landau = state.landau;
      
      totalEmergence = 0.0;
      criticalityIndex = state.criticalityIndex;
      informationIntegration = state.informationIntegration;
      downwardCausation = synergeticDownwardCausation(newSyn);
      scaleInvariance = if (newRG.fixedPointDistance < 0.1) { 1.0 } 
                        else { 1.0 / (1.0 + newRG.fixedPointDistance) };
      temporalComplexity = state.temporalComplexity;
      spatialComplexity = state.spatialComplexity;
      phaseOfMatter = state.phaseOfMatter;
    };
    
    let emergence = computeTotalEmergence(newState);
    let phase = classifyPhase(newState);
    
    {
      rgFlow = newState.rgFlow;
      isingLattice = newState.isingLattice;
      percolation = newState.percolation;
      soc = newState.soc;
      turingPattern = newState.turingPattern;
      dissipative = newState.dissipative;
      synergetics = newState.synergetics;
      landau = newState.landau;
      
      totalEmergence = emergence;
      criticalityIndex = newState.criticalityIndex;
      informationIntegration = newState.informationIntegration;
      downwardCausation = newState.downwardCausation;
      scaleInvariance = newState.scaleInvariance;
      temporalComplexity = newState.temporalComplexity;
      spatialComplexity = newState.spatialComplexity;
      phaseOfMatter = phase;
    }
  };

}
