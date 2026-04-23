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
