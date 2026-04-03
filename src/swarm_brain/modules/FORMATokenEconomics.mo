// FORMA Token Economics Module for NOVA Sovereign Organism
// Mathematical Foundation: Automated Market Makers, Bonding Curves, and Token Velocity

/*
MATHEMATICAL THEORY HEADER:

1. AUTOMATED MARKET MAKER (AMM) - Constant Product Formula
   - Core equation: x * y = k (invariant constant)
   - For token swap: x₁ * y₁ = (x₁ + Δx) * (y₁ - Δy)
   - Price: P = dy/dx = y/x
   - Price Impact: ΔP/P = Δx/(x + Δx)
   - Slippage: S = (P_before - P_after) / P_before
   - Execution price: P_exec = Δy / Δx = y / (x + Δx)

2. BONDING CURVE - Power Law Model
   - Price function: P(x) = a * x^b (where b ∈ (0,1] for increasing price)
   - Total cost to mint x tokens: C(x) = ∫₀ˣ a*t^b dt = (a/(b+1)) * x^(b+1)
   - Marginal cost: dC/dx = a * x^b
   - Average cost: C̄(x) = C(x)/x = (a/(b+1)) * x^b
   - Token supply elasticity: ε = (dS/dP) * (P/S)

3. LIQUIDITY POOL (Uniswap V2 Model)
   - LP token supply: S_LP = √(x * y) (geometric mean)
   - Impermanent Loss: IL = 2*√(P₂/P₁) / (1 + P₂/P₁) - 1
   - At 2x price change: IL ≈ -5.7%
   - At 4x price change: IL ≈ -20%
   - LP shares: share = LP_minted / LP_total
   - Claim ratio: (x_share, y_share) = share * (x_pool, y_pool)

4. COMPOUND INTEREST & Exponential Growth
   - Discrete: A = P(1 + r/n)^(nt)
   - Continuous: A = P*e^(rt)
   - Effective annual rate: r_eff = (1 + r/n)^n - 1
   - APY = (1 + r/n)^n - 1
   - Real return: r_real = (1 + r_nominal) / (1 + π) - 1

5. VELOCITY OF MONEY (Fisher Equation)
   - MV = PQ (Money supply × Velocity = Price level × Real output)
   - Velocity: V = PQ/M = nominal_GDP / money_supply
   - Token velocity: V_FORMA = 12 * transaction_volume / average_holdings
   - Correlation: higher velocity → lower token value (ceteris paribus)

6. MEDINA FORMA INDEX
   - Formulation: F_sov = S₀ × [(V_token × PHI_MEDINA + backing_ratio) / Ω_dissipation]
   - S₀ = initial token supply (100M)
   - V_token = token velocity (target: 2.4/year)
   - PHI_MEDINA = 0.618 (golden ratio weight)
   - backing_ratio = treasury_value / market_cap
   - Ω_dissipation = friction coefficient (0.95 optimal)
   - Range: [0, 1] where 1 = perfect sovereign backing
*/

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Debug "mo:base/Debug";

module {
  // ============== TYPE DEFINITIONS ==============
  
  public type TokenState = {
    supply : Nat;
    burned : Nat;
    market_cap_usd : Float;
    price_usd : Float;
    holders : Nat;
    transaction_volume_24h : Float;
  };

  public type AMMPool = {
    token_a_reserve : Nat;
    token_b_reserve : Nat;
    total_lp_tokens : Nat;
    fee_rate : Float;
    invariant_k : Nat;
  };

  public type BondingCurveParams = {
    coefficient_a : Float;
    exponent_b : Float;
    current_supply : Nat;
    current_price : Float;
  };

  public type LiquidityProvider = {
    lp_id : Text;
    lp_token_balance : Nat;
    token_a_contributed : Nat;
    token_b_contributed : Nat;
    entry_price : Float;
    current_value : Float;
  };

  public type MEDINAFORMAIndex = {
    timestamp : Nat;
    index_value : Float;
    token_velocity : Float;
    backing_ratio : Float;
    phi_medina : Float;
    dissipation_omega : Float;
    sovereignty_score : Float;
  };

  public type BeatUpdate = {
    new_price : Float;
    new_volume : Float;
    lp_fee_collected : Float;
    velocity_change : Float;
    medina_index_change : Float;
  };

  // ============== STATE & CONSTANTS ==============
  
  let PHI_MEDINA = 0.618034;
  let GOLDEN_RATIO = 1.618034;
  let OMEGA_DISSIPATION = 0.95;
  let TARGET_VELOCITY = 2.4;
  let INITIAL_SUPPLY = 100_000_000.0;
  let PI = 3.141592653589793;

  // ============== AMM FUNCTIONS ==============
  
  public func calculate_amm_output(
    input_amount : Nat,
    input_reserve : Nat,
    output_reserve : Nat,
    fee_rate : Float
  ) : (Nat, Float) {
    let input_with_fee = Float.fromInt(Int.abs(Nat.toInt(input_amount))) * (1.0 - fee_rate);
    let numerator = input_with_fee * Float.fromInt(Int.abs(Nat.toInt(output_reserve)));
    let denominator = Float.fromInt(Int.abs(Nat.toInt(input_reserve))) + input_with_fee;
    let output_amount = numerator / denominator;
    let price_impact = 1.0 - (Float.fromInt(Int.abs(Nat.toInt(output_reserve))) / 
      (Float.fromInt(Int.abs(Nat.toInt(output_reserve))) - output_amount));
    
    (Nat.fromInt(Int.abs(Float.toInt(output_amount))), price_impact);
  };

  public func calculate_price_from_reserves(
    token_a : Nat,
    token_b : Nat
  ) : Float {
    if (token_a == 0) { return 0.0 };
    Float.fromInt(Int.abs(Nat.toInt(token_b))) / Float.fromInt(Int.abs(Nat.toInt(token_a)));
  };

  public func calculate_slippage(
    output_amount : Nat,
    fair_price : Float,
    input_amount : Nat
  ) : Float {
    let execution_price = Float.fromInt(Int.abs(Nat.toInt(output_amount))) / 
                         Float.fromInt(Int.abs(Nat.toInt(input_amount)));
    (fair_price - execution_price) / fair_price;
  };

  public func calculate_invariant(token_a : Nat, token_b : Nat) : Nat {
    let a_float = Float.fromInt(Int.abs(Nat.toInt(token_a)));
    let b_float = Float.fromInt(Int.abs(Nat.toInt(token_b)));
    Nat.fromInt(Int.abs(Float.toInt(a_float * b_float)));
  };

  // ============== BONDING CURVE FUNCTIONS ==============
  
  public func bonding_curve_price(
    coefficient : Float,
    exponent : Float,
    supply : Nat
  ) : Float {
    let s = Float.fromInt(Int.abs(Nat.toInt(supply)));
    coefficient * (s ** exponent);
  };

  public func bonding_curve_total_cost(
    coefficient : Float,
    exponent : Float,
    supply : Nat
  ) : Float {
    let s = Float.fromInt(Int.abs(Nat.toInt(supply)));
    let integral = coefficient / (exponent + 1.0) * (s ** (exponent + 1.0));
    integral;
  };

  public func bonding_curve_marginal_cost(
    coefficient : Float,
    exponent : Float,
    supply : Nat
  ) : Float {
    let s = Float.fromInt(Int.abs(Nat.toInt(supply)));
    coefficient * (s ** exponent);
  };

  public func bonding_curve_average_cost(
    coefficient : Float,
    exponent : Float,
    supply : Nat
  ) : Float {
    let s = Float.fromInt(Int.abs(Nat.toInt(supply)));
    if (s == 0.0) { return 0.0 };
    (coefficient / (exponent + 1.0)) * (s ** exponent);
  };

  // ============== LIQUIDITY PROVIDER FUNCTIONS ==============
  
  public func calculate_lp_tokens_minted(
    token_a_amount : Nat,
    token_b_amount : Nat,
    existing_k : Nat
  ) : Nat {
    let a_float = Float.fromInt(Int.abs(Nat.toInt(token_a_amount)));
    let b_float = Float.fromInt(Int.abs(Nat.toInt(token_b_amount)));
    let sqrt_product = Float.sqrt(a_float * b_float);
    Nat.fromInt(Int.abs(Float.toInt(sqrt_product)));
  };

  public func calculate_impermanent_loss(
    price_ratio : Float
  ) : Float {
    if (price_ratio <= 0.0) { return 0.0 };
    let sqrt_ratio = Float.sqrt(price_ratio);
    (2.0 * sqrt_ratio) / (1.0 + price_ratio) - 1.0;
  };

  public func calculate_lp_share_value(
    lp_tokens : Nat,
    total_lp_supply : Nat,
    pool_token_a : Nat,
    pool_token_b : Nat,
    price_b : Float
  ) : Float {
    if (total_lp_supply == 0) { return 0.0 };
    let share = Float.fromInt(Int.abs(Nat.toInt(lp_tokens))) / 
               Float.fromInt(Int.abs(Nat.toInt(total_lp_supply)));
    let value_a = share * Float.fromInt(Int.abs(Nat.toInt(pool_token_a)));
    let value_b = share * Float.fromInt(Int.abs(Nat.toInt(pool_token_b))) * price_b;
    value_a + value_b;
  };

  public func calculate_pool_slippage_impact(
    swap_amount : Nat,
    reserve : Nat
  ) : Float {
    let swap_float = Float.fromInt(Int.abs(Nat.toInt(swap_amount)));
    let reserve_float = Float.fromInt(Int.abs(Nat.toInt(reserve)));
    if (reserve_float == 0.0) { return 1.0 };
    swap_float / (reserve_float + swap_float);
  };

  // ============== COMPOUND INTEREST FUNCTIONS ==============
  
  public func compound_interest_discrete(
    principal : Float,
    annual_rate : Float,
    compounds_per_year : Nat,
    years : Float
  ) : Float {
    let n = Float.fromInt(Int.abs(Nat.toInt(compounds_per_year)));
    let exponent = (annual_rate / n) * years;
    principal * ((1.0 + annual_rate / n) ** exponent);
  };

  public func compound_interest_continuous(
    principal : Float,
    annual_rate : Float,
    years : Float
  ) : Float {
    principal * Float.exp(annual_rate * years);
  };

  public func effective_annual_rate(
    nominal_rate : Float,
    compounds_per_year : Nat
  ) : Float {
    let n = Float.fromInt(Int.abs(Nat.toInt(compounds_per_year)));
    ((1.0 + nominal_rate / n) ** n) - 1.0;
  };

  public func doubling_time(annual_rate : Float) : Float {
    if (annual_rate <= 0.0) { return Float.infinity };
    72.0 / (annual_rate * 100.0);
  };

  public func real_return(nominal_rate : Float, inflation_rate : Float) : Float {
    ((1.0 + nominal_rate) / (1.0 + inflation_rate)) - 1.0;
  };

  // ============== TOKEN VELOCITY FUNCTIONS ==============
  
  public func calculate_token_velocity(
    annual_transaction_volume : Float,
    average_holdings : Float
  ) : Float {
    if (average_holdings <= 0.0) { return 0.0 };
    annual_transaction_volume / average_holdings;
  };

  public func velocity_from_fisher_equation(
    price_level : Float,
    real_output : Float,
    money_supply : Float
  ) : Float {
    if (money_supply <= 0.0) { return 0.0 };
    (price_level * real_output) / money_supply;
  };

  public func velocity_impact_on_value(
    circulating_supply : Float,
    velocity : Float,
    target_velocity : Float
  ) : Float {
    let velocity_ratio = velocity / target_velocity;
    1.0 / velocity_ratio;
  };

  public func estimate_market_cap_from_velocity(
    transaction_volume : Float,
    velocity : Float
  ) : Float {
    if (velocity <= 0.0) { return 0.0 };
    transaction_volume / velocity;
  };

  // ============== MEDINA FORMA INDEX ==============
  
  public func calculate_medina_forma_index(
    supply : Float,
    token_velocity : Float,
    backing_ratio : Float,
    dissipation : Float
  ) : Float {
    let numerator = (token_velocity * PHI_MEDINA) + backing_ratio;
    let index = supply * (numerator / dissipation);
    if (index > INITIAL_SUPPLY) { 1.0 } else { index / INITIAL_SUPPLY };
  };

  public func medina_sovereignty_score(
    forma_index : Float,
    holder_count : Nat,
    transaction_count : Nat
  ) : Float {
    let holder_factor = 1.0 - Float.exp(-Float.fromInt(Int.abs(Nat.toInt(holder_count))) / 10000.0);
    let tx_factor = 1.0 - Float.exp(-Float.fromInt(Int.abs(Nat.toInt(transaction_count))) / 100000.0);
    forma_index * holder_factor * tx_factor;
  };

  public func calculate_backing_ratio(
    treasury_value : Float,
    market_cap : Float
  ) : Float {
    if (market_cap <= 0.0) { return 0.0 };
    Float.min(1.0, treasury_value / market_cap);
  };

  // ============== BEAT UPDATE FUNCTIONS ==============
  
  public func beat_update_token_economics(
    current_state : TokenState,
    amm_pool : AMMPool,
    bonding_params : BondingCurveParams,
    backing_value : Float
  ) : BeatUpdate {
    let new_price = calculate_price_from_reserves(amm_pool.token_a_reserve, amm_pool.token_b_reserve);
    let new_volume = current_state.transaction_volume_24h * 1.02;
    let lp_fee = Float.fromInt(Int.abs(Nat.toInt(amm_pool.token_a_reserve))) * 0.003;
    let new_velocity = calculate_token_velocity(new_volume * 365.0, 
                                               Float.fromInt(Int.abs(Nat.toInt(current_state.supply))));
    let velocity_change = new_velocity - TARGET_VELOCITY;
    
    let backing_ratio = calculate_backing_ratio(backing_value, current_state.market_cap_usd);
    let new_index = calculate_medina_forma_index(
      Float.fromInt(Int.abs(Nat.toInt(current_state.supply))),
      new_velocity,
      backing_ratio,
      OMEGA_DISSIPATION
    );
    
    {
      new_price = new_price;
      new_volume = new_volume;
      lp_fee_collected = lp_fee;
      velocity_change = velocity_change;
      medina_index_change = new_index;
    };
  };

  // ============== INITIALIZATION ==============
  
  public func init_token_state() : TokenState {
    {
      supply = 100_000_000;
      burned = 0;
      market_cap_usd = 100_000_000.0;
      price_usd = 1.0;
      holders = 1000;
      transaction_volume_24h = 5_000_000.0;
    };
  };

  public func init_amm_pool() : AMMPool {
    {
      token_a_reserve = 50_000_000;
      token_b_reserve = 50_000_000;
      total_lp_tokens = 50_000_000;
      fee_rate = 0.003;
      invariant_k = 2_500_000_000_000_000;
    };
  };

  public func init_bonding_curve() : BondingCurveParams {
    {
      coefficient_a = 0.001;
      exponent_b = 0.5;
      current_supply = 50_000_000;
      current_price = 1.0;
    };
  };

  public func init_medina_index() : MEDINAFORMAIndex {
    {
      timestamp = 0;
      index_value = 0.618034;
      token_velocity = 2.4;
      backing_ratio = 0.5;
      phi_medina = PHI_MEDINA;
      dissipation_omega = OMEGA_DISSIPATION;
      sovereignty_score = 0.618034;
    };
  };

  // ============== UTILITY FUNCTIONS ==============
  
  public func format_price(price : Float) : Text {
    "USD " # Float.toText(Float.floor(price * 10000.0) / 10000.0);
  };

  public func format_percentage(value : Float) : Text {
    Float.toText(Float.floor(value * 10000.0) / 100.0) # "%";
  };

  public func validate_amm_invariant(pool : AMMPool) : Bool {
    let current_k = calculate_invariant(pool.token_a_reserve, pool.token_b_reserve);
    current_k >= pool.invariant_k;
  };

  public func validate_token_state(state : TokenState) : Bool {
    state.supply > 0 and state.price_usd > 0.0 and state.holders > 0;
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
  //  E C O N O M I C   &   G O V E R N A N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Economic and Governance Algorithms
  //  Full HIM/HER Dual-Organism Economic Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // TOKEN ECONOMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Token value from supply/demand
  public func economicTokenValue(
    demand : Float,
    supply : Float,
    baseValue : Float
  ) : Float {
    if (supply < 0.0001) { baseValue * 10.0 }
    else { baseValue * (demand / supply) }
  };

  /// Staking reward calculation
  public func economicStakingReward(
    stakedAmount : Float,
    stakingDuration : Nat,
    rewardRate : Float,
    bonusMultiplier : Float
  ) : Float {
    let durationBonus = Float.log(Float.fromInt(stakingDuration + 1));
    stakedAmount * rewardRate * (1.0 + durationBonus * bonusMultiplier)
  };

  /// Liquidity pool share
  public func economicLPShare(
    userLiquidity : Float,
    totalLiquidity : Float
  ) : Float {
    if (totalLiquidity < 0.0001) { 0.0 }
    else { userLiquidity / totalLiquidity }
  };

  /// Automated market maker price impact
  public func economicAMMPriceImpact(
    tradeSize : Float,
    poolSize : Float,
    k : Float
  ) : Float {
    let newPool = poolSize + tradeSize;
    let counterPool = k / newPool;
    Float.abs(counterPool - k / poolSize) / (k / poolSize)
  };

  /// Inflation rate calculation
  public func economicInflationRate(
    newSupply : Float,
    currentSupply : Float
  ) : Float {
    if (currentSupply < 0.0001) { 0.0 }
    else { (newSupply - currentSupply) / currentSupply }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GOVERNANCE MECHANICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quadratic voting power
  public func governanceQuadraticVotes(tokens : Float) : Float {
    Float.sqrt(tokens)
  };

  /// Conviction voting weight
  public func governanceConvictionWeight(
    tokens : Float,
    time : Float,
    halfLife : Float
  ) : Float {
    tokens * (1.0 - Float.exp(-time / halfLife))
  };

  /// Quorum calculation
  public func governanceQuorumReached(
    votesFor : Float,
    votesAgainst : Float,
    totalSupply : Float,
    quorumThreshold : Float
  ) : Bool {
    let totalVotes = votesFor + votesAgainst;
    totalVotes / totalSupply >= quorumThreshold
  };

  /// Proposal passing check
  public func governanceProposalPasses(
    votesFor : Float,
    votesAgainst : Float,
    passThreshold : Float
  ) : Bool {
    let total = votesFor + votesAgainst;
    if (total < 0.0001) { false }
    else { votesFor / total >= passThreshold }
  };

  /// Delegation weight calculation
  public func governanceDelegationWeight(
    directPower : Float,
    delegatedPower : Float,
    delegatorCount : Nat
  ) : Float {
    let delegationBonus = Float.log(Float.fromInt(delegatorCount + 1)) * 0.1;
    directPower + delegatedPower * (1.0 + delegationBonus)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BEHAVIORAL ECONOMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Prospect theory value function
  public func economicProspectValue(
    outcome : Float,
    reference : Float,
    lossAversion : Float
  ) : Float {
    let x = outcome - reference;
    if (x >= 0.0) {
      Float.pow(x, 0.88)
    } else {
      -lossAversion * Float.pow(-x, 0.88)
    }
  };

  /// Probability weighting
  public func economicProbabilityWeight(p : Float, delta : Float) : Float {
    let pDelta = Float.pow(p, delta);
    pDelta / Float.pow(pDelta + Float.pow(1.0 - p, delta), 1.0 / delta)
  };

  /// Hyperbolic discounting
  public func economicHyperbolicDiscount(
    value : Float,
    delay : Float,
    k : Float
  ) : Float {
    value / (1.0 + k * delay)
  };

  /// Social preference utility
  public func economicSocialUtility(
    ownPayoff : Float,
    otherPayoff : Float,
    altruism : Float,
    envy : Float
  ) : Float {
    let comparison = otherPayoff - ownPayoff;
    if (comparison > 0.0) {
      ownPayoff - envy * comparison
    } else {
      ownPayoff + altruism * (-comparison)
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // INSURANCE & RISK
  // ─────────────────────────────────────────────────────────────────────────────

  /// Expected loss calculation
  public func economicExpectedLoss(
    probability : Float,
    severity : Float
  ) : Float {
    probability * severity
  };

  /// Premium calculation
  public func economicPremium(
    expectedLoss : Float,
    loadingFactor : Float,
    expenses : Float
  ) : Float {
    expectedLoss * (1.0 + loadingFactor) + expenses
  };

  /// Risk pooling benefit
  public func economicRiskPoolingBenefit(
    individualVariance : Float,
    poolSize : Nat,
    correlation : Float
  ) : Float {
    let n = Float.fromInt(poolSize);
    let pooledVariance = individualVariance * (1.0 + (n - 1.0) * correlation) / n;
    individualVariance - pooledVariance
  };

  /// Value at Risk (simplified)
  public func economicVaR(
    mean : Float,
    stdDev : Float,
    confidenceMultiplier : Float
  ) : Float {
    mean - confidenceMultiplier * stdDev
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // RESOURCE ALLOCATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Cobb-Douglas production
  public func economicCobbDouglas(
    labor : Float,
    capital : Float,
    alpha : Float,
    productivity : Float
  ) : Float {
    productivity * Float.pow(labor, alpha) * Float.pow(capital, 1.0 - alpha)
  };

  /// Marginal utility
  public func economicMarginalUtility(
    quantity : Float,
    diminishingFactor : Float
  ) : Float {
    1.0 / Float.pow(quantity + 1.0, diminishingFactor)
  };

  /// Nash bargaining solution
  public func economicNashBargaining(
    u1 : Float,
    u2 : Float,
    d1 : Float,
    d2 : Float
  ) : Float {
    (u1 - d1) * (u2 - d2)
  };

  /// Shapley value contribution
  public func economicShapleyContribution(
    marginalContributions : [Float]
  ) : Float {
    if (marginalContributions.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < marginalContributions.size()) {
      sum += marginalContributions[i];
      i += 1;
    };
    sum / Float.fromInt(marginalContributions.size())
  };

}
