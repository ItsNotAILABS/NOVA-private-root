// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Agent Workspace Component
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import type { Agent, Task, Message } from './OroCommandCenter';

const S = {
  root: {
    height: '100%',
    display: 'flex',
    flexDirection: 'column' as const,
    overflow: 'hidden',
  },
  header: {
    padding: '16px 20px',
    background: 'rgba(20, 60, 100, 0.3)',
    borderBottom: '1px solid #1a4a7a',
    display: 'flex',
    alignItems: 'center',
    gap: 16,
  },
  avatar: {
    width: 48,
    height: 48,
    borderRadius: '50%',
    background: 'linear-gradient(135deg, #4af, #2a8)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontSize: 24,
  },
  agentInfo: {
    flex: 1,
  },
  agentName: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#fff',
    marginBottom: 4,
  },
  agentMeta: {
    fontSize: 11,
    color: '#6a9aca',
    display: 'flex',
    gap: 16,
  },
  statusIndicator: (status: string) => ({
    display: 'inline-flex',
    alignItems: 'center',
    gap: 6,
    padding: '4px 12px',
    borderRadius: 12,
    fontSize: 11,
    textTransform: 'uppercase' as const,
    background:
      status === 'Working' ? 'rgba(80, 255, 120, 0.15)' :
      status === 'Thinking' ? 'rgba(255, 255, 80, 0.15)' :
      'rgba(80, 170, 255, 0.15)',
    color:
      status === 'Working' ? '#4f8' :
      status === 'Thinking' ? '#ff8' :
      '#4af',
    border: `1px solid ${
      status === 'Working' ? '#4f8' :
      status === 'Thinking' ? '#ff8' :
      '#4af'
    }`,
  }),
  content: {
    flex: 1,
    overflow: 'auto',
    padding: '20px',
  },
  section: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 12,
    color: '#4af',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.12em',
    marginBottom: 12,
    display: 'flex',
    alignItems: 'center',
    gap: 8,
  },
  capabilitiesGrid: {
    display: 'flex',
    flexWrap: 'wrap' as const,
    gap: 8,
  },
  capability: {
    padding: '4px 12px',
    background: 'rgba(80, 170, 255, 0.1)',
    border: '1px solid #2a5a8a',
    borderRadius: 12,
    fontSize: 10,
    color: '#6ac',
  },
  taskCard: (status: string) => ({
    background: 'rgba(10, 30, 50, 0.8)',
    border: `1px solid ${
      status === 'InProgress' ? '#4af' :
      status === 'Completed' ? '#4f8' :
      status === 'Failed' ? '#f44' :
      '#2a4a6a'
    }`,
    borderRadius: 8,
    padding: '12px 16px',
    marginBottom: 12,
  }),
  taskTitle: {
    fontSize: 13,
    fontWeight: 'bold',
    color: '#fff',
    marginBottom: 6,
  },
  taskDescription: {
    fontSize: 11,
    color: '#8ab',
    marginBottom: 10,
    lineHeight: 1.5,
  },
  progressBar: {
    width: '100%',
    height: 6,
    background: '#0a1a2a',
    borderRadius: 3,
    overflow: 'hidden',
    marginBottom: 8,
  },
  progressFill: (progress: number) => ({
    width: `${progress}%`,
    height: '100%',
    background: progress === 100 ? '#4f8' : 'linear-gradient(90deg, #4af, #2a8)',
    borderRadius: 3,
    transition: 'width 0.3s',
  }),
  taskMeta: {
    display: 'flex',
    justifyContent: 'space-between',
    fontSize: 9,
    color: '#5a8aba',
  },
  messageList: {
    maxHeight: 200,
    overflow: 'auto',
  },
  message: (type: string) => ({
    padding: '8px 12px',
    background:
      type === 'System' ? 'rgba(100, 100, 100, 0.1)' :
      type === 'Request' ? 'rgba(80, 170, 255, 0.1)' :
      type === 'Response' ? 'rgba(80, 255, 120, 0.1)' :
      type === 'Alert' ? 'rgba(255, 80, 80, 0.1)' :
      'rgba(50, 50, 50, 0.1)',
    borderLeft: `3px solid ${
      type === 'System' ? '#888' :
      type === 'Request' ? '#4af' :
      type === 'Response' ? '#4f8' :
      type === 'Alert' ? '#f44' :
      '#444'
    }`,
    marginBottom: 8,
    borderRadius: '0 4px 4px 0',
  }),
  messageFrom: {
    fontSize: 9,
    color: '#6ac',
    marginBottom: 4,
    textTransform: 'uppercase' as const,
  },
  messageContent: {
    fontSize: 11,
    color: '#bcd',
    lineHeight: 1.4,
  },
  noData: {
    textAlign: 'center' as const,
    padding: '40px 20px',
    color: '#5a7a9a',
    fontSize: 12,
  },
  statsGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(4, 1fr)',
    gap: 12,
    marginBottom: 20,
  },
  statBox: {
    background: 'rgba(10, 30, 60, 0.6)',
    border: '1px solid #1a3a5c',
    borderRadius: 8,
    padding: '12px',
    textAlign: 'center' as const,
  },
  statValue: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#4af',
    marginBottom: 4,
  },
  statLabel: {
    fontSize: 9,
    color: '#5a8aba',
    textTransform: 'uppercase' as const,
  },
};

interface Props {
  agent: Agent;
  tasks: Task[];
  messages: Message[];
}

export function AgentWorkspace({ agent, tasks, messages }: Props) {
  const [activeTab, setActiveTab] = useState<'overview' | 'tasks' | 'comms'>('overview');
  
  const activeTasks = tasks.filter(t => t.status === 'InProgress');
  const completedTasks = tasks.filter(t => t.status === 'Completed');
  const recentMessages = messages.slice(-10).reverse();
  
  return (
    <div style={S.root}>
      {/* Header */}
      <div style={S.header}>
        <div style={S.avatar}>{agent.avatar}</div>
        <div style={S.agentInfo}>
          <div style={S.agentName}>{agent.name}</div>
          <div style={S.agentMeta}>
            <span>{agent.role}</span>
            <span>|</span>
            <span>{agent.tasksCompleted} tasks completed</span>
            <span>|</span>
            <span>{agent.specialization}</span>
          </div>
        </div>
        <div style={S.statusIndicator(agent.status)}>
          <span style={{ fontSize: 8 }}>●</span>
          {agent.status}
        </div>
      </div>
      
      {/* Content */}
      <div style={S.content}>
        {/* Stats */}
        <div style={S.statsGrid}>
          <div style={S.statBox}>
            <div style={S.statValue}>{(agent.coherence * 100).toFixed(0)}%</div>
            <div style={S.statLabel}>Coherence</div>
          </div>
          <div style={S.statBox}>
            <div style={S.statValue}>{(agent.energy * 100).toFixed(0)}%</div>
            <div style={S.statLabel}>Energy</div>
          </div>
          <div style={S.statBox}>
            <div style={S.statValue}>{activeTasks.length}</div>
            <div style={S.statLabel}>Active Tasks</div>
          </div>
          <div style={S.statBox}>
            <div style={S.statValue}>{agent.tasksCompleted}</div>
            <div style={S.statLabel}>Total Completed</div>
          </div>
        </div>
        
        {/* Capabilities */}
        <div style={S.section}>
          <div style={S.sectionTitle}>
            <span>🔧</span> Capabilities
          </div>
          <div style={S.capabilitiesGrid}>
            {agent.capabilities.map((cap, i) => (
              <span key={i} style={S.capability}>{cap}</span>
            ))}
          </div>
        </div>
        
        {/* Current Task */}
        {agent.currentTask && (
          <div style={S.section}>
            <div style={S.sectionTitle}>
              <span>⚡</span> Current Task
            </div>
            <div style={S.taskCard(agent.currentTask.status)}>
              <div style={S.taskTitle}>{agent.currentTask.title}</div>
              <div style={S.taskDescription}>{agent.currentTask.description}</div>
              <div style={S.progressBar}>
                <div style={S.progressFill(agent.currentTask.progress)} />
              </div>
              <div style={S.taskMeta}>
                <span>Progress: {agent.currentTask.progress.toFixed(0)}%</span>
                <span>Priority: {agent.currentTask.priority}</span>
              </div>
            </div>
          </div>
        )}
        
        {/* Active Tasks */}
        {activeTasks.length > 0 && (
          <div style={S.section}>
            <div style={S.sectionTitle}>
              <span>📋</span> Active Tasks ({activeTasks.length})
            </div>
            {activeTasks.map(task => (
              <div key={task.id} style={S.taskCard(task.status)}>
                <div style={S.taskTitle}>{task.title}</div>
                <div style={S.progressBar}>
                  <div style={S.progressFill(task.progress)} />
                </div>
                <div style={S.taskMeta}>
                  <span>{task.progress.toFixed(0)}% complete</span>
                  <span>{task.status}</span>
                </div>
              </div>
            ))}
          </div>
        )}
        
        {/* Recent Communications */}
        <div style={S.section}>
          <div style={S.sectionTitle}>
            <span>💬</span> Recent Communications
          </div>
          {recentMessages.length > 0 ? (
            <div style={S.messageList}>
              {recentMessages.map(msg => (
                <div key={msg.id} style={S.message(msg.type)}>
                  <div style={S.messageFrom}>
                    {msg.from} → {msg.to === 'broadcast' ? 'All' : msg.to}
                  </div>
                  <div style={S.messageContent}>{msg.content}</div>
                </div>
              ))}
            </div>
          ) : (
            <div style={S.noData}>No recent communications</div>
          )}
        </div>
      </div>
    </div>
  );
}
