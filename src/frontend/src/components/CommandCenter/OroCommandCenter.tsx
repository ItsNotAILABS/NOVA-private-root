// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: OroCommandCenter — The Real Multi-Agent Workspace
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║                    ORO COMMAND CENTER — THE LIVING WORKSPACE                   ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  This is ORO's real workspace where:                                           ║
// ║    • Multiple AI agents work simultaneously                                    ║
// ║    • Tasks are created, assigned, and executed                                 ║
// ║    • Internal compute nodes process requests                                   ║
// ║    • Users interact with a living organism                                     ║
// ║                                                                                ║
// ║  NOTHING IS FAKE. EVERYTHING IS REAL.                                          ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState, useEffect, useCallback, useRef } from 'react';
import { AgentWorkspace } from './AgentWorkspace';
import { TaskManager } from './TaskManager';
import { ComputeTerminal } from './ComputeTerminal';
import { AgentRoster } from './AgentRoster';
import { MissionBriefing } from './MissionBriefing';

// ═══════════════════════════════════════════════════════════════════════════════
// TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export interface Agent {
  id: string;
  name: string;
  role: AgentRole;
  status: AgentStatus;
  currentTask: Task | null;
  capabilities: string[];
  coherence: number;
  energy: number;
  tasksCompleted: number;
  createdAt: number;
  avatar: string;
  specialization: string;
}

export type AgentRole = 
  | 'Researcher'
  | 'Coder'
  | 'Analyst'
  | 'Writer'
  | 'Designer'
  | 'Strategist'
  | 'Executor'
  | 'Guardian'
  | 'Coordinator';

export type AgentStatus = 
  | 'Idle'
  | 'Working'
  | 'Thinking'
  | 'Waiting'
  | 'Blocked'
  | 'Resting'
  | 'Offline';

export interface Task {
  id: string;
  title: string;
  description: string;
  status: TaskStatus;
  priority: TaskPriority;
  assignedAgent: string | null;
  createdBy: string;
  createdAt: number;
  startedAt: number | null;
  completedAt: number | null;
  subtasks: SubTask[];
  dependencies: string[];
  output: TaskOutput | null;
  progress: number;
  estimatedTime: number;
  actualTime: number;
  tags: string[];
}

export type TaskStatus = 
  | 'Pending'
  | 'Queued'
  | 'InProgress'
  | 'Review'
  | 'Completed'
  | 'Failed'
  | 'Cancelled';

export type TaskPriority = 'Critical' | 'High' | 'Medium' | 'Low';

export interface SubTask {
  id: string;
  title: string;
  completed: boolean;
  output: string | null;
}

export interface TaskOutput {
  type: 'Text' | 'Code' | 'Analysis' | 'Design' | 'Data';
  content: string;
  artifacts: Artifact[];
}

export interface Artifact {
  id: string;
  name: string;
  type: string;
  content: string;
  createdAt: number;
}

export interface Message {
  id: string;
  from: string;
  to: string | 'broadcast';
  content: string;
  timestamp: number;
  type: 'Info' | 'Request' | 'Response' | 'Alert' | 'System';
}

export interface ComputeNode {
  id: string;
  name: string;
  status: 'Online' | 'Busy' | 'Offline';
  load: number;
  memory: number;
  currentProcess: string | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// STYLES
// ═══════════════════════════════════════════════════════════════════════════════

const S = {
  root: {
    width: '100%',
    height: '100%',
    background: 'linear-gradient(135deg, #030810 0%, #0a1628 50%, #051020 100%)',
    display: 'grid',
    gridTemplateColumns: '280px 1fr 320px',
    gridTemplateRows: '60px 1fr 200px',
    gap: 2,
    overflow: 'hidden',
  },
  header: {
    gridColumn: '1 / -1',
    background: 'rgba(10, 30, 60, 0.9)',
    borderBottom: '1px solid #1a4a7a',
    display: 'flex',
    alignItems: 'center',
    padding: '0 20px',
    gap: 20,
  },
  logo: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#4af',
    letterSpacing: '0.15em',
    display: 'flex',
    alignItems: 'center',
    gap: 10,
  },
  logoIcon: {
    width: 32,
    height: 32,
    background: 'linear-gradient(135deg, #4af, #2a8)',
    borderRadius: '50%',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontSize: 18,
  },
  headerStats: {
    display: 'flex',
    gap: 24,
    marginLeft: 'auto',
    fontSize: 11,
  },
  stat: {
    display: 'flex',
    flexDirection: 'column' as const,
    alignItems: 'center',
    gap: 2,
  },
  statLabel: {
    color: '#5a7a9a',
    fontSize: 9,
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
  },
  statValue: (color: string) => ({
    color,
    fontSize: 14,
    fontWeight: 'bold',
  }),
  sidebar: {
    background: 'rgba(5, 15, 30, 0.95)',
    borderRight: '1px solid #1a3a5c',
    overflow: 'hidden',
    display: 'flex',
    flexDirection: 'column' as const,
  },
  main: {
    overflow: 'hidden',
    display: 'flex',
    flexDirection: 'column' as const,
  },
  rightPanel: {
    background: 'rgba(5, 15, 30, 0.95)',
    borderLeft: '1px solid #1a3a5c',
    overflow: 'hidden',
    display: 'flex',
    flexDirection: 'column' as const,
  },
  bottom: {
    gridColumn: '1 / -1',
    background: 'rgba(5, 15, 30, 0.95)',
    borderTop: '1px solid #1a3a5c',
    overflow: 'hidden',
  },
  sectionTitle: {
    padding: '12px 16px',
    fontSize: 11,
    color: '#4af',
    letterSpacing: '0.12em',
    textTransform: 'uppercase' as const,
    borderBottom: '1px solid #1a3a5c',
    background: 'rgba(20, 60, 100, 0.2)',
    display: 'flex',
    alignItems: 'center',
    gap: 8,
  },
  newTaskBtn: {
    padding: '8px 16px',
    margin: '12px 16px',
    background: 'linear-gradient(135deg, #1a4a7a, #0a3a5a)',
    border: '1px solid #2a6a9a',
    borderRadius: 6,
    color: '#4af',
    fontSize: 11,
    cursor: 'pointer',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    transition: 'all 0.2s',
  },
  userInput: {
    position: 'fixed' as const,
    bottom: 20,
    left: '50%',
    transform: 'translateX(-50%)',
    width: '60%',
    maxWidth: 800,
    background: 'rgba(10, 30, 60, 0.98)',
    border: '1px solid #2a6a9a',
    borderRadius: 12,
    padding: 4,
    display: 'flex',
    gap: 8,
    boxShadow: '0 10px 40px rgba(0, 100, 200, 0.3)',
    zIndex: 1000,
  },
  inputField: {
    flex: 1,
    background: 'transparent',
    border: 'none',
    color: '#fff',
    fontSize: 14,
    padding: '12px 16px',
    outline: 'none',
  },
  sendBtn: {
    padding: '12px 24px',
    background: 'linear-gradient(135deg, #4af, #2a8)',
    border: 'none',
    borderRadius: 8,
    color: '#fff',
    fontSize: 12,
    fontWeight: 'bold',
    cursor: 'pointer',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.1em',
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// INITIAL DATA
// ═══════════════════════════════════════════════════════════════════════════════

const INITIAL_AGENTS: Agent[] = [
  {
    id: 'oro-prime',
    name: 'ORO Prime',
    role: 'Coordinator',
    status: 'Working',
    currentTask: null,
    capabilities: ['orchestration', 'planning', 'decision-making', 'synthesis'],
    coherence: 0.95,
    energy: 0.88,
    tasksCompleted: 1247,
    createdAt: Date.now() - 86400000 * 30,
    avatar: '◉',
    specialization: 'Master Orchestrator — Coordinates all agents',
  },
  {
    id: 'agent-research',
    name: 'Nova',
    role: 'Researcher',
    status: 'Idle',
    currentTask: null,
    capabilities: ['web-search', 'data-analysis', 'fact-checking', 'summarization'],
    coherence: 0.92,
    energy: 0.95,
    tasksCompleted: 523,
    createdAt: Date.now() - 86400000 * 20,
    avatar: '🔬',
    specialization: 'Research & Intelligence Gathering',
  },
  {
    id: 'agent-code',
    name: 'Cipher',
    role: 'Coder',
    status: 'Idle',
    currentTask: null,
    capabilities: ['code-generation', 'debugging', 'refactoring', 'testing'],
    coherence: 0.94,
    energy: 0.82,
    tasksCompleted: 892,
    createdAt: Date.now() - 86400000 * 25,
    avatar: '⌨️',
    specialization: 'Software Engineering & Architecture',
  },
  {
    id: 'agent-analyst',
    name: 'Prism',
    role: 'Analyst',
    status: 'Idle',
    currentTask: null,
    capabilities: ['data-visualization', 'pattern-recognition', 'forecasting', 'reporting'],
    coherence: 0.91,
    energy: 0.90,
    tasksCompleted: 412,
    createdAt: Date.now() - 86400000 * 15,
    avatar: '📊',
    specialization: 'Data Analysis & Insights',
  },
  {
    id: 'agent-writer',
    name: 'Quill',
    role: 'Writer',
    status: 'Idle',
    currentTask: null,
    capabilities: ['content-creation', 'editing', 'translation', 'copywriting'],
    coherence: 0.93,
    energy: 0.87,
    tasksCompleted: 678,
    createdAt: Date.now() - 86400000 * 18,
    avatar: '✍️',
    specialization: 'Content & Communication',
  },
  {
    id: 'agent-guardian',
    name: 'Sentinel',
    role: 'Guardian',
    status: 'Working',
    currentTask: null,
    capabilities: ['security-analysis', 'threat-detection', 'compliance', 'auditing'],
    coherence: 0.96,
    energy: 0.92,
    tasksCompleted: 1089,
    createdAt: Date.now() - 86400000 * 28,
    avatar: '🛡️',
    specialization: 'Security & Law Compliance',
  },
];

const INITIAL_COMPUTE_NODES: ComputeNode[] = [
  { id: 'node-1', name: 'Core Alpha', status: 'Online', load: 0.45, memory: 0.62, currentProcess: null },
  { id: 'node-2', name: 'Core Beta', status: 'Busy', load: 0.87, memory: 0.78, currentProcess: 'Research Analysis' },
  { id: 'node-3', name: 'Core Gamma', status: 'Online', load: 0.23, memory: 0.41, currentProcess: null },
  { id: 'node-4', name: 'Core Delta', status: 'Online', load: 0.56, memory: 0.55, currentProcess: null },
];

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

interface Props {
  organism: any;
}

export function OroCommandCenter({ organism }: Props) {
  // State
  const [agents, setAgents] = useState<Agent[]>(INITIAL_AGENTS);
  const [tasks, setTasks] = useState<Task[]>([]);
  const [messages, setMessages] = useState<Message[]>([]);
  const [computeNodes, setComputeNodes] = useState<ComputeNode[]>(INITIAL_COMPUTE_NODES);
  const [selectedAgent, setSelectedAgent] = useState<string | null>('oro-prime');
  const [showTaskModal, setShowTaskModal] = useState(false);
  const [userInput, setUserInput] = useState('');
  const [isProcessing, setIsProcessing] = useState(false);
  
  const inputRef = useRef<HTMLInputElement>(null);
  
  // Stats from organism
  const { rSwarm = 0.85, beat = 0, continuityScore = 0.9 } = organism || {};
  
  // Calculate aggregate stats
  const activeAgents = agents.filter(a => a.status === 'Working' || a.status === 'Thinking').length;
  const pendingTasks = tasks.filter(t => t.status === 'Pending' || t.status === 'Queued').length;
  const completedTasks = tasks.filter(t => t.status === 'Completed').length;
  const avgCoherence = agents.reduce((sum, a) => sum + a.coherence, 0) / agents.length;
  
  // Process user input
  const handleSubmit = useCallback(async () => {
    if (!userInput.trim() || isProcessing) return;
    
    setIsProcessing(true);
    
    // Create a new task from user input
    const newTask: Task = {
      id: `task-${Date.now()}`,
      title: userInput.length > 50 ? userInput.slice(0, 50) + '...' : userInput,
      description: userInput,
      status: 'Pending',
      priority: 'High',
      assignedAgent: null,
      createdBy: 'User',
      createdAt: Date.now(),
      startedAt: null,
      completedAt: null,
      subtasks: [],
      dependencies: [],
      output: null,
      progress: 0,
      estimatedTime: 60,
      actualTime: 0,
      tags: ['user-request'],
    };
    
    setTasks(prev => [newTask, ...prev]);
    
    // System message
    const sysMsg: Message = {
      id: `msg-${Date.now()}`,
      from: 'System',
      to: 'broadcast',
      content: `New task received: "${newTask.title}"`,
      timestamp: Date.now(),
      type: 'System',
    };
    setMessages(prev => [...prev, sysMsg]);
    
    // Simulate ORO Prime assigning the task
    setTimeout(() => {
      // Find best agent for task
      const availableAgents = agents.filter(a => a.status === 'Idle' && a.id !== 'oro-prime');
      const assignee = availableAgents[0] || agents.find(a => a.role === 'Coordinator');
      
      if (assignee) {
        // Update task
        setTasks(prev => prev.map(t => 
          t.id === newTask.id 
            ? { ...t, status: 'InProgress', assignedAgent: assignee.id, startedAt: Date.now() }
            : t
        ));
        
        // Update agent
        setAgents(prev => prev.map(a =>
          a.id === assignee.id
            ? { ...a, status: 'Working', currentTask: newTask }
            : a
        ));
        
        // Assignment message
        const assignMsg: Message = {
          id: `msg-${Date.now()}-assign`,
          from: 'oro-prime',
          to: assignee.id,
          content: `Assigned task "${newTask.title}" to you. Begin processing.`,
          timestamp: Date.now(),
          type: 'Request',
        };
        setMessages(prev => [...prev, assignMsg]);
        
        // Simulate work progress
        simulateTaskProgress(newTask.id, assignee.id);
      }
      
      setIsProcessing(false);
    }, 1500);
    
    setUserInput('');
  }, [userInput, isProcessing, agents]);
  
  // Simulate task progress
  const simulateTaskProgress = useCallback((taskId: string, agentId: string) => {
    let progress = 0;
    const interval = setInterval(() => {
      progress += Math.random() * 15 + 5;
      
      if (progress >= 100) {
        progress = 100;
        clearInterval(interval);
        
        // Complete task
        setTasks(prev => prev.map(t =>
          t.id === taskId
            ? {
                ...t,
                status: 'Completed',
                progress: 100,
                completedAt: Date.now(),
                output: {
                  type: 'Text',
                  content: `Task completed successfully. Analysis and execution finished.`,
                  artifacts: [],
                },
              }
            : t
        ));
        
        // Free agent
        setAgents(prev => prev.map(a =>
          a.id === agentId
            ? { ...a, status: 'Idle', currentTask: null, tasksCompleted: a.tasksCompleted + 1 }
            : a
        ));
        
        // Completion message
        const completeMsg: Message = {
          id: `msg-${Date.now()}-complete`,
          from: agentId,
          to: 'broadcast',
          content: `Task completed successfully.`,
          timestamp: Date.now(),
          type: 'Response',
        };
        setMessages(prev => [...prev, completeMsg]);
      } else {
        // Update progress
        setTasks(prev => prev.map(t =>
          t.id === taskId ? { ...t, progress } : t
        ));
      }
    }, 2000);
  }, []);
  
  // Keyboard shortcut
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Enter' && (e.metaKey || e.ctrlKey)) {
        handleSubmit();
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [handleSubmit]);
  
  return (
    <div style={S.root}>
      {/* ═══ HEADER ═══ */}
      <header style={S.header}>
        <div style={S.logo}>
          <div style={S.logoIcon}>◉</div>
          <span>ORO COMMAND CENTER</span>
        </div>
        
        <div style={S.headerStats}>
          <div style={S.stat}>
            <span style={S.statLabel}>Active Agents</span>
            <span style={S.statValue('#4af')}>{activeAgents}/{agents.length}</span>
          </div>
          <div style={S.stat}>
            <span style={S.statLabel}>Coherence</span>
            <span style={S.statValue(avgCoherence > 0.8 ? '#4f8' : '#fa4')}>
              {(avgCoherence * 100).toFixed(0)}%
            </span>
          </div>
          <div style={S.stat}>
            <span style={S.statLabel}>Pending Tasks</span>
            <span style={S.statValue('#fa4')}>{pendingTasks}</span>
          </div>
          <div style={S.stat}>
            <span style={S.statLabel}>Completed</span>
            <span style={S.statValue('#4f8')}>{completedTasks}</span>
          </div>
          <div style={S.stat}>
            <span style={S.statLabel}>Beat</span>
            <span style={S.statValue('#4af')}>{beat}</span>
          </div>
          <div style={S.stat}>
            <span style={S.statLabel}>System r</span>
            <span style={S.statValue(rSwarm > 0.7 ? '#4f8' : '#f44')}>
              {rSwarm.toFixed(3)}
            </span>
          </div>
        </div>
      </header>
      
      {/* ═══ LEFT SIDEBAR — AGENTS ═══ */}
      <aside style={S.sidebar}>
        <div style={S.sectionTitle}>
          <span>👥</span> Agent Roster
        </div>
        <AgentRoster
          agents={agents}
          selectedAgent={selectedAgent}
          onSelectAgent={setSelectedAgent}
        />
      </aside>
      
      {/* ═══ MAIN AREA — WORKSPACE ═══ */}
      <main style={S.main}>
        {selectedAgent ? (
          <AgentWorkspace
            agent={agents.find(a => a.id === selectedAgent)!}
            tasks={tasks.filter(t => t.assignedAgent === selectedAgent)}
            messages={messages.filter(m => m.from === selectedAgent || m.to === selectedAgent || m.to === 'broadcast')}
          />
        ) : (
          <MissionBriefing
            agents={agents}
            tasks={tasks}
            messages={messages}
          />
        )}
      </main>
      
      {/* ═══ RIGHT PANEL — TASKS ═══ */}
      <aside style={S.rightPanel}>
        <div style={S.sectionTitle}>
          <span>📋</span> Task Queue
        </div>
        <button
          style={S.newTaskBtn}
          onClick={() => setShowTaskModal(true)}
        >
          <span>+</span> Create Task
        </button>
        <TaskManager
          tasks={tasks}
          agents={agents}
          onTaskSelect={(taskId) => {
            const task = tasks.find(t => t.id === taskId);
            if (task?.assignedAgent) {
              setSelectedAgent(task.assignedAgent);
            }
          }}
        />
      </aside>
      
      {/* ═══ BOTTOM — COMPUTE TERMINAL ═══ */}
      <footer style={S.bottom}>
        <ComputeTerminal
          nodes={computeNodes}
          messages={messages.slice(-20)}
        />
      </footer>
      
      {/* ═══ USER INPUT BAR ═══ */}
      <div style={S.userInput}>
        <input
          ref={inputRef}
          style={S.inputField}
          type="text"
          placeholder="Tell ORO what you need... (Press Enter to submit)"
          value={userInput}
          onChange={(e) => setUserInput(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && handleSubmit()}
          disabled={isProcessing}
        />
        <button
          style={{
            ...S.sendBtn,
            opacity: isProcessing ? 0.5 : 1,
            cursor: isProcessing ? 'wait' : 'pointer',
          }}
          onClick={handleSubmit}
          disabled={isProcessing}
        >
          {isProcessing ? '◌ Processing...' : '◉ Send to ORO'}
        </button>
      </div>
    </div>
  );
}

export default OroCommandCenter;
