// PARALLAX DRONE SWARM — Organism Layer Panel
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Displays Bee Hive Mind + Ant Mind + Internal AI Organ Teams

import React from 'react';

const COL = {
  bg:       '#050a14',
  panel:    '#070e1e',
  border:   '#1a3a5c',
  accent:   '#4af',
  gold:     '#fa4',
  red:      '#f44',
  green:    '#4fa',
  purple:   '#c4f',
  dim:      '#3a6080',
  text:     '#9bc',
  textDim:  '#2a5a7a',
};

const ORGAN_COLORS = {
  ROUTING_OPTIMAL:    COL.green,
  ROUTING_DEGRADED:   COL.gold,
  HEALTHY:            COL.green,
  MONITORING:         COL.gold,
  ALERT:              COL.red,
  ENERGY_OK:          COL.green,
  LOW_ENERGY:         COL.gold,
  CRITICAL_ENERGY:    COL.red,
  HIGH_AWARENESS:     COL.green,
  LOW_AWARENESS:      COL.gold,
  SPAWN_RECOMMENDED:  COL.accent,
  HOLDING:            COL.dim,
  IDLE:               COL.textDim,
};

const COMB_COLORS = {
  QUEEN_GUARD: COL.gold,
  FORAGER:     COL.green,
  SCOUT:       COL.accent,
  NURSE:       COL.purple,
  BUILDER:     '#8cf',
  DEFENDER:    COL.red,
  WORKER:      COL.dim,
};

const ANT_COLORS = {
  FORAGER:  COL.green,
  DEFENDER: COL.red,
  RELAY:    COL.accent,
  NURSE:    COL.purple,
  SCOUT:    '#8cf',
  IDLE:     COL.textDim,
};

const TEAM_NAMES = ['SCOUT', 'STRIKER', 'GUARDIAN', 'RELAY', 'MEDIC'];
const ORGAN_NAMES = ['NERVOUS', 'IMMUNE', 'METABOLIC', 'SENSORY', 'REPRODUCTIVE'];

// Mini 20×20 grid heat map drawn with canvas-style inline div grid
function GridMap({ data, size = 80, maxVal = 1.0, colorFn }) {
  const GRID_W = 20;
  if (!data || data.length !== 400) return null;
  const cellPx = size / GRID_W;
  return (
    <div style={{
      display: 'grid',
      gridTemplateColumns: `repeat(${GRID_W}, ${cellPx}px)`,
      gap: 0,
      width: size,
      height: size,
      flexShrink: 0,
    }}>
      {data.map((v, i) => {
        const intensity = Math.min(1, v / maxVal);
        const bg = colorFn(intensity);
        return (
          <div
            key={i}
            style={{
              width: cellPx,
              height: cellPx,
              background: bg,
            }}
          />
        );
      })}
    </div>
  );
}

function nectarColor(t) {
  // green gradient
  const g = Math.floor(t * 180 + 60);
  return `rgb(0,${g},${Math.floor(t * 60)})`;
}
function foodColor(t) {
  // amber gradient
  const r = Math.floor(t * 220 + 20);
  const g = Math.floor(t * 130);
  return `rgb(${r},${g},0)`;
}
function dangerColor(t) {
  // red gradient
  return `rgb(${Math.floor(t * 240 + 15)},0,0)`;
}

// Bar meter
function Bar({ value, max = 2.0, color = COL.accent, width = 60, height = 6 }) {
  const pct = Math.min(1, Math.max(0, value / max));
  return (
    <div style={{
      width, height,
      background: '#0a1824',
      border: `1px solid ${COL.border}`,
      position: 'relative',
      display: 'inline-block',
      verticalAlign: 'middle',
    }}>
      <div style={{
        position: 'absolute', left: 0, top: 0,
        width: `${pct * 100}%`, height: '100%',
        background: color,
        transition: 'width 0.3s',
      }} />
    </div>
  );
}

const S = {
  root: {
    width: '100%',
    height: '100%',
    overflowY: 'auto',
    padding: '6px 8px',
    boxSizing: 'border-box',
    fontFamily: 'monospace',
    fontSize: '9px',
    color: COL.text,
    background: COL.panel,
  },
  section: {
    marginBottom: 8,
    borderBottom: `1px solid ${COL.border}`,
    paddingBottom: 6,
  },
  heading: {
    fontSize: '9px',
    color: COL.accent,
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
    marginBottom: 4,
    display: 'flex',
    alignItems: 'center',
    gap: 4,
  },
  row: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 2,
    gap: 4,
  },
  badge: (color) => ({
    color,
    border: `1px solid ${color}`,
    padding: '0 3px',
    borderRadius: 2,
    fontSize: '8px',
    flexShrink: 0,
  }),
  grid2: {
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: '2px 6px',
    marginBottom: 4,
  },
  maps: {
    display: 'flex',
    gap: 6,
    marginTop: 4,
    flexWrap: 'wrap',
  },
  mapLabel: {
    fontSize: '8px',
    color: COL.textDim,
    marginBottom: 2,
  },
};

export default function OrganismPanel({ swarm }) {
  const org = swarm.organism;
  if (!org) return null;

  const { organs, captains, morale, combRoles, antRoles, waggle, quorum,
          queenPheromone, nectarGrid, foodPher, dangerPher,
          entropy, isingM } = org;

  const moraleEntries = Object.entries(morale);
  const activeWaggle   = waggle.filter(w => w.active);

  return (
    <div style={S.root}>

      {/* ── Header ── */}
      <div style={{ ...S.heading, fontSize: '10px', marginBottom: 6 }}>
        ⬡ ORGANISM LAYER — {org.mode}
      </div>

      {/* ── Swarm Math ── */}
      <div style={S.section}>
        <div style={S.heading}>∑ SWARM MATH</div>
        <div style={S.grid2}>
          <div style={S.row}>
            <span style={{ color: COL.textDim }}>ENTROPY</span>
            <span style={{ color: COL.gold }}>{entropy.toFixed(3)}</span>
          </div>
          <div style={S.row}>
            <span style={{ color: COL.textDim }}>ISING M</span>
            <span style={{ color: isingM > 0.5 ? COL.green : isingM < -0.5 ? COL.red : COL.gold }}>
              {isingM.toFixed(3)}
            </span>
          </div>
        </div>
      </div>

      {/* ── Bee Hive Mind ── */}
      <div style={S.section}>
        <div style={S.heading}>⬡ BEE HIVE MIND</div>

        <div style={S.row}>
          <span style={{ color: COL.textDim }}>QUEEN PHEROMONE</span>
          <Bar value={queenPheromone} max={2.0} color={COL.gold} />
          <span style={{ color: COL.gold }}>{queenPheromone.toFixed(2)}</span>
        </div>

        <div style={S.row}>
          <span style={{ color: COL.textDim }}>WAGGLE SCOUTS</span>
          <span style={{ color: COL.accent }}>{activeWaggle.length}</span>
        </div>

        <div style={S.row}>
          <span style={{ color: COL.textDim }}>QUORUM</span>
          {quorum.decided
            ? <span style={S.badge(COL.green)}>DECIDED dir={(quorum.direction * 57.3).toFixed(0)}°</span>
            : <span style={S.badge(COL.gold)}>FORMING {quorum.votes}/{swarm.drones?.length || 0}</span>
          }
        </div>

        {/* Comb roles mini-legend */}
        <div style={{ marginTop: 4 }}>
          {['QUEEN_GUARD','FORAGER','SCOUT','NURSE','BUILDER','DEFENDER','WORKER'].map(role => {
            const count = combRoles.filter(r => r === role).length;
            if (!count) return null;
            return (
              <span key={role} style={{ ...S.badge(COMB_COLORS[role] || COL.dim), marginRight: 3 }}>
                {role[0]} ×{count}
              </span>
            );
          })}
        </div>

        <div style={S.maps}>
          <div>
            <div style={S.mapLabel}>NECTAR MAP</div>
            <GridMap data={nectarGrid} size={80} maxVal={1.0} colorFn={nectarColor} />
          </div>
        </div>
      </div>

      {/* ── Ant Mind ── */}
      <div style={S.section}>
        <div style={S.heading}>🐜 ANT MIND</div>

        {/* Ant role badge summary */}
        <div style={{ marginBottom: 4 }}>
          {['FORAGER','DEFENDER','RELAY','NURSE','SCOUT'].map(role => {
            const count = antRoles.filter(r => r === role).length;
            if (!count) return null;
            return (
              <span key={role} style={{ ...S.badge(ANT_COLORS[role] || COL.dim), marginRight: 3 }}>
                {role[0]} ×{count}
              </span>
            );
          })}
        </div>

        <div style={S.maps}>
          <div>
            <div style={S.mapLabel}>FOOD TRAIL</div>
            <GridMap data={foodPher} size={80} maxVal={3.0} colorFn={foodColor} />
          </div>
          <div>
            <div style={S.mapLabel}>DANGER TRAIL</div>
            <GridMap data={dangerPher} size={80} maxVal={3.0} colorFn={dangerColor} />
          </div>
        </div>
      </div>

      {/* ── Internal AI Teams ── */}
      <div style={S.section}>
        <div style={S.heading}>⚡ AI TEAMS</div>
        {TEAM_NAMES.map(team => {
          const cap = captains[team];
          const mor = morale[team] ?? 1;
          return (
            <div key={team} style={S.row}>
              <span style={{ color: COL.textDim, width: 60 }}>{team}</span>
              <Bar value={mor} max={2.0} color={mor > 1.2 ? COL.green : mor < 0.9 ? COL.red : COL.gold} width={50} />
              <span style={{ color: COL.text }}>{mor.toFixed(2)}</span>
              <span style={{ color: COL.textDim }}>
                {cap != null ? `cap:D${cap}` : '—'}
              </span>
            </div>
          );
        })}
      </div>

      {/* ── Organ Systems ── */}
      <div style={S.section}>
        <div style={S.heading}>🧬 ORGAN SYSTEMS</div>
        {ORGAN_NAMES.map(name => {
          const organ = organs[name];
          if (!organ) return null;
          const stateColor = ORGAN_COLORS[organ.state] || COL.textDim;
          return (
            <div key={name} style={{ ...S.row, marginBottom: 3 }}>
              <span style={{ color: COL.textDim, width: 80 }}>{name}</span>
              <Bar value={organ.output} max={1.0} color={stateColor} width={44} />
              <span style={{ color: stateColor, fontSize: '8px', flex: 1, textAlign: 'right' }}>
                {organ.state}
              </span>
            </div>
          );
        })}
      </div>

    </div>
  );
}
