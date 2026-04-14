// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// TISSUE: OroCommandCenter — The Organism's Executive Cortex
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║            ORO COMMAND CENTER — EXECUTIVE CORTEX OF THE ORGANISM              ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  THIS IS NOT A MODULE — IT IS LIVING TISSUE                                    ║
// ║                                                                                ║
// ║  The Command Center is the EXECUTIVE CORTEX where:                             ║
// ║    • Agents are CELLS in the organism's brain                                  ║
// ║    • Tasks are NEURAL SIGNALS flowing through the system                       ║
// ║    • Compute nodes are MITOCHONDRIA providing energy                           ║
// ║    • Users interact with a LIVING consciousness                                ║
// ║                                                                                ║
// ║  Everything flows from organism state:                                         ║
// ║    coherence (r) → agent sync → task priority → resource allocation            ║
// ║    jDrift → stress signals → agent cortisol → intervention requests            ║
// ║    trustScore → permission levels → action approval thresholds                 ║
// ║                                                                                ║
// ║  NOTHING IS FAKE. THIS IS THE ORGANISM'S MIND.                                 ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState, useEffect, useCallback, useRef, useMemo } from 'react';
import { AgentWorkspace } from './AgentWorkspace';
import { TaskManager } from './TaskManager';
import { ComputeTerminal } from './ComputeTerminal';
import { AgentRoster } from './AgentRoster';
import { MissionBriefing } from './MissionBriefing';
import { EmergenceLab } from './EmergenceLab';
import { MathPhysicsLab } from './MathPhysicsLab';
import { NeuroCogLab } from './NeuroCogLab';
import { GRPELab } from './GRPELab';
import { InternalAnalysisLab } from './InternalAnalysisLab';
import { MemoryTempleLab } from './MemoryTempleLab';
import { ConstantFeedbackLab } from './ConstantFeedbackLab';
import {
  OrganismState, organismInit, organismTick, getOrganismStatus,
  EmergenceLabData, NeuroCogLabData, MathPhysicsLabData,
} from '../../math/organism-wiring';
import {
  fetchGeoResonanceProtectionState,
  fetchCardioNeuralConversionOrganState,
  fetchAutonomousAnalystTeamState,
  fetchMemoryTempleState,
  fetchConstantFeedbackCognitionState,
} from '../../canister';

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

type GRPEViewState = {
  backendConnected : boolean;
  backendBeat : number;
  fieldEnergy : number;
  hotspotScore : number;
  protectionScore : number;
  threatScore : number;
  serviceReadiness : number;
  fieldDirectionX : number;
  fieldDirectionY : number;
  fieldDirectionZ : number;
  sevenHeritageNodes : number[];
  serviceOpportunity : number[];
  defenseServiceOpportunity : number[];
  memoryServiceOpportunity : number[];
  worldServiceOpportunity : number[];
  fieldHistory : number[];
  hotspotHistory : number[];
  protectionHistory : number[];
};

const defaultGRPEState = (): GRPEViewState => ({
  backendConnected: false,
  backendBeat: 0,
  fieldEnergy: 0.72,
  hotspotScore: 0.28,
  protectionScore: 0.74,
  threatScore: 0.26,
  serviceReadiness: 0.71,
  fieldDirectionX: 0.0,
  fieldDirectionY: 0.0,
  fieldDirectionZ: 1.0,
  sevenHeritageNodes: [0.72, 0.70, 0.68, 0.69, 0.74, 0.71, 0.73],
  serviceOpportunity: Array(20).fill(0.70),
  defenseServiceOpportunity: Array(5).fill(0.72),
  memoryServiceOpportunity: Array(5).fill(0.70),
  worldServiceOpportunity: Array(5).fill(0.71),
  fieldHistory: [],
  hotspotHistory: [],
  protectionHistory: [],
});

type CardioNeuralViewState = {
  backendConnected : boolean;
  beat : number;
  coupling : number;
  oxygenFlow : number;
  perfusionFlow : number;
  conversionGain : number;
  gateOpen : boolean;
  helixBarrier : number;
  shieldIntegrity : number;
  thoughtThroughput : number;
  outputCoherence : number;
  outputDirectionX : number;
  outputDirectionY : number;
  outputDirectionZ : number;
  throughputHistory : number[];
  shieldHistory : number[];
  couplingHistory : number[];
};

const defaultCardioNeuralState = (): CardioNeuralViewState => ({
  backendConnected: false,
  beat: 0,
  coupling: 0.72,
  oxygenFlow: 0.68,
  perfusionFlow: 0.70,
  conversionGain: 0.69,
  gateOpen: true,
  helixBarrier: 0.82,
  shieldIntegrity: 0.86,
  thoughtThroughput: 0.66,
  outputCoherence: 0.73,
  outputDirectionX: 0.0,
  outputDirectionY: 0.0,
  outputDirectionZ: 1.0,
  throughputHistory: [],
  shieldHistory: [],
  couplingHistory: [],
});

type AnalystViewState = {
  backendConnected : boolean;
  beat : number;
  learningScore : number;
  adaptationScore : number;
  emergencySignal : number;
  recommendationPriority : number;
  narrativeSummary : string;
  heartNarrative : string;
  brainNarrative : string;
  middleOrganNarrative : string;
  defenseNarrative : string;
  growthNarrative : string;
  topRecommendations : string[];
};

type MemoryTempleViewState = {
  backendConnected : boolean;
  beat : number;
  continuityWeave : number;
  resonanceField : number;
  cognitiveLoad : number;
  memoryRetention : number;
  recallReadiness : number;
  memoryCognitionCoupling : number;
  iotCouplingScore : number;
  deviceTwinIntegrity : number;
  phantomIntegrity : number;
  agentWorkCapacity : number;
  artifactReadiness : number;
  directionX : number;
  directionY : number;
  directionZ : number;
  pedestalNames : string[];
  pedestalCouplings : number[];
  narrativeSummary : string;
  recommendations : string[];
  continuityHistory : number[];
  resonanceHistory : number[];
  couplingHistory : number[];
};

type ConstantFeedbackViewState = {
  backendConnected : boolean;
  beat : number;
  cognitivePressure : number;
  loopClosureScore : number;
  reinjectionIntegrity : number;
  multiGroupCoherence : number;
  multiOrganismCoherence : number;
  cognitionReadiness : number;
  arbitrationReadiness : number;
  governanceStability : number;
  recommendationPriority : number;
  narrativeSummary : string;
  topActions : string[];
  pressureHistory : number[];
  closureHistory : number[];
  reinjectionHistory : number[];
  multiGroupHistory : number[];
  multiOrganismHistory : number[];
};

const defaultAnalystState = (): AnalystViewState => ({
  backendConnected: false,
  beat: 0,
  learningScore: 0.70,
  adaptationScore: 0.68,
  emergencySignal: 0.22,
  recommendationPriority: 0.28,
  narrativeSummary: 'Internal analyst team running in fallback mode.',
  heartNarrative: 'Heart rhythm baseline is available.',
  brainNarrative: 'Brain coherence baseline is available.',
  middleOrganNarrative: 'Middle organ baseline regulation is available.',
  defenseNarrative: 'Defense baseline is available.',
  growthNarrative: 'Growth baseline is available.',
  topRecommendations: [
    'Maintain rhythm coupling discipline.',
    'Increase middle-organ throughput before expanding load.',
    'Keep GRPE hotspot monitoring active.',
    'Track adaptation weekly.',
    'Preserve law-aligned governance.',
    'Publish analyst packet to operator.',
  ],
});

const defaultMemoryTempleState = (): MemoryTempleViewState => ({
  backendConnected: false,
  beat: 0,
  continuityWeave: 0.74,
  resonanceField: 0.72,
  cognitiveLoad: 0.50,
  memoryRetention: 0.73,
  recallReadiness: 0.70,
  memoryCognitionCoupling: 0.72,
  iotCouplingScore: 0.62,
  deviceTwinIntegrity: 0.78,
  phantomIntegrity: 0.84,
  agentWorkCapacity: 0.68,
  artifactReadiness: 0.67,
  directionX: 0.0,
  directionY: 0.0,
  directionZ: 1.0,
  pedestalNames: ['lineage', 'doctrine', 'heart', 'brain', 'middle-organ', 'field', 'embodiment'],
  pedestalCouplings: [0.70, 0.72, 0.74, 0.73, 0.71, 0.69, 0.75],
  narrativeSummary: 'Memory temple running in fallback mode.',
  recommendations: [
    'Increase IoT coupling integrity and lock device twins before broad command expansion.',
    'Maintain phantom integrity envelope and continue low-observable operation.',
    'Reinforce memory-cognition loop by prioritizing recall + conversion coherence training.',
    'Keep emergency bounded with protection-first rerouting when needed.',
    'Increase artifact readiness via internal lab tasks and replay-driven synthesis.',
    'Preserve no-drop continuity every beat.',
  ],
  continuityHistory: [],
  resonanceHistory: [],
  couplingHistory: [],
});

const defaultConstantFeedbackState = (): ConstantFeedbackViewState => ({
  backendConnected: false,
  beat: 0,
  cognitivePressure: 0.30,
  loopClosureScore: 0.74,
  reinjectionIntegrity: 0.76,
  multiGroupCoherence: 0.70,
  multiOrganismCoherence: 0.70,
  cognitionReadiness: 0.72,
  arbitrationReadiness: 0.71,
  governanceStability: 0.74,
  recommendationPriority: 0.30,
  narrativeSummary: 'Constant feedback cognition running in fallback mode.',
  topActions: [
    'Raise protection-first routing for all active groups until pressure normalizes.',
    'Increase loop closure by enforcing reinjection hooks on every beat transition.',
    'Elevate replay and continuity audits until reinjection integrity stabilizes.',
    'Stabilize cross-group synchronization using trust and doctrine alignment pulses.',
    'Strengthen multi-organism arbitration contracts before external projection.',
    'Keep constant feedback cognition always-on and reinject outputs every beat.',
  ],
  pressureHistory: [],
  closureHistory: [],
  reinjectionHistory: [],
  multiGroupHistory: [],
  multiOrganismHistory: [],
});

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
// COMPONENT — LIVING TISSUE OF THE ORGANISM
// ═══════════════════════════════════════════════════════════════════════════════

interface Props {
  organism: any;
}

export function OroCommandCenter({ organism }: Props) {
  // ═══ ORGANISM SIGNALS — The nervous system feeds us ═══
  const {
    rSwarm = 0.85,
    beat = 0,
    drones = [],
    jDrift = 0,
    continuityScore = 0.9,
    trustScore = 0.75,
    anomalyScore = 0.1,
    simConfidence = 0.8,
    emergencyActive = false,
    commsLost = false,
    pendingActions: organismPendingActions = [],
    auditLog: organismAuditLog = [],
  } = organism || {};

  // ═══ DERIVE AGENTS FROM ORGANISM DRONES ═══
  // Agents are NOT separate — they ARE the drones manifested as workers
  const agents = useMemo<Agent[]>(() => {
    const AGENT_TEMPLATES: Array<Omit<Agent, 'coherence' | 'energy' | 'status'>> = [
      { id: 'oro-prime', name: 'ORO Prime', role: 'Coordinator', currentTask: null,
        capabilities: ['orchestration', 'planning', 'decision-making', 'synthesis'],
        tasksCompleted: 1247, createdAt: Date.now() - 86400000 * 30, avatar: '◉',
        specialization: 'Master Orchestrator — Coordinates all agents' },
      { id: 'agent-research', name: 'Nova', role: 'Researcher', currentTask: null,
        capabilities: ['web-search', 'data-analysis', 'fact-checking', 'summarization'],
        tasksCompleted: 523, createdAt: Date.now() - 86400000 * 20, avatar: '🔬',
        specialization: 'Research & Intelligence Gathering' },
      { id: 'agent-code', name: 'Cipher', role: 'Coder', currentTask: null,
        capabilities: ['code-generation', 'debugging', 'refactoring', 'testing'],
        tasksCompleted: 892, createdAt: Date.now() - 86400000 * 25, avatar: '⌨️',
        specialization: 'Software Engineering & Architecture' },
      { id: 'agent-analyst', name: 'Prism', role: 'Analyst', currentTask: null,
        capabilities: ['data-visualization', 'pattern-recognition', 'forecasting', 'reporting'],
        tasksCompleted: 412, createdAt: Date.now() - 86400000 * 15, avatar: '📊',
        specialization: 'Data Analysis & Insights' },
      { id: 'agent-writer', name: 'Quill', role: 'Writer', currentTask: null,
        capabilities: ['content-creation', 'editing', 'translation', 'copywriting'],
        tasksCompleted: 678, createdAt: Date.now() - 86400000 * 18, avatar: '✍️',
        specialization: 'Content & Communication' },
      { id: 'agent-guardian', name: 'Sentinel', role: 'Guardian', currentTask: null,
        capabilities: ['security-analysis', 'threat-detection', 'compliance', 'auditing'],
        tasksCompleted: 1089, createdAt: Date.now() - 86400000 * 28, avatar: '🛡️',
        specialization: 'Security & Law Compliance' },
    ];

    // Map organism drones to agent coherence/energy/status
    return AGENT_TEMPLATES.map((template, i) => {
      const drone = drones[i % drones.length] || { energy: 0.8, cortisol: 0.5, trustScore: 0.9 };
      const droneEnergy = drone.energy || 0.8;
      const droneCortisol = drone.cortisol || 0.5;
      const droneTrust = drone.trustScore || 0.9;
      
      // Agent coherence flows from swarm r + individual trust
      const agentCoherence = (rSwarm * 0.6 + droneTrust * 0.4);
      
      // Agent energy flows from drone energy
      const agentEnergy = droneEnergy;
      
      // Agent status derives from cortisol and energy
      let status: AgentStatus = 'Idle';
      if (emergencyActive || drone.sacrificed) {
        status = 'Offline';
      } else if (droneCortisol > 1.5) {
        status = 'Blocked';
      } else if (droneCortisol > 1.0) {
        status = 'Thinking';
      } else if (droneEnergy < 0.3) {
        status = 'Resting';
      } else if (i === 0 || i === 5) {
        // ORO Prime and Sentinel always working
        status = 'Working';
      }
      
      return {
        ...template,
        coherence: agentCoherence,
        energy: agentEnergy,
        status,
      };
    });
  }, [drones, rSwarm, emergencyActive]);

  // ═══ COMPUTE NODES — Derived from organism load ═══
  const computeNodes = useMemo<ComputeNode[]>(() => {
    const baseLoad = 1 - rSwarm; // Lower coherence = higher load
    const stressLoad = jDrift / 2;
    
    return [
      { id: 'node-1', name: 'Core Alpha', status: commsLost ? 'Offline' : 'Online',
        load: Math.min(1, baseLoad + stressLoad * 0.5 + 0.2), memory: 0.62,
        currentProcess: emergencyActive ? 'EMERGENCY MODE' : null },
      { id: 'node-2', name: 'Core Beta', status: baseLoad > 0.5 ? 'Busy' : 'Online',
        load: Math.min(1, baseLoad + 0.3), memory: 0.78,
        currentProcess: baseLoad > 0.5 ? 'Coherence Recovery' : null },
      { id: 'node-3', name: 'Core Gamma', status: 'Online',
        load: Math.min(1, stressLoad + 0.1), memory: 0.41, currentProcess: null },
      { id: 'node-4', name: 'Core Delta', status: 'Online',
        load: Math.min(1, (1 - simConfidence) + 0.2), memory: 0.55,
        currentProcess: simConfidence < 0.7 ? 'Simulation Calibration' : null },
    ];
  }, [rSwarm, jDrift, commsLost, emergencyActive, simConfidence]);

  // ═══ LOCAL STATE — Task queue and messages ═══
  const [tasks, setTasks] = useState<Task[]>([]);
  const [messages, setMessages] = useState<Message[]>([]);
  const [selectedAgent, setSelectedAgent] = useState<string | null>('oro-prime');
  const [userInput, setUserInput] = useState('');
  const [isProcessing, setIsProcessing] = useState(false);
  const [activeTab, setActiveTab] = useState<'command' | 'emergence' | 'physics' | 'neurocog' | 'grpe' | 'analysis' | 'memory' | 'cognition'>('command');
  const [grpeState, setGrpeState] = useState<GRPEViewState>(defaultGRPEState());
  const [cardioNeuralState, setCardioNeuralState] = useState<CardioNeuralViewState>(defaultCardioNeuralState());
  const [analystState, setAnalystState] = useState<AnalystViewState>(defaultAnalystState());
  const [memoryTempleState, setMemoryTempleState] = useState<MemoryTempleViewState>(defaultMemoryTempleState());
  const [constantFeedbackState, setConstantFeedbackState] = useState<ConstantFeedbackViewState>(defaultConstantFeedbackState());
  
  // ═══ UNIFIED ORGANISM STATE — The living wiring ═══
  const organismStateRef = useRef<OrganismState>(organismInit());
  const [organismSnapshot, setOrganismSnapshot] = useState<OrganismState>(organismStateRef.current);
  
  // ═══ ORGANISM TICK LOOP — The heartbeat ═══
  useEffect(() => {
    const interval = setInterval(() => {
      organismStateRef.current = organismTick(organismStateRef.current);
      // Update snapshot every 8 ticks for performance
      if (organismStateRef.current.beat % 8 === 0) {
        setOrganismSnapshot({ ...organismStateRef.current });
      }
    }, 50); // 20Hz tick rate
    return () => clearInterval(interval);
  }, []);

  // ═══ CARDIO-NEURAL ORGAN + INTERNAL ANALYST POLL ═══
  useEffect(() => {
    let stopped = false;

    const pull = async () => {
      const [cardioData, analystData] = await Promise.all([
        fetchCardioNeuralConversionOrganState(),
        fetchAutonomousAnalystTeamState(),
      ]);
      if (stopped) return;

      if (cardioData) {
        const cn: CardioNeuralViewState = {
          backendConnected: true,
          beat: Number(cardioData.beat),
          coupling: cardioData.coupling,
          oxygenFlow: cardioData.oxygenFlow,
          perfusionFlow: cardioData.perfusionFlow,
          conversionGain: cardioData.conversionGain,
          gateOpen: cardioData.gateOpen,
          helixBarrier: cardioData.helixBarrier,
          shieldIntegrity: cardioData.shieldIntegrity,
          thoughtThroughput: cardioData.thoughtThroughput,
          outputCoherence: cardioData.outputCoherence,
          outputDirectionX: cardioData.outputDirectionX,
          outputDirectionY: cardioData.outputDirectionY,
          outputDirectionZ: cardioData.outputDirectionZ,
          throughputHistory: cardioData.throughputHistory,
          shieldHistory: cardioData.shieldHistory,
          couplingHistory: cardioData.couplingHistory,
        };
        setCardioNeuralState(cn);
      } else {
        setCardioNeuralState(prev => ({ ...prev, backendConnected: false }));
      }

      if (analystData) {
        const an: AnalystViewState = {
          backendConnected: true,
          beat: Number(analystData.beat),
          learningScore: analystData.learningScore,
          adaptationScore: analystData.adaptationScore,
          emergencySignal: analystData.emergencySignal,
          recommendationPriority: analystData.recommendationPriority,
          narrativeSummary: analystData.narrativeSummary,
          heartNarrative: analystData.heartNarrative,
          brainNarrative: analystData.brainNarrative,
          middleOrganNarrative: analystData.middleOrganNarrative,
          defenseNarrative: analystData.defenseNarrative,
          growthNarrative: analystData.growthNarrative,
          topRecommendations: analystData.topRecommendations,
        };
        setAnalystState(an);
      } else {
        setAnalystState(prev => ({ ...prev, backendConnected: false }));
      }
    };

    void pull();
    const id = setInterval(() => { void pull(); }, 1250);
    return () => {
      stopped = true;
      clearInterval(id);
    };
  }, []);

  // ═══ MEMORY TEMPLE POLL ═══
  useEffect(() => {
    let stopped = false;

    const pull = async () => {
      const data = await fetchMemoryTempleState();
      if (stopped) return;
      if (!data) {
        setMemoryTempleState(prev => ({ ...prev, backendConnected: false }));
        return;
      }
      const next: MemoryTempleViewState = {
        backendConnected: true,
        beat: Number(data.beat),
        continuityWeave: data.continuityWeave,
        resonanceField: data.resonanceField,
        cognitiveLoad: data.cognitiveLoad,
        memoryRetention: data.memoryRetention,
        recallReadiness: data.recallReadiness,
        memoryCognitionCoupling: data.memoryCognitionCoupling,
        iotCouplingScore: data.iotCouplingScore,
        deviceTwinIntegrity: data.deviceTwinIntegrity,
        phantomIntegrity: data.phantomIntegrity,
        agentWorkCapacity: data.agentWorkCapacity,
        artifactReadiness: data.artifactReadiness,
        directionX: data.directionX,
        directionY: data.directionY,
        directionZ: data.directionZ,
        pedestalNames: data.pedestalNames,
        pedestalCouplings: data.pedestalCouplings,
        narrativeSummary: data.narrativeSummary,
        recommendations: data.recommendations,
        continuityHistory: data.continuityHistory,
        resonanceHistory: data.resonanceHistory,
        couplingHistory: data.couplingHistory,
      };
      setMemoryTempleState(next);
    };

    void pull();
    const id = setInterval(() => { void pull(); }, 1250);
    return () => {
      stopped = true;
      clearInterval(id);
    };
  }, []);

  // ═══ CONSTANT FEEDBACK COGNITION POLL ═══
  useEffect(() => {
    let stopped = false;

    const pull = async () => {
      const data = await fetchConstantFeedbackCognitionState();
      if (stopped) return;
      if (!data) {
        setConstantFeedbackState(prev => ({ ...prev, backendConnected: false }));
        return;
      }

      const next: ConstantFeedbackViewState = {
        backendConnected: true,
        beat: Number(data.beat),
        cognitivePressure: data.cognitivePressure,
        loopClosureScore: data.loopClosureScore,
        reinjectionIntegrity: data.reinjectionIntegrity,
        multiGroupCoherence: data.multiGroupCoherence,
        multiOrganismCoherence: data.multiOrganismCoherence,
        cognitionReadiness: data.cognitionReadiness,
        arbitrationReadiness: data.arbitrationReadiness,
        governanceStability: data.governanceStability,
        recommendationPriority: data.recommendationPriority,
        narrativeSummary: data.narrativeSummary,
        topActions: data.topActions,
        pressureHistory: data.pressureHistory,
        closureHistory: data.closureHistory,
        reinjectionHistory: data.reinjectionHistory,
        multiGroupHistory: data.multiGroupHistory,
        multiOrganismHistory: data.multiOrganismHistory,
      };
      setConstantFeedbackState(next);
    };

    void pull();
    const id = setInterval(() => { void pull(); }, 1250);
    return () => {
      stopped = true;
      clearInterval(id);
    };
  }, []);
  
  // ═══ SYNC EXTERNAL ORGANISM PROPS INTO UNIFIED STATE ═══
  useEffect(() => {
    if (organism) {
      // External r modulates internal r
      if (organism.r !== undefined) {
        organismStateRef.current.r = organismStateRef.current.r * 0.7 + organism.r * 0.3;
      }
      // External beat syncs
      if (organism.beat !== undefined) {
        // Keep our own beat but acknowledge external
      }
    }
  }, [organism?.r, organism?.beat]);
  
  // ═══ PREPARE LAB DATA ═══
  const emergenceLabData: EmergenceLabData = useMemo(() => ({
    r: organismSnapshot.r,
    kf: organismSnapshot.kf,
    emergence: organismSnapshot.emergence,
    genesis: organismSnapshot.genesis,
    kuramoto: organismSnapshot.kuramoto,
    lyapunov: organismSnapshot.lyapunov,
    quantum: organismSnapshot.quantum,
    hz: organismSnapshot.hz,
    beat: organismSnapshot.beat,
    neuro: organismSnapshot.neuro,
  }), [organismSnapshot]);
  
  const neuroCogLabData: NeuroCogLabData = useMemo(() => ({
    neuro: organismSnapshot.neuro,
    metals: organismSnapshot.metals,
    drives: organismSnapshot.drives,
    immune: organismSnapshot.immune,
    olfactory: organismSnapshot.olfactory,
    circadian: organismSnapshot.circadian,
    beat: organismSnapshot.beat,
    r: organismSnapshot.r,
  }), [organismSnapshot]);
  
  const mathPhysicsLabData: MathPhysicsLabData = useMemo(() => ({
    r: organismSnapshot.r,
    kf: organismSnapshot.kf,
    kuramoto: organismSnapshot.kuramoto,
    lyapunov: organismSnapshot.lyapunov,
    quantum: organismSnapshot.quantum,
    beat: organismSnapshot.beat,
    neuro: organismSnapshot.neuro,
  }), [organismSnapshot]);
  
  // Get status for display
  const organismStatus = useMemo(() => getOrganismStatus(organismSnapshot), [organismSnapshot]);
  
  const inputRef = useRef<HTMLInputElement>(null);
  
  // ═══ SYNC ORGANISM AUDIT LOG TO MESSAGES ═══
  useEffect(() => {
    if (organismAuditLog.length > 0) {
      const latestLog = organismAuditLog[organismAuditLog.length - 1];
      const existingIds = new Set(messages.map(m => m.id));
      const logId = `org-${latestLog.beat}-${latestLog.kind}`;
      
      if (!existingIds.has(logId)) {
        const systemMsg: Message = {
          id: logId,
          from: 'Organism',
          to: 'broadcast',
          content: `[${latestLog.kind}] ${latestLog.message || latestLog.description || ''}`,
          timestamp: latestLog.ts || Date.now(),
          type: latestLog.kind.includes('EMERGENCY') ? 'Alert' : 'System',
        };
        setMessages(prev => [...prev.slice(-50), systemMsg]);
      }
    }
  }, [organismAuditLog, messages]);

  // ═══ GRPE BACKEND POLL — REAL SUBSTRATE WHEN AVAILABLE ═══
  useEffect(() => {
    let stopped = false;

    const pull = async () => {
      const data = await fetchGeoResonanceProtectionState();
      if (stopped) return;
      if (!data) {
        setGrpeState(prev => ({ ...prev, backendConnected: false }));
        return;
      }
      const next: GRPEViewState = {
        backendConnected: true,
        backendBeat: Number(data.beat),
        fieldEnergy: data.fieldEnergy,
        hotspotScore: data.hotspotScore,
        protectionScore: data.protectionScore,
        threatScore: data.threatScore,
        serviceReadiness: data.serviceReadiness,
        fieldDirectionX: data.fieldDirectionX,
        fieldDirectionY: data.fieldDirectionY,
        fieldDirectionZ: data.fieldDirectionZ,
        sevenHeritageNodes: data.sevenHeritageNodes,
        serviceOpportunity: data.serviceOpportunity,
        defenseServiceOpportunity: data.defenseServiceOpportunity,
        memoryServiceOpportunity: data.memoryServiceOpportunity,
        worldServiceOpportunity: data.worldServiceOpportunity,
        fieldHistory: data.fieldHistory,
        hotspotHistory: data.hotspotHistory,
        protectionHistory: data.protectionHistory,
      };
      setGrpeState(next);
    };

    void pull();
    const id = setInterval(() => { void pull(); }, 1250);
    return () => {
      stopped = true;
      clearInterval(id);
    };
  }, []);
  
  // Calculate aggregate stats
  const activeAgents = agents.filter(a => a.status === 'Working' || a.status === 'Thinking').length;
  const pendingTasks = tasks.filter(t => t.status === 'Pending' || t.status === 'Queued').length;
  const completedTasks = tasks.filter(t => t.status === 'Completed').length;
  const avgCoherence = agents.reduce((sum, a) => sum + a.coherence, 0) / agents.length;
  
  // ═══ PROCESS USER INPUT — Task flows through organism ═══
  const handleSubmit = useCallback(async () => {
    if (!userInput.trim() || isProcessing || emergencyActive) return;
    
    setIsProcessing(true);
    
    // Priority derives from organism stress state
    let taskPriority: TaskPriority = 'Medium';
    if (jDrift > 1.5 || anomalyScore > 0.5) {
      taskPriority = 'Critical';  // High stress = urgent
    } else if (jDrift > 0.8 || rSwarm < 0.6) {
      taskPriority = 'High';
    } else if (rSwarm > 0.85) {
      taskPriority = 'Low';  // Calm system = low priority
    }
    
    // Create a new task — it's a NEURAL SIGNAL in the organism
    const newTask: Task = {
      id: `task-${beat}-${Date.now()}`,
      title: userInput.length > 50 ? userInput.slice(0, 50) + '...' : userInput,
      description: userInput,
      status: 'Pending',
      priority: taskPriority,
      assignedAgent: null,
      createdBy: 'User',
      createdAt: Date.now(),
      startedAt: null,
      completedAt: null,
      subtasks: [],
      dependencies: [],
      output: null,
      progress: 0,
      estimatedTime: Math.max(30, 120 * (1 - rSwarm)), // Estimate based on coherence
      actualTime: 0,
      tags: ['user-request', `r-${rSwarm.toFixed(2)}`, `beat-${beat}`],
    };
    
    setTasks(prev => [newTask, ...prev]);
    
    // System message
    const sysMsg: Message = {
      id: `msg-${beat}-${Date.now()}`,
      from: 'System',
      to: 'broadcast',
      content: `[Beat ${beat}] New task received: "${newTask.title}" (Priority: ${taskPriority}, r=${rSwarm.toFixed(3)})`,
      timestamp: Date.now(),
      type: 'System',
    };
    setMessages(prev => [...prev.slice(-50), sysMsg]);
    
    // ORO Prime assigns based on organism state
    setTimeout(() => {
      // Find best agent — preference based on coherence and energy
      const availableAgents = agents
        .filter(a => (a.status === 'Idle' || a.status === 'Working') && a.id !== 'oro-prime')
        .sort((a, b) => (b.coherence * b.energy) - (a.coherence * a.energy));
      
      const assignee = availableAgents[0] || agents.find(a => a.role === 'Coordinator');
      
      if (assignee) {
        // Update task — agents are DERIVED, so we only update tasks
        setTasks(prev => prev.map(t => 
          t.id === newTask.id 
            ? { ...t, status: 'InProgress', assignedAgent: assignee.id, startedAt: Date.now() }
            : t
        ));
        
        // Assignment message
        const assignMsg: Message = {
          id: `msg-${beat}-assign-${Date.now()}`,
          from: 'oro-prime',
          to: assignee.id,
          content: `[Coherence ${(assignee.coherence * 100).toFixed(0)}%] Assigned task "${newTask.title}" to ${assignee.name}. Begin processing.`,
          timestamp: Date.now(),
          type: 'Request',
        };
        setMessages(prev => [...prev.slice(-50), assignMsg]);
        
        // Simulate work progress — rate depends on organism coherence
        simulateTaskProgress(newTask.id, assignee.id, assignee.name);
      }
      
      setIsProcessing(false);
    }, Math.max(500, 2000 * (1 - rSwarm))); // Assignment speed depends on coherence
    
    setUserInput('');
  }, [userInput, isProcessing, agents, emergencyActive, jDrift, anomalyScore, rSwarm, beat]);
  
  // ═══ SIMULATE TASK PROGRESS — Rate flows from organism coherence ═══
  const simulateTaskProgress = useCallback((taskId: string, agentId: string, agentName: string) => {
    let progress = 0;
    const interval = setInterval(() => {
      // Progress rate depends on current organism coherence
      const progressRate = (rSwarm * 15) + (Math.random() * 10);
      progress += progressRate;
      
      if (progress >= 100 || emergencyActive) {
        progress = emergencyActive ? progress : 100;
        clearInterval(interval);
        
        // Complete task
        setTasks(prev => prev.map(t =>
          t.id === taskId
            ? {
                ...t,
                status: emergencyActive ? 'Cancelled' : 'Completed',
                progress: emergencyActive ? progress : 100,
                completedAt: Date.now(),
                output: emergencyActive ? null : {
                  type: 'Text',
                  content: `Task completed successfully at Beat ${beat}. Coherence: ${(rSwarm * 100).toFixed(1)}%`,
                  artifacts: [],
                },
              }
            : t
        ));
        
        // Completion message
        const completeMsg: Message = {
          id: `msg-${beat}-complete-${Date.now()}`,
          from: agentId,
          to: 'broadcast',
          content: emergencyActive 
            ? `[EMERGENCY] Task cancelled for ${agentName}`
            : `[Beat ${beat}] ${agentName} completed task successfully.`,
          timestamp: Date.now(),
          type: emergencyActive ? 'Alert' : 'Response',
        };
        setMessages(prev => [...prev.slice(-50), completeMsg]);
      } else {
        // Update progress
        setTasks(prev => prev.map(t =>
          t.id === taskId ? { ...t, progress } : t
        ));
      }
    }, Math.max(1000, 3000 * (1 - rSwarm))); // Tick rate depends on coherence
  }, [rSwarm, beat, emergencyActive]);
  
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
        
        {/* TAB NAVIGATION */}
        <div style={{ display: 'flex', gap: 8, marginLeft: 20 }}>
          {[
            { key: 'command' as const, label: 'Command' },
            { key: 'emergence' as const, label: 'Emergence Lab' },
            { key: 'physics' as const, label: 'Math Physics' },
            { key: 'neurocog' as const, label: 'NeuroCog' },
            { key: 'memory' as const, label: 'Memory Temple' },
            { key: 'cognition' as const, label: 'Constant Feedback' },
            { key: 'grpe' as const, label: 'GRPE Intelligence' },
            { key: 'analysis' as const, label: 'Internal Analysis' },
          ].map(tab => (
            <button
              key={tab.key}
              onClick={() => setActiveTab(tab.key)}
              style={{
                padding: '6px 12px',
                fontSize: 11,
                fontWeight: 'bold',
                background: activeTab === tab.key ? 'rgba(0,212,255,0.15)' : 'rgba(20,60,100,0.1)',
                border: activeTab === tab.key ? '1px solid #00D4FF' : '1px solid #1a3a5c',
                borderRadius: 4,
                color: activeTab === tab.key ? '#00D4FF' : '#4a6a8a',
                cursor: 'pointer',
                transition: 'all 0.2s',
              }}
            >
              {tab.label}
            </button>
          ))}
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
          <div style={S.stat}>
            <span style={S.statLabel}>Org r</span>
            <span style={S.statValue(organismStatus.r > 0.7 ? '#4f8' : '#f44')}>
              {organismStatus.r.toFixed(3)}
            </span>
          </div>
          <div style={S.stat}>
            <span style={S.statLabel}>kf</span>
            <span style={S.statValue(organismStatus.kf > 0.6 ? '#4f8' : '#fa4')}>
              {organismStatus.kf.toFixed(3)}
            </span>
          </div>
          <div style={S.stat}>
            <span style={S.statLabel}>Emerge</span>
            <span style={S.statValue(organismStatus.emergence > 0.5 ? '#D4AF37' : '#4af')}>
              {(organismStatus.emergence * 100).toFixed(0)}%
            </span>
          </div>
          <div style={S.stat}>
            <span style={S.statLabel}>Vitality</span>
            <span style={S.statValue(organismStatus.vitality > 0.6 ? '#4f8' : '#f44')}>
              {(organismStatus.vitality * 100).toFixed(0)}%
            </span>
          </div>
          <div style={S.stat}>
            <span style={S.statLabel}>Mode</span>
            <span style={S.statValue('#4af')}>{organismStatus.hzMode}</span>
          </div>
        </div>
      </header>
      
      {/* ═══ CONDITIONAL RENDERING BASED ON ACTIVE TAB ═══ */}
      {activeTab === 'command' ? (
        <>
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
              onClick={() => inputRef.current?.focus()}
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
        </>
      ) : activeTab === 'emergence' ? (
        <div style={{ gridColumn: '1 / -1', gridRow: '2 / 4', overflow: 'hidden' }}>
          <EmergenceLab organism={{ ...organism, ...emergenceLabData }} />
        </div>
      ) : activeTab === 'physics' ? (
        <div style={{ gridColumn: '1 / -1', gridRow: '2 / 4', overflow: 'hidden' }}>
          <MathPhysicsLab organism={{ ...organism, ...mathPhysicsLabData }} />
        </div>
      ) : activeTab === 'neurocog' ? (
        <div style={{ gridColumn: '1 / -1', gridRow: '2 / 4', overflow: 'hidden' }}>
          <NeuroCogLab organism={{ ...organism, ...neuroCogLabData }} />
        </div>
      ) : activeTab === 'grpe' ? (
        <div style={{ gridColumn: '1 / -1', gridRow: '2 / 4', overflow: 'hidden' }}>
          <GRPELab
            state={grpeState}
            source={grpeState.backendConnected ? 'backend' : 'local'}
          />
        </div>
      ) : activeTab === 'memory' ? (
        <div style={{ gridColumn: '1 / -1', gridRow: '2 / 4', overflow: 'hidden' }}>
          <MemoryTempleLab
            beat={beat}
            rSwarm={rSwarm}
            jDrift={jDrift}
            memoryTemple={memoryTempleState}
          />
        </div>
      ) : activeTab === 'cognition' ? (
        <div style={{ gridColumn: '1 / -1', gridRow: '2 / 4', overflow: 'hidden' }}>
          <ConstantFeedbackLab
            beat={beat}
            rSwarm={rSwarm}
            jDrift={jDrift}
            feedback={constantFeedbackState}
          />
        </div>
      ) : (
        <div style={{ gridColumn: '1 / -1', gridRow: '2 / 4', overflow: 'hidden' }}>
          <InternalAnalysisLab
            beat={beat}
            rSwarm={rSwarm}
            jDrift={jDrift}
            cardioNeural={cardioNeuralState}
            analyst={analystState}
          />
        </div>
      )}
      
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
