// Swarm Vitals Panel — r_swarm, J(t), per-drone cortisol grid, HITL queue
// PARALLAX Drone Swarm Simulation — Medina Tech 2026

import React from 'react';

const s = {
  root: { padding: '10px', height: '100%', overflow: 'hidden', display: 'flex', flexDirection: 'column', gap: 8 },
  title: { fontSize: 10, color: '#4af', letterSpacing: '0.12em', textTransform: 'uppercase', borderBottom: '1px solid #1a3a5c', paddingBottom: 4 },
  section: { fontSize: 9, color: '#6af' },
  bar: { height: 10, background: '#0a1a2e', borderRadius: 3, overflow: 'hidden', marginTop: 2 },
  barFill: (pct, color) => ({
    height: '100%',
    width: `${pct * 100}%`,
    background: color,
    transition: 'width 0.3s',
    borderRadius: 3,
  }),
  droneGrid: { display: 'grid', gridTemplateColumns: 'repeat(6, 1fr)', gap: 2, marginTop: 4 },
  droneCell: (cortisol, sacrificed) => ({
    width: '100%',
    aspectRatio: '1',
    borderRadius: 2,
    background: sacrificed ? '#112' :
      cortisol > 1.5 ? '#aa1100' :
      cortisol > 1.2 ? '#553300' : '#003355',
    border: cortisol > 1.5 ? '1px solid #ff4400' : '1px solid #1a3a5c',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontSize: 7,
    color: sacrificed ? '#334' : '#adf',
    cursor: 'default',
  }),
  hitlQueue: { flex: 1, overflow: 'auto', marginTop: 4 },
  hitlItem: {
    background: '#0a1a2e',
    border: '1px solid #ff8800',
    borderRadius: 3,
    padding: '4px 6px',
    marginBottom: 4,
    fontSize: 9,
    color: '#ffa',
  },
  countdown: { color: '#f84', fontSize: 8 },
  formationBadge: (r) => ({
    display: 'inline-block',
    padding: '1px 6px',
    borderRadius: 10,
    fontSize: 9,
    fontWeight: 'bold',
    background: r >= 0.98 ? '#7a6000' : r >= 0.92 ? '#004d22' : '#002244',
    color: r >= 0.98 ? '#ffd700' : r >= 0.92 ? '#00ff88' : '#4af',
    border: r >= 0.98 ? '1px solid #ffd700' : '1px solid #1a3a5c',
  }),
};

function formationName(r) {
  if (r >= 0.98) return 'OMNIS STATE';
  if (r >= 0.95) return 'DIAMOND';
  if (r >= 0.92) return 'FORMATION LOCK';
  if (r >= 0.90) return 'CONVERGING';
  return 'LOOSE PATROL';
}

function BarMeter({ label, value, min = 0, max = 1, color, warn = false }) {
  const pct = Math.max(0, Math.min(1, (value - min) / (max - min)));
  return (
    <div>
      <div style={{ ...s.section, display: 'flex', justifyContent: 'space-between' }}>
        <span>{label}</span>
        <span style={{ color: warn ? '#f84' : '#4af' }}>{value.toFixed(4)}</span>
      </div>
      <div style={s.bar}>
        <div style={s.barFill(pct, color)} />
      </div>
    </div>
  );
}

function timeLeft(deadline) {
  const ms = Math.max(0, deadline - Date.now());
  return (ms / 1000).toFixed(1) + 's';
}

export default function SwarmVitals({ swarm }) {
  const { rSwarm, jDrift, drones, pendingActions, beat } = swarm;

  const rColor = rSwarm >= 0.92 ? '#00ff88' : rSwarm < 0.5 ? '#ff3300' : '#00aaff';
  const jColor = jDrift > 1.0 ? '#ff4400' : jDrift > 0.5 ? '#ffaa00' : '#00aaff';

  return (
    <div style={s.root}>
      <div style={s.title}>⬡ Swarm Vitals — Beat {beat}</div>

      {/* Formation badge */}
      <div style={{ marginBottom: 2 }}>
        <span style={s.formationBadge(rSwarm)}>{formationName(rSwarm)}</span>
      </div>

      {/* r_swarm */}
      <BarMeter label="r_swarm (Kuramoto Order)" value={rSwarm} min={0.5} max={1.0} color={rColor} />

      {/* J(t) Jasmine drift */}
      <BarMeter label="J(t) Jasmine Drift" value={jDrift} min={0} max={3} color={jColor} warn={jDrift > 1.0} />

      {/* Per-drone cortisol grid */}
      <div style={s.section}>Per-drone Cortisol</div>
      <div style={s.droneGrid}>
        {drones.map(d => (
          <div key={d.id} style={s.droneCell(d.cortisol, d.sacrificed)} title={`${d.cls} #${d.id} cortisol=${d.cortisol.toFixed(2)}`}>
            {d.id}
          </div>
        ))}
      </div>

      {/* HITL queue */}
      {pendingActions.length > 0 && (
        <>
          <div style={{ ...s.section, color: '#ff8800', marginTop: 4 }}>
            ⚠ HITL PENDING ({pendingActions.length})
          </div>
          <div style={s.hitlQueue}>
            {pendingActions.slice(0, 4).map(req => (
              <div key={req.id} style={s.hitlItem}>
                <div>#{req.id} D{req.droneId} {req.action}</div>
                <div style={{ color: '#adf', fontSize: 8, marginTop: 1 }}>{req.reason.slice(0, 50)}</div>
                <div style={s.countdown}>⏱ {timeLeft(req.deadline)}</div>
              </div>
            ))}
          </div>
        </>
      )}
    </div>
  );
}
