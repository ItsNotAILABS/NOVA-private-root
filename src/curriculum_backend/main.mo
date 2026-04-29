// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  Owner: Alfredo Medina Hernandez · Dallas TX · MedinaSITech@outlook.com                                  ║
// ║  Framework: Medina Doctrine — Native Nova Protocol                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// CURRICULUM BACKEND — DEEP EDUCATIONAL INTELLIGENCE ENGINE (BUILD №44)
// Casa de Inteligencia: This backend serves ALL frontends requiring educational computation
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MISSION:
//   Sovereign on-chain educational intelligence engine. Every curriculum standard, learning
//   objective, assessment rubric, and pedagogical workflow lives here. This is not an LMS —
//   this is the educational substrate of NOVA computed from learning science first principles.
//   Intelligence is infrastructure. FREE FOR ALL PUBLIC SCHOOLS.
//
// ARCHITECTURE (Casa de Inteligencia):
//   This BACKEND serves MULTIPLE FRONTENDS:
//     → DallasISDApp.tsx (classroom interface, student view)
//     → NeuroCogLab.tsx (learning science research)
//     → NovaBuilderApp.tsx (educational tool generation)
//     → TerminalHub.tsx (educator terminal)
//
// CAPABILITIES:
//   §1  Sovereign Identity & Genesis
//   §2  Curriculum Standards Engine — TEKS, Common Core, NGSS mappings
//   §3  Learning Objectives Engine — Bloom's taxonomy, mastery levels
//   §4  Assessment Engine — rubrics, scoring, adaptive testing
//   §5  Pedagogical Strategy Engine — instructional methods
//   §6  Student Model Engine — knowledge tracing, misconceptions
//   §7  Content Sequencing Engine — prerequisite graphs, learning paths
//   §8  Scaffolding Engine — zone of proximal development, hints
//   §9  Feedback Engine — formative, corrective, motivational
//   §10 Engagement Engine — gamification, intrinsic motivation
//   §11 Accessibility Engine — universal design, accommodations
//   §12 Grant Compliance Engine — Title I, Title IV-A, TEA, NSF
//   §13 Analytics Engine — learning analytics, progress tracking
//   §14 Collaboration Engine — peer learning, group dynamics
//   §15 Heartbeat & Telemetry — 873ms curriculum engine health
//   §16 Stream Publishing — CURRICULUM events to nova_stream
//
// MEDINA TECH | ALFREDO MEDINA HERNANDEZ | DALLAS TX | 2026
// FREE FOR ALL DALLAS ISD & DALLAS COUNTY PUBLIC SCHOOLS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Array     "mo:base/Array";
import Buffer    "mo:base/Buffer";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Iter      "mo:base/Iter";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";
import Bool      "mo:base/Bool";

actor CurriculumBackend {

  // ═══════════════════════════════════════════════════════════════════════════
  // §1 — SOVEREIGN IDENTITY & GENESIS
  // ═══════════════════════════════════════════════════════════════════════════

  stable var architectPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;
  stable var buildNumber        : Nat       = 44;

  func _isArchitect(caller : Principal) : Bool { caller == architectPrincipal };

  public shared(msg) func claimCurriculum() : async Text {
    if (genesisLocked) return "CURRICULUM_ALREADY_CLAIMED";
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-CURRICULUM-BACKEND-BUILD44-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text      { sovereignSeal };
  public query func isLocked()     : async Bool      { genesisLocked };
  public query func getArchitect() : async Principal { architectPrincipal };
  public query func getBuild()     : async Nat       { buildNumber };

  // ═══════════════════════════════════════════════════════════════════════════
  // EDUCATIONAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  // NOVA sovereign constants
  let HEARTBEAT_MS : Nat = 873;  // NOVA 873ms heartbeat

  // Bloom's Taxonomy levels (revised)
  let BLOOM_REMEMBER    : Nat = 1;
  let BLOOM_UNDERSTAND  : Nat = 2;
  let BLOOM_APPLY       : Nat = 3;
  let BLOOM_ANALYZE     : Nat = 4;
  let BLOOM_EVALUATE    : Nat = 5;
  let BLOOM_CREATE      : Nat = 6;

  // Mastery thresholds
  let MASTERY_THRESHOLD      : Float = 0.80;  // 80% for mastery
  let PROFICIENT_THRESHOLD   : Float = 0.70;  // 70% for proficiency
  let APPROACHING_THRESHOLD  : Float = 0.50;  // 50% for approaching

  // Zone of Proximal Development
  let ZPD_LOWER_BOUND : Float = 0.60;  // Can do with support
  let ZPD_UPPER_BOUND : Float = 0.90;  // Just beyond comfort

  // ═══════════════════════════════════════════════════════════════════════════
  // §2 — CURRICULUM STANDARDS ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Texas Essential Knowledge and Skills (TEKS), Common Core, NGSS mappings.
  // Every standard stored on-chain with full metadata.

  type CurriculumStandard = {
    id            : Nat;
    standardCode  : Text;  // e.g., "TEKS.111.26.b.4" or "CCSS.MATH.6.RP.A.1"
    framework     : Text;  // "TEKS" | "CCSS" | "NGSS"
    subject       : Text;  // "MATH" | "SCIENCE" | "ELA" | "SOCIAL_STUDIES" | "CS"
    gradeLevel    : Text;  // "K" | "1" | ... | "12" | "K-2" | "6-8"
    domain        : Text;  // e.g., "Ratios & Proportional Relationships"
    statement     : Text;  // Full standard statement
    skills        : [Text];
    prerequisites : [Nat]; // IDs of prerequisite standards
    bloomLevel    : Nat;   // Primary Bloom's level
    verbatim      : Bool;  // True if exact TEKS/CCSS text
  };

  let MAX_STANDARDS : Nat = 2048;
  stable var standardCount   : Nat = 0;
  stable var standardCodes   : [var Text] = Array.init(MAX_STANDARDS, "");
  stable var standardFrames  : [var Text] = Array.init(MAX_STANDARDS, "");
  stable var standardSubjs   : [var Text] = Array.init(MAX_STANDARDS, "");
  stable var standardGrades  : [var Text] = Array.init(MAX_STANDARDS, "");
  stable var standardDomains : [var Text] = Array.init(MAX_STANDARDS, "");
  stable var standardStmts   : [var Text] = Array.init(MAX_STANDARDS, "");
  stable var standardBlooms  : [var Nat]  = Array.init(MAX_STANDARDS, 1);
  stable var standardBootDone: Bool = false;

  /// Add a curriculum standard
  func _addStandard(
    code    : Text; frame : Text; subj  : Text; grade : Text;
    domain  : Text; stmt  : Text; bloom : Nat
  ) {
    if (standardCount >= MAX_STANDARDS) return;
    let k = standardCount;
    standardCodes[k]   := code;
    standardFrames[k]  := frame;
    standardSubjs[k]   := subj;
    standardGrades[k]  := grade;
    standardDomains[k] := domain;
    standardStmts[k]   := stmt;
    standardBlooms[k]  := bloom;
    standardCount += 1;
  };

  /// Get standard by index
  public query func getStandard(idx : Nat) : async {
    code : Text; framework : Text; subject : Text;
    grade : Text; domain : Text; statement : Text; bloom : Nat
  } {
    if (idx >= standardCount) return {
      code = ""; framework = ""; subject = ""; grade = ""; domain = ""; statement = ""; bloom = 0
    };
    {
      code      = standardCodes[idx];
      framework = standardFrames[idx];
      subject   = standardSubjs[idx];
      grade     = standardGrades[idx];
      domain    = standardDomains[idx];
      statement = standardStmts[idx];
      bloom     = standardBlooms[idx]
    }
  };

  /// Count standards
  public query func getStandardCount() : async Nat { standardCount };

  // ═══════════════════════════════════════════════════════════════════════════
  // §3 — LEARNING OBJECTIVES ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Bloom's taxonomy classification, mastery criteria, measurable outcomes.

  type LearningObjective = {
    id           : Nat;
    standardId   : Nat;      // Links to CurriculumStandard
    objective    : Text;     // "Students will be able to..."
    bloomLevel   : Nat;
    verb         : Text;     // Action verb (e.g., "analyze", "compare")
    successCrit  : Text;     // Measurable success criteria
    timeEstimate : Nat;      // Minutes to achieve
  };

  let MAX_OBJECTIVES : Nat = 4096;
  stable var objectiveCount    : Nat = 0;
  stable var objectiveTexts    : [var Text] = Array.init(MAX_OBJECTIVES, "");
  stable var objectiveBlooms   : [var Nat]  = Array.init(MAX_OBJECTIVES, 1);
  stable var objectiveVerbs    : [var Text] = Array.init(MAX_OBJECTIVES, "");
  stable var objectiveCriteria : [var Text] = Array.init(MAX_OBJECTIVES, "");
  stable var objectiveMinutes  : [var Nat]  = Array.init(MAX_OBJECTIVES, 30);

  /// Classify Bloom's level from verb
  public query func classifyBloomLevel(verb : Text) : async Nat {
    _classifyBloom(verb)
  };

  func _classifyBloom(verb : Text) : Nat {
    // Remember verbs
    if (_textContains(verb, "list") or _textContains(verb, "define") or
        _textContains(verb, "recall") or _textContains(verb, "identify") or
        _textContains(verb, "recognize") or _textContains(verb, "name")) {
      return BLOOM_REMEMBER;
    };
    // Understand verbs
    if (_textContains(verb, "explain") or _textContains(verb, "describe") or
        _textContains(verb, "summarize") or _textContains(verb, "interpret") or
        _textContains(verb, "classify") or _textContains(verb, "paraphrase")) {
      return BLOOM_UNDERSTAND;
    };
    // Apply verbs
    if (_textContains(verb, "apply") or _textContains(verb, "solve") or
        _textContains(verb, "use") or _textContains(verb, "demonstrate") or
        _textContains(verb, "calculate") or _textContains(verb, "compute")) {
      return BLOOM_APPLY;
    };
    // Analyze verbs
    if (_textContains(verb, "analyze") or _textContains(verb, "compare") or
        _textContains(verb, "contrast") or _textContains(verb, "differentiate") or
        _textContains(verb, "examine") or _textContains(verb, "investigate")) {
      return BLOOM_ANALYZE;
    };
    // Evaluate verbs
    if (_textContains(verb, "evaluate") or _textContains(verb, "judge") or
        _textContains(verb, "assess") or _textContains(verb, "critique") or
        _textContains(verb, "justify") or _textContains(verb, "defend")) {
      return BLOOM_EVALUATE;
    };
    // Create verbs
    if (_textContains(verb, "create") or _textContains(verb, "design") or
        _textContains(verb, "construct") or _textContains(verb, "develop") or
        _textContains(verb, "synthesize") or _textContains(verb, "compose")) {
      return BLOOM_CREATE;
    };
    BLOOM_UNDERSTAND  // Default
  };

  /// Get recommended verbs for Bloom level
  public query func getBloomVerbs(level : Nat) : async [Text] {
    switch (level) {
      case 1 { ["list", "define", "recall", "identify", "recognize", "name", "memorize"] };
      case 2 { ["explain", "describe", "summarize", "interpret", "classify", "paraphrase"] };
      case 3 { ["apply", "solve", "use", "demonstrate", "calculate", "compute", "implement"] };
      case 4 { ["analyze", "compare", "contrast", "differentiate", "examine", "investigate"] };
      case 5 { ["evaluate", "judge", "assess", "critique", "justify", "defend", "argue"] };
      case 6 { ["create", "design", "construct", "develop", "synthesize", "compose", "formulate"] };
      case _ { ["understand"] };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §4 — ASSESSMENT ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Rubrics, scoring algorithms, adaptive testing, item response theory.

  type AssessmentItem = {
    id           : Nat;
    objectiveId  : Nat;
    itemType     : Text;   // "MC" | "SHORT_ANSWER" | "EXTENDED" | "PERFORMANCE"
    difficulty   : Float;  // 0.0 (easy) to 1.0 (hard)
    discrimination: Float; // How well item separates high/low performers
    points       : Nat;
    rubricLevel  : Nat;    // 1-4 for rubric-based
  };

  type RubricLevel = {
    level       : Nat;    // 1, 2, 3, or 4
    label       : Text;   // "Beginning", "Developing", "Proficient", "Advanced"
    description : Text;
    criteria    : [Text];
  };

  /// Item Response Theory: probability of correct response
  /// P(correct) = 1 / (1 + e^(-a(θ - b)))
  /// a = discrimination, θ = ability, b = difficulty
  public query func irtProbability(
    ability : Float,
    difficulty : Float,
    discrimination : Float
  ) : async Float {
    let exponent = -discrimination * (ability - difficulty);
    1.0 / (1.0 + _exp(exponent))
  };

  /// Adaptive item selection: find optimal next item
  public query func selectNextItem(
    currentAbility : Float,
    itemDifficulties : [Float],
    itemsAttempted : [Nat]
  ) : async Nat {
    // Select item closest to ability but not yet attempted
    var bestIdx : Nat = 0;
    var bestDiff : Float = 1e15;
    var i : Nat = 0;
    while (i < itemDifficulties.size()) {
      var attempted = false;
      for (a in itemsAttempted.vals()) {
        if (a == i) attempted := true;
      };
      if (not attempted) {
        let diff = _abs(itemDifficulties[i] - currentAbility);
        if (diff < bestDiff) {
          bestDiff := diff;
          bestIdx := i;
        };
      };
      i += 1;
    };
    bestIdx
  };

  /// Calculate mastery level
  public query func calculateMastery(
    score : Float,
    maxScore : Float
  ) : async { level : Text; percentage : Float } {
    let pct = if (maxScore > 0.0) score / maxScore else 0.0;
    let level = if (pct >= MASTERY_THRESHOLD) "MASTERY"
                else if (pct >= PROFICIENT_THRESHOLD) "PROFICIENT"
                else if (pct >= APPROACHING_THRESHOLD) "APPROACHING"
                else "BEGINNING";
    { level = level; percentage = pct * 100.0 }
  };

  /// Standard-based grading: convert percentage to grade
  public query func standardBasedGrade(percentage : Float) : async Text {
    if (percentage >= 90.0) "A"
    else if (percentage >= 80.0) "B"
    else if (percentage >= 70.0) "C"
    else if (percentage >= 60.0) "D"
    else "F"
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §5 — PEDAGOGICAL STRATEGY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Instructional methods, differentiation, evidence-based strategies.

  type PedagogicalStrategy = {
    id          : Nat;
    name        : Text;
    description : Text;
    bestFor     : [Text];  // Learning styles/situations
    steps       : [Text];
    evidence    : Float;   // Effect size (Cohen's d)
  };

  /// Recommend strategy based on context
  public query func recommendStrategy(
    studentKnowledge : Float,  // 0-1 prior knowledge
    bloomLevel : Nat,
    groupSize : Nat
  ) : async Text {
    // Low prior knowledge → direct instruction
    if (studentKnowledge < 0.3) return "DIRECT_INSTRUCTION";
    
    // Higher Bloom's levels → inquiry-based
    if (bloomLevel >= BLOOM_ANALYZE) {
      if (groupSize > 1) return "COLLABORATIVE_INQUIRY";
      return "GUIDED_INQUIRY";
    };
    
    // Application level → worked examples
    if (bloomLevel == BLOOM_APPLY) return "WORKED_EXAMPLES";
    
    // Understanding level → concept mapping
    if (bloomLevel == BLOOM_UNDERSTAND) return "CONCEPT_MAPPING";
    
    "SCAFFOLDED_PRACTICE"
  };

  /// Calculate cognitive load
  public query func cognitiveLOad(
    intrinsicComplexity : Float,  // 0-1
    extraneousLoad : Float,       // 0-1
    germaneLoad : Float           // 0-1
  ) : async { total : Float; optimal : Bool } {
    let total = intrinsicComplexity + extraneousLoad + germaneLoad;
    let optimal = total <= 1.0 and germaneLoad > extraneousLoad;
    { total = total; optimal = optimal }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §6 — STUDENT MODEL ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Knowledge tracing, misconception detection, learning analytics.

  type StudentModel = {
    studentId      : Text;
    knowledgeState : [Float];  // Per-skill mastery estimates
    learningRate   : Float;    // Individual learning velocity
    forgetRate     : Float;    // Individual forgetting rate
    misconceptions : [Text];   // Detected misconceptions
    lastActivity   : Int;
  };

  /// Bayesian Knowledge Tracing update
  /// P(Lₙ) = P(Lₙ₋₁|obs) + P(T)(1 - P(Lₙ₋₁|obs))
  public query func bktUpdate(
    priorKnowledge : Float,  // P(Lₙ₋₁)
    correct : Bool,
    pSlip : Float,           // P(slip | knows)
    pGuess : Float,          // P(guess | doesn't know)
    pTransit : Float         // P(learn | didn't know)
  ) : async Float {
    // P(L|correct) = P(L)(1-P(S)) / [P(L)(1-P(S)) + (1-P(L))P(G)]
    // P(L|incorrect) = P(L)P(S) / [P(L)P(S) + (1-P(L))(1-P(G))]
    let pCorrectGivenKnows = 1.0 - pSlip;
    let pCorrectGivenNotKnows = pGuess;
    
    let posterior = if (correct) {
      let num = priorKnowledge * pCorrectGivenKnows;
      let denom = num + (1.0 - priorKnowledge) * pCorrectGivenNotKnows;
      if (denom > 0.0) num / denom else priorKnowledge
    } else {
      let num = priorKnowledge * pSlip;
      let denom = num + (1.0 - priorKnowledge) * (1.0 - pGuess);
      if (denom > 0.0) num / denom else priorKnowledge
    };
    
    // Learning transition
    posterior + pTransit * (1.0 - posterior)
  };

  /// Detect potential misconception from error pattern
  public query func detectMisconception(
    errorPattern : Text,
    correctAnswer : Text,
    studentAnswer : Text
  ) : async { detected : Bool; misconception : Text } {
    // Simplified pattern matching
    if (_textContains(studentAnswer, "add") and _textContains(correctAnswer, "multiply")) {
      return { detected = true; misconception = "Confusing addition with multiplication" };
    };
    if (_textContains(errorPattern, "sign_error")) {
      return { detected = true; misconception = "Sign/negative number confusion" };
    };
    if (_textContains(errorPattern, "order_of_ops")) {
      return { detected = true; misconception = "Order of operations error" };
    };
    { detected = false; misconception = "" }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §7 — CONTENT SEQUENCING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Prerequisite graphs, learning paths, optimal sequencing.

  /// Check if prerequisites are met
  public query func prerequisitesMet(
    skillMasteries : [Float],
    prerequisiteIds : [Nat],
    threshold : Float
  ) : async Bool {
    for (preReqId in prerequisiteIds.vals()) {
      if (preReqId < skillMasteries.size()) {
        if (skillMasteries[preReqId] < threshold) return false;
      };
    };
    true
  };

  /// Calculate readiness for a concept
  public query func conceptReadiness(
    prerequisiteMasteries : [Float],
    prerequisiteWeights : [Float]
  ) : async Float {
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;
    let n = if (prerequisiteMasteries.size() < prerequisiteWeights.size()) 
            prerequisiteMasteries.size() else prerequisiteWeights.size();
    var i : Nat = 0;
    while (i < n) {
      weightedSum += prerequisiteMasteries[i] * prerequisiteWeights[i];
      totalWeight += prerequisiteWeights[i];
      i += 1;
    };
    if (totalWeight > 0.0) weightedSum / totalWeight else 0.0
  };

  /// Recommend next topic based on mastery and prerequisites
  public query func recommendNextTopic(
    currentMasteries : [Float],
    prerequisiteGraph : [[Nat]],  // prerequisiteGraph[i] = prerequisites for topic i
    weights : [Float]
  ) : async Nat {
    var bestTopic : Nat = 0;
    var bestScore : Float = -1.0;
    
    var i : Nat = 0;
    while (i < currentMasteries.size()) {
      // Skip if already mastered
      if (currentMasteries[i] >= MASTERY_THRESHOLD) {
        i += 1;
        continue;
      };
      
      // Check prerequisites
      var prereqMet = true;
      var prereqSum : Float = 0.0;
      if (i < prerequisiteGraph.size()) {
        for (preReq in prerequisiteGraph[i].vals()) {
          if (preReq < currentMasteries.size()) {
            if (currentMasteries[preReq] < PROFICIENT_THRESHOLD) prereqMet := false;
            prereqSum += currentMasteries[preReq];
          };
        };
      };
      
      if (prereqMet) {
        // Score based on readiness and importance
        let weight = if (i < weights.size()) weights[i] else 1.0;
        let score = prereqSum * weight / (1.0 + currentMasteries[i]);
        if (score > bestScore) {
          bestScore := score;
          bestTopic := i;
        };
      };
      
      i += 1;
    };
    
    bestTopic
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §8 — SCAFFOLDING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Zone of Proximal Development, hints, fading support.

  /// Determine ZPD boundaries
  public query func zpdBoundaries(
    currentMastery : Float,
    taskDifficulty : Float
  ) : async { inZPD : Bool; supportLevel : Float } {
    // Task is in ZPD if student can do with support but not independently
    let gap = taskDifficulty - currentMastery;
    let inZPD = gap > 0.0 and gap <= (ZPD_UPPER_BOUND - ZPD_LOWER_BOUND);
    
    // Support level: higher gap = more support needed
    let supportLevel = if (gap <= 0.0) 0.0
                       else if (gap >= 0.5) 1.0
                       else gap * 2.0;
    
    { inZPD = inZPD; supportLevel = supportLevel }
  };

  /// Generate hint level based on attempts
  public query func hintLevel(
    attempts : Nat,
    maxHints : Nat
  ) : async { level : Nat; description : Text } {
    if (attempts == 0) return { level = 0; description = "No hint yet - try first" };
    if (attempts == 1) return { level = 1; description = "Metacognitive prompt" };
    if (attempts == 2) return { level = 2; description = "Strategic hint" };
    if (attempts == 3) return { level = 3; description = "Specific hint" };
    if (attempts >= 4) return { level = 4; description = "Bottom-out hint with answer" };
    { level = attempts; description = "Graduated hint" }
  };

  /// Calculate fading schedule
  public query func fadingSchedule(
    initialSupport : Float,
    successRate : Float,
    trialsCompleted : Nat
  ) : async Float {
    // Fade support as success increases
    let successFactor = successRate * Float.fromInt(trialsCompleted) / 10.0;
    let newSupport = initialSupport * (1.0 - successFactor);
    _clamp(newSupport, 0.0, 1.0)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §9 — FEEDBACK ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Formative feedback, corrective feedback, motivational feedback.

  type FeedbackType = { #CORRECT; #PARTIAL; #INCORRECT; #EFFORT };

  /// Generate feedback based on response
  public query func generateFeedback(
    isCorrect : Bool,
    partialCredit : Float,  // 0-1
    effortLevel : Float,    // 0-1
    streakCount : Nat
  ) : async { feedbackType : Text; message : Text } {
    if (isCorrect) {
      if (streakCount >= 3) {
        return { feedbackType = "MASTERY"; message = "Excellent! You've mastered this concept." };
      };
      return { feedbackType = "CORRECT"; message = "Great job! That's correct." };
    };
    
    if (partialCredit >= 0.5) {
      return { feedbackType = "PARTIAL"; message = "Good thinking! You're on the right track." };
    };
    
    if (effortLevel >= 0.7) {
      return { feedbackType = "EFFORT"; message = "Good effort! Let's review the concept together." };
    };
    
    { feedbackType = "INCORRECT"; message = "Not quite. Let's try a different approach." }
  };

  /// Calculate feedback effectiveness
  public query func feedbackEffectiveness(
    priorPerformance : Float,
    postPerformance : Float,
    feedbackGiven : Bool
  ) : async Float {
    if (not feedbackGiven) return 0.0;
    postPerformance - priorPerformance
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §10 — ENGAGEMENT ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Gamification, intrinsic motivation, flow state.

  type EngagementMetrics = {
    timeOnTask     : Nat;     // Seconds
    problemsAttempted : Nat;
    hintsUsed      : Nat;
    voluntaryRevisits : Nat;
    streakDays     : Nat;
  };

  /// Calculate engagement score
  public query func engagementScore(
    timeOnTask : Nat,
    problemsAttempted : Nat,
    hintsUsed : Nat,
    accuracy : Float
  ) : async Float {
    let timeScore = Float.fromInt(if (timeOnTask > 3600) 3600 else timeOnTask) / 3600.0;
    let problemScore = Float.fromInt(if (problemsAttempted > 20) 20 else problemsAttempted) / 20.0;
    let independenceScore = 1.0 - (Float.fromInt(hintsUsed) / Float.fromInt(problemsAttempted + 1));
    
    (timeScore * 0.3 + problemScore * 0.3 + independenceScore * 0.2 + accuracy * 0.2)
  };

  /// Check for flow state
  public query func isInFlowState(
    skillLevel : Float,
    challengeLevel : Float,
    tolerance : Float
  ) : async Bool {
    // Flow when challenge matches skill
    _abs(skillLevel - challengeLevel) <= tolerance
  };

  /// Calculate XP for gamification
  public query func calculateXP(
    problemsDone : Nat,
    accuracy : Float,
    streakBonus : Nat,
    firstTryBonus : Nat
  ) : async Nat {
    let baseXP = problemsDone * 10;
    let accuracyBonus = Float.toInt(accuracy * 50.0);
    let streak = streakBonus * 5;
    let firstTry = firstTryBonus * 15;
    Int.abs(baseXP + accuracyBonus + streak + firstTry)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §11 — ACCESSIBILITY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Universal design, accommodations, accessibility features.

  type AccommodationType = {
    code        : Text;  // e.g., "EXT_TIME", "TTS", "LARGE_PRINT"
    name        : Text;
    description : Text;
    multiplier  : Float; // For time-based accommodations
  };

  /// Calculate adjusted time with accommodations
  public query func adjustedTime(
    baseTime : Nat,
    timeMultiplier : Float
  ) : async Nat {
    let adjusted = Float.fromInt(baseTime) * timeMultiplier;
    Int.abs(Float.toInt(adjusted))
  };

  /// Get recommended accommodations
  public query func recommendAccommodations(
    readingLevel : Float,     // Grade level equivalent
    processingSpeed : Float,  // 0-1, 1 = typical
    attentionSpan : Float     // 0-1, 1 = typical
  ) : async [Text] {
    let accommodations = Buffer.Buffer<Text>(5);
    
    if (readingLevel < 0.7) {
      accommodations.add("TEXT_TO_SPEECH");
      accommodations.add("SIMPLIFIED_LANGUAGE");
    };
    if (processingSpeed < 0.7) {
      accommodations.add("EXTENDED_TIME");
      accommodations.add("REDUCED_DISTRACTORS");
    };
    if (attentionSpan < 0.6) {
      accommodations.add("FREQUENT_BREAKS");
      accommodations.add("CHUNKED_CONTENT");
    };
    
    Buffer.toArray(accommodations)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §12 — GRANT COMPLIANCE ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Title I, Title IV-A, TEA STEM, NSF compliance verification.

  type GrantProgram = {
    code        : Text;
    name        : Text;
    agency      : Text;
    eligibility : [Text];
    requirements: [Text];
    fundingRange: { min : Nat; max : Nat };
  };

  let GRANT_PROGRAMS : [{
    code : Text; name : Text; agency : Text;
    minFunding : Nat; maxFunding : Nat
  }] = [
    { code = "TITLE_I";    name = "Title I Part A"; agency = "DOE"; minFunding = 50000;  maxFunding = 5000000 },
    { code = "TITLE_IVA";  name = "Title IV-A SSAE"; agency = "DOE"; minFunding = 10000;  maxFunding = 500000 },
    { code = "TEA_STEM";   name = "TEA STEM Grant"; agency = "TEA"; minFunding = 25000;  maxFunding = 200000 },
    { code = "NSF_STEM";   name = "NSF K-12 STEM"; agency = "NSF"; minFunding = 100000; maxFunding = 1000000 },
    { code = "ERATE";      name = "E-Rate Program"; agency = "FCC"; minFunding = 5000;   maxFunding = 100000 }
  ];

  /// Check grant eligibility
  public query func checkGrantEligibility(
    schoolType : Text,       // "PUBLIC" | "CHARTER" | "PRIVATE"
    percentFRL : Float,      // Free/Reduced Lunch percentage
    studentCount : Nat,
    grantCode : Text
  ) : async { eligible : Bool; reason : Text } {
    // Title I requires >40% FRL
    if (grantCode == "TITLE_I") {
      if (schoolType != "PUBLIC") {
        return { eligible = false; reason = "Title I requires public school" };
      };
      if (percentFRL < 40.0) {
        return { eligible = false; reason = "Requires >40% Free/Reduced Lunch" };
      };
      return { eligible = true; reason = "Eligible for Title I Part A" };
    };
    
    // Title IV-A available to all public schools
    if (grantCode == "TITLE_IVA") {
      if (schoolType != "PUBLIC" and schoolType != "CHARTER") {
        return { eligible = false; reason = "Title IV-A requires public or charter school" };
      };
      return { eligible = true; reason = "Eligible for Title IV-A SSAE" };
    };
    
    // TEA STEM - Texas schools
    if (grantCode == "TEA_STEM") {
      return { eligible = true; reason = "Eligible for TEA STEM Grant" };
    };
    
    { eligible = false; reason = "Unknown grant program" }
  };

  /// Get grant programs for activity
  public query func getApplicableGrants(
    activityType : Text,  // "MATH_TECH", "STEM_LAB", "TUTORING"
    isTitleI : Bool
  ) : async [Text] {
    let grants = Buffer.Buffer<Text>(5);
    
    if (isTitleI) grants.add("TITLE_I");
    
    if (activityType == "MATH_TECH" or activityType == "STEM_LAB") {
      grants.add("TITLE_IVA");
      grants.add("TEA_STEM");
      grants.add("NSF_STEM");
    };
    
    grants.add("ERATE");  // Technology always eligible
    
    Buffer.toArray(grants)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §13 — ANALYTICS ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Learning analytics, progress tracking, outcome prediction.

  /// Calculate learning gain
  public query func learningGain(
    preScore : Float,
    postScore : Float
  ) : async Float {
    // Normalized gain: (post - pre) / (100 - pre)
    let maxPossible = 100.0 - preScore;
    if (maxPossible <= 0.0) return 0.0;
    (postScore - preScore) / maxPossible
  };

  /// Predict time to mastery
  public query func predictTimeToMastery(
    currentMastery : Float,
    learningRate : Float,  // Mastery points per hour
    targetMastery : Float
  ) : async Float {
    if (learningRate <= 0.0) return 1e15;
    let gap = targetMastery - currentMastery;
    if (gap <= 0.0) return 0.0;
    gap / learningRate
  };

  /// Calculate growth percentile
  public query func growthPercentile(
    studentGrowth : Float,
    peerGrowths : [Float]
  ) : async Float {
    if (peerGrowths.size() == 0) return 50.0;
    var countBelow : Nat = 0;
    for (pg in peerGrowths.vals()) {
      if (pg < studentGrowth) countBelow += 1;
    };
    Float.fromInt(countBelow) / Float.fromInt(peerGrowths.size()) * 100.0
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §14 — COLLABORATION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Peer learning, group formation, collaborative dynamics.

  /// Calculate group heterogeneity score
  public query func groupHeterogeneity(
    skillLevels : [Float]
  ) : async Float {
    if (skillLevels.size() < 2) return 0.0;
    var sum : Float = 0.0;
    for (s in skillLevels.vals()) { sum += s; };
    let mean = sum / Float.fromInt(skillLevels.size());
    
    var variance : Float = 0.0;
    for (s in skillLevels.vals()) {
      let diff = s - mean;
      variance += diff * diff;
    };
    variance /= Float.fromInt(skillLevels.size());
    
    _sqrt(variance)  // Standard deviation as heterogeneity
  };

  /// Form optimal groups
  public query func optimalGroupSize(
    taskComplexity : Float,
    classSize : Nat
  ) : async Nat {
    // Higher complexity → smaller groups
    let baseSize = if (taskComplexity > 0.7) 3
                   else if (taskComplexity > 0.4) 4
                   else 5;
    
    // Adjust for class size
    if (classSize < baseSize * 2) return 2;
    baseSize
  };

  /// Peer assistance effectiveness
  public query func peerAssistanceScore(
    helperMastery : Float,
    helpeeProgress : Float,
    interactionQuality : Float
  ) : async Float {
    let masteryFactor = helperMastery * 0.3;
    let progressFactor = helpeeProgress * 0.5;
    let qualityFactor = interactionQuality * 0.2;
    masteryFactor + progressFactor + qualityFactor
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §15 — HEARTBEAT & TELEMETRY (873ms)
  // ═══════════════════════════════════════════════════════════════════════════

  stable var tick        : Nat = 0;
  stable var lastCompute : Int = 0;
  stable var totalOps    : Nat = 0;

  type CurriculumEngineStatus = {
    buildNumber        : Nat;
    tick               : Nat;
    lastCompute        : Int;
    totalOps           : Nat;
    standardCount      : Nat;
    masteryThreshold   : Float;
    heartbeatMs        : Nat;
    freeForSchools     : Bool;
    sealed             : Bool;
  };

  public query func getCurriculumEngine() : async CurriculumEngineStatus {
    {
      buildNumber        = buildNumber;
      tick               = tick;
      lastCompute        = lastCompute;
      totalOps           = totalOps;
      standardCount      = standardCount;
      masteryThreshold   = MASTERY_THRESHOLD;
      heartbeatMs        = HEARTBEAT_MS;
      freeForSchools     = true;
      sealed             = genesisLocked;
    }
  };

  /// 873ms heartbeat
  public shared(msg) func heartbeat() : async { tick : Nat; status : Text } {
    tick += 1;
    lastCompute := Time.now();
    { tick = tick; status = "CURRICULUM_ENGINE_ALIVE" }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §16 — STREAM PUBLISHING
  // ═══════════════════════════════════════════════════════════════════════════

  stable var streamCanisterId : Principal = Principal.fromText("aaaaa-aa");

  public shared(msg) func setStreamCanister(canisterId : Principal) : async Bool {
    if (not _isArchitect(msg.caller)) return false;
    streamCanisterId := canisterId;
    true
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERNAL UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════

  func _abs(x : Float) : Float { if (x < 0.0) -x else x };
  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var prev : Float = 0.0;
    var n : Nat = 0;
    while (_abs(guess - prev) > 1e-15 and n < 50) {
      prev := guess;
      guess := 0.5 * (guess + x / guess);
      n += 1;
    };
    guess
  };

  func _exp(x : Float) : Float {
    let clamped = _clamp(x, -20.0, 20.0);
    var term : Float = 1.0;
    var sum = term;
    var n : Nat = 1;
    while (n < 20) {
      term *= clamped / Float.fromInt(n);
      sum += term;
      n += 1;
    };
    sum
  };

  func _textContains(haystack : Text, needle : Text) : Bool {
    let haystackLower = Text.toLowercase(haystack);
    let needleLower = Text.toLowercase(needle);
    Text.contains(haystackLower, #text needleLower)
  };

};
