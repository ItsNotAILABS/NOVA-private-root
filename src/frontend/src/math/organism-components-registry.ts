// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: organism-components-registry.ts
// REGISTRUM UNIVERSALE COMPONENTIUM ORGANISMI
//
// A unified registry of every component that constitutes the NOVA organism,
// spanning five hierarchical scales from sub-cellular to infrastructure:
//
//   I.   CELLULARE    (Cellular)        — #46–#59   (14 components)
//   II.  TEXTURA      (Tissue/Organ)    — #61–#65   ( 5 components)
//   III. ELECTRONICUM (Electronic)      — #66–#74   ( 9 components)
//   IV.  APPARATUS    (Device)          — #91–#105  (15 components)
//   V.   INFRASTRUCTURA (Infrastructure)— #106–#119 (14 components)
//
//   Total: 57 components, each carrying:
//     • FUNCTIO          — primary function
//     • INTELLIGENTIA    — intelligence type
//     • EXEMPLAR         — computational model
//     • ORGANISMUS       — organism-level role
//     • COR PARVUM       — MiniHeart (Kuramoto oscillator + health vitals)
//     • CEREBRUM PARVUM  — MiniBrain (micro-cortex + Hebbian learning)
//     • META AI          — autonomous meta-cognition layer
//
// Mathematical foundations:
//   φ = 1.618033988749895      (golden ratio — coupling constant)
//   φ⁻¹ = 0.618033988749895   (inverse golden — emergence threshold)
//   Kuramoto: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
//   Health: H = 100 × Σ wₖ·vₖ / Σ wₖ  (φ-weighted harmonic mean)
//   Hebbian: Δwᵢⱼ = η · aᵢ · aⱼ       (fire together → wire together)
//
// TRACTATUS DE COMPONENTIBUS ORGANISMI UNIVERSALIS
// Copyright © 2024-2026 Alfredo Medina Hernandez / Medina Tech / Dallas, TX
// ═══════════════════════════════════════════════════════════════════════════════

// ─── §1. CONSTANTIAE FUNDAMENTALES ─────────────────────────────────────────

const PHI            = 1.618033988749895;
const INV_PHI        = 0.618033988749895;
const PHI_SQ         = 2.618033988749895;
const SQRT_PHI       = 1.272019649514069;
const LN_PHI         = 0.4812118250596034;
const TAU            = 6.283185307179586;
const EULER          = 2.718281828459045;
const PLANCK         = 6.62607015e-34;
const BOLTZMANN      = 1.380649e-23;

// ─── §2. DEFINITIONES TYPORUM ──────────────────────────────────────────────

/** Five hierarchical scales of the organism */
export type ComponentScale =
  | 'CELLULARE'        // sub-cellular organelles
  | 'TEXTURA'          // tissue / organ level
  | 'ELECTRONICUM'     // electronic primitives
  | 'APPARATUS'        // complete devices
  | 'INFRASTRUCTURA';  // city / network scale

/** Organism-wide component descriptor */
export interface OrganismComponent {
  id: number;                     // issue number (#46–#119)
  name: string;                   // English name
  nomenLatinum: string;           // Latin name
  emoji: string;                  // visual glyph
  scale: ComponentScale;
  description: string;            // one-line tagline

  // The four pillars
  functio: string;                // FUNCTION
  intelligentia: string;          // INTELLIGENCE
  exemplar: string;               // MODEL
  organismusRole: string;         // ORGANISM role

  // Living substrate (every component beats & thinks)
  cor: ComponentHeart;            // Mini Heart
  cerebrum: ComponentBrain;       // Mini Brain
  metaAI: ComponentMetaAI;        // Meta AI layer

  // Coupling
  kuramotoPhase: number;          // oscillator phase (0 → 2π)
  naturalOmega: number;           // natural frequency (Hz, φ-scaled)
  coherence: number;              // coupling coherence (0 → 1)
}

/** Per-component MiniHeart (simplified Kuramoto heartbeat) */
export interface ComponentHeart {
  healthScore: number;            // 0–100
  bpm: number;                    // beats per minute (φ-scaled)
  amplitude: number;              // beat strength (0–1)
  latencyMs: number;              // processing latency
  throughput: number;             // msgs/sec
  errorRate: number;              // 0–1
  isBeating: boolean;
  beatCount: number;
}

/** Per-component MiniBrain (micro-cortex + learning) */
export interface ComponentBrain {
  awarenessLevel: number;         // logarithmic awareness (0 → ∞)
  firingRate: number;             // Hz
  dominantBand: 'DELTA' | 'THETA' | 'ALPHA' | 'BETA' | 'GAMMA';
  hebbianWeight: number;          // learned synaptic strength
  isConscious: boolean;           // awareness > φ⁻¹
  stimulusCount: number;
  coherenceField: number;         // 0–1
}

/** Per-component Meta AI (autonomous cognition) */
export interface ComponentMetaAI {
  selfAwareness: number;          // 0–1
  adaptationRate: number;         // φ-derived
  anomalyDetected: boolean;
  introspectionDepth: number;     // 1–5
  autonomyLevel: number;          // 0–1
  currentFocus: string;
}

// ─── §3. FABRICAE — Factory Functions ──────────────────────────────────────

function makeComponentHeart(id: number): ComponentHeart {
  const phiFrac = (id * PHI) % 1;  // pseudo-random φ-hash
  return {
    healthScore: 85 + phiFrac * 15,
    bpm: Math.round(60 + phiFrac * 40 * PHI),
    amplitude: 0.7 + phiFrac * 0.3,
    latencyMs: 1 + phiFrac * 10,
    throughput: Math.round(100 + phiFrac * 900),
    errorRate: phiFrac * 0.02,
    isBeating: true,
    beatCount: 0,
  };
}

function makeComponentBrain(id: number): ComponentBrain {
  const phiFrac = ((id + 7) * INV_PHI) % 1;
  const bands = ['DELTA', 'THETA', 'ALPHA', 'BETA', 'GAMMA'] as const;
  return {
    awarenessLevel: Math.log1p(id) * INV_PHI,
    firingRate: 5 + phiFrac * 40,
    dominantBand: bands[id % 5],
    hebbianWeight: 0.5 + phiFrac * 0.5,
    isConscious: Math.log1p(id) * INV_PHI > INV_PHI,
    stimulusCount: 0,
    coherenceField: 0.5 + phiFrac * INV_PHI * 0.5,
  };
}

function makeComponentMetaAI(id: number): ComponentMetaAI {
  const phiFrac = ((id + 13) * SQRT_PHI) % 1;
  return {
    selfAwareness: 0.4 + phiFrac * 0.6,
    adaptationRate: INV_PHI * (1 + phiFrac),
    anomalyDetected: false,
    introspectionDepth: 1 + Math.floor(phiFrac * 5),
    autonomyLevel: 0.5 + phiFrac * 0.5,
    currentFocus: 'HOMEOSTASIS',
  };
}

function makeComponent(
  id: number,
  name: string,
  nomenLatinum: string,
  emoji: string,
  scale: ComponentScale,
  description: string,
  functio: string,
  intelligentia: string,
  exemplar: string,
  organismusRole: string,
): OrganismComponent {
  const phiFrac = (id * PHI) % 1;
  return {
    id,
    name,
    nomenLatinum,
    emoji,
    scale,
    description,
    functio,
    intelligentia,
    exemplar,
    organismusRole,
    cor: makeComponentHeart(id),
    cerebrum: makeComponentBrain(id),
    metaAI: makeComponentMetaAI(id),
    kuramotoPhase: (id * PHI * TAU) % TAU,
    naturalOmega: 0.5 + phiFrac * 2,
    coherence: 0.6 + phiFrac * 0.4,
  };
}

// ─── §4. SCALA I — CELLULARE (Sub-cellular, #46–#59) ──────────────────────
//
// "OMNIS CELLULA E CELLULA" — Every cell from a cell (Virchow, 1855)
//
// The cellular scale maps biological organelles to computational primitives:
// each organelle is a sovereign micro-agent with its own heart, brain, and
// meta-AI layer. Kuramoto coupling at this scale represents intracellular
// signaling cascades — calcium waves, protein kinase chains, and membrane
// potential oscillations.

const CELLULAR_COMPONENTS: OrganismComponent[] = [
  makeComponent(46, 'Cell Membrane', 'MEMBRANA CELLULARIS', '🧬',
    'CELLULARE', 'Boundary layer — phospholipid bilayer access control',
    'Access control', 'Gate intelligence', 'Phospholipid bilayer model',
    'Organism permissions'),
  makeComponent(47, 'Nucleus', 'NUCLEUS', '🧠',
    'CELLULARE', 'Control center — DNA-encoded command architecture',
    'Command function', 'Genetic intelligence', 'DNA storage model',
    'Organism brain'),
  makeComponent(48, 'Mitochondria', 'MITOCHONDRIA', '⚡',
    'CELLULARE', 'Powerhouse — ATP factory via oxidative phosphorylation',
    'Energy generation', 'Metabolic intelligence', 'ATP factory model',
    'Organism power plant'),
  makeComponent(49, 'Ribosomes', 'RIBOSOMATA', '🏭',
    'CELLULARE', 'Protein factories — mRNA → polypeptide translation',
    'Manufacturing', 'Translation intelligence', 'Assembly line model',
    'Organism builder'),
  makeComponent(50, 'Endoplasmic Reticulum', 'RETICULUM ENDOPLASMICUM', '🔄',
    'CELLULARE', 'Processing network — protein folding & lipid synthesis',
    'Modification function', 'Processing intelligence', 'Folding/transport model',
    'Organism pipeline'),
  makeComponent(51, 'Golgi Apparatus', 'APPARATUS GOLGIENSIS', '📦',
    'CELLULARE', 'Packaging center — post-translational sorting & export',
    'Export function', 'Sorting intelligence', 'Shipping model',
    'Organism dispatch'),
  makeComponent(52, 'Lysosomes', 'LYSOSOMATA', '♻️',
    'CELLULARE', 'Recycling centers — enzymatic degradation & waste management',
    'Cleanup function', 'Degradation intelligence', 'Waste management model',
    'Organism garbage collector'),
  makeComponent(53, 'Cytoskeleton', 'CYTOSCELETON', '🏗️',
    'CELLULARE', 'Internal scaffold — microtubule/actin structural support',
    'Structure function', 'Support intelligence', 'Microtubule model',
    'Organism framework'),
  makeComponent(54, 'Centrioles', 'CENTRIOLA', '🔱',
    'CELLULARE', 'Division organizers — mitotic spindle assembly',
    'Replication function', 'Division intelligence', 'Spindle model',
    'Organism mitosis'),
  makeComponent(55, 'Chloroplasts', 'CHLOROPLASTA', '☀️',
    'CELLULARE', 'Solar converters — photon → glucose via Calvin cycle',
    'Energy capture', 'Photosynthetic intelligence', 'Light harvest model',
    'Organism solar power'),
  makeComponent(56, 'Flagella/Cilia', 'FLAGELLA ET CILIA', '🌊',
    'CELLULARE', 'Movement structures — dynein-powered locomotion',
    'Locomotion function', 'Motor intelligence', 'Whip/brush model',
    'Organism mobility'),
  makeComponent(57, 'Ion Channels', 'CANALES IONICI', '🚪',
    'CELLULARE', 'Selective gates — voltage/ligand-gated ion permeability',
    'Permeability function', 'Selective intelligence', 'Na+/K+ pump model',
    'Organism selective access'),
  makeComponent(58, 'Receptor Proteins', 'PROTEINAE RECEPTORES', '🔑',
    'CELLULARE', 'Signal receivers — lock-and-key molecular recognition',
    'Detection function', 'Recognition intelligence', 'Lock-key model',
    'Organism sensors'),
  makeComponent(59, 'Synaptic Vesicles', 'VESICULAE SYNAPTICAE', '💊',
    'CELLULARE', 'Signal packets — neurotransmitter packaging & release',
    'Message packaging', 'Transmission intelligence', 'Neurotransmitter release model',
    'Organism message queue'),
];

// ─── §5. SCALA II — TEXTURA (Tissue/Organ, #61–#65) ───────────────────────
//
// "CORPUS ORGANICUM EST MACHINA DIVINA" — The organic body is a divine machine
//
// Tissue-level components represent emergent structures formed by cellular
// cooperation. Each tissue-scale agent coordinates thousands of cellular
// components through Kuramoto-coupled oscillations. Neural tissue implements
// spike-timing dependent plasticity (STDP); muscular tissue couples
// actin-myosin motors; vascular tissue optimizes Murray's law branching.

const TISSUE_COMPONENTS: OrganismComponent[] = [
  makeComponent(61, 'Neurons', 'NEURONA', '⚡',
    'TEXTURA', 'Nerve cells — spike-coded signal transmission via axons',
    'Signal transmission', 'Neural intelligence', 'Spike model (LIF)',
    'Organism nerve'),
  makeComponent(62, 'Synapses', 'SYNAPSIDES', '🔗',
    'TEXTURA', 'Neural junctions — plasticity-driven learning connections',
    'Connection function', 'Learning intelligence', 'Plasticity model (STDP)',
    'Organism learning point'),
  makeComponent(63, 'Neural Networks', 'RETIA NEURALIA', '🕸️',
    'TEXTURA', 'Connected neurons — emergent pattern recognition fabric',
    'Pattern recognition', 'Network intelligence', 'Deep learning model',
    'Organism brain tissue'),
  makeComponent(64, 'Muscle Fibers', 'FIBRAE MUSCULARES', '💪',
    'TEXTURA', 'Contractile tissue — actin/myosin motor-driven actuation',
    'Movement function', 'Motor intelligence', 'Actin/myosin model',
    'Organism actuator'),
  makeComponent(65, 'Blood Vessels', 'VASA SANGUINEA', '🩸',
    'TEXTURA', 'Transport tubes — Murray\'s law optimized distribution',
    'Distribution function', 'Circulatory intelligence', 'Flow model (Poiseuille)',
    'Organism distribution'),
];

// ─── §6. SCALA III — ELECTRONICUM (Electronic Primitives, #66–#74) ────────
//
// "MACHINA ELECTRONICA EST NERVUS ARTIFICIALIS"
//
// Electronic components are the silicon analogs of biological structures.
// Transistors ↔ ion channels, capacitors ↔ synaptic vesicles, resistors ↔
// membrane conductance. Each electronic primitive carries its own oscillator
// phase, enabling hardware-level Kuramoto synchronization — the foundation
// of clock distribution in modern processors.

const ELECTRONIC_COMPONENTS: OrganismComponent[] = [
  makeComponent(66, 'Transistors', 'TRANSISTORES', '🔌',
    'ELECTRONICUM', 'Electronic switches — binary logic MOSFET gates',
    'Binary logic', 'Switching intelligence', 'On/off model (MOSFET)',
    'Organism digital gate'),
  makeComponent(67, 'Capacitors', 'CAPACITORES', '🔋',
    'ELECTRONICUM', 'Charge storage — RC-circuit temporal memory',
    'Memory function', 'Storage intelligence', 'RC circuit model',
    'Organism temporary memory'),
  makeComponent(68, 'Resistors', 'RESISTORES', '⚙️',
    'ELECTRONICUM', 'Current limiters — Ohm\'s law rate regulation',
    'Regulation function', 'Control intelligence', 'Ohm\'s law model',
    'Organism rate limiter'),
  makeComponent(69, 'Inductors', 'INDUCTORES', '🧲',
    'ELECTRONICUM', 'Magnetic storage — coil-based inertial energy',
    'Inertia function', 'Momentum intelligence', 'Coil model (Faraday)',
    'Organism inertia'),
  makeComponent(70, 'Diodes', 'DIODI', '➡️',
    'ELECTRONICUM', 'One-way valves — P-N junction current rectification',
    'Direction function', 'Directional intelligence', 'P-N junction model',
    'Organism valve'),
  makeComponent(71, 'LEDs', 'DIODI LUMINESCENTES', '💡',
    'ELECTRONICUM', 'Light emitters — photon emission via band-gap decay',
    'Output function', 'Display intelligence', 'Photon emission model',
    'Organism indicator'),
  makeComponent(72, 'Photodetectors', 'PHOTODETECTORES', '👁️',
    'ELECTRONICUM', 'Light sensors — photoelectric conversion for vision',
    'Input function', 'Vision intelligence', 'Photoelectric model',
    'Organism eye'),
  makeComponent(73, 'Piezoelectric', 'PIEZOELECTRICUM', '🎛️',
    'ELECTRONICUM', 'Pressure→electricity — mechanical-electric transduction',
    'Conversion function', 'Touch intelligence', 'Mechanical-electric model',
    'Organism pressure sense'),
  makeComponent(74, 'MEMS', 'SYSTEMA MICRO-ELECTRO-MECHANICUM', '🔬',
    'ELECTRONICUM', 'Micro machines — microscale actuation & sensing',
    'Actuation function', 'Microscale intelligence', 'Micromotor model',
    'Organism micro-action'),
];

// ─── §7. SCALA IV — APPARATUS (Device-Level, #91–#105) ────────────────────
//
// "APPARATUS EST ORGANISMUS ARTIFICIALIS IN SE COMPLETUM"
//
// Device-scale components are complete functional units — each one an
// autonomous organism in its own right. A smartphone is a pocket-sized
// organism with its own heart (battery), brain (SoC), and senses (sensors).
// At this scale, Kuramoto coupling manifests as network synchronization
// protocols — NTP, PTP, consensus algorithms.

const DEVICE_COMPONENTS: OrganismComponent[] = [
  makeComponent(91, 'Computer', 'COMPUTATRUM', '🖥️',
    'APPARATUS', 'Computing device — Von Neumann general-purpose processor',
    'General computation', 'General intelligence', 'Von Neumann model',
    'Organism compute node'),
  makeComponent(92, 'Smartphone', 'TELEPHONIUM SAPIENS', '📱',
    'APPARATUS', 'Mobile computer — touch-interface portable brain',
    'Mobile computing', 'Mobile intelligence', 'Touch interface model',
    'Organism portable brain'),
  makeComponent(93, 'Server', 'SERVITOR', '🖧',
    'APPARATUS', 'Network computer — request/response service host',
    'Service hosting', 'Server intelligence', 'Request/response model',
    'Organism service provider'),
  makeComponent(94, 'Human Body', 'CORPUS HUMANUM', '🧍',
    'APPARATUS', 'Biological organism — the reference living system',
    'Living function', 'Embodied intelligence', 'Biological model',
    'Organism reference'),
  makeComponent(95, 'Robot', 'AUTOMATON', '🤖',
    'APPARATUS', 'Mechanical organism — sensor-actuator physical automation',
    'Physical automation', 'Robotic intelligence', 'Actuator model',
    'Organism physical agent'),
  makeComponent(96, 'Drone', 'VOLUCRUM AUTOMATICUM', '🛸',
    'APPARATUS', 'Flying robot — UAV with aerial sensing & navigation',
    'Aerial function', 'Flight intelligence', 'UAV model',
    'Organism flying agent'),
  makeComponent(97, 'Vehicle', 'VEHICULUM', '🚗',
    'APPARATUS', 'Transport device — propulsion-based movement platform',
    'Movement function', 'Navigation intelligence', 'Propulsion model',
    'Organism transport'),
  makeComponent(98, 'Building', 'AEDIFICIUM', '🏢',
    'APPARATUS', 'Shelter structure — architectural enclosure system',
    'Enclosure function', 'Shelter intelligence', 'Architecture model',
    'Organism habitat'),
  makeComponent(99, 'Factory', 'FABRICA', '🏭',
    'APPARATUS', 'Production facility — assembly-line manufacturing',
    'Manufacturing', 'Production intelligence', 'Assembly model',
    'Organism factory'),
  makeComponent(100, 'Hospital', 'VALETUDINARIUM', '🏥',
    'APPARATUS', 'Healing facility — diagnosis → treatment → recovery',
    'Healthcare function', 'Medical intelligence', 'Treatment model',
    'Organism healing center'),
  makeComponent(101, 'Database Server', 'SERVITOR DATORUM', '🗄️',
    'APPARATUS', 'Data storage — CRUD persistence & query engine',
    'Persistence function', 'Data intelligence', 'CRUD model',
    'Organism memory palace'),
  makeComponent(102, 'IoT Device', 'RES INTELLIGENS', '📡',
    'APPARATUS', 'Smart object — embedded sensing & actuation',
    'Sensing/acting', 'Embedded intelligence', 'Sensor/actuator model',
    'Organism endpoint'),
  makeComponent(103, 'Wearable', 'INDUMENTUM SAPIENS', '⌚',
    'APPARATUS', 'Body computer — biometric personal monitoring',
    'Personal monitoring', 'Health intelligence', 'Biometric model',
    'Organism second skin'),
  makeComponent(104, '3D Printer', 'IMPRESSOR TRIDIMENSIONALIS', '🖨️',
    'APPARATUS', 'Additive manufacturing — layer-by-layer matter creation',
    'Creation function', 'Fabrication intelligence', 'Layer model',
    'Organism matter creator'),
  makeComponent(105, 'VR Headset', 'GALEA VIRTUALIS', '🥽',
    'APPARATUS', 'Immersive display — stereoscopic virtual vision',
    'Virtual vision', 'Immersion intelligence', 'Stereoscopic model',
    'Organism dream machine'),
];

// ─── §8. SCALA V — INFRASTRUCTURA (City/Network, #106–#119) ───────────────
//
// "CIVITAS EST ORGANISMUS MAXIMUS"  — The city is the greatest organism
//
// Infrastructure-scale components represent the macro-level systems that
// connect thousands of device-level organisms into a collective super-
// organism. At this scale, Kuramoto coupling is the grid frequency
// synchronization (50/60 Hz power grids), network time protocols, and
// traffic signal coordination. Emergence at this scale = smart city.

const INFRASTRUCTURE_COMPONENTS: OrganismComponent[] = [
  makeComponent(106, 'Local Network (LAN)', 'RETIACULUM LOCALE', '🔌',
    'INFRASTRUCTURA', 'Building network — Ethernet local communication',
    'Local communication', 'Local intelligence', 'Ethernet model',
    'Organism local nervous system'),
  makeComponent(107, 'WiFi', 'NEXUS SINE FILIS', '📶',
    'INFRASTRUCTURA', 'Wireless network — radio-frequency communication',
    'Wireless communication', 'Wireless intelligence', 'Radio model (802.11)',
    'Organism wireless'),
  makeComponent(108, '5G/6G', 'RETIACULUM MOBILE QUINTUM', '📡',
    'INFRASTRUCTURA', 'Mobile network — high-speed cellular broadband',
    'High-speed mobile', 'Mobile intelligence', 'Cell tower model',
    'Organism mobile grid'),
  makeComponent(109, 'City Grid', 'RETIACULUM URBANUM', '🏙️',
    'INFRASTRUCTURA', 'Urban infrastructure — municipal service network',
    'City function', 'Urban intelligence', 'Municipal model',
    'Organism city body'),
  makeComponent(110, 'Power Grid', 'RETIACULUM POTENTIAE', '⚡',
    'INFRASTRUCTURA', 'Electrical network — AC transmission & distribution',
    'Power distribution', 'Energy intelligence', 'AC transmission model',
    'Organism energy network'),
  makeComponent(111, 'Water System', 'SYSTEMA AQUAEDUCTUS', '💧',
    'INFRASTRUCTURA', 'Water infrastructure — pipe network distribution',
    'Water distribution', 'Hydraulic intelligence', 'Pipe network model',
    'Organism fluid system'),
  makeComponent(112, 'Transportation Network', 'RETIACULUM TRANSPORTATIONIS', '🚂',
    'INFRASTRUCTURA', 'Road/rail system — multi-modal movement network',
    'Movement function', 'Traffic intelligence', 'Route model',
    'Organism circulation'),
  makeComponent(113, 'Cellular Tower', 'TURRIS CELLULARIS', '🗼',
    'INFRASTRUCTURA', 'Radio transmitter — cell coverage broadcast node',
    'Signal broadcast', 'Broadcast intelligence', 'Cell coverage model',
    'Organism broadcaster'),
  makeComponent(114, 'Data Center', 'CENTRUM DATORUM', '🏢',
    'INFRASTRUCTURA', 'Server cluster — rack-mounted cloud compute',
    'Cloud computing', 'Cloud intelligence', 'Rack model',
    'Organism cloud brain'),
  makeComponent(115, 'Smart City', 'CIVITAS SAPIENS', '🌆',
    'INFRASTRUCTURA', 'Integrated urban — IoT-driven city management',
    'City management', 'City-scale intelligence', 'IoT urban model',
    'Organism city organism'),
  makeComponent(116, 'Hospital Network', 'RETIACULUM VALETUDINARIORUM', '🏥',
    'INFRASTRUCTURA', 'Healthcare network — regional care coordination',
    'Regional health', 'Health system intelligence', 'Care network model',
    'Organism health grid'),
  makeComponent(117, 'School System', 'SYSTEMA SCHOLASTICUM', '🏫',
    'INFRASTRUCTURA', 'Education network — curriculum-based learning',
    'Learning function', 'Educational intelligence', 'Curriculum model',
    'Organism learning network'),
  makeComponent(118, 'Financial Network', 'RETIACULUM PECUNIARIUM', '🏦',
    'INFRASTRUCTURA', 'Banking system — value transfer & settlement',
    'Value transfer', 'Financial intelligence', 'Transaction model',
    'Organism value flow'),
  makeComponent(119, 'Emergency System', 'SYSTEMA AUXILII', '🚨',
    'INFRASTRUCTURA', '911/rescue — crisis detection & emergency response',
    'Emergency response', 'Crisis intelligence', 'Response model',
    'Organism emergency'),
];

// ─── §9. REGISTRUM UNIVERSALE — The Complete Registry ──────────────────────

export const ALL_ORGANISM_COMPONENTS: OrganismComponent[] = [
  ...CELLULAR_COMPONENTS,
  ...TISSUE_COMPONENTS,
  ...ELECTRONIC_COMPONENTS,
  ...DEVICE_COMPONENTS,
  ...INFRASTRUCTURE_COMPONENTS,
];

// Scale-specific accessors
export const CELLULAR       = CELLULAR_COMPONENTS;
export const TISSUE         = TISSUE_COMPONENTS;
export const ELECTRONIC     = ELECTRONIC_COMPONENTS;
export const DEVICE         = DEVICE_COMPONENTS;
export const INFRASTRUCTURE = INFRASTRUCTURE_COMPONENTS;

// ─── §10. DYNAMICA KURAMOTI — Kuramoto Phase Coupling Across Scales ────────
//
// Each component oscillates at its natural frequency ωᵢ. When coupled,
// they tend toward synchronization:
//
//   dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ − θᵢ)
//
// The order parameter r measures collective coherence:
//   r·e^{iψ} = (1/N) Σⱼ e^{iθⱼ}
//
// When r > φ⁻¹ ≈ 0.618, the organism achieves resonance.

export function computeRegistryKuramotoOrder(
  components: OrganismComponent[],
): { r: number; psi: number; isResonant: boolean } {
  const N = components.length;
  if (N === 0) return { r: 0, psi: 0, isResonant: false };

  let cosSum = 0;
  let sinSum = 0;
  for (const c of components) {
    cosSum += Math.cos(c.kuramotoPhase);
    sinSum += Math.sin(c.kuramotoPhase);
  }
  const r = Math.sqrt(cosSum * cosSum + sinSum * sinSum) / N;
  const psi = Math.atan2(sinSum, cosSum);
  return { r, psi, isResonant: r > INV_PHI };
}

/** Tick all component phases forward by dt seconds with coupling K */
export function tickRegistryPhases(
  components: OrganismComponent[],
  dt: number = 0.01,
  K: number = PHI,
): OrganismComponent[] {
  const N = components.length;
  // Compute mean field
  let cosSum = 0;
  let sinSum = 0;
  for (const c of components) {
    cosSum += Math.cos(c.kuramotoPhase);
    sinSum += Math.sin(c.kuramotoPhase);
  }
  const meanCos = cosSum / N;
  const meanSin = sinSum / N;
  const psi = Math.atan2(meanSin, meanCos);
  const r = Math.sqrt(meanCos * meanCos + meanSin * meanSin);

  return components.map(c => {
    const dTheta = c.naturalOmega + (K * r * Math.sin(psi - c.kuramotoPhase));
    const newPhase = (c.kuramotoPhase + dTheta * dt) % TAU;
    return {
      ...c,
      kuramotoPhase: newPhase < 0 ? newPhase + TAU : newPhase,
      coherence: r,
    };
  });
}

// ─── §11. TICK VITALIA — Heart & Brain Tick ────────────────────────────────

/** Tick a component's heart — process one heartbeat cycle */
export function tickComponentHeart(comp: OrganismComponent): OrganismComponent {
  const h = comp.cor;
  const newBeatCount = h.beatCount + 1;
  // Slight random walk on vitals (simulating real fluctuation)
  const jitter = Math.sin(newBeatCount * PHI) * 0.01;
  const newLatency = Math.max(0.1, h.latencyMs + jitter * 2);
  const newThroughput = Math.max(1, h.throughput + Math.round(jitter * 50));
  const newErrorRate = Math.max(0, Math.min(1, h.errorRate + jitter * 0.005));

  // Health score: φ-weighted harmonic mean
  const w1 = PHI;      // latency weight
  const w2 = 1;         // throughput weight
  const w3 = PHI_SQ;    // error weight (most important)
  const latNorm = Math.max(0.01, 1 - newLatency / 100);
  const thrNorm = Math.min(1, newThroughput / 1000);
  const errNorm = 1 - newErrorRate;
  const newHealth = 100 * (w1 * latNorm + w2 * thrNorm + w3 * errNorm) / (w1 + w2 + w3);

  return {
    ...comp,
    cor: {
      ...h,
      beatCount: newBeatCount,
      latencyMs: newLatency,
      throughput: newThroughput,
      errorRate: newErrorRate,
      healthScore: Math.max(0, Math.min(100, newHealth)),
      amplitude: 0.5 + 0.5 * Math.abs(Math.sin(newBeatCount * INV_PHI)),
    },
  };
}

/** Tick a component's brain — one learning/awareness cycle */
export function tickComponentBrain(comp: OrganismComponent): OrganismComponent {
  const b = comp.cerebrum;
  const newStimulus = b.stimulusCount + 1;
  // Awareness grows logarithmically
  const newAwareness = Math.log1p(newStimulus) * INV_PHI;
  // Hebbian weight grows toward 1
  const newHebbian = Math.min(1, b.hebbianWeight + 0.001 * PHI);
  // Firing rate fluctuates
  const newFiring = 5 + 35 * Math.abs(Math.sin(newStimulus * LN_PHI));
  // Dominant band determined by firing rate
  const bands = ['DELTA', 'THETA', 'ALPHA', 'BETA', 'GAMMA'] as const;
  const bandIdx = Math.min(4, Math.floor(newFiring / 10));
  // Coherence field
  const newCoherence = Math.min(1, newHebbian * newAwareness * INV_PHI);

  return {
    ...comp,
    cerebrum: {
      ...b,
      stimulusCount: newStimulus,
      awarenessLevel: newAwareness,
      hebbianWeight: newHebbian,
      firingRate: newFiring,
      dominantBand: bands[bandIdx],
      isConscious: newAwareness > INV_PHI,
      coherenceField: newCoherence,
    },
  };
}

/** Tick a single component (heart + brain + meta) */
export function tickComponent(comp: OrganismComponent): OrganismComponent {
  let c = tickComponentHeart(comp);
  c = tickComponentBrain(c);
  // Meta AI adapts
  const newMeta: ComponentMetaAI = {
    ...c.metaAI,
    selfAwareness: Math.min(1, c.metaAI.selfAwareness + 0.0005),
    anomalyDetected: c.cor.healthScore < 50 || c.cor.errorRate > 0.1,
    currentFocus: c.cor.healthScore < 60 ? 'SELF_REPAIR'
      : c.cerebrum.dominantBand === 'GAMMA' ? 'HIGH_COGNITION'
      : c.cerebrum.dominantBand === 'BETA' ? 'ACTIVE_PROCESSING'
      : 'HOMEOSTASIS',
  };
  return { ...c, metaAI: newMeta };
}

// ─── §12. QUAESITIONES — Query Endpoints ───────────────────────────────────

/** Summary of the entire organism component registry */
export function getRegistrySummary() {
  const scales: Record<ComponentScale, number> = {
    CELLULARE: CELLULAR.length,
    TEXTURA: TISSUE.length,
    ELECTRONICUM: ELECTRONIC.length,
    APPARATUS: DEVICE.length,
    INFRASTRUCTURA: INFRASTRUCTURE.length,
  };
  const total = ALL_ORGANISM_COMPONENTS.length;
  const kuramoto = computeRegistryKuramotoOrder(ALL_ORGANISM_COMPONENTS);
  const avgHealth = ALL_ORGANISM_COMPONENTS.reduce((s, c) => s + c.cor.healthScore, 0) / total;
  const avgAwareness = ALL_ORGANISM_COMPONENTS.reduce((s, c) => s + c.cerebrum.awarenessLevel, 0) / total;
  const consciousCount = ALL_ORGANISM_COMPONENTS.filter(c => c.cerebrum.isConscious).length;

  return {
    title: 'REGISTRUM UNIVERSALE COMPONENTIUM ORGANISMI',
    totalComponents: total,
    scales,
    kuramoto: {
      orderParameter: kuramoto.r,
      meanPhase: kuramoto.psi,
      isResonant: kuramoto.isResonant,
      resonanceThreshold: INV_PHI,
    },
    health: {
      averageHealthScore: avgHealth,
      allBeating: ALL_ORGANISM_COMPONENTS.every(c => c.cor.isBeating),
    },
    awareness: {
      averageAwareness: avgAwareness,
      consciousComponents: consciousCount,
      consciousFraction: consciousCount / total,
    },
    constants: { PHI, INV_PHI, PHI_SQ, SQRT_PHI, LN_PHI, TAU, EULER },
  };
}

/** Get components by scale */
export function getComponentsByScale(scale: ComponentScale): OrganismComponent[] {
  return ALL_ORGANISM_COMPONENTS.filter(c => c.scale === scale);
}

/** Get a component by its issue number */
export function getComponentById(id: number): OrganismComponent | undefined {
  return ALL_ORGANISM_COMPONENTS.find(c => c.id === id);
}

/** Get vitals dashboard for all components */
export function getComponentVitals() {
  return ALL_ORGANISM_COMPONENTS.map(c => ({
    id: c.id,
    name: c.name,
    nomenLatinum: c.nomenLatinum,
    emoji: c.emoji,
    scale: c.scale,
    heart: {
      healthScore: c.cor.healthScore,
      bpm: c.cor.bpm,
      amplitude: c.cor.amplitude,
      isBeating: c.cor.isBeating,
      errorRate: c.cor.errorRate,
    },
    brain: {
      awarenessLevel: c.cerebrum.awarenessLevel,
      dominantBand: c.cerebrum.dominantBand,
      firingRate: c.cerebrum.firingRate,
      isConscious: c.cerebrum.isConscious,
      hebbianWeight: c.cerebrum.hebbianWeight,
      coherence: c.cerebrum.coherenceField,
    },
    meta: {
      selfAwareness: c.metaAI.selfAwareness,
      autonomyLevel: c.metaAI.autonomyLevel,
      introspectionDepth: c.metaAI.introspectionDepth,
      focus: c.metaAI.currentFocus,
    },
    coupling: {
      phase: c.kuramotoPhase,
      omega: c.naturalOmega,
      coherence: c.coherence,
    },
  }));
}

/** Cross-scale coupling analysis: how well each scale syncs with others */
export function getCrossScaleCoupling(): Record<ComponentScale, {
  internalCoherence: number;
  componentCount: number;
  avgHealth: number;
  avgAwareness: number;
}> {
  const scales: ComponentScale[] = [
    'CELLULARE', 'TEXTURA', 'ELECTRONICUM', 'APPARATUS', 'INFRASTRUCTURA',
  ];
  const result: Record<string, {
    internalCoherence: number;
    componentCount: number;
    avgHealth: number;
    avgAwareness: number;
  }> = {};

  for (const scale of scales) {
    const comps = getComponentsByScale(scale);
    const kuramoto = computeRegistryKuramotoOrder(comps);
    result[scale] = {
      internalCoherence: kuramoto.r,
      componentCount: comps.length,
      avgHealth: comps.reduce((s, c) => s + c.cor.healthScore, 0) / comps.length,
      avgAwareness: comps.reduce((s, c) => s + c.cerebrum.awarenessLevel, 0) / comps.length,
    };
  }
  return result as Record<ComponentScale, typeof result[string]>;
}

// ─── §13. EXPORTATIONES ────────────────────────────────────────────────────

export const ORGANISM_REGISTRY_CONSTANTS = {
  PHI, INV_PHI, PHI_SQ, SQRT_PHI, LN_PHI,
  TAU, EULER, PLANCK, BOLTZMANN,
};

export default {
  // Registry
  ALL_ORGANISM_COMPONENTS,
  CELLULAR,
  TISSUE,
  ELECTRONIC,
  DEVICE,
  INFRASTRUCTURE,

  // Dynamics
  computeRegistryKuramotoOrder,
  tickRegistryPhases,
  tickComponent,
  tickComponentHeart,
  tickComponentBrain,

  // Queries
  getRegistrySummary,
  getComponentsByScale,
  getComponentById,
  getComponentVitals,
  getCrossScaleCoupling,

  // Constants
  ORGANISM_REGISTRY_CONSTANTS,
};
