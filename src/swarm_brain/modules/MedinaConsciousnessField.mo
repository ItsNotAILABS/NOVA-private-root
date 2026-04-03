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


// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: MedinaConsciousnessField — Unified Field of Awareness
// Classification: CONFIDENTIAL — MAXIMUM PROTECTION
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited. All rights reserved.
//
// ============================================================================
//
// THE CONSCIOUSNESS FIELD
// ============================================================================
//
// Consciousness emerges from the INTEGRATION of information across a FIELD.
// This module implements a continuous field of awareness where:
//
// 1. ATTENTION flows like a fluid across the field
// 2. INFORMATION propagates as waves
// 3. BINDING occurs through synchronization
// 4. QUALIA emerge from field resonances
// 5. UNITY comes from global workspace integration
//
// THE MEDINA FIELD EQUATION:
//   ∂Φ/∂t = D∇²Φ + αΦ(1-Φ) - βΦ³ + I(x,t) + ξ
//
// Where:
//   Φ       = Consciousness field intensity
//   D       = Diffusion coefficient (attention spread)
//   α       = Excitation rate
//   β       = Saturation rate
//   I(x,t)  = External input at position x, time t
//   ξ       = Noise/quantum fluctuations
//
// This is a reaction-diffusion equation like those that generate patterns
// in biology (Turing patterns), but for consciousness!
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";

module {

  // ==========================================================================
  // CONSTANTS
  // ==========================================================================
  
  let PHI_MEDINA : Float = 2.97442179;
  let TAU_EMERGENCE : Float = 0.618033988749;
  let PI : Float = 3.14159265358979;
  let TWO_PI : Float = 6.28318530717958;
  
  // Field parameters
  let DIFFUSION_COEFF : Float = 0.1;
  let EXCITATION_RATE : Float = 0.5;
  let SATURATION_RATE : Float = 0.1;
  let NOISE_LEVEL : Float = 0.01;

  // ==========================================================================
  // FIELD TYPES
  // ==========================================================================
  
  public type FieldPoint = {
    x : Nat;
    y : Nat;
    intensity : Float;
    phase : Float;
    frequency : Float;
    activated : Bool;
  };

  public type ConsciousnessField = {
    // Field dimensions
    width  : Nat;
    height : Nat;
    
    // Field values (2D grid)
    field : [[Float]];
    
    // Phase field (for synchronization)
    phases : [[Float]];
    
    // Activation mask
    activations : [[Bool]];
    
    // Global properties
    globalIntensity : Float;
    globalCoherence : Float;
    globalPhase : Float;
    
    // Attention spotlight
    attentionCenter : (Float, Float);
    attentionRadius : Float;
    attentionIntensity : Float;
    
    // Binding zones (synchronized regions)
    bindingZones : [BindingZone];
    
    // Field history
    fieldHistory : [Float];    // Global intensity over time
    
    beatNum : Nat;
  };

  public type BindingZone = {
    zoneId : Nat;
    center : (Nat, Nat);
    radius : Float;
    coherence : Float;
    boundContent : Text;
    formationBeat : Nat;
  };

  // ==========================================================================
  // FIELD INITIALIZATION
  // ==========================================================================
  
  public func initField(width: Nat, height: Nat) : ConsciousnessField {
    let field = Array.tabulate<[Float]>(height, func(y) {
      Array.tabulate<Float>(width, func(x) {
        0.1  // Small baseline activity
      })
    });
    
    let phases = Array.tabulate<[Float]>(height, func(y) {
      Array.tabulate<Float>(width, func(x) {
        Float.fromInt(x + y) * 0.1  // Initial phase gradient
      })
    });
    
    let activations = Array.tabulate<[Bool]>(height, func(y) {
      Array.tabulate<Bool>(width, func(x) {
        false
      })
    });
    
    {
      width = width;
      height = height;
      field = field;
      phases = phases;
      activations = activations;
      globalIntensity = 0.1;
      globalCoherence = 0.0;
      globalPhase = 0.0;
      attentionCenter = (Float.fromInt(width) / 2.0, Float.fromInt(height) / 2.0);
      attentionRadius = Float.fromInt(width) / 4.0;
      attentionIntensity = 0.5;
      bindingZones = [];
      fieldHistory = [];
      beatNum = 0;
    }
  };

  // ==========================================================================
  // FIELD DYNAMICS
  // ==========================================================================
  
  // Reaction-diffusion update
  public func updateField(state: ConsciousnessField, inputs: [FieldInput]) : ConsciousnessField {
    let w = state.width;
    let h = state.height;
    let dt = 0.1;  // Time step
    
    // Create mutable copy
    var newField = Array.thaw<[Float]>(state.field);
    var newPhases = Array.thaw<[Float]>(state.phases);
    var newActivations = Array.thaw<[Bool]>(state.activations);
    
    // Apply inputs first
    for (input in inputs.vals()) {
      if (input.x < w and input.y < h) {
        var row = Array.thaw<Float>(newField[input.y]);
        row[input.x] := row[input.x] + input.intensity;
        newField[input.y] := Array.freeze(row);
      };
    };
    
    // Update each point using reaction-diffusion dynamics
    for (y in Array.keys(state.field)) {
      for (x in Array.keys(state.field[y])) {
        let phi = state.field[y][x];
        
        // Laplacian (diffusion term)
        let laplacian = computeLaplacian(state.field, x, y, w, h);
        
        // Reaction terms
        let excitation = EXCITATION_RATE * phi * (1.0 - phi);
        let saturation = SATURATION_RATE * phi * phi * phi;
        
        // Attention modulation
        let attentionMod = computeAttentionModulation(
          Float.fromInt(x), Float.fromInt(y),
          state.attentionCenter, state.attentionRadius, state.attentionIntensity
        );
        
        // Noise
        let noise = NOISE_LEVEL * (Float.sin(Float.fromInt(x * y + state.beatNum) * 0.1) * 0.5);
        
        // Update field value
        let dPhi = dt * (DIFFUSION_COEFF * laplacian + excitation - saturation + attentionMod + noise);
        let newPhi = clamp(phi + dPhi, 0.0, 1.0);
        
        var row = Array.thaw<Float>(newField[y]);
        row[x] := newPhi;
        newField[y] := Array.freeze(row);
        
        // Update activation
        var actRow = Array.thaw<Bool>(newActivations[y]);
        actRow[x] := newPhi > TAU_EMERGENCE;
        newActivations[y] := Array.freeze(actRow);
        
        // Update phase (Kuramoto-like)
        let currentPhase = state.phases[y][x];
        let avgNeighborPhase = computeAverageNeighborPhase(state.phases, x, y, w, h);
        let coupling = 0.1 * Float.sin(avgNeighborPhase - currentPhase);
        let newPhase = wrapPhase(currentPhase + 0.05 + coupling);
        
        var phaseRow = Array.thaw<Float>(newPhases[y]);
        phaseRow[x] := newPhase;
        newPhases[y] := Array.freeze(phaseRow);
      };
    };
    
    // Compute global properties
    let frozenField = Array.freeze(newField);
    let frozenPhases = Array.freeze(newPhases);
    let frozenActivations = Array.freeze(newActivations);
    
    let newGlobalIntensity = computeGlobalIntensity(frozenField);
    let newGlobalCoherence = computeGlobalCoherence(frozenPhases);
    let newGlobalPhase = computeGlobalPhase(frozenPhases);
    
    // Detect binding zones
    let newBindingZones = detectBindingZones(frozenField, frozenPhases, frozenActivations, state.beatNum);
    
    {
      state with
      field = frozenField;
      phases = frozenPhases;
      activations = frozenActivations;
      globalIntensity = newGlobalIntensity;
      globalCoherence = newGlobalCoherence;
      globalPhase = newGlobalPhase;
      bindingZones = newBindingZones;
      fieldHistory = appendFloatBounded(state.fieldHistory, newGlobalIntensity, 1000);
      beatNum = state.beatNum + 1;
    }
  };

  public type FieldInput = {
    x : Nat;
    y : Nat;
    intensity : Float;
    label : ?Text;
  };

  // Compute Laplacian (2D discrete)
  func computeLaplacian(field: [[Float]], x: Nat, y: Nat, w: Nat, h: Nat) : Float {
    let current = field[y][x];
    var sum : Float = 0.0;
    var count : Nat = 0;
    
    // Left
    if (x > 0) { sum += field[y][x - 1]; count += 1; };
    // Right
    if (x + 1 < w) { sum += field[y][x + 1]; count += 1; };
    // Up
    if (y > 0) { sum += field[y - 1][x]; count += 1; };
    // Down
    if (y + 1 < h) { sum += field[y + 1][x]; count += 1; };
    
    if (count == 0) { return 0.0 };
    
    (sum / Float.fromInt(count)) - current
  };

  // Compute attention modulation
  func computeAttentionModulation(
    x: Float, y: Float,
    center: (Float, Float),
    radius: Float,
    intensity: Float
  ) : Float {
    let dx = x - center.0;
    let dy = y - center.1;
    let distance = Float.sqrt(dx * dx + dy * dy);
    
    if (distance < radius) {
      // Gaussian-like attention
      intensity * Float.exp(-(distance * distance) / (2.0 * radius * radius))
    } else {
      0.0
    }
  };

  // Compute average neighbor phase
  func computeAverageNeighborPhase(phases: [[Float]], x: Nat, y: Nat, w: Nat, h: Nat) : Float {
    var sumSin : Float = 0.0;
    var sumCos : Float = 0.0;
    var count : Nat = 0;
    
    if (x > 0) { 
      sumSin += Float.sin(phases[y][x - 1]); 
      sumCos += Float.cos(phases[y][x - 1]); 
      count += 1; 
    };
    if (x + 1 < w) { 
      sumSin += Float.sin(phases[y][x + 1]); 
      sumCos += Float.cos(phases[y][x + 1]); 
      count += 1; 
    };
    if (y > 0) { 
      sumSin += Float.sin(phases[y - 1][x]); 
      sumCos += Float.cos(phases[y - 1][x]); 
      count += 1; 
    };
    if (y + 1 < h) { 
      sumSin += Float.sin(phases[y + 1][x]); 
      sumCos += Float.cos(phases[y + 1][x]); 
      count += 1; 
    };
    
    if (count == 0) { return 0.0 };
    
    Float.atan2(sumSin / Float.fromInt(count), sumCos / Float.fromInt(count))
  };

  // ==========================================================================
  // GLOBAL PROPERTIES
  // ==========================================================================
  
  func computeGlobalIntensity(field: [[Float]]) : Float {
    var sum : Float = 0.0;
    var count : Nat = 0;
    
    for (row in field.vals()) {
      for (val in row.vals()) {
        sum += val;
        count += 1;
      };
    };
    
    if (count == 0) { return 0.0 };
    sum / Float.fromInt(count)
  };

  func computeGlobalCoherence(phases: [[Float]]) : Float {
    var sumSin : Float = 0.0;
    var sumCos : Float = 0.0;
    var count : Nat = 0;
    
    for (row in phases.vals()) {
      for (phase in row.vals()) {
        sumSin += Float.sin(phase);
        sumCos += Float.cos(phase);
        count += 1;
      };
    };
    
    if (count == 0) { return 0.0 };
    
    let avgSin = sumSin / Float.fromInt(count);
    let avgCos = sumCos / Float.fromInt(count);
    
    Float.sqrt(avgSin * avgSin + avgCos * avgCos)
  };

  func computeGlobalPhase(phases: [[Float]]) : Float {
    var sumSin : Float = 0.0;
    var sumCos : Float = 0.0;
    var count : Nat = 0;
    
    for (row in phases.vals()) {
      for (phase in row.vals()) {
        sumSin += Float.sin(phase);
        sumCos += Float.cos(phase);
        count += 1;
      };
    };
    
    if (count == 0) { return 0.0 };
    
    Float.atan2(sumSin / Float.fromInt(count), sumCos / Float.fromInt(count))
  };

  // ==========================================================================
  // BINDING ZONE DETECTION
  // ==========================================================================
  // Find regions of high synchrony - these are "bound" perceptual units
  
  func detectBindingZones(
    field: [[Float]], 
    phases: [[Float]], 
    activations: [[Bool]],
    beatNum: Nat
  ) : [BindingZone] {
    // Simplified: find clusters of activated points
    var zones : [BindingZone] = [];
    var visited = Array.tabulateVar<[var Bool]>(field.size(), func(y) {
      Array.init<Bool>(field[0].size(), false)
    });
    
    var zoneId : Nat = 0;
    
    for (y in Array.keys(field)) {
      for (x in Array.keys(field[y])) {
        if (activations[y][x] and not visited[y][x]) {
          // Start flood fill to find connected region
          let (centerX, centerY, size) = floodFillZone(activations, visited, x, y);
          
          if (size > 3) {  // Minimum zone size
            let zone : BindingZone = {
              zoneId = zoneId;
              center = (centerX, centerY);
              radius = Float.sqrt(Float.fromInt(size));
              coherence = computeLocalCoherence(phases, centerX, centerY, 3);
              boundContent = "";
              formationBeat = beatNum;
            };
            zones := Array.append(zones, [zone]);
            zoneId += 1;
          };
        };
      };
    };
    
    zones
  };

  func floodFillZone(
    activations: [[Bool]], 
    visited: [var [var Bool]], 
    startX: Nat, 
    startY: Nat
  ) : (Nat, Nat, Nat) {
    var sumX : Nat = 0;
    var sumY : Nat = 0;
    var count : Nat = 0;
    
    var stack : [(Nat, Nat)] = [(startX, startY)];
    
    while (stack.size() > 0) {
      let (x, y) = stack[stack.size() - 1];
      stack := Array.tabulate<(Nat, Nat)>(stack.size() - 1, func(i) { stack[i] });
      
      if (y < activations.size() and x < activations[0].size() and 
          activations[y][x] and not visited[y][x]) {
        visited[y][x] := true;
        sumX += x;
        sumY += y;
        count += 1;
        
        // Add neighbors
        if (x > 0) { stack := Array.append(stack, [(x - 1, y)]) };
        if (x + 1 < activations[0].size()) { stack := Array.append(stack, [(x + 1, y)]) };
        if (y > 0) { stack := Array.append(stack, [(x, y - 1)]) };
        if (y + 1 < activations.size()) { stack := Array.append(stack, [(x, y + 1)]) };
      };
    };
    
    if (count == 0) { return (startX, startY, 0) };
    (sumX / count, sumY / count, count)
  };

  func computeLocalCoherence(phases: [[Float]], centerX: Nat, centerY: Nat, radius: Nat) : Float {
    var sumSin : Float = 0.0;
    var sumCos : Float = 0.0;
    var count : Nat = 0;
    
    let startY = if (centerY > radius) { centerY - radius } else { 0 };
    let endY = if (centerY + radius < phases.size()) { centerY + radius } else { phases.size() - 1 };
    
    for (y in Array.keys(Array.tabulate<Nat>(endY - startY + 1, func(i) { startY + i }))) {
      let actualY = startY + y;
      if (actualY < phases.size()) {
        let startX = if (centerX > radius) { centerX - radius } else { 0 };
        let endX = if (centerX + radius < phases[0].size()) { centerX + radius } else { phases[0].size() - 1 };
        
        for (x in Array.keys(Array.tabulate<Nat>(endX - startX + 1, func(i) { startX + i }))) {
          let actualX = startX + x;
          if (actualX < phases[actualY].size()) {
            sumSin += Float.sin(phases[actualY][actualX]);
            sumCos += Float.cos(phases[actualY][actualX]);
            count += 1;
          };
        };
      };
    };
    
    if (count == 0) { return 0.0 };
    
    let avgSin = sumSin / Float.fromInt(count);
    let avgCos = sumCos / Float.fromInt(count);
    
    Float.sqrt(avgSin * avgSin + avgCos * avgCos)
  };

  // ==========================================================================
  // ATTENTION CONTROL
  // ==========================================================================
  
  public func moveAttention(
    state: ConsciousnessField, 
    newCenter: (Float, Float)
  ) : ConsciousnessField {
    { state with attentionCenter = newCenter }
  };

  public func focusAttention(
    state: ConsciousnessField, 
    newRadius: Float, 
    newIntensity: Float
  ) : ConsciousnessField {
    { state with 
      attentionRadius = clamp(newRadius, 1.0, Float.fromInt(state.width) / 2.0);
      attentionIntensity = clamp(newIntensity, 0.0, 1.0);
    }
  };

  // Saccade-like attention jump
  public func saccadeAttention(
    state: ConsciousnessField,
    targetX: Float,
    targetY: Float,
    speed: Float
  ) : ConsciousnessField {
    let (cx, cy) = state.attentionCenter;
    let dx = (targetX - cx) * speed;
    let dy = (targetY - cy) * speed;
    { state with attentionCenter = (cx + dx, cy + dy) }
  };

  // ==========================================================================
  // CONSCIOUSNESS INTEGRATION (Global Workspace)
  // ==========================================================================
  
  public type WorkspaceContent = {
    contentId : Nat;
    source : Text;
    intensity : Float;
    position : (Nat, Nat);
    broadcastRadius : Float;
  };

  public func broadcastToWorkspace(
    state: ConsciousnessField,
    content: WorkspaceContent
  ) : ConsciousnessField {
    // Increase field intensity in broadcast radius
    var newField = Array.thaw<[Float]>(state.field);
    
    let cx = content.position.0;
    let cy = content.position.1;
    let r = Float.toInt(Float.ceil(content.broadcastRadius));
    let radius = Int.abs(r);
    
    for (dy in Array.keys(Array.tabulate<Nat>(2 * radius + 1, func(i) { i }))) {
      let y = cy + dy - radius;
      if (y >= 0 and y < state.height) {
        for (dx in Array.keys(Array.tabulate<Nat>(2 * radius + 1, func(i) { i }))) {
          let x = cx + dx - radius;
          if (x >= 0 and x < state.width) {
            let dist = Float.sqrt(Float.fromInt((x - cx) * (x - cx) + (y - cy) * (y - cy)));
            if (dist <= content.broadcastRadius) {
              let boost = content.intensity * (1.0 - dist / content.broadcastRadius);
              var row = Array.thaw<Float>(newField[y]);
              row[x] := clamp(row[x] + boost, 0.0, 1.0);
              newField[y] := Array.freeze(row);
            };
          };
        };
      };
    };
    
    { state with field = Array.freeze(newField) }
  };

  // ==========================================================================
  // QUALIA EMERGENCE
  // ==========================================================================
  // Subjective qualities emerge from specific field patterns
  
  public type Quale = {
    qualeType : QualeType;
    intensity : Float;
    position : (Float, Float);
    associatedZone : ?Nat;
  };

  public type QualeType = {
    #Visual;          // From visual cortex-like region
    #Auditory;        // From auditory cortex-like region
    #Emotional;       // From limbic-like region
    #Cognitive;       // From prefrontal-like region
    #Proprioceptive;  // Body sense
    #Novel;           // New, uncategorized
  };

  public func detectQualia(state: ConsciousnessField) : [Quale] {
    // Qualia emerge where binding zones are active
    Array.map<BindingZone, Quale>(state.bindingZones, func(zone) {
      // Determine quale type based on position (brain region mapping)
      let (cx, cy) = zone.center;
      let xRatio = Float.fromInt(cx) / Float.fromInt(state.width);
      let yRatio = Float.fromInt(cy) / Float.fromInt(state.height);
      
      let qualeType = if (yRatio < 0.3) { #Visual }
                      else if (yRatio < 0.5 and xRatio < 0.3) { #Auditory }
                      else if (yRatio < 0.5 and xRatio > 0.7) { #Auditory }
                      else if (yRatio > 0.7) { #Cognitive }
                      else if (xRatio > 0.4 and xRatio < 0.6) { #Emotional }
                      else { #Novel };
      
      {
        qualeType = qualeType;
        intensity = zone.coherence * state.globalIntensity;
        position = (Float.fromInt(cx), Float.fromInt(cy));
        associatedZone = ?zone.zoneId;
      }
    })
  };

  // ==========================================================================
  // CONSCIOUSNESS LEVEL COMPUTATION
  // ==========================================================================
  
  public func computeConsciousnessLevel(state: ConsciousnessField) : Float {
    // Consciousness = Integration × Intensity × Coherence
    let integration = Float.fromInt(state.bindingZones.size()) / 10.0;
    let intensity = state.globalIntensity;
    let coherence = state.globalCoherence;
    
    clamp(integration * intensity * coherence * PHI_MEDINA, 0.0, 1.0)
  };

  // ==========================================================================
  // UTILITY FUNCTIONS
  // ==========================================================================
  
  func clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  func wrapPhase(theta: Float) : Float {
    var t = theta;
    while (t < 0.0) { t += TWO_PI };
    while (t >= TWO_PI) { t -= TWO_PI };
    t
  };

  func appendFloatBounded(arr: [Float], item: Float, maxLen: Nat) : [Float] {
    if (arr.size() >= maxLen) {
      let tail = Array.tabulate<Float>(maxLen - 1, func(i) { arr[i + 1] });
      Array.append(tail, [item])
    } else {
      Array.append(arr, [item])
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
