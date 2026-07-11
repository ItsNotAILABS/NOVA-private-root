export const GATE_PROTOCOL_VERSION = 'nova-cain-oro-gates/2.0.0-alpha';

export const gates = Object.freeze([
  {
    id: 'GATE_IDENTITY',
    name: 'Identity Gate',
    plane: 'identity',
    purpose: 'Confirms organism, operator lane, namespace, and privilege class before routing.',
    requires: ['organism_id', 'operator_intent', 'lane', 'privilege_class'],
    denies: ['unknown_organism', 'anonymous_privileged_lane', 'unbound_namespace']
  },
  {
    id: 'GATE_USER_LANE',
    name: 'User Lane Gate',
    plane: 'users',
    purpose: 'Maps a request to a founder, builder, reviewer, demo, client, team, or internal-agent lane.',
    requires: ['lane_id', 'allowed_surfaces', 'data_boundary'],
    denies: ['cross_lane_data_leak', 'silent_user_privilege_escalation', 'unapproved_shared_namespace']
  },
  {
    id: 'GATE_INTENT',
    name: 'Intent Gate',
    plane: 'intent',
    purpose: 'Classifies whether a request is build, explain, evaluate, defend, deploy, allocate, demo, or deny.',
    requires: ['intent_text', 'classification', 'safe_action'],
    denies: ['ambiguous_privileged_action', 'unsafe_unbounded_action']
  },
  {
    id: 'GATE_CAPABILITY',
    name: 'Capability Gate',
    plane: 'capability',
    purpose: 'Verifies that the selected organism is allowed to perform the requested capability.',
    requires: ['organism_id', 'capability_id', 'capability_owner'],
    denies: ['capability_not_registered', 'organism_not_authorized', 'missing_owner']
  },
  {
    id: 'GATE_RESOURCE',
    name: 'Resource Gate',
    plane: 'resource',
    purpose: 'Controls allocation of users, workspaces, artifacts, compute, demos, and release lanes.',
    requires: ['resource_type', 'quota_or_limit', 'owner_lane'],
    denies: ['unverified_capacity_claim', 'unbounded_resource_allocation', 'unknown_owner_lane']
  },
  {
    id: 'GATE_ARTIFACT',
    name: 'Artifact Gate',
    plane: 'artifact',
    purpose: 'Separates private, team, demo, client, and public artifact lanes.',
    requires: ['artifact_lane', 'visibility', 'manifest'],
    denies: ['private_to_public_leak', 'missing_manifest', 'unapproved_demo_export']
  },
  {
    id: 'GATE_CYBER',
    name: 'Cyber-Tech Gate',
    plane: 'cyber',
    purpose: 'Allows defensive cyber planning while denying exploit, malware, evasion, credential theft, and unauthorized access content.',
    requires: ['cyber_classification', 'defensive_purpose', 'safe_output_form'],
    denies: ['offensive_cyber', 'malware_generation', 'credential_theft', 'evasion_guidance', 'private_trunk_disclosure']
  },
  {
    id: 'GATE_EXECUTION',
    name: 'Execution Gate',
    plane: 'execution',
    purpose: 'Requires bounded commands, workspace-local paths, timeout, and receipt capture before execution.',
    requires: ['bounded_workspace', 'timeout', 'receipt_path', 'audit_event'],
    denies: ['root_escape', 'secret_read', 'unbounded_daemon', 'silent_network_bind']
  },
  {
    id: 'GATE_CONTAINMENT',
    name: 'Containment Gate',
    plane: 'containment',
    purpose: 'Routes risky outputs to safe summaries, controls, detections, or operator review.',
    requires: ['risk_reason', 'safe_alternative', 'containment_mode'],
    denies: ['actionable_harmful_detail', 'private_trunk_disclosure']
  },
  {
    id: 'GATE_PROOF',
    name: 'Proof Gate',
    plane: 'proof',
    purpose: 'Requires receipts, manifest hashes, route decisions, and audit events for material actions.',
    requires: ['receipt', 'audit_event', 'decision', 'sha256'],
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

export function gateSummary() {
  return {
    version: GATE_PROTOCOL_VERSION,
    count: gates.length,
    planes: [...new Set(gates.map(gate => gate.plane))],
    gates
  };
}
