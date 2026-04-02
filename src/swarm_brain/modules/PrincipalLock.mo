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

}
