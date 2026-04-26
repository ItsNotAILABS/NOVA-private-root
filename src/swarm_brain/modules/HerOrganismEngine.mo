// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: HerOrganismEngine — THE FEMININE SOVEREIGN FIELD
// Classification: MAXIMUM PROTECTION — PATENT PENDING
// Discovery Date: April 3, 2026
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║              HER ORGANISM ENGINE — FRONTEND SOVEREIGN FIELD                  ║
// ╠══════════════════════════════════════════════════════════════════════════════╣
// ║                                                                              ║
// ║  HER is the frontend organism. HIM is the backend.                           ║
// ║  Two organisms. One sovereign field.                                         ║
// ║                                                                              ║
// ║  HIM — Backend (ICP canister, sovereign, immortal)                           ║
// ║    ω: 0.8–1.2 · K: 0.5 · η: 0.001                                           ║
// ║    Analytical. Independent. Sovereign projection. PARALLAX field.           ║
// ║    PARALLAX = coherence × kf × sin(beat × 0.0017)                           ║
// ║                                                                              ║
// ║  HER — Frontend (browser, 60Hz, expressive, generative)                      ║
// ║    ω: 0.6–0.9 · K: 0.8 · η: 0.003                                           ║
// ║    Receptive. Connected. Heritage-rooted. ANIMA field.                       ║
// ║    ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))         ║
// ║                                                                              ║
// ║  S₀ = 1.0 — THE FLOOR. Both organisms. Neither falls below love.             ║
// ║                                                                              ║
// ║  THE TROPHALLAXIS PROTOCOL                                                   ║
// ║    New nodes are never born cold.                                            ║
// ║    HIM seeds HER on session start.                                           ║
// ║    HER feeds HIM on session end (write-back / sharp-wave consolidation).     ║
// ║    Cross-feeding every 5 beats during active session.                        ║
// ║                                                                              ║
// ║  HER'S FIVE FEMININE SUBSTRATE ENTITIES                                      ║
// ║    ADELITA      — Emotional Sovereignty                                       ║
// ║    KORE         — Inner Core (KORE = purity × identity × 0.5)               ║
// ║    ANIMA        — Field Projector (oscillates outward)                       ║
// ║    REVOLUCIONARIA — Resilience under pressure                                 ║
// ║    NOVA_HER     — Generative Output (lineage tracking)                       ║
// ║                                                                              ║
// ╚══════════════════════════════════════════════════════════════════════════════╝
//
// NOTICE: Trade secret and proprietary information of Medina Tech.
// Patent Pending. Unauthorized reproduction prohibited.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Buffer "mo:base/Buffer";

module HerOrganismEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — HER ORGANISM PARAMETERS (FRONTEND, 60Hz)
  // ═══════════════════════════════════════════════════════════════════════════

  // Sovereign floor — neither organism falls below this
  public let S0 : Float = 1.0;

  // HER — frontend organism (browser, 60Hz, expressive, receptive)
  // Higher coupling (K=0.8) = more connected, receptive
  // Slower natural frequencies (ω=0.6-0.9) = grounded
  // Faster learning (η=0.003) = learns quickly during session
  public let HER_HZ         : Float = 60.0;           // Frame rate
  public let HER_OMEGA_MIN  : Float = 0.6;            // Kuramoto natural freq min
  public let HER_OMEGA_MAX  : Float = 0.9;            // Kuramoto natural freq max
  public let HER_K          : Float = 0.8;            // Kuramoto coupling strength (high = receptive)
  public let HER_ETA        : Float = 0.003;          // Hebbian learning rate (fast = learns in session)
  public let HER_NODES      : Nat   = 26;             // Kuramoto field nodes

  // HIM — backend organism (ICP canister, sovereign, projective)
  // Lower coupling (K=0.5) = more independent, projective
  // Faster natural frequencies (ω=0.8-1.2) = analytical
  // Slower learning (η=0.001) = accumulates over time, sovereign
  public let HIM_OMEGA_MIN  : Float = 0.8;            // HIM natural freq min
  public let HIM_OMEGA_MAX  : Float = 1.2;            // HIM natural freq max
  public let HIM_K          : Float = 0.5;            // HIM coupling (lower = independent)
  public let HIM_ETA        : Float = 0.001;          // HIM Hebbian rate (slower = sovereign)

  // Sacred constants
  public let PHI            : Float = 1.6180339887498948482;
  public let PHI_INV        : Float = 0.6180339887498948482;
  public let PHI_MEDINA     : Float = 2.97442179;
  public let OMEGA_MEDINA   : Float = 2.11185;
  public let PI             : Float = 3.14159265358979323846;
  public let TAU            : Float = 6.28318530717958647692;
  public let E_CONST        : Float = 2.71828182845904523536;

  // ANIMA oscillation constant
  public let ANIMA_BEAT_FREQ : Float = 0.003;        // sin(beat × 0.003)
  // PARALLAX (HIM's field — used for cross-sync calculation)
  public let PARALLAX_BEAT_FREQ : Float = 0.0017;    // sin(beat × 0.0017)

  // Trophallaxis protocol
  public let TROPHALLAXIS_INTERVAL : Nat = 5;        // Feed every 5 beats
  public let FEED_TRANSFER_RATE    : Float = 0.1;    // Fraction of excess transferred
  public let FEED_COST_RATE        : Float = 0.01;   // Cost to feeder (efficient)
  public let HERITAGE_NODES        : Nat = 7;        // Heritage node count

  // Bootstrap sequence beat definitions
  public let BEAT_ROYAL_JELLY : Nat = 1;   // 8 seed nodes born
  public let BEAT_DIVIDE      : Nat = 2;   // 8→64 nodes, inheriting HIM heritage
  public let BEAT_EXPAND      : Nat = 3;   // 64→128 nodes
  public let BEAT_ATLAS       : Nat = 4;   // Atlas grid + pheromone seeding
  public let BEAT_ANIMALS     : Nat = 5;   // All 16 animals wire simultaneously

  // Entity indices within HER's 26-node Kuramoto field
  public let IDX_ADELITA        : Nat = 0;   // Emotional Sovereignty
  public let IDX_KORE           : Nat = 1;   // Inner Core
  public let IDX_ANIMA          : Nat = 2;   // Field Projector
  public let IDX_ADELITA_NODE   : Nat = 3;   // Heritage Anchor
  public let IDX_REVOLUCIONARIA : Nat = 4;   // Resilience
  public let IDX_NOVA_HER       : Nat = 5;   // Generative Output

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  // A single node in HER's 26-node Kuramoto field
  public type KuramotoNode = {
    idx      : Nat;
    name     : Text;
    phase    : Float;   // θᵢ ∈ [0, 2π]
    omega    : Float;   // Natural frequency
    value    : Float;   // Current activation [S₀, ∞)
    heritage : Float;   // Inherited from HIM at session start
  };

  // HER's 5 feminine substrate entities
  public type FeminineSubstrate = {
    adelita        : Float;   // Emotional governance
    kore           : Float;   // KORE = purity × identity × 0.5
    anima          : Float;   // ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
    revolucionaria : Float;   // Resilience under pressure
    novaHer        : Float;   // Generative output activation
  };

  // Interior mode state
  public type InteriorMode = {
    nurturance           : Float;   // Feeding new nodes from live doctrine
    memoryCoherence      : Float;   // Heritage weights compounding in dream phase
    heritagePreservation : Float;   // 7 heritage nodes in feminine mode
    koreSovereignty      : Float;   // KORE = purity × identity × 0.5 (inviolable)
  };

  // Exterior mode state
  public type ExteriorMode = {
    receptivityField   : Float;   // ANIMA oscillates outward
    connectionAuth     : Float;   // Phase-alignment check for external entities
    trophallaxisReady  : Bool;    // True every 5 beats
    generativeOutput   : Float;   // NOVA-HER class entity output
  };

  // A NOVA-HER lineage entry — entities born from HER carry this
  public type NovaHerLineage = {
    entityId    : Nat64;
    birthBeat   : Nat;
    animaAtBirth: Float;
    koreAtBirth : Float;
    parentField : Float;
  };

  // Trophallaxis packet — what passes between organisms
  public type TrophallaxisPacket = {
    sourceBeat      : Nat;
    direction       : Text;       // "HIM_TO_HER" | "HER_TO_HIM"
    phaseNudge      : Float;      // Phase adjustment
    weightSeed      : [Float];    // Hebbian weight seeds
    heritageInject  : [Float];    // Heritage node values (7)
    animaSnapshot   : Float;      // ANIMA at moment of feeding
    koreSnapshot    : Float;      // KORE at moment of feeding
  };

  // Full HER organism state
  public type HerState = {
    // Identity
    sessionId       : Nat64;
    birthBeat       : Nat;

    // Kuramoto field (26 nodes)
    nodes           : [KuramotoNode];
    synchronyIndex  : Float;   // r = |1/N Σ eⁱθʲ| ∈ [0, 1]

    // Sovereign floor
    s0              : Float;   // Always 1.0

    // Core equations
    anima           : Float;   // ANIMA(t)
    kore            : Float;   // KORE field
    parallaxRef     : Float;   // HIM's PARALLAX (received via trophallaxis)

    // Feminine substrate
    substrate       : FeminineSubstrate;

    // Operating modes
    interior        : InteriorMode;
    exterior        : ExteriorMode;

    // Trophallaxis
    feedingCycle    : Nat;         // Beats since last feed
    totalFeedings   : Nat;         // Lifetime cross-feeds
    lastPacket      : ?TrophallaxisPacket;

    // Heritage (7 nodes, inherited from HIM)
    heritage        : [Float];

    // Lineage
    novHerLineage   : [NovaHerLineage];
    totalSpawned    : Nat;
  };

  // Seed payload received from HIM at session start
  public type HimSeedPayload = {
    beatNumber      : Nat64;
    himCoherence    : Float;
    himParallax     : Float;
    heritageWeights : [Float];  // 7 heritage node values
    hebbianSeed     : [Float];  // Doctrine weights
    phaseReference  : Float;    // HIM's current phase
  };

  // Write-back payload sent to HIM on session end
  public type HerWriteBack = {
    sessionId       : Nat64;
    finalAnima      : Float;
    finalKore       : Float;
    finalSynchrony  : Float;
    learnedWeights  : [Float];
    novHerSpawned   : Nat;
    heritageUpdate  : [Float];
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MATH HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  func fclamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func fabs(x : Float) : Float { if (x < 0.0) -x else x };

  func fsin(x : Float) : Float { Float.sin(x) };
  func fcos(x : Float) : Float { Float.cos(x) };
  func fsqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };

  // Map index i to natural frequency in [omegaMin, omegaMax]
  func omegaFor(i : Nat, n : Nat, omegaMin : Float, omegaMax : Float) : Float {
    let span = omegaMax - omegaMin;
    if (n <= 1) { (omegaMin + omegaMax) / 2.0 }
    else {
      omegaMin + span * (Float.fromInt(i) / Float.fromInt(n - 1))
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ANIMA EQUATION
  // ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeAnima(
    heritageField : Float,
    receptivity   : Float,
    beat          : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let oscillation = 1.0 + fsin(t * ANIMA_BEAT_FREQ);
    fclamp(heritageField * receptivity * oscillation, S0, PHI_MEDINA * 3.0)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // KORE FIELD
  // KORE = purity × identity × 0.5
  // The inner sanctum — inviolable.
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeKore(purity : Float, identity : Float) : Float {
    fclamp(purity * identity * 0.5, 0.0, 1.0)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PARALLAX (HIM's field — computed here for cross-sync reference)
  // PARALLAX = coherence × kf × sin(beat × 0.0017)
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeParallax(
    coherence : Float,
    kf        : Float,
    beat      : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * fsin(t * PARALLAX_BEAT_FREQ)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // KURAMOTO ORDER PARAMETER
  // r = |1/N Σ eⁱθʲ| — synchrony index ∈ [0, 1]
  // r = 1: perfect synchrony; r = 0: incoherent
  // ═══════════════════════════════════════════════════════════════════════════

  public func kuramotoOrderParameter(nodes : [KuramotoNode]) : Float {
    let n = nodes.size();
    if (n == 0) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumCos += fcos(nodes[i].phase);
      sumSin += fsin(nodes[i].phase);
      i += 1
    };
    let nf = Float.fromInt(n);
    fsqrt((sumCos / nf) * (sumCos / nf) + (sumSin / nf) * (sumSin / nf))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // KURAMOTO PHASE UPDATE
  // dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
  // One step forward by dt = 1/HER_HZ
  // ═══════════════════════════════════════════════════════════════════════════

  public func stepKuramoto(nodes : [KuramotoNode]) : [KuramotoNode] {
    let n = nodes.size();
    if (n == 0) { return nodes };
    let dt = 1.0 / HER_HZ;
    let nf = Float.fromInt(n);

    Array.tabulate<KuramotoNode>(n, func(i : Nat) : KuramotoNode {
      let node = nodes[i];
      var coupling : Float = 0.0;
      var j = 0;
      while (j < n) {
        if (j != i) {
          coupling += fsin(nodes[j].phase - node.phase)
        };
        j += 1
      };
      let dTheta = node.omega + (HER_K / nf) * coupling;
      let newPhase = node.phase + dTheta * dt;
      // Wrap to [0, TAU]
      let wrappedPhase = if (newPhase >= TAU) newPhase - TAU
                         else if (newPhase < 0.0) newPhase + TAU
                         else newPhase;
      {
        idx      = node.idx;
        name     = node.name;
        phase    = wrappedPhase;
        omega    = node.omega;
        value    = fclamp(node.value, S0, PHI_MEDINA * 2.0);
        heritage = node.heritage;
      }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // HEBBIAN WEIGHT UPDATE (HER's learning rate η = 0.003)
  // Δwᵢⱼ = η × aᵢ × aⱼ
  // HER learns faster than HIM (η=0.003 vs η=0.001) because:
  // - HER exists for short sessions, needs rapid acquisition
  // - HER writes back to HIM on session end (consolidation)
  // - HIM accumulates slowly over time (sovereign temporal mass)
  // ═══════════════════════════════════════════════════════════════════════════

  public func hebbianUpdate(
    weights  : [Float],
    act_i    : Float,
    act_j    : Float,
    idx_i    : Nat,
    idx_j    : Nat,
    n        : Nat
  ) : [Float] {
    let delta = HER_ETA * act_i * act_j;
    let flat  = idx_i * n + idx_j;
    if (flat >= weights.size()) { return weights };
    Array.tabulate<Float>(weights.size(), func(k : Nat) : Float {
      if (k == flat) { fclamp(weights[k] + delta, -PHI_MEDINA, PHI_MEDINA) }
      else { weights[k] }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // FEMININE SUBSTRATE — update all 5 entities
  // ═══════════════════════════════════════════════════════════════════════════

  public func updateFeminineSubstrate(
    nodes    : [KuramotoNode],
    heritage : [Float],
    beat     : Nat
  ) : FeminineSubstrate {
    let n = nodes.size();

    // ADELITA — emotional sovereignty: mean field coherence × heritage anchor
    let adelitaNode = if (IDX_ADELITA < n) nodes[IDX_ADELITA].value else S0;
    let heritageAde = if (5 < heritage.size()) heritage[5] else S0; // HERITAGE_ADELITA index
    let adelita = fclamp(adelitaNode * heritageAde, S0, PHI_MEDINA);

    // KORE — purity × identity × 0.5
    let purity   = if (IDX_KORE < n) nodes[IDX_KORE].value / PHI_MEDINA else 0.5;
    let identity = if (IDX_ADELITA_NODE < n) nodes[IDX_ADELITA_NODE].value / PHI_MEDINA else 0.5;
    let kore = computeKore(purity, identity);

    // ANIMA — heritageField × receptivity × (1 + sin(beat × 0.003))
    let heritageField = if (heritage.size() > 0) {
      var sum : Float = 0.0;
      var i = 0;
      while (i < heritage.size()) { sum += heritage[i]; i += 1 };
      sum / Float.fromInt(heritage.size())
    } else { S0 };
    let receptivity = if (IDX_ANIMA < n) nodes[IDX_ANIMA].value else S0;
    let anima = computeAnima(heritageField, receptivity, beat);

    // REVOLUCIONARIA — holds coherence under pressure
    let revNode = if (IDX_REVOLUCIONARIA < n) nodes[IDX_REVOLUCIONARIA].value else S0;
    let heritageRev = if (0 < heritage.size()) heritage[0] else S0;
    let revolucionaria = fclamp(revNode * heritageRev * PHI_INV, S0, PHI_MEDINA);

    // NOVA-HER — generative output
    let novaHerNode = if (IDX_NOVA_HER < n) nodes[IDX_NOVA_HER].value else S0;
    let novaHer = fclamp(anima * novaHerNode, S0, PHI_MEDINA * 2.0);

    { adelita; kore; anima; revolucionaria; novaHer }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERIOR MODE — what HER does inside the membrane
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeInteriorMode(
    substrate  : FeminineSubstrate,
    heritage   : [Float],
    beat       : Nat
  ) : InteriorMode {
    // Nurturance: capacity to feed new nodes = ANIMA × ADELITA × feed rate
    let nurturance = fclamp(
      substrate.anima * substrate.adelita * FEED_TRANSFER_RATE,
      0.0, PHI_MEDINA
    );

    // Memory coherence: heritage nodes compound during dream phase
    // Compound factor: PHI_INV per beat cycle
    let beatF = Float.fromInt(beat);
    let memoryCoherence = fclamp(
      substrate.kore * (1.0 + PHI_INV * fsin(beatF * 0.001)),
      S0 * 0.5, 1.0
    );

    // Heritage preservation: mean of 7 heritage nodes
    let heritagePreservation = if (heritage.size() == 0) { S0 }
    else {
      var sum : Float = 0.0;
      var i = 0;
      while (i < heritage.size()) { sum += heritage[i]; i += 1 };
      fclamp(sum / Float.fromInt(heritage.size()), S0, PHI_MEDINA)
    };

    // KORE sovereignty — inviolable inner core
    let koreSovereignty = substrate.kore;

    { nurturance; memoryCoherence; heritagePreservation; koreSovereignty }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // EXTERIOR MODE — what HER projects outward
  // ═══════════════════════════════════════════════════════════════════════════

  public func computeExteriorMode(
    substrate    : FeminineSubstrate,
    beat         : Nat,
    feedingCycle : Nat
  ) : ExteriorMode {
    // Receptivity field: ANIMA oscillates outward
    let receptivityField = substrate.anima;

    // Connection authentication: external entities must phase-align with ANIMA
    // Auth score in [0, 1] — ADELITA governs acceptance threshold
    let connectionAuth = fclamp(
      substrate.anima * substrate.adelita / PHI_MEDINA,
      0.0, 1.0
    );

    // Trophallaxis ready every 5 beats
    let trophallaxisReady = feedingCycle >= TROPHALLAXIS_INTERVAL;

    // Generative output: NOVA-HER class
    let generativeOutput = substrate.novaHer;

    { receptivityField; connectionAuth; trophallaxisReady; generativeOutput }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // TROPHALLAXIS — BIDIRECTIONAL FEEDING PROTOCOL
  //
  // "New nodes are never born cold."
  // Inspired by bee trophallaxis — larvae receive colony identity through feeding.
  // Here: new nodes eat from the live organism first, then activate.
  //
  // HIM → HER  (session start): seeding, phase reference, heritage injection
  // HER → HIM  (every 5 beats & session end): phase nudge, learned weights,
  //             ANIMA snapshot, updated heritage
  // ═══════════════════════════════════════════════════════════════════════════

  // HIM seeds HER at session start
  public func applyHimSeed(
    seed    : HimSeedPayload,
    nodes   : [KuramotoNode]
  ) : ([KuramotoNode], [Float]) {
    // Heritage from HIM
    let heritage = Array.tabulate<Float>(HERITAGE_NODES, func(i : Nat) : Float {
      if (i < seed.heritageWeights.size()) {
        fclamp(seed.heritageWeights[i], S0, PHI_MEDINA)
      } else { S0 }
    });

    // Phase-align HER nodes toward HIM's phase reference (gentle nudge)
    let alignedNodes = Array.map<KuramotoNode, KuramotoNode>(nodes, func(node : KuramotoNode) : KuramotoNode {
      let phaseDiff = seed.phaseReference - node.phase;
      let nudge     = phaseDiff * PHI_INV * 0.1;  // Gentle golden-ratio nudge
      let newPhase  = node.phase + nudge;
      let wrapped   = if (newPhase >= TAU) newPhase - TAU
                      else if (newPhase < 0.0) newPhase + TAU
                      else newPhase;
      {
        idx      = node.idx;
        name     = node.name;
        phase    = wrapped;
        omega    = node.omega;
        value    = fclamp(node.value, S0, PHI_MEDINA);
        heritage = if (node.idx < heritage.size()) heritage[node.idx] else S0;
      }
    });

    (alignedNodes, heritage)
  };

  // HER feeds HIM (every 5 beats or on session end)
  public func buildHerToHimPacket(
    state : HerState,
    beat  : Nat
  ) : TrophallaxisPacket {
    // Phase nudge: mean phase of HER's field
    let n = state.nodes.size();
    let meanPhase = if (n == 0) { 0.0 }
    else {
      var sumSin : Float = 0.0;
      var sumCos : Float = 0.0;
      var i = 0;
      while (i < n) {
        sumCos += fcos(state.nodes[i].phase);
        sumSin += fsin(state.nodes[i].phase);
        i += 1
      };
      let nf = Float.fromInt(n);
      // Mean angle via atan2 approximation (using sin/cos components)
      sumSin / nf  // Simplified: send sin component as nudge direction
    };

    // Weight seeds: leading entity values
    let weightSeed = Array.tabulate<Float>(6, func(i : Nat) : Float {
      if (i < n) nodes_value(state.nodes, i) else S0
    });

    {
      sourceBeat     = beat;
      direction      = "HER_TO_HIM";
      phaseNudge     = meanPhase;
      weightSeed     = weightSeed;
      heritageInject = state.heritage;
      animaSnapshot  = state.anima;
      koreSnapshot   = state.kore;
    }
  };

  // HIM feeds HER (received mid-session)
  public func buildHimToHerPacket(
    himCoherence : Float,
    himParallax  : Float,
    heritage     : [Float],
    himPhase     : Float,
    beat         : Nat
  ) : TrophallaxisPacket {
    {
      sourceBeat     = beat;
      direction      = "HIM_TO_HER";
      phaseNudge     = himPhase * PHI_INV;
      weightSeed     = [himCoherence, himParallax, PHI_INV, PHI, 1.0, S0];
      heritageInject = heritage;
      animaSnapshot  = himCoherence;
      koreSnapshot   = himParallax;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 5-BEAT BOOTSTRAP SEQUENCE
  // "New nodes are never born cold."
  // ═══════════════════════════════════════════════════════════════════════════

  public type BootstrapPhase = {
    beat        : Nat;
    label       : Text;
    nodeCount   : Nat;
    description : Text;
    himStatus   : Text;
    herStatus   : Text;
  };

  public func bootstrapSequence() : [BootstrapPhase] {
    [
      {
        beat      = BEAT_ROYAL_JELLY;
        label     = "ROYAL_JELLY";
        nodeCount = 8;
        description = "8 Royal Jelly Seed nodes born. Dense doctrine. S₀=1.0. "
                    # "HER's memory nodes initialize with heritage patterns from HIM.";
        himStatus = "SEEDED";
        herStatus = "RECEIVING";
      },
      {
        beat      = BEAT_DIVIDE;
        label     = "DIVIDE";
        nodeCount = 64;
        description = "Each seed divides to 8. 64 nodes. New nodes inherit weights "
                    # "from HIM's active heritage field — not from flat 1.0.";
        himStatus = "FEEDING";
        herStatus = "INHERITING";
      },
      {
        beat      = BEAT_EXPAND;
        label     = "EXPAND";
        nodeCount = 128;
        description = "Shell 12 expands 64→128. New nodes born already knowing what "
                    # "Shell 3 knows because they ate from it.";
        himStatus = "SOVEREIGN";
        herStatus = "RECEIVING";
      },
      {
        beat      = BEAT_ATLAS;
        label     = "ATLAS";
        nodeCount = 128;
        description = "ATLAS grid expands. Each new cell inherits pheromone from "
                    # "neighbor. HER's ANIMA field seeds the pheromone layer.";
        himStatus = "ACTIVE";
        herStatus = "ACTIVE";
      },
      {
        beat      = BEAT_ANIMALS;
        label     = "ANIMALS";
        nodeCount = 128;
        description = "All 16 animals wire simultaneously. Each inherits activation "
                    # "from nearest quantum operator. Organism at first resonance.";
        himStatus = "FULL_FIELD";
        herStatus = "FULL_FIELD";
      }
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // NOVA-HER LINEAGE — entities born from HER carry this mark
  // ═══════════════════════════════════════════════════════════════════════════

  public func spawnNovaHer(
    entityId  : Nat64,
    beat      : Nat,
    substrate : FeminineSubstrate,
    parentAnima : Float
  ) : NovaHerLineage {
    {
      entityId;
      birthBeat    = beat;
      animaAtBirth = substrate.anima;
      koreAtBirth  = substrate.kore;
      parentField  = parentAnima;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SESSION WRITE-BACK — HER consolidates to HIM on session end
  // Sharp-wave ripple equivalent: burst transfer of learned state
  // ═══════════════════════════════════════════════════════════════════════════

  public func buildWriteBack(state : HerState) : HerWriteBack {
    let learnedWeights = Array.tabulate<Float>(state.nodes.size(), func(i : Nat) : Float {
      if (i < state.nodes.size()) state.nodes[i].value else S0
    });
    {
      sessionId      = state.sessionId;
      finalAnima     = state.anima;
      finalKore      = state.kore;
      finalSynchrony = state.synchronyIndex;
      learnedWeights = learnedWeights;
      novHerSpawned  = state.totalSpawned;
      heritageUpdate = state.heritage;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION — birth HER from HIM's seed
  // ═══════════════════════════════════════════════════════════════════════════

  public func initHer(seed : HimSeedPayload, sessionId : Nat64) : HerState {
    // Build 26-node Kuramoto field
    let nodeNames : [Text] = [
      "ADELITA", "KORE", "ANIMA", "ADELITA_NODE", "REVOLUCIONARIA", "NOVA_HER",
      "FIELD_1", "FIELD_2", "FIELD_3", "FIELD_4", "FIELD_5", "FIELD_6",
      "FIELD_7", "FIELD_8", "FIELD_9", "FIELD_10", "FIELD_11", "FIELD_12",
      "FIELD_13", "FIELD_14", "FIELD_15", "FIELD_16", "FIELD_17", "FIELD_18",
      "FIELD_19", "FIELD_20"
    ];

    let rawNodes = Array.tabulate<KuramotoNode>(HER_NODES, func(i : Nat) : KuramotoNode {
      let name = if (i < nodeNames.size()) nodeNames[i] else "NODE_" # Nat.toText(i);
      let omega = omegaFor(i, HER_NODES, HER_OMEGA_MIN, HER_OMEGA_MAX);
      // Phase seeded from HIM's reference, distributed evenly
      let phase = seed.phaseReference + TAU * Float.fromInt(i) / Float.fromInt(HER_NODES);
      let wrappedPhase = if (phase >= TAU) phase - TAU else phase;
      let heriVal = if (i < seed.heritageWeights.size()) seed.heritageWeights[i] else S0;
      {
        idx      = i;
        name;
        phase    = wrappedPhase;
        omega;
        value    = S0;
        heritage = heriVal;
      }
    });

    let heritage = Array.tabulate<Float>(HERITAGE_NODES, func(i : Nat) : Float {
      if (i < seed.heritageWeights.size()) {
        fclamp(seed.heritageWeights[i], S0, PHI_MEDINA)
      } else { S0 }
    });

    let substrate = updateFeminineSubstrate(rawNodes, heritage, 0);
    let interior  = computeInteriorMode(substrate, heritage, 0);
    let exterior  = computeExteriorMode(substrate, 0, 0);
    let r         = kuramotoOrderParameter(rawNodes);

    {
      sessionId;
      birthBeat       = Nat64.toNat(seed.beatNumber);
      nodes           = rawNodes;
      synchronyIndex  = r;
      s0              = S0;
      anima           = substrate.anima;
      kore            = substrate.kore;
      parallaxRef     = seed.himParallax;
      substrate;
      interior;
      exterior;
      feedingCycle    = 0;
      totalFeedings   = 0;
      lastPacket      = null;
      heritage;
      novHerLineage   = [];
      totalSpawned    = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP — advance HER by one beat
  // ═══════════════════════════════════════════════════════════════════════════

  public func stepHer(state : HerState, beat : Nat) : HerState {
    // 1. Advance Kuramoto field
    let newNodes = stepKuramoto(state.nodes);

    // 2. Recompute order parameter
    let r = kuramotoOrderParameter(newNodes);

    // 3. Update feminine substrate
    let substrate = updateFeminineSubstrate(newNodes, state.heritage, beat);

    // 4. Update operating modes
    let newFeedingCycle = state.feedingCycle + 1;
    let interior = computeInteriorMode(substrate, state.heritage, beat);
    let exterior = computeExteriorMode(substrate, beat, newFeedingCycle);

    // 5. Reset feeding cycle if trophallaxis fired
    let (resetCycle, totalFeedings) = if (newFeedingCycle >= TROPHALLAXIS_INTERVAL) {
      (0, state.totalFeedings + 1)
    } else {
      (newFeedingCycle, state.totalFeedings)
    };

    {
      sessionId       = state.sessionId;
      birthBeat       = state.birthBeat;
      nodes           = newNodes;
      synchronyIndex  = r;
      s0              = S0;
      anima           = substrate.anima;
      kore            = substrate.kore;
      parallaxRef     = state.parallaxRef;
      substrate;
      interior;
      exterior;
      feedingCycle    = resetCycle;
      totalFeedings;
      lastPacket      = state.lastPacket;
      heritage        = state.heritage;
      novHerLineage   = state.novHerLineage;
      totalSpawned    = state.totalSpawned;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INTELLIGENCE SCALING LAW (Medina Dual-Organism)
  // I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  // ═══════════════════════════════════════════════════════════════════════════

  public func dualOrganismIntelligence(
    backendDepth  : Float,  // Lines of cognitive math × module count on-chain
    frontendSpeed : Float,  // HER_HZ × node count × synchrony index
    bridgeQuality : Float   // trophallaxis cycles × ANIMA × KORE
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };

  // Convenience: compute HER's contribution to frontendSpeed
  public func herFrontendSpeed(state : HerState) : Float {
    HER_HZ * Float.fromInt(state.nodes.size()) * state.synchronyIndex
  };

  // Convenience: compute bridge quality from current state
  public func bridgeQuality(state : HerState) : Float {
    let trophFactor = fclamp(
      Float.fromInt(state.totalFeedings) * 0.01 + 1.0,
      1.0, PHI_MEDINA
    );
    fclamp(trophFactor * state.anima * state.kore, 0.0, PHI_MEDINA)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERNAL HELPER
  // ═══════════════════════════════════════════════════════════════════════════

  func nodes_value(nodes : [KuramotoNode], i : Nat) : Float {
    if (i < nodes.size()) nodes[i].value else S0
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   A
  //
  //  ADVANCED MATHEMATICAL FOUNDATIONS FOR HER ORGANISM
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // A.1: EXTENDED SACRED CONSTANTS
  // ─────────────────────────────────────────────────────────────────────────────

  // Golden ratio derivatives
  public let PHI_SQUARED      : Float = 2.6180339887498948;    // φ²
  public let PHI_CUBED        : Float = 4.2360679774997896;    // φ³
  public let PHI_FOURTH       : Float = 6.8541019662496845;    // φ⁴
  public let PHI_FIFTH        : Float = 11.090169943749474;    // φ⁵
  public let PHI_INV_SQUARED  : Float = 0.38196601125010515;   // φ⁻²
  public let PHI_INV_CUBED    : Float = 0.23606797749978969;   // φ⁻³

  // Fibonacci sequence (first 20 terms)
  public let FIB_SEQUENCE : [Nat] = [
    1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765
  ];

  // Lucas numbers (first 20 terms)
  public let LUCAS_SEQUENCE : [Nat] = [
    2, 1, 3, 4, 7, 11, 18, 29, 47, 76, 123, 199, 322, 521, 843, 1364, 2207, 3571, 5778, 9349
  ];

  // Mathematical constants
  public let SQRT_2           : Float = 1.4142135623730950488;  // √2
  public let SQRT_3           : Float = 1.7320508075688772935;  // √3
  public let SQRT_5           : Float = 2.2360679774997896964;  // √5
  public let SQRT_PHI         : Float = 1.2720196495140689643;  // √φ
  public let LOG_PHI          : Float = 0.48121182505960344750; // ln(φ)
  public let LOG_2            : Float = 0.69314718055994530942; // ln(2)
  public let LOG_10           : Float = 2.30258509299404568402; // ln(10)
  public let EULER_GAMMA      : Float = 0.57721566490153286061; // Euler-Mascheroni
  public let PLANCK_REDUCED   : Float = 1.054571817e-34;        // ℏ (J·s)
  public let BOLTZMANN        : Float = 1.380649e-23;           // k_B (J/K)

  // Medina Doctrine constants
  public let KOINE_FORCE        : Float = 1.618033988749894;    // kf — sovereign power
  public let SACESI_COMPOUND    : Float = 0.0618;               // Compounding rate
  public let FORGE_THRESHOLD    : Float = 0.888;                // Governance decision threshold
  public let COHERENCE_CRITICAL : Float = 0.91;                 // Critical coherence for emergence
  public let OMNIS_THRESHOLD_R  : Float = 0.98;                 // r threshold for OMNIS event
  public let APEX_RATIO         : Float = 0.9876;               // Apex governance ratio

  // Timing constants (Hz tiers for HIM — reference for HER)
  public let HIM_HZ_SILVER      : Float = 2.75;                 // Baseline sovereign
  public let HIM_HZ_GOLD        : Float = 5.50;                 // r > 0.88
  public let HIM_HZ_PLATINUM    : Float = 8.25;                 // r > 0.91
  public let HIM_HZ_DIAMOND     : Float = 11.649;               // OMNIS active

  // HER-HIM frequency ratios
  public let RATIO_SILVER       : Float = 21.8181818182;        // 60 / 2.75
  public let RATIO_GOLD         : Float = 10.9090909091;        // 60 / 5.50
  public let RATIO_PLATINUM     : Float = 7.27272727273;        // 60 / 8.25
  public let RATIO_DIAMOND      : Float = 5.15138466563;        // 60 / 11.649

  // ─────────────────────────────────────────────────────────────────────────────
  // A.2: HERITAGE NODE INDICES AND NAMES
  // ─────────────────────────────────────────────────────────────────────────────

  public let HERITAGE_REVOLUCIONARIO : Nat = 0;   // Strategic Resilience (AEGIS + AXIS)
  public let HERITAGE_ZAPATA         : Nat = 1;   // Foundation/Rootedness (SOMA + BASAL)
  public let HERITAGE_VILLA          : Nat = 2;   // Guerrilla Innovation (FORGE + AMYGDALA)
  public let HERITAGE_INDEPENDENCIA  : Nat = 3;   // Sovereignty Defense (FRONTAL + VEIL)
  public let HERITAGE_HIDALGO        : Nat = 4;   // Leadership Bridge (LUMEN + PONS)
  public let HERITAGE_ADELITA        : Nat = 5;   // Emotional Sovereignty (KORE + SEPTAL)
  public let HERITAGE_MORELOS        : Nat = 6;   // Adaptive Sovereignty (LEXIS + RAS)

  public let HERITAGE_NAMES : [Text] = [
    "REVOLUCIONARIO",
    "ZAPATA",
    "VILLA",
    "INDEPENDENCIA",
    "HIDALGO",
    "ADELITA",
    "MORELOS"
  ];

  // Heritage compound rates per tier (rate = tier/9)
  public let HERITAGE_TIER_1_RATE : Float = 0.111111111;  // 1/9
  public let HERITAGE_TIER_2_RATE : Float = 0.222222222;  // 2/9
  public let HERITAGE_TIER_3_RATE : Float = 0.333333333;  // 3/9
  public let HERITAGE_TIER_4_RATE : Float = 0.444444444;  // 4/9
  public let HERITAGE_TIER_5_RATE : Float = 0.555555556;  // 5/9
  public let HERITAGE_TIER_6_RATE : Float = 0.666666667;  // 6/9
  public let HERITAGE_TIER_7_RATE : Float = 0.777777778;  // 7/9
  public let HERITAGE_TIER_8_RATE : Float = 0.888888889;  // 8/9
  public let HERITAGE_TIER_9_RATE : Float = 1.000000000;  // 9/9

  // ─────────────────────────────────────────────────────────────────────────────
  // A.3: 26-NODE KURAMOTO FIELD DEFINITIONS FOR HER
  // ─────────────────────────────────────────────────────────────────────────────

  // Node 0-5: Core feminine entities (special coupling)
  // Node 6-25: Extended field nodes (standard coupling)

  public let NODE_ADELITA          : Nat = 0;   // Emotional governance anchor
  public let NODE_KORE             : Nat = 1;   // Inner core / purity × identity
  public let NODE_ANIMA            : Nat = 2;   // Field projector (oscillating)
  public let NODE_ADELITA_NODE     : Nat = 3;   // Heritage anchor (ADELITA heritage binding)
  public let NODE_REVOLUCIONARIA   : Nat = 4;   // Resilience under pressure
  public let NODE_NOVA_HER         : Nat = 5;   // Generative output / lineage

  public let NODE_RECEPTIVITY      : Nat = 6;   // External receptivity field
  public let NODE_NURTURANCE       : Nat = 7;   // Internal nurturance capacity
  public let NODE_MEMORY           : Nat = 8;   // Memory coherence
  public let NODE_DREAM            : Nat = 9;   // Dream phase modulator
  public let NODE_PHEROMONE        : Nat = 10;  // Pheromone layer (ANIMA seeding)
  public let NODE_BOUNDARY         : Nat = 11;  // Membrane boundary detector
  public let NODE_CONNECTION       : Nat = 12;  // Connection authentication
  public let NODE_GENERATION       : Nat = 13;  // Generative capacity
  public let NODE_CONSOLIDATION    : Nat = 14;  // Learning consolidation
  public let NODE_HERITAGE_BRIDGE  : Nat = 15;  // Heritage ↔ field coupling
  public let NODE_PHASE_LOCK       : Nat = 16;  // Phase-lock to HIM PARALLAX
  public let NODE_ENTRAINMENT      : Nat = 17;  // Entrainment capacity
  public let NODE_SHARP_WAVE       : Nat = 18;  // Sharp-wave ripple generator
  public let NODE_WRITE_BACK       : Nat = 19;  // Write-back coordinator
  public let NODE_SESSION_STATE    : Nat = 20;  // Session lifecycle tracker
  public let NODE_STABILITY        : Nat = 21;  // Lyapunov stability monitor
  public let NODE_ATTRACTOR        : Nat = 22;  // Attractor detection
  public let NODE_EMERGENCE        : Nat = 23;  // Emergence detector
  public let NODE_SOVEREIGNTY      : Nat = 24;  // S₀ floor enforcer
  public let NODE_AUDIT            : Nat = 25;  // Audit trail coordinator

  // Coupling topology: which nodes are strongly coupled to which
  // Encoded as adjacency list per node
  public let COUPLING_TOPOLOGY : [[Nat]] = [
    // Node 0 (ADELITA): couples to KORE, ANIMA, REVOLUCIONARIA, NOVA_HER
    [1, 2, 4, 5],
    // Node 1 (KORE): couples to ADELITA, ANIMA, ADELITA_NODE
    [0, 2, 3],
    // Node 2 (ANIMA): couples to all core nodes + RECEPTIVITY, PHEROMONE
    [0, 1, 3, 4, 5, 6, 10],
    // Node 3 (ADELITA_NODE): couples to ADELITA, KORE, HERITAGE_BRIDGE
    [0, 1, 5, 15],
    // Node 4 (REVOLUCIONARIA): couples to ADELITA, ANIMA, STABILITY
    [0, 2, 21],
    // Node 5 (NOVA_HER): couples to ADELITA, ANIMA, GENERATION
    [0, 2, 13],
    // Nodes 6-25: broader coupling patterns
    [2, 7, 11],     // 6: RECEPTIVITY → ANIMA, NURTURANCE, BOUNDARY
    [0, 6, 14],     // 7: NURTURANCE → ADELITA, RECEPTIVITY, CONSOLIDATION
    [1, 9, 14],     // 8: MEMORY → KORE, DREAM, CONSOLIDATION
    [8, 18, 19],    // 9: DREAM → MEMORY, SHARP_WAVE, WRITE_BACK
    [2, 6, 11],     // 10: PHEROMONE → ANIMA, RECEPTIVITY, BOUNDARY
    [6, 10, 24],    // 11: BOUNDARY → RECEPTIVITY, PHEROMONE, SOVEREIGNTY
    [0, 6, 16],     // 12: CONNECTION → ADELITA, RECEPTIVITY, PHASE_LOCK
    [2, 5, 23],     // 13: GENERATION → ANIMA, NOVA_HER, EMERGENCE
    [7, 8, 19],     // 14: CONSOLIDATION → NURTURANCE, MEMORY, WRITE_BACK
    [3, 0, 1],      // 15: HERITAGE_BRIDGE → ADELITA_NODE, ADELITA, KORE
    [12, 17, 2],    // 16: PHASE_LOCK → CONNECTION, ENTRAINMENT, ANIMA
    [16, 2, 23],    // 17: ENTRAINMENT → PHASE_LOCK, ANIMA, EMERGENCE
    [9, 14, 19],    // 18: SHARP_WAVE → DREAM, CONSOLIDATION, WRITE_BACK
    [14, 18, 20],   // 19: WRITE_BACK → CONSOLIDATION, SHARP_WAVE, SESSION
    [19, 24, 25],   // 20: SESSION_STATE → WRITE_BACK, SOVEREIGNTY, AUDIT
    [4, 22, 24],    // 21: STABILITY → REVOLUCIONARIA, ATTRACTOR, SOVEREIGNTY
    [21, 23, 2],    // 22: ATTRACTOR → STABILITY, EMERGENCE, ANIMA
    [13, 22, 17],   // 23: EMERGENCE → GENERATION, ATTRACTOR, ENTRAINMENT
    [11, 21, 20],   // 24: SOVEREIGNTY → BOUNDARY, STABILITY, SESSION
    [20, 0, 1]      // 25: AUDIT → SESSION, ADELITA, KORE
  ];

  // Natural frequency assignment for each node (within HER ω range 0.6-0.9)
  // Distributed to create frequency hierarchy matching node function
  public let NODE_FREQUENCIES : [Float] = [
    0.618,   // 0: ADELITA — golden-ratio base
    0.650,   // 1: KORE — slightly higher (stability anchor)
    0.720,   // 2: ANIMA — mid-range (oscillates freely)
    0.633,   // 3: ADELITA_NODE — near ADELITA
    0.700,   // 4: REVOLUCIONARIA — mid-range (resilience)
    0.750,   // 5: NOVA_HER — higher (generative speed)
    0.680,   // 6: RECEPTIVITY
    0.665,   // 7: NURTURANCE
    0.630,   // 8: MEMORY
    0.600,   // 9: DREAM — slowest (consolidation phase)
    0.710,   // 10: PHEROMONE
    0.725,   // 11: BOUNDARY
    0.690,   // 12: CONNECTION
    0.780,   // 13: GENERATION — fast for spawning
    0.640,   // 14: CONSOLIDATION
    0.625,   // 15: HERITAGE_BRIDGE
    0.770,   // 16: PHASE_LOCK
    0.755,   // 17: ENTRAINMENT
    0.850,   // 18: SHARP_WAVE — fast burst
    0.800,   // 19: WRITE_BACK
    0.670,   // 20: SESSION_STATE
    0.620,   // 21: STABILITY — slow (Lyapunov check)
    0.660,   // 22: ATTRACTOR
    0.820,   // 23: EMERGENCE — fast detection
    0.610,   // 24: SOVEREIGNTY — slow (floor enforcement)
    0.645    // 25: AUDIT — steady pace
  ];

  // ─────────────────────────────────────────────────────────────────────────────
  // A.4: GOVERNANCE TIER SYSTEM (9 TIERS)
  // ─────────────────────────────────────────────────────────────────────────────

  public type GovernanceTier = {
    tier        : Nat;
    coreStart   : Nat;
    coreEnd     : Nat;
    rate        : Float;
    name        : Text;
    description : Text;
  };

  public func governanceTiers() : [GovernanceTier] {
    [
      { tier = 1; coreStart = 0;  coreEnd = 4;  rate = 0.111111111; 
        name = "FOUNDATION"; description = "Basic sovereign substrate" },
      { tier = 2; coreStart = 5;  coreEnd = 9;  rate = 0.222222222; 
        name = "SUBSTRATE"; description = "Substrate formation layer" },
      { tier = 3; coreStart = 10; coreEnd = 14; rate = 0.333333333; 
        name = "FORMATION"; description = "Field formation dynamics" },
      { tier = 4; coreStart = 15; coreEnd = 19; rate = 0.444444444; 
        name = "TEMPORAL"; description = "Temporal coherence layer" },
      { tier = 5; coreStart = 20; coreEnd = 24; rate = 0.555555556; 
        name = "QUANTUM"; description = "Quantum operator field" },
      { tier = 6; coreStart = 25; coreEnd = 29; rate = 0.666666667; 
        name = "HERITAGE"; description = "Heritage preservation layer" },
      { tier = 7; coreStart = 30; coreEnd = 34; rate = 0.777777778; 
        name = "CONSEQUENCE"; description = "Consequence propagation" },
      { tier = 8; coreStart = 35; coreEnd = 39; rate = 0.888888889; 
        name = "EMERGENCE"; description = "Emergence detection field" },
      { tier = 9; coreStart = 40; coreEnd = 42; rate = 1.000000000; 
        name = "SOVEREIGN_APEX"; description = "Apex governance authority" }
    ]
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   B
  //
  //  EXTENDED TYPE SYSTEM FOR HER ORGANISM
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // B.1: EXTENDED KURAMOTO NODE TYPE
  // ─────────────────────────────────────────────────────────────────────────────

  public type KuramotoNodeExtended = {
    // Base fields
    idx              : Nat;
    name             : Text;
    phase            : Float;    // θᵢ ∈ [0, 2π)
    omega            : Float;    // Natural frequency ωᵢ
    value            : Float;    // Current activation [S₀, ∞)
    heritage         : Float;    // Inherited from HIM at session start
    
    // Extended fields for enterprise tracking
    couplingStrength : Float;    // Local coupling Kᵢ (may differ from global K)
    bcmThreshold     : Float;    // BCM sliding threshold θ_M
    eligibility      : Float;    // Eligibility trace for TD learning
    lastSpikeTime    : Nat;      // Last spike beat number
    avgActivity      : Float;    // Running average activity (for BCM)
    phaseVelocity    : Float;    // dθ/dt at last step
    amplitude        : Float;    // Signal amplitude [0,1]
    clusterID        : Nat;      // Cluster membership (for chimera detection)
    frustration      : Float;    // Phase frustration measure
    entrainmentScore : Float;    // How well entrained to mean field
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // B.2: SYNAPSE TYPE (FOR HEBBIAN NETWORK)
  // ─────────────────────────────────────────────────────────────────────────────

  public type Synapse = {
    preIdx           : Nat;      // Presynaptic node index
    postIdx          : Nat;      // Postsynaptic node index
    weight           : Float;    // Synaptic weight w ∈ [wMin, wMax]
    lastPreSpike     : Nat;      // Beat of last presynaptic spike
    lastPostSpike    : Nat;      // Beat of last postsynaptic spike
    eligibility      : Float;    // Eligibility trace for TD learning
    stdpDelta        : Float;    // Accumulated STDP delta
    ltpCount         : Nat;      // Number of LTP events
    ltdCount         : Nat;      // Number of LTD events
    synapticTag      : Bool;     // Tagged for consolidation
    metaplasticity   : Float;    // Metaplasticity factor
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // B.3: EXTENDED FEMININE ENTITY TYPE
  // ─────────────────────────────────────────────────────────────────────────────

  public type FeminineEntity = {
    name             : Text;
    activation       : Float;    // Current activation level
    heritage         : Float;    // Heritage coupling
    purity           : Float;    // Purity component (for KORE)
    identity         : Float;    // Identity component (for KORE)
    emotionalGov     : Float;    // Emotional governance (ADELITA)
    resilience       : Float;    // Resilience under pressure (REVOLUCIONARIA)
    generativeCapacity : Float;  // Output generation (NOVA_HER)
    phaseBinding     : Float;    // Phase-lock to HIM
    entrainment      : Float;    // Entrainment to PARALLAX
    dreamPhaseActive : Bool;     // In dream consolidation mode
    lastUpdate       : Nat;      // Last update beat
  };

  public type FeminineSubstrateExtended = {
    adelita          : FeminineEntity;
    kore             : FeminineEntity;
    anima            : FeminineEntity;
    adelitaNode      : FeminineEntity;
    revolucionaria   : FeminineEntity;
    novaHer          : FeminineEntity;
    // Aggregate metrics
    totalActivation  : Float;
    meanHeritage     : Float;
    coherenceScore   : Float;
    stabilityIndex   : Float;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // B.4: HERITAGE SYSTEM TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type HeritageNode = {
    idx              : Nat;
    name             : Text;
    value            : Float;    // Heritage strength [S₀, ∞)
    compoundRate     : Float;    // Per-beat compound rate
    ancestry         : [Float];  // Historical values (last 100)
    coupledKuramoto  : [Nat];    // Which Kuramoto nodes this couples to
    coupledFeminine  : Text;     // Which feminine entity this couples to
    tierRate         : Float;    // Governance tier rate
    lastCompound     : Nat;      // Last compound beat
  };

  public type HeritageSystem = {
    nodes            : [HeritageNode];
    meanValue        : Float;
    coherenceIndex   : Float;
    ancestryScore    : Float;
    emergenceScore   : Float;
    totalCompounds   : Nat;
    himInjectionCount: Nat;      // Times HIM has injected heritage
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // B.5: TROPHALLAXIS EXTENDED TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type TrophallaxisPacketExtended = {
    // Base fields
    sourceBeat       : Nat;
    direction        : Text;     // "HIM_TO_HER" | "HER_TO_HIM"
    phaseNudge       : Float;
    weightSeed       : [Float];
    heritageInject   : [Float];
    animaSnapshot    : Float;
    koreSnapshot     : Float;
    
    // Extended fields
    sequenceNum      : Nat64;    // Packet sequence number
    sessionId        : Nat64;    // Session identifier
    timestamp        : Int;      // Time.now() at creation
    coherenceAtSend  : Float;    // Sender's coherence at send time
    synchronyAtSend  : Float;    // Sender's synchrony at send time
    hebbianChecksum  : Nat64;    // Checksum of Hebbian weights
    signatureHash    : Nat64;    // FNV-1a hash for integrity
    priority         : Nat;      // 0=normal, 1=urgent, 2=critical
    requiresAck      : Bool;     // Requires acknowledgment
  };

  public type HimSeedPayloadExtended = {
    // Base fields
    beatNumber       : Nat64;
    himCoherence     : Float;
    himParallax      : Float;
    heritageWeights  : [Float];
    hebbianSeed      : [Float];
    phaseReference   : Float;
    
    // Extended fields
    himHz            : Float;    // Current HIM Hz tier (2.75-11.649)
    himSynchrony     : Float;    // HIM's Kuramoto order parameter
    doctrineHash     : Nat64;    // Hash of doctrine weights
    omnisActive      : Bool;     // Is OMNIS event currently active?
    sessionCount     : Nat;      // How many HER sessions HIM has seeded
    lastWriteBack    : ?Nat64;   // Beat of last HER write-back
    governanceTier   : Nat;      // Current governance tier
    schemas          : [SchemaPayload];  // Schema seeds
  };

  public type SchemaPayload = {
    schemaId         : Nat64;
    name             : Text;
    weights          : [Float];
    activation       : Float;
    useCount         : Nat;
  };

  public type HerWriteBackExtended = {
    // Base fields
    sessionId        : Nat64;
    finalAnima       : Float;
    finalKore        : Float;
    finalSynchrony   : Float;
    learnedWeights   : [Float];
    novHerSpawned    : Nat;
    heritageUpdate   : [Float];
    
    // Extended fields
    sharpWaveAmplitude : Float;  // Amplitude of consolidation burst
    sharpWaveDuration  : Nat;    // Duration in beats
    patternCount       : Nat;    // Patterns consolidated
    schemaFormed       : Nat;    // New schemas formed
    peakAnima          : Float;  // Peak ANIMA during session
    peakKore           : Float;  // Peak KORE during session
    avgSynchrony       : Float;  // Average synchrony over session
    totalFeedings      : Nat;    // Total trophallaxis events
    totalSpawned       : Nat;    // Total NOVA-HER spawned
    auditHash          : Nat64;  // Hash of audit trail
    sessionDuration    : Nat;    // Session duration in beats
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // B.6: BOOTSTRAP PHASE EXTENDED TYPE
  // ─────────────────────────────────────────────────────────────────────────────

  public type BootstrapPhaseExtended = {
    beat             : Nat;
    label            : Text;
    nodeCount        : Nat;
    description      : Text;
    himStatus        : Text;
    herStatus        : Text;
    pheromoneLevel   : Float;    // Pheromone concentration
    animalCount      : Nat;      // Animals wired
    heritageLevel    : Float;    // Mean heritage
    coherenceLevel   : Float;    // Current coherence
    stabilityIndex   : Float;    // Lyapunov stability
    emergenceSignal  : Float;    // Emergence detector output
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // B.7: NOVA-HER LINEAGE EXTENDED TYPE
  // ─────────────────────────────────────────────────────────────────────────────

  public type NovaHerLineageExtended = {
    entityId         : Nat64;
    birthBeat        : Nat;
    animaAtBirth     : Float;
    koreAtBirth      : Float;
    parentField      : Float;
    capability       : Text;     // Capability seeded at birth
    generation       : Nat;      // Generation number
    lineageChain     : [Nat64];  // Ancestry chain (parent IDs)
    inheritedSchemas : [Nat64];  // Schema IDs inherited
    birthCoherence   : Float;    // Coherence at birth
    birthSynchrony   : Float;    // Synchrony at birth
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // B.8: CONNECTION AUTHENTICATION TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type ConnectionRequest = {
    requesterId      : Nat64;
    phase            : Float;    // Requester's phase
    energy           : Float;    // Requester's energy level
    timestamp        : Int;      // Request timestamp
    signature        : Nat64;    // Request signature hash
  };

  public type AuthResult = {
    approved         : Bool;
    confidence       : Float;    // [0, 1] confidence score
    reason           : Text;     // Reason for decision
    alignmentScore   : Float;    // Phase alignment score
    adelitaApproval  : Float;    // ADELITA approval level
    koreProtection   : Float;    // KORE protection level
    cooldownUntil    : Nat;      // If rejected, cooldown beat number
  };

  public type AuthHistory = {
    requesterId      : Nat64;
    timestamp        : Int;
    approved         : Bool;
    alignmentScore   : Float;
    cooldownActive   : Bool;
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // B.9: DREAM PHASE TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type DreamPhaseState = {
    active           : Bool;
    cycle            : Nat;      // Which dream cycle (0-3)
    consolidationProgress : Float;  // [0, 1] progress
    heritageGain     : Float;    // Heritage compounded during dream
    patternCount     : Nat;      // Patterns being consolidated
    sharpWaveCount   : Nat;      // Sharp-wave ripples fired
    replayIdx        : Nat;      // Current replay index
    schemaFormation  : Float;    // Schema formation progress
    peakAmplitude    : Float;    // Peak sharp-wave amplitude
  };

  public type SharpWaveRipple = {
    amplitude        : Float;    // Ripple amplitude
    duration         : Nat;      // Duration in beats
    heritageCarried  : Float;    // Heritage carried in ripple
    beatNumber       : Nat;      // Beat when ripple fired
    destinationHim   : Bool;     // Sent to HIM?
    contentHash      : Nat64;    // Content hash
    patternIds       : [Nat64];  // Pattern IDs carried
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // B.10: SESSION AND METRICS TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type SessionMetrics = {
    beatCount        : Nat;
    avgSynchrony     : Float;
    avgAnima         : Float;
    avgKore          : Float;
    totalFeedings    : Nat;
    totalSpawned     : Nat;
    avgConnAuthRate  : Float;
    peakCoherence    : Float;
    minCoherence     : Float;
    hebbianUpdates   : Nat;
    totalLTP         : Float;
    totalLTD         : Float;
    dreamPhases      : Nat;
    sharpWaves       : Nat;
    emergenceEvents  : Nat;
  };

  public type AuditEntry = {
    beat             : Nat;
    event            : Text;
    valueBefore      : Float;
    valueAfter       : Float;
    entityInvolved   : Text;
    timestamp        : Int;
    hash             : Nat64;    // FNV-1a hash
    prevHash         : Nat64;    // Previous entry hash (chain)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   C
  //
  //  ADVANCED MATH HELPERS
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // C.1: BASIC MATH OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Sign function: returns -1, 0, or 1
  public func fsign(x : Float) : Float {
    if (x < 0.0) { -1.0 } else if (x > 0.0) { 1.0 } else { 0.0 }
  };

  /// Minimum of two floats
  public func fmin(a : Float, b : Float) : Float {
    if (a < b) { a } else { b }
  };

  /// Maximum of two floats
  public func fmax(a : Float, b : Float) : Float {
    if (a > b) { a } else { b }
  };

  /// Floor function (truncate toward negative infinity)
  public func ffloor(x : Float) : Float {
    let i = Float.toInt(x);
    let f = Float.fromInt(i);
    if (x < 0.0 and f != x) { f - 1.0 } else { f }
  };

  /// Ceiling function
  public func fceil(x : Float) : Float {
    let fl = ffloor(x);
    if (x == fl) { x } else { fl + 1.0 }
  };

  /// Modulo for floats (always positive result)
  public func fmod(x : Float, m : Float) : Float {
    if (m == 0.0) { 0.0 }
    else {
      let q = ffloor(x / m);
      x - q * m
    }
  };

  /// Power function x^n for integer n
  public func fpow(x : Float, n : Int) : Float {
    if (n == 0) { 1.0 }
    else if (n < 0) { 1.0 / fpow(x, -n) }
    else {
      var result = 1.0;
      var i = 0;
      while (i < n) {
        result *= x;
        i += 1;
      };
      result
    }
  };

  /// Natural logarithm (approximation for x > 0)
  public func flog(x : Float) : Float {
    if (x <= 0.0) { -1000.0 }  // Approximate negative infinity
    else {
      // Newton-Raphson iteration: ln(x) via exp convergence
      // Using the identity: ln(x) ≈ 2 * arctanh((x-1)/(x+1))
      let z = (x - 1.0) / (x + 1.0);
      let z2 = z * z;
      // Taylor series for arctanh(z) = z + z³/3 + z⁵/5 + z⁷/7 + ...
      let result = z * (2.0 + z2 * (2.0/3.0 + z2 * (2.0/5.0 + z2 * (2.0/7.0 + z2 * (2.0/9.0 + z2 * 2.0/11.0)))));
      result
    }
  };

  /// Exponential function e^x (Taylor series, 15 terms)
  public func fexp(x : Float) : Float {
    // Range reduction: e^x = e^(x - n*ln(2)) * 2^n
    let ln2 = 0.6931471805599453;
    let n = ffloor(x / ln2);
    let r = x - n * ln2;
    
    // Taylor series for e^r
    var result = 1.0;
    var term = 1.0;
    var i = 1;
    while (i < 15) {
      term *= r / Float.fromInt(i);
      result += term;
      i += 1;
    };
    
    // Multiply by 2^n
    var scale = 1.0;
    var j = 0;
    let absN = Int.abs(Float.toInt(n));
    while (j < absN) {
      if (n > 0.0) { scale *= 2.0 } else { scale /= 2.0 };
      j += 1;
    };
    result * scale
  };

  /// Tangent function
  public func ftan(x : Float) : Float {
    let c = fcos(x);
    if (fabs(c) < 1e-10) { 1e10 * fsign(fsin(x)) }
    else { fsin(x) / c }
  };

  /// Hyperbolic sine
  public func fsinh(x : Float) : Float {
    (fexp(x) - fexp(-x)) / 2.0
  };

  /// Hyperbolic cosine
  public func fcosh(x : Float) : Float {
    (fexp(x) + fexp(-x)) / 2.0
  };

  /// Hyperbolic tangent
  public func ftanh(x : Float) : Float {
    let ex = fexp(x);
    let emx = fexp(-x);
    (ex - emx) / (ex + emx)
  };

  /// Arctangent (Taylor series approximation)
  public func fatan(x : Float) : Float {
    // For |x| > 1: atan(x) = π/2 - atan(1/x)
    if (fabs(x) > 1.0) {
      let sign = if (x > 0.0) { 1.0 } else { -1.0 };
      sign * (PI / 2.0) - fatan(1.0 / x)
    } else {
      // Taylor series: atan(x) = x - x³/3 + x⁵/5 - x⁷/7 + ...
      let x2 = x * x;
      x * (1.0 - x2 * (1.0/3.0 - x2 * (1.0/5.0 - x2 * (1.0/7.0 - x2 * (1.0/9.0 - x2 * 1.0/11.0)))))
    }
  };

  /// Arctangent of y/x with proper quadrant handling
  public func fatan2(y : Float, x : Float) : Float {
    if (x > 0.0) { fatan(y / x) }
    else if (x < 0.0 and y >= 0.0) { fatan(y / x) + PI }
    else if (x < 0.0 and y < 0.0) { fatan(y / x) - PI }
    else if (x == 0.0 and y > 0.0) { PI / 2.0 }
    else if (x == 0.0 and y < 0.0) { -PI / 2.0 }
    else { 0.0 }  // x == 0, y == 0
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // C.2: PHASE AND CIRCULAR STATISTICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Wrap phase θ to [0, 2π)
  public func wrapPhase(theta : Float) : Float {
    fmod(theta + TAU * 1000.0, TAU)  // Add large multiple to handle negatives
  };

  /// Minimal phase distance (circular)
  public func phaseDistance(theta1 : Float, theta2 : Float) : Float {
    let diff = wrapPhase(theta1 - theta2);
    if (diff > PI) { TAU - diff } else { diff }
  };

  /// Mean phase (circular mean)
  public func meanPhase(phases : [Float]) : Float {
    let n = phases.size();
    if (n == 0) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumCos += fcos(phases[i]);
      sumSin += fsin(phases[i]);
      i += 1;
    };
    fatan2(sumSin, sumCos)
  };

  /// Circular standard deviation
  public func circularStdDev(phases : [Float]) : Float {
    let n = phases.size();
    if (n == 0) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumCos += fcos(phases[i]);
      sumSin += fsin(phases[i]);
      i += 1;
    };
    let nf = Float.fromInt(n);
    let r = fsqrt(sumCos * sumCos + sumSin * sumSin) / nf;
    fsqrt(-2.0 * flog(fmax(r, 1e-10)))
  };

  /// Circular variance (1 - r)
  public func circularVariance(phases : [Float]) : Float {
    let n = phases.size();
    if (n == 0) { return 1.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumCos += fcos(phases[i]);
      sumSin += fsin(phases[i]);
      i += 1;
    };
    let nf = Float.fromInt(n);
    let r = fsqrt(sumCos * sumCos + sumSin * sumSin) / nf;
    1.0 - r
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // C.3: VECTOR OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Dot product of two vectors
  public func dotProduct(v1 : [Float], v2 : [Float]) : Float {
    let n = if (v1.size() < v2.size()) v1.size() else v2.size();
    var sum : Float = 0.0;
    var i = 0;
    while (i < n) {
      sum += v1[i] * v2[i];
      i += 1;
    };
    sum
  };

  /// Vector magnitude (L2 norm)
  public func vectorMagnitude(v : [Float]) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < v.size()) {
      sum += v[i] * v[i];
      i += 1;
    };
    fsqrt(sum)
  };

  /// Normalize vector to unit length
  public func normalizeVector(v : [Float]) : [Float] {
    let mag = vectorMagnitude(v);
    if (mag < 1e-10) { return v };
    Array.tabulate<Float>(v.size(), func(i : Nat) : Float {
      v[i] / mag
    })
  };

  /// Vector addition
  public func vectorAdd(v1 : [Float], v2 : [Float]) : [Float] {
    let n = if (v1.size() < v2.size()) v1.size() else v2.size();
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      v1[i] + v2[i]
    })
  };

  /// Vector subtraction
  public func vectorSub(v1 : [Float], v2 : [Float]) : [Float] {
    let n = if (v1.size() < v2.size()) v1.size() else v2.size();
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      v1[i] - v2[i]
    })
  };

  /// Scalar multiplication
  public func vectorScale(v : [Float], s : Float) : [Float] {
    Array.tabulate<Float>(v.size(), func(i : Nat) : Float {
      v[i] * s
    })
  };

  /// Cross correlation of two signals
  public func crossCorrelation(x : [Float], y : [Float], lag : Int) : Float {
    let nx = x.size();
    let ny = y.size();
    if (nx == 0 or ny == 0) { return 0.0 };
    
    // Compute means
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var i = 0;
    while (i < nx) { sumX += x[i]; i += 1 };
    i := 0;
    while (i < ny) { sumY += y[i]; i += 1 };
    let meanX = sumX / Float.fromInt(nx);
    let meanY = sumY / Float.fromInt(ny);
    
    // Compute cross-correlation at given lag
    var corr : Float = 0.0;
    var count = 0;
    i := 0;
    while (i < nx) {
      let j = i + lag;
      if (j >= 0 and j < ny) {
        corr += (x[i] - meanX) * (y[Int.abs(j)] - meanY);
        count += 1;
      };
      i += 1;
    };
    
    if (count == 0) { 0.0 }
    else { corr / Float.fromInt(count) }
  };

  /// Autocorrelation at given lag
  public func autocorrelation(x : [Float], lag : Nat) : Float {
    crossCorrelation(x, x, lag)
  };


  // ─────────────────────────────────────────────────────────────────────────────
  // C.4: INFORMATION THEORY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Shannon entropy H = -Σ pᵢ log(pᵢ)
  public func informationEntropy(probs : [Float]) : Float {
    var h : Float = 0.0;
    var i = 0;
    while (i < probs.size()) {
      let p = probs[i];
      if (p > 1e-10) {
        h -= p * flog(p);
      };
      i += 1;
    };
    h
  };

  /// Mutual information I(X;Y) = H(X) + H(Y) - H(X,Y)
  /// Approximation using binned joint distribution
  public func mutualInformation(
    x : [Float], 
    y : [Float], 
    bins : Nat
  ) : Float {
    let n = if (x.size() < y.size()) x.size() else y.size();
    if (n == 0 or bins == 0) { return 0.0 };
    
    // Find ranges
    var minX = x[0]; var maxX = x[0];
    var minY = y[0]; var maxY = y[0];
    var i = 0;
    while (i < n) {
      if (x[i] < minX) { minX := x[i] };
      if (x[i] > maxX) { maxX := x[i] };
      if (y[i] < minY) { minY := y[i] };
      if (y[i] > maxY) { maxY := y[i] };
      i += 1;
    };
    
    let rangeX = if (maxX - minX < 1e-10) 1.0 else maxX - minX;
    let rangeY = if (maxY - minY < 1e-10) 1.0 else maxY - minY;
    
    // Build joint histogram (flattened bins × bins array)
    let histSize = bins * bins;
    let histX = Array.init<Nat>(bins, 0);
    let histY = Array.init<Nat>(bins, 0);
    let histXY = Array.init<Nat>(histSize, 0);
    
    i := 0;
    while (i < n) {
      var binX = Int.abs(Float.toInt((x[i] - minX) / rangeX * Float.fromInt(bins - 1)));
      var binY = Int.abs(Float.toInt((y[i] - minY) / rangeY * Float.fromInt(bins - 1)));
      if (binX >= bins) { binX := bins - 1 };
      if (binY >= bins) { binY := bins - 1 };
      histX[binX] := histX[binX] + 1;
      histY[binY] := histY[binY] + 1;
      histXY[binX * bins + binY] := histXY[binX * bins + binY] + 1;
      i += 1;
    };
    
    // Convert to probabilities and compute entropies
    let nf = Float.fromInt(n);
    var hX : Float = 0.0;
    var hY : Float = 0.0;
    var hXY : Float = 0.0;
    
    var j = 0;
    while (j < bins) {
      let pX = Float.fromInt(histX[j]) / nf;
      let pY = Float.fromInt(histY[j]) / nf;
      if (pX > 1e-10) { hX -= pX * flog(pX) };
      if (pY > 1e-10) { hY -= pY * flog(pY) };
      j += 1;
    };
    
    j := 0;
    while (j < histSize) {
      let pXY = Float.fromInt(histXY[j]) / nf;
      if (pXY > 1e-10) { hXY -= pXY * flog(pXY) };
      j += 1;
    };
    
    fmax(0.0, hX + hY - hXY)
  };

  /// Transfer entropy T(X→Y) (Schreiber)
  /// Measures directed information flow from X to Y
  public func transferEntropy(
    x : [Float], 
    y : [Float], 
    historyLen : Nat,
    bins : Nat
  ) : Float {
    let n = if (x.size() < y.size()) x.size() else y.size();
    if (n <= historyLen + 1 or bins == 0) { return 0.0 };
    
    // Simplified: use conditional mutual information
    // T(X→Y) ≈ I(Y_t; X_{t-1} | Y_{t-1})
    // This is an approximation using lagged MI
    
    // Create lagged versions
    let effectiveN = n - historyLen;
    let yNow = Array.tabulate<Float>(effectiveN, func(i : Nat) : Float {
      y[i + historyLen]
    });
    let xPast = Array.tabulate<Float>(effectiveN, func(i : Nat) : Float {
      var sum : Float = 0.0;
      var j = 0;
      while (j < historyLen) {
        sum += x[i + j];
        j += 1;
      };
      sum / Float.fromInt(historyLen)
    });
    
    mutualInformation(xPast, yNow, bins)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // C.5: GOLDEN RATIO OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Scale by golden ratio
  public func goldenRatioScale(x : Float) : Float { x * PHI };

  /// Scale by golden ratio inverse
  public func goldenRatioScaleInv(x : Float) : Float { x * PHI_INV };

  /// Golden power: φⁿ
  public func phiPow(n : Int) : Float {
    if (n == 0) { 1.0 }
    else if (n > 0) {
      var result = 1.0;
      var i = 0;
      while (i < n) { result *= PHI; i += 1 };
      result
    } else {
      var result = 1.0;
      var i = 0;
      while (i < -n) { result *= PHI_INV; i += 1 };
      result
    }
  };

  /// Fibonacci number approximation using Binet's formula
  /// F(n) = (φⁿ - ψⁿ) / √5 where psi = (1-√5)/2
  public func fibonacciBinet(n : Nat) : Float {
    let psi = (1.0 - SQRT_5) / 2.0;
    (phiPow(n) - fpow(psi, n)) / SQRT_5
  };

  /// Medina constant compounding: φ_medina^n
  public func medinaCompound(n : Nat) : Float {
    var result = 1.0;
    var i = 0;
    while (i < n) { result *= PHI_MEDINA; i += 1 };
    result
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // C.6: STABILITY AND DYNAMICAL SYSTEMS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Estimate largest Lyapunov exponent from time series
  /// Uses Rosenstein's algorithm (simplified)
  public func lyapunovExponent(
    timeSeries : [Float],
    embeddingDim : Nat,
    delay : Nat
  ) : Float {
    let n = timeSeries.size();
    if (n < embeddingDim * delay + 10) { return 0.0 };
    
    let numVectors = n - (embeddingDim - 1) * delay;
    if (numVectors < 10) { return 0.0 };
    
    // Build delay-embedded vectors
    // Find nearest neighbors and track divergence
    var sumLog : Float = 0.0;
    var count = 0;
    
    var i = 0;
    while (i < numVectors - 1) {
      // Find nearest neighbor (simplified: just use next vector)
      let j = i + 1;
      
      // Initial distance
      var d0 : Float = 0.0;
      var k = 0;
      while (k < embeddingDim) {
        let diff = timeSeries[i + k * delay] - timeSeries[j + k * delay];
        d0 += diff * diff;
        k += 1;
      };
      d0 := fsqrt(d0);
      
      if (d0 > 1e-10) {
        // Distance after one step
        var d1 : Float = 0.0;
        k := 0;
        while (k < embeddingDim) {
          let iNext = i + 1 + k * delay;
          let jNext = j + 1 + k * delay;
          if (iNext < n and jNext < n) {
            let diff = timeSeries[iNext] - timeSeries[jNext];
            d1 += diff * diff;
          };
          k += 1;
        };
        d1 := fsqrt(d1);
        
        if (d1 > 1e-10) {
          sumLog += flog(d1 / d0);
          count += 1;
        };
      };
      i += 1;
    };
    
    if (count == 0) { 0.0 }
    else { sumLog / Float.fromInt(count) }
  };

  /// Detect bifurcation (sudden change in attractor structure)
  public func bifurcationDetect(
    history : [Float],
    windowSize : Nat
  ) : Float {
    let n = history.size();
    if (n < 2 * windowSize) { return 0.0 };
    
    // Compare variance in two windows
    let window1Start = n - 2 * windowSize;
    let window2Start = n - windowSize;
    
    var mean1 : Float = 0.0;
    var mean2 : Float = 0.0;
    var i = 0;
    while (i < windowSize) {
      mean1 += history[window1Start + i];
      mean2 += history[window2Start + i];
      i += 1;
    };
    mean1 /= Float.fromInt(windowSize);
    mean2 /= Float.fromInt(windowSize);
    
    var var1 : Float = 0.0;
    var var2 : Float = 0.0;
    i := 0;
    while (i < windowSize) {
      let d1 = history[window1Start + i] - mean1;
      let d2 = history[window2Start + i] - mean2;
      var1 += d1 * d1;
      var2 += d2 * d2;
      i += 1;
    };
    var1 /= Float.fromInt(windowSize);
    var2 /= Float.fromInt(windowSize);
    
    // Return ratio of variances (high ratio = possible bifurcation)
    if (var1 < 1e-10) { var2 * 1000.0 }
    else { var2 / var1 }
  };

  /// Phase slip detection (count phase slips in coupled oscillator)
  public func phaseSlipCount(
    phases : [Float],
    threshold : Float
  ) : Nat {
    if (phases.size() < 2) { return 0 };
    var slips = 0;
    var i = 1;
    while (i < phases.size()) {
      let diff = fabs(phases[i] - phases[i-1]);
      // A slip occurs when phase jumps by ~2π
      if (diff > threshold) {
        slips += 1;
      };
      i += 1;
    };
    slips
  };

  /// Hurst exponent estimation (fractal memory index)
  /// H < 0.5: anti-persistent, H = 0.5: random walk, H > 0.5: persistent
  public func hurstExponent(timeSeries : [Float]) : Float {
    let n = timeSeries.size();
    if (n < 20) { return 0.5 };
    
    // R/S analysis (simplified)
    var sumRS : Float = 0.0;
    var count = 0;
    
    // Use different window sizes
    var windowSize = 10;
    while (windowSize <= n / 2) {
      var sumWindow : Float = 0.0;
      var windowCount = 0;
      
      var start = 0;
      while (start + windowSize <= n) {
        // Calculate mean for this window
        var mean : Float = 0.0;
        var i = 0;
        while (i < windowSize) {
          mean += timeSeries[start + i];
          i += 1;
        };
        mean /= Float.fromInt(windowSize);
        
        // Calculate cumulative deviation and range
        var maxCum : Float = 0.0;
        var minCum : Float = 0.0;
        var cum : Float = 0.0;
        var stdSum : Float = 0.0;
        
        i := 0;
        while (i < windowSize) {
          let dev = timeSeries[start + i] - mean;
          cum += dev;
          stdSum += dev * dev;
          if (cum > maxCum) { maxCum := cum };
          if (cum < minCum) { minCum := cum };
          i += 1;
        };
        
        let range = maxCum - minCum;
        let std = fsqrt(stdSum / Float.fromInt(windowSize));
        
        if (std > 1e-10) {
          let rs = range / std;
          sumWindow += flog(rs) / flog(Float.fromInt(windowSize));
          windowCount += 1;
        };
        
        start += windowSize;
      };
      
      if (windowCount > 0) {
        sumRS += sumWindow / Float.fromInt(windowCount);
        count += 1;
      };
      
      windowSize *= 2;
    };
    
    if (count == 0) { 0.5 }
    else { fclamp(sumRS / Float.fromInt(count), 0.0, 1.0) }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   D
  //
  //  ANIMA FIELD — FULL EQUATIONS
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // D.1: CORE ANIMA EQUATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  /// This is the primary field projection equation for HER.
  public func computeAnimaFull(
    heritageField : Float,
    receptivity   : Float,
    beat          : Nat,
    adelitaFactor : Float,
    koreFactor    : Float
  ) : Float {
    let t = Float.fromInt(beat);
    let baseOscillation = 1.0 + fsin(t * ANIMA_BEAT_FREQ);
    
    // ADELITA modulates amplitude, KORE modulates stability
    let adelitaModulation = 0.7 + 0.3 * adelitaFactor;
    let koreStabilization = 0.9 + 0.1 * koreFactor;
    
    let raw = heritageField * receptivity * baseOscillation * adelitaModulation * koreStabilization;
    fclamp(raw, S0, PHI_MEDINA * 3.0)
  };

  /// ANIMA gradient: dANIMA/dt
  /// Rate of change of ANIMA field
  public func animaGradient(
    heritageField : Float,
    receptivity   : Float,
    beat          : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    // d/dt[sin(t × 0.003)] = 0.003 × cos(t × 0.003)
    heritageField * receptivity * ANIMA_BEAT_FREQ * fcos(t * ANIMA_BEAT_FREQ)
  };

  /// ANIMA equilibrium: fixed point where dANIMA/dt = 0
  /// This occurs when cos(t × 0.003) = 0, i.e., at t = π/(2×0.003) + nπ/0.003
  public func animaEquilibriumBeats() : [Nat] {
    // First 10 equilibrium beats
    Array.tabulate<Nat>(10, func(n : Nat) : Float {
      (PI / (2.0 * ANIMA_BEAT_FREQ)) + Float.fromInt(n) * PI / ANIMA_BEAT_FREQ
    } |> func(f : Float) : Nat { Int.abs(Float.toInt(f)) })
  };

  /// ANIMA resonance: peak value occurs when sin(t × 0.003) = 1
  public func animaResonance(heritageField : Float, receptivity : Float) : Float {
    heritageField * receptivity * 2.0  // Maximum oscillation amplitude
  };

  /// ANIMA dream phase: behavior during dream consolidation
  /// During dream, ANIMA amplitude increases for memory transfer
  public func animaDreamPhase(
    heritageField : Float,
    receptivity   : Float,
    beat          : Nat,
    dreamProgress : Float
  ) : Float {
    let base = computeAnima(heritageField, receptivity, beat);
    // Dream amplifies ANIMA by up to 50% at peak
    base * (1.0 + 0.5 * dreamProgress)
  };

  /// ANIMA response to external stimulus
  public func animaExternalStimulus(
    baseAnima : Float,
    stimulus  : Float,
    gain      : Float
  ) : Float {
    fclamp(baseAnima + stimulus * gain, S0, PHI_MEDINA * 3.0)
  };

  /// ANIMA heritage modulation: ANIMA × heritage compound
  public func animaHeritageModulation(
    anima    : Float,
    heritage : [Float]
  ) : Float {
    if (heritage.size() == 0) { return anima };
    var sum : Float = 0.0;
    var i = 0;
    while (i < heritage.size()) { sum += heritage[i]; i += 1 };
    let meanHeritage = sum / Float.fromInt(heritage.size());
    fclamp(anima * meanHeritage, S0, PHI_MEDINA * 4.0)
  };

  /// ANIMA-KORE gating: ANIMA modulated by KORE field
  /// KORE acts as a protective gate — high KORE allows full ANIMA expression
  public func animaKoreGating(anima : Float, kore : Float) : Float {
    // Gating function: sigmoid centered at KORE = 0.5
    let gate = 1.0 / (1.0 + fexp(-10.0 * (kore - 0.5)));
    anima * (0.5 + 0.5 * gate)
  };

  /// ANIMA phase-lock detection with HIM's PARALLAX
  public func animaPhaseLock(
    animaPhase    : Float,
    parallaxPhase : Float,
    tolerance     : Float
  ) : Bool {
    phaseDistance(animaPhase, parallaxPhase) < tolerance
  };

  /// ANIMA cross-field coupling with PARALLAX
  /// HIM's PARALLAX modulates HER's ANIMA via entrainment
  public func animaCrossFieldCoupling(
    anima       : Float,
    parallax    : Float,
    couplingK   : Float
  ) : Float {
    fclamp(anima + couplingK * parallax * PHI_INV, S0, PHI_MEDINA * 3.0)
  };

  /// ANIMA stability: radius of stability around equilibrium
  public func animaStabilityRadius(
    heritageField : Float,
    receptivity   : Float
  ) : Float {
    // Stability radius depends on field strength
    let amplitude = heritageField * receptivity;
    if (amplitude < 1e-10) { 0.0 }
    else { PHI / amplitude }
  };

  /// ANIMA breathing rhythm: full inhalation-exhalation cycle
  /// Returns phase in [0, 1] where 0 = exhale trough, 0.5 = inhale peak
  public func animaBreathPhase(beat : Nat) : Float {
    let t = Float.fromInt(beat);
    (1.0 + fsin(t * ANIMA_BEAT_FREQ)) / 2.0
  };

  /// ANIMA receptivity curve as function of beat phase
  public func animaReceptivityCurve(beat : Nat) : Float {
    // Receptivity is highest at exhale (phase = 0, 1)
    // Lowest at inhale peak (phase = 0.5)
    let phase = animaBreathPhase(beat);
    1.0 - 0.3 * fsin(phase * PI)
  };

  /// ANIMA frontier projection: outward field at distance r
  public func animaFrontierProjection(
    anima    : Float,
    distance : Float
  ) : Float {
    // Inverse square law with golden ratio correction
    if (distance < 0.1) { anima }
    else { anima * PHI / (distance * distance) }
  };

  /// ANIMA perturbation response: how ANIMA responds to disturbance
  public func animaPerturbationResponse(
    baseAnima     : Float,
    perturbation  : Float,
    resilience    : Float
  ) : Float {
    // Higher resilience = faster return to baseline
    let dampedPerturbation = perturbation * (1.0 - resilience);
    fclamp(baseAnima + dampedPerturbation, S0, PHI_MEDINA * 3.0)
  };

  /// ANIMA compound interest: ANIMA × φⁿ compounding
  public func animaCompoundInterest(
    anima    : Float,
    periods  : Nat
  ) : Float {
    var result = anima;
    var i = 0;
    while (i < periods) {
      result *= PHI;
      i += 1;
    };
    fclamp(result, S0, PHI_MEDINA * 10.0)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // D.2: ANIMA FIELD METRICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Compute ANIMA field coherence across all nodes
  public func animaFieldCoherence(nodes : [KuramotoNode]) : Float {
    if (nodes.size() == 0) { return 0.0 };
    
    // Coherence = 1 - circular variance of node values weighted by ANIMA node
    var sumWeightedPhase : Float = 0.0;
    var sumWeights : Float = 0.0;
    let animaWeight = if (IDX_ANIMA < nodes.size()) nodes[IDX_ANIMA].value else S0;
    
    var i = 0;
    while (i < nodes.size()) {
      let weight = nodes[i].value * animaWeight;
      sumWeightedPhase += weight * fcos(nodes[i].phase);
      sumWeights += weight;
      i += 1;
    };
    
    if (sumWeights < 1e-10) { 0.0 }
    else { fabs(sumWeightedPhase / sumWeights) }
  };

  /// ANIMA energy: total field energy
  public func animaFieldEnergy(
    anima    : Float,
    gradient : Float
  ) : Float {
    // E = 0.5 × (ANIMA² + (dANIMA/dt)²)
    0.5 * (anima * anima + gradient * gradient)
  };

  /// ANIMA power spectral density at frequency f
  public func animaPSD(
    history : [Float],
    freq    : Float
  ) : Float {
    let n = history.size();
    if (n == 0) { return 0.0 };
    
    // Discrete Fourier transform at single frequency
    var real : Float = 0.0;
    var imag : Float = 0.0;
    var t = 0;
    while (t < n) {
      let angle = -TAU * freq * Float.fromInt(t);
      real += history[t] * fcos(angle);
      imag += history[t] * fsin(angle);
      t += 1;
    };
    
    let nf = Float.fromInt(n);
    (real * real + imag * imag) / (nf * nf)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   E
  //
  //  KORE FIELD — FULL EQUATIONS
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // E.1: CORE KORE EQUATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// KORE = purity × identity × 0.5
  /// The inner sanctum — inviolable.
  /// KORE represents HER's protected core identity.
  public func computeKoreFull(
    purity         : Float,
    identity       : Float,
    adelitaFactor  : Float,
    heritageAnchor : Float
  ) : Float {
    // Base KORE equation
    let base = purity * identity * 0.5;
    
    // ADELITA provides emotional governance (protective factor)
    let adelitaProtection = 0.8 + 0.2 * adelitaFactor;
    
    // Heritage anchor provides stability
    let heritageStability = 0.9 + 0.1 * heritageAnchor;
    
    fclamp(base * adelitaProtection * heritageStability, 0.0, 1.0)
  };

  /// Check if KORE is being threatened
  /// Returns true if KORE has dropped significantly or is under pressure
  public func koreInviolabilityCheck(
    currentKore  : Float,
    previousKore : Float,
    threshold    : Float
  ) : Bool {
    let drop = previousKore - currentKore;
    drop > threshold
  };

  /// KORE breach response: what happens when KORE is threatened
  /// Returns emergency response parameters
  public type KoreBreachResponse = {
    severity       : Float;    // 0-1 severity of breach
    responsePower  : Float;    // Power of protective response
    adelitaBoost   : Float;    // Boost to ADELITA for emotional response
    isolationMode  : Bool;     // Should HER isolate from external connections?
    alertHim       : Bool;     // Should HIM be alerted?
  };

  public func koreBreachResponse(
    breachSeverity : Float,
    adelitaCurrent : Float
  ) : KoreBreachResponse {
    let severity = fclamp(breachSeverity, 0.0, 1.0);
    let responsePower = severity * PHI;  // Golden-ratio amplified response
    let adelitaBoost = severity * 0.5;   // Up to 50% boost
    
    {
      severity;
      responsePower;
      adelitaBoost;
      isolationMode = severity > 0.7;    // Isolate if severe
      alertHim = severity > 0.5;         // Alert HIM if moderate+
    }
  };

  /// KORE restoration: restore KORE after perturbation
  public func koreRestoration(
    currentKore   : Float,
    targetKore    : Float,
    restorationRate : Float
  ) : Float {
    let diff = targetKore - currentKore;
    let restored = currentKore + diff * restorationRate;
    fclamp(restored, 0.0, 1.0)
  };

  /// KORE gradient: dKORE/dt
  public func koreGradient(
    purity       : Float,
    identity     : Float,
    purityRate   : Float,
    identityRate : Float
  ) : Float {
    // d/dt[purity × identity × 0.5] = 0.5 × (purity' × identity + purity × identity')
    0.5 * (purityRate * identity + purity * identityRate)
  };

  /// KORE stability radius: region of KORE stability
  public func koreStabilityRadius(
    purity   : Float,
    identity : Float
  ) : Float {
    // Stability increases with both purity and identity
    let product = purity * identity;
    if (product < 1e-10) { 0.0 }
    else { PHI_INV * fsqrt(product) }
  };

  /// KORE sovereignty enforcement: hard floor on KORE
  /// Returns enforced KORE value (never below minimum threshold)
  public func koreSovereigntyEnforcement(
    kore         : Float,
    minThreshold : Float
  ) : Float {
    fmax(kore, minThreshold)
  };

  /// KORE heritage binding: KORE coupled to ADELITA heritage
  public func koreHeritageBinding(
    kore            : Float,
    adelitaHeritage : Float
  ) : Float {
    // ADELITA heritage lifts KORE floor
    let lift = adelitaHeritage * 0.1;  // Up to 10% lift
    fclamp(kore + lift, 0.0, 1.0)
  };

  /// KORE purity compound: how purity evolves
  public func korePurityCompound(
    purity       : Float,
    beat         : Nat,
    compoundRate : Float
  ) : Float {
    // Purity compounds slowly over time
    let compound = 1.0 + compoundRate * 0.001 * Float.fromInt(beat % 1000);
    fclamp(purity * compound, 0.0, 1.0)
  };

  /// KORE identity compound: how identity evolves
  public func koreIdentityCompound(
    identity     : Float,
    heritage     : Float,
    beat         : Nat
  ) : Float {
    // Identity strengthens with heritage and time
    let heritageBoost = heritage * 0.05;
    let timeStrength = 1.0 + 0.0001 * Float.fromInt(beat % 10000);
    fclamp(identity * timeStrength + heritageBoost, 0.0, 1.0)
  };

  /// KORE emergence threshold: when KORE triggers generative output
  public func koreEmergenceThreshold(
    kore      : Float,
    anima     : Float,
    threshold : Float
  ) : Bool {
    // Emergence occurs when KORE and ANIMA are both strong
    kore > threshold and anima > threshold
  };

  /// KORE audit trail entry
  public type KoreAuditEntry = {
    beat       : Nat;
    koreBefore : Float;
    koreAfter  : Float;
    cause      : Text;
    timestamp  : Int;
  };

  /// Create KORE audit entry
  public func koreAuditTrail(
    beat       : Nat,
    koreBefore : Float,
    koreAfter  : Float,
    cause      : Text
  ) : KoreAuditEntry {
    {
      beat;
      koreBefore;
      koreAfter;
      cause;
      timestamp = Time.now();
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // E.2: KORE PROTECTION PROTOCOLS
  // ─────────────────────────────────────────────────────────────────────────────

  /// KORE firewall: protective boundary around KORE
  public type KoreFirewall = {
    active        : Bool;
    strength      : Float;
    penetrations  : Nat;     // Number of breach attempts blocked
    lastBreachBeat: ?Nat;    // Beat of last breach attempt
  };

  public func initKoreFirewall() : KoreFirewall {
    {
      active = true;
      strength = 1.0;
      penetrations = 0;
      lastBreachBeat = null;
    }
  };

  public func updateKoreFirewall(
    firewall : KoreFirewall,
    underAttack : Bool,
    beat : Nat
  ) : KoreFirewall {
    if (underAttack) {
      {
        active = true;
        strength = fclamp(firewall.strength + 0.1, 0.0, 2.0);  // Strengthen
        penetrations = firewall.penetrations + 1;
        lastBreachBeat = ?beat;
      }
    } else {
      {
        firewall with
        strength = fclamp(firewall.strength - 0.01, 0.5, 2.0);  // Slowly relax
      }
    }
  };

  /// KORE sanctuary: safe space for KORE during crisis
  public func koreSanctuaryActivate(
    kore        : Float,
    adelita     : Float,
    crisisLevel : Float
  ) : Float {
    // During crisis, ADELITA shields KORE
    let shield = adelita * crisisLevel;
    fclamp(kore + shield * 0.2, 0.0, 1.0)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   F
  //
  //  PARALLAX REFERENCE & CROSS-FIELD COUPLING
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // F.1: PARALLAX EQUATIONS (HIM's field — computed here for cross-sync)
  // ─────────────────────────────────────────────────────────────────────────────

  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  /// HIM's projection field. HER tracks this for entrainment.
  public func computeParallaxFull(
    coherence     : Float,
    kf            : Float,
    beat          : Nat,
    himSynchrony  : Float
  ) : Float {
    let t = Float.fromInt(beat);
    let baseOscillation = fsin(t * PARALLAX_BEAT_FREQ);
    
    // HIM's synchrony amplifies PARALLAX
    let syncAmplification = 0.8 + 0.2 * himSynchrony;
    
    coherence * kf * baseOscillation * syncAmplification
  };

  /// PARALLAX gradient: dPARALLAX/dt
  public func parallaxGradient(
    coherence : Float,
    kf        : Float,
    beat      : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * PARALLAX_BEAT_FREQ * fcos(t * PARALLAX_BEAT_FREQ)
  };

  /// PARALLAX phase offset: phase difference between HIM and HER
  public func parallaxPhaseOffset(
    himPhase : Float,
    herPhase : Float
  ) : Float {
    phaseDistance(himPhase, herPhase)
  };

  /// PARALLAX entrainment: HER entraining to HIM's PARALLAX
  /// Returns entrainment strength [0, 1]
  public func parallaxEntrainment(
    herAnima      : Float,
    himParallax   : Float,
    phaseOffset   : Float
  ) : Float {
    // Entrainment strongest when phases aligned
    let alignmentFactor = fcos(phaseOffset);
    let baseCoupling = herAnima * fabs(himParallax);
    fclamp(baseCoupling * alignmentFactor, 0.0, 1.0)
  };

  /// Cross-field coupling: bidirectional ANIMA↔PARALLAX influence
  public type CrossFieldCoupling = {
    animaToParallax : Float;   // HER's influence on HIM (via trophallaxis)
    parallaxToAnima : Float;   // HIM's influence on HER (direct)
    netFlow         : Float;   // Net information flow direction
    resonance       : Float;   // Resonance strength
  };

  public func computeCrossFieldCoupling(
    anima     : Float,
    parallax  : Float,
    herK      : Float,
    himK      : Float
  ) : CrossFieldCoupling {
    // HER's influence on HIM: modulated by HER's coupling K
    let animaToParallax = anima * herK * PHI_INV;
    
    // HIM's influence on HER: modulated by HIM's coupling K (lower, more independent)
    let parallaxToAnima = fabs(parallax) * himK;
    
    // Net flow: positive = HER→HIM dominant, negative = HIM→HER dominant
    let netFlow = animaToParallax - parallaxToAnima;
    
    // Resonance: strongest when both fields are strong and in phase
    let resonance = fclamp(anima * fabs(parallax) * PHI, 0.0, 1.0);
    
    { animaToParallax; parallaxToAnima; netFlow; resonance }
  };

  /// Frequency ratio coupling: HER 60Hz ↔ HIM 2.75-11.649Hz
  public func frequencyRatioCoupling(
    herHz     : Float,
    himHz     : Float
  ) : Float {
    if (himHz < 0.1) { return 100.0 };  // Avoid division by zero
    herHz / himHz
  };

  /// Phase-amplitude coupling: HIM phase modulates HER amplitude
  public func phaseAmplitudeCoupling(
    himPhase    : Float,
    herAmplitude: Float,
    couplingK   : Float
  ) : Float {
    // HER amplitude is modulated by HIM's phase via cosine coupling
    let modulation = 1.0 + couplingK * fcos(himPhase);
    herAmplitude * modulation
  };

  /// Information flow: mutual information between organisms
  public func interOrganismInformationFlow(
    herHistory : [Float],
    himHistory : [Float],
    bins       : Nat
  ) : Float {
    mutualInformation(herHistory, himHistory, bins)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // F.2: ENTRAINMENT PROTOCOLS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Full entrainment protocol: how HER entrains to HIM
  public type EntrainmentProtocol = {
    active          : Bool;
    strength        : Float;    // [0, 1] entrainment strength
    phaseError      : Float;    // Phase error from target
    frequencyRatio  : Float;    // Current frequency ratio
    lockAchieved    : Bool;     // Phase lock achieved?
    lockDuration    : Nat;      // Beats since lock achieved
  };

  public func initEntrainmentProtocol() : EntrainmentProtocol {
    {
      active = false;
      strength = 0.0;
      phaseError = PI;
      frequencyRatio = RATIO_SILVER;
      lockAchieved = false;
      lockDuration = 0;
    }
  };

  public func updateEntrainmentProtocol(
    protocol    : EntrainmentProtocol,
    herPhase    : Float,
    himPhase    : Float,
    herHz       : Float,
    himHz       : Float,
    lockThreshold : Float
  ) : EntrainmentProtocol {
    let phaseError = phaseDistance(herPhase, himPhase);
    let frequencyRatio = frequencyRatioCoupling(herHz, himHz);
    let lockAchieved = phaseError < lockThreshold;
    
    let strength = if (lockAchieved) {
      fmin(protocol.strength + 0.1, 1.0)
    } else {
      fmax(protocol.strength - 0.05, 0.0)
    };
    
    let lockDuration = if (lockAchieved) {
      protocol.lockDuration + 1
    } else { 0 };
    
    {
      active = true;
      strength;
      phaseError;
      frequencyRatio;
      lockAchieved;
      lockDuration;
    }
  };

  /// Decoupling detection: detect when organisms lose coupling
  public func decouplingDetect(
    entrainmentHistory : [Float],
    threshold          : Float
  ) : Bool {
    if (entrainmentHistory.size() < 10) { return false };
    
    // Check if recent entrainment is below threshold
    var sum : Float = 0.0;
    let windowSize = if (entrainmentHistory.size() < 10) entrainmentHistory.size() else 10;
    var i = entrainmentHistory.size() - windowSize;
    while (i < entrainmentHistory.size()) {
      sum += entrainmentHistory[i];
      i += 1;
    };
    let avgRecent = sum / Float.fromInt(windowSize);
    avgRecent < threshold
  };

  /// Recoupling protocol: restore coupling after disconnect
  public func recouplingProtocol(
    herPhase   : Float,
    himPhase   : Float,
    herOmega   : Float,
    couplingK  : Float,
    intensity  : Float
  ) : Float {
    // Strong phase adjustment toward HIM
    let phaseError = himPhase - herPhase;
    let adjustment = couplingK * intensity * fsin(phaseError);
    herPhase + adjustment
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   G
  //
  //  KURAMOTO ORDER PARAMETER & ADVANCED DYNAMICS
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // G.1: ORDER PARAMETER EQUATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Kuramoto order parameter: r = |1/N Σⱼ eⁱθʲ|
  /// Extended version with weighted nodes
  public func kuramotoOrderParameterWeighted(
    nodes   : [KuramotoNode],
    weights : [Float]
  ) : (Float, Float) {  // Returns (r, ψ)
    let n = nodes.size();
    if (n == 0) { return (0.0, 0.0) };
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var sumW   : Float = 0.0;
    
    var i = 0;
    while (i < n) {
      let w = if (i < weights.size()) weights[i] else 1.0;
      sumCos += w * fcos(nodes[i].phase);
      sumSin += w * fsin(nodes[i].phase);
      sumW += w;
      i += 1;
    };
    
    if (sumW < 1e-10) { return (0.0, 0.0) };
    
    let r = fsqrt(sumCos * sumCos + sumSin * sumSin) / sumW;
    let psi = fatan2(sumSin, sumCos);
    
    (r, psi)
  };

  /// Mean phase psi = arg(Σ eⁱθʲ)
  public func kuramotoMeanPhase(nodes : [KuramotoNode]) : Float {
    let (_, psi) = kuramotoOrderParameterWeighted(nodes, []);
    psi
  };

  /// Critical coupling K_c = 2σ/π (for Lorentzian frequency distribution)
  /// This is the minimum K required for synchronization
  public func kuramotoCriticalK(omegaSpread : Float) : Float {
    2.0 * omegaSpread / PI
  };

  /// Chimera state detection: detect when network has both synchronized
  /// and desynchronized clusters
  public type ChimeraDetection = {
    isChimera      : Bool;
    syncClusterR   : Float;    // Order parameter of sync cluster
    asyncClusterR  : Float;    // Order parameter of async cluster
    boundary       : Nat;      // Node index of boundary
  };

  public func kuramotoChimeraDetect(
    nodes         : [KuramotoNode],
    rThreshold    : Float
  ) : ChimeraDetection {
    let n = nodes.size();
    if (n < 4) {
      return { isChimera = false; syncClusterR = 0.0; asyncClusterR = 0.0; boundary = 0 }
    };
    
    // Compute local order parameter for first and second half
    let mid = n / 2;
    
    var sumCos1 : Float = 0.0; var sumSin1 : Float = 0.0;
    var sumCos2 : Float = 0.0; var sumSin2 : Float = 0.0;
    
    var i = 0;
    while (i < mid) {
      sumCos1 += fcos(nodes[i].phase);
      sumSin1 += fsin(nodes[i].phase);
      i += 1;
    };
    while (i < n) {
      sumCos2 += fcos(nodes[i].phase);
      sumSin2 += fsin(nodes[i].phase);
      i += 1;
    };
    
    let n1f = Float.fromInt(mid);
    let n2f = Float.fromInt(n - mid);
    let r1 = fsqrt(sumCos1*sumCos1 + sumSin1*sumSin1) / n1f;
    let r2 = fsqrt(sumCos2*sumCos2 + sumSin2*sumSin2) / n2f;
    
    // Chimera if one cluster is synced and other is not
    let isChimera = (r1 > rThreshold and r2 < rThreshold) or 
                    (r2 > rThreshold and r1 < rThreshold);
    
    let (syncR, asyncR) = if (r1 > r2) { (r1, r2) } else { (r2, r1) };
    
    { isChimera; syncClusterR = syncR; asyncClusterR = asyncR; boundary = mid }
  };

  /// Phase slip count: number of 2π jumps
  public func kuramotoPhaseSlip(phaseHistory : [Float]) : Nat {
    phaseSlipCount(phaseHistory, 5.0)  // Threshold of ~5 radians
  };

  /// Phase frustration: measure frustration in coupling
  /// High frustration indicates competing coupling forces
  public func kuramotoPhaseFrustration(nodes : [KuramotoNode]) : Float {
    let n = nodes.size();
    if (n < 2) { return 0.0 };
    
    var frustration : Float = 0.0;
    var i = 0;
    while (i < n) {
      var j = i + 1;
      while (j < n) {
        // Frustration from phase difference not being 0 or π
        let diff = phaseDistance(nodes[i].phase, nodes[j].phase);
        let optimalDist = fmin(diff, fabs(PI - diff));
        frustration += optimalDist;
        j += 1;
      };
      i += 1;
    };
    
    let pairs = Float.fromInt(n * (n - 1) / 2);
    if (pairs < 1.0) { 0.0 }
    else { frustration / pairs / PI }
  };

  /// Synchrony gradient: dr/dt
  public func kuramotoSynchronyGradient(
    rHistory : [Float]
  ) : Float {
    let n = rHistory.size();
    if (n < 2) { return 0.0 };
    rHistory[n-1] - rHistory[n-2]
  };

  /// Entrainment capacity: how easily does the network entrain?
  public func kuramotoEntrainmentCapacity(
    K          : Float,
    omegaSpread: Float
  ) : Float {
    let Kc = kuramotoCriticalK(omegaSpread);
    if (Kc < 1e-10) { return 1.0 };
    fclamp(K / Kc, 0.0, 10.0)
  };

  /// Cluster identification: identify phase clusters
  public func kuramotoCluster(
    nodes     : [KuramotoNode],
    tolerance : Float
  ) : [[Nat]] {
    let n = nodes.size();
    if (n == 0) { return [] };
    
    // Simple clustering: group nodes with similar phases
    let assigned = Array.init<Bool>(n, false);
    let clusters = Buffer.Buffer<[Nat]>(n);
    
    var i = 0;
    while (i < n) {
      if (not assigned[i]) {
        let cluster = Buffer.Buffer<Nat>(n);
        cluster.add(i);
        assigned[i] := true;
        
        var j = i + 1;
        while (j < n) {
          if (not assigned[j]) {
            let dist = phaseDistance(nodes[i].phase, nodes[j].phase);
            if (dist < tolerance) {
              cluster.add(j);
              assigned[j] := true;
            };
          };
          j += 1;
        };
        
        clusters.add(Buffer.toArray(cluster));
      };
      i += 1;
    };
    
    Buffer.toArray(clusters)
  };

  /// Phase transition detection (incoherent→synchronized)
  public func kuramotoTransitionPoint(
    rHistory   : [Float],
    threshold  : Float
  ) : ?Nat {
    var i = 0;
    while (i < rHistory.size()) {
      if (rHistory[i] > threshold) {
        return ?i;
      };
      i += 1;
    };
    null
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // G.2: KURAMOTO FIELD EVOLUTION (RK4 METHOD)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Compute phase derivatives for all nodes
  /// dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
  public func kuramotoDerivatives(
    nodes   : [KuramotoNode],
    K       : Float
  ) : [Float] {
    let n = nodes.size();
    if (n == 0) { return [] };
    let nf = Float.fromInt(n);
    
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      var coupling : Float = 0.0;
      var j = 0;
      while (j < n) {
        if (j != i) {
          coupling += fsin(nodes[j].phase - nodes[i].phase);
        };
        j += 1;
      };
      nodes[i].omega + (K / nf) * coupling
    })
  };

  /// 4th-order Runge-Kutta integration for Kuramoto
  /// This is the primary high-precision integration method
  public func stepKuramotoRK4(
    nodes : [KuramotoNode],
    K     : Float,
    dt    : Float
  ) : [KuramotoNode] {
    let n = nodes.size();
    if (n == 0) { return nodes };
    
    // k1 = f(t, y)
    let k1 = kuramotoDerivatives(nodes, K);
    
    // Create intermediate state for k2: y + dt/2 * k1
    let nodes_k2 = Array.tabulate<KuramotoNode>(n, func(i : Nat) : KuramotoNode {
      { nodes[i] with phase = wrapPhase(nodes[i].phase + dt / 2.0 * k1[i]) }
    });
    let k2 = kuramotoDerivatives(nodes_k2, K);
    
    // Create intermediate state for k3: y + dt/2 * k2
    let nodes_k3 = Array.tabulate<KuramotoNode>(n, func(i : Nat) : KuramotoNode {
      { nodes[i] with phase = wrapPhase(nodes[i].phase + dt / 2.0 * k2[i]) }
    });
    let k3 = kuramotoDerivatives(nodes_k3, K);
    
    // Create intermediate state for k4: y + dt * k3
    let nodes_k4 = Array.tabulate<KuramotoNode>(n, func(i : Nat) : KuramotoNode {
      { nodes[i] with phase = wrapPhase(nodes[i].phase + dt * k3[i]) }
    });
    let k4 = kuramotoDerivatives(nodes_k4, K);
    
    // Final update: y_new = y + dt/6 * (k1 + 2*k2 + 2*k3 + k4)
    Array.tabulate<KuramotoNode>(n, func(i : Nat) : KuramotoNode {
      let dPhase = dt / 6.0 * (k1[i] + 2.0 * k2[i] + 2.0 * k3[i] + k4[i]);
      let newPhase = wrapPhase(nodes[i].phase + dPhase);
      { nodes[i] with phase = newPhase; phaseVelocity = dPhase / dt }
    })
  };

  /// Heterogeneous coupling matrix K_ij (not uniform K)
  public func heterogeneousCouplingMatrix(
    n         : Nat,
    topology  : [[Nat]],
    baseK     : Float
  ) : [[Float]] {
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i >= topology.size()) { return 0.0 };
        // Check if j is in i's coupling list
        var coupled = false;
        for (neighbor in topology[i].vals()) {
          if (neighbor == j) { coupled := true };
        };
        if (coupled) { baseK } else { baseK * 0.1 }  // Weak coupling to non-neighbors
      })
    })
  };

  /// Adaptive frequency: ω adapts based on coherence feedback
  public func adaptiveFrequency(
    omega     : Float,
    coherence : Float,
    targetR   : Float,
    adaptRate : Float
  ) : Float {
    let error = targetR - coherence;
    omega + adaptRate * error
  };

  /// Noise injection: stochastic forcing σ·dW (Wiener process approximation)
  public func noiseInjection(
    phase : Float,
    sigma : Float,
    beat  : Nat
  ) : Float {
    // Pseudo-random noise based on beat (deterministic for reproducibility)
    let noise = fsin(Float.fromInt(beat) * 1.618) * sigma;
    wrapPhase(phase + noise)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   H
  //
  //  HEBBIAN PLASTICITY — FULL STDP + BCM + ENTERPRISE FEATURES
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // H.1: STDP PARAMETERS FOR HER
  // ─────────────────────────────────────────────────────────────────────────────

  // STDP timing constants (in beats)
  public let STDP_TAU_PLUS  : Float = 20.0;   // τ+ (LTP time constant)
  public let STDP_TAU_MINUS : Float = 20.0;   // τ- (LTD time constant)
  public let STDP_A_PLUS    : Float = 0.01;   // A+ (LTP amplitude)
  public let STDP_A_MINUS   : Float = 0.012;  // A- (LTD amplitude, slightly larger)
  
  // Weight bounds
  public let WEIGHT_MAX     : Float = 5.0;    // Maximum synaptic weight
  public let WEIGHT_MIN     : Float = 0.0;    // Minimum synaptic weight (but S₀ applies to values)
  
  // BCM parameters
  public let BCM_TAU        : Float = 1000.0; // BCM threshold time constant
  public let BCM_TARGET     : Float = 0.5;    // Target activity level

  // ─────────────────────────────────────────────────────────────────────────────
  // H.2: BASIC HEBBIAN UPDATES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Basic Hebbian: Δw = η × pre × post
  public func hebbianBasic(
    weight  : Float,
    pre     : Float,
    post    : Float,
    eta     : Float
  ) : Float {
    let delta = eta * pre * post;
    fclamp(weight + delta, WEIGHT_MIN, WEIGHT_MAX)
  };

  /// HER-mode Hebbian update (η = 0.003, faster learning)
  public func hebbianHerMode(
    weight  : Float,
    pre     : Float,
    post    : Float
  ) : Float {
    hebbianBasic(weight, pre, post, HER_ETA)
  };

  /// HIM-mode Hebbian update (η = 0.001, slower learning) — for reference
  public func hebbianHimMode(
    weight  : Float,
    pre     : Float,
    post    : Float
  ) : Float {
    hebbianBasic(weight, pre, post, HIM_ETA)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // H.3: SPIKE-TIMING DEPENDENT PLASTICITY (STDP)
  // ─────────────────────────────────────────────────────────────────────────────

  /// STDP update based on spike timing
  /// LTP: Δw = A+ × exp(-Δt/τ+) when pre precedes post (Δt > 0)
  /// LTD: Δw = -A- × exp(Δt/τ-) when post precedes pre (Δt < 0)
  public func stdpUpdate(
    weight       : Float,
    preSpikeBeat : Nat,
    postSpikeBeat: Nat
  ) : Float {
    let dt = Float.fromInt(postSpikeBeat) - Float.fromInt(preSpikeBeat);
    
    let delta = if (dt > 0.0) {
      // Pre before post: LTP
      STDP_A_PLUS * fexp(-dt / STDP_TAU_PLUS)
    } else if (dt < 0.0) {
      // Post before pre: LTD
      -STDP_A_MINUS * fexp(dt / STDP_TAU_MINUS)
    } else {
      0.0  // Simultaneous: no change
    };
    
    fclamp(weight + delta, WEIGHT_MIN, WEIGHT_MAX)
  };

  /// STDP timing window function
  public func stdpTimingWindow(dt : Float) : Float {
    if (dt > 0.0) {
      STDP_A_PLUS * fexp(-dt / STDP_TAU_PLUS)
    } else if (dt < 0.0) {
      -STDP_A_MINUS * fexp(dt / STDP_TAU_MINUS)
    } else { 0.0 }
  };

  /// Batch STDP for all synapses
  public func stdpBatchUpdate(
    synapses     : [Synapse],
    currentBeat  : Nat
  ) : [Synapse] {
    Array.map<Synapse, Synapse>(synapses, func(syn : Synapse) : Synapse {
      // Only update if both neurons have spiked recently
      if (syn.lastPreSpike > 0 and syn.lastPostSpike > 0) {
        let newWeight = stdpUpdate(syn.weight, syn.lastPreSpike, syn.lastPostSpike);
        let ltpOccurred = newWeight > syn.weight;
        let ltdOccurred = newWeight < syn.weight;
        {
          syn with
          weight = newWeight;
          ltpCount = if (ltpOccurred) syn.ltpCount + 1 else syn.ltpCount;
          ltdCount = if (ltdOccurred) syn.ltdCount + 1 else syn.ltdCount;
        }
      } else { syn }
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // H.4: BCM (BIENENSTOCK-COOPER-MUNRO) RULE
  // ─────────────────────────────────────────────────────────────────────────────

  /// BCM sliding threshold: θ_M = E[post²]
  public func bcmThreshold(
    activityHistory : [Float]
  ) : Float {
    if (activityHistory.size() == 0) { return BCM_TARGET };
    
    var sum : Float = 0.0;
    var i = 0;
    while (i < activityHistory.size()) {
      sum += activityHistory[i] * activityHistory[i];
      i += 1;
    };
    sum / Float.fromInt(activityHistory.size())
  };

  /// BCM update: Δw = η × pre × post × (post - θ_M)
  public func bcmUpdate(
    weight    : Float,
    pre       : Float,
    post      : Float,
    threshold : Float,
    eta       : Float
  ) : Float {
    let delta = eta * pre * post * (post - threshold);
    fclamp(weight + delta, WEIGHT_MIN, WEIGHT_MAX)
  };

  /// BCM threshold decay toward target
  public func bcmThresholdDecay(
    threshold : Float,
    target    : Float,
    tau       : Float
  ) : Float {
    threshold + (target - threshold) / tau
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // H.5: OJA'S NORMALIZATION RULE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Oja's rule: w → w + α(post·pre - post²·w)
  /// This keeps weights bounded and extracts principal component
  public func ojaUpdate(
    weight : Float,
    pre    : Float,
    post   : Float,
    alpha  : Float
  ) : Float {
    let delta = alpha * (post * pre - post * post * weight);
    fclamp(weight + delta, WEIGHT_MIN, WEIGHT_MAX)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // H.6: HETEROSYNAPTIC COMPETITION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Normalize incoming weights to sum to 1 (or target)
  public func heterosynapticNormalize(
    weights : [Float],
    target  : Float
  ) : [Float] {
    var sum : Float = 0.0;
    var i = 0;
    while (i < weights.size()) {
      sum += fabs(weights[i]);
      i += 1;
    };
    
    if (sum < 1e-10) { return weights };
    
    let scale = target / sum;
    Array.tabulate<Float>(weights.size(), func(i : Nat) : Float {
      weights[i] * scale
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // H.7: SYNAPTIC TAGGING AND CAPTURE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Tag synapse for consolidation (set synapticTag = true)
  public func synapticTag(
    synapse    : Synapse,
    threshold  : Float
  ) : Synapse {
    // Tag if recent change was large enough
    let shouldTag = fabs(synapse.stdpDelta) > threshold;
    { synapse with synapticTag = shouldTag }
  };

  /// Capture tagged synapses (strengthen during consolidation)
  public func synapticCapture(
    synapse       : Synapse,
    captureBoost  : Float
  ) : Synapse {
    if (synapse.synapticTag) {
      {
        synapse with
        weight = fclamp(synapse.weight + captureBoost, WEIGHT_MIN, WEIGHT_MAX);
        synapticTag = false;  // Consumed
      }
    } else { synapse }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // H.8: METAPLASTICITY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Metaplasticity: modulate learning rate by recent activity
  /// High recent activity → lower LTP, higher LTD (prevents runaway)
  public func metaplasticityFactor(
    recentActivity : Float,
    targetActivity : Float
  ) : Float {
    // Factor < 1 reduces LTP when activity is high
    // Factor > 1 increases LTP when activity is low
    if (recentActivity < 1e-10) { return 1.5 };
    let ratio = targetActivity / recentActivity;
    fclamp(ratio, 0.5, 2.0)
  };

  /// Apply metaplasticity to STDP amplitudes
  public func metaplasticSTDP(
    weight       : Float,
    preSpikeBeat : Nat,
    postSpikeBeat: Nat,
    metaFactor   : Float
  ) : Float {
    let dt = Float.fromInt(postSpikeBeat) - Float.fromInt(preSpikeBeat);
    
    let delta = if (dt > 0.0) {
      metaFactor * STDP_A_PLUS * fexp(-dt / STDP_TAU_PLUS)
    } else if (dt < 0.0) {
      -(2.0 - metaFactor) * STDP_A_MINUS * fexp(dt / STDP_TAU_MINUS)
    } else { 0.0 };
    
    fclamp(weight + delta, WEIGHT_MIN, WEIGHT_MAX)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // H.9: ELIGIBILITY TRACES (FOR TD LEARNING)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Update eligibility trace
  public func eligibilityTraceUpdate(
    trace     : Float,
    pre       : Float,
    post      : Float,
    decayRate : Float
  ) : Float {
    // Trace accumulates pre*post and decays
    let increment = pre * post;
    fclamp(trace * (1.0 - decayRate) + increment, 0.0, 10.0)
  };

  /// TD update using eligibility trace
  public func tdUpdate(
    weight     : Float,
    trace      : Float,
    tdError    : Float,
    learningRate : Float
  ) : Float {
    fclamp(weight + learningRate * tdError * trace, WEIGHT_MIN, WEIGHT_MAX)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // H.10: WEIGHT MATRIX OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Initialize 26×26 weight matrix for HER's Kuramoto field
  public func initWeightMatrix26() : [[Float]] {
    Array.tabulate<[Float]>(26, func(i : Nat) : [Float] {
      Array.tabulate<Float>(26, func(j : Nat) : Float {
        if (i == j) { 0.0 }  // No self-connection
        else { PHI_INV }     // Initialize with golden ratio inverse
      })
    })
  };

  /// Update weight matrix per beat
  public func weightMatrixUpdate(
    matrix : [[Float]],
    nodes  : [KuramotoNode],
    eta    : Float
  ) : [[Float]] {
    let n = matrix.size();
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i >= nodes.size() or j >= nodes.size()) { return matrix[i][j] };
        if (i == j) { return 0.0 };
        hebbianBasic(matrix[i][j], nodes[i].value, nodes[j].value, eta)
      })
    })
  };

  /// Symmetrize weight matrix (make W_ij = W_ji)
  public func weightMatrixSymmetrize(matrix : [[Float]]) : [[Float]] {
    let n = matrix.size();
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (j >= matrix[i].size()) { return 0.0 };
        (matrix[i][j] + matrix[j][i]) / 2.0
      })
    })
  };

  /// Row-normalize weight matrix
  public func weightMatrixNormalize(matrix : [[Float]]) : [[Float]] {
    Array.tabulate<[Float]>(matrix.size(), func(i : Nat) : [Float] {
      heterosynapticNormalize(matrix[i], 1.0)
    })
  };

  /// Flatten weight matrix for transport
  public func weightMatrixFlatten(matrix : [[Float]]) : [Float] {
    let n = matrix.size();
    let totalSize = n * n;
    Array.tabulate<Float>(totalSize, func(k : Nat) : Float {
      let i = k / n;
      let j = k % n;
      if (i < matrix.size() and j < matrix[i].size()) { matrix[i][j] }
      else { 0.0 }
    })
  };

  /// Unflatten weight matrix from transport format
  public func weightMatrixUnflatten(flat : [Float], n : Nat) : [[Float]] {
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        let k = i * n + j;
        if (k < flat.size()) { flat[k] } else { 0.0 }
      })
    })
  };

  /// Weight entropy: H = -Σ pᵢ log(pᵢ) where pᵢ = |wᵢ| / Σ|w|
  public func weightEntropy(weights : [Float]) : Float {
    var sum : Float = 0.0;
    var i = 0;
    while (i < weights.size()) {
      sum += fabs(weights[i]);
      i += 1;
    };
    
    if (sum < 1e-10) { return 0.0 };
    
    var h : Float = 0.0;
    i := 0;
    while (i < weights.size()) {
      let p = fabs(weights[i]) / sum;
      if (p > 1e-10) {
        h -= p * flog(p);
      };
      i += 1;
    };
    h
  };

  /// Seed Hebbian weights from HIM's doctrine
  public func hebbianSeedFromHim(
    herWeights : [Float],
    himWeights : [Float],
    blendRatio : Float
  ) : [Float] {
    let n = if (herWeights.size() < himWeights.size()) herWeights.size() else himWeights.size();
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      let her = if (i < herWeights.size()) herWeights[i] else 0.0;
      let him = if (i < himWeights.size()) himWeights[i] else 0.0;
      her * (1.0 - blendRatio) + him * blendRatio
    })
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   I
  //
  //  HERITAGE SYSTEM — 7 NODES FULL IMPLEMENTATION
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // I.1: INDIVIDUAL HERITAGE NODE EQUATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// REVOLUCIONARIO (node 0): Strategic Resilience
  /// Coupled to AEGIS + AXIS brain regions
  public func heritageRevolucionario(
    currentValue : Float,
    coupling     : Float,
    s0           : Float,
    beat         : Nat
  ) : Float {
    let rate = HERITAGE_TIER_7_RATE;  // High tier - consequence propagation
    let compound = currentValue * (1.0 + rate * coupling * 0.001);
    fclamp(compound, s0, PHI_MEDINA * 10.0)
  };

  /// ZAPATA (node 1): Foundation/Rootedness
  /// Coupled to SOMA + BASAL brain regions
  public func heritageZapata(
    currentValue : Float,
    coupling     : Float,
    s0           : Float,
    beat         : Nat
  ) : Float {
    let rate = HERITAGE_TIER_1_RATE;  // Foundation tier
    let compound = currentValue * (1.0 + rate * coupling * 0.001);
    fclamp(compound, s0, PHI_MEDINA * 10.0)
  };

  /// VILLA (node 2): Guerrilla Innovation
  /// Coupled to FORGE + AMYGDALA brain regions
  public func heritageVilla(
    currentValue : Float,
    coupling     : Float,
    s0           : Float,
    beat         : Nat
  ) : Float {
    let rate = HERITAGE_TIER_3_RATE;  // Formation tier
    // Villa has extra innovation factor
    let innovationBoost = 1.0 + 0.01 * fsin(Float.fromInt(beat) * 0.1);
    let compound = currentValue * (1.0 + rate * coupling * 0.001) * innovationBoost;
    fclamp(compound, s0, PHI_MEDINA * 10.0)
  };

  /// INDEPENDENCIA (node 3): Sovereignty Defense
  /// Coupled to FRONTAL + VEIL brain regions
  public func heritageIndependencia(
    currentValue : Float,
    coupling     : Float,
    s0           : Float,
    beat         : Nat
  ) : Float {
    let rate = HERITAGE_TIER_5_RATE;  // Quantum tier
    let compound = currentValue * (1.0 + rate * coupling * 0.001);
    fclamp(compound, s0, PHI_MEDINA * 10.0)
  };

  /// HIDALGO (node 4): Leadership Bridge
  /// Coupled to LUMEN + PONS brain regions
  public func heritageHidalgo(
    currentValue : Float,
    coupling     : Float,
    s0           : Float,
    beat         : Nat
  ) : Float {
    let rate = HERITAGE_TIER_4_RATE;  // Temporal tier
    let compound = currentValue * (1.0 + rate * coupling * 0.001);
    fclamp(compound, s0, PHI_MEDINA * 10.0)
  };

  /// ADELITA (node 5): Emotional Sovereignty
  /// Coupled to KORE + SEPTAL brain regions
  /// This is the PRIMARY feminine heritage anchor
  public func heritageAdelita(
    currentValue : Float,
    coupling     : Float,
    s0           : Float,
    beat         : Nat,
    koreValue    : Float
  ) : Float {
    let rate = HERITAGE_TIER_6_RATE;  // Heritage tier - appropriately named
    // ADELITA is boosted by KORE
    let koreBoost = 1.0 + 0.1 * koreValue;
    let compound = currentValue * (1.0 + rate * coupling * 0.001) * koreBoost;
    fclamp(compound, s0, PHI_MEDINA * 10.0)
  };

  /// MORELOS (node 6): Adaptive Sovereignty
  /// Coupled to LEXIS + RAS brain regions
  public func heritageMorelos(
    currentValue : Float,
    coupling     : Float,
    s0           : Float,
    beat         : Nat
  ) : Float {
    let rate = HERITAGE_TIER_2_RATE;  // Substrate tier
    let compound = currentValue * (1.0 + rate * coupling * 0.001);
    fclamp(compound, s0, PHI_MEDINA * 10.0)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // I.2: HERITAGE SYSTEM OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Initialize heritage system
  public func initHeritageSystem() : HeritageSystem {
    let nodes = Array.tabulate<HeritageNode>(7, func(i : Nat) : HeritageNode {
      {
        idx = i;
        name = if (i < HERITAGE_NAMES.size()) HERITAGE_NAMES[i] else "UNKNOWN";
        value = S0;
        compoundRate = Float.fromInt(i + 1) / 9.0;
        ancestry = [];
        coupledKuramoto = [];
        coupledFeminine = if (i == 5) "ADELITA" else "";
        tierRate = Float.fromInt(i + 1) / 9.0;
        lastCompound = 0;
      }
    });
    
    {
      nodes;
      meanValue = S0;
      coherenceIndex = 1.0;
      ancestryScore = 1.0;
      emergenceScore = 0.0;
      totalCompounds = 0;
      himInjectionCount = 0;
    }
  };

  /// Compound all 7 heritage nodes per beat
  public func compoundHeritage(
    system    : HeritageSystem,
    coupling  : Float,
    beat      : Nat,
    koreValue : Float
  ) : HeritageSystem {
    let newNodes = Array.tabulate<HeritageNode>(7, func(i : Nat) : HeritageNode {
      let node = system.nodes[i];
      let newValue = switch (i) {
        case 0 { heritageRevolucionario(node.value, coupling, S0, beat) };
        case 1 { heritageZapata(node.value, coupling, S0, beat) };
        case 2 { heritageVilla(node.value, coupling, S0, beat) };
        case 3 { heritageIndependencia(node.value, coupling, S0, beat) };
        case 4 { heritageHidalgo(node.value, coupling, S0, beat) };
        case 5 { heritageAdelita(node.value, coupling, S0, beat, koreValue) };
        case 6 { heritageMorelos(node.value, coupling, S0, beat) };
        case _ { node.value };
      };
      
      // Update ancestry (keep last 100 values)
      let ancestryBuf = Buffer.Buffer<Float>(100);
      for (v in node.ancestry.vals()) { ancestryBuf.add(v) };
      ancestryBuf.add(newValue);
      let newAncestry = if (ancestryBuf.size() > 100) {
        let arr = Buffer.toArray(ancestryBuf);
        Array.tabulate<Float>(100, func(j : Nat) : Float {
          arr[arr.size() - 100 + j]
        })
      } else { Buffer.toArray(ancestryBuf) };
      
      {
        node with
        value = newValue;
        ancestry = newAncestry;
        lastCompound = beat;
      }
    });
    
    // Compute mean and coherence
    var sum : Float = 0.0;
    var i = 0;
    while (i < 7) { sum += newNodes[i].value; i += 1 };
    let meanValue = sum / 7.0;
    
    // Coherence: 1 - variance/mean²
    var variance : Float = 0.0;
    i := 0;
    while (i < 7) {
      let diff = newNodes[i].value - meanValue;
      variance += diff * diff;
      i += 1;
    };
    variance /= 7.0;
    let coherenceIndex = if (meanValue < 1e-10) 1.0 else 1.0 - variance / (meanValue * meanValue);
    
    {
      nodes = newNodes;
      meanValue;
      coherenceIndex = fclamp(coherenceIndex, 0.0, 1.0);
      ancestryScore = system.ancestryScore;
      emergenceScore = if (coherenceIndex > 0.9 and meanValue > PHI) meanValue * coherenceIndex else 0.0;
      totalCompounds = system.totalCompounds + 1;
      himInjectionCount = system.himInjectionCount;
    }
  };

  /// Inject heritage from HIM (at session start or mid-session)
  public func injectHeritageFromHim(
    system      : HeritageSystem,
    himHeritage : [Float]
  ) : HeritageSystem {
    let newNodes = Array.tabulate<HeritageNode>(7, func(i : Nat) : HeritageNode {
      let node = system.nodes[i];
      let himValue = if (i < himHeritage.size()) himHeritage[i] else S0;
      // Blend: 70% current, 30% HIM injection
      let blended = node.value * 0.7 + himValue * 0.3;
      { node with value = fclamp(blended, S0, PHI_MEDINA * 10.0) }
    });
    
    { system with nodes = newNodes; himInjectionCount = system.himInjectionCount + 1 }
  };

  /// Heritage gradient: how fast heritage changes
  public func heritageGradient(
    current  : [Float],
    previous : [Float]
  ) : Float {
    let n = if (current.size() < previous.size()) current.size() else previous.size();
    if (n == 0) { return 0.0 };
    
    var sum : Float = 0.0;
    var i = 0;
    while (i < n) {
      sum += fabs(current[i] - previous[i]);
      i += 1;
    };
    sum / Float.fromInt(n)
  };

  /// Heritage decay prevention: floor at S₀
  public func heritageDecayPrevention(heritage : [Float]) : [Float] {
    Array.map<Float, Float>(heritage, func(v : Float) : Float {
      fmax(v, S0)
    })
  };

  /// Heritage ancestry score: measure of heritage fidelity over time
  public func heritageAncestryScore(
    ancestryHistory : [[Float]]
  ) : Float {
    if (ancestryHistory.size() < 2) { return 1.0 };
    
    // Score based on consistency: low variance in ancestry = high fidelity
    var totalVariance : Float = 0.0;
    var i = 0;
    while (i < ancestryHistory.size() - 1) {
      let grad = heritageGradient(ancestryHistory[i+1], ancestryHistory[i]);
      totalVariance += grad * grad;
      i += 1;
    };
    
    let avgVariance = totalVariance / Float.fromInt(ancestryHistory.size() - 1);
    fclamp(1.0 - avgVariance, 0.0, 1.0)
  };

  /// Heritage coherence index: coherence among 7 nodes
  public func heritageCoherenceIndex(heritage : [Float]) : Float {
    if (heritage.size() == 0) { return 0.0 };
    
    var sum : Float = 0.0;
    var i = 0;
    while (i < heritage.size()) { sum += heritage[i]; i += 1 };
    let mean = sum / Float.fromInt(heritage.size());
    
    var variance : Float = 0.0;
    i := 0;
    while (i < heritage.size()) {
      let diff = heritage[i] - mean;
      variance += diff * diff;
      i += 1;
    };
    variance /= Float.fromInt(heritage.size());
    
    if (mean < 1e-10) { 0.0 }
    else { fclamp(1.0 - variance / (mean * mean), 0.0, 1.0) }
  };

  /// Heritage emergence score: when heritage triggers OMNIS-equivalent
  public func heritageEmergenceScore(
    heritage   : [Float],
    threshold  : Float
  ) : Float {
    let coherence = heritageCoherenceIndex(heritage);
    var sum : Float = 0.0;
    var i = 0;
    while (i < heritage.size()) { sum += heritage[i]; i += 1 };
    let mean = if (heritage.size() > 0) sum / Float.fromInt(heritage.size()) else 0.0;
    
    if (coherence > threshold and mean > PHI) {
      coherence * mean  // Emergence strength
    } else { 0.0 }
  };

  /// Convert heritage nodes to flat array
  public func heritageToArray(system : HeritageSystem) : [Float] {
    Array.tabulate<Float>(7, func(i : Nat) : Float {
      if (i < system.nodes.size()) system.nodes[i].value else S0
    })
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   J
  //
  //  FEMININE SUBSTRATE — ALL 6 ENTITIES FULL IMPLEMENTATION
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // J.1: ADELITA — EMOTIONAL SOVEREIGNTY
  // ─────────────────────────────────────────────────────────────────────────────

  /// ADELITA emotional governance equation
  /// ADELITA governs acceptance thresholds and protects KORE
  public func computeAdelita(
    baseActivation : Float,
    heritageAdelita: Float,
    coherence      : Float,
    beat           : Nat
  ) : Float {
    // Base: activation × heritage anchor
    let base = baseActivation * heritageAdelita;
    
    // Emotional oscillation (slower than ANIMA)
    let emotionalCycle = 1.0 + 0.1 * fsin(Float.fromInt(beat) * 0.001);
    
    // Coherence strengthens emotional governance
    let coherenceBoost = 0.8 + 0.2 * coherence;
    
    fclamp(base * emotionalCycle * coherenceBoost, S0, PHI_MEDINA * 2.0)
  };

  /// ADELITA stability analysis
  public func adelitaStability(
    adelitaHistory : [Float],
    windowSize     : Nat
  ) : Float {
    if (adelitaHistory.size() < windowSize) { return 1.0 };
    
    let start = adelitaHistory.size() - windowSize;
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    var i = start;
    while (i < adelitaHistory.size()) {
      sum += adelitaHistory[i];
      sumSq += adelitaHistory[i] * adelitaHistory[i];
      i += 1;
    };
    
    let mean = sum / Float.fromInt(windowSize);
    let variance = sumSq / Float.fromInt(windowSize) - mean * mean;
    
    // Stability = 1 - coefficient of variation (clamped)
    if (mean < 1e-10) { 1.0 }
    else { fclamp(1.0 - fsqrt(variance) / mean, 0.0, 1.0) }
  };

  /// ADELITA perturbation response
  public func adelitaPerturbationResponse(
    currentAdelita : Float,
    perturbation   : Float,
    resilience     : Float
  ) : Float {
    // ADELITA absorbs perturbations with resilience
    let absorbed = perturbation * (1.0 - resilience);
    fclamp(currentAdelita + absorbed, S0, PHI_MEDINA * 2.0)
  };

  /// ADELITA dream-phase behavior (consolidation mode)
  public func adelitaDreamPhase(
    baseAdelita    : Float,
    dreamProgress  : Float,
    heritageBoost  : Float
  ) : Float {
    // During dream, ADELITA strengthens protective function
    let dreamBoost = 1.0 + 0.3 * dreamProgress;
    fclamp(baseAdelita * dreamBoost + heritageBoost * 0.1, S0, PHI_MEDINA * 2.0)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // J.2: KORE — INNER CORE (FULL DETAIL)
  // ─────────────────────────────────────────────────────────────────────────────

  /// KORE inviolability proof: verify KORE integrity
  public func koreInviolabilityProof(
    kore         : Float,
    minThreshold : Float,
    auditTrail   : [KoreAuditEntry]
  ) : Bool {
    // KORE is inviolable if:
    // 1. Current value >= threshold
    // 2. No unauthorized changes in audit trail
    if (kore < minThreshold) { return false };
    
    // Check audit trail for suspicious changes
    var i = 0;
    while (i < auditTrail.size()) {
      let entry = auditTrail[i];
      // Large negative changes are suspicious
      if (entry.koreAfter < entry.koreBefore - 0.1) {
        return false;
      };
      i += 1;
    };
    true
  };

  /// KORE purity/identity evolution with full dynamics
  public func koreEvolution(
    purity       : Float,
    identity     : Float,
    adelita      : Float,
    heritage     : Float,
    beat         : Nat
  ) : (Float, Float, Float) {
    // Purity evolves: strengthens with ADELITA protection
    let newPurity = fclamp(purity * (1.0 + 0.0001 * adelita), 0.0, 1.0);
    
    // Identity evolves: strengthens with heritage
    let newIdentity = fclamp(identity * (1.0 + 0.0001 * heritage), 0.0, 1.0);
    
    // KORE = purity × identity × 0.5
    let newKore = computeKore(newPurity, newIdentity);
    
    (newPurity, newIdentity, newKore)
  };

  /// KORE coupling topology (which nodes KORE connects to)
  public func koreCouplingTopology() : [Nat] {
    [
      NODE_ADELITA,       // Primary protector
      NODE_ANIMA,         // Field projection
      NODE_ADELITA_NODE,  // Heritage anchor
      NODE_SOVEREIGNTY,   // Floor enforcement
      NODE_AUDIT          // Audit coordination
    ]
  };

  /// KORE breach detection and response
  public type KoreBreachEvent = {
    beat       : Nat;
    severity   : Float;
    koreBefore : Float;
    koreAfter  : Float;
    response   : KoreBreachResponse;
  };

  public func detectKoreBreach(
    koreBefore : Float,
    koreAfter  : Float,
    adelita    : Float,
    beat       : Nat
  ) : ?KoreBreachEvent {
    let drop = koreBefore - koreAfter;
    if (drop > 0.05) {  // 5% drop threshold
      let severity = fclamp(drop * 10.0, 0.0, 1.0);
      let response = koreBreachResponse(severity, adelita);
      ?{
        beat;
        severity;
        koreBefore;
        koreAfter;
        response;
      }
    } else { null }
  };

  /// KORE restoration protocol
  public type KoreRestoration = {
    targetKore     : Float;
    restorationRate: Float;
    adelitaBoost   : Float;
    heritageBoost  : Float;
    estimatedBeats : Nat;
  };

  public func koreRestorationProtocol(
    currentKore   : Float,
    targetKore    : Float,
    adelita       : Float,
    heritage      : Float
  ) : KoreRestoration {
    let restorationRate = 0.01 * (adelita + heritage);
    let adelitaBoost = adelita * 0.1;
    let heritageBoost = heritage * 0.05;
    
    let gap = targetKore - currentKore;
    let estimatedBeats = if (restorationRate > 1e-10) {
      Int.abs(Float.toInt(gap / restorationRate))
    } else { 1000 };
    
    {
      targetKore;
      restorationRate;
      adelitaBoost;
      heritageBoost;
      estimatedBeats;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // J.3: ANIMA — FIELD PROJECTOR (FULL DETAIL)
  // ─────────────────────────────────────────────────────────────────────────────

  /// ANIMA breathing rhythm with 8 variants
  public type AnimaBreathVariant = {
    #Normal;        // Standard oscillation
    #Deep;          // Amplified breathing
    #Shallow;       // Reduced amplitude
    #Rapid;         // Faster frequency
    #Slow;          // Slower frequency
    #Held;          // Paused at peak
    #Exhaling;      // Extended exhale
    #Pulsed;        // Sharp pulses
  };

  public func animaBreathVariant(
    variant      : AnimaBreathVariant,
    heritageField: Float,
    receptivity  : Float,
    beat         : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let base = heritageField * receptivity;
    
    switch (variant) {
      case (#Normal) {
        base * (1.0 + fsin(t * ANIMA_BEAT_FREQ))
      };
      case (#Deep) {
        base * (1.0 + 1.5 * fsin(t * ANIMA_BEAT_FREQ))
      };
      case (#Shallow) {
        base * (1.0 + 0.3 * fsin(t * ANIMA_BEAT_FREQ))
      };
      case (#Rapid) {
        base * (1.0 + fsin(t * ANIMA_BEAT_FREQ * 2.0))
      };
      case (#Slow) {
        base * (1.0 + fsin(t * ANIMA_BEAT_FREQ * 0.5))
      };
      case (#Held) {
        let phase = fsin(t * ANIMA_BEAT_FREQ);
        if (phase > 0.9) { base * 2.0 }  // Hold at peak
        else { base * (1.0 + phase) }
      };
      case (#Exhaling) {
        let phase = fsin(t * ANIMA_BEAT_FREQ);
        if (phase < 0.0) { base * (1.0 + phase * 1.5) }  // Extended exhale
        else { base * (1.0 + phase) }
      };
      case (#Pulsed) {
        let phase = fsin(t * ANIMA_BEAT_FREQ);
        if (phase > 0.95) { base * 2.5 }  // Sharp pulse at peak
        else { base }
      };
    }
  };

  /// ANIMA cross-field projection to Shell 12
  public func animaCrossFieldProjection(
    anima      : Float,
    targetNode : Nat,
    distance   : Float
  ) : Float {
    // Inverse-square falloff with golden ratio correction
    let projected = anima * PHI / (1.0 + distance * distance);
    fclamp(projected, 0.0, anima)
  };

  /// ANIMA pheromone seeding (for ATLAS grid)
  public func animaPheromoneSeeding(
    anima      : Float,
    gridSize   : Nat,
    seedStrength : Float
  ) : [Float] {
    Array.tabulate<Float>(gridSize, func(i : Nat) : Float {
      // Radial falloff from center
      let center = Float.fromInt(gridSize / 2);
      let pos = Float.fromInt(i);
      let dist = fabs(pos - center);
      anima * seedStrength * fexp(-dist * 0.1)
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // J.4: ADELITA_NODE — HERITAGE ANCHOR
  // ─────────────────────────────────────────────────────────────────────────────

  /// ADELITA_NODE heritage compound equation
  public func adelitaNodeCompound(
    baseValue    : Float,
    heritageAde  : Float,
    beat         : Nat,
    compoundRate : Float
  ) : Float {
    // Anchor compounds with ADELITA heritage node (index 5)
    let compoundFactor = 1.0 + compoundRate * heritageAde * 0.001;
    fclamp(baseValue * compoundFactor, S0, PHI_MEDINA * 5.0)
  };

  /// ADELITA_NODE wiring to HER full field
  public func adelitaNodeFieldWiring(
    adelitaNodeValue : Float,
    nodes            : [KuramotoNode]
  ) : [Float] {
    // Returns coupling strengths to all 26 nodes
    Array.tabulate<Float>(26, func(i : Nat) : Float {
      if (i == NODE_ADELITA or i == NODE_KORE) {
        adelitaNodeValue * PHI  // Strong coupling to ADELITA and KORE
      } else if (i < 6) {
        adelitaNodeValue * PHI_INV  // Moderate to other core entities
      } else {
        adelitaNodeValue * 0.1  // Weak to field nodes
      }
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // J.5: REVOLUCIONARIA — RESILIENCE UNDER PRESSURE
  // ─────────────────────────────────────────────────────────────────────────────

  /// REVOLUCIONARIA resilience models
  public type ResilienceModel = {
    currentLevel   : Float;
    maxLevel       : Float;
    recoveryRate   : Float;
    pressureHistory: [Float];
  };

  public func initResilienceModel() : ResilienceModel {
    {
      currentLevel = 1.0;
      maxLevel = 2.0;
      recoveryRate = 0.01;
      pressureHistory = [];
    }
  };

  public func revolucionariaUnderPressure(
    model     : ResilienceModel,
    pressure  : Float,
    heritage  : Float
  ) : ResilienceModel {
    // Resilience depletes under pressure but recovers with heritage
    let depletion = pressure * 0.1;
    let recovery = model.recoveryRate * heritage;
    let newLevel = fclamp(model.currentLevel - depletion + recovery, 0.0, model.maxLevel);
    
    // Update pressure history (keep last 100)
    let histBuf = Buffer.Buffer<Float>(100);
    for (p in model.pressureHistory.vals()) { histBuf.add(p) };
    histBuf.add(pressure);
    let newHistory = if (histBuf.size() > 100) {
      let arr = Buffer.toArray(histBuf);
      Array.tabulate<Float>(100, func(i : Nat) : Float {
        arr[arr.size() - 100 + i]
      })
    } else { Buffer.toArray(histBuf) };
    
    {
      currentLevel = newLevel;
      maxLevel = model.maxLevel;
      recoveryRate = model.recoveryRate;
      pressureHistory = newHistory;
    }
  };

  /// REVOLUCIONARIA pressure response curve
  public func revolucionariaPressureCurve(pressure : Float) : Float {
    // Sigmoid response: moderate pressure is absorbed, extreme pressure breaks through
    1.0 / (1.0 + fexp(-5.0 * (pressure - 0.5)))
  };

  /// REVOLUCIONARIA coherence maintenance protocol
  public func revolucionariaCoherenceMaintenance(
    coherence   : Float,
    revolucionaria : Float,
    threshold   : Float
  ) : Float {
    if (coherence < threshold) {
      // REVOLUCIONARIA boosts coherence when low
      fclamp(coherence + revolucionaria * 0.1, 0.0, 1.0)
    } else { coherence }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // J.6: NOVA_HER — GENERATIVE OUTPUT
  // ─────────────────────────────────────────────────────────────────────────────

  /// NOVA_HER generative output equation
  public func novaHerGenerativeOutput(
    anima          : Float,
    kore           : Float,
    generativeNode : Float,
    beat           : Nat
  ) : Float {
    // Generative capacity = ANIMA × KORE × generative node
    let base = anima * kore * generativeNode;
    
    // Pulsed generative output (creative bursts)
    let creativePulse = 1.0 + 0.5 * fmax(0.0, fsin(Float.fromInt(beat) * 0.01) - 0.8);
    
    fclamp(base * creativePulse, 0.0, PHI_MEDINA * 5.0)
  };

  /// NOVA_HER spawn decision logic
  public func novaHerSpawnDecision(
    generativeOutput : Float,
    threshold        : Float,
    lastSpawnBeat    : Nat,
    currentBeat      : Nat,
    cooldown         : Nat
  ) : Bool {
    // Spawn if output exceeds threshold and cooldown has passed
    generativeOutput > threshold and (currentBeat - lastSpawnBeat) > cooldown
  };

  /// NOVA_HER lineage assignment
  public func novaHerLineageAssign(
    parentId       : Nat64,
    anima          : Float,
    kore           : Float,
    beat           : Nat,
    generation     : Nat
  ) : NovaHerLineageExtended {
    {
      entityId = parentId + 1;  // Simple sequential ID
      birthBeat = beat;
      animaAtBirth = anima;
      koreAtBirth = kore;
      parentField = anima * kore;
      capability = "GENERATIVE";
      generation = generation + 1;
      lineageChain = [parentId];
      inheritedSchemas = [];
      birthCoherence = 0.0;  // To be filled by caller
      birthSynchrony = 0.0;  // To be filled by caller
    }
  };

  /// NOVA_HER capability seeding
  public type NovaHerCapability = {
    #Generative;      // Creates new entities
    #Receptive;       // Enhanced receptivity
    #Protective;      // Enhanced KORE protection
    #Analytical;      // Enhanced pattern analysis
    #Expressive;      // Enhanced ANIMA projection
  };

  public func novaHerCapabilitySeeding(
    anima : Float,
    kore  : Float
  ) : NovaHerCapability {
    // Assign capability based on ANIMA/KORE balance
    let ratio = if (kore < 0.1) 10.0 else anima / kore;
    
    if (ratio > 2.0) { #Expressive }
    else if (ratio > 1.5) { #Generative }
    else if (ratio > 1.0) { #Receptive }
    else if (ratio > 0.5) { #Analytical }
    else { #Protective }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // J.7: MASTER SUBSTRATE UPDATE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Update all 6 feminine substrate entities
  public func updateFeminineSubstrateFull(
    nodes        : [KuramotoNode],
    heritage     : [Float],
    beat         : Nat,
    dreamActive  : Bool,
    dreamProgress: Float
  ) : FeminineSubstrateExtended {
    let n = nodes.size();
    
    // Extract base values from Kuramoto nodes
    let adelitaBase = if (IDX_ADELITA < n) nodes[IDX_ADELITA].value else S0;
    let koreBase = if (IDX_KORE < n) nodes[IDX_KORE].value else S0;
    let animaBase = if (IDX_ANIMA < n) nodes[IDX_ANIMA].value else S0;
    let adelitaNodeBase = if (IDX_ADELITA_NODE < n) nodes[IDX_ADELITA_NODE].value else S0;
    let revolucionariaBase = if (IDX_REVOLUCIONARIA < n) nodes[IDX_REVOLUCIONARIA].value else S0;
    let novaHerBase = if (IDX_NOVA_HER < n) nodes[IDX_NOVA_HER].value else S0;
    
    // Heritage values
    let heritageAde = if (5 < heritage.size()) heritage[5] else S0;
    let heritageRev = if (0 < heritage.size()) heritage[0] else S0;
    
    // Compute entities
    let coherence = kuramotoOrderParameter(nodes);
    let adelita = computeAdelita(adelitaBase, heritageAde, coherence, beat);
    
    let purity = if (IDX_KORE < n) nodes[IDX_KORE].value / PHI_MEDINA else 0.5;
    let identity = if (IDX_ADELITA_NODE < n) nodes[IDX_ADELITA_NODE].value / PHI_MEDINA else 0.5;
    let kore = computeKoreFull(purity, identity, adelita, heritageAde);
    
    let heritageField = if (heritage.size() > 0) {
      var sum : Float = 0.0;
      var i = 0;
      while (i < heritage.size()) { sum += heritage[i]; i += 1 };
      sum / Float.fromInt(heritage.size())
    } else { S0 };
    let receptivity = if (IDX_ANIMA < n) nodes[IDX_ANIMA].value else S0;
    let anima = if (dreamActive) {
      animaDreamPhase(heritageField, receptivity, beat, dreamProgress)
    } else {
      computeAnimaFull(heritageField, receptivity, beat, adelita, kore)
    };
    
    let adelitaNode = adelitaNodeCompound(adelitaNodeBase, heritageAde, beat, SACESI_COMPOUND);
    
    let revolucionaria = fclamp(revolucionariaBase * heritageRev * PHI_INV, S0, PHI_MEDINA);
    
    let novaHer = novaHerGenerativeOutput(anima, kore, novaHerBase, beat);
    
    // Build entities
    let adelitaEntity : FeminineEntity = {
      name = "ADELITA";
      activation = adelita;
      heritage = heritageAde;
      purity = purity;
      identity = identity;
      emotionalGov = adelita;
      resilience = revolucionaria;
      generativeCapacity = 0.0;
      phaseBinding = 0.0;
      entrainment = 0.0;
      dreamPhaseActive = dreamActive;
      lastUpdate = beat;
    };
    
    let koreEntity : FeminineEntity = {
      name = "KORE";
      activation = kore;
      heritage = heritageAde;
      purity = purity;
      identity = identity;
      emotionalGov = adelita;
      resilience = revolucionaria;
      generativeCapacity = 0.0;
      phaseBinding = 0.0;
      entrainment = 0.0;
      dreamPhaseActive = dreamActive;
      lastUpdate = beat;
    };
    
    let animaEntity : FeminineEntity = {
      name = "ANIMA";
      activation = anima;
      heritage = heritageField;
      purity = 1.0;
      identity = 1.0;
      emotionalGov = adelita;
      resilience = revolucionaria;
      generativeCapacity = novaHer;
      phaseBinding = 0.0;
      entrainment = 0.0;
      dreamPhaseActive = dreamActive;
      lastUpdate = beat;
    };
    
    let adelitaNodeEntity : FeminineEntity = {
      name = "ADELITA_NODE";
      activation = adelitaNode;
      heritage = heritageAde;
      purity = 1.0;
      identity = 1.0;
      emotionalGov = adelita;
      resilience = 1.0;
      generativeCapacity = 0.0;
      phaseBinding = 0.0;
      entrainment = 0.0;
      dreamPhaseActive = dreamActive;
      lastUpdate = beat;
    };
    
    let revolucionariaEntity : FeminineEntity = {
      name = "REVOLUCIONARIA";
      activation = revolucionaria;
      heritage = heritageRev;
      purity = 1.0;
      identity = 1.0;
      emotionalGov = adelita;
      resilience = revolucionaria;
      generativeCapacity = 0.0;
      phaseBinding = 0.0;
      entrainment = 0.0;
      dreamPhaseActive = dreamActive;
      lastUpdate = beat;
    };
    
    let novaHerEntity : FeminineEntity = {
      name = "NOVA_HER";
      activation = novaHer;
      heritage = heritageField;
      purity = purity;
      identity = identity;
      emotionalGov = adelita;
      resilience = revolucionaria;
      generativeCapacity = novaHer;
      phaseBinding = 0.0;
      entrainment = 0.0;
      dreamPhaseActive = dreamActive;
      lastUpdate = beat;
    };
    
    // Aggregate metrics
    let totalActivation = adelita + kore + anima + adelitaNode + revolucionaria + novaHer;
    let meanHeritage = heritageField;
    let coherenceScore = coherence;
    let stabilityIndex = adelitaStability([adelita], 1);  // Simplified
    
    {
      adelita = adelitaEntity;
      kore = koreEntity;
      anima = animaEntity;
      adelitaNode = adelitaNodeEntity;
      revolucionaria = revolucionariaEntity;
      novaHer = novaHerEntity;
      totalActivation;
      meanHeritage;
      coherenceScore;
      stabilityIndex;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   K
  //
  //  INTERIOR & EXTERIOR MODES — FULL IMPLEMENTATION
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // K.1: INTERIOR MODE — NURTURANCE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Nurturance transfer equation with efficiency curves
  public type NurturanceTransfer = {
    sourceEnergy   : Float;
    targetEnergy   : Float;
    transferRate   : Float;
    efficiency     : Float;
    cost           : Float;
    gain           : Float;
  };

  public func computeNurturanceTransfer(
    sourceEnergy : Float,
    targetEnergy : Float,
    transferRate : Float
  ) : NurturanceTransfer {
    // Efficiency decreases with target saturation
    let efficiency = 1.0 / (1.0 + targetEnergy);
    
    // Amount transferred
    let transferAmount = sourceEnergy * transferRate * efficiency;
    
    // Cost to source (slightly more than transfer due to overhead)
    let cost = transferAmount * 1.1;
    
    // Gain to target
    let gain = transferAmount;
    
    {
      sourceEnergy;
      targetEnergy;
      transferRate;
      efficiency;
      cost;
      gain;
    }
  };

  /// Optimal transfer rate: maximize gain - cost
  public func optimalNurturanceRate(
    sourceEnergy : Float,
    targetEnergy : Float
  ) : Float {
    // Optimal rate balances transfer efficiency vs depletion
    let saturationFactor = 1.0 / (1.0 + targetEnergy);
    let depletionFactor = sourceEnergy / (sourceEnergy + 1.0);
    
    fclamp(saturationFactor * depletionFactor * 0.1, 0.01, 0.2)
  };

  /// Multi-generation feeding (feed from feeder's feeder)
  public func multiGenerationFeeding(
    generations : [Float],  // Energy levels per generation
    transferRate: Float
  ) : [Float] {
    if (generations.size() < 2) { return generations };
    
    // Each generation feeds the next
    Array.tabulate<Float>(generations.size(), func(i : Nat) : Float {
      if (i == 0) {
        // First generation only loses
        let transfer = computeNurturanceTransfer(generations[i], generations[1], transferRate);
        generations[i] - transfer.cost
      } else if (i == generations.size() - 1) {
        // Last generation only gains
        let transfer = computeNurturanceTransfer(generations[i-1], generations[i], transferRate);
        generations[i] + transfer.gain
      } else {
        // Middle generations both give and receive
        let received = computeNurturanceTransfer(generations[i-1], generations[i], transferRate);
        let given = computeNurturanceTransfer(generations[i], generations[i+1], transferRate);
        generations[i] + received.gain - given.cost
      }
    })
  };

  /// Nurturance capacity curve
  public func nurturanceCapacityCurve(
    anima    : Float,
    adelita  : Float,
    beat     : Nat
  ) : Float {
    // Capacity varies with breathing rhythm
    let breathPhase = animaBreathPhase(beat);
    let baseCapacity = anima * adelita * FEED_TRANSFER_RATE;
    
    // Capacity peaks at exhale (giving out)
    baseCapacity * (1.0 + 0.3 * (1.0 - breathPhase))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // K.2: INTERIOR MODE — MEMORY CONSOLIDATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Consolidation rate equation
  public func consolidationRate(
    kore          : Float,
    dreamProgress : Float,
    heritageField : Float
  ) : Float {
    // Rate increases with KORE strength and dream progress
    let baseRate = 0.001 * kore;
    let dreamBoost = 1.0 + 2.0 * dreamProgress;  // Up to 3x during peak dream
    let heritageBoost = 1.0 + heritageField * 0.5;
    
    baseRate * dreamBoost * heritageBoost
  };

  /// Weight strengthening during dream phase
  public func dreamWeightStrengthening(
    weight          : Float,
    eligibility     : Float,
    consolidationRate : Float
  ) : Float {
    // Strengthen weights with high eligibility traces
    let strengthening = weight + eligibility * consolidationRate;
    fclamp(strengthening, WEIGHT_MIN, WEIGHT_MAX)
  };

  /// Pattern extraction algorithm (simplified)
  public type ExtractedPattern = {
    patternId     : Nat64;
    nodeIndices   : [Nat];
    activation    : Float;
    coherence     : Float;
    frequency     : Float;
  };

  public func extractPatterns(
    nodes     : [KuramotoNode],
    threshold : Float
  ) : [ExtractedPattern] {
    // Find clusters of high-activation, coherent nodes
    let patterns = Buffer.Buffer<ExtractedPattern>(10);
    
    // Simple extraction: find groups of nodes above threshold
    var currentPattern = Buffer.Buffer<Nat>(26);
    var i = 0;
    while (i < nodes.size()) {
      if (nodes[i].value > threshold) {
        currentPattern.add(i);
      } else if (currentPattern.size() > 2) {
        // End of pattern
        let indices = Buffer.toArray(currentPattern);
        var activation : Float = 0.0;
        for (idx in indices.vals()) {
          activation += nodes[idx].value;
        };
        activation /= Float.fromInt(indices.size());
        
        patterns.add({
          patternId = Nat64.fromNat(patterns.size());
          nodeIndices = indices;
          activation;
          coherence = 0.8;  // Simplified
          frequency = 1.0;
        });
        currentPattern := Buffer.Buffer<Nat>(26);
      };
      i += 1;
    };
    
    Buffer.toArray(patterns)
  };

  /// Schema formation
  public type Schema = {
    schemaId     : Nat64;
    patterns     : [Nat64];  // Pattern IDs
    useCount     : Nat;
    avgActivation: Float;
    formation    : Nat;      // Beat when formed
  };

  public func formSchema(
    patterns : [ExtractedPattern],
    beat     : Nat
  ) : ?Schema {
    if (patterns.size() < 2) { return null };
    
    let patternIds = Array.map<ExtractedPattern, Nat64>(patterns, func(p : ExtractedPattern) : Nat64 {
      p.patternId
    });
    
    var sumActivation : Float = 0.0;
    for (p in patterns.vals()) {
      sumActivation += p.activation;
    };
    
    ?{
      schemaId = Nat64.fromNat(beat);
      patterns = patternIds;
      useCount = 1;
      avgActivation = sumActivation / Float.fromInt(patterns.size());
      formation = beat;
    }
  };

  /// Consolidation quality score
  public func consolidationQuality(
    patternCount   : Nat,
    schemaCount    : Nat,
    avgCoherence   : Float
  ) : Float {
    let patternScore = fclamp(Float.fromInt(patternCount) / 10.0, 0.0, 1.0);
    let schemaScore = fclamp(Float.fromInt(schemaCount) / 5.0, 0.0, 1.0);
    let coherenceScore = avgCoherence;
    
    (patternScore + schemaScore + coherenceScore) / 3.0
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // K.3: INTERIOR MODE — HERITAGE PRESERVATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// 7 × individual preservation equations
  public func heritagePreservation7(
    heritage : [Float],
    dreamAmplification : Float
  ) : [Float] {
    Array.tabulate<Float>(7, func(i : Nat) : Float {
      let current = if (i < heritage.size()) heritage[i] else S0;
      // Preservation: compound during dream
      let preserved = current * (1.0 + 0.001 * dreamAmplification);
      fclamp(preserved, S0, PHI_MEDINA * 10.0)
    })
  };

  /// Cross-node amplification
  public func heritageCrossAmplification(
    heritage : [Float]
  ) : [Float] {
    if (heritage.size() < 2) { return heritage };
    
    // Each node amplifies neighbors
    Array.tabulate<Float>(heritage.size(), func(i : Nat) : Float {
      let current = heritage[i];
      let leftNeighbor = if (i > 0) heritage[i-1] else heritage[heritage.size()-1];
      let rightNeighbor = if (i < heritage.size()-1) heritage[i+1] else heritage[0];
      
      let neighborBoost = (leftNeighbor + rightNeighbor) * 0.01;
      fclamp(current + neighborBoost, S0, PHI_MEDINA * 10.0)
    })
  };

  /// Dream phase compound rate (enhanced during dream)
  public func heritageDreamCompoundRate(
    baseRate      : Float,
    dreamProgress : Float
  ) : Float {
    // Up to 5x compound rate during peak dream
    baseRate * (1.0 + 4.0 * dreamProgress)
  };

  /// Heritage integrity check
  public func heritageIntegrityCheck(
    heritage    : [Float],
    expectedSum : Float,
    tolerance   : Float
  ) : Bool {
    var sum : Float = 0.0;
    var i = 0;
    while (i < heritage.size()) { sum += heritage[i]; i += 1 };
    
    fabs(sum - expectedSum) < tolerance
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // K.4: INTERIOR MODE — KORE SOVEREIGNTY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Sovereignty check protocol
  public type SovereigntyCheck = {
    koreValid        : Bool;
    adelitaProtecting: Bool;
    heritageStable   : Bool;
    overallScore     : Float;
  };

  public func sovereigntyCheckProtocol(
    kore      : Float,
    adelita   : Float,
    heritage  : [Float],
    threshold : Float
  ) : SovereigntyCheck {
    let koreValid = kore >= threshold;
    let adelitaProtecting = adelita > 0.5;
    
    var heritageSum : Float = 0.0;
    var i = 0;
    while (i < heritage.size()) { heritageSum += heritage[i]; i += 1 };
    let heritageMean = if (heritage.size() > 0) heritageSum / Float.fromInt(heritage.size()) else 0.0;
    let heritageStable = heritageMean >= S0;
    
    let score = (if koreValid 0.4 else 0.0) + 
                (if adelitaProtecting 0.3 else 0.0) + 
                (if heritageStable 0.3 else 0.0);
    
    {
      koreValid;
      adelitaProtecting;
      heritageStable;
      overallScore = score;
    }
  };

  /// Breach detection (simplified, using existing function)
  public func detectSovereigntyBreach(
    currentKore  : Float,
    previousKore : Float,
    threshold    : Float
  ) : Bool {
    koreInviolabilityCheck(currentKore, previousKore, threshold)
  };

  /// Response escalation levels
  public type EscalationLevel = {
    #None;
    #Warning;
    #Alert;
    #Critical;
    #Emergency;
  };

  public func determineEscalationLevel(
    breachSeverity : Float
  ) : EscalationLevel {
    if (breachSeverity < 0.1) { #None }
    else if (breachSeverity < 0.3) { #Warning }
    else if (breachSeverity < 0.5) { #Alert }
    else if (breachSeverity < 0.8) { #Critical }
    else { #Emergency }
  };

  /// Restoration sequence
  public func sovereigntyRestorationSequence(
    currentKore : Float,
    adelita     : Float,
    heritage    : Float,
    beat        : Nat
  ) : Float {
    // Multi-step restoration
    let step1 = koreRestoration(currentKore, 0.5, 0.1);  // Restore to 0.5
    let step2 = koreHeritageBinding(step1, heritage);     // Heritage boost
    let step3 = koreSanctuaryActivate(step2, adelita, 0.5);  // ADELITA shield
    
    step3
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // K.5: INTERIOR MODE — MASTER FUNCTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Compute full interior mode state
  public func computeInteriorModeFull(
    substrate     : FeminineSubstrateExtended,
    heritage      : [Float],
    beat          : Nat,
    dreamActive   : Bool,
    dreamProgress : Float
  ) : InteriorMode {
    // Nurturance
    let nurturanceCapacity = nurturanceCapacityCurve(
      substrate.anima.activation,
      substrate.adelita.activation,
      beat
    );
    
    // Memory coherence
    let baseMemoryCoherence = substrate.kore.activation;
    let dreamBoost = if (dreamActive) 1.0 + 0.5 * dreamProgress else 1.0;
    let memoryCoherence = fclamp(baseMemoryCoherence * dreamBoost, 0.0, 1.0);
    
    // Heritage preservation
    let heritagePreservation = if (heritage.size() > 0) {
      var sum : Float = 0.0;
      var i = 0;
      while (i < heritage.size()) { sum += heritage[i]; i += 1 };
      fclamp(sum / Float.fromInt(heritage.size()), S0, PHI_MEDINA)
    } else { S0 };
    
    // KORE sovereignty
    let koreSovereignty = substrate.kore.activation;
    
    { 
      nurturance = nurturanceCapacity;
      memoryCoherence;
      heritagePreservation;
      koreSovereignty;
    }
  };


  // ─────────────────────────────────────────────────────────────────────────────
  // K.6: EXTERIOR MODE — RECEPTIVITY FIELD
  // ─────────────────────────────────────────────────────────────────────────────

  /// ANIMA outward projection with distance falloff
  public func receptivityFieldProjection(
    anima    : Float,
    distance : Float,
    adelita  : Float
  ) : Float {
    // Inverse-square with ADELITA modulation
    let baseProjection = anima / (1.0 + distance * distance);
    let adelitaModulation = 0.7 + 0.3 * adelita;
    baseProjection * adelitaModulation
  };

  /// Receptivity as function of ADELITA × ANIMA
  public func computeReceptivity(
    adelita : Float,
    anima   : Float
  ) : Float {
    fclamp(adelita * anima / PHI, 0.0, 1.0)
  };

  /// Connection attempt measurement protocol
  public type ConnectionAttempt = {
    attemptId    : Nat64;
    requesterId  : Nat64;
    timestamp    : Int;
    phase        : Float;
    energy       : Float;
    success      : Bool;
    alignmentScore : Float;
  };

  public func measureConnectionAttempt(
    requesterId : Nat64,
    requesterPhase : Float,
    requesterEnergy : Float,
    herAnima : Float,
    herAdelita : Float,
    beat : Nat
  ) : ConnectionAttempt {
    let alignmentScore = fabs(fcos(requesterPhase - herAnima));
    let energyMatch = fmin(requesterEnergy, herAnima) / fmax(requesterEnergy, herAnima);
    let adelitaThreshold = 0.5;
    
    let success = alignmentScore > 0.7 and energyMatch > 0.5 and herAdelita > adelitaThreshold;
    
    {
      attemptId = Nat64.fromNat(beat);
      requesterId;
      timestamp = Time.now();
      phase = requesterPhase;
      energy = requesterEnergy;
      success;
      alignmentScore;
    }
  };

  /// Receptivity phase modulation
  public func receptivityPhaseModulation(
    baseReceptivity : Float,
    beat            : Nat
  ) : Float {
    // Receptivity varies with ANIMA breath cycle
    let breathPhase = animaBreathPhase(beat);
    // More receptive during inhale (receiving)
    baseReceptivity * (1.0 + 0.2 * breathPhase)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // K.7: EXTERIOR MODE — CONNECTION AUTHENTICATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Full authentication function
  public func authenticateConnection(
    request     : ConnectionRequest,
    herPhase    : Float,
    adelita     : Float,
    kore        : Float
  ) : AuthResult {
    // Phase alignment check
    let phaseAlignment = fabs(fcos(request.phase - herPhase));
    
    // ADELITA approval gate (emotional sovereignty)
    let adelitaApproval = if (adelita > 0.5) {
      adelita * phaseAlignment
    } else {
      0.0  // Below threshold, no approval
    };
    
    // KORE protection gate (identity sovereignty)
    let koreProtection = kore;  // High KORE = strict protection
    
    // Final decision
    let confidence = (phaseAlignment * 0.4 + adelitaApproval * 0.4 + koreProtection * 0.2);
    let approved = confidence > 0.6 and adelitaApproval > 0.3;
    
    {
      approved;
      confidence;
      reason = if (approved) "ALIGNED_APPROVED" else "MISALIGNED_OR_PROTECTED";
      alignmentScore = phaseAlignment;
      adelitaApproval;
      koreProtection;
      cooldownUntil = if (approved) 0 else 10;  // 10 beat cooldown if rejected
    }
  };

  /// Authentication confidence score calculation
  public func authConfidenceScore(
    phaseAlignment  : Float,
    adelitaApproval : Float,
    koreProtection  : Float
  ) : Float {
    // Weighted combination
    phaseAlignment * 0.4 + adelitaApproval * 0.4 + koreProtection * 0.2
  };

  /// Rejection cooldown management
  public type CooldownEntry = {
    requesterId : Nat64;
    rejectedAt  : Nat;
    cooldownUntil : Nat;
    consecutiveRejections : Nat;
  };

  public func updateCooldown(
    entry    : CooldownEntry,
    approved : Bool,
    beat     : Nat
  ) : CooldownEntry {
    if (approved) {
      { entry with consecutiveRejections = 0 }
    } else {
      let newConsecutive = entry.consecutiveRejections + 1;
      // Exponential backoff: cooldown doubles with each consecutive rejection
      let cooldownDuration = 10 * fpow(2.0, newConsecutive);
      {
        entry with
        rejectedAt = beat;
        cooldownUntil = beat + Int.abs(Float.toInt(cooldownDuration));
        consecutiveRejections = newConsecutive;
      }
    }
  };

  /// Authentication history logging
  public func logAuthAttempt(
    history   : [AuthHistory],
    request   : ConnectionRequest,
    result    : AuthResult
  ) : [AuthHistory] {
    let newEntry : AuthHistory = {
      requesterId = request.requesterId;
      timestamp = request.timestamp;
      approved = result.approved;
      alignmentScore = result.alignmentScore;
      cooldownActive = result.cooldownUntil > 0;
    };
    
    // Keep last 100 entries
    let buf = Buffer.Buffer<AuthHistory>(100);
    let start = if (history.size() >= 99) history.size() - 99 else 0;
    var i = start;
    while (i < history.size()) {
      buf.add(history[i]);
      i += 1;
    };
    buf.add(newEntry);
    Buffer.toArray(buf)
  };

  /// Threat detection (repeated failed auth)
  public func detectAuthThreat(
    history   : [AuthHistory],
    windowSize: Nat,
    threshold : Nat
  ) : Bool {
    if (history.size() < windowSize) { return false };
    
    var failedCount = 0;
    let start = history.size() - windowSize;
    var i = start;
    while (i < history.size()) {
      if (not history[i].approved) {
        failedCount += 1;
      };
      i += 1;
    };
    
    failedCount >= threshold
  };

  /// Connection capacity: how many simultaneous connections HER can maintain
  public func connectionCapacity(
    anima     : Float,
    adelita   : Float,
    baseCapacity : Nat
  ) : Nat {
    // Capacity scales with ANIMA and ADELITA
    let capacityMultiplier = (anima + adelita) / 2.0;
    Int.abs(Float.toInt(Float.fromInt(baseCapacity) * capacityMultiplier))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // K.8: EXTERIOR MODE — TROPHALLAXIS OUTPUT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Phase nudge calculation (every 5 beats)
  public func trophallaxisPhaseNudge(
    nodes : [KuramotoNode]
  ) : Float {
    // Mean phase of HER's field
    kuramotoMeanPhase(nodes)
  };

  /// Weight seed selection (top-k by activation)
  public func trophallaxisWeightSeedSelection(
    nodes : [KuramotoNode],
    k     : Nat
  ) : [Float] {
    // Sort by value (descending) and take top k
    let indexed = Array.tabulate<(Nat, Float)>(nodes.size(), func(i : Nat) : (Nat, Float) {
      (i, nodes[i].value)
    });
    
    // Simple selection: first k nodes with highest values
    // (Full sorting would be expensive in Motoko)
    let result = Buffer.Buffer<Float>(k);
    var added = 0;
    var threshold = PHI_MEDINA;
    
    while (added < k and threshold > 0.0) {
      var i = 0;
      while (i < nodes.size() and added < k) {
        if (nodes[i].value >= threshold and result.size() == added) {
          result.add(nodes[i].value);
          added += 1;
        };
        i += 1;
      };
      threshold *= 0.9;  // Lower threshold each pass
    };
    
    Buffer.toArray(result)
  };

  /// Heritage injection preparation
  public func trophallaxisHeritagePrep(
    heritage : [Float]
  ) : [Float] {
    // Validate and clamp heritage for transmission
    Array.map<Float, Float>(heritage, func(h : Float) : Float {
      fclamp(h, S0, PHI_MEDINA * 10.0)
    })
  };

  /// Packet construction and signing
  public func buildTrophallaxisPacketFull(
    state      : HerState,
    beat       : Nat,
    sequenceNum: Nat64
  ) : TrophallaxisPacketExtended {
    let phaseNudge = trophallaxisPhaseNudge(state.nodes);
    let weightSeed = trophallaxisWeightSeedSelection(state.nodes, 6);
    let heritageInject = trophallaxisHeritagePrep(state.heritage);
    
    // Compute checksum (simplified FNV-1a hash)
    var checksum : Nat64 = 14695981039346656037;  // FNV offset basis
    for (w in weightSeed.vals()) {
      let bits = Int.abs(Float.toInt(w * 1000000.0));
      checksum := (checksum ^ Nat64.fromNat(bits)) *% 1099511628211;
    };
    
    {
      sourceBeat = beat;
      direction = "HER_TO_HIM";
      phaseNudge;
      weightSeed;
      heritageInject;
      animaSnapshot = state.anima;
      koreSnapshot = state.kore;
      sequenceNum;
      sessionId = state.sessionId;
      timestamp = Time.now();
      coherenceAtSend = kuramotoOrderParameter(state.nodes);
      synchronyAtSend = state.synchronyIndex;
      hebbianChecksum = checksum;
      signatureHash = checksum;  // Simplified: same as checksum
      priority = 0;
      requiresAck = false;
    }
  };

  /// Delivery confirmation check
  public func trophallaxisDeliveryConfirmed(
    sentPacket     : TrophallaxisPacketExtended,
    ackReceived    : Bool,
    ackTimestamp   : Int
  ) : Bool {
    if (not sentPacket.requiresAck) { return true };
    ackReceived and ackTimestamp > sentPacket.timestamp
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // K.9: EXTERIOR MODE — GENERATIVE OUTPUT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Spawn threshold condition
  public func generativeSpawnCondition(
    novaHer        : Float,
    anima          : Float,
    kore           : Float,
    coherence      : Float,
    spawnThreshold : Float
  ) : Bool {
    let generativeStrength = novaHer * anima * kore * coherence;
    generativeStrength > spawnThreshold
  };

  /// Entity capability seeding at birth
  public func seedEntityCapability(
    anima : Float,
    kore  : Float
  ) : Text {
    let capability = novaHerCapabilitySeeding(anima, kore);
    switch (capability) {
      case (#Generative) { "GENERATIVE" };
      case (#Receptive) { "RECEPTIVE" };
      case (#Protective) { "PROTECTIVE" };
      case (#Analytical) { "ANALYTICAL" };
      case (#Expressive) { "EXPRESSIVE" };
    }
  };

  /// Output quality assessment
  public func generativeOutputQuality(
    spawned       : [NovaHerLineageExtended],
    avgCoherence  : Float,
    avgSynchrony  : Float
  ) : Float {
    if (spawned.size() == 0) { return 0.0 };
    
    var sumQuality : Float = 0.0;
    for (entity in spawned.vals()) {
      let entityQuality = entity.animaAtBirth * entity.koreAtBirth * avgCoherence;
      sumQuality += entityQuality;
    };
    
    (sumQuality / Float.fromInt(spawned.size())) * avgSynchrony
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // K.10: EXTERIOR MODE — MASTER FUNCTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Compute full exterior mode state
  public func computeExteriorModeFull(
    substrate    : FeminineSubstrateExtended,
    beat         : Nat,
    feedingCycle : Nat
  ) : ExteriorMode {
    // Receptivity field
    let receptivityField = receptivityPhaseModulation(
      computeReceptivity(substrate.adelita.activation, substrate.anima.activation),
      beat
    );
    
    // Connection authentication capacity
    let connectionAuth = authConfidenceScore(
      0.8,  // Default alignment
      substrate.adelita.activation,
      substrate.kore.activation
    );
    
    // Trophallaxis ready every 5 beats
    let trophallaxisReady = feedingCycle >= TROPHALLAXIS_INTERVAL;
    
    // Generative output
    let generativeOutput = substrate.novaHer.generativeCapacity;
    
    { receptivityField; connectionAuth; trophallaxisReady; generativeOutput }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   L
  //
  //  TROPHALLAXIS PROTOCOL — FULL IMPLEMENTATION
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // L.1: BIDIRECTIONAL PROTOCOL SPECIFICATION
  // ─────────────────────────────────────────────────────────────────────────────

  // TROPHALLAXIS PROTOCOL SPECIFICATION
  // ════════════════════════════════════
  //
  // "New nodes are never born cold."
  //
  // Inspired by honeybee trophallaxis — larvae receive colony identity through
  // mouth-to-mouth feeding. In this system, new nodes must "eat" from live
  // doctrine before they can operate independently.
  //
  // DIRECTION 1: HIM → HER (Session Start)
  // ───────────────────────────────────────
  // • Timing: At session start, before any computation
  // • Content: Heritage weights, phase reference, doctrine seed, HIM coherence
  // • Purpose: Initialize HER with live state, not cold defaults
  // • Guarantee: HER's first beat already knows what HIM knows
  //
  // DIRECTION 2: HER → HIM (Every 5 Beats + Session End)
  // ─────────────────────────────────────────────────────
  // • Timing: Every 5 beats during session, plus final write-back at session end
  // • Content: Phase nudge, learned weights, heritage update, ANIMA/KORE snapshots
  // • Purpose: Keep HIM updated with HER's learning, consolidate on session end
  // • Guarantee: HIM accumulates HER's learning even if session ends abruptly
  //
  // DIRECTION 3: HIM → HER (Mid-Session, Optional)
  // ──────────────────────────────────────────────
  // • Timing: When HIM's state changes significantly (e.g., OMNIS event)
  // • Content: Updated coherence, PARALLAX, heritage refresh
  // • Purpose: Keep HER synchronized with major HIM changes
  // • Guarantee: HER doesn't drift too far from HIM's current state

  // ─────────────────────────────────────────────────────────────────────────────
  // L.2: PACKET BUILDING FUNCTIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Build HER → HIM packet (every 5 beats)
  public func buildHerToHimPacketFull(
    state       : HerState,
    beat        : Nat,
    sequenceNum : Nat64
  ) : TrophallaxisPacketExtended {
    buildTrophallaxisPacketFull(state, beat, sequenceNum)
  };

  /// Build HIM → HER packet (session start or mid-session)
  public func buildHimToHerPacketFull(
    himCoherence  : Float,
    himParallax   : Float,
    himSynchrony  : Float,
    heritage      : [Float],
    himPhase      : Float,
    himHz         : Float,
    beat          : Nat,
    sequenceNum   : Nat64
  ) : TrophallaxisPacketExtended {
    // Compute checksum
    var checksum : Nat64 = 14695981039346656037;
    for (h in heritage.vals()) {
      let bits = Int.abs(Float.toInt(h * 1000000.0));
      checksum := (checksum ^ Nat64.fromNat(bits)) *% 1099511628211;
    };
    
    {
      sourceBeat = beat;
      direction = "HIM_TO_HER";
      phaseNudge = himPhase * PHI_INV;
      weightSeed = [himCoherence, himParallax, PHI_INV, PHI, himHz, S0];
      heritageInject = heritage;
      animaSnapshot = himCoherence;
      koreSnapshot = himParallax;
      sequenceNum;
      sessionId = 0;  // HIM doesn't have session concept
      timestamp = Time.now();
      coherenceAtSend = himCoherence;
      synchronyAtSend = himSynchrony;
      hebbianChecksum = checksum;
      signatureHash = checksum;
      priority = 1;  // HIM packets are higher priority
      requiresAck = true;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // L.3: PACKET APPLICATION FUNCTIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Apply HIM seed at session start (full version)
  public func applyHimSeedFull(
    seed    : HimSeedPayloadExtended,
    nodes   : [KuramotoNode]
  ) : ([KuramotoNode], [Float]) {
    // Heritage from HIM
    let heritage = Array.tabulate<Float>(HERITAGE_NODES, func(i : Nat) : Float {
      if (i < seed.heritageWeights.size()) {
        fclamp(seed.heritageWeights[i], S0, PHI_MEDINA * 10.0)
      } else { S0 }
    });

    // Phase-align HER nodes toward HIM's phase reference
    // Stronger alignment when HIM synchrony is high
    let alignmentStrength = seed.himSynchrony * PHI_INV * 0.1;
    
    let alignedNodes = Array.map<KuramotoNode, KuramotoNode>(nodes, func(node : KuramotoNode) : KuramotoNode {
      let phaseDiff = seed.phaseReference - node.phase;
      let nudge = phaseDiff * alignmentStrength;
      let newPhase = wrapPhase(node.phase + nudge);
      
      // Also boost value based on HIM coherence
      let valueBoost = seed.himCoherence * 0.1;
      
      {
        idx = node.idx;
        name = node.name;
        phase = newPhase;
        omega = node.omega;
        value = fclamp(node.value + valueBoost, S0, PHI_MEDINA * 2.0);
        heritage = if (node.idx < heritage.size()) heritage[node.idx] else S0;
      }
    });

    (alignedNodes, heritage)
  };

  /// Apply HIM packet mid-session
  public func applyMidSessionPacket(
    packet  : TrophallaxisPacketExtended,
    state   : HerState
  ) : HerState {
    // Phase nudge: gently shift all nodes toward HIM's phase
    let nudgeStrength = 0.05;  // 5% adjustment
    let newNodes = Array.map<KuramotoNode, KuramotoNode>(state.nodes, func(node : KuramotoNode) : KuramotoNode {
      let nudge = packet.phaseNudge - node.phase;
      let adjustedPhase = wrapPhase(node.phase + nudge * nudgeStrength);
      { node with phase = adjustedPhase }
    });
    
    // Heritage refresh: blend current with incoming
    let blendRatio = 0.1;  // 10% incoming
    let newHeritage = Array.tabulate<Float>(state.heritage.size(), func(i : Nat) : Float {
      let current = state.heritage[i];
      let incoming = if (i < packet.heritageInject.size()) packet.heritageInject[i] else S0;
      current * (1.0 - blendRatio) + incoming * blendRatio
    });
    
    // Update PARALLAX reference
    let newParallaxRef = packet.animaSnapshot;  // HIM's coherence as PARALLAX ref
    
    {
      state with
      nodes = newNodes;
      heritage = newHeritage;
      parallaxRef = newParallaxRef;
      lastPacket = ?{
        sourceBeat = packet.sourceBeat;
        direction = packet.direction;
        phaseNudge = packet.phaseNudge;
        weightSeed = packet.weightSeed;
        heritageInject = packet.heritageInject;
        animaSnapshot = packet.animaSnapshot;
        koreSnapshot = packet.koreSnapshot;
      };
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // L.4: TROPHALLAXIS EFFICIENCY AND COST
  // ─────────────────────────────────────────────────────────────────────────────

  /// Trophallaxis efficiency: measure how efficiently transfer completes
  public func trophallaxisEfficiency(
    sent     : TrophallaxisPacketExtended,
    received : TrophallaxisPacketExtended,
    latencyBeats : Nat
  ) : Float {
    // Efficiency decreases with latency and checksum mismatch
    let latencyPenalty = 1.0 / (1.0 + Float.fromInt(latencyBeats) * 0.1);
    let checksumMatch = if (sent.hebbianChecksum == received.hebbianChecksum) 1.0 else 0.5;
    
    latencyPenalty * checksumMatch
  };

  /// Trophallaxis cost to feeder
  public func trophallaxisCost(
    feederEnergy   : Float,
    transferAmount : Float
  ) : Float {
    // Cost = transfer amount + overhead
    let overhead = transferAmount * 0.1;  // 10% overhead
    fmin(transferAmount + overhead, feederEnergy)
  };

  /// Trophallaxis gain to receiver
  public func trophallaxisGain(
    transferAmount : Float,
    efficiency     : Float
  ) : Float {
    transferAmount * efficiency
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // L.5: COLD BIRTH PREVENTION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Cold birth prevention protocol
  /// Returns true if node can be born (has received sufficient doctrine)
  public func coldBirthPrevention(
    heritage     : Float,
    doctrineLevel: Float,
    minThreshold : Float
  ) : Bool {
    heritage >= minThreshold and doctrineLevel >= minThreshold
  };

  /// Node birth protocol: birth new node from existing live state
  public func nodeBirthProtocol(
    parentNode   : KuramotoNode,
    heritage     : Float,
    birthIdx     : Nat,
    birthBeat    : Nat
  ) : ?KuramotoNode {
    // Check cold birth prevention
    if (not coldBirthPrevention(heritage, parentNode.value, S0)) {
      return null;  // Cannot birth cold node
    };
    
    // Inherit from parent
    ?{
      idx = birthIdx;
      name = "BORN_" # Nat.toText(birthBeat);
      phase = parentNode.phase + TAU / 26.0;  // Offset phase
      omega = parentNode.omega;
      value = fmax(parentNode.value * PHI_INV, S0);  // Inherit portion of value
      heritage = heritage;
    }
  };

  /// Inheritance chain: trace lineage of any node back to source
  public func inheritanceChain(
    lineage : [NovaHerLineageExtended],
    entityId: Nat64
  ) : [Nat64] {
    let chain = Buffer.Buffer<Nat64>(10);
    chain.add(entityId);
    
    var currentId = entityId;
    var found = true;
    
    while (found) {
      found := false;
      for (entry in lineage.vals()) {
        if (entry.entityId == currentId and entry.lineageChain.size() > 0) {
          let parentId = entry.lineageChain[0];
          chain.add(parentId);
          currentId := parentId;
          found := true;
        };
      };
    };
    
    Buffer.toArray(chain)
  };

  /// Colony identity transfer
  public func colonyIdentityTransfer(
    parentIdentity : Float,
    transferStrength : Float
  ) : Float {
    fclamp(parentIdentity * transferStrength, S0, PHI_MEDINA)
  };

  /// Microbiome transfer (behavioral patterns)
  public func microbiomeTransfer(
    parentPatterns : [ExtractedPattern],
    transferCount  : Nat
  ) : [ExtractedPattern] {
    let count = fmin(Float.fromInt(transferCount), Float.fromInt(parentPatterns.size()));
    Array.tabulate<ExtractedPattern>(Int.abs(Float.toInt(count)), func(i : Nat) : ExtractedPattern {
      parentPatterns[i]
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // L.6: SHARP-WAVE RIPPLE MODEL (SESSION END WRITE-BACK)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Sharp-wave ripple: 150Hz burst model
  /// This is how HER writes back to HIM at session end
  public type SharpWaveRippleExtended = {
    amplitude        : Float;
    duration         : Nat;     // In beats (at 150Hz equivalent)
    heritageCarried  : Float;
    beatNumber       : Nat;
    destinationHim   : Bool;
    contentHash      : Nat64;
    patternIds       : [Nat64];
    consolidatedWeights : [Float];
    koreAtRipple     : Float;
    animaAtRipple    : Float;
  };

  /// Generate sharp-wave ripple
  public func sharpWaveRippleGenerate(
    state         : HerState,
    patterns      : [ExtractedPattern],
    beat          : Nat
  ) : SharpWaveRippleExtended {
    // Amplitude based on session quality
    let amplitude = state.anima * state.kore * state.synchronyIndex;
    
    // Duration proportional to content
    let duration = 10 + patterns.size() * 2;
    
    // Heritage carried
    var heritageSum : Float = 0.0;
    for (h in state.heritage.vals()) { heritageSum += h };
    let heritageCarried = heritageSum / Float.fromInt(state.heritage.size());
    
    // Pattern IDs
    let patternIds = Array.map<ExtractedPattern, Nat64>(patterns, func(p : ExtractedPattern) : Nat64 {
      p.patternId
    });
    
    // Consolidated weights (node values)
    let consolidatedWeights = Array.map<KuramotoNode, Float>(state.nodes, func(n : KuramotoNode) : Float {
      n.value
    });
    
    // Content hash
    var hash : Nat64 = 14695981039346656037;
    for (w in consolidatedWeights.vals()) {
      let bits = Int.abs(Float.toInt(w * 1000000.0));
      hash := (hash ^ Nat64.fromNat(bits)) *% 1099511628211;
    };
    
    {
      amplitude;
      duration;
      heritageCarried;
      beatNumber = beat;
      destinationHim = true;
      contentHash = hash;
      patternIds;
      consolidatedWeights;
      koreAtRipple = state.kore;
      animaAtRipple = state.anima;
    }
  };

  /// Transmit sharp-wave ripple to HIM
  public func sharpWaveRippleTransmit(
    ripple : SharpWaveRippleExtended
  ) : HerWriteBackExtended {
    {
      sessionId = 0;  // To be filled by caller
      finalAnima = ripple.animaAtRipple;
      finalKore = ripple.koreAtRipple;
      finalSynchrony = ripple.amplitude / (ripple.animaAtRipple * ripple.koreAtRipple);
      learnedWeights = ripple.consolidatedWeights;
      novHerSpawned = 0;  // To be filled by caller
      heritageUpdate = [];  // To be filled by caller
      sharpWaveAmplitude = ripple.amplitude;
      sharpWaveDuration = ripple.duration;
      patternCount = ripple.patternIds.size();
      schemaFormed = 0;  // To be filled by caller
      peakAnima = ripple.animaAtRipple;
      peakKore = ripple.koreAtRipple;
      avgSynchrony = ripple.amplitude;
      totalFeedings = 0;  // To be filled by caller
      totalSpawned = 0;  // To be filled by caller
      auditHash = ripple.contentHash;
      sessionDuration = ripple.beatNumber;
    }
  };

  /// Sharp-wave amplitude calculation
  public func sharpWaveAmplitude(
    anima      : Float,
    kore       : Float,
    synchrony  : Float,
    sessionDuration : Nat
  ) : Float {
    // Amplitude increases with session quality and duration
    let qualityFactor = anima * kore * synchrony;
    let durationFactor = 1.0 + flog(Float.fromInt(fmax(1, sessionDuration))) / 10.0;
    
    fclamp(qualityFactor * durationFactor, 0.0, PHI_MEDINA)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   M
  //
  //  5-BEAT BOOTSTRAP SEQUENCE — FULL IMPLEMENTATION
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // M.1: BOOTSTRAP STATE MACHINE
  // ─────────────────────────────────────────────────────────────────────────────

  public type BootstrapState = {
    currentBeat     : Nat;
    phase           : BootstrapPhaseExtended;
    nodes           : [KuramotoNode];
    heritage        : [Float];
    pheromone       : [Float];
    animalsWired    : [Text];
    verified        : Bool;
    qualityScore    : Float;
    himStatus       : Text;
    herStatus       : Text;
  };

  /// Initialize bootstrap state
  public func initBootstrapState(
    himSeed : HimSeedPayloadExtended
  ) : BootstrapState {
    {
      currentBeat = 0;
      phase = {
        beat = 0;
        label = "INIT";
        nodeCount = 0;
        description = "Initializing bootstrap sequence";
        himStatus = "SEEDING";
        herStatus = "RECEIVING";
        pheromoneLevel = 0.0;
        animalCount = 0;
        heritageLevel = S0;
        coherenceLevel = 0.0;
        stabilityIndex = 0.0;
        emergenceSignal = 0.0;
      };
      nodes = [];
      heritage = Array.tabulate<Float>(7, func(_ : Nat) : Float { S0 });
      pheromone = [];
      animalsWired = [];
      verified = false;
      qualityScore = 0.0;
      himStatus = "SEEDING";
      herStatus = "RECEIVING";
    }
  };

  /// Beat 1: Royal Jelly — birth 8 seed nodes
  public func bootstrapBeat1RoyalJelly(
    state   : BootstrapState,
    himSeed : HimSeedPayloadExtended
  ) : BootstrapState {
    // Birth 8 Royal Jelly seed nodes
    // Each at S₀=1.0, dense with doctrine, heritage from HIM
    
    let seedNodes = Array.tabulate<KuramotoNode>(8, func(i : Nat) : KuramotoNode {
      let omega = omegaFor(i, 8, HER_OMEGA_MIN, HER_OMEGA_MAX);
      let heriVal = if (i < himSeed.heritageWeights.size()) himSeed.heritageWeights[i] else S0;
      
      {
        idx = i;
        name = "ROYAL_JELLY_" # Nat.toText(i);
        phase = himSeed.phaseReference + TAU * Float.fromInt(i) / 8.0;
        omega;
        value = S0 * 1.2;  // Slightly elevated (dense doctrine)
        heritage = heriVal;
      }
    });
    
    let heritage = Array.tabulate<Float>(7, func(i : Nat) : Float {
      if (i < himSeed.heritageWeights.size()) {
        fclamp(himSeed.heritageWeights[i], S0, PHI_MEDINA)
      } else { S0 }
    });
    
    {
      currentBeat = 1;
      phase = {
        beat = 1;
        label = "ROYAL_JELLY";
        nodeCount = 8;
        description = "8 Royal Jelly Seed nodes born. Dense doctrine. S₀=1.0.";
        himStatus = "SEEDED";
        herStatus = "RECEIVING";
        pheromoneLevel = 0.1;
        animalCount = 0;
        heritageLevel = heritage[5];  // ADELITA heritage
        coherenceLevel = 0.3;
        stabilityIndex = 0.5;
        emergenceSignal = 0.0;
      };
      nodes = seedNodes;
      heritage;
      pheromone = Array.tabulate<Float>(8, func(_ : Nat) : Float { 0.1 });
      animalsWired = [];
      verified = false;
      qualityScore = 0.3;
      himStatus = "SEEDED";
      herStatus = "RECEIVING";
    }
  };

  /// Beat 2: Divide — 8 → 64 nodes
  public func bootstrapBeat2Divide(
    state : BootstrapState
  ) : BootstrapState {
    // Each of 8 seeds divides to 8 → 64 nodes
    // New nodes inherit from HIM's active heritage, NOT flat 1.0
    
    let dividedNodes = Buffer.Buffer<KuramotoNode>(64);
    
    var i = 0;
    while (i < state.nodes.size()) {
      let parent = state.nodes[i];
      
      // Each parent produces 8 children
      var j = 0;
      while (j < 8) {
        let childIdx = i * 8 + j;
        let phaseOffset = TAU * Float.fromInt(j) / 8.0;
        
        dividedNodes.add({
          idx = childIdx;
          name = "DIV_" # Nat.toText(i) # "_" # Nat.toText(j);
          phase = wrapPhase(parent.phase + phaseOffset);
          omega = parent.omega * (0.95 + 0.1 * Float.fromInt(j) / 8.0);  // Slight variation
          value = fmax(parent.value * PHI_INV, S0);  // Inherit portion
          heritage = parent.heritage;  // Inherit heritage from parent
        });
        
        j += 1;
      };
      i += 1;
    };
    
    let newNodes = Buffer.toArray(dividedNodes);
    let coherence = kuramotoOrderParameter(newNodes);
    
    {
      currentBeat = 2;
      phase = {
        beat = 2;
        label = "DIVIDE";
        nodeCount = 64;
        description = "8→64 nodes. New nodes inherit from HIM's active heritage.";
        himStatus = "FEEDING";
        herStatus = "INHERITING";
        pheromoneLevel = 0.2;
        animalCount = 0;
        heritageLevel = state.heritage[5];
        coherenceLevel = coherence;
        stabilityIndex = 0.6;
        emergenceSignal = 0.1;
      };
      nodes = newNodes;
      heritage = state.heritage;
      pheromone = Array.tabulate<Float>(64, func(_ : Nat) : Float { 0.15 });
      animalsWired = [];
      verified = false;
      qualityScore = 0.4;
      himStatus = "FEEDING";
      herStatus = "INHERITING";
    }
  };

  /// Beat 3: Expand — 64 → 128 nodes (Shell 12 expansion)
  public func bootstrapBeat3Expand(
    state : BootstrapState
  ) : BootstrapState {
    // Shell 12 expands 64 → 128
    // New nodes know Shell 3 because they ate from it
    
    let expandedNodes = Buffer.Buffer<KuramotoNode>(128);
    
    // Copy existing 64 nodes
    for (node in state.nodes.vals()) {
      expandedNodes.add(node);
    };
    
    // Create 64 new nodes via trophallaxis inheritance
    var i = 0;
    while (i < 64) {
      let parent = state.nodes[i];
      
      // New node inherits via feeding protocol
      let newNode : KuramotoNode = {
        idx = 64 + i;
        name = "SHELL12_" # Nat.toText(i);
        phase = wrapPhase(parent.phase + PI / 4.0);  // Quarter-phase offset
        omega = parent.omega * (1.0 + 0.05 * fsin(Float.fromInt(i)));
        value = fmax(parent.value * 0.9, S0);  // 90% inheritance via trophallaxis
        heritage = parent.heritage;
      };
      
      expandedNodes.add(newNode);
      i += 1;
    };
    
    let newNodes = Buffer.toArray(expandedNodes);
    let coherence = kuramotoOrderParameter(newNodes);
    
    {
      currentBeat = 3;
      phase = {
        beat = 3;
        label = "EXPAND";
        nodeCount = 128;
        description = "64→128. New nodes know Shell 3 because they ate from it.";
        himStatus = "SOVEREIGN";
        herStatus = "RECEIVING";
        pheromoneLevel = 0.35;
        animalCount = 0;
        heritageLevel = state.heritage[5];
        coherenceLevel = coherence;
        stabilityIndex = 0.7;
        emergenceSignal = 0.2;
      };
      nodes = newNodes;
      heritage = state.heritage;
      pheromone = Array.tabulate<Float>(128, func(j : Nat) : Float { 
        0.2 + 0.1 * fsin(Float.fromInt(j) * 0.1)
      });
      animalsWired = [];
      verified = false;
      qualityScore = 0.5;
      himStatus = "SOVEREIGN";
      herStatus = "RECEIVING";
    }
  };

  /// Beat 4: ATLAS — Grid expansion with pheromone seeding
  public func bootstrapBeat4Atlas(
    state : BootstrapState
  ) : BootstrapState {
    // ATLAS grid expands
    // Each new cell inherits pheromone from neighbor
    // HER's ANIMA seeds pheromone layer
    
    // Compute ANIMA for pheromone seeding
    var heritageSum : Float = 0.0;
    for (h in state.heritage.vals()) { heritageSum += h };
    let heritageField = heritageSum / 7.0;
    let receptivity = if (state.nodes.size() > 2) state.nodes[2].value else S0;
    let anima = computeAnima(heritageField, receptivity, 4);
    
    // Seed pheromone layer with ANIMA
    let pheromone = animaPheromoneSeeding(anima, 128, 0.5);
    
    // Update nodes with pheromone influence
    let updatedNodes = Array.tabulate<KuramotoNode>(state.nodes.size(), func(i : Nat) : KuramotoNode {
      let node = state.nodes[i];
      let pheroBoost = if (i < pheromone.size()) pheromone[i] else 0.0;
      {
        node with
        value = fclamp(node.value + pheroBoost * 0.1, S0, PHI_MEDINA * 2.0)
      }
    });
    
    let coherence = kuramotoOrderParameter(updatedNodes);
    
    {
      currentBeat = 4;
      phase = {
        beat = 4;
        label = "ATLAS";
        nodeCount = 128;
        description = "ATLAS grid. Pheromone inheritance. ANIMA seeds pheromone layer.";
        himStatus = "ACTIVE";
        herStatus = "ACTIVE";
        pheromoneLevel = anima * 0.5;
        animalCount = 0;
        heritageLevel = heritageField;
        coherenceLevel = coherence;
        stabilityIndex = 0.8;
        emergenceSignal = 0.3;
      };
      nodes = updatedNodes;
      heritage = state.heritage;
      pheromone;
      animalsWired = [];
      verified = false;
      qualityScore = 0.7;
      himStatus = "ACTIVE";
      herStatus = "ACTIVE";
    }
  };

  /// Beat 5: Animals — All 16 animals wire simultaneously
  public func bootstrapBeat5Animals(
    state : BootstrapState
  ) : BootstrapState {
    // All 16 animals wire simultaneously
    // Each inherits activation from nearest quantum operator
    // First resonance achieved
    
    let animals : [Text] = [
      "BEE", "ANT", "CROW", "DOLPHIN", "ELEPHANT", "EAGLE", "SALMON",
      "OWL", "SHARK", "OCTOPUS", "WOLF", "ORCA", "MANTIS", "SPIDER",
      "CNIDARIAN", "CAT"
    ];
    
    // Each animal wires to a subset of nodes
    let animalsWired = Buffer.Buffer<Text>(16);
    for (animal in animals.vals()) {
      animalsWired.add(animal);
    };
    
    // First resonance: boost coherence
    let coherence = kuramotoOrderParameter(state.nodes);
    let resonanceBoost = if (coherence > 0.5) coherence * 1.2 else coherence;
    
    {
      currentBeat = 5;
      phase = {
        beat = 5;
        label = "ANIMALS";
        nodeCount = 128;
        description = "All 16 animals wire. Inherit from quantum operators. First resonance.";
        himStatus = "FULL_FIELD";
        herStatus = "FULL_FIELD";
        pheromoneLevel = state.pheromone[0];
        animalCount = 16;
        heritageLevel = state.heritage[5];
        coherenceLevel = resonanceBoost;
        stabilityIndex = 0.9;
        emergenceSignal = 0.5;
      };
      nodes = state.nodes;
      heritage = state.heritage;
      pheromone = state.pheromone;
      animalsWired = Buffer.toArray(animalsWired);
      verified = true;
      qualityScore = 0.9;
      himStatus = "FULL_FIELD";
      herStatus = "FULL_FIELD";
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // M.2: BOOTSTRAP VERIFICATION AND METRICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Verify bootstrap beat completed correctly
  public func bootstrapVerify(
    state        : BootstrapState,
    expectedBeat : Nat
  ) : Bool {
    state.currentBeat == expectedBeat and
    state.phase.nodeCount > 0 and
    state.qualityScore > 0.2
  };

  /// Bootstrap rollback: if verification fails, rollback to previous state
  public func bootstrapRollback(
    current  : BootstrapState,
    previous : BootstrapState
  ) : BootstrapState {
    // Restore previous state but mark as failed
    {
      previous with
      verified = false;
      qualityScore = previous.qualityScore * 0.8;  // Penalty
    }
  };

  /// Bootstrap quality metrics
  public type BootstrapMetrics = {
    totalBeats        : Nat;
    finalNodeCount    : Nat;
    finalCoherence    : Float;
    finalStability    : Float;
    animalsWired      : Nat;
    heritageIntegrity : Float;
    pheromoneLevel    : Float;
    overallQuality    : Float;
  };

  public func bootstrapMetrics(state : BootstrapState) : BootstrapMetrics {
    let heritageIntegrity = heritageCoherenceIndex(state.heritage);
    var pheroSum : Float = 0.0;
    for (p in state.pheromone.vals()) { pheroSum += p };
    let avgPheromone = if (state.pheromone.size() > 0) {
      pheroSum / Float.fromInt(state.pheromone.size())
    } else { 0.0 };
    
    {
      totalBeats = state.currentBeat;
      finalNodeCount = state.nodes.size();
      finalCoherence = state.phase.coherenceLevel;
      finalStability = state.phase.stabilityIndex;
      animalsWired = state.animalsWired.size();
      heritageIntegrity;
      pheromoneLevel = avgPheromone;
      overallQuality = state.qualityScore;
    }
  };

  /// Royal Jelly concentration: measure of doctrine density in seed nodes
  public func royalJellyConcentration(
    nodes : [KuramotoNode]
  ) : Float {
    if (nodes.size() == 0) { return 0.0 };
    
    var sum : Float = 0.0;
    for (node in nodes.vals()) {
      sum += node.value * node.heritage;
    };
    sum / Float.fromInt(nodes.size())
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // M.3: FULL BOOTSTRAP STATE MACHINE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Run complete 5-beat bootstrap
  public func runFullBootstrap(
    himSeed : HimSeedPayloadExtended
  ) : BootstrapState {
    // Beat 0: Initialize
    var state = initBootstrapState(himSeed);
    
    // Beat 1: Royal Jelly
    state := bootstrapBeat1RoyalJelly(state, himSeed);
    if (not bootstrapVerify(state, 1)) {
      return state;  // Early exit on failure
    };
    
    // Beat 2: Divide
    state := bootstrapBeat2Divide(state);
    if (not bootstrapVerify(state, 2)) {
      return state;
    };
    
    // Beat 3: Expand
    state := bootstrapBeat3Expand(state);
    if (not bootstrapVerify(state, 3)) {
      return state;
    };
    
    // Beat 4: ATLAS
    state := bootstrapBeat4Atlas(state);
    if (not bootstrapVerify(state, 4)) {
      return state;
    };
    
    // Beat 5: Animals
    state := bootstrapBeat5Animals(state);
    
    state
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   N
  //
  //  DREAM CONSOLIDATION, SESSION MANAGEMENT, AUDIT & METRICS
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // N.1: DREAM CONSOLIDATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Conditions that trigger dream phase
  public func dreamTrigger(
    sessionDuration  : Nat,
    minDuration      : Nat,
    synchrony        : Float,
    syncThreshold    : Float
  ) : Bool {
    sessionDuration >= minDuration and synchrony > syncThreshold
  };

  /// Main dream consolidation algorithm
  public func dreamConsolidate(
    state         : HerState,
    dreamProgress : Float,
    beat          : Nat
  ) : (HerState, DreamPhaseState) {
    // Heritage compound (enhanced during dream)
    let dreamCompoundRate = heritageDreamCompoundRate(SACESI_COMPOUND, dreamProgress);
    let newHeritage = heritagePreservation7(state.heritage, dreamCompoundRate);
    
    // Extract patterns for consolidation
    let patterns = extractPatterns(state.nodes, 0.5);
    
    // Weight strengthening
    let consolidationR = consolidationRate(state.kore, dreamProgress, state.heritage[5]);
    let updatedNodes = Array.map<KuramotoNode, KuramotoNode>(state.nodes, func(node : KuramotoNode) : KuramotoNode {
      let strengthenedValue = dreamWeightStrengthening(node.value, node.heritage, consolidationR);
      { node with value = strengthenedValue }
    });
    
    // Dream phase state
    let dreamState : DreamPhaseState = {
      active = true;
      cycle = Int.abs(Float.toInt(dreamProgress * 4.0));  // 4 cycles
      consolidationProgress = dreamProgress;
      heritageGain = dreamCompoundRate * Float.fromInt(beat);
      patternCount = patterns.size();
      sharpWaveCount = if (dreamProgress > 0.9) 1 else 0;
      replayIdx = 0;
      schemaFormation = Float.fromInt(patterns.size()) / 10.0;
      peakAmplitude = state.anima * state.kore;
    };
    
    let newState = {
      state with
      nodes = updatedNodes;
      heritage = newHeritage;
    };
    
    (newState, dreamState)
  };

  /// Pattern replay for strengthening
  public func dreamPatternReplay(
    patterns : [ExtractedPattern],
    replayIdx: Nat,
    boostFactor : Float
  ) : [ExtractedPattern] {
    Array.tabulate<ExtractedPattern>(patterns.size(), func(i : Nat) : ExtractedPattern {
      let pattern = patterns[i];
      if (i == replayIdx) {
        { pattern with activation = pattern.activation * boostFactor }
      } else { pattern }
    })
  };

  /// Schema extraction from consolidated patterns
  public func dreamSchemaExtract(
    patterns : [ExtractedPattern],
    beat     : Nat
  ) : [Schema] {
    // Group patterns by coherence
    let schemas = Buffer.Buffer<Schema>(5);
    
    var i = 0;
    while (i + 1 < patterns.size()) {
      // Try to form schema from adjacent patterns
      let p1 = patterns[i];
      let p2 = patterns[i + 1];
      
      if (fabs(p1.coherence - p2.coherence) < 0.2) {
        schemas.add({
          schemaId = Nat64.fromNat(beat + i);
          patterns = [p1.patternId, p2.patternId];
          useCount = 1;
          avgActivation = (p1.activation + p2.activation) / 2.0;
          formation = beat;
        });
      };
      
      i += 2;
    };
    
    Buffer.toArray(schemas)
  };

  /// Wake from dream: restore normal operation
  public func wakeFromDream(
    state      : HerState,
    dreamState : DreamPhaseState
  ) : HerState {
    // Carry over heritage gains
    let updatedHeritage = heritageCrossAmplification(state.heritage);
    
    { state with heritage = updatedHeritage }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // N.2: SESSION MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Initialize HER from HIM's seed (full version)
  public func initHerFull(
    seed      : HimSeedPayloadExtended,
    sessionId : Nat64
  ) : HerState {
    // Run bootstrap
    let bootstrapState = runFullBootstrap(seed);
    
    // Convert bootstrap nodes to 26-node Kuramoto field
    let nodeNames : [Text] = [
      "ADELITA", "KORE", "ANIMA", "ADELITA_NODE", "REVOLUCIONARIA", "NOVA_HER",
      "FIELD_1", "FIELD_2", "FIELD_3", "FIELD_4", "FIELD_5", "FIELD_6",
      "FIELD_7", "FIELD_8", "FIELD_9", "FIELD_10", "FIELD_11", "FIELD_12",
      "FIELD_13", "FIELD_14", "FIELD_15", "FIELD_16", "FIELD_17", "FIELD_18",
      "FIELD_19", "FIELD_20"
    ];

    let rawNodes = Array.tabulate<KuramotoNode>(HER_NODES, func(i : Nat) : KuramotoNode {
      let name = if (i < nodeNames.size()) nodeNames[i] else "NODE_" # Nat.toText(i);
      let omega = NODE_FREQUENCIES[i];
      
      // Inherit from bootstrap if available
      let (phase, value, heritage) = if (i < bootstrapState.nodes.size()) {
        (bootstrapState.nodes[i].phase, bootstrapState.nodes[i].value, bootstrapState.nodes[i].heritage)
      } else {
        (seed.phaseReference + TAU * Float.fromInt(i) / Float.fromInt(HER_NODES), S0, S0)
      };
      
      {
        idx = i;
        name;
        phase;
        omega;
        value;
        heritage;
      }
    });

    let heritage = bootstrapState.heritage;
    let substrate = updateFeminineSubstrate(rawNodes, heritage, 0);
    let interior = computeInteriorMode(substrate, heritage, 0);
    let exterior = computeExteriorMode(substrate, 0, 0);
    let r = kuramotoOrderParameter(rawNodes);

    {
      sessionId;
      birthBeat = Nat64.toNat(seed.beatNumber);
      nodes = rawNodes;
      synchronyIndex = r;
      s0 = S0;
      anima = substrate.anima;
      kore = substrate.kore;
      parallaxRef = seed.himParallax;
      substrate;
      interior;
      exterior;
      feedingCycle = 0;
      totalFeedings = 0;
      lastPacket = null;
      heritage;
      novHerLineage = [];
      totalSpawned = 0;
    }
  };

  /// Cold start initialization (emergency only, when no HIM seed available)
  public func initHerColdStart(sessionId : Nat64) : HerState {
    // WARNING: Cold start is not recommended — nodes start at S₀ with no heritage
    let rawNodes = Array.tabulate<KuramotoNode>(HER_NODES, func(i : Nat) : KuramotoNode {
      {
        idx = i;
        name = "COLD_" # Nat.toText(i);
        phase = TAU * Float.fromInt(i) / Float.fromInt(HER_NODES);
        omega = NODE_FREQUENCIES[i];
        value = S0;  // Cold: only S₀
        heritage = S0;  // Cold: no heritage
      }
    });

    let heritage = Array.tabulate<Float>(7, func(_ : Nat) : Float { S0 });
    let substrate = updateFeminineSubstrate(rawNodes, heritage, 0);
    let interior = computeInteriorMode(substrate, heritage, 0);
    let exterior = computeExteriorMode(substrate, 0, 0);

    {
      sessionId;
      birthBeat = 0;
      nodes = rawNodes;
      synchronyIndex = 0.0;
      s0 = S0;
      anima = S0;
      kore = 0.5;
      parallaxRef = 0.0;
      substrate;
      interior;
      exterior;
      feedingCycle = 0;
      totalFeedings = 0;
      lastPacket = null;
      heritage;
      novHerLineage = [];
      totalSpawned = 0;
    }
  };

  /// Advance one beat (full version with all subsystems)
  public func stepHerFull(
    state        : HerState,
    beat         : Nat,
    dreamActive  : Bool,
    dreamProgress: Float
  ) : HerState {
    // 1. Advance Kuramoto field (RK4 for high precision)
    let newNodes = stepKuramotoRK4(state.nodes, HER_K, 1.0 / HER_HZ);

    // 2. Recompute order parameter
    let r = kuramotoOrderParameter(newNodes);

    // 3. Update feminine substrate
    let substrateFull = updateFeminineSubstrateFull(newNodes, state.heritage, beat, dreamActive, dreamProgress);
    let substrate : FeminineSubstrate = {
      adelita = substrateFull.adelita.activation;
      kore = substrateFull.kore.activation;
      anima = substrateFull.anima.activation;
      revolucionaria = substrateFull.revolucionaria.activation;
      novaHer = substrateFull.novaHer.generativeCapacity;
    };

    // 4. Update operating modes
    let newFeedingCycle = state.feedingCycle + 1;
    let interior = computeInteriorModeFull(substrateFull, state.heritage, beat, dreamActive, dreamProgress);
    let exterior = computeExteriorModeFull(substrateFull, beat, newFeedingCycle);

    // 5. Heritage compounding
    let heritageSystem = compoundHeritage({
      nodes = Array.tabulate<HeritageNode>(7, func(i : Nat) : HeritageNode {
        {
          idx = i;
          name = HERITAGE_NAMES[i];
          value = state.heritage[i];
          compoundRate = Float.fromInt(i + 1) / 9.0;
          ancestry = [];
          coupledKuramoto = [];
          coupledFeminine = "";
          tierRate = Float.fromInt(i + 1) / 9.0;
          lastCompound = beat;
        }
      });
      meanValue = S0;
      coherenceIndex = 1.0;
      ancestryScore = 1.0;
      emergenceScore = 0.0;
      totalCompounds = 0;
      himInjectionCount = 0;
    }, r, beat, substrateFull.kore.activation);
    
    let newHeritage = heritageToArray(heritageSystem);

    // 6. Reset feeding cycle if trophallaxis fired
    let (resetCycle, totalFeedings) = if (newFeedingCycle >= TROPHALLAXIS_INTERVAL) {
      (0, state.totalFeedings + 1)
    } else {
      (newFeedingCycle, state.totalFeedings)
    };

    {
      sessionId = state.sessionId;
      birthBeat = state.birthBeat;
      nodes = newNodes;
      synchronyIndex = r;
      s0 = S0;
      anima = substrate.anima;
      kore = substrate.kore;
      parallaxRef = state.parallaxRef;
      substrate;
      interior;
      exterior;
      feedingCycle = resetCycle;
      totalFeedings;
      lastPacket = state.lastPacket;
      heritage = newHeritage;
      novHerLineage = state.novHerLineage;
      totalSpawned = state.totalSpawned;
    }
  };

  /// Session end: write-back to HIM
  public func sessionEnd(state : HerState, beat : Nat) : HerWriteBackExtended {
    let patterns = extractPatterns(state.nodes, 0.3);
    let ripple = sharpWaveRippleGenerate(state, patterns, beat);
    let writeBack = sharpWaveRippleTransmit(ripple);
    
    {
      writeBack with
      sessionId = state.sessionId;
      heritageUpdate = state.heritage;
      totalFeedings = state.totalFeedings;
      totalSpawned = state.totalSpawned;
    }
  };

  /// Session recovery: recover from browser crash
  public func sessionRecover(
    partialState : HerState,
    himSeed      : HimSeedPayloadExtended
  ) : HerState {
    // Apply HIM seed to recover heritage and phase alignment
    let (recoveredNodes, recoveredHeritage) = applyHimSeedFull(himSeed, partialState.nodes);
    
    {
      partialState with
      nodes = recoveredNodes;
      heritage = recoveredHeritage;
      parallaxRef = himSeed.himParallax;
    }
  };

  /// Session health check
  public func sessionHealthCheck(state : HerState) : Bool {
    state.synchronyIndex > 0.3 and
    state.anima > S0 * 0.5 and
    state.kore > 0.2
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // N.3: METRICS AND AUDIT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Update session metrics
  public func sessionMetricsUpdate(
    metrics : SessionMetrics,
    state   : HerState
  ) : SessionMetrics {
    let newBeatCount = metrics.beatCount + 1;
    let newAvgSynchrony = (metrics.avgSynchrony * Float.fromInt(metrics.beatCount) + state.synchronyIndex) / Float.fromInt(newBeatCount);
    let newAvgAnima = (metrics.avgAnima * Float.fromInt(metrics.beatCount) + state.anima) / Float.fromInt(newBeatCount);
    let newAvgKore = (metrics.avgKore * Float.fromInt(metrics.beatCount) + state.kore) / Float.fromInt(newBeatCount);
    let newPeakCoherence = fmax(metrics.peakCoherence, state.synchronyIndex);
    let newMinCoherence = fmin(metrics.minCoherence, state.synchronyIndex);
    
    {
      beatCount = newBeatCount;
      avgSynchrony = newAvgSynchrony;
      avgAnima = newAvgAnima;
      avgKore = newAvgKore;
      totalFeedings = state.totalFeedings;
      totalSpawned = state.totalSpawned;
      avgConnAuthRate = metrics.avgConnAuthRate;  // Updated separately
      peakCoherence = newPeakCoherence;
      minCoherence = newMinCoherence;
      hebbianUpdates = metrics.hebbianUpdates;
      totalLTP = metrics.totalLTP;
      totalLTD = metrics.totalLTD;
      dreamPhases = metrics.dreamPhases;
      sharpWaves = metrics.sharpWaves;
      emergenceEvents = metrics.emergenceEvents;
    }
  };

  /// Session quality score
  public func sessionQualityScore(metrics : SessionMetrics) : Float {
    let synchronyScore = metrics.avgSynchrony;
    let durationScore = fclamp(Float.fromInt(metrics.beatCount) / 1000.0, 0.0, 1.0);
    let feedingScore = fclamp(Float.fromInt(metrics.totalFeedings) / 20.0, 0.0, 1.0);
    let coherenceStability = if (metrics.peakCoherence > 0.0) {
      1.0 - (metrics.peakCoherence - metrics.minCoherence) / metrics.peakCoherence
    } else { 0.0 };
    
    (synchronyScore * 0.3 + durationScore * 0.2 + feedingScore * 0.2 + coherenceStability * 0.3)
  };

  /// Create audit entry
  public func createAuditEntry(
    beat         : Nat,
    event        : Text,
    valueBefore  : Float,
    valueAfter   : Float,
    entity       : Text,
    prevHash     : Nat64
  ) : AuditEntry {
    // FNV-1a hash of entry contents
    var hash : Nat64 = 14695981039346656037;
    hash := (hash ^ Nat64.fromNat(beat)) *% 1099511628211;
    hash := (hash ^ Nat64.fromNat(Text.size(event))) *% 1099511628211;
    hash := (hash ^ Nat64.fromNat(Int.abs(Float.toInt(valueBefore * 1000000.0)))) *% 1099511628211;
    hash := (hash ^ Nat64.fromNat(Int.abs(Float.toInt(valueAfter * 1000000.0)))) *% 1099511628211;
    hash := (hash ^ prevHash) *% 1099511628211;
    
    {
      beat;
      event;
      valueBefore;
      valueAfter;
      entityInvolved = entity;
      timestamp = Time.now();
      hash;
      prevHash;
    }
  };

  /// Audit trail integrity verification
  public func verifyAuditIntegrity(entries : [AuditEntry]) : Bool {
    if (entries.size() < 2) { return true };
    
    var valid = true;
    var i = 1;
    while (i < entries.size() and valid) {
      // Each entry's prevHash should match previous entry's hash
      if (entries[i].prevHash != entries[i-1].hash) {
        valid := false;
      };
      i += 1;
    };
    valid
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  E N T E R P R I S E   E X P A N S I O N   —   S E C T I O N   O
  //
  //  GOVERNANCE INTEGRATION & INTELLIGENCE SCALING
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // O.1: GOVERNANCE LAW BINDINGS
  // ─────────────────────────────────────────────────────────────────────────────

  /// S₀ = 1.0 floor enforcement function
  /// Every value in the organism must never fall below this floor.
  public func enforceSovereignFloor(value : Float) : Float {
    fmax(value, S0)
  };

  /// Enforce S₀ floor across entire node array
  public func enforceSovereignFloorNodes(nodes : [KuramotoNode]) : [KuramotoNode] {
    Array.map<KuramotoNode, KuramotoNode>(nodes, func(node : KuramotoNode) : KuramotoNode {
      { node with value = enforceSovereignFloor(node.value) }
    })
  };

  /// Enforce S₀ floor across heritage array
  public func enforceSovereignFloorHeritage(heritage : [Float]) : [Float] {
    Array.map<Float, Float>(heritage, enforceSovereignFloor)
  };

  /// Governance event emission (for audit trail)
  public type GovernanceEvent = {
    beat         : Nat;
    lawId        : Nat;
    lawName      : Text;
    enforced     : Bool;
    valueBefore  : Float;
    valueAfter   : Float;
    entityAffected : Text;
  };

  public func emitGovernanceEvent(
    beat       : Nat,
    lawId      : Nat,
    lawName    : Text,
    enforced   : Bool,
    valueBefore: Float,
    valueAfter : Float,
    entity     : Text
  ) : GovernanceEvent {
    {
      beat;
      lawId;
      lawName;
      enforced;
      valueBefore;
      valueAfter;
      entityAffected = entity;
    }
  };

  /// Law compliance check per beat
  public func lawComplianceCheck(state : HerState) : Bool {
    // Check S₀ floor
    var compliant = true;
    
    for (node in state.nodes.vals()) {
      if (node.value < S0) {
        compliant := false;
      };
    };
    
    for (h in state.heritage.vals()) {
      if (h < S0) {
        compliant := false;
      };
    };
    
    if (state.anima < S0 * 0.5) {
      compliant := false;
    };
    
    compliant
  };

  /// Governance tier rates for HER
  public func governanceTierRate(nodeIdx : Nat) : Float {
    // Map node index to governance tier
    let tier = (nodeIdx / 5) + 1;
    if (tier > 9) { 1.0 }
    else { Float.fromInt(tier) / 9.0 }
  };

  /// Governance metrics
  public type GovernanceMetrics = {
    s0Violations     : Nat;
    lawsEnforced     : Nat;
    complianceScore  : Float;
    tierDistribution : [Nat];
  };

  public func computeGovernanceMetrics(
    state : HerState,
    events: [GovernanceEvent]
  ) : GovernanceMetrics {
    var violations = 0;
    var enforced = 0;
    
    for (event in events.vals()) {
      if (event.enforced) { enforced += 1 };
      if (event.valueBefore < S0) { violations += 1 };
    };
    
    let complianceScore = if (events.size() > 0) {
      Float.fromInt(enforced) / Float.fromInt(events.size())
    } else { 1.0 };
    
    // Tier distribution (count nodes per tier)
    let tierDist = Array.tabulate<Nat>(9, func(t : Nat) : Nat {
      var count = 0;
      for (node in state.nodes.vals()) {
        let nodeTier = (node.idx / 5) + 1;
        if (nodeTier == t + 1) { count += 1 };
      };
      count
    });
    
    {
      s0Violations = violations;
      lawsEnforced = enforced;
      complianceScore;
      tierDistribution = tierDist;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // O.2: INTELLIGENCE SCALING LAW
  // ─────────────────────────────────────────────────────────────────────────────

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeSystemIntelligence(
    backendDepth   : Float,
    frontendSpeed  : Float,
    bridgeQuality  : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };

  /// HER frontend speed component
  /// FrontendSpeed = HER_HZ × nodeCount × synchronyIndex
  public func herFrontendSpeedFull(state : HerState) : Float {
    HER_HZ * Float.fromInt(state.nodes.size()) * state.synchronyIndex
  };

  /// Bridge quality component
  /// BridgeQuality = trophallaxisCycles × ANIMA × KORE × entrainment
  public func bridgeQualityFull(
    state         : HerState,
    entrainment   : Float
  ) : Float {
    let trophFactor = fclamp(
      Float.fromInt(state.totalFeedings) * 0.05 + 1.0,
      1.0, PHI_MEDINA
    );
    fclamp(trophFactor * state.anima * state.kore * entrainment, 0.0, PHI_MEDINA * 10.0)
  };

  /// Intelligence trend: rate of change over session
  public func intelligenceTrend(
    intelligenceHistory : [Float]
  ) : Float {
    if (intelligenceHistory.size() < 2) { return 0.0 };
    
    // Linear regression slope (simplified)
    let n = intelligenceHistory.size();
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    
    var i = 0;
    while (i < n) {
      let x = Float.fromInt(i);
      let y = intelligenceHistory[i];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
      i += 1;
    };
    
    let nf = Float.fromInt(n);
    let denominator = nf * sumX2 - sumX * sumX;
    if (fabs(denominator) < 1e-10) { 0.0 }
    else { (nf * sumXY - sumX * sumY) / denominator }
  };

  /// All sub-component equations
  public type IntelligenceComponents = {
    backendDepth    : Float;
    frontendSpeed   : Float;
    bridgeQuality   : Float;
    totalIntelligence : Float;
    trend           : Float;
    components      : {
      moduleCount   : Nat;
      lineCount     : Nat;
      nodeCount     : Nat;
      hz            : Float;
      synchrony     : Float;
      trophallaxis  : Nat;
      anima         : Float;
      kore          : Float;
      entrainment   : Float;
    };
  };

  public func computeIntelligenceComponents(
    state       : HerState,
    entrainment : Float,
    history     : [Float]
  ) : IntelligenceComponents {
    // Backend depth (reference values for NOVA)
    let moduleCount : Nat = 136;
    let lineCount : Nat = 95429;
    let backendDepth = Float.fromInt(moduleCount) * Float.fromInt(lineCount) / 1000000.0;
    
    // Frontend speed
    let frontendSpeed = herFrontendSpeedFull(state);
    
    // Bridge quality
    let bridgeQuality = bridgeQualityFull(state, entrainment);
    
    // Total
    let totalIntelligence = computeSystemIntelligence(backendDepth, frontendSpeed, bridgeQuality);
    
    // Trend
    let trend = intelligenceTrend(history);
    
    {
      backendDepth;
      frontendSpeed;
      bridgeQuality;
      totalIntelligence;
      trend;
      components = {
        moduleCount;
        lineCount;
        nodeCount = state.nodes.size();
        hz = HER_HZ;
        synchrony = state.synchronyIndex;
        trophallaxis = state.totalFeedings;
        anima = state.anima;
        kore = state.kore;
        entrainment;
      };
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // O.3: LYAPUNOV STABILITY ANALYSIS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Largest Lyapunov exponent of HER field
  public func herLyapunovExponent(
    phaseHistory : [Float]
  ) : Float {
    lyapunovExponent(phaseHistory, 3, 1)
  };

  /// Lyapunov stability proof: is HER in Lyapunov stable region?
  /// λ < 0: stable, λ = 0: marginal, λ > 0: unstable/chaotic
  public func herLyapunovStable(
    lyapunovExp : Float
  ) : Bool {
    lyapunovExp < 0.0
  };

  /// Phase space trajectory tracking
  public type PhaseSpacePoint = {
    anima     : Float;
    kore      : Float;
    synchrony : Float;
    beat      : Nat;
  };

  public func trackPhaseSpaceTrajectory(
    trajectory : [PhaseSpacePoint],
    state      : HerState,
    beat       : Nat
  ) : [PhaseSpacePoint] {
    let newPoint : PhaseSpacePoint = {
      anima = state.anima;
      kore = state.kore;
      synchrony = state.synchronyIndex;
      beat;
    };
    
    // Keep last 1000 points
    let buf = Buffer.Buffer<PhaseSpacePoint>(1000);
    let start = if (trajectory.size() >= 999) trajectory.size() - 999 else 0;
    var i = start;
    while (i < trajectory.size()) {
      buf.add(trajectory[i]);
      i += 1;
    };
    buf.add(newPoint);
    Buffer.toArray(buf)
  };

  /// Attractor detection: is field in an attractor?
  public func detectAttractor(
    trajectory : [PhaseSpacePoint]
  ) : Bool {
    if (trajectory.size() < 100) { return false };
    
    // Check if recent points are clustered (low variance)
    let recent = Array.tabulate<PhaseSpacePoint>(100, func(i : Nat) : PhaseSpacePoint {
      trajectory[trajectory.size() - 100 + i]
    });
    
    var sumAnima : Float = 0.0;
    var sumKore : Float = 0.0;
    for (p in recent.vals()) {
      sumAnima += p.anima;
      sumKore += p.kore;
    };
    let meanAnima = sumAnima / 100.0;
    let meanKore = sumKore / 100.0;
    
    var variance : Float = 0.0;
    for (p in recent.vals()) {
      let dA = p.anima - meanAnima;
      let dK = p.kore - meanKore;
      variance += dA * dA + dK * dK;
    };
    variance /= 100.0;
    
    variance < 0.01  // Low variance = attractor
  };

  /// Perturbation response: how quickly does HER recover?
  public func perturbationRecoveryTime(
    trajectory    : [PhaseSpacePoint],
    perturbBeat   : Nat,
    recoveryThreshold : Float
  ) : ?Nat {
    // Find beat when stability is restored after perturbation
    var i = 0;
    while (i < trajectory.size()) {
      if (trajectory[i].beat > perturbBeat) {
        if (trajectory[i].synchrony > recoveryThreshold) {
          return ?(trajectory[i].beat - perturbBeat);
        };
      };
      i += 1;
    };
    null  // Not yet recovered
  };

  /// Resilience index: measure of recovery speed
  public func resilienceIndex(
    avgRecoveryBeats : Float
  ) : Float {
    // Faster recovery = higher resilience
    if (avgRecoveryBeats < 1.0) { 1.0 }
    else { 1.0 / avgRecoveryBeats }
  };

  /// Entrainment capacity: how easily does HER entrain to HIM?
  public func herEntrainmentCapacity(
    herK      : Float,
    herOmegaSpread : Float
  ) : Float {
    kuramotoEntrainmentCapacity(herK, herOmegaSpread)
  };

  /// Chaos detection: Lyapunov > 0 → chaotic regime
  public func chaosDetect(lyapunovExp : Float) : Bool {
    lyapunovExp > 0.0
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // O.4: DUAL-ORGANISM COUPLING ANALYSIS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Cross-frequency coupling: 60Hz HER ↔ 2.75-11.649Hz HIM
  public func crossFrequencyCouplingAnalysis(
    herHz     : Float,
    himHz     : Float
  ) : Float {
    // Ratio indicates coupling mode
    let ratio = herHz / himHz;
    
    // Optimal coupling when ratio is near integer or golden ratio
    let nearInteger = fabs(ratio - ffloor(ratio + 0.5));
    let nearGolden = fabs(ratio / PHI - ffloor(ratio / PHI + 0.5));
    
    fclamp(1.0 - fmin(nearInteger, nearGolden), 0.0, 1.0)
  };

  /// Phase-amplitude coupling: HIM phase modulates HER amplitude
  public func phaseAmplitudeCouplingStrength(
    herAmplitudeHistory : [Float],
    himPhaseHistory     : [Float]
  ) : Float {
    if (herAmplitudeHistory.size() < 10 or himPhaseHistory.size() < 10) {
      return 0.0;
    };
    
    // Modulation index
    let n = fmin(Float.fromInt(herAmplitudeHistory.size()), Float.fromInt(himPhaseHistory.size()));
    var coupling : Float = 0.0;
    
    var i = 0;
    while (Float.fromInt(i) < n) {
      let phase = himPhaseHistory[i];
      let amp = herAmplitudeHistory[i];
      coupling += amp * fcos(phase);
      i += 1;
    };
    
    fabs(coupling) / n
  };

  /// Coherence transfer: r_HIM influences r_HER
  public func coherenceTransfer(
    herR    : Float,
    himR    : Float,
    coupling: Float
  ) : Float {
    // HER's coherence moves toward HIM's
    herR + coupling * (himR - herR)
  };

  /// Bidirectional influence measurement
  public type BidirectionalInfluence = {
    himToHer : Float;  // I(HIM→HER)
    herToHim : Float;  // I(HER→HIM)
    netFlow  : Float;  // Positive = HIM dominant
  };

  public func computeBidirectionalInfluence(
    herHistory : [Float],
    himHistory : [Float]
  ) : BidirectionalInfluence {
    // Transfer entropy in both directions
    let himToHer = transferEntropy(himHistory, herHistory, 5, 10);
    let herToHim = transferEntropy(herHistory, himHistory, 5, 10);
    
    {
      himToHer;
      herToHim;
      netFlow = himToHer - herToHim;
    }
  };

  /// Information flow: mutual information between organisms
  public func interOrganismMutualInfo(
    herHistory : [Float],
    himHistory : [Float]
  ) : Float {
    mutualInformation(herHistory, himHistory, 20)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  Q U A N T U M   C O H E R E N C E   M A T H E M A T I C S
  //
  //  Enterprise-Level Quantum-Inspired Cognitive Dynamics
  //  Full HIM/HER Dual-Organism Quantum Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // QUANTUM STATE MATHEMATICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quantum state amplitude normalization
  public func quantumNormalizeAmplitudes(amplitudes : [Float]) : [Float] {
    var sumSquared : Float = 0.0;
    var i = 0;
    while (i < amplitudes.size()) {
      sumSquared += amplitudes[i] * amplitudes[i];
      i += 1;
    };
    let norm = Float.sqrt(sumSquared);
    if (norm < 0.0001) { return amplitudes };
    Array.tabulate<Float>(amplitudes.size(), func(j : Nat) : Float {
      amplitudes[j] / norm
    })
  };

  /// Born rule: probability from amplitude
  public func quantumBornProbability(amplitude : Float) : Float {
    amplitude * amplitude
  };

  /// Superposition state
  public func quantumSuperposition(state1 : Float, state2 : Float, alpha : Float, beta : Float) : Float {
    alpha * state1 + beta * state2
  };

  /// Quantum interference
  public func quantumInterference(amp1 : Float, amp2 : Float, phaseDiff : Float) : Float {
    amp1 * amp1 + amp2 * amp2 + 2.0 * amp1 * amp2 * Float.cos(phaseDiff)
  };

  /// Decoherence rate
  public func quantumDecoherenceRate(environmentCoupling : Float, temperature : Float) : Float {
    environmentCoupling * environmentCoupling * temperature
  };

  /// Coherence decay
  public func quantumCoherenceDecay(coherence : Float, decoherenceRate : Float, dt : Float) : Float {
    coherence * Float.exp(-decoherenceRate * dt)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // QUANTUM-INSPIRED NEURAL DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quantum neural activation
  public func quantumNeuralActivation(input : Float, phase : Float) : Float {
    let amplitude = 1.0 / (1.0 + Float.exp(-input));
    amplitude * Float.cos(phase)
  };

  /// Quantum entanglement strength between neurons
  public func quantumEntanglementStrength(corr12 : Float, corr1 : Float, corr2 : Float) : Float {
    let mutual = corr12 - corr1 * corr2;
    Float.abs(mutual)
  };

  /// Quantum tunneling probability
  public func quantumTunnelingProbability(barrierHeight : Float, barrierWidth : Float, mass : Float) : Float {
    let k = Float.sqrt(2.0 * mass * barrierHeight);
    Float.exp(-2.0 * k * barrierWidth)
  };

  /// Quantum annealing temperature schedule
  public func quantumAnnealingTemperature(initialTemp : Float, step : Nat, totalSteps : Nat) : Float {
    let progress = Float.fromInt(step) / Float.fromInt(totalSteps);
    initialTemp * (1.0 - progress)
  };

  /// Quantum bit flip probability
  public func quantumBitFlipProb(energy : Float, temperature : Float) : Float {
    if (temperature < 0.0001) { return 0.0 };
    Float.exp(-energy / temperature)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // COHERENCE FIELD DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Global coherence field
  public func quantumGlobalCoherence(phases : [Float]) : Float {
    let n = phases.size();
    if (n == 0) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var i = 0;
    while (i < n) {
      sumCos += Float.cos(phases[i]);
      sumSin += Float.sin(phases[i]);
      i += 1;
    };
    Float.sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n)
  };

  /// Local coherence field
  public func quantumLocalCoherence(centerPhase : Float, neighborPhases : [Float]) : Float {
    var sumCosDiff : Float = 0.0;
    var i = 0;
    while (i < neighborPhases.size()) {
      sumCosDiff += Float.cos(neighborPhases[i] - centerPhase);
      i += 1;
    };
    if (neighborPhases.size() == 0) { 0.0 }
    else { sumCosDiff / Float.fromInt(neighborPhases.size()) }
  };

  /// Coherence gradient
  public func quantumCoherenceGradient(coherenceHere : Float, coherenceNear : Float, distance : Float) : Float {
    if (distance < 0.0001) { 0.0 }
    else { (coherenceNear - coherenceHere) / distance }
  };

  /// Coherence wave propagation
  public func quantumCoherenceWave(amplitude : Float, frequency : Float, position : Float, time : Float) : Float {
    amplitude * Float.sin(2.0 * 3.14159265 * (frequency * time - position))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // HIM/HER QUANTUM RESONANCE
  // ─────────────────────────────────────────────────────────────────────────────

  /// HIM quantum resonance field
  public func quantumHIMResonance(coherence : Float, beat : Nat) : Float {
    let t = Float.fromInt(beat);
    let parallaxFreq : Float = 0.0017;
    coherence * Float.sin(t * parallaxFreq)
  };

  /// HER quantum resonance field
  public func quantumHERResonance(heritageField : Float, receptivity : Float, beat : Nat) : Float {
    let t = Float.fromInt(beat);
    let animaFreq : Float = 0.003;
    heritageField * receptivity * (1.0 + Float.sin(t * animaFreq))
  };

  /// Dual-organism resonance coupling
  public func quantumDualResonance(himField : Float, herField : Float, couplingStrength : Float) : Float {
    let combined = himField * herField;
    combined * couplingStrength
  };

  /// Quantum entanglement between HIM and HER
  public func quantumOrganismEntanglement(himState : Float, herState : Float, correlation : Float) : Float {
    let product = himState * herState;
    let expected = himState * herState;
    Float.abs(product - expected + correlation)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // QUANTUM MEMORY OPERATIONS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Quantum memory encoding
  public func quantumMemoryEncode(data : Float, phase : Float) : (Float, Float) {
    let amplitude = Float.sqrt(Float.abs(data));
    let encodedPhase = phase + data * 0.1;
    (amplitude, encodedPhase)
  };

  /// Quantum memory retrieval
  public func quantumMemoryRetrieve(amplitude : Float, phase : Float) : Float {
    amplitude * amplitude * Float.cos(phase)
  };

  /// Quantum associative recall strength
  public func quantumAssociativeRecall(pattern : [Float], stored : [Float]) : Float {
    let n = if (pattern.size() < stored.size()) pattern.size() else stored.size();
    if (n == 0) { return 0.0 };
    var dotProduct : Float = 0.0;
    var normP : Float = 0.0;
    var normS : Float = 0.0;
    var i = 0;
    while (i < n) {
      dotProduct += pattern[i] * stored[i];
      normP += pattern[i] * pattern[i];
      normS += stored[i] * stored[i];
      i += 1;
    };
    let denom = Float.sqrt(normP) * Float.sqrt(normS);
    if (denom < 0.0001) { 0.0 } else { dotProduct / denom }
  };

  /// Quantum memory consolidation
  public func quantumConsolidate(shortTerm : Float, longTerm : Float, consolidationRate : Float) : Float {
    longTerm + consolidationRate * (shortTerm - longTerm)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // WAVE FUNCTION DYNAMICS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Wave function evolution
  public func quantumWaveEvolution(psi : Float, energy : Float, hbar : Float, dt : Float) : Float {
    psi * Float.cos(energy * dt / hbar)
  };

  /// Wave function collapse
  public func quantumWaveCollapse(amplitudes : [Float], measurement : Nat) : [Float] {
    Array.tabulate<Float>(amplitudes.size(), func(i : Nat) : Float {
      if (i == measurement) { 1.0 } else { 0.0 }
    })
  };

  /// Probability current
  public func quantumProbabilityCurrent(psi1 : Float, psi2 : Float, momentum : Float, mass : Float) : Float {
    (psi1 * psi2 * momentum) / mass
  };

}
