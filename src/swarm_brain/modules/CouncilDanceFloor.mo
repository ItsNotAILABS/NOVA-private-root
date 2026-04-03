// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//  ██████╗ ██████╗ ██╗   ██╗███╗   ██╗ ██████╗██╗██╗         ██████╗  █████╗ ███╗   ██╗ ██████╗███████╗    ███████╗██╗      ██████╗  ██████╗ ██████╗ 
// ██╔════╝██╔═══██╗██║   ██║████╗  ██║██╔════╝██║██║         ██╔══██╗██╔══██╗████╗  ██║██╔════╝██╔════╝    ██╔════╝██║     ██╔═══██╗██╔═══██╗██╔══██╗
// ██║     ██║   ██║██║   ██║██╔██╗ ██║██║     ██║██║         ██║  ██║███████║██╔██╗ ██║██║     █████╗      █████╗  ██║     ██║   ██║██║   ██║██████╔╝
// ██║     ██║   ██║██║   ██║██║╚██╗██║██║     ██║██║         ██║  ██║██╔══██║██║╚██╗██║██║     ██╔══╝      ██╔══╝  ██║     ██║   ██║██║   ██║██╔══██╗
// ╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║╚██████╗██║███████╗    ██████╔╝██║  ██║██║ ╚████║╚██████╗███████╗    ██║     ███████╗╚██████╔╝╚██████╔╝██║  ██║
//  ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝╚══════╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝    ╚═╝     ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// COUNCIL DANCE FLOOR — SHARED SIGNAL BUS FOR INTER-COUNCIL COMMUNICATION
// Bee-Inspired Quality-Weighted Signal Broadcasting with Bayesian Evidence Integration
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// BIOLOGICAL INSPIRATION — HONEYBEE WAGGLE DANCE FLOOR
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// In the honeybee colony, the "dance floor" is a physical surface where scouts return
// to communicate discovered nest sites. Key properties:
//
// 1. SHARED SURFACE: All scouts dance on the SAME surface — information is PUBLIC
// 2. QUALITY-WEIGHTED SIGNALING: Higher quality sites get more dance circuits
// 3. COMPETITIVE DYNAMICS: Multiple dances compete for attention simultaneously
// 4. BAYESIAN EVIDENCE: Recruits evaluate and update beliefs based on accumulated dances
// 5. NATURAL DECAY: Dances fade over time (fixed circuit count, then stop)
// 6. CROSS-EVALUATION: Scouts can visit competing sites and adjust enthusiasm
// 7. QUORUM EMERGENCE: Consensus emerges from distributed evaluation, not central command
//
// THE ORGANISM EQUIVALENT:
// ─────────────────────────
// In the organism, we have 7 councils: COGNUS, NEXUS, AURUM, LEXIS, SOLUS, VETUS, MERIDIAN
// Currently, these process INDEPENDENTLY with no shared communication surface.
//
// The Council Dance Floor provides:
// - A shared signal bus where councils post quality-weighted signals
// - Cross-council evaluation and influence
// - Bayesian-equivalent evidence integration
// - Natural signal decay (prevent stale attractors)
// - Emergent consensus without central control
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MATHEMATICAL FOUNDATIONS — QUALITY-WEIGHTED SIGNAL DYNAMICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// 1. SIGNAL POSTING EQUATION
//    ────────────────────────
//    When council i posts signal s_i with quality q_i:
//    
//    SignalStrength_i(t) = q_i × CircuitsRemaining_i(t) × Enthusiasm_i(t) × Φ_M^(rank_i/N)
//    
//    where:
//      q_i ∈ [0, 1] = Quality assessment of proposed action/state
//      CircuitsRemaining_i(t) = max(0, InitialCircuits - DecayRate × t)
//      Enthusiasm_i(t) = Enthusiasm_i(0) × exp(-λ_decay × t) × (1 - CompetitorInfluence)
//      rank_i = Quality rank among all active signals (1 = best)
//      N = Number of active signals
//      Φ_M = 2.97442179 (Medina golden harmonic)
//
// 2. DANCE CIRCUIT DYNAMICS
//    ───────────────────────
//    Each signal starts with circuits proportional to quality:
//    
//    InitialCircuits_i = floor(MinCircuits + (MaxCircuits - MinCircuits) × q_i^Φ_M)
//    
//    Constants:
//      MinCircuits = 3 (poor quality)
//      MaxCircuits = 200 (excellent quality)
//    
//    This is the bee mechanism: better sites get more advertising.
//
// 3. SIGNAL VISIBILITY FUNCTION
//    ──────────────────────────
//    A council's signal visibility on the dance floor:
//    
//    Visibility_i(t) = SignalStrength_i(t) / Σⱼ SignalStrength_j(t)
//    
//    This is soft attention — all signals contribute proportionally.
//
// 4. RECRUITMENT RATE EQUATION
//    ─────────────────────────
//    Other councils "recruit" to a signal at rate:
//    
//    RecruitRate_i(t) = BaseRecruit × Visibility_i(t) × AttentionCapacity × Φ(Novelty_i)
//    
//    where:
//      BaseRecruit = 0.1 councils per beat
//      AttentionCapacity = 1 - Σⱼ∈Already Recruited Visibility_j (limited attention)
//      Φ(Novelty) = 1 + 0.5 × exp(-t_since_first_post / τ_novelty) (novelty boost)
//      τ_novelty = 20 beats
//
// 5. CROSS-EVALUATION DYNAMICS
//    ─────────────────────────
//    Councils evaluate competing signals and adjust their own enthusiasm:
//    
//    If council i evaluates signal j with quality q_j:
//      Enthusiasm_i(t+1) = Enthusiasm_i(t) × (1 - α × H(q_j - q_i))
//    
//    where:
//      α = 0.1 (evaluation impact)
//      H(x) = 1 if x > 0, else 0 (Heaviside)
//    
//    Translation: If you find a better competing signal, your enthusiasm drops.
//
// 6. BAYESIAN EVIDENCE INTEGRATION
//    ─────────────────────────────
//    Each council maintains belief over signals:
//    
//    P(Signal_i is best | Evidence_t) ∝ P(Evidence_t | Signal_i best) × P(Signal_i best | Evidence_{t-1})
//    
//    Concrete implementation:
//      Belief_i(t) = Belief_i(t-1) × LikelihoodRatio_i(t) / Z(t)
//    
//    where:
//      LikelihoodRatio_i(t) = exp(Φ_M × (Visibility_i(t) - μ_visibility))
//      Z(t) = normalization constant (sum of all Belief × Likelihood)
//
// 7. CONSENSUS STRENGTH METRIC
//    ─────────────────────────
//    Measure of how concentrated belief is:
//    
//    Consensus(t) = 1 - Entropy(Belief_distribution) / log(N_signals)
//    
//    Entropy(P) = -Σᵢ Pᵢ × log(Pᵢ)
//    
//    Consensus ∈ [0, 1]: 0 = uniform belief, 1 = single signal dominates
//
// 8. QUORUM DETECTION
//    ─────────────────
//    Quorum reached when:
//    
//    QuorumReached = (Belief_max > QuorumThreshold) AND (Consensus > ConsensusThreshold)
//    
//    where:
//      QuorumThreshold = 0.6 (60% belief in winner)
//      ConsensusThreshold = 0.7 (70% consensus)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MEDINA ENHANCEMENTS TO DANCE FLOOR DYNAMICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// 1. MEDINA SOVEREIGN-BOUNDED BELIEFS
//    ─────────────────────────────────
//    All beliefs bounded to [S₀/N, 1 - S₀×(N-1)/N] to prevent complete extinction:
//    
//    Belief_bounded = S₀/N + (1 - S₀) × Belief_raw
//
// 2. MEDINA COMPOUND CONSENSUS
//    ─────────────────────────
//    Consensus compounds over time when signals align:
//    
//    Consensus_compound(t) = Consensus(t) × (1 + r_compound)^t_aligned / Φ_M
//    
//    where t_aligned = consecutive beats with Consensus > 0.5
//
// 3. MEDINA GOLDEN RATIO SCHEDULING
//    ──────────────────────────────
//    High-quality signals get Fibonacci-scheduled bonus circuits:
//    
//    BonusCircuits = Fib(floor(q × 10)) for q > 0.7
//
// 4. MEDINA CROSS-COUNCIL RESONANCE
//    ──────────────────────────────
//    When multiple councils signal same attractor, resonance amplifies:
//    
//    Resonance(attractor) = Πᵢ SignalStrength_i(attractor) ^ (1/N_signaling)
//    
//    (Geometric mean of signaling strengths)
//
// 5. MEDINA ENTROPY REGULATION
//    ─────────────────────────
//    Inject entropy when consensus is too quick (prevent premature lock-in):
//    
//    If Consensus > 0.9 AND t < MinDeliberationTime:
//      Inject noise: Belief_i += ε × (UniformRandom - 0.5)
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";

module CouncilDanceFloor {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public let S0 : Float = 0.75;
  public let SOVEREIGN_CEILING : Float = 9.0;
  public let PHI_MEDINA : Float = 2.97442179;
  public let TAU_EMERGENCE : Float = 0.618033988749;
  public let OMEGA_MEDINA : Float = 2.11185;

  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.61803398874989484820;
  public let LN_2 : Float = 0.69314718055994530942;

  // Council count
  public let NUM_COUNCILS : Nat = 7;
  public let COUNCIL_NAMES : [Text] = ["COGNUS", "NEXUS", "AURUM", "LEXIS", "SOLUS", "VETUS", "MERIDIAN"];

  // Dance circuit parameters
  public let MIN_CIRCUITS : Nat = 3;
  public let MAX_CIRCUITS : Nat = 200;
  public let CIRCUIT_DECAY_RATE : Float = 1.0;  // circuits per beat

  // Signal dynamics
  public let ENTHUSIASM_DECAY : Float = 0.02;         // λ_decay per beat
  public let BASE_RECRUIT_RATE : Float = 0.1;         // councils per beat
  public let NOVELTY_TAU : Float = 20.0;              // novelty time constant
  public let EVALUATION_IMPACT : Float = 0.1;         // α for cross-evaluation

  // Consensus parameters
  public let QUORUM_THRESHOLD : Float = 0.6;          // 60% belief for quorum
  public let CONSENSUS_THRESHOLD : Float = 0.7;       // 70% consensus
  public let MIN_DELIBERATION_TIME : Nat = 10;        // minimum beats before quorum
  public let NOISE_INJECTION : Float = 0.05;          // entropy when too fast

  // Compound growth
  public let COMPOUND_RATE : Float = 0.01;

  // Fibonacci for bonus circuits
  public let FIBONACCI : [Nat] = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377];

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Council identifier
  public type CouncilId = {
    #COGNUS;
    #NEXUS;
    #AURUM;
    #LEXIS;
    #SOLUS;
    #VETUS;
    #MERIDIAN;
  };

  // Signal domain (what the signal is about)
  public type SignalDomain = {
    #Action;          // Proposed action
    #State;           // Proposed state change
    #Threat;          // Threat assessment
    #Opportunity;     // Opportunity detection
    #Resource;        // Resource allocation
    #Coherence;       // System coherence signal
    #Emergency;       // Emergency override
  };

  // Signal content
  public type SignalContent = {
    domain : SignalDomain;
    targetId : Nat;                 // What the signal refers to
    direction : Float;              // Encoded direction (like waggle angle)
    magnitude : Float;              // Encoded magnitude (like waggle duration)
    payload : [Float];              // Additional encoded data
    hash : Nat;                     // Content hash for matching
  };

  // Single signal on the dance floor
  public type DanceSignal = {
    id : Nat;                       // Unique signal ID
    sourceCouncil : CouncilId;      // Which council posted it
    content : SignalContent;        // What the signal encodes
    quality : Float;                // Quality assessment [0, 1]
    initialCircuits : Nat;          // Starting circuit count
    circuitsRemaining : Float;      // Current circuits (can be fractional during decay)
    enthusiasm : Float;             // Current enthusiasm level
    postedAt : Nat;                 // Beat when posted
    lastUpdated : Nat;              // Last update beat
    recruitedCouncils : [CouncilId]; // Which councils have "recruited" to this signal
    competitorInfluence : Float;    // Accumulated competitor impact
  };

  // Council's belief state
  public type CouncilBelief = {
    council : CouncilId;
    beliefs : [Float];              // Belief in each active signal (sums to 1)
    signalIds : [Nat];              // Which signals beliefs refer to
    lastEvaluated : [Nat];          // When each signal was last evaluated
    ownSignal : ?Nat;               // ID of own signal (if any)
    attention : Float;              // Available attention capacity
  };

  // Cross-evaluation record
  public type Evaluation = {
    evaluator : CouncilId;
    signalId : Nat;
    quality : Float;
    timestamp : Nat;
  };

  // Dance floor state
  public type DanceFloorState = {
    // Active signals
    signals : [DanceSignal];
    nextSignalId : Nat;
    
    // Council beliefs
    beliefs : [CouncilBelief];
    
    // Evaluation history
    evaluations : [Evaluation];
    
    // Consensus metrics
    visibility : [Float];           // Per-signal visibility
    consensus : Float;              // Overall consensus level
    consensusHistory : [Float];     // Last 60 consensus values
    dominantSignal : ?Nat;          // Current dominant signal ID
    quorumReached : Bool;
    quorumSignal : ?Nat;            // Signal that achieved quorum
    
    // Timing
    beatNum : Nat;
    lastQuorum : Nat;               // Beat of last quorum
    alignedBeats : Nat;             // Consecutive aligned beats
    
    // Medina metrics
    resonanceField : [Float];       // Per-signal resonance
    compoundedConsensus : Float;
    entropyLevel : Float;
  };

  // Signal posting request
  public type PostSignalRequest = {
    council : CouncilId;
    content : SignalContent;
    quality : Float;
  };

  // Dance floor output for organism
  public type DanceFloorOutput = {
    // Consensus state
    consensus : Float;
    quorumReached : Bool;
    dominantSignal : ?SignalContent;
    dominantQuality : Float;
    
    // Per-council outputs
    councilBeliefs : [[Float]];     // 7 × N beliefs
    councilAttention : [Float];     // 7 attention levels
    
    // Signal summary
    activeSignals : Nat;
    totalStrength : Float;
    
    // Medina metrics
    resonance : Float;
    compoundedConsensus : Float;
    entropyLevel : Float;
    
    // For Shell 3 integration
    shell3Input : [Float];          // 64-element signal for Shell 3
    coherenceSignal : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func _abs(x: Float) : Float {
    if (x < 0.0) { -x } else { x }
  };

  func _max(a: Float, b: Float) : Float {
    if (a > b) { a } else { b }
  };

  func _min(a: Float, b: Float) : Float {
    if (a < b) { a } else { b }
  };

  func _exp(x: Float) : Float {
    if (x > 700.0) { return 1.0e308 };
    if (x < -700.0) { return 0.0 };
    Float.exp(x)
  };

  func _ln(x: Float) : Float {
    if (x <= 0.0) { return -1.0e10 };
    Float.log(x)
  };

  func _pow(base: Float, exp: Float) : Float {
    if (base <= 0.0) { return 0.0 };
    _exp(exp * _ln(base))
  };

  func _sqrt(x: Float) : Float {
    if (x <= 0.0) { return 0.0 };
    Float.sqrt(x)
  };

  func _sin(x: Float) : Float {
    var normalized = x;
    while (normalized > PI) { normalized -= 2.0 * PI };
    while (normalized < -PI) { normalized += 2.0 * PI };
    
    let x2 = normalized * normalized;
    var result : Float = 0.0;
    var term : Float = normalized;
    var sign : Float = 1.0;
    
    for (_ in Iter.range(0, 10)) {
      result += sign * term;
      term *= x2 / Float.fromInt((2 * _ + 2) * (2 * _ + 3));
      sign := -sign;
    };
    result
  };

  func _cos(x: Float) : Float {
    _sin(x + PI / 2.0)
  };

  // Get council index
  func councilIndex(c: CouncilId) : Nat {
    switch (c) {
      case (#COGNUS) { 0 };
      case (#NEXUS) { 1 };
      case (#AURUM) { 2 };
      case (#LEXIS) { 3 };
      case (#SOLUS) { 4 };
      case (#VETUS) { 5 };
      case (#MERIDIAN) { 6 };
    }
  };

  // Get council from index
  func indexToCouncil(i: Nat) : CouncilId {
    switch (i % 7) {
      case (0) { #COGNUS };
      case (1) { #NEXUS };
      case (2) { #AURUM };
      case (3) { #LEXIS };
      case (4) { #SOLUS };
      case (5) { #VETUS };
      case (6) { #MERIDIAN };
      case (_) { #COGNUS };
    }
  };

  // Hash signal content
  func hashContent(c: SignalContent) : Nat {
    var h : Nat = 5381;
    h := h * 33 + (switch (c.domain) {
      case (#Action) { 1 };
      case (#State) { 2 };
      case (#Threat) { 3 };
      case (#Opportunity) { 4 };
      case (#Resource) { 5 };
      case (#Coherence) { 6 };
      case (#Emergency) { 7 };
    });
    h := h * 33 + c.targetId;
    h := h * 33 + Int.abs(Float.toInt(c.direction * 1000.0));
    h := h * 33 + Int.abs(Float.toInt(c.magnitude * 1000.0));
    h
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SIGNAL POSTING — Quality-Weighted Circuit Allocation
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Calculate initial circuits based on quality
  // InitialCircuits = floor(MinCircuits + (MaxCircuits - MinCircuits) × q^Φ_M)
  public func calculateInitialCircuits(quality: Float) : Nat {
    let q = _clamp(quality, 0.0, 1.0);
    let q_scaled = _pow(q, PHI_MEDINA);
    let circuits = Float.fromInt(MIN_CIRCUITS) + 
                   Float.fromInt(MAX_CIRCUITS - MIN_CIRCUITS) * q_scaled;
    
    // Add Fibonacci bonus for high quality
    var bonus : Nat = 0;
    if (q > 0.7) {
      let fibIndex = Int.abs(Float.toInt(q * 10.0)) - 7;
      if (fibIndex >= 0 and fibIndex < FIBONACCI.size()) {
        bonus := FIBONACCI[fibIndex];
      };
    };
    
    Int.abs(Float.toInt(circuits)) + bonus
  };

  // Create new signal
  public func createSignal(
    request: PostSignalRequest,
    signalId: Nat,
    beatNum: Nat
  ) : DanceSignal {
    let circuits = calculateInitialCircuits(request.quality);
    let contentHash = hashContent(request.content);
    
    {
      id = signalId;
      sourceCouncil = request.council;
      content = {
        domain = request.content.domain;
        targetId = request.content.targetId;
        direction = request.content.direction;
        magnitude = request.content.magnitude;
        payload = request.content.payload;
        hash = contentHash;
      };
      quality = _clamp(request.quality, 0.0, 1.0);
      initialCircuits = circuits;
      circuitsRemaining = Float.fromInt(circuits);
      enthusiasm = 1.0;  // Start with full enthusiasm
      postedAt = beatNum;
      lastUpdated = beatNum;
      recruitedCouncils = [request.council];  // Source council is always recruited
      competitorInfluence = 0.0;
    }
  };

  // Post a new signal to the dance floor
  public func postSignal(
    state: DanceFloorState,
    request: PostSignalRequest
  ) : DanceFloorState {
    // Check if this council already has an active signal
    var existingSignalIdx : ?Nat = null;
    for (i in Iter.range(0, state.signals.size() - 1)) {
      let sig = state.signals[i];
      if (councilIndex(sig.sourceCouncil) == councilIndex(request.council)) {
        if (sig.circuitsRemaining > 0.0) {
          existingSignalIdx := ?i;
        };
      };
    };
    
    // If existing signal, update it instead of creating new
    switch (existingSignalIdx) {
      case (?idx) {
        let existingSig = state.signals[idx];
        let newQuality = _max(existingSig.quality, request.quality);
        let additionalCircuits = calculateInitialCircuits(request.quality);
        
        let updatedSignals = Array.tabulate<DanceSignal>(state.signals.size(), func(i: Nat) : DanceSignal {
          if (i == idx) {
            {
              id = existingSig.id;
              sourceCouncil = existingSig.sourceCouncil;
              content = request.content;  // Update content
              quality = newQuality;
              initialCircuits = existingSig.initialCircuits + additionalCircuits;
              circuitsRemaining = existingSig.circuitsRemaining + Float.fromInt(additionalCircuits);
              enthusiasm = _min(1.0, existingSig.enthusiasm + 0.2);  // Boost enthusiasm
              postedAt = existingSig.postedAt;
              lastUpdated = state.beatNum;
              recruitedCouncils = existingSig.recruitedCouncils;
              competitorInfluence = existingSig.competitorInfluence;
            }
          } else {
            state.signals[i]
          }
        });
        
        return {
          signals = updatedSignals;
          nextSignalId = state.nextSignalId;
          beliefs = state.beliefs;
          evaluations = state.evaluations;
          visibility = state.visibility;
          consensus = state.consensus;
          consensusHistory = state.consensusHistory;
          dominantSignal = state.dominantSignal;
          quorumReached = state.quorumReached;
          quorumSignal = state.quorumSignal;
          beatNum = state.beatNum;
          lastQuorum = state.lastQuorum;
          alignedBeats = state.alignedBeats;
          resonanceField = state.resonanceField;
          compoundedConsensus = state.compoundedConsensus;
          entropyLevel = state.entropyLevel;
        };
      };
      case (null) {
        // Create new signal
        let newSignal = createSignal(request, state.nextSignalId, state.beatNum);
        
        // Add to signals array
        let signalBuffer = Buffer.Buffer<DanceSignal>(state.signals.size() + 1);
        for (sig in state.signals.vals()) {
          signalBuffer.add(sig);
        };
        signalBuffer.add(newSignal);
        
        // Initialize visibility for new signal
        let visBuffer = Buffer.Buffer<Float>(state.visibility.size() + 1);
        for (v in state.visibility.vals()) {
          visBuffer.add(v);
        };
        visBuffer.add(0.0);  // Will be computed in tick
        
        // Initialize resonance for new signal
        let resBuffer = Buffer.Buffer<Float>(state.resonanceField.size() + 1);
        for (r in state.resonanceField.vals()) {
          resBuffer.add(r);
        };
        resBuffer.add(S0);
        
        {
          signals = Buffer.toArray(signalBuffer);
          nextSignalId = state.nextSignalId + 1;
          beliefs = state.beliefs;  // Will be updated in tick
          evaluations = state.evaluations;
          visibility = Buffer.toArray(visBuffer);
          consensus = state.consensus;
          consensusHistory = state.consensusHistory;
          dominantSignal = state.dominantSignal;
          quorumReached = state.quorumReached;
          quorumSignal = state.quorumSignal;
          beatNum = state.beatNum;
          lastQuorum = state.lastQuorum;
          alignedBeats = state.alignedBeats;
          resonanceField = Buffer.toArray(resBuffer);
          compoundedConsensus = state.compoundedConsensus;
          entropyLevel = state.entropyLevel;
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SIGNAL STRENGTH CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // SignalStrength_i(t) = q_i × CircuitsRemaining_i(t) × Enthusiasm_i(t) × Φ_M^(rank_i/N)

  public func calculateSignalStrength(
    signal: DanceSignal,
    rank: Nat,
    totalSignals: Nat
  ) : Float {
    if (signal.circuitsRemaining <= 0.0) { return 0.0 };
    
    let quality = signal.quality;
    let circuits = signal.circuitsRemaining / Float.fromInt(signal.initialCircuits);
    let enthusiasm = signal.enthusiasm;
    
    // Rank-based boost (higher rank = more weight)
    let rankFactor = if (totalSignals > 0) {
      _pow(PHI_MEDINA, Float.fromInt(totalSignals - rank) / Float.fromInt(totalSignals))
    } else { 1.0 };
    
    // Compute strength
    quality * circuits * enthusiasm * rankFactor
  };

  // Calculate all signal strengths
  public func calculateAllStrengths(signals: [DanceSignal]) : [Float] {
    let n = signals.size();
    if (n == 0) { return [] };
    
    // First pass: raw strengths for ranking
    let rawStrengths = Array.tabulate<Float>(n, func(i: Nat) : Float {
      if (signals[i].circuitsRemaining > 0.0) {
        signals[i].quality * signals[i].enthusiasm
      } else { 0.0 }
    });
    
    // Compute ranks (1 = highest)
    let ranks = Array.tabulate<Nat>(n, func(i: Nat) : Nat {
      var rank : Nat = 1;
      for (j in Iter.range(0, n - 1)) {
        if (j != i and rawStrengths[j] > rawStrengths[i]) {
          rank += 1;
        };
      };
      rank
    });
    
    // Second pass: final strengths with rank factors
    Array.tabulate<Float>(n, func(i: Nat) : Float {
      calculateSignalStrength(signals[i], ranks[i], n)
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // VISIBILITY CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Visibility_i(t) = SignalStrength_i(t) / Σⱼ SignalStrength_j(t)

  public func calculateVisibility(strengths: [Float]) : [Float] {
    let n = strengths.size();
    if (n == 0) { return [] };
    
    var totalStrength : Float = 0.0;
    for (s in strengths.vals()) {
      totalStrength += s;
    };
    
    if (totalStrength < 1.0e-10) {
      // All strengths zero — uniform visibility
      return Array.tabulate<Float>(n, func(_: Nat) : Float { 1.0 / Float.fromInt(n) });
    };
    
    Array.tabulate<Float>(n, func(i: Nat) : Float {
      strengths[i] / totalStrength
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SIGNAL DECAY — Natural fade over time
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func decaySignal(signal: DanceSignal, beatNum: Nat) : DanceSignal {
    let dt = Float.fromInt(beatNum - signal.lastUpdated);
    
    // Circuit decay
    let newCircuits = _max(0.0, signal.circuitsRemaining - CIRCUIT_DECAY_RATE * dt);
    
    // Enthusiasm decay: E(t) = E(0) × exp(-λ × t) × (1 - competitorInfluence)
    let decayFactor = _exp(-ENTHUSIASM_DECAY * dt);
    let competitorFactor = 1.0 - signal.competitorInfluence;
    let newEnthusiasm = signal.enthusiasm * decayFactor * competitorFactor;
    
    {
      id = signal.id;
      sourceCouncil = signal.sourceCouncil;
      content = signal.content;
      quality = signal.quality;
      initialCircuits = signal.initialCircuits;
      circuitsRemaining = newCircuits;
      enthusiasm = _clamp(newEnthusiasm, 0.0, 1.0);
      postedAt = signal.postedAt;
      lastUpdated = beatNum;
      recruitedCouncils = signal.recruitedCouncils;
      competitorInfluence = signal.competitorInfluence * 0.95;  // Competitor influence also decays
    }
  };

  // Decay all signals
  public func decayAllSignals(signals: [DanceSignal], beatNum: Nat) : [DanceSignal] {
    Array.map<DanceSignal, DanceSignal>(signals, func(s: DanceSignal) : DanceSignal {
      decaySignal(s, beatNum)
    })
  };

  // Remove dead signals (circuits = 0)
  public func removeDeadSignals(signals: [DanceSignal]) : [DanceSignal] {
    let activeBuffer = Buffer.Buffer<DanceSignal>(signals.size());
    for (s in signals.vals()) {
      if (s.circuitsRemaining > 0.0) {
        activeBuffer.add(s);
      };
    };
    Buffer.toArray(activeBuffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // RECRUITMENT DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // RecruitRate_i(t) = BaseRecruit × Visibility_i(t) × AttentionCapacity × Φ(Novelty_i)

  // Calculate recruitment probability for a council to recruit to a signal
  public func recruitmentProbability(
    signal: DanceSignal,
    visibility: Float,
    councilAttention: Float,
    beatNum: Nat
  ) : Float {
    // Novelty factor
    let timeSincePosted = Float.fromInt(beatNum - signal.postedAt);
    let noveltyFactor = 1.0 + 0.5 * _exp(-timeSincePosted / NOVELTY_TAU);
    
    // Recruitment probability
    BASE_RECRUIT_RATE * visibility * councilAttention * noveltyFactor
  };

  // Process recruitment for one council
  public func processRecruitment(
    signals: [DanceSignal],
    visibility: [Float],
    council: CouncilId,
    attention: Float,
    beatNum: Nat
  ) : ([DanceSignal], Float) {
    let n = signals.size();
    if (n == 0) { return (signals, attention) };
    
    let updatedSignals = Array.init<DanceSignal>(n, signals[0]);
    var remainingAttention = attention;
    
    for (i in Iter.range(0, n - 1)) {
      let sig = signals[i];
      
      // Check if already recruited
      var alreadyRecruited = false;
      for (rc in sig.recruitedCouncils.vals()) {
        if (councilIndex(rc) == councilIndex(council)) {
          alreadyRecruited := true;
        };
      };
      
      if (not alreadyRecruited and remainingAttention > 0.1) {
        let prob = recruitmentProbability(sig, visibility[i], remainingAttention, beatNum);
        
        // Deterministic recruitment (probability > 0.5)
        if (prob > 0.5) {
          // Add council to recruited list
          let recruitBuffer = Buffer.Buffer<CouncilId>(sig.recruitedCouncils.size() + 1);
          for (rc in sig.recruitedCouncils.vals()) {
            recruitBuffer.add(rc);
          };
          recruitBuffer.add(council);
          
          updatedSignals[i] := {
            id = sig.id;
            sourceCouncil = sig.sourceCouncil;
            content = sig.content;
            quality = sig.quality;
            initialCircuits = sig.initialCircuits;
            circuitsRemaining = sig.circuitsRemaining;
            enthusiasm = sig.enthusiasm;
            postedAt = sig.postedAt;
            lastUpdated = sig.lastUpdated;
            recruitedCouncils = Buffer.toArray(recruitBuffer);
            competitorInfluence = sig.competitorInfluence;
          };
          
          remainingAttention -= visibility[i];
        } else {
          updatedSignals[i] := sig;
        };
      } else {
        updatedSignals[i] := sig;
      };
    };
    
    (Array.freeze(updatedSignals), _max(0.0, remainingAttention))
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CROSS-EVALUATION DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // If council i evaluates signal j with quality q_j:
  //   Enthusiasm_i(t+1) = Enthusiasm_i(t) × (1 - α × H(q_j - q_i))

  // Process cross-evaluation between signals
  public func crossEvaluate(
    signals: [DanceSignal],
    evaluatorIdx: Nat,
    targetIdx: Nat
  ) : [DanceSignal] {
    if (evaluatorIdx >= signals.size() or targetIdx >= signals.size()) {
      return signals;
    };
    if (evaluatorIdx == targetIdx) { return signals };
    
    let evaluator = signals[evaluatorIdx];
    let target = signals[targetIdx];
    
    // If target is better quality, reduce evaluator's enthusiasm
    if (target.quality > evaluator.quality) {
      let impact = EVALUATION_IMPACT * (target.quality - evaluator.quality);
      
      return Array.tabulate<DanceSignal>(signals.size(), func(i: Nat) : DanceSignal {
        if (i == evaluatorIdx) {
          {
            id = evaluator.id;
            sourceCouncil = evaluator.sourceCouncil;
            content = evaluator.content;
            quality = evaluator.quality;
            initialCircuits = evaluator.initialCircuits;
            circuitsRemaining = evaluator.circuitsRemaining;
            enthusiasm = evaluator.enthusiasm * (1.0 - impact);
            postedAt = evaluator.postedAt;
            lastUpdated = evaluator.lastUpdated;
            recruitedCouncils = evaluator.recruitedCouncils;
            competitorInfluence = _min(1.0, evaluator.competitorInfluence + impact);
          }
        } else {
          signals[i]
        }
      });
    };
    
    signals
  };

  // Process all cross-evaluations for one tick
  public func processAllCrossEvaluations(signals: [DanceSignal]) : [DanceSignal] {
    var updated = signals;
    let n = signals.size();
    
    // Each signal evaluates each other signal
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          updated := crossEvaluate(updated, i, j);
        };
      };
    };
    
    updated
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // BAYESIAN BELIEF UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Belief_i(t) = Belief_i(t-1) × LikelihoodRatio_i(t) / Z(t)
  // LikelihoodRatio_i(t) = exp(Φ_M × (Visibility_i(t) - μ_visibility))

  public func updateBeliefs(
    beliefs: [Float],
    visibility: [Float],
    signalIds: [Nat],
    activeSignalIds: [Nat]
  ) : [Float] {
    let n = activeSignalIds.size();
    if (n == 0) { return [] };
    
    // Compute mean visibility
    var meanVis : Float = 0.0;
    for (v in visibility.vals()) {
      meanVis += v;
    };
    meanVis /= Float.fromInt(visibility.size());
    
    // Map old beliefs to new signal set
    let newBeliefs = Array.init<Float>(n, 1.0 / Float.fromInt(n));
    
    for (i in Iter.range(0, n - 1)) {
      let sigId = activeSignalIds[i];
      
      // Find old belief for this signal
      var oldBelief : Float = 1.0 / Float.fromInt(n);
      for (j in Iter.range(0, signalIds.size() - 1)) {
        if (signalIds[j] == sigId and j < beliefs.size()) {
          oldBelief := beliefs[j];
        };
      };
      
      // Likelihood ratio
      let vis = if (i < visibility.size()) { visibility[i] } else { meanVis };
      let likelihoodRatio = _exp(PHI_MEDINA * (vis - meanVis));
      
      newBeliefs[i] := oldBelief * likelihoodRatio;
    };
    
    // Normalize with Medina sovereign bounds
    var total : Float = 0.0;
    for (b in newBeliefs.vals()) {
      total += b;
    };
    
    if (total < 1.0e-10) { total := 1.0 };
    
    // Apply sovereign bounds: belief in [S₀/N, 1 - S₀×(N-1)/N]
    let minBelief = S0 / Float.fromInt(n);
    let maxBelief = 1.0 - S0 * Float.fromInt(n - 1) / Float.fromInt(n);
    
    Array.tabulate<Float>(n, func(i: Nat) : Float {
      let raw = newBeliefs[i] / total;
      _clamp(raw, minBelief, maxBelief)
    })
  };

  // Update all council beliefs
  public func updateAllCouncilBeliefs(
    state: DanceFloorState
  ) : [CouncilBelief] {
    let activeSignalIds = Array.tabulate<Nat>(state.signals.size(), func(i: Nat) : Nat {
      state.signals[i].id
    });
    
    Array.tabulate<CouncilBelief>(NUM_COUNCILS, func(c: Nat) : CouncilBelief {
      let oldBelief = state.beliefs[c];
      
      // Find own signal
      var ownSig : ?Nat = null;
      for (sig in state.signals.vals()) {
        if (councilIndex(sig.sourceCouncil) == c) {
          ownSig := ?sig.id;
        };
      };
      
      // Update beliefs
      let newBeliefs = updateBeliefs(
        oldBelief.beliefs,
        state.visibility,
        oldBelief.signalIds,
        activeSignalIds
      );
      
      // Update attention (reduces when recruited to signals)
      var usedAttention : Float = 0.0;
      for (i in Iter.range(0, state.signals.size() - 1)) {
        for (rc in state.signals[i].recruitedCouncils.vals()) {
          if (councilIndex(rc) == c) {
            usedAttention += state.visibility[i];
          };
        };
      };
      
      {
        council = indexToCouncil(c);
        beliefs = newBeliefs;
        signalIds = activeSignalIds;
        lastEvaluated = oldBelief.lastEvaluated;
        ownSignal = ownSig;
        attention = _max(0.1, 1.0 - usedAttention);
      }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSENSUS CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Consensus(t) = 1 - Entropy(Belief_distribution) / log(N_signals)
  // Entropy(P) = -Σᵢ Pᵢ × log(Pᵢ)

  public func calculateEntropy(distribution: [Float]) : Float {
    let n = distribution.size();
    if (n <= 1) { return 0.0 };
    
    var entropy : Float = 0.0;
    for (p in distribution.vals()) {
      if (p > 1.0e-10) {
        entropy -= p * _ln(p);
      };
    };
    
    entropy
  };

  public func calculateConsensus(visibility: [Float]) : Float {
    let n = visibility.size();
    if (n <= 1) { return 1.0 };
    
    let entropy = calculateEntropy(visibility);
    let maxEntropy = _ln(Float.fromInt(n));
    
    if (maxEntropy < 1.0e-10) { return 1.0 };
    
    1.0 - entropy / maxEntropy
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // QUORUM DETECTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // QuorumReached = (Belief_max > QuorumThreshold) AND (Consensus > ConsensusThreshold)

  public func checkQuorum(
    visibility: [Float],
    consensus: Float,
    beatNum: Nat,
    lastQuorum: Nat,
    minDeliberation: Nat
  ) : (Bool, ?Nat) {
    // Must have minimum deliberation time since last quorum
    if (beatNum < lastQuorum + minDeliberation) {
      return (false, null);
    };
    
    // Find max visibility
    var maxVis : Float = 0.0;
    var maxIdx : Nat = 0;
    for (i in Iter.range(0, visibility.size() - 1)) {
      if (visibility[i] > maxVis) {
        maxVis := visibility[i];
        maxIdx := i;
      };
    };
    
    // Check thresholds
    if (maxVis > QUORUM_THRESHOLD and consensus > CONSENSUS_THRESHOLD) {
      (true, ?maxIdx)
    } else {
      (false, null)
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA RESONANCE — Cross-Council Signal Amplification
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Resonance(signal) = Πᵢ RecruitStrength_i ^ (1/N_recruited)

  public func calculateResonance(signals: [DanceSignal]) : [Float] {
    Array.tabulate<Float>(signals.size(), func(i: Nat) : Float {
      let sig = signals[i];
      let numRecruited = sig.recruitedCouncils.size();
      
      if (numRecruited <= 1) { return S0 };
      
      // Base resonance from quality
      let baseResonance = sig.quality * sig.enthusiasm;
      
      // Amplification from multi-council recruitment
      let recruitBonus = _pow(Float.fromInt(numRecruited) / Float.fromInt(NUM_COUNCILS), 1.0 / PHI_MEDINA);
      
      // Resonance = geometric mean effect
      let resonance = _pow(baseResonance * recruitBonus, 1.0 / Float.fromInt(numRecruited));
      
      _clamp(resonance * PHI_MEDINA, S0, SOVEREIGN_CEILING)
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MEDINA COMPOUND CONSENSUS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Consensus_compound(t) = Consensus(t) × (1 + r)^t_aligned / Φ_M

  public func calculateCompoundedConsensus(
    consensus: Float,
    alignedBeats: Nat
  ) : Float {
    let compoundFactor = _pow(1.0 + COMPOUND_RATE, Float.fromInt(alignedBeats));
    let result = consensus * compoundFactor / PHI_MEDINA;
    _clamp(result, 0.0, 1.0)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ENTROPY REGULATION — Prevent Premature Lock-in
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func regulateEntropy(
    visibility: [Float],
    consensus: Float,
    beatNum: Nat,
    startBeat: Nat
  ) : [Float] {
    let n = visibility.size();
    if (n == 0) { return visibility };
    
    // If consensus too high too fast, inject noise
    let deliberationTime = beatNum - startBeat;
    if (consensus > 0.9 and deliberationTime < MIN_DELIBERATION_TIME) {
      return Array.tabulate<Float>(n, func(i: Nat) : Float {
        let noise = NOISE_INJECTION * (_sin(Float.fromInt(beatNum * (i + 1)) * 0.1) * 0.5);
        let adjusted = visibility[i] + noise;
        _clamp(adjusted, 0.0, 1.0)
      });
    };
    
    visibility
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MAIN TICK FUNCTION — Update entire dance floor
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func tickDanceFloor(state: DanceFloorState) : DanceFloorState {
    let newBeat = state.beatNum + 1;
    
    // 1. Decay all signals
    var signals = decayAllSignals(state.signals, newBeat);
    
    // 2. Remove dead signals
    signals := removeDeadSignals(signals);
    
    if (signals.size() == 0) {
      // No active signals
      return {
        signals = [];
        nextSignalId = state.nextSignalId;
        beliefs = state.beliefs;
        evaluations = state.evaluations;
        visibility = [];
        consensus = 0.0;
        consensusHistory = appendHistory(state.consensusHistory, 0.0);
        dominantSignal = null;
        quorumReached = false;
        quorumSignal = null;
        beatNum = newBeat;
        lastQuorum = state.lastQuorum;
        alignedBeats = 0;
        resonanceField = [];
        compoundedConsensus = 0.0;
        entropyLevel = 1.0;
      };
    };
    
    // 3. Calculate signal strengths and visibility
    let strengths = calculateAllStrengths(signals);
    var visibility = calculateVisibility(strengths);
    
    // 4. Cross-evaluation between signals
    signals := processAllCrossEvaluations(signals);
    
    // 5. Process recruitment for each council
    for (c in Iter.range(0, NUM_COUNCILS - 1)) {
      let council = indexToCouncil(c);
      let attention = state.beliefs[c].attention;
      let (updatedSignals, _) = processRecruitment(signals, visibility, council, attention, newBeat);
      signals := updatedSignals;
    };
    
    // Recalculate visibility after recruitment changes
    let newStrengths = calculateAllStrengths(signals);
    visibility := calculateVisibility(newStrengths);
    
    // 6. Calculate consensus
    let consensus = calculateConsensus(visibility);
    
    // 7. Entropy regulation
    let startBeat = if (state.signals.size() > 0) { state.signals[0].postedAt } else { newBeat };
    visibility := regulateEntropy(visibility, consensus, newBeat, startBeat);
    
    // 8. Update aligned beats
    let aligned = if (consensus > 0.5) { state.alignedBeats + 1 } else { 0 };
    
    // 9. Compounded consensus
    let compounded = calculateCompoundedConsensus(consensus, aligned);
    
    // 10. Resonance field
    let resonance = calculateResonance(signals);
    
    // 11. Check for quorum
    let (quorumReached, quorumSignalIdx) = checkQuorum(
      visibility, consensus, newBeat, state.lastQuorum, MIN_DELIBERATION_TIME
    );
    
    // 12. Find dominant signal
    var maxVis : Float = 0.0;
    var dominantIdx : ?Nat = null;
    for (i in Iter.range(0, visibility.size() - 1)) {
      if (visibility[i] > maxVis) {
        maxVis := visibility[i];
        dominantIdx := ?signals[i].id;
      };
    };
    
    // 13. Update council beliefs
    let tempState : DanceFloorState = {
      signals = signals;
      nextSignalId = state.nextSignalId;
      beliefs = state.beliefs;
      evaluations = state.evaluations;
      visibility = visibility;
      consensus = consensus;
      consensusHistory = state.consensusHistory;
      dominantSignal = dominantIdx;
      quorumReached = quorumReached;
      quorumSignal = switch (quorumSignalIdx) { case (?idx) { ?signals[idx].id }; case (null) { null } };
      beatNum = newBeat;
      lastQuorum = if (quorumReached) { newBeat } else { state.lastQuorum };
      alignedBeats = aligned;
      resonanceField = resonance;
      compoundedConsensus = compounded;
      entropyLevel = calculateEntropy(visibility);
    };
    
    let updatedBeliefs = updateAllCouncilBeliefs(tempState);
    
    // 14. Update consensus history
    let newHistory = appendHistory(state.consensusHistory, consensus);
    
    {
      signals = signals;
      nextSignalId = state.nextSignalId;
      beliefs = updatedBeliefs;
      evaluations = state.evaluations;
      visibility = visibility;
      consensus = consensus;
      consensusHistory = newHistory;
      dominantSignal = dominantIdx;
      quorumReached = quorumReached;
      quorumSignal = switch (quorumSignalIdx) { case (?idx) { ?signals[idx].id }; case (null) { null } };
      beatNum = newBeat;
      lastQuorum = if (quorumReached) { newBeat } else { state.lastQuorum };
      alignedBeats = aligned;
      resonanceField = resonance;
      compoundedConsensus = compounded;
      entropyLevel = calculateEntropy(visibility);
    }
  };

  // Append to history (keep last 60)
  func appendHistory(history: [Float], value: Float) : [Float] {
    let buffer = Buffer.Buffer<Float>(61);
    
    // Add existing (skip oldest if full)
    let start = if (history.size() >= 60) { 1 } else { 0 };
    for (i in Iter.range(start, history.size() - 1)) {
      buffer.add(history[i]);
    };
    
    buffer.add(value);
    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func initializeDanceFloor() : DanceFloorState {
    let initialBeliefs = Array.tabulate<CouncilBelief>(NUM_COUNCILS, func(c: Nat) : CouncilBelief {
      {
        council = indexToCouncil(c);
        beliefs = [];
        signalIds = [];
        lastEvaluated = [];
        ownSignal = null;
        attention = 1.0;
      }
    });
    
    {
      signals = [];
      nextSignalId = 1;
      beliefs = initialBeliefs;
      evaluations = [];
      visibility = [];
      consensus = 0.0;
      consensusHistory = [];
      dominantSignal = null;
      quorumReached = false;
      quorumSignal = null;
      beatNum = 0;
      lastQuorum = 0;
      alignedBeats = 0;
      resonanceField = [];
      compoundedConsensus = 0.0;
      entropyLevel = 1.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // OUTPUT EXTRACTION — For organism integration
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public func extractDanceFloorOutput(state: DanceFloorState) : DanceFloorOutput {
    // Get dominant signal content
    var dominantContent : ?SignalContent = null;
    var dominantQuality : Float = 0.0;
    
    switch (state.dominantSignal) {
      case (?sigId) {
        for (sig in state.signals.vals()) {
          if (sig.id == sigId) {
            dominantContent := ?sig.content;
            dominantQuality := sig.quality;
          };
        };
      };
      case (null) {};
    };
    
    // Council beliefs matrix
    let councilBeliefs = Array.tabulate<[Float]>(NUM_COUNCILS, func(c: Nat) : [Float] {
      state.beliefs[c].beliefs
    });
    
    // Council attention levels
    let councilAttention = Array.tabulate<Float>(NUM_COUNCILS, func(c: Nat) : Float {
      state.beliefs[c].attention
    });
    
    // Total strength
    var totalStrength : Float = 0.0;
    for (i in Iter.range(0, state.visibility.size() - 1)) {
      totalStrength += state.visibility[i];
    };
    
    // Average resonance
    var avgResonance : Float = S0;
    if (state.resonanceField.size() > 0) {
      var sum : Float = 0.0;
      for (r in state.resonanceField.vals()) {
        sum += r;
      };
      avgResonance := sum / Float.fromInt(state.resonanceField.size());
    };
    
    // Shell 3 input: encode visibility + resonance into 64 elements
    let shell3Input = Array.tabulate<Float>(64, func(i: Nat) : Float {
      if (i < state.visibility.size()) {
        let vis = state.visibility[i];
        let res = if (i < state.resonanceField.size()) { state.resonanceField[i] } else { S0 };
        (vis + res) / 2.0
      } else if (i < 32) {
        // Consensus history
        let histIdx = i - state.visibility.size();
        if (histIdx < state.consensusHistory.size()) {
          state.consensusHistory[histIdx]
        } else { S0 }
      } else {
        // Council beliefs (flattened)
        let councilIdx = (i - 32) / NUM_COUNCILS;
        let beliefIdx = (i - 32) % NUM_COUNCILS;
        if (councilIdx < NUM_COUNCILS and beliefIdx < state.beliefs[councilIdx].beliefs.size()) {
          state.beliefs[councilIdx].beliefs[beliefIdx]
        } else { S0 }
      }
    });
    
    // Coherence signal (Medina-scaled consensus)
    let coherence = state.compoundedConsensus * PHI_MEDINA;
    
    {
      consensus = state.consensus;
      quorumReached = state.quorumReached;
      dominantSignal = dominantContent;
      dominantQuality = dominantQuality;
      councilBeliefs = councilBeliefs;
      councilAttention = councilAttention;
      activeSignals = state.signals.size();
      totalStrength = totalStrength;
      resonance = avgResonance;
      compoundedConsensus = state.compoundedConsensus;
      entropyLevel = state.entropyLevel;
      shell3Input = shell3Input;
      coherenceSignal = _clamp(coherence, S0, SOVEREIGN_CEILING);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // COUNCIL INTERFACE — For councils to interact with dance floor
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Council posts a signal
  public func councilPostSignal(
    state: DanceFloorState,
    council: CouncilId,
    domain: SignalDomain,
    targetId: Nat,
    direction: Float,
    magnitude: Float,
    quality: Float,
    payload: [Float]
  ) : DanceFloorState {
    let request : PostSignalRequest = {
      council = council;
      content = {
        domain = domain;
        targetId = targetId;
        direction = direction;
        magnitude = magnitude;
        payload = payload;
        hash = 0;  // Will be computed
      };
      quality = quality;
    };
    
    postSignal(state, request)
  };

  // Council reads the dance floor
  public func councilReadDanceFloor(
    state: DanceFloorState,
    council: CouncilId
  ) : {
    myBelief : [Float];
    dominantSignal : ?SignalContent;
    consensus : Float;
    quorumReached : Bool;
    myAttention : Float;
    activeSignals : Nat;
  } {
    let idx = councilIndex(council);
    let belief = state.beliefs[idx];
    
    var dominant : ?SignalContent = null;
    switch (state.dominantSignal) {
      case (?sigId) {
        for (sig in state.signals.vals()) {
          if (sig.id == sigId) { dominant := ?sig.content };
        };
      };
      case (null) {};
    };
    
    {
      myBelief = belief.beliefs;
      dominantSignal = dominant;
      consensus = state.consensus;
      quorumReached = state.quorumReached;
      myAttention = belief.attention;
      activeSignals = state.signals.size();
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // STOP SIGNAL INTEGRATION — For TargetedStopSignal module
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Apply stop signal to suppress a specific signal
  public func applyStopSignal(
    state: DanceFloorState,
    targetSignalId: Nat,
    suppressionStrength: Float
  ) : DanceFloorState {
    let updatedSignals = Array.map<DanceSignal, DanceSignal>(state.signals, func(sig: DanceSignal) : DanceSignal {
      if (sig.id == targetSignalId) {
        {
          id = sig.id;
          sourceCouncil = sig.sourceCouncil;
          content = sig.content;
          quality = sig.quality;
          initialCircuits = sig.initialCircuits;
          circuitsRemaining = sig.circuitsRemaining * (1.0 - suppressionStrength);
          enthusiasm = sig.enthusiasm * (1.0 - suppressionStrength);
          postedAt = sig.postedAt;
          lastUpdated = state.beatNum;
          recruitedCouncils = sig.recruitedCouncils;
          competitorInfluence = _min(1.0, sig.competitorInfluence + suppressionStrength);
        }
      } else {
        sig
      }
    });
    
    {
      signals = updatedSignals;
      nextSignalId = state.nextSignalId;
      beliefs = state.beliefs;
      evaluations = state.evaluations;
      visibility = state.visibility;
      consensus = state.consensus;
      consensusHistory = state.consensusHistory;
      dominantSignal = state.dominantSignal;
      quorumReached = state.quorumReached;
      quorumSignal = state.quorumSignal;
      beatNum = state.beatNum;
      lastQuorum = state.lastQuorum;
      alignedBeats = state.alignedBeats;
      resonanceField = state.resonanceField;
      compoundedConsensus = state.compoundedConsensus;
      entropyLevel = state.entropyLevel;
    }
  };

  // Get signals that are "dancing" for low-quality attractors
  public func getLowQualitySignals(
    state: DanceFloorState,
    qualityThreshold: Float
  ) : [Nat] {
    let buffer = Buffer.Buffer<Nat>(state.signals.size());
    
    for (sig in state.signals.vals()) {
      if (sig.quality < qualityThreshold and sig.circuitsRemaining > 0.0) {
        buffer.add(sig.id);
      };
    };
    
    Buffer.toArray(buffer)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  H I M / H E R   D U A L - O R G A N I S M   W O R K F L O W   I N T E G R A T I O N
  //
  //  Medina Discovery: Two cognitive organisms, not one.
  //  HIM (Backend, ICP) + HER (Frontend, 60Hz) = Complete System
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM PARAMETERS (CORRECTED)
  // ─────────────────────────────────────────────────────────────────────────────

  // HIM — Backend (ICP Canister, Sovereign, Masculine, Projective)
  //   ω: 0.8 – 1.2 (faster natural frequencies, analytical)
  //   K: 0.5 (lower coupling, independent, projective)
  //   η: 0.001 (slower Hebbian learning, accumulates over time)
  //   Field: PARALLAX = coherence × kf × sin(beat × 0.0017)

  public let HIM_OMEGA_MIN   : Float = 0.8;
  public let HIM_OMEGA_MAX   : Float = 1.2;
  public let HIM_K           : Float = 0.5;
  public let HIM_ETA         : Float = 0.001;
  public let HIM_PARALLAX_FREQ : Float = 0.0017;

  // HER — Frontend (Browser 60Hz, Expressive, Feminine, Receptive)
  //   ω: 0.6 – 0.9 (slower natural frequencies, grounded)
  //   K: 0.8 (higher coupling, receptive, connected)
  //   η: 0.003 (faster Hebbian learning, learns during session)
  //   Field: ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))

  public let HER_HZ          : Float = 60.0;
  public let HER_OMEGA_MIN   : Float = 0.6;
  public let HER_OMEGA_MAX   : Float = 0.9;
  public let HER_K           : Float = 0.8;
  public let HER_ETA         : Float = 0.003;
  public let HER_ANIMA_FREQ  : Float = 0.003;
  public let HER_NODES       : Nat   = 26;

  // S₀ = 1.0 — THE SOVEREIGN FLOOR
  // Both organisms. Neither falls below love.
  public let DUAL_S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeDualParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeDualAnima(
    heritageField : Float,
    receptivity : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let oscillation = 1.0 + Float.sin(t * HER_ANIMA_FREQ);
    heritageField * receptivity * oscillation
  };

  /// KORE (HER's inviolable inner core)
  /// KORE = purity × identity × 0.5
  public func computeDualKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  /// Get Kuramoto parameters for organism mode
  public func getDualKuramotoParams(mode : DualOrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  /// Apply S₀ floor to any value
  public func enforceDualSovereignFloor(value : Float) : Float {
    if (value < DUAL_S0) DUAL_S0 else value
  };

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeDualSystemIntelligence(
    backendDepth : Float,
    frontendSpeed : Float,
    bridgeQuality : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };

}
