// ═══════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// Module: canister/novaBuilderActor.ts — NOVA BUILDER Canister Connection
// Language: TypeScript (CPL: typed JS layer over ICP agent)
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// Connects the CPL frontend to the nova_builder canister (Build №42).
// Functions match nova_builder/main.mo exactly.
// ═══════════════════════════════════════════════════════════════════════════

import { Actor, HttpAgent, type ActorSubclass } from '@dfinity/agent';
import { IDL } from '@dfinity/candid';

// ── Canister ID resolution ────────────────────────────────────────────────
const getNovaBuilderCanisterId = (): string => {
  if (typeof import.meta !== 'undefined' && import.meta.env?.VITE_NOVA_BUILDER_CANISTER_ID) {
    return import.meta.env.VITE_NOVA_BUILDER_CANISTER_ID as string;
  }
  if (typeof process !== 'undefined' && process.env?.NOVA_BUILDER_CANISTER_ID) {
    return process.env.NOVA_BUILDER_CANISTER_ID as string;
  }
  // Local dfx default — set VITE_NOVA_BUILDER_CANISTER_ID env var for production
  return 'bkyz2-fmaaa-aaaaa-qaaaq-cai';
};

const getHost = (): string => {
  if (typeof import.meta !== 'undefined' && import.meta.env?.VITE_IC_HOST) {
    return import.meta.env.VITE_IC_HOST as string;
  }
  return 'http://127.0.0.1:8000';
};

// ── TypeScript types matching nova_builder/main.mo exactly ───────────────

export type BuildStatus =
  | { QUEUED: null }
  | { GENERATING: null }
  | { GENERATED: null }
  | { DEPLOYING: null }
  | { DEPLOYED: null }
  | { FAILED: null };

export interface BuildSession {
  sessionId:      string;
  intent:         string;
  status:         BuildStatus;
  generatedCode:  string;
  deployAddress:  string;
  cyclesConsumed: bigint;
  tier:           bigint;
  submittedAt:    bigint;
  completedAt:    bigint;
  errorMsg:       string;
}

export interface BuildSummary {
  sessionId:      string;
  intent:         string;
  status:         BuildStatus;
  deployAddress:  string;
  cyclesConsumed: bigint;
  completedAt:    bigint;
}

export interface BuilderStatus {
  buildNumber:       bigint;
  sovereignSeal:     string;
  totalBuilds:       bigint;
  totalDeployed:     bigint;
  totalFailed:       bigint;
  totalCyclesBurned: bigint;
  subsidyPoolBalance: bigint;
  cyclesPerBuild:    bigint;
  subsidyThreshold:  bigint;
  queueDepth:        bigint;
  openToBuilders:    boolean;
  missionStatement:  string;
  uptimeNs:          bigint;
}

// ── IDL definition matching nova_builder/main.mo ──────────────────────────
const BuildStatusIDL = IDL.Variant({
  QUEUED:     IDL.Null,
  GENERATING: IDL.Null,
  GENERATED:  IDL.Null,
  DEPLOYING:  IDL.Null,
  DEPLOYED:   IDL.Null,
  FAILED:     IDL.Null,
});

const BuildSessionIDL = IDL.Record({
  sessionId:      IDL.Text,
  intent:         IDL.Text,
  status:         BuildStatusIDL,
  generatedCode:  IDL.Text,
  deployAddress:  IDL.Text,
  cyclesConsumed: IDL.Nat,
  tier:           IDL.Nat,
  submittedAt:    IDL.Int,
  completedAt:    IDL.Int,
  errorMsg:       IDL.Text,
});

const BuildSummaryIDL = IDL.Record({
  sessionId:      IDL.Text,
  intent:         IDL.Text,
  status:         BuildStatusIDL,
  deployAddress:  IDL.Text,
  cyclesConsumed: IDL.Nat,
  completedAt:    IDL.Int,
});

const BuilderStatusIDL = IDL.Record({
  buildNumber:       IDL.Nat,
  sovereignSeal:     IDL.Text,
  totalBuilds:       IDL.Nat,
  totalDeployed:     IDL.Nat,
  totalFailed:       IDL.Nat,
  totalCyclesBurned: IDL.Nat,
  subsidyPoolBalance: IDL.Nat,
  cyclesPerBuild:    IDL.Nat,
  subsidyThreshold:  IDL.Nat,
  queueDepth:        IDL.Nat,
  openToBuilders:    IDL.Bool,
  missionStatement:  IDL.Text,
  uptimeNs:          IDL.Int,
});

const novaBuilderIdl = ({ IDL: _IDL }: { IDL: typeof IDL }) => {
  const BuildStatus = BuildStatusIDL;
  return _IDL.Service({
    // Public
    submitBuild:       _IDL.Func([_IDL.Text], [_IDL.Text], []),
    getBuildSession:   _IDL.Func([_IDL.Text], [_IDL.Opt(BuildSessionIDL)], ['query']),
    getBuilderStatus:  _IDL.Func([], [BuilderStatusIDL], ['query']),
    getRecentBuilds:   _IDL.Func([_IDL.Nat], [_IDL.Vec(BuildSummaryIDL)], ['query']),
    getQueueDepth:     _IDL.Func([], [_IDL.Nat], ['query']),
    donateCycles:      _IDL.Func([], [_IDL.Text], []),
    diagnostics:       _IDL.Func([], [_IDL.Text], ['query']),
    getNoDropLaw:      _IDL.Func([], [_IDL.Text], ['query']),
    getSeal:           _IDL.Func([], [_IDL.Text], ['query']),
    isLocked:          _IDL.Func([], [_IDL.Bool], ['query']),
    getRateLimitTier:  _IDL.Func([], [_IDL.Record({
      tier: _IDL.Text,
      batchSize: _IDL.Nat,
      poolPct: _IDL.Nat,
    })], ['query']),
    getTotalDonated:   _IDL.Func([], [_IDL.Nat], ['query']),
    getHeartbeatTick:  _IDL.Func([], [_IDL.Nat], ['query']),
    getBrainCanister:  _IDL.Func([], [_IDL.Text], ['query']),
    getFactoryCanister: _IDL.Func([], [_IDL.Text], ['query']),
    // Admin
    claimBuilder:      _IDL.Func([], [_IDL.Text], []),
    creditPool:        _IDL.Func([_IDL.Nat], [_IDL.Text], []),
    setStreamCanister: _IDL.Func([_IDL.Text], [_IDL.Text], []),
    setBrainCanister:  _IDL.Func([_IDL.Text], [_IDL.Text], []),
    setFactoryCanister: _IDL.Func([_IDL.Text], [_IDL.Text], []),
    setSubsidyThreshold: _IDL.Func([_IDL.Nat], [_IDL.Text], []),
    setCyclesPerBuild: _IDL.Func([_IDL.Nat], [_IDL.Text], []),
    markBuildGenerating: _IDL.Func([_IDL.Text], [_IDL.Text], []),
    markBuildComplete:   _IDL.Func([_IDL.Text, _IDL.Text], [_IDL.Text], []),
    markBuildDeploying:  _IDL.Func([_IDL.Text], [_IDL.Text], []),
    markBuildDeployed:   _IDL.Func([_IDL.Text, _IDL.Text], [_IDL.Text], []),
    markBuildFailed:     _IDL.Func([_IDL.Text, _IDL.Text], [_IDL.Text], []),
  });
};

// ── Actor type ────────────────────────────────────────────────────────────
export type NovaBuilderActor = ActorSubclass<{
  submitBuild(intent: string): Promise<string>;
  getBuildSession(sessionId: string): Promise<[BuildSession] | []>;
  getBuilderStatus(): Promise<BuilderStatus>;
  getRecentBuilds(n: bigint): Promise<BuildSummary[]>;
  getQueueDepth(): Promise<bigint>;
  donateCycles(): Promise<string>;
  diagnostics(): Promise<string>;
  getNoDropLaw(): Promise<string>;
  getSeal(): Promise<string>;
  isLocked(): Promise<boolean>;
  getRateLimitTier(): Promise<{ tier: string; batchSize: bigint; poolPct: bigint }>;
  getTotalDonated(): Promise<bigint>;
  getHeartbeatTick(): Promise<bigint>;
  getBrainCanister(): Promise<string>;
  getFactoryCanister(): Promise<string>;
  claimBuilder(): Promise<string>;
  creditPool(amount: bigint): Promise<string>;
  setStreamCanister(p: string): Promise<string>;
  setBrainCanister(p: string): Promise<string>;
  setFactoryCanister(p: string): Promise<string>;
}>;

// ── Factory ───────────────────────────────────────────────────────────────
let _actorCache: NovaBuilderActor | null = null;

export function getNovaBuilderActor(): NovaBuilderActor {
  if (_actorCache) return _actorCache;
  const agent = new HttpAgent({ host: getHost() });
  // Only fetch root key in local/dev mode
  if (getHost().includes('127.0.0.1') || getHost().includes('localhost')) {
    agent.fetchRootKey().catch(() => {/* ignore in non-local */});
  }
  _actorCache = Actor.createActor(novaBuilderIdl, {
    agent,
    canisterId: getNovaBuilderCanisterId(),
  }) as NovaBuilderActor;
  return _actorCache;
}

// ── Convenience: status label from BuildStatus variant ───────────────────
export function buildStatusLabel(status: BuildStatus): string {
  if ('QUEUED'     in status) return 'QUEUED';
  if ('GENERATING' in status) return 'GENERATING';
  if ('GENERATED'  in status) return 'GENERATED';
  if ('DEPLOYING'  in status) return 'DEPLOYING';
  if ('DEPLOYED'   in status) return 'DEPLOYED';
  if ('FAILED'     in status) return 'FAILED';
  return 'UNKNOWN';
}

export function buildStatusColor(status: BuildStatus): string {
  if ('QUEUED'     in status) return '#4af';
  if ('GENERATING' in status) return '#fa0';
  if ('GENERATED'  in status) return '#0cf';
  if ('DEPLOYING'  in status) return '#f8f';
  if ('DEPLOYED'   in status) return '#4f4';
  if ('FAILED'     in status) return '#f44';
  return '#888';
}
