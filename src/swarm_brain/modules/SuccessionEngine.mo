// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — SUCCESSION ENGINE
// COMPREHENSIVE SOVEREIGN SUCCESSION AND GOVERNANCE MATHEMATICS
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — SOVEREIGN SUCCESSION: WHO LEADS THE ORGANISM NEXT
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: LEADERSHIP SELECTION — BORDA COUNT ──────────────────────────────
//   Borda count: each voter ranks N candidates, assigns N-k points to rank k
//   Borda score: B_i = Σⱼ (N - r_{ij})  where r_{ij} = rank voter j gives candidate i
//   Winner: argmax_i B_i
//   Maximum Borda score: B_max = N × (N-1)  (always ranked first by all)
//   Normalized: b_i = B_i / B_max ∈ [0,1]
//   Condorcet winner: beats every other candidate in pairwise comparison
//   Condorcet criterion: if x beats y in majority vote for all y ≠ x, x wins
//   Arrow's impossibility: no perfect voting system (monotonicity paradox)
//
// ── LAYER 2: WEIGHTED VOTING — SOVEREIGN COUNCIL ─────────────────────────────
//   The 7-organism sovereign council (NOVA doctrine)
//   Council weights: w_i = f(coherence_i, age_i, achievement_i)
//   Weighted vote: V(x) = Σᵢ wᵢ × v_i(x) / Σᵢ wᵢ
//   Supermajority threshold: V(x) ≥ 5/7 for succession (71.4%)
//   Veto power: any council member with w_i ≥ 0.20 can veto
//   Tie-breaking: highest Lyapunov stability certificate SC wins
//
// ── LAYER 3: SUCCESSION PROBABILITY — HAZARD MODEL ───────────────────────────
//   Hazard rate: λ(t) = f(t) / S(t)  where S(t) = 1 - F(t) = survival probability
//   Weibull hazard: λ(t) = (β/η) × (t/η)^(β-1)  [most general parametric]
//   β < 1: decreasing hazard (burn-in failures, infant mortality)
//   β = 1: constant hazard (random failures, exponential distribution)
//   β > 1: increasing hazard (aging, wear-out)
//   Sovereignty succession: β ≈ 2 (aging leaders more likely to be replaced)
//   Scale parameter η = 100 beats (typical leadership tenure)
//   Mean time to succession: E[T] = η × Γ(1 + 1/β)
//   Γ(1.5) = 0.886 → E[T] = 88.6 beats for typical NOVA leader
//
// ── LAYER 4: MERIT FUNCTION ───────────────────────────────────────────────────
//   Candidate merit: M_i = Σₖ α_k × C_ik
//   C_ik = score on criterion k (normalized [0,1])
//   Criteria and weights:
//   α₁=0.25: Lyapunov stability certificate (SC = exp(-Φ_M × V_sov))
//   α₂=0.20: FORMA token generation rate (economic contribution)
//   α₃=0.20: Sovereign entropy health score
//   α₄=0.15: Conflict resolution history (WarSimEngine wins ratio)
//   α₅=0.10: Navigation precision (SalmonNavigation confidence)
//   α₆=0.10: Learning rate (OctopusBrain memory consolidation)
//   Σ αₖ = 1.00
//   Merit M_i ∈ [0,1]
//
// ── LAYER 5: TRANSITION DYNAMICS ─────────────────────────────────────────────
//   Transition probability matrix P (Markov chain)
//   P_ij = probability of transitioning from leader i to leader j
//   Detailed balance condition (ergodic chain): π × P = π
//   Stationary distribution π: πᵢ = M_i / Σⱼ Mⱼ  (merit-proportional)
//   Mixing time: T_mix ≈ 1 / (1 - λ₂)  where λ₂ = second eigenvalue of P
//   Fast mixing (λ₂ << 1) → rapid adaptation to merit changes
//   Slow mixing (λ₂ ≈ 1) → sticky leadership, slow response to change
//   NOVA: target T_mix ≈ 7 beats (weekly succession review)
//
// ── LAYER 6: CORRUPTION RESISTANCE — SHAPLEY-SHUBIK ──────────────────────────
//   Shapley-Shubik power index: measures coalition-building power
//   φᵢ = #{orderings where i is pivotal} / n!
//   Voter i is pivotal in ordering π if:
//   sum of weights before i < threshold, but sum including i ≥ threshold
//   For equal weights and threshold = 5/7: φᵢ = 1/7 for all (equal power)
//   Banzhaf index: βᵢ = #{winning coalitions where i is critical} / total
//   Corruption: voter changes vote for private gain (bribe modeling)
//   Expected bribe to change vote: B* = V(outcome) × (1 - coherence)
//   Resistance: higher coherence → harder to bribe → more sovereign
//
// ── LAYER 7: JUBILEE SUCCESSION — JUBILEE PROTOCOL ───────────────────────────
//   Every Ω = 9.0 sovereign cycles, Jubilee resets all succession claims
//   Jubilee: G_M returns to S₀ = 1.0 (Medina Fibonacci reset)
//   All FORMA debts forgiven, all leadership scores reset to baseline
//   Jubilee succession formula: new leader = argmax M_i × random(Φ_M, OMEGA_M)
//   This introduces sovereign randomness (PHI_MEDINA × U[0,1]) preventing lock-in
//   Post-Jubilee stability period: 7 beats of leadership continuity
//
// ── LAYER 8: MEDINA SUCCESSION INDEX ──────────────────────────────────────────
//   S_succ = S₀ × [current_merit × Φ_M + council_consensus] / Ω
//   current_merit = merit score of current leader [0,1]
//   council_consensus = fraction of council that approved current leader [0,1]
//   S_succ ∈ [0, S₀(Φ_M+1)/Ω] = [0, 0.441]
//   S_succ > 0.36 → succession is sovereign (stable leadership)
//   S_succ < 0.20 → succession crisis → emergency council convened
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Iter  "mo:base/Iter";

module {

  public let PHI_MEDINA       : Float = 2.97442179;
  public let S0               : Float = 1.0;
  public let SOVEREIGN_CEILING: Float = 9.0;
  public let COHERENCE_ALIVE  : Float = 0.36;
  public let OMEGA_MEDINA     : Float = 2.11185;
  public let EPSILON          : Float = 1.0e-10;
  public let PI               : Float = 3.141592653589793;

  // Succession parameters
  public let N_COUNCIL         : Nat   = 7;       // council size
  public let COUNCIL_SUPERMAJORITY : Float = 5.0 / 7.0;  // 5/7 threshold
  public let VETO_THRESHOLD    : Float = 0.20;    // weight for veto power
  public let JUBILEE_PERIOD    : Float = SOVEREIGN_CEILING;  // 9 cycles

  // Weibull hazard parameters
  public let WEIBULL_BETA      : Float = 2.0;     // shape: β=2 (aging)
  public let WEIBULL_ETA       : Float = 100.0;   // scale: η beats

  // Merit criteria weights
  public let MERIT_W1_STABILITY  : Float = 0.25;
  public let MERIT_W2_FORMA      : Float = 0.20;
  public let MERIT_W3_ENTROPY    : Float = 0.20;
  public let MERIT_W4_CONFLICT   : Float = 0.15;
  public let MERIT_W5_NAV        : Float = 0.10;
  public let MERIT_W6_LEARNING   : Float = 0.10;

  // Corruption resistance
  public let BRIBE_BASE          : Float = 0.10;  // base bribe cost (FORMA)
  public let COHERENCE_BRIBE_MUL : Float = 2.0;   // coherence × multiplier

  public let HIST_MAX : Nat = 100;

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type CouncilMember = {
    id             : Nat;
    weight         : Float;     // voting weight [0,1]
    meritScore     : Float;     // M_i ∈ [0,1]
    stabilityScore : Float;     // SC from Lyapunov
    formaRate      : Float;     // FORMA generation rate
    winRate        : Float;     // conflict resolution win rate
    navConfidence  : Float;     // navigation confidence
    learningRate   : Float;     // learning speed
    age_beats      : Nat;       // leadership tenure
    isLeader       : Bool;
    voteHistory    : [Float];   // rolling vote record
  };

  public type SuccessionVote = {
    candidateId    : Nat;
    bordaScore     : Float;    // normalized Borda count
    weightedVote   : Float;    // weighted council vote
    isCondorcet    : Bool;     // is this a Condorcet winner?
    meritRank      : Nat;      // rank by merit (1=best)
    jubileeAdj     : Float;    // Jubilee-adjusted score
  };

  public type SuccessionState = {
    council        : [CouncilMember];
    currentLeader  : Nat;       // index into council
    leaderAge      : Nat;       // beats in power
    hazardRate     : Float;     // λ(t) — current succession risk
    successionProb : Float;     // probability of succession this beat
    lastVote       : [SuccessionVote];
    jubileeCycle   : Float;     // position in Jubilee cycle [0, Ω]
    jubileeActive  : Bool;      // is Jubilee in progress?
    successorId    : ?Nat;      // designated successor (if decided)
    councilConsensus : Float;   // [0,1] how much council agrees
    successionIndex : Float;    // S_succ sovereign index
    transitionMatrix : [Float]; // N×N Markov transition matrix (flattened)
    shapleyPower    : [Float];  // N Shapley-Shubik power indices
    histSuccessions : [Nat];    // past leader IDs
    beatNum         : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: MATH HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) 0.0 else Float.exp(exp * Float.log(base))
  };

  func _exp(x : Float) : Float { Float.exp(_clamp(x, -100.0, 100.0)) };

  func _appendNatRolling(buf : [Nat], val : Nat, cap : Nat) : [Nat] {
    if (buf.size() < cap) { Array.append<Nat>(buf, [val]) }
    else {
      let tail = Array.tabulate<Nat>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Nat>(tail, [val])
    }
  };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: MERIT CALCULATION
  // M_i = Σₖ αₖ × Cᵢₖ
  // ══════════════════════════════════════════════════════════════════════════

  public func computeMerit(member : CouncilMember) : Float {
    _clamp(
      MERIT_W1_STABILITY * member.stabilityScore +
      MERIT_W2_FORMA     * member.formaRate +
      MERIT_W3_ENTROPY   * (1.0 - _abs(member.meritScore - 0.6)) +  // entropy health near 0.6
      MERIT_W4_CONFLICT  * member.winRate +
      MERIT_W5_NAV       * member.navConfidence +
      MERIT_W6_LEARNING  * member.learningRate,
      0.0, 1.0
    )
  };

  // Update merit score for member
  public func updateMerit(member : CouncilMember) : CouncilMember {
    let newMerit = computeMerit(member);
    {
      id             = member.id;
      weight         = member.weight;
      meritScore     = newMerit;
      stabilityScore = member.stabilityScore;
      formaRate      = member.formaRate;
      winRate        = member.winRate;
      navConfidence  = member.navConfidence;
      learningRate   = member.learningRate;
      age_beats      = member.age_beats;
      isLeader       = member.isLeader;
      voteHistory    = member.voteHistory;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: BORDA COUNT VOTING
  // B_i = Σⱼ (N - rank_ij)
  // ══════════════════════════════════════════════════════════════════════════

  // Compute Borda scores for all candidates
  // ranks[j][i] = rank voter j gives candidate i (1=best)
  public func computeBordaScores(n : Nat, ranks : [[Nat]]) : [Float] {
    let nf = Float.fromInt(n);
    let scores = Array.init<Float>(n, 0.0);
    for (voterRanks in ranks.vals()) {
      var i : Nat = 0;
      while (i < n and i < voterRanks.size()) {
        let rank = voterRanks[i];
        let points = Float.fromInt(if (rank < n) (n - rank) else 0);
        scores[i] += points;
        i += 1;
      };
    };
    let maxScore = nf * (nf - 1.0);
    Array.tabulate<Float>(n, func(i) {
      if (maxScore < EPSILON) 0.0 else _clamp(scores[i] / maxScore, 0.0, 1.0)
    })
  };

  // Simplified Borda from merit scores (each member votes by merit ranking)
  public func meritBasedBorda(council : [CouncilMember]) : [Float] {
    let n = council.size();
    if (n == 0) { return [] };
    // Sort indices by merit (descending)
    let sortedByMerit = Array.tabulate<Nat>(n, func(i) { i });
    // Compute Borda for each: points = n - rank
    // rank of member i = number of members with higher merit
    Array.tabulate<Float>(n, func(i) {
      var higherMerit : Float = 0.0;
      var j : Nat = 0;
      while (j < n) {
        if (council[j].meritScore > council[i].meritScore) { higherMerit += 1.0 };
        j += 1;
      };
      let rank = higherMerit;  // 0-indexed rank
      _clamp((Float.fromInt(n) - 1.0 - rank) / Float.fromInt(n - 1), 0.0, 1.0)
    })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: WEIGHTED COUNCIL VOTE
  // V(x) = Σᵢ wᵢ × vote_i(x) / Σᵢ wᵢ
  // ══════════════════════════════════════════════════════════════════════════

  public func weightedCouncilVote(council : [CouncilMember], candidateIdx : Nat) : Float {
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;
    var i : Nat = 0;
    while (i < council.size()) {
      let m = council[i];
      let vote = if (i == candidateIdx) 1.0
                 else _clamp(m.meritScore / (if (candidateIdx < council.size()) council[candidateIdx].meritScore + EPSILON else 1.0), 0.0, 1.0);
      weightedSum += m.weight * vote;
      totalWeight += m.weight;
      i += 1;
    };
    if (totalWeight < EPSILON) 0.0 else _clamp(weightedSum / totalWeight, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: WEIBULL HAZARD RATE
  // λ(t) = (β/η) × (t/η)^(β-1)
  // ══════════════════════════════════════════════════════════════════════════

  // Weibull hazard rate at age t
  // λ(t) = (β/η) × (t/η)^(β-1)
  public func weibullHazard(age : Nat) : Float {
    let t = Float.fromInt(age) + 0.5;  // avoid t=0 singularity
    let rate = (WEIBULL_BETA / WEIBULL_ETA) * _pow(t / WEIBULL_ETA, WEIBULL_BETA - 1.0);
    _clamp(rate, 0.0, 1.0)
  };

  // Survival function: S(t) = exp(-∫₀ᵗ λ(s) ds) = exp(-(t/η)^β)
  public func weibullSurvival(age : Nat) : Float {
    let t = Float.fromInt(age);
    _clamp(_exp(-_pow(t / WEIBULL_ETA, WEIBULL_BETA)), 0.0, 1.0)
  };

  // Succession probability this beat: P(t) = λ(t) × Δt ≈ λ(t) × 1beat
  public func successionProbability(age : Nat) : Float {
    weibullHazard(age) * (1.0 - weibullSurvival(age))
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: SHAPLEY-SHUBIK POWER INDEX
  // φᵢ = #{orderings where i is pivotal} / n!
  // Simplified: equal weights → φᵢ = 1/N
  // ══════════════════════════════════════════════════════════════════════════

  public func shapleyPowerIndex(council : [CouncilMember]) : [Float] {
    let n = council.size();
    if (n == 0) { return [] };
    var totalWeight : Float = 0.0;
    for (m in council.vals()) { totalWeight += m.weight };

    // For weighted voting, approximate Shapley via Banzhaf-inspired formula
    // φᵢ ≈ wᵢ / totalWeight  (proportional approximation)
    Array.tabulate<Float>(n, func(i) {
      if (totalWeight < EPSILON) { 1.0 / Float.fromInt(n) }
      else { council[i].weight / totalWeight }
    })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: MARKOV TRANSITION MATRIX
  // P_ij = probability of transition from leader i to leader j
  // Stationary: πᵢ = Mᵢ / Σⱼ Mⱼ (merit-proportional)
  // ══════════════════════════════════════════════════════════════════════════

  public func computeTransitionMatrix(council : [CouncilMember]) : [Float] {
    let n = council.size();
    if (n == 0) { return [] };
    var totalMerit : Float = 0.0;
    for (m in council.vals()) { totalMerit += m.meritScore };
    if (totalMerit < EPSILON) {
      return Array.tabulate<Float>(n * n, func(k) {
        if (k mod (n + 1) == 0) 1.0 / Float.fromInt(n) else 0.0
      })
    };
    // P_ij = M_j / Σₖ Mₖ  (transition to most meritorious)
    // Self-loop: P_ii = 1 - λ(age_i)
    // Transition: P_ij (j≠i) = λ(age_i) × M_j / (Σₖ≠ᵢ Mₖ)
    Array.tabulate<Float>(n * n, func(k) {
      let i = k / n;
      let j = k mod n;
      if (i >= n or j >= n) { return 0.0 };
      if (i == j) {
        let survival = weibullSurvival(council[i].age_beats);
        _clamp(survival, 0.0, 1.0)
      } else {
        let hazard = 1.0 - weibullSurvival(council[i].age_beats);
        let mj = council[j].meritScore;
        let miTotal = totalMerit - council[i].meritScore;
        _clamp(hazard * mj / (miTotal + EPSILON), 0.0, 1.0)
      }
    })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: SUCCESSION INDEX
  // S_succ = S₀ × [current_merit × Φ_M + council_consensus] / Ω
  // ══════════════════════════════════════════════════════════════════════════

  public func successionIndex(currentMerit : Float, councilConsensus : Float) : Float {
    let idx = S0 * (currentMerit * PHI_MEDINA + councilConsensus) / SOVEREIGN_CEILING;
    _clamp(idx, 0.0, 1.0)
  };

  // Council consensus: fraction approving current leader (weighted vote > threshold)
  public func councilConsensus(council : [CouncilMember], leaderIdx : Nat) : Float {
    let wv = weightedCouncilVote(council, leaderIdx);
    _clamp(wv, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: JUBILEE CHECK
  // Every SOVEREIGN_CEILING cycles, Jubilee resets scores
  // ══════════════════════════════════════════════════════════════════════════

  public func isJubileeActive(jubileeCycle : Float) : Bool {
    jubileeCycle >= SOVEREIGN_CEILING * 0.99
  };

  public func jubileeReset(council : [CouncilMember]) : [CouncilMember] {
    Array.map<CouncilMember, CouncilMember>(council, func(m) {
      {
        id             = m.id;
        weight         = 1.0 / Float.fromInt(N_COUNCIL);  // equal weights post-Jubilee
        meritScore     = S0 / Float.fromInt(N_COUNCIL);   // reset merit to baseline
        stabilityScore = m.stabilityScore;
        formaRate      = m.formaRate;
        winRate        = m.winRate;
        navConfidence  = m.navConfidence;
        learningRate   = m.learningRate;
        age_beats      = 0;
        isLeader       = false;
        voteHistory    = [];
      }
    })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 12: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  public func beatSuccession(
    state          : SuccessionState,
    councilUpdates : [Float],     // N new merit scores from other modules
    randomRoll     : Float        // U[0,1] for succession dice
  ) : SuccessionState {
    let n = state.council.size();

    // Update council merit scores
    let updatedCouncil = Array.tabulate<CouncilMember>(n, func(i) {
      let m = state.council[i];
      let newStab = if (i < councilUpdates.size()) councilUpdates[i] else m.stabilityScore;
      let updated : CouncilMember = {
        id             = m.id;
        weight         = m.weight;
        meritScore     = m.meritScore;
        stabilityScore = newStab;
        formaRate      = m.formaRate;
        winRate        = m.winRate;
        navConfidence  = m.navConfidence;
        learningRate   = m.learningRate;
        age_beats      = if (i == state.currentLeader) m.age_beats + 1 else m.age_beats;
        isLeader       = i == state.currentLeader;
        voteHistory    = m.voteHistory;
      };
      updateMerit(updated)
    });

    // Compute hazard rate for current leader
    let leaderAge = updatedCouncil[state.currentLeader].age_beats;
    let hazard = weibullHazard(leaderAge);
    let succProb = successionProbability(leaderAge);

    // Should succession happen?
    let successionOccurs = randomRoll < succProb;

    // Find best successor (highest merit, not current leader)
    var bestSuccId : Nat = 0;
    var bestMerit : Float = 0.0;
    var i : Nat = 0;
    while (i < n) {
      if (i != state.currentLeader and updatedCouncil[i].meritScore > bestMerit) {
        bestMerit := updatedCouncil[i].meritScore;
        bestSuccId := i;
      };
      i += 1;
    };

    let newLeader = if (successionOccurs) bestSuccId else state.currentLeader;
    let newAge    = if (successionOccurs) 0 else leaderAge;

    // Jubilee cycle advance
    let newJubileeC = _clamp(state.jubileeCycle + 1.0 / JUBILEE_PERIOD, 0.0, SOVEREIGN_CEILING);
    let jubilee = isJubileeActive(newJubileeC);
    let postJubilee = if jubilee { jubileeReset(updatedCouncil) } else updatedCouncil;
    let finalJubileeC = if jubilee 0.0 else newJubileeC;

    // Compute succession metrics
    let consensus = councilConsensus(postJubilee, newLeader);
    let leaderMerit = postJubilee[newLeader].meritScore;
    let sIdx = successionIndex(leaderMerit, consensus);
    let shapley = shapleyPowerIndex(postJubilee);
    let transMatrix = computeTransitionMatrix(postJubilee);

    // Borda vote result
    let bordaScores = meritBasedBorda(postJubilee);
    let lastVote = Array.tabulate<SuccessionVote>(n, func(j) {
      {
        candidateId  = j;
        bordaScore   = if (j < bordaScores.size()) bordaScores[j] else 0.0;
        weightedVote = weightedCouncilVote(postJubilee, j);
        isCondorcet  = false;  // simplified
        meritRank    = j;
        jubileeAdj   = if jubilee (PHI_MEDINA / SOVEREIGN_CEILING) else 0.0;
      }
    });

    let newHistSucc = if (successionOccurs) _appendNatRolling(state.histSuccessions, newLeader, 50)
                      else state.histSuccessions;

    {
      council           = postJubilee;
      currentLeader     = newLeader;
      leaderAge         = newAge;
      hazardRate        = hazard;
      successionProb    = succProb;
      lastVote          = lastVote;
      jubileeCycle      = finalJubileeC;
      jubileeActive     = jubilee;
      successorId       = if successionOccurs (null) else (?bestSuccId);
      councilConsensus  = consensus;
      successionIndex   = sIdx;
      transitionMatrix  = transMatrix;
      shapleyPower      = shapley;
      histSuccessions   = newHistSucc;
      beatNum           = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 13: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  public func initSuccessionEngine() : SuccessionState {
    let initCouncil = Array.tabulate<CouncilMember>(N_COUNCIL, func(i) {
      {
        id             = i;
        weight         = 1.0 / Float.fromInt(N_COUNCIL);
        meritScore     = 0.5 + Float.fromInt(i) * 0.07;
        stabilityScore = 0.6;
        formaRate      = 0.5;
        winRate        = 0.5;
        navConfidence  = 0.5;
        learningRate   = 0.5;
        age_beats      = if (i == 0) 10 else 0;  // leader #0 has been around 10 beats
        isLeader       = i == 0;
        voteHistory    = [];
      }
    });

    let shapley = shapleyPowerIndex(initCouncil);
    let transMatrix = computeTransitionMatrix(initCouncil);
    let consensus = councilConsensus(initCouncil, 0);
    let leaderMerit = initCouncil[0].meritScore;

    {
      council           = initCouncil;
      currentLeader     = 0;
      leaderAge         = 10;
      hazardRate        = weibullHazard(10);
      successionProb    = successionProbability(10);
      lastVote          = [];
      jubileeCycle      = 0.0;
      jubileeActive     = false;
      successorId       = null;
      councilConsensus  = consensus;
      successionIndex   = successionIndex(leaderMerit, consensus);
      transitionMatrix  = transMatrix;
      shapleyPower      = shapley;
      histSuccessions   = [0];
      beatNum           = 0;
    }
  };

}
