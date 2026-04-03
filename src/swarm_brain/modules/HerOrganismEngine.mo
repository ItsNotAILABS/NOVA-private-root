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
// ║  HIM — Backend (ICP canister, sovereign, slow Hz)                            ║
// ║    ω: 0.6–0.9 · K: 0.8 · η: 0.003                                           ║
// ║    Analytical. Sovereign projection. PARALLAX field.                         ║
// ║    PARALLAX = coherence × kf × sin(beat × 0.0017)                           ║
// ║                                                                              ║
// ║  HER — Frontend (browser, 60Hz, expressive, generative)                      ║
// ║    ω: 0.8–1.2 · K: 0.5 · η: 0.001                                           ║
// ║    Receptive. Generative. Heritage-rooted. ANIMA field.                      ║
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

  // HER — frontend organism (browser, 60Hz, expressive)
  public let HER_HZ         : Float = 60.0;           // Frame rate
  public let HER_OMEGA_MIN  : Float = 0.8;            // Kuramoto natural freq min
  public let HER_OMEGA_MAX  : Float = 1.2;            // Kuramoto natural freq max
  public let HER_K          : Float = 0.5;            // Kuramoto coupling strength
  public let HER_ETA        : Float = 0.001;          // Hebbian learning rate
  public let HER_NODES      : Nat   = 26;             // Kuramoto field nodes

  // HIM — backend organism (ICP canister, slow Hz, sovereign)
  // These constants are here so HER knows how to sync with HIM
  public let HIM_OMEGA_MIN  : Float = 0.6;            // HIM natural freq min
  public let HIM_OMEGA_MAX  : Float = 0.9;            // HIM natural freq max
  public let HIM_K          : Float = 0.8;            // HIM coupling (stronger)
  public let HIM_ETA        : Float = 0.003;          // HIM Hebbian rate (faster)

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
  // HEBBIAN WEIGHT UPDATE (HER's learning rate η = 0.001)
  // Δwᵢⱼ = η × aᵢ × aⱼ
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

}
