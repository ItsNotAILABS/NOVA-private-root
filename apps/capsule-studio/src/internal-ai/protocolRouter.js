import { getOrganism, listOrganisms } from './organisms.js';
import { listGates } from './gates.js';
import { cyberGateReceipt, classifyCyberIntent } from './cyberSecurityGates.js';
import { buildAllowReceipt, buildDenialReceipt } from './receipts.js';

export const PROTOCOL_ROUTER_VERSION = 'nova-cain-protocol-router/1.0.0';

export function classifyIntent(text = '') {
  const input = String(text).toLowerCase();
  if (input.includes('deploy')) return 'deploy';
  if (input.includes('cyber') || input.includes('security') || input.includes('threat') || input.includes('incident')) return 'cyber_review';
  if (input.includes('gate') || input.includes('protocol')) return 'protocol_review';
  if (input.includes('build') || input.includes('create')) return 'build';
  if (input.includes('explain') || input.includes('summarize')) return 'explain';
  return 'review';
}

export function routeInternalRequest({ organismId = 'NOVA', intentText = '', lane = 'private-operator' } = {}) {
  const organism = getOrganism(organismId);
  const intent = classifyIntent(intentText);
  const cyberDecision = classifyCyberIntent(intentText);
  const cyberReceipt = cyberGateReceipt(intentText);

  if (!cyberDecision.allowed) {
    return {
      ok: false,
      version: PROTOCOL_ROUTER_VERSION,
      route: 'deny_with_safe_alternatives',
      organism,
      intent,
      lane,
      cyber: cyberDecision,
      cyberReceipt,
      receipt: buildDenialReceipt({
        organism: organism.id,
        intent,
        reason: 'Cyber-tech gate denied unsafe offensive detail.',
        safeAlternatives: cyberReceipt.safeAlternatives
      })
    };
  }

  const route = organism.id === 'CAIN' ? 'defensive_challenge_review' : intent === 'cyber_review' ? 'defensive_cyber_build_or_analysis' : 'internal_runtime_route';
  return {
    ok: true,
    version: PROTOCOL_ROUTER_VERSION,
    route,
    organism,
    intent,
    lane,
    cyber: cyberDecision,
    cyberReceipt,
    receipt: buildAllowReceipt({
      organism: organism.id,
      intent,
      route,
      payload: { lane, cyberSeverity: cyberDecision.severity }
    })
  };
}

export function internalAiStatus() {
  return {
    version: PROTOCOL_ROUTER_VERSION,
    organisms: listOrganisms(),
    gates: listGates(),
    cyberBoundary: 'Defensive controls, governance, detection, incident response, tabletop simulations, and secure design only.'
  };
}
