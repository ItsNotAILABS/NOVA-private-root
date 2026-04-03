// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — OCTOPUS BRAIN ENGINE
// COMPREHENSIVE DISTRIBUTED INTELLIGENCE AND CHROMATOPHORE DYNAMICS
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — OCTOPUS: DECENTRALIZED EMBODIED COGNITION
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: DISTRIBUTED NERVOUS SYSTEM ──────────────────────────────────────
//   Octopus neural architecture: 500 million neurons total
//   Central brain: 50 million neurons (only 10% of total!)
//   Arm ganglia: 450 million neurons (9 × 50M per arm)
//   Each arm is a semi-autonomous controller: local reflexes without central brain
//   Arm autonomy principle: arm can execute complex reaching, even when severed
//   Neural distribution: C_central = 0.10, C_arm = 0.90
//   Communication: ganglia ↔ central brain via ganglionic chain
//   Signal delay: Δt_signal = arm_length / v_axon ≈ 0.5m / 10m·s⁻¹ = 50 ms
//   Hierarchical control:
//   Level 0: central brain (goal and intent)
//   Level 1: arm ganglia (motor programs)
//   Level 2: sucker muscles (tactile and proprioceptive)
//   Arms independently explore while central brain makes global decisions
//
// ── LAYER 2: ARM DYNAMICS — MUSCULAR HYDROSTAT ────────────────────────────────
//   Arm = muscular hydrostat: constant volume, infinite degrees of freedom
//   Volume constraint: πr²L = constant → if L increases, r decreases
//   Three muscle groups:
//   Longitudinal (LM): shorten/lengthen arm, dL/dt = -α × LM_activity
//   Transverse (TM): thin/thicken arm, dr/dt = β × TM_activity
//   Oblique (OM): create torsion, dθ/dt = γ × OM_activity
//   Arm curvature: κ(s) = 1/R(s) = LM_differential / arm_width
//   Arm shape: Frenet-Serret: dT/ds = κN, dN/ds = -κT + τB, dB/ds = -τN
//   where T = tangent, N = normal, B = binormal, κ = curvature, τ = torsion
//   Octopus arm reaching: minimize ∫₀ˢ κ²(s) ds (minimum curvature path)
//   This is equivalent to natural cubic spline interpolation
//
// ── LAYER 3: CHROMATOPHORE DYNAMICS ──────────────────────────────────────────
//   Chromatophores: pigment cells controlled by radial muscles
//   Expansion: d_max × tanh(muscle_activity / σ_cm)  where d_max = 1.5mm
//   Iridophores: reflective cells using thin-film interference
//   Papillae: texture control (rough = 100μm bumps, smooth = flat)
//   Color equation: C(λ) = Σᵢ Aᵢ(r) × G(λ - λᵢ, σᵢ)
//   where Aᵢ = pigment density of type i, G = Gaussian spectral response
//   Typical pigments: red (λ_r=610nm), yellow (λ_y=580nm), brown (λ_b=560nm)
//   Camouflage objective: minimize ||C_skin - C_background||² across pixels
//   Pixelation: octopus skin has ~1M chromatophore units
//   Neural control: 1 motor neuron per chromatophore (direct control)
//   Temporal control: full expansion in ~300ms, retraction in ~500ms
//
// ── LAYER 4: LEARNING AND MEMORY ─────────────────────────────────────────────
//   Octopus has the most sophisticated invertebrate brain
//   Long-term memory: up to weeks for visual discrimination tasks
//   Vertical lobe: analog of mammalian hippocampus
//   Learning rule (modified Hebb): Δw_ij = η × r_i × r_j × reward
//   Where r_i = presynaptic rate, r_j = postsynaptic rate
//   Reward signal R: dopamine-like modulation in central brain
//   Association learning: pair CS (conditioned stimulus) with US (reward/shock)
//   Transfer learning: observational (watching another octopus solve task)
//   Memory consolidation: replay during sleep-like states (REM-analog)
//
// ── LAYER 5: CHEMORECEPTION — SUCKERS ─────────────────────────────────────────
//   Each sucker has: mechanoreceptors + chemoreceptors
//   ~250 sensory cells per sucker, ~2200 suckers per arm, 8 arms
//   Total: ~250 × 2200 × 8 = 4,400,000 sensory cells
//   Chemical detection: concentration C above threshold C_min
//   Response: r_chem = r_max × C / (C + K_D)  [Hill equation, n=1]
//   K_D = dissociation constant (affinity for compound)
//   Mechanical detection: displacement d → receptor potential V = V_max × tanh(d/d₀)
//   Grip force: F_sucker = P_vacuum × A_sucker ≈ 0.1 × 25×10⁻⁶ = 2.5 N per sucker
//   Total grip: F_total = N_suckers × F_sucker ≈ 2200 × 8 × 2.5 = 44,000 N (impossible grip)
//
// ── LAYER 6: JET PROPULSION ──────────────────────────────────────────────────
//   Mantle contracts → ejects water through funnel → thrust
//   Thrust: F_thrust = ρ_water × A_funnel × v_jet²
//   v_jet = mantle_contraction_rate × mantle_volume / A_funnel
//   Mantle volume: V_m ≈ 0.5 L, A_funnel ≈ 1 cm², v_jet_max ≈ 10 m/s
//   F_thrust_max = 1000 × 10⁻⁴ × 100 = 10 N (10× octopus body weight)
//   Efficiency: η = 2/(1 + v_jet/v_body)  (actuator disk theory)
//   Maximum speed: v_max ≈ 10 body lengths/s (escape response)
//   Energy cost: E_jet = ½ M_water × v_jet² per stroke
//   Steering: funnel direction controls heading (360° rotation possible)
//
// ── LAYER 7: MEDINA OCTOPUS DISTRIBUTION INDEX ────────────────────────────────
//   O_dist = S₀ × [arm_autonomy × Φ_M + central_coherence] / Ω
//   arm_autonomy = fraction of processing done in arm ganglia [0,1]
//   central_coherence = integration between central brain and arms [0,1]
//   O_dist ∈ [0, S₀(Φ_M+1)/Ω] = [0, 0.441]
//   Optimal: O_dist ≈ 0.40 (arms mostly autonomous, central loosely coherent)
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

  // Octopus neural constants
  public let N_ARMS                : Nat   = 8;
  public let NEURONS_CENTRAL       : Nat   = 50000000;   // 50M central neurons
  public let NEURONS_PER_ARM       : Nat   = 56250000;   // 450M/8 per arm
  public let SUCKERS_PER_ARM       : Nat   = 2200;
  public let CHEMORECEPTORS_PER_SUCKER : Nat = 250;
  public let SIGNAL_DELAY_MS       : Float = 50.0;       // arm-to-brain delay
  public let CENTRAL_FRACTION      : Float = 0.10;       // 10% neurons in brain

  // Arm dynamics
  public let ARM_LENGTH_M          : Float = 0.50;       // 50cm arm length
  public let ARM_RADIUS_M          : Float = 0.01;       // 1cm arm radius
  public let ARM_VOLUME_M3         : Float = 0.000157;   // π × r² × L
  public let AXON_VELOCITY_MS      : Float = 10.0;       // m/s signal speed
  public let LONG_MUSCLE_ALPHA     : Float = 0.3;        // longitudinal contraction rate
  public let TRANS_MUSCLE_BETA     : Float = 0.2;        // transverse rate
  public let OBLIQUE_GAMMA         : Float = 0.1;        // torsion rate

  // Chromatophore
  public let N_CHROMATOPHORES      : Nat   = 1000000;   // 1M chromatophore units
  public let CHROMA_MAX_D_MM       : Float = 1.5;       // max expansion diameter mm
  public let CHROMA_EXPAND_MS      : Float = 300.0;     // expansion time constant
  public let CHROMA_RETRACT_MS     : Float = 500.0;     // retraction time constant
  public let N_PIGMENT_TYPES       : Nat   = 3;         // red, yellow, brown
  public let LAMBDA_RED_NM         : Float = 610.0;
  public let LAMBDA_YELLOW_NM      : Float = 580.0;
  public let LAMBDA_BROWN_NM       : Float = 560.0;

  // Sucker/grip
  public let SUCKER_AREA_M2        : Float = 25.0e-6;   // 25mm² per sucker
  public let SUCKER_VACUUM_PA      : Float = 100000.0;  // 1atm vacuum pressure
  public let SUCKER_FORCE_N        : Float = 2.5;       // N per sucker

  // Jet propulsion
  public let MANTLE_VOLUME_M3      : Float = 0.0005;    // 0.5L mantle
  public let FUNNEL_AREA_M2        : Float = 1.0e-4;    // 1cm² funnel
  public let WATER_DENSITY         : Float = 1000.0;    // kg/m³

  // Learning
  public let LEARNING_RATE         : Float = 0.01;
  public let SYNAPSE_DECAY         : Float = 0.999;

  public let HIST_MAX              : Nat   = 100;

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type ArmState = {
    armIdx        : Nat;
    length        : Float;      // current arm length [0,1] normalized
    curvature     : Float;      // κ average curvature
    torsion       : Float;      // τ average torsion
    motorActivity : [Float];    // [LM, TM, OM] activity [0,1]
    gripForce     : Float;      // N total grip force
    touchSignal   : Float;      // aggregate touch input [0,1]
    chemSignal    : Float;      // aggregate chemical input [0,1]
    autonomyLevel : Float;      // how much arm is operating independently [0,1]
    localGoal     : Float;      // arm's local reaching objective [0,1]
  };

  public type ChromatophoreLayer = {
    pigmentActivation : [Float];  // 3 pigments: [red, yellow, brown] [0,1]
    iridophoreState   : Float;    // reflectance [0,1]
    papillaeHeight    : Float;    // texture height [0,1] (0=smooth, 1=rough)
    skinColor         : [Float];  // [R, G, B] 0-1
    camouflageMatch   : Float;    // match to background [0,1]
    expansionState    : Float;    // current chromatophore expansion [0,1]
  };

  public type JetPropulsion = {
    mantleContraction : Float;   // [0,1] contraction level
    jetVelocity       : Float;   // m/s
    thrustForce       : Float;   // N
    funnelAngle       : Float;   // degrees (heading direction)
    energyCostPerBeat : Float;   // Joules per beat
    efficiency        : Float;   // propulsive efficiency [0,1]
  };

  public type LearningState = {
    synapticWeights  : [Float];  // simplified: 20 key synapses
    rewardSignal     : Float;    // current dopamine analog [-1,1]
    associativeLinks : [Float];  // CS-US association strengths
    memoryConsolidation : Float; // [0,1] how consolidated memory is
  };

  public type OctopusBrainState = {
    arms            : [ArmState];     // 8 arm states
    centralGoal     : Float;         // what the central brain wants [0,1]
    chromatophore   : ChromatophoreLayer;
    jet             : JetPropulsion;
    learning        : LearningState;
    armAutonomy     : Float;         // 0=fully centralized, 1=fully decentralized
    centralCoherence: Float;         // coherence between brain and arms [0,1]
    octopusIndex    : Float;         // O_dist sovereign index
    alertLevel      : Float;
    huntMode        : Bool;
    escapeMode      : Bool;
    beatNum         : Nat;
    armHistory      : [Float];
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: MATH HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  func _tanh(x : Float) : Float {
    let e2x = Float.exp(_clamp(2.0 * x, -100.0, 100.0));
    (e2x - 1.0) / (e2x + 1.0)
  };
  func _exp(x : Float) : Float { Float.exp(_clamp(x, -100.0, 100.0)) };
  func _cos(x : Float) : Float { Float.cos(x) };
  func _sin(x : Float) : Float { Float.sin(x) };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: ARM DYNAMICS
  // Muscular hydrostat: constant volume constraint
  // Volume constraint: π r² L = V₀ = const
  // If L decreases → r increases (longitudinal compression → radial expansion)
  // ══════════════════════════════════════════════════════════════════════════

  // Update arm geometry given muscle activities
  // dL/dt = -α × LM_activity  (longitudinal shortening)
  // Volume conservation: r = sqrt(V₀ / (π × L))
  public func updateArmGeometry(arm : ArmState, dt : Float) : ArmState {
    let lm = arm.motorActivity[0];  // longitudinal muscle
    let tm = if (arm.motorActivity.size() > 1) arm.motorActivity[1] else 0.0;
    let om = if (arm.motorActivity.size() > 2) arm.motorActivity[2] else 0.0;

    let newLength = _clamp(arm.length - LONG_MUSCLE_ALPHA * lm * dt + TRANS_MUSCLE_BETA * tm * dt, 0.1, 1.0);
    let newCurv   = _clamp(arm.curvature + (lm - 0.5) * 0.1, 0.0, 10.0);
    let newTors   = _clamp(arm.torsion + om * OBLIQUE_GAMMA * dt, -PI, PI);

    // Grip force: each active sucker provides F = P × A
    let suckersActive = arm.touchSignal * Float.fromInt(SUCKERS_PER_ARM);
    let newGrip = suckersActive * SUCKER_FORCE_N;

    {
      armIdx        = arm.armIdx;
      length        = newLength;
      curvature     = newCurv;
      torsion       = newTors;
      motorActivity = arm.motorActivity;
      gripForce     = _clamp(newGrip, 0.0, Float.fromInt(SUCKERS_PER_ARM) * SUCKER_FORCE_N);
      touchSignal   = arm.touchSignal;
      chemSignal    = arm.chemSignal;
      autonomyLevel = arm.autonomyLevel;
      localGoal     = arm.localGoal;
    }
  };

  // Chemoreceptor response: Hill equation
  // r = r_max × Cⁿ / (K_D^n + Cⁿ)  for n=1: r = r_max × C / (K_D + C)
  public func chemoreceptorResponse(concentration : Float, kD : Float, r_max : Float) : Float {
    if (kD + concentration < EPSILON) { return 0.0 };
    r_max * concentration / (kD + concentration)
  };

  // Total arm sensory integration
  public func armSensoryIntegrate(arm : ArmState) : Float {
    let touchWeight = 0.6;
    let chemWeight  = 0.4;
    touchWeight * arm.touchSignal + chemWeight * arm.chemSignal
  };

  // Minimum curvature path (natural cubic spline arms)
  // Cost: J = ∫ κ²(s) ds ≈ Σ_i κᵢ² Δs
  public func curvatureCost(arms : [ArmState]) : Float {
    var total : Float = 0.0;
    for (arm in arms.vals()) {
      total += arm.curvature * arm.curvature;
    };
    total / Float.fromInt(arms.size())
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: CHROMATOPHORE DYNAMICS
  // Expansion: e(t+dt) = e(t) + (target - e(t)) × dt/τ_expand
  // Color: C_skin = Σᵢ pᵢ × G(λ - λᵢ, σᵢ)
  // ══════════════════════════════════════════════════════════════════════════

  // Chromatophore expansion dynamics (first-order RC filter)
  // τ = CHROMA_EXPAND_MS (expanding) or CHROMA_RETRACT_MS (retracting)
  public func updateChromatophore(
    current : Float,
    target  : Float,
    dt      : Float
  ) : Float {
    let tau = if (target > current) CHROMA_EXPAND_MS else CHROMA_RETRACT_MS;
    let alpha = dt / (tau / 1000.0);  // convert ms to beats
    _clamp(current + alpha * (target - current), 0.0, 1.0)
  };

  // Gaussian pigment spectral response: G(λ, λ_peak, σ)
  public func pigmentResponse(wavelength : Float, peak : Float, sigma : Float) : Float {
    let d = wavelength - peak;
    Float.exp(-d * d / (2.0 * sigma * sigma))
  };

  // Skin color from pigment activations [red, yellow, brown]
  // Returns [R, G, B] ∈ [0,1]³
  public func skinColor(activation : [Float]) : [Float] {
    if (activation.size() < 3) { return [0.5, 0.5, 0.5] };
    let red    = activation[0];
    let yellow = activation[1];
    let brown  = activation[2];

    // Red pigment → adds R, removes G, B
    // Yellow pigment → adds R, G, removes B
    // Brown pigment → reduces all (absorbs broadly)
    let R = _clamp(red * 0.9 + yellow * 0.7 + brown * 0.3, 0.0, 1.0);
    let G = _clamp(red * 0.1 + yellow * 0.8 + brown * 0.3, 0.0, 1.0);
    let B = _clamp(red * 0.05 + yellow * 0.1 + brown * 0.2, 0.0, 1.0);
    [R, G, B]
  };

  // Camouflage match: mean squared error between skin and background RGB
  // match = 1 - MSE(skin, background) ∈ [0,1]
  public func camouflageMatch(skinRGB : [Float], backgroundRGB : [Float]) : Float {
    if (skinRGB.size() < 3 or backgroundRGB.size() < 3) { return 0.0 };
    var mse : Float = 0.0;
    var i : Nat = 0;
    while (i < 3) {
      let d = skinRGB[i] - backgroundRGB[i];
      mse += d * d;
      i += 1;
    };
    _clamp(1.0 - mse / 3.0, 0.0, 1.0)
  };

  // Update chromatophore layer toward camouflage target
  public func updateCamouflage(
    layer        : ChromatophoreLayer,
    background   : [Float],           // target RGB
    dt           : Float
  ) : ChromatophoreLayer {
    // Compute target pigment activation to match background
    // Red = background[0], Yellow = mixed, Brown = darken
    let targetRed    = _clamp(background[0] * 0.8, 0.0, 1.0);
    let targetYellow = _clamp(background[0] * 0.5 + background[1] * 0.5, 0.0, 1.0);
    let targetBrown  = _clamp(1.0 - background[0] - background[1], 0.0, 1.0);

    let newRed    = updateChromatophore(layer.pigmentActivation[0], targetRed, dt);
    let newYellow = if (layer.pigmentActivation.size() > 1) updateChromatophore(layer.pigmentActivation[1], targetYellow, dt) else 0.5;
    let newBrown  = if (layer.pigmentActivation.size() > 2) updateChromatophore(layer.pigmentActivation[2], targetBrown, dt) else 0.3;

    let newActivation = [newRed, newYellow, newBrown];
    let newSkin = skinColor(newActivation);
    let newMatch = camouflageMatch(newSkin, background);
    let newExpansion = updateChromatophore(layer.expansionState, (targetRed + targetYellow) / 2.0, dt);

    {
      pigmentActivation = newActivation;
      iridophoreState   = layer.iridophoreState;
      papillaeHeight    = layer.papillaeHeight;
      skinColor         = newSkin;
      camouflageMatch   = newMatch;
      expansionState    = newExpansion;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: JET PROPULSION
  // F = ρ_water × A_funnel × v_jet²
  // v_jet = dV_mantle/dt / A_funnel
  // ══════════════════════════════════════════════════════════════════════════

  // Jet velocity from mantle contraction rate
  // v_jet = contraction_rate × V_mantle / A_funnel
  public func jetVelocity(contractionRate : Float) : Float {
    _clamp(contractionRate * MANTLE_VOLUME_M3 / FUNNEL_AREA_M2, 0.0, 30.0)
  };

  // Thrust force: F = ρ A v²
  public func thrustForce(v_jet : Float) : Float {
    WATER_DENSITY * FUNNEL_AREA_M2 * v_jet * v_jet
  };

  // Propulsive efficiency: η = 2 / (1 + v_jet/v_body)
  public func propulsiveEfficiency(v_jet : Float, v_body : Float) : Float {
    if (v_jet < EPSILON) { return 0.0 };
    _clamp(2.0 / (1.0 + v_jet / (v_body + EPSILON)), 0.0, 1.0)
  };

  // Energy cost per jet stroke: E = ½ M_water × v_jet²
  // M_water = ρ × V_ejected = ρ × A_funnel × v_jet × dt
  public func jetEnergyCost(v_jet : Float, dt : Float) : Float {
    let M_water = WATER_DENSITY * FUNNEL_AREA_M2 * v_jet * dt;
    0.5 * M_water * v_jet * v_jet
  };

  // Update jet propulsion state
  public func updateJet(
    jet            : JetPropulsion,
    contractionRate: Float,
    funnelAngle    : Float,
    v_body         : Float,
    dt             : Float
  ) : JetPropulsion {
    let v_jet = jetVelocity(contractionRate);
    let thrust = thrustForce(v_jet);
    let eta    = propulsiveEfficiency(v_jet, v_body);
    let cost   = jetEnergyCost(v_jet, dt);
    {
      mantleContraction = _clamp(contractionRate, 0.0, 1.0);
      jetVelocity       = v_jet;
      thrustForce       = thrust;
      funnelAngle       = _clamp(funnelAngle, 0.0, 360.0);
      energyCostPerBeat = cost;
      efficiency        = eta;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: DISTRIBUTED INTELLIGENCE — ARM AUTONOMY
  // ══════════════════════════════════════════════════════════════════════════

  // Update arm autonomy based on central brain coherence
  // High coherence → arms defer to central brain (lower autonomy)
  // Low coherence → arms operate independently (higher autonomy)
  public func updateArmAutonomy(centralCoherence : Float) : Float {
    _clamp(1.0 - centralCoherence * 0.7, 0.1, 0.95)
  };

  // Central coherence: how unified is the octopus's intent across arms?
  // Computed from variance in arm goals
  public func computeCentralCoherence(arms : [ArmState]) : Float {
    if (arms.size() == 0) { return 0.5 };
    var sumGoal : Float = 0.0;
    for (arm in arms.vals()) { sumGoal += arm.localGoal };
    let meanGoal = sumGoal / Float.fromInt(arms.size());
    var variance : Float = 0.0;
    for (arm in arms.vals()) {
      let d = arm.localGoal - meanGoal;
      variance += d * d;
    };
    variance := variance / Float.fromInt(arms.size());
    // Coherence is inverse of normalized variance
    _clamp(1.0 - variance / 0.25, 0.0, 1.0)  // 0.25 = max possible variance for [0,1]
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: HEBBIAN LEARNING
  // Δw_ij = η × r_i × r_j × reward
  // ══════════════════════════════════════════════════════════════════════════

  public func hebbianUpdate(
    weights : [Float],
    preActivity : [Float],
    postActivity : Float,
    reward : Float
  ) : [Float] {
    let n = if (weights.size() < preActivity.size()) weights.size() else preActivity.size();
    Array.tabulate<Float>(n, func(i) {
      let dw = LEARNING_RATE * preActivity[i] * postActivity * reward;
      _clamp(weights[i] * SYNAPSE_DECAY + dw, -1.0, 1.0)
    })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: MEDINA OCTOPUS INDEX
  // O_dist = S₀ × [arm_autonomy × Φ_M + central_coherence] / Ω
  // ══════════════════════════════════════════════════════════════════════════

  public func octopusIndex(armAutonomy : Float, centralCoherence : Float) : Float {
    let idx = S0 * (armAutonomy * PHI_MEDINA + centralCoherence) / SOVEREIGN_CEILING;
    _clamp(idx, 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  public func beatOctopus(
    state           : OctopusBrainState,
    armInputs       : [Float],      // 8 touch/chem signals
    centralGoal     : Float,
    backgroundRGB   : [Float],
    contractionRate : Float,
    funnelAngle     : Float,
    v_body          : Float,
    reward          : Float,
    dt              : Float
  ) : OctopusBrainState {
    // Update each arm
    let newArms = Array.tabulate<ArmState>(N_ARMS, func(i) {
      let arm = state.arms[i];
      let touchIn = if (i < armInputs.size()) armInputs[i] else 0.0;
      let armWith = {
        armIdx        = arm.armIdx;
        length        = arm.length;
        curvature     = arm.curvature;
        torsion       = arm.torsion;
        motorActivity = arm.motorActivity;
        gripForce     = arm.gripForce;
        touchSignal   = touchIn;
        chemSignal    = arm.chemSignal;
        autonomyLevel = arm.autonomyLevel;
        localGoal     = if arm.autonomyLevel > 0.5 { touchIn } else centralGoal;
      };
      updateArmGeometry(armWith, dt)
    });

    let newCC = computeCentralCoherence(newArms);
    let newAA = updateArmAutonomy(newCC);

    // Update chromatophore
    let newChroma = updateCamouflage(state.chromatophore, backgroundRGB, dt);

    // Update jet
    let newJet = updateJet(state.jet, contractionRate, funnelAngle, v_body, dt);

    // Update learning
    let armSensory = Array.tabulate<Float>(N_ARMS, func(i) { armSensoryIntegrate(newArms[i]) });
    let newWeights = hebbianUpdate(state.learning.synapticWeights, armSensory, centralGoal, reward);
    let newLearning : LearningState = {
      synapticWeights  = newWeights;
      rewardSignal     = reward;
      associativeLinks = state.learning.associativeLinks;
      memoryConsolidation = _clamp(state.learning.memoryConsolidation + 0.001, 0.0, 1.0);
    };

    let oIdx = octopusIndex(newAA, newCC);
    let alert = _clamp(reward + newCC * 0.3, 0.0, 1.0);
    let newArmH = _appendRolling(state.armHistory, curvatureCost(newArms), HIST_MAX);

    {
      arms             = newArms;
      centralGoal      = centralGoal;
      chromatophore    = newChroma;
      jet              = newJet;
      learning         = newLearning;
      armAutonomy      = newAA;
      centralCoherence = newCC;
      octopusIndex     = oIdx;
      alertLevel       = alert;
      huntMode         = centralGoal > 0.7 and reward > 0.0;
      escapeMode       = reward < -0.5;
      beatNum          = state.beatNum + 1;
      armHistory       = newArmH;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  func _initArm(idx : Nat) : ArmState {
    {
      armIdx        = idx;
      length        = 1.0;
      curvature     = 0.0;
      torsion       = 0.0;
      motorActivity = [0.3, 0.3, 0.1];
      gripForce     = 0.0;
      touchSignal   = 0.0;
      chemSignal    = 0.0;
      autonomyLevel = 0.7;  // high autonomy by default
      localGoal     = 0.5;
    }
  };

  public func initOctopusBrain() : OctopusBrainState {
    let initArms = Array.tabulate<ArmState>(N_ARMS, _initArm);
    let initChroma : ChromatophoreLayer = {
      pigmentActivation = [0.3, 0.4, 0.2];
      iridophoreState   = 0.5;
      papillaeHeight    = 0.2;
      skinColor         = [0.4, 0.35, 0.1];
      camouflageMatch   = 0.5;
      expansionState    = 0.5;
    };
    let initJet : JetPropulsion = {
      mantleContraction=0.0; jetVelocity=0.0; thrustForce=0.0;
      funnelAngle=180.0; energyCostPerBeat=0.0; efficiency=0.0;
    };
    let initLearn : LearningState = {
      synapticWeights  = Array.tabulate<Float>(N_ARMS, func(_) { 0.1 });
      rewardSignal     = 0.0;
      associativeLinks = Array.tabulate<Float>(10, func(_) { 0.0 });
      memoryConsolidation = 0.0;
    };
    {
      arms             = initArms;
      centralGoal      = 0.5;
      chromatophore    = initChroma;
      jet              = initJet;
      learning         = initLearn;
      armAutonomy      = 0.7;
      centralCoherence = 0.6;
      octopusIndex     = 0.0;
      alertLevel       = 0.0;
      huntMode         = false;
      escapeMode       = false;
      beatNum          = 0;
      armHistory       = [];
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
  //  A N I M A L   I N T E L L I G E N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Biomimetic Cognitive Algorithms
  //  Full HIM/HER Integration with Animal Brain Dynamics
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // SWARM INTELLIGENCE MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Reynolds flocking: Separation force
  public func animalSeparationForce(
    position : (Float, Float),
    neighbors : [(Float, Float)],
    separationRadius : Float
  ) : (Float, Float) {
    var forceX : Float = 0.0;
    var forceY : Float = 0.0;
    var i = 0;
    while (i < neighbors.size()) {
      let (nx, ny) = neighbors[i];
      let dx = position.0 - nx;
      let dy = position.1 - ny;
      let dist = Float.sqrt(dx * dx + dy * dy);
      if (dist > 0.0001 and dist < separationRadius) {
        let strength = (separationRadius - dist) / separationRadius;
        forceX += (dx / dist) * strength;
        forceY += (dy / dist) * strength;
      };
      i += 1;
    };
    (forceX, forceY)
  };

  /// Reynolds flocking: Alignment force
  public func animalAlignmentForce(
    velocity : (Float, Float),
    neighborVelocities : [(Float, Float)]
  ) : (Float, Float) {
    if (neighborVelocities.size() == 0) { return (0.0, 0.0) };
    var avgVx : Float = 0.0;
    var avgVy : Float = 0.0;
    var i = 0;
    while (i < neighborVelocities.size()) {
      let (vx, vy) = neighborVelocities[i];
      avgVx += vx;
      avgVy += vy;
      i += 1;
    };
    let n = Float.fromInt(neighborVelocities.size());
    avgVx /= n;
    avgVy /= n;
    (avgVx - velocity.0, avgVy - velocity.1)
  };

  /// Reynolds flocking: Cohesion force
  public func animalCohesionForce(
    position : (Float, Float),
    neighbors : [(Float, Float)]
  ) : (Float, Float) {
    if (neighbors.size() == 0) { return (0.0, 0.0) };
    var centerX : Float = 0.0;
    var centerY : Float = 0.0;
    var i = 0;
    while (i < neighbors.size()) {
      let (nx, ny) = neighbors[i];
      centerX += nx;
      centerY += ny;
      i += 1;
    };
    let n = Float.fromInt(neighbors.size());
    centerX /= n;
    centerY /= n;
    (centerX - position.0, centerY - position.1)
  };

  /// Ant colony pheromone update
  public func animalPheromoneUpdate(
    current : Float,
    deposit : Float,
    evaporationRate : Float,
    dt : Float
  ) : Float {
    (current + deposit) * (1.0 - evaporationRate * dt)
  };

  /// Ant path probability
  public func animalAntPathProbability(
    pheromone : Float,
    distance : Float,
    alpha : Float,
    beta : Float
  ) : Float {
    let pheromoneFactor = Float.pow(pheromone + 0.01, alpha);
    let distanceFactor = Float.pow(1.0 / (distance + 0.01), beta);
    pheromoneFactor * distanceFactor
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // ECHOLOCATION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Doppler shift for moving target
  public func animalDopplerShift(
    emittedFreq : Float,
    targetVelocity : Float,
    soundSpeed : Float
  ) : Float {
    emittedFreq * (soundSpeed + targetVelocity) / soundSpeed
  };

  /// Echo time-of-flight to distance
  public func animalEchoDistance(timeOfFlight : Float, soundSpeed : Float) : Float {
    (timeOfFlight * soundSpeed) / 2.0
  };

  /// Echo intensity decay
  public func animalEchoIntensity(
    sourceIntensity : Float,
    distance : Float,
    attenuation : Float
  ) : Float {
    sourceIntensity * Float.exp(-attenuation * distance) / (distance * distance + 0.01)
  };

  /// Azimuth from interaural time difference
  public func animalAzimuthFromITD(itd : Float, headRadius : Float, soundSpeed : Float) : Float {
    Float.asin(itd * soundSpeed / headRadius)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // VISUAL PROCESSING MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Retinal ganglion cell receptive field (DoG)
  public func animalDoGReceptiveField(
    x : Float,
    y : Float,
    sigmaCenter : Float,
    sigmaSurround : Float,
    centerStrength : Float,
    surroundStrength : Float
  ) : Float {
    let rSquared = x * x + y * y;
    let center = centerStrength * Float.exp(-rSquared / (2.0 * sigmaCenter * sigmaCenter));
    let surround = surroundStrength * Float.exp(-rSquared / (2.0 * sigmaSurround * sigmaSurround));
    center - surround
  };

  /// Gabor filter response
  public func animalGaborResponse(
    x : Float,
    y : Float,
    wavelength : Float,
    orientation : Float,
    sigma : Float,
    aspectRatio : Float
  ) : Float {
    let xTheta = x * Float.cos(orientation) + y * Float.sin(orientation);
    let yTheta = -x * Float.sin(orientation) + y * Float.cos(orientation);
    let gaussian = Float.exp(-(xTheta * xTheta + aspectRatio * aspectRatio * yTheta * yTheta) / (2.0 * sigma * sigma));
    let sinusoid = Float.cos(2.0 * 3.14159265 * xTheta / wavelength);
    gaussian * sinusoid
  };

  /// Motion energy from V1 simple cells
  public func animalMotionEnergy(
    leftwardResponse : Float,
    rightwardResponse : Float
  ) : Float {
    leftwardResponse * leftwardResponse - rightwardResponse * rightwardResponse
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // NAVIGATION MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Magnetic field sensing (magnetoreception)
  public func animalMagneticHeading(
    fieldX : Float,
    fieldY : Float
  ) : Float {
    Float.atan2(fieldY, fieldX)
  };

  /// Polarized light sensing
  public func animalPolarizationAngle(
    intensity0 : Float,
    intensity45 : Float,
    intensity90 : Float
  ) : Float {
    0.5 * Float.atan2(intensity45 - intensity90, intensity0 - intensity90)
  };

  /// Path integration
  public func animalPathIntegration(
    currentX : Float,
    currentY : Float,
    velocity : Float,
    heading : Float,
    dt : Float
  ) : (Float, Float) {
    let dx = velocity * Float.cos(heading) * dt;
    let dy = velocity * Float.sin(heading) * dt;
    (currentX + dx, currentY + dy)
  };

  /// Grid cell firing pattern
  public func animalGridCellFiring(
    x : Float,
    y : Float,
    gridSpacing : Float,
    gridOrientation : Float
  ) : Float {
    let theta1 : Float = gridOrientation;
    let theta2 : Float = gridOrientation + 1.0472;  // +60 degrees
    let theta3 : Float = gridOrientation + 2.0944;  // +120 degrees
    let k = 4.0 * 3.14159265 / (gridSpacing * Float.sqrt(3.0));
    let u1 = Float.cos(k * (x * Float.cos(theta1) + y * Float.sin(theta1)));
    let u2 = Float.cos(k * (x * Float.cos(theta2) + y * Float.sin(theta2)));
    let u3 = Float.cos(k * (x * Float.cos(theta3) + y * Float.sin(theta3)));
    (u1 + u2 + u3) / 3.0
  };

  /// Place cell firing
  public func animalPlaceCellFiring(
    x : Float,
    y : Float,
    centerX : Float,
    centerY : Float,
    fieldRadius : Float
  ) : Float {
    let dx = x - centerX;
    let dy = y - centerY;
    let distSquared = dx * dx + dy * dy;
    Float.exp(-distSquared / (2.0 * fieldRadius * fieldRadius))
  };

  /// Head direction cell
  public func animalHeadDirectionFiring(
    currentHeading : Float,
    preferredHeading : Float,
    tuningWidth : Float
  ) : Float {
    let diff = currentHeading - preferredHeading;
    Float.exp(-diff * diff / (2.0 * tuningWidth * tuningWidth))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // DECISION MAKING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Drift-diffusion model
  public func animalDriftDiffusion(
    evidence : Float,
    drift : Float,
    noise : Float,
    threshold : Float,
    dt : Float
  ) : (Float, Bool) {
    let newEvidence = evidence + drift * dt + noise * Float.sqrt(dt);
    let decided = Float.abs(newEvidence) >= threshold;
    (newEvidence, decided)
  };

  /// Winner-take-all competition
  public func animalWinnerTakeAll(
    activities : [Float],
    inhibition : Float
  ) : [Float] {
    var maxActivity : Float = 0.0;
    var i = 0;
    while (i < activities.size()) {
      if (activities[i] > maxActivity) { maxActivity := activities[i] };
      i += 1;
    };
    Array.tabulate<Float>(activities.size(), func(j : Nat) : Float {
      let diff = activities[j] - maxActivity;
      if (diff < -inhibition) { 0.0 } else { activities[j] }
    })
  };

  /// Urgency signal
  public func animalUrgencySignal(time : Float, gain : Float, offset : Float) : Float {
    offset + gain * time
  };

}
