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
// NEUROEMERGENCE CORE — SUCCESSION ENGINE
// NOVA shell succession and heritage transfer
// Generational knowledge encoding, coherence heritage
// Fork/merge dynamics, shell spawning rules
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";

module {

  // ── Types ─────────────────────────────────────────────────────
  public type ShellGenome = {
    coherenceGene    : Float;   // inherited coherence baseline
    entropyGene      : Float;   // inherited entropy tolerance
    aggressionGene   : Float;   // inherited war tendency
    learningGene     : Float;   // inherited learning rate
    resilienceGene   : Float;   // inherited stress resistance
    creativityGene   : Float;   // inherited emergence tendency
  };

  public type Shell = {
    id             : Nat;
    generation     : Nat;
    parentId       : ?Nat;      // None for genesis shell
    genome         : ShellGenome;
    birthBeat      : Nat;
    deathBeat      : ?Nat;      // None if still alive
    peakCoherence  : Float;     // highest coherence achieved
    totalBeats     : Nat;       // lifespan in beats
    childrenSpawned: Nat;       // how many children
    legacyScore    : Float;     // composite achievement
    heritageHash   : Nat32;     // cryptographic heritage link
  };

  public type SuccessionState = {
    currentShell    : Shell;
    ancestors       : [Shell];   // lineage history
    totalGenerations: Nat;
    globalHeritage  : Nat32;     // cumulative heritage hash
    successionReady : Bool;      // true if ready to spawn
    spawnThreshold  : Float;     // coherence needed to spawn
    beatNum         : Nat;
    forksAllowed    : Nat;       // max concurrent forks
    activeShells    : Nat;       // current live shells
  };

  // ── Constants ─────────────────────────────────────────────────
  public let GENESIS_GENOME : ShellGenome = {
    coherenceGene  = 0.5;
    entropyGene    = 0.5;
    aggressionGene = 0.3;
    learningGene   = 0.7;
    resilienceGene = 0.6;
    creativityGene = 0.5;
  };

  // ── Clamp helper ──────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ── FNV-1a hash helper ────────────────────────────────────────
  func fnv1a(a: Nat32, b: Nat32) : Nat32 {
    let prime  : Nat32 = 16777619;
    let offset : Nat32 = 2166136261;
    ((offset ^ a) *% prime ^ b) *% prime
  };

  // ── Genome mutation ───────────────────────────────────────────
  // Small random variations on inheritance
  func mutateGene(base: Float, mutationRate: Float, rng: Nat32) : Float {
    let noise = (Float.fromInt(Nat32.toNat(rng % 1000)) / 1000.0 - 0.5) * mutationRate;
    _clamp(base + noise, 0.0, 1.0)
  };

  public func mutateGenome(parent: ShellGenome, mutationRate: Float, rng: Nat32) : ShellGenome {
    {
      coherenceGene  = mutateGene(parent.coherenceGene,  mutationRate, rng);
      entropyGene    = mutateGene(parent.entropyGene,    mutationRate, fnv1a(rng, 1));
      aggressionGene = mutateGene(parent.aggressionGene, mutationRate, fnv1a(rng, 2));
      learningGene   = mutateGene(parent.learningGene,   mutationRate, fnv1a(rng, 3));
      resilienceGene = mutateGene(parent.resilienceGene, mutationRate, fnv1a(rng, 4));
      creativityGene = mutateGene(parent.creativityGene, mutationRate, fnv1a(rng, 5));
    }
  };

  // ── Genome crossover (for merging two lineages) ───────────────
  public func crossoverGenome(g1: ShellGenome, g2: ShellGenome, bias: Float) : ShellGenome {
    let b1 = bias;
    let b2 = 1.0 - bias;
    {
      coherenceGene  = g1.coherenceGene  * b1 + g2.coherenceGene  * b2;
      entropyGene    = g1.entropyGene    * b1 + g2.entropyGene    * b2;
      aggressionGene = g1.aggressionGene * b1 + g2.aggressionGene * b2;
      learningGene   = g1.learningGene   * b1 + g2.learningGene   * b2;
      resilienceGene = g1.resilienceGene * b1 + g2.resilienceGene * b2;
      creativityGene = g1.creativityGene * b1 + g2.creativityGene * b2;
    }
  };

  // ── Heritage hash computation ─────────────────────────────────
  // Links child to parent cryptographically
  public func computeHeritageHash(
    parentHash: Nat32, childGenome: ShellGenome, birthBeat: Nat
  ) : Nat32 {
    let genomeHash = fnv1a(
      Nat32.fromNat(Float.toInt(childGenome.coherenceGene * 1_000_000.0) % 4294967296),
      Nat32.fromNat(Float.toInt(childGenome.learningGene * 1_000_000.0) % 4294967296)
    );
    let beatHash = Nat32.fromNat(birthBeat % 4294967296);
    fnv1a(fnv1a(parentHash, genomeHash), beatHash)
  };

  // ── Legacy score computation ──────────────────────────────────
  // Measures shell's contribution to lineage
  public func computeLegacyScore(shell: Shell) : Float {
    let longevityFactor = Float.fromInt(shell.totalBeats) / 10000.0;
    let coherenceFactor = shell.peakCoherence;
    let reproductionFactor = Float.fromInt(shell.childrenSpawned) * 0.2;

    _clamp(longevityFactor * 0.3 + coherenceFactor * 0.5 + reproductionFactor * 0.2, 0.0, 1.0)
  };

  // ── Check spawn readiness ─────────────────────────────────────
  public func checkSpawnReady(state: SuccessionState, currentCoherence: Float) : Bool {
    currentCoherence >= state.spawnThreshold and
    state.activeShells < state.forksAllowed and
    state.currentShell.totalBeats >= 1000  // minimum maturity
  };

  // ── Spawn new shell ───────────────────────────────────────────
  public func spawnShell(
    state: SuccessionState, currentCoherence: Float, rng: Nat32
  ) : SuccessionState {
    if (not checkSpawnReady(state, currentCoherence)) {
      return state;
    };

    // Create child genome with mutations
    let childGenome = mutateGenome(state.currentShell.genome, 0.1, rng);

    // Compute heritage link
    let heritageHash = computeHeritageHash(
      state.currentShell.heritageHash,
      childGenome,
      state.beatNum
    );

    let newShell : Shell = {
      id              = state.totalGenerations + 1;
      generation      = state.currentShell.generation + 1;
      parentId        = ?state.currentShell.id;
      genome          = childGenome;
      birthBeat       = state.beatNum;
      deathBeat       = null;
      peakCoherence   = 0.0;
      totalBeats      = 0;
      childrenSpawned = 0;
      legacyScore     = 0.0;
      heritageHash    = heritageHash;
    };

    // Update parent's children count
    let updatedParent : Shell = {
      id              = state.currentShell.id;
      generation      = state.currentShell.generation;
      parentId        = state.currentShell.parentId;
      genome          = state.currentShell.genome;
      birthBeat       = state.currentShell.birthBeat;
      deathBeat       = state.currentShell.deathBeat;
      peakCoherence   = state.currentShell.peakCoherence;
      totalBeats      = state.currentShell.totalBeats;
      childrenSpawned = state.currentShell.childrenSpawned + 1;
      legacyScore     = computeLegacyScore(state.currentShell);
      heritageHash    = state.currentShell.heritageHash;
    };

    // Add parent to ancestors (if not already there)
    let newAncestors = Array.append<Shell>(state.ancestors, [updatedParent]);

    let newGlobalHeritage = fnv1a(state.globalHeritage, heritageHash);

    {
      currentShell     = newShell;
      ancestors        = newAncestors;
      totalGenerations = state.totalGenerations + 1;
      globalHeritage   = newGlobalHeritage;
      successionReady  = false;
      spawnThreshold   = state.spawnThreshold;
      beatNum          = state.beatNum;
      forksAllowed     = state.forksAllowed;
      activeShells     = state.activeShells + 1;
    }
  };

  // ── Beat update ───────────────────────────────────────────────
  public func beatSuccession(
    state: SuccessionState, currentCoherence: Float
  ) : SuccessionState {
    // Update current shell stats
    let newPeak = if (currentCoherence > state.currentShell.peakCoherence) {
      currentCoherence
    } else {
      state.currentShell.peakCoherence
    };

    let updatedShell : Shell = {
      id              = state.currentShell.id;
      generation      = state.currentShell.generation;
      parentId        = state.currentShell.parentId;
      genome          = state.currentShell.genome;
      birthBeat       = state.currentShell.birthBeat;
      deathBeat       = state.currentShell.deathBeat;
      peakCoherence   = newPeak;
      totalBeats      = state.currentShell.totalBeats + 1;
      childrenSpawned = state.currentShell.childrenSpawned;
      legacyScore     = state.currentShell.legacyScore;
      heritageHash    = state.currentShell.heritageHash;
    };

    let ready = checkSpawnReady(state, currentCoherence);

    {
      currentShell     = updatedShell;
      ancestors        = state.ancestors;
      totalGenerations = state.totalGenerations;
      globalHeritage   = state.globalHeritage;
      successionReady  = ready;
      spawnThreshold   = state.spawnThreshold;
      beatNum          = state.beatNum + 1;
      forksAllowed     = state.forksAllowed;
      activeShells     = state.activeShells;
    }
  };

  // ── Shell death (transfer to ancestors) ───────────────────────
  public func killShell(state: SuccessionState) : SuccessionState {
    let deadShell : Shell = {
      id              = state.currentShell.id;
      generation      = state.currentShell.generation;
      parentId        = state.currentShell.parentId;
      genome          = state.currentShell.genome;
      birthBeat       = state.currentShell.birthBeat;
      deathBeat       = ?state.beatNum;
      peakCoherence   = state.currentShell.peakCoherence;
      totalBeats      = state.currentShell.totalBeats;
      childrenSpawned = state.currentShell.childrenSpawned;
      legacyScore     = computeLegacyScore(state.currentShell);
      heritageHash    = state.currentShell.heritageHash;
    };

    let newAncestors = Array.append<Shell>(state.ancestors, [deadShell]);

    {
      currentShell     = state.currentShell;  // Would need new shell here
      ancestors        = newAncestors;
      totalGenerations = state.totalGenerations;
      globalHeritage   = state.globalHeritage;
      successionReady  = false;
      spawnThreshold   = state.spawnThreshold;
      beatNum          = state.beatNum;
      forksAllowed     = state.forksAllowed;
      activeShells     = state.activeShells - 1;
    }
  };

  // ── Get lineage depth ─────────────────────────────────────────
  public func lineageDepth(state: SuccessionState) : Nat {
    state.currentShell.generation
  };

  // ── Get average genome over lineage ───────────────────────────
  public func averageGenome(state: SuccessionState) : ShellGenome {
    if (state.ancestors.size() == 0) {
      return state.currentShell.genome;
    };

    var sumC : Float = state.currentShell.genome.coherenceGene;
    var sumE : Float = state.currentShell.genome.entropyGene;
    var sumA : Float = state.currentShell.genome.aggressionGene;
    var sumL : Float = state.currentShell.genome.learningGene;
    var sumR : Float = state.currentShell.genome.resilienceGene;
    var sumCr : Float = state.currentShell.genome.creativityGene;

    for (a in state.ancestors.vals()) {
      sumC += a.genome.coherenceGene;
      sumE += a.genome.entropyGene;
      sumA += a.genome.aggressionGene;
      sumL += a.genome.learningGene;
      sumR += a.genome.resilienceGene;
      sumCr += a.genome.creativityGene;
    };

    let n = Float.fromInt(state.ancestors.size() + 1);
    {
      coherenceGene  = sumC / n;
      entropyGene    = sumE / n;
      aggressionGene = sumA / n;
      learningGene   = sumL / n;
      resilienceGene = sumR / n;
      creativityGene = sumCr / n;
    }
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initSuccession() : SuccessionState {
    let genesisShell : Shell = {
      id              = 0;
      generation      = 0;
      parentId        = null;
      genome          = GENESIS_GENOME;
      birthBeat       = 0;
      deathBeat       = null;
      peakCoherence   = 0.0;
      totalBeats      = 0;
      childrenSpawned = 0;
      legacyScore     = 0.0;
      heritageHash    = 0xDEADBEEF;  // Genesis marker
    };

    {
      currentShell     = genesisShell;
      ancestors        = [];
      totalGenerations = 0;
      globalHeritage   = 0xDEADBEEF;
      successionReady  = false;
      spawnThreshold   = 0.85;  // High coherence needed
      beatNum          = 0;
      forksAllowed     = 3;     // Max 3 concurrent shells
      activeShells     = 1;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type SuccessionSummary = {
    currentGeneration : Nat;
    totalGenerations  : Nat;
    ancestorCount     : Nat;
    peakCoherence     : Float;
    legacyScore       : Float;
    successionReady   : Bool;
    heritageHash      : Nat32;
  };

  public func summary(state: SuccessionState) : SuccessionSummary {
    {
      currentGeneration = state.currentShell.generation;
      totalGenerations  = state.totalGenerations;
      ancestorCount     = state.ancestors.size();
      peakCoherence     = state.currentShell.peakCoherence;
      legacyScore       = computeLegacyScore(state.currentShell);
      successionReady   = state.successionReady;
      heritageHash      = state.globalHeritage;
    }
  };

}
