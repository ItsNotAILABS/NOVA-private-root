// ─── NOVA / PARALLAX — Unified Organism State Hook ───────────────────────────
// Wires SwarmCoordinator + WorldGenerator + EnterpriseHabitat into one hook.
// All math-first: law → state → gradients → morphogenesis → expression.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026

import { useState, useEffect, useRef, useCallback } from 'react';
import { SwarmCoordinator } from '../organisms/drone-mind';
import { WorldGenerator } from '../world/world-generator';
import { EnterpriseHabitat } from '../enterprise/habitat';
import {
  clamp,
  continuityScore, trustScore, anomalyScore, loadPulseScore, simulationConfidenceScore,
  computeKuramotoOrder,
} from '../math/core';

import type { DroneState, SwarmState, MacroState, WorldObject } from '../types/organism';
import type { WorldSnapshot }      from '../world/world-generator';
import type { EnterpriseSnapshot } from '../enterprise/habitat';
import type { HistorySediment, UnlockedDomain } from '../world/world-generator';

// ── Public interface ──────────────────────────────────────────────────────────
export interface OrganismState {
  // Swarm
  beat:            number;
  drones:          DroneState[];
  rSwarm:          number;
  psi:             number;
  jDrift:          number;
  swarmQCoherence: number;
  swarmConvergence: number;
  swarmNowAttention: number;

  // Scores
  continuityScore:  number;
  trustScore:       number;
  anomalyScore:     number;
  loadPulseScore:   number;
  simConfidence:    number;

  // World
  world:     WorldSnapshot | null;
  macroState: MacroState | null;

  // Enterprise
  enterprise: EnterpriseSnapshot | null;

  // Mission control
  missionStatus:   'IDLE' | 'ACTIVE' | 'EMERGENCY_STOP' | 'COMPLETE';
  missionName:     string;
  emergencyActive: boolean;
  commsLost:       boolean;
  architectSignal: number;

  // HITL
  pendingActions: import('../types/organism').HITLRequest[];
  auditLog:       import('../types/organism').AuditEntry[];

  // Controls
  setArchitectSignal: (v: number) => void;
  approve:       (id: number) => void;
  deny:          (id: number) => void;
  emergencyStop: () => void;
  startMission:  (name: string) => void;
  heartbeat:     () => void;
}

const MAX_DRONES = 12;
const TICK_MS    = 200;  // beats per 200ms (5 Hz)

// ── Hook ──────────────────────────────────────────────────────────────────────
export function useOrganismState(): OrganismState {
  // Singletons — survive re-renders
  const swarmRef     = useRef<SwarmCoordinator>(new SwarmCoordinator(MAX_DRONES));
  const worldRef     = useRef<WorldGenerator>(new WorldGenerator());
  const enterpriseRef = useRef<EnterpriseHabitat>(new EnterpriseHabitat());

  // Reactive state (display layer only)
  const [beat, setBeat]           = useState(0);
  const [drones, setDrones]       = useState<DroneState[]>(() => swarmRef.current.drones);
  const [rSwarm, setRSwarm]       = useState(0.88);
  const [psi, setPsi]             = useState(0);
  const [jDrift, setJDrift]       = useState(0);
  const [swarmQCoh, setSwarmQCoh] = useState(0.5);

  const [scores, setScores] = useState({
    continuityScore:  0.85,
    trustScore:       0.75,
    anomalyScore:     0.05,
    loadPulseScore:   0.20,
    simConfidence:    0.70,
  });

  const [world,      setWorld]      = useState<WorldSnapshot | null>(null);
  const [enterprise, setEnterprise] = useState<EnterpriseSnapshot | null>(null);

  const [missionStatus,   setMissionStatus]   = useState<OrganismState['missionStatus']>('IDLE');
  const [missionName,     setMissionName]     = useState('');
  const [emergencyActive, setEmergencyActive] = useState(false);
  const [commsLost,       setCommsLost]       = useState(false);
  const [architectSignal, setArchitectSignal] = useState(0.5);

  const [pendingActions, setPendingActions] = useState<import('../types/organism').HITLRequest[]>([]);
  const [auditLog,       setAuditLog]       = useState<import('../types/organism').AuditEntry[]>([]);

  const beatRef = useRef(0);

  // ── Master tick ─────────────────────────────────────────────────────────────
  const tick = useCallback(() => {
    if (emergencyActive) return;

    beatRef.current += 1;
    const b = beatRef.current;

    // 1. Swarm tick (Kuramoto + neuro + brain + quantum)
    const swarmResult = swarmRef.current.tick(architectSignal);
    const { drones: newDrones, rSwarm: r, psi: p, jDrift: j, swarmQCoherence: sqc } = swarmResult;

    // 2. Swarm aggregates for world + enterprise
    const active = newDrones.filter(d => !d.sacrificed);
    const n      = active.length || 1;
    const meanEnergy   = active.reduce((s, d) => s + d.energy, 0) / n;
    const meanCortisol = active.reduce((s, d) => s + d.cortisol, 0) / n;
    const meanTrust    = active.reduce((s, d) => s + d.trustScore, 0) / n;
    const meanAnomaly  = active.reduce((s, d) => s + d.anomalyScore, 0) / n;
    const meanTraffic  = active.reduce((s, d) => s + Math.sqrt(d.velX ** 2 + d.velZ ** 2), 0) / n;
    const swarmConv    = active.reduce((s, d) => s + d.qConvergence, 0) / n;
    const swarmNowAtt  = active.reduce((s, d) => s + d.nowAttention, 0) / n;

    // 3. Scores
    const Kc = continuityScore({
      contextGap:          clamp(j / 3, 0, 1),
      lostReferences:      clamp(1 - r, 0, 1),
      contradictionBurden: 0.05,
      handoffBreakage:     0.05,
      memoryDecay:         0.02,
    });
    const Ts = trustScore({
      continuityQuality:     Kc,
      lineageCompleteness:   clamp(meanEnergy / 2, 0, 1),
      reviewConfidence:      r,
      anomalyBurden:         meanAnomaly,
      versionConflictBurden: clamp(j / 3, 0, 1),
    });
    const As = anomalyScore({
      mahalanobisAbnormality: clamp(meanAnomaly, 0, 1),
      isolationForestSignal:  clamp(1 - r, 0, 1),
      zScoreExcursion:        clamp(j / 3, 0, 1),
      fingerprintDeviation:   0.05,
    });
    const Lp = loadPulseScore({
      queueBurden:        clamp(pendingActions.length / 10, 0, 1),
      notificationBurden: clamp(j / 2, 0, 1),
      blockerBurden:      commsLost ? 0.8 : 0.1,
      anomalyBurden:      As,
      workloadPressure:   clamp(meanCortisol - 1, 0, 1),
    });
    const Sc = simulationConfidenceScore(Kc, Ts, As, r);

    // 4. World tick (every 5 beats to save CPU)
    let newWorld: WorldSnapshot | null = null;
    if (b % 5 === 0) {
      newWorld = worldRef.current.tick(b, { rSwarm: r, jDrift: j, meanEnergy, meanCortisol, meanTrust, meanAnomaly, meanTraffic });
    }

    // 5. Enterprise tick (every 3 beats)
    let newEnterprise: EnterpriseSnapshot | null = null;
    if (b % 3 === 0) {
      newEnterprise = enterpriseRef.current.tick(b, r, j, meanTrust, meanAnomaly);
    }

    // 6. HITL generation (occasional cortisol spikes)
    if (meanCortisol > 1.5 && pendingActions.length < 5 && b % 30 === 0) {
      const actionDrone = active.find(d => d.cortisol === Math.max(...active.map(a => a.cortisol)));
      if (actionDrone) {
        const req: import('../types/organism').HITLRequest = {
          id:       b,
          droneId:  actionDrone.id,
          action:   'HIGH_CORTISOL_INTERVENTION',
          reason:   `Cortisol ${actionDrone.cortisol.toFixed(2)} > 1.5 — review drone state`,
          urgency:  clamp((actionDrone.cortisol - 1) / 2, 0, 1),
          deadline: Date.now() + 30000,
        };
        setPendingActions(prev => [...prev, req]);
      }
    }

    // Remove expired HITL
    const now = Date.now();
    setPendingActions(prev => prev.filter(r => r.deadline > now));

    // 7. React state update (batch)
    setBeat(b);
    setDrones(newDrones);
    setRSwarm(r);
    setPsi(p);
    setJDrift(j);
    setSwarmQCoh(sqc);
    setScores({ continuityScore: Kc, trustScore: Ts, anomalyScore: As, loadPulseScore: Lp, simConfidence: Sc });
    if (newWorld)      setWorld(newWorld);
    if (newEnterprise) setEnterprise(newEnterprise);

    // Comms-lost check
    setCommsLost(r < 0.52);
  }, [architectSignal, emergencyActive, pendingActions.length, commsLost]);

  // ── Timer loop ───────────────────────────────────────────────────────────────
  useEffect(() => {
    const id = setInterval(tick, TICK_MS);
    return () => clearInterval(id);
  }, [tick]);

  // ── Controls ──────────────────────────────────────────────────────────────────
  const approve = useCallback((id: number) => {
    setPendingActions(prev => prev.filter(r => r.id !== id));
    setAuditLog(prev => [...prev.slice(-99), { beat: beatRef.current, kind: 'HITL_APPROVED', message: `Action ${id} approved`, ts: Date.now() }]);
  }, []);

  const deny = useCallback((id: number) => {
    setPendingActions(prev => prev.filter(r => r.id !== id));
    setAuditLog(prev => [...prev.slice(-99), { beat: beatRef.current, kind: 'HITL_DENIED', message: `Action ${id} denied`, ts: Date.now() }]);
  }, []);

  const emergencyStop = useCallback(() => {
    setEmergencyActive(true);
    setMissionStatus('EMERGENCY_STOP');
    swarmRef.current.emergencyStop();
    setAuditLog(prev => [...prev.slice(-99), { beat: beatRef.current, kind: 'EMERGENCY_STOP', message: 'Emergency stop activated', ts: Date.now() }]);
  }, []);

  const startMission = useCallback((name: string) => {
    setMissionName(name);
    setMissionStatus('ACTIVE');
    setEmergencyActive(false);
    setAuditLog(prev => [...prev.slice(-99), { beat: beatRef.current, kind: 'MISSION_START', message: `Mission: ${name}`, ts: Date.now() }]);
  }, []);

  const heartbeat = useCallback(() => {
    setCommsLost(false);
    setAuditLog(prev => [...prev.slice(-99), { beat: beatRef.current, kind: 'HEARTBEAT', message: 'Manual heartbeat', ts: Date.now() }]);
  }, []);

  return {
    beat,
    drones,
    rSwarm,
    psi,
    jDrift,
    swarmQCoherence:    swarmQCoh,
    swarmConvergence:   drones.filter(d => !d.sacrificed).reduce((s, d) => s + d.qConvergence, 0) / Math.max(drones.filter(d => !d.sacrificed).length, 1),
    swarmNowAttention:  drones.filter(d => !d.sacrificed).reduce((s, d) => s + d.nowAttention, 0) / Math.max(drones.filter(d => !d.sacrificed).length, 1),
    ...scores,
    world,
    macroState: world?.macro ?? null,
    enterprise,
    missionStatus,
    missionName,
    emergencyActive,
    commsLost,
    architectSignal,
    pendingActions,
    auditLog,
    setArchitectSignal,
    approve,
    deny,
    emergencyStop,
    startMission,
    heartbeat,
  };
}
