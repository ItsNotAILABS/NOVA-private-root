// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — SOVEREIGN METALS ENGINE
// COMPREHENSIVE METALLURGICAL ECONOMICS AND SOVEREIGN ASSET MATHEMATICS
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — SOVEREIGN METALS AS ORGANISM BACKING
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: PRECIOUS METALS PRICE DYNAMICS ──────────────────────────────────
//   Gold (XAU), Silver (XAG), Platinum (XPT), Palladium (XPD), Rhodium (XRH)
//   Each metal has: spot price S(t), volatility σ, correlation matrix ρ
//
//   Geometric Brownian Motion (GBM) for each metal price:
//   dS = μ S dt + σ S dW
//   where μ = drift (real return), σ = volatility, dW = Wiener increment
//   Solution: S(t) = S₀ × exp((μ - σ²/2)t + σW(t))
//   Expected price: E[S(t)] = S₀ × exp(μt)
//   Variance: Var[S(t)] = S₀² × exp(2μt) × (exp(σ²t) - 1)
//
// ── LAYER 2: GOLD STANDARD BACKING ───────────────────────────────────────────
//   FORMA token backed by sovereign metals reserve R
//   Backing ratio: BR = Σᵢ mᵢ × Sᵢ / FORMA_supply
//   where mᵢ = mass of metal i in reserve, Sᵢ = spot price of metal i
//   Gold backing: BR_gold = m_gold × S_gold / FORMA_supply
//   Minimum backing: BR ≥ BR_MIN = 0.10 (10% backing floor)
//   Sovereign ceiling: BR ≤ BR_MAX = Ω = 9.0 (over-collateralization cap)
//   Rebalancing trigger: when |BR - BR_target| > threshold
//
// ── LAYER 3: METAL CORRELATION MATRIX ────────────────────────────────────────
//   5×5 correlation matrix ρ for [XAU, XAG, XPT, XPD, XRH]
//   ρ_XAU_XAG ≈ 0.85 (historically high gold-silver correlation)
//   ρ_XAU_XPT ≈ 0.72 (gold-platinum moderate)
//   ρ_XAU_XPD ≈ 0.65 (gold-palladium lower)
//   ρ_XAG_XPT ≈ 0.75
//   Cholesky decomposition L: ρ = L Lᵀ
//   Correlated price simulation: dS = μ dt + σ L dZ  (Z = independent Brownian)
//   Portfolio variance: σ²_portfolio = wᵀ Σ w = Σᵢⱼ wᵢ wⱼ σᵢ σⱼ ρᵢⱼ
//
// ── LAYER 4: MEAN-REVERSION (ORNSTEIN-UHLENBECK) ─────────────────────────────
//   Many commodity prices exhibit mean reversion:
//   dS = κ(μ_LT - S) dt + σ dW
//   κ = speed of reversion, μ_LT = long-term mean, σ = volatility
//   Solution: S(t) = μ_LT + (S₀ - μ_LT)exp(-κt) + σ∫₀ᵗ exp(-κ(t-s)) dW(s)
//   E[S(t)] = μ_LT + (S₀ - μ_LT)exp(-κt)
//   Var[S(t)] = σ²/(2κ) × (1 - exp(-2κt))
//   Steady-state variance: σ²_∞ = σ²/(2κ)
//   Half-life of reversion: t₁/₂ = ln(2)/κ
//
// ── LAYER 5: PORTFOLIO OPTIMIZATION (MARKOWITZ) ───────────────────────────────
//   Minimize variance: min wᵀ Σ w
//   Subject to: wᵀ μ = r_target (return constraint)
//              wᵀ 1 = 1 (budget constraint)
//              wᵢ ≥ 0 (no short selling)
//   Efficient frontier: parametric curve in (σ, μ) space
//   Minimum variance portfolio: w_MV = Σ⁻¹ 1 / (1ᵀ Σ⁻¹ 1)
//   Tangent portfolio: w_T = Σ⁻¹(μ - rf·1) / (1ᵀ Σ⁻¹(μ - rf·1))
//   Sharpe ratio: SR = (r - rf) / σ  (risk-adjusted return)
//
// ── LAYER 6: VALUE AT RISK (VaR) AND CVAR ────────────────────────────────────
//   VaR_α = -F⁻¹(α) where F = portfolio return distribution CDF
//   For normal distribution: VaR_α = -μ_P + z_α × σ_P
//   z_0.95 = 1.645, z_0.99 = 2.326
//   CVaR (Expected Shortfall): ES_α = -E[R | R ≤ VaR_α]
//   For normal: ES_α = μ_P + σ_P × φ(z_α) / α
//   φ = standard normal PDF
//   Metals reserve VaR: probability of reserve value dropping below minimum
//
// ── LAYER 7: OPTIONS PRICING (BLACK-SCHOLES FOR METAL OPTIONS) ────────────────
//   European call: C = S N(d₁) - K exp(-rT) N(d₂)
//   European put:  P = K exp(-rT) N(-d₂) - S N(-d₁)
//   d₁ = [ln(S/K) + (r + σ²/2)T] / (σ√T)
//   d₂ = d₁ - σ√T
//   N(x) = standard normal CDF
//   Greeks:
//   Δ = ∂C/∂S = N(d₁)  (delta)
//   Γ = ∂²C/∂S² = φ(d₁)/(S σ√T)  (gamma)
//   Θ = ∂C/∂T = -Sφ(d₁)σ/(2√T) - rK exp(-rT)N(d₂)  (theta)
//   Vega = ∂C/∂σ = S φ(d₁) √T
//   Rho = ∂C/∂r = KT exp(-rT) N(d₂)
//   Organism uses options to hedge metals reserve against price drops
//
// ── LAYER 8: SOVEREIGN METALS BACKING FORMULA ────────────────────────────────
//   Total reserve value: V_R = Σᵢ mᵢ × Sᵢ(t)
//   NOVA sovereignty index from metals: M_sov = S₀ × V_R × Φ_M / (Ω × FORMA_supply)
//   M_sov ∈ [0, 1]: 1 = fully sovereign-backed, 0 = unbacked
//   Target: M_sov ≥ COHERENCE_ALIVE = 0.36 (minimum sovereign backing)
//   If M_sov < 0.36: auto-rebalance triggered (sell FORMA, buy metals)
//   If M_sov > 0.90: excess → distribute to organism FORMA reserve
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
  public let PI             : Float = 3.141592653589793;
  public let SQRT_2PI       : Float = 2.5066282746310002;

  // Spot prices (USD, approximate 2026 levels)
  public let GOLD_SPOT_USD     : Float = 2800.0;  // XAU $/troy oz
  public let SILVER_SPOT_USD   : Float = 32.0;    // XAG $/troy oz
  public let PLATINUM_SPOT_USD : Float = 1050.0;  // XPT $/troy oz
  public let PALLADIUM_SPOT_USD: Float = 1200.0;  // XPD $/troy oz
  public let RHODIUM_SPOT_USD  : Float = 5000.0;  // XRH $/troy oz

  // Volatilities (annualized)
  public let GOLD_VOL     : Float = 0.15;  // σ_XAU = 15% annual
  public let SILVER_VOL   : Float = 0.30;  // σ_XAG = 30%
  public let PLATINUM_VOL : Float = 0.25;  // σ_XPT = 25%
  public let PALLADIUM_VOL: Float = 0.40;  // σ_XPD = 40%
  public let RHODIUM_VOL  : Float = 0.60;  // σ_XRH = 60%

  // Mean reversion parameters
  public let GOLD_KAPPA       : Float = 0.20;   // mean reversion speed
  public let GOLD_LT_MEAN     : Float = 2500.0; // long-term mean USD
  public let SILVER_KAPPA     : Float = 0.25;
  public let SILVER_LT_MEAN   : Float = 28.0;

  // Backing ratio parameters
  public let BR_MIN           : Float = 0.10;   // 10% minimum backing
  public let BR_TARGET        : Float = 0.40;   // 40% target backing
  public let BR_MAX           : Float = 1.00;   // 100% maximum (over-collateralized)
  public let BR_REBALANCE_TOL : Float = 0.05;   // rebalance when |BR - target| > 5%

  // Black-Scholes risk-free rate
  public let RISK_FREE_RATE   : Float = 0.05;   // 5% annual

  // VaR confidence levels
  public let VAR_95           : Float = 1.6449; // z-score for 95% VaR
  public let VAR_99           : Float = 2.3263; // z-score for 99% VaR

  // Correlation matrix [XAU, XAG, XPT, XPD, XRH] — flattened 5×5
  // rho_{i,j} = correlation between metals i and j
  public let METAL_CORRELATIONS : [Float] = [
    1.00, 0.85, 0.72, 0.65, 0.50,   // XAU row
    0.85, 1.00, 0.75, 0.60, 0.45,   // XAG row
    0.72, 0.75, 1.00, 0.70, 0.55,   // XPT row
    0.65, 0.60, 0.70, 1.00, 0.60,   // XPD row
    0.50, 0.45, 0.55, 0.60, 1.00,   // XRH row
  ];

  public let N_METALS   : Nat = 5;
  public let HIST_MAX   : Nat = 200;

  public let METAL_NAMES : [Text] = ["XAU","XAG","XPT","XPD","XRH"];
  public let METAL_VOLS  : [Float] = [GOLD_VOL, SILVER_VOL, PLATINUM_VOL, PALLADIUM_VOL, RHODIUM_VOL];

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type MetalPrice = {
    spot      : Float;   // current spot price USD/troy oz
    drift     : Float;   // μ — annual expected return
    vol       : Float;   // σ — annual volatility
    ltMean    : Float;   // μ_LT — long-term mean (for OU reversion)
    kappa     : Float;   // κ — mean reversion speed
    delta     : Float;   // Δ (day-over-day change)
    history   : [Float]; // rolling price history
  };

  public type MetalsReserve = {
    quantities    : [Float];  // ounces of each metal [XAU, XAG, XPT, XPD, XRH]
    spotPrices    : [Float];  // current spot prices [USD]
    totalValueUSD : Float;    // Σ qᵢ × Sᵢ
    allocWeights  : [Float];  // portfolio weights wᵢ = qᵢSᵢ / V_total
    backingRatio  : Float;    // V_total / FORMA_supply
    sovereignIndex: Float;    // M_sov = S₀ × V_R × Φ_M / (Ω × FORMA_supply)
  };

  public type PortfolioStats = {
    expectedReturn: Float;    // E[r] = Σᵢ wᵢ μᵢ
    variance      : Float;    // σ² = wᵀ Σ w
    stdDev        : Float;    // σ_P = √(wᵀ Σ w)
    sharpeRatio   : Float;    // SR = (E[r] - rf) / σ_P
    var95         : Float;    // VaR at 95% confidence
    var99         : Float;    // VaR at 99% confidence
    cvar95        : Float;    // CVaR at 95%
  };

  public type OptionsPosition = {
    metal         : Nat;      // index into metals array
    optionType    : Bool;     // true = call, false = put
    strikePrice   : Float;    // K (USD)
    timeToExpiry  : Float;    // T (years)
    impliedVol    : Float;    // σ implied from market
    bsPrice       : Float;    // Black-Scholes price
    delta_greek   : Float;
    gamma_greek   : Float;
    vega_greek    : Float;
    theta_greek   : Float;
  };

  public type SovereignMetalsState = {
    reserve       : MetalsReserve;
    metalPrices   : [MetalPrice];
    portfolio     : PortfolioStats;
    options       : [OptionsPosition];
    formaSupply   : Float;          // current FORMA circulating supply
    formaPrice    : Float;          // FORMA spot price USD
    rebalanceFlag : Bool;           // trigger rebalancing?
    beatNum       : Nat;
    history       : SovereignMetalsHistory;
  };

  public type SovereignMetalsHistory = {
    backingRatioHistory : [Float];
    sovereignIndexHistory : [Float];
    totalValueHistory : [Float];
    goldPriceHistory  : [Float];
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

  func _ln(x : Float) : Float {
    if (x <= 0.0) -100.0 else Float.log(x)
  };

  func _exp(x : Float) : Float { Float.exp(_clamp(x, -100.0, 100.0)) };

  // Standard normal CDF (Abramowitz & Stegun approximation)
  // N(x) ≈ 1 - φ(x)(b₁t + b₂t² + b₃t³ + b₄t⁴ + b₅t⁵) where t = 1/(1+0.2316419x)
  func _normalCDF(x : Float) : Float {
    if (x < -6.0) { return 0.0 };
    if (x >  6.0) { return 1.0 };
    let t = 1.0 / (1.0 + 0.2316419 * _abs(x));
    let phi = _exp(-x * x / 2.0) / SQRT_2PI;
    let poly = t * (0.319381530 + t * (-0.356563782 + t * (1.781477937 + t * (-1.821255978 + t * 1.330274429))));
    let cdf = 1.0 - phi * poly;
    if (x >= 0.0) cdf else (1.0 - cdf)
  };

  // Standard normal PDF
  func _normalPDF(x : Float) : Float {
    _exp(-x * x / 2.0) / SQRT_2PI
  };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: GEOMETRIC BROWNIAN MOTION PRICE UPDATE
  // dS = μ S dt + σ S dW
  // Discretized: S(t+dt) = S(t) × exp((μ - σ²/2)dt + σ √dt × Z)
  // Z ~ N(0,1) — provided as external pseudo-random input
  // ══════════════════════════════════════════════════════════════════════════

  public func gbmStep(
    spot : Float,
    drift : Float,
    vol : Float,
    dt : Float,
    normalRandom : Float  // Z ~ N(0,1) from caller
  ) : Float {
    let logReturn = (drift - vol * vol / 2.0) * dt + vol * _sqrt(dt) * normalRandom;
    _clamp(spot * _exp(logReturn), 0.01, 1000000.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: ORNSTEIN-UHLENBECK MEAN REVERSION
  // dS = κ(μ_LT - S) dt + σ dW
  // Discretized: S(t+dt) = S(t) + κ(μ_LT - S(t))dt + σ√dt × Z
  // ══════════════════════════════════════════════════════════════════════════

  public func ouStep(
    spot : Float,
    kappa : Float,
    ltMean : Float,
    vol : Float,
    dt : Float,
    normalRandom : Float
  ) : Float {
    let reversion = kappa * (ltMean - spot) * dt;
    let diffusion = vol * _sqrt(dt) * normalRandom;
    _clamp(spot + reversion + diffusion, 0.01, 1000000.0)
  };

  // Half-life of mean reversion: t₁/₂ = ln(2)/κ
  public func reversionHalfLife(kappa : Float) : Float {
    if (kappa < EPSILON) { return 9999.0 };
    0.6931471805599453 / kappa
  };

  // OU steady-state variance: σ²_∞ = σ²/(2κ)
  public func ouSteadyStateVar(vol : Float, kappa : Float) : Float {
    if (kappa < EPSILON) { return 9999.0 };
    (vol * vol) / (2.0 * kappa)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: PORTFOLIO MATHEMATICS
  // ══════════════════════════════════════════════════════════════════════════

  // Portfolio expected return: E[r_P] = Σᵢ wᵢ μᵢ
  public func portfolioExpectedReturn(weights : [Float], drifts : [Float]) : Float {
    var er : Float = 0.0;
    let n = if (weights.size() < drifts.size()) weights.size() else drifts.size();
    var i : Nat = 0;
    while (i < n) { er += weights[i] * drifts[i]; i += 1 };
    er
  };

  // Portfolio variance: σ²_P = wᵀ Σ w = Σᵢⱼ wᵢ wⱼ σᵢ σⱼ ρᵢⱼ
  // Σ = covariance matrix = diag(σ) × ρ × diag(σ)
  public func portfolioVariance(weights : [Float], vols : [Float], corrMatrix : [Float]) : Float {
    let n = weights.size();
    var variance : Float = 0.0;
    var i : Nat = 0;
    while (i < n) {
      var j : Nat = 0;
      while (j < n) {
        let corr = if (i * n + j < corrMatrix.size()) corrMatrix[i * n + j] else 0.0;
        let cov  = (if (i < vols.size()) vols[i] else 0.0) *
                   (if (j < vols.size()) vols[j] else 0.0) * corr;
        variance += weights[i] * weights[j] * cov;
        j += 1;
      };
      i += 1;
    };
    _clamp(variance, 0.0, 10.0)
  };

  // Sharpe ratio: SR = (E[r_P] - rf) / σ_P
  public func sharpeRatio(er : Float, stdDev : Float) : Float {
    if (stdDev < EPSILON) { return 0.0 };
    (er - RISK_FREE_RATE) / stdDev
  };

  // VaR at confidence α: VaR = -(μ_P - z_α × σ_P)
  public func valueAtRisk(er : Float, stdDev : Float, zScore : Float) : Float {
    _clamp(-(er - zScore * stdDev), 0.0, 1.0)
  };

  // CVaR (Expected Shortfall): ES = μ_P + σ_P × φ(z_α) / α
  public func conditionalVaR(er : Float, stdDev : Float, alpha : Float) : Float {
    if (alpha < EPSILON) { return 0.0 };
    let z = VAR_95;  // use 95% default
    er + stdDev * _normalPDF(z) / alpha
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: BLACK-SCHOLES OPTIONS PRICING
  // C = S N(d₁) - K e^{-rT} N(d₂)
  // d₁ = [ln(S/K) + (r + σ²/2)T] / (σ√T)
  // d₂ = d₁ - σ√T
  // ══════════════════════════════════════════════════════════════════════════

  public func blackScholesD1(spot : Float, strike : Float, r : Float, vol : Float, T : Float) : Float {
    if (vol < EPSILON or T < EPSILON) { return 0.0 };
    (_ln(spot / strike) + (r + vol * vol / 2.0) * T) / (vol * _sqrt(T))
  };

  public func blackScholesD2(d1 : Float, vol : Float, T : Float) : Float {
    d1 - vol * _sqrt(T)
  };

  public func blackScholesCall(spot : Float, strike : Float, r : Float, vol : Float, T : Float) : Float {
    if (T < EPSILON) { return _clamp(spot - strike, 0.0, 1e10) };
    let d1 = blackScholesD1(spot, strike, r, vol, T);
    let d2 = blackScholesD2(d1, vol, T);
    spot * _normalCDF(d1) - strike * _exp(-r * T) * _normalCDF(d2)
  };

  public func blackScholesPut(spot : Float, strike : Float, r : Float, vol : Float, T : Float) : Float {
    if (T < EPSILON) { return _clamp(strike - spot, 0.0, 1e10) };
    let d1 = blackScholesD1(spot, strike, r, vol, T);
    let d2 = blackScholesD2(d1, vol, T);
    strike * _exp(-r * T) * _normalCDF(-d2) - spot * _normalCDF(-d1)
  };

  // Greeks
  public func bsDelta(d1 : Float, isCall : Bool) : Float {
    if isCall { _normalCDF(d1) } else { _normalCDF(d1) - 1.0 }
  };

  public func bsGamma(spot : Float, d1 : Float, vol : Float, T : Float) : Float {
    if (spot < EPSILON or vol < EPSILON or T < EPSILON) { return 0.0 };
    _normalPDF(d1) / (spot * vol * _sqrt(T))
  };

  public func bsVega(spot : Float, d1 : Float, T : Float) : Float {
    spot * _normalPDF(d1) * _sqrt(T)
  };

  public func bsTheta(spot : Float, strike : Float, r : Float, vol : Float, T : Float, d1 : Float, d2 : Float, isCall : Bool) : Float {
    if (T < EPSILON) { return 0.0 };
    let term1 = -spot * _normalPDF(d1) * vol / (2.0 * _sqrt(T));
    if isCall {
      term1 - r * strike * _exp(-r * T) * _normalCDF(d2)
    } else {
      term1 + r * strike * _exp(-r * T) * _normalCDF(-d2)
    }
  };

  // Compute full options position
  public func computeOption(
    metalIdx  : Nat,
    spot      : Float,
    strike    : Float,
    vol       : Float,
    T         : Float,
    isCall    : Bool
  ) : OptionsPosition {
    let d1 = blackScholesD1(spot, strike, RISK_FREE_RATE, vol, T);
    let d2 = blackScholesD2(d1, vol, T);
    let price = if isCall {
      blackScholesCall(spot, strike, RISK_FREE_RATE, vol, T)
    } else {
      blackScholesPut(spot, strike, RISK_FREE_RATE, vol, T)
    };
    {
      metal        = metalIdx;
      optionType   = isCall;
      strikePrice  = strike;
      timeToExpiry = T;
      impliedVol   = vol;
      bsPrice      = price;
      delta_greek  = bsDelta(d1, isCall);
      gamma_greek  = bsGamma(spot, d1, vol, T);
      vega_greek   = bsVega(spot, d1, T);
      theta_greek  = bsTheta(spot, strike, RISK_FREE_RATE, vol, T, d1, d2, isCall);
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: RESERVE MATHEMATICS
  // ══════════════════════════════════════════════════════════════════════════

  // Compute total reserve value and portfolio weights
  public func computeReserve(quantities : [Float], spotPrices : [Float], formaSupply : Float) : MetalsReserve {
    let n = if (quantities.size() < spotPrices.size()) quantities.size() else spotPrices.size();
    var total : Float = 0.0;
    var i : Nat = 0;
    while (i < n) { total += quantities[i] * spotPrices[i]; i += 1 };

    let weights = if (total < EPSILON) {
      Array.tabulate<Float>(n, func(_) { 1.0 / Float.fromInt(n) })
    } else {
      Array.tabulate<Float>(n, func(idx) {
        if (idx < quantities.size() and idx < spotPrices.size()) {
          quantities[idx] * spotPrices[idx] / total
        } else 0.0
      })
    };

    let br = if (formaSupply < EPSILON) 0.0 else total / formaSupply;
    let mSov = S0 * total * PHI_MEDINA / (SOVEREIGN_CEILING * (formaSupply + EPSILON));

    {
      quantities    = quantities;
      spotPrices    = spotPrices;
      totalValueUSD = total;
      allocWeights  = weights;
      backingRatio  = _clamp(br, 0.0, 100.0);
      sovereignIndex = _clamp(mSov, 0.0, 1.0);
    }
  };

  // Compute portfolio statistics
  public func computePortfolioStats(weights : [Float], drifts : [Float]) : PortfolioStats {
    let er    = portfolioExpectedReturn(weights, drifts);
    let var_p = portfolioVariance(weights, METAL_VOLS, METAL_CORRELATIONS);
    let std_p = _sqrt(var_p);
    let sr    = sharpeRatio(er, std_p);
    let v95   = valueAtRisk(er, std_p, VAR_95);
    let v99   = valueAtRisk(er, std_p, VAR_99);
    let cvar  = conditionalVaR(er, std_p, 0.05);
    { expectedReturn=er; variance=var_p; stdDev=std_p; sharpeRatio=sr;
      var95=v95; var99=v99; cvar95=cvar }
  };

  // Should we rebalance? |BR - BR_target| > tolerance
  public func shouldRebalance(reserve : MetalsReserve) : Bool {
    _abs(reserve.backingRatio - BR_TARGET) > BR_REBALANCE_TOL
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  public func beatSovereignMetals(
    state        : SovereignMetalsState,
    normalRands  : [Float],   // 5 N(0,1) random numbers for price simulation
    dt           : Float,
    newFormaSupply : Float
  ) : SovereignMetalsState {
    let n = N_METALS;

    // Update spot prices via GBM + OU mean reversion blend
    let newSpots = Array.tabulate<Float>(n, func(i) {
      if (i < state.metalPrices.size()) {
        let mp = state.metalPrices[i];
        let z  = if (i < normalRands.size()) normalRands[i] else 0.0;
        let gbm = gbmStep(mp.spot, mp.drift, mp.vol, dt, z);
        let ou  = ouStep(mp.spot, mp.kappa, mp.ltMean, mp.vol, dt, z);
        (gbm + ou) / 2.0  // blend GBM and OU
      } else 0.0
    });

    // Update metal price records
    let newMetalPrices = Array.tabulate<MetalPrice>(n, func(i) {
      if (i < state.metalPrices.size()) {
        let mp = state.metalPrices[i];
        let ns = newSpots[i];
        {
          spot    = ns;
          drift   = mp.drift;
          vol     = mp.vol;
          ltMean  = mp.ltMean;
          kappa   = mp.kappa;
          delta   = ns - mp.spot;
          history = _appendRolling(mp.history, ns, HIST_MAX);
        }
      } else {
        { spot=0.0; drift=0.0; vol=0.0; ltMean=0.0; kappa=0.0; delta=0.0; history=[] }
      }
    });

    // Update reserve
    let newReserve = computeReserve(state.reserve.quantities, newSpots, newFormaSupply);

    // Update portfolio stats
    let metalDrifts = Array.tabulate<Float>(n, func(i) {
      if (i < state.metalPrices.size()) state.metalPrices[i].drift else 0.0
    });
    let newPortfolio = computePortfolioStats(newReserve.allocWeights, metalDrifts);

    // Update history
    let newHist : SovereignMetalsHistory = {
      backingRatioHistory   = _appendRolling(state.history.backingRatioHistory, newReserve.backingRatio, HIST_MAX);
      sovereignIndexHistory = _appendRolling(state.history.sovereignIndexHistory, newReserve.sovereignIndex, HIST_MAX);
      totalValueHistory     = _appendRolling(state.history.totalValueHistory, newReserve.totalValueUSD, HIST_MAX);
      goldPriceHistory      = _appendRolling(state.history.goldPriceHistory, newSpots[0], HIST_MAX);
    };

    {
      reserve        = newReserve;
      metalPrices    = newMetalPrices;
      portfolio      = newPortfolio;
      options        = state.options;
      formaSupply    = newFormaSupply;
      formaPrice     = state.formaPrice;
      rebalanceFlag  = shouldRebalance(newReserve);
      beatNum        = state.beatNum + 1;
      history        = newHist;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: SOVEREIGN METALS HEALTH
  // ══════════════════════════════════════════════════════════════════════════

  public func isSovereignlySolvent(state : SovereignMetalsState) : Bool {
    state.reserve.backingRatio >= BR_MIN and
    state.reserve.sovereignIndex >= COHERENCE_ALIVE
  };

  public func metalsHealthScore(state : SovereignMetalsState) : Float {
    let brScore = _clamp(state.reserve.backingRatio / BR_TARGET, 0.0, 1.0);
    let sovScore = state.reserve.sovereignIndex;
    let srScore  = _clamp(state.portfolio.sharpeRatio / 2.0, 0.0, 1.0);
    _clamp(0.4 * brScore + 0.4 * sovScore + 0.2 * srScore, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  public func initSovereignMetals(formaSupply : Float) : SovereignMetalsState {
    let initQuantities : [Float] = [100.0, 5000.0, 50.0, 30.0, 5.0]; // oz per metal
    let initSpots : [Float] = [GOLD_SPOT_USD, SILVER_SPOT_USD, PLATINUM_SPOT_USD, PALLADIUM_SPOT_USD, RHODIUM_SPOT_USD];
    let initDrifts : [Float] = [0.08, 0.05, 0.06, 0.07, 0.10];  // annual drifts
    let initKappas : [Float] = [GOLD_KAPPA, SILVER_KAPPA, 0.20, 0.25, 0.30];
    let initLTMeans : [Float] = [GOLD_LT_MEAN, SILVER_LT_MEAN, 950.0, 1100.0, 4500.0];

    let initMetalPrices = Array.tabulate<MetalPrice>(N_METALS, func(i) {
      {
        spot    = initSpots[i];
        drift   = if (i < initDrifts.size()) initDrifts[i] else 0.05;
        vol     = if (i < METAL_VOLS.size()) METAL_VOLS[i] else 0.20;
        ltMean  = if (i < initLTMeans.size()) initLTMeans[i] else initSpots[i];
        kappa   = if (i < initKappas.size()) initKappas[i] else 0.20;
        delta   = 0.0;
        history = [];
      }
    });

    let reserve = computeReserve(initQuantities, initSpots, formaSupply);
    let portfolio = computePortfolioStats(reserve.allocWeights, initDrifts);

    {
      reserve       = reserve;
      metalPrices   = initMetalPrices;
      portfolio     = portfolio;
      options       = [];
      formaSupply   = formaSupply;
      formaPrice    = 1.0;
      rebalanceFlag = false;
      beatNum       = 0;
      history       = {
        backingRatioHistory   = [];
        sovereignIndexHistory = [];
        totalValueHistory     = [];
        goldPriceHistory      = [];
      };
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
