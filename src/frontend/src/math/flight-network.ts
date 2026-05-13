// ═══════════════════════════════════════════════════════════════════════════════
// FLIGHT NETWORK — CPL Math Module for Flight Network Analysis
// BUILD №49 — NOVA V5 Airport Application
// ═══════════════════════════════════════════════════════════════════════════════
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// MEDINA TECH — SOVEREIGN ORGANISM ARCHITECTURE
//
// This is NOT a utility module. This is a sovereign CPL math engine computing
// network graph algorithms, shortest path for connections, delay propagation
// modeling, cascading failure analysis, and hub centrality scoring.
//
// All computations use φ-weighted graph theory from first principles.
//
// ═══════════════════════════════════════════════════════════════════════════════

import { PHI } from './core';

// ═══════════════════════════════════════════════════════════════════════════
// §1 — GRAPH DATA STRUCTURES
// ═══════════════════════════════════════════════════════════════════════════

export interface FlightEdge {
  from: string; // airport code
  to: string;   // airport code
  flightNumber: string;
  duration: number; // minutes
  frequency: number; // flights per day
  weight: number; // φ-weighted edge importance
}

export interface AirportNode {
  code: string;
  name: string;
  latitude: number;
  longitude: number;
  connections: number; // degree
  centrality: number; // φ-weighted importance
}

export class FlightNetwork {
  private nodes: Map<string, AirportNode> = new Map();
  private edges: FlightEdge[] = [];
  private adjacency: Map<string, FlightEdge[]> = new Map();

  addNode(node: AirportNode): void {
    this.nodes.set(node.code, node);
    if (!this.adjacency.has(node.code)) {
      this.adjacency.set(node.code, []);
    }
  }

  addEdge(edge: FlightEdge): void {
    this.edges.push(edge);

    const fromEdges = this.adjacency.get(edge.from) || [];
    fromEdges.push(edge);
    this.adjacency.set(edge.from, fromEdges);

    // Update connection count
    const fromNode = this.nodes.get(edge.from);
    if (fromNode) {
      fromNode.connections++;
    }
  }

  getNode(code: string): AirportNode | undefined {
    return this.nodes.get(code);
  }

  getNeighbors(code: string): FlightEdge[] {
    return this.adjacency.get(code) || [];
  }

  getAllNodes(): AirportNode[] {
    return Array.from(this.nodes.values());
  }

  getAllEdges(): FlightEdge[] {
    return this.edges;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// §2 — SHORTEST PATH (DIJKSTRA WITH φ-WEIGHTING)
// ═══════════════════════════════════════════════════════════════════════════

export interface PathResult {
  path: string[]; // sequence of airport codes
  flights: string[]; // sequence of flight numbers
  totalDuration: number; // minutes
  totalConnections: number;
}

/**
 * Find shortest path using Dijkstra's algorithm with φ-weighted edges
 * Weight = flight duration * φ^(connection_penalty)
 */
export function findShortestPath(
  network: FlightNetwork,
  origin: string,
  destination: string
): PathResult | null {
  const distances: Map<string, number> = new Map();
  const previous: Map<string, { airport: string; flight: string }> = new Map();
  const unvisited: Set<string> = new Set();

  // Initialize
  for (const node of network.getAllNodes()) {
    distances.set(node.code, Infinity);
    unvisited.add(node.code);
  }
  distances.set(origin, 0);

  while (unvisited.size > 0) {
    // Find node with minimum distance
    let current: string | null = null;
    let minDist = Infinity;
    for (const code of unvisited) {
      const dist = distances.get(code) || Infinity;
      if (dist < minDist) {
        minDist = dist;
        current = code;
      }
    }

    if (current === null || current === destination) {
      break;
    }

    unvisited.delete(current);

    // Check neighbors
    const neighbors = network.getNeighbors(current);
    for (const edge of neighbors) {
      const altDistance = (distances.get(current) || 0) + edge.weight;

      if (altDistance < (distances.get(edge.to) || Infinity)) {
        distances.set(edge.to, altDistance);
        previous.set(edge.to, { airport: current, flight: edge.flightNumber });
      }
    }
  }

  // Reconstruct path
  if (!previous.has(destination)) {
    return null; // No path found
  }

  const path: string[] = [];
  const flights: string[] = [];
  let current = destination;

  while (current !== origin) {
    path.unshift(current);
    const prev = previous.get(current);
    if (!prev) break;
    flights.unshift(prev.flight);
    current = prev.airport;
  }
  path.unshift(origin);

  return {
    path,
    flights,
    totalDuration: distances.get(destination) || 0,
    totalConnections: flights.length - 1
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// §3 — DELAY PROPAGATION MODELING
// ═══════════════════════════════════════════════════════════════════════════

export interface DelayPropagation {
  affectedFlights: Map<string, number>; // flight -> expected delay (minutes)
  cascadeDepth: number; // number of propagation levels
  totalImpact: number; // φ-weighted cumulative delay
}

/**
 * Model delay propagation through network using φ-decay
 * Each level of propagation reduces impact by φ⁻¹
 */
export function propagateDelay(
  network: FlightNetwork,
  initialFlight: string,
  initialDelay: number,
  maxDepth: number = 5
): DelayPropagation {
  const affected: Map<string, number> = new Map();
  affected.set(initialFlight, initialDelay);

  let currentLevel: Map<string, number> = new Map([[initialFlight, initialDelay]]);
  let depth = 0;
  let totalImpact = initialDelay * Math.pow(PHI, 0);

  while (depth < maxDepth && currentLevel.size > 0) {
    const nextLevel: Map<string, number> = new Map();
    depth++;

    for (const [flightNum, delay] of currentLevel) {
      // Find flights that connect from this one
      for (const edge of network.getAllEdges()) {
        if (edge.flightNumber === flightNum) {
          // Find connecting flights at destination
          const connectingFlights = network.getNeighbors(edge.to);

          for (const connecting of connectingFlights) {
            // Propagate delay with φ⁻¹ decay per level
            const propagatedDelay = delay * Math.pow(PHI, -depth);

            if (propagatedDelay > 5) { // Threshold: 5 minutes
              const existingDelay = affected.get(connecting.flightNumber) || 0;
              const newDelay = Math.max(existingDelay, propagatedDelay);

              affected.set(connecting.flightNumber, newDelay);
              nextLevel.set(connecting.flightNumber, newDelay);

              totalImpact += newDelay * Math.pow(PHI, depth);
            }
          }
        }
      }
    }

    currentLevel = nextLevel;
  }

  return {
    affectedFlights: affected,
    cascadeDepth: depth,
    totalImpact
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// §4 — CASCADING FAILURE ANALYSIS
// ═══════════════════════════════════════════════════════════════════════════

export interface CascadeAnalysis {
  criticalFlights: string[]; // flights whose failure causes cascades
  vulnerabilityScore: number; // φ-weighted network vulnerability
  robustness: number; // 0-1 scale (1 = highly robust)
}

/**
 * Analyze network vulnerability to cascading failures
 * Uses φ-weighted centrality to identify critical flights
 */
export function analyzeCascadeVulnerability(
  network: FlightNetwork
): CascadeAnalysis {
  const criticalFlights: string[] = [];
  let totalVulnerability = 0;

  // Test each flight for cascade impact
  for (const edge of network.getAllEdges()) {
    const cascade = propagateDelay(network, edge.flightNumber, 60, 3); // 60 min delay, 3 levels

    const impact = cascade.affectedFlights.size * cascade.totalImpact;

    if (impact > 1000) { // Threshold for "critical"
      criticalFlights.push(edge.flightNumber);
    }

    totalVulnerability += impact * Math.pow(PHI, -1);
  }

  const avgVulnerability = totalVulnerability / network.getAllEdges().length;
  const robustness = 1 / (1 + avgVulnerability / 10000); // Normalized

  return {
    criticalFlights,
    vulnerabilityScore: avgVulnerability,
    robustness
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// §5 — HUB CENTRALITY SCORING
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Calculate hub centrality using φ-weighted PageRank
 * Hubs are airports with high connection counts weighted by flight frequency
 */
export function calculateHubCentrality(
  network: FlightNetwork,
  iterations: number = 20
): Map<string, number> {
  const centrality: Map<string, number> = new Map();
  const nodes = network.getAllNodes();

  // Initialize with equal centrality
  for (const node of nodes) {
    centrality.set(node.code, 1.0 / nodes.length);
  }

  // φ-weighted PageRank iterations
  const dampingFactor = Math.pow(PHI, -1); // φ⁻¹ ≈ 0.618

  for (let iter = 0; iter < iterations; iter++) {
    const newCentrality: Map<string, number> = new Map();

    for (const node of nodes) {
      let sum = 0;

      // Sum contributions from incoming edges
      for (const edge of network.getAllEdges()) {
        if (edge.to === node.code) {
          const fromCentrality = centrality.get(edge.from) || 0;
          const fromOutDegree = network.getNeighbors(edge.from).length;

          if (fromOutDegree > 0) {
            // Weight by flight frequency and φ
            sum += (fromCentrality / fromOutDegree) * edge.frequency * Math.pow(PHI, -1);
          }
        }
      }

      const newValue = (1 - dampingFactor) / nodes.length + dampingFactor * sum;
      newCentrality.set(node.code, newValue);
    }

    // Update centrality
    for (const [code, value] of newCentrality) {
      centrality.set(code, value);
    }
  }

  // Update nodes with computed centrality
  for (const node of nodes) {
    node.centrality = centrality.get(node.code) || 0;
  }

  return centrality;
}

/**
 * Identify top N hub airports
 */
export function identifyHubs(
  network: FlightNetwork,
  topN: number = 10
): AirportNode[] {
  calculateHubCentrality(network);

  const nodes = network.getAllNodes();
  nodes.sort((a, b) => b.centrality - a.centrality);

  return nodes.slice(0, topN);
}

// ═══════════════════════════════════════════════════════════════════════════
// §6 — NETWORK RESILIENCE METRICS
// ═══════════════════════════════════════════════════════════════════════════

export interface ResilienceMetrics {
  connectivity: number; // 0-1 (1 = fully connected)
  averagePathLength: number; // average hops between airports
  clusteringCoefficient: number; // φ-weighted local connectivity
  resilience: number; // composite φ-weighted score
}

/**
 * Calculate network resilience metrics
 */
export function calculateResilience(network: FlightNetwork): ResilienceMetrics {
  const nodes = network.getAllNodes();
  const n = nodes.length;

  // Calculate connectivity
  const maxEdges = n * (n - 1);
  const actualEdges = network.getAllEdges().length;
  const connectivity = actualEdges / maxEdges;

  // Calculate average path length (sample 100 random pairs)
  let totalPathLength = 0;
  let pathCount = 0;

  for (let i = 0; i < 100; i++) {
    const origin = nodes[Math.floor(Math.random() * n)];
    const dest = nodes[Math.floor(Math.random() * n)];

    if (origin.code !== dest.code) {
      const path = findShortestPath(network, origin.code, dest.code);
      if (path) {
        totalPathLength += path.path.length - 1;
        pathCount++;
      }
    }
  }

  const avgPathLength = pathCount > 0 ? totalPathLength / pathCount : 0;

  // Calculate clustering coefficient (simplified)
  let totalClustering = 0;
  for (const node of nodes) {
    const neighbors = network.getNeighbors(node.code);
    const k = neighbors.length;

    if (k > 1) {
      // Count edges between neighbors
      let neighborConnections = 0;
      for (let i = 0; i < neighbors.length; i++) {
        for (let j = i + 1; j < neighbors.length; j++) {
          const edge1 = neighbors[i];
          const edge2 = neighbors[j];

          // Check if these neighbors are connected
          const hasConnection = network.getNeighbors(edge1.to).some(
            e => e.to === edge2.to
          );
          if (hasConnection) {
            neighborConnections++;
          }
        }
      }

      const maxConnections = (k * (k - 1)) / 2;
      const clustering = maxConnections > 0 ? neighborConnections / maxConnections : 0;
      totalClustering += clustering * Math.pow(PHI, -1); // φ-weighted
    }
  }

  const clusteringCoefficient = nodes.length > 0 ? totalClustering / nodes.length : 0;

  // φ-weighted composite resilience score
  const resilience = (
    connectivity * Math.pow(PHI, 0) +
    (1 / (1 + avgPathLength)) * Math.pow(PHI, 1) +
    clusteringCoefficient * Math.pow(PHI, 2)
  ) / (Math.pow(PHI, 0) + Math.pow(PHI, 1) + Math.pow(PHI, 2));

  return {
    connectivity,
    averagePathLength: avgPathLength,
    clusteringCoefficient,
    resilience
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// §7 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════

export const FlightNetworkAnalysis = {
  FlightNetwork,
  findShortestPath,
  propagateDelay,
  analyzeCascadeVulnerability,
  calculateHubCentrality,
  identifyHubs,
  calculateResilience
};
