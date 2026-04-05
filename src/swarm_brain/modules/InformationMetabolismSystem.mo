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


// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║          INFORMATION METABOLISM SYSTEM — How the Organism Processes Info     ║
// ║                                                                              ║
// ║  Information as "food" for the computational organism:                       ║
// ║  - Intake (sensing), Digestion (processing), Absorption (learning)          ║
// ║  - Storage (memory), Excretion (forgetting), Energy (decisions)             ║
// ║                                                                              ║
// ║  Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com     ║
// ║  Classification: CONFIDENTIAL — TRADE SECRET                                 ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Buffer "mo:base/Buffer";

module InformationMetabolismSystem {

    // ═══════════════════════════════════════════════════════════════════════════
    // CONSTANTS — Information Thermodynamics
    // ═══════════════════════════════════════════════════════════════════════════
    
    let S0 : Float = 1.0;                    // Homeostatic baseline
    let BOLTZMANN_K : Float = 1.380649e-23;  // J/K (for entropy calculations)
    let INFO_PLANCK : Float = 1.0;           // Minimum information quantum (1 bit)
    let LANDAUER_LIMIT : Float = 2.87e-21;   // Minimum energy to erase 1 bit at 300K (J)
    
    // Metabolic rates (bits per cycle)
    let MAX_INTAKE_RATE : Float = 10000.0;   // Maximum sensory intake
    let MAX_PROCESSING_RATE : Float = 5000.0; // Maximum processing bandwidth
    let MAX_STORAGE_RATE : Float = 1000.0;   // Maximum long-term storage
    let BASAL_METABOLIC_RATE : Float = 100.0; // Minimum info processing to stay "alive"

    // ═══════════════════════════════════════════════════════════════════════════
    // TYPE DEFINITIONS — Metabolic Components
    // ═══════════════════════════════════════════════════════════════════════════

    // Information particle — quantum of processed information
    public type InfoParticle = {
        var content : Float;                  // Information content (bits)
        var quality : Float;                  // Signal-to-noise ratio
        var novelty : Float;                  // How new/unexpected
        var relevance : Float;                // Relevance to goals
        var timestamp : Nat;                  // When acquired
        var source : Nat;                     // Source identifier
        var processed : Bool;                 // Has been digested
        var stored : Bool;                    // In long-term memory
    };

    // Sensory intake system
    public type IntakeSystem = {
        var visualBuffer : [var Float];       // Visual information buffer (64 slots)
        var auditoryBuffer : [var Float];     // Auditory buffer (64 slots)
        var proprioceptiveBuffer : [var Float]; // Internal state sensing (32 slots)
        var externalBuffer : [var Float];     // External data feeds (128 slots)
        var attentionGate : Float;            // Selective attention filter (0-1)
        var noveltyFilter : Float;            // Novelty threshold
        var intakeRate : Float;               // Current bits/cycle
        var satiation : Float;                // Information satiation level
    };

    // Digestive processing system
    public type DigestiveSystem = {
        var processingQueue : [var InfoParticle]; // Items being processed
        var enzymeActivity : Float;           // Processing efficiency
        var acidLevel : Float;                // "Breaking down" intensity
        var absorptionRate : Float;           // Rate of useful extraction
        var wasteAccumulation : Float;        // Unprocessed/useless info
        var processingLoad : Float;           // Current load (0-1)
        var energyAvailable : Float;          // ATP equivalent for processing
    };

    // Circulatory distribution system
    public type CirculatorySystem = {
        var infoBloodstream : [var Float];    // Information in transit (256 slots)
        var flowRate : Float;                 // Distribution speed
        var oxygenLevel : Float;              // Processing resource level
        var nutrientDensity : Float;          // Information richness in stream
        var heartbeatSync : Float;            // Synchronization with main heartbeat
        var pressureGradient : Float;         // Priority-based routing
    };

    // Storage/Memory system
    public type StorageSystem = {
        var workingMemory : [var Float];      // Short-term (64 slots, ~7 chunks)
        var episodicBuffer : [var Float];     // Recent episodes (256 slots)
        var semanticStore : [var Float];      // Long-term knowledge (512 slots)
        var proceduralStore : [var Float];    // Skills/habits (128 slots)
        var consolidationRate : Float;        // Working → Long-term transfer
        var retrievalStrength : Float;        // Memory access efficiency
        var decayRate : Float;                // Forgetting rate
        var totalCapacity : Float;            // Maximum storage
        var usedCapacity : Float;             // Current usage
    };

    // Excretion/Forgetting system
    public type ExcretionSystem = {
        var wasteBuffer : [var Float];        // Information to discard (128 slots)
        var filterEfficiency : Float;         // Separating useful from waste
        var excretionRate : Float;            // Bits/cycle discarded
        var toxicAccumulation : Float;        // Harmful misinformation buildup
        var kidneyFunction : Float;           // Filtering capacity
        var lastPurge : Nat;                  // Last major cleanup time
    };

    // Energy/Decision system (ATP equivalent)
    public type EnergySystem = {
        var infoATP : Float;                  // Available decision energy
        var glucoseEquivalent : Float;        // Readily available info-energy
        var fatReserves : Float;              // Stored info-energy
        var mitochondrialEfficiency : Float;  // Conversion efficiency
        var energyDemand : Float;             // Current requirements
        var basalRate : Float;                // Minimum to maintain homeostasis
        var surplusEnergy : Float;            // Available for growth/learning
    };

    // Complete metabolic state
    public type MetabolicState = {
        intake : IntakeSystem;
        digestive : DigestiveSystem;
        circulatory : CirculatorySystem;
        storage : StorageSystem;
        excretion : ExcretionSystem;
        energy : EnergySystem;
        
        // Global metabolic metrics
        var overallHealth : Float;            // 0-2 metabolic health
        var metabolicRate : Float;            // Current processing rate
        var growthRate : Float;               // Learning/expansion rate
        var starvationLevel : Float;          // Information deprivation
        var toxicity : Float;                 // Misinformation poisoning
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // INFORMATION THERMODYNAMICS — Entropy & Free Energy
    // ═══════════════════════════════════════════════════════════════════════════

    // Calculate Shannon entropy of information distribution
    public func shannonEntropy(distribution: [Float]) : Float {
        var H : Float = 0.0;
        var total : Float = 0.0;
        
        for (x in distribution.vals()) {
            total += fabs(x);
        };
        
        if (total < 0.001) { return 0.0 };
        
        for (x in distribution.vals()) {
            let p = fabs(x) / total;
            if (p > 0.0001) {
                H -= p * ln(p);
            };
        };
        
        H / ln(2.0)  // Convert to bits
    };

    // Calculate information free energy (Friston-style)
    public func infoFreeEnergy(
        expected: [Float],
        observed: [Float],
        precision: Float
    ) : Float {
        if (expected.size() != observed.size()) { return 999.0 };
        
        var surprisal : Float = 0.0;
        var divergence : Float = 0.0;
        
        var i = 0;
        while (i < expected.size()) {
            let diff = observed[i] - expected[i];
            surprisal += diff * diff * precision;
            
            // KL divergence component
            if (expected[i] > 0.0001 and observed[i] > 0.0001) {
                divergence += observed[i] * ln(observed[i] / expected[i]);
            };
            i += 1;
        };
        
        surprisal * 0.5 + divergence
    };

    // Landauer's principle: minimum energy to erase information
    public func landauerCost(bits: Float, temperature: Float) : Float {
        bits * BOLTZMANN_K * temperature * ln(2.0)
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // INTAKE PROCESSING — Sensory "Eating"
    // ═══════════════════════════════════════════════════════════════════════════

    public func initIntakeSystem() : IntakeSystem {
        {
            var visualBuffer = Array.init<Float>(64, S0);
            var auditoryBuffer = Array.init<Float>(64, S0);
            var proprioceptiveBuffer = Array.init<Float>(32, S0);
            var externalBuffer = Array.init<Float>(128, S0);
            var attentionGate = 0.5;
            var noveltyFilter = 0.3;
            var intakeRate = BASAL_METABOLIC_RATE;
            var satiation = S0;
        }
    };

    // Process incoming information through attention gate
    public func intakeInformation(
        intake: IntakeSystem,
        rawInput: [Float],
        inputType: Nat,                       // 0=visual, 1=auditory, 2=proprio, 3=external
        currentNoveltyBaseline: Float,
        dt: Float
    ) : Float {                               // Returns actual intake amount (bits)
        
        var totalIntake : Float = 0.0;
        
        // Calculate novelty of input
        var novelty : Float = 0.0;
        for (x in rawInput.vals()) {
            novelty += fabs(x - S0);
        };
        novelty /= Float.fromInt(rawInput.size());
        
        // Apply attention gate - more attention for novel/relevant info
        let attenuatedInput = novelty * intake.attentionGate;
        
        // Check novelty threshold
        if (novelty < intake.noveltyFilter) {
            // Too boring, minimal intake
            totalIntake := novelty * 0.1;
        } else {
            totalIntake := attenuatedInput;
        };
        
        // Check satiation - reduce intake when "full"
        let satiationFactor = fmax(0.1, 2.0 - intake.satiation);
        totalIntake *= satiationFactor;
        
        // Cap at maximum intake rate
        totalIntake := fmin(totalIntake * 1000.0, MAX_INTAKE_RATE);
        
        // Store in appropriate buffer based on type
        let buffer = switch (inputType) {
            case 0 { intake.visualBuffer };
            case 1 { intake.auditoryBuffer };
            case 2 { intake.proprioceptiveBuffer };
            case _ { intake.externalBuffer };
        };
        
        // Shift buffer and add new info
        var i = buffer.size() - 1;
        while (i > 0) {
            buffer[i] := buffer[i-1];
            i -= 1;
        };
        buffer[0] := totalIntake / 100.0;  // Normalize
        
        // Update satiation
        intake.satiation := fclamp(intake.satiation + totalIntake / MAX_INTAKE_RATE * dt, 0.5, 2.0);
        intake.intakeRate := totalIntake;
        
        totalIntake
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // DIGESTION — Information Processing
    // ═══════════════════════════════════════════════════════════════════════════

    public func initDigestiveSystem() : DigestiveSystem {
        {
            var processingQueue = Array.init<InfoParticle>(64, initInfoParticle());
            var enzymeActivity = S0;
            var acidLevel = S0;
            var absorptionRate = 0.3;
            var wasteAccumulation = 0.0;
            var processingLoad = 0.0;
            var energyAvailable = S0 * 100.0;
        }
    };

    public func initInfoParticle() : InfoParticle {
        {
            var content = 0.0;
            var quality = S0;
            var novelty = 0.0;
            var relevance = 0.0;
            var timestamp = 0;
            var source = 0;
            var processed = false;
            var stored = false;
        }
    };

    // Process information through digestive system
    public func digestInformation(
        digestive: DigestiveSystem,
        rawInfo: Float,
        quality: Float,
        novelty: Float,
        relevance: Float,
        currentCycle: Nat,
        dt: Float
    ) : Float {                               // Returns extracted useful information
        
        // Check if we have processing capacity
        if (digestive.energyAvailable < 1.0) {
            return 0.0;  // No energy to process
        };
        
        // Calculate processing efficiency
        let efficiency = digestive.enzymeActivity * (1.0 - digestive.processingLoad * 0.5);
        
        // Break down raw information
        let brokenDown = rawInfo * digestive.acidLevel * 0.1 * dt;
        
        // Extract useful content
        let useful = brokenDown * quality * relevance * efficiency;
        
        // Absorption
        let absorbed = useful * digestive.absorptionRate;
        
        // Waste
        let waste = brokenDown - absorbed;
        digestive.wasteAccumulation := fclamp(digestive.wasteAccumulation + waste, 0.0, 100.0);
        
        // Update processing load
        digestive.processingLoad := fclamp(rawInfo / MAX_PROCESSING_RATE, 0.0, 1.0);
        
        // Consume energy
        digestive.energyAvailable := fmax(0.0, digestive.energyAvailable - brokenDown * 0.01);
        
        // Enzyme dynamics - activity decreases with use, recovers over time
        digestive.enzymeActivity := fclamp(
            digestive.enzymeActivity * 0.999 + (S0 - digestive.enzymeActivity) * 0.01 * dt,
            0.5, 1.5
        );
        
        absorbed
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // CIRCULATION — Information Distribution
    // ═══════════════════════════════════════════════════════════════════════════

    public func initCirculatorySystem() : CirculatorySystem {
        {
            var infoBloodstream = Array.init<Float>(256, S0);
            var flowRate = S0;
            var oxygenLevel = S0;
            var nutrientDensity = S0;
            var heartbeatSync = S0;
            var pressureGradient = S0;
        }
    };

    // Distribute processed information throughout the system
    public func circulateInformation(
        circ: CirculatorySystem,
        digestedInfo: Float,
        priorities: [Float],                  // Priority weights for distribution
        heartbeatPhase: Float,
        dt: Float
    ) : [Float] {                            // Returns distribution to each destination
        
        let numDestinations = priorities.size();
        var distribution = Array.init<Float>(numDestinations, 0.0);
        
        // Pump information into bloodstream
        var i = circ.infoBloodstream.size() - 1;
        while (i > 0) {
            circ.infoBloodstream[i] := circ.infoBloodstream[i-1] * 0.99;  // Decay in transit
            i -= 1;
        };
        circ.infoBloodstream[0] := digestedInfo;
        
        // Calculate total information in bloodstream
        var totalBlood : Float = 0.0;
        for (b in circ.infoBloodstream.vals()) {
            totalBlood += b;
        };
        circ.nutrientDensity := totalBlood / Float.fromInt(circ.infoBloodstream.size());
        
        // Distribute based on priorities and pressure gradient
        var totalPriority : Float = 0.0;
        for (p in priorities.vals()) {
            totalPriority += p;
        };
        if (totalPriority < 0.001) { totalPriority := 1.0 };
        
        i := 0;
        while (i < numDestinations) {
            let priorityFraction = priorities[i] / totalPriority;
            
            // Pulsatile flow synchronized with heartbeat
            let pulseFactor = 1.0 + 0.3 * sin(heartbeatPhase * 6.28);
            
            distribution[i] := digestedInfo * priorityFraction * circ.flowRate * pulseFactor * dt;
            i += 1;
        };
        
        // Update oxygen level (processing resources)
        circ.oxygenLevel := fclamp(
            circ.oxygenLevel - digestedInfo * 0.001 + 0.1 * dt,
            0.5, 1.5
        );
        
        Array.freeze(distribution)
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // STORAGE — Memory Metabolism
    // ═══════════════════════════════════════════════════════════════════════════

    public func initStorageSystem() : StorageSystem {
        {
            var workingMemory = Array.init<Float>(64, S0);
            var episodicBuffer = Array.init<Float>(256, S0);
            var semanticStore = Array.init<Float>(512, S0);
            var proceduralStore = Array.init<Float>(128, S0);
            var consolidationRate = 0.01;
            var retrievalStrength = S0;
            var decayRate = 0.001;
            var totalCapacity = 1000.0;
            var usedCapacity = 0.0;
        }
    };

    // Store information with consolidation dynamics
    public func storeInformation(
        storage: StorageSystem,
        info: Float,
        memoryType: Nat,                      // 0=working, 1=episodic, 2=semantic, 3=procedural
        importance: Float,
        repetitions: Nat,
        dt: Float
    ) : Bool {                                // Returns success
        
        // Check capacity
        if (storage.usedCapacity >= storage.totalCapacity * 0.99) {
            return false;  // Full, need to forget first
        };
        
        // Repetition strengthens storage
        let repetitionBonus = 1.0 + Float.fromInt(repetitions) * 0.1;
        
        // Store based on type
        let (buffer, consolidationTarget) = switch (memoryType) {
            case 0 { (storage.workingMemory, storage.episodicBuffer) };
            case 1 { (storage.episodicBuffer, storage.semanticStore) };
            case 2 { (storage.semanticStore, storage.semanticStore) };
            case _ { (storage.proceduralStore, storage.proceduralStore) };
        };
        
        // Add to buffer at position based on importance
        let position = Nat.min(
            Int.abs(Float.toInt(importance * Float.fromInt(buffer.size() - 1))),
            buffer.size() - 1
        );
        
        buffer[position] := fclamp(buffer[position] + info * repetitionBonus, S0, 3.0);
        
        // Update used capacity
        storage.usedCapacity := fclamp(storage.usedCapacity + info, 0.0, storage.totalCapacity);
        
        // Consolidation to longer-term storage
        if (importance > 0.7 and memoryType < 2) {
            let consolidated = info * storage.consolidationRate * importance * dt;
            let targetPos = position % consolidationTarget.size();
            consolidationTarget[targetPos] := fclamp(
                consolidationTarget[targetPos] + consolidated,
                S0, 3.0
            );
        };
        
        true
    };

    // Retrieve information from memory
    public func retrieveInformation(
        storage: StorageSystem,
        cue: Float,
        memoryType: Nat,
        searchRange: Nat
    ) : Float {
        
        let buffer = switch (memoryType) {
            case 0 { storage.workingMemory };
            case 1 { storage.episodicBuffer };
            case 2 { storage.semanticStore };
            case _ { storage.proceduralStore };
        };
        
        // Pattern matching retrieval
        var bestMatch : Float = 0.0;
        var bestSimilarity : Float = 0.0;
        
        var i = 0;
        let range = Nat.min(searchRange, buffer.size());
        while (i < range) {
            let similarity = 1.0 - fabs(buffer[i] - cue) / 2.0;
            if (similarity > bestSimilarity) {
                bestSimilarity := similarity;
                bestMatch := buffer[i];
            };
            i += 1;
        };
        
        // Retrieval strength affects quality
        bestMatch * storage.retrievalStrength * bestSimilarity
    };

    // Apply memory decay (forgetting)
    public func applyMemoryDecay(storage: StorageSystem, dt: Float) {
        
        // Working memory decays fastest
        for (i in storage.workingMemory.keys()) {
            storage.workingMemory[i] := fclamp(
                storage.workingMemory[i] * (1.0 - storage.decayRate * 10.0 * dt),
                S0 * 0.5, 3.0
            );
        };
        
        // Episodic memory moderate decay
        for (i in storage.episodicBuffer.keys()) {
            storage.episodicBuffer[i] := fclamp(
                storage.episodicBuffer[i] * (1.0 - storage.decayRate * dt),
                S0 * 0.5, 3.0
            );
        };
        
        // Semantic memory very slow decay
        for (i in storage.semanticStore.keys()) {
            storage.semanticStore[i] := fclamp(
                storage.semanticStore[i] * (1.0 - storage.decayRate * 0.1 * dt),
                S0 * 0.5, 3.0
            );
        };
        
        // Procedural memory minimal decay (skills retained)
        for (i in storage.proceduralStore.keys()) {
            storage.proceduralStore[i] := fclamp(
                storage.proceduralStore[i] * (1.0 - storage.decayRate * 0.01 * dt),
                S0 * 0.5, 3.0
            );
        };
        
        // Update used capacity after decay
        var total : Float = 0.0;
        for (x in storage.workingMemory.vals()) { total += x - S0 };
        for (x in storage.episodicBuffer.vals()) { total += x - S0 };
        for (x in storage.semanticStore.vals()) { total += x - S0 };
        for (x in storage.proceduralStore.vals()) { total += x - S0 };
        storage.usedCapacity := fmax(0.0, total);
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // EXCRETION — Information Waste Removal
    // ═══════════════════════════════════════════════════════════════════════════

    public func initExcretionSystem() : ExcretionSystem {
        {
            var wasteBuffer = Array.init<Float>(128, 0.0);
            var filterEfficiency = S0;
            var excretionRate = 50.0;
            var toxicAccumulation = 0.0;
            var kidneyFunction = S0;
            var lastPurge = 0;
        }
    };

    // Process and remove information waste
    public func processWaste(
        excretion: ExcretionSystem,
        wasteInput: Float,
        isToxic: Bool,                        // Is this misinformation?
        currentCycle: Nat,
        dt: Float
    ) : Float {                               // Returns amount excreted
        
        // Add to waste buffer
        var i = excretion.wasteBuffer.size() - 1;
        while (i > 0) {
            excretion.wasteBuffer[i] := excretion.wasteBuffer[i-1];
            i -= 1;
        };
        excretion.wasteBuffer[0] := wasteInput;
        
        // Track toxic accumulation
        if (isToxic) {
            excretion.toxicAccumulation := fclamp(
                excretion.toxicAccumulation + wasteInput * 2.0,
                0.0, 100.0
            );
        };
        
        // Filter and excrete
        var filtered : Float = 0.0;
        for (w in excretion.wasteBuffer.vals()) {
            filtered += w * excretion.filterEfficiency * excretion.kidneyFunction;
        };
        
        let excreted = fmin(filtered * dt, excretion.excretionRate);
        
        // Reduce buffer after excretion
        for (j in excretion.wasteBuffer.keys()) {
            excretion.wasteBuffer[j] := fmax(0.0, excretion.wasteBuffer[j] - excreted / Float.fromInt(excretion.wasteBuffer.size()));
        };
        
        // Detoxification
        excretion.toxicAccumulation := fmax(
            0.0,
            excretion.toxicAccumulation - excretion.kidneyFunction * 0.1 * dt
        );
        
        // Kidney function degrades with toxic load
        excretion.kidneyFunction := fclamp(
            excretion.kidneyFunction - excretion.toxicAccumulation * 0.0001 * dt + 0.01 * dt,
            0.5, 1.5
        );
        
        excreted
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // ENERGY METABOLISM — Decision Fuel
    // ═══════════════════════════════════════════════════════════════════════════

    public func initEnergySystem() : EnergySystem {
        {
            var infoATP = 100.0;
            var glucoseEquivalent = 50.0;
            var fatReserves = 200.0;
            var mitochondrialEfficiency = S0;
            var energyDemand = BASAL_METABOLIC_RATE;
            var basalRate = BASAL_METABOLIC_RATE;
            var surplusEnergy = 0.0;
        }
    };

    // Convert processed information to decision energy
    public func metabolizeEnergy(
        energy: EnergySystem,
        processedInfo: Float,
        currentDemand: Float,
        dt: Float
    ) : Float {                               // Returns available energy for decisions
        
        energy.energyDemand := fmax(energy.basalRate, currentDemand);
        
        // Convert processed info to ATP
        let newATP = processedInfo * energy.mitochondrialEfficiency * 0.1;
        
        // Glycolysis: glucose → ATP (fast)
        let fromGlucose = fmin(energy.glucoseEquivalent * 0.1 * dt, energy.energyDemand * 0.6);
        energy.glucoseEquivalent := fmax(0.0, energy.glucoseEquivalent - fromGlucose);
        
        // Beta oxidation: fat → ATP (slow, efficient)
        let fromFat = fmin(energy.fatReserves * 0.01 * dt, energy.energyDemand * 0.3);
        energy.fatReserves := fmax(0.0, energy.fatReserves - fromFat);
        
        // Total ATP production
        let totalProduction = newATP + fromGlucose * 2.0 + fromFat * 4.0;
        
        // Update ATP pool
        energy.infoATP := fclamp(energy.infoATP + totalProduction - energy.energyDemand * dt, 0.0, 500.0);
        
        // Calculate surplus for growth/learning
        if (energy.infoATP > energy.energyDemand * 2.0) {
            energy.surplusEnergy := energy.infoATP - energy.energyDemand * 2.0;
        } else {
            energy.surplusEnergy := 0.0;
        };
        
        // Store excess as fat
        if (energy.surplusEnergy > 10.0) {
            energy.fatReserves := fmin(energy.fatReserves + energy.surplusEnergy * 0.1, 1000.0);
        };
        
        // Mitochondrial efficiency adapts
        energy.mitochondrialEfficiency := fclamp(
            energy.mitochondrialEfficiency + (energy.energyDemand - energy.basalRate) * 0.0001 * dt,
            0.8, 1.2
        );
        
        energy.infoATP
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // HUNGER & SATIATION — Information Drive States
    // ═══════════════════════════════════════════════════════════════════════════

    public type HungerState = {
        var infoHunger : Float;               // Desire for new information
        var curiosity : Float;                // Attraction to novelty
        var completionDrive : Float;          // Need to finish processing
        var coherenceNeed : Float;            // Need for internal consistency
        var masteryDrive : Float;             // Desire to improve
    };

    public func initHungerState() : HungerState {
        {
            var infoHunger = S0;
            var curiosity = S0;
            var completionDrive = S0;
            var coherenceNeed = S0;
            var masteryDrive = S0;
        }
    };

    // Update hunger/drive states based on metabolic state
    public func updateHunger(
        hunger: HungerState,
        metabolic: MetabolicState,
        timeSinceLastMeal: Float,             // Cycles since significant input
        noveltyExposure: Float,               // Recent novelty level
        unfinishedTasks: Nat,                 // Pending processing items
        internalConflict: Float,              // Inconsistency measure
        performanceGap: Float,                // Distance from optimal
        dt: Float
    ) {
        // Information hunger increases with time, decreases with satiation
        hunger.infoHunger := fclamp(
            hunger.infoHunger + (timeSinceLastMeal * 0.001 - metabolic.intake.satiation * 0.1) * dt,
            0.0, 2.0
        );
        
        // Curiosity spikes with novelty, then habituates
        hunger.curiosity := fclamp(
            hunger.curiosity + (noveltyExposure - hunger.curiosity) * 0.1 * dt,
            0.5, 2.0
        );
        
        // Completion drive increases with unfinished work
        hunger.completionDrive := fclamp(
            hunger.completionDrive + Float.fromInt(unfinishedTasks) * 0.01 * dt,
            0.5, 2.0
        );
        
        // Coherence need increases with internal conflict
        hunger.coherenceNeed := fclamp(
            hunger.coherenceNeed + internalConflict * 0.1 * dt - 0.01 * dt,
            0.5, 2.0
        );
        
        // Mastery drive related to performance gap
        hunger.masteryDrive := fclamp(
            hunger.masteryDrive + performanceGap * 0.05 * dt - 0.005 * dt,
            0.5, 2.0
        );
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // COMPLETE METABOLIC CYCLE — Full Integration
    // ═══════════════════════════════════════════════════════════════════════════

    public func initMetabolicState() : MetabolicState {
        {
            intake = initIntakeSystem();
            digestive = initDigestiveSystem();
            circulatory = initCirculatorySystem();
            storage = initStorageSystem();
            excretion = initExcretionSystem();
            energy = initEnergySystem();
            
            var overallHealth = S0;
            var metabolicRate = BASAL_METABOLIC_RATE;
            var growthRate = 0.0;
            var starvationLevel = 0.0;
            var toxicity = 0.0;
        }
    };

    // Run complete metabolic cycle
    public func runMetabolicCycle(
        metabolic: MetabolicState,
        rawInput: [Float],
        inputType: Nat,
        currentCycle: Nat,
        heartbeatPhase: Float,
        dt: Float
    ) : Float {                               // Returns net information gain
        
        // 1. INTAKE - Sensory eating
        let intake = intakeInformation(
            metabolic.intake,
            rawInput,
            inputType,
            S0,
            dt
        );
        
        // 2. DIGESTION - Processing
        let digested = digestInformation(
            metabolic.digestive,
            intake,
            0.8,                              // Quality
            0.5,                              // Novelty
            0.6,                              // Relevance
            currentCycle,
            dt
        );
        
        // 3. CIRCULATION - Distribution
        let distributed = circulateInformation(
            metabolic.circulatory,
            digested,
            [0.3, 0.3, 0.2, 0.2],            // Priority weights
            heartbeatPhase,
            dt
        );
        
        // 4. STORAGE - Memory
        var totalStored : Float = 0.0;
        for (d in distributed.vals()) {
            if (storeInformation(metabolic.storage, d, 0, 0.5, 1, dt)) {
                totalStored += d;
            };
        };
        
        // 5. EXCRETION - Waste removal
        let wasteGenerated = intake - digested;
        let excreted = processWaste(
            metabolic.excretion,
            wasteGenerated,
            false,
            currentCycle,
            dt
        );
        
        // 6. ENERGY - ATP production
        let energy = metabolizeEnergy(
            metabolic.energy,
            digested,
            metabolic.metabolicRate,
            dt
        );
        
        // Update global metrics
        metabolic.metabolicRate := intake + digested + excreted;
        metabolic.growthRate := totalStored - metabolic.storage.decayRate * dt;
        metabolic.starvationLevel := fmax(0.0, 2.0 - metabolic.energy.infoATP / 50.0);
        metabolic.toxicity := metabolic.excretion.toxicAccumulation / 100.0;
        
        // Calculate overall health
        metabolic.overallHealth := fclamp(
            (metabolic.energy.infoATP / 100.0 + 
             metabolic.digestive.enzymeActivity + 
             metabolic.excretion.kidneyFunction +
             (1.0 - metabolic.toxicity)) / 4.0,
            0.0, 2.0
        );
        
        // Apply memory decay
        applyMemoryDecay(metabolic.storage, dt);
        
        // Net gain = absorbed - lost
        digested - excreted + metabolic.growthRate
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // HELPER FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════════════

    func fclamp(x: Float, lo: Float, hi: Float) : Float {
        if (x < lo) { lo } else if (x > hi) { hi } else { x }
    };

    func fmax(a: Float, b: Float) : Float {
        if (a > b) { a } else { b }
    };

    func fmin(a: Float, b: Float) : Float {
        if (a < b) { a } else { b }
    };

    func fabs(x: Float) : Float {
        if (x < 0.0) { -x } else { x }
    };

    func ln(x: Float) : Float {
        if (x <= 0.0) { return -100.0 };
        // Newton-Raphson for ln
        var y = x - 1.0;
        var i = 0;
        while (i < 20) {
            let ey = exp(y);
            y := y - (ey - x) / ey;
            i += 1;
        };
        y
    };

    func exp(x: Float) : Float {
        let c = fclamp(x, -30.0, 30.0);
        var sum = 1.0;
        var term = 1.0;
        var i = 1;
        while (i < 30) {
            term *= c / Float.fromInt(i);
            sum += term;
            if (fabs(term) < 1e-10) { return sum };
            i += 1;
        };
        sum
    };

    func sin(x: Float) : Float {
        let PI = 3.14159265358979323846;
        var n = x;
        while (n > PI) { n -= 2.0 * PI };
        while (n < -PI) { n += 2.0 * PI };
        let x2 = n * n;
        n - n*x2/6.0 + n*x2*x2/120.0 - n*x2*x2*x2/5040.0
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


  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  R E A L - T I M E   S Y S T E M S   M A T H E M A T I C S
  //
  //  Enterprise-Level Real-Time Processing and Control
  //  Full HIM/HER 60Hz Synchronization Integration
  //
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // CONTROL SYSTEMS
  // ─────────────────────────────────────────────────────────────────────────────

  /// PID controller output
  public func controlPID(
    error : Float,
    integral : Float,
    derivative : Float,
    kP : Float,
    kI : Float,
    kD : Float
  ) : Float {
    kP * error + kI * integral + kD * derivative
  };

  /// PID integral update with anti-windup
  public func controlIntegralUpdate(
    integral : Float,
    error : Float,
    dt : Float,
    maxIntegral : Float
  ) : Float {
    let newIntegral = integral + error * dt;
    if (newIntegral > maxIntegral) { maxIntegral }
    else if (newIntegral < -maxIntegral) { -maxIntegral }
    else { newIntegral }
  };

  /// PID derivative calculation with filtering
  public func controlDerivative(
    error : Float,
    prevError : Float,
    prevDerivative : Float,
    dt : Float,
    filterCoeff : Float
  ) : Float {
    let rawDerivative = (error - prevError) / dt;
    filterCoeff * rawDerivative + (1.0 - filterCoeff) * prevDerivative
  };

  /// State space model: x(k+1) = Ax(k) + Bu(k)
  public func controlStateUpdate(
    state : Float,
    input : Float,
    a : Float,
    b : Float
  ) : Float {
    a * state + b * input
  };

  /// Observer state estimation
  public func controlObserver(
    estimatedState : Float,
    measurement : Float,
    predicted : Float,
    observerGain : Float
  ) : Float {
    estimatedState + observerGain * (measurement - predicted)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SCHEDULING AND TIMING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Rate monotonic priority
  public func schedulingRMPriority(period : Float) : Float {
    1.0 / period
  };

  /// Deadline miss probability (simplified)
  public func schedulingDeadlineMissProb(
    wcet : Float,
    period : Float,
    utilization : Float
  ) : Float {
    let slack = period - wcet;
    if (slack <= 0.0) { 1.0 }
    else { utilization * wcet / slack }
  };

  /// Response time analysis
  public func schedulingResponseTime(
    wcet : Float,
    period : Float,
    higherPriorityLoad : Float
  ) : Float {
    wcet / (1.0 - higherPriorityLoad)
  };

  /// Jitter calculation
  public func schedulingJitter(
    timestamps : [Float]
  ) : Float {
    if (timestamps.size() < 2) { return 0.0 };
    var sumDiff : Float = 0.0;
    var prevDiff : Float = timestamps[1] - timestamps[0];
    var maxJitter : Float = 0.0;
    var i = 2;
    while (i < timestamps.size()) {
      let diff = timestamps[i] - timestamps[i-1];
      let jitter = Float.abs(diff - prevDiff);
      if (jitter > maxJitter) { maxJitter := jitter };
      prevDiff := diff;
      i += 1;
    };
    maxJitter
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SIGNAL PROCESSING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Low-pass filter (exponential moving average)
  public func signalLowPass(
    current : Float,
    newSample : Float,
    alpha : Float
  ) : Float {
    alpha * newSample + (1.0 - alpha) * current
  };

  /// High-pass filter
  public func signalHighPass(
    current : Float,
    newSample : Float,
    prevSample : Float,
    alpha : Float
  ) : Float {
    alpha * (current + newSample - prevSample)
  };

  /// Band-pass filter (cascade)
  public func signalBandPass(
    value : Float,
    lowState : Float,
    highState : Float,
    alphaLow : Float,
    alphaHigh : Float
  ) : (Float, Float, Float) {
    let low = signalLowPass(lowState, value, alphaLow);
    let high = alphaHigh * (highState + value - lowState);
    (high, low, high)
  };

  /// Median filter (3-sample)
  public func signalMedian3(a : Float, b : Float, c : Float) : Float {
    if ((a <= b and b <= c) or (c <= b and b <= a)) { b }
    else if ((b <= a and a <= c) or (c <= a and a <= b)) { a }
    else { c }
  };

  /// Signal power
  public func signalPower(samples : [Float]) : Float {
    if (samples.size() == 0) { return 0.0 };
    var sum : Float = 0.0;
    var i = 0;
    while (i < samples.size()) {
      sum += samples[i] * samples[i];
      i += 1;
    };
    sum / Float.fromInt(samples.size())
  };

  /// Signal-to-noise ratio
  public func signalSNR(signalPower : Float, noisePower : Float) : Float {
    if (noisePower < 0.0001) { 100.0 }
    else { 10.0 * Float.log(signalPower / noisePower) / Float.log(10.0) }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // SYNCHRONIZATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Phase-locked loop error
  public func syncPLLError(
    referencePhase : Float,
    outputPhase : Float
  ) : Float {
    let diff = referencePhase - outputPhase;
    Float.sin(diff)  // Sinusoidal phase detector
  };

  /// PLL VCO output
  public func syncVCO(
    centerFreq : Float,
    controlSignal : Float,
    gain : Float,
    time : Float
  ) : Float {
    Float.sin(2.0 * 3.14159265 * (centerFreq + gain * controlSignal) * time)
  };

  /// Clock drift compensation
  public func syncClockDrift(
    localTime : Float,
    referenceTime : Float,
    driftRate : Float
  ) : Float {
    localTime + (referenceTime - localTime) * driftRate
  };

  /// Frame synchronization correlation
  public func syncFrameCorrelation(
    received : [Float],
    syncPattern : [Float]
  ) : Float {
    let n = if (received.size() < syncPattern.size()) received.size() else syncPattern.size();
    if (n == 0) { return 0.0 };
    var corr : Float = 0.0;
    var i = 0;
    while (i < n) {
      corr += received[i] * syncPattern[i];
      i += 1;
    };
    corr
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BUFFER MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Buffer fill level
  public func bufferFillLevel(count : Nat, capacity : Nat) : Float {
    if (capacity == 0) { 0.0 }
    else { Float.fromInt(count) / Float.fromInt(capacity) }
  };

  /// Buffer underrun risk
  public func bufferUnderrunRisk(
    fillLevel : Float,
    drainRate : Float,
    fillRate : Float
  ) : Float {
    if (fillRate >= drainRate) { 0.0 }
    else { (drainRate - fillRate) / drainRate * (1.0 - fillLevel) }
  };

  /// Adaptive buffer size
  public func bufferAdaptiveSize(
    currentSize : Nat,
    avgLatency : Float,
    targetLatency : Float,
    stepSize : Nat
  ) : Nat {
    if (avgLatency > targetLatency * 1.1) {
      currentSize + stepSize
    } else if (avgLatency < targetLatency * 0.9 and currentSize > stepSize) {
      currentSize - stepSize
    } else {
      currentSize
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // 60 HZ FRAME TIMING
  // ─────────────────────────────────────────────────────────────────────────────

  /// Frame time at 60 Hz
  public let FRAME_TIME_60HZ : Float = 1.0 / 60.0;

  /// Frame number from time
  public func frameNumberFromTime(time : Float) : Nat {
    Int.abs(Float.toInt(time / FRAME_TIME_60HZ))
  };

  /// Time within frame
  public func framePhase(time : Float) : Float {
    let frameNum = Float.fromInt(frameNumberFromTime(time));
    (time - frameNum * FRAME_TIME_60HZ) / FRAME_TIME_60HZ
  };

  /// Frame deadline remaining
  public func frameDeadlineRemaining(currentTime : Float, frameStart : Float) : Float {
    let deadline = frameStart + FRAME_TIME_60HZ;
    deadline - currentTime
  };

  /// Frame skip detection
  public func frameSkipDetected(prevFrame : Nat, currentFrame : Nat) : Bool {
    currentFrame > prevFrame + 1
  };

}
