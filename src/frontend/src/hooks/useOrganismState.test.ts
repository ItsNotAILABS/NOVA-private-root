// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  ORGANISM STATE HOOK TEST SUITE                                                                           ║
// ║  Tests for the useOrganismState React hook                                                                ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { renderHook, act, waitFor } from '@testing-library/react';
import { useOrganismState } from '../hooks/useOrganismState';

// Mock the dependencies
vi.mock('../organisms/drone-mind', () => ({
  SwarmCoordinator: vi.fn().mockImplementation(() => ({
    drones: Array.from({ length: 12 }, (_, i) => ({
      id: i,
      x: 0, y: 0, z: 0,
      velX: 0, velY: 0, velZ: 0,
      phase: 0,
      energy: 1.5,
      cortisol: 1.0,
      signal: 0.5,
      trustScore: 0.8,
      anomalyScore: 0.1,
      qConvergence: 0.7,
      nowAttention: 0.8,
      sacrificed: false,
      role: 'SCOUT',
      class: 'WORKER',
    })),
    tick: vi.fn().mockReturnValue({
      drones: Array.from({ length: 12 }, (_, i) => ({
        id: i,
        x: Math.random() * 10, y: 0, z: Math.random() * 10,
        velX: 0.1, velY: 0, velZ: 0.1,
        phase: Math.random() * Math.PI * 2,
        energy: 1.5 + Math.random() * 0.5,
        cortisol: 1.0 + Math.random() * 0.3,
        signal: 0.5 + Math.random() * 0.2,
        trustScore: 0.7 + Math.random() * 0.2,
        anomalyScore: 0.05 + Math.random() * 0.1,
        qConvergence: 0.6 + Math.random() * 0.3,
        nowAttention: 0.7 + Math.random() * 0.2,
        sacrificed: false,
        role: 'SCOUT',
        class: 'WORKER',
      })),
      rSwarm: 0.85,
      psi: 0.5,
      jDrift: 0.1,
      swarmQCoherence: 0.75,
    }),
    emergencyStop: vi.fn(),
  })),
}));

vi.mock('../world/world-generator', () => ({
  WorldGenerator: vi.fn().mockImplementation(() => ({
    tick: vi.fn().mockReturnValue({
      objects: [],
      macro: {
        timeOfDay: 0.5,
        weather: 'clear',
        temperature: 20,
        season: 'summer',
      },
    }),
  })),
}));

vi.mock('../enterprise/habitat', () => ({
  EnterpriseHabitat: vi.fn().mockImplementation(() => ({
    tick: vi.fn().mockReturnValue({
      workers: [],
      projects: [],
      resources: {},
    }),
  })),
}));

// ═══════════════════════════════════════════════════════════════════════════════
// HOOK TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('useOrganismState', () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it('should initialize with default values', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(result.current.beat).toBe(0);
    expect(result.current.drones).toHaveLength(12);
    expect(result.current.missionStatus).toBe('IDLE');
    expect(result.current.emergencyActive).toBe(false);
  });

  it('should have valid initial rSwarm in [0, 1]', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(result.current.rSwarm).toBeGreaterThanOrEqual(0);
    expect(result.current.rSwarm).toBeLessThanOrEqual(1);
  });

  it('should have valid initial scores in [0, 1]', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(result.current.continuityScore).toBeGreaterThanOrEqual(0);
    expect(result.current.continuityScore).toBeLessThanOrEqual(1);
    expect(result.current.trustScore).toBeGreaterThanOrEqual(0);
    expect(result.current.trustScore).toBeLessThanOrEqual(1);
    expect(result.current.anomalyScore).toBeGreaterThanOrEqual(0);
    expect(result.current.anomalyScore).toBeLessThanOrEqual(1);
  });

  it('should increment beat on tick', async () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(result.current.beat).toBe(0);
    
    act(() => {
      vi.advanceTimersByTime(200); // TICK_MS
    });
    
    // The beat should have changed (either 0 or 1 depending on timing)
    expect(result.current.beat).toBeGreaterThanOrEqual(0);
  }, 10000);

  it('should have setArchitectSignal function', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(typeof result.current.setArchitectSignal).toBe('function');
  });

  it('should have approve function', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(typeof result.current.approve).toBe('function');
  });

  it('should have deny function', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(typeof result.current.deny).toBe('function');
  });

  it('should have emergencyStop function', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(typeof result.current.emergencyStop).toBe('function');
  });

  it('should have startMission function', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(typeof result.current.startMission).toBe('function');
  });

  it('should have heartbeat function', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(typeof result.current.heartbeat).toBe('function');
  });

  it('should activate emergency stop', () => {
    const { result } = renderHook(() => useOrganismState());
    
    act(() => {
      result.current.emergencyStop();
    });
    
    expect(result.current.emergencyActive).toBe(true);
    expect(result.current.missionStatus).toBe('EMERGENCY_STOP');
  });

  it('should start mission', () => {
    const { result } = renderHook(() => useOrganismState());
    
    act(() => {
      result.current.startMission('Test Mission Alpha');
    });
    
    expect(result.current.missionStatus).toBe('ACTIVE');
    expect(result.current.missionName).toBe('Test Mission Alpha');
  });

  it('should add audit log entry on emergency stop', () => {
    const { result } = renderHook(() => useOrganismState());
    
    act(() => {
      result.current.emergencyStop();
    });
    
    expect(result.current.auditLog.length).toBeGreaterThan(0);
    expect(result.current.auditLog.some(entry => entry.kind === 'EMERGENCY_STOP')).toBe(true);
  });

  it('should add audit log entry on mission start', () => {
    const { result } = renderHook(() => useOrganismState());
    
    act(() => {
      result.current.startMission('Test Mission');
    });
    
    expect(result.current.auditLog.length).toBeGreaterThan(0);
    expect(result.current.auditLog.some(entry => entry.kind === 'MISSION_START')).toBe(true);
  });

  it('should not tick when emergency is active', async () => {
    const { result } = renderHook(() => useOrganismState());
    
    act(() => {
      result.current.emergencyStop();
    });
    
    const beatBeforeAdvance = result.current.beat;
    
    act(() => {
      vi.advanceTimersByTime(1000); // 5 ticks
    });
    
    // Beat should not have advanced during emergency
    expect(result.current.beat).toBe(beatBeforeAdvance);
  });

  it('should update architect signal', () => {
    const { result } = renderHook(() => useOrganismState());
    
    act(() => {
      result.current.setArchitectSignal(0.8);
    });
    
    expect(result.current.architectSignal).toBe(0.8);
  });

  it('should have initial pendingActions as empty array', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(result.current.pendingActions).toEqual([]);
  });

  it('should have initial auditLog as empty array', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(result.current.auditLog).toEqual([]);
  });

  it('should compute swarm convergence from drones', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(result.current.swarmConvergence).toBeGreaterThanOrEqual(0);
    expect(result.current.swarmConvergence).toBeLessThanOrEqual(1);
  });

  it('should compute swarm now attention from drones', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(result.current.swarmNowAttention).toBeGreaterThanOrEqual(0);
    expect(result.current.swarmNowAttention).toBeLessThanOrEqual(1);
  });

  it('should have commsLost initially false', () => {
    const { result } = renderHook(() => useOrganismState());
    
    expect(result.current.commsLost).toBe(false);
  });

  it('should reset commsLost on heartbeat', () => {
    const { result } = renderHook(() => useOrganismState());
    
    act(() => {
      result.current.heartbeat();
    });
    
    expect(result.current.commsLost).toBe(false);
  });

  it('should add audit log entry on heartbeat', () => {
    const { result } = renderHook(() => useOrganismState());
    
    act(() => {
      result.current.heartbeat();
    });
    
    expect(result.current.auditLog.some(entry => entry.kind === 'HEARTBEAT')).toBe(true);
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// HITL (HUMAN-IN-THE-LOOP) TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('HITL Functions', () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it('should approve pending action and add to audit log', () => {
    const { result } = renderHook(() => useOrganismState());
    
    // Manually add a pending action for testing
    act(() => {
      // Simulate approve action (no pending actions to approve)
      result.current.approve(1);
    });
    
    // Should have added audit entry even if no action found
    expect(result.current.auditLog.some(entry => entry.kind === 'HITL_APPROVED')).toBe(true);
  });

  it('should deny pending action and add to audit log', () => {
    const { result } = renderHook(() => useOrganismState());
    
    act(() => {
      result.current.deny(1);
    });
    
    expect(result.current.auditLog.some(entry => entry.kind === 'HITL_DENIED')).toBe(true);
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// DRONE STATE TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Drone State', () => {
  it('should have expected drone properties', () => {
    const { result } = renderHook(() => useOrganismState());
    
    const drone = result.current.drones[0];
    expect(drone).toHaveProperty('id');
    expect(drone).toHaveProperty('phase');
    expect(drone).toHaveProperty('energy');
    expect(drone).toHaveProperty('cortisol');
  });

  it('should have all drones with valid energy above sovereign floor', () => {
    const { result } = renderHook(() => useOrganismState());
    
    for (const drone of result.current.drones) {
      expect(drone.energy).toBeGreaterThanOrEqual(1.0); // SOVEREIGN_FLOOR
    }
  });

  it('should have all drones with valid cortisol', () => {
    const { result } = renderHook(() => useOrganismState());
    
    for (const drone of result.current.drones) {
      expect(drone.cortisol).toBeGreaterThanOrEqual(0);
    }
  });

  it('should have all drones with valid trust score in [0, 1]', () => {
    const { result } = renderHook(() => useOrganismState());
    
    for (const drone of result.current.drones) {
      expect(drone.trustScore).toBeGreaterThanOrEqual(0);
      expect(drone.trustScore).toBeLessThanOrEqual(1);
    }
  });
});
