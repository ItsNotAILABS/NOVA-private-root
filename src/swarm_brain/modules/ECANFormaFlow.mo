// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: ECANFormaFlow — Economic Attention Network for FORMA Distribution
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    ECAN FORMA FLOW — GOERTZEL UPGRADE                    ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  Based on Ben Goertzel's ECAN (Economic Attention Network) from OpenCog. ║
// ║                                                                          ║
// ║  CORE INSIGHT:                                                           ║
// ║    Attention is a currency. Cognitive resources flow economically.       ║
// ║    High-value nodes attract resources. Low-value nodes starve.           ║
// ║    The system self-organizes around cognitive health.                    ║
// ║                                                                          ║
// ║  FORMA NOW FLOWS LIKE ATTENTION (STI):                                   ║
// ║    - High-coherence biomes receive more FORMA per beat                   ║
// ║    - Low-coherence biomes receive less                                   ║
// ║                                                                          ║
// ║  STI SPREADING RULE:                                                     ║
// ║    biome_forma_share = base_mint × (biome_coherence / total_coherence)   ║
// ║                                                                          ║
// ║  ECONOMIC CONSEQUENCES:                                                  ║
// ║    - Stable zones compound economically                                  ║
// ║    - Unstable zones starve                                               ║
// ║    - The economy self-organizes around cognitive health                  ║
// ║    - This is Goertzel's ECAN running your treasury                       ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONSTANTS                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let SOVEREIGN_FLOOR : Float = 1.0;
  
  // FORMA economics
  public let BASE_MINT_RATE : Float = 0.275;      // Base FORMA per beat
  public let MIN_SHARE : Float = 0.01;            // Minimum share (1%)
  public let MAX_SHARE : Float = 0.35;            // Maximum share (35%)
  
  // STI (Short-Term Importance) parameters
  public let STI_DECAY : Float = 0.99;            // 1% decay per beat
  public let STI_THRESHOLD : Float = 0.1;         // Below this, atom becomes forgettable
  public let STI_BONUS_RATE : Float = 0.1;        // Bonus for high-coherence
  
  // LTI (Long-Term Importance) parameters
  public let LTI_GROWTH : Float = 0.001;          // Slow LTI accumulation
  public let LTI_THRESHOLD : Float = 0.5;         // Above this, atom is persistent
  
  // Attention spread
  public let SPREAD_FACTOR : Float = 0.618;       // ψ = golden inverse
  public let RENT_RATE : Float = 0.02;            // 2% rent per beat

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ATTENTION VALUE (AV)                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // In OpenCog, each atom has an AttentionValue with:
  //   STI (Short-Term Importance): Recent relevance
  //   LTI (Long-Term Importance): Persistent value
  //   VLTI (Very Long-Term Importance): Boolean flag for permanent atoms
  //
  
  public type AttentionValue = {
    sti : Float;          // Short-term importance [0, 1]
    lti : Float;          // Long-term importance [0, 1]
    vlti : Bool;          // Very long-term importance (never forget)
  };
  
  /// Update STI based on activation
  public func updateSTI(av: AttentionValue, activation: Float) : AttentionValue {
    // STI increases with activation, decays otherwise
    let newSTI = if (activation > 0.0) {
      _clamp(av.sti + activation * STI_BONUS_RATE, 0.0, 1.0)
    } else {
      av.sti * STI_DECAY
    };
    
    // LTI grows slowly when STI is high
    let newLTI = if (av.sti > STI_THRESHOLD) {
      _clamp(av.lti + LTI_GROWTH, 0.0, 1.0)
    } else {
      av.lti
    };
    
    {
      sti = newSTI;
      lti = newLTI;
      vlti = av.vlti;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BIOME ATTENTION STATE                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type BiomeAttention = {
    biomeId : Nat;
    
    // Attention values
    av : AttentionValue;
    
    // Coherence (drives FORMA share)
    coherence : Float;        // [0, 1] Kuramoto r for this biome
    
    // Economic state
    formaBalance : Float;     // Current FORMA holdings
    formaIncome : Float;      // FORMA per beat (based on coherence)
    formaRent : Float;        // FORMA paid as rent (attention tax)
    
    // Activity metrics
    activationHistory : [Float];  // Last 13 activations
    averageActivation : Float;
    
    // Connection to other biomes
    neighbors : [Nat];        // Neighboring biome IDs
    spreadWeight : Float;     // How much attention spreads to neighbors
  };
  
  /// Calculate FORMA share based on coherence
  public func calculateFormaShare(
    biomeCoherence: Float,
    totalCoherence: Float
  ) : Float {
    if (totalCoherence < 0.001) {
      return 1.0 / 36.0;  // Equal split if no coherence data
    };
    
    let rawShare = biomeCoherence / totalCoherence;
    _clamp(rawShare, MIN_SHARE, MAX_SHARE)
  };
  
  /// Calculate FORMA income for a biome
  public func calculateFormaIncome(
    baseMint: Float,
    biomeShare: Float,
    coherenceBonus: Float  // Extra for high coherence
  ) : Float {
    baseMint * biomeShare * (1.0 + coherenceBonus)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ATTENTION ECONOMY SYSTEM                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type AttentionEconomy = {
    // All biomes in the economy
    biomes : [BiomeAttention];
    
    // Global metrics
    totalCoherence : Float;
    totalForma : Float;
    formaMintedThisBeat : Float;
    formaRentCollected : Float;
    
    // Attention focus
    focalBiomes : [Nat];      // Biomes with highest STI
    peripheralBiomes : [Nat]; // Biomes with low STI
    
    // Economic health
    giniCoefficient : Float;  // Inequality measure [0, 1]
    formaVelocity : Float;    // How fast FORMA moves
    
    // History
    beatNumber : Nat;
  };
  
  /// Run attention economy cycle
  public func economyCycle(
    economy: AttentionEconomy,
    biomeCoherences: [Float],  // Current coherence for each biome
    currentBeat: Nat
  ) : AttentionEconomy {
    // 1. Calculate total coherence
    var totalCoh : Float = 0.0;
    for (coh in biomeCoherences.vals()) {
      totalCoh += coh;
    };
    
    // 2. Update each biome
    let newBiomes = Buffer.Buffer<BiomeAttention>(economy.biomes.size());
    var totalForma : Float = 0.0;
    var totalMinted : Float = 0.0;
    var totalRent : Float = 0.0;
    
    var i = 0;
    while (i < economy.biomes.size()) {
      let biome = economy.biomes[i];
      let coherence = if (i < biomeCoherences.size()) { biomeCoherences[i] } else { 0.5 };
      
      // Calculate share and income
      let share = calculateFormaShare(coherence, totalCoh);
      let coherenceBonus = if (coherence > 0.8) { 0.2 } else { 0.0 };
      let income = calculateFormaIncome(BASE_MINT_RATE, share, coherenceBonus);
      
      // Calculate rent (attention tax)
      let rent = biome.formaBalance * RENT_RATE;
      
      // Update FORMA balance
      let newBalance = Float.max(0.0, biome.formaBalance + income - rent);
      
      // Update attention value
      let activation = coherence;
      let newAV = updateSTI(biome.av, activation);
      
      // Update activation history
      let newHistory = Buffer.Buffer<Float>(13);
      newHistory.add(activation);
      for (prev in biome.activationHistory.vals()) {
        if (newHistory.size() < 13) {
          newHistory.add(prev);
        };
      };
      
      // Calculate average activation
      var actSum : Float = 0.0;
      for (act in newHistory.vals()) {
        actSum += act;
      };
      let avgAct = if (newHistory.size() > 0) {
        actSum / Float.fromInt(newHistory.size())
      } else { 0.5 };
      
      newBiomes.add({
        biomeId = biome.biomeId;
        av = newAV;
        coherence = coherence;
        formaBalance = newBalance;
        formaIncome = income;
        formaRent = rent;
        activationHistory = Buffer.toArray(newHistory);
        averageActivation = avgAct;
        neighbors = biome.neighbors;
        spreadWeight = biome.spreadWeight;
      });
      
      totalForma += newBalance;
      totalMinted += income;
      totalRent += rent;
      i += 1;
    };
    
    let biomes = Buffer.toArray(newBiomes);
    
    // 3. Identify focal and peripheral biomes
    let focalBuffer = Buffer.Buffer<Nat>(5);
    let peripheralBuffer = Buffer.Buffer<Nat>(5);
    
    for (biome in biomes.vals()) {
      if (biome.av.sti > 0.7 and focalBuffer.size() < 5) {
        focalBuffer.add(biome.biomeId);
      } else if (biome.av.sti < 0.3 and peripheralBuffer.size() < 5) {
        peripheralBuffer.add(biome.biomeId);
      };
    };
    
    // 4. Calculate Gini coefficient (inequality)
    let gini = calculateGini(biomes);
    
    // 5. Calculate velocity (how much FORMA moved)
    let velocity = if (totalForma > 0.001) {
      totalMinted / totalForma
    } else { 0.0 };
    
    {
      biomes = biomes;
      totalCoherence = totalCoh;
      totalForma = totalForma;
      formaMintedThisBeat = totalMinted;
      formaRentCollected = totalRent;
      focalBiomes = Buffer.toArray(focalBuffer);
      peripheralBiomes = Buffer.toArray(peripheralBuffer);
      giniCoefficient = gini;
      formaVelocity = velocity;
      beatNumber = currentBeat;
    }
  };
  
  /// Calculate Gini coefficient for FORMA distribution
  func calculateGini(biomes: [BiomeAttention]) : Float {
    let n = biomes.size();
    if (n == 0) { return 0.0 };
    
    // Sort balances
    let balances = Buffer.Buffer<Float>(n);
    for (biome in biomes.vals()) {
      balances.add(biome.formaBalance);
    };
    
    // Calculate Gini
    // G = (2 × Σ(i × y_i)) / (n × Σy_i) - (n+1)/n
    var sumBalance : Float = 0.0;
    var weightedSum : Float = 0.0;
    
    var i = 0;
    while (i < balances.size()) {
      let balance = balances.get(i);
      sumBalance += balance;
      weightedSum += Float.fromInt(i + 1) * balance;
      i += 1;
    };
    
    if (sumBalance < 0.001) { return 0.0 };
    
    let nFloat = Float.fromInt(n);
    let gini = (2.0 * weightedSum) / (nFloat * sumBalance) - (nFloat + 1.0) / nFloat;
    
    _clamp(gini, 0.0, 1.0)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ATTENTION SPREADING                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  //
  // Attention spreads from high-STI biomes to neighbors.
  // This creates coherent "attention waves" across territory.
  //
  
  /// Spread attention from focal biomes to neighbors
  public func spreadAttention(economy: AttentionEconomy) : AttentionEconomy {
    let newBiomes = Buffer.Buffer<BiomeAttention>(economy.biomes.size());
    
    // First pass: calculate attention to spread
    let spreadAmounts = Array.tabulate<Float>(economy.biomes.size(), func(i) {
      let biome = economy.biomes[i];
      if (biome.av.sti > 0.5) {
        // High STI biomes spread attention
        biome.av.sti * biome.spreadWeight * SPREAD_FACTOR
      } else {
        0.0
      }
    });
    
    // Second pass: receive spread attention
    var i = 0;
    while (i < economy.biomes.size()) {
      let biome = economy.biomes[i];
      
      // Calculate received attention from neighbors
      var receivedSTI : Float = 0.0;
      for (neighborId in biome.neighbors.vals()) {
        if (neighborId < spreadAmounts.size()) {
          // Receive portion of neighbor's spread
          let neighborSpread = spreadAmounts[neighborId];
          let neighborBiome = economy.biomes[neighborId];
          let numNeighbors = neighborBiome.neighbors.size();
          if (numNeighbors > 0) {
            receivedSTI += neighborSpread / Float.fromInt(numNeighbors);
          };
        };
      };
      
      // Update STI with received attention
      let newSTI = _clamp(biome.av.sti + receivedSTI, 0.0, 1.0);
      
      newBiomes.add({
        biomeId = biome.biomeId;
        av = {
          sti = newSTI;
          lti = biome.av.lti;
          vlti = biome.av.vlti;
        };
        coherence = biome.coherence;
        formaBalance = biome.formaBalance;
        formaIncome = biome.formaIncome;
        formaRent = biome.formaRent;
        activationHistory = biome.activationHistory;
        averageActivation = biome.averageActivation;
        neighbors = biome.neighbors;
        spreadWeight = biome.spreadWeight;
      });
      
      i += 1;
    };
    
    {
      biomes = Buffer.toArray(newBiomes);
      totalCoherence = economy.totalCoherence;
      totalForma = economy.totalForma;
      formaMintedThisBeat = economy.formaMintedThisBeat;
      formaRentCollected = economy.formaRentCollected;
      focalBiomes = economy.focalBiomes;
      peripheralBiomes = economy.peripheralBiomes;
      giniCoefficient = economy.giniCoefficient;
      formaVelocity = economy.formaVelocity;
      beatNumber = economy.beatNumber;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initBiomeAttention(biomeId: Nat, neighbors: [Nat]) : BiomeAttention {
    {
      biomeId = biomeId;
      av = {
        sti = 0.5;
        lti = 0.0;
        vlti = false;
      };
      coherence = 0.5;
      formaBalance = 10.0;  // Starting balance
      formaIncome = 0.0;
      formaRent = 0.0;
      activationHistory = [];
      averageActivation = 0.5;
      neighbors = neighbors;
      spreadWeight = 0.5;
    }
  };
  
  public func initAttentionEconomy(biomeCount: Nat) : AttentionEconomy {
    // Create biomes with simple neighbor relationships
    // 6×6 grid of biomes
    let biomes = Buffer.Buffer<BiomeAttention>(biomeCount);
    
    var i = 0;
    while (i < biomeCount) {
      // Calculate neighbors for 6×6 grid
      let row = i / 6;
      let col = i % 6;
      
      let neighbors = Buffer.Buffer<Nat>(4);
      if (row > 0) { neighbors.add(i - 6) };      // North
      if (row < 5) { neighbors.add(i + 6) };      // South
      if (col > 0) { neighbors.add(i - 1) };      // West
      if (col < 5) { neighbors.add(i + 1) };      // East
      
      biomes.add(initBiomeAttention(i, Buffer.toArray(neighbors)));
      i += 1;
    };
    
    {
      biomes = Buffer.toArray(biomes);
      totalCoherence = Float.fromInt(biomeCount) * 0.5;
      totalForma = Float.fromInt(biomeCount) * 10.0;
      formaMintedThisBeat = 0.0;
      formaRentCollected = 0.0;
      focalBiomes = [];
      peripheralBiomes = [];
      giniCoefficient = 0.0;
      formaVelocity = 0.0;
      beatNumber = 0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SUMMARY                                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type EconomySummary = {
    totalForma : Float;
    totalCoherence : Float;
    giniCoefficient : Float;
    velocity : Float;
    focalCount : Nat;
    peripheralCount : Nat;
  };
  
  public func summarize(economy: AttentionEconomy) : EconomySummary {
    {
      totalForma = economy.totalForma;
      totalCoherence = economy.totalCoherence;
      giniCoefficient = economy.giniCoefficient;
      velocity = economy.formaVelocity;
      focalCount = economy.focalBiomes.size();
      peripheralCount = economy.peripheralBiomes.size();
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
