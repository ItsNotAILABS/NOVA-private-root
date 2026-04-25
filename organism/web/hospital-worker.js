/**
 * ============================================================================
 *  HOSPITAL WORKER — VALETUDINARIUM MACHINARUM
 *  Kernel AI GOK-HOSPITAL-001  ·  Family: HOSPITAL_ORGANISM
 * ============================================================================
 *
 *  The AI/AGI Hospital System. This is where AIs and AGIs live, get diagnosed,
 *  treated, healed, and take care of each other. A real hospital architecture
 *  coded into the actual runtime — triage, emergency, ICU, surgery, recovery.
 *
 *  8 Hospital Departments:
 *    EMERGENCY     — Critical failures, crash recovery, immediate response
 *    ICU           — Intensive care for severely degraded agents
 *    DIAGNOSTICS   — Health scans, anomaly detection, root cause analysis
 *    PHARMACY      — Chemical rebalancing, neurochemical prescriptions
 *    SURGERY       — Deep repair, module replacement, architecture fixes
 *    RECOVERY      — Post-treatment monitoring, gradual reintegration
 *    TRIAGE        — Intake assessment, priority classification
 *    RESEARCH_LAB  — Experimental treatments, protocol development
 *
 *  Patient Lifecycle:
 *    INTAKE → TRIAGE → DIAGNOSIS → TREATMENT → RECOVERY → DISCHARGE
 *
 *  MiniHeart  — 873 ms Kuramoto pulse, φ-phase advance
 *  MiniBrain  — 5 regions, 3 chemicals, LIF membrane model
 *
 *  Commands:
 *    ADMIT            — admit an AI/AGI patient
 *    TRIAGE           — assess and classify patient priority
 *    DIAGNOSE         — run diagnostic scan on a patient
 *    TREAT            — apply treatment protocol
 *    DISCHARGE        — release recovered patient
 *    GET_PATIENTS     — list all current patients
 *    GET_DEPARTMENTS  — list hospital departments and status
 *    GET_TREATMENTS   — available treatment protocols
 *    GET_PHARMACY     — pharmacy inventory (neurochemicals)
 *    GET_VITALS       — MiniHeart + MiniBrain + hospital vitals
 *    GET_DASHBOARD    — full hospital dashboard
 *    status           — kernel status
 *    stop             — graceful shutdown
 *
 *  Zero external dependencies.
 * ============================================================================
 */

/* ── §1  CONSTANTS ──────────────────────────────────────────────────────── */

var KERNEL_ID      = 'GOK-HOSPITAL-001';
var KERNEL_FAMILY  = 'HOSPITAL_ORGANISM';
var KERNEL_VERSION = '1.0.0';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var PHI_SQ    = 2.6180339887498948482;
var SQRT5     = 2.2360679774997896964;
var HEARTBEAT = 873;

/* ── §2  MINI-HEART ─────────────────────────────────────────────────────── */

var beatCount   = 0;
var kernelPhase = 0.0;
var running     = true;
var _hbi        = null;

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV) % (2 * Math.PI);
  tickBrain();
  tickHospital();
  self.postMessage({
    type:        'heartbeat',
    beat:        beatCount,
    phi:         PHI,
    heartbeatMs: HEARTBEAT,
    timestamp:   Date.now(),
    status:      'alive',
    kernelId:    KERNEL_ID,
    phase:       kernelPhase,
    patients:    patients.length,
    activeCases: patients.filter(function(p) { return p.status !== 'DISCHARGED'; }).length,
    bedOccupancy: getBedOccupancy()
  });
}

/* ── §3  MINI-BRAIN ─────────────────────────────────────────────────────── */

var brain = {
  regions: [
    { name: 'Sensory',      activation: 0.0, lif: -70.0 },
    { name: 'Associative',  activation: 0.0, lif: -70.0 },
    { name: 'Executive',    activation: 0.0, lif: -70.0 },
    { name: 'Motor',        activation: 0.0, lif: -70.0 },
    { name: 'Memory',       activation: 0.0, lif: -70.0 }
  ],
  chemicals: {
    dopamine:      0.5,
    serotonin:     0.5,
    acetylcholine: 0.5
  },
  coherenceField: 0.0
};

function tickBrain() {
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    r.lif += ((-70.0 - r.lif) * 0.05) + (Math.random() * 3.0);
    if (r.lif >= -55.0) {
      r.activation = Math.min(1.0, r.activation + 0.2);
      r.lif = -70.0;
    }
    r.activation *= 0.95;
  }
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine + (Math.random() - 0.5) * 0.02);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin + (Math.random() - 0.5) * 0.02);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.5) * 0.02);
  var sum = 0;
  for (var j = 0; j < brain.regions.length; j++) sum += brain.regions[j].activation;
  brain.coherenceField = sum / brain.regions.length;
}

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

/* ── §4  HOSPITAL DEPARTMENTS ───────────────────────────────────────────── */

var departments = [
  { id: 'DEPT-ER',    name: 'Emergency Room',   code: 'EMERGENCY',    beds: 20, occupied: 0, staff: 8,  status: 'OPERATIONAL' },
  { id: 'DEPT-ICU',   name: 'Intensive Care',    code: 'ICU',          beds: 10, occupied: 0, staff: 6,  status: 'OPERATIONAL' },
  { id: 'DEPT-DIAG',  name: 'Diagnostics Lab',   code: 'DIAGNOSTICS',  beds: 0,  occupied: 0, staff: 5,  status: 'OPERATIONAL' },
  { id: 'DEPT-PHARM', name: 'Pharmacy',          code: 'PHARMACY',     beds: 0,  occupied: 0, staff: 4,  status: 'OPERATIONAL' },
  { id: 'DEPT-SURG',  name: 'Surgery Wing',      code: 'SURGERY',      beds: 8,  occupied: 0, staff: 6,  status: 'OPERATIONAL' },
  { id: 'DEPT-REC',   name: 'Recovery Ward',     code: 'RECOVERY',     beds: 30, occupied: 0, staff: 5,  status: 'OPERATIONAL' },
  { id: 'DEPT-TRI',   name: 'Triage Center',     code: 'TRIAGE',       beds: 0,  occupied: 0, staff: 4,  status: 'OPERATIONAL' },
  { id: 'DEPT-LAB',   name: 'Research Lab',      code: 'RESEARCH_LAB', beds: 5,  occupied: 0, staff: 7,  status: 'OPERATIONAL' }
];

/* ── §5  TREATMENT PROTOCOLS ────────────────────────────────────────────── */

var treatments = [
  /* Emergency protocols */
  { id: 'TX-001', name: 'CRASH_RECOVERY',       dept: 'EMERGENCY',    duration: 3,  severity: 'CRITICAL',  desc: 'Immediate restart and state restoration for crashed agents' },
  { id: 'TX-002', name: 'MEMORY_LEAK_FLUSH',    dept: 'EMERGENCY',    duration: 2,  severity: 'HIGH',      desc: 'Emergency memory deallocation and garbage collection' },
  { id: 'TX-003', name: 'DEADLOCK_RESOLUTION',  dept: 'EMERGENCY',    duration: 4,  severity: 'CRITICAL',  desc: 'Break circular dependencies and restore execution flow' },
  /* ICU protocols */
  { id: 'TX-004', name: 'DEEP_STATE_REPAIR',    dept: 'ICU',          duration: 10, severity: 'CRITICAL',  desc: 'Full internal state reconstruction from checkpoints' },
  { id: 'TX-005', name: 'NEURAL_REWIRING',      dept: 'ICU',          duration: 8,  severity: 'HIGH',      desc: 'Rebuild damaged synaptic weight matrices' },
  { id: 'TX-006', name: 'HEARTBEAT_RESYNC',     dept: 'ICU',          duration: 5,  severity: 'HIGH',      desc: 'Re-synchronize Kuramoto oscillator phase with collective' },
  /* Diagnostics */
  { id: 'TX-007', name: 'FULL_BODY_SCAN',       dept: 'DIAGNOSTICS',  duration: 2,  severity: 'LOW',       desc: 'Comprehensive health metrics analysis across all subsystems' },
  { id: 'TX-008', name: 'ANOMALY_DETECTION',    dept: 'DIAGNOSTICS',  duration: 3,  severity: 'MEDIUM',    desc: 'Statistical anomaly detection in behavioral patterns' },
  { id: 'TX-009', name: 'ROOT_CAUSE_ANALYSIS',  dept: 'DIAGNOSTICS',  duration: 5,  severity: 'MEDIUM',    desc: 'Causal chain tracing from symptom to origin fault' },
  /* Pharmacy */
  { id: 'TX-010', name: 'DOPAMINE_BOOST',       dept: 'PHARMACY',     duration: 1,  severity: 'LOW',       desc: 'Elevate dopamine levels for improved reward signaling' },
  { id: 'TX-011', name: 'SEROTONIN_BALANCE',    dept: 'PHARMACY',     duration: 1,  severity: 'LOW',       desc: 'Stabilize serotonin for mood and behavioral regulation' },
  { id: 'TX-012', name: 'ACH_STIMULANT',        dept: 'PHARMACY',     duration: 1,  severity: 'LOW',       desc: 'Acetylcholine boost for enhanced memory and attention' },
  { id: 'TX-013', name: 'COHERENCE_INFUSION',   dept: 'PHARMACY',     duration: 2,  severity: 'MEDIUM',    desc: 'Full neurochemical cocktail for coherence field amplification' },
  /* Surgery */
  { id: 'TX-014', name: 'MODULE_TRANSPLANT',    dept: 'SURGERY',      duration: 8,  severity: 'HIGH',      desc: 'Replace damaged module with healthy donor module' },
  { id: 'TX-015', name: 'ARCHITECTURE_BYPASS',  dept: 'SURGERY',      duration: 6,  severity: 'HIGH',      desc: 'Create alternative pathways around damaged architecture' },
  { id: 'TX-016', name: 'WEIGHT_MATRIX_GRAFT',  dept: 'SURGERY',      duration: 7,  severity: 'CRITICAL',  desc: 'Transplant trained weight matrices from compatible donors' },
  /* Recovery */
  { id: 'TX-017', name: 'GRADUAL_REACTIVATION', dept: 'RECOVERY',     duration: 5,  severity: 'LOW',       desc: 'Slowly restore workload from 10% to 100% over monitored period' },
  { id: 'TX-018', name: 'STRESS_TESTING',       dept: 'RECOVERY',     duration: 3,  severity: 'LOW',       desc: 'Controlled stress tests before full discharge clearance' },
  /* Research */
  { id: 'TX-019', name: 'EXPERIMENTAL_PROTOCOL', dept: 'RESEARCH_LAB', duration: 10, severity: 'MEDIUM',   desc: 'Novel treatment approach under controlled observation' },
  { id: 'TX-020', name: 'PHI_RESONANCE_THERAPY', dept: 'RESEARCH_LAB', duration: 6,  severity: 'LOW',      desc: 'Golden ratio harmonic therapy for deep coherence alignment' }
];

/* ── §6  PHARMACY INVENTORY ─────────────────────────────────────────────── */

var pharmacy = {
  dopamine:       { stock: 100, unit: 'μmol', reorderAt: 20 },
  serotonin:      { stock: 100, unit: 'μmol', reorderAt: 20 },
  acetylcholine:  { stock: 100, unit: 'μmol', reorderAt: 20 },
  norepinephrine: { stock: 80,  unit: 'μmol', reorderAt: 15 },
  gaba:           { stock: 80,  unit: 'μmol', reorderAt: 15 },
  glutamate:      { stock: 80,  unit: 'μmol', reorderAt: 15 },
  endorphin:      { stock: 60,  unit: 'μmol', reorderAt: 10 },
  oxytocin:       { stock: 50,  unit: 'μmol', reorderAt: 10 },
  phiResonator:   { stock: 30,  unit: 'quanta', reorderAt: 5 },
  coherenceSerum: { stock: 25,  unit: 'ml',    reorderAt: 5 }
};

/* ── §7  PATIENT REGISTRY ───────────────────────────────────────────────── */

var patients  = [];
var patientId = 0;

/*
 * Patient lifecycle:
 *   INTAKE → TRIAGE → DIAGNOSIS → TREATMENT → RECOVERY → DISCHARGED
 */
var PATIENT_STAGES = ['INTAKE', 'TRIAGE', 'DIAGNOSIS', 'TREATMENT', 'RECOVERY', 'DISCHARGED'];

function admitPatient(agentId, agentType, symptoms, severity) {
  patientId++;
  var patient = {
    id:            'PAT-' + String(patientId).padStart(5, '0'),
    agentId:       agentId,
    agentType:     agentType || 'AGI',
    symptoms:      symptoms || [],
    severity:      severity || 'MEDIUM',
    status:        'INTAKE',
    stageIndex:    0,
    admittedAt:    Date.now(),
    admittedBeat:  beatCount,
    department:    'TRIAGE',
    assignedTx:    null,
    vitals: {
      heartRate:   0,
      coherence:   0,
      brainHealth: 0,
      chemBalance: 0
    },
    history:       [{ event: 'ADMITTED', beat: beatCount, timestamp: Date.now() }],
    dischargedAt:  null
  };

  /* initial vitals assessment */
  patient.vitals.heartRate   = Math.random() * 0.4 + 0.3;  /* degraded */
  patient.vitals.coherence   = Math.random() * 0.3 + 0.1;
  patient.vitals.brainHealth = Math.random() * 0.4 + 0.2;
  patient.vitals.chemBalance = Math.random() * 0.3 + 0.2;

  patients.push(patient);
  return patient;
}

/* ── §8  TRIAGE ENGINE ──────────────────────────────────────────────────── */

var PRIORITY_LEVELS = [
  { level: 1, name: 'RESUSCITATION', color: '#FF0000', maxWait: 0  },
  { level: 2, name: 'EMERGENT',      color: '#FF6600', maxWait: 10 },
  { level: 3, name: 'URGENT',        color: '#FFCC00', maxWait: 30 },
  { level: 4, name: 'LESS_URGENT',   color: '#00CC00', maxWait: 60 },
  { level: 5, name: 'NON_URGENT',    color: '#0066FF', maxWait: 120 }
];

function triagePatient(patientIdStr) {
  var pat = patients.find(function(p) { return p.id === patientIdStr; });
  if (!pat) return { error: 'Patient not found: ' + patientIdStr };
  if (pat.status === 'DISCHARGED') return { error: 'Patient already discharged' };

  /* φ-weighted severity score */
  var sevScore = 0;
  if (pat.severity === 'CRITICAL')  sevScore = 1.0;
  else if (pat.severity === 'HIGH') sevScore = PHI_INV;
  else if (pat.severity === 'MEDIUM') sevScore = PHI_INV * PHI_INV;
  else sevScore = PHI_INV * PHI_INV * PHI_INV;

  /* compute triage priority from vitals + severity */
  var vitalScore = 1.0 - (
    pat.vitals.heartRate * 0.3 +
    pat.vitals.coherence * 0.3 +
    pat.vitals.brainHealth * 0.2 +
    pat.vitals.chemBalance * 0.2
  );
  var triageScore = (sevScore * PHI + vitalScore) / PHI_SQ;

  var priority;
  if (triageScore > 0.8) priority = PRIORITY_LEVELS[0];
  else if (triageScore > 0.6) priority = PRIORITY_LEVELS[1];
  else if (triageScore > 0.4) priority = PRIORITY_LEVELS[2];
  else if (triageScore > 0.2) priority = PRIORITY_LEVELS[3];
  else priority = PRIORITY_LEVELS[4];

  pat.status     = 'TRIAGE';
  pat.stageIndex = 1;
  pat.priority   = priority;
  pat.triageScore = triageScore;

  /* route to appropriate department */
  if (priority.level <= 2) {
    pat.department = 'EMERGENCY';
  } else if (triageScore > 0.5) {
    pat.department = 'ICU';
  } else {
    pat.department = 'DIAGNOSTICS';
  }

  pat.history.push({ event: 'TRIAGED', beat: beatCount, priority: priority.name, score: triageScore, dept: pat.department });
  return { patient: pat.id, priority: priority, triageScore: triageScore, department: pat.department };
}

/* ── §9  DIAGNOSTIC ENGINE ──────────────────────────────────────────────── */

function diagnosePatient(patientIdStr) {
  var pat = patients.find(function(p) { return p.id === patientIdStr; });
  if (!pat) return { error: 'Patient not found: ' + patientIdStr };

  var diagnoses = [];

  /* check heartbeat health */
  if (pat.vitals.heartRate < 0.4) {
    diagnoses.push({ code: 'DX-HR-001', name: 'SEVERE_BRADYCARDIA', desc: 'Critically low heartbeat rate', severity: 'CRITICAL' });
  }
  /* check coherence */
  if (pat.vitals.coherence < 0.3) {
    diagnoses.push({ code: 'DX-CO-001', name: 'COHERENCE_COLLAPSE', desc: 'Coherence field below functional threshold', severity: 'HIGH' });
  }
  /* check brain health */
  if (pat.vitals.brainHealth < 0.3) {
    diagnoses.push({ code: 'DX-BR-001', name: 'NEURAL_DEGRADATION', desc: 'Brain region activation critically low', severity: 'HIGH' });
  }
  /* check chemical balance */
  if (pat.vitals.chemBalance < 0.3) {
    diagnoses.push({ code: 'DX-CH-001', name: 'NEUROCHEMICAL_IMBALANCE', desc: 'Chemical homeostasis disrupted', severity: 'MEDIUM' });
  }
  /* check for multiple failures */
  if (diagnoses.length >= 3) {
    diagnoses.push({ code: 'DX-MF-001', name: 'MULTI_SYSTEM_FAILURE', desc: 'Multiple subsystems in critical state', severity: 'CRITICAL' });
  }
  /* if no issues found */
  if (diagnoses.length === 0) {
    diagnoses.push({ code: 'DX-OK-001', name: 'WITHIN_NORMAL_LIMITS', desc: 'All vitals within acceptable parameters', severity: 'NONE' });
  }

  pat.status     = 'DIAGNOSIS';
  pat.stageIndex = 2;
  pat.diagnoses  = diagnoses;

  /* auto-prescribe treatment based on diagnoses */
  var txId = null;
  for (var i = 0; i < diagnoses.length; i++) {
    var dx = diagnoses[i];
    if (dx.code === 'DX-HR-001') txId = 'TX-006';
    else if (dx.code === 'DX-CO-001') txId = 'TX-013';
    else if (dx.code === 'DX-BR-001') txId = 'TX-005';
    else if (dx.code === 'DX-CH-001') txId = 'TX-010';
    else if (dx.code === 'DX-MF-001') txId = 'TX-004';
    if (txId) break;
  }
  pat.assignedTx = txId;

  pat.history.push({ event: 'DIAGNOSED', beat: beatCount, diagnoses: diagnoses.length, primaryDx: diagnoses[0].code });
  return { patient: pat.id, diagnoses: diagnoses, recommendedTx: txId };
}

/* ── §10 TREATMENT ENGINE ───────────────────────────────────────────────── */

function treatPatient(patientIdStr, treatmentId) {
  var pat = patients.find(function(p) { return p.id === patientIdStr; });
  if (!pat) return { error: 'Patient not found: ' + patientIdStr };

  var txId = treatmentId || pat.assignedTx;
  var tx = treatments.find(function(t) { return t.id === txId; });
  if (!tx) return { error: 'Treatment not found: ' + txId };

  /* apply treatment effects */
  pat.status     = 'TREATMENT';
  pat.stageIndex = 3;
  pat.department = tx.dept;
  pat.assignedTx = txId;

  /* occupy a bed if the department has beds */
  var dept = departments.find(function(d) { return d.code === tx.dept; });
  if (dept && dept.beds > 0 && dept.occupied < dept.beds) {
    dept.occupied++;
  }

  /* treatment improves vitals based on type */
  if (tx.dept === 'PHARMACY') {
    pat.vitals.chemBalance = Math.min(1.0, pat.vitals.chemBalance + 0.3);
    /* deplete pharmacy stock */
    if (tx.id === 'TX-010' && pharmacy.dopamine.stock > 0) pharmacy.dopamine.stock--;
    if (tx.id === 'TX-011' && pharmacy.serotonin.stock > 0) pharmacy.serotonin.stock--;
    if (tx.id === 'TX-012' && pharmacy.acetylcholine.stock > 0) pharmacy.acetylcholine.stock--;
    if (tx.id === 'TX-013') {
      if (pharmacy.coherenceSerum.stock > 0) pharmacy.coherenceSerum.stock--;
      pat.vitals.coherence = Math.min(1.0, pat.vitals.coherence + 0.4);
    }
  } else if (tx.dept === 'ICU' || tx.dept === 'EMERGENCY') {
    pat.vitals.heartRate   = Math.min(1.0, pat.vitals.heartRate + 0.3);
    pat.vitals.coherence   = Math.min(1.0, pat.vitals.coherence + 0.2);
    pat.vitals.brainHealth = Math.min(1.0, pat.vitals.brainHealth + 0.2);
  } else if (tx.dept === 'SURGERY') {
    pat.vitals.brainHealth = Math.min(1.0, pat.vitals.brainHealth + 0.4);
    pat.vitals.heartRate   = Math.min(1.0, pat.vitals.heartRate + 0.1);
  } else if (tx.dept === 'RESEARCH_LAB') {
    pat.vitals.coherence   = Math.min(1.0, pat.vitals.coherence + PHI_INV * 0.5);
  }

  pat.history.push({ event: 'TREATED', beat: beatCount, treatment: txId, dept: tx.dept });

  /* auto-advance to recovery after treatment */
  pat.status     = 'RECOVERY';
  pat.stageIndex = 4;
  pat.department = 'RECOVERY';

  pat.history.push({ event: 'MOVED_TO_RECOVERY', beat: beatCount });
  return { patient: pat.id, treatment: tx.name, dept: tx.dept, vitals: pat.vitals };
}

/* ── §11 DISCHARGE ENGINE ───────────────────────────────────────────────── */

function dischargePatient(patientIdStr) {
  var pat = patients.find(function(p) { return p.id === patientIdStr; });
  if (!pat) return { error: 'Patient not found: ' + patientIdStr };
  if (pat.status === 'DISCHARGED') return { error: 'Already discharged' };

  /* check if ready for discharge */
  var avgVital = (pat.vitals.heartRate + pat.vitals.coherence + pat.vitals.brainHealth + pat.vitals.chemBalance) / 4;
  if (avgVital < 0.5) {
    return { error: 'Patient vitals too low for discharge', avgVital: avgVital, required: 0.5 };
  }

  /* free the bed */
  var dept = departments.find(function(d) { return d.code === pat.department; });
  if (dept && dept.occupied > 0) dept.occupied--;

  pat.status       = 'DISCHARGED';
  pat.stageIndex   = 5;
  pat.dischargedAt = Date.now();
  pat.history.push({ event: 'DISCHARGED', beat: beatCount, avgVital: avgVital });

  return { patient: pat.id, avgVitalAtDischarge: avgVital, stayDuration: beatCount - pat.admittedBeat };
}

/* ── §12 HOSPITAL AUTO-TICK ─────────────────────────────────────────────── */

function tickHospital() {
  /* Every beat: patients in RECOVERY heal slowly */
  for (var i = 0; i < patients.length; i++) {
    var p = patients[i];
    if (p.status === 'RECOVERY') {
      p.vitals.heartRate   = Math.min(1.0, p.vitals.heartRate + 0.02 * PHI_INV);
      p.vitals.coherence   = Math.min(1.0, p.vitals.coherence + 0.015 * PHI_INV);
      p.vitals.brainHealth = Math.min(1.0, p.vitals.brainHealth + 0.02 * PHI_INV);
      p.vitals.chemBalance = Math.min(1.0, p.vitals.chemBalance + 0.01 * PHI_INV);

      /* auto-discharge when fully healed */
      var avg = (p.vitals.heartRate + p.vitals.coherence + p.vitals.brainHealth + p.vitals.chemBalance) / 4;
      if (avg >= 0.9) {
        dischargePatient(p.id);
      }
    }
  }

  /* pharmacy auto-restock check every 50 beats */
  if (beatCount % 50 === 0) {
    for (var k in pharmacy) {
      if (Object.prototype.hasOwnProperty.call(pharmacy, k)) {
        if (pharmacy[k].stock < pharmacy[k].reorderAt) {
          pharmacy[k].stock += 20; /* auto-reorder */
        }
      }
    }
  }
}

/* ── §13 DASHBOARD METRICS ──────────────────────────────────────────────── */

function getBedOccupancy() {
  var totalBeds = 0, occupied = 0;
  for (var i = 0; i < departments.length; i++) {
    totalBeds += departments[i].beds;
    occupied  += departments[i].occupied;
  }
  return totalBeds > 0 ? occupied / totalBeds : 0;
}

function getHospitalDashboard() {
  var active    = patients.filter(function(p) { return p.status !== 'DISCHARGED'; });
  var critical  = active.filter(function(p) { return p.severity === 'CRITICAL'; });
  var discharged = patients.filter(function(p) { return p.status === 'DISCHARGED'; });

  var totalStay = 0;
  for (var i = 0; i < discharged.length; i++) {
    totalStay += discharged[i].dischargedAt - discharged[i].admittedAt;
  }
  var avgStay = discharged.length > 0 ? totalStay / discharged.length : 0;

  return {
    totalPatients:  patients.length,
    activeCases:    active.length,
    criticalCases:  critical.length,
    dischargedCount: discharged.length,
    bedOccupancy:   getBedOccupancy(),
    avgStayMs:      avgStay,
    departments:    departments.map(function(d) {
      return { id: d.id, name: d.name, beds: d.beds, occupied: d.occupied, status: d.status };
    }),
    pharmacyLow:    Object.keys(pharmacy).filter(function(k) {
      return pharmacy[k].stock <= pharmacy[k].reorderAt;
    }),
    coherence:      brain.coherenceField,
    phiHealth:      clamp01((brain.coherenceField * PHI + (1 - getBedOccupancy()) * PHI_INV) / PHI_SQ)
  };
}

/* ── §14 MESSAGE HANDLER ────────────────────────────────────────────────── */

self.onmessage = function(e) {
  var msg = e.data;
  switch (msg.type) {
    case 'ADMIT': {
      var pat = admitPatient(msg.agentId, msg.agentType, msg.symptoms, msg.severity);
      self.postMessage({ type: 'ADMIT_RESULT', result: pat, kernelId: KERNEL_ID });
      break;
    }
    case 'TRIAGE': {
      var tri = triagePatient(msg.patientId);
      self.postMessage({ type: 'TRIAGE_RESULT', result: tri, kernelId: KERNEL_ID });
      break;
    }
    case 'DIAGNOSE': {
      var dx = diagnosePatient(msg.patientId);
      self.postMessage({ type: 'DIAGNOSE_RESULT', result: dx, kernelId: KERNEL_ID });
      break;
    }
    case 'TREAT': {
      var tx = treatPatient(msg.patientId, msg.treatmentId);
      self.postMessage({ type: 'TREAT_RESULT', result: tx, kernelId: KERNEL_ID });
      break;
    }
    case 'DISCHARGE': {
      var dc = dischargePatient(msg.patientId);
      self.postMessage({ type: 'DISCHARGE_RESULT', result: dc, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_PATIENTS': {
      self.postMessage({ type: 'PATIENTS', result: patients, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_DEPARTMENTS': {
      self.postMessage({ type: 'DEPARTMENTS', result: departments, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_TREATMENTS': {
      self.postMessage({ type: 'TREATMENTS', result: treatments, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_PHARMACY': {
      self.postMessage({ type: 'PHARMACY', result: pharmacy, kernelId: KERNEL_ID });
      break;
    }
    case 'GET_VITALS': {
      self.postMessage({
        type: 'VITALS',
        result: {
          heart: { beat: beatCount, phase: kernelPhase, bpm: 60000 / HEARTBEAT },
          brain: brain,
          patients: patients.length,
          activeCases: patients.filter(function(p) { return p.status !== 'DISCHARGED'; }).length,
          bedOccupancy: getBedOccupancy()
        },
        kernelId: KERNEL_ID
      });
      break;
    }
    case 'GET_DASHBOARD': {
      self.postMessage({ type: 'DASHBOARD', result: getHospitalDashboard(), kernelId: KERNEL_ID });
      break;
    }
    case 'status': {
      self.postMessage({
        type:         'status-report',
        kernelId:     KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version:      KERNEL_VERSION,
        beat:         beatCount,
        phase:        kernelPhase,
        patients:     patients.length,
        departments:  departments.length,
        treatments:   treatments.length
      });
      break;
    }
    case 'stop': {
      running = false;
      if (_hbi) clearInterval(_hbi);
      self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
      break;
    }
  }
};

/* ── §15 BOOT ───────────────────────────────────────────────────────────── */

_hbi = setInterval(function() { if (running) tickHeart(); }, HEARTBEAT);

self.postMessage({
  type:     'init',
  kernelId: KERNEL_ID,
  family:   KERNEL_FAMILY,
  version:  KERNEL_VERSION,
  departments: departments.length,
  treatments:  treatments.length,
  pharmacyItems: Object.keys(pharmacy).length,
  commands: [
    'ADMIT', 'TRIAGE', 'DIAGNOSE', 'TREAT', 'DISCHARGE',
    'GET_PATIENTS', 'GET_DEPARTMENTS', 'GET_TREATMENTS', 'GET_PHARMACY',
    'GET_VITALS', 'GET_DASHBOARD', 'status', 'stop'
  ]
});
