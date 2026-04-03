// ─── NOVA / PARALLAX — Artifact Studio Component ─────────────────────────────
// Browse, create, and manage first-class artifact objects.
// Shows lineage, trust, continuity, approvals per artifact.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026

import React, { useState } from 'react';
import type { OrganismState } from '../../hooks/useOrganismState';
import type { Artifact, ArtifactClass, ReviewState } from '../../types/organism';

const CLASS_COLORS: Record<string, string> = {
  brief:             '#4af',
  memo:              '#4af',
  summary:           '#4af',
  executive_digest:  '#ffd700',
  pm_update:         '#00ff88',
  decision_packet:   '#ff8800',
  approval_packet:   '#ff8800',
  proposal:          '#c4f',
  estimate_packet:   '#88ccff',
  handoff_packet:    '#88ff44',
  risk_report:       '#f44',
  anomaly_report:    '#f44',
  continuity_report: '#00aaff',
  meeting_artifact:  '#6af',
  simulation_artifact: '#c4f',
  release_artifact:  '#00ff88',
  external_share:    '#ffd700',
};

const REVIEW_BADGE: Record<ReviewState, { color: string; label: string }> = {
  draft:      { color: '#3a6080', label: 'DRAFT' },
  in_review:  { color: '#fa4',    label: 'REVIEW' },
  approved:   { color: '#00ff88', label: 'APPROVED' },
  rejected:   { color: '#f44',    label: 'REJECTED' },
  archived:   { color: '#246',    label: 'ARCHIVED' },
};

function TrustRing({ value, size = 32 }: { value: number; size?: number }) {
  const r = size / 2 - 3;
  const circ = 2 * Math.PI * r;
  const dash = circ * value;
  const color = value > 0.7 ? '#00ff88' : value > 0.5 ? '#fa4' : '#f44';
  return (
    <svg width={size} height={size} style={{ flexShrink: 0 }}>
      <circle cx={size/2} cy={size/2} r={r} fill="none" stroke="#0a1a2e" strokeWidth={2.5} />
      <circle cx={size/2} cy={size/2} r={r} fill="none" stroke={color} strokeWidth={2.5}
        strokeDasharray={`${dash} ${circ}`} strokeLinecap="round"
        transform={`rotate(-90 ${size/2} ${size/2})`} />
      <text x={size/2} y={size/2 + 3} textAnchor="middle" fontSize={7} fill={color} fontWeight={700}>
        {Math.round(value * 100)}
      </text>
    </svg>
  );
}

function ArtifactCard({ art }: { art: Artifact }) {
  const cls   = art.cls as string;
  const color = CLASS_COLORS[cls] ?? '#4af';
  const badge = REVIEW_BADGE[art.reviewState];
  return (
    <div style={{
      background: '#070e1e', border: `1px solid ${color}44`, borderRadius: 5,
      padding: 8, display: 'flex', gap: 8, alignItems: 'flex-start',
    }}>
      <TrustRing value={art.trustScore} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 2 }}>
          <span style={{ fontSize: 9, color, fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.06em' }}>{cls.replace(/_/g, ' ')}</span>
          <span style={{ fontSize: 7, color: badge.color, padding: '1px 5px', border: `1px solid ${badge.color}55`, borderRadius: 8 }}>{badge.label}</span>
        </div>
        <div style={{ fontSize: 10, color: '#9bc', fontWeight: 600, marginBottom: 2, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
          {art.title}
        </div>
        <div style={{ fontSize: 8, color: '#3a6080' }}>
          by {art.workerAuthor} · {art.divisionId} · v{art.version} · beat {art.beat}
        </div>
        <div style={{ display: 'flex', gap: 8, marginTop: 4, fontSize: 8 }}>
          <span style={{ color: '#4af' }}>T_a {(art.trustScore * 100).toFixed(0)}%</span>
          <span style={{ color: '#00ff88' }}>K_c {(art.continuityScore * 100).toFixed(0)}%</span>
          <span style={{ color: '#f44' }}>A_s {(art.anomalyBurden * 100).toFixed(0)}%</span>
          <span style={{ color: '#246' }}>{art.approvals.length} approvals · {art.comments.length} comments</span>
        </div>
        {art.lineage.length > 0 && (
          <div style={{ fontSize: 7, color: '#246', marginTop: 2 }}>
            Lineage: {art.lineage.slice(0, 3).join(' → ')}
          </div>
        )}
      </div>
    </div>
  );
}

export function ArtifactStudio({ organism }: { organism: OrganismState }) {
  const [clsFilter, setClsFilter] = useState<string>('all');
  const [reviewFilter, setReviewFilter] = useState<string>('all');

  const artifacts = organism.enterprise?.recentArtifacts ?? [];
  const filtered = artifacts.filter(a => {
    if (clsFilter  !== 'all' && a.cls          !== clsFilter)  return false;
    if (reviewFilter !== 'all' && a.reviewState !== reviewFilter) return false;
    return true;
  });

  const reviewStates: ReviewState[] = ['draft', 'in_review', 'approved', 'rejected', 'archived'];

  return (
    <div style={{ padding: 12, height: '100%', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: 10 }}>
      {/* Header */}
      <div style={{ fontSize: 10, color: '#4af', letterSpacing: '0.15em', textTransform: 'uppercase', borderBottom: '1px solid #1a3a5c', paddingBottom: 6 }}>
        ⬡ ARTIFACT STUDIO — {artifacts.length} ARTIFACTS
      </div>

      {/* Stats row */}
      <div style={{ display: 'flex', gap: 12, fontSize: 9, color: '#6af' }}>
        {reviewStates.map(rs => (
          <span key={rs}>
            <b style={{ color: REVIEW_BADGE[rs].color }}>{artifacts.filter(a => a.reviewState === rs).length}</b> {rs}
          </span>
        ))}
      </div>

      {/* Review state filter */}
      <div style={{ display: 'flex', gap: 4, flexWrap: 'wrap' }}>
        {['all', ...reviewStates].map(rs => (
          <button key={rs} onClick={() => setReviewFilter(rs)} style={{
            padding: '2px 8px', fontSize: 8, borderRadius: 10, cursor: 'pointer', textTransform: 'uppercase',
            background: reviewFilter === rs ? '#1a3a5c' : '#0a1a2e',
            color:      reviewFilter === rs ? '#4af' : '#3a6080',
            border:     `1px solid ${reviewFilter === rs ? '#4af' : '#1a3a5c'}`,
          }}>{rs}</button>
        ))}
      </div>

      {/* Artifact list */}
      {filtered.length === 0
        ? <div style={{ fontSize: 10, color: '#3a6080', textAlign: 'center', marginTop: 24 }}>No artifacts yet. Workers are producing…</div>
        : <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
            {filtered.map(a => <ArtifactCard key={a.id} art={a} />)}
          </div>
      }
    </div>
  );
}
