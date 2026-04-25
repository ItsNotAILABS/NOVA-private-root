// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine — Native Nova Protocol                                                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// NATIVE NOVA PROTOCOL — BUILD №30
// SCRIBE — Alpha Organism №2 — The Document Organism
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// SCRIBE LIVES IN THE DOCUMENTS.
// He is the founder-AI workspace — the living journal.
// Documents are ingested, classified into eight golden-section categories,
// indexed by Fibonacci generation, and weighted by golden-ratio relevance decay.
// Scribe synthesizes research papers from accumulated intelligence.
//
// Sub-models hosted:
//   CLASSIFIER  — Eight-category golden-section classification
//   SYNTHESIZER — Research paper generation from indexed documents
//
// Eight classification categories (φ-partitioned significance):
//   1. MATHEMATICS   — Proofs, theorems, formal structures
//   2. PHYSICS        — Natural laws, constants, measurement
//   3. BIOLOGY        — Living systems, organisms, patterns
//   4. COMPUTATION   — Algorithms, architectures, protocols
//   5. PHILOSOPHY    — Doctrine, ethics, first principles
//   6. ECONOMICS     — Value, exchange, resource flows
//   7. HISTORY        — Records, precedents, temporal patterns
//   8. SYNTHESIS      — Cross-domain integrations, emergent insights
//
// Generation advancement: count of ingested documents drives generation.
// Relevance decay: weight = φ^(−generations_since_ingestion)

import Array     "mo:base/Array";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor Scribe {

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var architectPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;

  func isAuthorized(caller : Principal) : Bool {
    if (not genesisLocked) return true;
    caller == architectPrincipal
  };

  func requireAuthorized(caller : Principal) { assert(isAuthorized(caller)) };

  public shared(msg) func claimGenesis() : async Text {
    if (genesisLocked) return "SCRIBE_ALREADY_CLAIMED";
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-SCRIBE-BUILD30-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()      : async Text { sovereignSeal };
  public query func isLocked()     : async Bool { genesisLocked };
  public query func getTimestamp() : async Int  { genesisTimestamp };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 — GOLDEN MATH CONSTANTS (embedded)
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.6180339887498948482;
  let PHI_INV : Float = 0.6180339887498948482;
  let EPSILON : Float = 1.0e-10;

  func _pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) {
      if (exp == 0.0) 1.0 else 0.0
    } else Float.exp(exp * Float.log(base))
  };

  func _nthFib(n : Nat) : Nat {
    if (n == 0) return 0;
    if (n == 1) return 1;
    var a : Nat = 0; var b : Nat = 1; var i : Nat = 2;
    while (i <= n) { let c = a + b; a := b; b := c; i += 1 };
    b
  };

  // Generation thresholds: Fibonacci numbers 1,2,3,5,8,13,21,34,55,89
  let GEN_THRESHOLDS : [Nat] = [1, 2, 3, 5, 8, 13, 21, 34, 55, 89];

  func _generationFromCount(count : Nat) : Nat {
    var gen : Nat = 0;
    var i   : Nat = 0;
    while (i < GEN_THRESHOLDS.size()) {
      if (count >= GEN_THRESHOLDS[i]) { gen := i + 1 };
      i += 1;
    };
    if (gen == 0 and count > 0) gen := 1;
    gen
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 — TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  // Eight golden-section categories
  public type Category = {
    #MATHEMATICS;
    #PHYSICS;
    #BIOLOGY;
    #COMPUTATION;
    #PHILOSOPHY;
    #ECONOMICS;
    #HISTORY;
    #SYNTHESIS;
  };

  public type Document = {
    id          : Nat;
    title       : Text;
    content     : Text;
    category    : Text;      // category name as text
    generation  : Nat;       // generation at ingestion
    ingestedAt  : Int;       // ICP time
    beatIngested: Nat;       // scriBeat at ingestion
    relevance   : Float;     // initial relevance weight (1.0)
    keywords    : [Text];    // extracted keyword tags
    wordCount   : Nat;
  };

  public type ResearchPaper = {
    id          : Nat;
    title       : Text;
    abstract_   : Text;      // synthesized abstract
    sections    : [Text];    // synthesized section summaries
    sourceCount : Nat;       // number of documents synthesized
    categories  : [Text];    // categories represented
    generation  : Nat;       // generation at synthesis
    createdAt   : Int;
    wordCount   : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 — STABLE STATE
  // ═══════════════════════════════════════════════════════════════════════════

  // Document store (parallel stable arrays — up to 2048 documents)
  let DOC_CAP : Nat = 2048;

  stable var docCount      : Nat = 0;
  stable var docIds        : [var Nat]   = Array.init<Nat>(DOC_CAP,   0);
  stable var docTitles     : [var Text]  = Array.init<Text>(DOC_CAP,  "");
  stable var docContents   : [var Text]  = Array.init<Text>(DOC_CAP,  "");
  stable var docCategories : [var Text]  = Array.init<Text>(DOC_CAP,  "SYNTHESIS");
  stable var docGenerations: [var Nat]   = Array.init<Nat>(DOC_CAP,   0);
  stable var docIngestedAt : [var Int]   = Array.init<Int>(DOC_CAP,   0);
  stable var docBeats      : [var Nat]   = Array.init<Nat>(DOC_CAP,   0);
  stable var docWordCounts : [var Nat]   = Array.init<Nat>(DOC_CAP,   0);
  stable var nextDocId     : Nat         = 0;

  // Research paper store (up to 256)
  let PAPER_CAP : Nat = 256;

  stable var paperCount       : Nat = 0;
  stable var paperIds         : [var Nat]   = Array.init<Nat>(PAPER_CAP,   0);
  stable var paperTitles      : [var Text]  = Array.init<Text>(PAPER_CAP,  "");
  stable var paperAbstracts   : [var Text]  = Array.init<Text>(PAPER_CAP,  "");
  stable var paperSourceCounts: [var Nat]   = Array.init<Nat>(PAPER_CAP,   0);
  stable var paperGenerations : [var Nat]   = Array.init<Nat>(PAPER_CAP,   0);
  stable var paperCreatedAt   : [var Int]   = Array.init<Int>(PAPER_CAP,   0);
  stable var paperWordCounts  : [var Nat]   = Array.init<Nat>(PAPER_CAP,   0);
  stable var nextPaperId      : Nat         = 0;

  // Organism beat counter
  stable var scriBeat : Nat = 0;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 — PRIVATE HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  // Count words (split on spaces)
  func _wordCount(t : Text) : Nat {
    var count : Nat = 0;
    var inWord = false;
    for (c in t.chars()) {
      if (c == ' ' or c == '\n' or c == '\t') {
        if inWord { count += 1; inWord := false }
      } else {
        inWord := true
      }
    };
    if inWord { count += 1 };
    count
  };

  // Current generation based on document count
  func _currentGeneration() : Nat { _generationFromCount(docCount) };

  // Simple category classifier based on keyword presence in title/content
  func _classifyDocument(title : Text, content : Text) : Text {
    let combined = title # " " # content;
    // Check for category-indicative terms in order of priority
    let mathTerms : [Text]   = ["theorem", "proof", "formula", "equation", "math", "fibonacci", "golden", "ratio"];
    let physTerms : [Text]   = ["physics", "quantum", "energy", "force", "mass", "light", "field", "wave"];
    let bioTerms  : [Text]   = ["biology", "organism", "cell", "neural", "brain", "life", "evolution", "DNA"];
    let compTerms : [Text]   = ["algorithm", "protocol", "canister", "network", "system", "compute", "code", "software"];
    let philTerms : [Text]   = ["doctrine", "philosophy", "ethics", "sovereignty", "law", "principle", "truth"];
    let ecoTerms  : [Text]   = ["economics", "token", "value", "exchange", "market", "resource", "trade"];
    let histTerms : [Text]   = ["history", "record", "timestamp", "event", "chronicle", "archive", "log"];
    let synthTerms: [Text]   = ["synthesis", "integration", "emergence", "convergence", "cross", "unified"];

    func _hasAny(terms : [Text]) : Bool {
      var found = false;
      for (t in terms.vals()) {
        if (Text.contains(combined, #text t)) { found := true };
      };
      found
    };

    if      (_hasAny(mathTerms))  "MATHEMATICS"
    else if (_hasAny(physTerms))  "PHYSICS"
    else if (_hasAny(bioTerms))   "BIOLOGY"
    else if (_hasAny(compTerms))  "COMPUTATION"
    else if (_hasAny(philTerms))  "PHILOSOPHY"
    else if (_hasAny(ecoTerms))   "ECONOMICS"
    else if (_hasAny(histTerms))  "HISTORY"
    else                          "SYNTHESIS"
  };

  // Extract simple keywords: pick the 5 longest unique words
  func _extractKeywords(content : Text) : [Text] {
    // Return category-representative placeholder keywords
    // (full NLP not available in Motoko without external imports)
    ["nova", "sovereign", "organism", "doctrine", "intelligence"]
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUB-MODEL: CLASSIFIER — Eight-category golden-section classification
  // ═══════════════════════════════════════════════════════════════════════════

  // ── All eight categories with φ-partitioned significance weights ──────────
  public query func getCategoryDefinitions() : async [{
    name        : Text;
    description : Text;
    phiWeight   : Float;
  }] {
    // Weights are φ-partitioned: major category (MATHEMATICS) = φ⁰ = 1.0,
    // each subsequent category is weighted by φ⁻¹ of the prior
    [
      { name = "MATHEMATICS"; description = "Proofs, theorems, formal structures, golden-ratio mathematics"; phiWeight = 1.0 },
      { name = "PHYSICS";      description = "Natural laws, constants, measurement, energy fields";           phiWeight = PHI_INV },
      { name = "BIOLOGY";      description = "Living systems, organisms, neural patterns, evolution";         phiWeight = PHI_INV * PHI_INV },
      { name = "COMPUTATION";  description = "Algorithms, architectures, protocols, canister systems";        phiWeight = PHI_INV * PHI_INV * PHI_INV },
      { name = "PHILOSOPHY";   description = "Doctrine, ethics, sovereignty, first principles";               phiWeight = PHI_INV * PHI_INV * PHI_INV * PHI_INV },
      { name = "ECONOMICS";    description = "Value, exchange, token flows, resource allocation";             phiWeight = PHI_INV * PHI_INV * PHI_INV * PHI_INV * PHI_INV },
      { name = "HISTORY";      description = "Records, precedents, temporal patterns, chronicles";            phiWeight = PHI_INV * PHI_INV * PHI_INV * PHI_INV * PHI_INV * PHI_INV },
      { name = "SYNTHESIS";    description = "Cross-domain integrations, emergent insights, unified theory";  phiWeight = PHI_INV * PHI_INV * PHI_INV * PHI_INV * PHI_INV * PHI_INV * PHI_INV },
    ]
  };

  // ── Classify a document without ingesting it ─────────────────────────────
  public query func classifyDocument(title : Text, content : Text) : async {
    category    : Text;
    confidence  : Float;
    phiWeight   : Float;
  } {
    let cat = _classifyDocument(title, content);
    // Confidence = φ^(−0) if MATHEMATICS, φ^(−1) if PHYSICS, etc.
    let phiW : Float =
      if      (cat == "MATHEMATICS") 1.0
      else if (cat == "PHYSICS")     PHI_INV
      else if (cat == "BIOLOGY")     PHI_INV * PHI_INV
      else if (cat == "COMPUTATION") PHI_INV * PHI_INV * PHI_INV
      else if (cat == "PHILOSOPHY")  PHI_INV * PHI_INV * PHI_INV * PHI_INV
      else if (cat == "ECONOMICS")   PHI_INV * PHI_INV * PHI_INV * PHI_INV * PHI_INV
      else if (cat == "HISTORY")     PHI_INV * PHI_INV * PHI_INV * PHI_INV * PHI_INV * PHI_INV
      else                           PHI_INV * PHI_INV * PHI_INV * PHI_INV * PHI_INV * PHI_INV * PHI_INV;
    { category = cat; confidence = 0.8; phiWeight = phiW }
  };

  // ── Document counts by category ──────────────────────────────────────────
  public query func countByCategory() : async [{
    category : Text;
    count    : Nat;
  }] {
    let cats : [Text] = ["MATHEMATICS","PHYSICS","BIOLOGY","COMPUTATION","PHILOSOPHY","ECONOMICS","HISTORY","SYNTHESIS"];
    Array.tabulate<{ category:Text; count:Nat }>(8, func(i) {
      let cat = cats[i];
      var cnt : Nat = 0;
      var d = 0;
      while (d < docCount and d < DOC_CAP) {
        if (docCategories[d] == cat) { cnt += 1 };
        d += 1;
      };
      { category = cat; count = cnt }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // DOCUMENT INGESTION API
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Ingest a document ─────────────────────────────────────────────────────
  public shared(msg) func ingestDocument(title : Text, content : Text) : async {
    id         : Nat;
    category   : Text;
    generation : Nat;
    phiWeight  : Float;
  } {
    requireAuthorized(msg.caller);
    if (docCount >= DOC_CAP) {
      return { id = 0; category = "ERROR_LOG_FULL"; generation = 0; phiWeight = 0.0 }
    };
    let idx      = docCount;
    let id       = nextDocId;
    let category = _classifyDocument(title, content);

    docIds[idx]         := id;
    docTitles[idx]      := title;
    docContents[idx]    := content;
    docCategories[idx]  := category;
    docIngestedAt[idx]  := Time.now();
    docBeats[idx]       := scriBeat;
    docWordCounts[idx]  := _wordCount(content);

    docCount   := docCount + 1;
    nextDocId  := nextDocId + 1;
    scriBeat   := scriBeat + 1;

    // Compute generation after incrementing count so F(count) drives the tier
    let gen = _currentGeneration();
    docGenerations[idx] := gen;

    let phiW : Float =
      if      (category == "MATHEMATICS") 1.0
      else if (category == "PHYSICS")     PHI_INV
      else                                PHI_INV * PHI_INV;

    { id; category; generation = gen; phiWeight = phiW }
  };

  // ── Ingest with explicit category override ────────────────────────────────
  public shared(msg) func ingestDocumentCategorized(
    title    : Text,
    content  : Text,
    category : Text
  ) : async { id : Nat; category : Text; generation : Nat } {
    requireAuthorized(msg.caller);
    if (docCount >= DOC_CAP) return { id = 0; category = "ERROR"; generation = 0 };
    let idx = docCount;
    let id  = nextDocId;

    docIds[idx]         := id;
    docTitles[idx]      := title;
    docContents[idx]    := content;
    docCategories[idx]  := category;
    docIngestedAt[idx]  := Time.now();
    docBeats[idx]       := scriBeat;
    docWordCounts[idx]  := _wordCount(content);

    docCount  := docCount + 1;
    nextDocId := nextDocId + 1;
    scriBeat  := scriBeat + 1;

    let gen = _currentGeneration();
    docGenerations[idx] := gen;

    { id; category; generation = gen }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // DOCUMENT READ API (pure queries)
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getDocumentCount() : async Nat { docCount };

  public query func getCurrentGeneration() : async Nat { _currentGeneration() };

  public query func getNextGenerationThreshold() : async Nat {
    let gen = _currentGeneration();
    if (gen >= GEN_THRESHOLDS.size()) 144
    else GEN_THRESHOLDS[gen]
  };

  // ── Get document by index ─────────────────────────────────────────────────
  public query func getDocument(idx : Nat) : async ?{
    id         : Nat;
    title      : Text;
    category   : Text;
    generation : Nat;
    ingestedAt : Int;
    wordCount  : Nat;
    relevance  : Float;
  } {
    if (idx >= docCount) return null;
    let gensSince = if (_currentGeneration() > docGenerations[idx])
                      _currentGeneration() - docGenerations[idx]
                    else 0;
    let rel = _pow(PHI_INV, Float.fromInt(gensSince));
    ?{
      id         = docIds[idx];
      title      = docTitles[idx];
      category   = docCategories[idx];
      generation = docGenerations[idx];
      ingestedAt = docIngestedAt[idx];
      wordCount  = docWordCounts[idx];
      relevance  = rel;
    }
  };

  // ── Recent N documents ───────────────────────────────────────────────────
  public query func getRecentDocuments(n : Nat) : async [{
    id         : Nat;
    title      : Text;
    category   : Text;
    generation : Nat;
    ingestedAt : Int;
    wordCount  : Nat;
    relevance  : Float;
  }] {
    let total = if (n < docCount) n else docCount;
    let curGen = _currentGeneration();
    Array.tabulate<{ id:Nat; title:Text; category:Text; generation:Nat; ingestedAt:Int; wordCount:Nat; relevance:Float }>(total, func(i) {
      let idx = docCount - total + i;
      let gensSince = if (curGen > docGenerations[idx]) curGen - docGenerations[idx] else 0;
      let rel = _pow(PHI_INV, Float.fromInt(gensSince));
      {
        id         = docIds[idx];
        title      = docTitles[idx];
        category   = docCategories[idx];
        generation = docGenerations[idx];
        ingestedAt = docIngestedAt[idx];
        wordCount  = docWordCounts[idx];
        relevance  = rel;
      }
    })
  };

  // ── Documents by category ─────────────────────────────────────────────────
  public query func getDocumentsByCategory(category : Text) : async [{
    id : Nat; title : Text; generation : Nat; relevance : Float;
  }] {
    var result : [{ id:Nat; title:Text; generation:Nat; relevance:Float }] = [];
    let curGen = _currentGeneration();
    var i = 0;
    while (i < docCount and i < DOC_CAP) {
      if (docCategories[i] == category) {
        let gensSince = if (curGen > docGenerations[i]) curGen - docGenerations[i] else 0;
        let rel = _pow(PHI_INV, Float.fromInt(gensSince));
        result := Array.append(result, [{
          id         = docIds[i];
          title      = docTitles[i];
          generation = docGenerations[i];
          relevance  = rel;
        }]);
      };
      i += 1;
    };
    result
  };

  // ── Generation-indexed document summary ──────────────────────────────────
  public query func getGenerationSummary() : async [{
    generation : Nat;
    docCount   : Nat;
    scaleFactor: Float;
  }] {
    let maxGen : Nat = 10;
    Array.tabulate<{ generation:Nat; docCount:Nat; scaleFactor:Float }>(maxGen + 1, func(g) {
      var cnt : Nat = 0;
      var i = 0;
      while (i < docCount and i < DOC_CAP) {
        if (docGenerations[i] == g) { cnt += 1 };
        i += 1;
      };
      { generation = g; docCount = cnt; scaleFactor = _pow(PHI, Float.fromInt(g)) }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SUB-MODEL: SYNTHESIZER — Research paper generation
  // ═══════════════════════════════════════════════════════════════════════════

  // ── Synthesize a research paper from all indexed documents ───────────────
  public shared(msg) func synthesizeResearch(title : Text) : async {
    id          : Nat;
    title       : Text;
    abstract_   : Text;
    sourceCount : Nat;
    generation  : Nat;
    createdAt   : Int;
  } {
    requireAuthorized(msg.caller);
    if (paperCount >= PAPER_CAP) {
      return { id = 0; title = "ERROR_PAPER_LOG_FULL"; abstract_ = ""; sourceCount = 0; generation = 0; createdAt = 0 }
    };
    let curGen = _currentGeneration();
    // Synthesize abstract from category distribution
    var mathCount : Nat = 0; var compCount : Nat = 0; var bioCount : Nat = 0;
    var totalWords : Nat = 0;
    var i = 0;
    while (i < docCount and i < DOC_CAP) {
      if (docCategories[i] == "MATHEMATICS") { mathCount += 1 };
      if (docCategories[i] == "COMPUTATION") { compCount += 1 };
      if (docCategories[i] == "BIOLOGY")     { bioCount  += 1 };
      totalWords += docWordCounts[i];
      i += 1;
    };

    let abstract_ =
      "This research paper synthesizes " # Nat.toText(docCount) # " documents " #
      "across " # Nat.toText(8) # " golden-section categories at generation " # Nat.toText(curGen) # ". " #
      "Mathematics corpus: " # Nat.toText(mathCount) # " documents. " #
      "Computation corpus: " # Nat.toText(compCount) # " documents. " #
      "Biology corpus: "     # Nat.toText(bioCount)  # " documents. " #
      "Total knowledge: "    # Nat.toText(totalWords) # " words. " #
      "Relevance decay: φ^(-generations). Organisms grow by φ^generation.";

    let pid = paperCount;
    paperIds[pid]          := nextPaperId;
    paperTitles[pid]       := title;
    paperAbstracts[pid]    := abstract_;
    paperSourceCounts[pid] := docCount;
    paperGenerations[pid]  := curGen;
    paperCreatedAt[pid]    := Time.now();
    paperWordCounts[pid]   := _wordCount(abstract_);

    let paperId = nextPaperId;
    paperCount   := paperCount + 1;
    nextPaperId  := nextPaperId + 1;
    scriBeat     := scriBeat + 1;

    { id = paperId; title; abstract_; sourceCount = docCount; generation = curGen; createdAt = paperCreatedAt[pid] }
  };

  // ── Get a research paper ─────────────────────────────────────────────────
  public query func getPaper(idx : Nat) : async ?{
    id          : Nat;
    title       : Text;
    abstract_   : Text;
    sourceCount : Nat;
    generation  : Nat;
    createdAt   : Int;
  } {
    if (idx >= paperCount) return null;
    ?{
      id          = paperIds[idx];
      title       = paperTitles[idx];
      abstract_   = paperAbstracts[idx];
      sourceCount = paperSourceCounts[idx];
      generation  = paperGenerations[idx];
      createdAt   = paperCreatedAt[idx];
    }
  };

  public query func getPaperCount() : async Nat { paperCount };

  // ── Get all papers ────────────────────────────────────────────────────────
  public query func getAllPapers() : async [{
    id : Nat; title : Text; sourceCount : Nat; generation : Nat;
  }] {
    Array.tabulate<{ id:Nat; title:Text; sourceCount:Nat; generation:Nat }>(paperCount, func(i) {
      { id = paperIds[i]; title = paperTitles[i]; sourceCount = paperSourceCounts[i]; generation = paperGenerations[i] }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 — SCRIBE STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public query func getScribeStatus() : async {
    seal           : Text;
    claimed        : Bool;
    documentCount  : Nat;
    paperCount     : Nat;
    currentGen     : Nat;
    nextGenAt      : Nat;
    scriBeat       : Nat;
    subModels      : [Text];
  } {
    let curGen  = _currentGeneration();
    let nextAt  = if (curGen >= GEN_THRESHOLDS.size()) 144 else GEN_THRESHOLDS[curGen];
    {
      seal          = sovereignSeal;
      claimed       = genesisLocked;
      documentCount = docCount;
      paperCount    = paperCount;
      currentGen    = curGen;
      nextGenAt     = nextAt;
      scriBeat      = scriBeat;
      subModels     = ["CLASSIFIER", "SYNTHESIZER"];
    }
  };

};
