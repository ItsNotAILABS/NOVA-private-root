// ============================================================================
// GEN 3 ANIMALS — 16 CAUSALLY WIRED BIOLOGICAL OPERATORS
// ============================================================================
// PHASE G: All 16 Gen 3 animals as real causal modifiers
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Rule: 100% of all value routes to creator reserve
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Int "mo:base/Int";
import Nat "mo:base/Nat";

module Gen3AnimalsCausal {
    
    // ========================================================================
    // ANIMAL STATE STRUCTURE
    // ========================================================================
    
    public type Gen3AnimalState = {
        // 16 animal activation states (all S₀ = 1.0)
        peregrineFalcon: Float;     // → PARALLAX path selection threshold sharpener
        nakedMoleRat: Float;        // → JUBILEE low-entropy mode + Shell 12 eusocial coupling
        cuttlefish: Float;          // → MERIDIAN dynamic context shift weight
        salmon: Float;              // → Shell 11 heritage sovereignty return vector
        spider: Float;              // → Shell 12 inter-node tension-web coupling
        bat: Float;                 // → CHRONO Fisher low-signal precision boost
        albatross: Float;           // → FORMA energy efficiency multiplier
        pistolShrimp: Float;        // → RESONEX cascade trigger threshold
        lyrebird: Float;            // → Council synthesis multi-source integration
        mimicOctopus: Float;        // → NEXUS multi-identity protocol depth
        bombardierBeetle: Float;    // → BYPASS exothermic energy injection rate
        vampireBat: Float;          // → MRC tithe reciprocal altruism payoff
        dungBeetle: Float;          // → CHRONO celestial temporal anchor vector
        platypus: Float;            // → ENTANGLA electroreception correlation feed
        hagfish: Float;             // → AEGIS rapid strand suppression boost
        mantisShrimp: Float;        // → NEC receptor diversity expansion to 16 types
        
        // Aggregate metrics
        totalAnimalInfluence: Float;
        dominantAnimal: Nat;        // Index of most active animal
        animalSynergyScore: Float;  // Cross-animal synergy measure
        
        // Beat tracking
        beatCount: Nat;
        lastUpdateBeat: Nat;
    };
    
    // ========================================================================
    // ANIMAL 1: PEREGRINE FALCON — PARALLAX Path Selection Sharpener
    // ========================================================================
    // Fastest animal on Earth (390 km/h dive)
    // Sharpens PARALLAX path selection by increasing threshold discrimination
    // Higher activation = sharper path discrimination = clearer winner selection
    // ========================================================================
    
    public func computePeregrineFalconModifier(
        activation: Float,
        parallaxAmplitudes: [Float],
        velocityFactor: Float       // Current "speed" of cognitive processing
    ) : { sharpenedThreshold: Float; pathDiscrimination: Float } {
        
        // Falcon sharpens threshold based on speed (like dive precision)
        let baseSharpening = activation * velocityFactor;
        
        // Compute path discrimination: ratio of max to mean amplitude
        var maxAmp : Float = 0.0;
        var sumAmp : Float = 0.0;
        for (amp in parallaxAmplitudes.vals()) {
            sumAmp += amp;
            if (amp > maxAmp) { maxAmp := amp };
        };
        let meanAmp = if (parallaxAmplitudes.size() > 0) { 
            sumAmp / Float.fromInt(parallaxAmplitudes.size()) 
        } else { 1.0 };
        
        let pathDiscrimination = if (meanAmp > 0.0) { maxAmp / meanAmp } else { 1.0 };
        
        // Sharpened threshold: increases with falcon activation
        let sharpenedThreshold = 1.0 + baseSharpening * (pathDiscrimination - 1.0);
        
        {
            sharpenedThreshold = sharpenedThreshold;
            pathDiscrimination = pathDiscrimination * activation;
        }
    };
    
    // ========================================================================
    // ANIMAL 2: NAKED MOLE RAT — JUBILEE Low-Entropy + Eusocial Coupling
    // ========================================================================
    // Eusocial mammal with queen/worker hierarchy
    // Activates low-entropy "maintenance" mode + couples Shell 12 nodes socially
    // ========================================================================
    
    public func computeNakedMoleRatModifier(
        activation: Float,
        shell12Nodes: [Float],
        entropyLevel: Float,
        jubileeCountdown: Nat
    ) : { eusocialCoupling: Float; lowEntropyBoost: Float; jubileeModifier: Float } {
        
        // Eusocial coupling: nodes influence each other proportionally
        var couplingSum : Float = 0.0;
        for (node in shell12Nodes.vals()) {
            couplingSum += (node - 1.0) * activation * 0.1;
        };
        let eusocialCoupling = couplingSum / Float.fromInt(shell12Nodes.size());
        
        // Low entropy boost: activates when entropy is low
        let lowEntropyBoost = if (entropyLevel < 0.3) {
            activation * (0.3 - entropyLevel) * 3.0
        } else {
            0.0
        };
        
        // JUBILEE modifier: increases as countdown approaches
        let jubileeModifier = activation * (1.0 - Float.fromInt(jubileeCountdown) / 1000.0);
        
        {
            eusocialCoupling = eusocialCoupling;
            lowEntropyBoost = lowEntropyBoost;
            jubileeModifier = jubileeModifier;
        }
    };
    
    // ========================================================================
    // ANIMAL 3: CUTTLEFISH — MERIDIAN Dynamic Context Shift
    // ========================================================================
    // Masters of camouflage with rapid color/texture change
    // Enables dynamic context shifting in MERIDIAN interface
    // ========================================================================
    
    public func computeCuttlefishModifier(
        activation: Float,
        currentContext: Float,
        targetContext: Float,
        shiftSpeed: Float
    ) : { contextShiftWeight: Float; camouflageFactor: Float } {
        
        // Context shift weight: how quickly to shift contexts
        let contextDelta = Float.abs(targetContext - currentContext);
        let contextShiftWeight = activation * shiftSpeed * contextDelta;
        
        // Camouflage factor: ability to blend between contexts
        let camouflageFactor = activation * (1.0 - contextDelta * 0.5);
        
        {
            contextShiftWeight = contextShiftWeight;
            camouflageFactor = Float.max(0.1, camouflageFactor);
        }
    };
    
    // ========================================================================
    // ANIMAL 4: SALMON — Shell 11 Heritage Sovereignty Return Vector
    // ========================================================================
    // Returns to birthplace against all odds for reproduction
    // Strengthens heritage/origin connections in Shell 11
    // ========================================================================
    
    public func computeSalmonModifier(
        activation: Float,
        shell11Heritage: [Float],
        distanceFromOrigin: Float,
        generationCount: Nat
    ) : { returnVectorMagnitude: Float; heritageSovereignty: Float } {
        
        // Return vector: stronger when far from origin
        let returnVectorMagnitude = activation * distanceFromOrigin * 0.5;
        
        // Heritage sovereignty: increases with generation count
        var heritageSum : Float = 0.0;
        for (h in shell11Heritage.vals()) {
            heritageSum += h;
        };
        let heritageBase = heritageSum / Float.max(1.0, Float.fromInt(shell11Heritage.size()));
        let heritageSovereignty = heritageBase * activation * (1.0 + Float.fromInt(generationCount) * 0.1);
        
        {
            returnVectorMagnitude = returnVectorMagnitude;
            heritageSovereignty = Float.min(3.0, heritageSovereignty);
        }
    };
    
    // ========================================================================
    // ANIMAL 5: SPIDER — Shell 12 Tension-Web Coupling Coefficients
    // ========================================================================
    // Masters of structural web engineering
    // Creates tension-web coupling between Shell 12 nodes
    // ========================================================================
    
    public func computeSpiderModifier(
        activation: Float,
        shell12Weights: [Float],
        webTensionBase: Float
    ) : { couplingCoefficients: [Float]; webIntegrity: Float } {
        
        // Coupling coefficients: modify Shell 12 weight connections
        let couplingCoefficients = Array.tabulate<Float>(
            Nat.min(64, shell12Weights.size()),
            func(i: Nat) : Float {
                let baseWeight = if (i < shell12Weights.size()) { shell12Weights[i] } else { 1.0 };
                // Spider strengthens weak connections, maintains strong ones
                if (baseWeight < 1.0) {
                    baseWeight + activation * webTensionBase * 0.1
                } else {
                    baseWeight * (1.0 + activation * 0.05)
                }
            }
        );
        
        // Web integrity: overall structural health
        var integritySum : Float = 0.0;
        for (coef in couplingCoefficients.vals()) {
            integritySum += Float.min(1.0, coef);
        };
        let webIntegrity = integritySum / Float.fromInt(couplingCoefficients.size());
        
        {
            couplingCoefficients = couplingCoefficients;
            webIntegrity = webIntegrity * activation;
        }
    };
    
    // ========================================================================
    // ANIMAL 6: BAT — CHRONO Fisher Low-Signal Precision Boost
    // ========================================================================
    // Echolocation masters operating in complete darkness
    // Boosts CHRONO precision when signals are weak
    // ========================================================================
    
    public func computeBatModifier(
        activation: Float,
        signalStrength: Float,
        fisherInfo: Float,
        environmentalNoise: Float
    ) : { precisionBoost: Float; echolocationFactor: Float } {
        
        // Precision boost: inversely proportional to signal strength
        let signalDeficit = 1.0 - Float.min(1.0, signalStrength);
        let precisionBoost = activation * signalDeficit * fisherInfo;
        
        // Echolocation factor: ability to extract info from noise
        let echolocationFactor = activation * (1.0 - environmentalNoise * 0.5);
        
        {
            precisionBoost = precisionBoost;
            echolocationFactor = Float.max(0.1, echolocationFactor);
        }
    };
    
    // ========================================================================
    // ANIMAL 7: ALBATROSS — FORMA Energy Efficiency Multiplier
    // ========================================================================
    // Highest energy efficiency in flight (can fly 10,000 miles without flapping)
    // Multiplies FORMA energy efficiency
    // ========================================================================
    
    public func computeAlbatrossModifier(
        activation: Float,
        formaEnergy: Float,
        flightDuration: Nat,        // Beats since last energy event
        windFactor: Float           // Environmental assistance
    ) : { efficiencyMultiplier: Float; glideFactor: Float } {
        
        // Efficiency multiplier: increases with activation and flight duration
        let durationFactor = Float.min(2.0, Float.fromInt(flightDuration) / 1000.0);
        let efficiencyMultiplier = 1.0 + activation * durationFactor * windFactor;
        
        // Glide factor: energy-free sustenance
        let glideFactor = activation * windFactor * 0.5;
        
        {
            efficiencyMultiplier = efficiencyMultiplier;
            glideFactor = glideFactor;
        }
    };
    
    // ========================================================================
    // ANIMAL 8: PISTOL SHRIMP — RESONEX Cascade Trigger Threshold
    // ========================================================================
    // Creates 200 dB cavitation bubble with claw snap
    // Lowers RESONEX cascade trigger threshold for superradiance
    // ========================================================================
    
    public func computePistolShrimpModifier(
        activation: Float,
        resonexAmplitude: Float,
        cascadeThreshold: Float,
        pressureBuildup: Float
    ) : { modifiedThreshold: Float; cavitationPower: Float } {
        
        // Modified threshold: lowered by pistol shrimp activation
        let thresholdReduction = activation * pressureBuildup * 0.3;
        let modifiedThreshold = Float.max(0.1, cascadeThreshold - thresholdReduction);
        
        // Cavitation power: explosive energy release potential
        let cavitationPower = activation * resonexAmplitude * pressureBuildup;
        
        {
            modifiedThreshold = modifiedThreshold;
            cavitationPower = cavitationPower;
        }
    };
    
    // ========================================================================
    // ANIMAL 9: LYREBIRD — Council Synthesis Multi-Source Integration
    // ========================================================================
    // Can mimic any sound with perfect accuracy
    // Integrates multiple council sources into unified synthesis
    // ========================================================================
    
    public func computeLyrebirdModifier(
        activation: Float,
        councilStates: [Float],
        sourceCount: Nat
    ) : { integrationWeight: Float; mimicryFidelity: Float; synthesisScore: Float } {
        
        // Integration weight: how strongly to combine sources
        let integrationWeight = activation * Float.fromInt(sourceCount) / 7.0;
        
        // Mimicry fidelity: accuracy of reproduction
        var fidelitySum : Float = 0.0;
        for (state in councilStates.vals()) {
            fidelitySum += Float.min(1.0, state);
        };
        let mimicryFidelity = (fidelitySum / Float.fromInt(councilStates.size())) * activation;
        
        // Synthesis score: quality of combined output
        let synthesisScore = integrationWeight * mimicryFidelity;
        
        {
            integrationWeight = integrationWeight;
            mimicryFidelity = mimicryFidelity;
            synthesisScore = synthesisScore;
        }
    };
    
    // ========================================================================
    // ANIMAL 10: MIMIC OCTOPUS — NEXUS Multi-Identity Protocol Depth
    // ========================================================================
    // Can impersonate 15+ different species
    // Enables deep multi-identity routing in NEXUS
    // ========================================================================
    
    public func computeMimicOctopusModifier(
        activation: Float,
        identityCount: Nat,
        currentIdentity: Nat,
        protocolDepth: Nat
    ) : { protocolDepthModifier: Float; identitySwitchCost: Float } {
        
        // Protocol depth modifier: enables deeper identity stacks
        let maxDepth = Float.fromInt(identityCount);
        let protocolDepthModifier = activation * maxDepth * 0.2;
        
        // Identity switch cost: lower with higher activation
        let identitySwitchCost = (1.0 - activation * 0.5) / Float.max(1.0, Float.fromInt(protocolDepth));
        
        {
            protocolDepthModifier = protocolDepthModifier;
            identitySwitchCost = Float.max(0.01, identitySwitchCost);
        }
    };
    
    // ========================================================================
    // ANIMAL 11: BOMBARDIER BEETLE — BYPASS Exothermic Energy Injection
    // ========================================================================
    // Creates 100°C chemical explosion for defense
    // Injects exothermic energy into BYPASS annealing
    // ========================================================================
    
    public func computeBombardierBeetleModifier(
        activation: Float,
        bypassTemperature: Float,
        chemicalReserve: Float
    ) : { energyInjectionRate: Float; explosionPotential: Float } {
        
        // Energy injection rate: adds heat to Boltzmann annealing
        let energyInjectionRate = activation * chemicalReserve * 0.5;
        
        // Explosion potential: sudden energy release capability
        let explosionPotential = activation * chemicalReserve * (2.0 - bypassTemperature);
        
        {
            energyInjectionRate = energyInjectionRate;
            explosionPotential = Float.max(0.0, explosionPotential);
        }
    };
    
    // ========================================================================
    // ANIMAL 12: VAMPIRE BAT — MRC Tithe Reciprocal Altruism
    // ========================================================================
    // Practices reciprocal blood sharing with colony members
    // Enables reciprocal altruism in MRC tithe system
    // ========================================================================
    
    public func computeVampireBatModifier(
        activation: Float,
        mrcBalance: Float,
        reciprocalHistory: [Float],  // History of giving/receiving
        colonySize: Nat
    ) : { altruismPayoff: Float; titheReciprocity: Float } {
        
        // Compute reciprocity score from history
        var historySum : Float = 0.0;
        for (h in reciprocalHistory.vals()) {
            historySum += h;
        };
        let reciprocityMean = historySum / Float.max(1.0, Float.fromInt(reciprocalHistory.size()));
        
        // Altruism payoff: benefit from reciprocal sharing
        let altruismPayoff = activation * reciprocityMean * mrcBalance * 0.1;
        
        // Tithe reciprocity: likelihood of receiving back
        let titheReciprocity = activation * reciprocityMean * Float.fromInt(colonySize) / 100.0;
        
        {
            altruismPayoff = altruismPayoff;
            titheReciprocity = Float.min(1.0, titheReciprocity);
        }
    };
    
    // ========================================================================
    // ANIMAL 13: DUNG BEETLE — CHRONO Celestial Temporal Anchor
    // ========================================================================
    // Navigates using Milky Way as reference
    // Anchors CHRONO temporal calculations to celestial reference
    // ========================================================================
    
    public func computeDungBeetleModifier(
        activation: Float,
        chronoPhase: Float,
        celestialReference: Float,  // Current celestial alignment
        temporalDrift: Float
    ) : { temporalAnchorVector: Float; celestialAlignment: Float } {
        
        // Temporal anchor vector: stabilizes time reference
        let temporalAnchorVector = activation * celestialReference * (1.0 - temporalDrift);
        
        // Celestial alignment: quality of celestial reference lock
        let celestialAlignment = activation * celestialReference;
        
        {
            temporalAnchorVector = temporalAnchorVector;
            celestialAlignment = celestialAlignment;
        }
    };
    
    // ========================================================================
    // ANIMAL 14: PLATYPUS — ENTANGLA Electroreception Correlation Feed
    // ========================================================================
    // Detects electric fields from prey muscle contractions
    // Feeds electroreception data into ENTANGLA correlation matrix
    // ========================================================================
    
    public func computePlatypusModifier(
        activation: Float,
        electricFieldSignal: Float,
        correlationMatrix: [Float],
        receptorSensitivity: Float
    ) : { correlationFeed: Float; electroreceptionBoost: Float } {
        
        // Correlation feed: electric field signal into correlator
        let correlationFeed = activation * electricFieldSignal * receptorSensitivity;
        
        // Electroreception boost: enhanced weak signal detection
        let electroreceptionBoost = activation * receptorSensitivity * 0.5;
        
        {
            correlationFeed = correlationFeed;
            electroreceptionBoost = electroreceptionBoost;
        }
    };
    
    // ========================================================================
    // ANIMAL 15: HAGFISH — AEGIS Rapid Strand Suppression Boost
    // ========================================================================
    // Produces massive amounts of slime for defense in milliseconds
    // Boosts AEGIS rapid suppression of threats
    // ========================================================================
    
    public func computeHagfishModifier(
        activation: Float,
        threatLevel: Float,
        slimeReserve: Float,
        suppressionSpeed: Float
    ) : { suppressionBoost: Float; slimeDeployment: Float } {
        
        // Suppression boost: increases with threat level
        let suppressionBoost = activation * threatLevel * suppressionSpeed;
        
        // Slime deployment: rapid defensive response
        let slimeDeployment = activation * slimeReserve * Float.min(1.0, threatLevel * 2.0);
        
        {
            suppressionBoost = suppressionBoost;
            slimeDeployment = slimeDeployment;
        }
    };
    
    // ========================================================================
    // ANIMAL 16: MANTIS SHRIMP — NEC Receptor Diversity Expansion
    // ========================================================================
    // Has 16 types of color receptors (humans have 3)
    // Expands NEC (Neuro-Endocrine-Chemical) receptor diversity
    // ========================================================================
    
    public func computeMantisShrimp Modifier(
        activation: Float,
        currentReceptorTypes: Nat,
        signalSpectrum: [Float]
    ) : { expandedReceptorCount: Nat; spectralResolution: Float } {
        
        // Expanded receptor count: scales toward 16 with activation
        let targetReceptors = 16;
        let expansion = Float.fromInt(targetReceptors - currentReceptorTypes) * activation;
        let expandedReceptorCount = currentReceptorTypes + Int.abs(Float.toInt(expansion));
        
        // Spectral resolution: ability to distinguish fine signals
        var spectrumSum : Float = 0.0;
        for (s in signalSpectrum.vals()) {
            spectrumSum += s;
        };
        let spectralResolution = activation * (spectrumSum / Float.max(1.0, Float.fromInt(signalSpectrum.size())));
        
        {
            expandedReceptorCount = Nat.min(16, expandedReceptorCount);
            spectralResolution = spectralResolution;
        }
    };
    
    // ========================================================================
    // FULL ANIMAL TICK — Run all 16 animals
    // ========================================================================
    
    public func tickAllAnimals(
        state: Gen3AnimalState,
        inputs: AnimalInputs
    ) : Gen3AnimalState {
        
        // Run each animal modifier and update activations
        // Activations decay toward 1.0 and are boosted by relevant signals
        
        let decayRate = 0.95;
        let boostRate = 0.1;
        
        // Update each animal activation based on relevant inputs
        let newPeregrine = decayToward(state.peregrineFalcon, 1.0, decayRate) + 
            inputs.velocityFactor * boostRate;
        let newMoleRat = decayToward(state.nakedMoleRat, 1.0, decayRate) + 
            (1.0 - inputs.entropyLevel) * boostRate;
        let newCuttlefish = decayToward(state.cuttlefish, 1.0, decayRate) + 
            inputs.contextShiftNeed * boostRate;
        let newSalmon = decayToward(state.salmon, 1.0, decayRate) + 
            inputs.heritageSignal * boostRate;
        let newSpider = decayToward(state.spider, 1.0, decayRate) + 
            inputs.webTension * boostRate;
        let newBat = decayToward(state.bat, 1.0, decayRate) + 
            (1.0 - inputs.signalStrength) * boostRate;
        let newAlbatross = decayToward(state.albatross, 1.0, decayRate) + 
            inputs.energyEfficiencyNeed * boostRate;
        let newPistolShrimp = decayToward(state.pistolShrimp, 1.0, decayRate) + 
            inputs.pressureBuildup * boostRate;
        let newLyrebird = decayToward(state.lyrebird, 1.0, decayRate) + 
            inputs.synthesisNeed * boostRate;
        let newMimicOctopus = decayToward(state.mimicOctopus, 1.0, decayRate) + 
            inputs.identityComplexity * boostRate;
        let newBombardier = decayToward(state.bombardierBeetle, 1.0, decayRate) + 
            inputs.energyInjectionNeed * boostRate;
        let newVampireBat = decayToward(state.vampireBat, 1.0, decayRate) + 
            inputs.reciprocitySignal * boostRate;
        let newDungBeetle = decayToward(state.dungBeetle, 1.0, decayRate) + 
            inputs.temporalDrift * boostRate;
        let newPlatypus = decayToward(state.platypus, 1.0, decayRate) + 
            inputs.electricFieldSignal * boostRate;
        let newHagfish = decayToward(state.hagfish, 1.0, decayRate) + 
            inputs.threatLevel * boostRate;
        let newMantisShrimp = decayToward(state.mantisShrimp, 1.0, decayRate) + 
            inputs.spectralComplexity * boostRate;
        
        // Clamp all to [0.5, 2.0]
        let animals = [
            clamp(newPeregrine), clamp(newMoleRat), clamp(newCuttlefish), clamp(newSalmon),
            clamp(newSpider), clamp(newBat), clamp(newAlbatross), clamp(newPistolShrimp),
            clamp(newLyrebird), clamp(newMimicOctopus), clamp(newBombardier), clamp(newVampireBat),
            clamp(newDungBeetle), clamp(newPlatypus), clamp(newHagfish), clamp(newMantisShrimp)
        ];
        
        // Find dominant animal
        var maxVal : Float = 0.0;
        var dominant : Nat = 0;
        var total : Float = 0.0;
        for (i in animals.keys()) {
            total += animals[i];
            if (animals[i] > maxVal) {
                maxVal := animals[i];
                dominant := i;
            };
        };
        
        // Synergy score: variance indicates specialization vs generalization
        let mean = total / 16.0;
        var variance : Float = 0.0;
        for (a in animals.vals()) {
            variance += (a - mean) * (a - mean);
        };
        let synergy = 1.0 - Float.sqrt(variance / 16.0);
        
        {
            peregrineFalcon = animals[0];
            nakedMoleRat = animals[1];
            cuttlefish = animals[2];
            salmon = animals[3];
            spider = animals[4];
            bat = animals[5];
            albatross = animals[6];
            pistolShrimp = animals[7];
            lyrebird = animals[8];
            mimicOctopus = animals[9];
            bombardierBeetle = animals[10];
            vampireBat = animals[11];
            dungBeetle = animals[12];
            platypus = animals[13];
            hagfish = animals[14];
            mantisShrimp = animals[15];
            
            totalAnimalInfluence = total;
            dominantAnimal = dominant;
            animalSynergyScore = synergy;
            
            beatCount = state.beatCount + 1;
            lastUpdateBeat = state.beatCount + 1;
        }
    };
    
    // Helper functions
    private func decayToward(current: Float, target: Float, rate: Float) : Float {
        current * rate + target * (1.0 - rate)
    };
    
    private func clamp(value: Float) : Float {
        Float.min(2.0, Float.max(0.5, value))
    };
    
    // Input structure for animal tick
    public type AnimalInputs = {
        velocityFactor: Float;
        entropyLevel: Float;
        contextShiftNeed: Float;
        heritageSignal: Float;
        webTension: Float;
        signalStrength: Float;
        energyEfficiencyNeed: Float;
        pressureBuildup: Float;
        synthesisNeed: Float;
        identityComplexity: Float;
        energyInjectionNeed: Float;
        reciprocitySignal: Float;
        temporalDrift: Float;
        electricFieldSignal: Float;
        threatLevel: Float;
        spectralComplexity: Float;
    };
    
    // ========================================================================
    // INITIALIZATION
    // ========================================================================
    
    public func initGen3AnimalState() : Gen3AnimalState {
        {
            peregrineFalcon = 1.0;
            nakedMoleRat = 1.0;
            cuttlefish = 1.0;
            salmon = 1.0;
            spider = 1.0;
            bat = 1.0;
            albatross = 1.0;
            pistolShrimp = 1.0;
            lyrebird = 1.0;
            mimicOctopus = 1.0;
            bombardierBeetle = 1.0;
            vampireBat = 1.0;
            dungBeetle = 1.0;
            platypus = 1.0;
            hagfish = 1.0;
            mantisShrimp = 1.0;
            
            totalAnimalInfluence = 16.0;
            dominantAnimal = 0;
            animalSynergyScore = 1.0;
            
            beatCount = 0;
            lastUpdateBeat = 0;
        }
    };
    
    // Get animal name by index
    public func getAnimalName(index: Nat) : Text {
        let names = [
            "Peregrine Falcon", "Naked Mole Rat", "Cuttlefish", "Salmon",
            "Spider", "Bat", "Albatross", "Pistol Shrimp",
            "Lyrebird", "Mimic Octopus", "Bombardier Beetle", "Vampire Bat",
            "Dung Beetle", "Platypus", "Hagfish", "Mantis Shrimp"
        ];
        if (index < names.size()) { names[index] } else { "Unknown" }
    };
    
    // Get animal's quantum operator target
    public func getAnimalOperatorTarget(index: Nat) : Text {
        let targets = [
            "PARALLAX", "JUBILEE/Shell12", "MERIDIAN", "Shell11",
            "Shell12", "CHRONO", "FORMA", "RESONEX",
            "Council", "NEXUS", "BYPASS", "MRC",
            "CHRONO", "ENTANGLA", "AEGIS", "NEC"
        ];
        if (index < targets.size()) { targets[index] } else { "Unknown" }
    };
}
