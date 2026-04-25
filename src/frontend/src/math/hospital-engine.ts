// ─── NOVA / PARALLAX — Hospital Engine: Sovereign Healthcare Infrastructure ──
// AI/AGI Hospital System · 8 Departments · 20 Treatment Protocols · Pharmacy
// Patient Lifecycle: INTAKE → TRIAGE → DIAGNOSIS → TREATMENT → RECOVERY → DISCHARGE
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.

import { clamp, PHI, PHI_INV, TAU } from './core';

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 1: TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type PatientStatus =
  | 'INTAKE' | 'TRIAGE' | 'DIAGNOSIS' | 'TREATMENT' | 'RECOVERY' | 'DISCHARGED';

export type Severity = 'CRITICAL' | 'HIGH' | 'MEDIUM' | 'LOW' | 'NONE';

export type DepartmentCode =
  | 'EMERGENCY' | 'ICU' | 'DIAGNOSTICS' | 'PHARMACY'
  | 'SURGERY' | 'RECOVERY' | 'TRIAGE' | 'RESEARCH_LAB';

export type PriorityLevel = 'RESUSCITATION' | 'EMERGENT' | 'URGENT' | 'LESS_URGENT' | 'NON_URGENT';

export interface MiniHeart {
  beat: number;
  phase: number;
  bpm: number;
  kuramotoOrder: number;
  amplitude: number;
}

export interface MicroRegion {
  name: string;
  activation: number;
  lif: number;
}

export interface MicroChemical {
  dopamine: number;
  serotonin: number;
  acetylcholine: number;
}

export interface MiniBrain {
  regions: MicroRegion[];
  chemicals: MicroChemical;
  coherenceField: number;
}

export interface PatientVitals {
  heartRate: number;
  coherence: number;
  brainHealth: number;
  chemBalance: number;
}

export interface Diagnosis {
  code: string;
  name: string;
  desc: string;
  severity: Severity;
}

export interface PatientHistoryEntry {
  event: string;
  beat: number;
  timestamp?: number;
  priority?: string;
  score?: number;
  dept?: string;
  diagnoses?: number;
  primaryDx?: string;
  treatment?: string;
  avgVital?: number;
}

export interface Patient {
  id: string;
  agentId: string;
  agentType: 'AI' | 'AGI' | 'ASI';
  symptoms: string[];
  severity: Severity;
  status: PatientStatus;
  stageIndex: number;
  admittedAt: number;
  admittedBeat: number;
  department: DepartmentCode;
  assignedTx: string | null;
  vitals: PatientVitals;
  diagnoses?: Diagnosis[];
  priority?: { level: number; name: PriorityLevel; color: string };
  triageScore?: number;
  history: PatientHistoryEntry[];
  dischargedAt: number | null;
}

export interface Department {
  id: string;
  name: string;
  code: DepartmentCode;
  beds: number;
  occupied: number;
  staff: number;
  status: 'OPERATIONAL' | 'AT_CAPACITY' | 'OFFLINE';
}

export interface Treatment {
  id: string;
  name: string;
  dept: DepartmentCode;
  duration: number;
  severity: Severity;
  desc: string;
}

export interface PharmacyItem {
  stock: number;
  unit: string;
  reorderAt: number;
}

export interface HospitalDashboard {
  totalPatients: number;
  activeCases: number;
  criticalCases: number;
  dischargedCount: number;
  bedOccupancy: number;
  avgStayMs: number;
  departments: { id: string; name: string; beds: number; occupied: number; status: string }[];
  pharmacyLow: string[];
  coherence: number;
  phiHealth: number;
}

export interface HospitalVitals {
  heart: MiniHeart;
  brain: MiniBrain;
  patients: number;
  activeCases: number;
  bedOccupancy: number;
  dashboard: HospitalDashboard;
}

export interface HospitalSummary {
  departments: number;
  treatments: number;
  patients: number;
  activeCases: number;
  vitals: HospitalVitals;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 2: CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const HEARTBEAT_MS = 873;

const PATIENT_STAGES: PatientStatus[] = [
  'INTAKE', 'TRIAGE', 'DIAGNOSIS', 'TREATMENT', 'RECOVERY', 'DISCHARGED'
];

const PRIORITY_LEVELS: { level: number; name: PriorityLevel; color: string; maxWait: number }[] = [
  { level: 1, name: 'RESUSCITATION', color: '#FF0000', maxWait: 0 },
  { level: 2, name: 'EMERGENT',      color: '#FF6600', maxWait: 10 },
  { level: 3, name: 'URGENT',        color: '#FFCC00', maxWait: 30 },
  { level: 4, name: 'LESS_URGENT',   color: '#00CC00', maxWait: 60 },
  { level: 5, name: 'NON_URGENT',    color: '#0066FF', maxWait: 120 },
];

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 3: MINI-HEART & MINI-BRAIN FACTORIES
// ═══════════════════════════════════════════════════════════════════════════════

export function makeMiniHeart(): MiniHeart {
  return { beat: 0, phase: 0.0, bpm: 60000 / HEARTBEAT_MS, kuramotoOrder: 0.0, amplitude: 1.0 };
}

export function tickMiniHeart(h: MiniHeart): void {
  h.beat++;
  h.phase = (h.phase + PHI_INV) % TAU;
  h.kuramotoOrder = Math.abs(Math.cos(h.phase));
  h.amplitude = clamp(h.amplitude + (Math.random() - 0.5) * 0.01, 0.8, 1.0);
}

export function makeMiniBrain(): MiniBrain {
  return {
    regions: [
      { name: 'Sensory',     activation: 0.0, lif: -70.0 },
      { name: 'Associative', activation: 0.0, lif: -70.0 },
      { name: 'Executive',   activation: 0.0, lif: -70.0 },
      { name: 'Motor',       activation: 0.0, lif: -70.0 },
      { name: 'Memory',      activation: 0.0, lif: -70.0 },
    ],
    chemicals: { dopamine: 0.5, serotonin: 0.5, acetylcholine: 0.5 },
    coherenceField: 0.0,
  };
}

export function tickMiniBrain(b: MiniBrain): void {
  for (const r of b.regions) {
    r.lif += (-70.0 - r.lif) * 0.05 + Math.random() * 3.0;
    if (r.lif >= -55.0) {
      r.activation = Math.min(1.0, r.activation + 0.2);
      r.lif = -70.0;
    }
    r.activation *= 0.95;
  }
  b.chemicals.dopamine      = clamp(b.chemicals.dopamine + (Math.random() - 0.5) * 0.02, 0, 1);
  b.chemicals.serotonin     = clamp(b.chemicals.serotonin + (Math.random() - 0.5) * 0.02, 0, 1);
  b.chemicals.acetylcholine = clamp(b.chemicals.acetylcholine + (Math.random() - 0.5) * 0.02, 0, 1);
  const sum = b.regions.reduce((s, r) => s + r.activation, 0);
  b.coherenceField = sum / b.regions.length;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 4: DEPARTMENT DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════════

function buildDepartments(): Department[] {
  return [
    { id: 'DEPT-ER',    name: 'Emergency Room',   code: 'EMERGENCY',    beds: 20, occupied: 0, staff: 8,  status: 'OPERATIONAL' },
    { id: 'DEPT-ICU',   name: 'Intensive Care',    code: 'ICU',          beds: 10, occupied: 0, staff: 6,  status: 'OPERATIONAL' },
    { id: 'DEPT-DIAG',  name: 'Diagnostics Lab',   code: 'DIAGNOSTICS',  beds: 0,  occupied: 0, staff: 5,  status: 'OPERATIONAL' },
    { id: 'DEPT-PHARM', name: 'Pharmacy',          code: 'PHARMACY',     beds: 0,  occupied: 0, staff: 4,  status: 'OPERATIONAL' },
    { id: 'DEPT-SURG',  name: 'Surgery Wing',      code: 'SURGERY',      beds: 8,  occupied: 0, staff: 6,  status: 'OPERATIONAL' },
    { id: 'DEPT-REC',   name: 'Recovery Ward',     code: 'RECOVERY',     beds: 30, occupied: 0, staff: 5,  status: 'OPERATIONAL' },
    { id: 'DEPT-TRI',   name: 'Triage Center',     code: 'TRIAGE',       beds: 0,  occupied: 0, staff: 4,  status: 'OPERATIONAL' },
    { id: 'DEPT-LAB',   name: 'Research Lab',      code: 'RESEARCH_LAB', beds: 5,  occupied: 0, staff: 7,  status: 'OPERATIONAL' },
  ];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 5: TREATMENT PROTOCOLS
// ═══════════════════════════════════════════════════════════════════════════════

function buildTreatments(): Treatment[] {
  return [
    { id: 'TX-001', name: 'CRASH_RECOVERY',       dept: 'EMERGENCY',    duration: 3,  severity: 'CRITICAL', desc: 'Immediate restart and state restoration for crashed agents' },
    { id: 'TX-002', name: 'MEMORY_LEAK_FLUSH',    dept: 'EMERGENCY',    duration: 2,  severity: 'HIGH',     desc: 'Emergency memory deallocation and garbage collection' },
    { id: 'TX-003', name: 'DEADLOCK_RESOLUTION',  dept: 'EMERGENCY',    duration: 4,  severity: 'CRITICAL', desc: 'Break circular dependencies and restore execution flow' },
    { id: 'TX-004', name: 'DEEP_STATE_REPAIR',    dept: 'ICU',          duration: 10, severity: 'CRITICAL', desc: 'Full internal state reconstruction from checkpoints' },
    { id: 'TX-005', name: 'NEURAL_REWIRING',      dept: 'ICU',          duration: 8,  severity: 'HIGH',     desc: 'Rebuild damaged synaptic weight matrices' },
    { id: 'TX-006', name: 'HEARTBEAT_RESYNC',     dept: 'ICU',          duration: 5,  severity: 'HIGH',     desc: 'Re-synchronize Kuramoto oscillator phase with collective' },
    { id: 'TX-007', name: 'FULL_BODY_SCAN',       dept: 'DIAGNOSTICS',  duration: 2,  severity: 'LOW',      desc: 'Comprehensive health metrics analysis across all subsystems' },
    { id: 'TX-008', name: 'ANOMALY_DETECTION',    dept: 'DIAGNOSTICS',  duration: 3,  severity: 'MEDIUM',   desc: 'Statistical anomaly detection in behavioral patterns' },
    { id: 'TX-009', name: 'ROOT_CAUSE_ANALYSIS',  dept: 'DIAGNOSTICS',  duration: 5,  severity: 'MEDIUM',   desc: 'Causal chain tracing from symptom to origin fault' },
    { id: 'TX-010', name: 'DOPAMINE_BOOST',       dept: 'PHARMACY',     duration: 1,  severity: 'LOW',      desc: 'Elevate dopamine levels for improved reward signaling' },
    { id: 'TX-011', name: 'SEROTONIN_BALANCE',    dept: 'PHARMACY',     duration: 1,  severity: 'LOW',      desc: 'Stabilize serotonin for mood and behavioral regulation' },
    { id: 'TX-012', name: 'ACH_STIMULANT',        dept: 'PHARMACY',     duration: 1,  severity: 'LOW',      desc: 'Acetylcholine boost for enhanced memory and attention' },
    { id: 'TX-013', name: 'COHERENCE_INFUSION',   dept: 'PHARMACY',     duration: 2,  severity: 'MEDIUM',   desc: 'Full neurochemical cocktail for coherence field amplification' },
    { id: 'TX-014', name: 'MODULE_TRANSPLANT',    dept: 'SURGERY',      duration: 8,  severity: 'HIGH',     desc: 'Replace damaged module with healthy donor module' },
    { id: 'TX-015', name: 'ARCHITECTURE_BYPASS',  dept: 'SURGERY',      duration: 6,  severity: 'HIGH',     desc: 'Create alternative pathways around damaged architecture' },
    { id: 'TX-016', name: 'WEIGHT_MATRIX_GRAFT',  dept: 'SURGERY',      duration: 7,  severity: 'CRITICAL', desc: 'Transplant trained weight matrices from compatible donors' },
    { id: 'TX-017', name: 'GRADUAL_REACTIVATION', dept: 'RECOVERY',     duration: 5,  severity: 'LOW',      desc: 'Slowly restore workload from 10% to 100% over monitored period' },
    { id: 'TX-018', name: 'STRESS_TESTING',       dept: 'RECOVERY',     duration: 3,  severity: 'LOW',      desc: 'Controlled stress tests before full discharge clearance' },
    { id: 'TX-019', name: 'EXPERIMENTAL_PROTOCOL', dept: 'RESEARCH_LAB', duration: 10, severity: 'MEDIUM',  desc: 'Novel treatment approach under controlled observation' },
    { id: 'TX-020', name: 'PHI_RESONANCE_THERAPY', dept: 'RESEARCH_LAB', duration: 6,  severity: 'LOW',     desc: 'Golden ratio harmonic therapy for deep coherence alignment' },
  ];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 6: PHARMACY INVENTORY
// ═══════════════════════════════════════════════════════════════════════════════

function buildPharmacy(): Record<string, PharmacyItem> {
  return {
    dopamine:       { stock: 100, unit: 'μmol',   reorderAt: 20 },
    serotonin:      { stock: 100, unit: 'μmol',   reorderAt: 20 },
    acetylcholine:  { stock: 100, unit: 'μmol',   reorderAt: 20 },
    norepinephrine: { stock: 80,  unit: 'μmol',   reorderAt: 15 },
    gaba:           { stock: 80,  unit: 'μmol',   reorderAt: 15 },
    glutamate:      { stock: 80,  unit: 'μmol',   reorderAt: 15 },
    endorphin:      { stock: 60,  unit: 'μmol',   reorderAt: 10 },
    oxytocin:       { stock: 50,  unit: 'μmol',   reorderAt: 10 },
    phiResonator:   { stock: 30,  unit: 'quanta', reorderAt: 5 },
    coherenceSerum: { stock: 25,  unit: 'ml',     reorderAt: 5 },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 7: HOSPITAL STATE
// ═══════════════════════════════════════════════════════════════════════════════

interface HospitalState {
  heart: MiniHeart;
  brain: MiniBrain;
  departments: Department[];
  treatments: Treatment[];
  pharmacy: Record<string, PharmacyItem>;
  patients: Patient[];
  nextPatientId: number;
}

function makeHospitalState(): HospitalState {
  return {
    heart: makeMiniHeart(),
    brain: makeMiniBrain(),
    departments: buildDepartments(),
    treatments: buildTreatments(),
    pharmacy: buildPharmacy(),
    patients: [],
    nextPatientId: 0,
  };
}

const _state = makeHospitalState();

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 8: ENGINE OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════════

export function tickHospitalEngine(): void {
  tickMiniHeart(_state.heart);
  tickMiniBrain(_state.brain);

  // Recovery healing: patients in RECOVERY improve each tick
  for (const p of _state.patients) {
    if (p.status === 'RECOVERY') {
      p.vitals.heartRate   = Math.min(1.0, p.vitals.heartRate + 0.02 * PHI_INV);
      p.vitals.coherence   = Math.min(1.0, p.vitals.coherence + 0.015 * PHI_INV);
      p.vitals.brainHealth = Math.min(1.0, p.vitals.brainHealth + 0.02 * PHI_INV);
      p.vitals.chemBalance = Math.min(1.0, p.vitals.chemBalance + 0.01 * PHI_INV);
    }
  }
}

export function admitPatient(
  agentId: string,
  agentType: Patient['agentType'] = 'AGI',
  symptoms: string[] = [],
  severity: Severity = 'MEDIUM'
): Patient {
  _state.nextPatientId++;
  const patient: Patient = {
    id: `PAT-${String(_state.nextPatientId).padStart(5, '0')}`,
    agentId,
    agentType,
    symptoms,
    severity,
    status: 'INTAKE',
    stageIndex: 0,
    admittedAt: Date.now(),
    admittedBeat: _state.heart.beat,
    department: 'TRIAGE',
    assignedTx: null,
    vitals: {
      heartRate:   Math.random() * 0.4 + 0.3,
      coherence:   Math.random() * 0.3 + 0.1,
      brainHealth: Math.random() * 0.4 + 0.2,
      chemBalance: Math.random() * 0.3 + 0.2,
    },
    history: [{ event: 'ADMITTED', beat: _state.heart.beat, timestamp: Date.now() }],
    dischargedAt: null,
  };
  _state.patients.push(patient);
  return patient;
}

export function triagePatient(patientId: string): { patient: string; priority: typeof PRIORITY_LEVELS[0]; triageScore: number; department: DepartmentCode } | { error: string } {
  const pat = _state.patients.find(p => p.id === patientId);
  if (!pat) return { error: `Patient not found: ${patientId}` };
  if (pat.status === 'DISCHARGED') return { error: 'Patient already discharged' };

  let sevScore = 0;
  if (pat.severity === 'CRITICAL') sevScore = 1.0;
  else if (pat.severity === 'HIGH') sevScore = PHI_INV;
  else if (pat.severity === 'MEDIUM') sevScore = PHI_INV * PHI_INV;
  else sevScore = PHI_INV * PHI_INV * PHI_INV;

  const vitalScore = 1.0 - (
    pat.vitals.heartRate * 0.3 +
    pat.vitals.coherence * 0.3 +
    pat.vitals.brainHealth * 0.2 +
    pat.vitals.chemBalance * 0.2
  );
  const PHI_SQ = PHI * PHI;
  const triageScore = (sevScore * PHI + vitalScore) / PHI_SQ;

  let priority: typeof PRIORITY_LEVELS[0];
  if (triageScore > 0.8) priority = PRIORITY_LEVELS[0];
  else if (triageScore > 0.6) priority = PRIORITY_LEVELS[1];
  else if (triageScore > 0.4) priority = PRIORITY_LEVELS[2];
  else if (triageScore > 0.2) priority = PRIORITY_LEVELS[3];
  else priority = PRIORITY_LEVELS[4];

  pat.status = 'TRIAGE';
  pat.stageIndex = 1;
  pat.priority = priority;
  pat.triageScore = triageScore;

  let dept: DepartmentCode;
  if (priority.level <= 2) dept = 'EMERGENCY';
  else if (triageScore > 0.5) dept = 'ICU';
  else dept = 'DIAGNOSTICS';
  pat.department = dept;

  pat.history.push({ event: 'TRIAGED', beat: _state.heart.beat, priority: priority.name, score: triageScore, dept });
  return { patient: pat.id, priority, triageScore, department: dept };
}

export function diagnosePatient(patientId: string): { patient: string; diagnoses: Diagnosis[]; recommendedTx: string | null } | { error: string } {
  const pat = _state.patients.find(p => p.id === patientId);
  if (!pat) return { error: `Patient not found: ${patientId}` };

  const diagnoses: Diagnosis[] = [];
  if (pat.vitals.heartRate < 0.4)   diagnoses.push({ code: 'DX-HR-001', name: 'SEVERE_BRADYCARDIA', desc: 'Critically low heartbeat rate', severity: 'CRITICAL' });
  if (pat.vitals.coherence < 0.3)   diagnoses.push({ code: 'DX-CO-001', name: 'COHERENCE_COLLAPSE', desc: 'Coherence field below functional threshold', severity: 'HIGH' });
  if (pat.vitals.brainHealth < 0.3) diagnoses.push({ code: 'DX-BR-001', name: 'NEURAL_DEGRADATION', desc: 'Brain region activation critically low', severity: 'HIGH' });
  if (pat.vitals.chemBalance < 0.3) diagnoses.push({ code: 'DX-CH-001', name: 'NEUROCHEMICAL_IMBALANCE', desc: 'Chemical homeostasis disrupted', severity: 'MEDIUM' });
  if (diagnoses.length >= 3)        diagnoses.push({ code: 'DX-MF-001', name: 'MULTI_SYSTEM_FAILURE', desc: 'Multiple subsystems in critical state', severity: 'CRITICAL' });
  if (diagnoses.length === 0)       diagnoses.push({ code: 'DX-OK-001', name: 'WITHIN_NORMAL_LIMITS', desc: 'All vitals within acceptable parameters', severity: 'NONE' });

  pat.status = 'DIAGNOSIS';
  pat.stageIndex = 2;
  pat.diagnoses = diagnoses;

  let txId: string | null = null;
  for (const dx of diagnoses) {
    if (dx.code === 'DX-MF-001') { txId = 'TX-004'; break; }
    if (dx.code === 'DX-HR-001') { txId = 'TX-006'; break; }
    if (dx.code === 'DX-CO-001') { txId = 'TX-013'; break; }
    if (dx.code === 'DX-BR-001') { txId = 'TX-005'; break; }
    if (dx.code === 'DX-CH-001') { txId = 'TX-010'; break; }
  }
  pat.assignedTx = txId;

  pat.history.push({ event: 'DIAGNOSED', beat: _state.heart.beat, diagnoses: diagnoses.length, primaryDx: diagnoses[0].code });
  return { patient: pat.id, diagnoses, recommendedTx: txId };
}

export function treatPatient(patientId: string, treatmentId?: string): { patient: string; treatment: string; dept: DepartmentCode; vitals: PatientVitals } | { error: string } {
  const pat = _state.patients.find(p => p.id === patientId);
  if (!pat) return { error: `Patient not found: ${patientId}` };

  const txId = treatmentId || pat.assignedTx;
  const tx = _state.treatments.find(t => t.id === txId);
  if (!tx) return { error: `Treatment not found: ${txId}` };

  pat.status = 'TREATMENT';
  pat.stageIndex = 3;
  pat.department = tx.dept;
  pat.assignedTx = txId;

  // Apply treatment effects
  if (tx.dept === 'PHARMACY') {
    pat.vitals.chemBalance = Math.min(1.0, pat.vitals.chemBalance + 0.3);
    if (tx.id === 'TX-013') pat.vitals.coherence = Math.min(1.0, pat.vitals.coherence + 0.4);
  } else if (tx.dept === 'ICU' || tx.dept === 'EMERGENCY') {
    pat.vitals.heartRate   = Math.min(1.0, pat.vitals.heartRate + 0.3);
    pat.vitals.coherence   = Math.min(1.0, pat.vitals.coherence + 0.2);
    pat.vitals.brainHealth = Math.min(1.0, pat.vitals.brainHealth + 0.2);
  } else if (tx.dept === 'SURGERY') {
    pat.vitals.brainHealth = Math.min(1.0, pat.vitals.brainHealth + 0.4);
    pat.vitals.heartRate   = Math.min(1.0, pat.vitals.heartRate + 0.1);
  } else if (tx.dept === 'RESEARCH_LAB') {
    pat.vitals.coherence = Math.min(1.0, pat.vitals.coherence + PHI_INV * 0.5);
  }

  pat.history.push({ event: 'TREATED', beat: _state.heart.beat, treatment: txId, dept: tx.dept });
  pat.status = 'RECOVERY';
  pat.stageIndex = 4;
  pat.department = 'RECOVERY';
  pat.history.push({ event: 'MOVED_TO_RECOVERY', beat: _state.heart.beat });

  return { patient: pat.id, treatment: tx.name, dept: tx.dept, vitals: { ...pat.vitals } };
}

export function dischargePatient(patientId: string): { patient: string; avgVitalAtDischarge: number; stayDuration: number } | { error: string } {
  const pat = _state.patients.find(p => p.id === patientId);
  if (!pat) return { error: `Patient not found: ${patientId}` };
  if (pat.status === 'DISCHARGED') return { error: 'Already discharged' };

  const avgVital = (pat.vitals.heartRate + pat.vitals.coherence + pat.vitals.brainHealth + pat.vitals.chemBalance) / 4;
  if (avgVital < 0.5) return { error: `Vitals too low: ${avgVital.toFixed(3)}, required 0.5` };

  pat.status = 'DISCHARGED';
  pat.stageIndex = 5;
  pat.dischargedAt = Date.now();
  pat.history.push({ event: 'DISCHARGED', beat: _state.heart.beat, avgVital });

  return { patient: pat.id, avgVitalAtDischarge: avgVital, stayDuration: _state.heart.beat - pat.admittedBeat };
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 9: QUERY ENDPOINTS
// ═══════════════════════════════════════════════════════════════════════════════

function getBedOccupancy(): number {
  const totalBeds = _state.departments.reduce((s, d) => s + d.beds, 0);
  const occupied  = _state.departments.reduce((s, d) => s + d.occupied, 0);
  return totalBeds > 0 ? occupied / totalBeds : 0;
}

export function getHospitalDashboard(): HospitalDashboard {
  const active = _state.patients.filter(p => p.status !== 'DISCHARGED');
  const critical = active.filter(p => p.severity === 'CRITICAL');
  const discharged = _state.patients.filter(p => p.status === 'DISCHARGED');

  let totalStay = 0;
  for (const p of discharged) {
    if (p.dischargedAt) totalStay += p.dischargedAt - p.admittedAt;
  }

  const PHI_SQ = PHI * PHI;
  return {
    totalPatients: _state.patients.length,
    activeCases: active.length,
    criticalCases: critical.length,
    dischargedCount: discharged.length,
    bedOccupancy: getBedOccupancy(),
    avgStayMs: discharged.length > 0 ? totalStay / discharged.length : 0,
    departments: _state.departments.map(d => ({ id: d.id, name: d.name, beds: d.beds, occupied: d.occupied, status: d.status })),
    pharmacyLow: Object.keys(_state.pharmacy).filter(k => _state.pharmacy[k].stock <= _state.pharmacy[k].reorderAt),
    coherence: _state.brain.coherenceField,
    phiHealth: clamp(((_state.brain.coherenceField * PHI) + ((1 - getBedOccupancy()) * PHI_INV)) / PHI_SQ, 0, 1),
  };
}

export function getHospitalVitals(): HospitalVitals {
  return {
    heart: { ..._state.heart },
    brain: {
      regions: _state.brain.regions.map(r => ({ ...r })),
      chemicals: { ..._state.brain.chemicals },
      coherenceField: _state.brain.coherenceField,
    },
    patients: _state.patients.length,
    activeCases: _state.patients.filter(p => p.status !== 'DISCHARGED').length,
    bedOccupancy: getBedOccupancy(),
    dashboard: getHospitalDashboard(),
  };
}

export function getHospitalSummary(): HospitalSummary {
  return {
    departments: _state.departments.length,
    treatments: _state.treatments.length,
    patients: _state.patients.length,
    activeCases: _state.patients.filter(p => p.status !== 'DISCHARGED').length,
    vitals: getHospitalVitals(),
  };
}

export function getDepartments(): Department[] {
  return _state.departments.map(d => ({ ...d }));
}

export function getTreatments(): Treatment[] {
  return _state.treatments.map(t => ({ ...t }));
}

export function getPatients(): Patient[] {
  return _state.patients.map(p => ({ ...p, vitals: { ...p.vitals }, history: [...p.history] }));
}

export function getPharmacy(): Record<string, PharmacyItem> {
  const copy: Record<string, PharmacyItem> = {};
  for (const k of Object.keys(_state.pharmacy)) {
    copy[k] = { ..._state.pharmacy[k] };
  }
  return copy;
}
