import { listOrganisms } from './organisms.js';

export const CAPABILITY_GRAPH_VERSION = 'nova-cain-oro-capability-graph/1.0.0-alpha';

export const capabilityDomains = Object.freeze([
  {
    id: 'runtime',
    owner: 'NOVA',
    capabilities: ['runtime_orchestration', 'workspace_generation', 'tool_routing', 'receipt_collection', 'operator_reporting', 'safe_execution_brokerage']
  },
  {
    id: 'challenge',
    owner: 'CAIN',
    capabilities: ['threat_modeling', 'policy_pressure_test', 'control_gap_detection', 'release_gate_challenge', 'claim_verification']
  },
  {
    id: 'resource',
    owner: 'ORO',
    capabilities: ['resource_allocation', 'operator_queue_management', 'artifact_lane_mapping', 'demo_readiness_planning', 'priority_sequence_planning']
  },
  {
    id: 'cyber-tech',
    owner: 'CAIN',
    capabilities: ['defensive_architecture_review', 'incident_tabletop', 'detection_engineering_plan', 'governance_control_mapping']
  },
  {
    id: 'proof',
    owner: 'NOVA',
    capabilities: ['manifest_hashing', 'route_receipts', 'audit_trace', 'deployment_packet_review']
  },
  {
    id: 'demo',
    owner: 'ORO',
    capabilities: ['client_demo_lane', 'expo_mobile_preview', 'local_deploy_showcase', 'artifact_handoff']
  }
]);

export function listCapabilityDomains() {
  return capabilityDomains;
}

export function capabilityGraph() {
  const organisms = listOrganisms();
  return {
    version: CAPABILITY_GRAPH_VERSION,
    organismCount: organisms.length,
    domainCount: capabilityDomains.length,
    domains: capabilityDomains,
    organismCoverage: organisms.map(organism => ({
      id: organism.id,
      capabilities: organism.capabilities,
      domains: capabilityDomains.filter(domain => domain.owner === organism.id).map(domain => domain.id)
    }))
  };
}

export function authorizeCapability(organismId, capabilityId) {
  const organism = listOrganisms().find(item => item.id === String(organismId || '').toUpperCase());
  if (!organism) return { ok: false, reason: 'unknown_organism', organismId, capabilityId };
  const direct = organism.capabilities.includes(capabilityId);
  const domain = capabilityDomains.find(item => item.capabilities.includes(capabilityId));
  const ownerMatch = domain?.owner === organism.id;
  return {
    ok: Boolean(direct || ownerMatch),
    organismId: organism.id,
    capabilityId,
    owner: domain?.owner || organism.id,
    domain: domain?.id || null,
    reason: direct || ownerMatch ? 'authorized' : 'capability_not_registered_for_organism'
  };
}
