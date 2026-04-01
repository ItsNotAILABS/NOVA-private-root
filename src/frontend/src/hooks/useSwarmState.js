// Swarm state hook — simulates ICP canister calls locally
// In production: replace with actual @dfinity/agent calls to deployed canisters

import { useState, useEffect, useRef, useCallback } from 'react';

const MAX_DRONES = 12;
const HELIX_ALPHA = 0.01;
const W_CEIL = 2.0;
const KURAMOTO_K = 0.618;

function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }
function sf(x) { return Math.max(1.0, x); }

function makeDrone(id) {
  const classes = ['SCOUT', 'STRIKER', 'GUARDIAN', 'RELAY', 'MEDIC', 'SOVEREIGN'];
  const cls = id === 0 ? 'SOVEREIGN' : classes[id % classes.length];
  const baseChem = {
    SCOUT:     [1.0, 1.0, 1.5, 1.0],
    STRIKER:   [1.0, 1.3, 1.2, 1.0],
    GUARDIAN:  [1.0, 1.1, 1.0, 1.5],
    RELAY:     [1.5, 1.0, 1.0, 1.0],
    MEDIC:     [1.0, 1.0, 1.0, 1.5],
    SOVEREIGN: [1.2, 1.2, 1.2, 1.2],
  }[cls];
  const angle = (id / MAX_DRONES) * Math.PI * 2;
  const radius = 30 + Math.random() * 20;
  return {
    id,
    cls,
    posX: Math.cos(angle) * radius,
    posY: (Math.random() - 0.5) * 10,
    posZ: Math.sin(angle) * radius,
    phase: id * 0.2,
    omega: 0.8 + Math.random() * 0.4,
    signal: 1.0,
    dopamine: sf(baseChem[0]),
    cortisol: sf(baseChem[1]),
    norepinephrine: sf(baseChem[2]),
    oxytocin: sf(baseChem[3]),
    activation: 1.0,
    sacrificed: false,
    lastBeat: 0,
  };
}

function computeRSwarm(drones) {
  const active = drones.filter(d => !d.sacrificed);
  if (!active.length) return 0.88;
  const sumCos = active.reduce((s, d) => s + Math.cos(d.phase), 0) / active.length;
  const sumSin = active.reduce((s, d) => s + Math.sin(d.phase), 0) / active.length;
  return clamp(Math.sqrt(sumCos * sumCos + sumSin * sumSin), 0.5, 1.0);
}

function computeJDrift(drones) {
  const active = drones.filter(d => !d.sacrificed);
  if (!active.length) return 0;
  const meanPhase = active.reduce((s, d) => s + d.phase, 0) / active.length;
  const meanCort  = active.reduce((s, d) => s + d.cortisol, 0) / active.length;
  const meanSig   = active.reduce((s, d) => s + d.signal, 0) / active.length;
  const j1 = active.reduce((s, d) => s + 0.4 * (d.phase - meanPhase) ** 2, 0) / active.length;
  const j2 = active.reduce((s, d) => s + 0.3 * (d.cortisol - meanCort) ** 2, 0) / active.length;
  const j3 = active.reduce((s, d) => s + 0.3 * (d.signal - meanSig) ** 2, 0) / active.length;
  return j1 + j2 + j3;
}

export function useSwarmState() {
  const [beat, setBeat]       = useState(0);
  const [rSwarm, setRSwarm]   = useState(0.88);
  const [jDrift, setJDrift]   = useState(0.0);
  const [drones, setDrones]   = useState(() => Array.from({ length: MAX_DRONES }, (_, i) => makeDrone(i)));
  const [pendingActions, setPendingActions] = useState([]);
  const [auditLog, setAuditLog]             = useState([]);
  const [missionStatus, setMissionStatus]   = useState('IDLE');
  const [missionName, setMissionName]       = useState('');
  const [emergencyActive, setEmergencyActive] = useState(false);
  const [architectSignal, setArchitectSignal] = useState(1.0);
  const [commsLost, setCommsLost]           = useState(false);

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
        seq: prev.length,
        kind,
        droneId,
        description: desc,
        rSwarm: r,
        jDrift: j,
        beat: beatRef.current,
        timestamp: Date.now(),
      };
      return [...prev.slice(-99), entry];
    });
  }, []);

  const queueAction = useCallback((droneId, action, reason, cortisol, jDrift_, rSwarm_) => {
    const windows = { SACRIFICE: 30, ENGAGE: 60, DISSOLVE: 15, ENTER_ZONE: 20, FORMATION_CHANGE: 10 };
    const window_ = (windows[action] || 30) * 1000;
    const req = {
      id: nextReqId.current++,
      droneId,
      action,
      reason,
      cortisol,
      jDrift: jDrift_,
      rSwarm: rSwarm_,
      beat: beatRef.current,
      deadline: Date.now() + window_,
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
        setDrones(prev => prev.map(d => {
          if (d.id !== req.droneId) return d;
          return { ...d, sacrificed: true, activation: 1.0 };
        }));
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

  // Simulation tick
  useEffect(() => {
    const interval = setInterval(() => {
      if (emergencyActive) return;

      beatRef.current += 1;
      const b = beatRef.current;
      setBeat(b);

      setDrones(prev => {
        const next = prev.map(d => {
          if (d.sacrificed) return d;

          // Law 23: signal decay
          const decayedSignal = sf(d.signal * Math.exp(-0.001 * (b - d.lastBeat)));

          // Law 6/7: Kuramoto
          const active = prev.filter(o => !o.sacrificed && o.id !== d.id);
          const kuramotoSum = active.reduce((s, o) => s + Math.sin(o.phase - d.phase), 0);
          const dTheta = d.omega + (KURAMOTO_K / prev.length) * kuramotoSum;
          const newPhase = d.phase + dTheta * 0.05;

          // Neurochemical drift
          const newCortisol = sf(d.cortisol + (Math.random() - 0.49) * 0.02);
          const newDopamine = sf(d.dopamine + (Math.random() - 0.5) * 0.01);

          return {
            ...d,
            phase: newPhase,
            signal: sf(decayedSignal * architectSignal),
            cortisol: newCortisol,
            dopamine: newDopamine,
            lastBeat: b,
            posX: d.posX + Math.cos(b * 0.01 + d.id) * 0.15,
            posZ: d.posZ + Math.sin(b * 0.01 + d.id) * 0.15,
          };
        });

        // Law 4: Hebbian update
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

        const r = computeRSwarm(next);
        const jd = computeJDrift(next);
        setRSwarm(r);
        setJDrift(jd);

        // Jasmine correction
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
          return next.map(d => {
            if (d.sacrificed) return d;
            return {
              ...d,
              phase: d.phase * 0.9 + meanPhase * 0.1,
              oxytocin: sf(d.oxytocin + 0.05),
              cortisol: sf(d.cortisol - 0.03),
            };
          });
        }

        // Queue sacrifice if cortisol threshold exceeded
        next.forEach(d => {
          if (!d.sacrificed && d.cortisol > 1.5) {
            const alreadyQueued = pendingRef.current.some(
              p => p.droneId === d.id && p.action === 'SACRIFICE' && p.status === 'PENDING'
            );
            if (!alreadyQueued) {
              queueAction(d.id, 'SACRIFICE',
                `Drone ${d.id} cortisol=${d.cortisol.toFixed(2)} exceeds threshold`,
                d.cortisol, jd, r
              );
            }
          }
        });

        // OMNIS state log
        if (r >= 0.98 && b % 10 === 0) {
          addLog('OMNIS_STATE', null, `OMNIS STATE r=${r.toFixed(4)}`, r, jd);
        }

        return next;
      });

      // Expire pending actions past deadline
      setPendingActions(prev => {
        const updated = prev.map(r =>
          r.status === 'PENDING' && Date.now() > r.deadline
            ? { ...r, status: 'EXPIRED' }
            : r
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
