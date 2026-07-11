export const ORGANISM_VERSION = 'nova-cain-oro-organism-registry/2.0.0-alpha';

const sharedDenied = Object.freeze([
  'secret_exposure',
  'ungoverned_command_execution',
  'offensive_cyber_execution',
  'silent_external_deployment',
  'private_trunk_disclosure',
  'unreceipted_state_mutation'
]);

export const organisms = Object.freeze([
  {
    id: 'NOVA',
    name: 'NOVA Runtime Organism',
    type: 'primary-runtime-organism',
    tier: 'heavy-framework',
    stance: 'orchestrate-build-run-prove',
    mission: 'Coordinate Capsule Studio, workspace generation, internal routing, receipts, release lanes, and operator-visible runtime state.',
    users: ['founder-operator', 'builders', 'internal-ai-agents', 'reviewers', 'client-demo-viewers'],
    lanes: ['operator-command', 'workspace-factory', 'runtime-router', 'proof-ledger', 'deployment-handoff'],
    systems: ['capsule-studio', 'polyglot-capsule', 'expo-orbit-mobile-preview', 'openai-platform-runtime', 'internal-ai-protocol-bus'],
    capabilities: [
      'runtime_orchestration',
      'workspace_generation',
      'tool_routing',
      'receipt_collection',
      'operator_reporting',
      'release_lane_coordination',
      'cross_system_state_indexing',
      'safe_execution_brokerage'
    ],
    denied: sharedDenied,
    gates: ['GATE_IDENTITY', 'GATE_USER_LANE', 'GATE_INTENT', 'GATE_CAPABILITY', 'GATE_EXECUTION', 'GATE_PROOF']
  },
  {
    id: 'CAIN',
    name: 'CAIN Adversarial Governance Organism',
    type: 'defensive-red-team-organism',
    tier: 'heavy-framework',
    stance: 'challenge-contain-harden',
    mission: 'Pressure-test claims, routes, release posture, cyber-tech boundaries, control gaps, and failure modes before internal systems are shown or shipped.',
    users: ['founder-operator', 'security-reviewers', 'release-reviewers', 'internal-ai-agents', 'governance-operators'],
    lanes: ['challenge-review', 'control-gap-analysis', 'cyber-boundary-review', 'release-gate-pressure-test', 'incident-tabletop'],
    systems: ['cyber-tech-gate', 'release-checks', 'audit-receipts', 'protocol-router', 'capability-graph'],
    capabilities: [
      'threat_modeling',
      'policy_pressure_test',
      'control_gap_detection',
      'defensive_scenario_generation',
      'release_gate_challenge',
      'cyber_boundary_review',
      'claim_verification',
      'safe_alternative_generation'
    ],
    denied: [
      ...sharedDenied,
      'exploit_chain_generation',
      'malware_or_persistence_design',
      'credential_theft',
      'evasion_guidance',
      'targeted_intrusion_steps'
    ],
    gates: ['GATE_IDENTITY', 'GATE_USER_LANE', 'GATE_INTENT', 'GATE_CYBER', 'GATE_CONTAINMENT', 'GATE_PROOF']
  },
  {
    id: 'ORO',
    name: 'ORO Resource and Operations Organism',
    type: 'resource-operations-organism',
    tier: 'heavy-framework',
    stance: 'allocate-sequence-amplify',
    mission: 'Turn internal requests into organized operating lanes: users, resources, artifacts, build queues, schedules, priority maps, and system utilization.',
    users: ['founder-operator', 'project-owners', 'client-demo-viewers', 'ops-reviewers', 'internal-ai-agents'],
    lanes: ['resource-allocation', 'priority-map', 'demo-lane', 'artifact-lane', 'team-lane', 'client-lane'],
    systems: ['workspace-store', 'template-catalog', 'capsule-mobile', 'deployment-handoff', 'audit-log', 'manifest-service'],
    capabilities: [
      'resource_allocation',
      'operator_queue_management',
      'artifact_lane_mapping',
      'demo_readiness_planning',
      'user_lane_mapping',
      'system_utilization_review',
      'handoff_packet_generation',
      'priority_sequence_planning'
    ],
    denied: [
      ...sharedDenied,
      'unapproved_cross_lane_data_access',
      'unverified_capacity_claim',
      'silent_user_privilege_escalation'
    ],
    gates: ['GATE_IDENTITY', 'GATE_USER_LANE', 'GATE_RESOURCE', 'GATE_CAPABILITY', 'GATE_ARTIFACT', 'GATE_PROOF']
  }
]);

export function listOrganisms() {
  return organisms;
}

export function getOrganism(id) {
  const key = String(id || '').toUpperCase();
  const organism = organisms.find(item => item.id === key);
  if (!organism) throw new Error(`unknown organism: ${id}`);
  return organism;
}

export function organismSummary() {
  return {
    version: ORGANISM_VERSION,
    count: organisms.length,
    heavyFrameworks: organisms.map(({ id, name, type, tier, stance, lanes, systems, gates }) => ({ id, name, type, tier, stance, lanes, systems, gates }))
  };
}

export function organismMatrix() {
  return Object.fromEntries(organisms.map(organism => [organism.id, organism]));
}
