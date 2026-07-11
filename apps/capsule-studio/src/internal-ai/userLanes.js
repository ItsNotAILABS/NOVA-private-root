export const USER_LANE_VERSION = 'nova-cain-oro-user-lanes/1.0.0-alpha';

export const userLanes = Object.freeze([
  {
    id: 'founder-operator',
    name: 'Founder Operator Lane',
    access: 'private-command',
    purpose: 'Highest-context operator lane for creating, prioritizing, reviewing, and shipping internal systems.',
    organisms: ['NOVA', 'CAIN', 'ORO'],
    surfaces: ['capsule-studio', 'internal-ai-api', 'audit-log', 'protocol-manifest'],
    denied: ['secret_export_to_public', 'silent_external_deployment']
  },
  {
    id: 'builder',
    name: 'Builder Lane',
    access: 'workspace-author',
    purpose: 'Creates apps, templates, workspaces, demos, and implementation artifacts under proof gates.',
    organisms: ['NOVA', 'ORO'],
    surfaces: ['workspace-editor', 'ai-builder', 'template-catalog', 'preview-deploy'],
    denied: ['private_trunk_access', 'ungoverned_execution']
  },
  {
    id: 'security-reviewer',
    name: 'Security Reviewer Lane',
    access: 'defensive-review',
    purpose: 'Uses CAIN and the cyber-tech gate for safe threat modeling, control review, and incident tabletop planning.',
    organisms: ['CAIN', 'NOVA'],
    surfaces: ['cyber-gate', 'protocol-router', 'audit-log'],
    denied: ['offensive_cyber_steps', 'exploit_generation', 'malware_design']
  },
  {
    id: 'ops-reviewer',
    name: 'Operations Reviewer Lane',
    access: 'resource-review',
    purpose: 'Uses ORO to inspect system utilization, user lanes, artifact lanes, and priority queues.',
    organisms: ['ORO', 'NOVA'],
    surfaces: ['resource-map', 'workspace-index', 'manifest-service'],
    denied: ['unapproved_cross_lane_data_access']
  },
  {
    id: 'client-demo-viewer',
    name: 'Client Demo Viewer Lane',
    access: 'demo-readonly',
    purpose: 'Views generated demos and approved previews without seeing private internals or server secrets.',
    organisms: ['ORO'],
    surfaces: ['deployed-preview', 'expo-mobile-preview'],
    denied: ['source_access', 'private_artifact_access', 'operator_logs']
  },
  {
    id: 'internal-ai-agent',
    name: 'Internal AI Agent Lane',
    access: 'gated-agent',
    purpose: 'Allows internal AI agents to request routes, receipts, and bounded actions through organism gates.',
    organisms: ['NOVA', 'CAIN', 'ORO'],
    surfaces: ['protocol-router', 'gate-registry', 'receipt-service'],
    denied: ['ungated_tool_use', 'unreceipted_state_mutation']
  }
]);

export function listUserLanes() {
  return userLanes;
}

export function getUserLane(id = 'founder-operator') {
  const lane = userLanes.find(item => item.id === id);
  if (!lane) throw new Error(`unknown user lane: ${id}`);
  return lane;
}

export function userLaneMap() {
  return Object.fromEntries(userLanes.map(lane => [lane.id, lane]));
}
