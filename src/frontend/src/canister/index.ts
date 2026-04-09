// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: canister/index.ts — Canister Connection Exports
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ═══════════════════════════════════════════════════════════════════════════════

export {
  connectSwarmBrain,
  getSwarmBrainActor,
  isConnectedToBackend,
  disconnectSwarmBrain,
  fetchSwarmSnapshot,
  fetchExtendedSnapshot,
  fetchOrganismState,
  fetchGeoResonanceProtectionState,
  triggerTick,
  triggerHeartbeat,
  setArchitectSignal,
  type SwarmSnapshot,
  type SwarmQMetrics,
  type TickResult,
  type OrganismState,
  type ExtendedSnapshot,
  type GeoResonanceProtectionState,
  type SwarmBrainActor,
} from './swarmBrainActor';

export { default as swarmBrain } from './swarmBrainActor';
