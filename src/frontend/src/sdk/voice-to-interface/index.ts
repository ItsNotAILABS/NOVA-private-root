// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: @medina/voice-to-interface-sdk — PUBLIC EXPORTS
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// Speak and the interface builds itself. Voice commands become live UI.
// "Show me a dashboard with sales data" → dashboard appears.
// No code, no drag-and-drop — just talk.
//
// Runtime front-end, runtime back-end, runtime everywhere.
// All AI models, all autonomous AIs, all systems — WIRED.
// ═══════════════════════════════════════════════════════════════════════════════

// ─── The Sovereign SDK ─────────────────────────────────────────────────────────
export { VoiceToInterfaceSDK } from './VoiceToInterfaceSDK';

// ─── Core Engines ──────────────────────────────────────────────────────────────
export { VoiceRecognitionEngine } from './VoiceRecognitionEngine';
export { IntentParser } from './IntentParser';
export { DOMConstructor } from './DOMConstructor';
export { RuntimeWire } from './RuntimeWire';

// ─── Language AI Workers (50 AIs × 3 Engines = 150 Engines) ────────────────────
export {
  LANGUAGE_AI_GROUPS,
  ALL_LANGUAGE_AIS,
  ALL_LANGUAGE_ENGINES,
  getLanguageWorkforceState,
  getLanguageAI,
  getLanguageAIByName,
  getGroupAIs,
  getEnginesByKind,
  getEngineSummary,
} from './LanguageAIWorkers';
export type {
  LanguageGroup,
  EngineKind,
  EngineStatus,
  LanguageEngine,
  LanguageAI,
  LanguageAIGroup,
  LanguageWorkforceState,
} from './LanguageAIWorkers';

// ─── AI Workforce Orchestrator (AGI Build Platform) ────────────────────────────
export {
  BuildOrchestrator,
  PipelineManager,
  TaskRouter,
  GroupCoordinator,
  MemoryBank,
} from './AIWorkforceOrchestrator';
export type {
  PipelineStage,
  AITask,
  TaskResult,
  BuildPipeline,
  PipelineStageEntry,
  MemoryEntry,
  OrchestratorState,
} from './AIWorkforceOrchestrator';

// ─── Multimodal SDK Registry (40 Sovereign SDKs) ──────────────────────────────
export {
  MULTIMODAL_SDKS,
  getSDKsByCategory,
  getSDKById,
  getSDKByPackage,
  getSDKsByInputModality,
  getSDKsByOutputModality,
  getAllModalities,
  getMultimodalSDKRegistryState,
} from './MultimodalSDKRegistry';
export type {
  SDKCategory,
  Modality,
  MultimodalSDK,
  MultimodalSDKRegistryState,
} from './MultimodalSDKRegistry';

// ─── Types ─────────────────────────────────────────────────────────────────────
export type {
  // Voice types
  VoiceResult,
  VoiceEngineStatus,
  VoiceConfig,
  VoiceEngineCallbacks,
  // Intent types
  VoiceIntent,
  IntentAction,
  UIComponentKind,
  ChartKind,
  LayoutStrategy,
  ColorTheme,
  DataDomain,
  // DOM types
  UIComponentDescriptor,
  LayoutConfig,
  DataBinding,
  AnimationConfig,
  EntranceAnimation,
  DataTransformKind,
  // Runtime types
  RuntimeModel,
  RuntimeModelFamily,
  RuntimeModelStatus,
  RuntimeDataSource,
  RuntimeField,
  RuntimeWireState,
  // SDK types
  VoiceToInterfaceConfig,
  VoiceToInterfaceState,
  SDKCallbacks,
} from './types';

// ─── Constants ─────────────────────────────────────────────────────────────────
export {
  PHI,
  PHI_INV,
  SCHUMANN_HZ,
  SOVEREIGN_FLOOR,
  VOICE_CONFIDENCE_THRESHOLD,
  ANIMATION_DURATION_MS,
  GRID_GAP_PX,
  RUNTIME_HEARTBEAT_MS,
} from './types';
