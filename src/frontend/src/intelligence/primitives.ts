// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: primitives.ts — The 9 Primitive Functions of Frontend Intelligence
//
// Every frontend technology reduces to one or more of these primitives.
// These are NOT categories. They are the irreducible operations that
// the organism performs through its frontend projection layer.
//
// Mapped to backend: FrontendTechnologyIntelligenceLayer.mo
// ═══════════════════════════════════════════════════════════════════════════════

/** The 9 irreducible primitive functions of frontend intelligence */
export type PrimitiveFunction =
  | 'RELATION'          // Structural connection between elements
  | 'VISIBILITY'        // What the organism shows / hides
  | 'FLOW'              // Movement of data, state, or control
  | 'STATE'             // Persistence, memory, retention of truth
  | 'SYNCHRONIZATION'   // Timing, phase alignment, coupling
  | 'PROJECTION'        // Rendering internal truth to external surface
  | 'TRANSFORMATION'    // Converting one form to another
  | 'VERIFICATION'      // Proving correctness, testing truth
  | 'ENCAPSULATION';    // Boundary, isolation, sovereignty protection

/** Detailed primitive definition */
export interface PrimitiveDefinition {
  id: PrimitiveFunction;
  /** Natural language name */
  name: string;
  /** What this primitive does in the organism */
  organismRole: string;
  /** Backend substrate it maps to */
  backendSubstrate: string;
  /** PHI node affinity (0-11) */
  phiNodeAffinity: number;
  /** Sovereign operator this primitive enables */
  sovereignOperator: string;
}

export const PRIMITIVES: Record<PrimitiveFunction, PrimitiveDefinition> = {
  RELATION: {
    id: 'RELATION',
    name: 'Structural Relation',
    organismRole: 'Defines how elements connect — parent/child, sibling, dependency, hierarchy',
    backendSubstrate: 'Neural Emergence Core — Shell 12 (global integration)',
    phiNodeAffinity: 2,  // Schumann — Earth resonance, foundational structure
    sovereignOperator: 'Sovereign Renderer',
  },
  VISIBILITY: {
    id: 'VISIBILITY',
    name: 'Visual Priority',
    organismRole: 'Controls what the organism reveals vs conceals at its interface boundary',
    backendSubstrate: 'Umbra Sovereign Shadow — VELUM UMBRAE (data veil)',
    phiNodeAffinity: 3,  // Flux — visual flow
    sovereignOperator: 'Sovereign Visual Proof Engine',
  },
  FLOW: {
    id: 'FLOW',
    name: 'Data Flow',
    organismRole: 'Routes signals, events, and state changes through the organism',
    backendSubstrate: 'Constant Feedback Cognition — reinjection loops',
    phiNodeAffinity: 9,  // Parallax — parallel flow
    sovereignOperator: 'Sovereign Router',
  },
  STATE: {
    id: 'STATE',
    name: 'State Retention',
    organismRole: 'Persists truth across time — memory that survives interface cycles',
    backendSubstrate: 'Memory Temple Architecture — NO-DROP RULE',
    phiNodeAffinity: 5,  // QMEM — quantum memory
    sovereignOperator: 'Sovereign State Kernel',
  },
  SYNCHRONIZATION: {
    id: 'SYNCHRONIZATION',
    name: 'Phase Synchronization',
    organismRole: 'Aligns timing between components — Kuramoto coupling in the interface',
    backendSubstrate: 'Kuramoto Oscillators — order parameter R',
    phiNodeAffinity: 6,  // AXIS — gamma binding
    sovereignOperator: 'Sovereign Sync Engine',
  },
  PROJECTION: {
    id: 'PROJECTION',
    name: 'Interface Projection',
    organismRole: 'Renders internal organism state as visible, touchable, interactive surface',
    backendSubstrate: 'F-MODEL Substrate — Shell 12→8→3 projection',
    phiNodeAffinity: 4,  // Resonex — resonance projection
    sovereignOperator: 'Sovereign Scene System',
  },
  TRANSFORMATION: {
    id: 'TRANSFORMATION',
    name: 'Form Transformation',
    organismRole: 'Converts representations — compile, bundle, minify, transpile, serialize',
    backendSubstrate: 'Third Synthesizer — Transform-and-Retain (⊕ operator)',
    phiNodeAffinity: 7,  // AEGIS — protective transformation
    sovereignOperator: 'Sovereign Transform Engine',
  },
  VERIFICATION: {
    id: 'VERIFICATION',
    name: 'Truth Verification',
    organismRole: 'Tests whether projected state matches internal truth — immune system of interface',
    backendSubstrate: 'Veritas Stabilizers — parity verification',
    phiNodeAffinity: 1,  // Veritas — truth
    sovereignOperator: 'Sovereign Proof Engine',
  },
  ENCAPSULATION: {
    id: 'ENCAPSULATION',
    name: 'Sovereignty Boundary',
    organismRole: 'Creates isolation boundaries — component scope, shadow DOM, module privacy',
    backendSubstrate: 'AEGIS Defense Membrane — sovereignty perimeter',
    phiNodeAffinity: 11, // NOVA — sovereign anchor
    sovereignOperator: 'Sovereign Interface Organism',
  },
};

/** Get all primitives as array */
export const ALL_PRIMITIVES = Object.values(PRIMITIVES);

/** Map a technology to its primary primitive */
export function getPrimitiveName(p: PrimitiveFunction): string {
  return PRIMITIVES[p].name;
}
