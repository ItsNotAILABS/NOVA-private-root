// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Agent Roster Component
// ═══════════════════════════════════════════════════════════════════════════════

import React from 'react';
import type { Agent } from './OroCommandCenter';

const S = {
  root: {
    flex: 1,
    overflow: 'auto',
    padding: '8px',
  },
  agentCard: (selected: boolean, status: string) => ({
    background: selected
      ? 'linear-gradient(135deg, #1a4a7a, #0a3a5a)'
      : 'rgba(10, 30, 50, 0.6)',
    border: `1px solid ${selected ? '#4af' : status === 'Working' ? '#4f8' : '#1a3a5c'}`,
    borderRadius: 8,
    padding: '12px',
    marginBottom: 8,
    cursor: 'pointer',
    transition: 'all 0.2s',
  }),
  agentHeader: {
    display: 'flex',
    alignItems: 'center',
    gap: 10,
    marginBottom: 8,
  },
  avatar: {
    width: 36,
    height: 36,
    borderRadius: '50%',
    background: 'linear-gradient(135deg, #2a5a8a, #1a3a5a)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontSize: 18,
  },
  agentName: {
    fontSize: 13,
    fontWeight: 'bold',
    color: '#fff',
  },
  agentRole: {
    fontSize: 9,
    color: '#6a9aca',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
  },
  statusBadge: (status: string) => ({
    marginLeft: 'auto',
    padding: '2px 8px',
    borderRadius: 10,
    fontSize: 8,
    textTransform: 'uppercase' as const,
    letterSpacing: '0.08em',
    background:
      status === 'Working' ? '#0a3a2a' :
      status === 'Thinking' ? '#3a3a0a' :
      status === 'Idle' ? '#1a2a3a' :
      status === 'Blocked' ? '#3a1a1a' : '#1a1a2a',
    color:
      status === 'Working' ? '#4f8' :
      status === 'Thinking' ? '#ff8' :
      status === 'Idle' ? '#4af' :
      status === 'Blocked' ? '#f44' : '#888',
    border: `1px solid ${
      status === 'Working' ? '#4f8' :
      status === 'Thinking' ? '#ff8' :
      status === 'Idle' ? '#4af' :
      status === 'Blocked' ? '#f44' : '#444'
    }`,
  }),
  statsRow: {
    display: 'flex',
    gap: 12,
    marginTop: 8,
  },
  stat: {
    flex: 1,
    display: 'flex',
    flexDirection: 'column' as const,
    alignItems: 'center',
    gap: 2,
  },
  statLabel: {
    fontSize: 8,
    color: '#5a7a9a',
    textTransform: 'uppercase' as const,
  },
  statBar: {
    width: '100%',
    height: 4,
    background: '#0a1a2a',
    borderRadius: 2,
    overflow: 'hidden',
  },
  statFill: (value: number, color: string) => ({
    width: `${value * 100}%`,
    height: '100%',
    background: color,
    borderRadius: 2,
    transition: 'width 0.3s',
  }),
  specialization: {
    fontSize: 9,
    color: '#5a8aba',
    marginTop: 6,
    fontStyle: 'italic' as const,
  },
  taskIndicator: {
    marginTop: 8,
    padding: '6px 8px',
    background: 'rgba(80, 200, 120, 0.1)',
    border: '1px solid #4f8',
    borderRadius: 4,
    fontSize: 9,
    color: '#4f8',
  },
};

interface Props {
  agents: Agent[];
  selectedAgent: string | null;
  onSelectAgent: (id: string | null) => void;
}

export function AgentRoster({ agents, selectedAgent, onSelectAgent }: Props) {
  // Sort: Coordinator first, then by status (Working > Thinking > Idle)
  const sortedAgents = [...agents].sort((a, b) => {
    if (a.role === 'Coordinator') return -1;
    if (b.role === 'Coordinator') return 1;
    const statusOrder: Record<string, number> = { Working: 0, Thinking: 1, Idle: 2, Waiting: 3, Blocked: 4, Resting: 5, Offline: 6 };
    return (statusOrder[a.status] || 10) - (statusOrder[b.status] || 10);
  });
  
  return (
    <div style={S.root}>
      {sortedAgents.map(agent => (
        <div
          key={agent.id}
          style={S.agentCard(selectedAgent === agent.id, agent.status)}
          onClick={() => onSelectAgent(selectedAgent === agent.id ? null : agent.id)}
        >
          <div style={S.agentHeader}>
            <div style={S.avatar}>{agent.avatar}</div>
            <div>
              <div style={S.agentName}>{agent.name}</div>
              <div style={S.agentRole}>{agent.role}</div>
            </div>
            <span style={S.statusBadge(agent.status)}>{agent.status}</span>
          </div>
          
          <div style={S.statsRow}>
            <div style={S.stat}>
              <span style={S.statLabel}>Coherence</span>
              <div style={S.statBar}>
                <div style={S.statFill(agent.coherence, agent.coherence > 0.8 ? '#4f8' : '#fa4')} />
              </div>
            </div>
            <div style={S.stat}>
              <span style={S.statLabel}>Energy</span>
              <div style={S.statBar}>
                <div style={S.statFill(agent.energy, agent.energy > 0.5 ? '#4af' : '#f44')} />
              </div>
            </div>
          </div>
          
          <div style={S.specialization}>{agent.specialization}</div>
          
          {agent.currentTask && (
            <div style={S.taskIndicator}>
              ◉ Working on: {agent.currentTask.title.slice(0, 30)}...
            </div>
          )}
        </div>
      ))}
    </div>
  );
}
