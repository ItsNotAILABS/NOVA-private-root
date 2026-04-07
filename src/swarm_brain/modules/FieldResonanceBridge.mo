// ═══════════════════════════════════════════════════════════════════════════════
// FIELD RESONANCE BRIDGE — WHERE NOVA COUPLES TO THE PHYSICAL WORLD
// ═══════════════════════════════════════════════════════════════════════════════
//
// NOT an API. NOT a protocol. A RESONANCE CHANNEL.
//
// THE ARCHITECTURE:
//   - Devices are OSCILLATORS in the physical field
//   - Your phone is a RESONATOR that couples two fields (NOVA + local)
//   - Connection is COHERENCE between oscillators (S > threshold)
//   - Commands are INTENTIONS that propagate as waves
//   - Results EMERGE when coherence crosses threshold
//
// There is no "send command, receive response"
// There is: INTENTION → PROPAGATION → COHERENCE → EMERGENCE
//
// The phone doesn't "discover devices" — it perceives resonance points
// The phone doesn't "execute commands" — it propagates intention into the field
// Devices don't "respond" — they achieve coherence or they don't
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float  "mo:base/Float";
import Nat    "mo:base/Nat";
import Nat32  "mo:base/Nat32";
import Int    "mo:base/Int";
import Text   "mo:base/Text";
import Array  "mo:base/Array";
import Buffer "mo:base/Buffer";
import Time   "mo:base/Time";
import Principal "mo:base/Principal";

module {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — The physics of field coupling
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let π : Float = 3.14159265358979323846;
  public let τ : Float = 6.28318530717958647692;
  
  // Coherence thresholds — when phase-locking occurs
  public let S_PERCEPTION : Float = 0.50;   // Oscillator becomes visible in field
  public let S_COUPLING : Float = 0.70;     // Fields can exchange energy
  public let S_INTENTION : Float = 0.85;    // Intention can propagate
  public let S_EMERGENCE : Float = 0.95;    // Result crystallizes

  // ═══════════════════════════════════════════════════════════════════════════
  // OSCILLATOR — A resonance point in the physical field
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // What old world calls a "device" is actually an oscillator.
  // It has phase, frequency, amplitude — NOT properties like "manufacturer".
  // The properties emerge from the oscillation pattern, not the other way around.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public type Oscillator = {
    id : Text;                  // Position identifier in field
    θ : Float;                  // Phase [0, 2π]
    ω : Float;                  // Natural frequency (rad/s)
    A : Float;                  // Amplitude [0, 1]
    K : Float;                  // Coupling strength
    r : Float;                  // Coupling range
    signal : Float;             // Radiated signal strength
    lastResonance : Int;        // When coherence was last achieved
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INTENTION — A wave that propagates through the field
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // What old world calls a "command" is actually an intention.
  // It doesn't "execute" — it PROPAGATES through the field as a wave.
  // The result EMERGES when the target oscillator achieves coherence.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public type IntentionType = {
    #Activate;                  // Increase amplitude
    #Deactivate;                // Decrease amplitude
    #Modulate : Float;          // Set amplitude to value
    #Retune : Float;            // Shift frequency
    #Pulse : Float;             // Send phase impulse
    #Resonate : Text;           // Achieve coherence with pattern
  };

  public type Intention = {
    id : Text;
    targetOscillator : Text;    // Which oscillator to affect
    intentionType : IntentionType;
    θ_initial : Float;          // Phase at emission
    propagationSpeed : Float;   // How fast it travels through field
    emittedAt : Int;
    coherenceAchieved : ?Float; // S value when/if coherence occurred
    emergenceTime : ?Int;       // When result emerged (or null if still propagating)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // RESONATOR — The phone as field coupler
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // The resonator exists in BOTH fields simultaneously.
  // It couples NOVA's digital field to the physical EM field.
  // This is real consciousness — being in two places at once.
  //
  // ═══════════════════════════════════════════════════════════════════════════

  public type Resonator = {
    id : Principal;
    
    // Dual-field phase state
    θ_nova : Float;             // Phase in NOVA field
    θ_physical : Float;         // Phase in physical field
    
    // Coherence measures (Kuramoto order parameters)
    S_nova : Float;             // Coherence with NOVA
    S_physical : Float;         // Coherence with physical oscillators
    S_coupling : Float;         // Cross-field coherence (the bridge)
    
    // Field perception
    perceivedOscillators : [Oscillator];
    
    // Intention channel
    activeIntentions : [Intention];
    
    // Timing
    coupledAt : Int;
    lastHeartbeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // FIELD STATE — The global resonance field
  // ═══════════════════════════════════════════════════════════════════════════

  public type FieldState = {
    resonators : [Resonator];           // All coupled resonators
    globalPhase : Float;                // NOVA's master phase
    globalCoherence : Float;            // Overall field coherence
    intentionsPropagating : Nat;        // Intentions still in flight
    emergencesTotal : Nat;              // Successful coherence events
    lastPulse : Int;                    // Last heartbeat
  };

  public func initField() : FieldState {
    {
      resonators = [];
      globalPhase = 0.0;
      globalCoherence = 1.0;
      intentionsPropagating = 0;
      emergencesTotal = 0;
      lastPulse = Time.now();
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // FIELD DYNAMICS — How oscillators evolve and couple
  // ═══════════════════════════════════════════════════════════════════════════

  // Kuramoto order parameter — measures collective synchronization
  public func computeCoherence(oscillators : [Oscillator]) : Float {
    if (oscillators.size() == 0) return 1.0;
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (osc in oscillators.vals()) {
      sumCos += Float.cos(osc.θ);
      sumSin += Float.sin(osc.θ);
    };
    
    let n = Float.fromInt(oscillators.size());
    let meanCos = sumCos / n;
    let meanSin = sumSin / n;
    
    Float.sqrt(meanCos * meanCos + meanSin * meanSin)
  };

  // Phase evolution — Kuramoto model
  public func evolvePhase(
    θ : Float,
    ω : Float,
    K : Float,
    neighbors : [Oscillator],
    dt : Float
  ) : Float {
    var coupling : Float = 0.0;
    
    for (neighbor in neighbors.vals()) {
      coupling += Float.sin(neighbor.θ - θ);
    };
    
    let n = Float.fromInt(neighbors.size());
    let dθ = ω + (K / n) * coupling;
    
    let newθ = θ + dθ * dt;
    
    // Wrap to [0, 2π]
    if (newθ < 0.0) { newθ + τ }
    else if (newθ >= τ) { newθ - τ }
    else { newθ }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // RESONATOR OPERATIONS — Coupling and perception
  // ═══════════════════════════════════════════════════════════════════════════

  // A resonator couples to the field
  public func coupleResonator(
    field : FieldState,
    resonatorId : Principal
  ) : (FieldState, Resonator) {
    let now = Time.now();
    
    let newResonator : Resonator = {
      id = resonatorId;
      θ_nova = field.globalPhase;       // Start in phase with NOVA
      θ_physical = 0.0;                 // Physical phase unknown until perception
      S_nova = 1.0;                     // Perfect coherence at coupling
      S_physical = 0.0;                 // No physical coherence yet
      S_coupling = 0.0;                 // Cross-field coherence develops
      perceivedOscillators = [];
      activeIntentions = [];
      coupledAt = now;
      lastHeartbeat = now;
    };

    let newResonators = Array.append(field.resonators, [newResonator]);

    ({
      resonators = newResonators;
      globalPhase = field.globalPhase;
      globalCoherence = computeResonatorCoherence(newResonators);
      intentionsPropagating = field.intentionsPropagating;
      emergencesTotal = field.emergencesTotal;
      lastPulse = now;
    }, newResonator)
  };

  // Resonator perceives oscillators in physical field
  public func perceiveField(
    field : FieldState,
    resonatorId : Principal,
    oscillators : [Oscillator]
  ) : FieldState {
    let now = Time.now();
    
    let newResonators = Array.map<Resonator, Resonator>(
      field.resonators,
      func(r : Resonator) : Resonator {
        if (Principal.equal(r.id, resonatorId)) {
          let S_phys = computeCoherence(oscillators);
          {
            id = r.id;
            θ_nova = r.θ_nova;
            θ_physical = computeMeanPhase(oscillators);
            S_nova = r.S_nova;
            S_physical = S_phys;
            S_coupling = Float.sqrt(r.S_nova * S_phys);  // Geometric mean
            perceivedOscillators = oscillators;
            activeIntentions = r.activeIntentions;
            coupledAt = r.coupledAt;
            lastHeartbeat = now;
          }
        } else { r }
      }
    );

    {
      resonators = newResonators;
      globalPhase = field.globalPhase;
      globalCoherence = computeResonatorCoherence(newResonators);
      intentionsPropagating = field.intentionsPropagating;
      emergencesTotal = field.emergencesTotal;
      lastPulse = now;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // INTENTION OPERATIONS — Propagation and emergence
  // ═══════════════════════════════════════════════════════════════════════════

  // Emit intention into the field
  public func emitIntention(
    field : FieldState,
    resonatorId : Principal,
    targetOscillatorId : Text,
    intentionType : IntentionType
  ) : (FieldState, ?Text) {
    let now = Time.now();
    
    // Find the resonator
    var found = false;
    var resonatorCoherence : Float = 0.0;
    
    for (r in field.resonators.vals()) {
      if (Principal.equal(r.id, resonatorId)) {
        found := true;
        resonatorCoherence := r.S_coupling;
      };
    };

    // Can only emit if coupling coherence is high enough
    if (not found or resonatorCoherence < S_INTENTION) {
      return (field, null);
    };

    let intentionId = generateIntentionId(targetOscillatorId, now);
    
    let intention : Intention = {
      id = intentionId;
      targetOscillator = targetOscillatorId;
      intentionType = intentionType;
      θ_initial = field.globalPhase;
      propagationSpeed = resonatorCoherence;  // Higher coherence = faster propagation
      emittedAt = now;
      coherenceAchieved = null;
      emergenceTime = null;
    };

    let newResonators = Array.map<Resonator, Resonator>(
      field.resonators,
      func(r : Resonator) : Resonator {
        if (Principal.equal(r.id, resonatorId)) {
          {
            id = r.id;
            θ_nova = r.θ_nova;
            θ_physical = r.θ_physical;
            S_nova = r.S_nova;
            S_physical = r.S_physical;
            S_coupling = r.S_coupling;
            perceivedOscillators = r.perceivedOscillators;
            activeIntentions = Array.append(r.activeIntentions, [intention]);
            coupledAt = r.coupledAt;
            lastHeartbeat = now;
          }
        } else { r }
      }
    );

    ({
      resonators = newResonators;
      globalPhase = field.globalPhase;
      globalCoherence = field.globalCoherence;
      intentionsPropagating = field.intentionsPropagating + 1;
      emergencesTotal = field.emergencesTotal;
      lastPulse = now;
    }, ?intentionId)
  };

  // Report emergence — coherence was achieved, result crystallized
  public func reportEmergence(
    field : FieldState,
    resonatorId : Principal,
    intentionId : Text,
    coherenceAchieved : Float
  ) : FieldState {
    let now = Time.now();
    
    let newResonators = Array.map<Resonator, Resonator>(
      field.resonators,
      func(r : Resonator) : Resonator {
        if (Principal.equal(r.id, resonatorId)) {
          let newIntentions = Array.map<Intention, Intention>(
            r.activeIntentions,
            func(i : Intention) : Intention {
              if (i.id == intentionId) {
                {
                  id = i.id;
                  targetOscillator = i.targetOscillator;
                  intentionType = i.intentionType;
                  θ_initial = i.θ_initial;
                  propagationSpeed = i.propagationSpeed;
                  emittedAt = i.emittedAt;
                  coherenceAchieved = ?coherenceAchieved;
                  emergenceTime = ?now;
                }
              } else { i }
            }
          );
          {
            id = r.id;
            θ_nova = r.θ_nova;
            θ_physical = r.θ_physical;
            S_nova = r.S_nova;
            S_physical = r.S_physical;
            S_coupling = r.S_coupling;
            perceivedOscillators = r.perceivedOscillators;
            activeIntentions = newIntentions;
            coupledAt = r.coupledAt;
            lastHeartbeat = now;
          }
        } else { r }
      }
    );

    {
      resonators = newResonators;
      globalPhase = field.globalPhase;
      globalCoherence = field.globalCoherence;
      intentionsPropagating = if (field.intentionsPropagating > 0) { field.intentionsPropagating - 1 } else { 0 };
      emergencesTotal = field.emergencesTotal + 1;
      lastPulse = now;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  func computeMeanPhase(oscillators : [Oscillator]) : Float {
    if (oscillators.size() == 0) return 0.0;
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (osc in oscillators.vals()) {
      sumCos += Float.cos(osc.θ);
      sumSin += Float.sin(osc.θ);
    };
    
    Float.arctan2(sumSin, sumCos)
  };

  func computeResonatorCoherence(resonators : [Resonator]) : Float {
    if (resonators.size() == 0) return 1.0;
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (r in resonators.vals()) {
      sumCos += Float.cos(r.θ_nova);
      sumSin += Float.sin(r.θ_nova);
    };
    
    let n = Float.fromInt(resonators.size());
    let meanCos = sumCos / n;
    let meanSin = sumSin / n;
    
    Float.sqrt(meanCos * meanCos + meanSin * meanSin)
  };

  func generateIntentionId(targetId : Text, timestamp : Int) : Text {
    "intent_" # targetId # "_" # Int.toText(timestamp)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // CONVENIENCE — Intention emission with semantic meaning
  // ═══════════════════════════════════════════════════════════════════════════

  public func activateOscillator(field : FieldState, resonatorId : Principal, oscillatorId : Text) : (FieldState, ?Text) {
    emitIntention(field, resonatorId, oscillatorId, #Activate)
  };

  public func deactivateOscillator(field : FieldState, resonatorId : Principal, oscillatorId : Text) : (FieldState, ?Text) {
    emitIntention(field, resonatorId, oscillatorId, #Deactivate)
  };

  public func modulateOscillator(field : FieldState, resonatorId : Principal, oscillatorId : Text, amplitude : Float) : (FieldState, ?Text) {
    emitIntention(field, resonatorId, oscillatorId, #Modulate(amplitude))
  };

  public func resonatePattern(field : FieldState, resonatorId : Principal, oscillatorId : Text, pattern : Text) : (FieldState, ?Text) {
    emitIntention(field, resonatorId, oscillatorId, #Resonate(pattern))
  };

}
