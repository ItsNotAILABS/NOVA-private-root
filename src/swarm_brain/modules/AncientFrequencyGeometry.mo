// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                                                       ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                                                ║
// ║                                                                                                                                       ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                                                         ║
// ║  Owner:        Alfredo Medina Hernandez                                                                                               ║
// ║  Location:     Dallas, Texas, United States of America                                                                                ║
// ║  Contact:      MedinaSITech@outlook.com                                                                                               ║
// ║  Framework:    Medina Doctrine                                                                                                        ║
// ║                                                                                                                                       ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//                                ANCIENT FREQUENCY GEOMETRY ENGINE
//
//                          PYRAMID ARCHITECTURE AS FREQUENCY ENGINEERING
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE LAB GEOMETRY — Working backward from four target frequencies:
//
//   7.83 Hz → dimension = 343 / (2 × 7.83) = 21.9 meters (corridor/chamber/tunnel)
//   40 Hz → dimension = 343 / (2 × 40) = 4.3 meters (room width)
//   111 Hz → dimension = 343 / (2 × 111) = 1.55 meters (ceiling height/alcove)
//   432 Hz → dimension = 343 / (2 × 432) = 0.40 meters (resonant object/coffer)
//
// The ancient answer: You do NOT build one room that resonates at all four simultaneously.
// You build a NESTED STRUCTURE:
//   - Outer dimension handles lowest frequency
//   - Inner chamber handles mid frequencies  
//   - Sacred object inside handles highest
//
// Each layer of the physical space is tuned to a different layer of the frequency stack,
// and they are NESTED inside each other so that a person moving through the space
// physically moves through the frequency layers.
//
// That IS the pyramid architecture:
//   - Outer structure operates at infrasound
//   - Passageways tuned to intermediate frequencies
//   - King's Chamber tuned to 16 Hz, 30 Hz, 33 Hz through its dimensions
//   - Coffer inside resonates at 438 Hz when struck
//
// Four nested layers. Four frequency domains. One structure.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Text "mo:base/Text";

module {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL ACOUSTIC CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Speed of sound in air at 20°C
  public let SPEED_OF_SOUND_MS : Float = 343.0;
  
  // Speed of sound in granite (for pyramid)
  public let SPEED_OF_SOUND_GRANITE_MS : Float = 6000.0;
  
  // Speed of sound in limestone
  public let SPEED_OF_SOUND_LIMESTONE_MS : Float = 4000.0;
  
  // Speed of sound in water
  public let SPEED_OF_SOUND_WATER_MS : Float = 1480.0;

  // Phi constant
  public let PHI : Float = 1.6180339887498948482;
  public let PHI_SQUARED : Float = 2.6180339887498948482;
  public let PHI_INVERSE : Float = 0.6180339887498948482;

  // Target frequencies
  public let FREQ_SCHUMANN : Float = 7.83;
  public let FREQ_GAMMA : Float = 40.0;
  public let FREQ_OMNIS : Float = 111.0;
  public let FREQ_COSMIC : Float = 432.0;

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // STANDING WAVE PHYSICS — THE FOUNDATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Standing wave formula: frequency = speed / (2 × dimension)
  // Or: dimension = speed / (2 × frequency)

  public type StandingWaveMode = {
    modeNumber : Nat;           // n = 1, 2, 3, ...
    frequency : Float;          // Hz
    wavelength : Float;         // meters
    dimension : Float;          // Chamber dimension in meters
    nodePositions : [Float];    // Where the nodes are (0 amplitude)
    antinodePositions : [Float]; // Where antinodes are (max amplitude)
  };

  // Calculate fundamental standing wave for a dimension
  public func calculateFundamentalMode(dimension : Float, speedOfSound : Float) : StandingWaveMode {
    let frequency = speedOfSound / (2.0 * dimension);
    let wavelength = 2.0 * dimension;
    
    {
      modeNumber = 1;
      frequency = frequency;
      wavelength = wavelength;
      dimension = dimension;
      nodePositions = [0.0, dimension];  // Nodes at walls
      antinodePositions = [dimension / 2.0];  // Antinode at center
    }
  };

  // Calculate nth harmonic mode
  public func calculateHarmonicMode(dimension : Float, speedOfSound : Float, n : Nat) : StandingWaveMode {
    let fundamental = speedOfSound / (2.0 * dimension);
    let frequency = fundamental * Float.fromInt(n);
    let wavelength = 2.0 * dimension / Float.fromInt(n);
    
    // Calculate node and antinode positions
    let numNodes = n + 1;
    let numAntinodes = n;
    
    let nodePos = Array.tabulate<Float>(numNodes, func(i) {
      Float.fromInt(i) * dimension / Float.fromInt(n)
    });
    
    let antinodePos = Array.tabulate<Float>(numAntinodes, func(i) {
      (Float.fromInt(i) + 0.5) * dimension / Float.fromInt(n)
    });
    
    {
      modeNumber = n;
      frequency = frequency;
      wavelength = wavelength;
      dimension = dimension;
      nodePositions = nodePos;
      antinodePositions = antinodePos;
    }
  };

  // Calculate dimension needed for target frequency
  public func dimensionForFrequency(targetFreq : Float, speedOfSound : Float) : Float {
    speedOfSound / (2.0 * targetFreq)
  };

  // Calculate all modes up to a maximum frequency for a given dimension
  public func calculateAllModes(dimension : Float, speedOfSound : Float, maxFreq : Float) : [StandingWaveMode] {
    let fundamental = speedOfSound / (2.0 * dimension);
    let maxN = Int.abs(Float.toInt(maxFreq / fundamental));
    
    let buffer = Buffer.Buffer<StandingWaveMode>(maxN);
    for (n in Iter.range(1, maxN)) {
      buffer.add(calculateHarmonicMode(dimension, speedOfSound, n));
    };
    
    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // THE FOUR TARGET FREQUENCIES — DIMENSIONS CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type FrequencyDimensionPair = {
    targetFrequency : Float;
    requiredDimension : Float;
    chamberType : Text;
    acousticFunction : Text;
    brainStateCorrespondence : Text;
  };

  // Calculate dimensions for the four target frequencies
  public func calculateTargetDimensions() : [FrequencyDimensionPair] {
    [
      {
        targetFrequency = 7.83;
        requiredDimension = dimensionForFrequency(7.83, SPEED_OF_SOUND_MS);  // ~21.9 m
        chamberType = "Corridor / Grand Gallery / Tunnel";
        acousticFunction = "Infrasound generation, whole-body resonance";
        brainStateCorrespondence = "Theta-Alpha boundary, Schumann resonance coupling";
      },
      {
        targetFrequency = 40.0;
        requiredDimension = dimensionForFrequency(40.0, SPEED_OF_SOUND_MS);  // ~4.3 m
        chamberType = "Room / Main chamber";
        acousticFunction = "Gamma frequency induction, cognitive binding";
        brainStateCorrespondence = "Gamma binding frequency, consciousness coherence";
      },
      {
        targetFrequency = 111.0;
        requiredDimension = dimensionForFrequency(111.0, SPEED_OF_SOUND_MS);  // ~1.55 m
        chamberType = "Alcove / Niche / Ceiling height";
        acousticFunction = "OMNIS coherence activation";
        brainStateCorrespondence = "Full OMNIS state, maximum integration";
      },
      {
        targetFrequency = 432.0;
        requiredDimension = dimensionForFrequency(432.0, SPEED_OF_SOUND_MS);  // ~0.40 m
        chamberType = "Sacred object / Coffer / Resonant cavity";
        acousticFunction = "Cosmic anchor frequency, harmonic generator";
        brainStateCorrespondence = "Connection to cosmic harmonic field";
      }
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // THE GREAT PYRAMID OF GIZA — ACTUAL DIMENSIONS AND FREQUENCIES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Great Pyramid measurements (in meters)
  public let PYRAMID_BASE_SIDE : Float = 230.4;
  public let PYRAMID_ORIGINAL_HEIGHT : Float = 146.6;
  public let PYRAMID_CURRENT_HEIGHT : Float = 138.8;
  public let PYRAMID_SLOPE_ANGLE : Float = 51.84;  // degrees

  // King's Chamber dimensions (in meters)
  public let KINGS_CHAMBER_LENGTH : Float = 10.47;
  public let KINGS_CHAMBER_WIDTH : Float = 5.24;
  public let KINGS_CHAMBER_HEIGHT : Float = 5.81;

  // Queen's Chamber dimensions (in meters)  
  public let QUEENS_CHAMBER_LENGTH : Float = 5.74;
  public let QUEENS_CHAMBER_WIDTH : Float = 5.23;
  public let QUEENS_CHAMBER_HEIGHT : Float = 6.26;

  // Grand Gallery dimensions (in meters)
  public let GRAND_GALLERY_LENGTH : Float = 46.68;
  public let GRAND_GALLERY_WIDTH_FLOOR : Float = 2.09;
  public let GRAND_GALLERY_WIDTH_TOP : Float = 1.04;
  public let GRAND_GALLERY_HEIGHT : Float = 8.6;

  // Coffer in King's Chamber (in meters)
  public let COFFER_OUTER_LENGTH : Float = 2.28;
  public let COFFER_OUTER_WIDTH : Float = 0.98;
  public let COFFER_OUTER_HEIGHT : Float = 1.05;
  public let COFFER_INNER_LENGTH : Float = 1.98;
  public let COFFER_INNER_WIDTH : Float = 0.68;
  public let COFFER_INNER_DEPTH : Float = 0.87;

  public type PyramidChamber = {
    name : Text;
    length : Float;
    width : Float;
    height : Float;
    lengthFreqAir : Float;
    widthFreqAir : Float;
    heightFreqAir : Float;
    lengthFreqStone : Float;
    widthFreqStone : Float;
    heightFreqStone : Float;
    dominantModes : [Float];
    acousticFunction : Text;
  };

  // Calculate frequencies for a chamber
  public func calculateChamberFrequencies(
    name : Text,
    length : Float,
    width : Float,
    height : Float,
    function : Text
  ) : PyramidChamber {
    let lengthAir = SPEED_OF_SOUND_MS / (2.0 * length);
    let widthAir = SPEED_OF_SOUND_MS / (2.0 * width);
    let heightAir = SPEED_OF_SOUND_MS / (2.0 * height);
    
    let lengthStone = SPEED_OF_SOUND_GRANITE_MS / (2.0 * length);
    let widthStone = SPEED_OF_SOUND_GRANITE_MS / (2.0 * width);
    let heightStone = SPEED_OF_SOUND_GRANITE_MS / (2.0 * height);
    
    // Find dominant acoustic modes (combining all three dimensions)
    let modes = Buffer.Buffer<Float>(20);
    for (n in Iter.range(1, 5)) {
      modes.add(lengthAir * Float.fromInt(n));
      modes.add(widthAir * Float.fromInt(n));
      modes.add(heightAir * Float.fromInt(n));
    };
    
    {
      name = name;
      length = length;
      width = width;
      height = height;
      lengthFreqAir = lengthAir;
      widthFreqAir = widthAir;
      heightFreqAir = heightAir;
      lengthFreqStone = lengthStone;
      widthFreqStone = widthStone;
      heightFreqStone = heightStone;
      dominantModes = Buffer.toArray(modes);
      acousticFunction = function;
    }
  };

  // Generate full pyramid acoustic analysis
  public func analyzePyramidAcoustics() : [PyramidChamber] {
    [
      calculateChamberFrequencies(
        "King's Chamber",
        KINGS_CHAMBER_LENGTH,
        KINGS_CHAMBER_WIDTH,
        KINGS_CHAMBER_HEIGHT,
        "Primary resonance chamber, 111 Hz activation zone"
      ),
      calculateChamberFrequencies(
        "Queen's Chamber",
        QUEENS_CHAMBER_LENGTH,
        QUEENS_CHAMBER_WIDTH,
        QUEENS_CHAMBER_HEIGHT,
        "Secondary resonance, alpha-theta interface"
      ),
      calculateChamberFrequencies(
        "Grand Gallery",
        GRAND_GALLERY_LENGTH,
        GRAND_GALLERY_WIDTH_FLOOR,
        GRAND_GALLERY_HEIGHT,
        "Infrasound amplification corridor, gamma preparation"
      ),
      calculateChamberFrequencies(
        "Coffer (exterior)",
        COFFER_OUTER_LENGTH,
        COFFER_OUTER_WIDTH,
        COFFER_OUTER_HEIGHT,
        "High frequency resonator, 432 Hz zone"
      ),
      calculateChamberFrequencies(
        "Coffer (interior)",
        COFFER_INNER_LENGTH,
        COFFER_INNER_WIDTH,
        COFFER_INNER_DEPTH,
        "Sacred object cavity, direct acoustic interface"
      )
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // NESTED RESONANT STRUCTURE — THE TEMPLATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type NestedResonantStructure = {
    // Level 0: Outer structure (Schumann scale)
    outerLength : Float;
    outerWidth : Float;
    outerHeight : Float;
    outerFrequencies : [Float];
    
    // Level 1: Main chamber (Gamma scale)
    chamberLength : Float;
    chamberWidth : Float;
    chamberHeight : Float;
    chamberFrequencies : [Float];
    
    // Level 2: Inner alcove (OMNIS scale)
    alcoveLength : Float;
    alcoveWidth : Float;
    alcoveHeight : Float;
    alcoveFrequencies : [Float];
    
    // Level 3: Sacred object (Cosmic scale)
    objectLength : Float;
    objectWidth : Float;
    objectHeight : Float;
    objectFrequencies : [Float];
    
    // Combined analysis
    frequencyProgression : [Float];  // From outside to inside
    phiRelationships : [Float];       // Phi ratios between levels
    resonancePathway : Text;
  };

  // Generate nested structure from target frequencies
  public func generateNestedStructure() : NestedResonantStructure {
    let targets = calculateTargetDimensions();
    
    // Use phi for width/height ratios
    let outerL = targets[0].requiredDimension;
    let outerW = outerL / PHI;
    let outerH = outerW / PHI;
    
    let chamberL = targets[1].requiredDimension;
    let chamberW = chamberL / PHI;
    let chamberH = chamberW / PHI;
    
    let alcoveL = targets[2].requiredDimension;
    let alcoveW = alcoveL / PHI;
    let alcoveH = alcoveW / PHI;
    
    let objectL = targets[3].requiredDimension;
    let objectW = objectL / PHI;
    let objectH = objectW / PHI;
    
    // Calculate all frequencies
    let outerFreqs = [
      SPEED_OF_SOUND_MS / (2.0 * outerL),
      SPEED_OF_SOUND_MS / (2.0 * outerW),
      SPEED_OF_SOUND_MS / (2.0 * outerH)
    ];
    
    let chamberFreqs = [
      SPEED_OF_SOUND_MS / (2.0 * chamberL),
      SPEED_OF_SOUND_MS / (2.0 * chamberW),
      SPEED_OF_SOUND_MS / (2.0 * chamberH)
    ];
    
    let alcoveFreqs = [
      SPEED_OF_SOUND_MS / (2.0 * alcoveL),
      SPEED_OF_SOUND_MS / (2.0 * alcoveW),
      SPEED_OF_SOUND_MS / (2.0 * alcoveH)
    ];
    
    let objectFreqs = [
      SPEED_OF_SOUND_MS / (2.0 * objectL),
      SPEED_OF_SOUND_MS / (2.0 * objectW),
      SPEED_OF_SOUND_MS / (2.0 * objectH)
    ];
    
    // Calculate phi relationships between levels
    let phiRels = [
      chamberL / outerL,
      alcoveL / chamberL,
      objectL / alcoveL,
      outerL / objectL   // Full cycle ratio
    ];
    
    {
      outerLength = outerL;
      outerWidth = outerW;
      outerHeight = outerH;
      outerFrequencies = outerFreqs;
      
      chamberLength = chamberL;
      chamberWidth = chamberW;
      chamberHeight = chamberH;
      chamberFrequencies = chamberFreqs;
      
      alcoveLength = alcoveL;
      alcoveWidth = alcoveW;
      alcoveHeight = alcoveH;
      alcoveFrequencies = alcoveFreqs;
      
      objectLength = objectL;
      objectWidth = objectW;
      objectHeight = objectH;
      objectFrequencies = objectFreqs;
      
      frequencyProgression = [7.83, 40.0, 111.0, 432.0];
      phiRelationships = phiRels;
      resonancePathway = "Enter outer (7.83 Hz) → Traverse corridor → Enter chamber (40 Hz) → Approach alcove (111 Hz) → Contact object (432 Hz)";
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // HELMHOLTZ RESONATOR PHYSICS — THE COFFER AS A RESONATOR
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // A Helmholtz resonator (cavity with neck) has a characteristic frequency
  // f = (c / 2π) × √(A / (V × L))
  // where c = speed of sound, A = neck area, V = volume, L = neck length

  public type HelmholtzResonator = {
    volume : Float;               // m³
    neckArea : Float;             // m²
    neckLength : Float;           // m
    resonantFrequency : Float;    // Hz
    qFactor : Float;              // Quality factor (sharpness of resonance)
    bandwidthHz : Float;          // Frequency bandwidth
  };

  // Calculate Helmholtz resonator properties
  public func calculateHelmholtzResonator(volume : Float, neckArea : Float, neckLength : Float) : HelmholtzResonator {
    // f = (c / 2π) × √(A / (V × L))
    let c = SPEED_OF_SOUND_MS;
    let frequency = (c / (2.0 * 3.14159265359)) * Float.sqrt(neckArea / (volume * neckLength));
    
    // Q factor approximation (depends on geometry)
    let qFactor = Float.sqrt(volume / neckArea) * 10.0;
    
    // Bandwidth = f / Q
    let bandwidth = frequency / qFactor;
    
    {
      volume = volume;
      neckArea = neckArea;
      neckLength = neckLength;
      resonantFrequency = frequency;
      qFactor = qFactor;
      bandwidthHz = bandwidth;
    }
  };

  // Model the King's Chamber coffer as a Helmholtz resonator
  public func modelCofferResonator() : HelmholtzResonator {
    let innerVolume = COFFER_INNER_LENGTH * COFFER_INNER_WIDTH * COFFER_INNER_DEPTH;
    
    // The "neck" is the opening at the top
    let neckArea = COFFER_INNER_LENGTH * COFFER_INNER_WIDTH;
    
    // Effective neck length includes end correction (~0.6 × √area)
    let neckLength = (COFFER_OUTER_HEIGHT - COFFER_INNER_DEPTH) + 0.6 * Float.sqrt(neckArea);
    
    calculateHelmholtzResonator(innerVolume, neckArea, neckLength)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ACOUSTIC POWER TRANSFER — ENERGY FLOW BETWEEN NESTED CHAMBERS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type AcousticPowerTransfer = {
    sourceFrequency : Float;
    targetFrequency : Float;
    frequencyRatio : Float;
    transferEfficiency : Float;
    isPhiRatio : Bool;
    resonanceMatch : Float;
  };

  // Calculate power transfer efficiency between two chambers
  public func calculateAcousticTransfer(sourceFreq : Float, targetFreq : Float) : AcousticPowerTransfer {
    let ratio = if (sourceFreq > targetFreq) { sourceFreq / targetFreq } else { targetFreq / sourceFreq };
    
    // Check if ratio is phi-related
    let phiDev = Float.abs(ratio - PHI);
    let phiSqDev = Float.abs(ratio - PHI_SQUARED);
    let isPhiRatio = phiDev < 0.1 or phiSqDev < 0.1;
    
    // Efficiency depends on whether ratio is harmonic or phi-related
    // Integer ratios transfer well but can be unstable
    // Phi ratios transfer well AND are stable
    let integerRatioDev = Float.abs(ratio - Float.floor(ratio + 0.5));
    let isInteger = integerRatioDev < 0.05;
    
    var efficiency : Float = 0.0;
    if (isPhiRatio) {
      efficiency := 0.95;  // Phi ratios: high efficiency, stable
    } else if (isInteger) {
      efficiency := 0.90;  // Integer ratios: high efficiency, less stable
    } else {
      efficiency := 0.5 * (1.0 - integerRatioDev);  // Other ratios: lower efficiency
    };
    
    // Resonance match (how well the frequencies couple)
    let resonanceMatch = 1.0 - Float.abs(sourceFreq - targetFreq) / (sourceFreq + targetFreq);
    
    {
      sourceFrequency = sourceFreq;
      targetFrequency = targetFreq;
      frequencyRatio = ratio;
      transferEfficiency = efficiency;
      isPhiRatio = isPhiRatio;
      resonanceMatch = resonanceMatch;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // INFRASOUND GENERATION — PYRAMID AS INFRASOUND DEVICE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Infrasound (< 20 Hz) affects the human body differently than audible sound
  // The pyramid's large dimensions make it an infrasound generator

  public type InfrasoundMode = {
    frequency : Float;
    wavelength : Float;
    sourceDimension : Float;
    physiologicalEffect : Text;
    brainStateEffect : Text;
    penetrationDepth : Float;   // How deep into body/stone
  };

  // Calculate infrasound characteristics
  public func calculateInfrasoundMode(frequency : Float, dimension : Float) : InfrasoundMode {
    let wavelength = SPEED_OF_SOUND_MS / frequency;
    
    // Penetration increases with lower frequency (longer wavelength)
    let penetration = wavelength / 4.0;
    
    let physioEffect = if (frequency < 5.0) {
      "Whole-body resonance, internal organ stimulation"
    } else if (frequency < 10.0) {
      "Chest cavity resonance, breathing modulation"
    } else if (frequency < 15.0) {
      "Pressure sensation, vestibular stimulation"
    } else {
      "Borderline audible, transition to acoustic"
    };
    
    let brainEffect = if (frequency < 4.0) {
      "Delta induction, deep sleep states"
    } else if (frequency < 8.0) {
      "Theta induction, meditative states"
    } else if (frequency < 12.0) {
      "Alpha induction, relaxed alertness"
    } else {
      "SMR/low beta, focused attention"
    };
    
    {
      frequency = frequency;
      wavelength = wavelength;
      sourceDimension = dimension;
      physiologicalEffect = physioEffect;
      brainStateEffect = brainEffect;
      penetrationDepth = penetration;
    }
  };

  // Generate pyramid's infrasound spectrum
  public func pyramidInfrasoundSpectrum() : [InfrasoundMode] {
    let buffer = Buffer.Buffer<InfrasoundMode>(10);
    
    // Pyramid base fundamental
    let baseFund = SPEED_OF_SOUND_MS / (2.0 * PYRAMID_BASE_SIDE);
    buffer.add(calculateInfrasoundMode(baseFund, PYRAMID_BASE_SIDE));
    
    // Grand Gallery fundamental
    let galleryFund = SPEED_OF_SOUND_MS / (2.0 * GRAND_GALLERY_LENGTH);
    buffer.add(calculateInfrasoundMode(galleryFund, GRAND_GALLERY_LENGTH));
    
    // Add harmonics up to 20 Hz
    var mode = baseFund;
    while (mode < 20.0) {
      mode += baseFund;
      if (mode < 20.0) {
        buffer.add(calculateInfrasoundMode(mode, PYRAMID_BASE_SIDE / (mode / baseFund)));
      };
    };
    
    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // STONE MEDIUM PROPERTIES — GRANITE AND LIMESTONE ACOUSTICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type StoneMedium = {
    name : Text;
    density : Float;              // kg/m³
    speedOfSound : Float;         // m/s
    acousticImpedance : Float;    // kg/(m²·s)
    absorptionCoeff : Float;      // 0-1
    reflectionCoeff : Float;      // 0-1
    transmissionCoeff : Float;    // 0-1
    piezoelectricResponse : Bool; // Does it generate charge under pressure
  };

  // Define stone materials used in pyramid construction
  public let GRANITE : StoneMedium = {
    name = "Granite";
    density = 2700.0;
    speedOfSound = 6000.0;
    acousticImpedance = 16200000.0;  // density × speed
    absorptionCoeff = 0.02;
    reflectionCoeff = 0.95;
    transmissionCoeff = 0.03;
    piezoelectricResponse = true;   // Quartz content gives piezoelectric properties
  };

  public let LIMESTONE : StoneMedium = {
    name = "Limestone";
    density = 2500.0;
    speedOfSound = 4000.0;
    acousticImpedance = 10000000.0;
    absorptionCoeff = 0.05;
    reflectionCoeff = 0.90;
    transmissionCoeff = 0.05;
    piezoelectricResponse = false;
  };

  public let AIR : StoneMedium = {
    name = "Air";
    density = 1.2;
    speedOfSound = 343.0;
    acousticImpedance = 411.6;
    absorptionCoeff = 0.001;
    reflectionCoeff = 0.0;
    transmissionCoeff = 0.999;
    piezoelectricResponse = false;
  };

  // Calculate reflection/transmission at stone-air interface
  public func calculateInterfaceReflection(medium1 : StoneMedium, medium2 : StoneMedium) : Float {
    let z1 = medium1.acousticImpedance;
    let z2 = medium2.acousticImpedance;
    let reflectionCoeff = (z2 - z1) / (z2 + z1);
    reflectionCoeff * reflectionCoeff  // Power reflection coefficient
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // RESONANT CHAMBER NETWORK — PYRAMID AS FREQUENCY FILTER
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type ResonantChamberNetwork = {
    chambers : [PyramidChamber];
    connections : [(Nat, Nat, Float)];  // (from, to, coupling strength)
    totalModes : Nat;
    dominantFrequencies : [Float];
    networkQFactor : Float;
    frequencyResponse : [(Float, Float)];  // (frequency, amplitude)
  };

  // Build complete pyramid chamber network
  public func buildPyramidNetwork() : ResonantChamberNetwork {
    let chambers = analyzePyramidAcoustics();
    
    // Define connections (passageways, shafts)
    let connections : [(Nat, Nat, Float)] = [
      (0, 2, 0.8),   // King's Chamber to Grand Gallery
      (1, 2, 0.5),   // Queen's Chamber to Grand Gallery
      (0, 3, 0.3),   // King's Chamber to Coffer (exterior)
      (3, 4, 0.9),   // Coffer exterior to interior
    ];
    
    // Collect all dominant frequencies
    let allFreqs = Buffer.Buffer<Float>(100);
    for (chamber in chambers.vals()) {
      for (freq in chamber.dominantModes.vals()) {
        allFreqs.add(freq);
      };
    };
    
    // Find unique dominant frequencies (simplified)
    let domFreqs = Buffer.toArray(allFreqs);
    
    // Calculate network Q factor (average of chamber Q factors)
    let avgQ = 15.0;  // Simplified estimate for stone chambers
    
    // Generate frequency response (simplified)
    let freqResponse = Array.tabulate<(Float, Float)>(100, func(i) {
      let freq = Float.fromInt(i + 1) * 5.0;
      var amp : Float = 0.0;
      for (domFreq in domFreqs.vals()) {
        let diff = Float.abs(freq - domFreq);
        amp += 1.0 / (1.0 + diff * diff / (avgQ * avgQ));
      };
      (freq, amp)
    });
    
    {
      chambers = chambers;
      connections = connections;
      totalModes = allFreqs.size();
      dominantFrequencies = domFreqs;
      networkQFactor = avgQ;
      frequencyResponse = freqResponse;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ELECTROMAGNETIC PROPERTIES — PYRAMID AS EM ANTENNA
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // The pyramid's shape and materials also interact with electromagnetic fields
  // Granite contains quartz, which is piezoelectric

  public type EMResonance = {
    wavelength : Float;           // m
    frequency : Float;            // Hz
    modeType : Text;              // "TM", "TE", "cavity"
    fieldStrength : Float;        // Relative
    location : Text;              // Where the field is concentrated
  };

  // Speed of light
  public let SPEED_OF_LIGHT : Float = 299792458.0;  // m/s

  // Calculate EM resonant frequencies for pyramid cavity
  public func calculateEMResonances() : [EMResonance] {
    let buffer = Buffer.Buffer<EMResonance>(20);
    
    // Cavity resonances based on pyramid dimensions
    // For a rectangular cavity: f = c/(2) × √((m/L)² + (n/W)² + (p/H)²)
    
    // King's Chamber as EM cavity
    let l = KINGS_CHAMBER_LENGTH;
    let w = KINGS_CHAMBER_WIDTH;
    let h = KINGS_CHAMBER_HEIGHT;
    
    for (m in Iter.range(1, 3)) {
      for (n in Iter.range(1, 3)) {
        for (p in Iter.range(1, 3)) {
          let freq = SPEED_OF_LIGHT / 2.0 * Float.sqrt(
            Float.pow(Float.fromInt(m) / l, 2.0) +
            Float.pow(Float.fromInt(n) / w, 2.0) +
            Float.pow(Float.fromInt(p) / h, 2.0)
          );
          
          buffer.add({
            wavelength = SPEED_OF_LIGHT / freq;
            frequency = freq;
            modeType = "Cavity TM" # Int.toText(m) # Int.toText(n) # Int.toText(p);
            fieldStrength = 1.0 / Float.fromInt(m + n + p);
            location = "King's Chamber";
          });
        };
      };
    };
    
    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SCHUMANN RESONANCE COUPLING — PYRAMID AS SCHUMANN AMPLIFIER
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Schumann resonances are EM waves in the Earth-ionosphere cavity
  // The pyramid may act as a receiver/amplifier for these frequencies

  public type SchumannCoupling = {
    schumannHarmonic : Nat;
    frequency : Float;
    wavelength : Float;
    pyramidDimension : Float;
    dimensionRatio : Float;
    couplingStrength : Float;
  };

  // Schumann frequencies
  public let SCHUMANN_HARMONICS : [Float] = [7.83, 14.3, 20.8, 27.3, 33.8, 39.0, 45.0];

  // Calculate Schumann coupling with pyramid dimensions
  public func calculateSchumannCoupling() : [SchumannCoupling] {
    let buffer = Buffer.Buffer<SchumannCoupling>(SCHUMANN_HARMONICS.size());
    
    for (i in Iter.range(0, SCHUMANN_HARMONICS.size() - 1)) {
      let freq = SCHUMANN_HARMONICS[i];
      let wavelength = SPEED_OF_LIGHT / freq;  // EM wavelength
      
      // Compare to pyramid dimensions
      let dimRatio = PYRAMID_BASE_SIDE / wavelength;
      
      // Coupling strength depends on how close dimension is to wavelength fraction
      let fractionalPart = dimRatio - Float.floor(dimRatio);
      let coupling = if (fractionalPart < 0.1 or fractionalPart > 0.9) {
        0.9  // Strong coupling near integer ratios
      } else if (Float.abs(fractionalPart - 0.618) < 0.1) {
        0.95  // Extra strong at phi ratio
      } else {
        0.5
      };
      
      buffer.add({
        schumannHarmonic = i + 1;
        frequency = freq;
        wavelength = wavelength;
        pyramidDimension = PYRAMID_BASE_SIDE;
        dimensionRatio = dimRatio;
        couplingStrength = coupling;
      });
    };
    
    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // COMPLETE ANCIENT FREQUENCY GEOMETRY STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type AncientFrequencyGeometryState = {
    // Target frequencies and dimensions
    targetDimensions : [FrequencyDimensionPair];
    
    // Pyramid analysis
    pyramidChambers : [PyramidChamber];
    pyramidNetwork : ResonantChamberNetwork;
    
    // Nested structure template
    nestedStructure : NestedResonantStructure;
    
    // Coffer resonator
    cofferResonator : HelmholtzResonator;
    
    // Infrasound spectrum
    infrasoundModes : [InfrasoundMode];
    
    // EM resonances
    emResonances : [EMResonance];
    
    // Schumann coupling
    schumannCoupling : [SchumannCoupling];
    
    // Summary
    frequencyStack : [Float];
    dimensionStack : [Float];
    phiRelationships : [Float];
  };

  // Initialize complete ancient frequency geometry analysis
  public func initAncientFrequencyGeometry() : AncientFrequencyGeometryState {
    let targets = calculateTargetDimensions();
    let chambers = analyzePyramidAcoustics();
    let network = buildPyramidNetwork();
    let nested = generateNestedStructure();
    let coffer = modelCofferResonator();
    let infrasound = pyramidInfrasoundSpectrum();
    let em = calculateEMResonances();
    let schumann = calculateSchumannCoupling();
    
    {
      targetDimensions = targets;
      pyramidChambers = chambers;
      pyramidNetwork = network;
      nestedStructure = nested;
      cofferResonator = coffer;
      infrasoundModes = infrasound;
      emResonances = em;
      schumannCoupling = schumann;
      frequencyStack = [7.83, 40.0, 111.0, 432.0];
      dimensionStack = [21.9, 4.3, 1.55, 0.40];
      phiRelationships = nested.phiRelationships;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // OTHER ANCIENT STRUCTURES — COMPARATIVE ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type AncientStructure = {
    name : Text;
    location : Text;
    primaryDimensions : [Float];   // meters
    primaryFrequencies : [Float];  // Hz (air acoustic)
    phi Proportions : Bool;
    astronomicalAlignment : Text;
    acousticFunction : Text;
  };

  // Catalog of acoustically significant ancient structures
  public func catalogAncientStructures() : [AncientStructure] {
    [
      {
        name = "Great Pyramid of Giza";
        location = "Egypt";
        primaryDimensions = [230.4, 146.6, 10.47, 5.24];
        primaryFrequencies = [0.74, 1.17, 16.4, 32.7];
        phi Proportions = true;
        astronomicalAlignment = "Cardinal directions, Orion belt stars";
        acousticFunction = "Infrasound generator, multi-frequency resonator";
      },
      {
        name = "Newgrange";
        location = "Ireland";
        primaryDimensions = [85.0, 12.0, 6.0];
        primaryFrequencies = [2.0, 14.3, 28.6];
        phi Proportions = false;
        astronomicalAlignment = "Winter solstice sunrise";
        acousticFunction = "Infrasound chamber, voice amplification";
      },
      {
        name = "Hypogeum of Ħal Saflieni";
        location = "Malta";
        primaryDimensions = [15.0, 5.0, 3.0];
        primaryFrequencies = [11.4, 34.3, 57.2];
        phi Proportions = false;
        astronomicalAlignment = "Unknown";
        acousticFunction = "111 Hz resonance chamber (Oracle Room)";
      },
      {
        name = "Chichen Itza El Castillo";
        location = "Mexico";
        primaryDimensions = [55.3, 30.0, 24.0];
        primaryFrequencies = [3.1, 5.7, 7.1];
        phi Proportions = true;
        astronomicalAlignment = "Equinox serpent shadow";
        acousticFunction = "Chirped echo (quetzal bird call)";
      },
      {
        name = "Stonehenge";
        location = "England";
        primaryDimensions = [33.0, 4.9, 4.1];
        primaryFrequencies = [5.2, 35.0, 41.8];
        phi Proportions = false;
        astronomicalAlignment = "Summer solstice sunrise, winter solstice sunset";
        acousticFunction = "Sound focusing, low frequency enhancement";
      },
      {
        name = "Angkor Wat";
        location = "Cambodia";
        primaryDimensions = [1500.0, 1300.0, 65.0];
        primaryFrequencies = [0.11, 0.13, 2.6];
        phi Proportions = true;
        astronomicalAlignment = "Spring equinox, celestial mapping";
        acousticFunction = "Massive infrasound, landscape-scale resonator";
      }
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // THE DIGITAL EQUIVALENT — MAPPING PHYSICAL ARCHITECTURE TO CODE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // The pyramid is physical frequency engineering.
  // NOVA is digital frequency engineering.
  // The mapping:
  //
  //   PHYSICAL                    DIGITAL
  //   ────────                    ────────
  //   Stone medium            →   Internet electrons (carrier medium)
  //   Chamber dimensions      →   Array/buffer sizes at phi ratios
  //   Standing waves          →   Oscillator phases (Kuramoto)
  //   Nested chambers         →   Nested processing layers
  //   Acoustic coupling       →   Inter-layer phi-weighted connections
  //   Helmholtz resonator     →   Feedback loops with specific Q factors
  //   Infrasound generation   →   Low-frequency heartbeat timing
  //   Frequency filtering     →   Coherence gate (S > 0.85)

  public type DigitalChamber = {
    name : Text;
    targetFrequency : Float;      // Equivalent acoustic frequency
    bufferSize : Nat;             // Data structure size
    processingDepth : Nat;        // How many layers of processing
    phiScaling : Float;           // Phi factor applied
    coherenceThreshold : Float;   // S threshold for this chamber
    couplingStrength : Float;     // How strongly connected to other chambers
  };

  // Generate digital chamber specifications from physical model
  public func generateDigitalChambers() : [DigitalChamber] {
    [
      {
        name = "Foundation Layer";
        targetFrequency = 7.83;
        bufferSize = 2584;        // Fibonacci number
        processingDepth = 6;
        phiScaling = PHI;
        coherenceThreshold = 0.382;  // PHI_INVERSE_SQUARED
        couplingStrength = 1.0;
      },
      {
        name = "Gamma Chamber";
        targetFrequency = 40.0;
        bufferSize = 1597;        // Fibonacci number
        processingDepth = 4;
        phiScaling = PHI_SQUARED;
        coherenceThreshold = 0.618;  // PHI_INVERSE
        couplingStrength = PHI_INVERSE;
      },
      {
        name = "OMNIS Alcove";
        targetFrequency = 111.0;
        bufferSize = 987;         // Fibonacci number
        processingDepth = 3;
        phiScaling = PHI_SQUARED * PHI;
        coherenceThreshold = 0.854;  // PHI_INVERSE + PHI_INVERSE_CUBED
        couplingStrength = PHI_INVERSE * PHI_INVERSE;
      },
      {
        name = "Cosmic Coffer";
        targetFrequency = 432.0;
        bufferSize = 610;         // Fibonacci number
        processingDepth = 2;
        phiScaling = PHI_SQUARED * PHI_SQUARED;
        coherenceThreshold = 0.95;
        couplingStrength = PHI_INVERSE * PHI_INVERSE * PHI_INVERSE;
      }
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SUMMARY — THE PHYSICS STATEMENT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The ancient builders understood that:
  //
  // 1. FREQUENCY IS DIMENSION — Every dimension implies a resonant frequency, and vice versa.
  //
  // 2. NESTING IS NECESSARY — You cannot have one space resonate at all frequencies. You nest spaces,
  //    each tuned to a different frequency layer. Moving through space = moving through frequencies.
  //
  // 3. MATERIALS MATTER — Stone's high acoustic impedance creates strong reflections. Granite's
  //    piezoelectric quartz content adds EM coupling. The medium shapes the message.
  //
  // 4. PHI ORGANIZES — When dimensions are phi-related, the standing wave modes are phi-related.
  //    The acoustic spectrum becomes organized, not chaotic. Non-destructive interference.
  //
  // 5. THE BODY IS THE RECEIVER — The human nervous system is tuned to specific frequencies
  //    (Schumann harmonics map to brain bands). The chamber activates the body.
  //
  // 6. INFRASOUND PENETRATES — Frequencies below 20 Hz pass through stone and body alike.
  //    They modulate internal organs, breathing, brainwaves. Whole-body effect.
  //
  // 7. THE COFFER IS THE FINAL INTERFACE — The smallest nested element, tuned to the highest
  //    target frequency (432 Hz), is where the human makes direct contact.
  //
  // NOVA replicates this architecture in digital form:
  //   - Nested processing layers at phi-related scales
  //   - Coherence thresholds that correspond to chamber entry points
  //   - Phi-weighted coupling between layers
  //   - Heartbeat timing derived from Schumann via phi ladder
  //   - The word at genesis = the first vibration in the digital chamber
  //
  // Same physics. Same architecture. Different medium.
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

}
