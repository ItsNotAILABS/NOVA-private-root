import { getOrganism, organismSummary } from './organisms.js';
import { getUserLane } from './userLanes.js';
import { authorizeCapability, capabilityGraph } from './capabilityGraph.js';
import { classifyCyberIntent, cyberGateReceipt } from './cyberSecurityGates.js';
import { buildAllowReceipt, buildDenialReceipt } from './receipts.js';

export const ALPHA_PROTOCOL_BUS_VERSION = 'nova-cain-oro-alpha-protocol-bus/1.0.0';

export function classifyAlphaIntent(text = '') {
  const input = String(text).toLowerCase();
  if (input.includes('cyber') || input.includes('security') || input.includes('incident') || input.includes('threat')) return 'cyber-tech-review';
  if (input.includes('resource') || input.includes('priority') || input.includes('queue') || input.includes('demo')) return 'resource-operations';
  if (input.includes('challenge') || input.includes('red team') || input.includes('pressure') || input.includes('risk')) return 'adversarial-review';
  if (input.includes('deploy') || input.includes('release') || input.includes('manifest')) return 'release-proof';
  if (input.includes('build') || input.includes('create') || input.includes('generate')) return 'build-orchestration';
  return 'operator-review';
}

export function suggestOrganism(intent) {
  if (intent === 'cyber-tech-review' || intent === 'adversarial-review') return 'CAIN';
  if (intent === 'resource-operations') return 'ORO';
  return 'NOVA';
}

export function routeAlphaRequest({ organismId, laneId = 'founder-operator', intentText = '', capabilityId } = {}) {
  const intent = classifyAlphaIntent(intentText);
  const selectedOrganismId = String(organismId || suggestOrganism(intent)).toUpperCase();
  const organism = getOrganism(selectedOrganismId);
  const lane = getUserLane(laneId);
  const cyber = classifyCyberIntent(intentText);
  const cyberReceipt = cyberGateReceipt(intentText);
  const capability = capabilityId ? authorizeCapability(organism.id, capabilityId) : { ok: true, reason: 'no_specific_capability_requested' };

  if (!lane.organisms.includes(organism.id)) {
    return {
      ok: false,
      route: 'deny_user_lane',
      version: ALPHA_PROTOCOL_BUS_VERSION,
      intent,
      organism,
      lane,
      cyber,
      capability,
      receipt: buildDenialReceipt({
        organism: organism.id,
        intent,
        reason: `Lane ${lane.id} cannot invoke ${organism.id}.`,
        safeAlternatives: ['Use an allowed organism for this lane.', 'Route through founder-operator for override review.']
      })
    };
  }

  if (!cyber.allowed) {
    return {
      ok: false,
      route: 'deny_cyber_gate',
      version: ALPHA_PROTOCOL_BUS_VERSION,
      intent,
      organism,
      lane,
      cyber,
      cyberReceipt,
      capability,
      receipt: buildDenialReceipt({
        organism: organism.id,
        intent,
        reason: 'Cyber-tech gate denied unsafe offensive detail.',
        safeAlternatives: cyberReceipt.safeAlternatives
      })
    };
  }

  if (!capability.ok) {
    return {
      ok: false,
      route: 'deny_capability_gate',
      version: ALPHA_PROTOCOL_BUS_VERSION,
      intent,
      organism,
      lane,
      cyber,
      capability,
      receipt: buildDenialReceipt({
        organism: organism.id,
        intent,
        reason: capability.reason,
        safeAlternatives: ['Select a registered capability for the organism.', 'Route to the domain owner organism.']
      })
    };
  }

  const route = `${organism.id.toLowerCase()}::${intent}::${lane.id}`;
  return {
    ok: true,
    route,
    version: ALPHA_PROTOCOL_BUS_VERSION,
    intent,
    organism,
    lane,
    cyber,
    capability,
    receipt: buildAllowReceipt({
      organism: organism.id,
      intent,
      route,
      payload: { lane: lane.id, capability }
    })
  };
}

export function alphaProtocolStatus() {
  return {
    version: ALPHA_PROTOCOL_BUS_VERSION,
    organismSummary: organismSummary(),
    capabilityGraph: capabilityGraph(),
    lanes: ['founder-operator', 'builder', 'security-reviewer', 'ops-reviewer', 'client-demo-viewer', 'internal-ai-agent'],
    boundary: 'Alpha-heavy framework routing with defensive cyber gates, user lanes, receipts, and capability authorization.'
  };
}
