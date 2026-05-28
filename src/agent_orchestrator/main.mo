import Array "mo:base/Array";
import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import LearningCore "canister:learning_core";

actor AgentOrchestrator {
  public type AgentProfile = {
    principal : Principal;
    domain : Text;
    canSpawn : Bool;
    reputation : Float;
    yieldScore : Float;
    jobsCompleted : Nat;
    lastActive : Int;
    enabled : Bool;
  };

  public type JobStatus = { #QUEUED; #RUNNING; #COMPLETED; #FAILED };

  public type AgentJob = {
    jobId : Nat;
    agent : Principal;
    workload : Text;
    rewardWeight : Float;
    assignedAt : Int;
    completedAt : Int;
    status : JobStatus;
    resultSummary : Text;
    learningRecordId : Nat;
  };

  public type IntentStatus = { #PENDING; #APPROVED; #REJECTED; #EXECUTED };

  public type ChainFusionPolicy = {
    policyId : Nat;
    asset : Text;
    maxAmount : Nat;
    riskTier : Nat;
    requireApproval : Bool;
    enabled : Bool;
  };

  public type ChainFusionIntent = {
    intentId : Nat;
    policyId : Nat;
    agent : Principal;
    asset : Text;
    amount : Nat;
    destination : Text;
    rationale : Text;
    evidenceRecordId : Nat;
    status : IntentStatus;
    createdAt : Int;
    updatedAt : Int;
  };

  stable var governor : Principal = Principal.fromText("aaaaa-aa");
  stable var locked : Bool = false;

  stable var agents : [AgentProfile] = [];
  stable var jobs : [AgentJob] = [];
  stable var nextJobId : Nat = 1;

  stable var policies : [ChainFusionPolicy] = [];
  stable var nextPolicyId : Nat = 1;
  stable var intents : [ChainFusionIntent] = [];
  stable var nextIntentId : Nat = 1;

  stable var tenant : Text = "NOVA";
  stable var baseYieldReward : Float = 0.03;

  func isGovernor(caller : Principal) : Bool {
    if (not locked) { true } else { caller == governor };
  };

  func getAgentIndex(principal : Principal) : Nat {
    var i : Nat = 0;
    while (i < agents.size()) {
      if (agents[i].principal == principal) { return i };
      i += 1;
    };
    agents.size()
  };

  func getPolicyIndex(policyId : Nat) : Nat {
    var i : Nat = 0;
    while (i < policies.size()) {
      if (policies[i].policyId == policyId) { return i };
      i += 1;
    };
    policies.size()
  };

  func getIntentIndex(intentId : Nat) : Nat {
    var i : Nat = 0;
    while (i < intents.size()) {
      if (intents[i].intentId == intentId) { return i };
      i += 1;
    };
    intents.size()
  };

  func getJobIndex(jobId : Nat) : Nat {
    var i : Nat = 0;
    while (i < jobs.size()) {
      if (jobs[i].jobId == jobId) { return i };
      i += 1;
    };
    jobs.size()
  };

  func updateAgent(index : Nat, profile : AgentProfile) {
    agents := Array.tabulate<AgentProfile>(agents.size(), func(i : Nat) : AgentProfile {
      if (i == index) { profile } else { agents[i] };
    });
  };

  func updateJob(index : Nat, job : AgentJob) {
    jobs := Array.tabulate<AgentJob>(jobs.size(), func(i : Nat) : AgentJob {
      if (i == index) { job } else { jobs[i] };
    });
  };

  func updatePolicy(index : Nat, policy : ChainFusionPolicy) {
    policies := Array.tabulate<ChainFusionPolicy>(policies.size(), func(i : Nat) : ChainFusionPolicy {
      if (i == index) { policy } else { policies[i] };
    });
  };

  func updateIntent(index : Nat, item : ChainFusionIntent) {
    intents := Array.tabulate<ChainFusionIntent>(intents.size(), func(i : Nat) : ChainFusionIntent {
      if (i == index) { item } else { intents[i] };
    });
  };

  func isKnownEnabledAgent(principal : Principal) : Bool {
    let idx = getAgentIndex(principal);
    idx < agents.size() and agents[idx].enabled
  };

  func safeReputation(x : Float) : Float {
    if (x < 0.0) { 0.0 } else if (x > 1.0) { 1.0 } else { x }
  };

  public shared(msg) func claimGenesis() : async Text {
    if (locked) { return "ORCHESTRATOR_ALREADY_LOCKED" };
    governor := msg.caller;
    locked := true;
    "ORCHESTRATOR_GENESIS_CLAIMED"
  };

  public shared(msg) func setTenant(next : Text) : async Text {
    assert(isGovernor(msg.caller));
    tenant := next;
    "TENANT_UPDATED"
  };

  public shared(msg) func setBaseYieldReward(next : Float) : async Text {
    assert(isGovernor(msg.caller));
    if (next <= 0.0 or next > 1.0) { return "INVALID_REWARD" };
    baseYieldReward := next;
    "BASE_YIELD_UPDATED"
  };

  public shared(msg) func registerAgent(principal : Principal, domain : Text, canSpawn : Bool) : async Text {
    assert(isGovernor(msg.caller));
    let idx = getAgentIndex(principal);
    if (idx < agents.size()) {
      let existing = agents[idx];
      updateAgent(idx, {
        principal = existing.principal;
        domain = domain;
        canSpawn = canSpawn;
        reputation = existing.reputation;
        yieldScore = existing.yieldScore;
        jobsCompleted = existing.jobsCompleted;
        lastActive = Time.now();
        enabled = true;
      });
      return "AGENT_UPDATED";
    };
    agents := Array.append<AgentProfile>(agents, [{
      principal = principal;
      domain = domain;
      canSpawn = canSpawn;
      reputation = 0.5;
      yieldScore = 0.0;
      jobsCompleted = 0;
      lastActive = Time.now();
      enabled = true;
    }]);
    "AGENT_REGISTERED"
  };

  public shared(msg) func disableAgent(principal : Principal) : async Text {
    assert(isGovernor(msg.caller));
    let idx = getAgentIndex(principal);
    if (idx >= agents.size()) { return "AGENT_NOT_FOUND" };
    let existing = agents[idx];
    updateAgent(idx, {
      principal = existing.principal;
      domain = existing.domain;
      canSpawn = existing.canSpawn;
      reputation = existing.reputation;
      yieldScore = existing.yieldScore;
      jobsCompleted = existing.jobsCompleted;
      lastActive = Time.now();
      enabled = false;
    });
    "AGENT_DISABLED"
  };

  public shared(msg) func spawnJob(agent : Principal, workload : Text, rewardWeight : Float) : async {
    ok : Bool;
    jobId : Nat;
    status : Text;
  } {
    if (not isGovernor(msg.caller) and msg.caller != agent) {
      return { ok = false; jobId = 0; status = "NOT_AUTHORIZED" };
    };
    let idx = getAgentIndex(agent);
    if (idx >= agents.size() or not agents[idx].enabled) {
      return { ok = false; jobId = 0; status = "AGENT_UNAVAILABLE" };
    };
    let profile = agents[idx];
    if (not profile.canSpawn and not isGovernor(msg.caller)) {
      return { ok = false; jobId = 0; status = "SPAWN_DISABLED" };
    };
    if (Text.size(workload) == 0) {
      return { ok = false; jobId = 0; status = "EMPTY_WORKLOAD" };
    };
    let weight = if (rewardWeight <= 0.0) { 0.1 } else { rewardWeight };
    let job : AgentJob = {
      jobId = nextJobId;
      agent = agent;
      workload = workload;
      rewardWeight = weight;
      assignedAt = Time.now();
      completedAt = 0;
      status = #QUEUED;
      resultSummary = "";
      learningRecordId = 0;
    };
    jobs := Array.append<AgentJob>(jobs, [job]);
    nextJobId += 1;
    { ok = true; jobId = job.jobId; status = "JOB_QUEUED" }
  };

  public shared(msg) func markJobRunning(jobId : Nat) : async Text {
    let idx = getJobIndex(jobId);
    if (idx >= jobs.size()) { return "JOB_NOT_FOUND" };
    let current = jobs[idx];
    if (msg.caller != current.agent and not isGovernor(msg.caller)) {
      return "NOT_AUTHORIZED";
    };
    updateJob(idx, {
      jobId = current.jobId;
      agent = current.agent;
      workload = current.workload;
      rewardWeight = current.rewardWeight;
      assignedAt = current.assignedAt;
      completedAt = current.completedAt;
      status = #RUNNING;
      resultSummary = current.resultSummary;
      learningRecordId = current.learningRecordId;
    });
    "JOB_RUNNING"
  };

  public shared(msg) func completeJob(jobId : Nat, success : Bool, summary : Text, qualityScore : Float) : async Text {
    let idx = getJobIndex(jobId);
    if (idx >= jobs.size()) { return "JOB_NOT_FOUND" };
    let current = jobs[idx];
    if (msg.caller != current.agent and not isGovernor(msg.caller)) {
      return "NOT_AUTHORIZED";
    };
    let agentIdx = getAgentIndex(current.agent);
    if (agentIdx >= agents.size()) { return "AGENT_NOT_FOUND" };
    let signal = await LearningCore.ingestSignal(
      "agent_orchestrator/job/" # Nat.toText(current.jobId),
      tenant,
      agents[agentIdx].domain,
      summary,
      #EVAL,
      qualityScore,
      [Principal.toText(current.agent), "agent_orchestrator", "job_completion"],
      "orchestration_v1"
    );
    let finalStatus = if (success) { #COMPLETED } else { #FAILED };
    updateJob(idx, {
      jobId = current.jobId;
      agent = current.agent;
      workload = current.workload;
      rewardWeight = current.rewardWeight;
      assignedAt = current.assignedAt;
      completedAt = Time.now();
      status = finalStatus;
      resultSummary = summary;
      learningRecordId = signal.recordId;
    });
    let profile = agents[agentIdx];
    let repDelta = if (success) { 0.04 * current.rewardWeight } else { -0.03 * current.rewardWeight };
    let yieldDelta = if (success) { baseYieldReward * current.rewardWeight } else { 0.0 };
    updateAgent(agentIdx, {
      principal = profile.principal;
      domain = profile.domain;
      canSpawn = profile.canSpawn;
      reputation = safeReputation(profile.reputation + repDelta);
      yieldScore = profile.yieldScore + yieldDelta;
      jobsCompleted = profile.jobsCompleted + 1;
      lastActive = Time.now();
      enabled = profile.enabled;
    });
    if (signal.ok) { "JOB_COMPLETED" } else { "JOB_COMPLETED_SIGNAL_REJECTED:" # signal.status }
  };

  public shared(msg) func routeLearningSignal(
    sourceId : Text,
    domain : Text,
    payload : Text,
    pipeline : LearningCore.Pipeline,
    qualityScore : Float,
    lineage : [Text],
    governanceTag : Text,
  ) : async {
    ok : Bool;
    recordId : Nat;
    status : Text;
  } {
    if (not isKnownEnabledAgent(msg.caller) and not isGovernor(msg.caller)) {
      return { ok = false; recordId = 0; status = "AGENT_NOT_REGISTERED" };
    };
    await LearningCore.ingestSignal(
      sourceId,
      tenant,
      domain,
      payload,
      pipeline,
      qualityScore,
      lineage,
      governanceTag
    )
  };

  public shared(msg) func upsertChainFusionPolicy(
    policyId : Nat,
    asset : Text,
    maxAmount : Nat,
    riskTier : Nat,
    requireApproval : Bool,
    enabled : Bool,
  ) : async Nat {
    assert(isGovernor(msg.caller));
    if (policyId == 0) {
      let next : ChainFusionPolicy = {
        policyId = nextPolicyId;
        asset = asset;
        maxAmount = maxAmount;
        riskTier = riskTier;
        requireApproval = requireApproval;
        enabled = enabled;
      };
      policies := Array.append<ChainFusionPolicy>(policies, [next]);
      nextPolicyId += 1;
      return next.policyId;
    };
    let idx = getPolicyIndex(policyId);
    if (idx >= policies.size()) { return 0 };
    updatePolicy(idx, {
      policyId = policyId;
      asset = asset;
      maxAmount = maxAmount;
      riskTier = riskTier;
      requireApproval = requireApproval;
      enabled = enabled;
    });
    policyId
  };

  public shared(msg) func submitChainFusionIntent(
    policyId : Nat,
    amount : Nat,
    destination : Text,
    rationale : Text,
  ) : async {
    ok : Bool;
    intentId : Nat;
    status : Text;
  } {
    if (not isKnownEnabledAgent(msg.caller)) {
      return { ok = false; intentId = 0; status = "AGENT_NOT_REGISTERED" };
    };
    let policyIdx = getPolicyIndex(policyId);
    if (policyIdx >= policies.size()) {
      return { ok = false; intentId = 0; status = "POLICY_NOT_FOUND" };
    };
    let policy = policies[policyIdx];
    if (not policy.enabled) {
      return { ok = false; intentId = 0; status = "POLICY_DISABLED" };
    };
    if (amount > policy.maxAmount) {
      return { ok = false; intentId = 0; status = "LIMIT_EXCEEDED" };
    };
    let status = if (policy.requireApproval) { #PENDING } else { #APPROVED };
    let signal = await LearningCore.ingestSignal(
      "agent_orchestrator/chain_fusion_intent",
      tenant,
      "chain_fusion",
      "intent|" # policy.asset # "|" # Nat.toText(amount) # "|" # destination # "|" # rationale,
      #EVAL,
      0.8,
      [Principal.toText(msg.caller), "chain_fusion", Nat.toText(policyId)],
      "chain_fusion_policy_v1"
    );
    let intent : ChainFusionIntent = {
      intentId = nextIntentId;
      policyId = policyId;
      agent = msg.caller;
      asset = policy.asset;
      amount = amount;
      destination = destination;
      rationale = rationale;
      evidenceRecordId = signal.recordId;
      status = status;
      createdAt = Time.now();
      updatedAt = Time.now();
    };
    intents := Array.append<ChainFusionIntent>(intents, [intent]);
    nextIntentId += 1;
    { ok = true; intentId = intent.intentId; status = "INTENT_RECORDED" }
  };

  public shared(msg) func reviewChainFusionIntent(intentId : Nat, approve : Bool) : async Text {
    assert(isGovernor(msg.caller));
    let idx = getIntentIndex(intentId);
    if (idx >= intents.size()) { return "INTENT_NOT_FOUND" };
    let current = intents[idx];
    if (current.status != #PENDING) { return "INTENT_NOT_PENDING" };
    let nextStatus = if (approve) { #APPROVED } else { #REJECTED };
    updateIntent(idx, {
      intentId = current.intentId;
      policyId = current.policyId;
      agent = current.agent;
      asset = current.asset;
      amount = current.amount;
      destination = current.destination;
      rationale = current.rationale;
      evidenceRecordId = current.evidenceRecordId;
      status = nextStatus;
      createdAt = current.createdAt;
      updatedAt = Time.now();
    });
    if (approve) { "INTENT_APPROVED" } else { "INTENT_REJECTED" }
  };

  public shared(msg) func markChainFusionExecuted(intentId : Nat) : async Text {
    assert(isGovernor(msg.caller));
    let idx = getIntentIndex(intentId);
    if (idx >= intents.size()) { return "INTENT_NOT_FOUND" };
    let current = intents[idx];
    if (current.status != #APPROVED) { return "INTENT_NOT_APPROVED" };
    updateIntent(idx, {
      intentId = current.intentId;
      policyId = current.policyId;
      agent = current.agent;
      asset = current.asset;
      amount = current.amount;
      destination = current.destination;
      rationale = current.rationale;
      evidenceRecordId = current.evidenceRecordId;
      status = #EXECUTED;
      createdAt = current.createdAt;
      updatedAt = Time.now();
    });
    "INTENT_EXECUTED"
  };

  public query func getAgents() : async [AgentProfile] { agents };
  public query func getJobs(limit : Nat) : async [AgentJob] {
    let cap = Nat.min(limit, jobs.size());
    Array.tabulate<AgentJob>(cap, func(i : Nat) : AgentJob { jobs[i] })
  };
  public query func getChainFusionPolicies() : async [ChainFusionPolicy] { policies };
  public query func getChainFusionIntents(limit : Nat) : async [ChainFusionIntent] {
    let cap = Nat.min(limit, intents.size());
    Array.tabulate<ChainFusionIntent>(cap, func(i : Nat) : ChainFusionIntent { intents[i] })
  };

  public query func getPlatformStatus() : async {
    tenant : Text;
    agentsRegistered : Nat;
    activeAgents : Nat;
    queuedJobs : Nat;
    runningJobs : Nat;
    completedJobs : Nat;
    totalYield : Float;
    chainFusionPolicies : Nat;
    chainFusionIntents : Nat;
  } {
    let active = Array.filter<AgentProfile>(agents, func(profile : AgentProfile) : Bool { profile.enabled });
    let queued = Array.filter<AgentJob>(jobs, func(job : AgentJob) : Bool { job.status == #QUEUED });
    let running = Array.filter<AgentJob>(jobs, func(job : AgentJob) : Bool { job.status == #RUNNING });
    let completed = Array.filter<AgentJob>(jobs, func(job : AgentJob) : Bool { job.status == #COMPLETED });
    var totalYield : Float = 0.0;
    var i : Nat = 0;
    while (i < agents.size()) {
      totalYield += agents[i].yieldScore;
      i += 1;
    };
    {
      tenant = tenant;
      agentsRegistered = agents.size();
      activeAgents = active.size();
      queuedJobs = queued.size();
      runningJobs = running.size();
      completedJobs = completed.size();
      totalYield = totalYield;
      chainFusionPolicies = policies.size();
      chainFusionIntents = intents.size();
    }
  };
}
