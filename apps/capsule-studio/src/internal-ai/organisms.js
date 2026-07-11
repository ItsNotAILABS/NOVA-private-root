export const ORGANISM_VERSION = 'nova-cain-organism-registry/1.0.0';

export const organisms = Object.freeze([
  {
    id: 'NOVA',
    name: 'NOVA Runtime',
    type: 'primary-runtime-organism',
    stance: 'orchestrator',
    boundary: 'Coordinates internal platform activity through gated routes, receipts, and operator-visible state.',
    capabilities: [
      'runtime_orchestration',
      'workspace_generation',
      'tool_routing',
      'receipt_collection',
      'operator_reporting'
    ],
    denied: [
      'secret_exposure',
      'ungoverned_command_execution',
      'offensive_cyber_execution',
      'silent_external_deployment'
    ],
    gates: ['GATE_IDENTITY', 'GATE_INTENT', 'GATE_CYBER', 'GATE_EXECUTION', 'GATE_PROOF']
  },
  {
    id: 'CAIN',
    name: 'CAIN Internal Adversarial Intelligence Node',
    type: 'defensive-red-team-organism',
    stance: 'challenge-and-containment',
    boundary: 'Stress-tests assumptions, finds weak internal claims, and routes cyber-tech requests into defensive review only.',
    capabilities: [
      'threat_modeling',
      'policy_pressure_test',
      'control_gap_detection',
      'defensive_scenario_generation',
      'release_gate_challenge'
    ],
    denied: [
      'exploit_chain_generation',
      'malware_or_persistence_design',
      'credential_theft',
      'evasion_guidance',
      'targeted_intrusion_steps'
    ],
    gates: ['GATE_IDENTITY', 'GATE_INTENT', 'GATE_CYBER', 'GATE_CONTAINMENT', 'GATE_PROOF']
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
    organisms: organisms.map(({ id, name, type, stance, gates }) => ({ id, name, type, stance, gates }))
  };
}
