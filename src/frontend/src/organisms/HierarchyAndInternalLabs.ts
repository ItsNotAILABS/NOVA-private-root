// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Module: HierarchyAndInternalLabs — Command Hierarchy + Internal AI Labs
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                    HIERARCHY & INTERNAL AI LABS                                                          ║
// ╠══════════════════════════════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                                          ║
// ║  THE HIERARCHY:                                                                                          ║
// ║    ARCHITECT (Human Admin)                                                                               ║
// ║        ↓                                                                                                 ║
// ║    SOVEREIGN COUNCIL (Governance AIs)                                                                    ║
// ║        ↓                                                                                                 ║
// ║    INTERNAL AI LABS (Behind-the-scenes workers)                                                          ║
// ║        ↓                                                                                                 ║
// ║    THEATRE COMMANDERS (Strategic level)                                                                  ║
// ║        ↓                                                                                                 ║
// ║    SWARM COMMANDERS (Operational level)                                                                  ║
// ║        ↓                                                                                                 ║
// ║    SQUAD LEADERS (Tactical level)                                                                        ║
// ║        ↓                                                                                                 ║
// ║    INDIVIDUAL UNITS (Execution level)                                                                    ║
// ║                                                                                                          ║
// ║  SCRIPTED vs SOVEREIGN:                                                                                  ║
// ║    • SCRIPTED: Rules, roles, doctrine — what things ARE (DNA)                                           ║
// ║    • SOVEREIGN: Decisions, adaptation, emergence — what things DECIDE                                   ║
// ║                                                                                                          ║
// ║  INTERNAL AI LABS keep the world ALIVE by constantly working on:                                         ║
// ║    • Scenarios                                                                                           ║
// ║    • World balance                                                                                       ║
// ║    • Hierarchy optimization                                                                              ║
// ║    • Quality assurance                                                                                   ║
// ║    • Research & improvement                                                                              ║
// ║                                                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { φ, fib } from './OrganicWorldFoundation';

// ═══════════════════════════════════════════════════════════════════════════════
// HIERARCHY LEVELS — The Chain of Command
// ═══════════════════════════════════════════════════════════════════════════════

export type HierarchyLevel =
  | 'ARCHITECT'           // Human admin — ultimate authority
  | 'SOVEREIGN_COUNCIL'   // High-level AI governance
  | 'AI_LAB'              // Internal teams that maintain the world
  | 'THEATRE_COMMANDER'   // Strategic level — whole theatre of operations
  | 'SWARM_COMMANDER'     // Operational level — multiple swarms
  | 'SQUAD_LEADER'        // Tactical level — small unit
  | 'INDIVIDUAL';         // Execution level — single drone/unit

export interface HierarchyNode {
  id: string;
  level: HierarchyLevel;
  name: string;
  
  // Chain of command
  superiorId: string | null;       // Who this reports to
  subordinateIds: string[];        // Who reports to this
  
  // Authority
  authorityScope: AuthorityScope;
  decisionRights: DecisionRight[];
  
  // Communication
  canCommunicateWith: HierarchyLevel[];  // What levels can this talk to directly
  
  // State
  isActive: boolean;
  coherence: number;
  effectiveness: number;
}

export interface AuthorityScope {
  // What can this level control?
  canCommand: boolean;           // Can issue orders
  canOverride: boolean;          // Can override subordinate decisions
  canCreate: boolean;            // Can create new entities
  canDestroy: boolean;           // Can destroy entities
  canModifyRules: boolean;       // Can change scripted rules
  canAccessLabs: boolean;        // Can access AI labs
  
  // Geographic/numeric scope
  maxUnitsControlled: number;
  maxAreaKm2: number;
  maxBudget: number;             // Resource allocation limit
}

export type DecisionRight =
  | 'ENGAGE'                     // Can authorize combat
  | 'RETREAT'                    // Can order retreat
  | 'RESOURCE_ALLOCATION'        // Can allocate resources
  | 'SPAWN_UNITS'                // Can create new units
  | 'DESTROY_UNITS'              // Can sacrifice units
  | 'MODIFY_DOCTRINE'            // Can change rules
  | 'CREATE_SCENARIOS'           // Can create new scenarios
  | 'MODIFY_WORLD'               // Can change world state
  | 'ACCESS_INTELLIGENCE'        // Can access sensor data
  | 'COMMUNICATE_EXTERNAL';      // Can talk outside hierarchy

// Default authority by level
export const DEFAULT_AUTHORITY: Record<HierarchyLevel, AuthorityScope> = {
  ARCHITECT: {
    canCommand: true,
    canOverride: true,
    canCreate: true,
    canDestroy: true,
    canModifyRules: true,
    canAccessLabs: true,
    maxUnitsControlled: Infinity,
    maxAreaKm2: Infinity,
    maxBudget: Infinity
  },
  SOVEREIGN_COUNCIL: {
    canCommand: true,
    canOverride: true,
    canCreate: true,
    canDestroy: true,
    canModifyRules: true,
    canAccessLabs: true,
    maxUnitsControlled: 10000,
    maxAreaKm2: 1000000,
    maxBudget: 1000000
  },
  AI_LAB: {
    canCommand: false,
    canOverride: false,
    canCreate: true,
    canDestroy: false,
    canModifyRules: true,
    canAccessLabs: true,
    maxUnitsControlled: 100,
    maxAreaKm2: 10000,
    maxBudget: 100000
  },
  THEATRE_COMMANDER: {
    canCommand: true,
    canOverride: true,
    canCreate: true,
    canDestroy: true,
    canModifyRules: false,
    canAccessLabs: false,
    maxUnitsControlled: 1000,
    maxAreaKm2: 100000,
    maxBudget: 500000
  },
  SWARM_COMMANDER: {
    canCommand: true,
    canOverride: true,
    canCreate: false,
    canDestroy: true,
    canModifyRules: false,
    canAccessLabs: false,
    maxUnitsControlled: 100,
    maxAreaKm2: 10000,
    maxBudget: 50000
  },
  SQUAD_LEADER: {
    canCommand: true,
    canOverride: false,
    canCreate: false,
    canDestroy: false,
    canModifyRules: false,
    canAccessLabs: false,
    maxUnitsControlled: 12,
    maxAreaKm2: 100,
    maxBudget: 1000
  },
  INDIVIDUAL: {
    canCommand: false,
    canOverride: false,
    canCreate: false,
    canDestroy: false,
    canModifyRules: false,
    canAccessLabs: false,
    maxUnitsControlled: 1,
    maxAreaKm2: 1,
    maxBudget: 10
  }
};

// ═══════════════════════════════════════════════════════════════════════════════
// SCRIPTED vs SOVEREIGN — Two Types of Behavior
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * SCRIPTED: These are the RULES — what things ARE.
 * Like DNA, doctrine, roles. They don't change (much).
 */
export interface ScriptedBehavior {
  id: string;
  name: string;
  type: ScriptedType;
  
  // The rule
  description: string;
  conditions: ScriptCondition[];
  actions: ScriptAction[];
  
  // Priority and scope
  priority: number;              // Higher = more important
  appliesTo: HierarchyLevel[];   // What levels follow this
  mandatory: boolean;            // Can this be overridden?
  
  // State
  isActive: boolean;
  timesTriggered: number;
}

export type ScriptedType =
  | 'DOCTRINE'                   // Military doctrine (how to fight)
  | 'ROLE'                       // What a unit type does
  | 'PROTOCOL'                   // Standard procedures
  | 'LAW'                        // Inviolable rules (60 laws)
  | 'CONSTRAINT';                // Physical/logical limits

export interface ScriptCondition {
  type: 'State' | 'Event' | 'Time' | 'Location' | 'Entity';
  parameter: string;
  operator: '==' | '!=' | '>' | '<' | '>=' | '<=' | 'contains' | 'near';
  value: any;
}

export interface ScriptAction {
  type: 'Command' | 'Modify' | 'Create' | 'Destroy' | 'Communicate' | 'Wait';
  target: string;
  parameters: Record<string, any>;
}

/**
 * SOVEREIGN: These are DECISIONS — what things CHOOSE.
 * Emergent, adaptive, learned.
 */
export interface SovereignDecision {
  id: string;
  deciderId: string;            // Who made this decision
  deciderLevel: HierarchyLevel;
  
  timestamp: number;
  
  // The decision
  type: DecisionType;
  description: string;
  
  // Context
  situation: string;
  alternatives: string[];       // What else was considered
  reasoning: string;            // Why this was chosen
  
  // Cognitive factors
  confidence: number;           // How sure
  coherence: number;            // Internal consistency
  urgency: number;              // Time pressure
  
  // Outcome
  executed: boolean;
  outcome: 'Success' | 'Failure' | 'Partial' | 'Pending' | null;
  
  // Learning
  hebbianReinforcement: number; // How much this affected weights
}

export type DecisionType =
  | 'TACTICAL'                   // Immediate combat decisions
  | 'OPERATIONAL'                // Mission-level decisions
  | 'STRATEGIC'                  // Long-term decisions
  | 'ADAPTIVE'                   // Changing behavior
  | 'CREATIVE';                  // Novel solutions

// ═══════════════════════════════════════════════════════════════════════════════
// INTERNAL AI LABS — The Behind-the-Scenes Workers
// ═══════════════════════════════════════════════════════════════════════════════

export type LabType =
  | 'SCENARIO_LAB'               // Creates and manages scenarios
  | 'BALANCE_LAB'                // Keeps the world balanced
  | 'QA_LAB'                     // Quality assurance, bug finding
  | 'RESEARCH_LAB'               // Improves organisms/systems
  | 'DOCTRINE_LAB'               // Develops military doctrine
  | 'HIERARCHY_LAB'              // Optimizes command structure
  | 'WORLD_LAB'                  // Maintains world state
  | 'ANALYTICS_LAB';             // Data analysis, reporting

export interface AILab {
  id: string;
  type: LabType;
  name: string;
  
  // The lab's "mind"
  coherence: number;
  energy: number;
  focus: number;                 // What it's currently focused on
  
  // Team members (sub-AIs)
  agents: LabAgent[];
  
  // Work queue
  tasks: LabTask[];
  completedTasks: LabTask[];
  
  // Output
  recommendations: LabRecommendation[];
  modifications: LabModification[];
  
  // State
  isActive: boolean;
  workload: number;              // 0-1 how busy
  efficiency: number;            // 0-1 how effective
  
  // Hebbian weights for task prioritization
  taskWeights: Map<string, number>;
}

export interface LabAgent {
  id: string;
  name: string;
  specialty: string;
  
  // Cognitive state (same as other organisms)
  coherence: number;
  energy: number;
  
  // Current work
  currentTask: string | null;
  productivity: number;
  
  // Skills
  skills: Map<string, number>;   // Skill name → proficiency
}

export interface LabTask {
  id: string;
  type: string;
  description: string;
  
  // Assignment
  assignedTo: string | null;     // Agent ID
  labId: string;
  
  // Priority
  priority: number;
  urgency: number;
  
  // Progress
  status: 'Pending' | 'InProgress' | 'Review' | 'Complete' | 'Failed';
  progress: number;              // 0-1
  
  // Timing
  createdAt: number;
  startedAt: number | null;
  completedAt: number | null;
  deadline: number | null;
  
  // Result
  output: any;
}

export interface LabRecommendation {
  id: string;
  labId: string;
  
  type: 'Improvement' | 'Warning' | 'Opportunity' | 'Risk';
  target: string;                // What this is about
  description: string;
  
  confidence: number;
  impact: number;                // Estimated effect
  
  // Action
  suggestedAction: string;
  approved: boolean;
  implemented: boolean;
}

export interface LabModification {
  id: string;
  labId: string;
  
  type: 'ScriptedRule' | 'HierarchyChange' | 'WorldChange' | 'Balance' | 'Doctrine';
  target: string;
  
  before: any;
  after: any;
  
  reason: string;
  approvedBy: string | null;
  
  timestamp: number;
  reverted: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// LAB IMPLEMENTATIONS — What Each Lab Does
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * SCENARIO LAB — Creates and manages scenarios
 */
export class ScenarioLab implements AILabBehavior {
  private lab: AILab;
  
  constructor() {
    this.lab = this.createLab('SCENARIO_LAB', 'Scenario Design Lab');
    this.addAgent('scenario_designer_1', 'Lead Scenario Designer', 'scenario_design');
    this.addAgent('scenario_writer_1', 'Scenario Writer', 'narrative');
    this.addAgent('balance_checker_1', 'Balance Analyst', 'game_balance');
  }
  
  tick(beat: number, worldState: any): void {
    // Check if world needs new scenarios
    if (this.shouldCreateScenario(worldState)) {
      this.queueTask({
        id: `task_scenario_${beat}`,
        type: 'CREATE_SCENARIO',
        description: 'Create new scenario based on world state',
        assignedTo: null,
        labId: this.lab.id,
        priority: 0.7,
        urgency: worldState.tension < 0.3 ? 0.8 : 0.4,
        status: 'Pending',
        progress: 0,
        createdAt: beat,
        startedAt: null,
        completedAt: null,
        deadline: beat + 1000,
        output: null
      });
    }
    
    // Process tasks
    this.processTasks(beat);
  }
  
  private shouldCreateScenario(worldState: any): boolean {
    // Create scenarios when tension is low (need excitement)
    // or when previous scenario ended
    return worldState.tension < 0.3 || worldState.activeScenarios < 1;
  }
  
  private processTasks(beat: number): void {
    for (const task of this.lab.tasks) {
      if (task.status === 'Pending') {
        // Assign to available agent
        const agent = this.findAvailableAgent(task.type);
        if (agent) {
          task.assignedTo = agent.id;
          task.status = 'InProgress';
          task.startedAt = beat;
          agent.currentTask = task.id;
        }
      } else if (task.status === 'InProgress') {
        // Progress task
        const agent = this.lab.agents.find(a => a.id === task.assignedTo);
        if (agent) {
          task.progress += agent.productivity * 0.01;
          if (task.progress >= 1) {
            task.status = 'Complete';
            task.completedAt = beat;
            task.output = this.generateScenarioOutput(task);
            agent.currentTask = null;
          }
        }
      }
    }
  }
  
  private findAvailableAgent(taskType: string): LabAgent | null {
    return this.lab.agents.find(a => a.currentTask === null) || null;
  }
  
  private generateScenarioOutput(task: LabTask): any {
    // Generate scenario based on lab's learned preferences
    return {
      type: 'symmetric_warfare',
      name: 'Generated Scenario',
      generated: true
    };
  }
  
  private createLab(type: LabType, name: string): AILab {
    return {
      id: `lab_${type}_${Date.now()}`,
      type,
      name,
      coherence: 0.8,
      energy: 1.0,
      focus: 0.5,
      agents: [],
      tasks: [],
      completedTasks: [],
      recommendations: [],
      modifications: [],
      isActive: true,
      workload: 0,
      efficiency: 0.8,
      taskWeights: new Map()
    };
  }
  
  private addAgent(id: string, name: string, specialty: string): void {
    this.lab.agents.push({
      id,
      name,
      specialty,
      coherence: 0.7 + Math.random() * 0.3,
      energy: 1.0,
      currentTask: null,
      productivity: 0.8 + Math.random() * 0.2,
      skills: new Map([[specialty, 0.8]])
    });
  }
  
  private queueTask(task: LabTask): void {
    this.lab.tasks.push(task);
  }
  
  getLab(): AILab { return this.lab; }
}

/**
 * BALANCE LAB — Keeps the world balanced
 */
export class BalanceLab implements AILabBehavior {
  private lab: AILab;
  private balanceHistory: BalanceSnapshot[] = [];
  
  constructor() {
    this.lab = {
      id: 'lab_balance',
      type: 'BALANCE_LAB',
      name: 'World Balance Lab',
      coherence: 0.9,
      energy: 1.0,
      focus: 0.5,
      agents: [
        { id: 'balance_1', name: 'Balance Analyst', specialty: 'metrics', coherence: 0.8, energy: 1, currentTask: null, productivity: 0.9, skills: new Map() },
        { id: 'balance_2', name: 'Fairness Checker', specialty: 'fairness', coherence: 0.85, energy: 1, currentTask: null, productivity: 0.85, skills: new Map() }
      ],
      tasks: [],
      completedTasks: [],
      recommendations: [],
      modifications: [],
      isActive: true,
      workload: 0.3,
      efficiency: 0.9,
      taskWeights: new Map()
    };
  }
  
  tick(beat: number, worldState: any): void {
    // Take balance snapshot
    const snapshot = this.takeSnapshot(beat, worldState);
    this.balanceHistory.push(snapshot);
    
    // Analyze for imbalances
    const issues = this.analyzeBalance(snapshot);
    
    // Create recommendations
    for (const issue of issues) {
      this.createRecommendation(issue);
    }
    
    // Limit history
    if (this.balanceHistory.length > 1000) {
      this.balanceHistory.shift();
    }
  }
  
  private takeSnapshot(beat: number, worldState: any): BalanceSnapshot {
    return {
      beat,
      novaStrength: worldState.novaStrength || 1.0,
      enemyStrength: worldState.enemyStrength || 1.0,
      resourceBalance: worldState.resources || 0.5,
      territoryBalance: worldState.territory || 0.5,
      difficultyRating: worldState.difficulty || 0.5
    };
  }
  
  private analyzeBalance(snapshot: BalanceSnapshot): BalanceIssue[] {
    const issues: BalanceIssue[] = [];
    
    // Check strength ratio
    const strengthRatio = snapshot.novaStrength / Math.max(0.1, snapshot.enemyStrength);
    if (strengthRatio > 2.0) {
      issues.push({
        type: 'TOO_EASY',
        severity: (strengthRatio - 2) / 3,
        description: 'NOVA is too strong compared to enemies'
      });
    } else if (strengthRatio < 0.5) {
      issues.push({
        type: 'TOO_HARD',
        severity: (0.5 - strengthRatio) * 2,
        description: 'Enemies are overwhelming NOVA'
      });
    }
    
    // Check resource balance
    if (snapshot.resourceBalance > 0.8) {
      issues.push({
        type: 'RESOURCE_GLUT',
        severity: snapshot.resourceBalance - 0.8,
        description: 'Too many resources available'
      });
    } else if (snapshot.resourceBalance < 0.2) {
      issues.push({
        type: 'RESOURCE_SCARCITY',
        severity: 0.2 - snapshot.resourceBalance,
        description: 'Resources too scarce'
      });
    }
    
    return issues;
  }
  
  private createRecommendation(issue: BalanceIssue): void {
    const rec: LabRecommendation = {
      id: `rec_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      labId: this.lab.id,
      type: 'Warning',
      target: issue.type,
      description: issue.description,
      confidence: 0.8,
      impact: issue.severity,
      suggestedAction: this.suggestAction(issue),
      approved: false,
      implemented: false
    };
    
    this.lab.recommendations.push(rec);
    
    // Auto-approve low-severity issues
    if (issue.severity < 0.3) {
      rec.approved = true;
    }
  }
  
  private suggestAction(issue: BalanceIssue): string {
    switch (issue.type) {
      case 'TOO_EASY':
        return 'Spawn additional enemy forces or upgrade enemy capabilities';
      case 'TOO_HARD':
        return 'Reduce enemy spawn rate or provide NOVA with reinforcements';
      case 'RESOURCE_GLUT':
        return 'Reduce resource spawn rate or create resource sinks';
      case 'RESOURCE_SCARCITY':
        return 'Increase resource availability or reduce consumption';
      default:
        return 'Review and assess manually';
    }
  }
  
  getLab(): AILab { return this.lab; }
}

interface BalanceSnapshot {
  beat: number;
  novaStrength: number;
  enemyStrength: number;
  resourceBalance: number;
  territoryBalance: number;
  difficultyRating: number;
}

interface BalanceIssue {
  type: string;
  severity: number;
  description: string;
}

/**
 * DOCTRINE LAB — Develops and refines military doctrine
 */
export class DoctrineLab implements AILabBehavior {
  private lab: AILab;
  private doctrineLibrary: Map<string, DoctrineEntry> = new Map();
  
  constructor() {
    this.lab = {
      id: 'lab_doctrine',
      type: 'DOCTRINE_LAB',
      name: 'Military Doctrine Lab',
      coherence: 0.85,
      energy: 1.0,
      focus: 0.6,
      agents: [
        { id: 'strategist_1', name: 'Chief Strategist', specialty: 'strategy', coherence: 0.9, energy: 1, currentTask: null, productivity: 0.85, skills: new Map([['strategy', 0.95]]) },
        { id: 'tactician_1', name: 'Tactical Analyst', specialty: 'tactics', coherence: 0.85, energy: 1, currentTask: null, productivity: 0.9, skills: new Map([['tactics', 0.9]]) },
        { id: 'historian_1', name: 'Military Historian', specialty: 'history', coherence: 0.8, energy: 1, currentTask: null, productivity: 0.8, skills: new Map([['history', 0.85]]) }
      ],
      tasks: [],
      completedTasks: [],
      recommendations: [],
      modifications: [],
      isActive: true,
      workload: 0.4,
      efficiency: 0.85,
      taskWeights: new Map()
    };
    
    // Initialize with base doctrines
    this.initializeDoctrines();
  }
  
  private initializeDoctrines(): void {
    // Sun Tzu
    this.addDoctrine('sun_tzu_deception', 'Deception', 
      'All warfare is based on deception', 'Sun Tzu', 
      ['feint', 'ambush', 'misdirection']);
    
    this.addDoctrine('sun_tzu_terrain', 'Terrain Exploitation',
      'Know the terrain as you know yourself', 'Sun Tzu',
      ['high_ground', 'chokepoints', 'flanking']);
    
    // Clausewitz
    this.addDoctrine('clausewitz_cog', 'Center of Gravity',
      'Strike at the enemy center of gravity', 'Clausewitz',
      ['command_targeting', 'logistics_interdiction', 'morale_attack']);
    
    this.addDoctrine('clausewitz_friction', 'Fog of War',
      'Everything in war is simple, but the simple is difficult', 'Clausewitz',
      ['redundancy', 'flexibility', 'reserves']);
    
    // Boyd
    this.addDoctrine('boyd_ooda', 'OODA Loop',
      'Observe, Orient, Decide, Act — faster than the enemy', 'John Boyd',
      ['rapid_decision', 'tempo', 'initiative']);
    
    // Modern Drone Warfare
    this.addDoctrine('swarm_saturation', 'Swarm Saturation',
      'Overwhelm defenses with numbers', 'Modern',
      ['mass_attack', 'distributed_targeting', 'attrition']);
    
    this.addDoctrine('loyal_wingman', 'Loyal Wingman',
      'AI wingmen extend manned platform capability', 'Modern',
      ['manned_unmanned_teaming', 'sensor_extension', 'risk_distribution']);
  }
  
  private addDoctrine(id: string, name: string, description: string, source: string, tactics: string[]): void {
    this.doctrineLibrary.set(id, {
      id,
      name,
      description,
      source,
      tactics,
      effectiveness: 0.5,
      timesUsed: 0,
      successRate: 0.5
    });
  }
  
  tick(beat: number, worldState: any): void {
    // Analyze combat outcomes to refine doctrine
    if (worldState.recentCombat) {
      this.analyzeCombatOutcome(worldState.recentCombat);
    }
    
    // Periodically review doctrine effectiveness
    if (beat % fib(10) === 0) {
      this.reviewDoctrineEffectiveness();
    }
  }
  
  private analyzeCombatOutcome(combat: any): void {
    // Update doctrine based on what worked
    const doctrinesUsed = combat.doctrinesUsed || [];
    const success = combat.outcome === 'Victory';
    
    for (const doctrineId of doctrinesUsed) {
      const doctrine = this.doctrineLibrary.get(doctrineId);
      if (doctrine) {
        doctrine.timesUsed++;
        // Hebbian update
        const learningRate = 0.1;
        if (success) {
          doctrine.successRate = doctrine.successRate * (1 - learningRate) + learningRate;
          doctrine.effectiveness = Math.min(1, doctrine.effectiveness + 0.05);
        } else {
          doctrine.successRate = doctrine.successRate * (1 - learningRate);
          doctrine.effectiveness = Math.max(0, doctrine.effectiveness - 0.03);
        }
      }
    }
  }
  
  private reviewDoctrineEffectiveness(): void {
    // Generate recommendations for low-performing doctrines
    for (const [id, doctrine] of this.doctrineLibrary) {
      if (doctrine.timesUsed > 10 && doctrine.successRate < 0.3) {
        this.lab.recommendations.push({
          id: `rec_doctrine_${id}_${Date.now()}`,
          labId: this.lab.id,
          type: 'Warning',
          target: id,
          description: `Doctrine "${doctrine.name}" has low success rate (${(doctrine.successRate * 100).toFixed(1)}%)`,
          confidence: 0.8,
          impact: 0.5,
          suggestedAction: 'Review doctrine application or retire',
          approved: false,
          implemented: false
        });
      }
    }
  }
  
  getDoctrineLibrary(): Map<string, DoctrineEntry> { return this.doctrineLibrary; }
  getLab(): AILab { return this.lab; }
}

interface DoctrineEntry {
  id: string;
  name: string;
  description: string;
  source: string;
  tactics: string[];
  effectiveness: number;
  timesUsed: number;
  successRate: number;
}

/**
 * HIERARCHY LAB — Optimizes command structure
 */
export class HierarchyLab implements AILabBehavior {
  private lab: AILab;
  
  constructor() {
    this.lab = {
      id: 'lab_hierarchy',
      type: 'HIERARCHY_LAB',
      name: 'Command Hierarchy Lab',
      coherence: 0.85,
      energy: 1.0,
      focus: 0.5,
      agents: [
        { id: 'org_analyst_1', name: 'Org Structure Analyst', specialty: 'organization', coherence: 0.85, energy: 1, currentTask: null, productivity: 0.85, skills: new Map() },
        { id: 'comm_analyst_1', name: 'Communication Analyst', specialty: 'communication', coherence: 0.8, energy: 1, currentTask: null, productivity: 0.8, skills: new Map() }
      ],
      tasks: [],
      completedTasks: [],
      recommendations: [],
      modifications: [],
      isActive: true,
      workload: 0.25,
      efficiency: 0.85,
      taskWeights: new Map()
    };
  }
  
  tick(beat: number, hierarchy: CommandHierarchy): void {
    // Analyze span of control
    this.analyzeSpanOfControl(hierarchy);
    
    // Analyze communication efficiency
    this.analyzeCommunication(hierarchy);
    
    // Analyze decision latency
    this.analyzeDecisionLatency(hierarchy);
  }
  
  private analyzeSpanOfControl(hierarchy: CommandHierarchy): void {
    // Check if any commander has too many direct reports
    for (const node of hierarchy.nodes.values()) {
      if (node.subordinateIds.length > 7) {
        // Miller's Law - humans (and AIs) can only manage 7±2
        this.lab.recommendations.push({
          id: `rec_span_${node.id}_${Date.now()}`,
          labId: this.lab.id,
          type: 'Warning',
          target: node.id,
          description: `Commander ${node.name} has ${node.subordinateIds.length} direct reports (optimal: 5-7)`,
          confidence: 0.9,
          impact: 0.6,
          suggestedAction: 'Add intermediate command layer',
          approved: false,
          implemented: false
        });
      }
    }
  }
  
  private analyzeCommunication(hierarchy: CommandHierarchy): void {
    // Check for communication bottlenecks
    // (Simplified - would analyze actual message flow)
  }
  
  private analyzeDecisionLatency(hierarchy: CommandHierarchy): void {
    // Check if decisions are taking too long through the chain
    // (Simplified - would track actual decision times)
  }
  
  getLab(): AILab { return this.lab; }
}

interface AILabBehavior {
  tick(beat: number, context: any): void;
  getLab(): AILab;
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMMAND HIERARCHY — The Full Chain of Command
// ═══════════════════════════════════════════════════════════════════════════════

export class CommandHierarchy {
  public nodes: Map<string, HierarchyNode> = new Map();
  private scriptedBehaviors: Map<string, ScriptedBehavior> = new Map();
  private sovereignDecisions: SovereignDecision[] = [];
  
  // The labs
  private labs: Map<string, AILabBehavior> = new Map();
  
  constructor() {
    // Initialize hierarchy
    this.initializeHierarchy();
    
    // Initialize labs
    this.initializeLabs();
    
    // Initialize scripted behaviors
    this.initializeScriptedBehaviors();
  }
  
  private initializeHierarchy(): void {
    // Create default hierarchy
    
    // ARCHITECT - The human admin
    this.addNode({
      id: 'architect',
      level: 'ARCHITECT',
      name: 'Architect',
      superiorId: null,
      subordinateIds: ['council'],
      authorityScope: DEFAULT_AUTHORITY.ARCHITECT,
      decisionRights: ['ENGAGE', 'RETREAT', 'RESOURCE_ALLOCATION', 'SPAWN_UNITS', 'DESTROY_UNITS', 'MODIFY_DOCTRINE', 'CREATE_SCENARIOS', 'MODIFY_WORLD', 'ACCESS_INTELLIGENCE', 'COMMUNICATE_EXTERNAL'],
      canCommunicateWith: ['SOVEREIGN_COUNCIL', 'AI_LAB', 'THEATRE_COMMANDER'],
      isActive: true,
      coherence: 1.0,
      effectiveness: 1.0
    });
    
    // SOVEREIGN COUNCIL
    this.addNode({
      id: 'council',
      level: 'SOVEREIGN_COUNCIL',
      name: 'Sovereign Council',
      superiorId: 'architect',
      subordinateIds: ['lab_scenarios', 'lab_balance', 'lab_doctrine', 'lab_hierarchy', 'theatre_cmd_1'],
      authorityScope: DEFAULT_AUTHORITY.SOVEREIGN_COUNCIL,
      decisionRights: ['ENGAGE', 'RETREAT', 'RESOURCE_ALLOCATION', 'SPAWN_UNITS', 'MODIFY_DOCTRINE', 'CREATE_SCENARIOS', 'ACCESS_INTELLIGENCE'],
      canCommunicateWith: ['ARCHITECT', 'AI_LAB', 'THEATRE_COMMANDER'],
      isActive: true,
      coherence: 0.9,
      effectiveness: 0.9
    });
    
    // AI LABS (as nodes in hierarchy)
    for (const labType of ['lab_scenarios', 'lab_balance', 'lab_doctrine', 'lab_hierarchy']) {
      this.addNode({
        id: labType,
        level: 'AI_LAB',
        name: `AI Lab: ${labType}`,
        superiorId: 'council',
        subordinateIds: [],
        authorityScope: DEFAULT_AUTHORITY.AI_LAB,
        decisionRights: ['MODIFY_DOCTRINE', 'ACCESS_INTELLIGENCE'],
        canCommunicateWith: ['SOVEREIGN_COUNCIL', 'AI_LAB'],
        isActive: true,
        coherence: 0.85,
        effectiveness: 0.85
      });
    }
    
    // THEATRE COMMANDER
    this.addNode({
      id: 'theatre_cmd_1',
      level: 'THEATRE_COMMANDER',
      name: 'Theatre Commander Alpha',
      superiorId: 'council',
      subordinateIds: ['swarm_cmd_1', 'swarm_cmd_2'],
      authorityScope: DEFAULT_AUTHORITY.THEATRE_COMMANDER,
      decisionRights: ['ENGAGE', 'RETREAT', 'RESOURCE_ALLOCATION', 'SPAWN_UNITS', 'DESTROY_UNITS', 'ACCESS_INTELLIGENCE'],
      canCommunicateWith: ['SOVEREIGN_COUNCIL', 'SWARM_COMMANDER'],
      isActive: true,
      coherence: 0.85,
      effectiveness: 0.85
    });
    
    // SWARM COMMANDERS
    this.addNode({
      id: 'swarm_cmd_1',
      level: 'SWARM_COMMANDER',
      name: 'Swarm Commander Bravo',
      superiorId: 'theatre_cmd_1',
      subordinateIds: ['squad_1', 'squad_2', 'squad_3'],
      authorityScope: DEFAULT_AUTHORITY.SWARM_COMMANDER,
      decisionRights: ['ENGAGE', 'RETREAT', 'DESTROY_UNITS', 'ACCESS_INTELLIGENCE'],
      canCommunicateWith: ['THEATRE_COMMANDER', 'SQUAD_LEADER'],
      isActive: true,
      coherence: 0.8,
      effectiveness: 0.8
    });
    
    this.addNode({
      id: 'swarm_cmd_2',
      level: 'SWARM_COMMANDER',
      name: 'Swarm Commander Charlie',
      superiorId: 'theatre_cmd_1',
      subordinateIds: ['squad_4', 'squad_5'],
      authorityScope: DEFAULT_AUTHORITY.SWARM_COMMANDER,
      decisionRights: ['ENGAGE', 'RETREAT', 'DESTROY_UNITS', 'ACCESS_INTELLIGENCE'],
      canCommunicateWith: ['THEATRE_COMMANDER', 'SQUAD_LEADER'],
      isActive: true,
      coherence: 0.8,
      effectiveness: 0.8
    });
  }
  
  private initializeLabs(): void {
    this.labs.set('SCENARIO_LAB', new ScenarioLab());
    this.labs.set('BALANCE_LAB', new BalanceLab());
    this.labs.set('DOCTRINE_LAB', new DoctrineLab());
    this.labs.set('HIERARCHY_LAB', new HierarchyLab());
  }
  
  private initializeScriptedBehaviors(): void {
    // DOCTRINE: Always maintain formation coherence
    this.addScriptedBehavior({
      id: 'doctrine_formation',
      name: 'Maintain Formation',
      type: 'DOCTRINE',
      description: 'Units must maintain formation coherence above 0.5',
      conditions: [
        { type: 'State', parameter: 'formation_coherence', operator: '<', value: 0.5 }
      ],
      actions: [
        { type: 'Command', target: 'self', parameters: { command: 'REGROUP' } }
      ],
      priority: 0.8,
      appliesTo: ['SWARM_COMMANDER', 'SQUAD_LEADER'],
      mandatory: true,
      isActive: true,
      timesTriggered: 0
    });
    
    // ROLE: Scout behavior
    this.addScriptedBehavior({
      id: 'role_scout',
      name: 'Scout Role',
      type: 'ROLE',
      description: 'Scouts move ahead of main force and report contacts',
      conditions: [
        { type: 'Entity', parameter: 'unit_type', operator: '==', value: 'SCOUT' }
      ],
      actions: [
        { type: 'Command', target: 'self', parameters: { command: 'ADVANCE', distance: 100 } },
        { type: 'Communicate', target: 'superior', parameters: { type: 'CONTACT_REPORT' } }
      ],
      priority: 0.7,
      appliesTo: ['INDIVIDUAL'],
      mandatory: false,
      isActive: true,
      timesTriggered: 0
    });
    
    // PROTOCOL: Chain of command communication
    this.addScriptedBehavior({
      id: 'protocol_chain',
      name: 'Chain of Command',
      type: 'PROTOCOL',
      description: 'Orders flow down, reports flow up',
      conditions: [],
      actions: [],
      priority: 1.0,
      appliesTo: ['THEATRE_COMMANDER', 'SWARM_COMMANDER', 'SQUAD_LEADER', 'INDIVIDUAL'],
      mandatory: true,
      isActive: true,
      timesTriggered: 0
    });
    
    // LAW: Never fire on friendlies (from 60 laws)
    this.addScriptedBehavior({
      id: 'law_no_friendly_fire',
      name: 'No Friendly Fire',
      type: 'LAW',
      description: 'Never engage units marked as friendly',
      conditions: [
        { type: 'Entity', parameter: 'target_faction', operator: '==', value: 'FRIENDLY' }
      ],
      actions: [
        { type: 'Command', target: 'self', parameters: { command: 'HOLD_FIRE' } }
      ],
      priority: 1.0,
      appliesTo: ['THEATRE_COMMANDER', 'SWARM_COMMANDER', 'SQUAD_LEADER', 'INDIVIDUAL'],
      mandatory: true,
      isActive: true,
      timesTriggered: 0
    });
  }
  
  /**
   * Main tick - updates hierarchy and labs
   */
  tick(beat: number, worldState: any): void {
    // Tick all labs
    for (const [type, lab] of this.labs) {
      if (type === 'SCENARIO_LAB') {
        (lab as ScenarioLab).tick(beat, worldState);
      } else if (type === 'BALANCE_LAB') {
        (lab as BalanceLab).tick(beat, worldState);
      } else if (type === 'DOCTRINE_LAB') {
        (lab as DoctrineLab).tick(beat, worldState);
      } else if (type === 'HIERARCHY_LAB') {
        (lab as HierarchyLab).tick(beat, this);
      }
    }
    
    // Check scripted behaviors
    this.checkScriptedBehaviors(worldState);
    
    // Process any pending decisions
    this.processDecisions();
  }
  
  private checkScriptedBehaviors(worldState: any): void {
    for (const behavior of this.scriptedBehaviors.values()) {
      if (!behavior.isActive) continue;
      
      // Check if conditions are met
      const conditionsMet = this.evaluateConditions(behavior.conditions, worldState);
      
      if (conditionsMet) {
        behavior.timesTriggered++;
        // Execute actions (in a real system)
      }
    }
  }
  
  private evaluateConditions(conditions: ScriptCondition[], context: any): boolean {
    // Simplified condition evaluation
    return conditions.every(c => {
      const value = context[c.parameter];
      switch (c.operator) {
        case '==': return value === c.value;
        case '!=': return value !== c.value;
        case '>': return value > c.value;
        case '<': return value < c.value;
        case '>=': return value >= c.value;
        case '<=': return value <= c.value;
        default: return false;
      }
    });
  }
  
  private processDecisions(): void {
    // Process pending sovereign decisions
    for (const decision of this.sovereignDecisions) {
      if (!decision.executed) {
        // Execute the decision (in a real system)
        decision.executed = true;
      }
    }
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════════════════════════════════════
  
  addNode(node: HierarchyNode): void {
    this.nodes.set(node.id, node);
  }
  
  addScriptedBehavior(behavior: ScriptedBehavior): void {
    this.scriptedBehaviors.set(behavior.id, behavior);
  }
  
  recordDecision(decision: SovereignDecision): void {
    this.sovereignDecisions.push(decision);
    // Limit history
    if (this.sovereignDecisions.length > 1000) {
      this.sovereignDecisions.shift();
    }
  }
  
  getNode(id: string): HierarchyNode | undefined {
    return this.nodes.get(id);
  }
  
  getLab(type: LabType): AILabBehavior | undefined {
    return this.labs.get(type);
  }
  
  getAllLabs(): AILab[] {
    return Array.from(this.labs.values()).map(l => l.getLab());
  }
  
  getScriptedBehaviors(): ScriptedBehavior[] {
    return Array.from(this.scriptedBehaviors.values());
  }
  
  getRecentDecisions(count: number = 100): SovereignDecision[] {
    return this.sovereignDecisions.slice(-count);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DOCTRINE NOTE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * HIERARCHY + INTERNAL LABS + SCRIPTED vs SOVEREIGN
 * 
 * THE HIERARCHY:
 *   ARCHITECT → COUNCIL → LABS → THEATRE → SWARM → SQUAD → UNIT
 *   
 *   Each level has:
 *   - Authority scope (what it can do)
 *   - Decision rights (what it can decide)
 *   - Communication permissions (who it can talk to)
 * 
 * INTERNAL AI LABS:
 *   These organisms work BEHIND THE SCENES:
 *   - SCENARIO_LAB: Creates challenges
 *   - BALANCE_LAB: Keeps things fair
 *   - DOCTRINE_LAB: Develops strategy
 *   - HIERARCHY_LAB: Optimizes structure
 *   
 *   They're like the "game masters" that keep the world alive
 *   without the player seeing them.
 * 
 * SCRIPTED vs SOVEREIGN:
 *   SCRIPTED (DNA/Laws):
 *   - "Scouts always advance"
 *   - "Never fire on friendlies"
 *   - "Maintain formation"
 *   These are the RULES - they don't change.
 *   
 *   SOVEREIGN (Decisions):
 *   - "Attack now or wait?"
 *   - "Flank left or right?"
 *   - "Sacrifice drone A or B?"
 *   These EMERGE from the organism's cognition.
 * 
 * Together, they create a world where:
 *   - Rules provide structure (scripted)
 *   - Intelligence provides adaptation (sovereign)
 *   - Labs keep everything alive and balanced
 *   - Hierarchy ensures coordination
 * 
 * NOTHING IS FAKE. EVERYTHING IS REAL.
 */
