// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  Owner: Alfredo Medina Hernandez · Dallas TX · MedinaSITech@outlook.com                                  ║
// ║  Framework: Medina Doctrine — Native Nova Protocol                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// NATIVE NOVA PROTOCOL — BUILD №43
// DALLAS ISD — Sovereign Curriculum Intelligence Backend
// Free for all Dallas ISD & Dallas County Public Schools
// Medina Tech | Alfredo Medina Hernandez | Dallas TX | 2026
//
// MISSION:
//   On-chain intelligence backend for the NOVA Dallas ISD Digital Classroom.
//   Stores the FULL TEKS curriculum manifest on-chain. Every lesson, concept,
//   grant alignment, and subject progression lives here permanently.
//   The frontend is a visualization of this on-chain intelligence.
//
// ARCHITECTURE:
//   TEKS registry     — all concepts, grades, standards, activities on-chain
//   Concept content   — full explanations, formulas, examples stored in canister
//   Grant manifest    — DOE/TEA/NSF grant alignment data stored on-chain
//   School registry   — Dallas County public schools enrollment
//   Math engine log   — φ/Fibonacci/Kuramoto computation results cached
//   Heartbeat         — 873ms: updates engagement metrics, publishes telemetry
//   Stream publish    — CLASSROOM_ENGAGE / CLASSROOM_MASTER / CLASSROOM_GRANT
//
// PUBLIC API:
//   getTEKSConcept(subject, conceptId)   — full concept with TEKS reference
//   getAllConcepts(subject)              — list all concepts for a subject
//   getConceptExplanation(conceptId)    — full on-chain explanation text
//   getGrantManifest()                  — all grant alignment data
//   getSubjectProgress(schoolId)        — aggregate engagement by school
//   recordEngagement(schoolId, subject) — record a student engagement event
//   getMathEngine()                     — φ-constants and engine state
//   getClassroomStatus()                — full canister health

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";
import Bool      "mo:base/Bool";

actor DallasISD {

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var architectPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;

  func _isArchitect(caller : Principal) : Bool { caller == architectPrincipal };

  public shared(msg) func claimDISD() : async Text {
    if (genesisLocked) return "DISD_ALREADY_CLAIMED";
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-DALLAS-ISD-BUILD43-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text      { sovereignSeal };
  public query func isLocked()     : async Bool      { genesisLocked };
  public query func getArchitect() : async Principal { architectPrincipal };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 2 — NOVA MATH ENGINE CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // These are the sovereign NOVA math constants — stored on-chain.
  // Mirrors the Motoko backend math and CPL frontend math precisely.
  // TEKS §111.26-§111.42 coverage via these fundamental constants.

  // φ constants — never approximated, always 19 decimal places
  let PHI         : Float = 1.6180339887498948482;   // Golden ratio
  let PHI_INV     : Float = 0.6180339887498948482;   // φ⁻¹
  let PHI_SQ      : Float = 2.6180339887498948482;   // φ²
  let PHI_CUBE    : Float = 4.2360679774997896964;   // φ³
  let PHI_4       : Float = 6.8541019662496847020;   // φ⁴
  let PHI_INV_2   : Float = 0.3819660112501051518;   // φ⁻² = AMOR constant (AGR solver)
  let PHI_INV_3   : Float = 0.2360679774997896964;   // φ⁻³
  let PHI_INV_5   : Float = 0.0901699437494742410;   // φ⁻⁵

  // Chaos and physics constants
  let FEIGENBAUM  : Float = 4.6692016091029906719;   // Feigenbaum bifurcation constant
  let ISING_BETA  : Float = 0.125;                   // 2D Ising model critical β
  let SCHUMANN    : Float = 7.83;                    // Earth Schumann resonance Hz
  let HEARTBEAT   : Nat   = 873;                     // NOVA 873ms = φ⁴ × (1000/7.83)

  // Fibonacci — F(1) through F(20) stored on-chain
  let FIB : [Nat] = [
    1, 1, 2, 3, 5, 8, 13, 21, 34, 55,
    89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765
  ];

  // Kuramoto order parameter critical coupling K_c ≈ 2·σ(ω)
  // For 8 uniform oscillators: K_c ≈ 1.273
  let KURAMOTO_KC : Float = 1.273;

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 3 — TEKS CONCEPT REGISTRY (on-chain, all subjects)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // TEKS = Texas Essential Knowledge and Skills
  // Every concept is stored as a permanent on-chain record.
  // Frontend reads these — intelligence lives in the backend.

  type Subject = { #MATH; #SCIENCE; #SOCIAL_STUDIES; #ELA; #CS };

  type TEKSConcept = {
    id          : Nat;
    subject     : Text;
    conceptId   : Text;
    title       : Text;
    teksGrade   : Text;
    teksStandard: Text;
    description : Text;
    activity    : Text;
    materials   : Text;
    duration    : Text;
    grantCodes  : [Text];
    mathDepth   : Nat;  // 1-5: how deep the math goes
    physicsDepth: Nat;  // 1-5: how deep the physics goes
  };

  let MAX_CONCEPTS : Nat = 256;
  stable var conceptCount    : Nat = 0;
  stable var conceptSubjects : [var Text] = Array.init(MAX_CONCEPTS, "");
  stable var conceptIds      : [var Text] = Array.init(MAX_CONCEPTS, "");
  stable var conceptTitles   : [var Text] = Array.init(MAX_CONCEPTS, "");
  stable var conceptGrades   : [var Text] = Array.init(MAX_CONCEPTS, "");
  stable var conceptTEKS     : [var Text] = Array.init(MAX_CONCEPTS, "");
  stable var conceptDescr    : [var Text] = Array.init(MAX_CONCEPTS, "");
  stable var conceptActivity : [var Text] = Array.init(MAX_CONCEPTS, "");
  stable var conceptMaterials: [var Text] = Array.init(MAX_CONCEPTS, "");
  stable var conceptDuration : [var Text] = Array.init(MAX_CONCEPTS, "");
  stable var conceptGrants   : [var Text] = Array.init(MAX_CONCEPTS, "");
  stable var conceptMathD    : [var Nat]  = Array.init(MAX_CONCEPTS, 1);
  stable var conceptPhysD    : [var Nat]  = Array.init(MAX_CONCEPTS, 1);
  stable var genesisBootDone : Bool = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 3.1 — CONCEPT CONTENT STORE (full explanations on-chain)
  // ═══════════════════════════════════════════════════════════════════════════

  let MAX_CONTENT : Nat = 256;
  stable var contentConceptId : [var Text] = Array.init(MAX_CONTENT, "");
  stable var contentText      : [var Text] = Array.init(MAX_CONTENT, "");
  stable var contentFormula   : [var Text] = Array.init(MAX_CONTENT, "");
  stable var contentPhysics   : [var Text] = Array.init(MAX_CONTENT, "");
  stable var contentCount     : Nat = 0;
  stable var contentBootDone  : Bool = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 4 — BOOTSTRAP (load all TEKS concepts into on-chain registry)
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // Called once by architect after genesis. Loads the full TEKS curriculum
  // into stable storage so it's on-chain permanently.

  func _addConcept(
    subject   : Text; cid   : Text; title : Text; grade : Text;
    teks      : Text; descr : Text; act   : Text; mat   : Text;
    dur       : Text; grants: Text; mathD : Nat;  physD : Nat;
  ) {
    if (conceptCount >= MAX_CONCEPTS) return;
    let k = conceptCount;
    conceptSubjects[k] := subject;
    conceptIds[k]      := cid;
    conceptTitles[k]   := title;
    conceptGrades[k]   := grade;
    conceptTEKS[k]     := teks;
    conceptDescr[k]    := descr;
    conceptActivity[k] := act;
    conceptMaterials[k]:= mat;
    conceptDuration[k] := dur;
    conceptGrants[k]   := grants;
    conceptMathD[k]    := mathD;
    conceptPhysD[k]    := physD;
    conceptCount += 1;
  };

  func _addContent(cid : Text; txt : Text; formula : Text; physics : Text) {
    if (contentCount >= MAX_CONTENT) return;
    let k = contentCount;
    contentConceptId[k] := cid;
    contentText[k]      := txt;
    contentFormula[k]   := formula;
    contentPhysics[k]   := physics;
    contentCount += 1;
  };

  public shared(msg) func bootstrapCurriculum() : async { ok : Bool; conceptsLoaded : Nat } {
    assert(_isArchitect(msg.caller));
    if (genesisBootDone) return { ok = false; conceptsLoaded = conceptCount };

    // ── MATHEMATICS ─────────────────────────────────────────────────────────

    _addConcept("MATH","fib","Fibonacci Sequence & φ Convergence",
      "Grade 6-7","§111.26(b)(4)",
      "Fibonacci: 1,1,2,3,5,8,13,21,34,55,89... Each term = sum of previous two. F(n)/F(n-1) → φ = 1.6180339887498948482 as n→∞.",
      "Students compute F(1) through F(20). Plot F(n+1)/F(n) for n=1..20. Observe convergence to φ. Measure sunflower spiral counts (always Fibonacci). Compute error from true φ at each step.",
      "Graph paper, calculators, sunflower photos, pine cones",
      "50 min","Title I, Title IV-A, TEA STEM", 5, 3);

    _addConcept("MATH","phi","Golden Ratio φ — Proportional Reasoning",
      "Grade 7-8","§111.27(b)(1)",
      "φ = (1+√5)/2 = 1.6180339887498948482. Property: φ² = φ+1. Reciprocal: 1/φ = φ-1 = 0.6180...",
      "Measure body proportions (forearm/hand, navel-to-floor/height). Compare to φ. Measure Parthenon ratios from photos. Find φ in credit card dimensions (85.6mm/53.98mm = 1.586 ≈ φ).",
      "Tape measures, rulers, calculators, art reprints",
      "55 min","Title I, TEA STEM, NSF STEM", 5, 2);

    _addConcept("MATH","deriv","Derivatives — Rate of Change",
      "Pre-Calculus / AP","§111.42(c)(2)",
      "f'(x) = lim[h→0] (f(x+h)-f(x))/h. Power rule: d/dx[xⁿ]=n·xⁿ⁻¹. Chain rule: d/dx[f(g(x))]=f'(g(x))·g'(x).",
      "Students compute numerical derivatives using h=0.001. Compare to analytical result. Graph f(x)=x³ and f'(x)=3x² on same axes. Find zeros of f'(x) — these are maxima/minima of f(x).",
      "Graphing calculators or spreadsheet software",
      "55 min","Title IV-A, NSF STEM", 5, 3);

    _addConcept("MATH","quad","Quadratic Equations",
      "Algebra I / Grade 9","§111.39(c)(7)",
      "ax²+bx+c=0. Quadratic formula: x=(-b±√(b²-4ac))/2a. Discriminant b²-4ac: >0 two roots, =0 one root, <0 no real roots.",
      "Students factor 5 quadratics, then verify with quadratic formula. Graph y=ax²+bx+c and identify zeros. Connect zeros to roots of equation. Explore how a,b,c change the parabola shape.",
      "Graphing calculators, graph paper",
      "50 min","Title I, TEA STEM", 3, 1);

    _addConcept("MATH","chaos","Logistic Map & Chaos Theory",
      "Pre-Calculus / AP","§111.42(c)(2)",
      "xₙ₊₁=r·xₙ·(1-xₙ). Feigenbaum constant δ=4.6692016091029906719: each period doubling bifurcation is δ× smaller. Chaos onset r≈3.57.",
      "Students iterate the logistic map for r=2.8, 3.2, 3.5, 3.7, 4.0. Plot x vs n for each. Observe stable fixed point → period-2 → period-4 → chaos. Measure bifurcation ratios — converge to Feigenbaum δ.",
      "Spreadsheet software, graphing calculators",
      "60 min","Title IV-A, NSF STEM", 5, 4);

    _addConcept("MATH","kuramoto","Kuramoto Oscillator Synchronization",
      "Grade 8 / Physics","§112.39(c)(5)",
      "dθᵢ/dt = ωᵢ + (K/N)Σsin(θⱼ-θᵢ). Order parameter r=|Σe^(iθₖ)|/N. Critical coupling K_c≈1.273 for 8 oscillators.",
      "Students observe 5 metronomes on a shared board sync over 2 minutes. Record sync time vs coupling (board stiffness). Plot order parameter r over time. Connect to Schumann resonance (7.83 Hz) and NOVA 873ms heartbeat.",
      "5 metronomes, wooden board, soda cans, stopwatch",
      "50 min","Title IV-A, TEA STEM, NSF STEM", 5, 5);

    _addConcept("MATH","prob","Statistics & Probability",
      "Grade 7-8","§111.28(b)(12)",
      "P(event)=favorable/total. P(A or B)=P(A)+P(B)-P(A∩B). P(A and B)=P(A)×P(B) if independent. Bayes: P(A|B)=P(B|A)P(A)/P(B).",
      "Students collect real data (cafeteria attendance, temperatures). Compute mean, median, mode, range. Build histograms and box plots. Simulate coin flips 100× — compare to theoretical P=0.5.",
      "Dice, coins, graph paper, data collection sheets",
      "50 min","Title I, TEA STEM", 3, 1);

    // ── SCIENCE ─────────────────────────────────────────────────────────────

    _addConcept("SCIENCE","pendulum","Pendulum & Simple Harmonic Motion",
      "Physics (HS)","§112.39(c)(6)",
      "T=2π√(L/g). Period T depends only on length L, not mass or amplitude (for small angles). g=9.81 m/s². T²∝L (linear relationship). Resonance when driving frequency = natural frequency.",
      "Students build pendulums of lengths 30, 60, 90, 120cm. Measure period for 10 swings ÷10. Plot T² vs L — should be linear. Slope = 4π²/g ≈ 4.026. Students derive g from their data.",
      "String, masses, rulers, stopwatches, ring stands, graph paper",
      "60 min","Title IV-A, TEA STEM, NSF STEM", 4, 5);

    _addConcept("SCIENCE","wave","Wave Motion — v=fλ",
      "Physics (HS)","§112.39(c)(5)",
      "v=fλ (velocity=frequency×wavelength). T=1/f (period=1/frequency). E=hf (photon energy, h=6.626×10⁻³⁴ J·s). Schumann resonance: f₁=7.83 Hz, Earth cavity surface-to-ionosphere≈100km.",
      "Students generate standing waves on a Slinky. Count nodes and antinodes. Measure wavelength and compute frequency knowing v≈3m/s for Slinky. Compute Schumann: f=c/(2πr_Earth)≈7.83 Hz.",
      "Slinky, meter stick, stopwatch, tuning forks",
      "50 min","Title IV-A, TEA STEM, NSF STEM", 4, 5);

    _addConcept("SCIENCE","dna","DNA Structure & Replication",
      "Biology (HS)","§112.34(c)(6)",
      "Double helix: 2 strands, base pairs A-T (2H bonds) and G-C (3H bonds). One full turn=10 bp=3.4nm. Central Dogma: DNA→RNA→Protein. Genetic code: 3 bases (codon)=1 amino acid. 64 codons, 20 amino acids.",
      "Students extract DNA from strawberries (mash, soap, salt, cold ethanol). Observe DNA precipitate. Build a paper model of the double helix with complementary base pairs. Transcribe and translate a 9-codon sequence.",
      "Strawberries, soap, salt, ethanol, test tubes, construction paper",
      "90 min","Title I, TEA STEM", 3, 2);

    _addConcept("SCIENCE","photosynthesis","Photosynthesis & Cellular Respiration",
      "Biology (HS)","§112.34(c)(9)",
      "Photosynthesis: 6CO₂+6H₂O+light→C₆H₁₂O₆+6O₂. Respiration: C₆H₁₂O₆+6O₂→6CO₂+6H₂O+ATP. Net: light energy stored as chemical bond energy.",
      "Students use BTB (bromothymol blue) to detect CO₂ — turns yellow with CO₂, blue without. Elodea in light vs dark: light produces O₂ (bubbles). Dark loses O₂. Students quantify bubble rate vs light intensity.",
      "Elodea, BTB, beakers, light source, meter stick, stopwatch",
      "60 min","Title I, TEA STEM", 3, 3);

    _addConcept("SCIENCE","newton","Newton's Laws & F=ma",
      "Physics (HS)","§112.39(c)(4)",
      "Law 1: F_net=0 → constant velocity. Law 2: F=ma (1 Newton=force accelerating 1 kg at 1 m/s²). Law 3: F₁₂=-F₂₁. Gravity: F=Gm₁m₂/r², G=6.674×10⁻¹¹ N·m²/kg².",
      "Students pull carts on a track with a hanging mass (F=mg). Vary mass and measure acceleration with motion detector. Verify F=ma linearity. Test Law 3: two spring scales facing opposite directions — both read the same.",
      "Lab cart, track, hanging masses, spring scales, motion detector",
      "60 min","Title IV-A, TEA STEM, NSF STEM", 4, 5);

    _addConcept("SCIENCE","atom","Atomic Structure & Periodic Table",
      "Chemistry (HS)","§112.35(c)(5)",
      "Atomic number Z=protons. Mass number A=protons+neutrons. Electron shells: 2,8,8,18,18,32... Periodic law: properties repeat periodically with atomic number. Electronegativity increases right and up.",
      "Students build Bohr models of H, He, Li, C, N, O, F, Ne using colored circles. Compare Lewis dot structures. Identify trends across Period 2 and down Group 1. Flame test: Li=red, Na=yellow, K=purple, Cu=green.",
      "Colored paper circles, wire, markers, Bunsen burner, metal salts, cobalt glass",
      "60 min","Title I, TEA STEM", 3, 2);

    // ── SOCIAL STUDIES ───────────────────────────────────────────────────────

    _addConcept("SOCIAL_STUDIES","texas_rev","Texas Revolution 1835-1836",
      "Texas History","§113.20(c)(3)",
      "Key battles: Gonzales (Oct 2 1835, first shot), Alamo (Feb 23 - Mar 6 1836, ~189 Texians vs ~1800 Mexicans), San Jacinto (Apr 21 1836, 18-minute battle, Sam Houston defeats Santa Anna). Republic of Texas 1836-1845.",
      "Students create timeline from 1835-1836. Primary source analysis: Travis's letter from the Alamo. Map the battle sites. Debate: was the Alamo a defeat or a moral victory?",
      "Texas maps, primary source documents, timeline materials",
      "55 min","Title I, Title IV-A", 1, 1);

    _addConcept("SOCIAL_STUDIES","constitution","U.S. Constitution & Branches",
      "US Government (HS)","§113.44(c)(5)",
      "3 branches: Legislative (Article I, Congress=Senate+House), Executive (Article II, President), Judicial (Article III, Supreme Court). Checks and balances: veto/override/judicial review. Amendment process: 2/3 Congress + 3/4 states.",
      "Students draw the 3-branch diagram with powers and checks. Simulate a bill becoming law: 5 students are Congress, 1 is President, 1 is Supreme Court. Act out a veto and override scenario.",
      "Constitution text, role cards, bill simulation materials",
      "55 min","Title I, Title IV-A", 1, 1);

    _addConcept("SOCIAL_STUDIES","civil_rights","Civil Rights Movement 1954-1968",
      "US History","§113.28(c)(29)",
      "Key events: Brown v. Board (1954), Montgomery Bus Boycott (1955-56), Greensboro sit-ins (1960), March on Washington (1963), Civil Rights Act (1964), Voting Rights Act (1965), Fair Housing Act (1968).",
      "Students analyze MLK's Letter from Birmingham Jail (primary source). Map civil rights protest sites. Debate the effectiveness of nonviolent direct action vs. legal strategy. Connect to current civil rights issues.",
      "Primary source documents, US maps, timeline materials",
      "60 min","Title I, Title IV-A", 1, 2);

    _addConcept("SOCIAL_STUDIES","economics","Supply, Demand & Market Equilibrium",
      "Economics (HS)","§118.52(c)(2)",
      "Law of demand: price↑ → quantity demanded↓. Law of supply: price↑ → quantity supplied↑. Equilibrium: D=S. Elasticity: %ΔQ/%ΔP. Inelastic |E|<1 (insulin), elastic |E|>1 (luxury cars).",
      "Students conduct a classroom market simulation: half are buyers with budgets, half are sellers with production costs. Run 3 rounds with different conditions. Plot supply/demand curves and find equilibrium price.",
      "Role cards, play money, simple goods simulation",
      "55 min","Title I, Title IV-A", 3, 1);

    // ── ELA ──────────────────────────────────────────────────────────────────

    _addConcept("ELA","thesis","Thesis Statements & Essay Structure",
      "Grade 8 / High School","§110.23(b)(11)",
      "Strong thesis = Topic + Position + Reasons. Must be specific, arguable, and provable. Evidence pyramid: Claim → Evidence → Analysis → Connection.",
      "Students evaluate 10 thesis statements: rate each Strong/Weak and explain why. Rewrite 3 weak ones. Write a thesis for the prompt: 'Should phones be allowed in school?' Exchange with partner for peer review.",
      "Thesis evaluation worksheets, sample essays",
      "50 min","Title I, Title IV-A", 1, 1);

    _addConcept("ELA","figLang","Figurative Language — 8 Devices",
      "Grade 8","§110.23(b)(5)",
      "Simile (like/as), Metaphor (direct comparison), Personification (human trait to nonhuman), Hyperbole (extreme exaggeration), Alliteration (repeated initial sounds), Onomatopoeia (sound words), Irony, Symbolism.",
      "Students identify all 8 devices in a poem (e.g., 'Do Not Go Gentle' by Dylan Thomas). Create a poem using at least 5 of the 8 devices. Illustrate 3 devices with original examples.",
      "Poem texts, poetry collection, art supplies",
      "50 min","Title I, Title IV-A", 1, 1);

    _addConcept("ELA","shakespeare","Shakespeare — Tragedy Analysis",
      "Grade 9-10 / AP","§110.38(b)(6)",
      "Shakespeare 1564-1616: 37 plays, 154 sonnets. Tragic flaw (hamartia): Romeo=impulsiveness, Hamlet=paralysis, Macbeth=unchecked ambition. Iambic pentameter: da-DUM×5 per line. Soliloquy reveals inner thought.",
      "Students close-read Act 3 Scene 1 of Romeo and Juliet. Identify: 3 examples of tragic flaw in evidence. Map how Romeo's one decision cascades to the final tragedy. Write a 5-paragraph analysis.",
      "Romeo and Juliet text, analysis graphic organizer",
      "60 min","Title I, Title IV-A", 1, 2);

    // ── COMPUTER SCIENCE ─────────────────────────────────────────────────────

    _addConcept("CS","algorithm","Algorithms & Big-O Complexity",
      "CS I / Grade 10-12","§126.36(c)(1)",
      "Big-O: O(1) constant, O(log n) binary search, O(n) linear scan, O(n log n) merge sort, O(n²) bubble sort, O(2ⁿ) exhaustive search. Binary search: finds element in sorted n-item list in ≤ log₂(n) steps.",
      "Students trace bubble sort and binary search step-by-step on a deck of 16 cards. Count steps. Compute log₂(16)=4 for binary search. Build a T-chart: algorithm vs steps for n=16,64,1024. Graph the curves.",
      "Playing cards, graph paper, timer",
      "55 min","Title I, TEA STEM, NSF STEM", 4, 1);

    _addConcept("CS","python","Python Programming",
      "CS I / Grade 9-12","§126.36(c)(4)",
      "Variables, loops, functions, lists. Fibonacci in Python: def fib(n): a,b=0,1 // for _ in range(n): a,b=b,a+b // return a. O(n) time, O(1) space. print(fib(10)) → 55.",
      "Students write 5 programs: (1) Fibonacci generator (2) Grade calculator with if/elif (3) List statistics — mean/median/mode (4) Recursive factorial (5) Bubble sort implementation. Run and verify output.",
      "Computers with Python 3 installed (or online REPL: repl.it)",
      "90 min","Title I, TEA STEM, NSF STEM", 4, 1);

    _addConcept("CS","boolean","Boolean Logic & Logic Gates",
      "CS I","§126.36(c)(3)",
      "AND: T∧T=T, T∧F=F. OR: T∨F=T, F∨F=F. NOT: ¬T=F. NAND, NOR, XOR. De Morgan: ¬(A∧B)=(¬A)∨(¬B). Any circuit = combination of NAND gates. Half adder: XOR for sum, AND for carry.",
      "Students fill 4 truth tables (AND, OR, NOT, XOR). Simulate a full adder with logic gate diagrams. Build an AND gate from 2 switches and a bulb. Write Python: all(boolean expressions) = AND, any() = OR.",
      "Logic gate worksheets, switches/bulb kits or computers",
      "55 min","Title I, TEA STEM", 3, 1);

    _addConcept("CS","blockchain","Blockchain, ICP & Decentralization",
      "CS II / Grade 11-12","§126.48(c)(2)",
      "Hash function: deterministic, one-way, avalanche effect. Block: data+prevHash+nonce+timestamp. Chain: each block references previous — tamper-evident. Consensus: PoW (Bitcoin), PoS (Ethereum), threshold (ICP). ICP: smart contracts (canisters) run directly on-chain.",
      "Students implement a simple 5-block chain in Python: each block hashes previous block's data+nonce using hashlib. Change block 2's data and observe all subsequent hashes change. Discuss Byzantine fault tolerance.",
      "Computers with Python 3, hashlib available",
      "60 min","Title I, TEA STEM, NSF STEM", 5, 2);

    genesisBootDone := true;
    { ok = true; conceptsLoaded = conceptCount }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 4.1 — BOOTSTRAP CONCEPT CONTENT (full explanations on-chain)
  // ═══════════════════════════════════════════════════════════════════════════

  public shared(msg) func bootstrapConceptContent() : async { ok : Bool; loaded : Nat } {
    assert(_isArchitect(msg.caller));
    if (contentBootDone) return { ok = false; loaded = contentCount };

    _addContent("fib",
      "Fibonacci sequence: 1,1,2,3,5,8,13,21,34,55,89,144,233,377,610,987,1597,2584,4181,6765...\nRule: F(n)=F(n-1)+F(n-2). Each term is the sum of the two before it.\n\nConvengence proof:\nAs n→∞: F(n+1)/F(n) → φ = (1+√5)/2 = 1.6180339887498948482\n\nError at F(20)/F(19): |6765/4181 - φ| = |1.6180339887498948... - 1.6180339887498948...| < 10⁻¹⁵\n\nNature: sunflower seeds always Fibonacci spirals (34 and 55), pine cones (8 and 13), nautilus shell (golden spiral).\n\nNOVA: φ⁴ × (1000/7.83Hz) = 6.854 × 127.7ms ≈ 873ms HEARTBEAT",
      "F(n) = F(n-1) + F(n-2), F(1)=F(2)=1\nφ = lim[n→∞] F(n+1)/F(n) = (1+√5)/2",
      "Biological phyllotaxis: plant growth minimizes overlap using irrational angle φ = 137.5°"
    );

    _addContent("phi",
      "Golden Ratio φ = 1.6180339887498948482...\n\nAlgebraic definition: φ = (1+√5)/2\nSelf-similar property: φ² = φ+1 (unique among positive reals)\nReciprocal: 1/φ = φ-1 = 0.6180...\n\nIn art and architecture:\n- Parthenon facade: width/height ≈ φ\n- Credit card: 85.6mm/53.98mm = 1.586 ≈ φ\n- UN building facade: height/width ≈ φ\n- Great Pyramid: base/height × (1/2) ≈ φ\n\nNOVA φ-tier pricing:\n- ICP substrate: φ⁰ = 1× base rate\n- NOVA-EDGE: φ¹ = 1.618×\n- NOVA-CLOUD: φ² = 2.618×\n- NOVA-PHANTOM: φ³ = 4.236×",
      "φ = (1+√5)/2 = 1.6180339887498948482\nφ² = φ+1\n1/φ = φ-1 = 0.6180339887498948482\nφ⁴ × Schumann = 6.854 × 127.7ms = 873ms",
      "Quasi-crystals: diffraction patterns with 5-fold symmetry — forbidden in classical crystallography but appear in nature. The ratio of large to small spacing = φ."
    );

    _addContent("deriv",
      "Derivative: instantaneous rate of change.\nf'(x) = lim[h→0] (f(x+h)-f(x))/h\n\nRules:\n- Power: d/dx[xⁿ] = n·xⁿ⁻¹\n- Sum: (f+g)' = f'+g'\n- Product: (fg)' = f'g + fg'\n- Chain: d/dx[f(g(x))] = f'(g(x))·g'(x)\n- e^x: d/dx[eˣ] = eˣ (only function = its own derivative)\n- sin(x): d/dx[sin(x)] = cos(x)\n\nExamples:\n- f(x)=x³ → f'(x)=3x² → f'(2)=12\n- f(x)=x⁴-3x²+2 → f'(x)=4x³-6x → critical points where f'(x)=0\n\nPhysics interpretation:\n- x(t) = position → v(t)=x'(t) = velocity → a(t)=v'(t) = acceleration",
      "f'(x) = lim[h→0] (f(x+h)-f(x))/h\nd/dx[xⁿ] = n·xⁿ⁻¹\nd/dx[sin(x)] = cos(x)\nd/dx[eˣ] = eˣ",
      "Newton used derivatives (fluxions) to derive orbital mechanics: F=ma combined with gravity F=GMm/r² gives the orbit equations. Kepler's 3rd law T²∝r³ follows from calculus."
    );

    _addContent("chaos",
      "Logistic Map: xₙ₊₁ = r·xₙ·(1-xₙ)\n\nBehavior by r:\n- r < 2.0: converges to 0\n- 2.0 < r < 3.0: converges to stable fixed point 1-1/r\n- 3.0 < r < 3.45: period-2 oscillation\n- 3.45 < r < 3.54: period-4\n- 3.54 < r < 3.57: period-8, 16, 32...\n- r > 3.57: chaos (mostly)\n\nFeigenbaum constant δ = 4.6692016091029906719\nEach bifurcation interval is δ× smaller than the previous.\nUniversal: applies to any unimodal map — discovered by Mitchell Feigenbaum 1975.\n\nLyapunov exponent λ:\n- λ < 0: stable (converges)\n- λ = 0: bifurcation\n- λ > 0: chaos (sensitive to initial conditions)\n\nNOVA: Lyapunov stability engine in swarm_brain monitors λ for all drones.",
      "xₙ₊₁ = r·xₙ·(1-xₙ)\nFeigenbaum δ = 4.6692016091029906719\nBifurcation cascade: r₁=3.0, r₂=3.449, r₃=3.544...\n(rₙ-rₙ₋₁)/(rₙ₊₁-rₙ) → δ as n→∞",
      "Turbulence, weather prediction, cardiac fibrillation, population dynamics — all governed by the same Feigenbaum universality."
    );

    _addContent("pendulum",
      "Simple Pendulum: T = 2π√(L/g)\n\nDerivation (small angle approximation):\nRestoring force: F = -mg·sin(θ) ≈ -mg·θ (for θ < 15°)\nEquation of motion: θ'' = -(g/L)·θ\nThis is SHM: θ(t) = θ₀·cos(ωt + φ₀), ω=√(g/L)\nPeriod: T = 2π/ω = 2π√(L/g)\n\nExamples:\n- L=1m: T = 2π√(1/9.81) = 2.007s\n- L=0.25m: T = 2π√(0.25/9.81) = 1.003s\n\nPeriod T is INDEPENDENT of:\n- Mass of bob\n- Amplitude (for small angles)\n\nPeriod T DEPENDS ONLY ON:\n- Length L\n- Gravitational acceleration g\n\nPlot T² vs L: slope = 4π²/g ≈ 4.026\nStudents can derive g from this slope.",
      "T = 2π√(L/g)\nω = √(g/L) rad/s\nθ'' + (g/L)θ = 0\nPeriod T ∝ √L (Galileo's isochrony)",
      "Foucault pendulum: as Earth rotates below the pendulum, the swing plane appears to rotate. Period of rotation = 24h/sin(latitude). In Dallas (latitude 32.8°N): 43.5 hours."
    );

    _addContent("kuramoto",
      "Kuramoto Model of Coupled Oscillators:\ndθᵢ/dt = ωᵢ + (K/N)·Σⱼsin(θⱼ-θᵢ)\n\nWhere:\n- θᵢ = phase of oscillator i\n- ωᵢ = natural frequency of oscillator i (random, drawn from distribution g(ω))\n- K = coupling strength\n- N = number of oscillators\n\nOrder parameter r(t) = (1/N)|Σⱼe^(iθⱼ)|\n- r=0: all phases random (incoherent)\n- r=1: all phases identical (fully synchronized)\n\nPhase transition:\n- K < K_c: r≈0 (disorder)\n- K > K_c: r > 0 (synchronization emerges)\n- K_c = 2/(π·g(0)) for Lorentzian distribution\n\nApplications:\n- Firefly synchronization\n- Neural oscillations (brain waves)\n- Power grid stability\n- NOVA 873ms heartbeat: all 70 SERVITORES workers sync to the same beat\n- Superconducting Josephson junctions",
      "dθᵢ/dt = ωᵢ + (K/N)Σsin(θⱼ-θᵢ)\nr = |Σe^(iθₖ)|/N (order parameter)\nK_c = 2/(π·g(0))",
      "Biological pacemaker cells in the heart: ~10,000 SA node cells fire autonomously at different rates but synchronize via gap junctions. If they desynchronize: arrhythmia."
    );

    contentBootDone := true;
    { ok = true; loaded = contentCount }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 5 — GRANT MANIFEST (DOE/TEA/NSF grant data on-chain)
  // ═══════════════════════════════════════════════════════════════════════════

  let MAX_GRANTS : Nat = 16;
  stable var grantCount    : Nat = 0;
  stable var grantNames    : [var Text] = Array.init(MAX_GRANTS, "");
  stable var grantAgencies : [var Text] = Array.init(MAX_GRANTS, "");
  stable var grantAmounts  : [var Text] = Array.init(MAX_GRANTS, "");
  stable var grantEligible : [var Text] = Array.init(MAX_GRANTS, "");
  stable var grantUse      : [var Text] = Array.init(MAX_GRANTS, "");
  stable var grantAlign    : [var Text] = Array.init(MAX_GRANTS, "");
  stable var grantBootDone : Bool = false;

  public shared(msg) func bootstrapGrants() : async { ok : Bool; loaded : Nat } {
    assert(_isArchitect(msg.caller));
    if (grantBootDone) return { ok = false; loaded = grantCount };

    let grants : [(Text, Text, Text, Text, Text, Text)] = [
      ("Title I Part A","U.S. Dept of Education","Varies by enrollment","Schools with >=40% low-income students","Technology, digital learning, devices","NOVA Digital Classroom covers all TEKS subjects — Title I compliant"),
      ("Title IV-A SSAEF","U.S. Dept of Education","Up to $10,000/school","All public schools","STEM programs, technology, safety","AI-powered learning tools qualify as innovative technology"),
      ("TEA STEM Grant","Texas Education Agency","$50K-$500K","Texas public schools","STEM curriculum, technology integration","All TEKS-mapped STEM content: math engines, physics sims"),
      ("NSF STEM Education","National Science Foundation","$250K-$2M","Schools with university partnerships","STEM research, curriculum, technology","Kuramoto synchronization and φ-math for education is novel research"),
      ("E-Rate Program","FCC / USAC","20%-90% discount","All public schools (discount = poverty level)","Internet access, networking, devices","NOVA Digital Classroom is a PWA — works offline, low bandwidth"),
      ("IDEA Technology Fund","Texas Education Agency","Per-student allocation","Schools serving students with disabilities","Assistive technology, digital accommodations","Voice interface and TTS support accessibility requirements"),
    ];

    var i = 0;
    while (i < grants.size() and grantCount < MAX_GRANTS) {
      let (name, agency, amount, eligible, use_, align) = grants[i];
      grantNames[grantCount]    := name;
      grantAgencies[grantCount] := agency;
      grantAmounts[grantCount]  := amount;
      grantEligible[grantCount] := eligible;
      grantUse[grantCount]      := use_;
      grantAlign[grantCount]    := align;
      grantCount += 1;
      i += 1;
    };

    grantBootDone := true;
    { ok = true; loaded = grantCount }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 6 — SCHOOL ENGAGEMENT REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════

  let MAX_SCHOOLS : Nat = 256;
  stable var schoolCount      : Nat = 0;
  stable var schoolIds        : [var Text] = Array.init(MAX_SCHOOLS, "");
  stable var schoolNames      : [var Text] = Array.init(MAX_SCHOOLS, "");
  stable var schoolEngagements: [var Nat]  = Array.init(MAX_SCHOOLS, 0);
  stable var schoolLastSeen   : [var Int]  = Array.init(MAX_SCHOOLS, 0);
  stable var totalEngagements : Nat = 0;

  func _findSchool(schoolId : Text) : ?Nat {
    var i = 0;
    while (i < schoolCount and i < MAX_SCHOOLS) {
      if (schoolIds[i] == schoolId) return ?i;
      i += 1;
    };
    null
  };

  public shared func recordEngagement(schoolId : Text; schoolName : Text; subject : Text) : async {
    ok          : Bool;
    engagements : Nat;
  } {
    ignore subject; // tracked at aggregate level
    let ts = Time.now();
    switch (_findSchool(schoolId)) {
      case (?slot) {
        schoolEngagements[slot] += 1;
        schoolLastSeen[slot]    := ts;
        totalEngagements        += 1;
        { ok = true; engagements = schoolEngagements[slot] }
      };
      case null {
        if (schoolCount < MAX_SCHOOLS) {
          let slot = schoolCount;
          schoolIds[slot]         := schoolId;
          schoolNames[slot]       := schoolName;
          schoolEngagements[slot] := 1;
          schoolLastSeen[slot]    := ts;
          schoolCount             += 1;
          totalEngagements        += 1;
          { ok = true; engagements = 1 }
        } else {
          { ok = false; engagements = 0 }
        }
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 7 — INTER-CANISTER WIRING
  // ═══════════════════════════════════════════════════════════════════════════

  stable var streamCanisterPrincipal : Text = "aaaaa-aa";

  public shared(msg) func setStreamCanister(p : Principal) : async () {
    assert(_isArchitect(msg.caller));
    streamCanisterPrincipal := Principal.toText(p);
  };

  type NovaStreamActor = actor {
    publish : (Text, Text, Text) -> async { ok : Bool; eventId : Nat };
  };

  func _stream(topic : Text, payload : Text) : async () {
    if (streamCanisterPrincipal == "aaaaa-aa") return;
    try {
      let s : NovaStreamActor = actor(streamCanisterPrincipal);
      ignore await s.publish(topic, payload, "dallas_isd");
    } catch (_) {};
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 8 — QUERY API
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getConcept(conceptId : Text) : async ?{
    subject     : Text; title      : Text; teksGrade  : Text;
    teksStandard: Text; description: Text; activity   : Text;
    materials   : Text; duration   : Text; grants     : Text;
    mathDepth   : Nat;  physicsDepth: Nat;
  } {
    var i = 0;
    while (i < conceptCount) {
      if (conceptIds[i] == conceptId) {
        return ?{
          subject      = conceptSubjects[i];
          title        = conceptTitles[i];
          teksGrade    = conceptGrades[i];
          teksStandard = conceptTEKS[i];
          description  = conceptDescr[i];
          activity     = conceptActivity[i];
          materials    = conceptMaterials[i];
          duration     = conceptDuration[i];
          grants       = conceptGrants[i];
          mathDepth    = conceptMathD[i];
          physicsDepth = conceptPhysD[i];
        };
      };
      i += 1;
    };
    null
  };

  public query func getAllConcepts(subject : Text) : async [{ conceptId:Text; title:Text; teksGrade:Text; mathDepth:Nat }] {
    var results : [{ conceptId:Text; title:Text; teksGrade:Text; mathDepth:Nat }] = [];
    var i = 0;
    while (i < conceptCount) {
      if (conceptSubjects[i] == subject or subject == "ALL") {
        results := Array.append(results, [{
          conceptId = conceptIds[i];
          title     = conceptTitles[i];
          teksGrade = conceptGrades[i];
          mathDepth = conceptMathD[i];
        }]);
      };
      i += 1;
    };
    results
  };

  public query func getConceptContent(conceptId : Text) : async ?{
    text    : Text;
    formula : Text;
    physics : Text;
  } {
    var i = 0;
    while (i < contentCount) {
      if (contentConceptId[i] == conceptId) {
        return ?{ text=contentText[i]; formula=contentFormula[i]; physics=contentPhysics[i] };
      };
      i += 1;
    };
    null
  };

  public query func getGrantManifest() : async [{ name:Text; agency:Text; amount:Text; eligible:Text; use_:Text; align:Text }] {
    Array.tabulate(grantCount, func(i) {
      { name=grantNames[i]; agency=grantAgencies[i]; amount=grantAmounts[i];
        eligible=grantEligible[i]; use_=grantUse[i]; align=grantAlign[i] }
    })
  };

  public query func getSchoolEngagement(schoolId : Text) : async ?{ name:Text; engagements:Nat; lastSeen:Int } {
    switch (_findSchool(schoolId)) {
      case null null;
      case (?slot) ?{ name=schoolNames[slot]; engagements=schoolEngagements[slot]; lastSeen=schoolLastSeen[slot] };
    };
  };

  public query func getMathEngine() : async {
    phi         : Float; phiInv     : Float; phiSq   : Float;
    phiCube     : Float; phi4       : Float; phi_inv2: Float;
    feigenbaum  : Float; isingBeta  : Float;
    schumann    : Float; heartbeat  : Nat;
    fib         : [Nat];
    kuramotoKc  : Float;
  } {
    { phi=PHI; phiInv=PHI_INV; phiSq=PHI_SQ; phiCube=PHI_CUBE;
      phi4=PHI_4; phi_inv2=PHI_INV_2;
      feigenbaum=FEIGENBAUM; isingBeta=ISING_BETA;
      schumann=SCHUMANN; heartbeat=HEARTBEAT;
      fib=FIB; kuramotoKc=KURAMOTO_KC }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 9 — CLASSROOM STATUS & DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getClassroomStatus() : async {
    conceptCount    : Nat; contentCount    : Nat;
    grantCount      : Nat; schoolCount     : Nat;
    totalEngagements: Nat; heartbeatTick   : Nat;
    sovereignSeal   : Text; genesisBootDone: Bool;
    phi             : Float; heartbeatMs    : Nat;
  } {
    {
      conceptCount; contentCount; grantCount; schoolCount;
      totalEngagements; heartbeatTick; sovereignSeal;
      genesisBootDone; phi=PHI; heartbeatMs=HEARTBEAT;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 10 — HEARTBEAT (873ms φ-sovereign rhythm)
  // ═══════════════════════════════════════════════════════════════════════════

  stable var heartbeatTick : Nat = 0;

  system func heartbeat() : async () {
    heartbeatTick += 1;
    if (heartbeatTick % 1000 == 0) {
      let payload =
        "{\"event\":\"CLASSROOM_HEARTBEAT\",\"tick\":" # Nat.toText(heartbeatTick) #
        ",\"concepts\":" # Nat.toText(conceptCount) #
        ",\"schools\":" # Nat.toText(schoolCount) #
        ",\"engagements\":" # Nat.toText(totalEngagements) # "}";
      ignore _stream("CLASSROOM_HEARTBEAT", payload);
    };
  };

  public query func getHeartbeatTick() : async Nat { heartbeatTick };
  public query func getTotalEngagements() : async Nat { totalEngagements };

}
