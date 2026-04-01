// ============================================================
// NEUROEMERGENCE CORE — WAR SIM ENGINE
// Game-theoretic war simulation dynamics
// Nash equilibrium seeking, Prisoner's Dilemma extensions
// Evolutionary stable strategies (ESS) for shell competition
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";

module {

  // ── Types ─────────────────────────────────────────────────────
  public type Strategy = {
    #Cooperate;
    #Defect;
    #TitForTat;
    #GrimTrigger;
    #Pavlov;     // win-stay, lose-switch
    #Random;
  };

  public type Combatant = {
    id           : Nat;
    strategy     : Strategy;
    aggression   : Float;    // 0-1 base aggression
    defense      : Float;    // 0-1 defensive posture
    resources    : Float;    // current resource pool
    reputation   : Float;    // -1 to 1 (cooperation history)
    warHistory   : [Bool];   // last 10 outcomes (true = won)
    escEscalation: Float;    // 0-1 escalation tendency
  };

  public type WarState = {
    combatants      : [Combatant];
    payoffMatrix    : [[Float]];   // 2x2: CC, CD, DC, DD
    nashEquilibrium : (Strategy, Strategy);
    globalTension   : Float;       // 0-1 system-wide conflict level
    warActive       : Bool;
    roundNum        : Nat;
    totalConflicts  : Nat;
    cooperationRate : Float;       // system-wide cooperation %
    beatNum         : Nat;
  };

  // ── Constants ─────────────────────────────────────────────────
  // Payoff matrix for Prisoner's Dilemma variant
  // [cooperator_payoff, defector_payoff] for each outcome
  public let PD_PAYOFFS : [[Float]] = [
    [3.0, 3.0],   // Both cooperate: R,R
    [0.0, 5.0],   // C vs D: S,T
    [5.0, 0.0],   // D vs C: T,S
    [1.0, 1.0]    // Both defect: P,P
  ];

  // Hawk-Dove payoffs (V=4 value, C=6 cost)
  public let HD_PAYOFFS : [[Float]] = [
    [2.0, 2.0],   // Both Dove: V/2, V/2
    [0.0, 4.0],   // Dove vs Hawk: 0, V
    [4.0, 0.0],   // Hawk vs Dove: V, 0
    [-1.0, -1.0]  // Both Hawk: (V-C)/2, (V-C)/2
  ];

  // ── Clamp helper ──────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ── Strategy decision ─────────────────────────────────────────
  func decideAction(c: Combatant, opponentLastMove: Bool, rng: Nat32) : Bool {
    switch (c.strategy) {
      case (#Cooperate) { true };
      case (#Defect) { false };
      case (#TitForTat) { opponentLastMove };
      case (#GrimTrigger) {
        // Defect forever if opponent ever defected
        var everDefected = false;
        for (h in c.warHistory.vals()) {
          if (not h) { everDefected := true };
        };
        not everDefected
      };
      case (#Pavlov) {
        // Win-stay, lose-switch
        if (c.warHistory.size() == 0) { true }
        else { c.warHistory[c.warHistory.size() - 1] }
      };
      case (#Random) {
        (rng % 2) == 0
      };
    }
  };

  // ── Resolve single conflict ───────────────────────────────────
  func resolveConflict(
    c1: Combatant, c2: Combatant,
    move1: Bool, move2: Bool,
    payoffs: [[Float]]
  ) : (Float, Float) {
    let idx = if (move1 and move2) { 0 }      // CC
              else if (move1 and not move2) { 1 }  // CD
              else if (not move1 and move2) { 2 }  // DC
              else { 3 };                          // DD
    (payoffs[idx][0], payoffs[idx][1])
  };

  // ── Update combatant after conflict ───────────────────────────
  func updateCombatant(c: Combatant, payoff: Float, won: Bool) : Combatant {
    let newResources = _clamp(c.resources + payoff * 0.1, 0.0, 10.0);

    // Update reputation based on cooperation
    let repDelta = if (payoff >= 3.0) { 0.1 } else if (payoff <= 1.0) { -0.1 } else { 0.0 };
    let newRep = _clamp(c.reputation + repDelta, -1.0, 1.0);

    // Update war history (circular buffer of 10)
    let newHistory = if (c.warHistory.size() >= 10) {
      let tail = Array.tabulate<Bool>(9, func(i) { c.warHistory[i + 1] });
      Array.append<Bool>(tail, [won])
    } else {
      Array.append<Bool>(c.warHistory, [won])
    };

    // Escalation increases if losing, decreases if winning
    let escDelta = if (won) { -0.05 } else { 0.05 };
    let newEsc = _clamp(c.escEscalation + escDelta, 0.0, 1.0);

    {
      id            = c.id;
      strategy      = c.strategy;
      aggression    = c.aggression;
      defense       = c.defense;
      resources     = newResources;
      reputation    = newRep;
      warHistory    = newHistory;
      escEscalation = newEsc;
    }
  };

  // ── Full war round ────────────────────────────────────────────
  public func warRound(state: WarState, rng: Nat32) : WarState {
    if (state.combatants.size() < 2) { return state };

    // Pair up combatants
    var newCombatants = state.combatants;
    var totalCoop : Float = 0.0;
    var conflicts = 0;

    // Round-robin conflicts
    for (i in Array.keys(state.combatants)) {
      for (j in Array.keys(state.combatants)) {
        if (i < j) {
          let c1 = newCombatants[i];
          let c2 = newCombatants[j];

          // Check if conflict threshold met
          let tensionCheck = (c1.aggression + c2.aggression) / 2.0;
          if (tensionCheck > state.globalTension * 0.5) {
            conflicts += 1;

            // Decide moves
            let lastC1 = if (c1.warHistory.size() > 0) { c1.warHistory[c1.warHistory.size() - 1] } else { true };
            let lastC2 = if (c2.warHistory.size() > 0) { c2.warHistory[c2.warHistory.size() - 1] } else { true };

            let move1 = decideAction(c1, lastC2, rng +% Nat32.fromNat(i));
            let move2 = decideAction(c2, lastC1, rng +% Nat32.fromNat(j));

            if (move1) { totalCoop += 1.0 };
            if (move2) { totalCoop += 1.0 };

            let (pay1, pay2) = resolveConflict(c1, c2, move1, move2, state.payoffMatrix);

            // Determine winner
            let won1 = pay1 >= pay2;
            let won2 = pay2 >= pay1;

            let updatedC1 = updateCombatant(c1, pay1, won1);
            let updatedC2 = updateCombatant(c2, pay2, won2);

            // Update array
            newCombatants := Array.mapEntries<Combatant, Combatant>(
              newCombatants,
              func(idx, c) {
                if (idx == i) { updatedC1 }
                else if (idx == j) { updatedC2 }
                else { c }
              }
            );
          };
        };
      };
    };

    let coopRate = if (conflicts > 0) {
      totalCoop / (Float.fromInt(conflicts) * 2.0)
    } else { state.cooperationRate };

    // Update global tension
    let newTension = _clamp(
      state.globalTension + (1.0 - coopRate) * 0.1 - coopRate * 0.05,
      0.0, 1.0
    );

    {
      combatants      = newCombatants;
      payoffMatrix    = state.payoffMatrix;
      nashEquilibrium = state.nashEquilibrium;
      globalTension   = newTension;
      warActive       = newTension > 0.3;
      roundNum        = state.roundNum + 1;
      totalConflicts  = state.totalConflicts + conflicts;
      cooperationRate = coopRate;
      beatNum         = state.beatNum + 1;
    }
  };

  // ── Evolutionary pressure ─────────────────────────────────────
  // Low-resource combatants adopt strategies of high-resource ones
  public func evolutionaryPressure(state: WarState) : WarState {
    // Find best and worst performers
    var bestIdx = 0;
    var bestRes : Float = 0.0;
    for (i in Array.keys(state.combatants)) {
      if (state.combatants[i].resources > bestRes) {
        bestRes := state.combatants[i].resources;
        bestIdx := i;
      };
    };

    let bestStrategy = state.combatants[bestIdx].strategy;

    // Low performers adopt winner's strategy (10% chance)
    let threshold = bestRes * 0.3;
    let newCombatants = Array.map<Combatant, Combatant>(
      state.combatants,
      func(c) {
        if (c.resources < threshold) {
          { id = c.id; strategy = bestStrategy; aggression = c.aggression;
            defense = c.defense; resources = c.resources; reputation = c.reputation;
            warHistory = c.warHistory; escEscalation = c.escEscalation }
        } else { c }
      }
    );

    {
      combatants      = newCombatants;
      payoffMatrix    = state.payoffMatrix;
      nashEquilibrium = state.nashEquilibrium;
      globalTension   = state.globalTension;
      warActive       = state.warActive;
      roundNum        = state.roundNum;
      totalConflicts  = state.totalConflicts;
      cooperationRate = state.cooperationRate;
      beatNum         = state.beatNum;
    }
  };

  // ── Nash equilibrium finder (for 2-player 2-strategy) ─────────
  public func findNashEquilibrium(payoffs: [[Float]]) : (Strategy, Strategy) {
    // For standard PD: (Defect, Defect) is Nash
    // For HD: mixed equilibrium exists
    let cc = payoffs[0][0];
    let cd = payoffs[1][0];
    let dc = payoffs[2][0];
    let dd = payoffs[3][0];

    // Check pure strategy Nash equilibria
    if (dd >= cd and dd >= dc) {
      return (#Defect, #Defect);
    };
    if (cc >= dc and cc >= cd) {
      return (#Cooperate, #Cooperate);
    };
    // Default to Tit-for-Tat as robust strategy
    (#TitForTat, #TitForTat)
  };

  // ── War health score ──────────────────────────────────────────
  public func warHealthScore(state: WarState) : Float {
    // High cooperation + low tension = healthy
    let coopFactor = state.cooperationRate;
    let tensionFactor = 1.0 - state.globalTension;
    (coopFactor * 0.6 + tensionFactor * 0.4)
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initWarState(numCombatants: Nat) : WarState {
    let combatants = Array.tabulate<Combatant>(numCombatants, func(i) {
      let strat : Strategy = switch (i % 6) {
        case 0 { #Cooperate };
        case 1 { #Defect };
        case 2 { #TitForTat };
        case 3 { #GrimTrigger };
        case 4 { #Pavlov };
        case _ { #Random };
      };
      {
        id            = i;
        strategy      = strat;
        aggression    = Float.fromInt(i % 10) / 10.0;
        defense       = 0.5;
        resources     = 5.0;
        reputation    = 0.0;
        warHistory    = [];
        escEscalation = 0.2;
      }
    });

    let nash = findNashEquilibrium(PD_PAYOFFS);

    {
      combatants      = combatants;
      payoffMatrix    = PD_PAYOFFS;
      nashEquilibrium = nash;
      globalTension   = 0.2;
      warActive       = false;
      roundNum        = 0;
      totalConflicts  = 0;
      cooperationRate = 0.5;
      beatNum         = 0;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type WarSummary = {
    numCombatants   : Nat;
    globalTension   : Float;
    cooperationRate : Float;
    warActive       : Bool;
    totalConflicts  : Nat;
    healthScore     : Float;
  };

  public func summary(state: WarState) : WarSummary {
    {
      numCombatants   = state.combatants.size();
      globalTension   = state.globalTension;
      cooperationRate = state.cooperationRate;
      warActive       = state.warActive;
      totalConflicts  = state.totalConflicts;
      healthScore     = warHealthScore(state);
    }
  };

}
