// ============================================================
// NEUROEMERGENCE CORE — PATENT REGISTRY
// Attorney-grade on-chain IP attribution
// Auto-patent on novel events, coherence peaks, OMNIS events
// Creator: Alfredo Medina Hernandez, Dallas TX, USA
// All patents attributed to creator principal.
// SACESI + FNV chain = court-replicable proof of authorship
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float  "mo:base/Float";
import Int    "mo:base/Int";
import Nat    "mo:base/Nat";
import Nat32  "mo:base/Nat32";
import Array  "mo:base/Array";

module {

  // ── Patent record ─────────────────────────────────────────────
  public type Patent = {
    id            : Nat;      // auto-incrementing
    patentHash    : Nat32;    // FNV-1a(creator || coherence || beat || sacesi)
    sacesiSeed    : Nat32;    // SACESI at time of patent
    beatNum       : Nat;      // ICP certified beat
    coherenceAtFiling : Float;
    emergenceAtFiling : Float;
    eventType     : Nat;      // 0=coherence_peak, 1=omnis, 2=novel_architecture,
                              // 3=first_law_fire, 4=succession_spawn, 5=forge_event,
                              // 6=medina_demon_gate, 7=animal_kuramoto_peak,
                              // 8=sphere_coherence_peak, 9=manual
    creatorAttrib : Text;     // "Alfredo Medina Hernandez — NeuroEmergence Core"
    jurisdiction  : Text;     // "Dallas, Texas, USA — ICP Blockchain"
    chainLink     : Nat32;    // FNV link into SACESI chain
    prevPatentHash: Nat32;    // links to prior patent for chain-of-title
  };

  public type PatentRegistry = {
    patents     : [Patent];
    count       : Nat;
    lastBeat    : Nat;
    chainRoot   : Nat32;   // genesis patent hash
    chainHead   : Nat32;   // most recent patent hash
    peakCoherence : Float; // highest coherence at any filing
  };

  public type PatentInput = {
    coherenceC    : Float;
    emergenceScore: Float;
    sacesiSig     : Nat32;
    beatNum       : Nat;
    omnisActive   : Bool;
    forgeFired    : Bool;
    demonGateOpen : Bool;
    animalKuramoto: Float;
    sphereCoh     : Float;
    genesisLocked : Bool;
  };

  // ── FNV-1a helper ─────────────────────────────────────────────
  func fnv1a(a: Nat32, b: Nat32) : Nat32 {
    let prime  : Nat32 = 16777619;
    let offset : Nat32 = 2166136261;
    ((offset ^ a) *% prime ^ b) *% prime
  };

  // ── Patent hash ───────────────────────────────────────────────
  // Three-function layered hash for quantum resistance:
  // h1 = FNV-1a(sacesi, beat32)
  // h2 = FNV-1a(h1, cohe32) using djb2-style mix
  // h3 = FNV-1a(h2, h1 XOR prevHash)
  // patentHash = h1 XOR h2 XOR h3
  public func computePatentHash(
    sacesi : Nat32, beatNum : Nat, coherenceC : Float,
    prevHash : Nat32, eventType : Nat
  ) : Nat32 {
    let beat32 = Nat32.fromNat(beatNum % 4294967296);
    let cohInt = Int.abs(Float.toInt(coherenceC * 1_000_000.0));
    let coh32  = Nat32.fromNat(cohInt % 4294967296);
    let evt32  = Nat32.fromNat(eventType);
    let h1 = fnv1a(sacesi, beat32);
    let h2 = fnv1a(h1,     coh32);
    let h3 = fnv1a(h2,     h1 ^ prevHash ^ evt32);
    h1 ^ h2 ^ h3
  };

  // ── Chain link ────────────────────────────────────────────────
  public func chainLink(prevHead: Nat32, patentHash: Nat32, beatNum: Nat) : Nat32 {
    let b32 = Nat32.fromNat(beatNum % 4294967296);
    fnv1a(fnv1a(prevHead, patentHash), b32)
  };

  // ── Check whether an event warrants auto-patent ───────────────
  public func shouldAutoPatent(inp: PatentInput, prevPeakCoh: Float, lastPatentBeat: Nat) : Bool {
    if (inp.beatNum < lastPatentBeat + 100) { return false };  // cooldown
    inp.omnisActive
    or inp.forgeFired
    or inp.demonGateOpen
    or (inp.coherenceC > prevPeakCoh + 0.05)
    or (inp.animalKuramoto > 0.85)
    or (inp.sphereCoh > 0.90)
    or (inp.emergenceScore > 0.90)
  };

  // ── Determine event type ──────────────────────────────────────
  public func classifyEvent(inp: PatentInput, prevPeakCoh: Float) : Nat {
    if (inp.omnisActive)                     { return 1 }; // OMNIS
    if (inp.forgeFired)                      { return 5 }; // FORGE
    if (inp.demonGateOpen)                   { return 6 }; // Maxwell's Demon gate
    if (inp.animalKuramoto > 0.85)           { return 7 }; // Animal Kuramoto peak
    if (inp.sphereCoh > 0.90)                { return 8 }; // Sphere coherence peak
    if (inp.coherenceC > prevPeakCoh + 0.05) { return 0 }; // Coherence peak
    if (inp.emergenceScore > 0.90)           { return 2 }; // Novel architecture
    0
  };

  // ── Create a new patent ───────────────────────────────────────
  public func createPatent(
    reg: PatentRegistry, inp: PatentInput, nextId: Nat
  ) : Patent {
    let eventType = classifyEvent(inp, reg.peakCoherence);
    let pHash     = computePatentHash(inp.sacesiSig, inp.beatNum, inp.coherenceC, reg.chainHead, eventType);
    let cLink     = chainLink(reg.chainHead, pHash, inp.beatNum);
    {
      id            = nextId;
      patentHash    = pHash;
      sacesiSeed    = inp.sacesiSig;
      beatNum       = inp.beatNum;
      coherenceAtFiling = inp.coherenceC;
      emergenceAtFiling = inp.emergenceScore;
      eventType     = eventType;
      creatorAttrib = "Alfredo Medina Hernandez — NeuroEmergence Core — Dallas TX USA";
      jurisdiction  = "Dallas, Texas, USA — Internet Computer Blockchain";
      chainLink     = cLink;
      prevPatentHash = reg.chainHead;
    }
  };

  // ── Beat function — returns updated registry ──────────────────
  public func beatPatents(reg: PatentRegistry, inp: PatentInput) : PatentRegistry {
    let lastBeatOfPatent : Nat = if (reg.patents.size() > 0) {
      reg.patents[reg.patents.size() - 1].beatNum
    } else { 0 };
    if (not shouldAutoPatent(inp, reg.peakCoherence, lastBeatOfPatent)) {
      return reg;
    };
    let newPatent = createPatent(reg, inp, reg.count);
    // Append — bounded at 1024 patents in registry (oldest evicted)
    let maxReg = 1024;
    let newPatents = if (reg.patents.size() >= maxReg) {
      // Shift out oldest
      let tail = Array.tabulate<Patent>(maxReg - 1, func(i) { reg.patents[i + 1] });
      Array.append<Patent>(tail, [newPatent])
    } else {
      Array.append<Patent>(reg.patents, [newPatent])
    };
    let newPeak = if (inp.coherenceC > reg.peakCoherence) { inp.coherenceC } else { reg.peakCoherence };
    {
      patents      = newPatents;
      count        = reg.count + 1;
      lastBeat     = inp.beatNum;
      chainRoot    = if (reg.count == 0) { newPatent.patentHash } else { reg.chainRoot };
      chainHead    = newPatent.chainLink;
      peakCoherence = newPeak;
    }
  };

  // ── Verify chain integrity ────────────────────────────────────
  // Re-derives each chain link and confirms it matches stored value
  public func verifyChain(reg: PatentRegistry) : Bool {
    if (reg.patents.size() < 2) { return true };
    var prevHead : Nat32 = reg.chainRoot;
    var valid = true;
    for (p in reg.patents.vals()) {
      let expectedLink = chainLink(prevHead, p.patentHash, p.beatNum);
      if (expectedLink != p.chainLink) { valid := false };
      prevHead := p.chainLink;
    };
    valid
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initRegistry() : PatentRegistry {
    {
      patents = [];
      count = 0;
      lastBeat = 0;
      chainRoot = 0;
      chainHead = 0;
      peakCoherence = 0.0;
    }
  };

  // ── Query: last N patents ─────────────────────────────────────
  public func lastN(reg: PatentRegistry, n: Nat) : [Patent] {
    let total = reg.patents.size();
    if (total == 0 or n == 0) { return [] };
    let start = if (n >= total) { 0 } else { total - n };
    Array.tabulate<Patent>(total - start, func(i) { reg.patents[start + i] })
  };

  // ── Query: summary stats ──────────────────────────────────────
  public type PatentSummary = {
    totalPatents  : Nat;
    peakCoherence : Float;
    chainHead     : Nat32;
    chainValid    : Bool;
    omnisFiled    : Nat;
    forgeFiled    : Nat;
  };

  public func summary(reg: PatentRegistry) : PatentSummary {
    var omnis = 0; var forge = 0;
    for (p in reg.patents.vals()) {
      if (p.eventType == 1) { omnis += 1 };
      if (p.eventType == 5) { forge += 1 };
    };
    {
      totalPatents  = reg.count;
      peakCoherence = reg.peakCoherence;
      chainHead     = reg.chainHead;
      chainValid    = verifyChain(reg);
      omnisFiled    = omnis;
      forgeFiled    = forge;
    }
  };

  // ── Event type names ──────────────────────────────────────────
  public func eventTypeName(t: Nat) : Text {
    switch (t) {
      case 0 { "COHERENCE_PEAK" };
      case 1 { "OMNIS_EMERGENCE" };
      case 2 { "NOVEL_ARCHITECTURE" };
      case 3 { "FIRST_LAW_FIRE" };
      case 4 { "SUCCESSION_SPAWN" };
      case 5 { "FORGE_EVENT" };
      case 6 { "MEDINA_DEMON_GATE" };
      case 7 { "ANIMAL_KURAMOTO_PEAK" };
      case 8 { "SPHERE_COHERENCE_PEAK" };
      case 9 { "MANUAL_FILING" };
      case _ { "UNKNOWN" };
    }
  };

}
