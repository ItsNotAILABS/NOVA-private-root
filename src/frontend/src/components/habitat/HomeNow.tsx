// ─── NOVA / PARALLAX — Enterprise Habitat Shell ──────────────────────────────
// Home/Now view: what matters now, scores, presence, pulse.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026

import React, { useState } from 'react';
import type { OrganismState } from '../../hooks/useOrganismState';
import type { EnterpriseSnapshot } from '../../enterprise/habitat';
import type { MacroState } from '../../types/organism';

// ── Score badge ───────────────────────────────────────────────────────────────
function ScoreBadge({ label, value, warn, danger }: { label: string; value: number; warn?: number; danger?: number }) {
  const pct = Math.round(value * 100);
  const color = danger !== undefined && value < danger ? '#f44' :
                warn   !== undefined && value < warn   ? '#fa4' : '#4af';
  const border = danger !== undefined && value < danger ? '#f44' :
                 warn   !== undefined && value < warn   ? '#fa4' : '#1a3a5c';
  return (
    <div style={{ padding: '6px 10px', border: `1px solid ${border}`, borderRadius: 4, minWidth: 90 }}>
      <div style={{ fontSize: 9, color: '#6af', letterSpacing: '0.1em', textTransform: 'uppercase' }}>{label}</div>
      <div style={{ fontSize: 20, fontWeight: 700, color, fontVariantNumeric: 'tabular-nums' }}>{pct}<span style={{ fontSize: 11 }}>%</span></div>
    </div>
  );
}

// ── Pulse bar ─────────────────────────────────────────────────────────────────
function PulseBar({ label, value, color = '#4af' }: { label: string; value: number; color?: string }) {
  return (
    <div style={{ marginBottom: 6 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 9, color: '#6af' }}>
        <span>{label}</span><span style={{ color }}>{(value * 100).toFixed(1)}%</span>
      </div>
      <div style={{ height: 5, background: '#0a1a2e', borderRadius: 3, overflow: 'hidden' }}>
        <div style={{ height: '100%', width: `${value * 100}%`, background: color, transition: 'width 0.4s', borderRadius: 3 }} />
      </div>
    </div>
  );
}

// ── Worker presence dot ───────────────────────────────────────────────────────
function WorkerDot({ name, status, trust, loadPulse }: { name: string; status: string; trust: number; loadPulse: number }) {
  const statusColor: Record<string, string> = {
    idle: '#246', active: '#00ff88', thinking: '#4af', blocked: '#f44',
    disagreeing: '#fa4', escalating: '#f84',
  };
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '3px 0', fontSize: 9, color: '#9bc' }}>
      <div style={{ width: 8, height: 8, borderRadius: '50%', background: statusColor[status] ?? '#246', flexShrink: 0 }} />
      <span style={{ flex: 1 }}>{name}</span>
      <span style={{ color: '#4af' }}>{(trust * 100).toFixed(0)}%T</span>
      <span style={{ color: loadPulse > 0.7 ? '#f44' : '#246' }}>{(loadPulse * 100).toFixed(0)}%L</span>
    </div>
  );
}

// ── HomeNow panel ─────────────────────────────────────────────────────────────
interface HomeNowProps {
  organism: OrganismState;
}

export function HomeNow({ organism }: HomeNowProps) {
  const { beat, rSwarm, jDrift, continuityScore, trustScore, anomalyScore, loadPulseScore, simConfidence,
          enterprise, missionStatus, missionName, commsLost, pendingActions, auditLog } = organism;

  const workers = enterprise?.workers ?? [];
  const active  = workers.filter(w => w.status !== 'idle').slice(0, 8);
  const danger  = workers.filter(w => w.status === 'blocked' || w.status === 'escalating');

  return (
    <div style={{ padding: 12, height: '100%', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: 10 }}>
      {/* Header */}
      <div style={{ fontSize: 10, color: '#4af', letterSpacing: '0.15em', textTransform: 'uppercase', borderBottom: '1px solid #1a3a5c', paddingBottom: 6 }}>
        ⬡ HOME / NOW — BEAT {beat}
        {commsLost && <span style={{ color: '#f44', marginLeft: 8 }}>⚠ COMMS LOST</span>}
        {missionStatus === 'ACTIVE' && <span style={{ color: '#00ff88', marginLeft: 8 }}>● {missionName}</span>}
        {missionStatus === 'EMERGENCY_STOP' && <span style={{ color: '#f44', marginLeft: 8 }}>■ EMERGENCY STOP</span>}
      </div>

      {/* Score row */}
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <ScoreBadge label="Continuity K_c" value={continuityScore} warn={0.60} danger={0.40} />
        <ScoreBadge label="Trust T_s"      value={trustScore}      warn={0.60} danger={0.40} />
        <ScoreBadge label="Anomaly A_s"    value={1 - anomalyScore} warn={0.50} danger={0.30} />
        <ScoreBadge label="Sim Conf SC"    value={simConfidence}   warn={0.60} danger={0.40} />
        <ScoreBadge label="Coherence r"    value={rSwarm}          warn={0.70} danger={0.55} />
      </div>

      {/* Pulse bars */}
      <div style={{ background: '#070e1e', border: '1px solid #1a3a5c', borderRadius: 4, padding: 8 }}>
        <div style={{ fontSize: 9, color: '#4af', marginBottom: 6, textTransform: 'uppercase', letterSpacing: '0.1em' }}>Company Pulse</div>
        <PulseBar label="Kuramoto Order r"   value={rSwarm}         color="#00aaff" />
        <PulseBar label="Load / Pulse L_p"   value={loadPulseScore} color={loadPulseScore > 0.7 ? '#f44' : '#fa4'} />
        <PulseBar label="Jasmine Drift J(t)" value={Math.min(jDrift / 3, 1)} color="#ff8800" />
        <PulseBar label="Continuity K_c"     value={continuityScore} color="#00ff88" />
      </div>

      {/* HITL */}
      {pendingActions.length > 0 && (
        <div style={{ background: '#1a0a00', border: '1px solid #ff8800', borderRadius: 4, padding: 8 }}>
          <div style={{ fontSize: 9, color: '#ff8800', marginBottom: 4, textTransform: 'uppercase' }}>⚠ {pendingActions.length} HITL Pending</div>
          {pendingActions.slice(0, 3).map(r => (
            <div key={r.id} style={{ fontSize: 8, color: '#ffa', marginBottom: 3 }}>
              D{r.droneId} — {r.action} — urgency {(r.urgency * 100).toFixed(0)}%
            </div>
          ))}
        </div>
      )}

      {/* Danger workers */}
      {danger.length > 0 && (
        <div style={{ background: '#1a0000', border: '1px solid #f44', borderRadius: 4, padding: 8 }}>
          <div style={{ fontSize: 9, color: '#f44', marginBottom: 4, textTransform: 'uppercase' }}>⚠ Workers Need Attention</div>
          {danger.map(w => <WorkerDot key={w.id} name={w.name} status={w.status} trust={w.trust} loadPulse={w.loadPulse} />)}
        </div>
      )}

      {/* Active workers */}
      <div style={{ background: '#070e1e', border: '1px solid #1a3a5c', borderRadius: 4, padding: 8 }}>
        <div style={{ fontSize: 9, color: '#4af', marginBottom: 4, textTransform: 'uppercase', letterSpacing: '0.1em' }}>Worker Society</div>
        {active.length === 0
          ? <div style={{ fontSize: 9, color: '#246' }}>All workers idle</div>
          : active.map(w => <WorkerDot key={w.id} name={w.name} status={w.status} trust={w.trust} loadPulse={w.loadPulse} />)
        }
      </div>

      {/* Recent audit */}
      <div style={{ background: '#020609', border: '1px solid #0a1a2e', borderRadius: 3, padding: '4px 6px', maxHeight: 100, overflowY: 'auto' }}>
        {auditLog.slice(-8).reverse().map((e, i) => (
          <div key={i} style={{ fontSize: 8, color: '#48a', marginBottom: 1 }}>
            [{e.beat}] <span style={{ color: e.kind === 'EMERGENCY_STOP' ? '#f44' : '#4af' }}>{e.kind}</span> {e.message}
          </div>
        ))}
      </div>
    </div>
  );
}
