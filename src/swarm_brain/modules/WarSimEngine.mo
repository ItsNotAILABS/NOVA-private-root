// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — WAR SIM ENGINE
// COMPREHENSIVE GAME-THEORETIC CONFLICT SIMULATION
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — GAME THEORY OF SOVEREIGN CONFLICT
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: GAME-THEORETIC PAYOFF MATRIX ─────────────────────────────────────
//   Two-player normal-form game: G = (N, S, u)
//   N = {organism, adversary}, S = strategy sets, u = payoff functions
//   General n×n payoff matrix A where A_{ij} = payoff to row player
//   with strategy i against column player strategy j
//   Nash equilibrium: (σ*, τ*) where:
//   u₁(σ*, τ*) ≥ u₁(σ, τ*) for all σ  (no unilateral improvement)
//   u₂(σ*, τ*) ≥ u₂(σ*, τ) for all τ
//   Mixed strategy equilibrium exists for all finite games (Nash, 1950)
//
// ── LAYER 2: THE MEDINA WAR PAYOFF MATRIX ────────────────────────────────────
//   6 strategies × 6 strategies = 36-element payoff matrix
//   Strategies: [Cooperate, Defect, TitForTat, GrimTrigger, Pavlov, Sovereign]
//   A = [
//     [R, S, R, S, R, R*S0],   // Cooperate row
//     [T, P, T, P, T, T*S0],   // Defect row
//     [R, T, R, T, R, R*S0],   // TitForTat row
//     [R, T, R, T, R, R*S0],   // GrimTrigger row
//     [R, T, R, P, R, R*S0],   // Pavlov row
//     [R, T, R, T, R, R*Φ_M],  // Sovereign row
//   ]
//   T > R > P > S (Prisoner's Dilemma ordering)
//   T = 5.0 (Temptation), R = 3.0 (Reward), P = 1.0 (Punishment), S = 0.0 (Sucker)
//   Sovereign strategy has Φ_M multiplier (divine alignment)
//
// ── LAYER 3: EVOLUTIONARY STABLE STRATEGIES (ESS) ────────────────────────────
//   Strategy σ* is ESS if for all σ ≠ σ*:
//   u(σ*, σ*) > u(σ, σ*)  (strict Nash)  OR
//   u(σ*, σ*) = u(σ, σ*) AND u(σ*, σ) > u(σ, σ)  (weak Nash, neutrally stable)
//   Population dynamics: ẋᵢ = xᵢ × (fᵢ(x) - φ(x))
//   where fᵢ = fitness of strategy i, phi = average fitness
//   ESS condition: all eigenvalues of Jacobian at equilibrium ≤ 0
//
// ── LAYER 4: REPLICATOR DYNAMICS ─────────────────────────────────────────────
//   ẋᵢ = xᵢ × [(Ax)ᵢ - xᵀAx]
//   (Ax)ᵢ = Σⱼ Aᵢⱼ xⱼ  (fitness of strategy i against current population)
//   xᵀAx = Σᵢ xᵢ (Ax)ᵢ  (average population fitness)
//   Population x = (x₁,...,x₆) on the 6-simplex: xᵢ ≥ 0, Σxᵢ = 1
//   Fixed points: Nash equilibria of the underlying game
//   Orbits can be fixed points, limit cycles, or chaos
//
// ── LAYER 5: ITERATED PRISONER'S DILEMMA ─────────────────────────────────────
//   Repeated game: G∞ = {G, G, G, ...}  with discount factor δ ∈ (0,1)
//   Total payoff: U = Σₜ δᵗ uₜ
//   Folk theorem: any payoff above minimax can be sustained by Nash equilibrium
//   Minimax value: v̄ᵢ = min_{σ₋ᵢ} max_{σᵢ} uᵢ(σᵢ, σ₋ᵢ)
//   Tit-for-Tat is ESS when: δ ≥ (T-R)/(T-P) (cooperation threshold)
//   At T=5, R=3, P=1: δ ≥ (5-3)/(5-1) = 0.5 → cooperation when future matters
//
// ── LAYER 6: WAR OF ATTRITION ─────────────────────────────────────────────────
//   Two organisms contest a resource of value V
//   Each pays cost c per unit time
//   Optimal waiting time T* drawn from exp(c/V) distribution
//   Expected payoff: E[u] = V/2 - c/2 × E[T*] = 0  (at ESS)
//   ESS mixed strategy: F(t) = 1 - exp(-c/V × t) (exponential waiting)
//   Hawk-Dove game: special case with V (resource), C (injury cost)
//   P(Hawk) at ESS = V/C when V < C
//
// ── LAYER 7: COLONEL BLOTTO GAME ─────────────────────────────────────────────
//   Two commanders allocate forces across n battlefields
//   Commander 1 has A total forces, Commander 2 has B forces
//   Each allocates: xᵢ to battlefield i, Σxᵢ = A, Σyᵢ = B, xᵢ,yᵢ ≥ 0
//   Win battlefield i if xᵢ > yᵢ, tie if equal
//   Payoff = fraction of battlefields won
//   Optimal strategy (symmetric): uniform distribution over all allocations
//   that sum to A on n battlefields
//   For n=3: optimal = uniform over {(a,b,c): a+b+c=A, a,b,c≥0} simplex
//
// ── LAYER 8: LANCHESTER COMBAT EQUATIONS ──────────────────────────────────────
//   Linear law (ancient combat): dA/dt = -β, dB/dt = -α
//   Square law (modern ranged): dA/dt = -β B, dB/dt = -α A
//   Square law solution: A² - α/β × B² = A₀² - α/β × B₀²
//   Break-even: A₀ √(β/α) = B₀ (force ratio for equal outcome)
//   NOVA application: organism's army strength A vs threat B
//   Attrition rate α = organism effectiveness per unit force
//   β = threat effectiveness per unit force
//   Victory condition: A(t_final) > 0 while B(t_final) = 0
//
// ── LAYER 9: AUCTIONS AND MECHANISM DESIGN ────────────────────────────────────
//   Sealed-bid first-price auction: bid b_i, value v_i, win if max bid
//   Strategy: b*(v) = v × (n-1)/n  for n symmetric bidders (uniform values)
//   Revenue equivalence theorem: all standard auctions generate same expected revenue
//   Vickrey (second-price): b*(v) = v (truthful bidding is dominant strategy)
//   NOVA resource allocation: organisms bid for attention/energy using FORMA tokens
//   Optimal mechanism: direct revelation mechanism implementing Vickrey
//
// ── LAYER 10: MEDINA SOVEREIGN WAR INDEX ─────────────────────────────────────
//   W_M = S₀ × [Σᵢ wᵢ × strategyScore_i] × Φ_M / Ω
//   where:
//     strategyScore_i = payoff of organism's strategy against current threats
//     wᵢ = weight of engagement zone i (AEGIS layers)
//     Φ_M = 2.97442179, Ω = 9.0, S₀ = 1.0
//   W_M ∈ [0, Φ_M/Ω] = [0, 0.3305]
//   W_M > 0.20 → organism is winning the conflict
//   W_M < 0.10 → organism is losing, escalate defense
//   This is NOVA's sovereign conflict signature
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Iter  "mo:base/Iter";

module {

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 1: CONSTANTS
  // ══════════════════════════════════════════════════════════════════════════

  public let PHI_MEDINA     : Float = 2.97442179;
  public let S0             : Float = 1.0;
  public let SOVEREIGN_CEILING : Float = 9.0;
  public let COHERENCE_ALIVE   : Float = 0.36;
  public let EPSILON        : Float = 1.0e-10;

  // Prisoner's Dilemma payoffs (T > R > P > S)
  public let PAYOFF_T : Float = 5.0;  // Temptation (defect vs cooperate)
  public let PAYOFF_R : Float = 3.0;  // Reward (mutual cooperation)
  public let PAYOFF_P : Float = 1.0;  // Punishment (mutual defection)
  public let PAYOFF_S : Float = 0.0;  // Sucker (cooperate vs defect)

  // Discount factor for repeated games
  public let DISCOUNT_DELTA : Float = 0.8;  // δ = 0.8 → future matters strongly
  public let COOP_THRESHOLD : Float = 0.5;  // δ ≥ this → TfT is ESS

  // Replicator dynamics step size
  public let REPLICATOR_DT  : Float = 0.05;

  // Lanchester parameters
  public let ATTRITION_BASE : Float = 0.1;  // base attrition rate

  // Hawk-Dove
  public let RESOURCE_VALUE : Float = 3.0;  // V (resource value)
  public let INJURY_COST    : Float = 5.0;  // C (cost of injury)
  public let HAWK_ESS_PROB  : Float = 0.6;  // V/C at ESS

  // Colonel Blotto
  public let N_BATTLEFIELDS : Nat = 6;       // number of fronts

  // Medina war index thresholds
  public let WAR_INDEX_WIN  : Float = 0.20;
  public let WAR_INDEX_LOSE : Float = 0.10;

  // History
  public let WAR_HIST_MAX   : Nat = 100;

  // Number of strategies
  public let N_STRATEGIES   : Nat = 6;

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STRATEGY TYPES AND PAYOFF MATRIX
  // ══════════════════════════════════════════════════════════════════════════

  public type Strategy = {
    #Cooperate;
    #Defect;
    #TitForTat;
    #GrimTrigger;
    #Pavlov;
    #Sovereign;
  };

  func _stratIdx(s : Strategy) : Nat {
    switch s {
      case (#Cooperate)    0;
      case (#Defect)       1;
      case (#TitForTat)    2;
      case (#GrimTrigger)  3;
      case (#Pavlov)       4;
      case (#Sovereign)    5;
    }
  };

  // 6×6 payoff matrix (row=organism strategy, col=opponent strategy)
  // Row index = _stratIdx(organism), Col index = _stratIdx(opponent)
  // Payoff to organism
  let PAYOFF_MATRIX : [[Float]] = [
    // vs: Coop  Def   TfT   Grim  Pav   Sov
    [PAYOFF_R, PAYOFF_S, PAYOFF_R, PAYOFF_S, PAYOFF_R, PAYOFF_R * S0],  // Cooperate
    [PAYOFF_T, PAYOFF_P, PAYOFF_T, PAYOFF_P, PAYOFF_T, PAYOFF_T * S0],  // Defect
    [PAYOFF_R, PAYOFF_T, PAYOFF_R, PAYOFF_T, PAYOFF_R, PAYOFF_R * S0],  // TitForTat
    [PAYOFF_R, PAYOFF_T, PAYOFF_R, PAYOFF_T, PAYOFF_R, PAYOFF_R * S0],  // GrimTrigger
    [PAYOFF_R, PAYOFF_T, PAYOFF_R, PAYOFF_P, PAYOFF_R, PAYOFF_R * S0],  // Pavlov
    [PAYOFF_R, PAYOFF_T, PAYOFF_R, PAYOFF_T, PAYOFF_R, PAYOFF_R * PHI_MEDINA],  // Sovereign
  ];

  // Get payoff for organism playing s1 against opponent playing s2
  public func getPayoff(s1 : Strategy, s2 : Strategy) : Float {
    let r = _stratIdx(s1);
    let c = _stratIdx(s2);
    if (r < PAYOFF_MATRIX.size() and c < PAYOFF_MATRIX[r].size()) {
      PAYOFF_MATRIX[r][c]
    } else { 0.0 }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: COMBATANT TYPE
  // ══════════════════════════════════════════════════════════════════════════

  public type Combatant = {
    id           : Nat;
    strategy     : Strategy;
    aggression   : Float;    // [0,1] base aggression
    defense      : Float;    // [0,1] defensive posture
    resources    : Float;    // current resource pool
    fitness      : Float;    // evolutionary fitness
    lastOpponent : Strategy; // for TitForTat memory
    isBetrayed   : Bool;     // for GrimTrigger memory
    wins         : Nat;
    losses       : Nat;
    totalPayoff  : Float;
  };

  public type Engagement = {
    attacker     : Combatant;
    defender     : Combatant;
    attackerPayoff : Float;
    defenderPayoff : Float;
    winner       : ?Nat;     // None = tie
    rounds       : Nat;
    totalValue   : Float;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: PAYOFF COMPUTATION
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };

  // Iterated payoff with discount: U = Σₜ δᵗ uₜ / (1 - δ)
  // For repeated Prisoner's Dilemma, compute expected discounted payoff
  public func iteratedPayoff(s1 : Strategy, s2 : Strategy, rounds : Nat) : Float {
    if (rounds == 0) { return 0.0 };
    var total : Float = 0.0;
    var curS1 = s1;
    var curS2 = s2;
    var betray1 = false;
    var betray2 = false;
    var discount : Float = 1.0;
    var t : Nat = 0;
    while (t < rounds) {
      let p1 = getPayoff(curS1, curS2);
      let p2 = getPayoff(curS2, curS1);
      total += discount * p1;
      discount *= DISCOUNT_DELTA;
      // Update strategies for next round
      let next1 = updateStrategy(curS1, curS2, betray1);
      let next2 = updateStrategy(curS2, curS1, betray2);
      betray1 := curS2 == #Defect;
      betray2 := curS1 == #Defect;
      curS1 := next1;
      curS2 := next2;
      t += 1;
    };
    total
  };

  // Strategy response function (determines next strategy)
  public func updateStrategy(own : Strategy, opp : Strategy, betrayed : Bool) : Strategy {
    switch own {
      case (#TitForTat)   { opp };               // copy opponent's last move
      case (#GrimTrigger) { if (betrayed) #Defect else #Cooperate };
      case (#Pavlov) {
        // Win-stay, lose-switch
        let payoff = getPayoff(own, opp);
        if (payoff >= PAYOFF_R) own else (if (own == #Cooperate) #Defect else #Cooperate)
      };
      case (#Sovereign) { #Sovereign };           // Sovereign never defects
      case s { s };                               // Cooperate and Defect are fixed
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: REPLICATOR DYNAMICS
  // ẋᵢ = xᵢ × [(Ax)ᵢ - xᵀAx]
  // Population x on 6-simplex
  // ══════════════════════════════════════════════════════════════════════════

  // Compute fitness of each strategy given population mix x
  // fᵢ = (Ax)ᵢ = Σⱼ Aᵢⱼ xⱼ
  public func computeFitness(population : [Float]) : [Float] {
    let n = N_STRATEGIES;
    Array.tabulate<Float>(n, func(i) {
      var fi : Float = 0.0;
      var j : Nat = 0;
      while (j < n and j < population.size() and i < PAYOFF_MATRIX.size()) {
        if (j < PAYOFF_MATRIX[i].size()) {
          fi += PAYOFF_MATRIX[i][j] * population[j];
        };
        j += 1;
      };
      fi
    })
  };

  // Average fitness: phi = xᵀAx = Σᵢ xᵢ fᵢ
  public func avgFitness(population : [Float], fitness : [Float]) : Float {
    var phi : Float = 0.0;
    let n = if (population.size() < fitness.size()) population.size() else fitness.size();
    var i : Nat = 0;
    while (i < n) { phi += population[i] * fitness[i]; i += 1 };
    phi
  };

  // One replicator dynamics step
  // ẋᵢ = xᵢ × [(Ax)ᵢ - xᵀAx]
  public func replicatorStep(population : [Float]) : [Float] {
    let fitness = computeFitness(population);
    let phi = avgFitness(population, fitness);
    let newPop = Array.tabulate<Float>(N_STRATEGIES, func(i) {
      if (i < population.size() and i < fitness.size()) {
        let xi = population[i];
        let dx = xi * (fitness[i] - phi);
        _clamp(xi + REPLICATOR_DT * dx, 0.0001, 1.0)
      } else { 1.0 / Float.fromInt(N_STRATEGIES) }
    });
    // Normalize to simplex
    var total : Float = 0.0;
    for (v in newPop.vals()) { total += v };
    if (total < EPSILON) {
      Array.tabulate<Float>(N_STRATEGIES, func(_) { 1.0 / Float.fromInt(N_STRATEGIES) })
    } else {
      Array.map<Float, Float>(newPop, func(v) { v / total })
    }
  };

  // Find Nash equilibrium (approximate via many replicator steps)
  public func nashEquilibriumApprox(initPop : [Float], maxSteps : Nat) : [Float] {
    var pop = initPop;
    var t : Nat = 0;
    while (t < maxSteps) {
      pop := replicatorStep(pop);
      t += 1;
    };
    pop
  };

  // Is strategy σ evolutionarily stable?
  // Checks: u(σ,σ) > u(τ,σ) for all τ ≠ σ  (invader cannot grow)
  public func isESS(s : Strategy) : Bool {
    let myPayoffVsSelf = getPayoff(s, s);
    var i : Nat = 0;
    while (i < N_STRATEGIES) {
      let other : Strategy = switch i {
        case 0 #Cooperate; case 1 #Defect; case 2 #TitForTat;
        case 3 #GrimTrigger; case 4 #Pavlov; case _ #Sovereign;
      };
      if (other != s) {
        let invaderVsSelf = getPayoff(other, s);
        if (invaderVsSelf >= myPayoffVsSelf) { return false };
      };
      i += 1;
    };
    true
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: LANCHESTER COMBAT EQUATIONS
  // Square law: dA/dt = -β B, dB/dt = -α A
  // Solution: A² - (α/β)B² = A₀² - (α/β)B₀²  (Lanchester constant)
  // ══════════════════════════════════════════════════════════════════════════

  public type LanchesterState = {
    forceA     : Float;   // organism force strength
    forceB     : Float;   // adversary force strength
    alphaRate  : Float;   // organism attrition effectiveness
    betaRate   : Float;   // adversary attrition effectiveness
    lanchConst : Float;   // A² - (α/β)B² (conserved quantity)
    beatNum    : Nat;
  };

  // One Lanchester beat (Euler integration of square law)
  // dA/dt = -β B → ΔA = -β B Δt
  // dB/dt = -α A → ΔB = -α A Δt
  public func lanchesterBeat(state : LanchesterState, dt : Float) : LanchesterState {
    let dA = -state.betaRate * state.forceB * dt;
    let dB = -state.alphaRate * state.forceA * dt;
    let newA = _clamp(state.forceA + dA, 0.0, 1000.0);
    let newB = _clamp(state.forceB + dB, 0.0, 1000.0);
    let lc = newA * newA - (state.alphaRate / (state.betaRate + EPSILON)) * newB * newB;
    {
      forceA    = newA;
      forceB    = newB;
      alphaRate = state.alphaRate;
      betaRate  = state.betaRate;
      lanchConst = lc;
      beatNum   = state.beatNum + 1;
    }
  };

  // Lanchester victory time estimate (for square law)
  // t_victory ≈ (1/α) × ln(A₀/A_threshold)
  public func lanchesterVictoryTime(force : Float, rate : Float, threshold : Float) : Float {
    if (rate < EPSILON or force <= threshold) { return 0.0 };
    Float.log(force / threshold) / rate
  };

  // Lanchester break-even condition: A₀√(β) = B₀√(α)
  // Returns force multiplier needed to win: A₀ / B₀_min
  public func lanchesterBreakEven(alphaRate : Float, betaRate : Float) : Float {
    _sqrt((betaRate + EPSILON) / (alphaRate + EPSILON))
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: HAWK-DOVE DYNAMICS
  // Mixed strategy ESS: P(Hawk) = V/C
  // ══════════════════════════════════════════════════════════════════════════

  public type HawkDoveState = {
    pHawk      : Float;   // current probability of playing Hawk
    pDove      : Float;   // 1 - pHawk
    resource   : Float;   // V (value of contested resource)
    injuryCost : Float;   // C (cost of injury)
    essHawk    : Float;   // ESS hawk probability = V/C
    avgFitness : Float;   // average fitness in current population
  };

  // Hawk-Dove payoff matrix:
  // Hawk vs Hawk: (V-C)/2 each
  // Hawk vs Dove: Hawk gets V, Dove gets 0
  // Dove vs Dove: V/2 each
  public func hawkPayoff(pHawk : Float, v : Float, c : Float) : Float {
    let pDove = 1.0 - pHawk;
    (pHawk * (v - c) / 2.0 + pDove * v)
  };

  public func dovePayoff(pHawk : Float, v : Float) : Float {
    let pDove = 1.0 - pHawk;
    pHawk * 0.0 + pDove * v / 2.0
  };

  // Replicator for Hawk-Dove: ṗ_H = p_H(f_H - φ)
  public func hawkDoveStep(state : HawkDoveState, dt : Float) : HawkDoveState {
    let fH = hawkPayoff(state.pHawk, state.resource, state.injuryCost);
    let fD = dovePayoff(state.pHawk, state.resource);
    let phi = state.pHawk * fH + state.pDove * fD;
    let dpH = state.pHawk * (fH - phi) * dt;
    let newPH = _clamp(state.pHawk + dpH, 0.0, 1.0);
    {
      pHawk      = newPH;
      pDove      = 1.0 - newPH;
      resource   = state.resource;
      injuryCost = state.injuryCost;
      essHawk    = _clamp(state.resource / (state.injuryCost + EPSILON), 0.0, 1.0);
      avgFitness = phi;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: COLONEL BLOTTO GAME
  // Optimal strategy: uniform allocation with constraint Σxᵢ = A
  // ══════════════════════════════════════════════════════════════════════════

  // Blotto allocation: distribute forces across N_BATTLEFIELDS battlefields
  // Optimal: maximize number of battlefields won
  // Simple greedy: allocate proportional to battlefield value weights
  public func blottoAllocate(totalForce : Float, fieldWeights : [Float]) : [Float] {
    let n = fieldWeights.size();
    if (n == 0) { return [] };
    var weightSum : Float = 0.0;
    for (w in fieldWeights.vals()) { weightSum += w };
    if (weightSum < EPSILON) {
      let uniform = totalForce / Float.fromInt(n);
      return Array.tabulate<Float>(n, func(_) { uniform })
    };
    Array.map<Float, Float>(fieldWeights, func(w) { totalForce * w / weightSum })
  };

  // Blotto battle outcome: compare allocations, count battlefields won
  public func blottoBattle(forceA : [Float], forceB : [Float]) : (Nat, Nat, Nat) {
    // Returns (winsA, winsB, ties)
    var wA : Nat = 0;
    var wB : Nat = 0;
    var ties : Nat = 0;
    let n = if (forceA.size() < forceB.size()) forceA.size() else forceB.size();
    var i : Nat = 0;
    while (i < n) {
      if (forceA[i] > forceB[i]) { wA += 1 }
      else if (forceB[i] > forceA[i]) { wB += 1 }
      else { ties += 1 };
      i += 1;
    };
    (wA, wB, ties)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: WAR SIMULATION STATE
  // ══════════════════════════════════════════════════════════════════════════

  public type WarSimState = {
    // Population of strategies (6-simplex)
    population    : [Float];

    // Current organism combatant
    organism      : Combatant;

    // Lanchester state
    lanchester    : LanchesterState;

    // Hawk-Dove state
    hawkDove      : HawkDoveState;

    // Blotto: organism battlefield allocations
    blottoForce   : [Float];

    // Engagement history
    payoffHistory : [Float];   // rolling 100-beat payoff history
    winHistory    : [Bool];    // rolling 100-beat win record

    // Medina war index
    warIndex      : Float;     // W_M = sovereign war performance

    // Beat counter
    beatNum       : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: MEDINA WAR INDEX
  // W_M = S₀ × mean(strategyPayoffs) × Φ_M / Ω
  // ══════════════════════════════════════════════════════════════════════════

  public func medinaWarIndex(population : [Float]) : Float {
    let fitness = computeFitness(population);
    let phi = avgFitness(population, fitness);
    // Sovereign strategy payoff
    let sovPayoff = if (N_STRATEGIES - 1 < fitness.size()) fitness[N_STRATEGIES - 1] else phi;
    let w_m = S0 * sovPayoff * PHI_MEDINA / SOVEREIGN_CEILING;
    _clamp(w_m, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  func _appendBoolRolling(buf : [Bool], val : Bool, cap : Nat) : [Bool] {
    if (buf.size() < cap) { Array.append<Bool>(buf, [val]) }
    else {
      let tail = Array.tabulate<Bool>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Bool>(tail, [val])
    }
  };

  public func beatWarSim(
    state       : WarSimState,
    newStrategy : Strategy,
    oppStrategy : Strategy,
    lanchDt     : Float
  ) : WarSimState {
    // Get payoff for this engagement
    let payoff = getPayoff(newStrategy, oppStrategy);
    let won    = payoff > getPayoff(oppStrategy, newStrategy);

    // Update population via replicator
    let newPop = replicatorStep(state.population);

    // Update organism combatant
    let nextStrat = updateStrategy(newStrategy, oppStrategy, state.organism.isBetrayed);
    let newOrganism : Combatant = {
      id           = state.organism.id;
      strategy     = nextStrat;
      aggression   = state.organism.aggression;
      defense      = state.organism.defense;
      resources    = _clamp(state.organism.resources + payoff - 1.0, 0.0, 100.0);
      fitness      = 0.9 * state.organism.fitness + 0.1 * payoff;
      lastOpponent = oppStrategy;
      isBetrayed   = oppStrategy == #Defect;
      wins         = if won (state.organism.wins + 1) else state.organism.wins;
      losses       = if (not won) (state.organism.losses + 1) else state.organism.losses;
      totalPayoff  = state.organism.totalPayoff + payoff;
    };

    // Update Lanchester
    let newLanch = lanchesterBeat(state.lanchester, lanchDt);

    // Update Hawk-Dove
    let newHD = hawkDoveStep(state.hawkDove, lanchDt);

    // Rolling history
    let newPayH = _appendRolling(state.payoffHistory, payoff, WAR_HIST_MAX);
    let newWinH = _appendBoolRolling(state.winHistory, won, WAR_HIST_MAX);

    // Medina war index
    let newWI = medinaWarIndex(newPop);

    {
      population    = newPop;
      organism      = newOrganism;
      lanchester    = newLanch;
      hawkDove      = newHD;
      blottoForce   = state.blottoForce;
      payoffHistory = newPayH;
      winHistory    = newWinH;
      warIndex      = newWI;
      beatNum       = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 12: WAR HEALTH ASSESSMENT
  // ══════════════════════════════════════════════════════════════════════════

  // Win rate from history
  public func winRate(winHistory : [Bool]) : Float {
    let n = winHistory.size();
    if (n == 0) { return 0.0 };
    var wins : Float = 0.0;
    for (w in winHistory.vals()) { if w { wins += 1.0 } };
    wins / Float.fromInt(n)
  };

  // Average payoff from history
  public func avgPayoff(payoffHistory : [Float]) : Float {
    let n = payoffHistory.size();
    if (n == 0) { return 0.0 };
    var s : Float = 0.0;
    for (p in payoffHistory.vals()) { s += p };
    s / Float.fromInt(n)
  };

  // Is organism winning the war?
  public func isWinning(state : WarSimState) : Bool {
    state.warIndex > WAR_INDEX_WIN and winRate(state.winHistory) > 0.5
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 13: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  public func initWarSim() : WarSimState {
    let uniformPop = Array.tabulate<Float>(N_STRATEGIES, func(_) {
      1.0 / Float.fromInt(N_STRATEGIES)
    });

    let fieldWeights = Array.tabulate<Float>(N_BATTLEFIELDS, func(_) {
      1.0 / Float.fromInt(N_BATTLEFIELDS)
    });

    let initOrganism : Combatant = {
      id = 0; strategy = #Sovereign; aggression = 0.5; defense = 0.7;
      resources = 10.0; fitness = PAYOFF_R; lastOpponent = #Cooperate;
      isBetrayed = false; wins = 0; losses = 0; totalPayoff = 0.0;
    };

    let initLanch : LanchesterState = {
      forceA = 100.0; forceB = 80.0;
      alphaRate = ATTRITION_BASE; betaRate = ATTRITION_BASE;
      lanchConst = 100.0 * 100.0 - 80.0 * 80.0; beatNum = 0;
    };

    let initHD : HawkDoveState = {
      pHawk = 0.5; pDove = 0.5; resource = RESOURCE_VALUE;
      injuryCost = INJURY_COST; essHawk = HAWK_ESS_PROB; avgFitness = PAYOFF_R;
    };

    {
      population    = uniformPop;
      organism      = initOrganism;
      lanchester    = initLanch;
      hawkDove      = initHD;
      blottoForce   = fieldWeights;
      payoffHistory = [];
      winHistory    = [];
      warIndex      = medinaWarIndex(uniformPop);
      beatNum       = 0;
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


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  D E F E N S E   &   S E C U R I T Y   M A T H E M A T I C S
  //
  //  Enterprise-Level Security Algorithms and Threat Response
  //  Full HIM/HER Dual-Organism Protection Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // THREAT DETECTION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Anomaly score using Mahalanobis distance
  public func defenseAnomalyScore(
    observation : [Float],
    mean : [Float],
    invCovariance : [[Float]]
  ) : Float {
    let n = observation.size();
    if (n == 0 or mean.size() != n) { return 0.0 };
    
    var score : Float = 0.0;
    var i = 0;
    while (i < n) {
      var j = 0;
      while (j < n) {
        let diff_i = observation[i] - mean[i];
        let diff_j = observation[j] - mean[j];
        score += diff_i * invCovariance[i][j] * diff_j;
        j += 1;
      };
      i += 1;
    };
    Float.sqrt(Float.abs(score))
  };

  /// Exponential moving average for baseline
  public func defenseEMABaseline(
    current : Float,
    observation : Float,
    alpha : Float
  ) : Float {
    alpha * observation + (1.0 - alpha) * current
  };

  /// Z-score anomaly detection
  public func defenseZScoreAnomaly(
    value : Float,
    mean : Float,
    stdDev : Float
  ) : Float {
    if (stdDev < 0.0001) { 0.0 }
    else { Float.abs((value - mean) / stdDev) }
  };

  /// Threat probability from multiple indicators
  public func defenseThreatProbability(
    indicators : [Float],
    weights : [Float]
  ) : Float {
    let n = if (indicators.size() < weights.size()) indicators.size() else weights.size();
    if (n == 0) { return 0.0 };
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;
    var i = 0;
    while (i < n) {
      weightedSum += indicators[i] * weights[i];
      totalWeight += weights[i];
      i += 1;
    };
    if (totalWeight < 0.0001) { 0.0 }
    else { weightedSum / totalWeight }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESPONSE COORDINATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Priority queue score
  public func defenseResponsePriority(
    threatLevel : Float,
    urgency : Float,
    resources : Float
  ) : Float {
    threatLevel * urgency / (resources + 0.1)
  };

  /// Resource allocation optimization
  public func defenseResourceAllocation(
    available : Float,
    demands : [Float]
  ) : [Float] {
    var totalDemand : Float = 0.0;
    var i = 0;
    while (i < demands.size()) {
      totalDemand += demands[i];
      i += 1;
    };
    if (totalDemand < 0.0001) {
      return Array.tabulate<Float>(demands.size(), func(_ : Nat) : Float { 0.0 });
    };
    Array.tabulate<Float>(demands.size(), func(j : Nat) : Float {
      available * demands[j] / totalDemand
    })
  };

  /// Cascade failure probability
  public func defenseCascadeFailureProb(
    nodeFailProb : Float,
    connectivity : Float,
    loadFactor : Float
  ) : Float {
    let amplified = nodeFailProb * (1.0 + connectivity * loadFactor);
    if (amplified > 1.0) { 1.0 } else { amplified }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // CRYPTOGRAPHIC PRIMITIVES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Hash chain verification
  public func defenseHashChainVerify(
    expectedHash : Nat,
    computedHash : Nat,
    tolerance : Nat
  ) : Bool {
    let diff = if (expectedHash > computedHash) 
               expectedHash - computedHash 
               else computedHash - expectedHash;
    diff <= tolerance
  };

  /// Key derivation strength
  public func defenseKeyStrength(
    entropy : Float,
    iterations : Nat
  ) : Float {
    entropy * Float.log(Float.fromInt(iterations + 1))
  };

  /// Time-based token window
  public func defenseTokenWindow(
    currentTime : Nat,
    windowSize : Nat,
    secret : Nat
  ) : Nat {
    let window = currentTime / windowSize;
    (window * secret) % 1000000
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NETWORK SECURITY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rate limiting token bucket
  public func defenseTokenBucket(
    tokens : Float,
    maxTokens : Float,
    refillRate : Float,
    requested : Float,
    dt : Float
  ) : (Float, Bool) {
    let refilled = Float.min(tokens + refillRate * dt, maxTokens);
    if (refilled >= requested) {
      (refilled - requested, true)
    } else {
      (refilled, false)
    }
  };

  /// Connection trust score
  public func defenseTrustScore(
    successfulInteractions : Nat,
    failedInteractions : Nat,
    age : Nat
  ) : Float {
    let total = successfulInteractions + failedInteractions;
    if (total == 0) { return 0.5 };
    let successRate = Float.fromInt(successfulInteractions) / Float.fromInt(total);
    let ageFactor = Float.log(Float.fromInt(age + 1)) / 10.0;
    (successRate + ageFactor) / 2.0
  };

  /// DDoS detection metric
  public func defenseDDoSMetric(
    requestRate : Float,
    baseline : Float,
    variance : Float
  ) : Float {
    let deviation = (requestRate - baseline) / (Float.sqrt(variance) + 0.01);
    Float.abs(deviation)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SOVEREIGNTY PROTECTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Sovereignty assertion strength
  public func defenseSovereigntyStrength(
    autonomyLevel : Float,
    resourceControl : Float,
    decisionLatency : Float
  ) : Float {
    let efficiency = 1.0 / (decisionLatency + 0.01);
    autonomyLevel * resourceControl * efficiency
  };

  /// Integrity verification score
  public func defenseIntegrityScore(
    originalHash : Nat,
    currentHash : Nat,
    mutations : Nat
  ) : Float {
    let match = if (originalHash == currentHash) 1.0 else 0.0;
    let mutationPenalty = 1.0 / (Float.fromInt(mutations + 1));
    (match + mutationPenalty) / 2.0
  };

  /// Rollback safety margin
  public func defenseRollbackMargin(
    currentState : Float,
    checkpoint : Float,
    volatility : Float
  ) : Float {
    let diff = Float.abs(currentState - checkpoint);
    diff / (volatility + 0.01)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ADAPTIVE IMMUNE RESPONSE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Antibody-antigen affinity
  public func defenseAffinity(
    antibody : [Float],
    antigen : [Float]
  ) : Float {
    let n = if (antibody.size() < antigen.size()) antibody.size() else antigen.size();
    if (n == 0) { return 0.0 };
    var matchScore : Float = 0.0;
    var i = 0;
    while (i < n) {
      matchScore += 1.0 - Float.abs(antibody[i] - antigen[i]);
      i += 1;
    };
    matchScore / Float.fromInt(n)
  };

  /// Clonal selection probability
  public func defenseClonalSelection(
    affinity : Float,
    temperature : Float
  ) : Float {
    Float.exp(affinity / (temperature + 0.01))
  };

  /// Memory cell formation rate
  public func defenseMemoryCellRate(
    exposureCount : Nat,
    affinitySum : Float
  ) : Float {
    let exposureFactor = Float.log(Float.fromInt(exposureCount + 1));
    affinitySum * exposureFactor
  };

}
