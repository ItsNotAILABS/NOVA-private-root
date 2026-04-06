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


// ============================================================
// NEUROEMERGENCE CORE — NEURAL SUBSTRATE GRADIENT FIELD
// Real brain mapped to computational substrate with gradient dynamics
// 
// This module maps the EXACT neuroanatomy of the human brain
// into a gradient field substrate for sovereign organism cognition.
// 
// Neuroanatomical Mapping:
// - 86 billion neurons → compressed representational substrate
// - 6 cortical layers → hierarchical gradient field
// - 52 Brodmann areas → functional gradient zones
// - White matter tracts → connectivity gradients
// - Neurotransmitter systems → chemical gradient fields
// 
// Gradient Field Mathematics:
// - Neural field: ∂u/∂t = -u + ∫W(x,y)f(u(y))dy + I(x)
// - Gradient flow: ∇F = -∂E/∂x (energy minimization)
// - Diffusion: ∂c/∂t = D∇²c + R(c) (neuromodulator spread)
// 
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";

module {

  // ══════════════════════════════════════════════════════════════
  // BRODMANN AREAS (Real Brain Mapping)
  // ══════════════════════════════════════════════════════════════

  // Brodmann area representation
  public type BrodmannArea = {
    id            : Nat;           // BA number (1-52)
    name          : Text;
    hemisphere    : Hemisphere;
    
    // Spatial gradient coordinates
    position      : GradientCoord;
    extent        : Float;         // Spatial extent
    
    // Layer-specific activity (6 cortical layers)
    layer1        : Float;         // Molecular layer
    layer2        : Float;         // External granular
    layer3        : Float;         // External pyramidal
    layer4        : Float;         // Internal granular (input)
    layer5        : Float;         // Internal pyramidal (output)
    layer6        : Float;         // Multiform (feedback)
    
    // Functional state
    activity      : Float;         // Current activation
    prediction    : Float;         // Predictive signal
    error         : Float;         // Prediction error
    
    // Cytoarchitectonic properties
    neuronDensity : Float;         // Neurons per mm³
    myelination   : Float;         // Myelination degree
  };

  public type Hemisphere = {
    #Left;
    #Right;
    #Bilateral;
  };

  // 3D gradient coordinate
  public type GradientCoord = {
    x : Float;                     // Anterior-Posterior
    y : Float;                     // Medial-Lateral  
    z : Float;                     // Dorsal-Ventral
  };

  // ══════════════════════════════════════════════════════════════
  // GRADIENT FIELD TYPES
  // ══════════════════════════════════════════════════════════════

  // Neural mass field
  public type NeuralField = {
    // Spatial discretization
    gridSize      : Nat;           // Resolution
    fieldValues   : [[Float]];     // 2D field (can extend to 3D)
    
    // Dynamics
    timeConstant  : Float;         // τ
    threshold     : Float;         // Activation threshold
    steepness     : Float;         // Sigmoid steepness
    
    // Connectivity kernel
    excitRadius   : Float;         // Excitatory spread
    inhibRadius   : Float;         // Inhibitory spread
    excitStrength : Float;         // a_e
    inhibStrength : Float;         // a_i
    
    // External input
    inputField    : [[Float]];
  };

  // Chemical gradient field (neuromodulators)
  public type ChemicalGradient = {
    name          : Text;          // e.g., "Dopamine"
    concentration : [[Float]];     // Spatial concentration
    
    // Diffusion parameters
    diffusionCoeff: Float;         // D
    decayRate     : Float;         // Degradation
    releaseRate   : Float;         // Release from sources
    
    // Source locations
    sources       : [GradientCoord];
    sourceStrengths: [Float];
    
    // Receptor binding
    bindingAffinity: Float;
    saturation    : Float;
  };

  // Connectivity gradient
  public type ConnectivityGradient = {
    // Gradient axes (Huntenburg et al.)
    sensoryMotor  : [[Float]];     // Unimodal ↔ Transmodal
    visualAuditory: [[Float]];     // Visual ↔ Auditory
    
    // Hierarchical gradient
    hierarchyLevel: [[Float]];     // Low-level ↔ High-level
    
    // Temporal gradient
    timescale     : [[Float]];     // Fast ↔ Slow dynamics
  };

  // ══════════════════════════════════════════════════════════════
  // WHITE MATTER TRACTS
  // ══════════════════════════════════════════════════════════════

  public type WhiteMatterTract = {
    name          : Text;
    tractType     : TractType;
    
    // Endpoints
    origin        : [Nat];         // Origin Brodmann areas
    termination   : [Nat];         // Target Brodmann areas
    
    // Properties
    fiberCount    : Nat;           // Number of axons
    myelinIntegrity: Float;        // FA equivalent
    length        : Float;         // Tract length
    conductionSpeed: Float;        // m/s
    
    // Current state
    signalStrength: Float;
    coherence     : Float;
  };

  public type TractType = {
    #Association;        // Within hemisphere
    #Commissural;        // Between hemispheres
    #Projection;         // Cortex ↔ subcortex
  };

  // Major tracts
  public let MAJOR_TRACTS : [Text] = [
    "CorpusCallosum",           // Interhemispheric
    "ArcuateFasciculus",        // Language (Broca↔Wernicke)
    "SuperiorLongitudinal",     // Parietal↔Frontal
    "InferiorLongitudinal",     // Occipital↔Temporal
    "Uncinate",                 // Temporal↔Frontal
    "Cingulum",                 // Limbic
    "CorticospinalTract",       // Motor
    "Fornix",                   // Hippocampus↔Hypothalamus
    "OpticRadiation",           // LGN↔V1
    "InternalCapsule",          // Thalamus↔Cortex
  ];

  // ══════════════════════════════════════════════════════════════
  // SUBCORTICAL NUCLEI
  // ══════════════════════════════════════════════════════════════

  public type SubcorticalNucleus = {
    name          : Text;
    nucleusType   : NucleusType;
    position      : GradientCoord;
    
    // Subdivisions
    subdivisions  : [Text];
    subActivity   : [Float];
    
    // Connectivity
    afferents     : [Nat];         // Input from BA
    efferents     : [Nat];         // Output to BA
    
    // Function
    activity      : Float;
    neuromodOutput: Float;         // If neuromodulatory
  };

  public type NucleusType = {
    #Thalamic;
    #BasalGanglia;
    #Limbic;
    #Brainstem;
    #Cerebellar;
    #Hypothalamic;
  };

  // ══════════════════════════════════════════════════════════════
  // FULL SUBSTRATE STATE
  // ══════════════════════════════════════════════════════════════

  public type NeuralSubstrateState = {
    // Cortical representation
    brodmannAreas   : [BrodmannArea];
    
    // Gradient fields
    excitationField : NeuralField;
    inhibitionField : NeuralField;
    predictionField : NeuralField;
    errorField      : NeuralField;
    
    // Chemical gradients
    dopamineGradient: ChemicalGradient;
    serotoninGradient: ChemicalGradient;
    norepinephrineGradient: ChemicalGradient;
    acetylcholineGradient: ChemicalGradient;
    glutamateGradient: ChemicalGradient;
    gabaGradient    : ChemicalGradient;
    
    // Connectivity
    connectivityGradient: ConnectivityGradient;
    whiteTracts     : [WhiteMatterTract];
    
    // Subcortical
    subcorticalNuclei: [SubcorticalNucleus];
    
    // Global substrate state
    globalEnergy    : Float;        // Metabolic/computational
    temperature     : Float;        // "Neural temperature"
    entropy         : Float;        // Information entropy
    
    // Gradient flow
    energyGradient  : [[Float]];    // ∇E
    flowVelocity    : [[Float]];    // dx/dt
    
    // Temporal
    beatNum         : Nat;
    dt              : Float;
  };

  // ══════════════════════════════════════════════════════════════
  // CONSTANTS
  // ══════════════════════════════════════════════════════════════

  let EPSILON : Float = 1e-10;
  let PI : Float = 3.14159265358979;
  let GRID_SIZE : Nat = 32;

  // ══════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func _sigmoid(x: Float, steepness: Float, threshold: Float) : Float {
    1.0 / (1.0 + Float.exp(-steepness * (x - threshold)))
  };

  func _gaussian(dist: Float, sigma: Float) : Float {
    Float.exp(-(dist * dist) / (2.0 * sigma * sigma))
  };

  func _laplacian(field: [[Float]], i: Nat, j: Nat) : Float {
    let n = field.size();
    if (n == 0 or i == 0 or j == 0 or i >= n - 1 or j >= n - 1) { return 0.0 };
    
    let center = field[i][j];
    let up = field[i-1][j];
    let down = field[i+1][j];
    let left = field[i][j-1];
    let right = field[i][j+1];
    
    up + down + left + right - 4.0 * center
  };

  // ══════════════════════════════════════════════════════════════
  // NEURAL FIELD DYNAMICS
  // ══════════════════════════════════════════════════════════════

  // Wilson-Cowan neural field equation
  // ∂u/∂t = -u/τ + S(∫W(x,y)u(y)dy + I(x))
  public func updateNeuralField(
    field: NeuralField,
    dt: Float
  ) : NeuralField {
    let n = field.gridSize;
    var newValues = Array.tabulate<[Float]>(n, func(i) {
      Array.tabulate<Float>(n, func(j) {
        let current = field.fieldValues[i][j];
        
        // Compute lateral interactions
        var excitation : Float = 0.0;
        var inhibition : Float = 0.0;
        
        // Local connectivity kernel
        var di : Int = -3;
        while (di <= 3) {
          var dj : Int = -3;
          while (dj <= 3) {
            let ni = Int.abs(i + di);
            let nj = Int.abs(j + dj);
            if (ni < n and nj < n and (di != 0 or dj != 0)) {
              let dist = Float.sqrt(Float.fromInt(di * di + dj * dj));
              let neighborVal = field.fieldValues[ni][nj];
              
              // Mexican hat: excitation close, inhibition far
              excitation += _gaussian(dist, field.excitRadius) * neighborVal * field.excitStrength;
              inhibition += _gaussian(dist, field.inhibRadius) * neighborVal * field.inhibStrength;
            };
            dj += 1;
          };
          di += 1;
        };
        
        // External input
        let input = if (i < field.inputField.size() and j < field.inputField[i].size()) {
          field.inputField[i][j]
        } else { 0.0 };
        
        // Neural mass equation
        let netInput = excitation - inhibition + input;
        let activation = _sigmoid(netInput, field.steepness, field.threshold);
        
        // Temporal dynamics
        let decay = -current / field.timeConstant;
        let newVal = current + (decay + activation) * dt;
        
        _clamp(newVal, 0.0, 1.0)
      })
    });
    
    {
      gridSize = field.gridSize;
      fieldValues = newValues;
      timeConstant = field.timeConstant;
      threshold = field.threshold;
      steepness = field.steepness;
      excitRadius = field.excitRadius;
      inhibRadius = field.inhibRadius;
      excitStrength = field.excitStrength;
      inhibStrength = field.inhibStrength;
      inputField = field.inputField;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // CHEMICAL GRADIENT DIFFUSION
  // ══════════════════════════════════════════════════════════════

  // Reaction-diffusion: ∂c/∂t = D∇²c - k·c + R
  public func updateChemicalGradient(
    gradient: ChemicalGradient,
    dt: Float
  ) : ChemicalGradient {
    let n = gradient.concentration.size();
    if (n == 0) { return gradient };
    
    var newConc = Array.tabulate<[Float]>(n, func(i) {
      let m = gradient.concentration[i].size();
      Array.tabulate<Float>(m, func(j) {
        let current = gradient.concentration[i][j];
        
        // Diffusion term (Laplacian)
        let laplacian = _laplacian(gradient.concentration, i, j);
        let diffusion = gradient.diffusionCoeff * laplacian;
        
        // Decay term
        let decay = -gradient.decayRate * current;
        
        // Source term (release from nuclei)
        var release : Float = 0.0;
        var k : Nat = 0;
        for (source in gradient.sources.vals()) {
          let di = Float.fromInt(i) / Float.fromInt(n) - source.x;
          let dj = Float.fromInt(j) / Float.fromInt(n) - source.y;
          let dist = Float.sqrt(di * di + dj * dj);
          let strength = if (k < gradient.sourceStrengths.size()) {
            gradient.sourceStrengths[k]
          } else { 0.0 };
          release += strength * _gaussian(dist, 0.1) * gradient.releaseRate;
          k += 1;
        };
        
        // Update
        let newVal = current + (diffusion + decay + release) * dt;
        _clamp(newVal, 0.0, gradient.saturation)
      })
    });
    
    {
      name = gradient.name;
      concentration = newConc;
      diffusionCoeff = gradient.diffusionCoeff;
      decayRate = gradient.decayRate;
      releaseRate = gradient.releaseRate;
      sources = gradient.sources;
      sourceStrengths = gradient.sourceStrengths;
      bindingAffinity = gradient.bindingAffinity;
      saturation = gradient.saturation;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // BRODMANN AREA UPDATE
  // ══════════════════════════════════════════════════════════════

  // Update Brodmann area based on gradient field values
  public func updateBrodmannArea(
    area: BrodmannArea,
    excitationField: [[Float]],
    inhibitionField: [[Float]],
    dopamine: [[Float]],
    gridSize: Nat
  ) : BrodmannArea {
    // Sample field at area position
    let xi = Int.abs(Float.toInt(area.position.x * Float.fromInt(gridSize)));
    let yi = Int.abs(Float.toInt(area.position.y * Float.fromInt(gridSize)));
    
    let excit = if (xi < excitationField.size() and yi < excitationField[xi].size()) {
      excitationField[xi][yi]
    } else { 0.0 };
    
    let inhib = if (xi < inhibitionField.size() and yi < inhibitionField[xi].size()) {
      inhibitionField[xi][yi]
    } else { 0.0 };
    
    let da = if (xi < dopamine.size() and yi < dopamine[xi].size()) {
      dopamine[xi][yi]
    } else { 0.5 };
    
    // Layer-specific dynamics
    // Layer 4 receives input, Layer 5 generates output
    let newL4 = excit * 0.7;  // Input layer
    let newL5 = area.layer5 * 0.8 + (newL4 - inhib) * 0.2;  // Output layer
    let newL2 = area.layer3 * 0.3 + newL4 * 0.2;  // Feedforward
    let newL6 = area.layer6 * 0.7 + newL5 * 0.1;  // Feedback
    
    // Predictive coding
    let prediction = newL6 * 0.6 + area.prediction * 0.4;
    let error = _clamp((newL4 - prediction), -1.0, 1.0);
    
    // Activity modulated by dopamine
    let activity = (newL5 + newL2 / 3.0) * (0.7 + da * 0.3);
    
    {
      id = area.id;
      name = area.name;
      hemisphere = area.hemisphere;
      position = area.position;
      extent = area.extent;
      layer1 = area.layer1;
      layer2 = _clamp(newL2, 0.0, 1.0);
      layer3 = area.layer3;
      layer4 = _clamp(newL4, 0.0, 1.0);
      layer5 = _clamp(newL5, 0.0, 1.0);
      layer6 = _clamp(newL6, 0.0, 1.0);
      activity = _clamp(activity, 0.0, 1.0);
      prediction = prediction;
      error = error;
      neuronDensity = area.neuronDensity;
      myelination = area.myelination;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // GRADIENT FLOW (Energy Minimization)
  // ══════════════════════════════════════════════════════════════

  // Compute energy gradient ∇E
  public func computeEnergyGradient(
    excitationField: [[Float]],
    predictionField: [[Float]],
    errorField: [[Float]]
  ) : [[Float]] {
    let n = excitationField.size();
    if (n == 0) { return [[]] };
    
    Array.tabulate<[Float]>(n, func(i) {
      let m = excitationField[i].size();
      Array.tabulate<Float>(m, func(j) {
        // Energy = prediction_error² + activity_cost
        let err = if (i < errorField.size() and j < errorField[i].size()) {
          errorField[i][j]
        } else { 0.0 };
        
        let act = excitationField[i][j];
        
        // Gradient: direction of steepest descent
        let energyGrad = 2.0 * err + 0.1 * act;  // Error term + regularization
        _clamp(energyGrad, -1.0, 1.0)
      })
    })
  };

  // ══════════════════════════════════════════════════════════════
  // MAIN BEAT FUNCTION
  // ══════════════════════════════════════════════════════════════

  public type SubstrateInput = {
    sensoryInput     : [[Float]];   // External sensory
    motorCommand     : [[Float]];   // Motor output
    reward           : Float;       // Reward signal
    arousal          : Float;       // Arousal level
  };

  public func beatNeuralSubstrate(
    state: NeuralSubstrateState,
    input: SubstrateInput
  ) : NeuralSubstrateState {
    let dt = state.dt;
    
    // 1. Update excitation field with sensory input
    let excitWithInput : NeuralField = {
      state.excitationField with
      inputField = input.sensoryInput
    };
    let newExcitation = updateNeuralField(excitWithInput, dt);
    
    // 2. Update inhibition field
    let newInhibition = updateNeuralField(state.inhibitionField, dt);
    
    // 3. Update prediction field (top-down)
    let newPrediction = updateNeuralField(state.predictionField, dt);
    
    // 4. Compute error field
    let newErrorField : NeuralField = {
      state.errorField with
      fieldValues = Array.tabulate<[Float]>(state.errorField.gridSize, func(i) {
        Array.tabulate<Float>(state.errorField.gridSize, func(j) {
          let excit = newExcitation.fieldValues[i][j];
          let pred = newPrediction.fieldValues[i][j];
          _clamp(excit - pred, -1.0, 1.0)
        })
      })
    };
    
    // 5. Update chemical gradients
    // Dopamine sources: VTA, SNc
    let daWithReward : ChemicalGradient = {
      state.dopamineGradient with
      sourceStrengths = Array.map<Float, Float>(
        state.dopamineGradient.sourceStrengths,
        func(s) { s + input.reward * 0.3 }
      )
    };
    let newDopamine = updateChemicalGradient(daWithReward, dt);
    
    // Norepinephrine modulated by arousal
    let neWithArousal : ChemicalGradient = {
      state.norepinephrineGradient with
      sourceStrengths = Array.map<Float, Float>(
        state.norepinephrineGradient.sourceStrengths,
        func(s) { s * (0.5 + input.arousal * 0.5) }
      )
    };
    let newNE = updateChemicalGradient(neWithArousal, dt);
    
    let newSerotonin = updateChemicalGradient(state.serotoninGradient, dt);
    let newACh = updateChemicalGradient(state.acetylcholineGradient, dt);
    let newGlutamate = updateChemicalGradient(state.glutamateGradient, dt);
    let newGABA = updateChemicalGradient(state.gabaGradient, dt);
    
    // 6. Update Brodmann areas
    let newBAs = Array.map<BrodmannArea, BrodmannArea>(state.brodmannAreas, func(ba) {
      updateBrodmannArea(
        ba,
        newExcitation.fieldValues,
        newInhibition.fieldValues,
        newDopamine.concentration,
        state.excitationField.gridSize
      )
    });
    
    // 7. Compute energy gradient
    let newEnergyGrad = computeEnergyGradient(
      newExcitation.fieldValues,
      newPrediction.fieldValues,
      newErrorField.fieldValues
    );
    
    // 8. Compute global energy
    var sumError : Float = 0.0;
    var sumAct : Float = 0.0;
    for (row in newErrorField.fieldValues.vals()) {
      for (v in row.vals()) {
        sumError += v * v;
      };
    };
    for (row in newExcitation.fieldValues.vals()) {
      for (v in row.vals()) {
        sumAct += v;
      };
    };
    let gridTotal = Float.fromInt(state.excitationField.gridSize * state.excitationField.gridSize);
    let newEnergy = sumError / gridTotal + sumAct * 0.01;
    
    // 9. Compute entropy
    var entropy : Float = 0.0;
    for (ba in newBAs.vals()) {
      let p = ba.activity;
      if (p > EPSILON and p < 1.0 - EPSILON) {
        entropy -= p * Float.log(p) + (1.0 - p) * Float.log(1.0 - p);
      };
    };
    entropy /= Float.fromInt(Nat.max(newBAs.size(), 1));
    
    {
      brodmannAreas = newBAs;
      excitationField = newExcitation;
      inhibitionField = newInhibition;
      predictionField = newPrediction;
      errorField = newErrorField;
      dopamineGradient = newDopamine;
      serotoninGradient = newSerotonin;
      norepinephrineGradient = newNE;
      acetylcholineGradient = newACh;
      glutamateGradient = newGlutamate;
      gabaGradient = newGABA;
      connectivityGradient = state.connectivityGradient;
      whiteTracts = state.whiteTracts;
      subcorticalNuclei = state.subcorticalNuclei;
      globalEnergy = _clamp(newEnergy, 0.0, 10.0);
      temperature = state.temperature * 0.99 + newEnergy * 0.01;
      entropy = entropy;
      energyGradient = newEnergyGrad;
      flowVelocity = state.flowVelocity;
      beatNum = state.beatNum + 1;
      dt = state.dt;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ══════════════════════════════════════════════════════════════

  func createEmptyField(size: Nat, initVal: Float) : [[Float]] {
    Array.tabulate<[Float]>(size, func(_) {
      Array.tabulate<Float>(size, func(_) { initVal })
    })
  };

  func createNeuralField(size: Nat) : NeuralField {
    {
      gridSize = size;
      fieldValues = createEmptyField(size, 0.1);
      timeConstant = 10.0;
      threshold = 0.3;
      steepness = 4.0;
      excitRadius = 2.0;
      inhibRadius = 4.0;
      excitStrength = 0.8;
      inhibStrength = 0.4;
      inputField = createEmptyField(size, 0.0);
    }
  };

  func createChemicalGradient(name: Text, sources: [GradientCoord]) : ChemicalGradient {
    {
      name = name;
      concentration = createEmptyField(GRID_SIZE, 0.5);
      diffusionCoeff = 0.1;
      decayRate = 0.05;
      releaseRate = 0.1;
      sources = sources;
      sourceStrengths = Array.tabulate<Float>(sources.size(), func(_) { 0.3 });
      bindingAffinity = 0.8;
      saturation = 1.0;
    }
  };

  // Create Brodmann area
  func createBA(id: Nat, name: Text, x: Float, y: Float, z: Float) : BrodmannArea {
    {
      id = id;
      name = name;
      hemisphere = #Bilateral;
      position = { x = x; y = y; z = z };
      extent = 0.1;
      layer1 = 0.1;
      layer2 = 0.2;
      layer3 = 0.3;
      layer4 = 0.2;
      layer5 = 0.3;
      layer6 = 0.2;
      activity = 0.2;
      prediction = 0.2;
      error = 0.0;
      neuronDensity = 0.5;
      myelination = 0.5;
    }
  };

  public func initNeuralSubstrate() : NeuralSubstrateState {
    // Key Brodmann areas
    let brodmannAreas = [
      createBA(4, "PrimaryMotor", 0.3, 0.5, 0.7),
      createBA(6, "PremotorSMA", 0.25, 0.5, 0.7),
      createBA(17, "PrimaryVisual", 0.9, 0.5, 0.4),
      createBA(18, "SecondaryVisual", 0.85, 0.5, 0.45),
      createBA(41, "PrimaryAuditory", 0.5, 0.8, 0.4),
      createBA(1, "PrimarySomatosensory", 0.35, 0.5, 0.7),
      createBA(9, "DorsolateralPFC", 0.1, 0.5, 0.7),
      createBA(10, "FrontalPole", 0.05, 0.5, 0.5),
      createBA(11, "OrbitofrontalCortex", 0.1, 0.5, 0.3),
      createBA(24, "AnteriorCingulate", 0.2, 0.5, 0.6),
      createBA(44, "Broca", 0.2, 0.3, 0.5),
      createBA(22, "Wernicke", 0.6, 0.3, 0.5),
      createBA(7, "SuperiorParietal", 0.5, 0.5, 0.8),
      createBA(40, "InferiorParietal", 0.5, 0.4, 0.6),
      createBA(37, "FusiformGyrus", 0.7, 0.4, 0.3),
    ];
    
    // Neuromodulator sources
    let vtaCoord : GradientCoord = { x = 0.5; y = 0.5; z = 0.2 };
    let sncCoord : GradientCoord = { x = 0.45; y = 0.5; z = 0.25 };
    let lcCoord : GradientCoord = { x = 0.6; y = 0.5; z = 0.15 };
    let rapheCoord : GradientCoord = { x = 0.55; y = 0.5; z = 0.1 };
    let bfCoord : GradientCoord = { x = 0.3; y = 0.5; z = 0.25 };
    
    {
      brodmannAreas = brodmannAreas;
      excitationField = createNeuralField(GRID_SIZE);
      inhibitionField = createNeuralField(GRID_SIZE);
      predictionField = createNeuralField(GRID_SIZE);
      errorField = createNeuralField(GRID_SIZE);
      dopamineGradient = createChemicalGradient("Dopamine", [vtaCoord, sncCoord]);
      serotoninGradient = createChemicalGradient("Serotonin", [rapheCoord]);
      norepinephrineGradient = createChemicalGradient("Norepinephrine", [lcCoord]);
      acetylcholineGradient = createChemicalGradient("Acetylcholine", [bfCoord]);
      glutamateGradient = createChemicalGradient("Glutamate", []);
      gabaGradient = createChemicalGradient("GABA", []);
      connectivityGradient = {
        sensoryMotor = createEmptyField(GRID_SIZE, 0.5);
        visualAuditory = createEmptyField(GRID_SIZE, 0.5);
        hierarchyLevel = createEmptyField(GRID_SIZE, 0.5);
        timescale = createEmptyField(GRID_SIZE, 0.5);
      };
      whiteTracts = [];
      subcorticalNuclei = [];
      globalEnergy = 0.5;
      temperature = 0.5;
      entropy = 0.5;
      energyGradient = createEmptyField(GRID_SIZE, 0.0);
      flowVelocity = createEmptyField(GRID_SIZE, 0.0);
      beatNum = 0;
      dt = 0.001;
    }
  };

  // ══════════════════════════════════════════════════════════════
  // SUMMARY
  // ══════════════════════════════════════════════════════════════

  public type SubstrateSummary = {
    brodmannCount    : Nat;
    globalEnergy     : Float;
    entropy          : Float;
    avgExcitation    : Float;
    avgInhibition    : Float;
    avgPredictionError: Float;
    dopamineLevel    : Float;
    serotoninLevel   : Float;
  };

  public func summary(state: NeuralSubstrateState) : SubstrateSummary {
    var sumExcit : Float = 0.0;
    var sumInhib : Float = 0.0;
    var sumErr : Float = 0.0;
    var sumDA : Float = 0.0;
    var sumSer : Float = 0.0;
    
    for (row in state.excitationField.fieldValues.vals()) {
      for (v in row.vals()) { sumExcit += v };
    };
    for (row in state.inhibitionField.fieldValues.vals()) {
      for (v in row.vals()) { sumInhib += v };
    };
    for (row in state.errorField.fieldValues.vals()) {
      for (v in row.vals()) { sumErr += Float.abs(v) };
    };
    for (row in state.dopamineGradient.concentration.vals()) {
      for (v in row.vals()) { sumDA += v };
    };
    for (row in state.serotoninGradient.concentration.vals()) {
      for (v in row.vals()) { sumSer += v };
    };
    
    let total = Float.fromInt(GRID_SIZE * GRID_SIZE);
    
    {
      brodmannCount = state.brodmannAreas.size();
      globalEnergy = state.globalEnergy;
      entropy = state.entropy;
      avgExcitation = sumExcit / total;
      avgInhibition = sumInhib / total;
      avgPredictionError = sumErr / total;
      dopamineLevel = sumDA / total;
      serotoninLevel = sumSer / total;
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

}
