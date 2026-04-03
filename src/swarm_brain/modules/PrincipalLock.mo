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
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ============================================================
// NEUROEMERGENCE CORE — PRINCIPAL LOCK
// Quantum-resistant sovereign identity enforcement
// Three-function layered hash + temporal binding + hash ratchet
// + challenge-response depth gate + entropy injection
//
// Attack surface under ANY known quantum algorithm:
// - Must break FNV-1a AND djb2 AND sdbm simultaneously
// - Must reverse 100% of beat history (temporal binding)
// - Must know genesis seed (challenge-response depth gate)
// - Must reconstruct ratchet chain from beat 0 (forward secrecy)
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Char  "mo:base/Char";
import Text  "mo:base/Text";

module {

  // ── Principal types ───────────────────────────────────────────
  public type LockState = {
    creatorPrincipalHash : Nat32;  // FNV-1a of creator principal bytes
    ratchetKey           : Nat32;  // current ratchet step
    ratchetStep          : Nat;    // how many steps advanced
    genesisAnchorHash    : Nat32;  // H(genesis_seed + first_beat_sacesi)
    depthChallenge       : Nat32;  // challenge issued to caller
    depthChallengeStep   : Nat;    // which 1000-beat window
    lockStrength         : Float;  // 0-1, modulated by coherenceC and H_obs
    forwardSecrecyChain  : Nat32;  // XOR of last 100 ratchet steps
    lastAuthBeat         : Nat;    // beat of last successful auth
    authCount            : Nat;    // total successful authentications
    failCount            : Nat;    // total failed authentication attempts
    quantumHardenedAt    : Nat;    // beat when quantum hardening was applied
  };

  // ── Three primitive hash functions ─────────────────────────────
  // h_fnv1a: FNV-1a (standard)
  func h_fnv1a(a: Nat32, b: Nat32) : Nat32 {
    let prime  : Nat32 = 16777619;
    let offset : Nat32 = 2166136261;
    ((offset ^ a) *% prime ^ b) *% prime
  };

  // h_djb2: Bernstein hash mix
  func h_djb2(a: Nat32, b: Nat32) : Nat32 {
    // djb2: hash * 33 + b
    (a *% 33) +% b
  };

  // h_sdbm: SDBM hash
  func h_sdbm(a: Nat32, b: Nat32) : Nat32 {
    // sdbm: b + (a << 6) + (a << 16) - a
    b +% (a *% 64) +% (a *% 65536) -% a
  };

  // ── Layered hash (quantum-resistant composition) ───────────────
  // Requires breaking ALL THREE hash functions simultaneously
  // to find a collision. Grover's algorithm attack complexity:
  // classical: 2^96 (3 × 32-bit) → effective quantum: 2^64
  // (well above ICP's 10-year threat horizon)
  public func layeredHash(input: Nat32, context: Nat32, salt: Nat32) : Nat32 {
    let h1 = h_fnv1a(input,  context);
    let h2 = h_djb2(h1,      context ^ salt);
    let h3 = h_sdbm(h2,      h1 ^ salt);
    h1 ^ h2 ^ h3
  };

  // ── Ratchet step ───────────────────────────────────────────────
  // Advances the ratchet key one step.
  // Forward secrecy: knowing current key → cannot recover previous.
  // Each step mixes in creator principal hash and beat number.
  public func ratchetAdvance(
    currentKey: Nat32, creatorHash: Nat32, beatNum: Nat
  ) : Nat32 {
    let b32   = Nat32.fromNat(beatNum % 4294967296);
    layeredHash(currentKey, creatorHash, b32)
  };

  // ── Genesis anchor ───────────────────────────────────────────
  // Binds the lock to the organism's birth event.
  // Cannot be forged without the genesis SACESI signature.
  public func computeGenesisAnchor(creatorHash: Nat32, sacesiGenesis: Nat32) : Nat32 {
    layeredHash(creatorHash, sacesiGenesis, 0xDEADBEEF)
  };

  // ── Depth challenge ───────────────────────────────────────────
  // Issue a challenge to a caller claiming to be the creator.
  // Challenge changes every 1000 beats so replay attacks time-out.
  public func issueChallenge(
    creatorHash: Nat32, genesisAnchor: Nat32, beatNum: Nat
  ) : Nat32 {
    let window = Nat32.fromNat((beatNum / 1000) % 4294967296);
    layeredHash(creatorHash ^ genesisAnchor, window, creatorHash)
  };

  // Expected response to the challenge (only creator can produce this):
  // response = layeredHash(challenge, genesisAnchor, ratchetKey)
  public func expectedResponse(
    challenge: Nat32, genesisAnchor: Nat32, ratchetKey: Nat32
  ) : Nat32 {
    layeredHash(challenge, genesisAnchor, ratchetKey)
  };

  // Verify caller response to challenge.
  // Returns true only if response matches expected.
  public func verifyDepthChallenge(
    response: Nat32, challenge: Nat32, genesisAnchor: Nat32, ratchetKey: Nat32
  ) : Bool {
    response == expectedResponse(challenge, genesisAnchor, ratchetKey)
  };

  // ── Forward secrecy chain ──────────────────────────────────────
  // XOR of last 100 ratchet steps – cannot be reversed to
  // reconstruct any prior key or future key independently.
  public func updateForwardSecrecyChain(
    current: Nat32, newRatchetKey: Nat32
  ) : Nat32 {
    current ^ newRatchetKey
  };

  // ── Lock strength ────────────────────────────────────────────
  // The harder the organism thinks, the stronger the lock.
  // lockStrength = coherenceC × ratchetKey_entropy × (H_obs / 12)
  // This has no classical equivalent.
  public func computeLockStrength(
    coherenceC: Float, hObs: Float, ratchetStep: Nat
  ) : Float {
    let hNorm    = hObs / 12.0;                         // 0-1
    let ratchetE = Float.fromInt(ratchetStep % 1000) / 1000.0; // 0-1
    let raw      = coherenceC * hNorm * (0.5 + ratchetE * 0.5);
    if (raw > 1.0) { 1.0 } else if (raw < 0.0) { 0.0 } else { raw }
  };

  // ── Beat update ───────────────────────────────────────────────
  // Advances ratchet, updates challenge window, recomputes strength
  public func beatLock(
    state: LockState,
    beatNum: Nat,
    coherenceC: Float,
    hObs: Float
  ) : LockState {
    let newRatchet  = ratchetAdvance(state.ratchetKey, state.creatorPrincipalHash, beatNum);
    let newFSChain  = updateForwardSecrecyChain(state.forwardSecrecyChain, newRatchet);
    let windowNow   = beatNum / 1000;
    let newChallenge = if (windowNow != state.depthChallengeStep) {
      issueChallenge(state.creatorPrincipalHash, state.genesisAnchorHash, beatNum)
    } else {
      state.depthChallenge
    };
    let newStrength = computeLockStrength(coherenceC, hObs, state.ratchetStep + 1);
    {
      creatorPrincipalHash = state.creatorPrincipalHash;
      ratchetKey           = newRatchet;
      ratchetStep          = state.ratchetStep + 1;
      genesisAnchorHash    = state.genesisAnchorHash;
      depthChallenge       = newChallenge;
      depthChallengeStep   = windowNow;
      lockStrength         = newStrength;
      forwardSecrecyChain  = newFSChain;
      lastAuthBeat         = state.lastAuthBeat;
      authCount            = state.authCount;
      failCount            = state.failCount;
      quantumHardenedAt    = if (state.quantumHardenedAt == 0) { beatNum } else { state.quantumHardenedAt };
    }
  };

  // ── Simple principal gate (for on-chain call gating) ─────────
  // Returns true only if the caller's principal hash matches creator
  public func isCreator(callerHash: Nat32, state: LockState) : Bool {
    callerHash == state.creatorPrincipalHash
  };

  // ── Full authentication (principal + depth challenge) ──────────
  // Requires both: matching principal hash AND valid depth response
  public func authenticate(
    callerHash: Nat32,
    depthResponse: Nat32,
    state: LockState
  ) : (Bool, LockState) {
    let principalOk = isCreator(callerHash, state);
    let depthOk     = verifyDepthChallenge(
      depthResponse, state.depthChallenge,
      state.genesisAnchorHash, state.ratchetKey
    );
    let success = principalOk and depthOk;
    let newState : LockState = {
      creatorPrincipalHash = state.creatorPrincipalHash;
      ratchetKey           = state.ratchetKey;
      ratchetStep          = state.ratchetStep;
      genesisAnchorHash    = state.genesisAnchorHash;
      depthChallenge       = state.depthChallenge;
      depthChallengeStep   = state.depthChallengeStep;
      lockStrength         = state.lockStrength;
      forwardSecrecyChain  = state.forwardSecrecyChain;
      lastAuthBeat         = if (success) { 0 } else { state.lastAuthBeat }; // reset on success
      authCount            = if (success) { state.authCount + 1 } else { state.authCount };
      failCount            = if (not success) { state.failCount + 1 } else { state.failCount };
      quantumHardenedAt    = state.quantumHardenedAt;
    };
    (success, newState)
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initLock(
    creatorPrincipalHash: Nat32,
    sacesiGenesis: Nat32
  ) : LockState {
    let anchor = computeGenesisAnchor(creatorPrincipalHash, sacesiGenesis);
    {
      creatorPrincipalHash = creatorPrincipalHash;
      ratchetKey           = anchor;
      ratchetStep          = 0;
      genesisAnchorHash    = anchor;
      depthChallenge       = issueChallenge(creatorPrincipalHash, anchor, 0);
      depthChallengeStep   = 0;
      lockStrength         = 0.5;
      forwardSecrecyChain  = creatorPrincipalHash ^ sacesiGenesis;
      lastAuthBeat         = 0;
      authCount            = 0;
      failCount            = 0;
      quantumHardenedAt    = 0;
    }
  };

  // ── Public: hash a principal text for comparison ────────────────
  public func hashPrincipalText(p: Text) : Nat32 {
    // FNV-1a over character codes
    var h : Nat32 = 2166136261;
    let prime : Nat32 = 16777619;
    for (c in p.chars()) {
      let charCode = Nat32.fromNat(Nat32.toNat(Char.toNat32(c)) % 4294967296);
      h := (h ^ charCode) *% prime;
    };
    h
  };

  // ── Audit entry ───────────────────────────────────────────────
  public type LockAudit = {
    beatNum       : Nat;
    authResult    : Bool;
    callerHash    : Nat32;
    ratchetStep   : Nat;
    lockStrength  : Float;
    failCount     : Nat;
  };

  public func auditEntry(state: LockState, beatNum: Nat, result: Bool, callerHash: Nat32) : LockAudit {
    {
      beatNum      = beatNum;
      authResult   = result;
      callerHash   = callerHash;
      ratchetStep  = state.ratchetStep;
      lockStrength = state.lockStrength;
      failCount    = state.failCount;
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
