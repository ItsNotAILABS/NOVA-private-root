// ─── NOVA / PARALLAX — Worker Hub Component ──────────────────────────────────
// Shows the full worker society: status, scores, disagreements, council output.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026

import React, { useState } from 'react';
import type { OrganismState } from '../../hooks/useOrganismState';
import type { Worker } from '../../types/organism';
import type { DisagreementObject } from '../../enterprise/habitat';

const STATUS_COLOR: Record<string, string> = {
  idle:        '#1a3a5c',
  active:      '#003322',
  thinking:    '#002244',
  blocked:     '#330000',
  disagreeing: '#332200',
  escalating:  '#331100',
};

const STATUS_TEXT: Record<string, string> = {
  idle:        '#3a6080',
  active:      '#00ff88',
  thinking:    '#4af',
  blocked:     '#f44',
  disagreeing: '#fa4',
  escalating:  '#f84',
};

function WorkerCard({ worker }: { worker: Worker }) {
  const bg  = STATUS_COLOR[worker.status] ?? '#0a1a2e';
  const col = STATUS_TEXT[worker.status]  ?? '#6af';
  return (
    <div style={{
      background: bg, border: `1px solid ${col}22`, borderRadius: 4, padding: '6px 8px',
      display: 'flex', flexDirection: 'column', gap: 3, minWidth: 160,
    }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <span style={{ fontSize: 9, color: col, fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.08em' }}>{worker.name}</span>
        <span style={{ fontSize: 8, color: col, padding: '1px 4px', border: `1px solid ${col}55`, borderRadius: 8 }}>{worker.status}</span>
      </div>
      <div style={{ fontSize: 8, color: '#3a6080' }}>{worker.cls.replace('_', ' ').replace('division', 'DIV')} · {worker.division}</div>
      {worker.currentTask && (
        <div style={{ fontSize: 8, color: '#9bc', fontStyle: 'italic' }}>{worker.currentTask.slice(0, 40)}</div>
      )}
      <div style={{ display: 'flex', gap: 6, marginTop: 2 }}>
        <TinyBar label="T" value={worker.trust}      color="#4af" />
        <TinyBar label="K" value={worker.continuity} color="#00ff88" />
        <TinyBar label="L" value={worker.loadPulse}  color={worker.loadPulse > 0.7 ? '#f44' : '#fa4'} />
        <TinyBar label="A" value={worker.anomaly}    color="#f44" />
      </div>
    </div>
  );
}

function TinyBar({ label, value, color }: { label: string; value: number; color: string }) {
  return (
    <div style={{ flex: 1 }}>
      <div style={{ fontSize: 7, color: '#3a6080', marginBottom: 1 }}>{label}</div>
      <div style={{ height: 4, background: '#0a1a2e', borderRadius: 2, overflow: 'hidden' }}>
        <div style={{ height: '100%', width: `${Math.min(value, 1) * 100}%`, background: color, borderRadius: 2 }} />
      </div>
    </div>
  );
}

function DisagreementCard({ d }: { d: DisagreementObject }) {
  return (
    <div style={{ background: '#1a1000', border: '1px solid #fa4', borderRadius: 4, padding: 6, marginBottom: 4 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 9 }}>
        <span style={{ color: '#fa4' }}>⚡ DISAGREEMENT</span>
        <span style={{ color: '#f84' }}>severity {(d.severity * 100).toFixed(0)}%</span>
      </div>
      <div style={{ fontSize: 8, color: '#9bc', marginTop: 3 }}>
        <strong style={{ color: '#4af' }}>{d.workerA}</strong> vs <strong style={{ color: '#4af' }}>{d.workerB}</strong>
      </div>
      <div style={{ fontSize: 8, color: '#6af', marginTop: 2 }}>Topic: {d.topic.slice(0, 60)}</div>
      {d.resolved && <div style={{ fontSize: 7, color: '#00ff88', marginTop: 2 }}>✓ Resolved: {d.resolution?.slice(0, 60)}</div>}
    </div>
  );
}

export function WorkerHub({ organism }: { organism: OrganismState }) {
  const [divFilter, setDivFilter] = useState<string>('ALL');
  const enterprise = organism.enterprise;
  if (!enterprise) return <div style={{ padding: 12, color: '#3a6080', fontSize: 10 }}>Enterprise initializing…</div>;

  const divisions = ['ALL', ...new Set(enterprise.workers.map(w => w.division))];
  const filtered  = enterprise.workers.filter(w => divFilter === 'ALL' || w.division === divFilter);

  return (
    <div style={{ padding: 12, height: '100%', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: 10 }}>
      {/* Header */}
      <div style={{ fontSize: 10, color: '#4af', letterSpacing: '0.15em', textTransform: 'uppercase', borderBottom: '1px solid #1a3a5c', paddingBottom: 6 }}>
        ⬡ WORKER HUB — {enterprise.workers.length} WORKERS
      </div>

      {/* Division filter */}
      <div style={{ display: 'flex', gap: 4, flexWrap: 'wrap' }}>
        {divisions.map(div => (
          <button
            key={div}
            onClick={() => setDivFilter(div)}
            style={{
              padding: '2px 8px', fontSize: 8, borderRadius: 10,
              background: divFilter === div ? '#1a3a5c' : '#0a1a2e',
              color: divFilter === div ? '#4af' : '#3a6080',
              border: `1px solid ${divFilter === div ? '#4af' : '#1a3a5c'}`,
              cursor: 'pointer', textTransform: 'uppercase', letterSpacing: '0.06em',
            }}
          >{div}</button>
        ))}
      </div>

      {/* Worker society stats */}
      <div style={{ display: 'flex', gap: 8, fontSize: 9, color: '#6af' }}>
        <span>Active: <b style={{ color: '#00ff88' }}>{enterprise.workers.filter(w => w.status === 'active').length}</b></span>
        <span>Blocked: <b style={{ color: '#f44' }}>{enterprise.workers.filter(w => w.status === 'blocked').length}</b></span>
        <span>Disagreeing: <b style={{ color: '#fa4' }}>{enterprise.workers.filter(w => w.status === 'disagreeing').length}</b></span>
      </div>

      {/* Worker cards */}
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
        {filtered.map(w => <WorkerCard key={w.id} worker={w} />)}
      </div>

      {/* Disagreements */}
      {enterprise.disagreements.filter(d => !d.resolved).length > 0 && (
        <div>
          <div style={{ fontSize: 9, color: '#fa4', marginBottom: 4, textTransform: 'uppercase', letterSpacing: '0.1em' }}>
            Active Disagreements ({enterprise.disagreements.filter(d => !d.resolved).length})
          </div>
          {enterprise.disagreements.filter(d => !d.resolved).slice(0, 5).map(d => (
            <DisagreementCard key={d.id} d={d} />
          ))}
        </div>
      )}

      {/* Continuity status */}
      <div style={{ background: '#070e1e', border: '1px solid #1a3a5c', borderRadius: 4, padding: 8 }}>
        <div style={{ fontSize: 9, color: '#4af', marginBottom: 4, textTransform: 'uppercase', letterSpacing: '0.1em' }}>Continuity K_c</div>
        <div style={{ fontSize: 18, fontWeight: 700, color: organism.continuityScore < 0.5 ? '#f44' : '#00ff88' }}>
          {(organism.continuityScore * 100).toFixed(1)}%
        </div>
        <div style={{ fontSize: 8, color: '#3a6080' }}>The pass never drops.</div>
      </div>
    </div>
  );
}
