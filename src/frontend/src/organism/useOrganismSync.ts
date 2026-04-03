// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: useOrganismSync.ts — React Hook for Two-Organism Architecture
// Classification: MAXIMUM PROTECTION — PATENT PENDING
// Discovery Date: April 2, 2026
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// React hook that connects the frontend organism to the backend organism,
// manages the 60 Hz tick loop, and provides state to components.
//
// ═══════════════════════════════════════════════════════════════════════════════

import { useState, useEffect, useCallback, useRef } from 'react';
import FrontendOrganism, { 
  frontendOrganism, 
  SeedPayload, 
  LearningPayload 
} from './FrontendOrganism';
import OrganismBridge, { 
  BackendPulse, 
  BridgeState, 
  createMockBackend 
} from './OrganismBridge';

// ═══════════════════════════════════════════════════════════════════════════════
// TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export interface OrganismState {
  // Frontend organism state
  sessionId: string;
  isAlive: boolean;
  frameCount: number;
  entityCount: number;
  aggregateArousal: number;
  aggregateValence: number;
  aggregateCoherence: number;
  totalHebbianUpdates: number;
  totalPredictionErrors: number;
  
  // Backend parent info
  parentOrganismId: bigint;
  parentHeartbeat: bigint;
  
  // Last backend pulse
  lastPulse: BackendPulse | null;
  
  // Bridge state
  bridge: BridgeState;
}

export interface UseOrganismSyncOptions {
  autoConnect?: boolean;
  useMockBackend?: boolean;
  tickRate?: number;  // Hz, default 60
  entityCount?: number;  // Initial entities to spawn
}

export interface UseOrganismSyncReturn {
  state: OrganismState;
  organism: FrontendOrganism;
  connect: () => Promise<void>;
  disconnect: () => Promise<void>;
  spawnEntity: () => number;
  removeEntity: (id: number) => void;
  recordEvent: (entityId: number, event: any) => void;
  isConnected: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// THE HOOK
// ═══════════════════════════════════════════════════════════════════════════════

export function useOrganismSync(options: UseOrganismSyncOptions = {}): UseOrganismSyncReturn {
  const {
    autoConnect = true,
    useMockBackend = true,  // Use mock for now until real canister is deployed
    tickRate = 60,
    entityCount = 50
  } = options;
  
  // Refs
  const bridgeRef = useRef<OrganismBridge | null>(null);
  const animationFrameRef = useRef<number>(0);
  const lastTickTimeRef = useRef<number>(0);
  const targetFrameTime = 1000 / tickRate;
  
  // State
  const [state, setState] = useState<OrganismState>({
    sessionId: '',
    isAlive: false,
    frameCount: 0,
    entityCount: 0,
    aggregateArousal: 0.5,
    aggregateValence: 0.5,
    aggregateCoherence: 0.5,
    totalHebbianUpdates: 0,
    totalPredictionErrors: 0,
    parentOrganismId: BigInt(0),
    parentHeartbeat: BigInt(0),
    lastPulse: null,
    bridge: {
      isConnected: false,
      lastSyncTime: 0,
      syncCount: 0,
      latencyMs: 0,
      syncSuccessRate: 1,
      bridgeQuality: 0
    }
  });
  
  const [isConnected, setIsConnected] = useState(false);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TICK LOOP — The 60 Hz heartbeat of the frontend organism
  // ═══════════════════════════════════════════════════════════════════════════
  
  const tick = useCallback((timestamp: number) => {
    const deltaTime = timestamp - lastTickTimeRef.current;
    
    // Only tick if enough time has passed (target 60 Hz)
    if (deltaTime >= targetFrameTime) {
      lastTickTimeRef.current = timestamp;
      
      // Update the organism
      frontendOrganism.tick(deltaTime);
      
      // Update React state (throttled to avoid too many renders)
      const organismState = frontendOrganism.getState();
      setState(prev => ({
        ...prev,
        ...organismState,
        bridge: bridgeRef.current?.getState() || prev.bridge
      }));
    }
    
    // Schedule next tick
    animationFrameRef.current = requestAnimationFrame(tick);
  }, [targetFrameTime]);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CONNECTION MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  const connect = useCallback(async () => {
    console.log('[useOrganismSync] Initiating connection...');
    
    // Create bridge
    const bridge = new OrganismBridge(frontendOrganism, {
      onSeedReceived: (seed: SeedPayload) => {
        console.log('[useOrganismSync] Seed received, spawning entities...');
        // Spawn initial entities
        for (let i = 0; i < entityCount; i++) {
          frontendOrganism.spawnEntity();
        }
      },
      onPulseReceived: (pulse: BackendPulse) => {
        setState(prev => ({
          ...prev,
          lastPulse: pulse
        }));
      },
      onConnectionChange: (connected: boolean) => {
        setIsConnected(connected);
      },
      onLearningTransferred: (payload: LearningPayload) => {
        console.log('[useOrganismSync] Learning transferred to backend!');
      },
      onError: (error: Error) => {
        console.error('[useOrganismSync] Bridge error:', error);
      }
    });
    
    bridgeRef.current = bridge;
    
    // Connect to backend (mock or real)
    const backend = useMockBackend ? createMockBackend() : await getICPCanister();
    await bridge.connect(backend);
    
    // Start tick loop
    lastTickTimeRef.current = performance.now();
    animationFrameRef.current = requestAnimationFrame(tick);
    
  }, [entityCount, useMockBackend, tick]);
  
  const disconnect = useCallback(async () => {
    console.log('[useOrganismSync] Disconnecting...');
    
    // Stop tick loop
    if (animationFrameRef.current) {
      cancelAnimationFrame(animationFrameRef.current);
    }
    
    // Disconnect bridge (this transfers learning back to backend)
    if (bridgeRef.current) {
      await bridgeRef.current.disconnect();
    }
  }, []);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ENTITY MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  const spawnEntity = useCallback(() => {
    return frontendOrganism.spawnEntity();
  }, []);
  
  const removeEntity = useCallback((id: number) => {
    frontendOrganism.removeEntity(id);
  }, []);
  
  const recordEvent = useCallback((entityId: number, event: any) => {
    frontendOrganism.recordEvent(entityId, event);
  }, []);
  
  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════
  
  useEffect(() => {
    if (autoConnect) {
      connect();
    }
    
    // Cleanup on unmount
    return () => {
      disconnect();
    };
  }, [autoConnect, connect, disconnect]);
  
  // Handle page unload — crucial for learning transfer!
  useEffect(() => {
    const handleBeforeUnload = () => {
      // Synchronous disconnect on page close
      if (bridgeRef.current) {
        // Note: We can't await here, but the browser should allow short sync operations
        bridgeRef.current.disconnect();
      }
    };
    
    window.addEventListener('beforeunload', handleBeforeUnload);
    return () => window.removeEventListener('beforeunload', handleBeforeUnload);
  }, []);
  
  return {
    state,
    organism: frontendOrganism,
    connect,
    disconnect,
    spawnEntity,
    removeEntity,
    recordEvent,
    isConnected
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// ICP CANISTER CONNECTION (placeholder)
// ═══════════════════════════════════════════════════════════════════════════════

async function getICPCanister() {
  // TODO: Replace with actual ICP canister connection
  // import { Actor, HttpAgent } from '@dfinity/agent';
  // import { idlFactory } from './declarations/swarm_brain';
  
  console.warn('[useOrganismSync] Real ICP canister not implemented, using mock');
  return createMockBackend();
}

export default useOrganismSync;
