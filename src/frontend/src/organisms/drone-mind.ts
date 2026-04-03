// ─── NOVA / PARALLAX — DroneMind TypeScript Class ────────────────────────────
// The cognitive model for one drone. All math mirrors the Motoko backend.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026

import {
  clamp, sf, sigmoid, wrapPhase,
  BRAIN_NODES, CHEM_BASELINES, NEURO_DT, CHAN_TAU,
  kuramotoPhaseStep, neurochemStep, brainForwardPass, brainBias,
  stdpUpdate, hebbianUpdate, energyStep, quantumChannelStep,
  trustScore, anomalyScore, loadPulseScore, computeJasmineDrift,
  mahalanobisApprox, zScore,
  applyFactionResistance, FACTION_DOMINANCE_THRESHOLD,
  PHI_INV,
} from '../math/core';

import type { DroneState, DroneClass } from '../types/organism';

// ── Faction structure for Law 24 ──────────────────────────────────────────────
interface FactionSignal {
  dominant: string;
  ratio:    number;
}

// ── DroneMind: Full cognitive organism ───────────────────────────────────────
export class DroneMind {
  private state: DroneState;
  private baseline = CHEM_BASELINES;

  constructor(id: number, cls: DroneClass) {
    this.state = DroneMind.makeDroneState(id, cls);
  }

  static makeDroneState(id: number, cls: DroneClass): DroneState {
    const base = CHEM_BASELINES[cls] ?? CHEM_BASELINES['SCOUT'];
    const angle  = (id / 12) * Math.PI * 2;
    const radius = 30 + Math.random() * 20;

    const brainWeights = Array.from(
      { length: BRAIN_NODES * BRAIN_NODES },
      () => 0.5 + Math.random() * 0.5
    );

    return {
      id,
      cls,
      posX: Math.cos(angle) * radius,
      posY: (Math.random() - 0.5) * 8,
      posZ: Math.sin(angle) * radius,
      velX: 0,
      velZ: 0,
      phase:  id * 0.2,
      omega:  0.8 + Math.random() * 0.4,
      signal: 1.0,
      energy: 1.5,
      dopamine:       sf(base.dopamine),
      cortisol:       sf(base.cortisol),
      norepinephrine: sf(base.norepinephrine),
      oxytocin:       sf(base.oxytocin),
      brainWeights,
      brainActivation: Array(BRAIN_NODES).fill(0.5),
      qAlpha:       0.5,
      qBeta:        0.5,
      qGamma:       0.5,
      qDelta:       0.5,
      qConvergence: 0.0,
      qCoherence:   0.5,
      nowAttention: 1.0,
      sacrificed:   false,
      lastBeat:     0,
      trustScore:   0.75,
      anomalyScore: 0.0,
      loadPulse:    0.2,
    };
  }

  get snapshot(): DroneState {
    return { ...this.state };
  }

  /**
   * Full per-beat cognitive update.
   * Called once per simulation beat with swarm-level context.
   */
  tick(
    beat:         number,
    allPhases:    number[],
    allSignals:   number[],
    allCortisols: number[],
    rSwarm:       number,
    jDrift:       number,
    meanHebb:     number,
    architectSignal: number,
    factionSignal: FactionSignal | null
  ): void {
    if (this.state.sacrificed) return;

    const s = this.state;
    const bl = this.baseline[s.cls] ?? this.baseline['SCOUT'];

    // ── Law 24: Faction Resistance ─────────────────────────────────────────
    let { signal, norepinephrine } = s;
    if (factionSignal && factionSignal.ratio > FACTION_DOMINANCE_THRESHOLD) {
      const applied = applyFactionResistance(signal, norepinephrine, factionSignal.ratio);
      signal          = applied.signal;
      norepinephrine  = applied.norepinephrine;
    }

    // ── Kuramoto phase update ──────────────────────────────────────────────
    const newPhase = kuramotoPhaseStep(s.phase, s.omega, allPhases, PHI_INV, NEURO_DT);

    // ── Neurochemical ODE step ─────────────────────────────────────────────
    const newChem = neurochemStep(
      { dopamine: s.dopamine, cortisol: s.cortisol, norepinephrine, oxytocin: s.oxytocin },
      bl,
      rSwarm, jDrift, s.energy, meanHebb
    );

    // ── 6-node brain forward pass ──────────────────────────────────────────
    const bias = brainBias(newChem, architectSignal);
    const newAct = brainForwardPass(s.brainActivation, s.brainWeights, bias);

    // ── STDP weight update ─────────────────────────────────────────────────
    const newWeights = stdpUpdate(s.brainWeights, newAct);

    // ── Energy step ───────────────────────────────────────────────────────
    const newEnergy = energyStep(s.energy, signal, newAct, s.velX, s.velZ);

    // ── Quantum channel update ─────────────────────────────────────────────
    const qNext = quantumChannelStep(
      { alpha: s.qAlpha, beta: s.qBeta, gamma: s.qGamma, delta: s.qDelta,
        convergence: s.qConvergence, coherence: s.qCoherence, nowAttention: s.nowAttention },
      newChem, rSwarm, NEURO_DT
    );

    // ── Score update ───────────────────────────────────────────────────────
    // Trust: continuity from convergence, lineage from energy, review from brain OUTPUT
    const ts = trustScore({
      continuityQuality:     qNext.convergence,
      lineageCompleteness:   clamp(newEnergy / 2.0, 0, 1),
      reviewConfidence:      newAct[5] ?? 0.5,
      anomalyBurden:         s.anomalyScore,
      versionConflictBurden: clamp(jDrift / 3.0, 0, 1),
    });

    // Anomaly: deviation from swarm mean
    const meanCortisol = allCortisols.reduce((a, b) => a + b, 0) / (allCortisols.length || 1);
    const cortisol_std = Math.sqrt(allCortisols.reduce((a, c) => a + (c - meanCortisol) ** 2, 0) / (allCortisols.length || 1));
    const zC = Math.abs(zScore(newChem.cortisol, meanCortisol, cortisol_std));
    const as_ = anomalyScore({
      mahalanobisAbnormality: clamp(zC / 4, 0, 1),
      isolationForestSignal:  clamp(1 - rSwarm, 0, 1),
      zScoreExcursion:        clamp(zC / 3, 0, 1),
      fingerprintDeviation:   clamp(Math.abs(newPhase - s.phase) * 2, 0, 1),
    });

    const lp = loadPulseScore({
      queueBurden:        clamp(newChem.cortisol - 1, 0, 1),
      notificationBurden: clamp(jDrift / 2, 0, 1),
      blockerBurden:      clamp(1 - newEnergy, 0, 1),
      anomalyBurden:      as_,
      workloadPressure:   clamp(1 - qNext.convergence, 0, 1),
    });

    // ── Movement toward swarm centroid (formation physics) ────────────────
    const attraction = 0.005 * (1 - rSwarm);
    const newVelX = s.velX * 0.95 - attraction * s.posX;
    const newVelZ = s.velZ * 0.95 - attraction * s.posZ;

    // ── Write back ────────────────────────────────────────────────────────
    this.state = {
      ...s,
      phase:           newPhase,
      signal,
      velX:            newVelX,
      velZ:            newVelZ,
      posX:            s.posX + newVelX,
      posZ:            s.posZ + newVelZ,
      dopamine:        newChem.dopamine,
      cortisol:        newChem.cortisol,
      norepinephrine:  newChem.norepinephrine,
      oxytocin:        newChem.oxytocin,
      energy:          newEnergy,
      brainActivation: newAct,
      brainWeights:    newWeights,
      qAlpha:          qNext.alpha,
      qBeta:           qNext.beta,
      qGamma:          qNext.gamma,
      qDelta:          qNext.delta,
      qConvergence:    qNext.convergence,
      qCoherence:      qNext.coherence,
      nowAttention:    qNext.nowAttention,
      lastBeat:        beat,
      trustScore:      ts,
      anomalyScore:    as_,
      loadPulse:       lp,
    };
  }

  /** Sacrifice this drone (e.g., defender role for swarm coherence) */
  sacrifice(): void {
    this.state = { ...this.state, sacrificed: true };
  }

  /** Re-entrain phase toward swarm mean (trophallaxis repair) */
  reEntrain(psi: number, strength: number = 0.3): void {
    const diff = wrapPhase(psi - this.state.phase);
    this.state = { ...this.state, phase: this.state.phase + strength * diff };
  }
}

// ── SwarmCoordinator ──────────────────────────────────────────────────────────
// Manages the full drone fleet, inter-drone Hebbian learning, and swarm scoring.

export class SwarmCoordinator {
  private minds: DroneMind[];
  private hebbMatrix: number[][];  // [n×n] inter-drone weights
  private beat: number = 0;

  constructor(count: number) {
    const classes: DroneClass[] = ['SOVEREIGN', 'SCOUT', 'STRIKER', 'GUARDIAN', 'RELAY', 'MEDIC'];
    this.minds = Array.from({ length: count }, (_, i) => {
      const cls: DroneClass = i === 0 ? 'SOVEREIGN' : classes[i % classes.length];
      return new DroneMind(i, cls);
    });
    this.hebbMatrix = Array.from({ length: count }, () => Array(count).fill(1.0));
  }

  get drones(): DroneState[] {
    return this.minds.map(m => m.snapshot);
  }

  tick(architectSignal: number = 0.5): {
    drones:          DroneState[];
    rSwarm:          number;
    psi:             number;
    jDrift:          number;
    swarmQCoherence: number;
    beat:            number;
  } {
    this.beat++;
    const snaps = this.drones;
    const active = snaps.filter(d => !d.sacrificed);

    // Swarm aggregates
    const allPhases    = active.map(d => d.phase);
    const allSignals   = active.map(d => d.signal);
    const allCortisols = active.map(d => d.cortisol);

    // Kuramoto order
    const n = allPhases.length || 1;
    const sumCos = allPhases.reduce((s, p) => s + Math.cos(p), 0) / n;
    const sumSin = allPhases.reduce((s, p) => s + Math.sin(p), 0) / n;
    const rSwarm = clamp(Math.sqrt(sumCos ** 2 + sumSin ** 2), 0.5, 1.0);
    const psi    = Math.atan2(sumSin, sumCos);

    // Jasmine drift
    const jDrift = computeJasmineDrift(allPhases, allCortisols, allSignals);

    // Mean Hebbian weight for this drone
    this.minds.forEach((mind, i) => {
      if (snaps[i]?.sacrificed) return;
      const row = this.hebbMatrix[i] ?? [];
      const meanHebb = row.reduce((s, w) => s + w, 0) / (row.length || 1);

      mind.tick(
        this.beat, allPhases, allSignals, allCortisols,
        rSwarm, jDrift, meanHebb, architectSignal, null
      );
    });

    // Update Hebbian matrix
    const newSnaps = this.drones;
    for (let i = 0; i < this.minds.length; i++) {
      for (let j = i + 1; j < this.minds.length; j++) {
        const si = newSnaps[i]?.signal ?? 1;
        const sj = newSnaps[j]?.signal ?? 1;
        const w  = this.hebbMatrix[i]?.[j] ?? 1.0;
        const wn = hebbianUpdate(w, si, sj);
        if (this.hebbMatrix[i]) this.hebbMatrix[i][j] = wn;
        if (this.hebbMatrix[j]) this.hebbMatrix[j][i] = wn;
      }
    }

    // Swarm Q-coherence average
    const swarmQCoherence = newSnaps.filter(d => !d.sacrificed)
      .reduce((s, d) => s + d.qCoherence, 0) / (active.length || 1);

    return { drones: newSnaps, rSwarm, psi, jDrift, swarmQCoherence, beat: this.beat };
  }

  emergencyStop(): void {
    this.minds.forEach(m => {
      // Freeze all drones — they retain memory but stop acting
    });
  }

  getHebbMatrix(): number[][] { return this.hebbMatrix; }
}
