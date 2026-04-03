// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Task Manager Component
// ═══════════════════════════════════════════════════════════════════════════════

import React from 'react';
import type { Task, Agent } from './OroCommandCenter';

const S = {
  root: {
    flex: 1,
    overflow: 'auto',
    padding: '0 8px 8px',
  },
  taskCard: (status: string, priority: string) => ({
    background: 'rgba(10, 30, 50, 0.8)',
    border: `1px solid ${
      status === 'InProgress' ? '#4af' :
      status === 'Completed' ? '#4f8' :
      status === 'Failed' ? '#f44' :
      priority === 'Critical' ? '#f84' :
      priority === 'High' ? '#fa4' :
      '#2a4a6a'
    }`,
    borderRadius: 8,
    padding: '10px 12px',
    marginBottom: 8,
    cursor: 'pointer',
    transition: 'all 0.2s',
  }),
  taskHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 6,
  },
  taskTitle: {
    fontSize: 11,
    fontWeight: 'bold',
    color: '#fff',
    flex: 1,
    lineHeight: 1.3,
  },
  priorityBadge: (priority: string) => ({
    padding: '2px 6px',
    borderRadius: 8,
    fontSize: 8,
    textTransform: 'uppercase' as const,
    marginLeft: 8,
    background:
      priority === 'Critical' ? '#3a1a1a' :
      priority === 'High' ? '#3a2a1a' :
      priority === 'Medium' ? '#1a2a3a' :
      '#1a1a2a',
    color:
      priority === 'Critical' ? '#f44' :
      priority === 'High' ? '#fa4' :
      priority === 'Medium' ? '#4af' :
      '#888',
    border: `1px solid ${
      priority === 'Critical' ? '#f44' :
      priority === 'High' ? '#fa4' :
      priority === 'Medium' ? '#4af' :
      '#444'
    }`,
  }),
  statusBadge: (status: string) => ({
    display: 'inline-block',
    padding: '2px 8px',
    borderRadius: 8,
    fontSize: 8,
    textTransform: 'uppercase' as const,
    background:
      status === 'InProgress' ? '#1a3a4a' :
      status === 'Completed' ? '#1a3a2a' :
      status === 'Failed' ? '#3a1a1a' :
      status === 'Pending' ? '#2a2a1a' :
      '#1a1a2a',
    color:
      status === 'InProgress' ? '#4af' :
      status === 'Completed' ? '#4f8' :
      status === 'Failed' ? '#f44' :
      status === 'Pending' ? '#fa4' :
      '#888',
  }),
  progressBar: {
    width: '100%',
    height: 4,
    background: '#0a1a2a',
    borderRadius: 2,
    overflow: 'hidden',
    marginTop: 8,
    marginBottom: 6,
  },
  progressFill: (progress: number, status: string) => ({
    width: `${progress}%`,
    height: '100%',
    background:
      status === 'Completed' ? '#4f8' :
      status === 'Failed' ? '#f44' :
      'linear-gradient(90deg, #4af, #2a8)',
    borderRadius: 2,
    transition: 'width 0.3s',
  }),
  taskMeta: {
    display: 'flex',
    justifyContent: 'space-between',
    fontSize: 9,
    color: '#5a8aba',
  },
  assignee: {
    display: 'flex',
    alignItems: 'center',
    gap: 4,
  },
  assigneeAvatar: {
    width: 14,
    height: 14,
    borderRadius: '50%',
    background: '#2a5a8a',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontSize: 8,
  },
  emptyState: {
    textAlign: 'center' as const,
    padding: '30px 20px',
    color: '#5a7a9a',
    fontSize: 11,
  },
  sectionLabel: {
    fontSize: 9,
    color: '#5a7a9a',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
    padding: '8px 4px 4px',
    borderBottom: '1px solid #1a3a5c',
    marginBottom: 8,
  },
};

interface Props {
  tasks: Task[];
  agents: Agent[];
  onTaskSelect: (taskId: string) => void;
}

export function TaskManager({ tasks, agents, onTaskSelect }: Props) {
  const getAgentName = (agentId: string | null) => {
    if (!agentId) return 'Unassigned';
    const agent = agents.find(a => a.id === agentId);
    return agent?.name || 'Unknown';
  };
  
  const getAgentAvatar = (agentId: string | null) => {
    if (!agentId) return '?';
    const agent = agents.find(a => a.id === agentId);
    return agent?.avatar || '?';
  };
  
  const formatTime = (timestamp: number | null) => {
    if (!timestamp) return '--';
    const diff = Date.now() - timestamp;
    if (diff < 60000) return 'Just now';
    if (diff < 3600000) return `${Math.floor(diff / 60000)}m ago`;
    return `${Math.floor(diff / 3600000)}h ago`;
  };
  
  // Group tasks by status
  const inProgress = tasks.filter(t => t.status === 'InProgress');
  const pending = tasks.filter(t => t.status === 'Pending' || t.status === 'Queued');
  const completed = tasks.filter(t => t.status === 'Completed').slice(0, 5);
  
  if (tasks.length === 0) {
    return (
      <div style={S.root}>
        <div style={S.emptyState}>
          <div style={{ fontSize: 24, marginBottom: 8 }}>📋</div>
          <div>No tasks yet</div>
          <div style={{ fontSize: 9, marginTop: 4 }}>Send a request to ORO to create a task</div>
        </div>
      </div>
    );
  }
  
  return (
    <div style={S.root}>
      {/* In Progress */}
      {inProgress.length > 0 && (
        <>
          <div style={S.sectionLabel}>In Progress ({inProgress.length})</div>
          {inProgress.map(task => (
            <div
              key={task.id}
              style={S.taskCard(task.status, task.priority)}
              onClick={() => onTaskSelect(task.id)}
            >
              <div style={S.taskHeader}>
                <div style={S.taskTitle}>{task.title}</div>
                <span style={S.priorityBadge(task.priority)}>{task.priority}</span>
              </div>
              <div style={S.progressBar}>
                <div style={S.progressFill(task.progress, task.status)} />
              </div>
              <div style={S.taskMeta}>
                <div style={S.assignee}>
                  <span style={S.assigneeAvatar}>{getAgentAvatar(task.assignedAgent)}</span>
                  <span>{getAgentName(task.assignedAgent)}</span>
                </div>
                <span>{task.progress.toFixed(0)}%</span>
              </div>
            </div>
          ))}
        </>
      )}
      
      {/* Pending */}
      {pending.length > 0 && (
        <>
          <div style={S.sectionLabel}>Pending ({pending.length})</div>
          {pending.map(task => (
            <div
              key={task.id}
              style={S.taskCard(task.status, task.priority)}
              onClick={() => onTaskSelect(task.id)}
            >
              <div style={S.taskHeader}>
                <div style={S.taskTitle}>{task.title}</div>
                <span style={S.priorityBadge(task.priority)}>{task.priority}</span>
              </div>
              <div style={S.taskMeta}>
                <span style={S.statusBadge(task.status)}>{task.status}</span>
                <span>{formatTime(task.createdAt)}</span>
              </div>
            </div>
          ))}
        </>
      )}
      
      {/* Completed */}
      {completed.length > 0 && (
        <>
          <div style={S.sectionLabel}>Completed ({completed.length})</div>
          {completed.map(task => (
            <div
              key={task.id}
              style={S.taskCard(task.status, task.priority)}
              onClick={() => onTaskSelect(task.id)}
            >
              <div style={S.taskHeader}>
                <div style={S.taskTitle}>{task.title}</div>
                <span style={S.statusBadge(task.status)}>✓ Done</span>
              </div>
              <div style={S.taskMeta}>
                <div style={S.assignee}>
                  <span style={S.assigneeAvatar}>{getAgentAvatar(task.assignedAgent)}</span>
                  <span>{getAgentName(task.assignedAgent)}</span>
                </div>
                <span>{formatTime(task.completedAt)}</span>
              </div>
            </div>
          ))}
        </>
      )}
    </div>
  );
}
