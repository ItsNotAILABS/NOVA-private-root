// ═══════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// Module: canister/skyhiGroupActor.ts — REAL Canister Connection to SKYHI_GROUP
// Language: TypeScript (CPL: typed JS layer over ICP agent)
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// THIS FILE CONNECTS THE FRONTEND TO THE REAL skyhi_group CANISTER.
// NO MOCKS. NO FAKES. REAL CANISTER CALLS.
// Functions match skyhi_group/main.mo Build №49 exactly.
// ═══════════════════════════════════════════════════════════════════════════

import { Actor, HttpAgent, type ActorSubclass } from '@dfinity/agent';
import { IDL } from '@dfinity/candid';

// ── Canister ID resolution ────────────────────────────────────────────────
const getSkyHiCanisterId = (): string => {
  if (typeof import.meta !== 'undefined' && import.meta.env?.VITE_SKYHI_CANISTER_ID) {
    return import.meta.env.VITE_SKYHI_CANISTER_ID as string;
  }
  if (typeof process !== 'undefined' && process.env?.SKYHI_CANISTER_ID) {
    return process.env.SKYHI_CANISTER_ID as string;
  }
  // Local dfx default replica ID for skyhi_group canister.
  // PRODUCTION: set VITE_SKYHI_CANISTER_ID env var to the mainnet canister ID
  // before deploying. Never ship this default ID to mainnet.
  return 'b77ix-eeaaa-aaaaa-qaada-cai';
};

const getHost = (): string => {
  if (typeof import.meta !== 'undefined' && import.meta.env?.VITE_IC_HOST) {
    return import.meta.env.VITE_IC_HOST as string;
  }
  return 'http://127.0.0.1:8000';
};

// ── TypeScript types matching skyhi_group/main.mo exactly ────────────────

export interface SkyHiStatus {
  buildNumber:       bigint;
  client:            string;
  sovereignSeal:     string;
  piiVaultSize:      bigint;
  activeSessions:    bigint;
  totalMemberships:  bigint;
  honeypotCount:     bigint;
  honeypotTriggered: bigint;
  canaryCount:       bigint;
  canaryTriggered:   bigint;
  threatsDetected:   bigint;
  threatsBlocked:    bigint;
  paymentsRouted:    bigint;
  feesCollected:     bigint;
  agiQueries:        bigint;
  translations:      bigint;
  predictions:       bigint;
  connections:       bigint;
  selfHealingEvents: bigint;
  tick:              bigint;
  lastHealthScore:   number;
}

export interface HealthCheck {
  tick:                bigint;
  agiLatencyOk:       boolean;
  encryptionOk:       boolean;
  bookingConversionOk: boolean;
  socialCoherenceOk:  boolean;
  canaryIntegrityOk:  boolean;
  overallScore:       number;
}

export interface AuditEntry {
  id:        bigint;
  timestamp: bigint;
  principal: string;
  action:    string;
  resource:  string;
  outcome:   { allowed: null } | { denied: null } | { flagged: null };
}

// ── IDL Factory (Candid interface) ────────────────────────────────────────
const idlFactory = ({ IDL: idl }: { IDL: typeof IDL }) => {
  const MembershipTier = idl.Variant({
    free:      idl.Null,
    basic:     idl.Null,
    premium:   idl.Null,
    sovereign: idl.Null,
  });

  const DocType = idl.Variant({
    passport:       idl.Null,
    driverLicense:  idl.Null,
    nationalId:     idl.Null,
    visa:           idl.Null,
  });

  const Rail = idl.Variant({
    fiat:     idl.Null,
    internal: idl.Null,
    crypto:   idl.Null,
    phantom:  idl.Null,
  });

  const ThreatCategory = idl.Variant({
    anomaly:         idl.Null,
    bot:             idl.Null,
    accountTakeover: idl.Null,
    honeypotTrip:    idl.Null,
    canaryLeak:      idl.Null,
    ddos:            idl.Null,
    injection:       idl.Null,
  });

  const OkErrNat  = idl.Variant({ ok: idl.Nat, err: idl.Text });
  const OkErrText = idl.Variant({ ok: idl.Text, err: idl.Text });
  const OkErrFloat = idl.Variant({ ok: idl.Float64, err: idl.Text });

  const Outcome = idl.Variant({
    allowed: idl.Null,
    denied:  idl.Null,
    flagged: idl.Null,
  });

  const AuditEntry = idl.Record({
    id:        idl.Nat,
    timestamp: idl.Int,
    principal: idl.Principal,
    action:    idl.Text,
    resource:  idl.Text,
    outcome:   Outcome,
  });

  const HealthCheck = idl.Record({
    tick:                idl.Nat,
    agiLatencyOk:       idl.Bool,
    encryptionOk:       idl.Bool,
    bookingConversionOk: idl.Bool,
    socialCoherenceOk:  idl.Bool,
    canaryIntegrityOk:  idl.Bool,
    overallScore:       idl.Float64,
  });

  const SkyHiStatus = idl.Record({
    buildNumber:       idl.Nat,
    client:            idl.Text,
    sovereignSeal:     idl.Text,
    piiVaultSize:      idl.Nat,
    activeSessions:    idl.Nat,
    totalMemberships:  idl.Nat,
    honeypotCount:     idl.Nat,
    honeypotTriggered: idl.Nat,
    canaryCount:       idl.Nat,
    canaryTriggered:   idl.Nat,
    threatsDetected:   idl.Nat,
    threatsBlocked:    idl.Nat,
    paymentsRouted:    idl.Nat,
    feesCollected:     idl.Nat,
    agiQueries:        idl.Nat,
    translations:      idl.Nat,
    predictions:       idl.Nat,
    connections:       idl.Nat,
    selfHealingEvents: idl.Nat,
    tick:              idl.Nat,
    lastHealthScore:   idl.Float64,
  });

  return idl.Service({
    claimSkyHi:             idl.Func([], [], []),
    registerPIIProof:       idl.Func([idl.Text, DocType, idl.Text], [OkErrNat], []),
    verifyPIIProof:         idl.Func([idl.Text], [idl.Bool], []),
    createSession:          idl.Func([idl.Text, MembershipTier, idl.Text], [OkErrNat], []),
    revokeSession:          idl.Func([idl.Text], [idl.Bool], []),
    validateSession:        idl.Func([idl.Text], [idl.Bool], ['query']),
    seedHoneypot:           idl.Func([idl.Text, idl.Nat], [OkErrNat], []),
    triggerHoneypot:        idl.Func([idl.Nat], [idl.Bool], []),
    deployCanary:           idl.Func([idl.Text, idl.Text], [OkErrNat], []),
    reportCanaryLeak:       idl.Func([idl.Text, idl.Text], [idl.Bool], []),
    reportThreat:           idl.Func([ThreatCategory, idl.Nat, idl.Text], [idl.Nat], []),
    routePayment:           idl.Func([Rail, idl.Nat, idl.Text], [OkErrNat], []),
    queryTravelAssistant:   idl.Func([idl.Text], [OkErrText], []),
    requestTranslation:     idl.Func([idl.Text, idl.Text, idl.Text], [OkErrText], []),
    predictFlightDemand:    idl.Func([idl.Text, idl.Text], [OkErrText], []),
    scoreSocialConnection:  idl.Func([idl.Text, idl.Text], [OkErrFloat], []),
    heartbeat:              idl.Func([], [], []),
    getSkyHiStatus:         idl.Func([], [SkyHiStatus], ['query']),
    getLastHealthCheck:     idl.Func([], [idl.Opt(HealthCheck)], ['query']),
    getAuditLog:            idl.Func([], [idl.Vec(AuditEntry)], ['query']),
    diagnostics:            idl.Func([], [idl.Text], ['query']),
  });
};

// ── Actor creation ────────────────────────────────────────────────────────
let _actor: ActorSubclass<Record<string, (...args: unknown[]) => Promise<unknown>>> | null = null;

export async function getSkyHiActor() {
  if (_actor) return _actor;

  const agent = await HttpAgent.create({ host: getHost() });

  // Fetch root key in local development only
  if (getHost().includes('127.0.0.1') || getHost().includes('localhost')) {
    await agent.fetchRootKey();
  }

  _actor = Actor.createActor(idlFactory, {
    agent,
    canisterId: getSkyHiCanisterId(),
  });

  return _actor;
}
