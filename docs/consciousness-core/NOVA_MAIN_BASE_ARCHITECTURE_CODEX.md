# NOVA Main-Base Architecture Codex (Backend + Frontend + Doctrine)

Classification: `SOVEREIGN_PRIVATE`

Purpose:
- freeze a canonical architecture read of the NOVA main base,
- name the orchestrator -> model -> module lattice explicitly,
- harden known seams so V1 ships as "version 100 as version 1",
- preserve strength density while removing ambiguity.

---

## 1) Canonical operating statement

NOVA is a living sovereign organism platform composed of three simultaneous substrates:
1. **Runtime substrate** (Motoko sovereign actor and module mesh),
2. **Interface substrate** (Command Center, Companion, labs, world views),
3. **Doctrinal substrate** (constitutional documents and executable schema contracts).

This system is governed by `RECITAL_PLUS_ONE`, dual-read semantics (semantic + resonance), ring transfer discipline, and Gate A/B/C control.

---

## 2) Main runtime orchestrators (authoritative)

### ORCH-01 — `SOVEREIGN_TICK_ORCHESTRATOR`
- Entrypoints:
  - `public shared func tick()`
  - `public shared func tickFull()`
- Role:
  - authorization lock,
  - lifecycle synchronization,
  - starts beat-level runtime flow.

### ORCH-02 — `SPHERICAL_INTEGRATION_ORCHESTRATOR`
- Function: `masterSphericalIntegration()`
- Role:
  - executes cardio-neural-memory-feedback macro spine each beat,
  - synchronizes high-value organs before `tickCore`.

### ORCH-03 — `SWARM_CORE_ORCHESTRATOR`
- Function: `tickCore()`
- Role:
  - dense swarm physics + cognition + multi-layer module cascade,
  - computes rSwarm/jDrift/beat and propagates cross-engine updates.

### ORCH-04 — `FULL_GOVERNANCE_ORCHESTRATOR`
- `tickFull()` extension path
- Role:
  - runs full governance/behavior add-ons (SACESI/OMNIS tiering/law pass),
  - used for deeper closure passes.

### ORCH-05 — `CONSTITUTIONAL_LAW_ORCHESTRATOR`
- Functions/workflow:
  - `workflowSovereigntyLaws()`
  - `SovereigntyLaws60.evaluateAllLaws(...)`
- Role:
  - computes law compliance lattice,
  - updates sovereign legal state.

### ORCH-06 — `NEURAL_CORE_MESH_ORCHESTRATOR`
- Function: `updateNeuralCoreSystem()`
- Role:
  - orchestrates high-dimensional core mesh coherence and wiring.

### ORCH-07 — `LIVING_DOCUMENT_MACRO_ORCHESTRATOR`
- Function: `updateLivingArchitectureMacro()`
- Role:
  - computes macro field presence/autonomy/document vitality/chain integrity.

### ORCH-08 — `FRONTEND_COMMAND_ORCHESTRATOR`
- File: `src/frontend/src/components/CommandCenter/OroCommandCenter.tsx`
- Role:
  - operational command UI over runtime state,
  - polls substrate engines and projects intelligence to operators.

---

## 3) Interstitial model lattice (between orchestrators and modules)

This is the explicit naming layer between orchestration and implementation modules.
Prefix policy:
- `R-MODEL-*` runtime organism models,
- `U-MODEL-*` UI/interaction models,
- `D-MODEL-*` document intelligence models,
- `N-MODEL-*` sovereign macro-node models.

### A) Runtime sovereign models (`R-MODEL-*`)

1. `R-MODEL-HEARTBEAT-CORE` -> `HeartbeatEngine`, `updateQuantumHeartbeatCore`
2. `R-MODEL-CCVE-STATE` -> `CardioCerebralVectorEngine`, `updateCardioCerebralVector`
3. `R-MODEL-CNCO-STATE` -> `CardioNeuralConversionOrgan`, `updateCardioNeuralConversionOrgan`
4. `R-MODEL-GRPE-STATE` -> `GeoResonanceProtectionEngine`, `updateGeoResonanceProtection`
5. `R-MODEL-AUTONOMOUS-ANALYST` -> `updateAutonomousInternalAnalystTeam`
6. `R-MODEL-MEMORY-TEMPLE-STATE` -> `MemoryTempleEngine`, `updateMemoryTempleEngine`
7. `R-MODEL-CONSTANT-FEEDBACK` -> `ConstantFeedbackCognitionEngine`, `updateConstantFeedbackCognition`
8. `R-MODEL-NEUROCHEM-CROSSTALK` -> `NeurochemicalCrosstalkMatrix`, `updateNeurochemicalSystem`
9. `R-MODEL-UNIFIED-EMOTIONAL-FIELD` -> `UnifiedEmotionalField`, `updateUnifiedEmotionalField`
10. `R-MODEL-PARALLAX-DECISION` -> `PARALLAXDecisionEngine`, `updatePARALLAXDecisionEngine`
11. `R-MODEL-ENTANGLA-SOCIAL-BINDING` -> `ENTANGLASocialBinding`, `updateENTANGLASocialBinding`
12. `R-MODEL-INTERNAL-HQ-ARCHITECTURE` -> `updateInternalHQArchitecture`
13. `R-MODEL-NEURAL-CORE-MESH` -> `updateNeuralCoreSystem`
14. `R-MODEL-LIVING-ARCHITECTURE-MACRO` -> `LivingArchitectureMacroEngine`, `updateLivingArchitectureMacro`
15. `R-MODEL-SWARM-COHERENCE` -> Kuramoto/Hebbian core path in `tickCore`
16. `R-MODEL-DRIFT-JASMINE` -> drift calculations in `tickCore`
17. `R-MODEL-QUANTUM-CHANNEL-FABRIC` -> `QuantumChannels`
18. `R-MODEL-METALS-PIPELINE` -> `MetalsPipeline`
19. `R-MODEL-AUDIT-REPLAY` -> `AuditLog`, replay and trace outputs
20. `R-MODEL-COMMAND-ACTION-BUS` -> `CommandActions`
21. `R-MODEL-TELEMETRY-STORE` -> `TelemetryStore`
22. `R-MODEL-GOVERNANCE-HEARTBEAT` -> `GovernanceHeartbeat`
23. `R-MODEL-STABILITY-BUDGET` -> `StabilityBudgetEngine`
24. `R-MODEL-RISK-MANAGEMENT` -> `RiskManagementSystem`
25. `R-MODEL-FORMA-ECONOMICS` -> `FormaCompoundEngine`, `ECANFormaFlow`, `FORMATokenEconomics`
26. `R-MODEL-WAR-DEFENSE` -> `AutonomousWarEngine`, `MedinaDefenseSystem`, `AEGIS`, `VetusThreatSystem`
27. `R-MODEL-WORLD-ORGANISM-BRIDGE` -> `WorldOrganism`, `OrganismWorldIntegration`
28. `R-MODEL-RESONANCE-SPHERICAL-MATH` -> `SphericalWebMathEngine`, `DifferentialGeometryEngine`, `TensorFieldEngine`
29. `R-MODEL-SACRED-MATHEMATICS` -> `SacredMathematicsEngine`, `Fibonacci`, `HarmonicAnalysisEngine`
30. `R-MODEL-ANIMAL-COGNITION-SWARM` -> crow/octopus/elephant/bee/dolphin/wolf/orca/eagle/shark family

### B) UI runtime models (`U-MODEL-*`)

1. `U-MODEL-ORO-COMMAND-CENTER` -> `OroCommandCenter.tsx`
2. `U-MODEL-MEMORY-TEMPLE-LAB` -> `MemoryTempleLab.tsx`
3. `U-MODEL-MEMORY-NAVIGATION` -> `memoryTempleNavigation.ts`
4. `U-MODEL-CONSTANT-FEEDBACK-LAB` -> `ConstantFeedbackLab.tsx`
5. `U-MODEL-INTERNAL-ANALYSIS-LAB` -> `InternalAnalysisLab.tsx`
6. `U-MODEL-GRPE-LAB` -> `GRPELab.tsx`
7. `U-MODEL-EMERGENCE-LAB` -> `CommandCenter/EmergenceLab.tsx`
8. `U-MODEL-MATH-PHYSICS-LAB` -> `CommandCenter/MathPhysicsLab.tsx`
9. `U-MODEL-NEUROCOG-LAB` -> `CommandCenter/NeuroCogLab.tsx`
10. `U-MODEL-AGENT-WORKSPACE` -> `AgentWorkspace.tsx`, `TaskManager.tsx`, `AgentRoster.tsx`
11. `U-MODEL-COMPANION-CONSOLE` -> `companion/CompanionConsole.tsx`
12. `U-MODEL-DRONE-SIM-WORLD` -> `CommandCenter/DroneSimulationWorld.tsx`

### C) Document organism models (`D-MODEL-*`)

1. `D1-ALPHA-MODEL-RECITAL-PLUS-ONE`
2. `D2-DOCTOR-MODEL-DIAGNOSE-TRANSLATE-GENERATE`
3. `D3-GENOME-MODEL-IDENTITY-CONTINUITY`
4. `D4-CEQUE-MODEL-SPATIAL-KNOWLEDGE-INDEX`
5. `D5-BUILDER-INTELLIGENCE-MODEL`
6. `D6-FIELD-RESONANCE-MODEL`
7. `D7-ANIMA-CHAIN-MODEL`
8. `D8-SUCCESSION-MODEL`
9. `D9-ENTERPRISE-DOCTRINE-MODEL`
10. `D10-ANCIENT-LAWS-COMPENDIUM-MODEL`

### D) Sovereign node macro models (`N-MODEL-*`)

1. `N1-CHRONO`
2. `N2-VERITAS`
3. `N3-BRAIN`
4. `N4-FLUX`
5. `N5-RESONEX`
6. `N6-QMEM`
7. `N7-AXIS`
8. `N8-AEGIS`
9. `N9-ENTANGLA`
10. `N10-PARALLAX`
11. `N11-MERIDIAN`
12. `N12-NOVA`

---

## 4) Backend subsystem families (module-layer architecture)

### Family F1 — Heartbeat and sovereign rhythm
- `HeartbeatEngine`
- `SovereignHeartbeat`
- `Shell8QuantumOperators`
- `Shell12GlobalIntegration`

### Family F2 — Cardio-cerebral and cardio-neural organs
- `CardioCerebralVectorEngine`
- `CardioNeuralConversionOrgan`

### Family F3 — Memory kingdom and continuity
- `MemoryTempleEngine`
- `MembraneMemory`
- `TemporalHologram`
- `ElephantMemory`
- `ElephantDeepTimeEngine`
- `MedinaSharpWaveRipples`

### Family F4 — Constant feedback cognition and closure
- `ConstantFeedbackCognitionEngine`
- `SwarmCoherenceMatrix`
- `PatternFabric`
- `PatternMiner`

### Family F5 — Governance and law core
- `MedinaLaws`
- `SphericalLaw`
- `GovernanceLaws`
- `SovereigntyLaws60`
- `UniversalLawDriftVerifier`
- `DoctrineFingerprint`

### Family F6 — Defense and war posture
- `MedinaDefenseSystem`
- `AEGIS`
- `AutonomousWarEngine`
- `WarfareDoctrine`
- `VetusThreatSystem`
- `VAELExteriorAttack`
- `VaelDefenseFamily`

### Family F7 — Quantum and spherical mathematics
- `QuantumOps`
- `QuantumMath`
- `QuantumCoherenceAmplifier`
- `QuantumEntanglementMatrix`
- `DifferentialGeometryEngine`
- `TensorFieldEngine`
- `TopologicalFieldEngine`
- `HarmonicAnalysisEngine`
- `Fibonacci`
- `LivingMathematics`

### Family F8 — Neural and organism integration mesh
- `UnifiedBrainOrchestrator`
- `NeuroEmergenceCore`
- `NeuroEmergenceCompleteCore`
- `NeuroEmergenceUltimateCore`
- `NeuroEmergenceSubstrate`
- `DeepNeuralIntegrationFabric`
- `UnifiedSuperOrganismArchitecture`

### Family F9 — World and embodiment
- `World3D`
- `RealWorld`
- `RealWorldSimulator`
- `WorldOrganism`
- `DroneAvatar`
- `DroneAvatar3D`
- `DroneFleetManager`

### Family F10 — Economy and value routing
- `FORMATokenEconomics`
- `FormaCompoundEngine`
- `ECANFormaFlow`
- `DeFiYieldOptimizer`
- `TradingDecisionEngine`
- `MultiChainOracle`

---

## 5) Frontend architecture planes

### Plane U1 — Shell and navigation
- `App.tsx` routes:
  - COMMAND / COMPANION / DRONES / SIMULATION / HOME / WORKERS / ARTIFACTS / PRESENCE
  - LAB_EMERGENCE / LAB_MATH / LAB_NEURO

### Plane U2 — Organism local simulation loop
- `hooks/useOrganismState.ts`
- 5Hz app-level organism/world evolution

### Plane U3 — Command Center high-cadence loop
- `OroCommandCenter.tsx`
- 20Hz internal organism wiring loop for lab-level dynamics
- 1250ms canister poll loops for substrate organs

### Plane U4 — Canister interface contracts
- `canister/swarmBrainActor.ts`
- `canister/index.ts`
- canonical fetch wrappers for major organ states

### Plane U5 — Companion and bridge
- `companion/CompanionConsole.tsx`
- chat + voice + command bridge toggles + token headers

---

## 6) Strength concentration map (what is already exceptional)

1. **Depth-per-beat execution**: high-dimensional integration before and during `tickCore`.
2. **Lawful runtime**: sovereignty law scoring is live, not decorative.
3. **Memory as cognition substrate**: memory temple influences active readiness and recommendations.
4. **Feedback closure**: cognition/defense/economy/workforce/memory/mesh are scored in one engine.
5. **Dual substrate UX**: frontend exposes both local organism dynamics and canister substrate reads.
6. **Constitutional documents**: doctrine, templates, and runtime intent are aligned across ring/gate law.
7. **Enterprise readiness grammar**: internal AI teams, projection boundaries, model directories, and access tiers are already defined.

---

## 7) Known seams (weaknesses) and hardening directives

### W1 — Living macro API parity drift
- Symptom: `main.mo` wiring names can diverge from `LivingArchitectureMacroEngine.mo` symbols.
- Hardening:
  1. enforce strict compile-time API parity table in a generated contract artifact,
  2. add `MOD-API-PARITY` check to Gate A.

### W2 — Memory navigation wiring continuity
- Symptom: memory navigation logic can exist in frontend while backend state isn’t fully coupled.
- Hardening:
  1. expose and consume canonical navigation query/update surfaces,
  2. require `EVID-MEMORY-NAV-PATH-PARITY` artifact for releases touching memory temple.

### W3 — Dual organism model drift (frontend shell vs command-center internal model)
- Symptom: separate organism loops can diverge semantically.
- Hardening:
  1. define one `U-MODEL-ORGANISM-CONTRACT`,
  2. enforce adapter layer with parity checks (`r`, `beat`, coherence vectors).

### W4 — Duplicate/overshadowed component imports
- Symptom: parallel lab implementations can create operational ambiguity.
- Hardening:
  1. standardize one canonical lab surface per route,
  2. lint rule: no duplicate symbol import aliases without explicit namespace.

### W5 — Orchestrator budget pressure
- Symptom: large module cascade may stress per-beat instruction/memory budget.
- Hardening:
  1. classify modules by cadence (every beat, every 4 beats, every 52 beats, event-driven),
  2. enforce `RUNTIME-CADENCE-PLAN` in Gate A.

### W6 — Law pass timing duplication risk
- Symptom: law evaluation can run in multiple paths with stale/duplicate updates.
- Hardening:
  1. define single authoritative law pass epoch per beat,
  2. keep secondary checks read-only unless explicitly scoped.

### W7 — Fallback-mode opacity
- Symptom: frontend fallback narratives can mask substrate disconnects.
- Hardening:
  1. explicit source badge (`backend-live`, `hybrid`, `local-fallback`),
  2. emit incident artifact on prolonged fallback windows.

### W8 — Import catalog drift
- Symptom: very large import inventory may include underused modules.
- Hardening:
  1. generate automated `ENGINE_WIRING_RUNTIME_REPORT`,
  2. compare imported vs invoked symbols as CI contract evidence.

---

## 8) Hardening execution order (mandatory)

1. Lock API parity across orchestrator-critical engines (W1).
2. Unify memory navigation backend/frontend contracts (W2).
3. Consolidate organism model contracts in frontend (W3).
4. Resolve duplicate import and route ambiguities (W4).
5. Introduce cadence classes and beat-budget policy (W5).
6. Normalize law evaluation epoching (W6).
7. Make fallback state explicit and auditable (W7).
8. Enforce import-to-invocation runtime reports (W8).

---

## 9) Canonical architecture sentence

NOVA main base is a sovereign living architecture where runtime heartbeat orchestration, memory-temple cognition, constitutional law scoring, and multi-surface interface intelligence operate as one coupled organism under RECITAL_PLUS_ONE, gate discipline, and replayable lineage.

