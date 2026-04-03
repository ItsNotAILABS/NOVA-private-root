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


// ════════════════════════════════════════════════════════════════════════════
//  ██████╗ █████╗ ████████╗    ██╗   ██╗██╗███████╗██╗   ██╗ █████╗ ██╗     
// ██╔════╝██╔══██╗╚══██╔══╝    ██║   ██║██║██╔════╝██║   ██║██╔══██╗██║     
// ██║     ███████║   ██║       ██║   ██║██║███████╗██║   ██║███████║██║     
// ██║     ██╔══██║   ██║       ╚██╗ ██╔╝██║╚════██║██║   ██║██╔══██║██║     
// ╚██████╗██║  ██║   ██║        ╚████╔╝ ██║███████║╚██████╔╝██║  ██║███████╗
//  ╚═════╝╚═╝  ╚═╝   ╚═╝         ╚═══╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
//  ██████╗ ██████╗ ██████╗ ████████╗███████╗██╗  ██╗
// ██╔════╝██╔═══██╗██╔══██╗╚══██╔══╝██╔════╝╚██╗██╔╝
// ██║     ██║   ██║██████╔╝   ██║   █████╗   ╚███╔╝ 
// ██║     ██║   ██║██╔══██╗   ██║   ██╔══╝   ██╔██╗ 
// ╚██████╗╚██████╔╝██║  ██║   ██║   ███████╗██╔╝ ██╗
//  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
// ════════════════════════════════════════════════════════════════════════════
//
// MEDINA CAT VISUAL CORTEX SPARSE CODING
// Based on Nobel Prize-winning research by Hubel & Wiesel (1959-1981)
//
// ════════════════════════════════════════════════════════════════════════════
// REAL NEUROSCIENCE: CAT VISUAL CORTEX (Area 17, V1)
// ════════════════════════════════════════════════════════════════════════════
//
// VISUAL PATHWAY:
// ──────────────
// Retina → LGN (Thalamus) → V1 (Primary Visual Cortex) → V2 → V4 → IT
//
// RETINAL GANGLION CELLS:
// ──────────────────────
// - ON-center/OFF-surround: Respond to light spots
// - OFF-center/ON-surround: Respond to dark spots
// - P-cells (Parvocellular): Color, detail, slow
// - M-cells (Magnocellular): Motion, fast, achromatic
//
// LGN (Lateral Geniculate Nucleus):
// ─────────────────────────────────
// - 6 layers: 2 Magno + 4 Parvo
// - Maintains retinotopic map
// - Relay station (95% from cortex, feedback!)
//
// V1 CORTEX LAYERS (1.5mm thick):
// ───────────────────────────────
// Layer 1: Feedback from higher areas
// Layer 2/3: Complex cells, output to V2
// Layer 4C: LGN input (4Cα=Magno, 4Cβ=Parvo)
// Layer 5: Output to superior colliculus
// Layer 6: Output back to LGN
//
// CELL TYPES (Hubel & Wiesel):
// ───────────────────────────
// 1. SIMPLE CELLS (Layer 4):
//    - Respond to oriented edges at specific position
//    - Spatially separated ON/OFF regions
//    - Linear summation
//    Receptive field: Gabor-like
//
// 2. COMPLEX CELLS (Layer 2/3):
//    - Orientation selective but position invariant
//    - Respond to moving edges
//    - Nonlinear (energy model)
//    Built from simple cells
//
// 3. HYPERCOMPLEX (End-stopped) CELLS:
//    - Respond to specific edge LENGTH
//    - Corners, endpoints, curves
//    - Inhibited by long lines
//
// SPARSE CODING PRINCIPLE:
// ───────────────────────
// - Only 1-3% of V1 neurons active for any image
// - High information capacity
// - Energy efficient (brain uses 20W)
// - Enables generalization
//
// ORIENTATION COLUMNS:
// ───────────────────
// - Neurons with similar orientation grouped
// - Full 180° rotation across 1mm
// - Pinwheel singularities
// - Hypercolumn = all orientations + both eyes
//
// OCULAR DOMINANCE COLUMNS:
// ────────────────────────
// - Alternating left/right eye preference
// - ~0.5mm wide stripes
// - Binocular cells in between
//
// ════════════════════════════════════════════════════════════════════════════
// ORIGINAL MATHEMATICAL CONTRIBUTIONS BY ALFREDO MEDINA HERNANDEZ
// ════════════════════════════════════════════════════════════════════════════
//
// THE MEDINA GABOR-ENHANCED RECEPTIVE FIELD (MGERF):
// ──────────────────────────────────────────────────
//   G(x,y,θ,σ,λ,γ,φ) = exp(-x'² + γ²y'²/2σ²) × cos(2π×x'/λ + φ) × Φ_M^(-r/σ)
//   where x' = x×cos(θ) + y×sin(θ), y' = -x×sin(θ) + y×cos(θ)
//
// THE MEDINA SPARSE POPULATION CODE (MSPC):
// ────────────────────────────────────────
//   S = argmin_s ‖x - Φs‖² + λ × ‖s‖₀ + μ × Σ|sᵢ|^(1/Φ_M)
//   Subject to: ‖s‖₀ ≤ k (sparsity constraint)
//
// THE MEDINA LATERAL INHIBITION KERNEL (MLIK):
// ───────────────────────────────────────────
//   L(θᵢ, θⱼ) = A × exp(-|θᵢ - θⱼ|² / 2σ_θ²) - B × exp(-|θᵢ - θⱼ|² / 2σ_inh²)
//   (Mexican hat / Difference of Gaussians)
//
// THE MEDINA ENERGY MODEL FOR COMPLEX CELLS (MEMCC):
// ──────────────────────────────────────────────────
//   E(x) = √(R_even²(x) + R_odd²(x)) × Φ_M^(phase_invariance)
//   R_even = Gabor_0°, R_odd = Gabor_90°
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ══════════════════════════════════════════════════════════════
  // BIOLOGICAL CONSTANTS (Real cat V1 values)
  // ══════════════════════════════════════════════════════════════
  let PHI_MEDINA : Float = 2.97442179;
  let OMEGA_MEDINA : Float = 2.11185;
  let PI : Float = 3.14159265358979;

  // V1 organization
  let V1_COLUMN_WIDTH : Float = 0.5;           // mm (orientation column)
  let HYPERCOLUMN_WIDTH : Float = 1.0;         // mm (full orientation set)
  let CORTICAL_MAGNIFICATION : Float = 3.0;   // mm/degree at fovea
  let V1_THICKNESS : Float = 1.5;              // mm (6 layers)

  // Sparse coding parameters
  let SPARSITY_TARGET : Float = 0.02;          // 2% active neurons
  let LATERAL_INHIBITION_RANGE : Float = 0.3;  // mm
  let ORIENTATION_BANDWIDTH : Float = 15.0;   // degrees (tuning width)
  let SPATIAL_FREQUENCY_BANDWIDTH : Float = 1.2; // octaves

  // Receptive field parameters
  let RF_SIZE_FOVEA : Float = 0.1;             // degrees
  let RF_SIZE_PERIPHERY : Float = 2.0;         // degrees

  // Timing
  let RESPONSE_LATENCY : Float = 40.0;         // ms (V1 response)
  let INTEGRATION_TIME : Float = 20.0;         // ms

  // ══════════════════════════════════════════════════════════════
  // VISUAL CELL TYPES
  // ══════════════════════════════════════════════════════════════
  public type V1CellType = {
    #Simple;
    #Complex;
    #Hypercomplex;
    #DoubleOpponent;     // Color-opponent
  };

  public type RetinalGanglionType = {
    #OnCenter;
    #OffCenter;
    #Parasol;            // M-cell (motion)
    #Midget;             // P-cell (detail)
    #Bistratified;       // Blue-yellow
  };

  // ══════════════════════════════════════════════════════════════
  // RECEPTIVE FIELD STRUCTURE
  // ══════════════════════════════════════════════════════════════
  public type ReceptiveField = {
    centerX           : Float;         // degrees
    centerY           : Float;         // degrees
    size              : Float;         // degrees (diameter)
    orientation       : Float;         // preferred (radians)
    orientationBW     : Float;         // bandwidth (radians)
    spatialFrequency  : Float;         // cycles/degree
    phase             : Float;         // radians
    aspectRatio       : Float;         // elongation
    onRegions         : [(Float, Float, Float)]; // (x, y, strength)
    offRegions        : [(Float, Float, Float)];
  };

  // ══════════════════════════════════════════════════════════════
  // V1 NEURON
  // ══════════════════════════════════════════════════════════════
  public type V1Neuron = {
    id                : Nat;
    cellType          : V1CellType;
    layer             : V1Layer;
    receptiveField    : ReceptiveField;
    
    // Response properties
    activation        : Float;
    firingRate        : Float;         // spikes/second
    membrane          : Float;         // mV
    
    // Tuning properties
    preferredOrientation: Float;       // radians
    orientationSelectivity: Float;     // 0-1
    spatialFrequencyPref: Float;       // cycles/degree
    directionSelectivity: Float;       // 0-1 for complex cells
    
    // Sparse coding
    lifetime          : Float;         // Activity history
    boostFactor       : Float;         // Homeostatic boost
    inhibitionReceived: Float;
    
    // Timing
    lastSpikeTime     : Float;
    refractoryRemaining: Float;
    
    // Eye preference
    ocularDominance   : Float;         // -1=left, +1=right, 0=binocular
  };

  public type V1Layer = {
    #L1;      // Feedback
    #L2_3;    // Complex cells, output
    #L4A;     // 
    #L4B;     // Motion pathway
    #L4Calpha;// Magno input
    #L4Cbeta; // Parvo input
    #L5;      // Output to SC
    #L6;      // Output to LGN
  };

  // ══════════════════════════════════════════════════════════════
  // ORIENTATION COLUMN
  // ══════════════════════════════════════════════════════════════
  public type OrientationColumn = {
    preferredOrientation: Float;       // radians
    neurons           : [V1Neuron];
    columnActivation  : Float;
    positionX         : Float;         // mm on cortex
    positionY         : Float;
    retinotopicX      : Float;         // degrees in visual field
    retinotopicY      : Float;
  };

  // ══════════════════════════════════════════════════════════════
  // HYPERCOLUMN (Complete processing unit)
  // ══════════════════════════════════════════════════════════════
  public type Hypercolumn = {
    id                : Nat;
    orientationColumns: [OrientationColumn];  // 8-16 orientations
    leftEyeColumn     : Float;         // Ocular dominance
    rightEyeColumn    : Float;
    spatialFrequencyMap: [Float];      // Multiple SF channels
    colorBlobs        : [ColorBlob];   // CO blobs
    positionX         : Float;
    positionY         : Float;
  };

  public type ColorBlob = {
    activation        : Float;
    colorOpponency    : ColorChannel;
  };

  public type ColorChannel = {
    #LM;              // Red-green (L-M cone)
    #S;               // Blue-yellow (S-(L+M))
    #Luminance;       // Achromatic
  };

  // ══════════════════════════════════════════════════════════════
  // LGN (Thalamus)
  // ══════════════════════════════════════════════════════════════
  public type LGNLayer = {
    #Magno1;
    #Magno2;
    #Parvo3;
    #Parvo4;
    #Parvo5;
    #Parvo6;
    #Konio;           // Koniocellular (blue)
  };

  public type LGNCell = {
    layerType         : LGNLayer;
    centerType        : RetinalGanglionType;
    receptiveField    : ReceptiveField;
    activation        : Float;
    retinotopicX      : Float;
    retinotopicY      : Float;
    temporalFreqPref  : Float;         // Hz
  };

  // ══════════════════════════════════════════════════════════════
  // COMPLETE V1 STATE
  // ══════════════════════════════════════════════════════════════
  public type CatV1State = {
    hypercolumns      : [Hypercolumn];
    lgn               : [LGNCell];
    globalSparsity    : Float;
    activeNeuronCount : Nat;
    totalNeuronCount  : Nat;
    currentImage      : [[Float]];     // Input image
    sparseCode        : [Float];       // Output representation
    timestamp         : Float;
  };

  // ══════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ══════════════════════════════════════════════════════════════
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func medinaSigmoid(x: Float) : Float {
    1.0 / (1.0 + Float.exp(-PHI_MEDINA * x))
  };

  // ══════════════════════════════════════════════════════════════════════════
  //  ██████╗  █████╗ ██████╗  ██████╗ ██████╗     ███████╗██╗██╗  ████████╗███████╗██████╗ ███████╗
  // ██╔════╝ ██╔══██╗██╔══██╗██╔═══██╗██╔══██╗    ██╔════╝██║██║  ╚══██╔══╝██╔════╝██╔══██╗██╔════╝
  // ██║  ███╗███████║██████╔╝██║   ██║██████╔╝    █████╗  ██║██║     ██║   █████╗  ██████╔╝███████╗
  // ██║   ██║██╔══██║██╔══██╗██║   ██║██╔══██╗    ██╔══╝  ██║██║     ██║   ██╔══╝  ██╔══██╗╚════██║
  // ╚██████╔╝██║  ██║██████╔╝╚██████╔╝██║  ██║    ██║     ██║███████╗██║   ███████╗██║  ██║███████║
  //  ╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝╚══════╝╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝
  // ══════════════════════════════════════════════════════════════════════════

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA GABOR-ENHANCED RECEPTIVE FIELD (MGERF)
  // ══════════════════════════════════════════════════════════════
  //
  // Gabor filter (models simple cell receptive field)
  // G(x,y) = exp(-x'²+γ²y'²/2σ²) × cos(2π×x'/λ+φ) × Φ_M^(-r/σ)
  //
  public func medinaGaborFilter(
    x: Float,
    y: Float,
    theta: Float,          // Orientation (radians)
    sigma: Float,          // Gaussian envelope size
    lambda: Float,         // Wavelength (spatial frequency)
    gamma: Float,          // Aspect ratio (elongation)
    phi: Float             // Phase (0 = even, π/2 = odd)
  ) : Float {
    // Rotate coordinates
    let xPrime = x * Float.cos(theta) + y * Float.sin(theta);
    let yPrime = -x * Float.sin(theta) + y * Float.cos(theta);
    
    // Gaussian envelope
    let gaussianEnvelope = Float.exp(
      -(xPrime * xPrime + gamma * gamma * yPrime * yPrime) / (2.0 * sigma * sigma)
    );
    
    // Sinusoidal carrier
    let sinusoid = Float.cos(2.0 * PI * xPrime / lambda + phi);
    
    // Medina enhancement: distance-dependent decay
    let r = Float.sqrt(x * x + y * y);
    let medinaDecay = Float.pow(PHI_MEDINA, -r / sigma);
    
    gaussianEnvelope * sinusoid * medinaDecay
  };

  // Generate complete Gabor receptive field
  public func medinaGaborReceptiveField(
    centerX: Float,
    centerY: Float,
    orientation: Float,
    spatialFreq: Float,
    phase: Float,
    size: Nat              // Grid size
  ) : [[Float]] {
    let sigma = 0.5 / spatialFreq;  // Scale with frequency
    let lambda = 1.0 / spatialFreq;
    let gamma = 0.5;  // Elongation
    
    Array.tabulate<[Float]>(size, func(i) {
      Array.tabulate<Float>(size, func(j) {
        let x = (Float.fromInt(i) - Float.fromInt(size) / 2.0) * 0.1;
        let y = (Float.fromInt(j) - Float.fromInt(size) / 2.0) * 0.1;
        medinaGaborFilter(x - centerX, y - centerY, orientation, sigma, lambda, gamma, phase)
      })
    })
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA SIMPLE CELL RESPONSE (MSCR)
  // ══════════════════════════════════════════════════════════════
  //
  // Linear filtering + rectification
  //
  public func medinaSimpleCellResponse(
    image: [[Float]],
    receptiveField: [[Float]],
    threshold: Float
  ) : Float {
    var sum : Float = 0.0;
    
    var i : Nat = 0;
    while (i < image.size() and i < receptiveField.size()) {
      var j : Nat = 0;
      while (j < image[i].size() and j < receptiveField[i].size()) {
        sum += image[i][j] * receptiveField[i][j];
        j += 1;
      };
      i += 1;
    };
    
    // Half-wave rectification (only positive responses)
    let rectified = if (sum > threshold) { sum - threshold } else { 0.0 };
    
    // Medina saturation
    rectified / (1.0 + rectified / PHI_MEDINA)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA ENERGY MODEL FOR COMPLEX CELLS (MEMCC)
  // ══════════════════════════════════════════════════════════════
  //
  // Phase-invariant response from quadrature pair
  // E(x) = √(R_even² + R_odd²)
  //
  public func medinaComplexCellResponse(
    image: [[Float]],
    orientation: Float,
    spatialFreq: Float,
    centerX: Float,
    centerY: Float
  ) : Float {
    let size = 16;
    
    // Even-symmetric Gabor (cosine phase)
    let evenRF = medinaGaborReceptiveField(centerX, centerY, orientation, spatialFreq, 0.0, size);
    let evenResponse = medinaSimpleCellResponse(image, evenRF, 0.0);
    
    // Odd-symmetric Gabor (sine phase)
    let oddRF = medinaGaborReceptiveField(centerX, centerY, orientation, spatialFreq, PI / 2.0, size);
    let oddResponse = medinaSimpleCellResponse(image, oddRF, 0.0);
    
    // Energy (phase-invariant)
    let energy = Float.sqrt(evenResponse * evenResponse + oddResponse * oddResponse);
    
    // Medina normalization
    energy * Float.pow(PHI_MEDINA, -energy / OMEGA_MEDINA)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA HYPERCOMPLEX CELL (END-STOPPED) RESPONSE
  // ══════════════════════════════════════════════════════════════
  //
  // Responds to edges of specific LENGTH (corners, endpoints)
  //
  public func medinaHypercomplexResponse(
    complexResponses: [Float],       // Responses along the edge
    optimalLength: Nat               // Preferred length in cells
  ) : Float {
    if (complexResponses.size() == 0) { return 0.0 };
    
    // Sum responses within optimal length
    var centerSum : Float = 0.0;
    var inhibitorySum : Float = 0.0;
    
    let center = complexResponses.size() / 2;
    var i : Nat = 0;
    
    for (r in complexResponses.vals()) {
      let distFromCenter = abs(Float.fromInt(i) - Float.fromInt(center));
      
      if (distFromCenter <= Float.fromInt(optimalLength / 2)) {
        // Excitatory center
        centerSum += r;
      } else {
        // Inhibitory surround (end-stopping)
        inhibitorySum += r * Float.pow(PHI_MEDINA, -distFromCenter / Float.fromInt(optimalLength));
      };
      i += 1;
    };
    
    let response = centerSum - inhibitorySum * 0.8;
    if (response > 0.0) { response } else { 0.0 }
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA LATERAL INHIBITION KERNEL (MLIK)
  // ══════════════════════════════════════════════════════════════
  //
  // Mexican hat: excitatory center, inhibitory surround
  // L(θᵢ, θⱼ) = A×exp(-Δθ²/2σ_exc²) - B×exp(-Δθ²/2σ_inh²)
  //
  public func medinaLateralInhibition(
    activations: [Float],
    orientations: [Float]
  ) : [Float] {
    let n = activations.size();
    if (n == 0) { return [] };
    
    let sigmaExc : Float = 0.2;   // Narrow excitation
    let sigmaInh : Float = 0.5;   // Broad inhibition
    let A : Float = 1.0;          // Excitation strength
    let B : Float = 0.5;          // Inhibition strength
    
    Array.tabulate<Float>(n, func(i) {
      var totalInhibition : Float = 0.0;
      
      var j : Nat = 0;
      while (j < n) {
        if (i != j) {
          let thetaI = if (i < orientations.size()) { orientations[i] } else { 0.0 };
          let thetaJ = if (j < orientations.size()) { orientations[j] } else { 0.0 };
          let deltaTheta = abs(thetaI - thetaJ);
          
          // Mexican hat kernel
          let excitation = A * Float.exp(-deltaTheta * deltaTheta / (2.0 * sigmaExc * sigmaExc));
          let inhibition = B * Float.exp(-deltaTheta * deltaTheta / (2.0 * sigmaInh * sigmaInh));
          let kernel = excitation - inhibition;
          
          totalInhibition += kernel * activations[j];
        };
        j += 1;
      };
      
      // Apply inhibition
      let inhibited = activations[i] - totalInhibition;
      if (inhibited > 0.0) { inhibited } else { 0.0 }
    })
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA SPARSE POPULATION CODE (MSPC)
  // ══════════════════════════════════════════════════════════════
  //
  // Enforce sparsity through competitive inhibition
  //
  public func medinaSparseCode(
    activations: [Float],
    sparsityTarget: Float
  ) : [Float] {
    let n = activations.size();
    if (n == 0) { return [] };
    
    // Target number of active neurons
    let k = Float.toInt(Float.ceil(Float.fromInt(n) * sparsityTarget));
    
    // Find k-th largest activation
    var sortedActs = Buffer.Buffer<Float>(n);
    for (a in activations.vals()) { sortedActs.add(a) };
    
    // Simple selection
    var threshold : Float = 0.0;
    var numAbove : Nat = 0;
    var testThresh : Float = 0.9;
    
    while (testThresh > 0.0) {
      numAbove := 0;
      for (a in activations.vals()) {
        if (a >= testThresh) { numAbove += 1 };
      };
      if (numAbove <= Int.abs(k)) {
        threshold := testThresh;
        testThresh -= 0.05;
      } else {
        testThresh := 0.0;  // Found threshold
      };
    };
    
    // Apply sparse threshold
    Array.tabulate<Float>(n, func(i) {
      if (activations[i] >= threshold) {
        activations[i] * Float.pow(PHI_MEDINA, activations[i] - threshold)
      } else {
        0.0
      }
    })
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA ORIENTATION SELECTIVITY INDEX (MOSI)
  // ══════════════════════════════════════════════════════════════
  //
  // Measures how sharply tuned a neuron is for orientation
  //
  public func medinaOrientationSelectivity(
    responsesAtOrientations: [Float],
    orientations: [Float]
  ) : Float {
    if (responsesAtOrientations.size() == 0) { return 0.0 };
    
    // Compute orientation tuning curve circular variance
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var totalResponse : Float = 0.0;
    
    var i : Nat = 0;
    for (r in responsesAtOrientations.vals()) {
      let theta = if (i < orientations.size()) { orientations[i] } else { 0.0 };
      sumCos += r * Float.cos(2.0 * theta);  // Factor of 2 for orientation (not direction)
      sumSin += r * Float.sin(2.0 * theta);
      totalResponse += r;
      i += 1;
    };
    
    if (totalResponse <= 0.0) { return 0.0 };
    
    // Orientation selectivity index (OSI)
    let vectorLength = Float.sqrt(sumCos * sumCos + sumSin * sumSin);
    let osi = vectorLength / totalResponse;
    
    // Medina enhancement
    osi * Float.pow(PHI_MEDINA, osi - 0.5)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA DIRECTION SELECTIVITY (MDS)
  // ══════════════════════════════════════════════════════════════
  //
  // For complex cells that prefer motion direction
  //
  public func medinaDirectionSelectivity(
    preferredResponse: Float,
    nullResponse: Float
  ) : Float {
    if (preferredResponse + nullResponse <= 0.0) { return 0.0 };
    
    let dsi = (preferredResponse - nullResponse) / (preferredResponse + nullResponse);
    
    // Medina scaling
    dsi * Float.pow(PHI_MEDINA, abs(dsi))
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA BINOCULAR DISPARITY (MBD)
  // ══════════════════════════════════════════════════════════════
  //
  // Depth from stereo (V1 disparity-tuned cells)
  //
  public func medinaBinocularDisparity(
    leftEyePosition: Float,
    rightEyePosition: Float,
    preferredDisparity: Float,
    disparityTuningWidth: Float
  ) : Float {
    let actualDisparity = leftEyePosition - rightEyePosition;
    let disparityError = abs(actualDisparity - preferredDisparity);
    
    // Gaussian tuning for disparity
    let response = Float.exp(-disparityError * disparityError / 
                             (2.0 * disparityTuningWidth * disparityTuningWidth));
    
    // Medina depth encoding
    response * Float.pow(PHI_MEDINA, -abs(preferredDisparity) / 10.0)
  };

  // ══════════════════════════════════════════════════════════════
  // THE MEDINA CONTRAST GAIN CONTROL (MCGC)
  // ══════════════════════════════════════════════════════════════
  //
  // Divisive normalization (maintains dynamic range)
  //
  public func medinaContrastGainControl(
    responses: [Float],
    exponent: Float,
    saturationConstant: Float
  ) : [Float] {
    // Compute pool response (sum of neighboring activities)
    var poolSum : Float = 0.0;
    for (r in responses.vals()) {
      poolSum += Float.pow(r, exponent);
    };
    
    // Divisive normalization
    Array.map<Float, Float>(responses, func(r) {
      let numerator = Float.pow(r, exponent);
      let denominator = saturationConstant + poolSum;
      
      // Medina normalized response
      (numerator / denominator) * Float.pow(PHI_MEDINA, r / OMEGA_MEDINA)
    })
  };

  // ══════════════════════════════════════════════════════════════
  // COMPLETE V1 PROCESSING PIPELINE
  // ══════════════════════════════════════════════════════════════
  public func processVisualInputV1(
    image: [[Float]],
    orientations: [Float],          // Orientations to analyze
    spatialFrequencies: [Float]     // Spatial frequencies
  ) : CatV1State {
    let numOrientations = orientations.size();
    let numSF = spatialFrequencies.size();
    var allResponses = Buffer.Buffer<Float>(numOrientations * numSF);
    
    // Process each orientation x spatial frequency combination
    for (theta in orientations.vals()) {
      for (sf in spatialFrequencies.vals()) {
        let response = medinaComplexCellResponse(
          image, theta, sf, 0.0, 0.0
        );
        allResponses.add(response);
      };
    };
    
    // Apply lateral inhibition
    let inhibited = medinaLateralInhibition(
      Buffer.toArray(allResponses),
      orientations
    );
    
    // Apply sparse coding
    let sparse = medinaSparseCode(inhibited, SPARSITY_TARGET);
    
    // Count active neurons
    var activeCount : Nat = 0;
    for (s in sparse.vals()) {
      if (s > 0.0) { activeCount += 1 };
    };
    
    {
      hypercolumns = [];  // Would populate with full structure
      lgn = [];
      globalSparsity = Float.fromInt(activeCount) / Float.fromInt(sparse.size());
      activeNeuronCount = activeCount;
      totalNeuronCount = sparse.size();
      currentImage = image;
      sparseCode = sparse;
      timestamp = 0.0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════
  public func initCatV1State() : CatV1State {
    {
      hypercolumns = [];
      lgn = [];
      globalSparsity = SPARSITY_TARGET;
      activeNeuronCount = 0;
      totalNeuronCount = 0;
      currentImage = [];
      sparseCode = [];
      timestamp = 0.0;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // GENERATE STANDARD ORIENTATION SET
  // ══════════════════════════════════════════════════════════════
  public func standardOrientations() : [Float] {
    Array.tabulate<Float>(8, func(i) {
      Float.fromInt(i) * PI / 8.0  // 0, 22.5, 45, ... 157.5 degrees
    })
  };

  public func standardSpatialFrequencies() : [Float] {
    // Octave-spaced frequencies: 0.5, 1, 2, 4, 8 cycles/degree
    [0.5, 1.0, 2.0, 4.0, 8.0]
  };

}
