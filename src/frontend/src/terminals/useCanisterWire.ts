// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — REAL Canister Wire Hook
// NO MOCKS. NO FAKES. NO Math.random(). REAL CANISTER DATA.
// Every terminal polls the actual swarm_brain canister backend via ICP wire.
// ═══════════════════════════════════════════════════════════════════════════════

import { useState, useEffect, useRef, useCallback } from 'react';
import {
  connectSwarmBrain,
  isConnectedToBackend,
  type SwarmBrainActor,
  type SwarmSnapshot,
  type ExtendedSnapshot,
  type SwarmQMetrics,
  type QuantumHeartbeatState,
  type CardioCerebralState,
  type GeoResonanceProtectionState,
  type CardioNeuralConversionOrganState,
  type AutonomousAnalystTeamState,
  type MemoryTempleState,
  type ConstantFeedbackCognitionState,
  type OrganismState,
} from '../canister/swarmBrainActor';

// ─── Shared types ────────────────────────────────────────────────────────────

export interface WireLogEntry {
  id: number;
  time: string;
  source: string;
  type: 'SYS' | 'DATA' | 'ALERT' | 'WIRE';
  message: string;
}

export interface WireState {
  connected: boolean;
  lastBeat: number;
  logs: WireLogEntry[];
  error: string | null;
}

// ─── Format helpers ──────────────────────────────────────────────────────────

function ts(): string {
  return new Date().toLocaleTimeString('en-US', { hour12: false });
}

function fmt(v: number, digits = 4): string {
  return v.toFixed(digits);
}

function pct(v: number): string {
  return (v * 100).toFixed(1) + '%';
}

// ─── Master wire hook — connects to real canister ────────────────────────────

export function useCanisterWire(
  domain: string,
  pollMs: number,
  extractLogs: (actor: SwarmBrainActor, beatNum: number) => Promise<WireLogEntry[]>,
) {
  const [state, setState] = useState<WireState>({
    connected: false,
    lastBeat: 0,
    logs: [],
    error: null,
  });
  const nextId = useRef(1);
  const actorRef = useRef<SwarmBrainActor | null>(null);

  const addLog = useCallback((entry: Omit<WireLogEntry, 'id'>) => {
    const log: WireLogEntry = { ...entry, id: nextId.current++ };
    setState(prev => {
      const next = [...prev.logs, log];
      return { ...prev, logs: next.length > 300 ? next.slice(-300) : next };
    });
  }, []);

  // Boot + connect
  useEffect(() => {
    let cancelled = false;

    addLog({ time: ts(), source: 'BOOT', type: 'SYS', message: `${domain} Terminal v2.0.0 — REAL WIRE MODE` });
    addLog({ time: ts(), source: 'WIRE', type: 'SYS', message: 'Connecting to swarm_brain canister...' });

    (async () => {
      try {
        const actor = await connectSwarmBrain();
        if (cancelled) return;
        actorRef.current = actor;
        const beat = await actor.getCurrentBeat();
        const beatNum = Number(beat);
        if (cancelled) return;
        setState(prev => ({ ...prev, connected: true, lastBeat: beatNum }));
        addLog({ time: ts(), source: 'WIRE', type: 'DATA', message: `CONNECTED — Beat ${beatNum} — REAL DATA ACTIVE` });
        addLog({ time: ts(), source: 'WIRE', type: 'SYS', message: 'All readings from live canister. No simulation.' });
      } catch (err) {
        if (cancelled) return;
        const msg = err instanceof Error ? err.message : String(err);
        setState(prev => ({ ...prev, error: msg }));
        addLog({ time: ts(), source: 'WIRE', type: 'ALERT', message: `Connection failed: ${msg}` });
        addLog({ time: ts(), source: 'WIRE', type: 'SYS', message: 'Retrying in 5s...' });
      }
    })();

    return () => { cancelled = true; };
  }, [domain, addLog]);

  // Polling loop — real data
  useEffect(() => {
    if (!actorRef.current) return;
    const actor = actorRef.current;

    const poll = async () => {
      try {
        const entries = await extractLogs(actor, nextId.current);
        if (entries.length > 0) {
          setState(prev => {
            const next = [...prev.logs, ...entries.map(e => ({ ...e, id: nextId.current++ }))];
            return {
              ...prev,
              logs: next.length > 300 ? next.slice(-300) : next,
              lastBeat: prev.lastBeat + 1,
            };
          });
        }
      } catch (err) {
        addLog({
          time: ts(),
          source: 'WIRE',
          type: 'ALERT',
          message: `Poll error: ${err instanceof Error ? err.message : String(err)}`,
        });
      }
    };

    const interval = setInterval(poll, pollMs);
    poll(); // first immediate poll
    return () => clearInterval(interval);
  }, [state.connected, pollMs, extractLogs, addLog]);

  return state;
}

// ═══════════════════════════════════════════════════════════════════════════════
// DOMAIN-SPECIFIC WIRE EXTRACTORS
// Each function calls REAL canister endpoints and formats log entries
// ═══════════════════════════════════════════════════════════════════════════════

// ─── DEFENSE ─────────────────────────────────────────────────────────────────

export async function extractDefenseLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [geo, cardio, feedback] = await Promise.all([
    actor.getGeoResonanceProtectionState(),
    actor.getCardioNeuralConversionOrganState(),
    actor.getConstantFeedbackCognitionState(),
  ]);

  logs.push({ id: 0, time: t, source: 'AEGIS', type: 'DATA',
    message: `Shield integrity: ${pct(cardio.shieldIntegrity)} | Protection: ${pct(geo.protectionScore)} | Threat: ${pct(geo.threatScore)}` });
  logs.push({ id: 0, time: t, source: 'WARCOM', type: 'DATA',
    message: `Defense posture: ${pct(feedback.defensePostureScore)} | Risk containment: ${pct(feedback.riskContainmentScore)} | Beat ${geo.beat}` });
  logs.push({ id: 0, time: t, source: 'CFI', type: 'DATA',
    message: `Field energy: ${fmt(geo.fieldEnergy)} | Hotspot: ${pct(geo.hotspotScore)} | Service: ${pct(geo.serviceReadiness)}` });

  if (geo.threatScore > 0.5) {
    logs.push({ id: 0, time: t, source: 'AEGIS', type: 'ALERT',
      message: `ELEVATED THREAT — score ${pct(geo.threatScore)} — helix barrier ${pct(cardio.helixBarrier)}` });
  }

  return logs;
}

// ─── MEMORY ──────────────────────────────────────────────────────────────────

export async function extractMemoryLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const mem = await actor.getMemoryTempleState();

  logs.push({ id: 0, time: t, source: 'TEMPLE', type: 'DATA',
    message: `Continuity: ${pct(mem.continuityWeave)} | Resonance: ${pct(mem.resonanceField)} | Retention: ${pct(mem.memoryRetention)}` });
  logs.push({ id: 0, time: t, source: 'PALACE', type: 'DATA',
    message: `Recall: ${pct(mem.recallReadiness)} | Cognition coupling: ${pct(mem.memoryCognitionCoupling)} | Load: ${pct(mem.cognitiveLoad)}` });

  if (mem.pedestalNames.length > 0) {
    const pedestals = mem.pedestalNames.slice(0, 5).join(', ');
    logs.push({ id: 0, time: t, source: 'TEMPLE', type: 'DATA',
      message: `Active pedestals: ${pedestals} | IoT coupling: ${pct(mem.iotCouplingScore)}` });
  }

  if (mem.narrativeSummary) {
    logs.push({ id: 0, time: t, source: 'TEMPLE', type: 'SYS', message: mem.narrativeSummary });
  }

  if (mem.memoryRetention < 0.5) {
    logs.push({ id: 0, time: t, source: 'TEMPLE', type: 'ALERT',
      message: `LOW RETENTION — ${pct(mem.memoryRetention)} — consolidation needed` });
  }

  return logs;
}

// ─── GOVERNANCE ──────────────────────────────────────────────────────────────

export async function extractGovernanceLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [feedback, compliance] = await Promise.all([
    actor.getConstantFeedbackCognitionState(),
    actor.getComplianceScore(),
  ]);

  logs.push({ id: 0, time: t, source: 'LAW', type: 'DATA',
    message: `Law continuity: ${pct(feedback.lawContinuityScore)} | Compliance: ${pct(compliance)} | Governance stability: ${pct(feedback.governanceStability)}` });
  logs.push({ id: 0, time: t, source: 'DOCTRINE', type: 'DATA',
    message: `Sovereign alignment: ${pct(feedback.sovereignAlignmentScore)} | Arbitration: ${pct(feedback.arbitrationReadiness)} | Beat ${feedback.beat}` });

  if (feedback.topActions.length > 0) {
    logs.push({ id: 0, time: t, source: 'LAW', type: 'SYS',
      message: `Priority action: ${feedback.topActions[0]}` });
  }

  if (feedback.lawContinuityScore < 0.7) {
    logs.push({ id: 0, time: t, source: 'LAW', type: 'ALERT',
      message: `LAW DRIFT — continuity ${pct(feedback.lawContinuityScore)} below threshold` });
  }

  return logs;
}

// ─── NEURAL ──────────────────────────────────────────────────────────────────

export async function extractNeuralLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [cardio, feedback] = await Promise.all([
    actor.getCardioNeuralConversionOrganState(),
    actor.getConstantFeedbackCognitionState(),
  ]);

  logs.push({ id: 0, time: t, source: 'NEURAL', type: 'DATA',
    message: `Coupling: ${pct(cardio.coupling)} | Throughput: ${pct(cardio.thoughtThroughput)} | Coherence: ${pct(cardio.outputCoherence)}` });
  logs.push({ id: 0, time: t, source: 'NEURO', type: 'DATA',
    message: `O₂ flow: ${pct(cardio.oxygenFlow)} | Perfusion: ${pct(cardio.perfusionFlow)} | Gate: ${cardio.gateOpen ? 'OPEN' : 'CLOSED'}` });
  logs.push({ id: 0, time: t, source: 'MESH', type: 'DATA',
    message: `Mesh resonance: ${pct(feedback.meshResonanceScore)} | Workforce: ${pct(feedback.workforceCoherenceScore)} | Memory: ${pct(feedback.memoryIntegrityScore)}` });

  if (!cardio.gateOpen) {
    logs.push({ id: 0, time: t, source: 'NEURAL', type: 'ALERT',
      message: `NEURAL GATE CLOSED — throughput restricted — gain ${fmt(cardio.conversionGain)}` });
  }

  return logs;
}

// ─── QUANTUM ─────────────────────────────────────────────────────────────────

export async function extractQuantumLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const qhb = await actor.getQuantumHeartbeatState();

  logs.push({ id: 0, time: t, source: 'QHB', type: 'DATA',
    message: `Phase: ${fmt(qhb.quantumPhase)} | Coherence: ${pct(qhb.quantumCoherence)} | Cardiac: ${pct(qhb.cardiacCoherence)} | Beat #${qhb.quantumBeatNumber}` });
  logs.push({ id: 0, time: t, source: 'QSOV', type: 'DATA',
    message: `QSov: ${pct(qhb.qsovScore)} | Geometric: ${fmt(qhb.qsovGeometricMean)} | Fibonacci: #${qhb.fibonacciBeatNumber}` });
  logs.push({ id: 0, time: t, source: 'PARALLAX', type: 'DATA',
    message: `Winner path: ${qhb.parallaxWinnerPath} | Score: ${pct(qhb.parallaxScore)} | Chrono: ${pct(qhb.chronoScore)}` });
  logs.push({ id: 0, time: t, source: 'ENTANGLA', type: 'DATA',
    message: `S-value: ${fmt(qhb.entanglaSValue)} | EMA: ${fmt(qhb.entanglaEMA)} | QMEM fidelity: ${pct(qhb.qmemFidelity)}` });

  if (qhb.resonexCascadeActive) {
    logs.push({ id: 0, time: t, source: 'RESONEX', type: 'ALERT',
      message: `CASCADE ACTIVE — ${qhb.resonexParticipants} participants — amplitude ${fmt(qhb.resonexAmplitude)}` });
  }

  return logs;
}

// ─── ECONOMIC ────────────────────────────────────────────────────────────────

export async function extractEconomicLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [ext, org, feedback] = await Promise.all([
    actor.getExtendedSnapshot(),
    actor.getOrganismState(),
    actor.getConstantFeedbackCognitionState(),
  ]);

  logs.push({ id: 0, time: t, source: 'FORMA', type: 'DATA',
    message: `Compliance: ${pct(ext.complianceScore)} | Hz: ${fmt(ext.hz, 2)} | Tier: ${ext.frequencyTier}` });
  logs.push({ id: 0, time: t, source: 'ECONOMY', type: 'DATA',
    message: `Economic resilience: ${pct(feedback.economicResilienceScore)} | Energy: ${pct(org.energy)} | Morale: ${pct(org.morale)}` });
  logs.push({ id: 0, time: t, source: 'TOKEN', type: 'DATA',
    message: `OMNIS: ${ext.omnisActive ? 'FIRED' : 'STANDBY'} | Count: ${ext.omnisCount} | Architect signal: ${fmt(ext.architectSignal)}` });

  return logs;
}

// ─── SWARM ───────────────────────────────────────────────────────────────────

export async function extractSwarmLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [snap, qm] = await Promise.all([
    actor.getSwarmSnapshot(),
    actor.getSwarmQMetrics(),
  ]);

  logs.push({ id: 0, time: t, source: 'SWARM', type: 'DATA',
    message: `Drones: ${snap.droneCount} | r(swarm): ${fmt(snap.rSwarm)} | J(drift): ${fmt(snap.jDrift)} | Beat: ${snap.beat}` });
  logs.push({ id: 0, time: t, source: 'KURAMOTO', type: 'DATA',
    message: `Q-Coherence: ${pct(qm.swarmQCoherence)} | Convergence: ${pct(qm.swarmConvergence)} | Now-index: ${fmt(qm.swarmNowIndex)}` });

  const sacrificedCount = snap.sacrificed.filter(Boolean).length;
  if (sacrificedCount > 0) {
    logs.push({ id: 0, time: t, source: 'SWARM', type: 'ALERT',
      message: `${sacrificedCount} drones sacrificed — fleet strength ${snap.droneCount - sacrificedCount} active` });
  }

  if (snap.droneCount > 0) {
    const avgPhase = snap.phases.reduce((a, b) => a + b, 0) / snap.phases.length;
    const avgSignal = snap.signals.reduce((a, b) => a + b, 0) / snap.signals.length;
    logs.push({ id: 0, time: t, source: 'FLEET', type: 'DATA',
      message: `Mean phase: ${fmt(avgPhase)} | Mean signal: ${fmt(avgSignal)} | Classes: ${[...new Set(snap.classes)].join(', ')}` });
  }

  return logs;
}

// ─── COGNITIVE ───────────────────────────────────────────────────────────────

export async function extractCognitiveLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const fb = await actor.getConstantFeedbackCognitionState();

  logs.push({ id: 0, time: t, source: 'COGNITION', type: 'DATA',
    message: `Pressure: ${pct(fb.cognitivePressure)} | Loop closure: ${pct(fb.loopClosureScore)} | Reinjection: ${pct(fb.reinjectionIntegrity)}` });
  logs.push({ id: 0, time: t, source: 'COHERENCE', type: 'DATA',
    message: `Multi-group: ${pct(fb.multiGroupCoherence)} | Multi-organism: ${pct(fb.multiOrganismCoherence)} | Readiness: ${pct(fb.cognitionReadiness)}` });

  if (fb.narrativeSummary) {
    logs.push({ id: 0, time: t, source: 'NARRATIVE', type: 'SYS', message: fb.narrativeSummary });
  }

  if (fb.cognitivePressure > 0.8) {
    logs.push({ id: 0, time: t, source: 'COGNITION', type: 'ALERT',
      message: `HIGH PRESSURE — ${pct(fb.cognitivePressure)} — reinjection integrity ${pct(fb.reinjectionIntegrity)}` });
  }

  return logs;
}

// ─── SENSOR ──────────────────────────────────────────────────────────────────

export async function extractSensorLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const geo = await actor.getGeoResonanceProtectionState();

  logs.push({ id: 0, time: t, source: 'FIELD', type: 'DATA',
    message: `Field energy: ${fmt(geo.fieldEnergy)} | Direction: (${fmt(geo.fieldDirectionX, 2)}, ${fmt(geo.fieldDirectionY, 2)}, ${fmt(geo.fieldDirectionZ, 2)})` });
  logs.push({ id: 0, time: t, source: 'GEO', type: 'DATA',
    message: `Hotspot: ${pct(geo.hotspotScore)} | Protection: ${pct(geo.protectionScore)} | Service: ${pct(geo.serviceReadiness)}` });

  if (geo.sevenHeritageNodes.length > 0) {
    const nodes = geo.sevenHeritageNodes.map(n => fmt(n, 2)).join(' | ');
    logs.push({ id: 0, time: t, source: 'HERITAGE', type: 'DATA',
      message: `Heritage nodes: ${nodes}` });
  }

  return logs;
}

// ─── FREQUENCY ───────────────────────────────────────────────────────────────

export async function extractFrequencyLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [freq, qhb] = await Promise.all([
    actor.getFrequencyTier(),
    actor.getQuantumHeartbeatState(),
  ]);

  logs.push({ id: 0, time: t, source: 'FREQ', type: 'DATA',
    message: `Tier: ${freq.tier} | Hz: ${fmt(freq.hz, 2)} | Circadian phase: ${fmt(qhb.circadianPhase)}` });
  logs.push({ id: 0, time: t, source: 'RHYTHM', type: 'DATA',
    message: `HB variability: ${pct(qhb.heartbeatVariability)} | Circadian alignment: ${pct(qhb.circadianAlignment)} | Total heartbeats: ${qhb.totalHeartbeats}` });
  logs.push({ id: 0, time: t, source: 'BYPASS', type: 'DATA',
    message: `Bypass rhythm: ${qhb.bypassSelectedRhythm} | Temperature: ${fmt(qhb.bypassTemperature)} | Score: ${pct(qhb.bypassScore)}` });

  return logs;
}

// ─── SOVEREIGNTY ─────────────────────────────────────────────────────────────

export async function extractSovereigntyLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [org, compliance, omnis, beat] = await Promise.all([
    actor.getOrganismState(),
    actor.getComplianceScore(),
    actor.getOmnisFired(),
    actor.getCurrentBeat(),
  ]);

  logs.push({ id: 0, time: t, source: 'SOVEREIGN', type: 'DATA',
    message: `Mode: ${org.mode} | Coherence: ${pct(org.coherence)} | Trust: ${pct(org.trustScore)} | Beat: ${Number(beat)}` });
  logs.push({ id: 0, time: t, source: 'GENESIS', type: 'DATA',
    message: `Continuity: ${pct(org.continuityScore)} | Compliance: ${pct(compliance)} | OMNIS: ${omnis ? 'FIRED' : 'STANDBY'}` });

  if (org.emergencyActive) {
    logs.push({ id: 0, time: t, source: 'SOVEREIGN', type: 'ALERT',
      message: `EMERGENCY ACTIVE — anomaly ${pct(org.anomalyScore)} — morale ${pct(org.morale)}` });
  }

  return logs;
}

// ─── INTEGRATION ─────────────────────────────────────────────────────────────

export async function extractIntegrationLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [cc, cardio] = await Promise.all([
    actor.getCardioCerebralState(),
    actor.getCardioNeuralConversionOrganState(),
  ]);

  logs.push({ id: 0, time: t, source: 'CARDIO', type: 'DATA',
    message: `Resonance: ${pct(cc.resonance)} | Phase lag: ${fmt(cc.phaseLag)} | Propulsion: ${pct(cc.propulsion)}` });
  logs.push({ id: 0, time: t, source: 'CEREBRAL', type: 'DATA',
    message: `Alignment: ${pct(cc.alignment)} | Push effectiveness: ${pct(cc.pushEffectiveness)} | Beat #${cc.beatNum}` });
  logs.push({ id: 0, time: t, source: 'CONVERT', type: 'DATA',
    message: `Conversion gain: ${fmt(cardio.conversionGain)} | Direction: (${fmt(cardio.outputDirectionX, 2)}, ${fmt(cardio.outputDirectionY, 2)}, ${fmt(cardio.outputDirectionZ, 2)})` });

  return logs;
}

// ─── PACKAGING ───────────────────────────────────────────────────────────────

export async function extractPackagingLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [ext, org] = await Promise.all([
    actor.getExtendedSnapshot(),
    actor.getOrganismState(),
  ]);

  logs.push({ id: 0, time: t, source: 'SDK', type: 'DATA',
    message: `Compliance: ${pct(ext.complianceScore)} | SACE-U: ${fmt(ext.saceU)} | Sim confidence: ${pct(org.simConfidence)}` });
  logs.push({ id: 0, time: t, source: 'DEPLOY', type: 'DATA',
    message: `Energy: ${pct(org.energy)} | Tier: ${ext.frequencyTier} | Hz: ${fmt(ext.hz, 2)} | Beat: ${ext.beat}` });

  return logs;
}

// ─── INTELLIGENCE ────────────────────────────────────────────────────────────

export async function extractIntelligenceLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const analyst = await actor.getAutonomousAnalystTeamState();

  logs.push({ id: 0, time: t, source: 'ANALYST', type: 'DATA',
    message: `Learning: ${pct(analyst.learningScore)} | Adaptation: ${pct(analyst.adaptationScore)} | Priority: ${pct(analyst.recommendationPriority)}` });

  if (analyst.narrativeSummary) {
    logs.push({ id: 0, time: t, source: 'NARRATIVE', type: 'SYS', message: analyst.narrativeSummary });
  }
  if (analyst.heartNarrative) {
    logs.push({ id: 0, time: t, source: 'HEART', type: 'DATA', message: analyst.heartNarrative });
  }
  if (analyst.brainNarrative) {
    logs.push({ id: 0, time: t, source: 'BRAIN', type: 'DATA', message: analyst.brainNarrative });
  }
  if (analyst.defenseNarrative) {
    logs.push({ id: 0, time: t, source: 'DEFENSE', type: 'DATA', message: analyst.defenseNarrative });
  }

  if (analyst.topRecommendations.length > 0) {
    for (const rec of analyst.topRecommendations.slice(0, 3)) {
      logs.push({ id: 0, time: t, source: 'RECOM', type: 'SYS', message: rec });
    }
  }

  if (analyst.emergencySignal > 0.5) {
    logs.push({ id: 0, time: t, source: 'ANALYST', type: 'ALERT',
      message: `EMERGENCY SIGNAL — level ${pct(analyst.emergencySignal)}` });
  }

  return logs;
}

// ─── MATH ────────────────────────────────────────────────────────────────────

export async function extractMathLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [qhb, qm] = await Promise.all([
    actor.getQuantumHeartbeatState(),
    actor.getSwarmQMetrics(),
  ]);

  logs.push({ id: 0, time: t, source: 'PHI', type: 'DATA',
    message: `Veritas parity: ${pct(qhb.veritasParityScore)} | Veritas score: ${pct(qhb.veritasScore)} | Avg coherence: ${pct(qhb.averageCoherence)}` });
  logs.push({ id: 0, time: t, source: 'QFIELD', type: 'DATA',
    message: `Resonex amplitude: ${fmt(qhb.resonexAmplitude)} | Participants: ${qhb.resonexParticipants} | Cascade: ${qhb.resonexCascadeActive ? 'YES' : 'NO'}` });
  logs.push({ id: 0, time: t, source: 'TOPOLOGY', type: 'DATA',
    message: `Swarm Q-coherence: ${pct(qm.swarmQCoherence)} | Convergence: ${pct(qm.swarmConvergence)} | Now-index: ${fmt(qm.swarmNowIndex)}` });

  if (qhb.veritasStabilizers.length > 0) {
    const stabs = qhb.veritasStabilizers.slice(0, 6).map(s => fmt(s, 3)).join(' | ');
    logs.push({ id: 0, time: t, source: 'VERITAS', type: 'DATA', message: `Stabilizers: ${stabs}` });
  }

  return logs;
}
