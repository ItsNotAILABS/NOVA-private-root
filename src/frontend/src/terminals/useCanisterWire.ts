// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — REAL Canister Wire Hook
// NO MOCKS. NO FAKES. NO Math.random(). REAL CANISTER DATA.
// Every terminal polls the actual swarm_brain canister backend via ICP wire.
// ═══════════════════════════════════════════════════════════════════════════════

import { useState, useEffect, useRef, useCallback } from 'react';
import {
  connectSwarmBrain,
  type SwarmBrainActor,
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

  const [aegis, war, cf, od] = await Promise.all([
    actor.getAEGISState(),
    actor.getWarDefenseModeState(),
    actor.getCounterforceStatus(),
    actor.getOffenseDefenseStatus(),
  ]);

  logs.push({ id: 0, time: t, source: 'AEGIS', type: 'DATA',
    message: `Threat: ${fmt(aegis.threatLevel)} | Active: ${aegis.defenseActive} | Last alert beat: ${aegis.lastAlertBeat}` });
  logs.push({ id: 0, time: t, source: 'WARCOM', type: 'DATA',
    message: `Mode: ${war.mode} | Posture: ${war.posture} | Threat: ${pct(war.threatScore)} | Gate: ${pct(war.gateStrictness)}` });
  logs.push({ id: 0, time: t, source: 'WARCOM', type: 'DATA',
    message: `Continuity: ${pct(war.continuityScore)} | Coherence: ${pct(war.coherenceScore)} | Integrity: ${pct(war.integrityScore)}` });
  logs.push({ id: 0, time: t, source: 'CFI', type: 'DATA',
    message: `Effectiveness: ${pct(cf.overallEffectiveness)} | Scouts: ${pct(cf.scoutCoverage)} | Hunter: ${pct(cf.hunterSuccessRate)} | Campaigns: ${cf.activeCampaigns}` });
  logs.push({ id: 0, time: t, source: 'OFFENSE', type: 'DATA',
    message: `Off: ${pct(od.offensivePower)} | Def: ${pct(od.defensivePower)} | Balance: ${pct(od.offenseDefenseBalance)} | Drones: ${od.dronesDeployed}` });

  if (war.threatScore > 0.5) {
    logs.push({ id: 0, time: t, source: 'AEGIS', type: 'ALERT',
      message: `ELEVATED THREAT — ${pct(war.threatScore)} — lockdown: ${war.interfaceLockdown} — shields: ${od.shieldStrength.toFixed(3)}` });
  }

  return logs;
}

// ─── MEMORY ──────────────────────────────────────────────────────────────────

export async function extractMemoryLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [temple, sys, mem] = await Promise.all([
    actor.getMemoryTempleState(),
    actor.getMemorySystemState(),
    actor.getMemoryState(),
  ]);

  logs.push({ id: 0, time: t, source: 'TEMPLE', type: 'DATA',
    message: `Continuity: ${pct(temple.continuityWeave)} | Resonance: ${pct(temple.resonanceField)} | Retention: ${pct(temple.memoryRetention)}` });
  logs.push({ id: 0, time: t, source: 'SYSTEM', type: 'DATA',
    message: `QMEM fidelity: ${pct(sys.qmemFidelity)} | T2: ${fmt(sys.qmemT2Time)} | Dream: ${sys.dreamCycleActive} | Rest: ${sys.isRestState}` });
  logs.push({ id: 0, time: t, source: 'PLASTICITY', type: 'DATA',
    message: `BDNF: ${pct(sys.bdnfLevel)} | NGF: ${pct(sys.ngfLevel)} | Potentiation: ${pct(sys.memoryPotentiation)} | Rate: ${pct(sys.plasticityRate)}` });
  logs.push({ id: 0, time: t, source: 'SHELL', type: 'DATA',
    message: `Shell3 nodes: ${sys.shell3ActiveNodes} (avg: ${pct(sys.shell3AverageActivation)}) | Shell12 nodes: ${sys.shell12ActiveNodes} (avg: ${pct(sys.shell12AverageActivation)})` });
  logs.push({ id: 0, time: t, source: 'PALACE', type: 'DATA',
    message: `Traces: ${mem.traceCount} | Transfer: ${pct(sys.shell3ToShell12TransferRate)} | Retrieval: ${pct(sys.shell12ToShell3RetrievalRate)}` });

  if (temple.pedestalNames.length > 0) {
    logs.push({ id: 0, time: t, source: 'TEMPLE', type: 'DATA',
      message: `Pedestals: ${temple.pedestalNames.slice(0, 5).join(', ')}` });
  }

  if (temple.narrativeSummary) {
    logs.push({ id: 0, time: t, source: 'TEMPLE', type: 'SYS', message: temple.narrativeSummary });
  }

  return logs;
}

// ─── GOVERNANCE ──────────────────────────────────────────────────────────────

export async function extractGovernanceLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [law, snap, sec] = await Promise.all([
    actor.getLawComplianceState(),
    actor.getLawsSnapshot(),
    actor.getSecurityStatus(),
  ]);

  logs.push({ id: 0, time: t, source: 'LAW', type: 'DATA',
    message: `Overall: ${pct(law.overallCompliance)} | G0: ${pct(law.lawGroup0Compliance)} | G1: ${pct(law.lawGroup1Compliance)} | G2: ${pct(law.lawGroup2Compliance)}` });
  logs.push({ id: 0, time: t, source: 'LAW', type: 'DATA',
    message: `G3: ${pct(law.lawGroup3Compliance)} | G4: ${pct(law.lawGroup4Compliance)} | Violations: ${law.violationCount} | Re-entrainments: ${law.totalReEntrainments}` });
  logs.push({ id: 0, time: t, source: 'DOCTRINE', type: 'DATA',
    message: `Compliance: ${pct(snap.compliance)} | Passing: ${snap.passing} | Fingerprint: ${snap.fingerprint} | Jacob's: L${snap.jacobsRung} ×${fmt(snap.multiplier, 2)}` });
  logs.push({ id: 0, time: t, source: 'SECURITY', type: 'DATA',
    message: `Score: ${pct(sec.securityScore)} | Encryption: ${pct(sec.encryptionCoverage)} | Lockdown: ${sec.lockdownActive ? sec.lockdownLevel : 'NONE'}` });

  if (law.highRiskLaws.length > 0) {
    logs.push({ id: 0, time: t, source: 'LAW', type: 'ALERT',
      message: `HIGH RISK LAWS: ${law.highRiskLaws.join(', ')} — ${law.violationCount} violations` });
  }

  return logs;
}

// ─── NEURAL ──────────────────────────────────────────────────────────────────

export async function extractNeuralLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [core, brain, nt] = await Promise.all([
    actor.getNeuralCoreState(),
    actor.getBrainRegionStates(),
    actor.getNeurotransmitterState(),
  ]);

  logs.push({ id: 0, time: t, source: 'CORE', type: 'DATA',
    message: `Synchrony: ${pct(core.globalSynchrony)} | NeuroDyn: ${pct(core.coreNeuroDynamics)} | Animal: ${pct(core.animalIntelligence)} | Status: ${core.neuralStatus}` });
  logs.push({ id: 0, time: t, source: 'STACKS', type: 'DATA',
    message: `Emergence: ${pct(core.emergenceStack)} | Cognitive: ${pct(core.cognitiveStack)} | Defense: ${pct(core.defenseStack)} | Production: ${pct(core.productionStack)}` });
  logs.push({ id: 0, time: t, source: 'BRAIN', type: 'DATA',
    message: `PFC: ${pct(brain.prefrontalControl)} | Basal: ${pct(brain.basalGangliaSelection)} | Thalamus: ${pct(brain.thalamusRelay)} | Hippocampus: ${pct(brain.hippocampusMemory)}` });
  logs.push({ id: 0, time: t, source: 'BRAIN', type: 'DATA',
    message: `Amygdala: ${pct(brain.amygdalaSalience)} | Cerebellum: ${pct(brain.cerebellumTiming)} | Fear: ${pct(brain.fearResponse)} | Reward: ${pct(brain.rewardResponse)}` });
  logs.push({ id: 0, time: t, source: 'CHEM', type: 'DATA',
    message: `GABA: ${pct(nt.gaba)} | Glut: ${pct(nt.glutamate)} | E/I: ${fmt(nt.eiRatio)} | Stress: ${pct(nt.stressLevel)} | Reward: ${pct(nt.rewardLevel)}` });
  logs.push({ id: 0, time: t, source: 'CHEM', type: 'DATA',
    message: `Cortisol: ${pct(nt.cortisol)} | Oxytocin: ${pct(nt.oxytocin)} | BDNF: ${pct(nt.bdnf)} | Plasticity: ${pct(nt.plasticityRate)}` });

  if (nt.stressLevel > 0.7) {
    logs.push({ id: 0, time: t, source: 'CHEM', type: 'ALERT',
      message: `HIGH STRESS — ${pct(nt.stressLevel)} — cortisol ${pct(nt.cortisol)} — adrenaline ${pct(nt.adrenaline)}` });
  }

  return logs;
}

// ─── QUANTUM ─────────────────────────────────────────────────────────────────

export async function extractQuantumLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [qhb, ops, spherical] = await Promise.all([
    actor.getQuantumHeartbeatState(),
    actor.getQuantumOperatorStates(),
    actor.getSphericalQuantumState(),
  ]);

  logs.push({ id: 0, time: t, source: 'QHB', type: 'DATA',
    message: `Phase: ${fmt(qhb.quantumPhase)} | Coherence: ${pct(qhb.quantumCoherence)} | Cardiac: ${pct(qhb.cardiacCoherence)} | Beat #${qhb.quantumBeatNumber}` });
  logs.push({ id: 0, time: t, source: 'QSOV', type: 'DATA',
    message: `QSov: ${pct(qhb.qsovScore)} | Geometric: ${fmt(qhb.qsovGeometricMean)} | Fibonacci: #${qhb.fibonacciBeatNumber}` });
  logs.push({ id: 0, time: t, source: 'OPERATORS', type: 'DATA',
    message: `Super: ${pct(ops.superposition)} | Entangle: ${pct(ops.entanglement)} | Interfere: ${pct(ops.interference)} | Tunnel: ${pct(ops.tunneling)}` });
  logs.push({ id: 0, time: t, source: 'OPERATORS', type: 'DATA',
    message: `Decohere: ${pct(ops.decoherence)} | Measure: ${pct(ops.measurement)} | Zeno: ${pct(ops.zeno)} | Walk: ${pct(ops.quantumWalk)} | Bell: ${pct(ops.bellViolation)}` });
  logs.push({ id: 0, time: t, source: 'SPHERICAL', type: 'DATA',
    message: `Integrity: ${pct(spherical.sphericalIntegrity)} | Vitality: ${pct(spherical.organismVitality)} | AEGIS sov: ${pct(spherical.aegisSovereignty)}` });
  logs.push({ id: 0, time: t, source: 'PARALLAX', type: 'DATA',
    message: `Winner path: ${qhb.parallaxWinnerPath} | Score: ${pct(qhb.parallaxScore)} | Chrono: ${pct(qhb.chronoScore)}` });

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

  const [econ, sys, token] = await Promise.all([
    actor.getEconomicState(),
    actor.getEconomicSystemState(),
    actor.getTokenOrganismStats(),
  ]);

  logs.push({ id: 0, time: t, source: 'FORMA', type: 'DATA',
    message: `Balance: ${fmt(sys.formaBalance)} | MRC: ${fmt(sys.mrcBalance)} | KNT: ${fmt(sys.kntBalance)} | Master: ${fmt(sys.masterAccumulator)}` });
  logs.push({ id: 0, time: t, source: 'ECONOMY', type: 'DATA',
    message: `Mint: ${fmt(econ.totalMinted)} | Multiplier: ${fmt(econ.economicMultiplier)} | Jacob's L${sys.jacobsLevel} ×${fmt(sys.jacobsMultiplier, 2)}` });
  logs.push({ id: 0, time: t, source: 'MARKET', type: 'DATA',
    message: `Greed: ${pct(sys.greedIndex)} | Fear: ${pct(sys.fearIndex)} | G/F: ${fmt(sys.greedFearRatio)} | Cascade risk: ${pct(sys.cascadeRisk)}` });
  logs.push({ id: 0, time: t, source: 'TOKEN', type: 'DATA',
    message: `Tokens: ${token.totalTokensGenerated} total / ${token.activeTokens} active | Coherence: ${pct(token.globalCoherence)} | Order: ${pct(token.orderParameter)}` });
  logs.push({ id: 0, time: t, source: 'TOKEN', type: 'DATA',
    message: `Micro: ${pct(token.microCoherence)} | Meso: ${pct(token.mesoCoherence)} | Macro: ${pct(token.macroCoherence)} | Emergence: ${token.emergenceCount}` });

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

  const [fb, pred, learn] = await Promise.all([
    actor.getConstantFeedbackCognitionState(),
    actor.getPredictionSystemState(),
    actor.getLearningSystemState(),
  ]);

  logs.push({ id: 0, time: t, source: 'COGNITION', type: 'DATA',
    message: `Pressure: ${pct(fb.cognitivePressure)} | Loop closure: ${pct(fb.loopClosureScore)} | Reinjection: ${pct(fb.reinjectionIntegrity)}` });
  logs.push({ id: 0, time: t, source: 'PREDICTION', type: 'DATA',
    message: `Error: ${fmt(pred.predictionError)} | Accuracy: ${pct(pred.predictionAccuracy)} | Kalman: ${fmt(pred.kalmanGain)} | Free energy: ${fmt(pred.freeEnergy)}` });
  logs.push({ id: 0, time: t, source: 'PREDICTION', type: 'DATA',
    message: `Short: ${fmt(pred.shortTermError)} | Medium: ${fmt(pred.mediumTermError)} | Long: ${fmt(pred.longTermError)} | Horizon: ${pred.predictionHorizon}` });
  logs.push({ id: 0, time: t, source: 'LEARNING', type: 'DATA',
    message: `TD error: ${fmt(learn.tdError)} | LR: ${fmt(learn.learningRate)} | Hebbian: ${fmt(learn.hebbianRate)} | STDP: ${learn.stdpEnabled}` });
  logs.push({ id: 0, time: t, source: 'LEARNING', type: 'DATA',
    message: `Salience: ${pct(learn.salienceLevel)} | Metaplasticity: ${pct(learn.metaplasticityFactor)} | Social boost: ${pct(learn.socialLearningBoost)}` });

  if (fb.narrativeSummary) {
    logs.push({ id: 0, time: t, source: 'NARRATIVE', type: 'SYS', message: fb.narrativeSummary });
  }

  return logs;
}

// ─── SENSOR ──────────────────────────────────────────────────────────────────

export async function extractSensorLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [eco, health] = await Promise.all([
    actor.getEcologicalState(),
    actor.getOrganismHealthReport(),
  ]);

  logs.push({ id: 0, time: t, source: 'ECOLOGY', type: 'DATA',
    message: `Prey: ${fmt(eco.lvPrey)} | Predator: ${fmt(eco.lvPredator)} | Stress: ${pct(eco.stressLevel)} | Antifragile: ${pct(eco.antifragility)}` });
  logs.push({ id: 0, time: t, source: 'ECOLOGY', type: 'DATA',
    message: `Hormetic: ${eco.hormeticZone ? 'YES' : 'NO'} | Victories: ${eco.victories}` });
  logs.push({ id: 0, time: t, source: 'HEALTH', type: 'DATA',
    message: `Vitality: ${pct(health.organismVitality)} | Spherical: ${pct(health.sphericalIntegrity)} | Neural: ${pct(health.neuralHealth)} | Quantum: ${pct(health.quantumHealth)}` });
  logs.push({ id: 0, time: t, source: 'HEALTH', type: 'DATA',
    message: `Memory: ${pct(health.memoryHealth)} | Learning: ${pct(health.learningHealth)} | Economic: ${pct(health.economicHealth)} | Defense: ${pct(health.defenseHealth)}` });
  logs.push({ id: 0, time: t, source: 'HEALTH', type: 'DATA',
    message: `Coherence: ${pct(health.coherenceScore)} | Sovereignty: ${pct(health.sovereigntyScore)} | Entropy: ${pct(health.entropyLevel)} | Beat: ${health.beat}` });

  for (const warning of health.criticalWarnings.slice(0, 3)) {
    logs.push({ id: 0, time: t, source: 'HEALTH', type: 'ALERT', message: warning });
  }

  return logs;
}

// ─── FREQUENCY ───────────────────────────────────────────────────────────────

export async function extractFrequencyLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [hz, circ, kur] = await Promise.all([
    actor.getHzSpectrumState(),
    actor.getCircadianState(),
    actor.getKuramotoState(),
  ]);

  logs.push({ id: 0, time: t, source: 'SPECTRUM', type: 'DATA',
    message: `Kore: ${fmt(hz.koreFrequency, 2)}Hz | Thalamic: ${fmt(hz.thalamicFrequency, 2)}Hz | RAS: ${fmt(hz.rasLocusFrequency, 2)}Hz | VAEL: ${fmt(hz.vaelFrequency, 2)}Hz` });
  logs.push({ id: 0, time: t, source: 'SPECTRUM', type: 'DATA',
    message: `Peak: ${fmt(hz.spectrumPeakFrequency, 2)}Hz | Avg mod: ${pct(hz.spectrumAverageModulation)} | Variance: ${fmt(hz.spectrumVariance)}` });
  logs.push({ id: 0, time: t, source: 'CIRCADIAN', type: 'DATA',
    message: `Phase: ${fmt(circ.circadianPhase)} | Time: ${fmt(circ.timeOfDay, 1)} | ${circ.isDay ? 'DAY' : 'NIGHT'} | Sleep: ${circ.sleepMode ? 'ON' : 'OFF'}` });
  logs.push({ id: 0, time: t, source: 'CIRCADIAN', type: 'DATA',
    message: `Melatonin: ${pct(circ.melatoninLevel)} | Cortisol: ${pct(circ.cortisolLevel)} | Orexin: ${pct(circ.orexinLevel)} | Adenosine: ${pct(circ.adenosineLevel)}` });
  logs.push({ id: 0, time: t, source: 'KURAMOTO', type: 'DATA',
    message: `Order: ${pct(kur.orderParam)} | Mean phase: ${fmt(kur.meanPhase)} | K: ${fmt(kur.globalK)} | Chimera: ${kur.chimera}` });

  if (circ.sleepPressure > 0.8) {
    logs.push({ id: 0, time: t, source: 'CIRCADIAN', type: 'ALERT',
      message: `HIGH SLEEP PRESSURE — ${pct(circ.sleepPressure)} — dream cycle in ${circ.beatsUntilDreamCycle} beats` });
  }

  return logs;
}

// ─── SOVEREIGNTY ─────────────────────────────────────────────────────────────

export async function extractSovereigntyLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [sov, cores, fingerprint, org] = await Promise.all([
    actor.getSovereigntyState(),
    actor.getCoreStates(),
    actor.getDoctrineFingerprint(),
    actor.getOrganismState(),
  ]);

  logs.push({ id: 0, time: t, source: 'SOVEREIGN', type: 'DATA',
    message: `Mission: ${sov.missionLock ? 'LOCKED' : 'OPEN'} | Courage: ${pct(sov.courage)} | Grounded: ${pct(sov.grounded)} | Fear: ${pct(sov.fear)}` });
  logs.push({ id: 0, time: t, source: 'SOVEREIGN', type: 'DATA',
    message: `Persistence: ${pct(sov.missionPersistence)} | Surrender floor: ${pct(sov.surrenderFloor)} | Permanent: ${pct(sov.permanentFloor)} | Streak: ×${fmt(sov.streakMultiplier, 2)}` });
  logs.push({ id: 0, time: t, source: 'CORE', type: 'DATA',
    message: `Cores: ${cores.totalCores} | Mean activation: ${pct(cores.meanActivation)} | Pheromone: ${pct(cores.pheromoneLevel)}` });
  logs.push({ id: 0, time: t, source: 'DOCTRINE', type: 'DATA',
    message: `Fingerprint: 0x${fingerprint.toString(16).toUpperCase()} | Mode: ${org.mode} | Coherence: ${pct(org.coherence)} | Trust: ${pct(org.trustScore)}` });

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

  const [shell, animal, shells] = await Promise.all([
    actor.getShellIntegrationState(),
    actor.getAnimalIntelligenceOutputs(),
    actor.getShellStates(),
  ]);

  logs.push({ id: 0, time: t, source: 'SHELL3', type: 'DATA',
    message: `Nodes: ${shell.shell3ActiveNodes} | Avg: ${pct(shell.shell3AverageActivation)} | Max: ${pct(shell.shell3MaxActivation)} | Q-phase: ${fmt(shell.shell3QuantumPhase)}` });
  logs.push({ id: 0, time: t, source: 'SHELL12', type: 'DATA',
    message: `Nodes: ${shell.shell12ActiveNodes} | Avg: ${pct(shell.shell12AverageActivation)} | Max: ${pct(shell.shell12MaxActivation)} | Q-coherence: ${pct(shell.shell12QuantumCoherence)}` });
  logs.push({ id: 0, time: t, source: 'ANIMAL', type: 'DATA',
    message: `Crow: ${pct(animal.crow)} | Octopus: ${pct(animal.octopus)} | Elephant: ${pct(animal.elephant)} | Bee: ${pct(animal.bee)} | Dolphin: ${pct(animal.dolphin)}` });
  logs.push({ id: 0, time: t, source: 'ANIMAL', type: 'DATA',
    message: `Shark: ${pct(animal.shark)} | Wolf: ${pct(animal.wolf)} | Eagle: ${pct(animal.eagle)} | Orca: ${pct(animal.orca)} | Total: ${pct(animal.totalAnimalContribution)}` });
  logs.push({ id: 0, time: t, source: 'SHELLS', type: 'DATA',
    message: `S1: ${pct(shells.shell1Coherence)} | S2: ${pct(shells.shell2BasalTone)} | S4: ${pct(shells.shell4Control)} | S8: ${pct(shells.shell8Quantum)} | S9: ${pct(shells.shell9MatriarchCoherence)}` });

  return logs;
}

// ─── PACKAGING ───────────────────────────────────────────────────────────────

export async function extractPackagingLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [ext, org, sec] = await Promise.all([
    actor.getExtendedSnapshot(),
    actor.getOrganismState(),
    actor.getSecurityStatus(),
  ]);

  logs.push({ id: 0, time: t, source: 'SDK', type: 'DATA',
    message: `Compliance: ${pct(ext.complianceScore)} | SACE-U: ${fmt(ext.saceU)} | Tier: ${ext.frequencyTier} | Hz: ${fmt(ext.hz, 2)}` });
  logs.push({ id: 0, time: t, source: 'DEPLOY', type: 'DATA',
    message: `Energy: ${pct(org.energy)} | Sim confidence: ${pct(org.simConfidence)} | Beat: ${ext.beat}` });
  logs.push({ id: 0, time: t, source: 'SECURITY', type: 'DATA',
    message: `Security: ${pct(sec.securityScore)} | Encryption: ${pct(sec.encryptionCoverage)} | Models updated: ${sec.modelsUpdated} | Ready: ${sec.readyForLaunch}` });

  return logs;
}

// ─── INTELLIGENCE ────────────────────────────────────────────────────────────

export async function extractIntelligenceLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [team, teams] = await Promise.all([
    actor.getAutonomousTeamStatus(),
    actor.getOrganismTeamsState(),
  ]);

  logs.push({ id: 0, time: t, source: 'TEAM', type: 'DATA',
    message: `Backend: ${fmt(team.backendHz, 2)}Hz | Frontend: ${fmt(team.frontendHz, 2)}Hz | Sync: ${pct(team.heartBrainSync)} | Quality: ${pct(team.regulationQuality)}` });
  logs.push({ id: 0, time: t, source: 'BRAIN', type: 'DATA',
    message: `Coherence: ${pct(team.brainCoherence)} | State: ${team.brainState} | Freq: ${fmt(team.dominantFrequency, 2)}Hz | Consciousness: ${pct(team.consciousnessLevel)}` });
  logs.push({ id: 0, time: t, source: 'BRAIN', type: 'DATA',
    message: `δ: ${pct(team.deltaPower)} | θ: ${pct(team.thetaPower)} | α: ${pct(team.alphaPower)} | β: ${pct(team.betaPower)} | γ: ${pct(team.gammaPower)}` });
  logs.push({ id: 0, time: t, source: 'ANALYSIS', type: 'DATA',
    message: `Learning: ${pct(team.learningRate)} | Adaptation: ${pct(team.adaptationSpeed)} | Cognitive load: ${pct(team.cognitiveLoad)} | Attention: ${pct(team.attentionLevel)}` });
  logs.push({ id: 0, time: t, source: 'ARCHON', type: 'DATA',
    message: `Coherence: ${pct(teams.archonCoherence)} | Consensus: ${pct(teams.archonConsensus)} | Vector convergence: ${pct(teams.vectorConvergence)}` });
  logs.push({ id: 0, time: t, source: 'FORGE', type: 'DATA',
    message: `Execution: ${pct(teams.forgeExecutionCapacity)} | Lumen accuracy: ${pct(teams.lumenWorldModelAccuracy)} | Vector passing: ${teams.vectorPassing}` });

  if (team.emergencyDetected) {
    logs.push({ id: 0, time: t, source: 'TEAM', type: 'ALERT',
      message: `EMERGENCY DETECTED — emotional state: ${team.emotionalState} — O₂: ${pct(team.oxygenLevel)}` });
  }

  return logs;
}

// ─── MATH ────────────────────────────────────────────────────────────────────

export async function extractMathLogs(actor: SwarmBrainActor): Promise<WireLogEntry[]> {
  const logs: WireLogEntry[] = [];
  const t = ts();

  const [field, qhb, qm] = await Promise.all([
    actor.getUnifiedFieldState(),
    actor.getQuantumHeartbeatState(),
    actor.getSwarmQMetrics(),
  ]);

  logs.push({ id: 0, time: t, source: 'PSI', type: 'DATA',
    message: `Ψ coherence: ${pct(field.psiCoherence)} | Ψ fear: ${pct(field.psiFear)} | Ψ economy: ${pct(field.psiEconomy)} | Ψ memory: ${pct(field.psiMemory)}` });
  logs.push({ id: 0, time: t, source: 'PSI', type: 'DATA',
    message: `Ψ sovereignty: ${pct(field.psiSovereignty)} | Golden ratio: ${fmt(field.goldenRatio)} | Fibonacci: #${field.fibonacciCurrent} | Primes: ${field.primeCount}` });
  logs.push({ id: 0, time: t, source: 'FIELD', type: 'DATA',
    message: `Permanent floor: ${pct(field.permanentFloor)} | Ancient law: ${pct(field.ancientLawCompliance)}` });
  logs.push({ id: 0, time: t, source: 'VERITAS', type: 'DATA',
    message: `Parity: ${pct(qhb.veritasParityScore)} | Score: ${pct(qhb.veritasScore)} | Avg coherence: ${pct(qhb.averageCoherence)}` });
  logs.push({ id: 0, time: t, source: 'TOPOLOGY', type: 'DATA',
    message: `Swarm Q-coherence: ${pct(qm.swarmQCoherence)} | Convergence: ${pct(qm.swarmConvergence)} | Now-index: ${fmt(qm.swarmNowIndex)}` });

  if (qhb.veritasStabilizers.length > 0) {
    const stabs = qhb.veritasStabilizers.slice(0, 6).map(s => fmt(s, 3)).join(' | ');
    logs.push({ id: 0, time: t, source: 'VERITAS', type: 'DATA', message: `Stabilizers: ${stabs}` });
  }

  return logs;
}
