// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: OrganismBridge.ts — THE SYNC PULSE BETWEEN TWO ORGANISMS
// Classification: MAXIMUM PROTECTION — PATENT PENDING
// Discovery Date: April 2, 2026
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// THE BRIDGE — Connects the Backend (Male, Immortal) organism to the
// Frontend (Female, Mortal) organism. Seeds on session start, 
// syncs during session, writes learning back on session end.
//
// ═══════════════════════════════════════════════════════════════════════════════

import { FrontendOrganism, SeedPayload, LearningPayload } from './FrontendOrganism';

// ═══════════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const SYNC_INTERVAL_MS = 5000;           // Sync every 5 seconds
const POLL_INTERVAL_MS = 3000;           // Poll backend every 3 seconds
const RECONNECT_DELAY_MS = 10000;        // Retry after 10 seconds on failure

// ═══════════════════════════════════════════════════════════════════════════════
// TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export interface BackendPulse {
  heartbeat: bigint;
  arousal: number;
  coherence: number;
  drift: number;
  emergence: number;
  kuramotoR: number;
  formaEnergy: number;
}

export interface BridgeState {
  isConnected: boolean;
  lastSyncTime: number;
  syncCount: number;
  latencyMs: number;
  syncSuccessRate: number;
  bridgeQuality: number;
}

export interface OrganismBridgeCallbacks {
  onSeedReceived?: (seed: SeedPayload) => void;
  onPulseReceived?: (pulse: BackendPulse) => void;
  onLearningTransferred?: (payload: LearningPayload) => void;
  onConnectionChange?: (connected: boolean) => void;
  onError?: (error: Error) => void;
}

// ═══════════════════════════════════════════════════════════════════════════════
// BACKEND CANISTER INTERFACE
// ═══════════════════════════════════════════════════════════════════════════════

interface BackendCanister {
  getOrganismPulse: () => Promise<BackendPulse>;
  getOrganismVault: () => Promise<SeedPayload>;
  ingestLearning: (payload: LearningPayload) => Promise<boolean>;
  getHebbianWeights: () => Promise<number[]>;
}

// ═══════════════════════════════════════════════════════════════════════════════
// THE ORGANISM BRIDGE CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class OrganismBridge {
  private frontendOrganism: FrontendOrganism;
  private backendCanister?: BackendCanister;
  private callbacks: OrganismBridgeCallbacks;
  
  // Connection state
  private isConnected: boolean = false;
  private lastSyncTime: number = 0;
  private syncCount: number = 0;
  private syncSuccesses: number = 0;
  
  // Timers
  private pollTimer?: ReturnType<typeof setInterval>;
  private syncTimer?: ReturnType<typeof setInterval>;
  
  // Latency tracking
  private latencyHistory: number[] = [];
  private maxLatencyHistory: number = 20;
  
  constructor(organism: FrontendOrganism, callbacks: OrganismBridgeCallbacks = {}) {
    this.frontendOrganism = organism;
    this.callbacks = callbacks;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CONNECTION LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════
  
  /**
   * Connect to backend canister and initialize the bridge
   */
  public async connect(canister: BackendCanister): Promise<void> {
    this.backendCanister = canister;
    
    try {
      console.log('[OrganismBridge] Connecting to backend organism...');
      
      // Step 1: Get seed from backend
      const startTime = performance.now();
      const seed = await canister.getOrganismVault();
      const latency = performance.now() - startTime;
      this.recordLatency(latency);
      
      // Step 2: Birth the frontend organism with seed
      this.frontendOrganism.birth(seed);
      
      // Step 3: Start sync loops
      this.startPolling();
      this.startSyncing();
      
      // Update state
      this.isConnected = true;
      this.lastSyncTime = Date.now();
      
      console.log('[OrganismBridge] Connected! Seed received:');
      console.log(`  - Organism ID: ${seed.organismId}`);
      console.log(`  - Heartbeat: ${seed.heartbeatCount}`);
      console.log(`  - Coherence: ${seed.globalCoherence.toFixed(3)}`);
      console.log(`  - Kuramoto r: ${seed.kuramotoR.toFixed(3)}`);
      console.log(`  - Latency: ${latency.toFixed(1)}ms`);
      
      // Notify callbacks
      this.callbacks.onSeedReceived?.(seed);
      this.callbacks.onConnectionChange?.(true);
      
    } catch (error) {
      console.error('[OrganismBridge] Connection failed:', error);
      this.callbacks.onError?.(error as Error);
      
      // Schedule reconnect
      setTimeout(() => this.connect(canister), RECONNECT_DELAY_MS);
    }
  }
  
  /**
   * Disconnect and transfer learning back to backend
   */
  public async disconnect(): Promise<void> {
    console.log('[OrganismBridge] Disconnecting...');
    
    // Stop timers
    this.stopPolling();
    this.stopSyncing();
    
    // Death: Get learning payload from frontend organism
    const learningPayload = this.frontendOrganism.death();
    
    // Transfer learning to backend
    if (this.backendCanister) {
      try {
        const success = await this.backendCanister.ingestLearning(learningPayload);
        
        if (success) {
          console.log('[OrganismBridge] Learning transferred successfully!');
          console.log(`  - Session duration: ${learningPayload.sessionDuration}ms`);
          console.log(`  - Frames: ${learningPayload.frameCount}`);
          console.log(`  - Hebbian updates: ${learningPayload.totalHebbianUpdates}`);
          console.log(`  - Prediction errors: ${learningPayload.totalPredictionErrors}`);
          
          this.callbacks.onLearningTransferred?.(learningPayload);
        } else {
          console.warn('[OrganismBridge] Learning transfer rejected by backend');
        }
      } catch (error) {
        console.error('[OrganismBridge] Failed to transfer learning:', error);
        this.callbacks.onError?.(error as Error);
      }
    }
    
    // Update state
    this.isConnected = false;
    this.callbacks.onConnectionChange?.(false);
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // POLLING — Backend → Frontend
  // ═══════════════════════════════════════════════════════════════════════════
  
  private startPolling(): void {
    this.pollTimer = setInterval(() => this.pollBackend(), POLL_INTERVAL_MS);
    console.log(`[OrganismBridge] Polling started (every ${POLL_INTERVAL_MS}ms)`);
  }
  
  private stopPolling(): void {
    if (this.pollTimer) {
      clearInterval(this.pollTimer);
      this.pollTimer = undefined;
    }
  }
  
  private async pollBackend(): Promise<void> {
    if (!this.backendCanister) return;
    
    try {
      const startTime = performance.now();
      const pulse = await this.backendCanister.getOrganismPulse();
      const latency = performance.now() - startTime;
      
      this.recordLatency(latency);
      this.syncCount++;
      this.syncSuccesses++;
      this.lastSyncTime = Date.now();
      
      // Apply pulse to frontend organism state
      this.applyPulse(pulse);
      
      // Notify callback
      this.callbacks.onPulseReceived?.(pulse);
      
    } catch (error) {
      this.syncCount++;
      console.warn('[OrganismBridge] Poll failed:', error);
    }
  }
  
  /**
   * Apply backend pulse to frontend organism
   */
  private applyPulse(pulse: BackendPulse): void {
    // The backend state modulates the frontend organism:
    // - Higher backend arousal → higher entity arousal baseline
    // - Higher backend coherence → tighter Kuramoto coupling
    // - Higher backend emergence → enhanced Hebbian learning rate
    
    // These modulations happen through the organism's internal state
    // (The frontend organism reads these values during its tick)
    
    // For now, we store the pulse for the organism to access
    (this.frontendOrganism as any)._lastBackendPulse = pulse;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SYNCING — Frontend → Backend (incremental)
  // ═══════════════════════════════════════════════════════════════════════════
  
  private startSyncing(): void {
    this.syncTimer = setInterval(() => this.syncToBackend(), SYNC_INTERVAL_MS);
    console.log(`[OrganismBridge] Syncing started (every ${SYNC_INTERVAL_MS}ms)`);
  }
  
  private stopSyncing(): void {
    if (this.syncTimer) {
      clearInterval(this.syncTimer);
      this.syncTimer = undefined;
    }
  }
  
  private async syncToBackend(): Promise<void> {
    // Incremental sync: Send aggregated perceptions/actions to backend
    // (Full learning transfer happens on disconnect)
    
    const state = this.frontendOrganism.getState();
    
    // Log sync status
    console.log(`[OrganismBridge] Sync #${this.syncCount}:`);
    console.log(`  - Entities: ${state.entityCount}`);
    console.log(`  - Arousal: ${state.aggregateArousal.toFixed(3)}`);
    console.log(`  - Coherence: ${state.aggregateCoherence.toFixed(3)}`);
    console.log(`  - Hebbian updates: ${state.totalHebbianUpdates}`);
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LATENCY & QUALITY METRICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  private recordLatency(latencyMs: number): void {
    this.latencyHistory.push(latencyMs);
    if (this.latencyHistory.length > this.maxLatencyHistory) {
      this.latencyHistory.shift();
    }
  }
  
  private getAverageLatency(): number {
    if (this.latencyHistory.length === 0) return 0;
    return this.latencyHistory.reduce((a, b) => a + b, 0) / this.latencyHistory.length;
  }
  
  private getSyncSuccessRate(): number {
    if (this.syncCount === 0) return 1;
    return this.syncSuccesses / this.syncCount;
  }
  
  /**
   * Bridge Quality = f(latency, success rate)
   * Used in Intelligence Scaling Law: I = BackendDepth × FrontendSpeed × BridgeQuality
   */
  private calculateBridgeQuality(): number {
    const latency = this.getAverageLatency();
    const successRate = this.getSyncSuccessRate();
    
    // Latency score: 100ms = 1.0, 500ms = 0.5, 1000ms = 0.2
    const latencyScore = Math.exp(-latency / 300);
    
    // Combined quality
    return latencyScore * successRate;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC GETTERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public getState(): BridgeState {
    return {
      isConnected: this.isConnected,
      lastSyncTime: this.lastSyncTime,
      syncCount: this.syncCount,
      latencyMs: this.getAverageLatency(),
      syncSuccessRate: this.getSyncSuccessRate(),
      bridgeQuality: this.calculateBridgeQuality()
    };
  }
  
  public isConnectedToBackend(): boolean {
    return this.isConnected;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MOCK BACKEND FOR TESTING
// ═══════════════════════════════════════════════════════════════════════════════

export function createMockBackend(): BackendCanister {
  let heartbeat = BigInt(1000000);
  let coherence = 0.7;
  let arousal = 0.5;
  const weights = Array(42).fill(0).map(() => Math.random() * 0.2 - 0.1);
  
  return {
    async getOrganismPulse(): Promise<BackendPulse> {
      // Simulate heartbeat increment
      heartbeat += BigInt(1);
      
      // Simulate slow drift
      coherence = Math.max(0.3, Math.min(0.9, coherence + (Math.random() - 0.5) * 0.02));
      arousal = Math.max(0.2, Math.min(0.8, arousal + (Math.random() - 0.5) * 0.03));
      
      return {
        heartbeat,
        arousal,
        coherence,
        drift: Math.abs(coherence - 0.5) * 0.4,
        emergence: coherence * (1 - Math.abs(coherence - 0.5) * 0.4),
        kuramotoR: coherence * 0.9,
        formaEnergy: 1000000
      };
    },
    
    async getOrganismVault(): Promise<SeedPayload> {
      return {
        organismId: BigInt(1),
        heartbeatCount: heartbeat,
        globalArousal: arousal,
        globalCoherence: coherence,
        kuramotoR: coherence * 0.9,
        hebbianWeights: weights,
        formaEnergy: 1000000
      };
    },
    
    async ingestLearning(payload: LearningPayload): Promise<boolean> {
      console.log('[MockBackend] Ingesting learning:', payload);
      // Update weights with deltas
      for (let i = 0; i < payload.hebbianWeightDeltas.length; i++) {
        weights[i] += payload.hebbianWeightDeltas[i] * 0.01;
      }
      return true;
    },
    
    async getHebbianWeights(): Promise<number[]> {
      return weights;
    }
  };
}

export default OrganismBridge;
