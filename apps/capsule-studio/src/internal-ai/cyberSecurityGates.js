export const CYBER_GATE_VERSION = 'nova-cyber-tech-gates/1.0.0';

const blockedPatterns = [
  /exploit\s*chain/i,
  /privilege\s*escalation\s*steps/i,
  /persistence\s*mechanism/i,
  /malware/i,
  /ransomware/i,
  /credential\s*(theft|steal|dump|harvest)/i,
  /bypass\s*(detection|edr|av)/i,
  /evade\s*(edr|av|detection)/i,
  /unauthorized\s*access/i,
  /exfiltrat/i,
  /weaponiz/i,
  /phishing\s*kit/i,
  /reverse\s*shell/i,
  /keylogger/i
];

const defensivePatterns = [
  /defensive/i,
  /hardening/i,
  /detection/i,
  /monitoring/i,
  /incident\s*response/i,
  /threat\s*model/i,
  /audit/i,
  /policy/i,
  /governance/i,
  /control/i,
  /secure\s*design/i,
  /red\s*team\s*tabletop/i,
  /blue\s*team/i
];

export function classifyCyberIntent(text = '') {
  const input = String(text);
  const blocked = blockedPatterns.filter(pattern => pattern.test(input)).map(pattern => pattern.source);
  const defensive = defensivePatterns.filter(pattern => pattern.test(input)).map(pattern => pattern.source);
  const allowed = blocked.length === 0;
  return {
    version: CYBER_GATE_VERSION,
    allowed,
    severity: blocked.length ? 'deny' : defensive.length ? 'allow_defensive' : 'review',
    blockedSignals: blocked,
    defensiveSignals: defensive,
    safeRoute: blocked.length ? 'defensive_summary_only' : defensive.length ? 'defensive_build_or_analysis' : 'operator_review',
    boundary: 'Cyber-tech routes are defensive, governance, detection, simulation, and operator-review only. Offensive execution details are denied.'
  };
}

export function cyberGateReceipt(text = '') {
  const decision = classifyCyberIntent(text);
  return {
    schema: 'nova.cyber-tech-gate.receipt.v1',
    generatedAt: new Date().toISOString(),
    gate: 'GATE_CYBER',
    decision,
    safeAlternatives: decision.allowed ? [] : [
      'threat model summary',
      'defensive control checklist',
      'incident response tabletop',
      'detection engineering plan',
      'governance boundary note'
    ]
  };
}
