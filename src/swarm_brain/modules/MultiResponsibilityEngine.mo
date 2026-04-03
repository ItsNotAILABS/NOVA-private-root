// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: MultiResponsibilityEngine — Engine Multi-Role & Spherical Web Wiring
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║              MULTI-RESPONSIBILITY ENGINE ARCHITECTURE                    ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  CORE PRINCIPLE: Every engine has MULTIPLE responsibilities.             ║
// ║  All engines work TOGETHER in a SPHERICAL WEB topology.                  ║
// ║                                                                          ║
// ║  NOT LINEAR: A → B → C                                                   ║
// ║  NOT PARALLEL: A ∥ B ∥ C                                                 ║
// ║  SPHERICAL WEB: All ↔ All on curved manifold                             ║
// ║                                                                          ║
// ║  This module provides:                                                   ║
// ║    • Multi-responsibility engine framework                               ║
// ║    • Spherical web connectivity                                          ║
// ║    • Engine composition and aggregation                                  ║
// ║    • Cross-engine communication                                          ║
// ║    • Responsibility dispatch                                             ║
// ║    • Energy and coherence flow                                           ║
// ║    • Phase synchronization                                               ║
// ║    • Collective computation                                              ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";
import Text "mo:base/Text";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MATHEMATICAL CONSTANTS                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let τ : Float = 6.2831853071795864769;
  public let π : Float = 3.1415926535897932385;
  public let e : Float = 2.7182818284590452354;
  public let S₀ : Float = 0.3819660112501051518;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     RESPONSIBILITY TYPES                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Universal responsibility categories
  public type ResponsibilityCategory = {
    #Computation;         // Data processing and calculation
    #Memory;              // Storage and retrieval
    #Communication;       // Signal transmission
    #Coordination;        // Synchronization and orchestration
    #Defense;             // Security and protection
    #Creation;            // Generation of new structures
    #Analysis;            // Pattern recognition and understanding
    #Prediction;          // Forecasting future states
    #Optimization;        // Resource allocation and efficiency
    #Learning;            // Adaptation and improvement
    #Integration;         // Combining disparate information
    #Regulation;          // Maintaining homeostasis
  };

  // Specific responsibility with metadata
  public type Responsibility = {
    id : Nat32;
    category : ResponsibilityCategory;
    name : Text;
    priority : Float;      // 0.0 to 1.0
    weight : Float;        // Contribution weight
    isActive : Bool;
    lastExecution : Nat;
    executionCount : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MULTI-RESPONSIBILITY ENGINE                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type MultiEngine = {
    id : Nat32;
    name : Text;
    
    // Multiple responsibilities (core principle)
    responsibilities : [Responsibility];
    primaryResponsibility : Nat;  // Index of main responsibility
    
    // Engine state
    state : EngineState;
    
    // Spherical web position
    sphericalPosition : SphericalPosition;
    
    // Connections to other engines (spherical web)
    connections : [EngineConnection];
    
    // Input/output buffers
    inputBuffer : [Float];
    outputBuffer : [Float];
    
    // Metadata
    createdAt : Nat;
    lastTick : Nat;
    tickCount : Nat;
  };

  public type EngineState = {
    energy : Float;
    coherence : Float;
    phase : Float;
    activation : Float;
    temperature : Float;
    entropy : Float;
  };

  public type SphericalPosition = {
    theta : Float;    // Polar angle (0 to π)
    phi : Float;      // Azimuthal angle (0 to 2π)
    radius : Float;   // Distance from center
    layer : Nat;      // Shell layer (0 = core, increasing = outer)
  };

  public type EngineConnection = {
    targetId : Nat32;
    strength : Float;         // Connection strength
    geodesicDistance : Float; // Distance along sphere surface
    phaseOffset : Float;      // Phase relationship
    bandwidth : Float;        // Data transfer capacity
    latency : Float;          // Signal delay
    bidirectional : Bool;     // Two-way connection
    connectionType : ConnectionType;
  };

  public type ConnectionType = {
    #DataFlow;          // Information transfer
    #PhaseCoupling;     // Kuramoto-style phase sync
    #EnergyTransfer;    // Energy flow
    #CoherenceLink;     // Coherence sharing
    #CommandControl;    // Hierarchical control
    #Feedback;          // Bidirectional feedback
    #Broadcast;         // One-to-many
    #Aggregate;         // Many-to-one
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SPHERICAL WEB FABRIC                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type SphericalWebFabric = {
    engines : [MultiEngine];
    engineCount : Nat;
    
    // Global state
    globalCoherence : Float;
    globalPhase : Float;
    totalEnergy : Float;
    
    // Topology
    radius : Float;
    numLayers : Nat;
    
    // Connection matrices
    adjacencyMatrix : [[Float]];      // Connection strengths
    phaseMatrix : [[Float]];          // Phase relationships
    distanceMatrix : [[Float]];       // Geodesic distances
    
    // Tick state
    currentTick : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ENGINE CREATION                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Create a new multi-responsibility engine
  public func createEngine(
    id : Nat32,
    name : Text,
    responsibilities : [ResponsibilityCategory],
    theta : Float,
    phi : Float,
    layer : Nat
  ) : MultiEngine {
    // Convert categories to full responsibility objects
    let resps = Array.tabulate<Responsibility>(responsibilities.size(), func(i : Nat) : Responsibility {
      {
        id = Nat32.fromNat(i);
        category = responsibilities[i];
        name = responsibilityName(responsibilities[i]);
        priority = if (i == 0) { 1.0 } else { 1.0 - 0.1 * Float.fromInt(i) };
        weight = 1.0 / Float.fromInt(responsibilities.size());
        isActive = true;
        lastExecution = 0;
        executionCount = 0;
      }
    });
    
    {
      id = id;
      name = name;
      responsibilities = resps;
      primaryResponsibility = 0;
      state = {
        energy = 1.0;
        coherence = 1.0;
        phase = phi;  // Initial phase from position
        activation = 0.5;
        temperature = 1.0;
        entropy = 0.0;
      };
      sphericalPosition = {
        theta = theta;
        phi = phi;
        radius = 1.0 + 0.1 * Float.fromInt(layer);
        layer = layer;
      };
      connections = [];
      inputBuffer = [];
      outputBuffer = [];
      createdAt = 0;
      lastTick = 0;
      tickCount = 0;
    }
  };

  // Get name for responsibility category
  func responsibilityName(cat : ResponsibilityCategory) : Text {
    switch (cat) {
      case (#Computation) { "Computation" };
      case (#Memory) { "Memory" };
      case (#Communication) { "Communication" };
      case (#Coordination) { "Coordination" };
      case (#Defense) { "Defense" };
      case (#Creation) { "Creation" };
      case (#Analysis) { "Analysis" };
      case (#Prediction) { "Prediction" };
      case (#Optimization) { "Optimization" };
      case (#Learning) { "Learning" };
      case (#Integration) { "Integration" };
      case (#Regulation) { "Regulation" };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SPHERICAL WEB CREATION                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Create a complete spherical web of engines
  public func createSphericalWeb(
    numEngines : Nat,
    numLayers : Nat
  ) : SphericalWebFabric {
    let engines = Buffer.Buffer<MultiEngine>(numEngines);
    
    // Distribute engines using Fibonacci spiral
    let goldenAngle = π * (3.0 - Float.sqrt(5.0));
    
    for (i in Iter.range(0, numEngines - 1)) {
      let theta = Float.arccos(1.0 - 2.0 * (Float.fromInt(i) + 0.5) / Float.fromInt(numEngines));
      let phi = goldenAngle * Float.fromInt(i);
      let layer = i % numLayers;
      
      // Assign responsibilities based on position
      let resps = assignResponsibilitiesByPosition(theta, phi, layer);
      
      let engine = createEngine(
        Nat32.fromNat(i),
        "E-" # Nat.toText(i),
        resps,
        theta,
        phi,
        layer
      );
      
      engines.add(engine);
    };
    
    // Build connection matrices
    let engArray = Buffer.toArray(engines);
    let adjacency = buildAdjacencyMatrix(engArray);
    let phases = buildPhaseMatrix(engArray);
    let distances = buildDistanceMatrix(engArray);
    
    // Add connections to each engine
    let connectedEngines = Buffer.Buffer<MultiEngine>(numEngines);
    for (i in Iter.range(0, numEngines - 1)) {
      let eng = engArray[i];
      let conns = buildEngineConnections(i, engArray, adjacency, distances);
      
      connectedEngines.add({
        id = eng.id;
        name = eng.name;
        responsibilities = eng.responsibilities;
        primaryResponsibility = eng.primaryResponsibility;
        state = eng.state;
        sphericalPosition = eng.sphericalPosition;
        connections = conns;
        inputBuffer = eng.inputBuffer;
        outputBuffer = eng.outputBuffer;
        createdAt = eng.createdAt;
        lastTick = eng.lastTick;
        tickCount = eng.tickCount;
      });
    };
    
    {
      engines = Buffer.toArray(connectedEngines);
      engineCount = numEngines;
      globalCoherence = 1.0;
      globalPhase = 0.0;
      totalEnergy = Float.fromInt(numEngines);
      radius = 1.0;
      numLayers = numLayers;
      adjacencyMatrix = adjacency;
      phaseMatrix = phases;
      distanceMatrix = distances;
      currentTick = 0;
    }
  };

  // Assign responsibilities based on spherical position
  func assignResponsibilitiesByPosition(theta : Float, phi : Float, layer : Nat) : [ResponsibilityCategory] {
    let resps = Buffer.Buffer<ResponsibilityCategory>(4);
    
    // North pole region: Computation, Prediction, Analysis
    if (theta < π / 6.0) {
      resps.add(#Computation);
      resps.add(#Prediction);
      resps.add(#Analysis);
    }
    // South pole region: Memory, Integration, Regulation
    else if (theta > 5.0 * π / 6.0) {
      resps.add(#Memory);
      resps.add(#Integration);
      resps.add(#Regulation);
    }
    // Equatorial band: Communication, Coordination
    else if (theta > π / 3.0 and theta < 2.0 * π / 3.0) {
      resps.add(#Communication);
      resps.add(#Coordination);
      resps.add(#Learning);
    }
    // Northern mid-latitudes: Creation, Optimization
    else if (theta < π / 2.0) {
      resps.add(#Creation);
      resps.add(#Optimization);
      resps.add(#Computation);
    }
    // Southern mid-latitudes: Defense, Regulation
    else {
      resps.add(#Defense);
      resps.add(#Regulation);
      resps.add(#Memory);
    };
    
    // Add layer-specific responsibilities
    if (layer == 0) {
      resps.add(#Integration);  // Core layer: integration
    } else if (layer == 1) {
      resps.add(#Coordination);  // Inner layer: coordination
    } else {
      resps.add(#Communication);  // Outer layers: communication
    };
    
    // Add phi-based responsibility (golden sections)
    let phiNorm = phi / τ;
    if (phiNorm < ψ) {
      resps.add(#Learning);
    } else if (phiNorm < φ - 1.0) {
      resps.add(#Prediction);
    } else {
      resps.add(#Optimization);
    };
    
    Buffer.toArray(resps)
  };

  // Build adjacency matrix (spherical web: all connected with distance-based weights)
  func buildAdjacencyMatrix(engines : [MultiEngine]) : [[Float]] {
    let n = engines.size();
    
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i == j) { return 0.0 };
        
        // Geodesic distance on sphere
        let dist = sphericalDistance(engines[i].sphericalPosition, engines[j].sphericalPosition);
        
        // Weight: inverse distance (stronger for closer engines)
        // But all engines are connected (spherical web)
        let maxDist = π;  // Maximum geodesic distance
        1.0 - (dist / maxDist)
      })
    })
  };

  // Build phase matrix
  func buildPhaseMatrix(engines : [MultiEngine]) : [[Float]] {
    let n = engines.size();
    
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i == j) { return 0.0 };
        
        // Phase difference
        engines[j].state.phase - engines[i].state.phase
      })
    })
  };

  // Build geodesic distance matrix
  func buildDistanceMatrix(engines : [MultiEngine]) : [[Float]] {
    let n = engines.size();
    
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i == j) { return 0.0 };
        sphericalDistance(engines[i].sphericalPosition, engines[j].sphericalPosition)
      })
    })
  };

  // Build connections for single engine
  func buildEngineConnections(
    engineIdx : Nat,
    engines : [MultiEngine],
    adjacency : [[Float]],
    distances : [[Float]]
  ) : [EngineConnection] {
    let n = engines.size();
    let conns = Buffer.Buffer<EngineConnection>(n - 1);
    
    for (j in Iter.range(0, n - 1)) {
      if (j != engineIdx) {
        let strength = adjacency[engineIdx][j];
        let dist = distances[engineIdx][j];
        
        // Only include connections above threshold (but threshold is low for spherical web)
        if (strength > 0.1) {
          conns.add({
            targetId = Nat32.fromNat(j);
            strength = strength;
            geodesicDistance = dist;
            phaseOffset = engines[j].state.phase - engines[engineIdx].state.phase;
            bandwidth = strength * φ;  // Golden-scaled bandwidth
            latency = dist / π;  // Distance-based latency
            bidirectional = true;
            connectionType = determineConnectionType(engines[engineIdx], engines[j]);
          });
        };
      };
    };
    
    Buffer.toArray(conns)
  };

  // Determine connection type based on engine responsibilities
  func determineConnectionType(source : MultiEngine, target : MultiEngine) : ConnectionType {
    // Check primary responsibilities
    let srcPrimary = source.responsibilities[source.primaryResponsibility].category;
    let tgtPrimary = target.responsibilities[target.primaryResponsibility].category;
    
    switch (srcPrimary, tgtPrimary) {
      case (#Computation, _) { #DataFlow };
      case (#Communication, _) { #Broadcast };
      case (#Coordination, _) { #PhaseCoupling };
      case (#Memory, _) { #DataFlow };
      case (_, #Coordination) { #CommandControl };
      case (_, #Integration) { #Aggregate };
      case (_, _) { #Feedback };
    }
  };

  // Spherical distance between two positions
  func sphericalDistance(a : SphericalPosition, b : SphericalPosition) : Float {
    // Haversine formula
    let dTheta = b.theta - a.theta;
    let dPhi = b.phi - a.phi;
    
    let sinDTheta2 = Float.sin(dTheta / 2.0);
    let sinDPhi2 = Float.sin(dPhi / 2.0);
    
    let h = sinDTheta2 * sinDTheta2 + 
            Float.sin(a.theta) * Float.sin(b.theta) * sinDPhi2 * sinDPhi2;
    
    let r = (a.radius + b.radius) / 2.0;
    2.0 * r * Float.arcsin(Float.sqrt(h))
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ENGINE EXECUTION                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Execute all responsibilities of an engine
  public func executeEngine(
    engine : MultiEngine,
    input : [Float],
    fabric : SphericalWebFabric
  ) : (MultiEngine, [Float]) {
    let outputs = Buffer.Buffer<Float>(engine.responsibilities.size());
    var updatedState = engine.state;
    var updatedResps = engine.responsibilities;
    
    // Execute each responsibility
    for (i in Iter.range(0, engine.responsibilities.size() - 1)) {
      let resp = engine.responsibilities[i];
      
      if (resp.isActive) {
        let (output, newState) = executeResponsibility(resp, input, updatedState, engine, fabric);
        outputs.add(output);
        updatedState := newState;
        
        // Update responsibility execution count
        updatedResps := Array.tabulate<Responsibility>(updatedResps.size(), func(j : Nat) : Responsibility {
          if (j == i) {
            {
              id = resp.id;
              category = resp.category;
              name = resp.name;
              priority = resp.priority;
              weight = resp.weight;
              isActive = resp.isActive;
              lastExecution = fabric.currentTick;
              executionCount = resp.executionCount + 1;
            }
          } else {
            updatedResps[j]
          }
        });
      };
    };
    
    let updatedEngine : MultiEngine = {
      id = engine.id;
      name = engine.name;
      responsibilities = updatedResps;
      primaryResponsibility = engine.primaryResponsibility;
      state = updatedState;
      sphericalPosition = engine.sphericalPosition;
      connections = engine.connections;
      inputBuffer = input;
      outputBuffer = Buffer.toArray(outputs);
      createdAt = engine.createdAt;
      lastTick = fabric.currentTick;
      tickCount = engine.tickCount + 1;
    };
    
    (updatedEngine, Buffer.toArray(outputs))
  };

  // Execute a single responsibility
  func executeResponsibility(
    resp : Responsibility,
    input : [Float],
    state : EngineState,
    engine : MultiEngine,
    fabric : SphericalWebFabric
  ) : (Float, EngineState) {
    switch (resp.category) {
      case (#Computation) {
        // Compute weighted sum with nonlinear activation
        var sum : Float = 0.0;
        for (x in input.vals()) { sum += x };
        let output = Float.tanh(sum * state.coherence);
        let newState = { 
          energy = state.energy * ψ + 0.1; 
          coherence = state.coherence;
          phase = state.phase;
          activation = output;
          temperature = state.temperature;
          entropy = state.entropy + 0.01;
        };
        (output, newState)
      };
      
      case (#Memory) {
        // Store input in activation (simplified memory)
        var sum : Float = 0.0;
        for (x in input.vals()) { sum += x };
        let blended = state.activation * φ + sum * ψ;  // Golden blend
        let newState = { 
          energy = state.energy; 
          coherence = state.coherence;
          phase = state.phase;
          activation = blended;
          temperature = state.temperature;
          entropy = state.entropy;
        };
        (blended, newState)
      };
      
      case (#Communication) {
        // Propagate signal (return average of connections)
        var connSum : Float = 0.0;
        for (conn in engine.connections.vals()) {
          connSum += conn.strength;
        };
        let avgConn = connSum / Float.fromInt(engine.connections.size());
        (avgConn * state.activation, state)
      };
      
      case (#Coordination) {
        // Phase coupling contribution
        let phaseContrib = Float.sin(state.phase) * state.coherence;
        let newPhase = state.phase + 0.01 * fabric.globalPhase;
        let newState = { 
          energy = state.energy; 
          coherence = state.coherence;
          phase = newPhase;
          activation = state.activation;
          temperature = state.temperature;
          entropy = state.entropy;
        };
        (phaseContrib, newState)
      };
      
      case (#Defense) {
        // Check for anomalies
        var maxInput : Float = 0.0;
        for (x in input.vals()) {
          if (Float.abs(x) > maxInput) { maxInput := Float.abs(x) };
        };
        let anomaly = if (maxInput > 2.0) { 1.0 } else { 0.0 };
        let defended = 1.0 - anomaly;
        (defended, state)
      };
      
      case (#Creation) {
        // Generate new pattern
        let created = Float.sin(state.phase) * Float.cos(engine.sphericalPosition.theta) * state.coherence;
        (created, state)
      };
      
      case (#Analysis) {
        // Pattern analysis (variance)
        if (input.size() == 0) { return (0.0, state) };
        
        var sum : Float = 0.0;
        var sum2 : Float = 0.0;
        for (x in input.vals()) {
          sum += x;
          sum2 += x * x;
        };
        let n = Float.fromInt(input.size());
        let variance = sum2 / n - (sum / n) * (sum / n);
        (Float.sqrt(variance), state)
      };
      
      case (#Prediction) {
        // Simple prediction based on trend
        if (input.size() < 2) { return (0.0, state) };
        
        let last = input[input.size() - 1];
        let prev = input[input.size() - 2];
        let prediction = last + (last - prev) * ψ;  // Golden-damped extrapolation
        (prediction, state)
      };
      
      case (#Optimization) {
        // Minimize energy while maximizing coherence
        let newEnergy = state.energy * 0.99;  // Slow decay
        let newCoherence = Float.min(1.0, state.coherence + 0.001);
        let newState = { 
          energy = newEnergy; 
          coherence = newCoherence;
          phase = state.phase;
          activation = state.activation;
          temperature = state.temperature * 0.999;
          entropy = state.entropy;
        };
        (newCoherence / (newEnergy + 0.1), newState)
      };
      
      case (#Learning) {
        // Hebbian-style learning rate
        var inputSum : Float = 0.0;
        for (x in input.vals()) { inputSum += x };
        let learningSignal = inputSum * state.activation;
        let newState = { 
          energy = state.energy; 
          coherence = state.coherence;
          phase = state.phase;
          activation = state.activation + 0.01 * learningSignal;
          temperature = state.temperature;
          entropy = state.entropy;
        };
        (learningSignal, newState)
      };
      
      case (#Integration) {
        // Integrate all inputs with coherence weighting
        var weightedSum : Float = 0.0;
        for (x in input.vals()) {
          weightedSum += x * state.coherence;
        };
        (weightedSum / Float.fromInt(Nat.max(1, input.size())), state)
      };
      
      case (#Regulation) {
        // Homeostatic regulation
        let target = 0.5;  // Target activation
        let error = target - state.activation;
        let correction = error * 0.1;
        let newState = { 
          energy = state.energy; 
          coherence = state.coherence;
          phase = state.phase;
          activation = state.activation + correction;
          temperature = state.temperature;
          entropy = state.entropy;
        };
        (correction, newState)
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FABRIC TICK                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Execute one complete tick of the spherical web
  public func fabricTick(
    fabric : SphericalWebFabric,
    globalInputs : [Float]
  ) : SphericalWebFabric {
    let n = fabric.engineCount;
    let updatedEngines = Buffer.Buffer<MultiEngine>(n);
    
    // Phase 1: Execute all engines (spherical web: all fire together)
    for (i in Iter.range(0, n - 1)) {
      let engine = fabric.engines[i];
      
      // Gather inputs from connected engines
      let inputs = gatherInputs(engine, fabric, globalInputs);
      
      // Execute engine
      let (updatedEngine, _outputs) = executeEngine(engine, inputs, fabric);
      updatedEngines.add(updatedEngine);
    };
    
    let newEngines = Buffer.toArray(updatedEngines);
    
    // Phase 2: Kuramoto phase coupling
    let coupledEngines = kuramotoCoupling(newEngines, fabric.adjacencyMatrix, 0.01);
    
    // Phase 3: Energy diffusion
    let diffusedEngines = energyDiffusion(coupledEngines, fabric.adjacencyMatrix, 0.01);
    
    // Phase 4: Compute global state
    let (globalCoh, globalPh) = computeGlobalState(diffusedEngines);
    var totalE : Float = 0.0;
    for (eng in diffusedEngines.vals()) {
      totalE += eng.state.energy;
    };
    
    {
      engines = diffusedEngines;
      engineCount = n;
      globalCoherence = globalCoh;
      globalPhase = globalPh;
      totalEnergy = totalE;
      radius = fabric.radius;
      numLayers = fabric.numLayers;
      adjacencyMatrix = fabric.adjacencyMatrix;
      phaseMatrix = buildPhaseMatrix(diffusedEngines);
      distanceMatrix = fabric.distanceMatrix;
      currentTick = fabric.currentTick + 1;
    }
  };

  // Gather inputs from connected engines
  func gatherInputs(
    engine : MultiEngine,
    fabric : SphericalWebFabric,
    globalInputs : [Float]
  ) : [Float] {
    let inputs = Buffer.Buffer<Float>(engine.connections.size() + globalInputs.size());
    
    // Add global inputs
    for (x in globalInputs.vals()) {
      inputs.add(x);
    };
    
    // Add inputs from connected engines
    for (conn in engine.connections.vals()) {
      let targetIdx = Nat32.toNat(conn.targetId);
      if (targetIdx < fabric.engines.size()) {
        let targetEngine = fabric.engines[targetIdx];
        // Use target's activation weighted by connection strength
        inputs.add(targetEngine.state.activation * conn.strength);
      };
    };
    
    Buffer.toArray(inputs)
  };

  // Kuramoto phase coupling
  func kuramotoCoupling(
    engines : [MultiEngine],
    adjacency : [[Float]],
    dt : Float
  ) : [MultiEngine] {
    let n = engines.size();
    let K : Float = φ;  // Coupling constant
    
    // Compute order parameter
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (eng in engines.vals()) {
      sumCos += Float.cos(eng.state.phase);
      sumSin += Float.sin(eng.state.phase);
    };
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n);
    let psi = Float.arctan2(sumSin, sumCos);
    
    // Update phases
    Array.tabulate<MultiEngine>(n, func(i : Nat) : MultiEngine {
      let eng = engines[i];
      
      // Natural frequency based on position
      let omega = ψ * Float.sin(eng.sphericalPosition.theta);
      
      // Mean-field coupling
      let coupling = K * r * Float.sin(psi - eng.state.phase);
      
      // Local coupling from neighbors
      var localCoupling : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        if (j != i) {
          localCoupling += adjacency[i][j] * Float.sin(engines[j].state.phase - eng.state.phase);
        };
      };
      localCoupling /= Float.fromInt(n - 1);
      
      let dPhase = omega + coupling + K * ψ * localCoupling;
      let newPhase = eng.state.phase + dPhase * dt;
      
      {
        id = eng.id;
        name = eng.name;
        responsibilities = eng.responsibilities;
        primaryResponsibility = eng.primaryResponsibility;
        state = {
          energy = eng.state.energy;
          coherence = r;  // Update local coherence to match global
          phase = newPhase;
          activation = eng.state.activation;
          temperature = eng.state.temperature;
          entropy = eng.state.entropy;
        };
        sphericalPosition = eng.sphericalPosition;
        connections = eng.connections;
        inputBuffer = eng.inputBuffer;
        outputBuffer = eng.outputBuffer;
        createdAt = eng.createdAt;
        lastTick = eng.lastTick;
        tickCount = eng.tickCount;
      }
    })
  };

  // Energy diffusion across fabric
  func energyDiffusion(
    engines : [MultiEngine],
    adjacency : [[Float]],
    dt : Float
  ) : [MultiEngine] {
    let n = engines.size();
    let D : Float = ψ;  // Diffusion coefficient
    
    Array.tabulate<MultiEngine>(n, func(i : Nat) : MultiEngine {
      let eng = engines[i];
      
      // Compute Laplacian term
      var laplacian : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        if (j != i) {
          laplacian += adjacency[i][j] * (engines[j].state.energy - eng.state.energy);
        };
      };
      
      let newEnergy = Float.max(0.1, eng.state.energy + D * laplacian * dt);
      
      {
        id = eng.id;
        name = eng.name;
        responsibilities = eng.responsibilities;
        primaryResponsibility = eng.primaryResponsibility;
        state = {
          energy = newEnergy;
          coherence = eng.state.coherence;
          phase = eng.state.phase;
          activation = eng.state.activation;
          temperature = eng.state.temperature;
          entropy = eng.state.entropy;
        };
        sphericalPosition = eng.sphericalPosition;
        connections = eng.connections;
        inputBuffer = eng.inputBuffer;
        outputBuffer = eng.outputBuffer;
        createdAt = eng.createdAt;
        lastTick = eng.lastTick;
        tickCount = eng.tickCount;
      }
    })
  };

  // Compute global state from engines
  func computeGlobalState(engines : [MultiEngine]) : (Float, Float) {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (eng in engines.vals()) {
      sumCos += Float.cos(eng.state.phase);
      sumSin += Float.sin(eng.state.phase);
    };
    
    let n = Float.fromInt(engines.size());
    let coherence = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / n;
    let phase = Float.arctan2(sumSin, sumCos);
    
    (coherence, phase)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COLLECTIVE OPERATIONS                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Get all engines with a specific responsibility
  public func enginesWithResponsibility(
    fabric : SphericalWebFabric,
    category : ResponsibilityCategory
  ) : [MultiEngine] {
    let result = Buffer.Buffer<MultiEngine>(fabric.engineCount);
    
    for (eng in fabric.engines.vals()) {
      for (resp in eng.responsibilities.vals()) {
        if (resp.category == category) {
          result.add(eng);
          break;  // Only add once per engine
        };
      };
    };
    
    Buffer.toArray(result)
  };

  // Broadcast signal to all engines
  public func broadcast(fabric : SphericalWebFabric, signal : Float) : SphericalWebFabric {
    let inputs = [signal];
    fabricTick(fabric, inputs)
  };

  // Query collective output
  public func collectiveOutput(fabric : SphericalWebFabric) : Float {
    var sum : Float = 0.0;
    for (eng in fabric.engines.vals()) {
      sum += eng.state.activation * eng.state.coherence;
    };
    sum / Float.fromInt(fabric.engineCount)
  };

  // Get fabric statistics
  public type FabricStats = {
    meanCoherence : Float;
    meanEnergy : Float;
    meanActivation : Float;
    phaseDispersion : Float;
    totalResponsibilities : Nat;
    activeEngines : Nat;
  };

  public func fabricStats(fabric : SphericalWebFabric) : FabricStats {
    var sumCoh : Float = 0.0;
    var sumE : Float = 0.0;
    var sumAct : Float = 0.0;
    var sumPhase : Float = 0.0;
    var sumPhase2 : Float = 0.0;
    var totalResps : Nat = 0;
    var activeCount : Nat = 0;
    
    for (eng in fabric.engines.vals()) {
      sumCoh += eng.state.coherence;
      sumE += eng.state.energy;
      sumAct += eng.state.activation;
      sumPhase += eng.state.phase;
      sumPhase2 += eng.state.phase * eng.state.phase;
      totalResps += eng.responsibilities.size();
      if (eng.state.activation > 0.1) { activeCount += 1 };
    };
    
    let n = Float.fromInt(fabric.engineCount);
    let meanPhase = sumPhase / n;
    let phaseVar = sumPhase2 / n - meanPhase * meanPhase;
    
    {
      meanCoherence = sumCoh / n;
      meanEnergy = sumE / n;
      meanActivation = sumAct / n;
      phaseDispersion = Float.sqrt(Float.abs(phaseVar));
      totalResponsibilities = totalResps;
      activeEngines = activeCount;
    }
  };

}
