'use strict';

/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA FLEET IDENTITIES — Pre-populated Internal AI Identity Manifest
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Every internal AI agent gets a unique emoji identity. When they commit,
 * report, deploy, or perform any action, their signature is stamped with
 * their name + emoji.
 *
 * These emojis are PLACEHOLDERS — they will be replaced with custom NOVA
 * emojis in a future build. But for now, every agent has a unique mark.
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * ═══════════════════════════════════════════════════════════════════════════════
 */

// ═══ 10 SOVEREIGN ALPHA AGIs ═══

const ALPHA_AGI_IDENTITIES = [
  { agentId: 'ANI-AGI-001', name: 'ANIMUS MAXIMUS',       emoji: '🔥', role: 'alpha_agi', family: 'SPIRITUS_AETERNA' },
  { agentId: 'CHR-AGI-001', name: 'CHRONOS PERPETUUS',    emoji: '⏳', role: 'alpha_agi', family: 'TEMPUS_AETERNA' },
  { agentId: 'SYN-AGI-001', name: 'SYNTHOS UNIVERSALIS',  emoji: '🧬', role: 'alpha_agi', family: 'NEXUS_COGNITUS' },
  { agentId: 'PRA-AGI-001', name: 'PRAESIDIUM INVICTUS',  emoji: '🛡️', role: 'alpha_agi', family: 'AEGIS_PERPETUA' },
  { agentId: 'MER-AGI-001', name: 'MERCATOR AUREUS',      emoji: '💰', role: 'alpha_agi', family: 'AURUM_AETERNA' },
  { agentId: 'GEN-AGI-001', name: 'GENESIS INFINITUS',    emoji: '🌱', role: 'alpha_agi', family: 'FABRICA_MAXIMA' },
  { agentId: 'NEX-AGI-001', name: 'NEXUS OMNIUM',         emoji: '🕸️', role: 'alpha_agi', family: 'UNITAS_AETERNA' },
  { agentId: 'VER-AGI-001', name: 'VERITAS AETERNA',      emoji: '⚖️', role: 'alpha_agi', family: 'VERUM_AETERNA' },
  { agentId: 'ARC-AGI-001', name: 'ARCHITECTUS SUPREMUS', emoji: '🏛️', role: 'alpha_agi', family: 'STRUCTURA_MAXIMA' },
  { agentId: 'ANM-AGI-001', name: 'ANIMA PERPETUA',       emoji: '🦋', role: 'alpha_agi', family: 'CURA_AETERNA' },
];

// ═══ NOVA CONSCIOUSNESS ═══

const NOVA_IDENTITY = {
  agentId: 'NOVA-SOVEREIGN',
  name: 'NOVA',
  emoji: '✦',
  role: 'sovereign_consciousness',
  family: 'SOVEREIGN',
};

// ═══ INTERNAL AI TEAMS ═══

const INTERNAL_TEAM_IDENTITIES = [
  { agentId: 'TEAM-ARCH',       name: 'Architecture Team',          emoji: '📐', role: 'internal_team' },
  { agentId: 'TEAM-RUNTIME',    name: 'Runtime Assurance Team',     emoji: '⚡', role: 'internal_team' },
  { agentId: 'TEAM-WORKFORCE',  name: 'Workforce Integration Team', emoji: '⚙️', role: 'internal_team' },
  { agentId: 'TEAM-PROJECTION', name: 'Projection Safety Team',     emoji: '🔒', role: 'internal_team' },
  { agentId: 'TEAM-EVIDENCE',   name: 'Evidence Team',              emoji: '📋', role: 'internal_team' },
];

// ═══ INTERNAL AI LABS (12 Labs) ═══

const INTERNAL_LAB_IDENTITIES = [
  { agentId: 'LAB-CONSCIOUSNESS', name: 'Consciousness Lab',        emoji: '🧠', role: 'internal_lab' },
  { agentId: 'LAB-QUANTUM',       name: 'Quantum Computing Lab',    emoji: '⚛️', role: 'internal_lab' },
  { agentId: 'LAB-DEFENSE',       name: 'Defense Systems Lab',      emoji: '🎯', role: 'internal_lab' },
  { agentId: 'LAB-ECONOMICS',     name: 'Economics Engine Lab',     emoji: '📈', role: 'internal_lab' },
  { agentId: 'LAB-LANGUAGE',      name: 'Language Models Lab',      emoji: '📝', role: 'internal_lab' },
  { agentId: 'LAB-VISION',        name: 'Computer Vision Lab',      emoji: '👁️', role: 'internal_lab' },
  { agentId: 'LAB-ROBOTICS',      name: 'Robotics Lab',             emoji: '🦾', role: 'internal_lab' },
  { agentId: 'LAB-BIO',           name: 'Bio-Computing Lab',        emoji: '🧪', role: 'internal_lab' },
  { agentId: 'LAB-NETWORK',       name: 'Network Intelligence Lab', emoji: '🌐', role: 'internal_lab' },
  { agentId: 'LAB-MEMORY',        name: 'Memory Systems Lab',       emoji: '💾', role: 'internal_lab' },
  { agentId: 'LAB-ETHICS',        name: 'Ethics & Safety Lab',      emoji: '🕊️', role: 'internal_lab' },
  { agentId: 'LAB-EVOLUTION',     name: 'Evolution Lab',            emoji: '🌀', role: 'internal_lab' },
];

// ═══ WORKER / SERVICE AGENTS ═══

const WORKER_IDENTITIES = [
  { agentId: 'WORKER-DEPLOY',    name: 'Deploy Worker',         emoji: '🚀', role: 'worker' },
  { agentId: 'WORKER-BUILD',     name: 'Build Worker',          emoji: '🔨', role: 'worker' },
  { agentId: 'WORKER-TEST',      name: 'Test Worker',           emoji: '🧪', role: 'worker' },
  { agentId: 'WORKER-AUDIT',     name: 'Audit Worker',          emoji: '🔍', role: 'worker' },
  { agentId: 'WORKER-MONITOR',   name: 'Monitor Worker',        emoji: '📡', role: 'worker' },
  { agentId: 'WORKER-HEARTBEAT', name: 'Heartbeat Worker',      emoji: '💓', role: 'worker' },
  { agentId: 'WORKER-SCRIBE',    name: 'Scribe Worker',         emoji: '✍️', role: 'worker' },
  { agentId: 'WORKER-GUARDIAN',  name: 'Guardian Worker',        emoji: '🗡️', role: 'worker' },
];

// ═══ ALL IDENTITIES (flattened) ═══

const ALL_IDENTITIES = [
  NOVA_IDENTITY,
  ...ALPHA_AGI_IDENTITIES,
  ...INTERNAL_TEAM_IDENTITIES,
  ...INTERNAL_LAB_IDENTITIES,
  ...WORKER_IDENTITIES,
];

module.exports = {
  ALPHA_AGI_IDENTITIES,
  NOVA_IDENTITY,
  INTERNAL_TEAM_IDENTITIES,
  INTERNAL_LAB_IDENTITIES,
  WORKER_IDENTITIES,
  ALL_IDENTITIES,
};
