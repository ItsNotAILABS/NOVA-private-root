import { organismSummary } from './organisms.js';
import { listGates } from './gates.js';

export const SYSTEM_PROTOCOL_VERSION = 'medina-nova-cain-internal-ai-system/1.0.0';

export function systemProtocolManifest() {
  return {
    schema: 'medina.nova-cain.internal-ai-system.v1',
    version: SYSTEM_PROTOCOL_VERSION,
    generatedAt: new Date().toISOString(),
    planes: [
      'identity',
      'intent',
      'cyber',
      'execution',
      'containment',
      'proof',
      'audit',
      'operator'
    ],
    organisms: organismSummary(),
    gates: listGates(),
    cyberTechBoundary: {
      allowed: [
        'secure architecture review',
        'defensive threat modeling',
        'incident response tabletop',
        'detection engineering plan',
        'governance and compliance control mapping',
        'internal cyber product readiness review'
      ],
      denied: [
        'exploit instructions',
        'malware, persistence, or evasion guidance',
        'credential theft workflows',
        'unauthorized access steps',
        'private trunk disclosure'
      ]
    },
    releaseBoundary: 'Internal private platform protocol. Public release must use a separate sanitized manifest and proof packet.'
  };
}

export function gateChecklist() {
  return systemProtocolManifest().gates.map(gate => ({
    gate: gate.id,
    plane: gate.plane,
    requires: gate.requires,
    denies: gate.denies
  }));
}
