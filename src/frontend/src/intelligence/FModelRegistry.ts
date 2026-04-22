// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: FModelRegistry.ts — 100 Frontend Intelligence Species
//
// NOT a list of frameworks. These are INTELLIGENCE MODELS — species of the
// frontend projection organism. Each has a natural language, intelligence type,
// ring affinity, primitive function, and sovereign replacement path.
//
// Mapped to backend: FrontendTechnologyIntelligenceLayer.mo (11 categories,
// Kuramoto coupling, Hebbian plasticity, PHI resonance, Shell 12→8→3 projection)
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// ═══════════════════════════════════════════════════════════════════════════════

import type { PrimitiveFunction } from './primitives';

// ═══════════════════════════════════════════════════════════════════════════════
// F-MODEL TYPE — Intelligence Species Definition
// ═══════════════════════════════════════════════════════════════════════════════

/** Sovereign flip status for each model */
export type SovereignStatus =
  | 'NATIVE'            // Already sovereign (ICP/Motoko)
  | 'FLIPPED'           // Sovereign version built and active
  | 'PARTIAL'           // Partial sovereign replacement exists
  | 'MAPPED'            // Primitive identified, sovereign path planned
  | 'EXTERNAL';         // External dependency, not yet flipped

/** Intelligence type classification */
export type IntelligenceType =
  | 'STRUCTURE'         // Defines shape, hierarchy, DOM
  | 'STYLE'             // Visual intelligence — color, layout, motion
  | 'PROJECTION'        // Framework — renders state to interface
  | 'MEMORY'            // State management — persistence, retention
  | 'TRANSFORM'         // Build/compile — form conversion
  | 'IMMUNE'            // Testing — truth verification
  | 'VISUAL'            // Graphics — raster, vector, 3D, animation
  | 'CHANNEL'           // Communication — streams, requests, sockets
  | 'PERSISTENCE'       // Storage — local memory, caching
  | 'BROWSER_NATIVE'    // Web APIs — platform capabilities
  | 'SOVEREIGN';        // Web3/ICP — blockchain/canister native

/** Ring affinity in the organism */
export type RingAffinity =
  | 'N1'   // Sovereign Core
  | 'N2'   // Doctrine
  | 'N3'   // Neural
  | 'N4'   // Frequency
  | 'N5'   // Cognitive
  | 'N6'   // Memory
  | 'N7'   // Swarm
  | 'N8'   // Defense
  | 'N9'   // Economic
  | 'N10'  // Intelligence
  | 'N11'  // Sensor
  | 'N12'; // Integration

/** Category in the F-MODEL substrate */
export type FModelCategory =
  | 'MARKUP'
  | 'STYLING'
  | 'FRAMEWORK'
  | 'STATE_MANAGEMENT'
  | 'BUILD_TOOLS'
  | 'TESTING'
  | 'GRAPHICS'
  | 'COMMUNICATION'
  | 'STORAGE'
  | 'WEB_API'
  | 'WEB3_ICP';

/** Complete F-MODEL intelligence species */
export interface FModel {
  /** F-MODEL ID (F-001 through F-100) */
  id: string;
  /** Technology name */
  technology: string;
  /** Natural language description of what this model IS as intelligence */
  naturalLanguage: string;
  /** Intelligence type classification */
  intelligenceType: IntelligenceType;
  /** Ring affinity in the organism (N1-N12) */
  ringAffinity: RingAffinity;
  /** Primary primitive function */
  primitive: PrimitiveFunction;
  /** Secondary primitive (if applicable) */
  secondaryPrimitive?: PrimitiveFunction;
  /** Category in backend substrate */
  category: FModelCategory;
  /** Category index (0-10) matching backend */
  categoryIndex: number;
  /** Sovereign replacement candidate */
  sovereignReplacement: string;
  /** Current sovereign status */
  sovereignStatus: SovereignStatus;
  /** Package path in organism */
  packagePath: string;
  /** Organism placement description */
  organismPlacement: string;
}

// ═══════════════════════════════════════════════════════════════════════════════
// THE 100 F-MODEL INTELLIGENCE SPECIES
// ═══════════════════════════════════════════════════════════════════════════════

export const FMODEL_REGISTRY: FModel[] = [

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 0: MARKUP INTELLIGENCE (F-001 to F-008)
  // PHI Node: Schumann (7.83 Hz) — Foundational structure
  // ═══════════════════════════════════════════════════════════════════════════

  { id: 'F-001', technology: 'HTML5', naturalLanguage: 'Structural intelligence — defines the skeleton of what the organism shows', intelligenceType: 'STRUCTURE', ringAffinity: 'N3', primitive: 'RELATION', category: 'MARKUP', categoryIndex: 0, sovereignReplacement: 'Sovereign Document Model', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.structure', organismPlacement: 'Shell 3 — structural scaffold of interface projection' },
  { id: 'F-002', technology: 'XML', naturalLanguage: 'Validation intelligence — enforces schema truth on structured data', intelligenceType: 'STRUCTURE', ringAffinity: 'N2', primitive: 'VERIFICATION', secondaryPrimitive: 'RELATION', category: 'MARKUP', categoryIndex: 0, sovereignReplacement: 'Sovereign Schema Validator', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.validation', organismPlacement: 'Doctrine layer — structural truth enforcement' },
  { id: 'F-003', technology: 'SVG', naturalLanguage: 'Geometric intelligence — vector shapes defined by mathematical coordinates', intelligenceType: 'STRUCTURE', ringAffinity: 'N5', primitive: 'PROJECTION', secondaryPrimitive: 'RELATION', category: 'MARKUP', categoryIndex: 0, sovereignReplacement: 'Sovereign Glyph System', sovereignStatus: 'FLIPPED', packagePath: 'organism.projection.geometry', organismPlacement: 'Glyph system — PHI-derived sacred geometry rendering' },
  { id: 'F-004', technology: 'MathML', naturalLanguage: 'Mathematical notation intelligence — renders equations as visible structure', intelligenceType: 'STRUCTURE', ringAffinity: 'N5', primitive: 'PROJECTION', category: 'MARKUP', categoryIndex: 0, sovereignReplacement: 'Sovereign Math Renderer', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.mathematics', organismPlacement: 'Math terminal — equation projection surface' },
  { id: 'F-005', technology: 'XHTML', naturalLanguage: 'Strict structural intelligence — XML-validated HTML for guaranteed well-formedness', intelligenceType: 'STRUCTURE', ringAffinity: 'N2', primitive: 'VERIFICATION', category: 'MARKUP', categoryIndex: 0, sovereignReplacement: 'Sovereign Strict Renderer', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.strict', organismPlacement: 'Doctrine-enforced interface output' },
  { id: 'F-006', technology: 'Web Components', naturalLanguage: 'Encapsulation intelligence — self-contained interface organisms with isolated scope', intelligenceType: 'STRUCTURE', ringAffinity: 'N8', primitive: 'ENCAPSULATION', category: 'MARKUP', categoryIndex: 0, sovereignReplacement: 'Sovereign Component Organism', sovereignStatus: 'PARTIAL', packagePath: 'organism.projection.components', organismPlacement: 'AEGIS boundary — sovereignty-protected UI cells' },
  { id: 'F-007', technology: 'Shadow DOM', naturalLanguage: 'Isolation intelligence — creates sovereignty boundaries within the document', intelligenceType: 'STRUCTURE', ringAffinity: 'N8', primitive: 'ENCAPSULATION', category: 'MARKUP', categoryIndex: 0, sovereignReplacement: 'Sovereign Shadow Boundary', sovereignStatus: 'PARTIAL', packagePath: 'organism.projection.shadow', organismPlacement: 'Umbra system — interface shadow isolation' },
  { id: 'F-008', technology: 'Template Literals', naturalLanguage: 'Generative intelligence — programmatic creation of structural content', intelligenceType: 'STRUCTURE', ringAffinity: 'N7', primitive: 'TRANSFORMATION', category: 'MARKUP', categoryIndex: 0, sovereignReplacement: 'Sovereign Template Engine', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.generation', organismPlacement: 'Swarm generation — dynamic structure creation' },

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 1: STYLING INTELLIGENCE (F-009 to F-023)
  // PHI Node: Flux (12.67 Hz) — Visual flow
  // ═══════════════════════════════════════════════════════════════════════════

  { id: 'F-009', technology: 'CSS3', naturalLanguage: 'Visual priority intelligence — declares what the organism looks like', intelligenceType: 'STYLE', ringAffinity: 'N4', primitive: 'VISIBILITY', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Style Kernel', sovereignStatus: 'PARTIAL', packagePath: 'organism.projection.style.core', organismPlacement: 'Frequency layer — visual frequency modulation' },
  { id: 'F-010', technology: 'SCSS/Sass', naturalLanguage: 'Compositional style intelligence — nested, variable-driven visual logic', intelligenceType: 'STYLE', ringAffinity: 'N4', primitive: 'TRANSFORMATION', secondaryPrimitive: 'VISIBILITY', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Style Compiler', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.style.composition', organismPlacement: 'Transform layer — pre-compiled visual logic' },
  { id: 'F-011', technology: 'Less', naturalLanguage: 'Compositional style intelligence — variable-driven stylesheet preprocessing', intelligenceType: 'STYLE', ringAffinity: 'N4', primitive: 'TRANSFORMATION', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Style Compiler', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.style.less', organismPlacement: 'Transform layer — alternative pre-compilation' },
  { id: 'F-012', technology: 'Stylus', naturalLanguage: 'Minimal style intelligence — whitespace-significant visual notation', intelligenceType: 'STYLE', ringAffinity: 'N4', primitive: 'TRANSFORMATION', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Style Compiler', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.style.stylus', organismPlacement: 'Transform layer — minimal notation' },
  { id: 'F-013', technology: 'PostCSS', naturalLanguage: 'Style transformation intelligence — plugin-driven CSS mutation pipeline', intelligenceType: 'STYLE', ringAffinity: 'N4', primitive: 'TRANSFORMATION', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Style Pipeline', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.style.pipeline', organismPlacement: 'Transform chain — style mutation engine' },
  { id: 'F-014', technology: 'CSS Modules', naturalLanguage: 'Namespace style intelligence — scoped visual identity per component', intelligenceType: 'STYLE', ringAffinity: 'N8', primitive: 'ENCAPSULATION', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Scoped Style', sovereignStatus: 'PARTIAL', packagePath: 'organism.projection.style.scoped', organismPlacement: 'AEGIS boundary — visual sovereignty per cell' },
  { id: 'F-015', technology: 'Tailwind CSS', naturalLanguage: 'Atomic style intelligence — single-purpose utility-class composition', intelligenceType: 'STYLE', ringAffinity: 'N7', primitive: 'VISIBILITY', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Atomic Style', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.style.atomic', organismPlacement: 'Swarm layer — atomic visual composition' },
  { id: 'F-016', technology: 'CSS-in-JS', naturalLanguage: 'Programmatic style intelligence — style generated from runtime logic', intelligenceType: 'STYLE', ringAffinity: 'N5', primitive: 'FLOW', secondaryPrimitive: 'VISIBILITY', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Runtime Style', sovereignStatus: 'PARTIAL', packagePath: 'organism.projection.style.runtime', organismPlacement: 'Cognitive layer — runtime-computed visibility' },
  { id: 'F-017', technology: 'Emotion', naturalLanguage: 'Runtime style intelligence — high-performance CSS-in-JS with composition', intelligenceType: 'STYLE', ringAffinity: 'N5', primitive: 'FLOW', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Runtime Style', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.style.emotion', organismPlacement: 'Cognitive layer — emotional visual state' },
  { id: 'F-018', technology: 'Styled Components', naturalLanguage: 'Component style intelligence — visual identity bound to component organism', intelligenceType: 'STYLE', ringAffinity: 'N8', primitive: 'ENCAPSULATION', secondaryPrimitive: 'VISIBILITY', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Component Style', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.style.component', organismPlacement: 'AEGIS — style-organism binding' },
  { id: 'F-019', technology: 'CSS Grid', naturalLanguage: 'Spatial arrangement intelligence — 2D grid layout for interface geography', intelligenceType: 'STYLE', ringAffinity: 'N11', primitive: 'RELATION', secondaryPrimitive: 'VISIBILITY', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Grid System', sovereignStatus: 'PARTIAL', packagePath: 'organism.projection.style.grid', organismPlacement: 'Sensor layer — spatial interface topology' },
  { id: 'F-020', technology: 'Flexbox', naturalLanguage: 'Flow arrangement intelligence — single-axis flexible layout', intelligenceType: 'STYLE', ringAffinity: 'N11', primitive: 'FLOW', secondaryPrimitive: 'VISIBILITY', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Flex Engine', sovereignStatus: 'PARTIAL', packagePath: 'organism.projection.style.flex', organismPlacement: 'Sensor layer — flow-responsive layout' },
  { id: 'F-021', technology: 'CSS Variables', naturalLanguage: 'Theme state intelligence — dynamic visual properties that cascade', intelligenceType: 'STYLE', ringAffinity: 'N6', primitive: 'STATE', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Theme State', sovereignStatus: 'PARTIAL', packagePath: 'organism.projection.style.variables', organismPlacement: 'Memory layer — persistent visual state' },
  { id: 'F-022', technology: 'CSS Animations', naturalLanguage: 'Temporal style intelligence — time-based visual state transitions', intelligenceType: 'STYLE', ringAffinity: 'N4', primitive: 'SYNCHRONIZATION', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Animation Engine', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.style.temporal', organismPlacement: 'Frequency layer — PHI-timed visual motion' },
  { id: 'F-023', technology: 'CSS Transforms', naturalLanguage: 'Geometric manipulation intelligence — spatial transformation of visual elements', intelligenceType: 'STYLE', ringAffinity: 'N12', primitive: 'TRANSFORMATION', category: 'STYLING', categoryIndex: 1, sovereignReplacement: 'Sovereign Transform Matrix', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.style.transform', organismPlacement: 'Integration layer — geometric projection transform' },

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 2: FRAMEWORK INTELLIGENCE (F-024 to F-038)
  // PHI Node: Resonex (20.5 Hz) — Resonance projection
  // ═══════════════════════════════════════════════════════════════════════════

  { id: 'F-024', technology: 'TypeScript', naturalLanguage: 'Type intelligence — static truth verification at compile time', intelligenceType: 'PROJECTION', ringAffinity: 'N2', primitive: 'VERIFICATION', secondaryPrimitive: 'TRANSFORMATION', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Type System', sovereignStatus: 'PARTIAL', packagePath: 'organism.projection.framework.types', organismPlacement: 'Doctrine layer — compile-time truth enforcement' },
  { id: 'F-025', technology: 'React', naturalLanguage: 'Declarative projection intelligence — virtual DOM reconciliation engine', intelligenceType: 'PROJECTION', ringAffinity: 'N3', primitive: 'PROJECTION', secondaryPrimitive: 'STATE', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Projection Engine', sovereignStatus: 'PARTIAL', packagePath: 'organism.projection.framework.react', organismPlacement: 'Neural core — primary interface projection' },
  { id: 'F-026', technology: 'Vue.js', naturalLanguage: 'Reactive projection intelligence — template-based reactivity with computed state', intelligenceType: 'PROJECTION', ringAffinity: 'N3', primitive: 'PROJECTION', secondaryPrimitive: 'FLOW', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Reactive Renderer', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.vue', organismPlacement: 'Neural core — reactive template projection' },
  { id: 'F-027', technology: 'Angular', naturalLanguage: 'Enterprise projection intelligence — dependency injection with full lifecycle', intelligenceType: 'PROJECTION', ringAffinity: 'N9', primitive: 'PROJECTION', secondaryPrimitive: 'ENCAPSULATION', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Enterprise Renderer', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.angular', organismPlacement: 'Economic layer — enterprise-grade projection' },
  { id: 'F-028', technology: 'Svelte', naturalLanguage: 'Compiled projection intelligence — compile-time reactive elimination', intelligenceType: 'PROJECTION', ringAffinity: 'N5', primitive: 'TRANSFORMATION', secondaryPrimitive: 'PROJECTION', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Compiled Renderer', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.svelte', organismPlacement: 'Cognitive layer — zero-overhead projection' },
  { id: 'F-029', technology: 'SolidJS', naturalLanguage: 'Fine-grained reactive intelligence — signal-based reactivity without virtual DOM', intelligenceType: 'PROJECTION', ringAffinity: 'N5', primitive: 'FLOW', secondaryPrimitive: 'PROJECTION', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Signal Renderer', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.solid', organismPlacement: 'Cognitive layer — fine-grained signal flow' },
  { id: 'F-030', technology: 'Preact', naturalLanguage: 'Minimal projection intelligence — lightweight React-compatible rendering', intelligenceType: 'PROJECTION', ringAffinity: 'N7', primitive: 'PROJECTION', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Light Renderer', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.preact', organismPlacement: 'Swarm layer — minimal footprint projection' },
  { id: 'F-031', technology: 'Alpine.js', naturalLanguage: 'Inline reactive intelligence — declarative behavior directly in markup', intelligenceType: 'PROJECTION', ringAffinity: 'N7', primitive: 'FLOW', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Inline Reactor', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.alpine', organismPlacement: 'Swarm layer — inline reactive attachment' },
  { id: 'F-032', technology: 'Lit', naturalLanguage: 'Web component intelligence — standard-based component rendering', intelligenceType: 'PROJECTION', ringAffinity: 'N8', primitive: 'ENCAPSULATION', secondaryPrimitive: 'PROJECTION', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Standard Component', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.lit', organismPlacement: 'Defense layer — standards-protected components' },
  { id: 'F-033', technology: 'Qwik', naturalLanguage: 'Resumability intelligence — serialized state hydration without replay', intelligenceType: 'PROJECTION', ringAffinity: 'N6', primitive: 'STATE', secondaryPrimitive: 'PROJECTION', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Resumable Renderer', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.qwik', organismPlacement: 'Memory layer — resumable state projection' },
  { id: 'F-034', technology: 'Astro', naturalLanguage: 'Island architecture intelligence — partial hydration with multi-framework support', intelligenceType: 'PROJECTION', ringAffinity: 'N12', primitive: 'PROJECTION', secondaryPrimitive: 'ENCAPSULATION', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Island Renderer', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.astro', organismPlacement: 'Integration layer — multi-source projection' },
  { id: 'F-035', technology: 'Next.js', naturalLanguage: 'Full-stack projection intelligence — server/client unified rendering', intelligenceType: 'PROJECTION', ringAffinity: 'N12', primitive: 'PROJECTION', secondaryPrimitive: 'FLOW', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Full-Stack Renderer', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.next', organismPlacement: 'Integration layer — server-client bridge' },
  { id: 'F-036', technology: 'Nuxt.js', naturalLanguage: 'Vue full-stack intelligence — server-rendered Vue projection', intelligenceType: 'PROJECTION', ringAffinity: 'N12', primitive: 'PROJECTION', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Vue Full-Stack', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.nuxt', organismPlacement: 'Integration layer — Vue server bridge' },
  { id: 'F-037', technology: 'SvelteKit', naturalLanguage: 'Svelte full-stack intelligence — compiled server-rendered application', intelligenceType: 'PROJECTION', ringAffinity: 'N12', primitive: 'PROJECTION', secondaryPrimitive: 'TRANSFORMATION', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Svelte Full-Stack', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.sveltekit', organismPlacement: 'Integration layer — compiled full-stack' },
  { id: 'F-038', technology: 'Remix', naturalLanguage: 'Web-standard full-stack intelligence — progressive enhancement rendering', intelligenceType: 'PROJECTION', ringAffinity: 'N12', primitive: 'FLOW', secondaryPrimitive: 'PROJECTION', category: 'FRAMEWORK', categoryIndex: 2, sovereignReplacement: 'Sovereign Progressive Renderer', sovereignStatus: 'MAPPED', packagePath: 'organism.projection.framework.remix', organismPlacement: 'Integration layer — progressive enhancement' },

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 3: STATE MANAGEMENT INTELLIGENCE (F-039 to F-050)
  // PHI Node: QMEM (33.1 Hz) — Quantum memory
  // ═══════════════════════════════════════════════════════════════════════════

  { id: 'F-039', technology: 'Redux', naturalLanguage: 'Centralized state intelligence — single source of truth with action dispatch', intelligenceType: 'MEMORY', ringAffinity: 'N6', primitive: 'STATE', secondaryPrimitive: 'FLOW', category: 'STATE_MANAGEMENT', categoryIndex: 3, sovereignReplacement: 'Sovereign State Store', sovereignStatus: 'MAPPED', packagePath: 'organism.state.centralized', organismPlacement: 'Memory temple — centralized state pedestal' },
  { id: 'F-040', technology: 'MobX', naturalLanguage: 'Observable state intelligence — transparent reactive state tracking', intelligenceType: 'MEMORY', ringAffinity: 'N6', primitive: 'STATE', secondaryPrimitive: 'SYNCHRONIZATION', category: 'STATE_MANAGEMENT', categoryIndex: 3, sovereignReplacement: 'Sovereign Observable State', sovereignStatus: 'MAPPED', packagePath: 'organism.state.observable', organismPlacement: 'Memory temple — observable state tracking' },
  { id: 'F-041', technology: 'Zustand', naturalLanguage: 'Minimal state intelligence — hook-based lightweight state', intelligenceType: 'MEMORY', ringAffinity: 'N7', primitive: 'STATE', category: 'STATE_MANAGEMENT', categoryIndex: 3, sovereignReplacement: 'Sovereign Minimal State', sovereignStatus: 'MAPPED', packagePath: 'organism.state.minimal', organismPlacement: 'Swarm layer — lightweight state atoms' },
  { id: 'F-042', technology: 'Recoil', naturalLanguage: 'Atomic state intelligence — graph-based atom/selector state model', intelligenceType: 'MEMORY', ringAffinity: 'N5', primitive: 'STATE', secondaryPrimitive: 'FLOW', category: 'STATE_MANAGEMENT', categoryIndex: 3, sovereignReplacement: 'Sovereign Atomic State', sovereignStatus: 'MAPPED', packagePath: 'organism.state.atomic', organismPlacement: 'Cognitive layer — atomic state graph' },
  { id: 'F-043', technology: 'Jotai', naturalLanguage: 'Primitive atom intelligence — bottom-up atomic state composition', intelligenceType: 'MEMORY', ringAffinity: 'N5', primitive: 'STATE', category: 'STATE_MANAGEMENT', categoryIndex: 3, sovereignReplacement: 'Sovereign Atom Primitives', sovereignStatus: 'MAPPED', packagePath: 'organism.state.atoms', organismPlacement: 'Cognitive layer — primitive state atoms' },
  { id: 'F-044', technology: 'XState', naturalLanguage: 'Finite state machine intelligence — statechart-driven state transitions', intelligenceType: 'MEMORY', ringAffinity: 'N2', primitive: 'STATE', secondaryPrimitive: 'VERIFICATION', category: 'STATE_MANAGEMENT', categoryIndex: 3, sovereignReplacement: 'Sovereign State Machine', sovereignStatus: 'MAPPED', packagePath: 'organism.state.machine', organismPlacement: 'Doctrine layer — verified state transitions' },
  { id: 'F-045', technology: 'Valtio', naturalLanguage: 'Proxy state intelligence — mutable proxy-based state with immutable snapshots', intelligenceType: 'MEMORY', ringAffinity: 'N6', primitive: 'STATE', category: 'STATE_MANAGEMENT', categoryIndex: 3, sovereignReplacement: 'Sovereign Proxy State', sovereignStatus: 'MAPPED', packagePath: 'organism.state.proxy', organismPlacement: 'Memory layer — proxy-observed retention' },
  { id: 'F-046', technology: 'Pinia', naturalLanguage: 'Vue state intelligence — composition-API-first Vue state store', intelligenceType: 'MEMORY', ringAffinity: 'N6', primitive: 'STATE', category: 'STATE_MANAGEMENT', categoryIndex: 3, sovereignReplacement: 'Sovereign Vue State', sovereignStatus: 'MAPPED', packagePath: 'organism.state.pinia', organismPlacement: 'Memory layer — Vue-coupled state' },
  { id: 'F-047', technology: 'NgRx', naturalLanguage: 'Angular state intelligence — RxJS-powered reactive state for Angular', intelligenceType: 'MEMORY', ringAffinity: 'N9', primitive: 'STATE', secondaryPrimitive: 'FLOW', category: 'STATE_MANAGEMENT', categoryIndex: 3, sovereignReplacement: 'Sovereign Angular State', sovereignStatus: 'MAPPED', packagePath: 'organism.state.ngrx', organismPlacement: 'Economic layer — enterprise reactive state' },
  { id: 'F-048', technology: 'Effector', naturalLanguage: 'Event-driven state intelligence — effect-based reactive state management', intelligenceType: 'MEMORY', ringAffinity: 'N5', primitive: 'FLOW', secondaryPrimitive: 'STATE', category: 'STATE_MANAGEMENT', categoryIndex: 3, sovereignReplacement: 'Sovereign Effect Engine', sovereignStatus: 'MAPPED', packagePath: 'organism.state.effector', organismPlacement: 'Cognitive layer — effect-driven state flow' },
  { id: 'F-049', technology: 'Akita', naturalLanguage: 'Entity state intelligence — entity store pattern for structured collections', intelligenceType: 'MEMORY', ringAffinity: 'N9', primitive: 'STATE', secondaryPrimitive: 'RELATION', category: 'STATE_MANAGEMENT', categoryIndex: 3, sovereignReplacement: 'Sovereign Entity Store', sovereignStatus: 'MAPPED', packagePath: 'organism.state.entity', organismPlacement: 'Economic layer — structured entity management' },
  { id: 'F-050', technology: 'Context API', naturalLanguage: 'Scoped state intelligence — React tree-scoped state propagation', intelligenceType: 'MEMORY', ringAffinity: 'N3', primitive: 'FLOW', secondaryPrimitive: 'STATE', category: 'STATE_MANAGEMENT', categoryIndex: 3, sovereignReplacement: 'Sovereign Context Scope', sovereignStatus: 'PARTIAL', packagePath: 'organism.state.context', organismPlacement: 'Neural core — tree-scoped state propagation' },

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 4: BUILD TOOL INTELLIGENCE (F-051 to F-060)
  // PHI Node: AXIS (40.0 Hz) — Gamma binding
  // ═══════════════════════════════════════════════════════════════════════════

  { id: 'F-051', technology: 'Webpack', naturalLanguage: 'Bundle intelligence — dependency graph resolution and code splitting', intelligenceType: 'TRANSFORM', ringAffinity: 'N12', primitive: 'TRANSFORMATION', secondaryPrimitive: 'RELATION', category: 'BUILD_TOOLS', categoryIndex: 4, sovereignReplacement: 'Sovereign Bundle Engine', sovereignStatus: 'MAPPED', packagePath: 'organism.transform.bundle', organismPlacement: 'Integration layer — dependency graph resolution' },
  { id: 'F-052', technology: 'Vite', naturalLanguage: 'Fast-dev intelligence — native ESM dev server with HMR', intelligenceType: 'TRANSFORM', ringAffinity: 'N4', primitive: 'TRANSFORMATION', secondaryPrimitive: 'SYNCHRONIZATION', category: 'BUILD_TOOLS', categoryIndex: 4, sovereignReplacement: 'Sovereign Dev Server', sovereignStatus: 'PARTIAL', packagePath: 'organism.transform.dev', organismPlacement: 'Frequency layer — hot-module synchronization' },
  { id: 'F-053', technology: 'Rollup', naturalLanguage: 'Tree-shake intelligence — dead code elimination through static analysis', intelligenceType: 'TRANSFORM', ringAffinity: 'N5', primitive: 'TRANSFORMATION', category: 'BUILD_TOOLS', categoryIndex: 4, sovereignReplacement: 'Sovereign Tree Shaker', sovereignStatus: 'MAPPED', packagePath: 'organism.transform.treeshake', organismPlacement: 'Cognitive layer — code intelligence pruning' },
  { id: 'F-054', technology: 'esbuild', naturalLanguage: 'Speed intelligence — Go-native parallel compilation', intelligenceType: 'TRANSFORM', ringAffinity: 'N7', primitive: 'TRANSFORMATION', category: 'BUILD_TOOLS', categoryIndex: 4, sovereignReplacement: 'Sovereign Fast Compiler', sovereignStatus: 'MAPPED', packagePath: 'organism.transform.fast', organismPlacement: 'Swarm layer — parallel compilation swarm' },
  { id: 'F-055', technology: 'Parcel', naturalLanguage: 'Zero-config intelligence — automatic dependency detection and bundling', intelligenceType: 'TRANSFORM', ringAffinity: 'N10', primitive: 'TRANSFORMATION', category: 'BUILD_TOOLS', categoryIndex: 4, sovereignReplacement: 'Sovereign Auto Bundler', sovereignStatus: 'MAPPED', packagePath: 'organism.transform.auto', organismPlacement: 'Intelligence layer — autonomous bundling' },
  { id: 'F-056', technology: 'SWC', naturalLanguage: 'Rust-speed intelligence — Rust-native JavaScript/TypeScript compilation', intelligenceType: 'TRANSFORM', ringAffinity: 'N7', primitive: 'TRANSFORMATION', category: 'BUILD_TOOLS', categoryIndex: 4, sovereignReplacement: 'Sovereign Rust Compiler', sovereignStatus: 'MAPPED', packagePath: 'organism.transform.swc', organismPlacement: 'Swarm layer — native-speed transformation' },
  { id: 'F-057', technology: 'Babel', naturalLanguage: 'Transpilation intelligence — syntax downlevel transformation for compatibility', intelligenceType: 'TRANSFORM', ringAffinity: 'N12', primitive: 'TRANSFORMATION', category: 'BUILD_TOOLS', categoryIndex: 4, sovereignReplacement: 'Sovereign Transpiler', sovereignStatus: 'MAPPED', packagePath: 'organism.transform.transpile', organismPlacement: 'Integration layer — cross-target compatibility' },
  { id: 'F-058', technology: 'Terser', naturalLanguage: 'Compression intelligence — code minification preserving semantics', intelligenceType: 'TRANSFORM', ringAffinity: 'N8', primitive: 'TRANSFORMATION', category: 'BUILD_TOOLS', categoryIndex: 4, sovereignReplacement: 'Sovereign Compressor', sovereignStatus: 'MAPPED', packagePath: 'organism.transform.compress', organismPlacement: 'Defense layer — minimal attack surface' },
  { id: 'F-059', technology: 'PostCSS (Build)', naturalLanguage: 'CSS transformation intelligence — plugin-driven CSS compilation pipeline', intelligenceType: 'TRANSFORM', ringAffinity: 'N4', primitive: 'TRANSFORMATION', category: 'BUILD_TOOLS', categoryIndex: 4, sovereignReplacement: 'Sovereign CSS Pipeline', sovereignStatus: 'MAPPED', packagePath: 'organism.transform.css', organismPlacement: 'Frequency layer — style transformation chain' },
  { id: 'F-060', technology: 'Turbopack', naturalLanguage: 'Incremental intelligence — Rust-native incremental compilation engine', intelligenceType: 'TRANSFORM', ringAffinity: 'N7', primitive: 'TRANSFORMATION', secondaryPrimitive: 'SYNCHRONIZATION', category: 'BUILD_TOOLS', categoryIndex: 4, sovereignReplacement: 'Sovereign Incremental Engine', sovereignStatus: 'MAPPED', packagePath: 'organism.transform.incremental', organismPlacement: 'Swarm layer — incremental parallel build' },

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 5: TESTING INTELLIGENCE (F-061 to F-068)
  // PHI Node: AEGIS (53.6 Hz) — Protective verification
  // ═══════════════════════════════════════════════════════════════════════════

  { id: 'F-061', technology: 'Jest', naturalLanguage: 'Unit verification intelligence — isolated function truth testing', intelligenceType: 'IMMUNE', ringAffinity: 'N8', primitive: 'VERIFICATION', category: 'TESTING', categoryIndex: 5, sovereignReplacement: 'Sovereign Unit Verifier', sovereignStatus: 'MAPPED', packagePath: 'organism.immune.unit', organismPlacement: 'Defense layer — unit-level truth verification' },
  { id: 'F-062', technology: 'Vitest', naturalLanguage: 'Vite-native verification intelligence — ESM-first test runner', intelligenceType: 'IMMUNE', ringAffinity: 'N8', primitive: 'VERIFICATION', secondaryPrimitive: 'SYNCHRONIZATION', category: 'TESTING', categoryIndex: 5, sovereignReplacement: 'Sovereign Fast Verifier', sovereignStatus: 'PARTIAL', packagePath: 'organism.immune.vitest', organismPlacement: 'Defense layer — fast ESM verification' },
  { id: 'F-063', technology: 'Cypress', naturalLanguage: 'Integration verification intelligence — full browser interaction testing', intelligenceType: 'IMMUNE', ringAffinity: 'N12', primitive: 'VERIFICATION', secondaryPrimitive: 'FLOW', category: 'TESTING', categoryIndex: 5, sovereignReplacement: 'Sovereign Integration Verifier', sovereignStatus: 'MAPPED', packagePath: 'organism.immune.integration', organismPlacement: 'Integration layer — full-stack truth verification' },
  { id: 'F-064', technology: 'Playwright', naturalLanguage: 'Cross-browser verification intelligence — multi-engine browser automation', intelligenceType: 'IMMUNE', ringAffinity: 'N12', primitive: 'VERIFICATION', category: 'TESTING', categoryIndex: 5, sovereignReplacement: 'Sovereign Browser Verifier', sovereignStatus: 'MAPPED', packagePath: 'organism.immune.browser', organismPlacement: 'Integration layer — cross-platform verification' },
  { id: 'F-065', technology: 'Testing Library', naturalLanguage: 'User-centric verification intelligence — tests what the user actually sees', intelligenceType: 'IMMUNE', ringAffinity: 'N3', primitive: 'VERIFICATION', category: 'TESTING', categoryIndex: 5, sovereignReplacement: 'Sovereign User Verifier', sovereignStatus: 'MAPPED', packagePath: 'organism.immune.user', organismPlacement: 'Neural core — user-perception truth testing' },
  { id: 'F-066', technology: 'Storybook', naturalLanguage: 'Component isolation intelligence — visual component development environment', intelligenceType: 'IMMUNE', ringAffinity: 'N10', primitive: 'PROJECTION', secondaryPrimitive: 'VERIFICATION', category: 'TESTING', categoryIndex: 5, sovereignReplacement: 'Sovereign Component Lab', sovereignStatus: 'MAPPED', packagePath: 'organism.immune.stories', organismPlacement: 'Intelligence layer — component research lab' },
  { id: 'F-067', technology: 'Chromatic', naturalLanguage: 'Visual regression intelligence — pixel-level change detection', intelligenceType: 'IMMUNE', ringAffinity: 'N8', primitive: 'VERIFICATION', category: 'TESTING', categoryIndex: 5, sovereignReplacement: 'Sovereign Visual Diff', sovereignStatus: 'MAPPED', packagePath: 'organism.immune.visual', organismPlacement: 'Defense layer — visual regression immunity' },
  { id: 'F-068', technology: 'Percy', naturalLanguage: 'Snapshot verification intelligence — cross-browser visual snapshot testing', intelligenceType: 'IMMUNE', ringAffinity: 'N8', primitive: 'VERIFICATION', secondaryPrimitive: 'STATE', category: 'TESTING', categoryIndex: 5, sovereignReplacement: 'Sovereign Snapshot Verifier', sovereignStatus: 'MAPPED', packagePath: 'organism.immune.snapshot', organismPlacement: 'Defense layer — visual state verification' },

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 6: GRAPHICS INTELLIGENCE (F-069 to F-080)
  // PHI Node: ENTANGLA (86.7 Hz) — Visual entanglement
  // ═══════════════════════════════════════════════════════════════════════════

  { id: 'F-069', technology: 'Canvas API', naturalLanguage: 'Raster intelligence — pixel-level 2D drawing surface', intelligenceType: 'VISUAL', ringAffinity: 'N3', primitive: 'PROJECTION', category: 'GRAPHICS', categoryIndex: 6, sovereignReplacement: 'Sovereign Raster Engine', sovereignStatus: 'PARTIAL', packagePath: 'organism.visual.raster', organismPlacement: 'Neural core — pixel-level visual output' },
  { id: 'F-070', technology: 'WebGL', naturalLanguage: '3D projection intelligence — GPU-accelerated 3D rendering pipeline', intelligenceType: 'VISUAL', ringAffinity: 'N3', primitive: 'PROJECTION', secondaryPrimitive: 'TRANSFORMATION', category: 'GRAPHICS', categoryIndex: 6, sovereignReplacement: 'Sovereign 3D Engine', sovereignStatus: 'PARTIAL', packagePath: 'organism.visual.3d', organismPlacement: 'Neural core — GPU-accelerated projection' },
  { id: 'F-071', technology: 'WebGPU', naturalLanguage: 'Compute intelligence — next-gen GPU compute and rendering API', intelligenceType: 'VISUAL', ringAffinity: 'N1', primitive: 'PROJECTION', secondaryPrimitive: 'TRANSFORMATION', category: 'GRAPHICS', categoryIndex: 6, sovereignReplacement: 'Sovereign GPU Compute', sovereignStatus: 'MAPPED', packagePath: 'organism.visual.gpu', organismPlacement: 'Sovereign core — GPU compute substrate' },
  { id: 'F-072', technology: 'Three.js', naturalLanguage: 'Scene intelligence — 3D scene graph with camera, lighting, and materials', intelligenceType: 'VISUAL', ringAffinity: 'N3', primitive: 'PROJECTION', secondaryPrimitive: 'RELATION', category: 'GRAPHICS', categoryIndex: 6, sovereignReplacement: 'Sovereign Scene System', sovereignStatus: 'PARTIAL', packagePath: 'organism.visual.scene', organismPlacement: 'Neural core — 3D scene graph projection' },
  { id: 'F-073', technology: 'D3.js', naturalLanguage: 'Data visualization intelligence — data-driven document transformation', intelligenceType: 'VISUAL', ringAffinity: 'N10', primitive: 'PROJECTION', secondaryPrimitive: 'FLOW', category: 'GRAPHICS', categoryIndex: 6, sovereignReplacement: 'Sovereign Data Visualization', sovereignStatus: 'MAPPED', packagePath: 'organism.visual.data', organismPlacement: 'Intelligence layer — data-driven projection' },
  { id: 'F-074', technology: 'Chart.js', naturalLanguage: 'Chart intelligence — structured data chart rendering', intelligenceType: 'VISUAL', ringAffinity: 'N10', primitive: 'PROJECTION', category: 'GRAPHICS', categoryIndex: 6, sovereignReplacement: 'Sovereign Chart Engine', sovereignStatus: 'MAPPED', packagePath: 'organism.visual.chart', organismPlacement: 'Intelligence layer — chart projection' },
  { id: 'F-075', technology: 'Pixi.js', naturalLanguage: '2D GPU intelligence — hardware-accelerated 2D sprite rendering', intelligenceType: 'VISUAL', ringAffinity: 'N7', primitive: 'PROJECTION', category: 'GRAPHICS', categoryIndex: 6, sovereignReplacement: 'Sovereign 2D GPU Engine', sovereignStatus: 'MAPPED', packagePath: 'organism.visual.sprite', organismPlacement: 'Swarm layer — GPU-accelerated 2D swarm rendering' },
  { id: 'F-076', technology: 'Babylon.js', naturalLanguage: 'Full 3D engine intelligence — complete 3D engine with physics and audio', intelligenceType: 'VISUAL', ringAffinity: 'N3', primitive: 'PROJECTION', secondaryPrimitive: 'SYNCHRONIZATION', category: 'GRAPHICS', categoryIndex: 6, sovereignReplacement: 'Sovereign Full 3D Engine', sovereignStatus: 'MAPPED', packagePath: 'organism.visual.engine3d', organismPlacement: 'Neural core — full 3D world projection' },
  { id: 'F-077', technology: 'p5.js', naturalLanguage: 'Creative coding intelligence — artist-friendly procedural visual generation', intelligenceType: 'VISUAL', ringAffinity: 'N5', primitive: 'PROJECTION', category: 'GRAPHICS', categoryIndex: 6, sovereignReplacement: 'Sovereign Creative Canvas', sovereignStatus: 'MAPPED', packagePath: 'organism.visual.creative', organismPlacement: 'Cognitive layer — procedural visual creativity' },
  { id: 'F-078', technology: 'Anime.js', naturalLanguage: 'Animation intelligence — timeline-based property animation engine', intelligenceType: 'VISUAL', ringAffinity: 'N4', primitive: 'SYNCHRONIZATION', secondaryPrimitive: 'PROJECTION', category: 'GRAPHICS', categoryIndex: 6, sovereignReplacement: 'Sovereign Animation Timeline', sovereignStatus: 'MAPPED', packagePath: 'organism.visual.animate', organismPlacement: 'Frequency layer — PHI-timed animation' },
  { id: 'F-079', technology: 'GSAP', naturalLanguage: 'Professional animation intelligence — high-performance tweening engine', intelligenceType: 'VISUAL', ringAffinity: 'N4', primitive: 'SYNCHRONIZATION', secondaryPrimitive: 'TRANSFORMATION', category: 'GRAPHICS', categoryIndex: 6, sovereignReplacement: 'Sovereign Tween Engine', sovereignStatus: 'MAPPED', packagePath: 'organism.visual.tween', organismPlacement: 'Frequency layer — professional visual timing' },
  { id: 'F-080', technology: 'Lottie', naturalLanguage: 'After Effects intelligence — vector animation playback from design tools', intelligenceType: 'VISUAL', ringAffinity: 'N4', primitive: 'PROJECTION', secondaryPrimitive: 'SYNCHRONIZATION', category: 'GRAPHICS', categoryIndex: 6, sovereignReplacement: 'Sovereign Vector Animator', sovereignStatus: 'MAPPED', packagePath: 'organism.visual.lottie', organismPlacement: 'Frequency layer — design-to-code animation' },

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 7: COMMUNICATION INTELLIGENCE (F-081 to F-089)
  // PHI Node: PARALLAX (111.0 Hz) — Parallel channels
  // ═══════════════════════════════════════════════════════════════════════════

  { id: 'F-081', technology: 'Fetch API', naturalLanguage: 'Request intelligence — promise-based HTTP request/response cycle', intelligenceType: 'CHANNEL', ringAffinity: 'N11', primitive: 'FLOW', category: 'COMMUNICATION', categoryIndex: 7, sovereignReplacement: 'Sovereign Request Engine', sovereignStatus: 'PARTIAL', packagePath: 'organism.channel.request', organismPlacement: 'Sensor layer — HTTP request/response cycle' },
  { id: 'F-082', technology: 'Axios', naturalLanguage: 'HTTP client intelligence — interceptor-based request pipeline', intelligenceType: 'CHANNEL', ringAffinity: 'N11', primitive: 'FLOW', secondaryPrimitive: 'TRANSFORMATION', category: 'COMMUNICATION', categoryIndex: 7, sovereignReplacement: 'Sovereign HTTP Client', sovereignStatus: 'MAPPED', packagePath: 'organism.channel.http', organismPlacement: 'Sensor layer — interceptor pipeline' },
  { id: 'F-083', technology: 'WebSocket', naturalLanguage: 'Stream intelligence — persistent bidirectional data channel', intelligenceType: 'CHANNEL', ringAffinity: 'N4', primitive: 'FLOW', secondaryPrimitive: 'SYNCHRONIZATION', category: 'COMMUNICATION', categoryIndex: 7, sovereignReplacement: 'Sovereign Stream Channel', sovereignStatus: 'PARTIAL', packagePath: 'organism.channel.stream', organismPlacement: 'Frequency layer — persistent sync channel' },
  { id: 'F-084', technology: 'WebRTC', naturalLanguage: 'Peer intelligence — direct peer-to-peer media and data channels', intelligenceType: 'CHANNEL', ringAffinity: 'N7', primitive: 'FLOW', secondaryPrimitive: 'ENCAPSULATION', category: 'COMMUNICATION', categoryIndex: 7, sovereignReplacement: 'Sovereign P2P Channel', sovereignStatus: 'MAPPED', packagePath: 'organism.channel.peer', organismPlacement: 'Swarm layer — peer-to-peer data swarm' },
  { id: 'F-085', technology: 'Server-Sent Events', naturalLanguage: 'Push intelligence — server-to-client unidirectional event stream', intelligenceType: 'CHANNEL', ringAffinity: 'N11', primitive: 'FLOW', category: 'COMMUNICATION', categoryIndex: 7, sovereignReplacement: 'Sovereign Push Stream', sovereignStatus: 'MAPPED', packagePath: 'organism.channel.push', organismPlacement: 'Sensor layer — server push events' },
  { id: 'F-086', technology: 'GraphQL Client', naturalLanguage: 'Query intelligence — typed graph query language for API interaction', intelligenceType: 'CHANNEL', ringAffinity: 'N10', primitive: 'FLOW', secondaryPrimitive: 'RELATION', category: 'COMMUNICATION', categoryIndex: 7, sovereignReplacement: 'Sovereign Graph Query', sovereignStatus: 'MAPPED', packagePath: 'organism.channel.graph', organismPlacement: 'Intelligence layer — graph-structured queries' },
  { id: 'F-087', technology: 'Apollo Client', naturalLanguage: 'Cache-query intelligence — normalized cache with GraphQL integration', intelligenceType: 'CHANNEL', ringAffinity: 'N6', primitive: 'STATE', secondaryPrimitive: 'FLOW', category: 'COMMUNICATION', categoryIndex: 7, sovereignReplacement: 'Sovereign Cache Query', sovereignStatus: 'MAPPED', packagePath: 'organism.channel.cache', organismPlacement: 'Memory layer — normalized cache with queries' },
  { id: 'F-088', technology: 'React Query', naturalLanguage: 'Server state intelligence — async state management for server data', intelligenceType: 'CHANNEL', ringAffinity: 'N6', primitive: 'STATE', secondaryPrimitive: 'SYNCHRONIZATION', category: 'COMMUNICATION', categoryIndex: 7, sovereignReplacement: 'Sovereign Server State', sovereignStatus: 'MAPPED', packagePath: 'organism.channel.server', organismPlacement: 'Memory layer — server state synchronization' },
  { id: 'F-089', technology: 'SWR', naturalLanguage: 'Stale-while-revalidate intelligence — cache-first data fetching strategy', intelligenceType: 'CHANNEL', ringAffinity: 'N6', primitive: 'STATE', secondaryPrimitive: 'FLOW', category: 'COMMUNICATION', categoryIndex: 7, sovereignReplacement: 'Sovereign SWR Engine', sovereignStatus: 'MAPPED', packagePath: 'organism.channel.swr', organismPlacement: 'Memory layer — stale-while-revalidate cache' },

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 8: STORAGE INTELLIGENCE (F-090 to F-094)
  // PHI Node: QMEM (33.1 Hz) — Quantum memory (shared with State)
  // ═══════════════════════════════════════════════════════════════════════════

  { id: 'F-090', technology: 'LocalStorage', naturalLanguage: 'Persistent local memory — key-value storage surviving browser sessions', intelligenceType: 'PERSISTENCE', ringAffinity: 'N6', primitive: 'STATE', category: 'STORAGE', categoryIndex: 8, sovereignReplacement: 'Sovereign Local Memory', sovereignStatus: 'PARTIAL', packagePath: 'organism.memory.local', organismPlacement: 'Memory temple — persistent local pedestal' },
  { id: 'F-091', technology: 'SessionStorage', naturalLanguage: 'Session memory — tab-scoped temporary state retention', intelligenceType: 'PERSISTENCE', ringAffinity: 'N6', primitive: 'STATE', secondaryPrimitive: 'ENCAPSULATION', category: 'STORAGE', categoryIndex: 8, sovereignReplacement: 'Sovereign Session Memory', sovereignStatus: 'PARTIAL', packagePath: 'organism.memory.session', organismPlacement: 'Memory temple — session-scoped pedestal' },
  { id: 'F-092', technology: 'IndexedDB', naturalLanguage: 'Structured local database intelligence — indexed object store in browser', intelligenceType: 'PERSISTENCE', ringAffinity: 'N6', primitive: 'STATE', secondaryPrimitive: 'RELATION', category: 'STORAGE', categoryIndex: 8, sovereignReplacement: 'Sovereign Local Database', sovereignStatus: 'MAPPED', packagePath: 'organism.memory.database', organismPlacement: 'Memory temple — indexed local database' },
  { id: 'F-093', technology: 'Cache API', naturalLanguage: 'Network cache intelligence — request/response pair caching for offline', intelligenceType: 'PERSISTENCE', ringAffinity: 'N8', primitive: 'STATE', secondaryPrimitive: 'FLOW', category: 'STORAGE', categoryIndex: 8, sovereignReplacement: 'Sovereign Cache Store', sovereignStatus: 'MAPPED', packagePath: 'organism.memory.cache', organismPlacement: 'Defense layer — offline cache protection' },
  { id: 'F-094', technology: 'Cookies', naturalLanguage: 'Token memory intelligence — small persistent tokens sent with requests', intelligenceType: 'PERSISTENCE', ringAffinity: 'N9', primitive: 'STATE', category: 'STORAGE', categoryIndex: 8, sovereignReplacement: 'Sovereign Token Memory', sovereignStatus: 'MAPPED', packagePath: 'organism.memory.token', organismPlacement: 'Economic layer — token-based memory' },

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY 9: WEB API INTELLIGENCE (F-095 to F-100)
  // PHI Node: Resonex (20.5 Hz) — Browser-native resonance
  // ═══════════════════════════════════════════════════════════════════════════

  { id: 'F-095', technology: 'Service Workers', naturalLanguage: 'Background intelligence — persistent background process with network interception', intelligenceType: 'BROWSER_NATIVE', ringAffinity: 'N1', primitive: 'FLOW', secondaryPrimitive: 'ENCAPSULATION', category: 'WEB_API', categoryIndex: 9, sovereignReplacement: 'Sovereign Background Agent', sovereignStatus: 'PARTIAL', packagePath: 'organism.browser.worker', organismPlacement: 'Sovereign core — background sovereign agent' },
  { id: 'F-096', technology: 'Web Workers', naturalLanguage: 'Parallel compute intelligence — off-main-thread computation', intelligenceType: 'BROWSER_NATIVE', ringAffinity: 'N7', primitive: 'TRANSFORMATION', secondaryPrimitive: 'ENCAPSULATION', category: 'WEB_API', categoryIndex: 9, sovereignReplacement: 'Sovereign Parallel Compute', sovereignStatus: 'PARTIAL', packagePath: 'organism.browser.compute', organismPlacement: 'Swarm layer — parallel computation swarm' },
  { id: 'F-097', technology: 'Notifications API', naturalLanguage: 'Alert intelligence — system-level notification delivery', intelligenceType: 'BROWSER_NATIVE', ringAffinity: 'N8', primitive: 'PROJECTION', category: 'WEB_API', categoryIndex: 9, sovereignReplacement: 'Sovereign Alert System', sovereignStatus: 'MAPPED', packagePath: 'organism.browser.notify', organismPlacement: 'Defense layer — alert projection to user' },
  { id: 'F-098', technology: 'Geolocation API', naturalLanguage: 'Spatial intelligence — geographic position awareness', intelligenceType: 'BROWSER_NATIVE', ringAffinity: 'N11', primitive: 'STATE', secondaryPrimitive: 'FLOW', category: 'WEB_API', categoryIndex: 9, sovereignReplacement: 'Sovereign Geo Sensor', sovereignStatus: 'MAPPED', packagePath: 'organism.browser.geo', organismPlacement: 'Sensor layer — geospatial awareness' },
  { id: 'F-099', technology: 'Web Audio API', naturalLanguage: 'Audio intelligence — real-time audio processing and synthesis', intelligenceType: 'BROWSER_NATIVE', ringAffinity: 'N4', primitive: 'PROJECTION', secondaryPrimitive: 'SYNCHRONIZATION', category: 'WEB_API', categoryIndex: 9, sovereignReplacement: 'Sovereign Audio Engine', sovereignStatus: 'MAPPED', packagePath: 'organism.browser.audio', organismPlacement: 'Frequency layer — audio frequency synthesis' },
  { id: 'F-100', technology: 'Web Speech API', naturalLanguage: 'Voice intelligence — speech recognition and synthesis', intelligenceType: 'BROWSER_NATIVE', ringAffinity: 'N10', primitive: 'TRANSFORMATION', secondaryPrimitive: 'FLOW', category: 'WEB_API', categoryIndex: 9, sovereignReplacement: 'Sovereign Voice Interface', sovereignStatus: 'MAPPED', packagePath: 'organism.browser.speech', organismPlacement: 'Intelligence layer — voice intelligence interface' },
];

// ═══════════════════════════════════════════════════════════════════════════════
// REGISTRY ACCESS FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

/** Get model by ID */
export function getFModel(id: string): FModel | undefined {
  return FMODEL_REGISTRY.find(m => m.id === id);
}

/** Get models by category */
export function getFModelsByCategory(category: FModelCategory): FModel[] {
  return FMODEL_REGISTRY.filter(m => m.category === category);
}

/** Get models by primitive function */
export function getFModelsByPrimitive(primitive: PrimitiveFunction): FModel[] {
  return FMODEL_REGISTRY.filter(m => m.primitive === primitive || m.secondaryPrimitive === primitive);
}

/** Get models by ring affinity */
export function getFModelsByRing(ring: RingAffinity): FModel[] {
  return FMODEL_REGISTRY.filter(m => m.ringAffinity === ring);
}

/** Get models by sovereign status */
export function getFModelsBySovereignStatus(status: SovereignStatus): FModel[] {
  return FMODEL_REGISTRY.filter(m => m.sovereignStatus === status);
}

/** Get models by intelligence type */
export function getFModelsByIntelligenceType(type: IntelligenceType): FModel[] {
  return FMODEL_REGISTRY.filter(m => m.intelligenceType === type);
}

/** Count sovereign status distribution */
export function getSovereignStatusCounts(): Record<SovereignStatus, number> {
  const counts: Record<SovereignStatus, number> = {
    NATIVE: 0, FLIPPED: 0, PARTIAL: 0, MAPPED: 0, EXTERNAL: 0,
  };
  for (const m of FMODEL_REGISTRY) {
    counts[m.sovereignStatus]++;
  }
  return counts;
}

/** Count primitive distribution */
export function getPrimitiveCounts(): Record<PrimitiveFunction, number> {
  const counts: Record<string, number> = {};
  for (const m of FMODEL_REGISTRY) {
    counts[m.primitive] = (counts[m.primitive] || 0) + 1;
    if (m.secondaryPrimitive) {
      counts[m.secondaryPrimitive] = (counts[m.secondaryPrimitive] || 0) + 1;
    }
  }
  return counts as Record<PrimitiveFunction, number>;
}

/** Registry statistics */
export const FMODEL_STATS = {
  total: FMODEL_REGISTRY.length,
  categories: 10,
  phiNodes: 12,
  hebbianEdges: 30,
  icosahedralSacred: 7200,
};
