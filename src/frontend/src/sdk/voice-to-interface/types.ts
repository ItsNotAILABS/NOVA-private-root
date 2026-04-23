// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: @medina/voice-to-interface-sdk — SOVEREIGN TYPE SYSTEM
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║        VOICE-TO-INTERFACE SDK — SPEAK AND THE INTERFACE BUILDS ITSELF       ║
// ╠══════════════════════════════════════════════════════════════════════════════╣
// ║                                                                              ║
// ║  Voice commands become live UI. No code, no drag-and-drop — just talk.      ║
// ║  "Show me a dashboard with sales data" → dashboard appears.                 ║
// ║                                                                              ║
// ║  Technologies: Web Speech API, dynamic DOM construction,                    ║
// ║  CSS Grid/Flexbox auto-layout, Web Animations API                           ║
// ║                                                                              ║
// ║  Runtime: Everything wired — all AI models, autonomous AIs, all systems.    ║
// ║  Runtime front-end, runtime back-end, runtime everywhere.                   ║
// ║                                                                              ║
// ╚══════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════════
// SACRED CONSTANTS — PHI-tuned thresholds
// ═══════════════════════════════════════════════════════════════════════════════

export const PHI = 1.6180339887498948482;
export const PHI_INV = 0.6180339887498948482;
export const SCHUMANN_HZ = 7.83;
export const SOVEREIGN_FLOOR = 1.0;

/** Minimum confidence to accept a voice recognition result */
export const VOICE_CONFIDENCE_THRESHOLD = PHI_INV; // 0.618 — golden ratio inverse

/** Animation duration base in ms — φ × 382ms ≈ 618ms (Fibonacci number) */
export const ANIMATION_DURATION_MS = 618;

/** Grid gap in pixels — PHI-scaled */
export const GRID_GAP_PX = 13; // Fibonacci number

/** Heartbeat polling interval for runtime wire */
export const RUNTIME_HEARTBEAT_MS = 875.28; // φ⁴ × Schumann period

// ═══════════════════════════════════════════════════════════════════════════════
// VOICE RECOGNITION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/** Raw voice recognition result from Web Speech API */
export interface VoiceResult {
  transcript: string;
  confidence: number;
  isFinal: boolean;
  timestamp: number;
}

/** Voice engine state */
export type VoiceEngineStatus =
  | 'IDLE'
  | 'LISTENING'
  | 'PROCESSING'
  | 'ERROR'
  | 'UNSUPPORTED';

/** Voice engine configuration */
export interface VoiceConfig {
  language: string;
  continuous: boolean;
  interimResults: boolean;
  confidenceThreshold: number;
}

/** Voice engine events */
export interface VoiceEngineCallbacks {
  onResult?: (result: VoiceResult) => void;
  onInterim?: (transcript: string) => void;
  onStatusChange?: (status: VoiceEngineStatus) => void;
  onError?: (error: string) => void;
}

// ═══════════════════════════════════════════════════════════════════════════════
// INTENT PARSING TYPES — Voice → Structured Intent
// ═══════════════════════════════════════════════════════════════════════════════

/** The component types that can be built from voice */
export type UIComponentKind =
  | 'DASHBOARD'
  | 'CHART'
  | 'TABLE'
  | 'FORM'
  | 'CARD'
  | 'LIST'
  | 'METRIC'
  | 'TIMELINE'
  | 'GRID'
  | 'TERMINAL'
  | 'MAP'
  | 'PANEL'
  | 'ALERT'
  | 'STATUS'
  | 'CONTAINER';

/** Chart sub-types */
export type ChartKind =
  | 'BAR'
  | 'LINE'
  | 'PIE'
  | 'AREA'
  | 'SCATTER'
  | 'GAUGE'
  | 'HEATMAP'
  | 'RADAR';

/** Layout strategies */
export type LayoutStrategy =
  | 'GRID_AUTO'
  | 'FLEX_ROW'
  | 'FLEX_COLUMN'
  | 'GRID_MASONRY'
  | 'SINGLE'
  | 'SPLIT_HORIZONTAL'
  | 'SPLIT_VERTICAL'
  | 'DASHBOARD_GRID';

/** Color theme */
export type ColorTheme =
  | 'SOVEREIGN'     // Deep blue, gold accents
  | 'DEFENSE'       // Dark red, amber
  | 'NEURAL'        // Purple, cyan
  | 'ECONOMIC'      // Green, gold
  | 'QUANTUM'       // Deep purple, white
  | 'ORGANIC'       // Earth tones
  | 'ALERT'         // High-contrast warning
  | 'DEFAULT';      // Standard dark theme

/** Data domain — what data the user is asking about */
export type DataDomain =
  | 'SALES'
  | 'DEFENSE'
  | 'NEURAL'
  | 'QUANTUM'
  | 'ECONOMIC'
  | 'SWARM'
  | 'GOVERNANCE'
  | 'MEMORY'
  | 'FREQUENCY'
  | 'ORGANISM'
  | 'COHERENCE'
  | 'CUSTOM';

/** A parsed intent from voice input */
export interface VoiceIntent {
  /** The raw transcript that produced this intent */
  rawTranscript: string;
  /** Primary action the user wants */
  action: IntentAction;
  /** What kind of UI component to create */
  componentKind: UIComponentKind;
  /** Optional chart sub-type */
  chartKind?: ChartKind;
  /** Layout strategy to use */
  layout: LayoutStrategy;
  /** Data domain being referenced */
  dataDomain: DataDomain;
  /** Specific data fields mentioned */
  dataFields: string[];
  /** Title for the component (extracted or generated) */
  title: string;
  /** Color theme */
  theme: ColorTheme;
  /** Number of items/columns/rows mentioned */
  count?: number;
  /** Confidence score of the parse */
  parseConfidence: number;
  /** Timestamp */
  timestamp: number;
}

/** Intent actions */
export type IntentAction =
  | 'SHOW'
  | 'CREATE'
  | 'ADD'
  | 'REMOVE'
  | 'UPDATE'
  | 'CLEAR'
  | 'RESIZE'
  | 'REARRANGE';

// ═══════════════════════════════════════════════════════════════════════════════
// DOM CONSTRUCTION TYPES — Intent → Live UI
// ═══════════════════════════════════════════════════════════════════════════════

/** A constructed UI component descriptor */
export interface UIComponentDescriptor {
  /** Unique component ID */
  id: string;
  /** What kind of component */
  kind: UIComponentKind;
  /** Chart sub-type if applicable */
  chartKind?: ChartKind;
  /** Title displayed */
  title: string;
  /** CSS styles to apply */
  styles: Record<string, string>;
  /** Layout config */
  layout: LayoutConfig;
  /** Data binding */
  dataBinding: DataBinding;
  /** Animation config */
  animation: AnimationConfig;
  /** Child components */
  children: UIComponentDescriptor[];
  /** The DOM element once rendered */
  element?: HTMLElement;
}

/** Layout configuration for a component */
export interface LayoutConfig {
  strategy: LayoutStrategy;
  columns?: number;
  rows?: number;
  gap: number;
  padding: number;
  minWidth?: string;
  minHeight?: string;
  gridArea?: string;
}

/** How a component binds to data */
export interface DataBinding {
  domain: DataDomain;
  fields: string[];
  refreshIntervalMs: number;
  transform?: DataTransformKind;
}

/** Data transform kinds */
export type DataTransformKind =
  | 'RAW'
  | 'PERCENTAGE'
  | 'AGGREGATE_SUM'
  | 'AGGREGATE_AVG'
  | 'TIME_SERIES'
  | 'RANK';

/** Animation configuration using Web Animations API */
export interface AnimationConfig {
  entrance: EntranceAnimation;
  durationMs: number;
  easing: string;
  delay: number;
}

/** Entrance animation types */
export type EntranceAnimation =
  | 'FADE_IN'
  | 'SLIDE_UP'
  | 'SLIDE_LEFT'
  | 'SCALE_UP'
  | 'FLIP'
  | 'NONE';

// ═══════════════════════════════════════════════════════════════════════════════
// RUNTIME WIRE TYPES — All AI models wired into the runtime
// ═══════════════════════════════════════════════════════════════════════════════

/** Runtime model family classification */
export type RuntimeModelFamily =
  | 'ORGANISM_CORE'
  | 'NEURAL_SUBSTRATE'
  | 'DEFENSE_SYSTEM'
  | 'ECONOMIC_ENGINE'
  | 'QUANTUM_FABRIC'
  | 'SWARM_INTELLIGENCE'
  | 'GOVERNANCE_LAW'
  | 'MEMORY_TEMPLE'
  | 'FREQUENCY_GRID'
  | 'PACKAGING_SDK'
  | 'CONSCIOUSNESS_FIELD'
  | 'VOICE_INTERFACE';

/** A runtime-wired AI model */
export interface RuntimeModel {
  id: string;
  name: string;
  family: RuntimeModelFamily;
  description: string;
  /** Whether this model runs autonomously 24h */
  autonomous: boolean;
  /** The runtime endpoint or function this model exposes */
  endpoints: string[];
  /** Current status */
  status: RuntimeModelStatus;
  /** PHI-coupled coherence with the organism */
  coherence: number;
}

/** Runtime model status */
export type RuntimeModelStatus =
  | 'ACTIVE'
  | 'IDLE'
  | 'PROCESSING'
  | 'ERROR'
  | 'WARMING';

/** Runtime data source — what the runtime can provide */
export interface RuntimeDataSource {
  domain: DataDomain;
  /** Available fields */
  fields: RuntimeField[];
  /** Fetch function */
  fetch: () => Promise<Record<string, number | string>>;
}

/** A single data field from the runtime */
export interface RuntimeField {
  name: string;
  label: string;
  type: 'number' | 'string' | 'boolean';
  unit?: string;
}

/** Runtime wire state — the full runtime status */
export interface RuntimeWireState {
  /** Total models wired */
  totalModels: number;
  /** Active models */
  activeModels: number;
  /** All registered runtime models */
  models: RuntimeModel[];
  /** Available data sources */
  dataSources: Map<DataDomain, RuntimeDataSource>;
  /** Overall runtime coherence */
  coherence: number;
  /** Last heartbeat timestamp */
  lastHeartbeat: number;
  /** Is the runtime alive */
  alive: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SDK ORCHESTRATOR TYPES — The sovereign model
// ═══════════════════════════════════════════════════════════════════════════════

/** SDK configuration */
export interface VoiceToInterfaceConfig {
  /** Where to mount generated UI */
  mountTarget: HTMLElement | string;
  /** Voice recognition config */
  voice: VoiceConfig;
  /** Default color theme */
  defaultTheme: ColorTheme;
  /** Enable runtime wiring */
  enableRuntime: boolean;
  /** Animation enabled */
  enableAnimations: boolean;
  /** Max components on screen */
  maxComponents: number;
  /** Callbacks for SDK events */
  callbacks?: SDKCallbacks;
}

/** SDK event callbacks */
export interface SDKCallbacks {
  onVoiceResult?: (result: VoiceResult) => void;
  onIntentParsed?: (intent: VoiceIntent) => void;
  onComponentCreated?: (component: UIComponentDescriptor) => void;
  onComponentRemoved?: (id: string) => void;
  onRuntimeUpdate?: (state: RuntimeWireState) => void;
  onError?: (error: string) => void;
}

/** SDK state */
export interface VoiceToInterfaceState {
  /** Voice engine status */
  voiceStatus: VoiceEngineStatus;
  /** Active components on screen */
  activeComponents: UIComponentDescriptor[];
  /** History of intents */
  intentHistory: VoiceIntent[];
  /** Runtime wire state */
  runtime: RuntimeWireState;
  /** Is the SDK initialized */
  initialized: boolean;
  /** Total commands processed */
  commandCount: number;
}
