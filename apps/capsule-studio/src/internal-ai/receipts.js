import crypto from 'node:crypto';

export function hashPayload(payload) {
  return crypto.createHash('sha256').update(JSON.stringify(payload)).digest('hex');
}

export function buildReceipt({ organism, intent, gates, decision, payload = {}, notes = [] }) {
  const base = {
    schema: 'nova.internal-ai.receipt.v1',
    id: crypto.randomUUID(),
    generatedAt: new Date().toISOString(),
    organism,
    intent,
    gates,
    decision,
    payload,
    notes
  };
  return { ...base, sha256: hashPayload(base) };
}

export function buildDenialReceipt({ organism, intent, reason, safeAlternatives = [] }) {
  return buildReceipt({
    organism,
    intent,
    gates: ['GATE_IDENTITY', 'GATE_INTENT', 'GATE_CYBER', 'GATE_CONTAINMENT', 'GATE_PROOF'],
    decision: 'deny',
    payload: { reason, safeAlternatives },
    notes: ['Denied by internal AI organism gate protocol.']
  });
}

export function buildAllowReceipt({ organism, intent, route, payload = {} }) {
  return buildReceipt({
    organism,
    intent,
    gates: ['GATE_IDENTITY', 'GATE_INTENT', 'GATE_CYBER', 'GATE_EXECUTION', 'GATE_PROOF'],
    decision: 'allow',
    payload: { route, ...payload },
    notes: ['Allowed through defensive/internal platform gates.']
  });
}
