// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  MEDINA ICP — TYPES                                                      ║
// ║  Shared domain types for the MEDINA universal control plane.             ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.   ║
// ╚══════════════════════════════════════════════════════════════════════════╝

module {

  // ── COMMAND GRAMMAR ──────────────────────────────────────────────────────

  public type CommandTag = {
    #memory_find;  #memory_pin;  #memory_map;
    #govern_status;  #govern_propose;  #govern_approve;
    #model_invoke;  #model_route;
    #workspace_open;
    #company_onboard;  #company_connect;
    #company_internalize;  #company_hybrid;
    #replay_show;
    #run;
    #unknown;
  };

  public type ParsedCommand = {
    tag   : CommandTag;
    raw   : Text;
    args  : [Text];
  };

  // ── LAW / GATE ────────────────────────────────────────────────────────────

  public type GateId   = { #A; #B; #C };
  public type GateState = { #open; #soft_lock; #hard_lock };

  public type LawPass = {
    epoch      : Nat;
    recital    : Text;        // validated state hash / label
    expansion  : Text;        // one lawful expansion applied
    gateA      : GateState;
    gateB      : GateState;
    gateC      : GateState;
    dualReadOk : Bool;
  };

  public type DualReadResult = {
    semanticScore   : Float;
    resonanceScore  : Float;
    ok              : Bool;   // both modes must pass
  };

  // ── MEMORY TEMPLE ─────────────────────────────────────────────────────────

  public type MemCoord = {
    theta : Float;
    phi   : Float;
    depth : Float;
    ring  : Nat;
    beat  : Nat;
  };

  public type MemLineage = {
    parentHash : Text;
    chainHash  : Text;
    seqRef     : Text;
  };

  public type MemEntry = {
    id       : Nat;
    coord    : MemCoord;
    lineage  : MemLineage;
    content  : Text;
    salience : Float;
    pinned   : Bool;
    beat     : Nat;
  };

  public type MapMode = { #helix; #ring; #path };

  // ── GOVERNANCE ────────────────────────────────────────────────────────────

  public type ProposalStatus = {
    #pending; #approved; #rejected; #rolled_back;
  };

  public type Register = { #founder; #builder; #organism; #external };

  public type Proposal = {
    id         : Nat;
    register   : Register;
    content    : Text;
    status     : ProposalStatus;
    epoch      : Nat;
    evidence   : [Text];
  };

  // ── MODEL ROUTER ──────────────────────────────────────────────────────────

  public type ModelRole = {
    #strategist; #builder; #analyst; #governance;
    #memory_curator; #operations; #defense_risk; #projection;
  };

  // D1..D10 document intelligence models
  public type DModelId = {
    #D1_ALPHA; #D2_DOCTOR; #D3_GENOME; #D4_CEQUE; #D5_BUILDER;
    #D6_FIELD_RESONANCE; #D7_ANIMA_CHAIN; #D8_SUCCESSION;
    #D9_ENTERPRISE_DOCTRINE; #D10_ANCIENT_LAWS;
  };

  // N1..N12 sovereign macro-node models
  public type NModelId = {
    #N1_CHRONO; #N2_VERITAS; #N3_BRAIN; #N4_FLUX; #N5_RESONEX;
    #N6_QMEM; #N7_AXIS; #N8_AEGIS; #N9_ENTANGLA;
    #N10_PARALLAX; #N11_MERIDIAN; #N12_NOVA;
  };

  public type InvocationResult = {
    modelLabel : Text;
    rationale  : Text;
    output     : Text;
    beat       : Nat;
    ok         : Bool;
  };

  // ── COMPANY / TENANT ──────────────────────────────────────────────────────

  public type OnboardMode = { #connect; #internalize; #hybrid };

  public type TenantRecord = {
    id         : Nat;
    name       : Text;
    mode       : OnboardMode;
    beat       : Nat;
    evidence   : [Text];
    active     : Bool;
  };

  // ── ORCHESTRATORS ─────────────────────────────────────────────────────────

  public type OrchId = {
    #ORCH01_SOVEREIGN_TICK;
    #ORCH02_SPHERICAL_INTEGRATION;
    #ORCH03_SWARM_CORE;
    #ORCH04_FULL_GOVERNANCE;
    #ORCH05_CONSTITUTIONAL_LAW;
    #ORCH06_NEURAL_CORE_MESH;
    #ORCH07_LIVING_DOCUMENT_MACRO;
    #ORCH08_FRONTEND_COMMAND;
  };

  public type OrchBeat = {
    orchId    : OrchId;
    beat      : Nat;
    gateScore : Float;
    passed    : Bool;
  };

  // ── REPLAY / INCIDENT ─────────────────────────────────────────────────────

  public type IncidentKind = {
    #parse_error; #auth_denied; #permission_denied;
    #gate_failure; #fallback_triggered;
  };

  public type Incident = {
    id   : Nat;
    kind : IncidentKind;
    msg  : Text;
    beat : Nat;
  };

  public type ReplayEntry = {
    id        : Nat;
    operation : Text;
    outcome   : Text;
    beat      : Nat;
  };

  // ── MATALKO / MATH ────────────────────────────────────────────────────────

  public type MatalkoSnapshot = {
    beat             : Nat;
    macroAbsorption  : Float;
    dualReadEnergy   : Float;
    stabilityPot     : Float;
    chemPotential    : Float;
    memPotential     : Float;
  };

}
