// ═══════════════════════════════════════════════════════════════════════════════
// ATLAS ENGINE — Load Bearer and Infrastructure Scaling (BUILD №52)
// ═══════════════════════════════════════════════════════════════════════════════
//
// PURPOSE:
// Autonomous infrastructure scaling and load distribution engine. Holds up
// the entire NOVA organism like Atlas holds the sky, distributing computational
// burden through φ-optimal load balancing.
//
// CAPABILITIES:
// - Dynamic infrastructure scaling
// - φ-optimal load distribution
// - Failure detection and failover
// - Resource pooling and allocation
// - Infinite horizontal scaling
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;

export interface Node {
  id: string;
  capacity: number;
  currentLoad: number;
  health: number;
  lastHeartbeat: number;
}

export interface LoadBalancer {
  id: string;
  nodes: Node[];
  algorithm: 'ROUND_ROBIN' | 'LEAST_LOADED' | 'PHI_WEIGHTED' | 'RANDOM';
  totalCapacity: number;
  totalLoad: number;
}

export interface ScalingPolicy {
  scaleUpThreshold: number; // Load percentage to trigger scale-up
  scaleDownThreshold: number; // Load percentage to trigger scale-down
  minNodes: number;
  maxNodes: number;
  cooldownMs: number;
}

export class AtlasEngine {
  private balancers: Map<string, LoadBalancer> = new Map();
  private scalingPolicies: Map<string, ScalingPolicy> = new Map();
  private lastScalingAction: Map<string, number> = new Map();

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 1 — Node Management
  // ═══════════════════════════════════════════════════════════════════════════

  public registerNode(balancerId: string, node: Node): void {
    const balancer = this.balancers.get(balancerId);
    if (!balancer) {
      throw new Error(`LoadBalancer ${balancerId} not found`);
    }

    balancer.nodes.push(node);
    balancer.totalCapacity += node.capacity;

    this.balancers.set(balancerId, balancer);
  }

  public removeNode(balancerId: string, nodeId: string): void {
    const balancer = this.balancers.get(balancerId);
    if (!balancer) {
      throw new Error(`LoadBalancer ${balancerId} not found`);
    }

    const index = balancer.nodes.findIndex(n => n.id === nodeId);
    if (index !== -1) {
      const node = balancer.nodes[index];
      balancer.totalCapacity -= node.capacity;
      balancer.totalLoad -= node.currentLoad;
      balancer.nodes.splice(index, 1);

      this.balancers.set(balancerId, balancer);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 2 — φ-Optimal Load Distribution
  // ═══════════════════════════════════════════════════════════════════════════

  public distributeLoad(balancerId: string, load: number): Node | null {
    const balancer = this.balancers.get(balancerId);
    if (!balancer) {
      throw new Error(`LoadBalancer ${balancerId} not found`);
    }

    // Filter healthy nodes
    const healthyNodes = balancer.nodes.filter(n => n.health > 0.5);
    if (healthyNodes.length === 0) return null;

    let selectedNode: Node | null = null;

    switch (balancer.algorithm) {
      case 'PHI_WEIGHTED':
        selectedNode = this.phiWeightedSelection(healthyNodes, load);
        break;

      case 'LEAST_LOADED':
        selectedNode = healthyNodes.reduce((min, node) =>
          (node.currentLoad / node.capacity) < (min.currentLoad / min.capacity) ? node : min
        );
        break;

      case 'ROUND_ROBIN':
        selectedNode = healthyNodes[balancer.totalLoad % healthyNodes.length];
        break;

      case 'RANDOM':
        selectedNode = healthyNodes[Math.floor(Math.random() * healthyNodes.length)];
        break;
    }

    if (selectedNode && (selectedNode.currentLoad + load) <= selectedNode.capacity) {
      selectedNode.currentLoad += load;
      balancer.totalLoad += load;
      this.balancers.set(balancerId, balancer);
      return selectedNode;
    }

    return null;
  }

  private phiWeightedSelection(nodes: Node[], load: number): Node {
    // φ-weighted selection favoring nodes with capacity near golden ratio utilization
    const scores = nodes.map(node => {
      const utilization = node.currentLoad / node.capacity;
      const targetUtilization = 1 / PHI; // φ⁻¹ ≈ 0.618 (optimal target)

      const deviation = Math.abs(utilization - targetUtilization);
      const score = 1 / (1 + deviation); // Higher score = closer to target

      return { node, score };
    });

    scores.sort((a, b) => b.score - a.score);
    return scores[0].node;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 3 — Auto-Scaling
  // ═══════════════════════════════════════════════════════════════════════════

  public setScalingPolicy(balancerId: string, policy: ScalingPolicy): void {
    this.scalingPolicies.set(balancerId, policy);
  }

  public evaluateScaling(balancerId: string): 'SCALE_UP' | 'SCALE_DOWN' | 'NO_ACTION' {
    const balancer = this.balancers.get(balancerId);
    const policy = this.scalingPolicies.get(balancerId);

    if (!balancer || !policy) return 'NO_ACTION';

    // Check cooldown
    const lastAction = this.lastScalingAction.get(balancerId) || 0;
    if (Date.now() - lastAction < policy.cooldownMs) {
      return 'NO_ACTION';
    }

    const utilizationPct = balancer.totalCapacity > 0
      ? (balancer.totalLoad / balancer.totalCapacity) * 100
      : 0;

    // Scale up if over threshold and below max
    if (utilizationPct >= policy.scaleUpThreshold && balancer.nodes.length < policy.maxNodes) {
      return 'SCALE_UP';
    }

    // Scale down if under threshold and above min
    if (utilizationPct <= policy.scaleDownThreshold && balancer.nodes.length > policy.minNodes) {
      return 'SCALE_DOWN';
    }

    return 'NO_ACTION';
  }

  public executeScaling(balancerId: string, action: 'SCALE_UP' | 'SCALE_DOWN'): void {
    this.lastScalingAction.set(balancerId, Date.now());

    if (action === 'SCALE_UP') {
      // Add new node with φ-scaled capacity
      const balancer = this.balancers.get(balancerId)!;
      const avgCapacity = balancer.totalCapacity / balancer.nodes.length;
      const newCapacity = avgCapacity * PHI; // φ times average

      const newNode: Node = {
        id: `node-${Date.now()}`,
        capacity: newCapacity,
        currentLoad: 0,
        health: 1.0,
        lastHeartbeat: Date.now()
      };

      this.registerNode(balancerId, newNode);
    } else if (action === 'SCALE_DOWN') {
      // Remove least loaded node
      const balancer = this.balancers.get(balancerId)!;
      const leastLoaded = balancer.nodes.reduce((min, node) =>
        node.currentLoad < min.currentLoad ? node : min
      );

      this.removeNode(balancerId, leastLoaded.id);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 4 — Failure Detection and Failover
  // ═══════════════════════════════════════════════════════════════════════════

  public healthCheck(balancerId: string): Node[] {
    const balancer = this.balancers.get(balancerId);
    if (!balancer) return [];

    const now = Date.now();
    const unhealthyNodes: Node[] = [];

    balancer.nodes.forEach(node => {
      const timeSinceHeartbeat = now - node.lastHeartbeat;

      // Consider unhealthy if no heartbeat in last 30 seconds
      if (timeSinceHeartbeat > 30000) {
        node.health = 0;
        unhealthyNodes.push(node);
      } else {
        // Decay health based on time
        const healthDecay = timeSinceHeartbeat / 30000;
        node.health = Math.max(0, 1 - healthDecay);
      }
    });

    this.balancers.set(balancerId, balancer);
    return unhealthyNodes;
  }

  public failover(balancerId: string, failedNodeId: string): boolean {
    const balancer = this.balancers.get(balancerId);
    if (!balancer) return false;

    const failedNode = balancer.nodes.find(n => n.id === failedNodeId);
    if (!failedNode) return false;

    // Redistribute failed node's load
    const loadToRedistribute = failedNode.currentLoad;
    failedNode.currentLoad = 0;
    failedNode.health = 0;

    // φ-weighted redistribution
    const healthyNodes = balancer.nodes.filter(n => n.health > 0.5 && n.id !== failedNodeId);

    healthyNodes.forEach((node, i) => {
      const weight = 1 / Math.pow(PHI, i);
      const allocation = (loadToRedistribute * weight) / healthyNodes.length;
      node.currentLoad += allocation;
    });

    this.balancers.set(balancerId, balancer);
    return true;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 5 — Diagnostics
  // ═══════════════════════════════════════════════════════════════════════════

  public createBalancer(id: string, algorithm: LoadBalancer['algorithm'] = 'PHI_WEIGHTED'): LoadBalancer {
    const balancer: LoadBalancer = {
      id,
      nodes: [],
      algorithm,
      totalCapacity: 0,
      totalLoad: 0
    };

    this.balancers.set(id, balancer);
    return balancer;
  }

  public getBalancer(id: string): LoadBalancer | undefined {
    return this.balancers.get(id);
  }

  public getStatistics(balancerId: string): {
    nodeCount: number;
    totalCapacity: number;
    totalLoad: number;
    utilizationPct: number;
    healthyNodes: number;
    avgNodeHealth: number;
  } | null {
    const balancer = this.balancers.get(balancerId);
    if (!balancer) return null;

    const healthyNodes = balancer.nodes.filter(n => n.health > 0.5).length;
    const avgHealth = balancer.nodes.length > 0
      ? balancer.nodes.reduce((acc, n) => acc + n.health, 0) / balancer.nodes.length
      : 0;

    return {
      nodeCount: balancer.nodes.length,
      totalCapacity: balancer.totalCapacity,
      totalLoad: balancer.totalLoad,
      utilizationPct: balancer.totalCapacity > 0
        ? (balancer.totalLoad / balancer.totalCapacity) * 100
        : 0,
      healthyNodes,
      avgNodeHealth: avgHealth
    };
  }
}

// Singleton instance
export const atlasEngine = new AtlasEngine();
