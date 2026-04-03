// ─── NOVA / PARALLAX — Presence Board Component ──────────────────────────────
// Who is active, idle, focused, overloaded. Space heat. Company pulse.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026

import React from 'react';
import type { OrganismState } from '../../hooks/useOrganismState';
import type { UserPresence, SpacePresence, TeamPulse } from '../../types/organism';

const PRESENCE_COLOR: Record<string, string> = {
  active:     '#00ff88',
  idle:       '#1a3a5c',
  focused:    '#4af',
  reviewing:  '#fa4',
  overloaded: '#f44',
  offline:    '#111',
};

function UserDot({ user }: { user: UserPresence }) {
  const col = PRESENCE_COLOR[user.presence] ?? '#111';
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 6, padding: '3px 0', fontSize: 9, color: '#9bc' }}>
      <div style={{ width: 8, height: 8, borderRadius: '50%', background: col, flexShrink: 0 }} />
      <span style={{ flex: 1 }}>{user.name}</span>
      <span style={{ fontSize: 8, color: '#3a6080' }}>{user.division}</span>
      <span style={{ fontSize: 8, color: user.loadPulse > 0.7 ? '#f44' : '#246' }}>
        {(user.loadPulse * 100).toFixed(0)}%
      </span>
    </div>
  );
}

function SpaceCard({ space }: { space: SpacePresence }) {
  const heatColor = space.heat > 0.7 ? '#f44' : space.heat > 0.4 ? '#fa4' : '#4af';
  return (
    <div style={{ background: '#070e1e', border: `1px solid ${heatColor}44`, borderRadius: 4, padding: 6, marginBottom: 4 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 9 }}>
        <span style={{ color: '#9bc' }}>{space.name}</span>
        <span style={{ color: heatColor }}>🔥 {(space.heat * 100).toFixed(0)}%</span>
      </div>
      <div style={{ fontSize: 8, color: '#3a6080', marginTop: 2 }}>
        {space.users.length} users · {space.workers.length} workers
      </div>
      <div style={{ height: 3, background: '#0a1a2e', borderRadius: 2, marginTop: 4, overflow: 'hidden' }}>
        <div style={{ height: '100%', width: `${space.heat * 100}%`, background: heatColor, borderRadius: 2 }} />
      </div>
    </div>
  );
}

function TeamPulseCard({ team }: { team: TeamPulse }) {
  const lpColor = team.loadPulse > 0.7 ? '#f44' : team.loadPulse > 0.4 ? '#fa4' : '#00ff88';
  return (
    <div style={{ background: '#070e1e', border: '1px solid #1a3a5c', borderRadius: 4, padding: '6px 8px', marginBottom: 4 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 9, marginBottom: 4 }}>
        <span style={{ color: '#9bc', fontWeight: 600 }}>{team.division}</span>
        {team.stalling && <span style={{ color: '#f44', fontSize: 8 }}>⚠ STALLING</span>}
      </div>
      <div style={{ display: 'flex', gap: 8, fontSize: 8, color: '#3a6080' }}>
        <span>L_p <b style={{ color: lpColor }}>{(team.loadPulse * 100).toFixed(0)}%</b></span>
        <span>T_s <b style={{ color: '#4af' }}>{(team.trust * 100).toFixed(0)}%</b></span>
        <span>A_s <b style={{ color: '#f84' }}>{(team.anomaly * 100).toFixed(0)}%</b></span>
      </div>
    </div>
  );
}

export function PresenceBoard({ organism }: { organism: OrganismState }) {
  const enterprise = organism.enterprise;
  const users  = enterprise?.users  ?? [];
  const spaces = enterprise?.spaces ?? [];
  const teams  = enterprise?.teams  ?? [];

  const active    = users.filter(u => u.presence === 'active').length;
  const overloaded = users.filter(u => u.presence === 'overloaded').length;
  const companyPulse = enterprise?.companyPulse ?? 0.2;

  return (
    <div style={{ padding: 12, height: '100%', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: 10 }}>
      {/* Header */}
      <div style={{ fontSize: 10, color: '#4af', letterSpacing: '0.15em', textTransform: 'uppercase', borderBottom: '1px solid #1a3a5c', paddingBottom: 6 }}>
        ⬡ PRESENCE BOARD
      </div>

      {/* Company pulse */}
      <div style={{ background: '#070e1e', border: '1px solid #1a3a5c', borderRadius: 4, padding: 8 }}>
        <div style={{ fontSize: 9, color: '#4af', marginBottom: 4, textTransform: 'uppercase', letterSpacing: '0.1em' }}>Company Pulse L_p</div>
        <div style={{ fontSize: 22, fontWeight: 700, color: companyPulse > 0.7 ? '#f44' : '#00ff88' }}>
          {(companyPulse * 100).toFixed(1)}%
        </div>
        <div style={{ display: 'flex', gap: 12, fontSize: 9, color: '#6af', marginTop: 4 }}>
          <span>Active: <b style={{ color: '#00ff88' }}>{active}</b></span>
          <span>Overloaded: <b style={{ color: '#f44' }}>{overloaded}</b></span>
          <span>Total: {users.length}</span>
        </div>
      </div>

      {/* Presence legend */}
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
        {Object.entries(PRESENCE_COLOR).map(([state, color]) => (
          <span key={state} style={{ fontSize: 8, color, display: 'flex', alignItems: 'center', gap: 3 }}>
            <span style={{ width: 6, height: 6, borderRadius: '50%', background: color, display: 'inline-block' }} />
            {state}
          </span>
        ))}
      </div>

      {/* Users */}
      {users.length > 0 && (
        <div style={{ background: '#070e1e', border: '1px solid #1a3a5c', borderRadius: 4, padding: 8 }}>
          <div style={{ fontSize: 9, color: '#4af', marginBottom: 4, textTransform: 'uppercase', letterSpacing: '0.1em' }}>Users</div>
          {users.map(u => <UserDot key={u.userId} user={u} />)}
        </div>
      )}

      {/* Hot spaces */}
      {spaces.length > 0 && (
        <div>
          <div style={{ fontSize: 9, color: '#4af', marginBottom: 4, textTransform: 'uppercase', letterSpacing: '0.1em' }}>Spaces</div>
          {spaces.map(s => <SpaceCard key={s.spaceId} space={s} />)}
        </div>
      )}

      {/* Team pulses */}
      {teams.length > 0 && (
        <div>
          <div style={{ fontSize: 9, color: '#4af', marginBottom: 4, textTransform: 'uppercase', letterSpacing: '0.1em' }}>Team Pulses</div>
          {teams.map(t => <TeamPulseCard key={t.teamId} team={t} />)}
        </div>
      )}

      {users.length === 0 && spaces.length === 0 && teams.length === 0 && (
        <div style={{ fontSize: 10, color: '#3a6080', textAlign: 'center', marginTop: 24 }}>
          No presence data yet. Users will appear as they connect.
        </div>
      )}
    </div>
  );
}
