// Swarm state hook — self-hosted local simulation
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.

import { useState, useEffect, useRef, useCallback } from 'react';

// ─── CONSTANTS ────────────────────────────────────────────────────────────────
const MAX_DRONES   = 12;
const HELIX_ALPHA  = 0.01;   // Hebbian inter-drone learning rate
const W_CEIL       = 2.0;    // Hebbian weight ceiling
const KURAMOTO_K   = 0.618;  // Kuramoto coupling constant
const BRAIN_NODES  = 6;      // 0=SENSOR 1=MEMORY 2=EXECUTIVE 3=EMOTIONAL 4=MOTOR 5=OUTPUT
const STDP_ALPHA   = 0.005;  // STDP learning rate
const STDP_DECAY   = 0.001;  // STDP weight decay
const DT           = 0.05;   // ODE integration step (beats)

// ─── MATH PRIMITIVES ─────────────────────────────────────────────────────────
function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }
function sf(x) { return Math.max(1.0, x); }   // sovereign floor
function sigmoid(x) { return 1.0 / (1.0 + Math.exp(-clamp(x, -10, 10))); }

// ─── NEUROCHEMICAL BASELINES ─────────────────────────────────────────────────
const CHEM_BASELINES = {
  SCOUT:     [1.0, 1.0, 1.5, 1.0],
  STRIKER:   [1.0, 1.3, 1.2, 1.0],
  GUARDIAN:  [1.0, 1.1, 1.0, 1.5],
  RELAY:     [1.5, 1.0, 1.0, 1.0],
  MEDIC:     [1.0, 1.0, 1.0, 1.5],
  SOVEREIGN: [1.2, 1.2, 1.2, 1.2],
};

// ─── DRONE FACTORY ───────────────────────────────────────────────────────────
function makeDrone(id) {
  const classes = ['SCOUT', 'STRIKER', 'GUARDIAN', 'RELAY', 'MEDIC', 'SOVEREIGN'];
  const cls = id === 0 ? 'SOVEREIGN' : classes[id % classes.length];
  const [dopBase, corBase, norBase, oxyBase] = CHEM_BASELINES[cls];
  const angle  = (id / MAX_DRONES) * Math.PI * 2;
  const radius = 30 + Math.random() * 20;

  // Initial 6×6 brain weight matrix (rows=to, cols=from)
  const brainWeights = Array.from({ length: BRAIN_NODES * BRAIN_NODES }, () =>
    0.5 + Math.random() * 0.5
  );

  return {
    id,
    cls,
    posX: Math.cos(angle) * radius,
    posY: (Math.random() - 0.5) * 8,
    posZ: Math.sin(angle) * radius,
    velX: 0,
    velZ: 0,
    phase: id * 0.2,
    omega: 0.8 + Math.random() * 0.4,
    signal: 1.0,
    energy: 1.5,
    dopamine:       sf(dopBase),
    cortisol:       sf(corBase),
    norepinephrine: sf(norBase),
    oxytocin:       sf(oxyBase),
    activation: 1.0,
    sacrificed: false,
    lastBeat: 0,
    // 6-node micro-brain
    brainWeights,
    brainActivation: Array(BRAIN_NODES).fill(0.5),
  };
}

// ─── KURAMOTO ORDER PARAMETER ─────────────────────────────────────────────────
function computeRSwarm(drones) {
  const active = drones.filter(d => !d.sacrificed);
  if (!active.length) return 0.88;
  const n = active.length;
  const sumCos = active.reduce((s, d) => s + Math.cos(d.phase), 0) / n;
  const sumSin = active.reduce((s, d) => s + Math.sin(d.phase), 0) / n;
  return clamp(Math.sqrt(sumCos * sumCos + sumSin * sumSin), 0.5, 1.0);
}

// ─── JASMINE LYAPUNOV DRIFT ───────────────────────────────────────────────────
function computeJDrift(drones) {
  const active = drones.filter(d => !d.sacrificed);
  if (!active.length) return 0;
  const n = active.length;
  const meanPhase = active.reduce((s, d) => s + d.phase, 0) / n;
  const meanCort  = active.reduce((s, d) => s + d.cortisol, 0) / n;
  const meanSig   = active.reduce((s, d) => s + d.signal, 0) / n;
  const j1 = active.reduce((s, d) => s + 0.4 * (d.phase - meanPhase) ** 2, 0) / n;
  const j2 = active.reduce((s, d) => s + 0.3 * (d.cortisol - meanCort) ** 2, 0) / n;
  const j3 = active.reduce((s, d) => s + 0.3 * (d.signal - meanSig) ** 2, 0) / n;
  return j1 + j2 + j3;
}

// ─── 6-NODE BRAIN FORWARD PASS ────────────────────────────────────────────────
// Nodes: 0=SENSOR 1=MEMORY 2=EXECUTIVE 3=EMOTIONAL 4=MOTOR 5=OUTPUT
// Neurochemicals gate each node's bias. Two settling passes (recurrent).
function brainForwardPass(drone, architectSignal) {
  const { dopamine: D, cortisol: C, norepinephrine: N, oxytocin: O, brainWeights } = drone;
  // Neurochemical biases (each chem's excess above 1.0 modulates its node)
  const bias = [
    N * 0.25,                          // SENSOR:     arousal sharpens sensing
    D * 0.20,                          // MEMORY:     dopamine consolidates
    D * 0.15 - C * 0.10,              // EXECUTIVE:  reward enables, stress impairs
    C * 0.30 + N * 0.20,              // EMOTIONAL:  stress + arousal
    N * 0.35,                          // MOTOR:      arousal drives action
    O * 0.20 + architectSignal * 0.30, // OUTPUT:     cohesion + external command
  ];
  let act = [...drone.brainActivation];
  // 2 forward settling passes through the 6×6 recurrent matrix
  for (let pass = 0; pass < 2; pass++) {
    const next = Array(BRAIN_NODES).fill(0);
    for (let i = 0; i < BRAIN_NODES; i++) {
      let sum = bias[i];
      for (let j = 0; j < BRAIN_NODES; j++) {
        sum += brainWeights[i * BRAIN_NODES + j] * act[j];
      }
      next[i] = sigmoid(sum);
    }
    act = next;
  }
  return act; // [activation_0 .. activation_5]
}

// ─── STDP WEIGHT UPDATE ───────────────────────────────────────────────────────
// Δw_ij = α · (pre · post) − decay · w_ij   (BCM-like unsupervised Hebbian)
function stdpUpdate(weights, activations) {
  return weights.map((w, idx) => {
    const i = Math.floor(idx / BRAIN_NODES);
    const j = idx % BRAIN_NODES;
    const dw = STDP_ALPHA * activations[i] * activations[j] - STDP_DECAY * w;
    return clamp(w + dw, 0.1, 3.0);
  });
}

// ─── COUPLED NEUROCHEMICAL ODEs ───────────────────────────────────────────────
// 4-species system: DOPAMINE, CORTISOL, NOREPINEPHRINE, OXYTOCIN
// Euler integration with dt = DT
function neurochemStep(drone, rSwarm, jDrift, meanHebb) {
  const { dopamine: D, cortisol: C, norepinephrine: N, oxytocin: O, cls, energy } = drone;
  const [dopBase, corBase, norBase, oxyBase] = CHEM_BASELINES[cls] || [1, 1, 1, 1];

  // DOPAMINE: reward signal ← swarm coherence × energy
  const dD = (0.5 * rSwarm * clamp(energy, 0, 2) - 0.15 * (D - dopBase)) * DT;

  // CORTISOL: stress ← Jasmine drift, antagonized by oxytocin
  const corExcess = Math.max(0, C - 1.0);
  const dC = (0.8 * jDrift - 0.20 * O * corExcess - 0.10 * (C - corBase)) * DT;

  // NOREPINEPHRINE: arousal ← cortisol above class baseline
  const dN = (0.6 * Math.max(0, C - corBase) - 0.25 * (N - norBase)) * DT;

  // OXYTOCIN: bonding ← Hebbian proximity + coherence
  const dO = (0.4 * meanHebb + 0.3 * rSwarm - 0.20 * (O - oxyBase)) * DT;

  return {
    dopamine:       sf(D + dD),
    cortisol:       sf(C + dC),
    norepinephrine: sf(N + dN),
    oxytocin:       sf(O + dO),
  };
}

// ─── ENERGY MODEL ─────────────────────────────────────────────────────────────
// Replenish over time; deplete from signaling, neural activity, movement
function energyStep(drone) {
  const REPLENISH   = 0.015;
  const SIGNAL_COST = 0.003;
  const BRAIN_COST  = 0.002;
  const MOVE_COST   = 0.005;
  const meanAct = drone.brainActivation.reduce((s, a) => s + a, 0) / BRAIN_NODES;
  const speed   = Math.sqrt(drone.velX ** 2 + drone.velZ ** 2);
  const newE = drone.energy
    + REPLENISH
    - SIGNAL_COST * drone.signal
    - BRAIN_COST  * meanAct
    - MOVE_COST   * speed;
  return clamp(newE, 0.2, 2.0);
}

// ─── REYNOLDS BOIDS FLOCKING ──────────────────────────────────────────────────
// Separation · Alignment · Cohesion · Anchor-to-formation-center
function boidsUpdate(drone, allDrones, rSwarm) {
  const SEP_R    = 15.0;
  const COH_R    = 50.0;
  const MAX_SPD  = 0.45;
  const W_SEP    = 1.5, W_ALI = 0.8, W_COH = 0.6;
  const anchorK  = 0.005 + 0.02 * rSwarm; // tighter anchor when swarm is coherent

  let [sepX, sepZ] = [0, 0];
  let [aliX, aliZ] = [0, 0];
  let [cohX, cohZ] = [0, 0];
  let nSep = 0, nAli = 0, nCoh = 0;

  for (const o of allDrones) {
    if (o.sacrificed || o.id === drone.id) continue;
    const dx = drone.posX - o.posX;
    const dz = drone.posZ - o.posZ;
    const dist = Math.sqrt(dx * dx + dz * dz) + 0.001;
    if (dist < SEP_R) { sepX += dx / dist; sepZ += dz / dist; nSep++; }
    if (dist < COH_R) {
      aliX += o.velX; aliZ += o.velZ; nAli++;
      cohX += o.posX; cohZ += o.posZ; nCoh++;
    }
  }
  if (nSep) { sepX /= nSep; sepZ /= nSep; }
  if (nAli) { aliX /= nAli; aliZ /= nAli; }
  if (nCoh) { cohX = cohX / nCoh - drone.posX; cohZ = cohZ / nCoh - drone.posZ; }

  // Anchor: weak pull to orbit center
  const ancX = -drone.posX * anchorK;
  const ancZ = -drone.posZ * anchorK;

  const forceX = W_SEP * sepX + W_ALI * aliX + W_COH * cohX + ancX;
  const forceZ = W_SEP * sepZ + W_ALI * aliZ + W_COH * cohZ + ancZ;

  // Norepinephrine modulates speed — arousal makes drones move faster
  const norExcess = Math.max(0, drone.norepinephrine - 1.0);
  const speedMod  = clamp(0.5 + 0.8 * norExcess, 0.5, 2.0);

  let newVX = drone.velX * 0.85 + forceX * 0.05;
  let newVZ = drone.velZ * 0.85 + forceZ * 0.05;
  const speed = Math.sqrt(newVX * newVX + newVZ * newVZ);
  if (speed > MAX_SPD * speedMod) {
    newVX = newVX / speed * MAX_SPD * speedMod;
    newVZ = newVZ / speed * MAX_SPD * speedMod;
  }
  return {
    velX: newVX,
    velZ: newVZ,
    posX: drone.posX + newVX,
    posZ: drone.posZ + newVZ,
  };
}

// ─── MAIN HOOK ────────────────────────────────────────────────────────────────
export function useSwarmState() {
  const [beat, setBeat]       = useState(0);
  const [rSwarm, setRSwarm]   = useState(0.88);
  const [jDrift, setJDrift]   = useState(0.0);
  const [drones, setDrones]   = useState(() =>
    Array.from({ length: MAX_DRONES }, (_, i) => makeDrone(i))
  );
  const [pendingActions, setPendingActions] = useState([]);
  const [auditLog, setAuditLog]             = useState([]);
  const [missionStatus, setMissionStatus]   = useState('IDLE');
  const [missionName, setMissionName]       = useState('');
  const [emergencyActive, setEmergencyActive] = useState(false);
  const [architectSignal, setArchitectSignal] = useState(1.0);
  const [commsLost, setCommsLost]           = useState(false);

  // Inter-drone Hebbian weights (swarm-level, separate from intra-brain STDP)
  const swarmWeights = useRef(
    Array.from({ length: MAX_DRONES }, () => Array(MAX_DRONES).fill(0.1))
  );
  const jRisingRef = useRef(0);
  const prevJRef   = useRef(0.0);
  const beatRef    = useRef(0);
  const nextReqId  = useRef(0);
  const pendingRef = useRef([]);

  const addLog = useCallback((kind, droneId, desc, r, j) => {
    setAuditLog(prev => {
      const entry = {
        seq: prev.length, kind, droneId,
        description: desc, rSwarm: r, jDrift: j,
        beat: beatRef.current, timestamp: Date.now(),
      };
      return [...prev.slice(-99), entry];
    });
  }, []);

  const queueAction = useCallback((droneId, action, reason, cortisol, jDrift_, rSwarm_) => {
    const windows = { SACRIFICE: 30, ENGAGE: 60, DISSOLVE: 15, ENTER_ZONE: 20, FORMATION_CHANGE: 10 };
    const req = {
      id: nextReqId.current++, droneId, action, reason, cortisol,
      jDrift: jDrift_, rSwarm: rSwarm_, beat: beatRef.current,
      deadline: Date.now() + (windows[action] || 30) * 1000,
      status: 'PENDING',
    };
    pendingRef.current = [...pendingRef.current, req];
    setPendingActions(prev => [...prev, req]);
    addLog('HITL_QUEUED', droneId, `${action}: ${reason}`, rSwarm_, jDrift_);
  }, [addLog]);

  const approve = useCallback((reqId) => {
    setPendingActions(prev => {
      const updated = prev.map(r => r.id === reqId ? { ...r, status: 'APPROVED' } : r);
      pendingRef.current = updated;
      return updated;
    });
    const req = pendingRef.current.find(r => r.id === reqId);
    if (req) {
      addLog('HITL_APPROVED', req.droneId, `APPROVED: ${req.action}`, req.rSwarm, req.jDrift);
      if (req.action === 'SACRIFICE') {
        setDrones(prev => prev.map(d =>
          d.id !== req.droneId ? d : { ...d, sacrificed: true, activation: 1.0 }
        ));
        addLog('DRONE_SACRIFICED', req.droneId, `Drone ${req.droneId} sacrificed`, req.rSwarm, req.jDrift);
      }
    }
  }, [addLog]);

  const deny = useCallback((reqId) => {
    setPendingActions(prev => {
      const updated = prev.map(r => r.id === reqId ? { ...r, status: 'DENIED' } : r);
      pendingRef.current = updated;
      return updated;
    });
    const req = pendingRef.current.find(r => r.id === reqId);
    if (req) addLog('HITL_DENIED', req.droneId, `DENIED: ${req.action}`, req.rSwarm, req.jDrift);
  }, [addLog]);

  const emergencyStop = useCallback(() => {
    setEmergencyActive(true);
    setMissionStatus('EMERGENCY_STOP');
    addLog('EMERGENCY_STOP', null, 'Emergency stop activated', 0, 0);
  }, [addLog]);

  const startMission = useCallback((name) => {
    if (emergencyActive) return;
    setMissionStatus('ACTIVE');
    setMissionName(name);
    addLog('MISSION_START', null, `Mission started: ${name}`, 0, 0);
  }, [emergencyActive, addLog]);

  // ─── SIMULATION TICK ────────────────────────────────────────────────────────
  useEffect(() => {
    const interval = setInterval(() => {
      if (emergencyActive) return;

      beatRef.current += 1;
      const b = beatRef.current;
      setBeat(b);

      setDrones(prev => {
        // ── Step 1: Kuramoto phase update ────────────────────────────────────
        let next = prev.map(d => {
          if (d.sacrificed) return d;
          const active = prev.filter(o => !o.sacrificed && o.id !== d.id);
          const kuramotoSum = active.reduce((s, o) => s + Math.sin(o.phase - d.phase), 0);
          const dTheta = d.omega + (KURAMOTO_K / prev.length) * kuramotoSum;
          return { ...d, phase: d.phase + dTheta * 0.05, lastBeat: b };
        });

        // ── Step 2: Inter-drone Hebbian learning (swarm weights) ─────────────
        for (let i = 0; i < next.length; i++) {
          for (let j = i + 1; j < next.length; j++) {
            if (next[i].sacrificed || next[j].sacrificed) continue;
            const dx = next[i].posX - next[j].posX;
            const dz = next[i].posZ - next[j].posZ;
            const dist = Math.sqrt(dx * dx + dz * dz) + 0.001;
            const proximity = 1.0 / (1.0 + dist / 10.0);
            const w = swarmWeights.current[i][j];
            const delta = HELIX_ALPHA * next[i].signal * next[j].signal * (1.0 - w / W_CEIL) * proximity;
            swarmWeights.current[i][j] = Math.min(W_CEIL, w + delta);
            swarmWeights.current[j][i] = swarmWeights.current[i][j];
          }
        }

        // ── Step 3: Compute collective metrics (needed for ODEs) ─────────────
        const r  = computeRSwarm(next);
        const jd = computeJDrift(next);
        setRSwarm(r);
        setJDrift(jd);

        // ── Step 4: Neurochemical ODEs + Brain pass + STDP + Energy + Boids ──
        next = next.map(d => {
          if (d.sacrificed) return d;

          // Mean Hebbian weight to active neighbors (drives oxytocin)
          const activeNeighbors = next.filter(o => !o.sacrificed && o.id !== d.id);
          const meanHebb = activeNeighbors.length > 0
            ? activeNeighbors.reduce((s, o) => s + swarmWeights.current[d.id][o.id], 0)
              / activeNeighbors.length
            : 0.1;

          // 4-species neurochemical ODE step
          const chem = neurochemStep(d, r, jd, meanHebb);

          // 6-node brain forward pass with updated neurochemicals
          const brainActivation = brainForwardPass({ ...d, ...chem }, architectSignal);

          // STDP: update intra-brain weights
          const brainWeights = stdpUpdate(d.brainWeights, brainActivation);

          // Signal = OUTPUT node activation × energy (Law 23 + brain output)
          const outputAct = brainActivation[5]; // OUTPUT node
          const newSignal = sf(outputAct * d.energy * architectSignal);

          // Energy model
          const energy = energyStep({ ...d, signal: newSignal, brainActivation });

          // Reynolds boids position + velocity
          const { velX, velZ, posX, posZ } = boidsUpdate(
            { ...d, velX: d.velX, velZ: d.velZ, norepinephrine: chem.norepinephrine },
            next, r
          );

          return {
            ...d,
            ...chem,
            brainActivation,
            brainWeights,
            signal: newSignal,
            energy,
            velX,
            velZ,
            posX,
            posZ,
            activation: sf(outputAct * energy),
          };
        });

        // ── Step 5: Jasmine correction ────────────────────────────────────────
        if (jd > prevJRef.current) {
          jRisingRef.current++;
        } else {
          jRisingRef.current = 0;
        }
        prevJRef.current = jd;

        if (jRisingRef.current >= 3) {
          jRisingRef.current = 0;
          const active = next.filter(x => !x.sacrificed);
          const meanPhase = active.reduce((s, x) => s + x.phase, 0) / (active.length || 1);
          next = next.map(d => {
            if (d.sacrificed) return d;
            return {
              ...d,
              phase:    d.phase * 0.9 + meanPhase * 0.1,
              oxytocin: sf(d.oxytocin + 0.05),
              cortisol: sf(d.cortisol - 0.03),
            };
          });
          addLog('JASMINE_CORRECT', null, `Jasmine fired r=${r.toFixed(3)} J=${jd.toFixed(3)}`, r, jd);
        }

        // ── Step 6: Sacrifice doctrine + OMNIS log ────────────────────────────
        next.forEach(d => {
          if (!d.sacrificed && d.cortisol > 1.5) {
            const alreadyQueued = pendingRef.current.some(
              p => p.droneId === d.id && p.action === 'SACRIFICE' && p.status === 'PENDING'
            );
            if (!alreadyQueued) {
              queueAction(d.id, 'SACRIFICE',
                `D${d.id} cortisol=${d.cortisol.toFixed(2)} exceeds threshold`,
                d.cortisol, jd, r
              );
            }
          }
        });

        if (r >= 0.98 && b % 10 === 0) {
          addLog('OMNIS_STATE', null, `OMNIS r=${r.toFixed(4)} energy=${
            (next.filter(x=>!x.sacrificed).reduce((s,x)=>s+x.energy,0)/next.filter(x=>!x.sacrificed).length).toFixed(2)
          }`, r, jd);
        }

        return next;
      });

      // Expire pending actions
      setPendingActions(prev => {
        const updated = prev.map(r =>
          r.status === 'PENDING' && Date.now() > r.deadline
            ? { ...r, status: 'EXPIRED' } : r
        );
        pendingRef.current = updated;
        return updated;
      });
    }, 500);

    return () => clearInterval(interval);
  }, [emergencyActive, architectSignal, queueAction, addLog]);

  return {
    beat,
    rSwarm,
    jDrift,
    drones,
    pendingActions: pendingActions.filter(r => r.status === 'PENDING'),
    allActions: pendingActions,
    auditLog,
    missionStatus,
    missionName,
    emergencyActive,
    architectSignal,
    commsLost,
    swarmWeights: swarmWeights.current,
    approve,
    deny,
    emergencyStop,
    startMission,
    setArchitectSignal,
    setMissionStatus,
  };
}
