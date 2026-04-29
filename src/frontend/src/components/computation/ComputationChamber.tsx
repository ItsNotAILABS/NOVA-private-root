// ─── NOVA / PARALLAX — Computation Chamber Component ─────────────────────────
// REAL physics computation — NOT simulation. Physics is MATH and GEOMETRY.
// Displays the living world-body: macro-state, gradient fields, world objects,
// sediments, domain unlocks. Rendered as an SVG overhead map.
// EVERYTHING IS INTELLIGENCE — deep rooted infrastructure.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026

import React, { useMemo } from 'react';
import type { OrganismState } from '../../hooks/useOrganismState';
import type { WorldObject, MacroState } from '../../types/organism';
import type { HistorySediment, UnlockedDomain } from '../../world/world-generator';
import { GRID_W, GRID_H } from '../../world/world-generator';

// ── Color mappings for material states ───────────────────────────────────────
const MATERIAL_COLORS: Record<string, string> = {
  fluid:           'rgba(0, 80, 160, 0.4)',
  'semi-stable':   'rgba(0, 120, 200, 0.6)',
  crystallized:    'rgba(80, 200, 255, 0.85)',
  decayed:         'rgba(60, 20, 20, 0.7)',
  anomalous:       'rgba(180, 0, 200, 0.6)',
  'memory-anchored': 'rgba(100, 80, 200, 0.7)',
  sacred:          'rgba(255, 220, 0, 0.9)',
};

const STRUCTURE_SYMBOLS: Record<string, string> = {
  territory:    '▣',
  hub:          '◉',
  road:         '─',
  scar:         '✕',
  ruin:         '▽',
  fortification:'▲',
  biome:        '◌',
  anomaly:      '⬡',
  domain:       '✦',
};

// ── MacroState dashboard ──────────────────────────────────────────────────────
function MacroBar({ label, value, color = '#4af' }: { label: string; value: number; color?: string }) {
  const v = Math.max(0, Math.min(1, value));
  return (
    <div style={{ marginBottom: 4 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 8, color: '#6af' }}>
        <span>{label}</span><span style={{ color }}>{(v * 100).toFixed(1)}%</span>
      </div>
      <div style={{ height: 4, background: '#0a1a2e', borderRadius: 2, overflow: 'hidden' }}>
        <div style={{ height: '100%', width: `${v * 100}%`, background: color, transition: 'width 0.5s', borderRadius: 2 }} />
      </div>
    </div>
  );
}

// ── World map SVG ─────────────────────────────────────────────────────────────
interface WorldMapProps {
  objects:   WorldObject[];
  sediments: HistorySediment[];
  domains:   UnlockedDomain[];
  width:     number;
  height:    number;
}

function WorldMap({ objects, sediments, domains, width, height }: WorldMapProps) {
  const sx = width  / GRID_W;
  const sy = height / GRID_H;

  const worldObjects = useMemo(() => {
    return objects.filter(o => o.geometry.coords.length > 0).map(o => {
      const [gx = 32, gy = 32] = o.geometry.coords[0] ?? [32, 32];
      const x = gx * sx;
      const y = gy * sy;
      const color = MATERIAL_COLORS[o.material] ?? 'rgba(0,100,200,0.5)';
      const symbol = STRUCTURE_SYMBOLS[o.structureClass] ?? '·';
      const r = Math.max(2, (o.geometry.radius ?? 3) * sx * 0.15);
      return { id: o.id, x, y, color, symbol, r, emission: o.emission, pulse: o.pulse };
    });
  }, [objects, sx, sy]);

  const scarObjects = useMemo(() => {
    return sediments.map(s => ({
      id:   s.id,
      x:    s.x * sx,
      y:    s.y * sy,
      mag:  s.magnitude,
      type: s.type,
    }));
  }, [sediments, sx, sy]);

  const domainRings = useMemo(() => {
    return domains.map(d => ({
      id: d.ruleId,
      x:  d.centerX * sx,
      y:  d.centerY * sy,
      r:  8 * sx,
      label: d.label,
    }));
  }, [domains, sx, sy]);

  return (
    <svg width={width} height={height} style={{ display: 'block' }}>
      {/* Background grid (subtle) */}
      <rect x={0} y={0} width={width} height={height} fill="#020609" />
      {/* Grid lines every 8 cells */}
      {Array.from({ length: Math.floor(GRID_W / 8) + 1 }, (_, i) => (
        <line key={`vg${i}`} x1={i * 8 * sx} y1={0} x2={i * 8 * sx} y2={height} stroke="#0a1a2e" strokeWidth={0.5} />
      ))}
      {Array.from({ length: Math.floor(GRID_H / 8) + 1 }, (_, i) => (
        <line key={`hg${i}`} x1={0} y1={i * 8 * sy} x2={width} y2={i * 8 * sy} stroke="#0a1a2e" strokeWidth={0.5} />
      ))}

      {/* Sediment scars */}
      {scarObjects.map(s => (
        <circle
          key={s.id}
          cx={s.x} cy={s.y}
          r={4 * s.mag}
          fill={s.type === 'scar' ? `rgba(200,60,0,${s.mag * 0.4})` : `rgba(60,0,80,${s.mag * 0.3})`}
          stroke={s.type === 'scar' ? '#f44' : '#8a4'}
          strokeWidth={0.5}
          strokeOpacity={s.mag}
        />
      ))}

      {/* World objects */}
      {worldObjects.map(o => (
        <g key={o.id} transform={`translate(${o.x},${o.y})`}>
          {/* Glow ring */}
          {o.emission > 0.5 && (
            <circle r={o.r * 2} fill="none" stroke={o.color} strokeWidth={1} opacity={o.emission * 0.4} />
          )}
          {/* Core */}
          <circle r={o.r} fill={o.color} opacity={0.8} />
          {/* Symbol */}
          <text
            x={0} y={3}
            textAnchor="middle"
            fontSize={Math.max(6, o.r * 1.2)}
            fill="#fff"
            opacity={0.7}
          >{o.symbol}</text>
        </g>
      ))}

      {/* Domain unlock rings */}
      {domainRings.map(d => (
        <g key={d.id}>
          <circle cx={d.x} cy={d.y} r={d.r}
            fill="none" stroke="#ffd700" strokeWidth={1.5} strokeDasharray="4 4" opacity={0.7} />
          <text x={d.x} y={d.y - d.r - 4} textAnchor="middle" fontSize={7} fill="#ffd700" opacity={0.9}>
            {d.label}
          </text>
        </g>
      ))}

      {/* Center marker */}
      <circle cx={width / 2} cy={height / 2} r={3} fill="#4af" opacity={0.5} />
      <circle cx={width / 2} cy={height / 2} r={12} fill="none" stroke="#4af" strokeWidth={0.5} opacity={0.3} />
    </svg>
  );
}

// ── ComputationChamber (REAL physics, NOT simulation) ─────────────────────────────────
export function ComputationChamber({ organism }: { organism: OrganismState }) {
  const { world, macroState, simConfidence, beat } = organism;

  if (!world || !macroState) {
    return (
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', height: '100%', color: '#3a6080', fontSize: 10 }}>
        ⟳ World generating… beat {beat}
      </div>
    );
  }

  const { objects, sediments, domains } = world;
  const macro = macroState;

  return (
    <div style={{ display: 'flex', height: '100%', gap: 0 }}>
      {/* World map */}
      <div style={{ flex: 1, position: 'relative', overflow: 'hidden' }}>
        <div style={{ position: 'absolute', top: 8, left: 10, zIndex: 10, fontSize: 9, color: '#4af', letterSpacing: '0.12em', textTransform: 'uppercase' }}>
          ⬡ COMPUTATION CHAMBER — REAL PHYSICS — BEAT {beat}
        </div>
        <div style={{ position: 'absolute', top: 8, right: 10, zIndex: 10, fontSize: 8, color: '#ffd700' }}>
          SC: {(simConfidence * 100).toFixed(0)}%
        </div>
        <div style={{ width: '100%', height: '100%' }}>
          <WorldMap
            objects={objects}
            sediments={sediments}
            domains={domains}
            width={window.innerWidth * 0.55}
            height={window.innerHeight * 0.75}
          />
        </div>

        {/* Legend */}
        <div style={{ position: 'absolute', bottom: 8, left: 10, display: 'flex', flexWrap: 'wrap', gap: 8 }}>
          {Object.entries(STRUCTURE_SYMBOLS).map(([cls, sym]) => (
            <span key={cls} style={{ fontSize: 8, color: '#3a6080' }}>
              {sym} {cls}
            </span>
          ))}
        </div>
      </div>

      {/* Macro-state panel */}
      <div style={{ width: 160, background: '#070e1e', borderLeft: '1px solid #1a3a5c', padding: 10, overflowY: 'auto' }}>
        <div style={{ fontSize: 9, color: '#4af', letterSpacing: '0.12em', textTransform: 'uppercase', borderBottom: '1px solid #1a3a5c', paddingBottom: 4, marginBottom: 8 }}>
          Macro State
        </div>
        <MacroBar label="Coherence"     value={macro.coherence}        color="#4af" />
        <MacroBar label="Stability"     value={macro.stability}        color="#00ff88" />
        <MacroBar label="Trust"         value={macro.trust}            color="#00aaff" />
        <MacroBar label="Law Density"   value={macro.lawDensity}       color="#ffd700" />
        <MacroBar label="Escalation"    value={macro.escalation}       color="#f84" />
        <MacroBar label="Pressure"      value={macro.pressure}         color="#fa4" />
        <MacroBar label="Damage"        value={macro.damage}           color="#f44" />
        <MacroBar label="Memory"        value={macro.memoryDensity}    color="#c4f" />
        <MacroBar label="Energy"        value={macro.energy / 2}       color="#ffdd44" />
        <MacroBar label="Traffic"       value={macro.trafficFlow}      color="#88ccff" />
        <MacroBar label="Anomaly"       value={macro.anomalyDensity}   color="#ff4488" />
        <MacroBar label="Domains"       value={macro.domainActivation} color="#ffd700" />
        <MacroBar label="Infra Maturity" value={macro.infrastructureMaturity} color="#88ff44" />
        <MacroBar label="Node Maturity"  value={macro.nodeMaturity}    color="#44ff88" />

        <div style={{ marginTop: 10, fontSize: 8, color: '#3a6080', borderTop: '1px solid #0a1a2e', paddingTop: 6 }}>
          <div>World Age: {macro.worldAge} beats</div>
          <div style={{ marginTop: 3 }}>
            Objects: {objects.length} | Scars: {sediments.length} | Domains: {domains.length}
          </div>
        </div>
      </div>
    </div>
  );
}
