// Swarm Vitals Panel — r_swarm, J(t), neurochemicals, energy, brain output, HITL queue
// PARALLAX Drone Swarm Simulation — Medina Tech 2026

import React from 'react';

const s = {
  root: { padding: '10px', height: '100%', overflow: 'auto', display: 'flex', flexDirection: 'column', gap: 6 },
  title: { fontSize: 10, color: '#4af', letterSpacing: '0.12em', textTransform: 'uppercase', borderBottom: '1px solid #1a3a5c', paddingBottom: 4, flexShrink: 0 },
  section: { fontSize: 9, color: '#6af' },
  bar: { height: 8, background: '#0a1a2e', borderRadius: 3, overflow: 'hidden', marginTop: 2 },
  barFill: (pct, color) => ({
    height: '100%', width: `${pct * 100}%`, background: color,
    transition: 'width 0.3s', borderRadius: 3,
  }),
  droneGrid: { display: 'grid', gridTemplateColumns: 'repeat(6, 1fr)', gap: 2, marginTop: 2 },
  droneCell: (dominant, sacrificed) => ({
    width: '100%', aspectRatio: '1', borderRadius: 2,
    background: sacrificed ? '#112' : CHEM_COLORS[dominant] || '#003355',
    border: dominant === 'cortisol' ? '1px solid #ff4400' : '1px solid #1a3a5c',
    display: 'flex', alignItems: 'center', justifyContent: 'center',
    fontSize: 7, color: sacrificed ? '#334' : '#eee', cursor: 'default',
  }),
  hitlQueue: { overflow: 'auto', marginTop: 2 },
  hitlItem: {
    background: '#0a1a2e', border: '1px solid #ff8800', borderRadius: 3,
    padding: '3px 5px', marginBottom: 3, fontSize: 8, color: '#ffa',
  },
  countdown: { color: '#f84', fontSize: 7 },
  formationBadge: (r) => ({
    display: 'inline-block', padding: '1px 6px', borderRadius: 10, fontSize: 9,
    fontWeight: 'bold',
    background: r >= 0.98 ? '#7a6000' : r >= 0.92 ? '#004d22' : '#002244',
    color:      r >= 0.98 ? '#ffd700' : r >= 0.92 ? '#00ff88' : '#4af',
    border:     r >= 0.98 ? '1px solid #ffd700' : '1px solid #1a3a5c',
  }),
  miniBarRow: { display: 'flex', gap: 2, height: 4, marginTop: 2 },
  miniBar: (pct, color) => ({
    flex: pct, background: color, borderRadius: 1, minWidth: 1,
    transition: 'flex 0.3s',
  }),
};

const CHEM_COLORS = {
  dopamine:       '#0088cc',  // blue
  cortisol:       '#cc2200',  // red
  norepinephrine: '#ff8800',  // orange
  oxytocin:       '#cc44cc',  // magenta
};

function dominantChem(d) {
  const excess = {
    dopamine:       d.dopamine - 1.0,
    cortisol:       d.cortisol - 1.0,
    norepinephrine: d.norepinephrine - 1.0,
    oxytocin:       d.oxytocin - 1.0,
  };
  const max = Math.max(...Object.values(excess));
  if (max <= 0.02) return 'neutral';
  return Object.keys(excess).find(k => excess[k] === max) || 'neutral';
}

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
        <span style={{ color: warn ? '#f84' : '#4af' }}>{value.toFixed(3)}</span>
      </div>
      <div style={s.bar}><div style={s.barFill(pct, color)} /></div>
    </div>
  );
}

function ChemBars({ label, dop, cor, nor, oxy }) {
  // 4 proportional mini-bars
  const total = dop + cor + nor + oxy + 0.001;
  return (
    <div>
      <div style={s.section}>{label}</div>
      <div style={s.miniBarRow}>
        <div style={s.miniBar(dop / total, CHEM_COLORS.dopamine)} title={`DOP ${dop.toFixed(2)}`} />
        <div style={s.miniBar(cor / total, CHEM_COLORS.cortisol)} title={`COR ${cor.toFixed(2)}`} />
        <div style={s.miniBar(nor / total, CHEM_COLORS.norepinephrine)} title={`NOR ${nor.toFixed(2)}`} />
        <div style={s.miniBar(oxy / total, CHEM_COLORS.oxytocin)} title={`OXY ${oxy.toFixed(2)}`} />
      </div>
    </div>
  );
}

function timeLeft(deadline) {
  return (Math.max(0, deadline - Date.now()) / 1000).toFixed(0) + 's';
}

export default function SwarmVitals({ swarm }) {
  const { rSwarm, jDrift, drones, pendingActions, beat } = swarm;
  const active = drones.filter(d => !d.sacrificed);
  const n = active.length || 1;

  // Swarm-wide averages
  const avgDop = active.reduce((s, d) => s + d.dopamine, 0) / n;
  const avgCor = active.reduce((s, d) => s + d.cortisol, 0) / n;
  const avgNor = active.reduce((s, d) => s + d.norepinephrine, 0) / n;
  const avgOxy = active.reduce((s, d) => s + d.oxytocin, 0) / n;
  const avgEng = active.reduce((s, d) => s + (d.energy || 1.5), 0) / n;
  const avgOut = active.reduce((s, d) => s + (d.brainActivation ? d.brainActivation[5] || 0 : 0), 0) / n;

  const rColor = rSwarm >= 0.92 ? '#00ff88' : rSwarm < 0.5 ? '#ff3300' : '#00aaff';
  const jColor = jDrift > 1.0 ? '#ff4400' : jDrift > 0.5 ? '#ffaa00' : '#00aaff';
  const eColor = avgEng < 0.6 ? '#ff4400' : avgEng < 1.0 ? '#ffaa00' : '#00aaff';

  return (
    <div style={s.root}>
      <div style={s.title}>⬡ Swarm Vitals — Beat {beat}</div>

      <div style={{ marginBottom: 2 }}>
        <span style={s.formationBadge(rSwarm)}>{formationName(rSwarm)}</span>
      </div>

      <BarMeter label="r_swarm (Kuramoto Order)" value={rSwarm} min={0.5} max={1.0} color={rColor} />
      <BarMeter label="J(t) Jasmine Drift"       value={jDrift} min={0} max={3} color={jColor} warn={jDrift > 1.0} />
      <BarMeter label="⚡ Mean Energy"            value={avgEng} min={0.2} max={2.0} color={eColor} warn={avgEng < 0.6} />
      <BarMeter label="🧠 Brain Output (mean)"   value={avgOut} min={0} max={1.0} color="#aa44ff" />

      {/* Swarm neurochemical legend */}
      <div style={{ ...s.section, display: 'flex', gap: 8, marginTop: 2 }}>
        {Object.entries(CHEM_COLORS).map(([k, c]) => (
          <span key={k} style={{ color: c, fontSize: 8 }}>
            ■ {k.slice(0, 3).toUpperCase()} {({ dopamine: avgDop, cortisol: avgCor, norepinephrine: avgNor, oxytocin: avgOxy })[k].toFixed(2)}
          </span>
        ))}
      </div>

      {/* Swarm neurochemical proportional bars */}
      <ChemBars label="Swarm Neurochemistry" dop={avgDop} cor={avgCor} nor={avgNor} oxy={avgOxy} />

      {/* Per-drone grid — color by dominant neurochemical */}
      <div style={s.section}>Per-drone Dominant Chem</div>
      <div style={s.droneGrid}>
        {drones.map(d => {
          const dom = dominantChem(d);
          return (
            <div
              key={d.id}
              style={s.droneCell(dom, d.sacrificed)}
              title={`${d.cls} #${d.id} | DOP=${d.dopamine?.toFixed(2)} COR=${d.cortisol?.toFixed(2)} NOR=${d.norepinephrine?.toFixed(2)} OXY=${d.oxytocin?.toFixed(2)} E=${d.energy?.toFixed(2)}`}
            >
              {d.id}
            </div>
          );
        })}
      </div>

      {/* HITL queue */}
      {pendingActions.length > 0 && (
        <>
          <div style={{ ...s.section, color: '#ff8800', marginTop: 2 }}>
            ⚠ HITL PENDING ({pendingActions.length})
          </div>
          <div style={s.hitlQueue}>
            {pendingActions.slice(0, 4).map(req => (
              <div key={req.id} style={s.hitlItem}>
                <div>#{req.id} D{req.droneId} {req.action}</div>
                <div style={{ color: '#adf', fontSize: 7, marginTop: 1 }}>{req.reason.slice(0, 50)}</div>
                <div style={s.countdown}>⏱ {timeLeft(req.deadline)}</div>
              </div>
            ))}
          </div>
        </>
      )}
    </div>
  );
}
