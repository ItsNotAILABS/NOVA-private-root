// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Mission Briefing Component (Overview when no agent selected)
// ═══════════════════════════════════════════════════════════════════════════════

import React from 'react';
import type { Agent, Task, Message } from './OroCommandCenter';

const S = {
  root: {
    height: '100%',
    overflow: 'auto',
    padding: '24px',
  },
  header: {
    textAlign: 'center' as const,
    marginBottom: 32,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#4af',
    marginBottom: 8,
    letterSpacing: '0.05em',
  },
  subtitle: {
    fontSize: 12,
    color: '#6a9aca',
    maxWidth: 600,
    margin: '0 auto',
    lineHeight: 1.6,
  },
  statsGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(4, 1fr)',
    gap: 16,
    marginBottom: 32,
  },
  statCard: {
    background: 'linear-gradient(135deg, rgba(20, 60, 100, 0.4), rgba(10, 40, 80, 0.4))',
    border: '1px solid #2a5a8a',
    borderRadius: 12,
    padding: '20px',
    textAlign: 'center' as const,
  },
  statValue: (color: string) => ({
    fontSize: 36,
    fontWeight: 'bold',
    color,
    marginBottom: 4,
  }),
  statLabel: {
    fontSize: 10,
    color: '#6a9aca',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
  },
  section: {
    marginBottom: 32,
  },
  sectionTitle: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#4af',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.12em',
    marginBottom: 16,
    display: 'flex',
    alignItems: 'center',
    gap: 8,
    paddingBottom: 8,
    borderBottom: '1px solid #1a3a5c',
  },
  agentGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(3, 1fr)',
    gap: 12,
  },
  agentMiniCard: (status: string) => ({
    background: 'rgba(10, 30, 50, 0.6)',
    border: `1px solid ${
      status === 'Working' ? '#4f8' :
      status === 'Thinking' ? '#ff8' :
      '#2a4a6a'
    }`,
    borderRadius: 8,
    padding: '12px',
    display: 'flex',
    alignItems: 'center',
    gap: 12,
  }),
  agentAvatar: {
    width: 40,
    height: 40,
    borderRadius: '50%',
    background: 'linear-gradient(135deg, #2a5a8a, #1a3a5a)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontSize: 20,
  },
  agentInfo: {
    flex: 1,
  },
  agentName: {
    fontSize: 12,
    fontWeight: 'bold',
    color: '#fff',
    marginBottom: 2,
  },
  agentRole: {
    fontSize: 9,
    color: '#6a9aca',
  },
  agentStatus: (status: string) => ({
    fontSize: 8,
    padding: '2px 8px',
    borderRadius: 8,
    background:
      status === 'Working' ? '#0a3a2a' :
      status === 'Thinking' ? '#3a3a0a' :
      '#1a2a3a',
    color:
      status === 'Working' ? '#4f8' :
      status === 'Thinking' ? '#ff8' :
      '#4af',
  }),
  activityFeed: {
    maxHeight: 200,
    overflow: 'auto',
    background: 'rgba(5, 15, 30, 0.6)',
    border: '1px solid #1a3a5c',
    borderRadius: 8,
    padding: '12px',
  },
  activityItem: (type: string) => ({
    padding: '8px 12px',
    borderLeft: `3px solid ${
      type === 'System' ? '#888' :
      type === 'Request' ? '#4af' :
      type === 'Response' ? '#4f8' :
      '#fa4'
    }`,
    marginBottom: 8,
    background: 'rgba(20, 40, 60, 0.3)',
    borderRadius: '0 4px 4px 0',
  }),
  activityTime: {
    fontSize: 8,
    color: '#5a7a9a',
    marginBottom: 2,
  },
  activityContent: {
    fontSize: 11,
    color: '#9bc',
    lineHeight: 1.4,
  },
  welcomeBox: {
    background: 'linear-gradient(135deg, rgba(80, 170, 255, 0.1), rgba(80, 255, 170, 0.1))',
    border: '1px solid #2a6a9a',
    borderRadius: 12,
    padding: '24px',
    textAlign: 'center' as const,
    marginTop: 20,
  },
  welcomeTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#4af',
    marginBottom: 12,
  },
  welcomeText: {
    fontSize: 12,
    color: '#8ab',
    lineHeight: 1.6,
    maxWidth: 500,
    margin: '0 auto',
  },
  quickActions: {
    display: 'flex',
    justifyContent: 'center',
    gap: 12,
    marginTop: 20,
  },
  actionBtn: {
    padding: '10px 20px',
    background: 'linear-gradient(135deg, #1a4a7a, #0a3a5a)',
    border: '1px solid #2a6a9a',
    borderRadius: 8,
    color: '#4af',
    fontSize: 11,
    cursor: 'pointer',
    display: 'flex',
    alignItems: 'center',
    gap: 8,
  },
};

interface Props {
  agents: Agent[];
  tasks: Task[];
  messages: Message[];
}

export function MissionBriefing({ agents, tasks, messages }: Props) {
  const activeAgents = agents.filter(a => a.status === 'Working' || a.status === 'Thinking');
  const totalCompleted = agents.reduce((sum, a) => sum + a.tasksCompleted, 0);
  const avgCoherence = agents.reduce((sum, a) => sum + a.coherence, 0) / agents.length;
  const pendingTasks = tasks.filter(t => t.status === 'Pending' || t.status === 'InProgress');
  
  const formatTime = (timestamp: number) => {
    const diff = Date.now() - timestamp;
    if (diff < 60000) return 'Just now';
    if (diff < 3600000) return `${Math.floor(diff / 60000)}m ago`;
    return `${Math.floor(diff / 3600000)}h ago`;
  };
  
  return (
    <div style={S.root}>
      {/* Header */}
      <div style={S.header}>
        <div style={S.title}>◉ ORO COMMAND CENTER</div>
        <div style={S.subtitle}>
          Welcome to the multi-agent workspace. ORO coordinates a team of specialized agents
          to accomplish complex tasks. Each agent has unique capabilities and works in harmony
          with the collective organism.
        </div>
      </div>
      
      {/* Stats */}
      <div style={S.statsGrid}>
        <div style={S.statCard}>
          <div style={S.statValue('#4af')}>{agents.length}</div>
          <div style={S.statLabel}>Total Agents</div>
        </div>
        <div style={S.statCard}>
          <div style={S.statValue('#4f8')}>{activeAgents.length}</div>
          <div style={S.statLabel}>Active Now</div>
        </div>
        <div style={S.statCard}>
          <div style={S.statValue('#fa4')}>{pendingTasks.length}</div>
          <div style={S.statLabel}>Active Tasks</div>
        </div>
        <div style={S.statCard}>
          <div style={S.statValue(avgCoherence > 0.8 ? '#4f8' : '#fa4')}>
            {(avgCoherence * 100).toFixed(0)}%
          </div>
          <div style={S.statLabel}>Coherence</div>
        </div>
      </div>
      
      {/* Agent Overview */}
      <div style={S.section}>
        <div style={S.sectionTitle}>
          <span>👥</span> Agent Team
        </div>
        <div style={S.agentGrid}>
          {agents.map(agent => (
            <div key={agent.id} style={S.agentMiniCard(agent.status)}>
              <div style={S.agentAvatar}>{agent.avatar}</div>
              <div style={S.agentInfo}>
                <div style={S.agentName}>{agent.name}</div>
                <div style={S.agentRole}>{agent.role}</div>
              </div>
              <span style={S.agentStatus(agent.status)}>{agent.status}</span>
            </div>
          ))}
        </div>
      </div>
      
      {/* Activity Feed */}
      <div style={S.section}>
        <div style={S.sectionTitle}>
          <span>📡</span> Recent Activity
        </div>
        <div style={S.activityFeed}>
          {messages.length > 0 ? (
            messages.slice(-10).reverse().map(msg => (
              <div key={msg.id} style={S.activityItem(msg.type)}>
                <div style={S.activityTime}>
                  {formatTime(msg.timestamp)} · {msg.from} → {msg.to === 'broadcast' ? 'All' : msg.to}
                </div>
                <div style={S.activityContent}>{msg.content}</div>
              </div>
            ))
          ) : (
            <div style={{ textAlign: 'center', color: '#5a7a9a', padding: 20 }}>
              No recent activity. Send a request to get started.
            </div>
          )}
        </div>
      </div>
      
      {/* Welcome Box */}
      <div style={S.welcomeBox}>
        <div style={S.welcomeTitle}>🚀 Ready to Work</div>
        <div style={S.welcomeText}>
          Type your request in the input bar below. ORO will analyze your request,
          assign it to the most capable agent, and track progress in real-time.
          Select any agent from the sidebar to view their workspace.
        </div>
        <div style={S.quickActions}>
          <button style={S.actionBtn}>
            <span>📊</span> View Analytics
          </button>
          <button style={S.actionBtn}>
            <span>📋</span> Task History
          </button>
          <button style={S.actionBtn}>
            <span>⚙️</span> Settings
          </button>
        </div>
      </div>
    </div>
  );
}
