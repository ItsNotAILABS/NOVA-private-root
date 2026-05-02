// ═══════════════════════════════════════════════════════════════════════════════
// AIRPORT FLOW — CPL Math Module for Passenger Flow Dynamics
// BUILD №49 — NOVA V5 Airport Application
// ═══════════════════════════════════════════════════════════════════════════════
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// MEDINA TECH — SOVEREIGN ORGANISM ARCHITECTURE
//
// This is NOT a utility module. This is a sovereign CPL math engine computing
// passenger flow dynamics, queue theory, bottleneck prediction, gate assignment
// optimization, boarding group sequencing, and connection probability analysis.
//
// All computations are performed from first principles using φ-weighted mathematics.
//
// ═══════════════════════════════════════════════════════════════════════════════

import { PHI, FEIGENBAUM_D } from './core';

// ═══════════════════════════════════════════════════════════════════════════
// §1 — PASSENGER FLOW DYNAMICS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Queue Theory: M/M/c queue model for passenger processing
 * λ = arrival rate (passengers per minute)
 * μ = service rate (passengers per minute per server)
 * c = number of servers (gates, kiosks, checkpoints)
 *
 * Returns: Average wait time in minutes
 */
export function calculateQueueWaitTime(
  arrivalRate: number,
  serviceRate: number,
  numServers: number
): number {
  const rho = arrivalRate / (serviceRate * numServers); // Utilization

  if (rho >= 1.0) {
    return Infinity; // System is unstable
  }

  // Erlang C formula (simplified)
  const c = numServers;
  const lambda = arrivalRate;
  const mu = serviceRate;

  // Average wait time in queue
  const erlangC = calculateErlangC(lambda, mu, c);
  const avgWait = (erlangC / (c * mu - lambda)) * PHI; // φ-weighted

  return avgWait;
}

/**
 * Erlang C formula: Probability of waiting in queue
 */
function calculateErlangC(lambda: number, mu: number, c: number): number {
  const a = lambda / mu; // Traffic intensity

  // Simplified calculation for pilot
  const p0 = 1 / (1 + a / c); // Probability of zero wait
  const pc = (Math.pow(a, c) / factorial(c)) * (c / (c - a)) * p0;

  return pc;
}

function factorial(n: number): number {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

// ═══════════════════════════════════════════════════════════════════════════
// §2 — BOTTLENECK PREDICTION
// ═══════════════════════════════════════════════════════════════════════════

export interface Bottleneck {
  location: string;
  severity: number; // φ-weighted: 0=no bottleneck, 1=moderate, >1=severe
  predictedDelay: number; // minutes
  recommendation: string;
}

/**
 * Predict bottlenecks in passenger flow
 * Uses φ-powers to weight different congestion points
 */
export function predictBottlenecks(
  securityQueue: number,
  gateQueue: number,
  boardingQueue: number
): Bottleneck[] {
  const bottlenecks: Bottleneck[] = [];

  // Security checkpoint
  if (securityQueue > 30) {
    const severity = (securityQueue / 30) * PHI;
    bottlenecks.push({
      location: 'Security Checkpoint',
      severity,
      predictedDelay: securityQueue * 0.5 * PHI,
      recommendation: severity > 2 ? 'Open additional lanes' : 'Monitor closely'
    });
  }

  // Gate area
  if (gateQueue > 50) {
    const severity = (gateQueue / 50) * Math.pow(PHI, 2);
    bottlenecks.push({
      location: 'Gate Area',
      severity,
      predictedDelay: gateQueue * 0.3 * PHI,
      recommendation: severity > 2 ? 'Start early boarding' : 'Pre-board premium passengers'
    });
  }

  // Boarding process
  if (boardingQueue > 100) {
    const severity = (boardingQueue / 100) * Math.pow(PHI, 3);
    bottlenecks.push({
      location: 'Boarding Process',
      severity,
      predictedDelay: boardingQueue * 0.2 * PHI,
      recommendation: 'Expedite boarding - add staff'
    });
  }

  return bottlenecks;
}

// ═══════════════════════════════════════════════════════════════════════════
// §3 — GATE ASSIGNMENT OPTIMIZATION
// ═══════════════════════════════════════════════════════════════════════════

export interface GateScore {
  gateId: string;
  score: number; // φ-weighted optimization score (higher = better)
  walkingDistance: number; // meters
  turnaroundTime: number; // minutes
}

/**
 * Optimize gate assignment using φ-weighted multi-objective scoring
 * Objective 1 (φ⁰): Minimize passenger walking distance
 * Objective 2 (φ¹): Maximize aircraft turnaround efficiency
 */
export function scoreGateAssignment(
  gateId: string,
  avgWalkingDistance: number,
  expectedTurnaround: number,
  requiredTurnaround: number
): GateScore {
  // Normalize walking distance (target: 200m, max: 1000m)
  const walkingScore = Math.max(0, 1 - (avgWalkingDistance / 1000));

  // Normalize turnaround time (bonus if extra time available)
  const turnaroundScore = Math.min(2, expectedTurnaround / requiredTurnaround);

  // φ-weighted composite score
  const compositeScore = (walkingScore * Math.pow(PHI, 0)) + (turnaroundScore * Math.pow(PHI, 1));

  return {
    gateId,
    score: compositeScore,
    walkingDistance: avgWalkingDistance,
    turnaroundTime: expectedTurnaround
  };
}

/**
 * Find optimal gate from available gates
 */
export function findOptimalGate(gates: GateScore[]): GateScore | null {
  if (gates.length === 0) return null;

  return gates.reduce((best, current) =>
    current.score > best.score ? current : best
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// §4 — BOARDING GROUP SEQUENCING
// ═══════════════════════════════════════════════════════════════════════════

export interface BoardingGroup {
  groupNumber: number;
  priority: number; // φ-weighted priority score
  passengerCount: number;
  estimatedBoardingTime: number; // minutes
}

/**
 * Calculate φ-weighted boarding priority
 * Premium passengers: φ³
 * Families with children: φ²
 * Window seats: φ¹
 * Middle seats: φ⁰
 * Aisle seats: φ⁻¹
 */
export function calculateBoardingPriority(
  isPremium: boolean,
  hasChildren: boolean,
  seatType: 'window' | 'middle' | 'aisle'
): number {
  let priority = 0;

  if (isPremium) {
    priority += Math.pow(PHI, 3);
  }

  if (hasChildren) {
    priority += Math.pow(PHI, 2);
  }

  switch (seatType) {
    case 'window':
      priority += Math.pow(PHI, 1);
      break;
    case 'middle':
      priority += Math.pow(PHI, 0);
      break;
    case 'aisle':
      priority += Math.pow(PHI, -1);
      break;
  }

  return priority;
}

/**
 * Sequence boarding groups for optimal flow
 */
export function sequenceBoardingGroups(groups: BoardingGroup[]): BoardingGroup[] {
  return groups.sort((a, b) => b.priority - a.priority);
}

// ═══════════════════════════════════════════════════════════════════════════
// §5 — CONNECTION PROBABILITY (MONTE CARLO)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Monte Carlo simulation of connection success probability
 * Factors: scheduled connection time, delay distribution, walking time
 */
export function simulateConnectionProbability(
  scheduledConnectionMinutes: number,
  inboundDelayMean: number,
  inboundDelayStdDev: number,
  walkingTimeMinutes: number,
  numSimulations: number = 10000
): number {
  let successCount = 0;

  for (let i = 0; i < numSimulations; i++) {
    // Sample inbound delay from normal distribution
    const delay = sampleNormal(inboundDelayMean, inboundDelayStdDev);

    // Available time = scheduled time - delay - walking time
    const availableTime = scheduledConnectionMinutes - delay - walkingTimeMinutes;

    if (availableTime >= 0) {
      successCount++;
    }
  }

  const probability = successCount / numSimulations;

  // φ-weighted adjustment for pessimistic real-world conditions
  return probability * Math.pow(PHI, -1); // Reduce by φ⁻¹ factor
}

/**
 * Sample from normal distribution (Box-Muller transform)
 */
function sampleNormal(mean: number, stdDev: number): number {
  const u1 = Math.random();
  const u2 = Math.random();

  const z0 = Math.sqrt(-2.0 * Math.log(u1)) * Math.cos(2.0 * Math.PI * u2);

  return mean + z0 * stdDev;
}

// ═══════════════════════════════════════════════════════════════════════════
// §6 — PASSENGER DENSITY & FLOW RATE
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Calculate safe passenger density using φ-based crowd dynamics
 * Safe density: 1 person per φ² square meters
 * Warning density: 1 person per φ¹ square meters
 * Critical density: 1 person per φ⁰ square meters
 */
export function calculateCrowdDensity(
  numPassengers: number,
  areaSquareMeters: number
): {
  density: number; // persons per square meter
  level: 'safe' | 'warning' | 'critical';
  recommendation: string;
} {
  const density = numPassengers / areaSquareMeters;

  const safeDensity = 1 / Math.pow(PHI, 2); // ~0.382 persons/m²
  const warningDensity = 1 / Math.pow(PHI, 1); // ~0.618 persons/m²
  const criticalDensity = 1 / Math.pow(PHI, 0); // 1.0 persons/m²

  let level: 'safe' | 'warning' | 'critical';
  let recommendation: string;

  if (density <= safeDensity) {
    level = 'safe';
    recommendation = 'Normal operations';
  } else if (density <= warningDensity) {
    level = 'warning';
    recommendation = 'Monitor crowd flow - consider opening additional space';
  } else {
    level = 'critical';
    recommendation = 'URGENT: Reduce crowd density - redirect passengers';
  }

  return { density, level, recommendation };
}

/**
 * Calculate maximum flow rate through a corridor
 * Based on Fruin Level of Service (φ-weighted)
 */
export function calculateMaxFlowRate(
  corridorWidthMeters: number,
  levelOfService: 'A' | 'B' | 'C' | 'D' | 'E' | 'F'
): number {
  // Fruin LoS flow rates (persons per meter per minute)
  const flowRates: { [key: string]: number } = {
    'A': 23 * Math.pow(PHI, -2), // Comfortable
    'B': 33 * Math.pow(PHI, -1), // Slightly restricted
    'C': 49 * Math.pow(PHI, 0),  // Restricted
    'D': 66 * Math.pow(PHI, 1),  // Very restricted
    'E': 82 * Math.pow(PHI, 2),  // Severely restricted
    'F': 0 // Complete congestion
  };

  const flowRate = flowRates[levelOfService] || 0;
  return flowRate * corridorWidthMeters;
}

// ═══════════════════════════════════════════════════════════════════════════
// §7 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════

export const AirportFlow = {
  calculateQueueWaitTime,
  predictBottlenecks,
  scoreGateAssignment,
  findOptimalGate,
  calculateBoardingPriority,
  sequenceBoardingGroups,
  simulateConnectionProbability,
  calculateCrowdDensity,
  calculateMaxFlowRate
};
