// ═══════════════════════════════════════════════════════════════════════════
// DALLAS ISD CANISTER — Actor (Build №43)
// Language: CPL (TypeScript + @dfinity/agent)
// Frontend connection to dallas_isd sovereign curriculum backend.
// Medina Tech · Alfredo Medina Hernandez · Dallas TX · 2026
// ═══════════════════════════════════════════════════════════════════════════

import { Actor, HttpAgent, type ActorSubclass } from '@dfinity/agent';
import { IDL } from '@dfinity/candid';

const getCanisterId = (): string => {
  if (typeof import.meta !== 'undefined' && import.meta.env?.VITE_DALLAS_ISD_CANISTER_ID)
    return import.meta.env.VITE_DALLAS_ISD_CANISTER_ID as string;
  if (typeof process !== 'undefined' && process.env?.DALLAS_ISD_CANISTER_ID)
    return process.env.DALLAS_ISD_CANISTER_ID as string;
  return 'bkyz2-fmaaa-aaaaa-qaaao-cai'; // local dev placeholder
};

const getHost = (): string => {
  if (typeof import.meta !== 'undefined' && import.meta.env?.VITE_IC_HOST)
    return import.meta.env.VITE_IC_HOST as string;
  return 'http://127.0.0.1:8000';
};

// ── TypeScript types matching dallas_isd/main.mo exactly ─────────────────

export interface TEKSConceptSummary {
  conceptId : string;
  title     : string;
  teksGrade : string;
  mathDepth : bigint;
}

export interface TEKSConceptFull {
  subject      : string;
  title        : string;
  teksGrade    : string;
  teksStandard : string;
  description  : string;
  activity     : string;
  materials    : string;
  duration     : string;
  grants       : string;
  mathDepth    : bigint;
  physicsDepth : bigint;
}

export interface ConceptContent {
  text    : string;
  formula : string;
  physics : string;
}

export interface GrantEntry {
  name     : string;
  agency   : string;
  amount   : string;
  eligible : string;
  use_     : string;
  align    : string;
}

export interface MathEngine {
  phi        : number;
  phiInv     : number;
  phiSq      : number;
  phiCube    : number;
  phi4       : number;
  phi_inv2   : number;
  feigenbaum : number;
  isingBeta  : number;
  schumann   : number;
  heartbeat  : bigint;
  fib        : bigint[];
  kuramotoKc : number;
}

export interface ClassroomStatus {
  conceptCount     : bigint;
  contentCount     : bigint;
  grantCount       : bigint;
  schoolCount      : bigint;
  totalEngagements : bigint;
  heartbeatTick    : bigint;
  sovereignSeal    : string;
  genesisBootDone  : boolean;
  phi              : number;
  heartbeatMs      : bigint;
}

// ── Candid IDL ─────────────────────────────────────────────────────────────

const idlFactory = ({ IDL: I }: { IDL: typeof IDL }) => {
  const ConceptSummary = I.Record({
    conceptId: I.Text,
    title:     I.Text,
    teksGrade: I.Text,
    mathDepth: I.Nat,
  });

  const ConceptFull = I.Record({
    subject:      I.Text,
    title:        I.Text,
    teksGrade:    I.Text,
    teksStandard: I.Text,
    description:  I.Text,
    activity:     I.Text,
    materials:    I.Text,
    duration:     I.Text,
    grants:       I.Text,
    mathDepth:    I.Nat,
    physicsDepth: I.Nat,
  });

  const Content = I.Record({
    text:    I.Text,
    formula: I.Text,
    physics: I.Text,
  });

  const Grant = I.Record({
    name:     I.Text,
    agency:   I.Text,
    amount:   I.Text,
    eligible: I.Text,
    use_:     I.Text,
    align:    I.Text,
  });

  const MathEng = I.Record({
    phi:        I.Float64,
    phiInv:     I.Float64,
    phiSq:      I.Float64,
    phiCube:    I.Float64,
    phi4:       I.Float64,
    phi_inv2:   I.Float64,
    feigenbaum: I.Float64,
    isingBeta:  I.Float64,
    schumann:   I.Float64,
    heartbeat:  I.Nat,
    fib:        I.Vec(I.Nat),
    kuramotoKc: I.Float64,
  });

  const Status = I.Record({
    conceptCount:     I.Nat,
    contentCount:     I.Nat,
    grantCount:       I.Nat,
    schoolCount:      I.Nat,
    totalEngagements: I.Nat,
    heartbeatTick:    I.Nat,
    sovereignSeal:    I.Text,
    genesisBootDone:  I.Bool,
    phi:              I.Float64,
    heartbeatMs:      I.Nat,
  });

  const BootResult = I.Record({ ok: I.Bool, conceptsLoaded: I.Nat });
  const EngResult  = I.Record({ ok: I.Bool, engagements:    I.Nat });

  return I.Service({
    // Curriculum queries
    getConcept         : I.Func([I.Text], [I.Opt(ConceptFull)], ['query']),
    getAllConcepts      : I.Func([I.Text], [I.Vec(ConceptSummary)], ['query']),
    getConceptContent  : I.Func([I.Text], [I.Opt(Content)], ['query']),

    // Grant manifest
    getGrantManifest   : I.Func([], [I.Vec(Grant)], ['query']),

    // Math engine
    getMathEngine      : I.Func([], [MathEng], ['query']),

    // School engagement
    recordEngagement   : I.Func([I.Text, I.Text, I.Text], [EngResult], []),
    getTotalEngagements: I.Func([], [I.Nat], ['query']),

    // Status
    getClassroomStatus : I.Func([], [Status], ['query']),
    getHeartbeatTick   : I.Func([], [I.Nat], ['query']),

    // Admin (bootstrap)
    claimDISD              : I.Func([], [I.Text], []),
    bootstrapCurriculum    : I.Func([], [BootResult], []),
    bootstrapConceptContent: I.Func([], [I.Record({ ok: I.Bool, loaded: I.Nat })], []),
    bootstrapGrants        : I.Func([], [I.Record({ ok: I.Bool, loaded: I.Nat })], []),
    setStreamCanister      : I.Func([I.Principal], [], []),
  });
};

// ── Actor singleton ────────────────────────────────────────────────────────

type DallasISDCanisterActor = ActorSubclass<{
  getConcept          : (conceptId: string) => Promise<[TEKSConceptFull] | []>;
  getAllConcepts       : (subject: string) => Promise<TEKSConceptSummary[]>;
  getConceptContent   : (conceptId: string) => Promise<[ConceptContent] | []>;
  getGrantManifest    : () => Promise<GrantEntry[]>;
  getMathEngine       : () => Promise<MathEngine>;
  recordEngagement    : (schoolId: string, schoolName: string, subject: string) => Promise<{ ok: boolean; engagements: bigint }>;
  getTotalEngagements : () => Promise<bigint>;
  getClassroomStatus  : () => Promise<ClassroomStatus>;
  getHeartbeatTick    : () => Promise<bigint>;
  claimDISD           : () => Promise<string>;
  bootstrapCurriculum     : () => Promise<{ ok: boolean; conceptsLoaded: bigint }>;
  bootstrapConceptContent : () => Promise<{ ok: boolean; loaded: bigint }>;
  bootstrapGrants         : () => Promise<{ ok: boolean; loaded: bigint }>;
  setStreamCanister       : (p: unknown) => Promise<void>;
}>;

let _actor: DallasISDCanisterActor | null = null;

export function getDallasISDCanisterActor(): DallasISDCanisterActor {
  if (_actor) return _actor;
  const agent = new HttpAgent({ host: getHost() });
  if (getHost().includes('127.0.0.1')) {
    agent.fetchRootKey().catch(() => {});
  }
  _actor = Actor.createActor(idlFactory, {
    agent,
    canisterId: getCanisterId(),
  }) as DallasISDCanisterActor;
  return _actor;
}
