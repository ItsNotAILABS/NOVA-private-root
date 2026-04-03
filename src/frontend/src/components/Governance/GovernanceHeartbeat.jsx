// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Component: GovernanceHeartbeat — Sovereign Governance System
// PARALLAX Drone Swarm Simulation — Medina Tech 2026
//
// Complete governance system:
//   - Sabbath protocol compliance
//   - Jubilee cycles
//   - Biblical laws integration
//   - Voting mechanisms
//   - Emergency succession
//   - Creator reserve management
//   - Heartbeat monitoring
// ============================================================================

import React, { useState, useMemo, useEffect } from 'react';

const φ = 1.6180339887498948482;

// ─── GOVERNANCE STATES ────────────────────────────────────────────────────────
const GOVERNANCE_STATES = {
  active: { color: '#00ff88', label: 'ACTIVE', icon: '💚' },
  sabbath: { color: '#aa44ff', label: 'SABBATH', icon: '🕯️' },
  jubilee: { color: '#ffd700', label: 'JUBILEE', icon: '🎺' },
  emergency: { color: '#ff4444', label: 'EMERGENCY', icon: '🚨' },
  transition: { color: '#ffaa00', label: 'TRANSITION', icon: '⏳' },
  suspended: { color: '#888888', label: 'SUSPENDED', icon: '⏸️' },
};

// ─── BIBLICAL LAWS ────────────────────────────────────────────────────────────
const BIBLICAL_LAWS = [
  { id: 1, name: 'Creator Sovereignty', description: 'The creator maintains ultimate authority', active: true },
  { id: 2, name: 'Sabbath Rest', description: 'Every 7th cycle, systems rest and consolidate', active: true },
  { id: 3, name: 'Jubilee Reset', description: 'Every 50th cycle, debts forgiven and land returned', active: true },
  { id: 4, name: 'Fair Weights', description: 'All measurements must be accurate and honest', active: true },
  { id: 5, name: 'No Usury', description: 'No exploitative interest on loans', active: true },
  { id: 6, name: 'Gleaning Rights', description: 'Leave resources for the less fortunate', active: true },
  { id: 7, name: 'Cities of Refuge', description: 'Safe zones must exist for protection', active: true },
  { id: 8, name: 'Witness Requirement', description: 'Major decisions require multiple confirmations', active: true },
];

// ─── HEARTBEAT MONITOR ────────────────────────────────────────────────────────
function HeartbeatMonitor({ heartbeat, history }) {
  const [pulse, setPulse] = useState(false);
  
  useEffect(() => {
    const interval = setInterval(() => {
      setPulse(p => !p);
    }, 1000 / (heartbeat.bpm / 60));
    
    return () => clearInterval(interval);
  }, [heartbeat.bpm]);
  
  const maxBpm = Math.max(...history.map(h => h.bpm), heartbeat.bpm);
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: `1px solid ${heartbeat.healthy ? '#00ff88' : '#ff4444'}`,
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
        <div style={{
          width: 20,
          height: 20,
          borderRadius: '50%',
          background: heartbeat.healthy ? '#00ff88' : '#ff4444',
          opacity: pulse ? 1 : 0.3,
          transition: 'opacity 0.1s',
          boxShadow: pulse ? `0 0 15px ${heartbeat.healthy ? '#00ff88' : '#ff4444'}` : 'none',
        }} />
        <div style={{ fontSize: 10, color: '#6af' }}>GOVERNANCE HEARTBEAT</div>
        <div style={{
          marginLeft: 'auto',
          fontSize: 9,
          padding: '2px 8px',
          borderRadius: 8,
          background: heartbeat.healthy ? '#003322' : '#330000',
          color: heartbeat.healthy ? '#00ff88' : '#ff4444',
        }}>
          {heartbeat.healthy ? 'HEALTHY' : 'CRITICAL'}
        </div>
      </div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 8, marginBottom: 12 }}>
        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: 24, color: '#00ff88' }}>{heartbeat.bpm}</div>
          <div style={{ fontSize: 8, color: '#68a' }}>BPM</div>
        </div>
        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: 24, color: '#4af' }}>{heartbeat.uptime}%</div>
          <div style={{ fontSize: 8, color: '#68a' }}>Uptime</div>
        </div>
        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: 24, color: '#ffd700' }}>{heartbeat.latency}ms</div>
          <div style={{ fontSize: 8, color: '#68a' }}>Latency</div>
        </div>
      </div>
      
      {/* Heartbeat graph */}
      <div style={{
        height: 50,
        display: 'flex',
        alignItems: 'flex-end',
        gap: 2,
        padding: 4,
        background: '#050a14',
        borderRadius: 4,
      }}>
        {history.slice(-30).map((h, i) => (
          <div
            key={i}
            style={{
              flex: 1,
              height: `${(h.bpm / maxBpm) * 100}%`,
              background: h.healthy ? '#00ff88' : '#ff4444',
              borderRadius: '2px 2px 0 0',
              opacity: 0.5 + (i / 30) * 0.5,
            }}
          />
        ))}
      </div>
    </div>
  );
}

// ─── SABBATH CYCLE ────────────────────────────────────────────────────────────
function SabbathCycle({ currentCycle, nextSabbath, inSabbath }) {
  const progress = ((currentCycle % 7) / 7) * 100;
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: `1px solid ${inSabbath ? '#aa44ff' : '#1a3a5c'}`,
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
        <span style={{ fontSize: 20 }}>🕯️</span>
        <div style={{ fontSize: 10, color: '#aa44ff' }}>SABBATH CYCLE</div>
        {inSabbath && (
          <span style={{
            marginLeft: 'auto',
            fontSize: 9,
            padding: '2px 8px',
            borderRadius: 8,
            background: '#2a0044',
            color: '#aa44ff',
            border: '1px solid #aa44ff',
          }}>
            IN SABBATH
          </span>
        )}
      </div>
      
      <div style={{ marginBottom: 8 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 9, marginBottom: 2 }}>
          <span style={{ color: '#68a' }}>Cycle Progress</span>
          <span style={{ color: '#aa44ff' }}>{currentCycle % 7}/7</span>
        </div>
        <div style={{
          height: 8,
          background: '#050a14',
          borderRadius: 4,
          overflow: 'hidden',
        }}>
          <div style={{
            width: `${progress}%`,
            height: '100%',
            background: 'linear-gradient(90deg, #aa44ff, #ffd700)',
          }} />
        </div>
      </div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', gap: 2 }}>
        {[1, 2, 3, 4, 5, 6, 7].map(day => (
          <div
            key={day}
            style={{
              aspectRatio: '1',
              borderRadius: 4,
              background: day === 7 ? '#aa44ff' :
                         day <= (currentCycle % 7) ? '#1a3a5c' : '#050a14',
              border: `1px solid ${day === 7 ? '#aa44ff' : '#1a3a5c'}`,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: 9,
              color: day === 7 ? '#ffd700' : '#68a',
            }}
          >
            {day}
          </div>
        ))}
      </div>
      
      <div style={{ fontSize: 8, color: '#68a', marginTop: 8 }}>
        Next Sabbath: Cycle {nextSabbath}
      </div>
    </div>
  );
}

// ─── JUBILEE TRACKER ──────────────────────────────────────────────────────────
function JubileeTracker({ currentCycle, nextJubilee, inJubilee }) {
  const progress = ((currentCycle % 50) / 50) * 100;
  const cyclesRemaining = 50 - (currentCycle % 50);
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: `1px solid ${inJubilee ? '#ffd700' : '#1a3a5c'}`,
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
        <span style={{ fontSize: 20 }}>🎺</span>
        <div style={{ fontSize: 10, color: '#ffd700' }}>JUBILEE CYCLE</div>
        {inJubilee && (
          <span style={{
            marginLeft: 'auto',
            fontSize: 9,
            padding: '2px 8px',
            borderRadius: 8,
            background: '#3a3a00',
            color: '#ffd700',
            border: '1px solid #ffd700',
            animation: 'pulse 1s infinite',
          }}>
            🎺 JUBILEE ACTIVE
          </span>
        )}
      </div>
      
      <div style={{ marginBottom: 8 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 9, marginBottom: 2 }}>
          <span style={{ color: '#68a' }}>50-Cycle Progress</span>
          <span style={{ color: '#ffd700' }}>{currentCycle % 50}/50</span>
        </div>
        <div style={{
          height: 12,
          background: '#050a14',
          borderRadius: 6,
          overflow: 'hidden',
          position: 'relative',
        }}>
          <div style={{
            width: `${progress}%`,
            height: '100%',
            background: 'linear-gradient(90deg, #ffd700, #ff8800)',
          }} />
          {/* Sabbath markers */}
          {[7, 14, 21, 28, 35, 42, 49].map(s => (
            <div key={s} style={{
              position: 'absolute',
              left: `${(s / 50) * 100}%`,
              top: 0,
              bottom: 0,
              width: 1,
              background: '#aa44ff',
            }} />
          ))}
        </div>
      </div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 8 }}>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Cycles Remaining</div>
          <div style={{ fontSize: 16, color: '#ffd700' }}>{cyclesRemaining}</div>
        </div>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Next Jubilee</div>
          <div style={{ fontSize: 16, color: '#ffd700' }}>Cycle {nextJubilee}</div>
        </div>
      </div>
      
      {inJubilee && (
        <div style={{
          marginTop: 8,
          padding: 8,
          borderRadius: 6,
          background: '#2a2a00',
          border: '1px solid #ffd700',
        }}>
          <div style={{ fontSize: 9, color: '#ffd700', marginBottom: 4 }}>JUBILEE EFFECTS ACTIVE:</div>
          <div style={{ fontSize: 8, color: '#adf' }}>• All debts forgiven</div>
          <div style={{ fontSize: 8, color: '#adf' }}>• Territory returned to original owners</div>
          <div style={{ fontSize: 8, color: '#adf' }}>• Full system reset and optimization</div>
        </div>
      )}
    </div>
  );
}

// ─── CREATOR RESERVE ──────────────────────────────────────────────────────────
function CreatorReserve({ reserve }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #ffd700',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ fontSize: 10, color: '#ffd700', marginBottom: 8 }}>👑 CREATOR RESERVE</div>
      
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 12, marginBottom: 12 }}>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>FORMA Tokens</div>
          <div style={{ fontSize: 18, color: '#ffd700' }}>
            {reserve.formaTokens?.toLocaleString() || 0}
          </div>
        </div>
        <div>
          <div style={{ fontSize: 8, color: '#68a' }}>Reserve %</div>
          <div style={{ fontSize: 18, color: '#00ff88' }}>
            {reserve.percentage?.toFixed(1) || 0}%
          </div>
        </div>
      </div>
      
      <div style={{ marginBottom: 8 }}>
        <div style={{ fontSize: 9, color: '#6af', marginBottom: 4 }}>VESTING SCHEDULE</div>
        <div style={{
          height: 8,
          background: '#050a14',
          borderRadius: 4,
          overflow: 'hidden',
        }}>
          <div style={{
            width: `${reserve.vested || 0}%`,
            height: '100%',
            background: '#ffd700',
          }} />
        </div>
        <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 7, color: '#68a', marginTop: 2 }}>
          <span>{reserve.vested?.toFixed(1) || 0}% vested</span>
          <span>{reserve.vestingPeriod || 'N/A'}</span>
        </div>
      </div>
      
      <div style={{ fontSize: 8, color: '#68a' }}>
        Last withdrawal: {reserve.lastWithdrawal || 'Never'}
      </div>
    </div>
  );
}

// ─── VOTING PANEL ─────────────────────────────────────────────────────────────
function VotingPanel({ proposals }) {
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #4488ff',
      borderRadius: 8,
      padding: 12,
      maxHeight: 200,
      overflow: 'auto',
    }}>
      <div style={{ fontSize: 10, color: '#4488ff', marginBottom: 8 }}>🗳️ ACTIVE PROPOSALS</div>
      
      {proposals.length === 0 ? (
        <div style={{ fontSize: 9, color: '#68a' }}>No active proposals</div>
      ) : (
        proposals.map(proposal => (
          <div key={proposal.id} style={{
            padding: 8,
            marginBottom: 6,
            borderRadius: 6,
            background: '#050a14',
            border: '1px solid #1a3a5c',
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
              <span style={{ fontSize: 9, color: '#adf' }}>{proposal.title}</span>
              <span style={{
                fontSize: 8,
                color: proposal.status === 'active' ? '#00ff88' : '#ffaa00',
              }}>
                {proposal.status?.toUpperCase()}
              </span>
            </div>
            
            <div style={{ display: 'flex', gap: 8, marginBottom: 4 }}>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 7, color: '#68a' }}>For</div>
                <div style={{
                  height: 4,
                  background: '#00ff88',
                  borderRadius: 2,
                  width: `${proposal.forVotes}%`,
                }} />
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 7, color: '#68a' }}>Against</div>
                <div style={{
                  height: 4,
                  background: '#ff4444',
                  borderRadius: 2,
                  width: `${proposal.againstVotes}%`,
                }} />
              </div>
            </div>
            
            <div style={{ fontSize: 7, color: '#68a' }}>
              Ends: {proposal.endTime || 'Unknown'}
            </div>
          </div>
        ))
      )}
    </div>
  );
}

// ─── LAWS COMPLIANCE ──────────────────────────────────────────────────────────
function LawsCompliance({ laws }) {
  const compliant = laws.filter(l => l.active).length;
  const total = laws.length;
  
  return (
    <div style={{
      background: '#0a1a2e',
      border: '1px solid #00ff88',
      borderRadius: 8,
      padding: 12,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
        <span style={{ fontSize: 16 }}>📜</span>
        <div style={{ fontSize: 10, color: '#00ff88' }}>BIBLICAL LAWS</div>
        <span style={{
          marginLeft: 'auto',
          fontSize: 9,
          color: compliant === total ? '#00ff88' : '#ffaa00',
        }}>
          {compliant}/{total} COMPLIANT
        </span>
      </div>
      
      <div style={{ maxHeight: 150, overflow: 'auto' }}>
        {laws.map(law => (
          <div key={law.id} style={{
            display: 'flex',
            alignItems: 'center',
            gap: 8,
            padding: '4px 0',
            borderBottom: '1px solid #1a3a5c',
          }}>
            <span style={{
              color: law.active ? '#00ff88' : '#ff4444',
              fontSize: 12,
            }}>
              {law.active ? '✓' : '✗'}
            </span>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 9, color: '#adf' }}>{law.name}</div>
              <div style={{ fontSize: 7, color: '#68a' }}>{law.description}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// ─── STYLES ───────────────────────────────────────────────────────────────────
const styles = {
  root: {
    display: 'flex',
    flexDirection: 'column',
    height: '100%',
    background: '#070e1e',
    border: '1px solid #1a3a5c',
    borderRadius: 4,
    overflow: 'hidden',
  },
  header: {
    padding: '10px 12px',
    borderBottom: '1px solid #1a3a5c',
    display: 'flex',
    alignItems: 'center',
    gap: 8,
  },
  title: {
    fontSize: 12,
    color: '#ffd700',
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
  },
  content: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: 'repeat(2, 1fr)',
    gap: 10,
    padding: 10,
    overflow: 'auto',
  },
};

// ─── MAIN COMPONENT ───────────────────────────────────────────────────────────
export default function GovernanceHeartbeat({ governanceState = {} }) {
  // Sample state if none provided
  const state = {
    status: governanceState.status || 'active',
    currentCycle: governanceState.currentCycle || 147,
    inSabbath: governanceState.inSabbath || false,
    inJubilee: governanceState.inJubilee || false,
    heartbeat: governanceState.heartbeat || {
      bpm: 60,
      uptime: 99.97,
      latency: 12,
      healthy: true,
    },
    heartbeatHistory: governanceState.heartbeatHistory || Array.from({ length: 30 }, () => ({
      bpm: 55 + Math.random() * 15,
      healthy: Math.random() > 0.05,
    })),
    creatorReserve: governanceState.creatorReserve || {
      formaTokens: 1000000000,
      percentage: 10,
      vested: 25,
      vestingPeriod: '4 years',
      lastWithdrawal: 'Cycle 100',
    },
    proposals: governanceState.proposals || [
      { id: 1, title: 'Increase drone production rate', status: 'active', forVotes: 65, againstVotes: 35, endTime: 'Cycle 150' },
      { id: 2, title: 'Territory expansion to sector 7', status: 'active', forVotes: 82, againstVotes: 18, endTime: 'Cycle 152' },
    ],
    laws: BIBLICAL_LAWS,
  };
  
  const statusData = GOVERNANCE_STATES[state.status] || GOVERNANCE_STATES.active;
  
  return (
    <div style={styles.root}>
      <div style={styles.header}>
        <span style={{ fontSize: 20 }}>{statusData.icon}</span>
        <span style={styles.title}>Governance Heartbeat</span>
        <span style={{
          fontSize: 9,
          padding: '2px 8px',
          borderRadius: 8,
          background: `${statusData.color}22`,
          color: statusData.color,
          border: `1px solid ${statusData.color}`,
        }}>
          {statusData.label}
        </span>
        <span style={{ fontSize: 9, color: '#68a', marginLeft: 'auto' }}>
          Cycle {state.currentCycle}
        </span>
      </div>
      
      <div style={styles.content}>
        <HeartbeatMonitor heartbeat={state.heartbeat} history={state.heartbeatHistory} />
        <SabbathCycle
          currentCycle={state.currentCycle}
          nextSabbath={Math.ceil(state.currentCycle / 7) * 7}
          inSabbath={state.inSabbath}
        />
        <JubileeTracker
          currentCycle={state.currentCycle}
          nextJubilee={Math.ceil(state.currentCycle / 50) * 50}
          inJubilee={state.inJubilee}
        />
        <CreatorReserve reserve={state.creatorReserve} />
        <VotingPanel proposals={state.proposals} />
        <LawsCompliance laws={state.laws} />
      </div>
    </div>
  );
}
