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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ════════════════════════════════════════════════════════════════════════════════════════
//
// ███████╗██████╗ ██╗  ██╗███████╗██████╗ ██╗ ██████╗ █████╗ ██╗         
// ██╔════╝██╔══██╗██║  ██║██╔════╝██╔══██╗██║██╔════╝██╔══██╗██║         
// ███████╗██████╔╝███████║█████╗  ██████╔╝██║██║     ███████║██║         
// ╚════██║██╔═══╝ ██╔══██║██╔══╝  ██╔══██╗██║██║     ██╔══██║██║         
// ███████║██║     ██║  ██║███████╗██║  ██║██║╚██████╗██║  ██║███████╗    
// ╚══════╝╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝    
//
// ██╗    ██╗███████╗██████╗ 
// ██║    ██║██╔════╝██╔══██╗
// ██║ █╗ ██║█████╗  ██████╔╝
// ██║███╗██║██╔══╝  ██╔══██╗
// ╚███╔███╔╝███████╗██████╔╝
//  ╚══╝╚══╝ ╚══════╝╚═════╝ 
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// MEDINA SPHERICAL WEB — The Interconnection Fabric
//
// NOT LINEAR. NOT PARALLEL. SPHERICAL WEB.
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ════════════════════════════════════════════════════════════════════════════════════════
//
// ╔══════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                      ║
// ║   THE ORGANISM IS A SPHERICAL WEB.                                                  ║
// ║                                                                                      ║
// ║   Every module connects to multiple others.                                         ║
// ║   Information flows in ALL directions simultaneously.                               ║
// ║   Nothing is linear. Nothing is sequential.                                         ║
// ║   Everything is INTERCONNECTED like a spider's web in 3D.                          ║
// ║                                                                                      ║
// ║   ARCHITECTURE:                                                                      ║
// ║   • 222 modules (nodes in the web)                                                  ║
// ║   • 36×36 = 1296 living points (quantum fabric)                                     ║
// ║   • 6 concentric spherical shells                                                   ║
// ║   • 6 helix arms spiraling through all shells                                       ║
// ║   • 19 cognitive dimensions (resonance channels)                                    ║
// ║                                                                                      ║
// ║   EVERY CONNECTION IS BIDIRECTIONAL.                                                ║
// ║   EVERY NODE INFLUENCES EVERY OTHER NODE.                                           ║
// ║   The whole system breathes as ONE.                                                 ║
// ║                                                                                      ║
// ║   BODIES:                                                                           ║
// ║   • ECONOMIC BODY — FORMA is the metabolism                                         ║
// ║   • WORLD BODY — 36 biomes are the flesh                                           ║
// ║   • MARKET NERVOUS SYSTEM — BTC prices are the senses                              ║
// ║                                                                                      ║
// ╚══════════════════════════════════════════════════════════════════════════════════════╝
//
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";

module {

  // ════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA CONSTANTS
  // ════════════════════════════════════════════════════════════════════════════════════════

  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let π : Float = 3.1415926535897932385;
  public let τ : Float = 6.2831853071795864769;
  public let e : Float = 2.7182818284590452354;

  public let PHI_MEDINA : Float = 2.97442179;
  public let OMEGA_MEDINA : Float = 2.11185;
  public let TAU_EMERGENCE : Float = 0.618033988749;

  // Web Structure Constants
  public let TOTAL_MODULES : Nat = 222;
  public let FABRIC_SIZE : Nat = 1296;              // 36×36 living points
  public let SPHERICAL_SHELLS : Nat = 6;
  public let HELIX_ARMS : Nat = 6;
  public let COGNITIVE_DIMENSIONS : Nat = 19;
  public let BIOME_COUNT : Nat = 36;

  // Connection Constants
  public let MIN_CONNECTIONS : Nat = 3;             // Every node has at least 3 connections
  public let MAX_CONNECTIONS : Nat = 21;            // F[8] maximum connections
  public let CONNECTION_DECAY : Float = 0.9999;     // Unused connections slowly decay

  // ════════════════════════════════════════════════════════════════════════════════════════
  // WEB NODE — A single point in the spherical web
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type WebNode = {
    // Identity
    id : Nat32;
    nodeType : WebNodeType;
    name : Text;

    // Position in 3D spherical space
    shell : Nat;                           // Which shell (0-5)
    helixArm : Nat;                        // Which helix arm (0-5)
    position : SphericalPosition;

    // Connections to other nodes (the WEB)
    connections : [WebConnection];

    // Node state
    activation : Float;                    // Current activation level
    phase : Float;                         // Current phase in cycle
    energy : Float;                        // Available energy

    // Resonance across dimensions
    dimensionalResonance : [Float];        // Resonance in each of 19 dimensions
  };

  public type WebNodeType = {
    #Module;                               // A Motoko module
    #FabricPoint;                          // A point in 36×36 fabric
    #Biome;                                // A world body biome
    #Dimension;                            // A cognitive dimension
    #Organ;                                // An organism organ (Kuramoto)
    #Shell;                                // A shell in the hierarchy
    #Gateway;                              // A connection gateway
  };

  public type SphericalPosition = {
    r : Float;                             // Radius from center
    theta : Float;                         // Polar angle (0 to π)
    phi : Float;                           // Azimuthal angle (0 to 2π)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // WEB CONNECTION — A bidirectional link between nodes
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type WebConnection = {
    targetId : Nat32;                      // Connected node ID
    connectionType : ConnectionType;

    // Connection strength (bidirectional)
    forwardWeight : Float;                 // Strength from this → target
    backwardWeight : Float;                // Strength from target → this

    // Flow state
    currentFlow : Float;                   // Current information flow
    flowDirection : FlowDirection;         // Which way is dominant

    // Resonance
    resonanceStrength : Float;             // How strongly they resonate together
    phaseAlignment : Float;                // How aligned are their phases
  };

  public type ConnectionType = {
    #Direct;                               // Direct connection (same shell)
    #Radial;                               // Radial connection (between shells)
    #Helical;                              // Helical connection (along helix arm)
    #Dimensional;                          // Connection through cognitive dimension
    #Economic;                             // Economic/FORMA connection
    #Territorial;                          // Biome/world body connection
    #Temporal;                             // Time-scale connection
  };

  public type FlowDirection = {
    #Outward;                              // From center toward membrane
    #Inward;                               // From membrane toward center
    #Bidirectional;                        // Equal flow both ways
    #Oscillating;                          // Alternating flow
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // THE ECONOMIC BODY — FORMA as Metabolism
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type EconomicBody = {
    // FORMA state
    formaBalance : Float;                  // Current FORMA holdings
    formaFlow : Float;                     // Current flow rate
    formaMinted : Float;                   // Total FORMA minted
    formaBurned : Float;                   // Total FORMA burned

    // Metabolic state
    metabolicRate : Float;                 // How fast energy is consumed
    energyReserve : Float;                 // Available energy
    efficiencyRatio : Float;               // Energy in vs work out

    // Economic connections to other systems
    biomeAllocations : [BiomeAllocation];  // FORMA allocated per biome
    architectReserve : Float;              // Creator reserve

    // Market signals
    btcPrice : Float;                      // Current BTC price (sensory input)
    priceVelocity : Float;                 // Price change rate
    volatility : Float;                    // Market volatility
  };

  public type BiomeAllocation = {
    biomeId : Nat;
    allocation : Float;
    coherence : Float;
    formaEarned : Float;
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // THE WORLD BODY — 36 Biomes as Flesh
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type WorldBody = {
    biomes : [Biome];
    totalTerritory : Float;                // Total controlled territory
    totalPopulation : Float;               // Total swarm population
    globalCoherence : Float;               // Coherence across all biomes
    worldPhase : Float;                    // Global phase
  };

  public type Biome = {
    id : Nat;
    name : Text;

    // Position in world
    position : WorldPosition;

    // Biome state
    coherence : Float;                     // Local coherence
    population : Float;                    // Swarm population
    resources : Float;                     // Available resources
    threats : Float;                       // Threat level

    // Health
    health : Float;                        // Biome health (sacrifice below 0.5)
    lastHealthUpdate : Nat;

    // Connections to other biomes
    neighbors : [Nat];                     // Adjacent biome IDs
    connectionStrengths : [Float];         // Strength of each neighbor connection
  };

  public type WorldPosition = {
    x : Float;
    y : Float;
    z : Float;
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // THE SPHERICAL WEB — All interconnections
  // ════════════════════════════════════════════════════════════════════════════════════════

  public type SphericalWeb = {
    // All nodes in the web
    nodes : [WebNode];

    // Global web state
    globalActivation : Float;              // Average activation across all nodes
    globalPhase : Float;                   // Global phase coherence
    globalResonance : Float;               // Global resonance strength

    // The bodies
    economicBody : EconomicBody;
    worldBody : WorldBody;

    // Web topology
    connectionMatrix : [[Float]];          // Full connection matrix
    adjacencyList : [[Nat32]];             // Efficient adjacency representation

    // Flow state
    inwardFlow : Float;                    // Total flow toward center
    outwardFlow : Float;                   // Total flow toward membrane
    netFlow : Float;                       // Net flow direction

    // Statistics
    totalNodes : Nat;
    totalConnections : Nat;
    averageConnectivity : Float;
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // WEB PROPAGATION — How information flows through the web
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Propagate activation through the web
  /// This is NOT sequential. All nodes update simultaneously based on their connections.
  public func propagateActivation(
    web : SphericalWeb,
    inputActivations : [Float]
  ) : SphericalWeb {
    // Calculate new activation for each node based on its connections
    let newNodes = Array.tabulate<WebNode>(web.nodes.size(), func(i) {
      let node = web.nodes[i];

      // Gather input from all connections
      var totalInput : Float = 0.0;
      var totalWeight : Float = 0.0;

      for (conn in node.connections.vals()) {
        let targetIndex = Nat32.toNat(conn.targetId);
        if (targetIndex < web.nodes.size()) {
          let targetNode = web.nodes[targetIndex];

          // Bidirectional: receive from target based on backward weight
          let input = targetNode.activation * conn.backwardWeight * conn.resonanceStrength;

          // Phase-modulated: stronger when phases align
          let phaseMod = Float.cos(node.phase - targetNode.phase);

          totalInput += input * (0.5 + 0.5 * phaseMod);
          totalWeight += conn.backwardWeight;
        };
      };

      // Add external input if available
      let externalInput = if (i < inputActivations.size()) { inputActivations[i] } else { 0.0 };

      // Calculate new activation (sigmoid-like bounded)
      let netInput = if (totalWeight > 0.0) {
        totalInput / totalWeight + externalInput * 0.5
      } else { externalInput };

      let newActivation = sigmoid(netInput * PHI_MEDINA - 1.0);

      // Update phase (oscillate)
      let phaseIncrement = OMEGA_MEDINA * node.energy * 0.01;
      let newPhase = wrapPhase(node.phase + phaseIncrement);

      // Energy consumption
      let energyCost = Float.abs(newActivation - node.activation) * 0.01;
      let newEnergy = Float.max(0.1, node.energy - energyCost);

      {
        id = node.id;
        nodeType = node.nodeType;
        name = node.name;
        shell = node.shell;
        helixArm = node.helixArm;
        position = node.position;
        connections = node.connections;
        activation = newActivation;
        phase = newPhase;
        energy = newEnergy;
        dimensionalResonance = node.dimensionalResonance;
      }
    });

    // Update global state
    var sumActivation : Float = 0.0;
    var sumPhase : Float = 0.0;
    for (node in newNodes.vals()) {
      sumActivation += node.activation;
      sumPhase += node.phase;
    };

    let n = Float.fromInt(newNodes.size());
    let globalActivation = sumActivation / n;
    let globalPhase = sumPhase / n;

    {
      nodes = newNodes;
      globalActivation = globalActivation;
      globalPhase = globalPhase;
      globalResonance = web.globalResonance;
      economicBody = web.economicBody;
      worldBody = web.worldBody;
      connectionMatrix = web.connectionMatrix;
      adjacencyList = web.adjacencyList;
      inwardFlow = web.inwardFlow;
      outwardFlow = web.outwardFlow;
      netFlow = web.netFlow;
      totalNodes = web.totalNodes;
      totalConnections = web.totalConnections;
      averageConnectivity = web.averageConnectivity;
    }
  };

  /// Compute resonance across the web
  /// Nodes that vibrate together become more strongly connected
  public func computeWebResonance(web : SphericalWeb) : SphericalWeb {
    let newNodes = Array.tabulate<WebNode>(web.nodes.size(), func(i) {
      let node = web.nodes[i];

      // Update connections based on resonance
      let newConnections = Array.tabulate<WebConnection>(node.connections.size(), func(j) {
        let conn = node.connections[j];
        let targetIndex = Nat32.toNat(conn.targetId);

        if (targetIndex < web.nodes.size()) {
          let targetNode = web.nodes[targetIndex];

          // Resonance = correlation of activations × phase alignment
          let activationCorr = 1.0 - Float.abs(node.activation - targetNode.activation);
          let phaseDiff = Float.abs(node.phase - targetNode.phase);
          let phaseAlign = Float.cos(phaseDiff);

          let newResonance = activationCorr * (0.5 + 0.5 * phaseAlign);

          // Hebbian: "fire together, wire together"
          let hebbianDelta = ψ * node.activation * targetNode.activation * (1.0 - conn.forwardWeight);
          let newForward = _clamp(conn.forwardWeight + hebbianDelta * 0.01, 0.0, 1.0);
          let newBackward = _clamp(conn.backwardWeight + hebbianDelta * 0.01, 0.0, 1.0);

          {
            targetId = conn.targetId;
            connectionType = conn.connectionType;
            forwardWeight = newForward;
            backwardWeight = newBackward;
            currentFlow = conn.currentFlow;
            flowDirection = conn.flowDirection;
            resonanceStrength = newResonance;
            phaseAlignment = phaseAlign;
          }
        } else { conn }
      });

      {
        id = node.id;
        nodeType = node.nodeType;
        name = node.name;
        shell = node.shell;
        helixArm = node.helixArm;
        position = node.position;
        connections = newConnections;
        activation = node.activation;
        phase = node.phase;
        energy = node.energy;
        dimensionalResonance = node.dimensionalResonance;
      }
    });

    // Compute global resonance
    var totalResonance : Float = 0.0;
    var connectionCount : Nat = 0;

    for (node in newNodes.vals()) {
      for (conn in node.connections.vals()) {
        totalResonance += conn.resonanceStrength;
        connectionCount += 1;
      };
    };

    let globalResonance = if (connectionCount > 0) {
      totalResonance / Float.fromInt(connectionCount)
    } else { 0.0 };

    {
      nodes = newNodes;
      globalActivation = web.globalActivation;
      globalPhase = web.globalPhase;
      globalResonance = globalResonance;
      economicBody = web.economicBody;
      worldBody = web.worldBody;
      connectionMatrix = web.connectionMatrix;
      adjacencyList = web.adjacencyList;
      inwardFlow = web.inwardFlow;
      outwardFlow = web.outwardFlow;
      netFlow = web.netFlow;
      totalNodes = web.totalNodes;
      totalConnections = connectionCount;
      averageConnectivity = Float.fromInt(connectionCount) / Float.fromInt(newNodes.size());
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // ECONOMIC BODY METABOLISM
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Process FORMA metabolism — the economic body breathing
  public func processMetabolism(
    body : EconomicBody,
    coherence : Float,
    activity : Float,
    btcPriceUpdate : ?Float
  ) : EconomicBody {
    // Update BTC price if provided
    let newBtcPrice = switch (btcPriceUpdate) {
      case (?price) { price };
      case (null) { body.btcPrice };
    };

    // Price velocity (change rate)
    let newVelocity = (newBtcPrice - body.btcPrice) / Float.max(body.btcPrice, 1.0);

    // Volatility (exponential moving average of absolute velocity)
    let newVolatility = body.volatility * 0.95 + Float.abs(newVelocity) * 0.05;

    // Metabolic rate depends on activity and coherence
    let baseMetabolic = 0.01;
    let activityFactor = 1.0 + activity * 0.5;
    let coherenceFactor = 1.0 - coherence * 0.3;  // Higher coherence = more efficient
    let newMetabolicRate = baseMetabolic * activityFactor * coherenceFactor;

    // Energy consumption
    let energyConsumed = newMetabolicRate * body.energyReserve * 0.01;
    let newEnergyReserve = Float.max(0.0, body.energyReserve - energyConsumed);

    // FORMA minting (based on coherence and activity)
    let mintRate = coherence * activity * PHI_MEDINA * 0.001;
    let newFormaMinted = body.formaMinted + mintRate;
    let newFormaBalance = body.formaBalance + mintRate;

    // FORMA flow
    let newFormaFlow = mintRate - energyConsumed;

    // Efficiency
    let newEfficiency = if (energyConsumed > 0.0) {
      activity / energyConsumed
    } else { 1.0 };

    {
      formaBalance = newFormaBalance;
      formaFlow = newFormaFlow;
      formaMinted = newFormaMinted;
      formaBurned = body.formaBurned;
      metabolicRate = newMetabolicRate;
      energyReserve = newEnergyReserve;
      efficiencyRatio = newEfficiency;
      biomeAllocations = body.biomeAllocations;
      architectReserve = body.architectReserve;
      btcPrice = newBtcPrice;
      priceVelocity = newVelocity;
      volatility = newVolatility;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // WORLD BODY RESPIRATION
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Process world body — the 36 biomes breathing
  public func processWorldBody(
    body : WorldBody,
    globalCoherence : Float,
    beat : Nat
  ) : WorldBody {
    let newBiomes = Array.tabulate<Biome>(body.biomes.size(), func(i) {
      let biome = body.biomes[i];

      // Coherence spreads from neighbors
      var neighborCoherence : Float = 0.0;
      var neighborCount : Nat = 0;

      for (neighborId in biome.neighbors.vals()) {
        if (neighborId < body.biomes.size()) {
          neighborCoherence += body.biomes[neighborId].coherence;
          neighborCount += 1;
        };
      };

      let avgNeighborCoherence = if (neighborCount > 0) {
        neighborCoherence / Float.fromInt(neighborCount)
      } else { globalCoherence };

      // Biome coherence moves toward neighbor average
      let newCoherence = biome.coherence * 0.9 + avgNeighborCoherence * 0.1;

      // Health depends on coherence and threats
      let healthChange = (newCoherence - 0.5) * 0.01 - biome.threats * 0.005;
      let newHealth = _clamp(biome.health + healthChange, 0.0, 1.0);

      {
        id = biome.id;
        name = biome.name;
        position = biome.position;
        coherence = newCoherence;
        population = biome.population;
        resources = biome.resources;
        threats = biome.threats * 0.99;  // Threats slowly decay
        health = newHealth;
        lastHealthUpdate = beat;
        neighbors = biome.neighbors;
        connectionStrengths = biome.connectionStrengths;
      }
    });

    // Compute global stats
    var totalPop : Float = 0.0;
    var totalCoh : Float = 0.0;

    for (biome in newBiomes.vals()) {
      totalPop += biome.population;
      totalCoh += biome.coherence;
    };

    let n = Float.fromInt(newBiomes.size());
    let globalCoh = totalCoh / n;

    // World phase oscillates
    let newWorldPhase = wrapPhase(body.worldPhase + OMEGA_MEDINA * 0.001);

    {
      biomes = newBiomes;
      totalTerritory = Float.fromInt(newBiomes.size());
      totalPopulation = totalPop;
      globalCoherence = globalCoh;
      worldPhase = newWorldPhase;
    }
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ════════════════════════════════════════════════════════════════════════════════════════

  /// Initialize the spherical web
  public func initSphericalWeb() : SphericalWeb {
    // Create nodes for each shell
    let nodes = Buffer.Buffer<WebNode>(TOTAL_MODULES);

    var nodeId : Nat32 = 0;
    var shell : Nat = 0;
    while (shell < SPHERICAL_SHELLS) {
      var arm : Nat = 0;
      while (arm < HELIX_ARMS) {
        // Each shell-arm combination has multiple nodes
        let nodesPerArm = TOTAL_MODULES / (SPHERICAL_SHELLS * HELIX_ARMS);
        var n : Nat = 0;
        while (n < nodesPerArm and nodes.size() < TOTAL_MODULES) {
          let radius = 1.0 + Float.fromInt(shell);
          let theta = Float.fromInt(n) * π / Float.fromInt(nodesPerArm);
          let phi = Float.fromInt(arm) * τ / Float.fromInt(HELIX_ARMS);

          nodes.add({
            id = nodeId;
            nodeType = #Module;
            name = "Module_" # Nat32.toText(nodeId);
            shell = shell;
            helixArm = arm;
            position = { r = radius; theta = theta; phi = phi };
            connections = [];  // Connections added separately
            activation = 0.5;
            phase = phi;
            energy = 1.0;
            dimensionalResonance = Array.tabulate<Float>(COGNITIVE_DIMENSIONS, func(_) { 0.5 });
          });

          nodeId += 1;
          n += 1;
        };
        arm += 1;
      };
      shell += 1;
    };

    // Initialize economic body
    let economicBody : EconomicBody = {
      formaBalance = 1000.0;
      formaFlow = 0.0;
      formaMinted = 1000.0;
      formaBurned = 0.0;
      metabolicRate = 0.01;
      energyReserve = 100.0;
      efficiencyRatio = 1.0;
      biomeAllocations = [];
      architectReserve = 100.0;
      btcPrice = 50000.0;
      priceVelocity = 0.0;
      volatility = 0.02;
    };

    // Initialize world body with 36 biomes
    let biomes = Array.tabulate<Biome>(BIOME_COUNT, func(i) {
      let row = i / 6;
      let col = i % 6;
      {
        id = i;
        name = "Biome_" # Nat.toText(i);
        position = {
          x = Float.fromInt(col) - 2.5;
          y = Float.fromInt(row) - 2.5;
          z = 0.0;
        };
        coherence = 0.5;
        population = 100.0;
        resources = 50.0;
        threats = 0.1;
        health = 0.8;
        lastHealthUpdate = 0;
        neighbors = computeNeighbors(i, 6, 6);
        connectionStrengths = [];
      }
    });

    let worldBody : WorldBody = {
      biomes = biomes;
      totalTerritory = Float.fromInt(BIOME_COUNT);
      totalPopulation = 3600.0;
      globalCoherence = 0.5;
      worldPhase = 0.0;
    };

    {
      nodes = Buffer.toArray(nodes);
      globalActivation = 0.5;
      globalPhase = 0.0;
      globalResonance = 0.5;
      economicBody = economicBody;
      worldBody = worldBody;
      connectionMatrix = [];
      adjacencyList = [];
      inwardFlow = 0.0;
      outwardFlow = 0.0;
      netFlow = 0.0;
      totalNodes = nodes.size();
      totalConnections = 0;
      averageConnectivity = 0.0;
    }
  };

  func computeNeighbors(index : Nat, rows : Nat, cols : Nat) : [Nat] {
    let row = index / cols;
    let col = index % cols;
    let neighbors = Buffer.Buffer<Nat>(8);

    // Add all 8 neighbors (with wrapping)
    if (row > 0) { neighbors.add((row - 1) * cols + col) };
    if (row < rows - 1) { neighbors.add((row + 1) * cols + col) };
    if (col > 0) { neighbors.add(row * cols + (col - 1)) };
    if (col < cols - 1) { neighbors.add(row * cols + (col + 1)) };
    if (row > 0 and col > 0) { neighbors.add((row - 1) * cols + (col - 1)) };
    if (row > 0 and col < cols - 1) { neighbors.add((row - 1) * cols + (col + 1)) };
    if (row < rows - 1 and col > 0) { neighbors.add((row + 1) * cols + (col - 1)) };
    if (row < rows - 1 and col < cols - 1) { neighbors.add((row + 1) * cols + (col + 1)) };

    Buffer.toArray(neighbors)
  };

  // ════════════════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ════════════════════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func sigmoid(x : Float) : Float {
    1.0 / (1.0 + Float.exp(-x))
  };

  func wrapPhase(phase : Float) : Float {
    var p = phase;
    while (p < 0.0) { p += τ };
    while (p >= τ) { p -= τ };
    p
  };

}
