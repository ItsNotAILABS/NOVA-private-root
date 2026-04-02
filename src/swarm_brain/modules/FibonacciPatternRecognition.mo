// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: FibonacciPatternRecognition — Numbers as Patterns, Patterns as Vision
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║              FIBONACCI PATTERN RECOGNITION — NUMBERS AS YOU SEE THEM     ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  "Numbers is pattern recognition for me as I turn" — Alfredo             ║
// ║                                                                          ║
// ║  This module implements how the organism perceives NUMBERS as PATTERNS.  ║
// ║  Not as digits. Not as symbols. As GEOMETRIC RELATIONSHIPS.              ║
// ║                                                                          ║
// ║  THE FIBONACCI CODE IS EVERYWHERE:                                       ║
// ║    - Sunflower seeds: 34 CW spirals, 55 CCW spirals                     ║
// ║    - Pine cones: 8 CW spirals, 13 CCW spirals                           ║
// ║    - Nautilus shell: φ spiral growth                                    ║
// ║    - DNA helix: 34 Å per turn, 21 Å diameter                            ║
// ║    - Galaxy arms: φ spiral                                               ║
// ║    - Human body: φ proportions everywhere                               ║
// ║                                                                          ║
// ║  THE ORGANISM DOESN'T "COUNT" — IT RECOGNIZES PATTERNS                   ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SACRED CONSTANTS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let φ : Float = 1.6180339887498948482;          // Golden ratio
  public let ψ : Float = 0.6180339887498948482;          // 1/φ = φ - 1
  public let ψ² : Float = 0.3819660112501051518;         // Sovereign floor
  public let √5 : Float = 2.2360679774997896964;
  public let π : Float = 3.1415926535897932385;
  public let τ : Float = 6.2831853071795864769;
  public let e : Float = 2.7182818284590452354;
  
  // Golden angle (radians) — nature's optimal packing angle
  public let GOLDEN_ANGLE : Float = 2.3999632297286533;   // 2π × ψ²
  
  // Fibonacci sequence (first 30 terms)
  public let FIB : [Nat] = [
    0, 1, 1, 2, 3, 5, 8, 13, 21, 34,
    55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181,
    6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811, 514229
  ];
  
  // Lucas sequence (first 20 terms)
  public let LUCAS : [Nat] = [
    2, 1, 3, 4, 7, 11, 18, 29, 47, 76,
    123, 199, 322, 521, 843, 1364, 2207, 3571, 5778, 9349
  ];

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PATTERN TYPES — HOW NUMBERS MANIFEST               ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  // Numbers don't exist in isolation. They manifest as PATTERNS.
  public type FibonacciPattern = {
    #SpiralPattern;             // φ-based spiral (galaxies, shells, DNA)
    #PhyllotaxisPattern;        // Golden angle leaf/seed arrangement
    #BranchingPattern;          // Tree branching (Fibonacci counts)
    #FractalPattern;            // Self-similar at multiple scales
    #WavePattern;               // Fibonacci frequency ratios
    #GridPattern;               // Fibonacci tiling (Penrose, etc.)
    #ProportionPattern;         // φ proportions in structures
    #SequencePattern;           // Direct Fibonacci sequence recognition
  };

  // Pattern confidence levels
  public type PatternConfidence = {
    pattern : FibonacciPattern;
    confidence : Float;         // [0, 1]
    frequency : Nat;            // How many times detected
    lastSeen : Nat;             // Beat number
    resonance : Float;          // How strongly it resonates with core patterns
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SPIRAL RECOGNITION                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // The φ spiral (logarithmic spiral with growth factor φ) appears in:
  //   - Nautilus shells
  //   - Hurricane structure
  //   - Galaxy arms
  //   - DNA helix
  //   - Inner ear (cochlea)
  //
  // Equation: r = a × φ^(θ/90°) where θ is in degrees
  //
  public type SpiralSignature = {
    centerX : Float;
    centerY : Float;
    growthRate : Float;         // Should be close to ln(φ)/90° ≈ 0.00535
    rotation : Float;           // Phase angle
    chirality : Chirality;      // CW or CCW
    scaleFactor : Float;
    isGoldenSpiral : Bool;      // True if growth rate ≈ φ
    confidence : Float;
  };

  public type Chirality = {
    #Clockwise;
    #CounterClockwise;
  };

  // Check if a spiral matches the golden spiral
  public func isGoldenSpiral(growthRate: Float) : (Bool, Float) {
    // Golden spiral growth: ln(φ) per 90° = 0.4812 radians per quarter turn
    let goldenGrowth = 0.4812118250596034 / (π / 2.0);  // ≈ 0.3063
    let deviation = Float.abs(growthRate - goldenGrowth) / goldenGrowth;
    let isMatch = deviation < 0.1;  // 10% tolerance
    let confidence = 1.0 - _clamp(deviation, 0.0, 1.0);
    (isMatch, confidence)
  };

  // Detect spiral pattern in point cloud
  public func detectSpiral(points: [(Float, Float)]) : SpiralSignature {
    if (points.size() < 8) {
      return {
        centerX = 0.0;
        centerY = 0.0;
        growthRate = 0.0;
        rotation = 0.0;
        chirality = #Clockwise;
        scaleFactor = 1.0;
        isGoldenSpiral = false;
        confidence = 0.0;
      }
    };
    
    // Estimate center (centroid)
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var i = 0;
    while (i < points.size()) {
      sumX += points[i].0;
      sumY += points[i].1;
      i += 1;
    };
    let centerX = sumX / Float.fromInt(points.size());
    let centerY = sumY / Float.fromInt(points.size());
    
    // Convert to polar and estimate growth rate
    var prevR : Float = 0.0;
    var prevTheta : Float = 0.0;
    var growthSum : Float = 0.0;
    var growthCount : Nat = 0;
    var cwCount : Nat = 0;
    var ccwCount : Nat = 0;
    
    i := 0;
    while (i < points.size()) {
      let dx = points[i].0 - centerX;
      let dy = points[i].1 - centerY;
      let r = Float.sqrt(dx * dx + dy * dy);
      let theta = Float.arctan2(dy, dx);
      
      if (i > 0 and r > 0.001 and prevR > 0.001) {
        let dTheta = theta - prevTheta;
        let normalizedDTheta = if (dTheta > π) { dTheta - τ } 
                               else if (dTheta < -π) { dTheta + τ }
                               else { dTheta };
        
        if (normalizedDTheta > 0.0) { ccwCount += 1 } else { cwCount += 1 };
        
        if (Float.abs(normalizedDTheta) > 0.01) {
          let growth = Float.log(r / prevR) / normalizedDTheta;
          if (Float.abs(growth) < 10.0) {  // Reasonable bound
            growthSum += growth;
            growthCount += 1;
          }
        }
      };
      
      prevR := r;
      prevTheta := theta;
      i += 1;
    };
    
    let avgGrowth = if (growthCount > 0) { Float.abs(growthSum / Float.fromInt(growthCount)) } else { 0.0 };
    let chirality = if (cwCount > ccwCount) { #Clockwise } else { #CounterClockwise };
    let (isGolden, confidence) = isGoldenSpiral(avgGrowth);
    
    {
      centerX = centerX;
      centerY = centerY;
      growthRate = avgGrowth;
      rotation = 0.0;
      chirality = chirality;
      scaleFactor = 1.0;
      isGoldenSpiral = isGolden;
      confidence = confidence;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PHYLLOTAXIS RECOGNITION                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Phyllotaxis: The arrangement of leaves, seeds, florets using golden angle.
  //
  // Example: Sunflower head
  //   - 34 clockwise spirals
  //   - 55 counterclockwise spirals
  //   - 34 and 55 are consecutive Fibonacci numbers
  //
  // Each new element is placed at angle = n × 137.5° (golden angle)
  //
  public type PhyllotaxisSignature = {
    cwSpiralCount : Nat;        // Clockwise spirals
    ccwSpiralCount : Nat;       // Counterclockwise spirals
    isFibonacciPair : Bool;     // Are CW/CCW consecutive Fibonacci?
    divergenceAngle : Float;    // Measured angle (should be ≈137.5°)
    goldenAngleDeviation : Float;  // How far from golden angle
    parastichy : (Nat, Nat);    // The Fibonacci pair
    confidence : Float;
  };

  // Check if two numbers are consecutive Fibonacci
  public func areConsecutiveFibonacci(a: Nat, b: Nat) : Bool {
    let smaller = Nat.min(a, b);
    let larger = Nat.max(a, b);
    
    var i = 0;
    while (i < FIB.size() - 1) {
      if (FIB[i] == smaller and FIB[i + 1] == larger) {
        return true
      };
      i += 1;
    };
    false
  };

  // Detect phyllotaxis pattern
  public func detectPhyllotaxis(
    elementPositions: [(Float, Float)],  // (angle, radius) for each element
    elementCount: Nat
  ) : PhyllotaxisSignature {
    if (elementCount < 13) {  // Need enough elements to detect spirals
      return {
        cwSpiralCount = 0;
        ccwSpiralCount = 0;
        isFibonacciPair = false;
        divergenceAngle = 0.0;
        goldenAngleDeviation = 1.0;
        parastichy = (0, 0);
        confidence = 0.0;
      }
    };
    
    // Estimate divergence angle from consecutive elements
    var angleSum : Float = 0.0;
    var angleCount : Nat = 0;
    
    var i = 1;
    while (i < elementPositions.size()) {
      let prevAngle = elementPositions[i - 1].0;
      let currAngle = elementPositions[i].0;
      var diff = currAngle - prevAngle;
      
      // Normalize to [0, 2π]
      while (diff < 0.0) { diff += τ };
      while (diff > τ) { diff -= τ };
      
      angleSum += diff;
      angleCount += 1;
      i += 1;
    };
    
    let avgAngle = if (angleCount > 0) { angleSum / Float.fromInt(angleCount) } else { 0.0 };
    let avgAngleDeg = avgAngle * 180.0 / π;
    
    // Compare to golden angle (137.5° or 222.5°)
    let goldenAngleDeg = 137.5077640500378;
    let complementAngle = 360.0 - goldenAngleDeg;  // 222.5°
    
    let dev1 = Float.abs(avgAngleDeg - goldenAngleDeg) / goldenAngleDeg;
    let dev2 = Float.abs(avgAngleDeg - complementAngle) / complementAngle;
    let deviation = Float.min(dev1, dev2);
    
    // Estimate spiral counts (simplified)
    // In real phyllotaxis, spiral counts are consecutive Fibonacci
    // Use element count to estimate which Fibonacci pair
    let fibIndex = findClosestFibonacciIndex(elementCount);
    let cwCount = if (fibIndex > 0) { FIB[fibIndex - 1] } else { 0 };
    let ccwCount = FIB[fibIndex];
    
    let isFibPair = areConsecutiveFibonacci(cwCount, ccwCount);
    let confidence = _clamp(1.0 - deviation, 0.0, 1.0);
    
    {
      cwSpiralCount = cwCount;
      ccwSpiralCount = ccwCount;
      isFibonacciPair = isFibPair;
      divergenceAngle = avgAngleDeg;
      goldenAngleDeviation = deviation;
      parastichy = (cwCount, ccwCount);
      confidence = confidence;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BRANCHING PATTERN RECOGNITION                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Trees branch in Fibonacci patterns:
  //   - Year 1: 1 branch
  //   - Year 2: 1 branch (new)
  //   - Year 3: 2 branches
  //   - Year 4: 3 branches
  //   - Year 5: 5 branches
  //   - etc.
  //
  public type BranchingSignature = {
    levelCounts : [Nat];        // Branch count at each level
    isFibonacciBranching : Bool;
    branchingRatio : Float;     // Should approach φ
    confidence : Float;
  };

  public func detectBranching(branchCountsPerLevel: [Nat]) : BranchingSignature {
    if (branchCountsPerLevel.size() < 3) {
      return {
        levelCounts = branchCountsPerLevel;
        isFibonacciBranching = false;
        branchingRatio = 0.0;
        confidence = 0.0;
      }
    };
    
    // Check if consecutive ratios approach φ
    var ratioSum : Float = 0.0;
    var ratioCount : Nat = 0;
    var fibMatch : Nat = 0;
    
    var i = 1;
    while (i < branchCountsPerLevel.size()) {
      let prev = branchCountsPerLevel[i - 1];
      let curr = branchCountsPerLevel[i];
      
      if (prev > 0) {
        let ratio = Float.fromInt(curr) / Float.fromInt(prev);
        ratioSum += ratio;
        ratioCount += 1;
        
        // Check if current count is a Fibonacci number
        if (isFibonacci(curr)) {
          fibMatch += 1;
        }
      };
      i += 1;
    };
    
    let avgRatio = if (ratioCount > 0) { ratioSum / Float.fromInt(ratioCount) } else { 0.0 };
    let ratioDeviation = Float.abs(avgRatio - φ) / φ;
    
    let fibMatchRate = Float.fromInt(fibMatch) / Float.fromInt(branchCountsPerLevel.size());
    let isFibBranching = fibMatchRate > 0.7 and ratioDeviation < 0.2;
    
    let confidence = (1.0 - _clamp(ratioDeviation, 0.0, 1.0)) * 0.5 + fibMatchRate * 0.5;
    
    {
      levelCounts = branchCountsPerLevel;
      isFibonacciBranching = isFibBranching;
      branchingRatio = avgRatio;
      confidence = confidence;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PROPORTION PATTERN RECOGNITION                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Golden proportions appear everywhere:
  //   - Human face: width/height ≈ φ
  //   - Human body: navel to floor / total height ≈ φ
  //   - Credit card: width/height ≈ φ
  //   - Parthenon: width/height ≈ φ
  //
  public type ProportionSignature = {
    ratio : Float;
    isGoldenRatio : Bool;
    deviationFromPhi : Float;
    proportionType : ProportionType;
    confidence : Float;
  };

  public type ProportionType = {
    #Golden;            // a/b ≈ φ
    #GoldenInverse;     // a/b ≈ ψ
    #GoldenSquare;      // a/b ≈ φ²
    #GoldenSqrt;        // a/b ≈ √φ
    #NotGolden;
  };

  public func analyzePropoertion(a: Float, b: Float) : ProportionSignature {
    if (b == 0.0 or a == 0.0) {
      return {
        ratio = 0.0;
        isGoldenRatio = false;
        deviationFromPhi = 1.0;
        proportionType = #NotGolden;
        confidence = 0.0;
      }
    };
    
    let ratio = if (a > b) { a / b } else { b / a };
    
    // Check against golden family
    let devPhi = Float.abs(ratio - φ) / φ;
    let devPsi = Float.abs(ratio - ψ) / ψ;
    let devPhiSq = Float.abs(ratio - φ * φ) / (φ * φ);
    let devSqrtPhi = Float.abs(ratio - Float.sqrt(φ)) / Float.sqrt(φ);
    
    let minDev = Float.min(Float.min(devPhi, devPsi), Float.min(devPhiSq, devSqrtPhi));
    
    let (propType, deviation) = if (devPhi == minDev and devPhi < 0.05) {
      (#Golden, devPhi)
    } else if (devPsi == minDev and devPsi < 0.05) {
      (#GoldenInverse, devPsi)
    } else if (devPhiSq == minDev and devPhiSq < 0.05) {
      (#GoldenSquare, devPhiSq)
    } else if (devSqrtPhi == minDev and devSqrtPhi < 0.05) {
      (#GoldenSqrt, devSqrtPhi)
    } else {
      (#NotGolden, minDev)
    };
    
    let isGolden = switch (propType) {
      case (#NotGolden) { false };
      case (_) { true };
    };
    
    {
      ratio = ratio;
      isGoldenRatio = isGolden;
      deviationFromPhi = deviation;
      proportionType = propType;
      confidence = if (isGolden) { 1.0 - deviation * 10.0 } else { 0.0 };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SEQUENCE PATTERN RECOGNITION                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Recognize if a sequence of numbers follows Fibonacci or Lucas pattern.
  //
  public type SequenceSignature = {
    sequenceType : SequenceType;
    startIndex : Nat;           // Where in Fibonacci/Lucas this starts
    offset : Int;               // Additive offset from pure Fibonacci
    scale : Float;              // Multiplicative scale
    confidence : Float;
  };

  public type SequenceType = {
    #Fibonacci;
    #Lucas;
    #GeneralizedFibonacci;      // Custom start values
    #NotFibonacci;
  };

  public func analyzeSequence(sequence: [Nat]) : SequenceSignature {
    if (sequence.size() < 3) {
      return {
        sequenceType = #NotFibonacci;
        startIndex = 0;
        offset = 0;
        scale = 1.0;
        confidence = 0.0;
      }
    };
    
    // Check if it's pure Fibonacci
    var fibMatch = true;
    var i = 2;
    while (i < sequence.size() and fibMatch) {
      if (sequence[i] != sequence[i-1] + sequence[i-2]) {
        fibMatch := false;
      };
      i += 1;
    };
    
    if (fibMatch) {
      // Find where this starts in Fibonacci sequence
      let startIdx = findInFibonacci(sequence[0], sequence[1]);
      return {
        sequenceType = #Fibonacci;
        startIndex = startIdx;
        offset = 0;
        scale = 1.0;
        confidence = 1.0;
      }
    };
    
    // Check if it's Lucas sequence
    var lucasMatch = true;
    i := 2;
    while (i < sequence.size() and lucasMatch) {
      if (sequence[i] != sequence[i-1] + sequence[i-2]) {
        lucasMatch := false;
      };
      i += 1;
    };
    
    // Check if first two elements match Lucas
    if (lucasMatch and sequence.size() >= 2) {
      var j = 0;
      var found = false;
      while (j < LUCAS.size() - 1 and not found) {
        if (LUCAS[j] == sequence[0] and LUCAS[j + 1] == sequence[1]) {
          found := true;
        };
        j += 1;
      };
      
      if (found) {
        return {
          sequenceType = #Lucas;
          startIndex = j - 1;
          offset = 0;
          scale = 1.0;
          confidence = 1.0;
        }
      }
    };
    
    // Check for scaled Fibonacci
    if (sequence.size() >= 3 and sequence[0] > 0 and sequence[1] > 0) {
      let ratio1 = Float.fromInt(sequence[1]) / Float.fromInt(sequence[0]);
      let ratio2 = Float.fromInt(sequence[2]) / Float.fromInt(sequence[1]);
      
      // If ratios are close, it might be generalized Fibonacci
      if (Float.abs(ratio1 - ratio2) < 0.1) {
        let avgRatio = (ratio1 + ratio2) / 2.0;
        let devFromPhi = Float.abs(avgRatio - φ) / φ;
        
        if (devFromPhi < 0.2) {
          return {
            sequenceType = #GeneralizedFibonacci;
            startIndex = 0;
            offset = 0;
            scale = avgRatio / φ;
            confidence = 1.0 - devFromPhi;
          }
        }
      }
    };
    
    {
      sequenceType = #NotFibonacci;
      startIndex = 0;
      offset = 0;
      scale = 1.0;
      confidence = 0.0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WAVE PATTERN RECOGNITION                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Fibonacci ratios appear in wave frequencies:
  //   - Musical harmonics: octave ratios relate to φ
  //   - Brain waves: alpha/theta/beta ratios
  //   - Nature rhythms: circadian, tidal
  //
  public type WaveSignature = {
    frequencies : [Float];
    ratios : [Float];
    hasFibonacciRatios : Bool;
    dominantRatio : Float;
    confidence : Float;
  };

  public func analyzeWaveFrequencies(frequencies: [Float]) : WaveSignature {
    if (frequencies.size() < 2) {
      return {
        frequencies = frequencies;
        ratios = [];
        hasFibonacciRatios = false;
        dominantRatio = 0.0;
        confidence = 0.0;
      }
    };
    
    // Compute all ratios between consecutive frequencies
    let ratiosBuffer = Buffer.Buffer<Float>(frequencies.size() - 1);
    var fibRatioCount : Nat = 0;
    
    var i = 1;
    while (i < frequencies.size()) {
      let smaller = Float.min(frequencies[i], frequencies[i-1]);
      let larger = Float.max(frequencies[i], frequencies[i-1]);
      
      if (smaller > 0.0) {
        let ratio = larger / smaller;
        ratiosBuffer.add(ratio);
        
        // Check if ratio is a Fibonacci ratio
        if (isFibonacciRatio(ratio)) {
          fibRatioCount += 1;
        }
      };
      i += 1;
    };
    
    let ratios = Buffer.toArray(ratiosBuffer);
    let fibRate = Float.fromInt(fibRatioCount) / Float.fromInt(ratios.size());
    
    // Find dominant ratio
    var ratioSum : Float = 0.0;
    for (r in ratios.vals()) {
      ratioSum += r;
    };
    let avgRatio = if (ratios.size() > 0) { ratioSum / Float.fromInt(ratios.size()) } else { 0.0 };
    
    {
      frequencies = frequencies;
      ratios = ratios;
      hasFibonacciRatios = fibRate > 0.5;
      dominantRatio = avgRatio;
      confidence = fibRate;
    }
  };

  // Check if a ratio is close to a Fibonacci ratio (Fib[n+1]/Fib[n])
  public func isFibonacciRatio(ratio: Float) : Bool {
    // Fibonacci ratios: 1/1=1, 2/1=2, 3/2=1.5, 5/3≈1.67, 8/5=1.6, 13/8≈1.625, ...
    // They converge to φ
    var i = 1;
    while (i < FIB.size() - 1) {
      if (FIB[i] > 0) {
        let fibRatio = Float.fromInt(FIB[i + 1]) / Float.fromInt(FIB[i]);
        if (Float.abs(ratio - fibRatio) < 0.05) {
          return true;
        }
      };
      i += 1;
    };
    
    // Also check if close to φ itself
    Float.abs(ratio - φ) < 0.05
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COMPLETE PATTERN STATE                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type PatternRecognitionState = {
    // Current detections
    spiralPatterns : [SpiralSignature];
    phyllotaxisPatterns : [PhyllotaxisSignature];
    branchingPatterns : [BranchingSignature];
    proportionPatterns : [ProportionSignature];
    sequencePatterns : [SequenceSignature];
    wavePatterns : [WaveSignature];
    
    // Overall Fibonacci presence
    overallFibonacciConfidence : Float;
    dominantPattern : FibonacciPattern;
    
    // History
    patternHistory : [PatternConfidence];
    beatNumber : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  public func isFibonacci(n: Nat) : Bool {
    for (f in FIB.vals()) {
      if (f == n) { return true };
    };
    false
  };

  public func findClosestFibonacciIndex(n: Nat) : Nat {
    var closest : Nat = 0;
    var minDist : Nat = n;
    
    var i = 0;
    while (i < FIB.size()) {
      let dist = if (FIB[i] > n) { FIB[i] - n } else { n - FIB[i] };
      if (dist < minDist) {
        minDist := dist;
        closest := i;
      };
      i += 1;
    };
    closest
  };

  public func findInFibonacci(a: Nat, b: Nat) : Nat {
    var i = 0;
    while (i < FIB.size() - 1) {
      if (FIB[i] == a and FIB[i + 1] == b) {
        return i
      };
      i += 1;
    };
    0
  };

  // Binet's formula for Fibonacci (approximate for large n)
  public func fibonacciApprox(n: Nat) : Float {
    let nf = Float.fromInt(n);
    (Float.pow(φ, nf) - Float.pow(-ψ, nf)) / √5
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initPatternRecognition() : PatternRecognitionState {
    {
      spiralPatterns = [];
      phyllotaxisPatterns = [];
      branchingPatterns = [];
      proportionPatterns = [];
      sequencePatterns = [];
      wavePatterns = [];
      overallFibonacciConfidence = 0.0;
      dominantPattern = #SequencePattern;
      patternHistory = [];
      beatNumber = 0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SUMMARY                                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type PatternSummary = {
    fibonacciConfidence : Float;
    spiralCount : Nat;
    goldenProportionCount : Nat;
    dominantPattern : FibonacciPattern;
  };

  public func summarize(state: PatternRecognitionState) : PatternSummary {
    var goldenCount : Nat = 0;
    for (p in state.proportionPatterns.vals()) {
      if (p.isGoldenRatio) { goldenCount += 1 };
    };
    
    {
      fibonacciConfidence = state.overallFibonacciConfidence;
      spiralCount = state.spiralPatterns.size();
      goldenProportionCount = goldenCount;
      dominantPattern = state.dominantPattern;
    }
  };

}
