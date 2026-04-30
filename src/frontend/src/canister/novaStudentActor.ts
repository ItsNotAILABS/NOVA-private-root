// ═══════════════════════════════════════════════════════════════════════════
// NOVA STUDENT — Canister Actor (Build №43)
// Language: CPL (TypeScript + @dfinity/agent)
// Frontend connection to nova_student sovereign backend.
// Medina Tech · Alfredo Medina Hernandez · Dallas TX · 2026
// ═══════════════════════════════════════════════════════════════════════════

import { Actor, HttpAgent, type ActorSubclass } from '@dfinity/agent';
import { IDL } from '@dfinity/candid';

// ── Canister ID resolution ─────────────────────────────────────────────────
const getCanisterId = (): string => {
  if (typeof import.meta !== 'undefined' && import.meta.env?.VITE_NOVA_STUDENT_CANISTER_ID)
    return import.meta.env.VITE_NOVA_STUDENT_CANISTER_ID as string;
  if (typeof process !== 'undefined' && process.env?.NOVA_STUDENT_CANISTER_ID)
    return process.env.NOVA_STUDENT_CANISTER_ID as string;
  return 'bkyz2-fmaaa-aaaaa-qaaap-cai'; // local dev placeholder
};

const getHost = (): string => {
  if (typeof import.meta !== 'undefined' && import.meta.env?.VITE_IC_HOST)
    return import.meta.env.VITE_IC_HOST as string;
  return 'http://127.0.0.1:8000';
};

// ── TypeScript types matching nova_student/main.mo exactly ────────────────

export interface StudentSession {
  sessionId  : string;
  name       : string;
  created    : bigint;
  lastSeen   : bigint;
  questions  : bigint;
  quizScore  : bigint;
  quizTotal  : bigint;
  progMath   : bigint;
  progSci    : bigint;
  progSS     : bigint;
  progELA    : bigint;
  progCS     : bigint;
}

export interface StartSessionResult {
  sessionId : string;
  isNew     : boolean;
  slot      : bigint;
}

export interface AskTutorResult {
  ok         : boolean;
  response   : string;
  confidence : number;
  teksRef    : string;
  mathDepth  : bigint;
  sessionId  : string;
}

export interface QuizCardResult {
  ok         : boolean;
  interval   : bigint;
  nextReview : bigint;
  easiness   : number;
}

export interface QuizCard {
  cardId     : string;
  reps       : bigint;
  interval   : bigint;
  easiness   : number;
  nextReview : bigint;
  isDue      : boolean;
}

export interface SubjectProgress {
  math          : bigint;
  science       : bigint;
  social_studies: bigint;
  ela           : bigint;
  cs            : bigint;
  overall       : bigint;
}

export interface TutorLogEntry {
  subject   : string;
  question  : string;
  response  : string;
  timestamp : bigint;
}

export interface StudentStats {
  totalStudents  : bigint;
  totalSessions  : bigint;
  totalQuestions : bigint;
  totalMasteries : bigint;
  sovereignSeal  : string;
  heartbeatMs    : bigint;
  phiConstant    : number;
  schumannHz     : number;
}

// ── Candid IDL ────────────────────────────────────────────────────────────

const idlFactory = ({ IDL: I }: { IDL: typeof IDL }) => {
  const SessionResult = I.Record({
    sessionId: I.Text,
    isNew:     I.Bool,
    slot:      I.Nat,
  });

  const AskTutorResult = I.Record({
    ok:         I.Bool,
    response:   I.Text,
    confidence: I.Float64,
    teksRef:    I.Text,
    mathDepth:  I.Nat,
    sessionId:  I.Text,
  });

  const QuizUpdateResult = I.Record({
    ok:         I.Bool,
    interval:   I.Nat,
    nextReview: I.Int,
    easiness:   I.Float64,
  });

  const QuizCard = I.Record({
    cardId:     I.Text,
    reps:       I.Nat,
    interval:   I.Nat,
    easiness:   I.Float64,
    nextReview: I.Int,
    isDue:      I.Bool,
  });

  const Session = I.Record({
    sessionId: I.Text,
    name:      I.Text,
    created:   I.Int,
    lastSeen:  I.Int,
    questions: I.Nat,
    quizScore: I.Nat,
    quizTotal: I.Nat,
    progMath:  I.Nat,
    progSci:   I.Nat,
    progSS:    I.Nat,
    progELA:   I.Nat,
    progCS:    I.Nat,
  });

  const Progress = I.Record({
    math:           I.Nat,
    science:        I.Nat,
    social_studies: I.Nat,
    ela:            I.Nat,
    cs:             I.Nat,
    overall:        I.Nat,
  });

  const TutorEntry = I.Record({
    subject:   I.Text,
    question:  I.Text,
    response:  I.Text,
    timestamp: I.Int,
  });

  const Stats = I.Record({
    totalStudents:  I.Nat,
    totalSessions:  I.Nat,
    totalQuestions: I.Nat,
    totalMasteries: I.Nat,
    sovereignSeal:  I.Text,
    heartbeatMs:    I.Nat,
    phiConstant:    I.Float64,
    schumannHz:     I.Float64,
  });

  return I.Service({
    // Student session
    startSession   : I.Func([I.Text], [SessionResult], []),
    getSession     : I.Func([I.Text], [I.Opt(Session)], ['query']),
    getAllProgress  : I.Func([I.Text], [Progress], ['query']),

    // AI tutoring (calls swarm_brain)
    askTutor       : I.Func([I.Text, I.Text, I.Text], [AskTutorResult], []),

    // SM-2 quiz
    updateQuizCard : I.Func([I.Text, I.Text, I.Nat], [QuizUpdateResult], []),
    getQuizCards   : I.Func([I.Text], [I.Vec(QuizCard)], ['query']),

    // Tutor log
    getRecentTutorLog : I.Func([I.Text, I.Nat], [I.Vec(TutorEntry)], ['query']),

    // Global stats
    getStudentStats   : I.Func([], [Stats], ['query']),
    getNoDropLaw      : I.Func([], [I.Text], ['query']),
    getDiagnostics    : I.Func([], [I.Text], ['query']),
    getHeartbeatTick  : I.Func([], [I.Nat], ['query']),

    // Admin
    claimStudent      : I.Func([], [I.Text], []),
    setBrainCanister  : I.Func([I.Principal], [], []),
    setStreamCanister : I.Func([I.Principal], [], []),
  });
};

// ── Actor singleton ────────────────────────────────────────────────────────

type NovaStudentActor = ActorSubclass<{
  startSession      : (name: string) => Promise<StartSessionResult>;
  getSession        : (sessionId: string) => Promise<[StudentSession] | []>;
  getAllProgress     : (sessionId: string) => Promise<SubjectProgress>;
  askTutor          : (sessionId: string, subject: string, question: string) => Promise<AskTutorResult>;
  updateQuizCard    : (sessionId: string, cardId: string, quality: bigint) => Promise<QuizCardResult>;
  getQuizCards      : (sessionId: string) => Promise<QuizCard[]>;
  getRecentTutorLog : (sessionId: string, n: bigint) => Promise<TutorLogEntry[]>;
  getStudentStats   : () => Promise<StudentStats>;
  getNoDropLaw      : () => Promise<string>;
  getDiagnostics    : () => Promise<string>;
  getHeartbeatTick  : () => Promise<bigint>;
  claimStudent      : () => Promise<string>;
  setBrainCanister  : (p: unknown) => Promise<void>;
  setStreamCanister : (p: unknown) => Promise<void>;
}>;

let _actor: NovaStudentActor | null = null;

export function getNovaStudentActor(): NovaStudentActor {
  if (_actor) return _actor;
  const agent = new HttpAgent({ host: getHost() });
  if (getHost().includes('127.0.0.1')) {
    agent.fetchRootKey().catch(() => {});
  }
  _actor = Actor.createActor(idlFactory, {
    agent,
    canisterId: getCanisterId(),
  }) as NovaStudentActor;
  return _actor;
}
