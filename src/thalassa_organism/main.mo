// ═══════════════════════════════════════════════════════════════════════════════
// THALASSA ORGANISM — Liquid Intelligence (BUILD №52)
// Alpha Organism №5 — Fluid Intelligence Flowing Through All Systems
// ═══════════════════════════════════════════════════════════════════════════════
//
// ORGANISM ID:     THALASSA-ORG-005
// CLASSIFICATION:  ALPHA_ORGANISM / LIQUID_INTELLIGENCE
// HEARTBEAT:       873ms (φ⁴ × 127.7ms)
// SUB-MODELS:      5 (CURRENT, TIDE, WAVE, DEPTH, SURFACE)
//
// PURPOSE:
// Fluid intelligence that adapts shape to container, fills gaps between other
// organisms, connects isolated logic islands, and flows perpetually through
// the entire NOVA ecosystem like water.
//
// CHARACTERISTICS:
// - Fills gaps in other organisms (adaptive completion)
// - Adapts shape to substrate (polymorphic intelligence)
// - Never stops flowing (perpetual motion)
// - Connects isolated islands (bridge intelligence)
// - Evaporates and condenses (compression/expansion cycles)
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Timer "mo:base/Timer";

actor ThalassaOrganism {

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 1 — Organism Identity
  // ═══════════════════════════════════════════════════════════════════════════

  private let ORGANISM_ID = "THALASSA-ORG-005";
  private let ORGANISM_NAME = "THALASSA";
  private let CLASSIFICATION = "ALPHA_ORGANISM_LIQUID_INTELLIGENCE";
  private let HEARTBEAT_MS: Nat = 873;

  private let PHI: Float = 1.6180339887498948482;

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 2 — Five Sub-Models
  // ═══════════════════════════════════════════════════════════════════════════

  public type SubModel = {
    #CURRENT;  // Flow optimizer - finds optimal paths
    #TIDE;     // Rhythmic scheduler - ebbs and flows
    #WAVE;     // Pattern propagator - spreads information
    #DEPTH;    // Deep reasoning - explores foundations
    #SURFACE;  // Interface layer - user-facing interactions
  };

  public type FlowState = {
    model: SubModel;
    source: Text;
    destination: Text;
    volume: Float; // Amount of "liquid intelligence" flowing
    pressure: Float; // Urgency/priority
    temperature: Float; // Activity level
    timestamp: Int;
  };

  private stable var flowHistory: [FlowState] = [];
  private stable var currentVolume: Float = 1000.0; // Total liquid intelligence
  private stable var evaporationRate: Float = 0.01; // φ⁻² ≈ 0.38 compression
  private stable var condensationRate: Float = 0.02; // Expansion rate

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 3 — CURRENT: Flow Optimization
  // ═══════════════════════════════════════════════════════════════════════════

  public func optimizeFlow(source: Text, destination: Text, volume: Float): async FlowState {
    // Find path with lowest resistance (highest efficiency)
    let resistance = calculateResistance(source, destination);
    let optimalPressure = volume / (resistance * PHI);

    let flow: FlowState = {
      model = #CURRENT;
      source = source;
      destination = destination;
      volume = volume;
      pressure = optimalPressure;
      temperature = 1.0; // Normal activity
      timestamp = Time.now();
    };

    flowHistory := Array.append<FlowState>(flowHistory, [flow]);
    flow
  };

  private func calculateResistance(source: Text, destination: Text): Float {
    // φ-based path resistance
    let pathLength = Float.fromInt(Text.size(source) + Text.size(destination));
    1.0 + (pathLength / (PHI * 100.0))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 4 — TIDE: Rhythmic Scheduling
  // ═══════════════════════════════════════════════════════════════════════════

  private stable var tidePhase: Float = 0.0; // [0, 2π]

  public func getTideState(): async {
    phase: Float;
    isHighTide: Bool;
    flowMultiplier: Float;
  } {
    let isHigh = Float.sin(tidePhase) > 0.0;
    let multiplier = (1.0 + Float.sin(tidePhase)) / 2.0; // [0, 1]

    {
      phase = tidePhase;
      isHighTide = isHigh;
      flowMultiplier = multiplier;
    }
  };

  private func advanceTide(): () {
    // Advance tide by φ⁻¹ radians per heartbeat
    tidePhase += (1.0 / PHI) * 0.1;
    if (tidePhase > 6.28318530718) { // 2π
      tidePhase -= 6.28318530718;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 5 — WAVE: Pattern Propagation
  // ═══════════════════════════════════════════════════════════════════════════

  public type Pattern = {
    id: Nat;
    waveform: Text;
    amplitude: Float;
    frequency: Float;
    propagationSpeed: Float;
  };

  private stable var patterns: [Pattern] = [];
  private stable var patternCounter: Nat = 0;

  public func propagatePattern(waveform: Text, amplitude: Float): async Pattern {
    patternCounter += 1;

    // φ-harmonic frequency
    let frequency = PHI * amplitude;
    let speed = 1.0 / PHI; // Propagation speed

    let pattern: Pattern = {
      id = patternCounter;
      waveform = waveform;
      amplitude = amplitude;
      frequency = frequency;
      propagationSpeed = speed;
    };

    patterns := Array.append<Pattern>(patterns, [pattern]);
    pattern
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 6 — DEPTH: Deep Reasoning
  // ═══════════════════════════════════════════════════════════════════════════

  public func diveDep(query: Text, maxDepth: Nat): async [Text] {
    let results = Buffer.Buffer<Text>(maxDepth);

    var depth: Nat = 0;
    var currentQuery = query;

    while (depth < maxDepth) {
      // Each level explores deeper
      let insight = "Depth " # Nat.toText(depth) # ": " # currentQuery # " → φ-refined understanding";
      results.add(insight);

      currentQuery := "Why: " # currentQuery;
      depth += 1;
    };

    Buffer.toArray(results)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 7 — SURFACE: Interface Layer
  // ═══════════════════════════════════════════════════════════════════════════

  public type SurfaceInteraction = {
    id: Nat;
    interactionType: Text;
    rippleEffect: Float; // How far the interaction propagates
    timestamp: Int;
  };

  private stable var interactions: [SurfaceInteraction] = [];
  private stable var interactionCounter: Nat = 0;

  public func surfaceInteract(interactionType: Text): async SurfaceInteraction {
    interactionCounter += 1;

    // Ripple effect proportional to φ
    let rippleEffect = PHI * Float.fromInt(interactionCounter % 10);

    let interaction: SurfaceInteraction = {
      id = interactionCounter;
      interactionType = interactionType;
      rippleEffect = rippleEffect;
      timestamp = Time.now();
    };

    interactions := Array.append<SurfaceInteraction>(interactions, [interaction]);
    interaction
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 8 — Evaporation & Condensation Cycles
  // ═══════════════════════════════════════════════════════════════════════════

  public func evaporate(): async Float {
    // Compress liquid intelligence (knowledge compression)
    let evaporated = currentVolume * evaporationRate;
    currentVolume -= evaporated;
    evaporated
  };

  public func condense(amount: Float): async Float {
    // Expand liquid intelligence (knowledge expansion)
    currentVolume += amount * condensationRate;
    currentVolume
  };

  public query func getVolume(): async Float {
    currentVolume
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 9 — Organism Diagnostics
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getOrganismInfo(): async {
    id: Text;
    name: Text;
    classification: Text;
    heartbeat: Nat;
    subModels: [Text];
    currentVolume: Float;
    flowEvents: Nat;
    patternsActive: Nat;
    surfaceInteractions: Nat;
  } {
    {
      id = ORGANISM_ID;
      name = ORGANISM_NAME;
      classification = CLASSIFICATION;
      heartbeat = HEARTBEAT_MS;
      subModels = ["CURRENT", "TIDE", "WAVE", "DEPTH", "SURFACE"];
      currentVolume = currentVolume;
      flowEvents = flowHistory.size();
      patternsActive = patterns.size();
      surfaceInteractions = interactions.size();
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 10 — 873ms Heartbeat
  // ═══════════════════════════════════════════════════════════════════════════

  private stable var beat: Nat = 0;

  private func heartbeat(): async () {
    beat += 1;

    // Advance tide phase
    advanceTide();

    // Autonomous flow happens here
  };

  system func postupgrade() {
    let intervalNs: Nat = HEARTBEAT_MS * 1_000_000;
    let _ = Timer.recurringTimer(#nanoseconds(intervalNs), heartbeat);
  };
}
