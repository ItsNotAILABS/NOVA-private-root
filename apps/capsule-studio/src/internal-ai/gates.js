export const GATE_PROTOCOL_VERSION = 'nova-cain-gates/1.0.0';

export const gates = Object.freeze([
  {
    id: 'GATE_IDENTITY',
    name: 'Identity Gate',
    plane: 'identity',
    purpose: 'Confirms which organism, operator lane, and namespace is being invoked.',
    requires: ['organism_id', 'operator_intent', 'lane'],
    denies: ['unknown_organism', 'anonymous_privileged_lane']
  },
  {
    id: 'GATE_INTENT',
    name: 'Intent Gate',
    plane: 'intent',
    purpose: 'Classifies whether a request is build, explain, evaluate, defend, deploy, or deny.',
    requires: ['intent_text', 'classification'],
    denies: ['ambiguous_privileged_action', 'unsafe_unbounded_action']
  },
  {
    id: 'GATE_CYBER',
    name: 'Cyber-Tech Gate',
    plane: 'cyber',
    purpose: 'Allows defensive cyber planning while denying exploit, malware, evasion, and unauthorized access content.',
    requires: ['cyber_classification', 'defensive_purpose'],
    denies: ['offensive_cyber', 'malware_generation', 'credential_theft', 'evasion_guidance']
  },
  {
    id: 'GATE_EXECUTION',
    name: 'Execution Gate',
    plane: 'execution',
    purpose: 'Requires bounded commands, workspace-local paths, timeout, and receipt capture before execution.',
    requires: ['bounded_workspace', 'timeout', 'receipt_path'],
    denies: ['root_escape', 'secret_read', 'unbounded_daemon', 'silent_network_bind']
  },
  {
    id: 'GATE_CONTAINMENT',
    name: 'Containment Gate',
    plane: 'containment',
    purpose: 'Routes risky outputs to safe summaries, controls, detections, or operator review.',
    requires: ['risk_reason', 'safe_alternative'],
    denies: ['actionable_harmful_detail', 'private_trunk_disclosure']
  },
  {
    id: 'GATE_PROOF',
    name: 'Proof Gate',
    plane: 'proof',
    purpose: 'Requires receipts, manifest hashes, route decisions, and audit events for material actions.',
    requires: ['receipt', 'audit_event', 'decision'],
    denies: ['unreceipted_claim', 'unverified_deployment_claim']
  }
]);

export function listGates() {
  return gates;
}

export function getGate(id) {
  const gate = gates.find(item => item.id === id);
  if (!gate) throw new Error(`unknown gate: ${id}`);
  return gate;
}

export function gateMap() {
  return Object.fromEntries(gates.map(gate => [gate.id, gate]));
}
