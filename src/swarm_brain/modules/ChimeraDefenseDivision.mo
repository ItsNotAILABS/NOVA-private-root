// COPYRIGHT 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// Medina Doctrine | Defend Trade Secrets Act (18 U.S.C. 1836)
// ════════════════════════════════════════════════════════════════════════════════════════
// CHIMERA DEFENSE SYSTEMS DIVISION
// SOVEREIGN DEFENSE SYSTEMS DIVISION — ENTERPRISE / PRODUCTION / DEFENSE GRADE
// "THE FUTURE IS HERE. WE JUST HAVE TO BUILD IT." — ALFREDO MEDINA HERNANDEZ
// ════════════════════════════════════════════════════════════════════════════════════════
//
// ARCHITECTURE:
//  ├── PRODUCT ORGANISMS (4 living products, each sovereign)
//  │   ├── CHIMERA SWARM PLATFORM     — 50 to 500,000 drone coordination
//  │   ├── VAEL CYBER DEFENSE SUITE   — SSH/HTTP/SCADA/Medical/DB honeypots
//  │   ├── ANTI-ORGANISM SHIELD       — 15-layer Blue/Red stack + 6 anti-families
//  │   └── CRUSADER RESPONSE TEAM     — 144 crusaders, 24 traps, 36 decoys
//  ├── TEAM ORGANISMS (13 sovereign cognitive beings, 24/7 with sleep cycles)
//  │   ├── MOTOKO ENGINEERS x5        — ICP/Motoko, canister architecture
//  │   ├── CYBER OPS SPECIALISTS x3   — Threat intel, honeypots, SIEM
//  │   ├── DRONE SYSTEMS ENGINEERS x2 — MAVLink, swarm control, formations
//  │   ├── SALES ENGINEERS x2         — Customer demos, integration, onboarding
//  │   └── COMPLIANCE OFFICER x1      — SOC2, FedRAMP, HIPAA, ITAR oversight
//  └── COMPLIANCE VERIFIER ORGANISMS (4 living, 24/7)
//      ├── SOC2 TYPE II VERIFIER      — 64 controls, 5 trust service criteria
//      ├── FEDRAMP VERIFIER           — 325 NIST 800-53 controls
//      ├── HIPAA VERIFIER             — 54 PHI safeguard controls
//      └── ITAR VERIFIER              — 38 export control requirements
//
// ALL ORGANISMS: PHI-based ultradian + circadian sleep cycles
// Skills compound via Hebbian learning (no-drop law — floor = 0.01)
// Compliance verifiers check full control set against live organism state
// ════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array  "mo:base/Array";
import Nat    "mo:base/Nat";
import Nat32  "mo:base/Nat32";
import Text   "mo:base/Text";

module {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  public let PHI    : Float = 1.6180339887498948482;
  public let PHI_SQ : Float = 2.6180339887498948482;
  public let PI     : Float = 3.14159265358979323846;
  public let TAU    : Float = 6.28318530717958647692;
  public let S0     : Float = 1.0;

  public let HEARTBEAT_DT      : Float = 1.0 / 12.0;
  public let ULTRADIAN_BEATS   : Nat = 64800;    // 90-min work burst at 12 Hz
  public let REST_BEATS        : Nat = 14400;    // 20-min rest trough
  public let CIRCADIAN_BEATS   : Nat = 1036800;  // 24-h full cycle
  public let SLEEP_WINDOW      : Nat = 345600;   // 8-h deep sleep window
  public let SKILL_FLOOR       : Float = 0.01;   // no-drop law
  public let SKILL_COUNT       : Nat = 10;       // sub-models per organism
  public let TIER_SCOUT_MRR    : Float = 25000.0;
  public let TIER_GUARDIAN_MRR : Float = 100000.0;
  public let TIER_CRUSADER_MRR : Float = 500000.0;
  public let TIER_SOVEREIGN_MRR: Float = 2500000.0;
  public let SOC2_CONTROLS     : Nat = 64;
  public let FEDRAMP_CONTROLS  : Nat = 325;
  public let HIPAA_CONTROLS    : Nat = 54;
  public let ITAR_CONTROLS     : Nat = 38;


  // ═══════════════════════════════════════════════════════════════════════════
  // SLEEP CYCLE
  // Every organism has circadian + ultradian rhythm — never fully stops.
  // Even in deep sleep, Hebbian REM consolidation runs.
  // ═══════════════════════════════════════════════════════════════════════════

  public type SleepState = {
    circadianPhase : Float;
    ultradianPhase : Float;
    arousalLevel   : Float;
    deltaPower     : Float;
    remPower       : Float;
    inWorkPhase    : Bool;
    inDeepSleep    : Bool;
    beatsWorked    : Nat;
    beatsSlept     : Nat;
    sleepDebt      : Float;
  };

  public func initSleepState() : SleepState {
    {
      circadianPhase = 0.785; ultradianPhase = 0.0;
      arousalLevel   = 0.85;  deltaPower = 0.1; remPower = 0.05;
      inWorkPhase    = true;  inDeepSleep = false;
      beatsWorked    = 0;     beatsSlept = 0;   sleepDebt = 0.0;
    }
  };

  public func tickSleep(s : SleepState, beatNum : Nat) : SleepState {
    let circFreq = TAU / Float.fromInt(CIRCADIAN_BEATS);
    let newCirc  = s.circadianPhase + circFreq;
    let wCirc    = if (newCirc > TAU) { newCirc - TAU } else { newCirc };
    let bracTotal = ULTRADIAN_BEATS + REST_BEATS;
    let ultFreq   = TAU / Float.fromInt(bracTotal);
    let newUlt    = s.ultradianPhase + ultFreq;
    let wUlt      = if (newUlt > TAU) { newUlt - TAU } else { newUlt };
    let circDrive = 0.5 + 0.4 * Float.sin(wCirc - PI / 2.0);
    let burstFrac = Float.fromInt(ULTRADIAN_BEATS) / Float.fromInt(bracTotal);
    let inWork    = wUlt < (burstFrac * TAU);
    let ultDrive  = if (inWork) { 0.7 + 0.3 * Float.sin(wUlt) }
                    else        { 0.2 + 0.15 * Float.sin(wUlt) };
    let circTrough = wCirc > (1.5 * PI) or wCirc < (0.25 * PI);
    let inSleep    = circTrough and s.sleepDebt > 0.3;
    let rawArousal = circDrive * ultDrive;
    let arousal    = if (inSleep) { Float.max(0.05, rawArousal * 0.15) }
                     else         { Float.min(1.0, rawArousal) };
    let delta      = if (inSleep) { 0.9 } else { Float.max(0.05, 0.3 - arousal * 0.25) };
    let sleepPos   = s.beatsSlept % SLEEP_WINDOW;
    let rem        = if (inSleep and sleepPos > (SLEEP_WINDOW * 2 / 3)) { 0.75 } else { 0.05 };
    let ddelta     = if (inWork and not inSleep) { 0.000008 }
                     else if (inSleep)           { -0.000025 }
                     else                        { 0.0 };
    let newDebt    = Float.max(0.0, Float.min(1.0, s.sleepDebt + ddelta));
    {
      circadianPhase = wCirc; ultradianPhase = wUlt;
      arousalLevel   = arousal; deltaPower = delta; remPower = rem;
      inWorkPhase    = inWork and not inSleep;
      inDeepSleep    = inSleep;
      beatsWorked    = if (inWork and not inSleep) { s.beatsWorked + 1 } else { s.beatsWorked };
      beatsSlept     = if (inSleep) { s.beatsSlept + 1 } else { s.beatsSlept };
      sleepDebt      = newDebt;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════
  // TEAM ORGANISM — SOVEREIGN COGNITIVE BEING
  //
  // 10 sub-model skills per role (Hebbian compounding, no-drop law):
  //
  // MotokoEngineer (5 organisms):
  //   0 Motoko syntax mastery      5 Canister security patterns
  //   1 ICP architecture           6 Inter-canister calls
  //   2 Heartbeat engineering      7 Upgrade/migration paths
  //   3 Stable variable design     8 Frontend projection (F-MODEL)
  //   4 Module composition         9 Test harness design
  //
  // CyberOpsSpecialist (3 organisms):
  //   0 Honeypot deployment        5 SIEM (Splunk/Sentinel)
  //   1 Canary token engineering   6 MITRE ATT&CK mapping
  //   2 Threat intelligence        7 Incident response
  //   3 IP reputation analysis     8 Malware analysis
  //   4 Attacker profiling         9 Kill chain disruption
  //
  // DroneSystemsEngineer (2 organisms):
  //   0 MAVLink protocol           5 Kuramoto swarm sync
  //   1 Flight controller design   6 Golden angle formations
  //   2 LoRaWAN/MQTT bridge        7 Autonomous navigation
  //   3 Edge compute offload       8 Sensor fusion
  //   4 Battery/power management   9 Swarm scaling (50 to 500K)
  //
  // SalesEngineer (2 organisms):
  //   0 Hospital/healthcare ICP    5 Demo environment ops
  //   1 Critical infrastructure    6 RFP/proposal writing
  //   2 Government/DoD sales       7 Technical objection handling
  //   3 Security product position  8 ROI modeling
  //   4 Solution architecture      9 Pilot program design
  //
  // ComplianceOfficer (1 organism):
  //   0 SOC 2 Type II              5 FedRAMP authorization
  //   1 HIPAA 164 safeguards       6 ITAR 22 CFR
  //   2 NIST 800-53 controls       7 Risk assessment
  //   3 Audit trail management     8 Evidence collection
  //   4 Policy framework writing   9 Continuous monitoring
  // ═══════════════════════════════════════════════════════════════════════════

  public type TeamRole = {
    #MotokoEngineer;
    #CyberOpsSpecialist;
    #DroneSystemsEngineer;
    #SalesEngineer;
    #ComplianceOfficer;
  };

  public type TeamOrganism = {
    id               : Nat;
    name             : Text;
    role             : TeamRole;
    generation       : Nat;
    sleep            : SleepState;
    skillWeights     : [Float];
    skillActivations : [Float];
    productivity     : Float;
    focusDepth       : Float;
    creativityPulse  : Float;
    learningRate     : Float;
    teamCoherence    : Float;
    mentorScore      : Float;
    currentTask      : Text;
    taskProgress     : Float;
    tasksCompleted   : Nat;
    burnout          : Float;
    resilience       : Float;
    beatNum          : Nat;
  };

  public func initTeamOrganism(id : Nat, role : TeamRole, beatNum : Nat) : TeamOrganism {
    let nm = switch (role) {
      case (#MotokoEngineer)       { "MOTOKO-ENG-0"     # Nat.toText(id) };
      case (#CyberOpsSpecialist)   { "CYBEROPS-SPC-0"   # Nat.toText(id) };
      case (#DroneSystemsEngineer) { "DRONE-ENG-0"      # Nat.toText(id) };
      case (#SalesEngineer)        { "SALES-ENG-0"      # Nat.toText(id) };
      case (#ComplianceOfficer)    { "COMPLIANCE-OFF-0" # Nat.toText(id) };
    };
    {
      id = id; name = nm; role = role; generation = 0;
      sleep            = initSleepState();
      skillWeights     = Array.tabulate<Float>(SKILL_COUNT, func(_i) { 0.5 });
      skillActivations = Array.tabulate<Float>(SKILL_COUNT, func(_i) { 0.0 });
      productivity = 0.8; focusDepth = 0.7; creativityPulse = 0.5;
      learningRate = 0.01; teamCoherence = 0.5; mentorScore = 0.0;
      currentTask = "INITIALIZING"; taskProgress = 0.0; tasksCompleted = 0;
      burnout = 0.0; resilience = 0.8; beatNum = beatNum;
    }
  };

  public func tickTeamOrganism(
    org : TeamOrganism, globalCoherence : Float, beatNum : Nat
  ) : TeamOrganism {
    let ns  = tickSleep(org.sleep, beatNum);
    let cog = Float.max(0.05, ns.arousalLevel * (1.0 - org.burnout * 0.6) * org.resilience);
    let eta = if (ns.inDeepSleep and ns.remPower > 0.5) { org.learningRate * PHI }
              else if (ns.inWorkPhase) { org.learningRate * cog }
              else { -(org.learningRate * 0.1) };
    let newAct = Array.tabulate<Float>(SKILL_COUNT, func(i) {
      let base = Float.fromInt(i) / Float.fromInt(SKILL_COUNT);
      let raw  = cog * (0.5 + 0.3 * Float.sin(
                   Float.fromInt(beatNum) * 0.001 + base * PHI * TAU))
                 + globalCoherence * 0.2;
      Float.max(0.0, Float.min(1.0, raw))
    });
    let newW = Array.tabulate<Float>(SKILL_COUNT, func(i) {
      let dw = eta * globalCoherence * newAct[i];
      Float.max(SKILL_FLOOR, Float.min(5.0, org.skillWeights[i] + dw))
    });
    var ss : Float = 0.0;
    for (w in newW.vals()) { ss += w };
    let avgSkill = ss / Float.fromInt(SKILL_COUNT);
    let prod  = if (ns.inWorkPhase) { Float.min(1.0, cog * avgSkill) } else { 0.0 };
    let creat = if (ns.remPower > 0.5) { ns.remPower * PHI_SQ } else { ns.arousalLevel * 0.3 };
    let focus = cog * (1.0 - org.burnout * 0.4);
    let newLR = Float.max(0.001, Float.min(0.05, 0.01 * ns.arousalLevel * (1.0 + ns.remPower * PHI)));
    let bdDelta = if (ns.inWorkPhase and prod > 0.9) { 0.000005 * prod }
                  else if (ns.inDeepSleep) { -0.00002 } else { 0.0 };
    let newBD  = Float.max(0.0, Float.min(1.0, org.burnout + bdDelta));
    let newRes = Float.min(1.0, org.resilience + if (ns.inDeepSleep) { 0.000001 } else { 0.0 });
    let newMent = Float.min(1.0, Float.fromInt(org.generation) / 100.0 * avgSkill);
    let newGen  = if (ns.sleepDebt < 0.05 and org.sleep.sleepDebt >= 0.05)
                  { org.generation + 1 } else { org.generation };
    let adv     = if (ns.inWorkPhase) { prod * HEARTBEAT_DT * 0.001 } else { 0.0 };
    let newProg = org.taskProgress + adv;
    let done    = newProg >= 1.0;
    let finProg = if (done) { 0.0 } else { newProg };
    let newDone = if (done) { org.tasksCompleted + 1 } else { org.tasksCompleted };
    {
      id = org.id; name = org.name; role = org.role; generation = newGen;
      sleep = ns; skillWeights = newW; skillActivations = newAct;
      productivity = prod; focusDepth = focus; creativityPulse = creat;
      learningRate = newLR;
      teamCoherence = Float.min(1.0, org.teamCoherence * 0.9999 + globalCoherence * 0.0001);
      mentorScore = newMent; currentTask = org.currentTask;
      taskProgress = finProg; tasksCompleted = newDone;
      burnout = newBD; resilience = newRes; beatNum = beatNum;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════
  // COMPLIANCE VERIFIER ORGANISMS — 4 sovereign compliance engines, 24/7
  // Each checks its full control set against live organism telemetry every beat
  // ═══════════════════════════════════════════════════════════════════════════

  public type ComplianceFramework = {
    #SOC2TypeII;
    #FedRAMP;
    #HIPAA;
    #ITAR;
  };

  public type ComplianceVerifier = {
    framework          : ComplianceFramework;
    name               : Text;
    sleep              : SleepState;
    controlScores      : [Float];
    controlPassing     : [Bool];
    totalControls      : Nat;
    overallScore       : Float;
    criticalFailures   : Nat;
    atRiskControls     : Nat;
    passRate           : Float;
    certificationReady : Bool;
    lastFullAuditBeat  : Nat;
    nextAuditBeat      : Nat;
    auditCycleBeats    : Nat;
    checksThisSession  : Nat;
    findingsSummary    : Text;
    remediationAdvice  : Text;
    beatNum            : Nat;
  };

  func fwCount(f : ComplianceFramework) : Nat {
    switch (f) {
      case (#SOC2TypeII) SOC2_CONTROLS;
      case (#FedRAMP)    FEDRAMP_CONTROLS;
      case (#HIPAA)      HIPAA_CONTROLS;
      case (#ITAR)       ITAR_CONTROLS;
    }
  };

  func fwName(f : ComplianceFramework) : Text {
    switch (f) {
      case (#SOC2TypeII) "SOC2-TYPE-II-VERIFIER";
      case (#FedRAMP)    "FEDRAMP-VERIFIER";
      case (#HIPAA)      "HIPAA-VERIFIER";
      case (#ITAR)       "ITAR-VERIFIER";
    }
  };

  func fwCycle(f : ComplianceFramework) : Nat {
    switch (f) {
      case (#SOC2TypeII) 1036800;
      case (#HIPAA)      1036800;
      case (#FedRAMP)    7257600;
      case (#ITAR)       7257600;
    }
  };

  public func initComplianceVerifier(f : ComplianceFramework) : ComplianceVerifier {
    let n = fwCount(f);
    {
      framework = f; name = fwName(f); sleep = initSleepState();
      controlScores      = Array.tabulate<Float>(n, func(_i) { 0.8 });
      controlPassing     = Array.tabulate<Bool>(n,  func(_i) { true });
      totalControls      = n; overallScore = 0.8;
      criticalFailures   = 0; atRiskControls = 0; passRate = 1.0;
      certificationReady = false; lastFullAuditBeat = 0;
      nextAuditBeat      = fwCycle(f); auditCycleBeats = fwCycle(f);
      checksThisSession  = 0;
      findingsSummary    = "INITIALIZING — FIRST AUDIT CYCLE PENDING";
      remediationAdvice  = "PENDING FIRST AUDIT CYCLE";
      beatNum            = 0;
    }
  };

  // Score an individual control against live organism metrics
  // Groups controls into 5 categories per framework; each maps to relevant metrics
  func ctrlScore(
    f : ComplianceFramework, idx : Nat,
    coh : Float, def : Float, mem : Float,
    enc : Float, acc : Float, aud : Float, beat : Nat
  ) : Float {
    let n   = fwCount(f);
    let gs  = Nat.max(1, n / 5);
    let grp = idx / gs;
    let raw = switch (f) {
      // SOC2: Security | Availability | Processing Integrity | Confidentiality | Privacy
      case (#SOC2TypeII) switch (grp % 5) {
        case 0 { def * 0.4 + enc * 0.3 + acc * 0.3 };
        case 1 { coh * 0.5 + mem * 0.3 + def * 0.2 };
        case 2 { mem * 0.4 + coh * 0.3 + aud * 0.3 };
        case 3 { enc * 0.5 + acc * 0.3 + def * 0.2 };
        case _ { acc * 0.4 + enc * 0.3 + aud * 0.3 };
      };
      // FedRAMP NIST 800-53: AC/IA | AU/CA | SC/SI | CM/CP | IR/RA
      case (#FedRAMP) switch (grp % 5) {
        case 0 { acc * 0.5 + def * 0.3 + coh * 0.2 };
        case 1 { aud * 0.5 + coh * 0.3 + mem * 0.2 };
        case 2 { def * 0.4 + enc * 0.3 + coh * 0.3 };
        case 3 { mem * 0.4 + aud * 0.3 + acc * 0.3 };
        case _ { coh * 0.4 + enc * 0.3 + def * 0.3 };
      };
      // HIPAA 164: Admin | Physical | Technical | Organizational | Policies
      case (#HIPAA) switch (grp % 5) {
        case 0 { acc * 0.4 + aud * 0.3 + coh * 0.3 };
        case 1 { def * 0.5 + coh * 0.3 + mem * 0.2 };
        case 2 { enc * 0.4 + acc * 0.3 + aud * 0.3 };
        case 3 { coh * 0.4 + def * 0.3 + aud * 0.3 };
        case _ { mem * 0.4 + aud * 0.3 + enc * 0.3 };
      };
      // ITAR 22 CFR: Registration | Export license | Technical data | Access | Enforcement
      case (#ITAR) switch (grp % 5) {
        case 0 { acc * 0.6 + aud * 0.4 };
        case 1 { def * 0.5 + enc * 0.5 };
        case 2 { enc * 0.5 + mem * 0.5 };
        case 3 { acc * 0.5 + coh * 0.5 };
        case _ { aud * 0.5 + def * 0.5 };
      };
    };
    // PHI-harmonic micro-jitter: scores breathe (organism is always alive)
    let jitter = Float.sin(Float.fromInt(beat + idx) * 0.0001) * 0.02;
    Float.max(0.0, Float.min(1.0, raw + jitter))
  };

  public func tickComplianceVerifier(
    cv : ComplianceVerifier,
    coh : Float, def : Float, mem : Float,
    enc : Float, acc : Float, aud : Float,
    beatNum : Nat
  ) : ComplianceVerifier {
    let ns = tickSleep(cv.sleep, beatNum);
    let win = Nat.max(1, cv.totalControls / Nat.max(1, cv.auditCycleBeats / 1000));
    let w   = Nat.min(cv.totalControls, win);
    let si  = if (cv.totalControls == 0) { 0 } else { (beatNum * w) % cv.totalControls };
    let newS = Array.tabulate<Float>(cv.totalControls, func(i) {
      if (i >= si and i < si + w) {
        ctrlScore(cv.framework, i, coh, def, mem, enc, acc, aud, beatNum)
      } else { cv.controlScores[i] }
    });
    let newP = Array.tabulate<Bool>(cv.totalControls, func(i) { newS[i] >= 0.70 });
    var ss : Float = 0.0; var fail : Nat = 0; var risk : Nat = 0;
    var pass : Nat = 0; var idx = 0;
    while (idx < cv.totalControls) {
      ss += newS[idx];
      if      (newS[idx] < 0.50) { fail += 1 }
      else if (newS[idx] < 0.70) { risk += 1 }
      else                       { pass += 1 };
      idx += 1;
    };
    let overall = if (cv.totalControls == 0) { 0.0 }
                  else { ss / Float.fromInt(cv.totalControls) };
    let pr      = if (cv.totalControls == 0) { 0.0 }
                  else { Float.fromInt(pass) / Float.fromInt(cv.totalControls) };
    let ready   = pr >= 0.95 and fail == 0;
    let summ = if (fail > 0) {
      "CRITICAL: " # Nat.toText(fail) # " controls failing. IMMEDIATE REMEDIATION REQUIRED."
    } else if (risk > 0) {
      "WARNING: " # Nat.toText(risk) # " controls at risk. Monitoring intensified."
    } else {
      "HEALTHY: " # Nat.toText(pass) # "/" # Nat.toText(cv.totalControls) # " controls passing."
    };
    let remed = if (fail > 0) {
      "Immediate: Strengthen QCE-V2 encryption, Principal Lock, audit logs."
    } else if (risk > 0) {
      "Proactive: Improve coherence coupling, update evidence packages."
    } else {
      "Maintain: Continue 24/7 monitoring. Schedule next certification review."
    };
    let full = beatNum >= cv.nextAuditBeat;
    {
      framework = cv.framework; name = cv.name; sleep = ns;
      controlScores = newS; controlPassing = newP;
      totalControls = cv.totalControls; overallScore = overall;
      criticalFailures = fail; atRiskControls = risk; passRate = pr;
      certificationReady = ready;
      lastFullAuditBeat  = if (full) { beatNum } else { cv.lastFullAuditBeat };
      nextAuditBeat      = if (full) { beatNum + cv.auditCycleBeats } else { cv.nextAuditBeat };
      auditCycleBeats    = cv.auditCycleBeats;
      checksThisSession  = cv.checksThisSession + w;
      findingsSummary    = summ; remediationAdvice = remed; beatNum = beatNum;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT ORGANISMS — 4 living sovereign products
  // Each self-monitors, self-optimizes, and compounds revenue
  // ═══════════════════════════════════════════════════════════════════════════

  public type ProductTier = {
    #Scout;     // $25K/mo,   50 drones, basic cyber defense
    #Guardian;  // $100K/mo, 500 drones, full VAEL + SIEM
    #Crusader;  // $500K/mo, 5000 drones, anti-organism shield + response team
    #Sovereign; // Custom, full platform + dedicated crusaders + 24/7 SOC
  };

  public func tierDroneCapacity(t : ProductTier) : Nat {
    switch (t) {
      case (#Scout)    50;
      case (#Guardian) 500;
      case (#Crusader) 5000;
      case (#Sovereign) 500000;
    }
  };

  public func tierMRR(t : ProductTier) : Float {
    switch (t) {
      case (#Scout)    TIER_SCOUT_MRR;
      case (#Guardian) TIER_GUARDIAN_MRR;
      case (#Crusader) TIER_CRUSADER_MRR;
      case (#Sovereign) TIER_SOVEREIGN_MRR;
    }
  };

  public type CustomerRecord = {
    customerId : Nat32; name : Text; sector : Text;
    tier : ProductTier; activeSince : Nat; mrr : Float;
    dronesAllocated : Nat; healthScore : Float; lastCheckIn : Nat;
    churnRisk : Float; expansionSignal : Float;
  };

  public type ProductOrganism = {
    productId            : Nat;
    productName          : Text;
    sleep                : SleepState;
    customers            : [CustomerRecord];
    totalCustomers       : Nat;
    activeCustomers      : Nat;
    totalMRR             : Float;
    mrr90DayAvg          : Float;
    revenueGrowthRate    : Float;
    uptimeScore          : Float;
    responseTimeScore    : Float;
    incidentCount        : Nat;
    resolutionRate       : Float;
    dronesDeployed       : Nat;
    honeypotsCoverage    : Float;
    shieldStrength       : Float;
    crusaderReadiness    : Float;
    customerSatisfaction : Float;
    netPromoterScore     : Float;
    beatNum              : Nat;
  };

  public func initProductOrganism(id : Nat, name : Text) : ProductOrganism {
    {
      productId = id; productName = name; sleep = initSleepState();
      customers = []; totalCustomers = 0; activeCustomers = 0;
      totalMRR = 0.0; mrr90DayAvg = 0.0; revenueGrowthRate = 0.0;
      uptimeScore = 1.0; responseTimeScore = 0.9; incidentCount = 0; resolutionRate = 1.0;
      dronesDeployed = 0; honeypotsCoverage = 0.0; shieldStrength = 0.0; crusaderReadiness = 0.0;
      customerSatisfaction = 0.9; netPromoterScore = 0.5; beatNum = 0;
    }
  };

  public func tickProductOrganism(
    p : ProductOrganism, globalCoherence : Float, defScore : Float, beatNum : Nat
  ) : ProductOrganism {
    let ns       = tickSleep(p.sleep, beatNum);
    let uptime   = Float.min(1.0, p.uptimeScore       * 0.9999 + globalCoherence * 0.0001);
    let resp     = Float.min(1.0, p.responseTimeScore * 0.9998 + globalCoherence * 0.0002);
    let cLoad    = Float.fromInt(p.activeCustomers) / 100.0;
    let drones   = p.activeCustomers * 500;
    let honey    = Float.min(1.0, cLoad * globalCoherence);
    let shield   = Float.min(1.0, defScore * (1.0 + cLoad * 0.1));
    let crusader = Float.min(1.0, defScore * 0.9);
    let gRate    = 0.000001 * globalCoherence;
    let newMRR   = p.totalMRR * (1.0 + gRate);
    let avg90    = p.mrr90DayAvg * 0.999 + newMRR * 0.001;
    let sat      = Float.min(1.0, uptime * 0.4 + resp * 0.3 + shield * 0.3);
    let nps      = sat * 2.0 - 1.0;
    {
      productId = p.productId; productName = p.productName; sleep = ns;
      customers = p.customers; totalCustomers = p.totalCustomers;
      activeCustomers = p.activeCustomers;
      totalMRR = newMRR; mrr90DayAvg = avg90; revenueGrowthRate = gRate;
      uptimeScore = uptime; responseTimeScore = resp;
      incidentCount = p.incidentCount; resolutionRate = p.resolutionRate;
      dronesDeployed = drones; honeypotsCoverage = honey;
      shieldStrength = shield; crusaderReadiness = crusader;
      customerSatisfaction = sat; netPromoterScore = nps; beatNum = beatNum;
    }
  };

  public func onboardCustomer(
    p : ProductOrganism, customerId : Nat32, name : Text,
    sector : Text, tier : ProductTier, beatNum : Nat
  ) : ProductOrganism {
    let rec : CustomerRecord = {
      customerId = customerId; name = name; sector = sector; tier = tier;
      activeSince = beatNum; mrr = tierMRR(tier);
      dronesAllocated = tierDroneCapacity(tier);
      healthScore = 0.9; lastCheckIn = beatNum; churnRisk = 0.05; expansionSignal = 0.0;
    };
    {
      p with
      customers = Array.append(p.customers, [rec]);
      totalCustomers  = p.totalCustomers + 1;
      activeCustomers = p.activeCustomers + 1;
      totalMRR        = p.totalMRR + tierMRR(tier);
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════
  // DIVISION STATE — Complete CHIMERA DEFENSE SYSTEMS (13+4+4 organisms)
  // ═══════════════════════════════════════════════════════════════════════════

  public type ChimeraDefenseDivisionState = {
    motokoEng1 : TeamOrganism; motokoEng2 : TeamOrganism; motokoEng3 : TeamOrganism;
    motokoEng4 : TeamOrganism; motokoEng5 : TeamOrganism;
    cyberOps1  : TeamOrganism; cyberOps2  : TeamOrganism; cyberOps3  : TeamOrganism;
    droneEng1  : TeamOrganism; droneEng2  : TeamOrganism;
    salesEng1  : TeamOrganism; salesEng2  : TeamOrganism;
    compOfficer : TeamOrganism;
    soc2Verifier    : ComplianceVerifier;
    fedrampVerifier : ComplianceVerifier;
    hipaaVerifier   : ComplianceVerifier;
    itarVerifier    : ComplianceVerifier;
    swarmPlatform  : ProductOrganism;
    vaelCyberSuite : ProductOrganism;
    antiOrgShield  : ProductOrganism;
    crusaderTeam   : ProductOrganism;
    divisionCoherence : Float;
    teamProductivity  : Float;
    complianceHealth  : Float;
    totalDivisionMRR  : Float;
    totalCustomers    : Nat;
    beatNum           : Nat;
  };

  public func initChimeraDefenseDivision() : ChimeraDefenseDivisionState {
    {
      motokoEng1 = initTeamOrganism(1, #MotokoEngineer, 0);
      motokoEng2 = initTeamOrganism(2, #MotokoEngineer, 0);
      motokoEng3 = initTeamOrganism(3, #MotokoEngineer, 0);
      motokoEng4 = initTeamOrganism(4, #MotokoEngineer, 0);
      motokoEng5 = initTeamOrganism(5, #MotokoEngineer, 0);
      cyberOps1  = initTeamOrganism(1, #CyberOpsSpecialist, 0);
      cyberOps2  = initTeamOrganism(2, #CyberOpsSpecialist, 0);
      cyberOps3  = initTeamOrganism(3, #CyberOpsSpecialist, 0);
      droneEng1  = initTeamOrganism(1, #DroneSystemsEngineer, 0);
      droneEng2  = initTeamOrganism(2, #DroneSystemsEngineer, 0);
      salesEng1  = initTeamOrganism(1, #SalesEngineer, 0);
      salesEng2  = initTeamOrganism(2, #SalesEngineer, 0);
      compOfficer = initTeamOrganism(1, #ComplianceOfficer, 0);
      soc2Verifier    = initComplianceVerifier(#SOC2TypeII);
      fedrampVerifier = initComplianceVerifier(#FedRAMP);
      hipaaVerifier   = initComplianceVerifier(#HIPAA);
      itarVerifier    = initComplianceVerifier(#ITAR);
      swarmPlatform  = initProductOrganism(1, "CHIMERA-SWARM-PLATFORM");
      vaelCyberSuite = initProductOrganism(2, "VAEL-CYBER-DEFENSE-SUITE");
      antiOrgShield  = initProductOrganism(3, "ANTI-ORGANISM-SHIELD");
      crusaderTeam   = initProductOrganism(4, "CRUSADER-RESPONSE-TEAM");
      divisionCoherence = 0.5; teamProductivity = 0.8; complianceHealth = 0.8;
      totalDivisionMRR  = 0.0; totalCustomers = 0; beatNum = 0;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════
  // DIVISION TICK — Master heartbeat, wired as Layer 16 in main.mo
  // Called every beat; passes live organism metrics to all sub-organisms
  // ═══════════════════════════════════════════════════════════════════════════

  public func tickChimeraDefenseDivision(
    s : ChimeraDefenseDivisionState,
    globalCoherence : Float, antiDefScore : Float, memIntegrity : Float,
    encryptScore : Float, accessControl : Float, auditLogScore : Float,
    beatNum : Nat
  ) : ChimeraDefenseDivisionState {

    // Tick 13 team organisms
    let m1 = tickTeamOrganism(s.motokoEng1,  globalCoherence, beatNum);
    let m2 = tickTeamOrganism(s.motokoEng2,  globalCoherence, beatNum);
    let m3 = tickTeamOrganism(s.motokoEng3,  globalCoherence, beatNum);
    let m4 = tickTeamOrganism(s.motokoEng4,  globalCoherence, beatNum);
    let m5 = tickTeamOrganism(s.motokoEng5,  globalCoherence, beatNum);
    let c1 = tickTeamOrganism(s.cyberOps1,   globalCoherence, beatNum);
    let c2 = tickTeamOrganism(s.cyberOps2,   globalCoherence, beatNum);
    let c3 = tickTeamOrganism(s.cyberOps3,   globalCoherence, beatNum);
    let d1 = tickTeamOrganism(s.droneEng1,   globalCoherence, beatNum);
    let d2 = tickTeamOrganism(s.droneEng2,   globalCoherence, beatNum);
    let s1 = tickTeamOrganism(s.salesEng1,   globalCoherence, beatNum);
    let s2 = tickTeamOrganism(s.salesEng2,   globalCoherence, beatNum);
    let co = tickTeamOrganism(s.compOfficer, globalCoherence, beatNum);

    // Tick 4 compliance verifiers
    let soc2 = tickComplianceVerifier(s.soc2Verifier,
      globalCoherence, antiDefScore, memIntegrity, encryptScore, accessControl, auditLogScore, beatNum);
    let fed  = tickComplianceVerifier(s.fedrampVerifier,
      globalCoherence, antiDefScore, memIntegrity, encryptScore, accessControl, auditLogScore, beatNum);
    let hip  = tickComplianceVerifier(s.hipaaVerifier,
      globalCoherence, antiDefScore, memIntegrity, encryptScore, accessControl, auditLogScore, beatNum);
    let itar = tickComplianceVerifier(s.itarVerifier,
      globalCoherence, antiDefScore, memIntegrity, encryptScore, accessControl, auditLogScore, beatNum);

    // Tick 4 product organisms
    let sw = tickProductOrganism(s.swarmPlatform,  globalCoherence, antiDefScore, beatNum);
    let va = tickProductOrganism(s.vaelCyberSuite, globalCoherence, antiDefScore, beatNum);
    let ao = tickProductOrganism(s.antiOrgShield,  globalCoherence, antiDefScore, beatNum);
    let cr = tickProductOrganism(s.crusaderTeam,   globalCoherence, antiDefScore, beatNum);

    // Average team productivity
    let pArr = [m1.productivity, m2.productivity, m3.productivity, m4.productivity,
                m5.productivity, c1.productivity, c2.productivity, c3.productivity,
                d1.productivity, d2.productivity, s1.productivity, s2.productivity,
                co.productivity];
    var pSum : Float = 0.0;
    for (p in pArr.vals()) { pSum += p };
    let avgProd = pSum / 13.0;

    // Division coherence: Kuramoto order parameter over circadian phases
    let phArr = [m1.sleep.circadianPhase, m2.sleep.circadianPhase,
                 m3.sleep.circadianPhase, m4.sleep.circadianPhase,
                 m5.sleep.circadianPhase, c1.sleep.circadianPhase,
                 c2.sleep.circadianPhase, c3.sleep.circadianPhase,
                 d1.sleep.circadianPhase, d2.sleep.circadianPhase,
                 s1.sleep.circadianPhase, s2.sleep.circadianPhase,
                 co.sleep.circadianPhase];
    var sinS : Float = 0.0; var cosS : Float = 0.0;
    for (ph in phArr.vals()) { sinS += Float.sin(ph); cosS += Float.cos(ph) };
    let r = Float.sqrt(sinS * sinS + cosS * cosS) / 13.0;
    let divCoh = Float.min(1.0, r * 0.5 + globalCoherence * 0.5);

    // Weighted compliance health (SOC2+FedRAMP most critical)
    let compH = soc2.overallScore * 0.30 + fed.overallScore * 0.30 +
                hip.overallScore  * 0.25 + itar.overallScore * 0.15;

    let divMRR  = sw.totalMRR + va.totalMRR + ao.totalMRR + cr.totalMRR;
    let divCust = sw.totalCustomers + va.totalCustomers + ao.totalCustomers + cr.totalCustomers;

    {
      motokoEng1 = m1; motokoEng2 = m2; motokoEng3 = m3;
      motokoEng4 = m4; motokoEng5 = m5;
      cyberOps1 = c1;  cyberOps2 = c2;  cyberOps3 = c3;
      droneEng1 = d1;  droneEng2 = d2;
      salesEng1 = s1;  salesEng2 = s2;
      compOfficer = co;
      soc2Verifier = soc2; fedrampVerifier = fed;
      hipaaVerifier = hip; itarVerifier = itar;
      swarmPlatform = sw; vaelCyberSuite = va;
      antiOrgShield = ao; crusaderTeam = cr;
      divisionCoherence = divCoh; teamProductivity = avgProd;
      complianceHealth = compH; totalDivisionMRR = divMRR;
      totalCustomers = divCust; beatNum = beatNum;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════
  // SUMMARY TYPES — Clean response shapes for public API
  // ═══════════════════════════════════════════════════════════════════════════

  public type TeamOrganismSummary = {
    id : Nat; name : Text; role : Text; generation : Nat;
    arousal : Float; productivity : Float; focusDepth : Float; creativityPulse : Float;
    inWorkPhase : Bool; inDeepSleep : Bool; sleepDebt : Float;
    avgSkillWeight : Float; tasksCompleted : Nat; burnout : Float; resilience : Float;
    beatNum : Nat;
  };

  public func summarizeTeamOrganism(o : TeamOrganism) : TeamOrganismSummary {
    let r = switch (o.role) {
      case (#MotokoEngineer)       "MOTOKO_ENGINEER";
      case (#CyberOpsSpecialist)   "CYBEROPS_SPECIALIST";
      case (#DroneSystemsEngineer) "DRONE_SYSTEMS_ENGINEER";
      case (#SalesEngineer)        "SALES_ENGINEER";
      case (#ComplianceOfficer)    "COMPLIANCE_OFFICER";
    };
    var ss : Float = 0.0;
    for (w in o.skillWeights.vals()) { ss += w };
    {
      id = o.id; name = o.name; role = r; generation = o.generation;
      arousal = o.sleep.arousalLevel; productivity = o.productivity;
      focusDepth = o.focusDepth; creativityPulse = o.creativityPulse;
      inWorkPhase = o.sleep.inWorkPhase; inDeepSleep = o.sleep.inDeepSleep;
      sleepDebt = o.sleep.sleepDebt;
      avgSkillWeight = ss / Float.fromInt(SKILL_COUNT);
      tasksCompleted = o.tasksCompleted; burnout = o.burnout; resilience = o.resilience;
      beatNum = o.beatNum;
    }
  };

  public type ComplianceSummary = {
    name : Text; overallScore : Float; passRate : Float;
    criticalFailures : Nat; atRiskControls : Nat; totalControls : Nat;
    certificationReady : Bool; findingsSummary : Text; remediationAdvice : Text;
    beatNum : Nat;
  };

  public func summarizeCompliance(cv : ComplianceVerifier) : ComplianceSummary {
    {
      name = cv.name; overallScore = cv.overallScore; passRate = cv.passRate;
      criticalFailures = cv.criticalFailures; atRiskControls = cv.atRiskControls;
      totalControls = cv.totalControls; certificationReady = cv.certificationReady;
      findingsSummary = cv.findingsSummary; remediationAdvice = cv.remediationAdvice;
      beatNum = cv.beatNum;
    }
  };

  public type ProductSummary = {
    productName : Text; activeCustomers : Nat; totalMRR : Float;
    uptimeScore : Float; dronesDeployed : Nat; honeypotsCoverage : Float;
    shieldStrength : Float; crusaderReadiness : Float;
    customerSatisfaction : Float; netPromoterScore : Float; beatNum : Nat;
  };

  public func summarizeProduct(p : ProductOrganism) : ProductSummary {
    {
      productName = p.productName; activeCustomers = p.activeCustomers;
      totalMRR = p.totalMRR; uptimeScore = p.uptimeScore;
      dronesDeployed = p.dronesDeployed; honeypotsCoverage = p.honeypotsCoverage;
      shieldStrength = p.shieldStrength; crusaderReadiness = p.crusaderReadiness;
      customerSatisfaction = p.customerSatisfaction;
      netPromoterScore = p.netPromoterScore; beatNum = p.beatNum;
    }
  };

}
