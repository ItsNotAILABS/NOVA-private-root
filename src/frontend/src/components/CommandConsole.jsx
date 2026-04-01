// Command Console — Mission control, HITL approve/deny, architect signal
// PARALLAX Drone Swarm Simulation — Medina Tech 2026

import React, { useState, useRef, useEffect } from 'react';

const s = {
  root: { padding: '10px', height: '100%', overflow: 'hidden', display: 'flex', flexDirection: 'column', gap: 6 },
  title: { fontSize: 10, color: '#4af', letterSpacing: '0.12em', textTransform: 'uppercase', borderBottom: '1px solid #1a3a5c', paddingBottom: 4 },
  row: { display: 'flex', gap: 6, alignItems: 'center' },
  btn: (color = '#0a1a2e', border = '#1a3a5c', text = '#4af') => ({
    padding: '3px 8px',
    fontSize: 9,
    background: color,
    border: `1px solid ${border}`,
    color: text,
    borderRadius: 3,
    cursor: 'pointer',
    letterSpacing: '0.05em',
    textTransform: 'uppercase',
  }),
  emergencyBtn: {
    padding: '4px 14px',
    fontSize: 10,
    background: '#3a0000',
    border: '1px solid #ff0000',
    color: '#ff4444',
    borderRadius: 3,
    cursor: 'pointer',
    letterSpacing: '0.1em',
    textTransform: 'uppercase',
    fontWeight: 'bold',
  },
  label: { fontSize: 9, color: '#6af' },
  input: {
    flex: 1,
    background: '#0a1a2e',
    border: '1px solid #1a3a5c',
    color: '#adf',
    fontSize: 9,
    padding: '2px 6px',
    borderRadius: 3,
  },
  slider: { flex: 1, accentColor: '#4af' },
  hitlList: { flex: 1, overflow: 'auto' },
  hitlItem: {
    background: '#0a1a2e',
    border: '1px solid #ff8800',
    borderRadius: 3,
    padding: '4px 6px',
    marginBottom: 3,
    fontSize: 9,
  },
  logArea: { height: 80, overflow: 'auto', background: '#020609', borderRadius: 3, padding: '3px 5px', fontSize: 8, color: '#48a', border: '1px solid #0a1a2e' },
  logEntry: (kind) => ({
    color: kind === 'EMERGENCY_STOP' ? '#f44' :
           kind === 'HITL_APPROVED' ? '#4f8' :
           kind === 'HITL_DENIED'   ? '#f84' :
           kind === 'OMNIS_STATE'   ? '#ffd700' :
           kind === 'DRONE_SACRIFICED' ? '#f84' : '#48a',
    marginBottom: 1,
  }),
  statusBadge: (status) => ({
    display: 'inline-block',
    padding: '1px 5px',
    borderRadius: 8,
    fontSize: 8,
    background: status === 'ACTIVE' ? '#003322' : status === 'EMERGENCY_STOP' ? '#330000' : '#0a1a2e',
    color: status === 'ACTIVE' ? '#00ff88' : status === 'EMERGENCY_STOP' ? '#ff4444' : '#4af',
    border: status === 'ACTIVE' ? '1px solid #00ff88' : '1px solid #1a3a5c',
  }),
};

function timeLeft(deadline) {
  const ms = Math.max(0, deadline - Date.now());
  return (ms / 1000).toFixed(0) + 's';
}

export default function CommandConsole({ swarm }) {
  const {
    missionStatus, missionName, emergencyActive, commsLost,
    pendingActions, auditLog,
    approve, deny, emergencyStop, startMission, heartbeat,
    architectSignal, setArchitectSignal,
  } = swarm;

  const [missionInput, setMissionInput] = useState('');
  const logRef = useRef(null);

  useEffect(() => {
    if (logRef.current) {
      logRef.current.scrollTop = logRef.current.scrollHeight;
    }
  }, [auditLog]);

  return (
    <div style={s.root}>
      <div style={s.title}>⬡ Command Console</div>

      {/* Mission status + start */}
      <div style={s.row}>
        <span style={s.statusBadge(missionStatus)}>{missionStatus}</span>
        {missionStatus === 'ACTIVE' && (
          <span style={{ fontSize: 9, color: '#adf' }}>{missionName}</span>
        )}
        <input
          style={s.input}
          value={missionInput}
          onChange={e => setMissionInput(e.target.value)}
          placeholder="mission name"
        />
        <button
          style={s.btn('#002233', '#1a3a5c', '#4af')}
          onClick={() => { if (missionInput) { startMission(missionInput); setMissionInput(''); } }}
          disabled={emergencyActive}
        >
          START
        </button>
      </div>

      {/* Architect Signal slider */}
      <div style={s.row}>
        <span style={s.label}>Architect Signal</span>
        <input
          type="range" min={0} max={2} step={0.05}
          value={architectSignal}
          onChange={e => setArchitectSignal(Number(e.target.value))}
          style={s.slider}
        />
        <span style={{ ...s.label, color: '#ffd700', minWidth: 30 }}>{architectSignal.toFixed(2)}x</span>
      </div>

      {/* Emergency Stop */}
      <div style={s.row}>
        <button style={s.emergencyBtn} onClick={emergencyStop} disabled={emergencyActive}>
          ⛔ EMERGENCY STOP
        </button>
        {emergencyActive && <span style={{ fontSize: 9, color: '#f44' }}>ACTIVE</span>}
      </div>

      {/* Comms heartbeat (Law 23: Observer Independence) */}
      <div style={s.row}>
        <button
          style={s.btn('#001122', '#1a3a5c', '#44ccff')}
          onClick={heartbeat}
          title="Ping the swarm to keep comms alive (timeout: 60s)"
        >
          📡 HEARTBEAT
        </button>
        {commsLost && (
          <span style={{ fontSize: 9, color: '#ffaa00', fontWeight: 'bold' }}>
            ⚠ COMMS LOST — Swarm autonomous (Law 23)
          </span>
        )}
      </div>

      {/* HITL approvals */}
      {pendingActions.length > 0 && (
        <div style={s.hitlList}>
          <div style={{ ...s.label, color: '#ff8800', marginBottom: 4 }}>
            HITL QUEUE ({pendingActions.length})
          </div>
          {pendingActions.map(req => (
            <div key={req.id} style={s.hitlItem}>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 2 }}>
                <span style={{ color: '#ffa', fontWeight: 'bold' }}>
                  {req.action} — D{req.droneId}
                </span>
                <span style={{ color: '#f84', fontSize: 8 }}>⏱{timeLeft(req.deadline)}</span>
              </div>
              <div style={{ color: '#8af', fontSize: 8, marginBottom: 3 }}>{req.reason.slice(0, 60)}</div>
              <div style={s.row}>
                <button
                  style={s.btn('#003322', '#00aa44', '#00ff88')}
                  onClick={() => approve(req.id)}
                  disabled={emergencyActive}
                >
                  ✓ APPROVE
                </button>
                <button
                  style={s.btn('#330000', '#aa2200', '#ff6644')}
                  onClick={() => deny(req.id)}
                >
                  ✗ DENY
                </button>
                <span style={{ fontSize: 8, color: '#68a' }}>
                  r={req.rSwarm.toFixed(3)} J={req.jDrift.toFixed(3)}
                </span>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Audit log */}
      <div style={s.label}>Swarm Log</div>
      <div style={s.logArea} ref={logRef}>
        {auditLog.slice(-30).map((entry, i) => (
          <div key={i} style={s.logEntry(entry.kind)}>
            [{entry.beat}] {entry.kind}{entry.droneId != null ? ` D${entry.droneId}` : ''} — {entry.description.slice(0, 60)}
          </div>
        ))}
      </div>
    </div>
  );
}
