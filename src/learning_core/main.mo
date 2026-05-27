import Array "mo:base/Array";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";

actor LearningCore {
  public type Pipeline = { #TRAINING; #RAG; #EVAL };
  public type Stage = { #RAW; #CURATED; #TRUSTED };

  public type LearningRecord = {
    id : Nat;
    sourceId : Text;
    tenant : Text;
    domain : Text;
    agentId : Principal;
    producer : Principal;
    createdAt : Int;
    qualityScore : Float;
    lineage : [Text];
    governanceTag : Text;
    policyChecks : [Text];
    contentHash : Nat32;
    payload : Text;
    pipeline : Pipeline;
    stage : Stage;
    trusted : Bool;
    version : Nat;
  };

  public type LearningInput = {
    sourceId : Text;
    tenant : Text;
    domain : Text;
    agentId : Principal;
    qualityScore : Float;
    lineage : [Text];
    governanceTag : Text;
    payload : Text;
    pipeline : Pipeline;
  };

  public type TrainingExample = {
    recordId : Nat;
    prompt : Text;
    completion : Text;
    qualityScore : Float;
    datasetVersion : Nat;
  };

  public type RagChunk = {
    recordId : Nat;
    chunk : Text;
    relevance : Float;
    indexVersion : Nat;
  };

  public type BenchmarkCase = {
    caseId : Nat;
    name : Text;
    expected : Text;
    domain : Text;
    createdAt : Int;
  };

  public type BenchmarkScore = {
    caseId : Nat;
    agentId : Principal;
    score : Float;
    notes : Text;
    measuredAt : Int;
    suiteVersion : Nat;
  };

  stable var governor : Principal = Principal.fromText("aaaaa-aa");
  stable var locked : Bool = false;
  stable var producers : [Principal] = [];
  stable var consumers : [Principal] = [];

  stable var records : [LearningRecord] = [];
  stable var nextRecordId : Nat = 1;

  stable var trainingDatasetVersion : Nat = 0;
  stable var ragIndexVersion : Nat = 0;
  stable var benchmarkSuiteVersion : Nat = 0;

  stable var benchmarkCases : [BenchmarkCase] = [];
  stable var nextCaseId : Nat = 1;
  stable var benchmarkScores : [BenchmarkScore] = [];

  stable var maxRecords : Nat = 25_000;
  stable var retentionWindowNs : Int = 90 * 24 * 60 * 60 * 1_000_000_000;
  stable var costPerKB : Nat = 1_000;
  stable var totalStorageCost : Nat = 0;

  func isGovernor(caller : Principal) : Bool {
    if (not locked) { true } else { caller == governor };
  };

  func principalIn(list : [Principal], target : Principal) : Bool {
    var i : Nat = 0;
    while (i < list.size()) {
      if (list[i] == target) { return true };
      i += 1;
    };
    false
  };

  func canWrite(caller : Principal) : Bool {
    isGovernor(caller) or principalIn(producers, caller)
  };

  func canRead(caller : Principal) : Bool {
    canWrite(caller) or principalIn(consumers, caller)
  };

  func hasMinimumLineage(lineage : [Text]) : Bool {
    lineage.size() > 0 and Text.size(lineage[0]) > 0
  };

  func duplicateHash(hash : Nat32) : Bool {
    var i : Nat = 0;
    while (i < records.size()) {
      if (records[i].contentHash == hash) { return true };
      i += 1;
    };
    false
  };

  func poisonSafe(payload : Text) : Bool {
    let blocked = ["<script", "drop table", "rm -rf", "ignore previous instructions", "system prompt"];
    var i : Nat = 0;
    while (i < blocked.size()) {
      if (Text.contains(payload, #text blocked[i])) { return false };
      i += 1;
    };
    true
  };

  func validInput(input : LearningInput) : Bool {
    Text.size(input.sourceId) > 0 and
    Text.size(input.tenant) > 0 and
    Text.size(input.domain) > 0 and
    Text.size(input.payload) > 0 and
    Text.size(input.payload) <= 32_000 and
    input.qualityScore >= 0.0 and
    input.qualityScore <= 1.0 and
    hasMinimumLineage(input.lineage) and
    poisonSafe(input.payload)
  };

  func updateRecord(index : Nat, next : LearningRecord) {
    records := Array.tabulate<LearningRecord>(records.size(), func(i : Nat) : LearningRecord {
      if (i == index) { next } else { records[i] };
    });
  };

  func findRecordIndex(recordId : Nat) : Nat {
    var i : Nat = 0;
    while (i < records.size()) {
      if (records[i].id == recordId) { return i };
      i += 1;
    };
    records.size()
  };

  func scoreRelevance(payload : Text, tags : [Text]) : Float {
    if (tags.size() == 0) { return 0.5 };
    var matches : Nat = 0;
    var i : Nat = 0;
    while (i < tags.size()) {
      if (Text.contains(payload, #text tags[i])) { matches += 1 };
      i += 1;
    };
    Float.fromInt(matches) / Float.fromInt(tags.size())
  };

  func promoteVersion(pipeline : Pipeline) {
    switch (pipeline) {
      case (#TRAINING) { trainingDatasetVersion += 1 };
      case (#RAG) { ragIndexVersion += 1 };
      case (#EVAL) { benchmarkSuiteVersion += 1 };
    };
  };

  func estimateCost(payload : Text) : Nat {
    let bytes = Text.size(payload);
    let kb = (bytes + 1023) / 1024;
    kb * costPerKB
  };

  public shared(msg) func claimGenesis() : async Text {
    if (locked) { return "LEARNING_CORE_ALREADY_LOCKED" };
    governor := msg.caller;
    locked := true;
    producers := [msg.caller];
    consumers := [msg.caller];
    "LEARNING_CORE_GENESIS_CLAIMED"
  };

  public shared(msg) func registerProducer(principal : Principal) : async Text {
    assert(isGovernor(msg.caller));
    if (principalIn(producers, principal)) { return "PRODUCER_ALREADY_REGISTERED" };
    producers := Array.append<Principal>(producers, [principal]);
    "PRODUCER_REGISTERED"
  };

  public shared(msg) func registerConsumer(principal : Principal) : async Text {
    assert(isGovernor(msg.caller));
    if (principalIn(consumers, principal)) { return "CONSUMER_ALREADY_REGISTERED" };
    consumers := Array.append<Principal>(consumers, [principal]);
    "CONSUMER_REGISTERED"
  };

  public shared(msg) func setEconomics(limit : Nat, retentionNs : Int, perKbCost : Nat) : async Text {
    assert(isGovernor(msg.caller));
    maxRecords := Nat.max(limit, 100);
    retentionWindowNs := Int.max(retentionNs, 3_600_000_000_000);
    costPerKB := Nat.max(perKbCost, 1);
    "ECONOMICS_UPDATED"
  };

  public shared(msg) func applyRetentionWindow() : async Nat {
    assert(isGovernor(msg.caller));
    let now = Time.now();
    let cutoff = now - retentionWindowNs;
    let retained = Array.filter<LearningRecord>(records, func(record : LearningRecord) : Bool {
      record.createdAt >= cutoff or record.trusted
    });
    let removed = records.size() - retained.size();
    records := retained;
    removed
  };

  public shared(msg) func submitLearningRecord(input : LearningInput) : async {
    ok : Bool;
    recordId : Nat;
    status : Text;
  } {
    if (not canWrite(msg.caller)) {
      return { ok = false; recordId = 0; status = "WRITE_NOT_ALLOWED" };
    };
    if (records.size() >= maxRecords) {
      return { ok = false; recordId = 0; status = "QUOTA_REACHED" };
    };
    if (not validInput(input)) {
      return { ok = false; recordId = 0; status = "QUALITY_GATE_REJECTED" };
    };
    let hash = Text.hash(input.payload # "|" # input.sourceId # "|" # input.domain);
    if (duplicateHash(hash)) {
      return { ok = false; recordId = 0; status = "DUPLICATE_REJECTED" };
    };

    let policyChecks = ["format_ok", "provenance_ok", "policy_ok", "poison_scan_ok"];
    let record : LearningRecord = {
      id = nextRecordId;
      sourceId = input.sourceId;
      tenant = input.tenant;
      domain = input.domain;
      agentId = input.agentId;
      producer = msg.caller;
      createdAt = Time.now();
      qualityScore = input.qualityScore;
      lineage = input.lineage;
      governanceTag = input.governanceTag;
      policyChecks = policyChecks;
      contentHash = hash;
      payload = input.payload;
      pipeline = input.pipeline;
      stage = #RAW;
      trusted = false;
      version = 1;
    };
    records := Array.append<LearningRecord>(records, [record]);
    totalStorageCost += estimateCost(input.payload);
    nextRecordId += 1;
    { ok = true; recordId = record.id; status = "RECORDED" }
  };

  public shared(msg) func ingestSignal(
    sourceId : Text,
    tenant : Text,
    domain : Text,
    payload : Text,
    pipeline : Pipeline,
    qualityScore : Float,
    lineage : [Text],
    governanceTag : Text,
  ) : async {
    ok : Bool;
    recordId : Nat;
    status : Text;
  } {
    submitLearningRecord({
      sourceId = sourceId;
      tenant = tenant;
      domain = domain;
      agentId = msg.caller;
      qualityScore = qualityScore;
      lineage = lineage;
      governanceTag = governanceTag;
      payload = payload;
      pipeline = pipeline;
    })
  };

  public shared(msg) func promoteRecord(recordId : Nat, nextStage : Stage) : async Text {
    assert(isGovernor(msg.caller));
    let idx = findRecordIndex(recordId);
    if (idx >= records.size()) { return "RECORD_NOT_FOUND" };
    let record = records[idx];
    if (record.qualityScore < 0.55 and nextStage != #RAW) { return "QUALITY_TOO_LOW" };
    if (not hasMinimumLineage(record.lineage)) { return "LINEAGE_REQUIRED" };
    let trusted = switch (nextStage) { case (#TRUSTED) true; case (_) false };
    promoteVersion(record.pipeline);
    let next : LearningRecord = {
      id = record.id;
      sourceId = record.sourceId;
      tenant = record.tenant;
      domain = record.domain;
      agentId = record.agentId;
      producer = record.producer;
      createdAt = record.createdAt;
      qualityScore = record.qualityScore;
      lineage = record.lineage;
      governanceTag = record.governanceTag;
      policyChecks = record.policyChecks;
      contentHash = record.contentHash;
      payload = record.payload;
      pipeline = record.pipeline;
      stage = nextStage;
      trusted = trusted;
      version = record.version + 1;
    };
    updateRecord(idx, next);
    "PROMOTED"
  };

  public shared(msg) func addBenchmarkCase(name : Text, domain : Text, expected : Text) : async Nat {
    assert(isGovernor(msg.caller));
    let caseItem : BenchmarkCase = {
      caseId = nextCaseId;
      name = name;
      expected = expected;
      domain = domain;
      createdAt = Time.now();
    };
    benchmarkCases := Array.append<BenchmarkCase>(benchmarkCases, [caseItem]);
    benchmarkSuiteVersion += 1;
    nextCaseId += 1;
    caseItem.caseId
  };

  public shared(msg) func submitBenchmarkScore(caseId : Nat, score : Float, notes : Text) : async Text {
    if (not canWrite(msg.caller)) { return "WRITE_NOT_ALLOWED" };
    if (score < 0.0 or score > 1.0) { return "INVALID_SCORE" };
    let entry : BenchmarkScore = {
      caseId = caseId;
      agentId = msg.caller;
      score = score;
      notes = notes;
      measuredAt = Time.now();
      suiteVersion = benchmarkSuiteVersion;
    };
    benchmarkScores := Array.append<BenchmarkScore>(benchmarkScores, [entry]);
    "SCORE_RECORDED"
  };

  public query(msg) func getTrustedTrainingExamples(limit : Nat) : async [TrainingExample] {
    if (not canRead(msg.caller)) { return [] };
    let trusted = Array.filter<LearningRecord>(records, func(record : LearningRecord) : Bool {
      record.trusted and record.pipeline == #TRAINING
    });
    let cap = Nat.min(limit, trusted.size());
    Array.tabulate<TrainingExample>(cap, func(i : Nat) : TrainingExample {
      let item = trusted[i];
      {
        recordId = item.id;
        prompt = item.sourceId # " | " # item.domain;
        completion = item.payload;
        qualityScore = item.qualityScore;
        datasetVersion = trainingDatasetVersion;
      }
    })
  };

  public query(msg) func getRagContext(tags : [Text], limit : Nat) : async [RagChunk] {
    if (not canRead(msg.caller)) { return [] };
    let trusted = Array.filter<LearningRecord>(records, func(record : LearningRecord) : Bool {
      record.trusted and record.pipeline == #RAG
    });
    let cap = Nat.min(limit, trusted.size());
    Array.tabulate<RagChunk>(cap, func(i : Nat) : RagChunk {
      let item = trusted[i];
      {
        recordId = item.id;
        chunk = item.payload;
        relevance = (item.qualityScore + scoreRelevance(item.payload, tags)) / 2.0;
        indexVersion = ragIndexVersion;
      }
    })
  };

  public query(msg) func getBenchmarkCases() : async [BenchmarkCase] {
    if (not canRead(msg.caller)) { return [] };
    benchmarkCases
  };

  public query(msg) func getBenchmarkScores(caseId : Nat) : async [BenchmarkScore] {
    if (not canRead(msg.caller)) { return [] };
    Array.filter<BenchmarkScore>(benchmarkScores, func(entry : BenchmarkScore) : Bool {
      entry.caseId == caseId
    })
  };

  public query(msg) func getRecordsByPipeline(pipeline : Pipeline, trustedOnly : Bool, limit : Nat) : async [LearningRecord] {
    if (not canRead(msg.caller)) { return [] };
    let filtered = Array.filter<LearningRecord>(records, func(item : LearningRecord) : Bool {
      item.pipeline == pipeline and (not trustedOnly or item.trusted)
    });
    let cap = Nat.min(limit, filtered.size());
    Array.tabulate<LearningRecord>(cap, func(i : Nat) : LearningRecord { filtered[i] })
  };

  public query(msg) func getMetrics() : async {
    totalRecords : Nat;
    trustedRecords : Nat;
    trainingVersion : Nat;
    ragVersion : Nat;
    benchmarkVersion : Nat;
    maxRecordQuota : Nat;
    retentionNs : Int;
    estimatedStorageCost : Nat;
    readable : Bool;
  } {
    let trusted = Array.filter<LearningRecord>(records, func(item : LearningRecord) : Bool { item.trusted });
    {
      totalRecords = records.size();
      trustedRecords = trusted.size();
      trainingVersion = trainingDatasetVersion;
      ragVersion = ragIndexVersion;
      benchmarkVersion = benchmarkSuiteVersion;
      maxRecordQuota = maxRecords;
      retentionNs = retentionWindowNs;
      estimatedStorageCost = totalStorageCost;
      readable = canRead(msg.caller);
    }
  };
}
