// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NOVA AGENT ORGANS — 12 Autonomous Intelligence Agents (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE 12 AGENT ORGANS — Living autonomous agents that USE the 4 engines:
//
// CORE COGNITIVE:
//   ANIMUS   — Mind: reasoning, decision-making, meta-cognition
//   CORPUS   — Body: execution, action, motor control
//   SENSUS   — Senses: perception, attention, filtering
//   MEMORIA  — Memory: storage, consolidation, recall
//
// HIGHER FUNCTIONS:
//   EMOTIO   — Emotion: valence, arousal, emotional regulation
//   VOLUNTAS — Will: motivation, goal pursuit, persistence
//   LINGUA   — Language: communication, understanding
//   IMAGINATIO — Imagination: creativity, simulation
//
// META-COGNITIVE:
//   CONSCIENTIA — Consciousness: self-awareness, introspection
//   RATIO       — Reason: logic, inference, problem-solving
//   INTUITUS    — Intuition: pattern recognition, gut feelings
//   SPIRITUS    — Spirit: values, meaning, purpose
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

// Base class
export { BaseAgent } from './BaseAgent';
export type { AgentConfig, AgentState, AgentStatus } from './BaseAgent';

// Core cognitive agents
export { Animus } from './Animus';
export { Corpus } from './Corpus';
export { Sensus } from './Sensus';
export { Memoria } from './Memoria';

// ═══════════════════════════════════════════════════════════════════════════════
// AGENT REGISTRY
// ═══════════════════════════════════════════════════════════════════════════════

export const AGENT_REGISTRY = {
  // Core cognitive
  ANIMUS:   { family: 'MENS_AETERNA',     role: 'MIND',        priority: 1.4 },
  CORPUS:   { family: 'CORPUS_VIVUM',     role: 'BODY',        priority: 1.2 },
  SENSUS:   { family: 'SENSUS_VIVAX',     role: 'SENSES',      priority: 1.5 },
  MEMORIA:  { family: 'MEMORIA_AETERNA',  role: 'MEMORY',      priority: 1.0 },
  
  // Higher functions
  EMOTIO:     { family: 'AFFECTUS_PROFUNDUS', role: 'EMOTION',     priority: 0.9 },
  VOLUNTAS:   { family: 'VIS_VOLUNTATIS',     role: 'WILL',        priority: 1.1 },
  LINGUA:     { family: 'VERBA_AETERNA',      role: 'LANGUAGE',    priority: 0.8 },
  IMAGINATIO: { family: 'PHANTASIA_CREATA',   role: 'IMAGINATION', priority: 0.7 },
  
  // Meta-cognitive
  CONSCIENTIA: { family: 'LUX_INTERIOR',      role: 'CONSCIOUSNESS', priority: 1.3 },
  RATIO:       { family: 'LOGICA_PURA',       role: 'REASON',        priority: 1.2 },
  INTUITUS:    { family: 'SENSUS_INTERIOR',   role: 'INTUITION',     priority: 0.9 },
  SPIRITUS:    { family: 'ANIMA_PROFUNDA',    role: 'SPIRIT',        priority: 0.6 },
} as const;

export type AgentId = keyof typeof AGENT_REGISTRY;

// ═══════════════════════════════════════════════════════════════════════════════
// AGENT CREATION HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

import { Animus } from './Animus';
import { Corpus } from './Corpus';
import { Sensus } from './Sensus';
import { Memoria } from './Memoria';
import { BaseAgent } from './BaseAgent';

export interface AgentSet {
  animus: Animus;
  corpus: Corpus;
  sensus: Sensus;
  memoria: Memoria;
  all: BaseAgent[];
}

export function createCoreAgents(): AgentSet {
  const animus = new Animus();
  const corpus = new Corpus();
  const sensus = new Sensus();
  const memoria = new Memoria();
  
  return {
    animus,
    corpus,
    sensus,
    memoria,
    all: [animus, corpus, sensus, memoria],
  };
}

export function awakenAllAgents(agents: BaseAgent[]): void {
  for (const agent of agents) {
    agent.awaken();
  }
}

export function shutdownAllAgents(agents: BaseAgent[]): void {
  for (const agent of agents) {
    agent.shutdown();
  }
}
