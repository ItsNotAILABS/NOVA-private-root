// ═══════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// Module: canister/parallaxActor.ts — REAL Canister Connection to PARALLAX
// Language: TypeScript (CPL: typed JS layer over ICP agent)
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// THIS FILE CONNECTS THE FRONTEND TO THE REAL phantom_transfer CANISTER.
// NO MOCKS. NO FAKES. REAL CANISTER CALLS.
// Functions match phantom_transfer/main.mo Build №35 exactly.
// ═══════════════════════════════════════════════════════════════════════════

import { Actor, HttpAgent, type ActorSubclass } from '@dfinity/agent';
import { IDL } from '@dfinity/candid';

// ── Canister ID resolution ────────────────────────────────────────────────
const getParallaxCanisterId = (): string => {
  if (typeof import.meta !== 'undefined' && import.meta.env?.VITE_PARALLAX_CANISTER_ID) {
    return import.meta.env.VITE_PARALLAX_CANISTER_ID as string;
  }
  if (typeof process !== 'undefined' && process.env?.PARALLAX_CANISTER_ID) {
    return process.env.PARALLAX_CANISTER_ID as string;
  }
  // Local dfx default — phantom_transfer gets this ID in local replica
  return 'br5f7-7uaaa-aaaaa-qaaca-cai';
};

const getHost = (): string => {
  if (typeof import.meta !== 'undefined' && import.meta.env?.VITE_IC_HOST) {
    return import.meta.env.VITE_IC_HOST as string;
  }
  // Local dfx replica
  return 'http://127.0.0.1:8000';
};

// ── TypeScript types matching phantom_transfer/main.mo exactly ───────────

export interface ClearinghouseStatus {
  buildNumber:          bigint;
  sovereignSeal:        string;
  totalTransfers:       bigint;
  totalTransfersSettled: bigint;
  totalTransfersCancelled: bigint;
  totalFiatIngested:    bigint;
  totalFeesCollected:   bigint;
  totalPhantomCommits:  bigint;
  liquidityPool:        bigint;
  liquidityPoolGroup:   string;
  groupENeurons:        bigint;
  registeredUsers:      bigint;
  linkedAccountsTotal:  bigint;
  claimsGenerated:      bigint;
  claimsRedeemed:       bigint;
  claimsExpired:        bigint;
  exitsQueued:          bigint;
  exitsDelivered:       bigint;
  totalRemittances:     bigint;
  authorizedOracles:    bigint;
  supportedRails:       string[];
  supportedCurrencies:  string[];
  architectureStatement: string;
}

export interface ExchangeRate {
  currency:    string;
  ratePerCent: bigint;
  updatedBy:   string;
  updatedAt:   bigint;
}

export interface UserProfile {
  principal:         string;
  tier:              bigint;
  onesicansBalance:  bigint;
  registeredAt:      bigint;
  label:             string;
}

export interface LinkedAccount {
  id:          bigint;
  railType:    string;   // BANK_ACH | BANK_SPEI | CARD_VISA | WALLET_BTC | etc.
  ref:         string;   // tokenized routing ref
  currency:    string;
  balanceCents: bigint;
  label:       string;
  linkedAt:    bigint;
}

export interface QueuedExit {
  exitId:         bigint;
  userPrincipal:  string;
  amountOnesican: bigint;
  amountFiat:     bigint;
  targetCurrency: string;
  exitRail:       string;
  destRef:        string;
  status:         string;
  createdAt:      bigint;
  deliveredAt:    bigint;
  note:           string;
}

export interface ClaimLink {
  claimCode:   string;
  amountOnesican: bigint;
  currency:    string;
  sender:      string;
  createdAt:   bigint;
  expiresAt:   bigint;
  status:      string;
  redeemMethod: string;
  redeemRef:   string;
  note:        string;
}

export interface IngestFiatResult {
  success:         boolean;
  txId:            bigint;
  onesicansGranted: bigint;
  novaPesoMinted:  bigint;
  fee:             bigint;
  message:         string;
}

export interface RemittanceResult {
  success:        boolean;
  txId:           bigint;
  exitId:         bigint;
  claimCode:      string;
  fiatIn:         bigint;
  onesicansNet:   bigint;
  fiatOut:        bigint;
  fee:            bigint;
  message:        string;
}

export interface ExitFiatResult {
  success:    boolean;
  exitId:     bigint;
  fiatAmount: bigint;
  message:    string;
}

export interface ClaimResult {
  success:    boolean;
  claimCode:  string;
  amountOnesican: bigint;
  expiresAt:  bigint;
  message:    string;
}

export interface RedeemResult {
  success:   boolean;
  exitId:    bigint;
  fiatAmount: bigint;
  message:   string;
}

export interface RegisterResult {
  success:   boolean;
  message:   string;
  tier:      bigint;
}

export interface LinkAccountResult {
  success:   boolean;
  accountId: bigint;
  message:   string;
}

// ── IDL Factory — matches phantom_transfer/main.mo public interface ────────
// This is the Candid IDL defined in TypeScript using @dfinity/candid.
// Only the functions used by the PWA are included (query/update distinction).
const idlFactory = ({ IDL: I }: { IDL: typeof IDL }): IDL.ServiceClass => {
  // Return types
  const ClearinghouseStatusT = I.Record({
    buildNumber:           I.Nat,
    sovereignSeal:         I.Text,
    totalTransfers:        I.Nat,
    totalTransfersSettled: I.Nat,
    totalTransfersCancelled: I.Nat,
    totalFiatIngested:     I.Nat,
    totalFeesCollected:    I.Nat,
    totalPhantomCommits:   I.Nat,
    liquidityPool:         I.Nat,
    liquidityPoolGroup:    I.Text,
    groupENeurons:         I.Nat,
    registeredUsers:       I.Nat,
    linkedAccountsTotal:   I.Nat,
    claimsGenerated:       I.Nat,
    claimsRedeemed:        I.Nat,
    claimsExpired:         I.Nat,
    exitsQueued:           I.Nat,
    exitsDelivered:        I.Nat,
    totalRemittances:      I.Nat,
    authorizedOracles:     I.Nat,
    supportedRails:        I.Vec(I.Text),
    supportedCurrencies:   I.Vec(I.Text),
    architectureStatement: I.Text,
  });
  const ExchangeRateT = I.Record({
    currency:    I.Text,
    ratePerCent: I.Nat,
    updatedBy:   I.Text,
    updatedAt:   I.Int,
  });
  const IngestFiatT = I.Record({
    success:          I.Bool,
    txId:             I.Nat,
    onesicansGranted: I.Nat,
    novaPesoMinted:   I.Nat,
    fee:              I.Nat,
    message:          I.Text,
  });
  const RemittanceT = I.Record({
    success:      I.Bool,
    txId:         I.Nat,
    exitId:       I.Nat,
    claimCode:    I.Text,
    fiatIn:       I.Nat,
    onesicansNet: I.Nat,
    fiatOut:      I.Nat,
    fee:          I.Nat,
    message:      I.Text,
  });
  const ExitFiatT = I.Record({
    success:    I.Bool,
    exitId:     I.Nat,
    fiatAmount: I.Nat,
    message:    I.Text,
  });
  const RegisterT = I.Record({
    success: I.Bool,
    message: I.Text,
    tier:    I.Nat,
  });
  const LinkAccountT = I.Record({
    success:   I.Bool,
    accountId: I.Nat,
    message:   I.Text,
  });
  const ClaimResultT = I.Record({
    success:        I.Bool,
    claimCode:      I.Text,
    amountOnesican: I.Nat,
    expiresAt:      I.Int,
    message:        I.Text,
  });
  const RedeemResultT = I.Record({
    success:    I.Bool,
    exitId:     I.Nat,
    fiatAmount: I.Nat,
    message:    I.Text,
  });
  const QueuedExitT = I.Record({
    exitId:         I.Nat,
    userPrincipal:  I.Text,
    amountOnesican: I.Nat,
    amountFiat:     I.Nat,
    targetCurrency: I.Text,
    exitRail:       I.Text,
    destRef:        I.Text,
    status:         I.Text,
    createdAt:      I.Int,
    deliveredAt:    I.Int,
    note:           I.Text,
  });

  return I.Service({
    // ── QUERIES (read-only, fast) ────────────────────────────────────────
    getClearinghouseStatus: I.Func([], [ClearinghouseStatusT], ['query']),
    getExchangeRates:       I.Func([], [I.Vec(ExchangeRateT)], ['query']),
    getQueuedExits:         I.Func([I.Nat], [I.Vec(QueuedExitT)], ['query']),
    getRailStatus:          I.Func([I.Text], [I.Record({ rail: I.Text, volume: I.Nat, count: I.Nat, avgFee: I.Nat })], ['query']),

    // ── UPDATES (state-changing calls) ───────────────────────────────────
    registerUser:       I.Func([I.Text], [RegisterT], []),
    linkAccount:        I.Func([I.Text, I.Text, I.Text, I.Nat, I.Text], [LinkAccountT], []),
    ingestFiatPayment:  I.Func([I.Text, I.Nat, I.Text, I.Text], [IngestFiatT], []),
    exitToFiat:         I.Func([I.Nat, I.Text, I.Text, I.Text, I.Text], [ExitFiatT], []),
    sendRemittance:     I.Func([I.Text, I.Nat, I.Text, I.Text, I.Text, I.Text, I.Text], [RemittanceT], []),
    generateClaimLink:  I.Func([I.Nat, I.Text, I.Text, I.Text], [ClaimResultT], []),
    redeemClaimLink:    I.Func([I.Text, I.Text, I.Text], [RedeemResultT], []),
  });
};

// ── Actor singleton ───────────────────────────────────────────────────────
let _agent:  HttpAgent  | null = null;
let _actor: ActorSubclass<Record<string, unknown>> | null = null;

export function getParallaxAgent(): HttpAgent {
  if (!_agent) {
    _agent = new HttpAgent({ host: getHost() });
    // For local development: fetch root key (don't do this in production)
    if (getHost().includes('127.0.0.1') || getHost().includes('localhost')) {
      _agent.fetchRootKey().catch(console.warn);
    }
  }
  return _agent;
}

export function getParallaxActor(): ActorSubclass<Record<string, unknown>> {
  if (!_actor) {
    _actor = Actor.createActor(idlFactory, {
      agent:      getParallaxAgent(),
      canisterId: getParallaxCanisterId(),
    });
  }
  return _actor;
}

// ── Typed call wrappers ───────────────────────────────────────────────────

export async function parallax_getClearinghouseStatus(): Promise<ClearinghouseStatus> {
  const actor = getParallaxActor();
  return (await (actor.getClearinghouseStatus as () => Promise<ClearinghouseStatus>)());
}

export async function parallax_getExchangeRates(): Promise<ExchangeRate[]> {
  const actor = getParallaxActor();
  return (await (actor.getExchangeRates as () => Promise<ExchangeRate[]>)());
}

export async function parallax_getQueuedExits(limit: number): Promise<QueuedExit[]> {
  const actor = getParallaxActor();
  return (await (actor.getQueuedExits as (l: bigint) => Promise<QueuedExit[]>)(
    BigInt(limit)
  ));
}

export async function parallax_registerUser(label: string): Promise<RegisterResult> {
  const actor = getParallaxActor();
  return (await (actor.registerUser as (l: string) => Promise<RegisterResult>)(label));
}

export async function parallax_linkAccount(
  railType: string, ref: string, currency: string, balanceCents: number, label: string
): Promise<LinkAccountResult> {
  const actor = getParallaxActor();
  return (await (actor.linkAccount as (
    rt: string, r: string, c: string, b: bigint, l: string
  ) => Promise<LinkAccountResult>)(railType, ref, currency, BigInt(balanceCents), label));
}

export async function parallax_ingestFiatPayment(
  currency: string, amountCents: number, paymentRef: string, note: string
): Promise<IngestFiatResult> {
  const actor = getParallaxActor();
  return (await (actor.ingestFiatPayment as (
    c: string, a: bigint, p: string, n: string
  ) => Promise<IngestFiatResult>)(currency, BigInt(amountCents), paymentRef, note));
}

export async function parallax_sendRemittance(
  fromCurrency: string, amountCents: number, fromCardRef: string,
  toCurrency: string, toRef: string, toRefType: string, note: string
): Promise<RemittanceResult> {
  const actor = getParallaxActor();
  return (await (actor.sendRemittance as (
    fc: string, ac: bigint, cr: string, tc: string, tr: string, trt: string, n: string
  ) => Promise<RemittanceResult>)(
    fromCurrency, BigInt(amountCents), fromCardRef,
    toCurrency, toRef, toRefType, note
  ));
}

export async function parallax_exitToFiat(
  amountOnesicans: number, targetCurrency: string,
  exitRail: string, destinationRef: string, note: string
): Promise<ExitFiatResult> {
  const actor = getParallaxActor();
  return (await (actor.exitToFiat as (
    a: bigint, tc: string, r: string, d: string, n: string
  ) => Promise<ExitFiatResult>)(
    BigInt(amountOnesicans), targetCurrency, exitRail, destinationRef, note
  ));
}

export async function parallax_generateClaimLink(
  amountOnesicans: number, currency: string, redeemMethod: string, note: string
): Promise<ClaimResult> {
  const actor = getParallaxActor();
  return (await (actor.generateClaimLink as (
    a: bigint, c: string, rm: string, n: string
  ) => Promise<ClaimResult>)(BigInt(amountOnesicans), currency, redeemMethod, note));
}

export async function parallax_redeemClaimLink(
  claimCode: string, redeemMethod: string, redeemRef: string
): Promise<RedeemResult> {
  const actor = getParallaxActor();
  return (await (actor.redeemClaimLink as (
    cc: string, rm: string, rr: string
  ) => Promise<RedeemResult>)(claimCode, redeemMethod, redeemRef));
}
