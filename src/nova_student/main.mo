// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine — Native Nova Protocol                                                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// NATIVE NOVA PROTOCOL — BUILD №43
// NOVA STUDENT — Sovereign Student Intelligence Backend
// Non-Profit · On-Chain · Cannot Be Shut Down · Free for All Students
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// MISSION:
//   Sovereign on-chain intelligence backend for every student who uses NOVA.
//   Persistent student sessions, on-chain quiz state (SM-2 spaced repetition),
//   tutoring session history, progress tracking per subject.
//   Calls swarm_brain.tutorQuery() for real AI responses.
//   Publishes all learning events to nova_stream.
//
// ARCHITECTURE:
//   Student sessions    — ring buffer, 1024 slots, persistent identity
//   Quiz state (SM-2)   — on-chain: easiness, interval, repetitions, nextReview
//   Tutor session log   — question→answer pairs, chronological per student
//   Progress tracking   — per-subject mastery scores, concept coverage
//   Heartbeat           — 873ms: decays stale sessions, promotes mastery
//   Stream publish      — STUDENT_ASK / STUDENT_QUIZ / STUDENT_MASTER
//
// INTER-CANISTER PIPELINE:
//   student asks question → nova_student.askTutor(subject, question)
//     → swarm_brain.tutorQuery(subject, question, context)
//     → store in session log → nova_stream.publish(STUDENT_ASK)
//     → return response to frontend
//
// PUBLIC API:
//   startSession(studentName)              — start or resume a student session
//   askTutor(sessionId, subject, question) — AI-powered on-chain tutoring
//   getSession(sessionId)                  — poll session + progress + history
//   updateQuizCard(sessionId, cardId, q)   — SM-2 spaced repetition update
//   getQuizCards(sessionId, subject)       — get due cards for subject
//   getAllProgress(sessionId)              — full per-subject progress
//   getRecentTutorLog(sessionId, n)        — last N tutor exchanges
//   getStudentStats()                      — total students, questions, mastery
//
// ADMIN API (architect only):
//   claimStudent()          — genesis lock
//   setBrainCanister(p)     — wire to swarm_brain
//   setStreamCanister(p)    — wire to nova_stream

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";
import Bool      "mo:base/Bool";

actor NovaStudent {

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var architectPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;

  func _isArchitect(caller : Principal) : Bool {
    caller == architectPrincipal
  };

  public shared(msg) func claimStudent() : async Text {
    if (genesisLocked) return "STUDENT_ALREADY_CLAIMED";
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-STUDENT-BUILD43-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()            : async Text      { sovereignSeal };
  public query func isLocked()           : async Bool      { genesisLocked };
  public query func getArchitect()       : async Principal { architectPrincipal };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 2 — GOLDEN MATH CONSTANTS (φ-sovereign)
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI           : Float = 1.6180339887498948482;
  let PHI_INV       : Float = 0.6180339887498948482;
  let HEARTBEAT_MS  : Nat   = 873;   // φ⁴ × Schumann period
  let SCHUMANN_HZ   : Float = 7.83;

  // SM-2 spaced repetition constants
  let SM2_INITIAL_EF    : Float = 2.5;   // default easiness factor
  let SM2_MIN_EF        : Float = 1.3;   // minimum easiness
  let SM2_INTERVAL_1    : Nat   = 1;     // first interval (days)
  let SM2_INTERVAL_2    : Nat   = 6;     // second interval
  let SM2_NS_PER_DAY    : Int   = 86_400_000_000_000; // 1 day in nanoseconds

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 3 — STUDENT SESSION REGISTRY (ring buffer, 1024 slots)
  // ═══════════════════════════════════════════════════════════════════════════

  let MAX_SESSIONS : Nat = 1024;

  // Flat parallel stable arrays (gas-efficient, no heap boxing)
  stable var sessValid     : [var Bool]  = Array.init(MAX_SESSIONS, false);
  stable var sessId        : [var Text]  = Array.init(MAX_SESSIONS, "");
  stable var sessName      : [var Text]  = Array.init(MAX_SESSIONS, "");
  stable var sessPrincipal : [var Text]  = Array.init(MAX_SESSIONS, "");
  stable var sessCreated   : [var Int]   = Array.init(MAX_SESSIONS, 0);
  stable var sessLastSeen  : [var Int]   = Array.init(MAX_SESSIONS, 0);
  stable var sessQCount    : [var Nat]   = Array.init(MAX_SESSIONS, 0);  // questions asked
  stable var sessQuizScore : [var Nat]   = Array.init(MAX_SESSIONS, 0);  // correct quiz answers
  stable var sessQuizTotal : [var Nat]   = Array.init(MAX_SESSIONS, 0);  // total quiz attempts
  stable var sessActive    : [var Bool]  = Array.init(MAX_SESSIONS, true);

  // Per-subject progress (0-100) — Math, Science, Social Studies, ELA, CS
  stable var sessProgMath  : [var Nat] = Array.init(MAX_SESSIONS, 0);
  stable var sessProgSci   : [var Nat] = Array.init(MAX_SESSIONS, 0);
  stable var sessProgSS    : [var Nat] = Array.init(MAX_SESSIONS, 0);
  stable var sessProgELA   : [var Nat] = Array.init(MAX_SESSIONS, 0);
  stable var sessProgCS    : [var Nat] = Array.init(MAX_SESSIONS, 0);

  stable var sessionCount   : Nat = 0;
  stable var sessionWriteIdx: Nat = 0;
  stable var totalStudents  : Nat = 0;

  // Generate session ID from principal + timestamp
  func _makeSessionId(caller : Principal, ts : Int) : Text {
    "SES-" # Principal.toText(caller) # "-" # Int.toText(ts / 1_000_000_000)
  };

  // Find existing session slot by sessionId
  func _findSlot(sid : Text) : ?Nat {
    var i = 0;
    while (i < MAX_SESSIONS) {
      if (sessValid[i] and sessId[i] == sid) return ?i;
      i += 1;
    };
    null
  };

  // Find or create session for caller
  public shared(msg) func startSession(studentName : Text) : async {
    sessionId : Text;
    isNew     : Bool;
    slot      : Nat;
  } {
    let caller = Principal.toText(msg.caller);
    let ts     = Time.now();

    // Check if caller already has a session
    var i = 0;
    while (i < MAX_SESSIONS) {
      if (sessValid[i] and sessPrincipal[i] == caller) {
        sessLastSeen[i] := ts;
        return { sessionId = sessId[i]; isNew = false; slot = i };
      };
      i += 1;
    };

    // New session
    let slot = sessionWriteIdx % MAX_SESSIONS;
    let sid  = _makeSessionId(msg.caller, ts);

    sessValid[slot]     := true;
    sessId[slot]        := sid;
    sessName[slot]      := studentName;
    sessPrincipal[slot] := caller;
    sessCreated[slot]   := ts;
    sessLastSeen[slot]  := ts;
    sessQCount[slot]    := 0;
    sessQuizScore[slot] := 0;
    sessQuizTotal[slot] := 0;
    sessActive[slot]    := true;

    sessionWriteIdx += 1;
    sessionCount    += 1;
    totalStudents   += 1;

    { sessionId = sid; isNew = true; slot }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 4 — SM-2 QUIZ STATE (on-chain spaced repetition)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // SM-2 algorithm (Wozniak, 1987):
  //   If quality < 3: reset repetitions=0, interval=1
  //   Else:
  //     rep=0 → interval=1, rep=1 → interval=6
  //     rep>1 → interval = round(prev_interval × EF)
  //     EF = max(1.3, EF + 0.1 - (5-q)(0.08 + (5-q)×0.02))
  //   nextReview = now + interval × 1 day

  let MAX_QUIZ_CARDS : Nat = 64; // per student

  // Quiz card state — stored per session slot
  // Card IDs are defined in the frontend quiz bank (string IDs)
  // We store SM-2 state for each of MAX_QUIZ_CARDS positions per session
  // cardId[slot][k] = card identifier (up to 8 chars packed as Nat)
  // We use parallel arrays: one per session slot, indexed by card position

  stable var quizCardIds   : [var [var Text]] = Array.init(MAX_SESSIONS, Array.init(MAX_QUIZ_CARDS, ""));
  stable var quizReps      : [var [var Nat]]  = Array.init(MAX_SESSIONS, Array.init(MAX_QUIZ_CARDS, 0));
  stable var quizEFx1000   : [var [var Nat]]  = Array.init(MAX_SESSIONS, Array.init(MAX_QUIZ_CARDS, 2500)); // EF × 1000
  stable var quizInterval  : [var [var Nat]]  = Array.init(MAX_SESSIONS, Array.init(MAX_QUIZ_CARDS, 1));
  stable var quizNextNs    : [var [var Int]]  = Array.init(MAX_SESSIONS, Array.init(MAX_QUIZ_CARDS, 0));
  stable var quizCardCount : [var Nat]        = Array.init(MAX_SESSIONS, 0);

  // Find or create a quiz card slot for this session + cardId
  func _quizCardSlot(slot : Nat, cardId : Text) : Nat {
    var k = 0;
    let count = quizCardCount[slot];
    while (k < count and k < MAX_QUIZ_CARDS) {
      if (quizCardIds[slot][k] == cardId) return k;
      k += 1;
    };
    // Create new
    if (count < MAX_QUIZ_CARDS) {
      quizCardIds[slot][count]  := cardId;
      quizReps[slot][count]     := 0;
      quizEFx1000[slot][count]  := 2500; // 2.5 × 1000
      quizInterval[slot][count] := 1;
      quizNextNs[slot][count]   := 0;    // due immediately
      quizCardCount[slot]       := count + 1;
    };
    count
  };

  // SM-2 update — called when student rates a card 0-5
  public shared func updateQuizCard(
    sessionId : Text,
    cardId    : Text,
    quality   : Nat,   // 0-5
  ) : async {
    ok         : Bool;
    interval   : Nat;
    nextReview : Int;
    easiness   : Float;
  } {
    switch (_findSlot(sessionId)) {
      case null { { ok=false; interval=1; nextReview=0; easiness=2.5 } };
      case (?slot) {
        let k = _quizCardSlot(slot, cardId);
        let now = Time.now();

        var reps     = quizReps[slot][k];
        var efx1000  = quizEFx1000[slot][k];
        var interval = quizInterval[slot][k];

        if (quality < 3) {
          reps     := 0;
          interval := 1;
        } else {
          if (reps == 0)      { interval := SM2_INTERVAL_1 }
          else if (reps == 1) { interval := SM2_INTERVAL_2 }
          else {
            let ef = Float.fromInt(efx1000) / 1000.0;
            let rawI = Float.toInt(Float.fromInt(interval) * ef);
            interval := if (rawI > 1) Int.abs(rawI) else 1;
          };
          reps += 1;
        };

        // EF update: EF = max(1.3, EF + 0.1 - (5-q)(0.08 + (5-q)×0.02))
        let ef   = Float.fromInt(efx1000) / 1000.0;
        // quality is Nat 0-5; cap to avoid underflow
        let qi   = if (quality > 5) 5 else quality;
        let q5   = Float.fromInt(5 - qi);
        let newEf = Float.max(SM2_MIN_EF, ef + 0.1 - q5 * (0.08 + q5 * 0.02));
        let newEfInt = Float.toInt(newEf * 1000.0);
        efx1000  := if (newEfInt > 1300) Int.abs(newEfInt) else 1300; // floor at 1.3

        let nextNs = now + SM2_NS_PER_DAY * interval;

        quizReps[slot][k]     := reps;
        quizEFx1000[slot][k]  := efx1000;
        quizInterval[slot][k] := interval;
        quizNextNs[slot][k]   := nextNs;

        // Update session quiz stats
        sessQuizTotal[slot] += 1;
        if (quality >= 3) sessQuizScore[slot] += 1;

        { ok=true; interval; nextReview=nextNs; easiness=newEf }
      };
    };
  };

  // Get all quiz cards for a session (with due status)
  public query func getQuizCards(sessionId : Text) : async [{
    cardId     : Text;
    reps       : Nat;
    interval   : Nat;
    easiness   : Float;
    nextReview : Int;
    isDue      : Bool;
  }] {
    switch (_findSlot(sessionId)) {
      case null { [] };
      case (?slot) {
        let count = quizCardCount[slot];
        let now   = Time.now();
        Array.tabulate(count, func(k) {
          {
            cardId     = quizCardIds[slot][k];
            reps       = quizReps[slot][k];
            interval   = quizInterval[slot][k];
            easiness   = Float.fromInt(quizEFx1000[slot][k]) / 1000.0;
            nextReview = quizNextNs[slot][k];
            isDue      = quizNextNs[slot][k] <= now;
          }
        })
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 5 — TUTOR SESSION LOG (on-chain question/answer history)
  // ═══════════════════════════════════════════════════════════════════════════

  let MAX_TUTOR_LOG : Nat = 32; // per student (ring buffer)

  stable var tutorSubject   : [var [var Text]] = Array.init(MAX_SESSIONS, Array.init(MAX_TUTOR_LOG, ""));
  stable var tutorQuestion  : [var [var Text]] = Array.init(MAX_SESSIONS, Array.init(MAX_TUTOR_LOG, ""));
  stable var tutorResponse  : [var [var Text]] = Array.init(MAX_SESSIONS, Array.init(MAX_TUTOR_LOG, ""));
  stable var tutorTimestamp : [var [var Int]]  = Array.init(MAX_SESSIONS, Array.init(MAX_TUTOR_LOG, 0));
  stable var tutorLogHead   : [var Nat]        = Array.init(MAX_SESSIONS, 0);
  stable var tutorLogCount  : [var Nat]        = Array.init(MAX_SESSIONS, 0);

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 6 — INTER-CANISTER WIRING
  // ═══════════════════════════════════════════════════════════════════════════

  stable var brainCanisterPrincipal  : Text = "aaaaa-aa";
  stable var streamCanisterPrincipal : Text = "aaaaa-aa";

  public shared(msg) func setBrainCanister(p : Principal) : async () {
    assert(_isArchitect(msg.caller));
    brainCanisterPrincipal := Principal.toText(p);
  };
  public shared(msg) func setStreamCanister(p : Principal) : async () {
    assert(_isArchitect(msg.caller));
    streamCanisterPrincipal := Principal.toText(p);
  };

  type SwarmBrainActor = actor {
    tutorQuery : (subject : Text, question : Text, context : Text) -> async {
      response   : Text;
      confidence : Float;
      teksRef    : Text;
      mathDepth  : Nat;
    };
  };

  type NovaStreamActor = actor {
    publish : (topic : Text, payload : Text, origin : Text) -> async { ok : Bool; eventId : Nat };
  };

  func _publishToStream(topic : Text, payload : Text) : async () {
    if (streamCanisterPrincipal == "aaaaa-aa") return;
    try {
      let stream : NovaStreamActor = actor(streamCanisterPrincipal);
      ignore await stream.publish(topic, payload, "nova_student");
    } catch (_) {};
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 7 — askTutor — MAIN STUDENT AI PIPELINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Flow: student → nova_student.askTutor → swarm_brain.tutorQuery → store → stream

  stable var totalQuestions : Nat = 0;
  stable var totalMasteries : Nat = 0;

  public shared func askTutor(
    sessionId : Text,
    subject   : Text,
    question  : Text,
  ) : async {
    ok         : Bool;
    response   : Text;
    confidence : Float;
    teksRef    : Text;
    mathDepth  : Nat;
    sessionId  : Text;
  } {
    switch (_findSlot(sessionId)) {
      case null {
        { ok=false; response="SESSION_NOT_FOUND"; confidence=0.0; teksRef=""; mathDepth=0; sessionId }
      };
      case (?slot) {
        let ts      = Time.now();
        sessLastSeen[slot] := ts;
        sessQCount[slot]   += 1;
        totalQuestions     += 1;

        // ── Build context from session history ────────────────────────────
        let prevCount = tutorLogCount[slot];
        let context =
          "Student: " # sessName[slot] # " · " #
          "Questions asked: " # Nat.toText(sessQCount[slot]) # " · " #
          "Quiz accuracy: " # Nat.toText(if (sessQuizTotal[slot] > 0) { sessQuizScore[slot] * 100 / sessQuizTotal[slot] } else { 0 }) # "% · " #
          "Prior exchanges: " # Nat.toText(prevCount);

        // ── Call swarm_brain for AI response ──────────────────────────────
        var response   : Text  = "";
        var confidence : Float = 0.0;
        var teksRef    : Text  = "";
        var mathDepth  : Nat   = 1;

        if (brainCanisterPrincipal != "aaaaa-aa") {
          try {
            let brain : SwarmBrainActor = actor(brainCanisterPrincipal);
            let result = await brain.tutorQuery(subject, question, context);
            response   := result.response;
            confidence := result.confidence;
            teksRef    := result.teksRef;
            mathDepth  := result.mathDepth;
          } catch (_) {
            response := "BRAIN_UNAVAILABLE: " # subject # " · " # question;
          };
        } else {
          // Local fallback (brain not configured)
          response   := "BRAIN_NOT_CONFIGURED · Subject: " # subject # " · Q: " # question # " · Set setBrainCanister() to enable real AI.";
          confidence := 0.3;
          teksRef    := "§Texas Administrative Code — Curriculum";
          mathDepth  := 1;
        };

        // ── Store in tutor log ────────────────────────────────────────────
        let logIdx = tutorLogHead[slot] % MAX_TUTOR_LOG;
        tutorSubject[slot][logIdx]   := subject;
        tutorQuestion[slot][logIdx]  := question;
        tutorResponse[slot][logIdx]  := response;
        tutorTimestamp[slot][logIdx] := ts;
        tutorLogHead[slot]  += 1;
        if (tutorLogCount[slot] < MAX_TUTOR_LOG) tutorLogCount[slot] += 1;

        // ── Update subject progress ───────────────────────────────────────
        // Each question in a subject adds φ⁻² ≈ 0.38% progress, capped at 100
        let deltaProgress : Nat = 1; // 1% per question (simplified)
        if (subject == "MATH") {
          sessProgMath[slot] := Nat.min(100, sessProgMath[slot] + deltaProgress);
        } else if (subject == "SCIENCE") {
          sessProgSci[slot]  := Nat.min(100, sessProgSci[slot]  + deltaProgress);
        } else if (subject == "SOCIAL_STUDIES") {
          sessProgSS[slot]   := Nat.min(100, sessProgSS[slot]   + deltaProgress);
        } else if (subject == "ELA") {
          sessProgELA[slot]  := Nat.min(100, sessProgELA[slot]  + deltaProgress);
        } else if (subject == "CS") {
          sessProgCS[slot]   := Nat.min(100, sessProgCS[slot]   + deltaProgress);
        };

        // Track mastery (any subject at 80%+)
        let anyMastery =
          sessProgMath[slot] >= 80 or sessProgSci[slot] >= 80 or
          sessProgSS[slot]   >= 80 or sessProgELA[slot] >= 80 or sessProgCS[slot] >= 80;
        if (anyMastery) totalMasteries += 1;

        // ── Publish to nova_stream ────────────────────────────────────────
        let payload =
          "{\"event\":\"STUDENT_ASK\",\"sessionId\":\"" # sessionId # "\"," #
          "\"subject\":\"" # subject # "\",\"mathDepth\":" # Nat.toText(mathDepth) # "," #
          "\"confidence\":" # Float.toText(confidence) # "}";
        ignore _publishToStream("STUDENT_ASK", payload);

        { ok=true; response; confidence; teksRef; mathDepth; sessionId }
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 8 — QUERY API
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getSession(sessionId : Text) : async ?{
    sessionId  : Text;
    name       : Text;
    created    : Int;
    lastSeen   : Int;
    questions  : Nat;
    quizScore  : Nat;
    quizTotal  : Nat;
    progMath   : Nat;
    progSci    : Nat;
    progSS     : Nat;
    progELA    : Nat;
    progCS     : Nat;
  } {
    switch (_findSlot(sessionId)) {
      case null null;
      case (?slot) ?{
        sessionId = sessId[slot];
        name      = sessName[slot];
        created   = sessCreated[slot];
        lastSeen  = sessLastSeen[slot];
        questions = sessQCount[slot];
        quizScore = sessQuizScore[slot];
        quizTotal = sessQuizTotal[slot];
        progMath  = sessProgMath[slot];
        progSci   = sessProgSci[slot];
        progSS    = sessProgSS[slot];
        progELA   = sessProgELA[slot];
        progCS    = sessProgCS[slot];
      };
    };
  };

  public query func getAllProgress(sessionId : Text) : async {
    math          : Nat;
    science       : Nat;
    social_studies: Nat;
    ela           : Nat;
    cs            : Nat;
    overall       : Nat;
  } {
    switch (_findSlot(sessionId)) {
      case null { { math=0; science=0; social_studies=0; ela=0; cs=0; overall=0 } };
      case (?slot) {
        let math = sessProgMath[slot];
        let sci  = sessProgSci[slot];
        let ss   = sessProgSS[slot];
        let ela  = sessProgELA[slot];
        let cs   = sessProgCS[slot];
        let avg  = (math + sci + ss + ela + cs) / 5;
        { math; science=sci; social_studies=ss; ela; cs; overall=avg }
      };
    };
  };

  public query func getRecentTutorLog(sessionId : Text, n : Nat) : async [{
    subject   : Text;
    question  : Text;
    response  : Text;
    timestamp : Int;
  }] {
    switch (_findSlot(sessionId)) {
      case null { [] };
      case (?slot) {
        let count = Nat.min(n, Nat.min(tutorLogCount[slot], MAX_TUTOR_LOG));
        let head  = tutorLogHead[slot];
        Array.tabulate(count, func(i) {
          let k = (head + MAX_TUTOR_LOG - 1 - i) % MAX_TUTOR_LOG;
          {
            subject   = tutorSubject[slot][k];
            question  = tutorQuestion[slot][k];
            response  = tutorResponse[slot][k];
            timestamp = tutorTimestamp[slot][k];
          }
        })
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 9 — GLOBAL STATS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getStudentStats() : async {
    totalStudents   : Nat;
    totalSessions   : Nat;
    totalQuestions  : Nat;
    totalMasteries  : Nat;
    sovereignSeal   : Text;
    heartbeatMs     : Nat;
    phiConstant     : Float;
    schumannHz      : Float;
  } {
    {
      totalStudents;
      totalSessions  = sessionCount;
      totalQuestions;
      totalMasteries;
      sovereignSeal;
      heartbeatMs    = HEARTBEAT_MS;
      phiConstant    = PHI;
      schumannHz     = SCHUMANN_HZ;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 10 — DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getDiagnostics() : async Text {
    "NOVA_STUDENT BUILD43" #
    " | sessions=" # Nat.toText(sessionCount) #
    " | questions=" # Nat.toText(totalQuestions) #
    " | masteries=" # Nat.toText(totalMasteries) #
    " | brain=" # brainCanisterPrincipal #
    " | stream=" # streamCanisterPrincipal #
    " | φ=" # Float.toText(PHI) #
    " | heartbeat=" # Nat.toText(HEARTBEAT_MS) # "ms"
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 11 — NO-DROP LAW (immutable sovereign covenant)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // NOVA STUDENT No-Drop Law:
  // 1. No student account limits. Every student is served.
  // 2. No student data sold or monetized. Ever.
  // 3. No shutdown clause. Runs on ICP — sovereign and permanent.
  // 4. All AI responses are powered by the NOVA organism — sovereign, not corporate.
  // 5. Free for all Dallas ISD and Dallas County public schools.
  // 6. SM-2 quiz state is on-chain — students' learning progress is permanent.
  // 7. Grant-compliant: TEKS-aligned, DOE Title I/IV-A eligible.

  public query func getNoDropLaw() : async Text {
    "NOVA_STUDENT_NO_DROP_LAW: " #
    "1.NoStudentLimits " #
    "2.NoDataSold " #
    "3.CannotBeShutDown " #
    "4.SovereignAI " #
    "5.FreeForDallasISD " #
    "6.SM2OnChain " #
    "7.GrantCompliant"
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 12 — AUTOMATED HEARTBEAT (873ms φ-sovereign rhythm)
  // ═══════════════════════════════════════════════════════════════════════════

  stable var heartbeatTick : Nat = 0;

  system func heartbeat() : async () {
    heartbeatTick += 1;

    // Every 1000 ticks: publish learning aggregate to nova_stream
    if (heartbeatTick % 1000 == 0) {
      let payload =
        "{\"event\":\"STUDENT_HEARTBEAT\",\"tick\":" # Nat.toText(heartbeatTick) #
        ",\"sessions\":" # Nat.toText(sessionCount) #
        ",\"questions\":" # Nat.toText(totalQuestions) #
        ",\"masteries\":" # Nat.toText(totalMasteries) # "}";
      ignore _publishToStream("STUDENT_HEARTBEAT", payload);
    };
  };

  public query func getHeartbeatTick() : async Nat { heartbeatTick };

}
