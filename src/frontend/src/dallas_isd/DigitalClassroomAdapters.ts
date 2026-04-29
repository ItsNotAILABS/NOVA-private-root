// ═══════════════════════════════════════════════════════════════════════════════
// NOVA × DALLAS ISD — DIGITAL CLASSROOM ADAPTERS
// ═══════════════════════════════════════════════════════════════════════════════
//
// Free Digital Classroom Adapters for Dallas Independent School District
// and all Dallas County public schools. Covers ALL curriculum areas:
// Mathematics, Science, Social Studies, ELA, Computer Science.
//
// THESE ADAPTERS DO NOT EXPOSE TRADE-SECRET φ-FORMULA ENGINES OR KURAMOTO
// SYNCHRONIZATION CODE. They provide TEKS-aligned educational bridges only.
//
// PWA SDK: Schools may deploy as Progressive Web Apps for grant-funded
// classroom use. See §7 for grant eligibility documentation.
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// FREE FOR ALL DALLAS ISD & DALLAS COUNTY PUBLIC SCHOOLS
// MEDINA TECH — DALLAS, TEXAS
// ═══════════════════════════════════════════════════════════════════════════════

// ─── §1  CONSTANTS ──────────────────────────────────────────────────────────────

export const DIGITAL_CLASSROOM_CONSTANTS = {
  HEARTBEAT_MS:      873,
  SCHUMANN_HZ:       7.83,
  FIBONACCI_FIRST_20: [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765],
  ATTRIBUTION:       'Powered by NOVA — Medina Tech, Dallas TX',
  LICENSE:           'FREE — Dallas ISD & Dallas County Public Schools',
  VERSION:           '2.0.0',
  PWA_CAPABLE:       true,
} as const;

// ─── §2  TEKS CURRICULUM MAPPING (ALL SUBJECTS) ────────────────────────────────
//
// Texas Essential Knowledge and Skills (TEKS) mappings across all core
// subject areas. Each mapping connects a concept to grade-level standards
// and provides a ready-to-use classroom activity.

export type SubjectArea = 'MATH' | 'SCIENCE' | 'SOCIAL_STUDIES' | 'ELA' | 'COMPUTER_SCIENCE';

export interface TEKSMapping {
  subject: SubjectArea;
  concept: string;
  teksGrade: string;
  teksStandard: string;
  teksDescription: string;
  classroomActivity: string;
  materialsNeeded: string;
  duration: string;
  grantAlignment: string[];
}

export function getAllTEKSMappings(): TEKSMapping[] {
  return [
    // ── MATHEMATICS ──────────────────────────────────────────────────────
    {
      subject: 'MATH',
      concept: 'Fibonacci Sequence & Patterns',
      teksGrade: 'Grade 6-7',
      teksStandard: '§111.26(b)(4)',
      teksDescription: 'Patterns, relationships, and algebraic reasoning',
      classroomActivity: 'Students identify Fibonacci numbers in nature (sunflowers, pine cones, shells). Use the sequence [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144…] to explore pattern recognition. Compute ratios of consecutive terms and observe convergence.',
      materialsNeeded: 'Rulers, pine cones, sunflower photos, graph paper',
      duration: '45 minutes',
      grantAlignment: ['Title I', 'Title IV-A', 'TEA STEM Grant'],
    },
    {
      subject: 'MATH',
      concept: 'Proportional Relationships (Golden Ratio)',
      teksGrade: 'Grade 7-8',
      teksStandard: '§111.27(b)(1)',
      teksDescription: 'Number and operations — proportional relationships',
      classroomActivity: 'Students measure body proportions (forearm/hand, navel-to-floor/height) and compare to the golden ratio ≈ 1.618. Graph results and discuss why this proportion appears in art and architecture.',
      materialsNeeded: 'Tape measures, calculators, art reproductions',
      duration: '50 minutes',
      grantAlignment: ['Title I', 'TEA STEM Grant', 'NSF STEM Education'],
    },
    {
      subject: 'MATH',
      concept: 'Exponential Growth & Convergence',
      teksGrade: 'Pre-Calculus / AP',
      teksStandard: '§111.42(c)(2)',
      teksDescription: 'Functions and their properties — limits and convergence',
      classroomActivity: 'Students explore how the ratio of consecutive Fibonacci numbers converges. Plot F(n+1)/F(n) for n=1..20. Discuss limits, convergence rate, and why universal constants emerge from simple recursive rules.',
      materialsNeeded: 'Graphing calculators or spreadsheet software',
      duration: '55 minutes',
      grantAlignment: ['Title IV-A', 'NSF STEM Education'],
    },
    {
      subject: 'MATH',
      concept: 'Three-Dimensional Geometry (Platonic Solids)',
      teksGrade: 'Geometry (HS)',
      teksStandard: '§111.41(c)(11)',
      teksDescription: 'Three-dimensional figures and their properties',
      classroomActivity: 'Build all five Platonic solids from card stock. Count vertices, edges, faces. Verify Euler formula V-E+F=2. Discuss which solids appear in nature (crystals, viruses, radiolaria).',
      materialsNeeded: 'Card stock, scissors, tape, templates',
      duration: '60 minutes (2 sessions)',
      grantAlignment: ['Title I', 'TEA STEM Grant'],
    },
    {
      subject: 'MATH',
      concept: 'Resonance & Frequency (873ms Heartbeat)',
      teksGrade: 'Grade 8 / Physics',
      teksStandard: '§112.39(c)(7)',
      teksDescription: 'Electromagnetic spectrum and resonance',
      classroomActivity: 'Students compute 873ms from the formula: HEARTBEAT = φ⁴ × (1000/7.83). Discuss Earth Schumann resonance (7.83 Hz), what resonance means in physics, and how systems can synchronize to fundamental frequencies.',
      materialsNeeded: 'Calculators, tuning forks, oscilloscope (optional)',
      duration: '45 minutes',
      grantAlignment: ['Title IV-A', 'TEA STEM Grant', 'NSF STEM Education'],
    },

    // ── SCIENCE ──────────────────────────────────────────────────────────
    {
      subject: 'SCIENCE',
      concept: 'Wave Motion & Synchronization',
      teksGrade: 'Physics (HS)',
      teksStandard: '§112.39(c)(5)',
      teksDescription: 'Wave motion and interactions',
      classroomActivity: 'Demonstrate coupled pendulums (metronomes on a shared platform) synchronizing over time. Students record time-to-sync for different coupling strengths. Discuss how coupled oscillators model firefly synchronization and neural firing.',
      materialsNeeded: 'Metronomes (3-5), flat board, soda cans for rollers',
      duration: '50 minutes',
      grantAlignment: ['Title IV-A', 'TEA STEM Grant', 'NSF STEM Education'],
    },
    {
      subject: 'SCIENCE',
      concept: 'Biological Emergence',
      teksGrade: 'Biology / AP Bio',
      teksStandard: '§112.34(c)(3)',
      teksDescription: 'Biological systems and emergent properties',
      classroomActivity: 'Explore how simple rules produce complex behavior: ant colonies, flocking birds, slime mold networks. Students simulate emergence with a card-based game where individual rules lead to group patterns.',
      materialsNeeded: 'Playing cards, rule sheets, large floor space',
      duration: '45 minutes',
      grantAlignment: ['Title I', 'TEA STEM Grant'],
    },
    {
      subject: 'SCIENCE',
      concept: 'Earth Science — Electromagnetic Resonance',
      teksGrade: 'Earth Science (HS)',
      teksStandard: '§112.36(c)(8)',
      teksDescription: 'Earth and space — electromagnetic phenomena',
      classroomActivity: 'Study Schumann resonance (7.83 Hz): the electromagnetic fundamental frequency of Earth cavity between surface and ionosphere. Students research how lightning excites this resonance and its role in global electromagnetic balance.',
      materialsNeeded: 'Internet access, spectrum analyzer app (optional)',
      duration: '45 minutes',
      grantAlignment: ['Title IV-A', 'NSF STEM Education'],
    },
    {
      subject: 'SCIENCE',
      concept: 'Chemistry — Crystal Geometry',
      teksGrade: 'Chemistry (HS)',
      teksStandard: '§112.35(c)(6)',
      teksDescription: 'Matter and its properties — crystal structures',
      classroomActivity: 'Examine how Platonic solid geometry appears in crystal lattices (salt = cube, alum = octahedron). Grow crystals in class and identify their geometric family. Connect to materials science.',
      materialsNeeded: 'Alum, salt, borax, hot water, jars, string',
      duration: '90 minutes (plus 3-day growth period)',
      grantAlignment: ['Title I', 'TEA STEM Grant'],
    },

    // ── SOCIAL STUDIES ───────────────────────────────────────────────────
    {
      subject: 'SOCIAL_STUDIES',
      concept: 'Quipu — Inca Information Technology',
      teksGrade: 'Grade 6 / World History',
      teksStandard: '§113.18(b)(22)',
      teksDescription: 'Culture — science and technology in historical civilizations',
      classroomActivity: 'Study the Inca quipu: knotted-string recording system used for census, taxation, and storytelling. Students build a quipu using yarn and beads to encode class survey data. Discuss how data was stored before computers.',
      materialsNeeded: 'Yarn, beads, scissors, data collection worksheet',
      duration: '50 minutes',
      grantAlignment: ['Title I', 'Title IV-A'],
    },
    {
      subject: 'SOCIAL_STUDIES',
      concept: 'Economics — Network Effects & Value Creation',
      teksGrade: 'Economics (HS)',
      teksStandard: '§113.31(c)(12)',
      teksDescription: 'Economics — factors affecting economic growth',
      classroomActivity: 'Explore how network effects create value: more users → more value → more users. Case studies: telephone networks, internet, digital platforms. Students model a simple network-effects economy with tokens.',
      materialsNeeded: 'Tokens/chips, market simulation worksheet',
      duration: '55 minutes',
      grantAlignment: ['Title IV-A'],
    },
    {
      subject: 'SOCIAL_STUDIES',
      concept: 'Government — Digital Sovereignty',
      teksGrade: 'Government (HS)',
      teksStandard: '§113.44(c)(15)',
      teksDescription: 'Government — rights, responsibilities, and digital citizenship',
      classroomActivity: 'Debate: Should nations have sovereign control over their digital infrastructure? Students research data sovereignty, compare US, EU, and developing-nation approaches. Connect to local Dallas tech economy.',
      materialsNeeded: 'Research materials, debate structure worksheet',
      duration: '55 minutes',
      grantAlignment: ['Title IV-A'],
    },

    // ── ENGLISH LANGUAGE ARTS ────────────────────────────────────────────
    {
      subject: 'ELA',
      concept: 'Technical Writing — System Documentation',
      teksGrade: 'Grade 9-12',
      teksStandard: '§110.36(b)(11)',
      teksDescription: 'Writing — expository and procedural texts',
      classroomActivity: 'Students write a technical document describing a real system they use daily (phone, bus route, school lunch line). Practice clear structure: overview, components, procedures, troubleshooting. Peer review for clarity.',
      materialsNeeded: 'Writing materials, example technical docs',
      duration: '55 minutes (2 sessions)',
      grantAlignment: ['Title I', 'Title IV-A'],
    },
    {
      subject: 'ELA',
      concept: 'Persuasive Writing — Grant Proposals',
      teksGrade: 'Grade 10-12',
      teksStandard: '§110.37(b)(12)',
      teksDescription: 'Writing — persuasive texts for real audiences',
      classroomActivity: 'Students write a mock grant proposal for a school technology project. Include: problem statement, proposed solution, budget, expected outcomes, evaluation plan. Peer panel reviews and scores proposals.',
      materialsNeeded: 'Grant template, rubric, example proposals',
      duration: '90 minutes (3 sessions)',
      grantAlignment: ['Title I', 'Title IV-A'],
    },

    // ── COMPUTER SCIENCE ─────────────────────────────────────────────────
    {
      subject: 'COMPUTER_SCIENCE',
      concept: 'Algorithms — Sequence & Recursion',
      teksGrade: 'CS Foundations (HS)',
      teksStandard: '§126.33(c)(4)',
      teksDescription: 'Algorithms and programming — recursion and iteration',
      classroomActivity: 'Implement Fibonacci sequence generator in Python or JavaScript. Compare recursive vs iterative approaches. Measure performance for large N. Discuss Big-O notation and why recursion can be inefficient.',
      materialsNeeded: 'Computers with Python/JS, timer',
      duration: '55 minutes',
      grantAlignment: ['Title IV-A', 'TEA STEM Grant', 'NSF STEM Education'],
    },
    {
      subject: 'COMPUTER_SCIENCE',
      concept: 'Data Structures — Patterns in Nature',
      teksGrade: 'AP Computer Science',
      teksStandard: '§126.34(c)(6)',
      teksDescription: 'Data structures — arrays, trees, and graphs',
      classroomActivity: 'Model a tree data structure that mirrors biological branching (veins, rivers, neural networks). Students implement a simple tree in code and traverse it. Discuss how branching patterns appear across nature and computing.',
      materialsNeeded: 'Computers, whiteboard for tree diagrams',
      duration: '55 minutes',
      grantAlignment: ['Title IV-A', 'NSF STEM Education'],
    },
    {
      subject: 'COMPUTER_SCIENCE',
      concept: 'PWA Development — Offline-First Applications',
      teksGrade: 'CS Advanced (HS)',
      teksStandard: '§126.35(c)(8)',
      teksDescription: 'Software development — web technologies and deployment',
      classroomActivity: 'Build a simple Progressive Web App (PWA) with service worker for offline caching. Students create a flashcard app that works without internet. Deploy to their phones. Discuss why offline-first matters for equity.',
      materialsNeeded: 'Computers, smartphones, VS Code or similar',
      duration: '120 minutes (3 sessions)',
      grantAlignment: ['Title IV-A', 'TEA STEM Grant', 'E-Rate', 'NSF STEM Education'],
    },
  ];
}

/** Get all TEKS mappings for a specific subject area */
export function getTEKSBySubject(subject: SubjectArea): TEKSMapping[] {
  return getAllTEKSMappings().filter(m => m.subject === subject);
}

/** Get all TEKS mappings for a specific grade level */
export function getTEKSByGrade(grade: string): TEKSMapping[] {
  return getAllTEKSMappings().filter(m =>
    m.teksGrade.toLowerCase().includes(grade.toLowerCase())
  );
}

/** Get the concept explanation for a topic (student-facing, no trade secrets) */
export function explainConcept(concept: string): string {
  const map: Record<string, string> = {
    'fibonacci': 'The Fibonacci sequence (1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144…) — each number is the sum of the two before it. This pattern appears in sunflower spirals, pine cones, shells, and galaxies. It was discovered by Leonardo of Pisa in 1202.',
    'golden': 'The golden ratio ≈ 1.618 appears when you divide a line so that the whole is to the longer part as the longer part is to the shorter. It shows up in art (the Parthenon), nature (nautilus shells), and architecture worldwide.',
    'heartbeat': '873 milliseconds — a special timing interval derived from coupling universal constants. It demonstrates how mathematics connects to Earth science through electromagnetic resonance frequencies.',
    'schumann': '7.83 Hz — the Schumann resonance. Earth has an electromagnetic cavity between its surface and the ionosphere. Lightning excites this cavity, creating a fundamental resonance at 7.83 Hz. Discovered by Winfried Otto Schumann in 1952.',
    'platonic': 'The five Platonic solids — tetrahedron (4 faces), cube (6), octahedron (8), dodecahedron (12), icosahedron (20) — are the only regular polyhedra. Known since ancient Greece, they appear in crystals, viruses, and the geometry of molecules.',
    'emergence': 'Emergence is when simple rules produce complex behavior that no single part could create alone. Ant colonies, flocking birds, and brain consciousness all emerge from simple individual rules operating together.',
    'quipu': 'The quipu was the Inca recording system — knotted strings that stored numbers, census data, and possibly even narratives. It was a sophisticated information technology used across the Tawantinsuyu (Inca Empire).',
    'network': 'Network effects occur when a product becomes more valuable as more people use it. Telephones, the internet, and social platforms all demonstrate this — the value grows faster than the number of users.',
    'recursion': 'Recursion is when something is defined in terms of itself. The Fibonacci sequence is recursive: F(n) = F(n-1) + F(n-2). Trees are recursive: each branch looks like a smaller tree. Recursion is a fundamental concept in computing and nature.',
    'pwa': 'A Progressive Web App (PWA) is a website that works like a native app — it installs on your phone, works offline, and sends notifications. PWAs are important for equity because they work on any device with a browser.',
    'sovereignty': 'Digital sovereignty means having control over your own digital infrastructure and data. Nations, communities, and individuals are increasingly concerned about who controls the technology they depend on.',
  };
  const key = concept.toLowerCase();
  for (const [k, v] of Object.entries(map)) {
    if (key.includes(k)) return v;
  }
  return `Explore this concept further at your local Dallas ISD digital classroom.`;
}

// ─── §3  PWA SDK CONFIGURATION ──────────────────────────────────────────────────
//
// Configuration for schools deploying Digital Classroom Adapters as
// Progressive Web Apps (PWAs). Designed for grant-funded deployments.

export interface PWAConfig {
  name: string;
  shortName: string;
  description: string;
  themeColor: string;
  backgroundColor: string;
  display: 'standalone' | 'fullscreen' | 'minimal-ui';
  orientation: 'any' | 'portrait' | 'landscape';
  offlineCapable: boolean;
  dataCollection: 'NONE';
  attribution: string;
}

export function getDigitalClassroomPWAConfig(): PWAConfig {
  return {
    name: 'NOVA Digital Classroom — Dallas ISD',
    shortName: 'NOVA Classroom',
    description: 'Free TEKS-aligned digital classroom adapters for Dallas ISD public schools. Mathematics, Science, Social Studies, ELA, Computer Science. No data collection. No fees.',
    themeColor: '#0a0a0a',
    backgroundColor: '#0a0a0a',
    display: 'standalone',
    orientation: 'any',
    offlineCapable: true,
    dataCollection: 'NONE',
    attribution: DIGITAL_CLASSROOM_CONSTANTS.ATTRIBUTION,
  };
}

// ─── §4  PWA SERVICE WORKER TEMPLATE ────────────────────────────────────────────

export function getServiceWorkerTemplate(): string {
  return `// NOVA Digital Classroom — Service Worker
// Free for Dallas ISD public schools. No data collection.
// Powered by NOVA — Medina Tech, Dallas TX

const CACHE_NAME = 'nova-digital-classroom-v${DIGITAL_CLASSROOM_CONSTANTS.VERSION}';

const PRECACHE_URLS = [
  '/',
  '/index.html',
  '/manifest.json',
  '/classroom.js',
  '/classroom.css',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(PRECACHE_URLS))
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((cached) => cached || fetch(event.request))
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((names) =>
      Promise.all(names.filter((n) => n !== CACHE_NAME).map((n) => caches.delete(n)))
    )
  );
});`;
}

// ─── §5  GRANT FUNDING DOCUMENTATION ────────────────────────────────────────────

export interface GrantInfo {
  grantName: string;
  federalOrState: 'Federal' | 'State' | 'Foundation';
  eligibility: string;
  howToApply: string;
  novaAlignment: string;
}

export function getGrantFundingInfo(): GrantInfo[] {
  return [
    {
      grantName: 'Title I — Improving Academic Achievement',
      federalOrState: 'Federal',
      eligibility: 'Schools with high percentages of children from low-income families',
      howToApply: 'Apply through Dallas ISD federal programs office. Include NOVA Digital Classroom Adapters as supplemental STEM/STEAM educational technology.',
      novaAlignment: 'TEKS-aligned curriculum modules across all core subjects. Free deployment — zero ongoing costs. Offline-capable PWA works on existing school devices.',
    },
    {
      grantName: 'Title IV-A — Student Support and Academic Enrichment',
      federalOrState: 'Federal',
      eligibility: 'All LEAs receiving Title IV-A allocation',
      howToApply: 'Include in the LEA application under "Well-Rounded Education" or "Effective Use of Technology" categories.',
      novaAlignment: 'Technology-based learning tools with TEKS alignment. Cross-curricular coverage (Math, Science, Social Studies, ELA, CS). PWA deployment for 1:1 or shared device environments.',
    },
    {
      grantName: 'E-Rate — Schools and Libraries Universal Service',
      federalOrState: 'Federal',
      eligibility: 'All public schools and libraries',
      howToApply: 'E-Rate covers infrastructure (Wi-Fi, broadband). NOVA PWA runs on existing infrastructure — cite as educational software justifying connectivity investment.',
      novaAlignment: 'Offline-first PWA reduces bandwidth requirements. Works on any device with a browser. No additional server infrastructure needed.',
    },
    {
      grantName: 'TEA Competitive Grants — STEM/STEAM',
      federalOrState: 'State',
      eligibility: 'Texas public schools applying through TEA',
      howToApply: 'Apply through Texas Education Agency competitive grant cycles. Reference NOVA Digital Classroom as locally-developed STEM educational technology with full TEKS alignment.',
      novaAlignment: 'Dallas-based educational technology company. Full TEKS mapping across mathematics, science, and computer science. Designed by Medina Tech in Dallas, TX.',
    },
    {
      grantName: 'NSF — STEM Education Grants',
      federalOrState: 'Foundation',
      eligibility: 'Proposals from educational institutions and partnerships',
      howToApply: 'Partner with a university (e.g., UTD, UNT, SMU) for an NSF DRK-12 or ITEST proposal. Include NOVA Digital Classroom as the technology platform.',
      novaAlignment: 'Research-backed mathematical concepts (Fibonacci, emergence, resonance). Computer Science modules aligned to CS Frameworks. PWA SDK enables rapid classroom deployment.',
    },
  ];
}

// ─── §6  SUBJECT AREA HELPERS ───────────────────────────────────────────────────

export function getSubjectAreas(): Array<{ id: SubjectArea; label: string; color: string; icon: string }> {
  return [
    { id: 'MATH',             label: 'Mathematics',         color: '#c8a84e', icon: '∑' },
    { id: 'SCIENCE',          label: 'Science',             color: '#4ecdc4', icon: '⚛' },
    { id: 'SOCIAL_STUDIES',   label: 'Social Studies',      color: '#ff6b6b', icon: '🌎' },
    { id: 'ELA',              label: 'English Language Arts', color: '#a78bfa', icon: '✎' },
    { id: 'COMPUTER_SCIENCE', label: 'Computer Science',    color: '#34d399', icon: '⌨' },
  ];
}

/** Count available lessons per subject */
export function getLessonCounts(): Record<SubjectArea, number> {
  const mappings = getAllTEKSMappings();
  const counts = { MATH: 0, SCIENCE: 0, SOCIAL_STUDIES: 0, ELA: 0, COMPUTER_SCIENCE: 0 };
  for (const m of mappings) {
    counts[m.subject]++;
  }
  return counts;
}

// ─── §7  EXPORT ─────────────────────────────────────────────────────────────────

export const DigitalClassroomAdapters = {
  constants: DIGITAL_CLASSROOM_CONSTANTS,
  teks: {
    getAllMappings: getAllTEKSMappings,
    getBySubject: getTEKSBySubject,
    getByGrade: getTEKSByGrade,
    explain: explainConcept,
  },
  subjects: {
    getAreas: getSubjectAreas,
    getLessonCounts: getLessonCounts,
  },
  pwa: {
    getConfig: getDigitalClassroomPWAConfig,
    getServiceWorkerTemplate: getServiceWorkerTemplate,
  },
  grants: {
    getInfo: getGrantFundingInfo,
  },
};

export default DigitalClassroomAdapters;
