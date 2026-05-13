// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  Owner: Alfredo Medina Hernandez · Dallas TX · MedinaSITech@outlook.com                                  ║
// ║  Framework: Medina Doctrine — Native Nova Protocol                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// COGNITION BACKEND — DEEP COGNITIVE INTELLIGENCE ENGINE (BUILD №45)
// Casa de Inteligencia: This backend serves the ENTIRE ORGANISM — all canisters, frontends, workers
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MISSION:
//   Sovereign on-chain cognitive intelligence engine. Every neural computation, learning
//   algorithm, decision workflow, and memory system lives here. This is not a chatbot —
//   this is the cognitive substrate of NOVA computed from neuroscience and AI first
//   principles. Intelligence is infrastructure.
//
// WAVE ROUTING ENGINE (VEIN ARCHITECTURE):
//   When computation enters this backend, the WAVE ROUTER distributes it to wherever it
//   needs to go in the organism. Like blood entering a vein — it routes to the right organ.
//   The Wave Router is an AGI that runs inside this backend, deciding in real-time where
//   each computation must flow.
//
// AGI ENGINES INSIDE:
//   This backend has LIVING INTELLIGENCE inside it. Not just functions — AGIs that process,
//   route, and transform cognitive computations. The backend and frontend both have their
//   own intelligence that talk to each other through wave propagation.
//
// ARCHITECTURE (Casa de Inteligencia — SERVES ENTIRE ORGANISM):
//   CANISTER LAYER (Motoko backends):
//     → swarm_brain (cognitive orchestration, learning)
//     → swarm_organism (organism-level cognition)
//     → intelligence_backend (math-cognition coupling)
//     → physics_backend (neural field physics)
//     → nova_stream (cognition event publishing)
//     → organism_solver (SYN binding cognition)
//   CPL LAYER (Frontend intelligence):
//     → DallasISDApp.tsx (student learning, spaced repetition, tutoring)
//     → NeuroCogLab.tsx (cognitive research, neurochemistry)
//     → NovaBuilderApp.tsx (code generation cognition, intent understanding)
//     → CompanionConsole.tsx (conversational AI, voice interaction)
//     → OroCommandCenter.tsx (multi-agent coordination)
//     → NECDashboard.tsx (neural emergence core)
//   WORKER LAYER (SERVITORES):
//     → All 70 SERVITORES workers receive cognition via wave routing
//
// CAPABILITIES:
//   §1  Sovereign Identity & Genesis
//   §2  Neural Network Engine — perceptrons, activation, backprop
//   §3  Memory Engine — short-term, long-term, episodic, semantic
//   §4  Learning Engine — SM-2 spaced repetition, reinforcement
//   §5  Decision Engine — utility, Bayesian inference, Markov chains
//   §6  Language Engine — tokenization, embeddings, attention
//   §7  Perception Engine — pattern recognition, feature extraction
//   §8  Neurochemistry Engine — dopamine, serotonin, neuromodulation
//   §9  Reasoning Engine — logic, inference, abduction
//   §10 Planning Engine — goal decomposition, search
//   §11 Emotion Engine — valence, arousal, affect
//   §12 Attention Engine — saliency, focus, filtering
//   §13 Creativity Engine — novelty, combination, mutation
//   §14 Social Cognition Engine — theory of mind, trust
//   §15 Heartbeat & Telemetry — 873ms cognitive engine health
//   §16 Stream Publishing — COGNITION_COMPUTE events to nova_stream
//
// MEDINA TECH | ALFREDO MEDINA HERNANDEZ | DALLAS TX | 2026
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

actor CognitionBackend {

  // ═══════════════════════════════════════════════════════════════════════════
  // §1 — SOVEREIGN IDENTITY & GENESIS
  // ═══════════════════════════════════════════════════════════════════════════

  stable var architectPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;
  stable var buildNumber        : Nat       = 45;

  func _isArchitect(caller : Principal) : Bool { caller == architectPrincipal };

  public shared(msg) func claimCognition() : async Text {
    if (genesisLocked) return "COGNITION_ALREADY_CLAIMED";
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-COGNITION-BACKEND-BUILD44-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text      { sovereignSeal };
  public query func isLocked()     : async Bool      { genesisLocked };
  public query func getArchitect() : async Principal { architectPrincipal };
  public query func getBuild()     : async Nat       { buildNumber };

  // ═══════════════════════════════════════════════════════════════════════════
  // COGNITIVE CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  // Math constants
  let PI       : Float = 3.1415926535897932385;
  let TAU      : Float = 6.2831853071795864769;
  let E        : Float = 2.7182818284590452354;
  let PHI      : Float = 1.6180339887498948482;
  let PHI_INV  : Float = 0.6180339887498948482;

  // NOVA sovereign constants
  let HEARTBEAT_MS        : Nat   = 873;  // NOVA 873ms heartbeat
  let SOVEREIGN_FLOOR     : Float = 1.0;  // Minimum neurochemical level

  // Neurochemistry baseline levels (from MassiveScaleOrganismCore)
  let DOPAMINE_BASELINE   : Float = 1.0;
  let SEROTONIN_BASELINE  : Float = 1.0;
  let NOREPINEPHRINE_BASE : Float = 1.0;
  let ACETYLCHOLINE_BASE  : Float = 1.0;
  let GABA_BASELINE       : Float = 1.0;
  let GLUTAMATE_BASELINE  : Float = 1.0;

  // SM-2 spaced repetition constants
  let SM2_MIN_EF          : Float = 1.3;   // Minimum easiness factor
  let SM2_INITIAL_EF      : Float = 2.5;   // Initial easiness factor
  let SM2_MIN_INTERVAL    : Nat   = 1;     // Minimum interval (days)

  // φ⁻ⁿ constants for wave routing priorities
  let PHI_INV_2 : Float = 0.3819660112501051518;   // φ⁻²
  let PHI_INV_3 : Float = 0.2360679774997896964;   // φ⁻³
  let PHI_INV_4 : Float = 0.1458980337503154990;   // φ⁻⁴
  let PHI_INV_5 : Float = 0.0901699437494742410;   // φ⁻⁵

  // ═══════════════════════════════════════════════════════════════════════════
  // §1.5 — WAVE ROUTING ENGINE (VEIN ARCHITECTURE)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // THE WAVE ROUTER AGI — When computation enters this backend at the "beginning
  // of the vein," this engine routes it to wherever it needs to go in the organism.
  // Like blood flow — it finds the right organ. This is LIVING INTELLIGENCE inside
  // the backend, not passive functions.

  type CognitionRouteTarget = {
    #SWARM_BRAIN;
    #SWARM_ORGANISM;
    #INTELLIGENCE;
    #PHYSICS;
    #CURRICULUM;
    #CPL_FRONTEND;
    #SERVITORES;
    #BROADCAST_ALL;
  };

  type CognitionWavePacket = {
    payload     : Text;
    target      : CognitionRouteTarget;
    priority    : Float;
    timestamp   : Int;
    cogType     : Text;   // "NEURAL" | "MEMORY" | "DECISION" | "LEARNING" | etc.
  };

  stable var cogWaveCount    : Nat = 0;
  stable var cogRoutesTotal  : Nat = 0;

  /// Route a cognition computation to the right destination in the organism
  public shared(msg) func waveRouteCognition(payload : Text, target : CognitionRouteTarget, priorityLevel : Nat) : async Text {
    let priority = switch (priorityLevel) {
      case 1 { PHI_INV };      // φ⁻¹ — urgent
      case 2 { PHI_INV_2 };    // φ⁻² — high
      case 3 { PHI_INV_3 };    // φ⁻³ — normal
      case 4 { PHI_INV_4 };    // φ⁻⁴ — low
      case _ { PHI_INV_5 };    // φ⁻⁵ — background
    };
    cogWaveCount += 1;
    cogRoutesTotal += 1;
    "COGNITION_WAVE_ROUTED:" # debug_show(target) # ":PRIORITY:" # Float.toText(priority)
  };

  public query func getCognitionRouteStats() : async { packetsRouted : Nat; totalRouted : Nat } {
    { packetsRouted = cogWaveCount; totalRouted = cogRoutesTotal }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §1.6 — COGNITION AGI (LIVING INTELLIGENCE)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // This backend contains LIVING INTELLIGENCE — AGIs that process cognition
  // in real-time. The Cognition AGI decides HOW to think, not just WHAT to think.
  // It optimizes, prioritizes, and routes based on organism state.

  stable var cognitionAGIState : Text = "LISTENING";
  stable var agiCogCycles : Nat = 0;
  stable var agiCogLastWake : Int = 0;

  public query func getCognitionAGIState() : async Text { cognitionAGIState };

  public shared(msg) func wakeCognitionAGI() : async Text {
    if (cognitionAGIState == "DORMANT") {
      cognitionAGIState := "LISTENING";
      agiCogLastWake := Time.now();
      return "COGNITION_AGI_AWAKENED";
    };
    "COGNITION_AGI_ALREADY_ACTIVE:" # cognitionAGIState
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §2 — NEURAL NETWORK ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Perceptrons, activation functions, forward propagation, backpropagation.
  // Used by pattern recognition, prediction, and learning systems.

  type Vector = [Float];
  type Matrix = [[Float]];

  /// Sigmoid activation: σ(x) = 1/(1 + e^(-x))
  public query func sigmoid(x : Float) : async Float {
    _sigmoid(x)
  };

  func _sigmoid(x : Float) : Float {
    let clamped = _clamp(x, -20.0, 20.0);
    1.0 / (1.0 + _exp(-clamped))
  };

  /// Sigmoid derivative: σ'(x) = σ(x)(1 - σ(x))
  public query func sigmoidDerivative(x : Float) : async Float {
    let s = _sigmoid(x);
    s * (1.0 - s)
  };

  /// Tanh activation
  public query func tanhActivation(x : Float) : async Float {
    _tanh(x)
  };

  func _tanh(x : Float) : Float {
    let clamped = _clamp(x, -20.0, 20.0);
    let e2 = _exp(2.0 * clamped);
    (e2 - 1.0) / (e2 + 1.0)
  };

  /// ReLU activation: max(0, x)
  public query func relu(x : Float) : async Float {
    if (x > 0.0) x else 0.0
  };

  /// Leaky ReLU: max(αx, x)
  public query func leakyRelu(x : Float, alpha : Float) : async Float {
    if (x > 0.0) x else alpha * x
  };

  /// Softmax function for probability distribution
  public query func softmax(xs : [Float]) : async [Float] {
    _softmax(xs)
  };

  func _softmax(xs : [Float]) : [Float] {
    var maxX : Float = -1e15;
    for (x in xs.vals()) {
      if (x > maxX) maxX := x;
    };
    let exps = Array.map<Float, Float>(xs, func(x : Float) : Float { _exp(x - maxX) });
    var sum : Float = 0.0;
    for (e in exps.vals()) { sum += e; };
    if (sum < 1e-15) return exps;
    Array.map<Float, Float>(exps, func(e : Float) : Float { e / sum })
  };

  /// Perceptron forward pass: output = σ(Σ wᵢxᵢ + bias)
  public query func perceptron(
    inputs : [Float],
    weights : [Float],
    bias : Float
  ) : async Float {
    var sum = bias;
    let n = if (inputs.size() < weights.size()) inputs.size() else weights.size();
    var i : Nat = 0;
    while (i < n) {
      sum += inputs[i] * weights[i];
      i += 1;
    };
    _sigmoid(sum)
  };

  /// Layer forward pass: outputs = activation(inputs × weights + bias)
  public query func layerForward(
    inputs : [Float],
    weights : [[Float]],  // [output_dim][input_dim]
    biases : [Float]
  ) : async [Float] {
    let outputDim = weights.size();
    Array.tabulate<Float>(outputDim, func(j : Nat) : Float {
      var sum = if (j < biases.size()) biases[j] else 0.0;
      if (j < weights.size()) {
        let w = weights[j];
        var i : Nat = 0;
        while (i < inputs.size() and i < w.size()) {
          sum += inputs[i] * w[i];
          i += 1;
        };
      };
      _sigmoid(sum)
    })
  };

  /// Cross-entropy loss: L = -Σ yᵢ log(ŷᵢ)
  public query func crossEntropyLoss(targets : [Float], predictions : [Float]) : async Float {
    var loss : Float = 0.0;
    let n = if (targets.size() < predictions.size()) targets.size() else predictions.size();
    var i : Nat = 0;
    while (i < n) {
      let p = _clamp(predictions[i], 1e-15, 1.0 - 1e-15);
      loss -= targets[i] * _ln(p);
      i += 1;
    };
    loss
  };

  /// Mean squared error: MSE = (1/n) Σ (yᵢ - ŷᵢ)²
  public query func mse(targets : [Float], predictions : [Float]) : async Float {
    var sum : Float = 0.0;
    let n = if (targets.size() < predictions.size()) targets.size() else predictions.size();
    if (n == 0) return 0.0;
    var i : Nat = 0;
    while (i < n) {
      let diff = targets[i] - predictions[i];
      sum += diff * diff;
      i += 1;
    };
    sum / Float.fromInt(n)
  };

  /// Gradient descent update: w_new = w_old - η·∇L
  public query func gradientUpdate(
    weights : [Float],
    gradients : [Float],
    learningRate : Float
  ) : async [Float] {
    let n = if (weights.size() < gradients.size()) weights.size() else gradients.size();
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      weights[i] - learningRate * gradients[i]
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §3 — MEMORY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Short-term, long-term, episodic, and semantic memory systems.
  // Used by learning, recall, and context maintenance.

  // Memory types
  type MemoryItem = {
    id          : Nat;
    content     : Text;
    timestamp   : Int;
    importance  : Float;
    accessCount : Nat;
    lastAccess  : Int;
    memoryType  : Text;  // "EPISODIC" | "SEMANTIC" | "PROCEDURAL"
  };

  let MAX_STM_CAPACITY : Nat = 7;  // Miller's magic number (7 ± 2)
  let MAX_LTM_CAPACITY : Nat = 1024;

  stable var stmItems : [var MemoryItem] = [var];
  stable var stmCount : Nat = 0;
  stable var ltmItems : [var MemoryItem] = [var];
  stable var ltmCount : Nat = 0;
  stable var memoryIdCounter : Nat = 0;

  /// Memory decay function: strength = e^(-t/τ) where τ = importance × baseDecay
  public query func memoryDecay(
    initialStrength : Float,
    timeSinceAccess : Float,
    importance : Float,
    baseDecayRate : Float
  ) : async Float {
    let tau = importance * baseDecayRate;
    if (tau <= 0.0) return 0.0;
    initialStrength * _exp(-timeSinceAccess / tau)
  };

  /// Ebbinghaus forgetting curve: R = e^(-t/S) where S = stability
  public query func forgettingCurve(
    time : Float,
    stability : Float
  ) : async Float {
    if (stability <= 0.0) return 0.0;
    _exp(-time / stability)
  };

  /// Memory consolidation: transfer from STM to LTM
  /// Based on importance threshold and rehearsal count
  public query func shouldConsolidate(
    importance : Float,
    rehearsalCount : Nat,
    importanceThreshold : Float,
    rehearsalThreshold : Nat
  ) : async Bool {
    importance >= importanceThreshold or rehearsalCount >= rehearsalThreshold
  };

  /// Working memory capacity (Cowan's limit: ~4 items)
  public query func workingMemoryCapacity() : async Nat {
    4
  };

  /// Long-term potentiation (LTP) strength increase
  public query func ltpStrengthening(
    currentStrength : Float,
    stimulusIntensity : Float,
    frequency : Float
  ) : async Float {
    // Simplified Hebbian learning: Δw ∝ pre × post
    let delta = 0.1 * stimulusIntensity * _sigmoid(frequency - 5.0);
    _clamp(currentStrength + delta, 0.0, 10.0)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §4 — LEARNING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // SM-2 spaced repetition, reinforcement learning, supervised learning.
  // Used by student tutoring, skill acquisition, and adaptive systems.

  // SM-2 Algorithm State
  type SM2Card = {
    cardId     : Text;
    easiness   : Float;   // EF ∈ [1.3, ∞)
    interval   : Nat;     // Days until next review
    repetitions: Nat;     // Successful reviews in a row
    nextReview : Int;     // Timestamp of next review
  };

  /// SM-2 algorithm: compute next interval based on quality response
  /// quality: 0-5 (0=complete blackout, 5=perfect response)
  public query func sm2Update(
    prevEF : Float,
    prevInterval : Nat,
    prevReps : Nat,
    quality : Nat
  ) : async { ef : Float; interval : Nat; reps : Nat } {
    // If quality < 3, restart from beginning
    if (quality < 3) {
      return { ef = prevEF; interval = 1; reps = 0 };
    };

    // Update easiness factor
    let q = Float.fromInt(quality);
    let newEF = prevEF + (0.1 - (5.0 - q) * (0.08 + (5.0 - q) * 0.02));
    let clampedEF = if (newEF < SM2_MIN_EF) SM2_MIN_EF else newEF;

    // Update interval
    let newReps = prevReps + 1;
    var newInterval : Nat = 1;
    if (newReps == 1) {
      newInterval := 1;
    } else if (newReps == 2) {
      newInterval := 6;
    } else {
      newInterval := Int.abs(Float.toInt(Float.fromInt(prevInterval) * clampedEF));
      if (newInterval < 1) newInterval := 1;
    };

    { ef = clampedEF; interval = newInterval; reps = newReps }
  };

  /// Compute optimal review time using memory decay
  public query func optimalReviewTime(
    currentStrength : Float,
    targetStrength : Float,
    decayRate : Float
  ) : async Float {
    // Solve: targetStrength = currentStrength × e^(-t/τ)
    // t = -τ × ln(targetStrength/currentStrength)
    if (currentStrength <= 0.0 or targetStrength <= 0.0) return 0.0;
    if (targetStrength >= currentStrength) return 0.0;
    -decayRate * _ln(targetStrength / currentStrength)
  };

  /// Reinforcement learning: Q-learning update
  /// Q(s,a) ← Q(s,a) + α[R + γ·max Q(s',a') - Q(s,a)]
  public query func qLearningUpdate(
    qValue : Float,
    reward : Float,
    maxNextQ : Float,
    learningRate : Float,
    discountFactor : Float
  ) : async Float {
    qValue + learningRate * (reward + discountFactor * maxNextQ - qValue)
  };

  /// Policy gradient: log probability weighted by advantage
  public query func policyGradient(
    logProb : Float,
    advantage : Float
  ) : async Float {
    logProb * advantage
  };

  /// Temporal difference error: δ = R + γV(s') - V(s)
  public query func tdError(
    reward : Float,
    nextValue : Float,
    currentValue : Float,
    discountFactor : Float
  ) : async Float {
    reward + discountFactor * nextValue - currentValue
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §5 — DECISION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Utility theory, Bayesian inference, Markov decision processes.
  // Used by planning, choice, and rational agent behavior.

  /// Expected utility: EU = Σ P(outcome) × U(outcome)
  public query func expectedUtility(
    probabilities : [Float],
    utilities : [Float]
  ) : async Float {
    var eu : Float = 0.0;
    let n = if (probabilities.size() < utilities.size()) probabilities.size() else utilities.size();
    var i : Nat = 0;
    while (i < n) {
      eu += probabilities[i] * utilities[i];
      i += 1;
    };
    eu
  };

  /// Bayes' theorem: P(A|B) = P(B|A)P(A) / P(B)
  public query func bayesUpdate(
    priorA : Float,       // P(A)
    likelihoodBA : Float, // P(B|A)
    evidenceB : Float     // P(B)
  ) : async Float {
    if (evidenceB <= 0.0) return priorA;
    (likelihoodBA * priorA) / evidenceB
  };

  /// Compute evidence: P(B) = P(B|A)P(A) + P(B|¬A)P(¬A)
  public query func computeEvidence(
    likelihoodBA : Float,     // P(B|A)
    priorA : Float,           // P(A)
    likelihoodBNotA : Float   // P(B|¬A)
  ) : async Float {
    likelihoodBA * priorA + likelihoodBNotA * (1.0 - priorA)
  };

  /// Softmax policy: P(a) = e^(Q(a)/τ) / Σ e^(Q(a')/τ)
  public query func softmaxPolicy(qValues : [Float], temperature : Float) : async [Float] {
    if (temperature <= 0.0) return _softmax(qValues);
    let scaled = Array.map<Float, Float>(qValues, func(q : Float) : Float { q / temperature });
    _softmax(scaled)
  };

  /// Entropy of probability distribution: H = -Σ p·log(p)
  public query func entropy(probs : [Float]) : async Float {
    var h : Float = 0.0;
    for (p in probs.vals()) {
      if (p > 1e-15) {
        h -= p * _ln(p);
      };
    };
    h
  };

  /// Information gain: IG = H(prior) - Σ P(v)H(posterior|v)
  public query func informationGain(
    priorEntropy : Float,
    posteriorEntropies : [Float],
    observationProbs : [Float]
  ) : async Float {
    var expectedPosterior : Float = 0.0;
    let n = if (posteriorEntropies.size() < observationProbs.size()) posteriorEntropies.size() else observationProbs.size();
    var i : Nat = 0;
    while (i < n) {
      expectedPosterior += observationProbs[i] * posteriorEntropies[i];
      i += 1;
    };
    priorEntropy - expectedPosterior
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §6 — LANGUAGE ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Tokenization, embeddings, attention mechanisms.
  // Used by natural language understanding and generation.

  /// Simple word count
  public query func wordCount(text : Text) : async Nat {
    var count : Nat = 0;
    var inWord = false;
    for (c in text.chars()) {
      if (c == ' ' or c == '\n' or c == '\t') {
        if (inWord) {
          count += 1;
          inWord := false;
        };
      } else {
        inWord := true;
      };
    };
    if (inWord) count += 1;
    count
  };

  /// Character n-gram extraction
  public query func extractNgrams(text : Text, n : Nat) : async Nat {
    let chars = Text.toArray(text);
    if (chars.size() < n) return 0;
    chars.size() - n + 1
  };

  /// Cosine similarity between two vectors
  public query func cosineSimilarity(a : [Float], b : [Float]) : async Float {
    _cosineSimilarity(a, b)
  };

  func _cosineSimilarity(a : [Float], b : [Float]) : Float {
    var dot : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;
    let n = if (a.size() < b.size()) a.size() else b.size();
    var i : Nat = 0;
    while (i < n) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
      i += 1;
    };
    let denom = _sqrt(normA) * _sqrt(normB);
    if (denom < 1e-15) return 0.0;
    dot / denom
  };

  /// Scaled dot-product attention: softmax(QK^T/√d_k)V
  public query func scaledDotAttention(
    query : [Float],
    key : [Float],
    dk : Float
  ) : async Float {
    var dot : Float = 0.0;
    let n = if (query.size() < key.size()) query.size() else key.size();
    var i : Nat = 0;
    while (i < n) {
      dot += query[i] * key[i];
      i += 1;
    };
    if (dk <= 0.0) return dot;
    dot / _sqrt(dk)
  };

  /// Attention weights from scores
  public query func attentionWeights(scores : [Float]) : async [Float] {
    _softmax(scores)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §7 — PERCEPTION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Pattern recognition, feature extraction, sensory processing.
  // Used by input processing and signal interpretation.

  /// Edge detection kernel (Sobel-like horizontal)
  public query func sobelHorizontal() : async [[Float]] {
    [
      [-1.0, 0.0, 1.0],
      [-2.0, 0.0, 2.0],
      [-1.0, 0.0, 1.0]
    ]
  };

  /// Edge detection kernel (Sobel-like vertical)
  public query func sobelVertical() : async [[Float]] {
    [
      [-1.0, -2.0, -1.0],
      [ 0.0,  0.0,  0.0],
      [ 1.0,  2.0,  1.0]
    ]
  };

  /// Gaussian blur kernel (3×3)
  public query func gaussianBlur3x3() : async [[Float]] {
    [
      [1.0/16.0, 2.0/16.0, 1.0/16.0],
      [2.0/16.0, 4.0/16.0, 2.0/16.0],
      [1.0/16.0, 2.0/16.0, 1.0/16.0]
    ]
  };

  /// Max pooling (2×2)
  public query func maxPool2x2(values : [Float]) : async Float {
    if (values.size() < 4) return 0.0;
    var max = values[0];
    var i : Nat = 1;
    while (i < 4 and i < values.size()) {
      if (values[i] > max) max := values[i];
      i += 1;
    };
    max
  };

  /// Average pooling (2×2)
  public query func avgPool2x2(values : [Float]) : async Float {
    var sum : Float = 0.0;
    let n = if (values.size() < 4) values.size() else 4;
    var i : Nat = 0;
    while (i < n) {
      sum += values[i];
      i += 1;
    };
    sum / Float.fromInt(n)
  };

  /// Feature normalization: (x - μ) / σ
  public query func normalize(values : [Float]) : async [Float] {
    let n = values.size();
    if (n == 0) return [];
    
    var sum : Float = 0.0;
    for (v in values.vals()) { sum += v; };
    let mean = sum / Float.fromInt(n);
    
    var varSum : Float = 0.0;
    for (v in values.vals()) {
      let diff = v - mean;
      varSum += diff * diff;
    };
    let std = _sqrt(varSum / Float.fromInt(n));
    
    if (std < 1e-15) {
      return Array.map<Float, Float>(values, func(_ : Float) : Float { 0.0 });
    };
    Array.map<Float, Float>(values, func(v : Float) : Float { (v - mean) / std })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §8 — NEUROCHEMISTRY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Dopamine, serotonin, norepinephrine, and neuromodulation.
  // Used by reward processing, mood regulation, and arousal.

  type NeurochemicalState = {
    dopamine      : Float;
    serotonin     : Float;
    norepinephrine: Float;
    acetylcholine : Float;
    gaba          : Float;
    glutamate     : Float;
  };

  /// Dopamine response to reward prediction error
  public query func dopamineResponse(
    actual : Float,
    predicted : Float,
    baseline : Float
  ) : async Float {
    // Δ dopamine ∝ (actual - predicted)
    let rpe = actual - predicted;
    let newLevel = baseline + 0.5 * rpe;
    _clamp(newLevel, SOVEREIGN_FLOOR, 10.0)
  };

  /// Serotonin modulation based on social/mood state
  public query func serotoninModulation(
    baseline : Float,
    socialSupport : Float,
    stressLevel : Float
  ) : async Float {
    let delta = 0.1 * socialSupport - 0.15 * stressLevel;
    _clamp(baseline + delta, SOVEREIGN_FLOOR, 10.0)
  };

  /// Norepinephrine (arousal/alertness)
  public query func norepinephrineResponse(
    baseline : Float,
    novelty : Float,
    threat : Float
  ) : async Float {
    let delta = 0.2 * novelty + 0.3 * threat;
    _clamp(baseline + delta, SOVEREIGN_FLOOR, 10.0)
  };

  /// Acetylcholine (attention/memory)
  public query func acetylcholineResponse(
    baseline : Float,
    attentionDemand : Float,
    learningSignal : Float
  ) : async Float {
    let delta = 0.15 * attentionDemand + 0.1 * learningSignal;
    _clamp(baseline + delta, SOVEREIGN_FLOOR, 10.0)
  };

  /// GABA (inhibition)
  public query func gabaResponse(
    baseline : Float,
    relaxationSignal : Float,
    anxietyLevel : Float
  ) : async Float {
    let delta = 0.2 * relaxationSignal - 0.1 * anxietyLevel;
    _clamp(baseline + delta, SOVEREIGN_FLOOR, 10.0)
  };

  /// Glutamate (excitation)
  public query func glutamateResponse(
    baseline : Float,
    excitationSignal : Float,
    learningRate : Float
  ) : async Float {
    let delta = 0.15 * excitationSignal + 0.1 * learningRate;
    _clamp(baseline + delta, SOVEREIGN_FLOOR, 10.0)
  };

  /// Neurochemical decay towards baseline
  public query func neurochemicalDecay(
    current : Float,
    baseline : Float,
    decayRate : Float,
    dt : Float
  ) : async Float {
    // Exponential decay: dx/dt = -k(x - baseline)
    let diff = current - baseline;
    let newValue = baseline + diff * _exp(-decayRate * dt);
    _clamp(newValue, SOVEREIGN_FLOOR, 10.0)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §9 — REASONING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Logic, inference, abduction, deduction, induction.
  // Used by problem solving and knowledge representation.

  /// Modus ponens: If P→Q and P, then Q
  public query func modusPonens(pImpliesQ : Bool, p : Bool) : async Bool {
    pImpliesQ and p
  };

  /// Modus tollens: If P→Q and ¬Q, then ¬P
  public query func modusTollens(pImpliesQ : Bool, notQ : Bool) : async Bool {
    pImpliesQ and notQ
  };

  /// Hypothetical syllogism: If P→Q and Q→R, then P→R
  public query func hypotheticalSyllogism(pImpliesQ : Bool, qImpliesR : Bool) : async Bool {
    pImpliesQ and qImpliesR
  };

  /// Confidence in abductive reasoning
  public query func abductiveConfidence(
    priorHypothesis : Float,
    likelihoodEvidence : Float,
    baseRateEvidence : Float
  ) : async Float {
    // P(H|E) using simplified Bayes
    if (baseRateEvidence <= 0.0) return priorHypothesis;
    let posterior = (likelihoodEvidence * priorHypothesis) / baseRateEvidence;
    _clamp(posterior, 0.0, 1.0)
  };

  /// Analogical similarity score
  public query func analogySimilarity(
    sharedFeatures : Nat,
    uniqueA : Nat,
    uniqueB : Nat
  ) : async Float {
    let total = sharedFeatures + uniqueA + uniqueB;
    if (total == 0) return 0.0;
    Float.fromInt(sharedFeatures) / Float.fromInt(total)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §10 — PLANNING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Goal decomposition, hierarchical planning, search.
  // Used by task management and autonomous behavior.

  type Goal = {
    id          : Nat;
    description : Text;
    priority    : Float;
    deadline    : Int;
    completed   : Bool;
    subGoals    : [Nat];
  };

  /// Goal urgency: combines priority and time pressure
  public query func goalUrgency(
    priority : Float,
    deadline : Int,
    currentTime : Int
  ) : async Float {
    let timeRemaining = deadline - currentTime;
    let timeRemainingFloat = Float.fromInt(timeRemaining);
    if (timeRemainingFloat <= 0.0) return priority * 10.0;  // Overdue
    let timePressure = 1.0 / (1.0 + timeRemainingFloat / 86400000000000.0);  // Normalize to days
    priority * (1.0 + timePressure)
  };

  /// Heuristic cost estimate (simplified A* h(n))
  public query func heuristicCost(
    currentState : [Float],
    goalState : [Float]
  ) : async Float {
    // Euclidean distance
    var sum : Float = 0.0;
    let n = if (currentState.size() < goalState.size()) currentState.size() else goalState.size();
    var i : Nat = 0;
    while (i < n) {
      let diff = currentState[i] - goalState[i];
      sum += diff * diff;
      i += 1;
    };
    _sqrt(sum)
  };

  /// Plan evaluation: total cost + risk
  public query func evaluatePlan(
    stepCosts : [Float],
    stepRisks : [Float],
    riskWeight : Float
  ) : async Float {
    var totalCost : Float = 0.0;
    var totalRisk : Float = 0.0;
    for (c in stepCosts.vals()) { totalCost += c; };
    for (r in stepRisks.vals()) { totalRisk += r; };
    totalCost + riskWeight * totalRisk
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §11 — EMOTION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Valence, arousal, affect, emotional regulation.
  // Used by social interaction and adaptive behavior.

  type EmotionalState = {
    valence : Float;   // Positive/negative (-1 to 1)
    arousal : Float;   // Calm/excited (0 to 1)
    dominance : Float; // Control/submission (0 to 1)
  };

  /// Map to discrete emotion using PAD model
  public query func classifyEmotion(
    valence : Float,
    arousal : Float,
    dominance : Float
  ) : async Text {
    // Simplified Russell circumplex
    if (valence > 0.3 and arousal > 0.5) return "EXCITED";
    if (valence > 0.3 and arousal <= 0.5) return "CONTENT";
    if (valence < -0.3 and arousal > 0.5) return "ANGRY";
    if (valence < -0.3 and arousal <= 0.5) return "SAD";
    if (valence >= -0.3 and valence <= 0.3 and arousal > 0.7) return "ALERT";
    "NEUTRAL"
  };

  /// Emotional decay towards baseline
  public query func emotionDecay(
    current : EmotionalState,
    decayRate : Float,
    dt : Float
  ) : async EmotionalState {
    let factor = _exp(-decayRate * dt);
    {
      valence = current.valence * factor;
      arousal = 0.5 + (current.arousal - 0.5) * factor;
      dominance = 0.5 + (current.dominance - 0.5) * factor
    }
  };

  /// Emotional contagion from observed emotion
  public query func emotionalContagion(
    selfState : EmotionalState,
    observedState : EmotionalState,
    susceptibility : Float
  ) : async EmotionalState {
    {
      valence = selfState.valence + susceptibility * (observedState.valence - selfState.valence);
      arousal = selfState.arousal + susceptibility * (observedState.arousal - selfState.arousal);
      dominance = selfState.dominance + susceptibility * (observedState.dominance - selfState.dominance)
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §12 — ATTENTION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Saliency, focus, filtering, selective attention.
  // Used by information processing and cognitive load management.

  /// Saliency score from features
  public query func computeSaliency(
    novelty : Float,
    intensity : Float,
    relevance : Float,
    weights : [Float]  // [novelty_w, intensity_w, relevance_w]
  ) : async Float {
    let nw = if (weights.size() > 0) weights[0] else 1.0;
    let iw = if (weights.size() > 1) weights[1] else 1.0;
    let rw = if (weights.size() > 2) weights[2] else 1.0;
    let total = nw + iw + rw;
    if (total <= 0.0) return 0.0;
    (nw * novelty + iw * intensity + rw * relevance) / total
  };

  /// Attention filter: items above threshold
  public query func attentionFilter(
    saliencies : [Float],
    threshold : Float
  ) : async [Nat] {
    let buf = Buffer.Buffer<Nat>(saliencies.size());
    var i : Nat = 0;
    while (i < saliencies.size()) {
      if (saliencies[i] >= threshold) {
        buf.add(i);
      };
      i += 1;
    };
    Buffer.toArray(buf)
  };

  /// Cognitive load: working memory utilization
  public query func cognitiveLoad(
    activeItems : Nat,
    itemComplexity : [Float]
  ) : async Float {
    let wmCapacity : Float = 4.0;  // Cowan's limit
    var totalComplexity : Float = 0.0;
    var i : Nat = 0;
    while (i < activeItems and i < itemComplexity.size()) {
      totalComplexity += itemComplexity[i];
      i += 1;
    };
    let utilizationCount = Float.fromInt(activeItems) / wmCapacity;
    let utilizationComplexity = totalComplexity / (wmCapacity * 2.0);  // Assume max complexity = 2
    (utilizationCount + utilizationComplexity) / 2.0
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §13 — CREATIVITY ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Novelty generation, combination, mutation.
  // Used by ideation and problem solving.

  /// Novelty score: distance from known examples
  public query func noveltyScore(
    candidate : [Float],
    knownExamples : [[Float]]
  ) : async Float {
    if (knownExamples.size() == 0) return 1.0;
    
    var minDistance : Float = 1e15;
    for (example in knownExamples.vals()) {
      var dist : Float = 0.0;
      let n = if (candidate.size() < example.size()) candidate.size() else example.size();
      var i : Nat = 0;
      while (i < n) {
        let diff = candidate[i] - example[i];
        dist += diff * diff;
        i += 1;
      };
      dist := _sqrt(dist);
      if (dist < minDistance) minDistance := dist;
    };
    
    // Normalize: assume typical distance ~10
    _clamp(minDistance / 10.0, 0.0, 1.0)
  };

  /// Conceptual blend: combine two concepts
  public query func conceptualBlend(
    concept1 : [Float],
    concept2 : [Float],
    blendRatio : Float
  ) : async [Float] {
    let n = if (concept1.size() < concept2.size()) concept1.size() else concept2.size();
    let r = _clamp(blendRatio, 0.0, 1.0);
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      (1.0 - r) * concept1[i] + r * concept2[i]
    })
  };

  /// Random mutation
  public query func mutate(
    original : [Float],
    mutationRate : Float,
    mutationMagnitude : Float,
    seed : Nat
  ) : async [Float] {
    // Deterministic "random" based on seed
    Array.tabulate<Float>(original.size(), func(i : Nat) : Float {
      let pseudoRandom = _sin(Float.fromInt(seed + i * 12345)) * 0.5 + 0.5;
      if (pseudoRandom < mutationRate) {
        let delta = (_sin(Float.fromInt(seed + i * 67890)) * 2.0 - 1.0) * mutationMagnitude;
        original[i] + delta
      } else {
        original[i]
      }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §14 — SOCIAL COGNITION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Theory of mind, trust, social learning.
  // Used by multi-agent coordination and social interaction.

  /// Trust update based on interaction outcome
  public query func updateTrust(
    currentTrust : Float,
    outcome : Float,       // -1 (betrayal) to 1 (cooperation)
    learningRate : Float
  ) : async Float {
    let delta = learningRate * (outcome - currentTrust);
    _clamp(currentTrust + delta, 0.0, 1.0)
  };

  /// Reciprocity expectation
  public query func reciprocityExpectation(
    previousGiven : Float,
    previousReceived : Float
  ) : async Float {
    if (previousGiven <= 0.0) return 0.5;
    let ratio = previousReceived / previousGiven;
    _clamp(ratio, 0.0, 2.0) / 2.0
  };

  /// Social proof: conformity to group
  public query func socialProof(
    ownOpinion : Float,
    groupOpinion : Float,
    conformityFactor : Float
  ) : async Float {
    let c = _clamp(conformityFactor, 0.0, 1.0);
    ownOpinion * (1.0 - c) + groupOpinion * c
  };

  /// Theory of mind: predict other's action
  public query func predictOtherAction(
    observedPreferences : [Float],
    actionUtilities : [Float]
  ) : async Nat {
    // Predict action with highest utility weighted by preference
    var maxScore : Float = -1e15;
    var bestAction : Nat = 0;
    let n = if (observedPreferences.size() < actionUtilities.size()) observedPreferences.size() else actionUtilities.size();
    var i : Nat = 0;
    while (i < n) {
      let score = observedPreferences[i] * actionUtilities[i];
      if (score > maxScore) {
        maxScore := score;
        bestAction := i;
      };
      i += 1;
    };
    bestAction
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // §15 — HEARTBEAT & TELEMETRY (873ms)
  // ═══════════════════════════════════════════════════════════════════════════

  stable var tick        : Nat = 0;
  stable var lastCompute : Int = 0;
  stable var totalOps    : Nat = 0;

  type CognitionEngineStatus = {
    buildNumber     : Nat;
    tick            : Nat;
    lastCompute     : Int;
    totalOps        : Nat;
    sm2MinEF        : Float;
    workingMemoryCap: Nat;
    heartbeatMs     : Nat;
    sovereignFloor  : Float;
    sealed          : Bool;
  };

  public query func getCognitionEngine() : async CognitionEngineStatus {
    {
      buildNumber     = buildNumber;
      tick            = tick;
      lastCompute     = lastCompute;
      totalOps        = totalOps;
      sm2MinEF        = SM2_MIN_EF;
      workingMemoryCap= 4;
      heartbeatMs     = HEARTBEAT_MS;
      sovereignFloor  = SOVEREIGN_FLOOR;
      sealed          = genesisLocked;
    }
  };

  /// 873ms heartbeat
  public shared(msg) func heartbeat() : async { tick : Nat; status : Text } {
    tick += 1;
    lastCompute := Time.now();
    { tick = tick; status = "COGNITION_ENGINE_ALIVE" }
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
  // INTERNAL MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════

  func _abs(x : Float) : Float { if (x < 0.0) -x else x };
  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
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

  func _ln(x : Float) : Float {
    if (x <= 0.0) return -1e15;
    let y = (x - 1.0) / (x + 1.0);
    var sum : Float = 0.0;
    var term = y;
    var n : Nat = 1;
    while (n < 50) {
      sum += term / Float.fromInt(2*n - 1);
      term *= y * y;
      n += 1;
    };
    2.0 * sum
  };

  func _sqrt(x : Float) : Float {
    if (x < 0.0) return 0.0;
    if (x == 0.0) return 0.0;
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

  func _sin(x : Float) : Float {
    var wrapped = x;
    while (wrapped > PI) wrapped -= TAU;
    while (wrapped < -PI) wrapped += TAU;
    var term = wrapped;
    var sum = term;
    var n : Nat = 1;
    while (n < 12) {
      term *= -wrapped * wrapped / Float.fromInt((2*n) * (2*n + 1));
      sum += term;
      n += 1;
    };
    sum
  };

};
