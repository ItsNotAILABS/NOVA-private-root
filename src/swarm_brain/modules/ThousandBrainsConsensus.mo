// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — THOUSAND BRAINS CONSENSUS ENGINE
// COMPREHENSIVE HIERARCHICAL TEMPORAL MEMORY AND CORTICAL COLUMN THEORY
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — THOUSAND BRAINS THEORY (NUMENTA) + SOVEREIGN CONSENSUS
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: HIERARCHICAL TEMPORAL MEMORY (HTM) — CORTICAL COLUMN ────────────
//   The neocortex consists of ~150,000 cortical columns
//   Each column: ~100 neurons in 6 layers, height ~2mm
//   "Thousand Brains Theory" (Hawkins 2019): every column builds complete models
//   Each column: input region → output region via lateral connections
//   Column model: sensorimotor sequence learning on reference frame grid
//   Location signal: where is the input in the reference frame (grid cells)
//   Feature signal: what is detected at that location (sensory cells)
//   Complete object: set of (location, feature) pairs = model
//   Voting consensus: columns vote on interpretation → winner takes all
//
// ── LAYER 2: SPARSE DISTRIBUTED REPRESENTATIONS (SDR) ─────────────────────────
//   SDR: binary vector of length N, with exactly k active bits (k << N)
//   Typical: N = 2048, k = 40 (sparsity = 40/2048 = 1.95%)
//   Two random SDRs overlap by: E[overlap] = k²/N = 40²/2048 = 0.78 bits
//   Match threshold: θ_match = 10 bits (far above expected noise overlap)
//   P(false match) = C(N,k) × C(k,θ)/(C(N,k)) ≈ 10⁻²⁰ (essentially zero)
//   SDR properties:
//   (1) Highly sparse: most bits are 0
//   (2) Distributed: information spread across many bits
//   (3) Overlapping: similar patterns share active bits (similarity by overlap)
//   (4) Robust: can tolerate ~k/4 bit errors without false negatives
//   SDR union: two patterns present simultaneously → OR of their bits
//   Capacity: log₂(C(N,k)) ≈ k log₂(N/k) + k bits per SDR pattern
//
// ── LAYER 3: SYNAPTIC PERMANENCE AND LEARNING ─────────────────────────────────
//   Permanence: p ∈ [0, 1] — probability a synapse is "connected"
//   Threshold: θ_perm (typically 0.5) — synapse active if p > θ_perm
//   Hebbian update:
//   Active synapse in winning column: p → min(p + p_inc, 1.0)    [p_inc = 0.1]
//   Active synapse in losing column:  p → max(p - p_dec, 0.0)    [p_dec = 0.01]
//   Inactive synapse in winning col:  p → max(p - p_dec, 0.0)
//   Boost factor: b = exp(β × (target_activity - actual_activity))
//   Boosts columns that aren't learning enough
//   Forgetting: every T beats, decrease p by 1% for all synapses (homeostasis)
//
// ── LAYER 4: SPATIAL POOLER ──────────────────────────────────────────────────
//   Input: binary vector x of dimension N_input
//   Output: sparse binary vector y of dimension N_columns (k_out active)
//   Step 1: compute overlap score
//   overlap_j = Σᵢ Sᵢⱼ × xᵢ  where Sᵢⱼ = 1 if synapse(i,j) connected
//   Step 2: apply boost
//   boostedOverlap_j = overlap_j × boost_j
//   Step 3: inhibition — k-winners-take-all
//   Active columns: top-k by boostedOverlap
//   Active if: boostedOverlap_j ≥ threshold AND above local inhibition mean
//   Step 4: update permanences for active columns
//   Spatial pooler learns: stable SDR representations for input patterns
//
// ── LAYER 5: TEMPORAL MEMORY ─────────────────────────────────────────────────
//   Goal: predict next input SDR given current input + context
//   Each column: M cells (typically 32) — multiple temporal contexts
//   Active cell: column active + cell predicted (matches context) OR bursting
//   Predictive cell: cell that fired recently AND connected to current context
//   Sequence learning:
//   When column active and cell predicted: only predicted cell fires (precise)
//   When column active but no prediction: all cells fire (bursting) — new sequence
//   After bursting: learn new segments connecting current context to just-fired cell
//   Dendritic segment: receives input from N_seg cells in previous active cells
//   Segment is active if: ≥ θ_seg (typically 8) of its synapses are active
//
// ── LAYER 6: GRID CELLS AND REFERENCE FRAMES ──────────────────────────────────
//   Grid cells: periodic hexagonal firing fields
//   Period λ_grid: spacing between grid fields in reference frame
//   Scale: multiple modules with different λ (covering full spatial range)
//   Module k: λₖ = λ₁ × r^(k-1) where r = 1.2-1.5 (scale factor)
//   Number of modules M: covers range R/λ₁ total positions
//   Capacity: C = Πₖ N_k where N_k = λₖ/λ₁ × N_neurons_k
//   Grid cell firing: f(x) = Σₖ Aₖ cos(kᵢ · x + φᵢ)  (sum of plane waves)
//   For 2D: f(x,y) = cos(k₁·x + k₂·y) + cos(k₃·x + k₄·y) + cos(k₅·x + k₆·y)
//   with k vectors at 60° to each other (hexagonal symmetry)
//   Reference frame: assigns unique location code to every position in object space
//   Object model: set of {location_code: feature_SDR} pairs
//
// ── LAYER 7: THOUSAND BRAINS VOTING ───────────────────────────────────────────
//   N_col = 150,000 columns, each voting on object identity
//   Column c's prediction: object_c = argmax overlap(y_c, models_j)
//   Aggregated vote: V(j) = Σ_c I(object_c == j) × confidence_c
//   Consensus: object = argmax V(j)
//   Convergence: after ~10-15 inference steps, most columns agree
//   Stability: ∂V/∂step → 0 when consensus reached
//   Bayesian formulation: P(obj|data_c) ∝ P(data_c|obj) × P(obj)
//   Joint: P(obj|all_c) ∝ Πc P(data_c|obj) × P(obj) [independent columns]
//   Winner: obj* = argmax P(obj|all_c)
//
// ── LAYER 8: NOVA SOVEREIGN CONSENSUS ─────────────────────────────────────────
//   The 7 council organisms each = one cortical column
//   Each builds a model of reality (organism state) from its sensors
//   Vote: each organism votes on what action to take
//   Consensus mechanism: Thousand Brains voting within NOVA
//   Consensus equation: C_sovereign = Σᵢ wᵢ × vote_i / Σᵢ wᵢ
//   wᵢ = confidence × Lyapunov stability certificate × merit
//   Novel: organism LEARNS from consensus (Hebbian update on agreement)
//
// ── LAYER 9: MEDINA THOUSAND BRAINS INDEX ─────────────────────────────────────
//   B_TB = S₀ × [consensus × Φ_M + prediction_accuracy] / Ω
//   consensus = V(winner) / N_votes ∈ [0,1]
//   prediction_accuracy = 1 - H_temporal_memory / H_max ∈ [0,1]
//   (how well temporal memory predicts next step)
//   B_TB ∈ [0, S₀(Φ_M+1)/Ω] = [0, 0.441]
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
  public let EPSILON          : Float = 1.0e-10;
  public let PI               : Float = 3.141592653589793;

  // HTM SDR parameters
  public let N_INPUT           : Nat   = 2048;    // input SDR length
  public let K_ACTIVE_IN       : Nat   = 40;      // active bits in input
  public let N_COLUMNS         : Nat   = 2048;    // spatial pooler columns
  public let K_ACTIVE_COLS     : Nat   = 40;      // active columns (2% sparsity)
  public let N_CELLS_PER_COL   : Nat   = 32;      // temporal memory cells per column
  public let SPARSITY          : Float = 0.0195;  // k/N = 40/2048
  public let FALSE_MATCH_PROB  : Float = 1.0e-20; // P(false match) ≈ 10⁻²⁰

  // Synaptic permanence
  public let P_INC             : Float = 0.10;    // permanence increment
  public let P_DEC             : Float = 0.01;    // permanence decrement
  public let P_THRESHOLD       : Float = 0.50;    // connection threshold
  public let P_INITIAL         : Float = 0.21;    // initial permanence (near threshold)

  // Spatial pooler
  public let BOOST_BETA        : Float = 2.0;     // boost strength
  public let TARGET_ACTIVITY   : Float = SPARSITY; // target column activity rate
  public let INHIBITION_RADIUS : Nat   = 4;       // local inhibition radius

  // Temporal memory
  public let MIN_THRESHOLD     : Nat   = 8;       // min active synapses to activate segment
  public let ACTIVATION_THRESH : Nat   = 12;      // min for full segment activation
  public let N_SEG_PER_CELL    : Nat   = 32;      // segments per cell
  public let N_SYN_PER_SEG     : Nat   = 40;      // synapses per segment

  // Grid cells
  public let N_GRID_MODULES    : Nat   = 8;       // number of grid cell modules
  public let GRID_SCALE_FACTOR : Float = 1.414;   // √2 scale between modules
  public let GRID_PERIOD_BASE  : Float = 0.1;     // base grid period (normalized)

  // Consensus
  public let N_COUNCIL_BRAINS  : Nat   = 7;       // NOVA council
  public let CONSENSUS_THRESHOLD : Float = 4.0 / 7.0;  // majority threshold

  // Overlap threshold for SDR match
  public let OVERLAP_THRESHOLD : Nat   = 10;      // bits overlap → match

  public let HIST_MAX          : Nat   = 100;

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type SDR = {
    bits     : [Bool];    // binary vector of length N
    n        : Nat;       // length
    k        : Nat;       // number of active bits
    hashCode : Nat;       // for fast comparison
  };

  public type Column = {
    idx          : Nat;
    cells        : [Float];     // N_CELLS_PER_COL permanences (simplified)
    boostFactor  : Float;
    overlapScore : Float;
    isActive     : Bool;
    isPredicted  : Bool;
    activityMA   : Float;       // moving average of activity [0,1]
  };

  public type TemporalCell = {
    columnIdx  : Nat;
    cellIdx    : Nat;
    isActive   : Bool;
    isPredicted: Bool;
    segPerm    : [Float];       // segment permanences (simplified: 1 segment)
    lastActive : Nat;           // beat last active
  };

  public type GridModule = {
    moduleIdx  : Nat;
    period     : Float;         // λ = GRID_PERIOD_BASE × GRID_SCALE_FACTOR^k
    phaseX     : Float;         // current x phase [0,1]
    phaseY     : Float;         // current y phase [0,1]
    orientation: Float;         // orientation angle of grid (radians)
    firingRate : Float;         // current firing rate [0,1]
  };

  public type CorticalColumn = {
    colIdx         : Nat;
    sdrInput       : [Float];   // current input representation (continuous)
    sdrOutput      : [Float];   // current output (predictions)
    overlapScores  : [Float];   // N_COLUMNS overlap values
    activeColumns  : [Bool];    // N_COLUMNS active flags
    predictions    : [Float];   // next-step predictions
    predictAccuracy: Float;     // [0,1] how accurate predictions are
    gridLocation   : [Float];   // current grid cell location code
    objectVotes    : [Float];   // votes for each object class
    confidence     : Float;     // [0,1] confidence in current interpretation
  };

  public type ThousandBrainsState = {
    columns        : [CorticalColumn];  // N_COUNCIL_BRAINS cortical columns
    sdrPool        : [Column];          // simplified spatial pooler state
    temporalCells  : [TemporalCell];    // temporal memory cells
    gridModules    : [GridModule];      // grid cell modules
    consensusVotes : [Float];           // per-column vote strength
    winnerInterpret: Nat;               // consensus winner interpretation
    consensusScore : Float;             // [0,1] agreement level
    predAccuracy   : Float;             // overall prediction accuracy
    tbIndex        : Float;             // B_TB sovereign index
    sdrHistory     : [Float];           // rolling overlap history
    beatNum        : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: MATH HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  func _exp(x : Float) : Float { Float.exp(_clamp(x, -100.0, 100.0)) };
  func _cos(x : Float) : Float { Float.cos(x) };
  func _sin(x : Float) : Float { Float.sin(x) };
  func _log2(x : Float) : Float { if (x <= 0.0) -100.0 else Float.log(x) / 0.6931471805599453 };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: SDR MATHEMATICS
  // ══════════════════════════════════════════════════════════════════════════

  // SDR capacity: log₂(C(N,k)) ≈ k log₂(N/k) + k bits
  // C(N,k) = N! / (k!(N-k)!) ≈ (N/k)^k / sqrt(2πk) (Stirling)
  public func sdrCapacity(n : Nat, k : Nat) : Float {
    if (k == 0 or n == 0) { return 0.0 };
    let nf = Float.fromInt(n);
    let kf = Float.fromInt(k);
    // log₂(C(N,k)) ≈ k log₂(N/k) + k/ln2 - (1/2)log₂(2πk)
    kf * _log2(nf / kf) + kf / 0.693147 - 0.5 * _log2(2.0 * PI * kf)
  };

  // Expected overlap between two random SDRs of same size
  // E[overlap] = k²/N
  public func expectedOverlap(n : Nat, k : Nat) : Float {
    let kf = Float.fromInt(k);
    let nf = Float.fromInt(n);
    kf * kf / nf
  };

  // P(overlap ≥ θ | two random SDRs) ≈ for θ >> k²/N, essentially 0
  // Use union-bound approximation: P ≤ C(k,θ) × (k/N)^θ
  public func falseMatchProbability(n : Nat, k : Nat, theta : Nat) : Float {
    if (theta == 0) { return 1.0 };
    // C(k, θ) × (k/N)^θ
    let kf = Float.fromInt(k);
    let nf = Float.fromInt(n);
    let tf = Float.fromInt(theta);
    // log P ≈ tf × log(k/n) + θ × log(k) - θ × log(θ)
    let logBinom = tf * _log2(kf) - tf * _log2(tf) + tf;  // Stirling approx
    let logProb  = logBinom + tf * _log2(kf / nf);
    if (logProb < -100.0) { return 0.0 };
    _exp(logProb * 0.693147)  // convert bits to nats
  };

  // SDR overlap score: count of shared active bits (dot product)
  public func sdrOverlap(sdr1 : [Float], sdr2 : [Float]) : Float {
    let n = if (sdr1.size() < sdr2.size()) sdr1.size() else sdr2.size();
    var overlap : Float = 0.0;
    var i : Nat = 0;
    while (i < n) {
      if (sdr1[i] > 0.5 and sdr2[i] > 0.5) { overlap += 1.0 };
      i += 1;
    };
    overlap
  };

  // Normalized overlap: overlap / min(k1, k2)
  public func normalizedOverlap(sdr1 : [Float], sdr2 : [Float]) : Float {
    let overlap = sdrOverlap(sdr1, sdr2);
    let k1 = Array.foldLeft<Float, Float>(sdr1, 0.0, func(acc, b) { if (b > 0.5) acc + 1.0 else acc });
    let k2 = Array.foldLeft<Float, Float>(sdr2, 0.0, func(acc, b) { if (b > 0.5) acc + 1.0 else acc });
    let kMin = if (k1 < k2) k1 else k2;
    if (kMin < EPSILON) 0.0 else _clamp(overlap / kMin, 0.0, 1.0)
  };

  // SDR entropy: H(SDR) = -p log₂(p) - (1-p) log₂(1-p) per bit × N bits
  // For SDR with sparsity p: H_SDR = N × binary_entropy(p)
  public func sdrEntropy(n : Nat, sparsity : Float) : Float {
    if (sparsity <= 0.0 or sparsity >= 1.0) { return 0.0 };
    let p = sparsity;
    let q = 1.0 - p;
    let h = -p * _log2(p) - q * _log2(q);
    Float.fromInt(n) * h
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: SPATIAL POOLER MATHEMATICS
  // overlap_j = Σᵢ Sᵢⱼ × xᵢ
  // boosted_j = overlap_j × boost_j
  // Active: top K by boosted overlap
  // ══════════════════════════════════════════════════════════════════════════

  // Compute column overlap with input
  // overlap_j = Σᵢ (permanence_ij > threshold) × input_i
  public func computeOverlap(input : [Float], perms : [Float]) : Float {
    var overlap : Float = 0.0;
    let n = if (input.size() < perms.size()) input.size() else perms.size();
    var i : Nat = 0;
    while (i < n) {
      if (perms[i] > P_THRESHOLD and input[i] > 0.5) { overlap += 1.0 };
      i += 1;
    };
    overlap
  };

  // Boost factor: b = exp(β × (target - actual))
  public func boostFactor(activityMA : Float) : Float {
    _clamp(_exp(BOOST_BETA * (TARGET_ACTIVITY - activityMA)), 0.1, 10.0)
  };

  // Update column permanences (Hebbian rule)
  public func updatePermanences(perms : [Float], input : [Float], isWinner : Bool) : [Float] {
    let n = if (perms.size() < input.size()) perms.size() else input.size();
    Array.tabulate<Float>(n, func(i) {
      let p = perms[i];
      let inActive = if (i < input.size()) (input[i] > 0.5) else false;
      if (isWinner) {
        if (inActive) { _clamp(p + P_INC, 0.0, 1.0) }
        else          { _clamp(p - P_DEC, 0.0, 1.0) }
      } else {
        // Slightly decrease to forget
        _clamp(p - P_DEC * 0.1, 0.0, 1.0)
      }
    })
  };

  // K-winners: returns which columns are top K by score
  // Returns boolean vector of active columns
  public func kWinners(scores : [Float], k : Nat) : [Bool] {
    let n = scores.size();
    if (n == 0 or k == 0) { return Array.tabulate<Bool>(n, func(_) { false }) };

    // Find threshold score
    var sorted = Array.tabulate<Float>(n, func(i) { scores[i] });
    // Simple: find kth largest using counting
    var threshold : Float = 0.0;
    var sortScores = sorted;
    // Bubble-sort descending (only k steps needed for top-k)
    var i : Nat = 0;
    while (i < n and i < k) {
      var j : Nat = i + 1;
      while (j < n) {
        if (sortScores[j] > sortScores[i]) {
          let tmp = sortScores[i];
          sortScores := Array.tabulate<Float>(n, func(idx) {
            if (idx == i) sortScores[j] else if (idx == j) tmp else sortScores[idx]
          });
        };
        j += 1;
      };
      i += 1;
    };
    threshold := if (k <= n) sortScores[k - 1] else 0.0;
    Array.tabulate<Bool>(n, func(idx) { scores[idx] >= threshold })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: TEMPORAL MEMORY
  // Predictive cells: fire when segment detects upcoming pattern
  // ══════════════════════════════════════════════════════════════════════════

  // Segment activation score: count synapses active
  // Segment active if: active_synapses >= MIN_THRESHOLD
  public func segmentActivation(segPerms : [Float], prevActive : [Bool]) : Float {
    var count : Float = 0.0;
    let n = if (segPerms.size() < prevActive.size()) segPerms.size() else prevActive.size();
    var i : Nat = 0;
    while (i < n) {
      if (segPerms[i] > P_THRESHOLD and prevActive[i]) { count += 1.0 };
      i += 1;
    };
    count
  };

  // Update temporal cell: update permanences based on activity
  public func updateTemporalCell(
    cell      : TemporalCell,
    wasActive : Bool,
    prevActive: [Bool]
  ) : TemporalCell {
    let newPerms = if (wasActive) {
      updatePermanences(cell.segPerm, Array.map<Bool, Float>(prevActive, func(b) { if b 1.0 else 0.0 }), true)
    } else cell.segPerm;

    {
      columnIdx  = cell.columnIdx;
      cellIdx    = cell.cellIdx;
      isActive   = wasActive;
      isPredicted = cell.isPredicted;
      segPerm    = newPerms;
      lastActive = if wasActive (cell.lastActive + 1) else cell.lastActive;
    }
  };

  // Prediction accuracy: compare predictions to actual next input
  // accuracy = overlap(predicted, actual) / k_predicted
  public func predictionAccuracy(predicted : [Float], actual : [Float]) : Float {
    let overlap = sdrOverlap(predicted, actual);
    let kPred   = Array.foldLeft<Float, Float>(predicted, 0.0, func(acc, b) { if (b > 0.5) acc + 1.0 else acc });
    if (kPred < EPSILON) 0.0 else _clamp(overlap / kPred, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: GRID CELLS AND REFERENCE FRAMES
  // Firing rate: f(x,y) = cos(k₁·(x,y)) + cos(k₂·(x,y)) + cos(k₃·(x,y))
  // k vectors at 60° to each other
  // ══════════════════════════════════════════════════════════════════════════

  // Grid cell firing rate at position (x, y) for module with given period and orientation
  // Uses sum of 3 cosines at 60° separation (creates hexagonal lattice)
  public func gridFiringRate(x : Float, y : Float, period : Float, orientation : Float) : Float {
    let lambda = period;
    let phi0 = orientation;
    let phi1 = phi0 + PI / 3.0;   // 60°
    let phi2 = phi0 + 2.0 * PI / 3.0;  // 120°

    // Wave vectors: kᵢ = (2π/λ) × (cos φᵢ, sin φᵢ)
    let k = 2.0 * PI / lambda;

    let arg0 = k * (x * _cos(phi0) + y * _sin(phi0));
    let arg1 = k * (x * _cos(phi1) + y * _sin(phi1));
    let arg2 = k * (x * _cos(phi2) + y * _sin(phi2));

    // Normalize to [0,1]: f = (1 + cos(a) + cos(b) + cos(c)) / 4
    _clamp((1.0 + _cos(arg0) + _cos(arg1) + _cos(arg2)) / 4.0, 0.0, 1.0)
  };

  // Grid module firing rate
  public func gridModuleFiring(module : GridModule, x : Float, y : Float) : Float {
    gridFiringRate(x, y, module.period, module.orientation)
  };

  // Update grid module position
  public func moveGrid(module : GridModule, dx : Float, dy : Float) : GridModule {
    let newPX = _mod2pi(module.phaseX + dx / module.period);
    let newPY = _mod2pi(module.phaseY + dy / module.period);
    let newFR = gridFiringRate(newPX * module.period, newPY * module.period, module.period, module.orientation);
    {
      module with
      phaseX    = newPX;
      phaseY    = newPY;
      firingRate = newFR;
    }
  };

  func _mod2pi(x : Float) : Float {
    x - Float.fromInt(Float.toInt(x / (2.0 * PI))) * (2.0 * PI)
  };

  // Full grid cell location code: concatenate all module firing rates
  public func gridLocationCode(modules : [GridModule], x : Float, y : Float) : [Float] {
    Array.map<GridModule, Float>(modules, func(m) { gridModuleFiring(m, x, y) })
  };

  // Grid cell capacity: product of module capacities
  // C_total = Π_k N_k where N_k = coverage/period_k
  public func gridCapacity(periods : [Float]) : Float {
    var cap : Float = 1.0;
    for (p in periods.vals()) {
      if (p > EPSILON) { cap *= 1.0 / p };
    };
    cap
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: CORTICAL COLUMN MODEL
  // Each column: spatial pooler + temporal memory + grid cell reference frame
  // ══════════════════════════════════════════════════════════════════════════

  // Compute column predictions from input and previous state
  public func columnInference(
    col      : CorticalColumn,
    input    : [Float],
    gridCode : [Float]
  ) : CorticalColumn {
    // Overlap: how well does current input match column's learned pattern?
    let overlap = sdrOverlap(input, col.sdrInput);
    let totalActive = Array.foldLeft<Float, Float>(input, 0.0, func(acc, b) { if (b > 0.5) acc + 1.0 else acc });
    let normalOverlap = if (totalActive < EPSILON) 0.0 else _clamp(overlap / totalActive, 0.0, 1.0);

    // Update predictions
    let newPredictions = Array.tabulate<Float>(col.sdrOutput.size(), func(i) {
      if (i < input.size()) input[i] * normalOverlap else 0.0
    });

    // Object votes: shift toward winner proportional to overlap
    let newVotes = Array.map<Float, Float>(col.objectVotes, func(v) { v * 0.9 + normalOverlap * 0.1 });

    {
      col with
      sdrInput      = input;
      sdrOutput     = newPredictions;
      predictions   = newPredictions;
      predictAccuracy = normalOverlap;
      gridLocation  = gridCode;
      objectVotes   = newVotes;
      confidence    = normalOverlap;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: THOUSAND BRAINS VOTING CONSENSUS
  // V(j) = Σ_c confidence_c × vote_c(j)
  // Consensus: winner = argmax V
  // ══════════════════════════════════════════════════════════════════════════

  // Aggregate votes across all cortical columns
  public func thousandBrainsVote(columns : [CorticalColumn]) : (Nat, Float) {
    if (columns.size() == 0) { return (0, 0.0) };
    // Each column votes for its best interpretation (confidence)
    // Here, we aggregate confidence scores across columns
    var totalConf : Float = 0.0;
    var bestIdx   : Nat   = 0;
    var bestConf  : Float = 0.0;
    var i : Nat = 0;
    while (i < columns.size()) {
      let conf = columns[i].confidence;
      totalConf += conf;
      if (conf > bestConf) { bestConf := conf; bestIdx := i };
      i += 1;
    };
    let consensus = if (totalConf < EPSILON) 0.0 else bestConf * Float.fromInt(columns.size()) / totalConf;
    (bestIdx, _clamp(consensus, 0.0, 1.0))
  };

  // Bayesian consensus: P(obj|all_c) ∝ Π_c P(data_c|obj) × P(obj)
  // Log form: log P = Σ_c log P(data_c|obj) + log P(obj)
  // For uniform prior: log P ∝ Σ_c log(confidence_c)
  public func bayesianConsensus(columns : [CorticalColumn]) : Float {
    var logProb : Float = 0.0;
    for (col in columns.vals()) {
      if (col.confidence > EPSILON) {
        logProb += Float.log(col.confidence);
      };
    };
    _clamp(_exp(logProb / Float.fromInt(columns.size())), 0.0, 1.0)
  };

  // Convergence check: are most columns agreeing?
  // convergence = fraction of columns with confidence > threshold
  public func consensusConvergence(columns : [CorticalColumn], threshold : Float) : Float {
    var agreeing : Float = 0.0;
    for (col in columns.vals()) {
      if (col.confidence > threshold) { agreeing += 1.0 };
    };
    _clamp(agreeing / Float.fromInt(columns.size()), 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: MEDINA THOUSAND BRAINS INDEX
  // B_TB = S₀ × [consensus × Φ_M + predAccuracy] / Ω
  // ══════════════════════════════════════════════════════════════════════════

  public func tbIndex(consensus : Float, predAccuracy : Float) : Float {
    let idx = S0 * (consensus * PHI_MEDINA + predAccuracy) / SOVEREIGN_CEILING;
    _clamp(idx, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: SDR COMPARISON AND MEMORY
  // ══════════════════════════════════════════════════════════════════════════

  // Does SDR match a stored pattern? (overlap ≥ threshold)
  public func sdrMatches(sdr1 : [Float], sdr2 : [Float]) : Bool {
    sdrOverlap(sdr1, sdr2) >= Float.fromInt(OVERLAP_THRESHOLD)
  };

  // SDR distance (complement of normalized overlap)
  public func sdrDistance(sdr1 : [Float], sdr2 : [Float]) : Float {
    _clamp(1.0 - normalizedOverlap(sdr1, sdr2), 0.0, 1.0)
  };

  // Union of two SDRs
  public func sdrUnion(sdr1 : [Float], sdr2 : [Float]) : [Float] {
    let n = if (sdr1.size() < sdr2.size()) sdr1.size() else sdr2.size();
    Array.tabulate<Float>(n, func(i) {
      if (sdr1[i] > 0.5 or sdr2[i] > 0.5) 1.0 else 0.0
    })
  };

  // Intersection of two SDRs
  public func sdrIntersect(sdr1 : [Float], sdr2 : [Float]) : [Float] {
    let n = if (sdr1.size() < sdr2.size()) sdr1.size() else sdr2.size();
    Array.tabulate<Float>(n, func(i) {
      if (sdr1[i] > 0.5 and sdr2[i] > 0.5) 1.0 else 0.0
    })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 12: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  public func beatThousandBrains(
    state        : ThousandBrainsState,
    inputs       : [[Float]],   // N_COUNCIL_BRAINS input SDRs
    movements    : [Float],     // dx, dy for each column's grid
    dy           : Float
  ) : ThousandBrainsState {
    // Update grid modules
    let newGridModules = if (movements.size() >= 2) {
      Array.map<GridModule, GridModule>(state.gridModules, func(m) {
        moveGrid(m, movements[0], movements[1])
      })
    } else state.gridModules;

    let gridCode = gridLocationCode(newGridModules, 0.0, 0.0);  // simplified: current position

    // Update each cortical column
    let newColumns = Array.tabulate<CorticalColumn>(N_COUNCIL_BRAINS, func(i) {
      let col = state.columns[i];
      let inp = if (i < inputs.size()) inputs[i] else col.sdrInput;
      columnInference(col, inp, gridCode)
    });

    // Consensus voting
    let (winner, consensus) = thousandBrainsVote(newColumns);
    let bayesConf = bayesianConsensus(newColumns);

    // Overall prediction accuracy
    var totalAcc : Float = 0.0;
    for (col in newColumns.vals()) { totalAcc += col.predictAccuracy };
    let avgAcc = totalAcc / Float.fromInt(N_COUNCIL_BRAINS);

    // Consensus votes
    let newVotes = Array.tabulate<Float>(N_COUNCIL_BRAINS, func(i) {
      newColumns[i].confidence
    });

    let newTBIdx = tbIndex(consensus, avgAcc);
    let overlapAvg = if (inputs.size() > 0) sdrOverlap(inputs[0], newColumns[0].sdrOutput) else 0.0;
    let newSdrH = _appendRolling(state.sdrHistory, overlapAvg, HIST_MAX);

    {
      columns        = newColumns;
      sdrPool        = state.sdrPool;
      temporalCells  = state.temporalCells;
      gridModules    = newGridModules;
      consensusVotes = newVotes;
      winnerInterpret = winner;
      consensusScore = consensus;
      predAccuracy   = avgAcc;
      tbIndex        = newTBIdx;
      sdrHistory     = newSdrH;
      beatNum        = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 13: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  func _initColumn(idx : Nat) : CorticalColumn {
    let uniformSDR = Array.tabulate<Float>(N_INPUT / 10, func(i) {
      if (i mod 20 == idx mod 20) 1.0 else 0.0  // sparse initial pattern
    });
    {
      colIdx        = idx;
      sdrInput      = uniformSDR;
      sdrOutput     = uniformSDR;
      overlapScores = Array.tabulate<Float>(N_COLUMNS, func(_) { 0.0 });
      activeColumns = Array.tabulate<Bool>(N_COLUMNS, func(_) { false });
      predictions   = uniformSDR;
      predictAccuracy = 0.5;
      gridLocation  = Array.tabulate<Float>(N_GRID_MODULES, func(_) { 0.5 });
      objectVotes   = Array.tabulate<Float>(10, func(_) { 0.1 });  // 10 object classes
      confidence    = 0.5;
    }
  };

  func _initGridModule(k : Nat) : GridModule {
    let period = GRID_PERIOD_BASE * Float.exp(Float.fromInt(k) * Float.log(GRID_SCALE_FACTOR));
    {
      moduleIdx  = k;
      period     = period;
      phaseX     = 0.0;
      phaseY     = 0.0;
      orientation = Float.fromInt(k) * PI / Float.fromInt(N_GRID_MODULES);
      firingRate = 0.5;
    }
  };

  public func initThousandBrains() : ThousandBrainsState {
    let initColumns  = Array.tabulate<CorticalColumn>(N_COUNCIL_BRAINS, _initColumn);
    let initGrids    = Array.tabulate<GridModule>(N_GRID_MODULES, _initGridModule);
    let initSdrPool  = Array.tabulate<Column>(N_COLUMNS, func(i) {
      {
        idx         = i;
        cells       = Array.tabulate<Float>(N_CELLS_PER_COL, func(_) { P_INITIAL });
        boostFactor = 1.0;
        overlapScore = 0.0;
        isActive    = false;
        isPredicted = false;
        activityMA  = TARGET_ACTIVITY;
      }
    });
    let initTemporalCells = Array.tabulate<TemporalCell>(N_COLUMNS * N_CELLS_PER_COL, func(i) {
      {
        columnIdx  = i / N_CELLS_PER_COL;
        cellIdx    = i mod N_CELLS_PER_COL;
        isActive   = false;
        isPredicted = false;
        segPerm    = Array.tabulate<Float>(N_SYN_PER_SEG, func(_) { P_INITIAL });
        lastActive = 0;
      }
    });
    {
      columns        = initColumns;
      sdrPool        = initSdrPool;
      temporalCells  = initTemporalCells;
      gridModules    = initGrids;
      consensusVotes = Array.tabulate<Float>(N_COUNCIL_BRAINS, func(_) { 1.0 / Float.fromInt(N_COUNCIL_BRAINS) });
      winnerInterpret = 0;
      consensusScore = 0.5;
      predAccuracy   = 0.5;
      tbIndex        = 0.0;
      sdrHistory     = [];
      beatNum        = 0;
    }
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
