## NOVA Consciousness Equation Canon

Classification: `SOVEREIGN_PRIVATE`

Purpose:
- Canonicalize major organism equations into one governed artifact.
- Preserve equation meaning across generations and multi-build reuse.
- Bind each equation to law, model, and gate references.

---

## 1) Equation governance

Every equation entry must provide:
1. Equation ID
2. Symbol definitions and valid ranges
3. Source implementation references
4. Law bindings
5. Gate impact
6. Replay/evidence implications

No unlabeled equation can gate runtime behavior.

---

## 2) Core equations (instantiated from current implementation)

### EQ-CCVE-RES-01: Cardio-cerebral resonance

Equation:
- `phaseLag = wrapPi(brainPhase - heartPhase)`
- `phaseLock = (cos(phaseLag) + 1) / 2`
- `freqDelta = abs(brainFrequency - heartFrequency) / max(brainFrequency, heartFrequency, EPS)`
- `freqMatch = clamp(1 - freqDelta, 0, 1)`
- `resonanceRaw = 0.6 * phaseLock + 0.4 * freqMatch`
- `resonance_t = clamp(0.85 * resonance_{t-1} + 0.15 * resonanceRaw, 0, 1)`

Source:
- `src/swarm_brain/modules/CardioCerebralVectorEngine.mo`

Bindings:
- Law IDs: `LAW-COHERENCE-LOCK`, `LAW-PHASE-CONTINUITY`
- Model IDs: `R-MODEL-CCVE-STATE`
- Gate impact: Gate A

---

### EQ-CCVE-PROP-02: Cardio-cerebral propulsion effectiveness

Equation:
- `propulsionRaw = resonance_t * (0.70 + 0.30 * heartbeatCoherence) - 0.50 * jDrift`
- `propulsion_t = clamp(0.85 * propulsion_{t-1} + 0.15 * propulsionRaw, 0, 2)`
- `alignment = clamp((dot(direction, doctrineDir) + 1) / 2, 0, 1)`
- `pushEffectiveness = clamp(propulsion_t * alignment * (0.5 + 0.5 * heartbeatCoherence), 0, 2)`

Source:
- `src/swarm_brain/modules/CardioCerebralVectorEngine.mo`

Bindings:
- Law IDs: `LAW-DOCTRINE-DIRECTION`, `LAW-DRIFT-BOUND`
- Model IDs: `R-MODEL-CCVE-STATE`
- Gate impact: Gate A

---

### EQ-CNCO-BRIDGE-03: Cardio-neural resonance bridge

Equation:
- `phaseLock = (cos(wrapPi(brainPhase - heartPhase)) + 1) / 2`
- `freqMatch = clamp(1 - abs(brainFrequency - heartFrequency) / max(brainFrequency, heartFrequency, EPS), 0, 1)`
- `resonanceBridgeRaw = clamp(0.45 * phaseLock + 0.25 * freqMatch + 0.20 * heartCoherence + 0.10 * brainCoherence, 0, 1.5)`
- `resonanceBridge_t = clamp(0.82 * resonanceBridge_{t-1} + 0.18 * resonanceBridgeRaw, 0, 1.5)`

Source:
- `src/swarm_brain/modules/CardioNeuralConversionOrgan.mo`

Bindings:
- Law IDs: `LAW-CONVERSION-INTEGRITY`
- Model IDs: `R-MODEL-CNCO-STATE`
- Gate impact: Gate A

---

### EQ-CNCO-CONV-04: Conversion coherence

Equation:
- `perfusionRaw = clamp(0.55 * perfusionProxy + 0.20 * cardioPropulsion + 0.15 * emotionalEmbodiment + 0.10 * resonanceBridge_t, 0, 1.5)`
- `oxygenRaw = clamp(0.60 * oxygenProxy + 0.25 * perfusionFlow_t + 0.15 * (1 - 0.5 * emotionalArousal), 0, 1.5)`
- `entrainmentRaw = clamp(0.40 * resonanceBridge_t + 0.25 * brainCoherence + 0.20 * heartCoherence + 0.15 * cardioPropulsion, 0, 1.5)`
- `conversionRaw = clamp(0.35 * entrainmentGain_t + 0.25 * oxygenFlow_t + 0.20 * perfusionFlow_t + 0.20 * resonanceBridge_t, 0, 1.5)`
- `conversionCoherence_t = clamp(0.80 * conversionCoherence_{t-1} + 0.20 * conversionRaw, 0, 1.5)`

Source:
- `src/swarm_brain/modules/CardioNeuralConversionOrgan.mo`

Bindings:
- Law IDs: `LAW-THIRD-BRAIN-STABILITY`
- Model IDs: `R-MODEL-CNCO-STATE`
- Gate impact: Gate A

---

### EQ-GRPE-FIELD-05: Geo-resonance field energy

Equation:
- `fieldRaw = clamp(0.22*magneticFlux + 0.14*rfIntensity + 0.10*hydrologyPotential + 0.12*qsovScore + 0.12*rSwarm + 0.10*cardioCerebralPush + 0.10*emotionalCertainty + 0.10*(1-abs(jDrift)), 0, 1.5)`
- `fieldEnergy_t = clamp(0.82 * fieldEnergy_{t-1} + 0.18 * fieldRaw, 0, 1.5)`
- `protectionRaw = clamp(0.35*fieldEnergy_t + 0.25*qsovScore + 0.20*cardioCerebralPush + 0.20*(0.5 + 0.5*dot(doctrineDir, emotionalDir)), 0, 1.5)`
- `protectionScore_t = clamp(0.80 * protectionScore_{t-1} + 0.20 * protectionRaw, 0, 1.5)`

Source:
- `src/swarm_brain/modules/GeoResonanceProtectionEngine.mo`

Bindings:
- Law IDs: `LAW-GEO-RESONANCE-PROTECTION`
- Model IDs: `R-MODEL-GRPE-STATE`
- Gate impact: Gate A, Gate C (if projected)

---

### EQ-GRPE-THREAT-06: Hotspot/threat/readiness chain

Equation:
- `hotspotRaw = clamp(0.40*infrastructureLoad + 0.25*anomalyScore + 0.20*rfIntensity + 0.15*(1-protectionScore_t), 0, 2.0)`
- `hotspotScore_t = clamp(0.78 * hotspotScore_{t-1} + 0.22 * hotspotRaw, 0, 2.0)`
- `threatRaw = clamp(0.55*hotspotScore_t + 0.25*anomalyScore + 0.20*(1-protectionScore_t), 0, 2.0)`
- `threatScore_t = clamp(0.80 * threatScore_{t-1} + 0.20 * threatRaw, 0, 2.0)`
- `readinessRaw = clamp(0.45*protectionScore_t + 0.25*fieldEnergy_t + 0.20*(1-0.5*hotspotScore_t) + 0.10*hydrologyPotential, 0, 1.5)`
- `serviceReadiness_t = clamp(0.82 * serviceReadiness_{t-1} + 0.18 * readinessRaw, 0, 1.5)`

Source:
- `src/swarm_brain/modules/GeoResonanceProtectionEngine.mo`

Bindings:
- Law IDs: `LAW-THREAT-CONTAINMENT`
- Model IDs: `R-MODEL-GRPE-STATE`
- Gate impact: Gate A, Gate C

---

### EQ-MT-CONT-07: Memory temple continuity weave

Equation:
- `driftAbs = clamp(abs(jDrift), 0, 1)`
- `continuityRaw = clamp(0.26*rSwarm + 0.20*doctrineCompliance + 0.18*(1-driftAbs) + 0.18*heartbeatCoherence + 0.18*memoryCognitionCoupling_{t-1}, 0, 1.5)`
- `continuityWeave_t = clamp(0.82 * continuityWeave_{t-1} + 0.18 * continuityRaw, 0, 1.5)`

Source:
- `src/swarm_brain/modules/MemoryTempleEngine.mo`

Bindings:
- Law IDs: `LAW-NO-DROP-CONTINUITY`, `LAW-MEMORY-TEMPLE`
- Model IDs: `R-MODEL-MEMORY-TEMPLE-STATE`
- Gate impact: Gate A

---

### EQ-MT-COUPLE-08: Memory-cognition coupling

Equation:
- `resonanceRaw = clamp(0.28*cardioCerebralResonance + 0.24*cardioNeuralCoupling + 0.16*heartbeatCoherence + 0.16*emotionalEmbodiment + 0.16*continuityWeave_t, 0, 1.5)`
- `resonanceField_t = clamp(0.80 * resonanceField_{t-1} + 0.20 * resonanceRaw, 0, 1.5)`
- `retentionRaw = clamp(0.32*continuityWeave_t + 0.26*resonanceField_t + 0.18*qsovScore + 0.14*doctrineCompliance + 0.10*analystLearningScore, 0, 1.5)`
- `memoryRetention_t = clamp(0.84 * memoryRetention_{t-1} + 0.16 * retentionRaw, 0, 1.5)`
- `couplingRaw = clamp(0.30*resonanceField_t + 0.22*memoryRetention_t + 0.20*cognitiveLoad + 0.15*cardioNeuralCoupling + 0.13*rSwarm, 0, 1.5)`
- `memoryCognitionCoupling_t = clamp(0.82 * memoryCognitionCoupling_{t-1} + 0.18 * couplingRaw, 0, 1.5)`

Source:
- `src/swarm_brain/modules/MemoryTempleEngine.mo`

Bindings:
- Law IDs: `LAW-MEMORY-COGNITION-COUPLING`
- Model IDs: `R-MODEL-MEMORY-TEMPLE-STATE`
- Gate impact: Gate A, Gate B

---

### EQ-MT-IOT-09: IoT and phantom integrity

Equation:
- `deviceNorm = clamp(connectedDeviceCount / 128, 0, 1)`
- `iotRaw = clamp(0.34*deviceNorm + 0.20*memoryCognitionCoupling_t + 0.18*continuityWeave_t + 0.16*geoProtectionScore + 0.12*(1-0.5*geoThreatScore), 0, 1.5)`
- `iotCouplingScore_t = clamp(0.80 * iotCouplingScore_{t-1} + 0.20 * iotRaw, 0, 1.5)`
- `phantomIntegrity_t = clamp(0.84 * phantomIntegrity_{t-1} + 0.16*(0.36*doctrineCompliance + 0.22*geoProtectionScore + 0.20*(1-0.5*geoThreatScore) + 0.12*(1-driftAbs) + 0.10*deviceTwinIntegrity_t), 0, 1.5)`

Source:
- `src/swarm_brain/modules/MemoryTempleEngine.mo`

Bindings:
- Law IDs: `LAW-PHANTOM-INTEGRITY`, `LAW-IOT-COUPLING-BOUNDARY`
- Model IDs: `R-MODEL-MEMORY-TEMPLE-STATE`
- Gate impact: Gate B, Gate C

---

## 3) Constant anchors

- `phi` and related constants remain anchored in parity artifacts:
  - `src/swarm_brain/phi.mo`
  - `src/frontend/src/phi.ts`
- Circular constants:
  - `PI = 3.141592653589793...`
  - `TAU = 2*PI`
- Stabilization constants:
  - `EPS = 1e-7` for division-safe normalization paths

---

## 4) Replay requirement

For each equation family:
1. Persist prior and current state values used in smoothing terms.
2. Persist any bounded normalization terms (e.g., `deviceNorm`, `driftAbs`).
3. Keep model snapshot IDs and beat index to allow replay reconstruction.

Without replay fields, equation evolution claims are non-verifiable.
