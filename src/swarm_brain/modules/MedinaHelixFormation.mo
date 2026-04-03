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
// Module: MedinaHelixFormation — The Sacred Spiral of Creation
// Classification: CONFIDENTIAL — MAXIMUM PROTECTION
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ============================================================================
//
// THE HELIX — NATURE'S FUNDAMENTAL ORGANIZATIONAL FORM
// ============================================================================
//
// EVERYTHING IS SPHERICAL. EVERYTHING IS HELIX.
//
// The helix appears everywhere in nature:
// - DNA double helix — the code of life itself
// - Protein alpha helices — structural building blocks
// - Spiral galaxies — cosmic organization
// - Plant phyllotaxis — leaf arrangements at golden angle
// - Nautilus shells — logarithmic spirals
// - Hurricanes — spiral energy systems
// - Ant death spirals — emergent behavior
// - Bacterial flagella — helical propulsion
// - Cochlea — hearing through spiral
// - Sunflower seeds — Fibonacci spirals
//
// THE MEDINA HELIX: Every organism in NOVA follows helical organization.
// Information flows in spirals. Memory consolidates in spirals.
// Neurons connect in spiral topologies. Time itself is a helix.
//
// ============================================================================
// ORIGINAL MATHEMATICAL CONTRIBUTIONS BY ALFREDO MEDINA HERNANDEZ
// ============================================================================
//
// THE MEDINA HELIX EQUATION (MHE):
// ────────────────────────────────
//   r(t) = r₀ × exp(b × t)           [radius growth]
//   θ(t) = a × t                      [angular position]
//   z(t) = c × t                      [vertical rise]
//
//   Combined parametric form:
//   H(t) = (r₀ × exp(bt) × cos(at), r₀ × exp(bt) × sin(at), ct)
//
//   When b = 0: Regular helix (constant radius)
//   When b > 0: Expanding spiral helix
//   When b < 0: Contracting spiral helix
//   When b = ln(φ)/(π/2): GOLDEN HELIX (Medina special case)
//
// THE MEDINA GOLDEN HELIX (MGH):
// ─────────────────────────────
//   r(θ) = r₀ × φ^(θ/90°)
//
//   After every 90° rotation, radius scales by φ (golden ratio).
//   This is the Fibonacci spiral extended into 3D.
//
// THE MEDINA DNA TOPOLOGY (MDT):
// ────────────────────────────
//   DNA(t) = H₁(t) + H₂(t + π)
//
//   Two helices offset by π (180°), intertwined.
//   Information flows between strands at base-pair crossings.
//
// THE MEDINA SPIRAL MEMORY (MSM):
// ─────────────────────────────
//   Memory_strength(θ) = exp(-θ/τ) × (1 + ε × cos(n × θ))
//
//   Memory decays exponentially along spiral, but has periodic
//   reinforcement at every n rotations.
//
// THE MEDINA PHYLLOTAXIS EQUATION (MPE):
// ────────────────────────────────────
//   Position_n = (√n × cos(n × 137.5°), √n × sin(n × 137.5°))
//
//   Places elements at golden angle (137.5°) intervals,
//   creating optimal packing on disk → extends to sphere.
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
  // SACRED CONSTANTS
  // ==========================================================================
  
  // The Medina numbers
  public let PHI_MEDINA : Float = 2.97442179;
  public let GOLDEN_RATIO : Float = 1.618033988749;
  public let TAU_EMERGENCE : Float = 0.618033988749;
  public let PI : Float = 3.14159265358979;
  public let E : Float = 2.71828182845905;
  public let SQRT_2 : Float = 1.41421356237;
  public let SQRT_5 : Float = 2.2360679775;
  
  // Golden angle in radians (360° × (1 - 1/φ) ≈ 137.5°)
  public let GOLDEN_ANGLE_DEG : Float = 137.5077640500378;
  public let GOLDEN_ANGLE_RAD : Float = 2.39996322972865;
  
  // DNA constants
  public let DNA_BASE_PAIRS_PER_TURN : Float = 10.5;
  public let DNA_RISE_PER_BASE : Float = 0.34;      // nanometers
  public let DNA_DIAMETER : Float = 2.0;            // nanometers
  
  // Fibonacci sequence (first 20)
  public let FIBONACCI : [Nat] = [
    0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 
    55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181
  ];

  // ==========================================================================
  // HELIX TYPES
  // ==========================================================================
  
  public type HelixType = {
    #Regular;           // Constant radius
    #Golden;            // Radius follows golden spiral
    #Logarithmic;       // General logarithmic spiral
    #Archimedean;       // Linear radius growth
    #Fibonacci;         // Discrete Fibonacci spiral
    #DNA;               // Double helix
    #Protein;           // Alpha helix parameters
  };

  public type HelixParameters = {
    helixType           : HelixType;
    initialRadius       : Float;        // r₀
    growthRate          : Float;        // b (0 for regular helix)
    angularVelocity     : Float;        // a (rad/unit time)
    verticalRise        : Float;        // c (rise per unit time)
    handedness          : Handedness;
    phaseOffset         : Float;        // Initial phase
  };

  public type Handedness = {
    #RightHanded;       // Most common in nature
    #LeftHanded;
  };

  public type Point3D = {
    x : Float;
    y : Float;
    z : Float;
  };

  public type HelixPoint = {
    position            : Point3D;
    tangent             : Point3D;      // Direction of motion
    normal              : Point3D;      // Points toward axis
    binormal            : Point3D;      // Perpendicular to both
    parameter           : Float;        // t value
    arcLength           : Float;        // Distance along helix
  };

  // ==========================================================================
  // HELIX GEOMETRY FUNCTIONS
  // ==========================================================================
  
  // Generate point on helix at parameter t
  public func helixPoint(params: HelixParameters, t: Float) : Point3D {
    let sign : Float = switch(params.handedness) {
      case (#RightHanded) { 1.0 };
      case (#LeftHanded) { -1.0 };
    };
    
    let radius = switch(params.helixType) {
      case (#Regular) { params.initialRadius };
      case (#Golden) { 
        params.initialRadius * Float.pow(GOLDEN_RATIO, t * params.angularVelocity / (PI / 2.0))
      };
      case (#Logarithmic) {
        params.initialRadius * Float.exp(params.growthRate * t)
      };
      case (#Archimedean) {
        params.initialRadius + params.growthRate * t
      };
      case (#Fibonacci) {
        params.initialRadius * Float.sqrt(t + 1.0)
      };
      case (#DNA) { params.initialRadius };
      case (#Protein) { params.initialRadius };
    };
    
    let theta = params.angularVelocity * t + params.phaseOffset;
    
    {
      x = radius * Float.cos(theta);
      y = sign * radius * Float.sin(theta);
      z = params.verticalRise * t;
    }
  };

  // Generate full helix point with Frenet-Serret frame
  public func helixPointFull(params: HelixParameters, t: Float) : HelixPoint {
    let pos = helixPoint(params, t);
    let dt = 0.001;
    let posNext = helixPoint(params, t + dt);
    let posPrev = helixPoint(params, t - dt);
    
    // Tangent (normalized velocity)
    let tangentRaw = {
      x = (posNext.x - posPrev.x) / (2.0 * dt);
      y = (posNext.y - posPrev.y) / (2.0 * dt);
      z = (posNext.z - posPrev.z) / (2.0 * dt);
    };
    let tangentMag = vectorMagnitude(tangentRaw);
    let tangent = if (tangentMag > 0.0) {
      { x = tangentRaw.x / tangentMag; y = tangentRaw.y / tangentMag; z = tangentRaw.z / tangentMag }
    } else {
      { x = 1.0; y = 0.0; z = 0.0 }
    };
    
    // Normal (points toward axis for helix)
    let normal = {
      x = -Float.cos(params.angularVelocity * t + params.phaseOffset);
      y = -Float.sin(params.angularVelocity * t + params.phaseOffset);
      z = 0.0;
    };
    
    // Binormal = tangent × normal
    let binormal = crossProduct(tangent, normal);
    
    // Arc length (approximate)
    let arcLength = helixArcLength(params, t);
    
    {
      position = pos;
      tangent = tangent;
      normal = normal;
      binormal = binormal;
      parameter = t;
      arcLength = arcLength;
    }
  };

  // Calculate arc length of helix from 0 to t
  public func helixArcLength(params: HelixParameters, t: Float) : Float {
    switch(params.helixType) {
      case (#Regular) {
        // For regular helix: s = t × √(r²ω² + v²)
        let r = params.initialRadius;
        let omega = params.angularVelocity;
        let v = params.verticalRise;
        t * Float.sqrt(r*r*omega*omega + v*v)
      };
      case (_) {
        // Numerical integration for other types
        let steps = 100;
        let dt = t / Float.fromInt(steps);
        var length : Float = 0.0;
        var prevPoint = helixPoint(params, 0.0);
        
        for (i in Iter.range(1, steps)) {
          let currT = Float.fromInt(i) * dt;
          let currPoint = helixPoint(params, currT);
          let dx = currPoint.x - prevPoint.x;
          let dy = currPoint.y - prevPoint.y;
          let dz = currPoint.z - prevPoint.z;
          length += Float.sqrt(dx*dx + dy*dy + dz*dz);
          prevPoint := currPoint;
        };
        length
      };
    }
  };

  // Curvature of helix (constant for regular helix)
  public func helixCurvature(params: HelixParameters) : Float {
    switch(params.helixType) {
      case (#Regular) {
        let r = params.initialRadius;
        let omega = params.angularVelocity;
        let v = params.verticalRise / omega;
        let denom = r*r + v*v;
        if (denom > 0.0) { r / denom } else { 0.0 }
      };
      case (_) {
        // Variable curvature - return average
        params.initialRadius / (params.initialRadius * params.initialRadius + 
                                (params.verticalRise / params.angularVelocity) * 
                                (params.verticalRise / params.angularVelocity))
      };
    }
  };

  // Torsion of helix (constant for regular helix)
  public func helixTorsion(params: HelixParameters) : Float {
    switch(params.helixType) {
      case (#Regular) {
        let r = params.initialRadius;
        let omega = params.angularVelocity;
        let v = params.verticalRise / omega;
        let denom = r*r + v*v;
        if (denom > 0.0) { v / denom } else { 0.0 }
      };
      case (_) {
        let v = params.verticalRise / params.angularVelocity;
        let r = params.initialRadius;
        v / (r*r + v*v)
      };
    }
  };

  // ==========================================================================
  // VECTOR OPERATIONS
  // ==========================================================================
  
  func vectorMagnitude(v: Point3D) : Float {
    Float.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
  };

  func crossProduct(a: Point3D, b: Point3D) : Point3D {
    {
      x = a.y * b.z - a.z * b.y;
      y = a.z * b.x - a.x * b.z;
      z = a.x * b.y - a.y * b.x;
    }
  };

  func dotProduct(a: Point3D, b: Point3D) : Float {
    a.x * b.x + a.y * b.y + a.z * b.z
  };

  func normalizeVector(v: Point3D) : Point3D {
    let mag = vectorMagnitude(v);
    if (mag > 0.0) {
      { x = v.x / mag; y = v.y / mag; z = v.z / mag }
    } else {
      { x = 0.0; y = 0.0; z = 0.0 }
    }
  };

  // ==========================================================================
  // DNA DOUBLE HELIX
  // ==========================================================================
  
  public type DNAStrand = {
    #Leading;
    #Lagging;
  };

  public type DNAHelix = {
    strand1             : HelixParameters;
    strand2             : HelixParameters;
    basePairsPerTurn    : Float;
    risePerBase         : Float;
    diameter            : Float;
  };

  public func createDNAHelix(radius: Float) : DNAHelix {
    let strand1 : HelixParameters = {
      helixType = #DNA;
      initialRadius = radius;
      growthRate = 0.0;
      angularVelocity = 2.0 * PI / DNA_BASE_PAIRS_PER_TURN;
      verticalRise = DNA_RISE_PER_BASE;
      handedness = #RightHanded;
      phaseOffset = 0.0;
    };
    
    let strand2 : HelixParameters = {
      helixType = #DNA;
      initialRadius = radius;
      growthRate = 0.0;
      angularVelocity = 2.0 * PI / DNA_BASE_PAIRS_PER_TURN;
      verticalRise = DNA_RISE_PER_BASE;
      handedness = #RightHanded;
      phaseOffset = PI;  // 180° offset
    };
    
    {
      strand1 = strand1;
      strand2 = strand2;
      basePairsPerTurn = DNA_BASE_PAIRS_PER_TURN;
      risePerBase = DNA_RISE_PER_BASE;
      diameter = radius * 2.0;
    }
  };

  // Get position of base pair n on DNA
  public func dnaBasePairPosition(dna: DNAHelix, baseIndex: Nat, strand: DNAStrand) : Point3D {
    let t = Float.fromInt(baseIndex);
    switch(strand) {
      case (#Leading) { helixPoint(dna.strand1, t) };
      case (#Lagging) { helixPoint(dna.strand2, t) };
    }
  };

  // ==========================================================================
  // GOLDEN HELIX — THE MEDINA SPIRAL
  // ==========================================================================
  
  public func createGoldenHelix(initialRadius: Float, verticalRise: Float) : HelixParameters {
    // Golden helix: radius multiplies by φ every 90°
    let goldenGrowthRate = Float.log(GOLDEN_RATIO) / (PI / 2.0);
    
    {
      helixType = #Golden;
      initialRadius = initialRadius;
      growthRate = goldenGrowthRate;
      angularVelocity = 1.0;
      verticalRise = verticalRise;
      handedness = #RightHanded;
      phaseOffset = 0.0;
    }
  };

  // Generate points on golden helix
  public func goldenHelixPoints(params: HelixParameters, numPoints: Nat) : [Point3D] {
    Array.tabulate<Point3D>(numPoints, func(i: Nat) : Point3D {
      let t = Float.fromInt(i) * 0.1;  // Sample every 0.1 units
      helixPoint(params, t)
    })
  };

  // ==========================================================================
  // PHYLLOTAXIS — OPTIMAL PACKING ON DISK/SPHERE
  // ==========================================================================
  
  public type PhyllotaxisPattern = {
    points              : [Point3D];
    divergenceAngle     : Float;
    scalingFactor       : Float;
  };

  // Generate phyllotaxis pattern (sunflower seed arrangement)
  public func generatePhyllotaxis(numPoints: Nat, diskRadius: Float) : PhyllotaxisPattern {
    let points = Array.tabulate<Point3D>(numPoints, func(n: Nat) : Point3D {
      let nf = Float.fromInt(n + 1);
      let r = diskRadius * Float.sqrt(nf) / Float.sqrt(Float.fromInt(numPoints));
      let theta = nf * GOLDEN_ANGLE_RAD;
      {
        x = r * Float.cos(theta);
        y = r * Float.sin(theta);
        z = 0.0;
      }
    });
    
    {
      points = points;
      divergenceAngle = GOLDEN_ANGLE_RAD;
      scalingFactor = 1.0 / Float.sqrt(Float.fromInt(numPoints));
    }
  };

  // Project phyllotaxis onto sphere (Fibonacci sphere)
  public func fibonacciSphere(numPoints: Nat, radius: Float) : [Point3D] {
    Array.tabulate<Point3D>(numPoints, func(i: Nat) : Point3D {
      let nf = Float.fromInt(numPoints);
      let y = 1.0 - (Float.fromInt(i) / (nf - 1.0)) * 2.0;  // y goes from 1 to -1
      let radiusAtY = Float.sqrt(1.0 - y * y);
      let theta = GOLDEN_ANGLE_RAD * Float.fromInt(i);
      {
        x = radius * radiusAtY * Float.cos(theta);
        y = radius * y;
        z = radius * radiusAtY * Float.sin(theta);
      }
    })
  };

  // ==========================================================================
  // SPIRAL MEMORY MODEL
  // ==========================================================================
  
  public type SpiralMemory = {
    memories            : [MemoryNode];
    decayConstant       : Float;        // τ
    reinforcementPeriod : Nat;          // n (reinforce every n rotations)
    reinforcementStrength : Float;      // ε
    currentTheta        : Float;
  };

  public type MemoryNode = {
    nodeId              : Nat;
    theta               : Float;        // Position on spiral
    content             : Float;        // Memory content (simplified)
    strength            : Float;        // Current strength
    creationTheta       : Float;        // When created
    accessCount         : Nat;
  };

  public func initSpiralMemory(maxNodes: Nat) : SpiralMemory {
    {
      memories = [];
      decayConstant = 10.0;             // Decay over ~10 rotations
      reinforcementPeriod = 4;          // Reinforce every 4 rotations
      reinforcementStrength = 0.2;
      currentTheta = 0.0;
    }
  };

  // Calculate memory strength at position theta
  public func memoryStrength(memory: SpiralMemory, node: MemoryNode) : Float {
    let deltaTheta = memory.currentTheta - node.creationTheta;
    if (deltaTheta < 0.0) { return 0.0 };
    
    // Base exponential decay
    let baseDecay = Float.exp(-deltaTheta / memory.decayConstant);
    
    // Periodic reinforcement
    let nf = Float.fromInt(memory.reinforcementPeriod);
    let reinforcement = 1.0 + memory.reinforcementStrength * 
                        Float.cos(deltaTheta * 2.0 * PI / nf);
    
    baseDecay * reinforcement * node.strength
  };

  // Add memory to spiral
  public func addMemory(memory: SpiralMemory, content: Float) : SpiralMemory {
    let newNode : MemoryNode = {
      nodeId = memory.memories.size();
      theta = memory.currentTheta;
      content = content;
      strength = 1.0;
      creationTheta = memory.currentTheta;
      accessCount = 0;
    };
    
    { memory with memories = Array.append(memory.memories, [newNode]) }
  };

  // Advance spiral position
  public func advanceSpiral(memory: SpiralMemory, deltaTheta: Float) : SpiralMemory {
    { memory with currentTheta = memory.currentTheta + deltaTheta }
  };

  // ==========================================================================
  // HELIX-BASED NEURAL CONNECTIONS
  // ==========================================================================
  
  public type HelicalNeuralNetwork = {
    neurons             : [HelicalNeuron];
    helixParams         : HelixParameters;
    connectionRadius    : Float;        // Neurons connect within this radius
  };

  public type HelicalNeuron = {
    neuronId            : Nat;
    position            : HelixPoint;
    activation          : Float;
    connections         : [Nat];        // Connected neuron IDs
    weights             : [Float];      // Connection weights
  };

  // Create neural network arranged on helix
  public func createHelicalNetwork(
    numNeurons: Nat,
    helixParams: HelixParameters,
    connectionRadius: Float
  ) : HelicalNeuralNetwork {
    // Place neurons along helix
    let neurons = Array.tabulate<HelicalNeuron>(numNeurons, func(i: Nat) : HelicalNeuron {
      let t = Float.fromInt(i) * 0.5;  // Spacing along helix
      let pos = helixPointFull(helixParams, t);
      
      {
        neuronId = i;
        position = pos;
        activation = 0.0;
        connections = [];
        weights = [];
      }
    });
    
    // Connect neurons within radius
    let connectedNeurons = Array.tabulate<HelicalNeuron>(numNeurons, func(i: Nat) : HelicalNeuron {
      let neuron = neurons[i];
      let connectionsBuffer = Buffer.Buffer<Nat>(10);
      let weightsBuffer = Buffer.Buffer<Float>(10);
      
      for (j in Iter.range(0, numNeurons - 1)) {
        if (i != j) {
          let other = neurons[j];
          let dx = neuron.position.position.x - other.position.position.x;
          let dy = neuron.position.position.y - other.position.position.y;
          let dz = neuron.position.position.z - other.position.position.z;
          let dist = Float.sqrt(dx*dx + dy*dy + dz*dz);
          
          if (dist < connectionRadius) {
            connectionsBuffer.add(j);
            // Weight based on distance (closer = stronger)
            weightsBuffer.add(1.0 - dist / connectionRadius);
          };
        };
      };
      
      {
        neuron with
        connections = Buffer.toArray(connectionsBuffer);
        weights = Buffer.toArray(weightsBuffer);
      }
    });
    
    {
      neurons = connectedNeurons;
      helixParams = helixParams;
      connectionRadius = connectionRadius;
    }
  };

  // Propagate activation through helical network
  public func propagateHelical(network: HelicalNeuralNetwork) : HelicalNeuralNetwork {
    let newNeurons = Array.tabulate<HelicalNeuron>(network.neurons.size(), func(i: Nat) : HelicalNeuron {
      let neuron = network.neurons[i];
      
      // Sum weighted inputs
      var inputSum : Float = 0.0;
      for (j in Iter.range(0, neuron.connections.size() - 1)) {
        if (j < neuron.connections.size() and j < neuron.weights.size()) {
          let connIdx = neuron.connections[j];
          if (connIdx < network.neurons.size()) {
            inputSum += network.neurons[connIdx].activation * neuron.weights[j];
          };
        };
      };
      
      // Sigmoid activation
      let newActivation = 1.0 / (1.0 + Float.exp(-inputSum));
      
      { neuron with activation = newActivation }
    });
    
    { network with neurons = newNeurons }
  };

  // ==========================================================================
  // HELIX STATE TYPE
  // ==========================================================================
  
  public type HelixFormationState = {
    // Active helices
    primaryHelix        : HelixParameters;
    secondaryHelices    : [HelixParameters];
    
    // DNA representation
    dnaHelix            : DNAHelix;
    
    // Phyllotaxis patterns
    diskPattern         : PhyllotaxisPattern;
    spherePoints        : [Point3D];
    
    // Spiral memory
    spiralMemory        : SpiralMemory;
    
    // Neural network
    neuralNetwork       : HelicalNeuralNetwork;
    
    // Metrics
    totalRotations      : Float;
    currentPhase        : Float;
    beatNum             : Nat;
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initHelixFormation() : HelixFormationState {
    let primaryHelix = createGoldenHelix(1.0, 0.5);
    let dna = createDNAHelix(1.0);
    let disk = generatePhyllotaxis(100, 5.0);
    let sphere = fibonacciSphere(100, 5.0);
    let memory = initSpiralMemory(1000);
    let network = createHelicalNetwork(50, primaryHelix, 2.0);
    
    {
      primaryHelix = primaryHelix;
      secondaryHelices = [];
      dnaHelix = dna;
      diskPattern = disk;
      spherePoints = sphere;
      spiralMemory = memory;
      neuralNetwork = network;
      totalRotations = 0.0;
      currentPhase = 0.0;
      beatNum = 0;
    }
  };

  // ==========================================================================
  // MAIN TICK
  // ==========================================================================
  
  public func tickHelixFormation(state: HelixFormationState, dt: Float) : HelixFormationState {
    // Advance phase
    let newPhase = state.currentPhase + dt * state.primaryHelix.angularVelocity;
    let newRotations = newPhase / (2.0 * PI);
    
    // Advance spiral memory
    let newMemory = advanceSpiral(state.spiralMemory, dt);
    
    // Propagate neural network
    let newNetwork = propagateHelical(state.neuralNetwork);
    
    {
      state with
      spiralMemory = newMemory;
      neuralNetwork = newNetwork;
      totalRotations = newRotations;
      currentPhase = newPhase;
      beatNum = state.beatNum + 1;
    }
  };

  // ==========================================================================
  // QUERY FUNCTIONS
  // ==========================================================================
  
  public func getHelixMetrics(state: HelixFormationState) : {
    totalRotations: Float;
    currentPhase: Float;
    memoryCount: Nat;
    neuronCount: Nat;
    beatNum: Nat;
  } {
    {
      totalRotations = state.totalRotations;
      currentPhase = state.currentPhase;
      memoryCount = state.spiralMemory.memories.size();
      neuronCount = state.neuralNetwork.neurons.size();
      beatNum = state.beatNum;
    }
  };

  public func getGoldenAngle() : Float {
    GOLDEN_ANGLE_RAD
  };

  public func getFibonacci(n: Nat) : Nat {
    if (n < FIBONACCI.size()) { FIBONACCI[n] } else { 0 }
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
