import { organismSummary } from './organisms.js';
import { gateSummary, listGates } from './gates.js';
import { listUserLanes } from './userLanes.js';
import { capabilityGraph } from './capabilityGraph.js';
import { alphaProtocolStatus } from './alphaProtocolBus.js';

export const SYSTEM_PROTOCOL_VERSION = 'medina-nova-cain-oro-internal-ai-system/2.0.0-alpha';

export function systemProtocolManifest() {
  return {
    schema: 'medina.nova-cain-oro.internal-ai-system.v2.alpha',
    version: SYSTEM_PROTOCOL_VERSION,
    generatedAt: new Date().toISOString(),
    stack: ['NOVA', 'CAIN', 'ORO'],
    planes: [
      'identity',
      'users',
      'intent',
      'capability',
      'resource',
      'artifact',
      'cyber',
      'execution',
      'containment',
      'proof',
      'audit',
      'operator'
    ],
    organisms: organismSummary(),
    gates: gateSummary(),
    userLanes: listUserLanes(),
    capabilityGraph: capabilityGraph(),
    alphaProtocol: alphaProtocolStatus(),
    cyberTechBoundary: {
      allowed: [
        'secure architecture review',
        'defensive threat modeling',
        'incident response tabletop',
        'detection engineering plan',
        'governance and compliance control mapping',
        'internal cyber product readiness review',
        'control gap analysis',
        'safe adversarial challenge review'
      ],
      denied: [
        'exploit instructions',
        'malware, persistence, or evasion guidance',
        'credential theft workflows',
        'unauthorized access steps',
        'private trunk disclosure',
        'operational bypass instructions'
      ]
    },
    releaseBoundary: 'Internal private alpha protocol. Public release must use a separate sanitized manifest and proof packet.'
  };
}

export function gateChecklist() {
  return listGates().map(gate => ({
    gate: gate.id,
    plane: gate.plane,
    requires: gate.requires,
    denies: gate.denies
  }));
}
