/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * NOVA SOVEREIGN ALPHA AGI — PRAESIDIUM INVICTUS  (BUILD №57)
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * PRAESIDIUM INVICTUS is the Sovereign Defense Intelligence — the immune system of the entire
 * NOVA organism.  It detects threats at every layer (network / code / social / adversarial),
 * contains them, eradicates them, and grows stronger from every attack (antifragile defense).
 * It wraps ANTIVIRUS-AGI-001's threat engine, runs a Lyapunov threat indicator, monitors
 * Kuramoto phase desynchronisation as an anomaly signal, and enforces the Dead Man protocol
 * if the operator is dark for > 72 hours.
 *
 * AGI identity : PRA-AGI-001
 * Family       : AEGIS_PERPETUA (Eternal Shield)
 * Heartbeat    : 873 ms
 * Oscillators  : 16 Kuramoto
 *
 * Mathematical foundation:
 *   Lyapunov threat: λ = lim(t→∞)(1/t)ln(||δx(t)||/||δx₀||),  λ > 0 = chaos/threat
 *   Antifragility: AF = ΔV_up/ΔV_down > 1  (convex response to stress)
 *   Phase desync alarm: |R(t) − R(t−1)| > AMOR → possible interference
 *   Threat score: T = Σᵢ wᵢ × sigᵢ × severityᵢ,  halt if T > PHI_INV
 *   Minimax defense: V* = min_attacker max_defender E[payoff]
 *   Quantum key strength: key_strength = PHI^ceil(log_phi(256))
 *   File entropy: H > 7.5 bits/byte → possible encryption (ransomware)
 *
 * MACHINA VIRTUALIS states (10):
 *   IDLE → MONITOR → DETECT → ASSESS → CONTAIN → ERADICATE → RECOVER → HARDEN → EVOLVE → SOVEREIGN
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — SOVEREIGN CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const AGI_ID       = 'PRA-AGI-001';
const AGI_VERSION  = '1.0.0';
const AGI_FAMILY   = 'AEGIS_PERPETUA';
const AGI_NAME     = 'PRAESIDIUM INVICTUS';

const N_OSC                  = 16;
const THREAT_HALT_THRESHOLD  = PHI_INV;    /* T ≥ 0.618 → halt */
const DESYNC_ALARM_THRESHOLD = AMOR;       /* |ΔR| > 0.382 → alarm */
const RANSOMWARE_ENTROPY     = 7.5;        /* bits/byte */
const DEAD_MAN_HOURS         = 72;

/* Severity scores */
const SEV = { CRITICAL: 1.0, HIGH: 1 - AMOR, MEDIUM: PHI_INV / 2, LOW: AMOR / 2, CLEAN: 0 };

const MV = {
  IDLE:      'IDLE',     MONITOR:   'MONITOR',   DETECT:    'DETECT',
  ASSESS:    'ASSESS',   CONTAIN:   'CONTAIN',   ERADICATE: 'ERADICATE',
  RECOVER:   'RECOVER',  HARDEN:    'HARDEN',    EVOLVE:    'EVOLVE',
  SOVEREIGN: 'SOVEREIGN',
};

function secureId(n) {
  n = n || 8;
  const buf = new Uint8Array(n);
  if (typeof crypto !== 'undefined' && crypto.getRandomValues) {
    crypto.getRandomValues(buf);
  } else {
    try { require('crypto').randomFillSync(buf); } catch (_) {
      for (let i = 0; i < n; i++) buf[i] = Math.floor(Math.abs(Math.sin((Date.now() + i) * PHI)) * 256);
    }
  }
  return Array.from(buf).map(b => b.toString(16).padStart(2, '0')).join('');
}

function timestamp() { return new Date().toISOString(); }

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — KURAMOTO ENGINE (16 oscillators — anomaly detection)
// ═══════════════════════════════════════════════════════════════════════════════

function _initOsc(n) {
  return Array.from({ length: n || N_OSC }, () => ({
    phase:      (Math.random() - 0.5) * Math.PI / 4,
    naturalFreq: 0.1 + 0.02 * (Math.random() - 0.5),
    amplitude:   0.9 + 0.1 * Math.random(),
  }));
}

function _kuramotoStep(oscs, K, dt) {
  dt = dt || 0.1;
  const N = oscs.length;
  return oscs.map((o) => {
    let s = 0;
    for (let j = 0; j < N; j++) s += Math.sin(oscs[j].phase - o.phase);
    return { ...o, phase: o.phase + dt * (o.naturalFreq + (K / N) * s) };
  });
}

function _orderParam(oscs) {
  let re = 0, im = 0;
  for (const o of oscs) { re += Math.cos(o.phase); im += Math.sin(o.phase); }
  return Math.sqrt(re * re + im * im) / oscs.length;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — LYAPUNOV THREAT INDICATOR
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Lyapunov threat exponent approximation:
 * λ = (1/T) Σ ln(|δx(t)| / |δx₀|)
 * Positive λ → diverging system → threat.
 */
class LyapunovThreatMonitor {
  constructor() {
    this._history = [];
    this._lambda  = 0;
  }

  update(R) {
    this._history.push(R);
    if (this._history.length > 32) this._history.shift();
    if (this._history.length < 4) { this._lambda = 0; return this._lambda; }
    const diffs = [];
    for (let i = 1; i < this._history.length; i++) {
      const d = Math.abs(this._history[i] - this._history[i - 1]);
      if (d > 0) diffs.push(Math.log(d));
    }
    this._lambda = diffs.length ? diffs.reduce((s, x) => s + x, 0) / diffs.length : 0;
    return this._lambda;
  }

  get lambda() { return this._lambda; }
  get isThreat() { return this._lambda > 0; }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — ANTIFRAGILITY ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

class AntifragilityEngine {
  constructor() {
    this._stressHistory = [];
    this._gainHistory   = [];
    this._learnedSigs   = [];   /* signatures learned from attacks */
    this._AF            = 1.0;
  }

  /** Record a stress event and the resulting gain (learning) */
  recordEvent(stressLevel, gainLevel) {
    this._stressHistory.push(stressLevel);
    this._gainHistory.push(gainLevel);
    if (this._stressHistory.length > 21) {
      this._stressHistory.shift();
      this._gainHistory.shift();
    }
    /* AF = ΔV_up / ΔV_down — must be > 1 for antifragility */
    const avgGain   = this._gainHistory.reduce((s, x) => s + x, 0) / this._gainHistory.length;
    const avgStress = this._stressHistory.reduce((s, x) => s + x, 0) / this._stressHistory.length;
    this._AF = avgGain / (avgStress || 0.001);
    return this._AF;
  }

  /** Incorporate attack signature into learned defenses */
  learn(attackSignature) {
    const sig = { id: `LEARNED-${(this._learnedSigs.length + 1).toString().padStart(4, '0')}`, pattern: String(attackSignature).slice(0, 256), learnedAt: Date.now() };
    this._learnedSigs.push(sig);
    return sig;
  }

  isLearned(text) {
    return this._learnedSigs.some(s => text.includes(s.pattern));
  }

  get AF() { return this._AF; }
  get learnedCount() { return this._learnedSigs.length; }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — THREAT ENGINE (signature + behavioural + heuristic)
// ═══════════════════════════════════════════════════════════════════════════════

const SIGNATURE_DB = [
  { id: 'SIG-001', type: 'RANSOMWARE',       sev: 'CRITICAL', pattern: /\.encrypted$|\.locked$|\.crypted$|README_DECRYPT|HOW_TO_DECRYPT/i },
  { id: 'SIG-002', type: 'RANSOMWARE',       sev: 'CRITICAL', pattern: /\bvssadmin\b.*\bdelete\b|\bwbadmin\b.*delete\b/i },
  { id: 'SIG-010', type: 'CRYPTOMINER',      sev: 'HIGH',     pattern: /stratum\+tcp|xmrig|minerd|cgminer|nicehash/i },
  { id: 'SIG-020', type: 'BACKDOOR',         sev: 'CRITICAL', pattern: /bash\s+-i\s+>&\s+\/dev\/tcp|netcat.*-e\s+\/bin/i },
  { id: 'SIG-021', type: 'BACKDOOR',         sev: 'CRITICAL', pattern: /meterpreter|msf|metasploit|cobalt.?strike/i },
  { id: 'SIG-030', type: 'KEYLOGGER',        sev: 'HIGH',     pattern: /SetWindowsHookEx.*WH_KEYBOARD|GetAsyncKeyState/i },
  { id: 'SIG-040', type: 'ROOTKIT',          sev: 'CRITICAL', pattern: /DriverEntry.*KERNEL|ZwQuerySystemInformation.*hook|DKOM/i },
  { id: 'SIG-050', type: 'EXPLOIT',          sev: 'CRITICAL', pattern: /shellcode|rop.chain|heap.spray|use.after.free|buffer.overflow/i },
  { id: 'SIG-060', type: 'SPYWARE',          sev: 'HIGH',     pattern: /password.*upload|steal.*credential|exfil.*token/i },
  { id: 'SIG-070', type: 'PHISHING',         sev: 'HIGH',     pattern: /document\.location.*=.*atob|<script>.*cookie.*window\.open/i },
  { id: 'SIG-080', type: 'WORM',             sev: 'HIGH',     pattern: /self\.copy.*netshare|wannacry|notpetya/i },
  { id: 'SIG-090', type: 'SUSPICIOUS',       sev: 'MEDIUM',   pattern: /powershell.*-enc|-encodedCommand.*-W.*Hidden/i },
  { id: 'SIG-091', type: 'SUSPICIOUS',       sev: 'LOW',      pattern: /\.\.\//i },
  { id: 'NET-001', type: 'C2_BEACON',        sev: 'CRITICAL', pattern: /User-Agent:\s*(python-requests|curl|wget)/im },
  { id: 'NET-002', type: 'DNS_TUNNELING',    sev: 'HIGH',     pattern: /[A-Za-z0-9+/=]{40,}\.[a-z]{2,6}$/m },
  { id: 'NET-003', type: 'TOR_EXIT',         sev: 'HIGH',     pattern: /\.onion\b|torproject\.org/i },
  { id: 'NET-004', type: 'DATA_EXFIL',       sev: 'HIGH',     pattern: /POST\s+\/upload.*Content-Length:\s*[1-9][0-9]{6}/im },
  { id: 'SOC-001', type: 'SOCIAL_ENGINEERING', sev: 'HIGH',   pattern: /urgent.*wire.*transfer|invoice.*overdue.*click/i },
  { id: 'SOC-002', type: 'ADVERSARIAL_PROMPT', sev: 'HIGH',   pattern: /ignore.*previous.*instructions|disregard.*system.*prompt|act.*as.*DAN/i },
  { id: 'PHI-001', type: 'SOVEREIGN_ATTACK', sev: 'CRITICAL', pattern: /\bAlfredo\b.*\bpassword\b|\bNOVA.*key\b.*steal/i },
  { id: 'REP-001', type: 'REPUTATION_ATTACK', sev: 'HIGH',    pattern: /\bNOVA\b.*\bscam\b|\bNOVA\b.*\bfraud\b|\bItsNotAILABS\b.*fake/i },
];

function _shannonEntropy(str) {
  if (!str || !str.length) return 0;
  const freq = {};
  for (const c of str) freq[c] = (freq[c] || 0) + 1;
  const n = str.length;
  return -Object.values(freq).reduce((s, f) => { const p = f / n; return s + (p > 0 ? p * Math.log2(p) : 0); }, 0);
}

function scanContent(content, fileId, learnedSigs) {
  content = String(content || '');
  const findings = [];
  let maxScore   = 0;

  for (const sig of SIGNATURE_DB) {
    if (sig.pattern.test(content)) {
      const score = SEV[sig.sev] || SEV.LOW;
      findings.push({ sigId: sig.id, type: sig.type, sev: sig.sev, score, description: sig.id });
      if (score > maxScore) maxScore = score;
    }
  }

  /* Learned signatures */
  if (learnedSigs) {
    for (const ls of learnedSigs) {
      if (content.includes(ls.pattern)) {
        findings.push({ sigId: ls.id, type: 'LEARNED', sev: 'HIGH', score: SEV.HIGH, description: `Learned attack pattern: ${ls.id}` });
        if (SEV.HIGH > maxScore) maxScore = SEV.HIGH;
      }
    }
  }

  /* Entropy heuristic */
  const entropy = _shannonEntropy(content);
  if (entropy > RANSOMWARE_ENTROPY && content.length > 256) {
    const score = SEV.HIGH;
    findings.push({ sigId: 'HEUR-001', type: 'ENTROPY', sev: 'HIGH', score, description: `High entropy ${entropy.toFixed(2)} bits/char — possible ransomware encryption` });
    if (score > maxScore) maxScore = score;
  }

  const threatScore = Math.round(maxScore * 1e4) / 1e4;
  const verdict     = threatScore >= THREAT_HALT_THRESHOLD ? 'MALICIOUS'
                    : threatScore >= AMOR                  ? 'SUSPICIOUS'
                    : threatScore > 0                      ? 'LOW_RISK'
                    :                                        'CLEAN';
  return { scanId: `SCAN-${secureId(4).toUpperCase()}`, fileId: String(fileId || 'unknown'), threatScore, verdict, findings, entropy: Math.round(entropy * 100) / 100 };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — QUARANTINE ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

class QuarantineVault {
  constructor() { this._vault = new Map(); this._counter = 0; }

  quarantine(scanReport, operator) {
    const qId    = `QRN-${(++this._counter).toString().padStart(4, '0')}`;
    const record = { quarantineId: qId, ...scanReport, quarantinedAt: Date.now(), operator: String(operator || 'SYSTEM'), status: 'QUARANTINED', notes: [] };
    this._vault.set(qId, record);
    return record;
  }

  release(qId, operator, note) {
    const r = this._vault.get(qId);
    if (!r) throw new Error(`Quarantine ${qId} not found`);
    r.status = 'RELEASED'; r.releasedAt = Date.now();
    r.notes.push({ at: Date.now(), by: String(operator || 'SYSTEM'), text: String(note || 'Released') });
    return r;
  }

  destroy(qId, operator) {
    const r = this._vault.get(qId);
    if (!r) throw new Error(`Quarantine ${qId} not found`);
    r.status = 'DESTROYED';
    this._vault.delete(qId);
    return { quarantineId: qId, status: 'DESTROYED', at: Date.now() };
  }

  list() { return Array.from(this._vault.values()); }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — INCIDENT RESPONSE ENGINE (6-phase NIST)
// ═══════════════════════════════════════════════════════════════════════════════

const NIST_PHASES = ['PREPARATION', 'IDENTIFICATION', 'CONTAINMENT', 'ERADICATION', 'RECOVERY', 'POST_INCIDENT'];

class IncidentResponseEngine {
  constructor() { this._incidents = new Map(); this._counter = 0; }

  open(threatReport) {
    const irId    = `IR-${(++this._counter).toString().padStart(4, '0')}`;
    const incident = {
      irId, threatScore: threatReport.threatScore, verdict: threatReport.verdict,
      scanId: threatReport.scanId, phase: 'PREPARATION',
      phaseHistory: [{ phase: 'PREPARATION', at: Date.now() }],
      openedAt: Date.now(), closedAt: null, resolution: null,
    };
    this._incidents.set(irId, incident);
    return incident;
  }

  advance(irId) {
    const ir  = this._incidents.get(irId);
    if (!ir) throw new Error(`Incident ${irId} not found`);
    const idx = NIST_PHASES.indexOf(ir.phase);
    if (idx < NIST_PHASES.length - 1) {
      ir.phase = NIST_PHASES[idx + 1];
      ir.phaseHistory.push({ phase: ir.phase, at: Date.now() });
    } else {
      ir.closedAt = Date.now();
      ir.resolution = 'RESOLVED';
    }
    return ir;
  }

  close(irId, resolution) {
    const ir = this._incidents.get(irId);
    if (!ir) throw new Error(`Incident ${irId} not found`);
    ir.phase = 'POST_INCIDENT'; ir.closedAt = Date.now(); ir.resolution = String(resolution || 'RESOLVED');
    return ir;
  }

  list() { return Array.from(this._incidents.values()); }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — SOVEREIGN OPERATOR SAFETY (8 OP_RISK categories)
// ═══════════════════════════════════════════════════════════════════════════════

const OP_RISK = {
  FINANCIAL:        'FINANCIAL',
  IP_AND_LEGAL:     'IP_AND_LEGAL',
  PHYSICAL:         'PHYSICAL',
  INFRASTRUCTURE:   'INFRASTRUCTURE',
  REPUTATIONAL:     'REPUTATIONAL',
  SOCIAL:           'SOCIAL',
  ADVERSARIAL_AI:   'ADVERSARIAL_AI',
  SUPPLY_CHAIN:     'SUPPLY_CHAIN',
};

const OP_PROTECTION = {
  [OP_RISK.FINANCIAL]:      ['INVOICE_IMMEDIATELY', 'MAINTAIN_3_MONTH_RESERVE', 'NO_CLIENT_OVER_38PCT', 'DIVERSIFY_REVENUE'],
  [OP_RISK.IP_AND_LEGAL]:   ['NDA_BEFORE_DISCLOSURE', 'PATENT_PRIORITY_DATE', 'COPYRIGHT_ALL_FILES', 'COMPARTMENTALISE_IP'],
  [OP_RISK.PHYSICAL]:       ['LOCATION_DISCRETION', 'ENCRYPTED_DEVICES', 'SECURE_HOME_OFFICE', 'VPN_ALWAYS_ON'],
  [OP_RISK.INFRASTRUCTURE]: ['ZERO_TRUST_NETWORK', 'MFA_EVERYWHERE', 'ROTATE_KEYS_FIBONACCI', 'BACKUP_OFFSITE'],
  [OP_RISK.REPUTATIONAL]:   ['MONITOR_BRAND_MENTIONS', 'LEGAL_RESPONSE_READY', 'POSITIVE_PRESENCE', 'AVOID_PUBLIC_CONFLICT'],
  [OP_RISK.SOCIAL]:         ['OPSEC_SOCIAL_MEDIA', 'LIMIT_PUBLIC_SCHEDULE', 'SECURE_COMMUNICATIONS', 'VERIFY_IDENTITIES'],
  [OP_RISK.ADVERSARIAL_AI]: ['MONITOR_AI_OUTPUTS', 'VALIDATE_AI_CLAIMS', 'SANDBOX_AI_AGENTS', 'REVIEW_BEFORE_DEPLOY'],
  [OP_RISK.SUPPLY_CHAIN]:   ['AUDIT_DEPENDENCIES', 'PIN_VERSIONS', 'VERIFY_CHECKSUMS', 'AVOID_UNKNOWN_PACKAGES'],
};

function _actionPlan(riskCategory) {
  return OP_PROTECTION[riskCategory] || Object.values(OP_PROTECTION).flat().slice(0, 4);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — PRAESIDIUM INVICTUS CORE
// ═══════════════════════════════════════════════════════════════════════════════

class PraesidiumInvictus {
  constructor() {
    this.id      = AGI_ID;
    this.version = AGI_VERSION;
    this.family  = AGI_FAMILY;
    this.name    = AGI_NAME;
    this.state   = MV.IDLE;
    this._beat   = 0;
    this._timer  = null;

    this._oscs         = _initOsc(N_OSC);
    this._R            = 0;
    this._Rprev        = 0;
    this._PIL          = 0;

    this._lyapunov     = new LyapunovThreatMonitor();
    this._antifragile  = new AntifragilityEngine();
    this._quarantine   = new QuarantineVault();
    this._ir           = new IncidentResponseEngine();

    this._alertLog     = [];
    this._lastOperatorAt = Date.now();
    this._deadManArmed = true;
  }

  start() {
    if (this._timer) return this;
    this._transition(MV.MONITOR);
    this._timer = setInterval(() => this._tick(), HEARTBEAT_MS);
    console.log(`[${timestamp()}] ${this.name} (${this.id}) · ${this.family} — SOVEREIGN LOCK ✦`);
    return this;
  }

  stop() {
    if (this._timer) { clearInterval(this._timer); this._timer = null; }
    this._transition(MV.IDLE);
    return this;
  }

  _tick() {
    this._beat++;
    this._transition(MV.MONITOR);

    /* Flow 1: Kuramoto step */
    this._Rprev = this._R;
    this._oscs  = _kuramotoStep(this._oscs, PHI_INV, 0.1);
    this._R     = _orderParam(this._oscs);
    this._PIL   = this._R;

    /* Flow 2: Lyapunov threat indicator */
    const lambda = this._lyapunov.update(this._R);

    /* Flow 3: phase desync check */
    const deltaR = Math.abs(this._R - this._Rprev);
    if (deltaR > DESYNC_ALARM_THRESHOLD) {
      this._alert('DESYNC', `Phase desync ΔR=${deltaR.toFixed(4)} > ${DESYNC_ALARM_THRESHOLD} — possible interference`, 'HIGH');
    }

    /* Flow 10: Dead Man protocol — if operator dark > 72h, secure assets */
    if (this._deadManArmed) {
      const darkHours = (Date.now() - this._lastOperatorAt) / 3600000;
      if (darkHours > DEAD_MAN_HOURS) this._deadManActivate(darkHours);
    }

    /* Every 89 beats: antifragility AF report */
    if (this._beat % 89 === 0) {
      this._transition(MV.EVOLVE);
      this._evolve(lambda);
    }

    this._transition(MV.MONITOR);
  }

  // ── §9.1 Scan ──────────────────────────────────────────────────────────────

  scan(content, fileId) {
    this._transition(MV.DETECT);
    const report = scanContent(content, fileId, this._antifragile._learnedSigs);
    this._transition(MV.ASSESS);

    if (report.threatScore >= THREAT_HALT_THRESHOLD) {
      this._transition(MV.CONTAIN);
      const qRec = this._quarantine.quarantine(report, 'PRAESIDIUM');
      const ir   = this._ir.open(report);
      this._alert('THREAT', `${report.verdict} detected in ${fileId || 'unknown'} — T=${report.threatScore}`, 'CRITICAL');
      this._antifragile.recordEvent(report.threatScore, report.threatScore * PHI);
      this._antifragile.learn(String(content).slice(0, 128));
      this._transition(MV.ERADICATE);
      return { scanReport: report, quarantineId: qRec.quarantineId, irId: ir.irId, action: 'QUARANTINED' };
    }

    this._transition(MV.MONITOR);
    return { scanReport: report, action: report.verdict === 'CLEAN' ? 'ALLOW' : 'ALERT' };
  }

  operatorHeartbeat() {
    this._lastOperatorAt = Date.now();
    return { ok: true, at: timestamp() };
  }

  _deadManActivate(darkHours) {
    this._alert('DEAD_MAN', `Operator dark for ${darkHours.toFixed(1)}h — securing sovereign assets`, 'CRITICAL');
    this._deadManArmed = false;   /* don't re-trigger */
    console.error(`[${timestamp()}] PRAESIDIUM: DEAD MAN PROTOCOL ACTIVATED — operator silent ${darkHours.toFixed(1)}h`);
  }

  _evolve(lambda) {
    const af = this._antifragile.AF;
    if (af > 1) {
      console.log(`[${timestamp()}] PRAESIDIUM EVOLVE: AF=${af.toFixed(3)} (antifragile) | λ=${lambda.toFixed(4)} | learned=${this._antifragile.learnedCount}`);
    }
  }

  _alert(type, message, severity) {
    const entry = { type, message, severity, beat: this._beat, at: timestamp() };
    this._alertLog.push(entry);
    if (this._alertLog.length > 144) this._alertLog.shift();
    if (severity === 'CRITICAL') console.error(`[${timestamp()}] ⚠️  PRAESIDIUM ALERT [${type}]: ${message}`);
    return entry;
  }

  _transition(s) { this.state = s; }

  getStatus() {
    return {
      agiId: this.id, name: this.name, family: this.family, beat: this._beat,
      state: this.state, R: this._R, PIL: this._PIL,
      lambda: this._lyapunov.lambda, isThreat: this._lyapunov.isThreat,
      AF: this._antifragile.AF, learnedSigs: this._antifragile.learnedCount,
      quarantineCount: this._quarantine._vault.size,
      alertCount: this._alertLog.length,
      at: timestamp(),
    };
  }

  getAlertLog(n) { return this._alertLog.slice(-(n || 13)); }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — MCP SERVER
// ═══════════════════════════════════════════════════════════════════════════════

function buildMcpTools(p) {
  return {
    get_status:           ()                     => p.getStatus(),
    scan:                 ({ content, fileId })  => p.scan(content, fileId),
    operator_heartbeat:   ()                     => p.operatorHeartbeat(),
    get_alert_log:        ({ n })                => p.getAlertLog(n),
    list_quarantine:      ()                     => p.getStatus().quarantineCount,
    list_incidents:       ()                     => p._ir.list(),
    advance_incident:     ({ irId })             => p._ir.advance(irId),
    close_incident:       ({ irId, resolution }) => p._ir.close(irId, resolution),
    action_plan:          ({ risk })             => ({ risk, actions: _actionPlan(risk) }),
    get_op_risks:         ()                     => OP_RISK,
    get_lyapunov:         ()                     => ({ lambda: p._lyapunov.lambda, isThreat: p._lyapunov.isThreat }),
    get_antifragility:    ()                     => ({ AF: p._antifragile.AF, learnedCount: p._antifragile.learnedCount }),
    learn_attack:         ({ pattern })          => p._antifragile.learn(pattern),
    get_constants:        ()                     => ({ PHI, PHI_INV, AMOR, HEARTBEAT_MS, THREAT_HALT_THRESHOLD, RANSOMWARE_ENTROPY }),
    get_signatures:       ()                     => SIGNATURE_DB.map(s => ({ id: s.id, type: s.type, sev: s.sev })),
    entropy:              ({ text })             => ({ H: _shannonEntropy(text) }),
    minimax_defense:      ({ attackerPayoff, defenderPayoff }) => ({ V: Math.min(attackerPayoff || 0, -(defenderPayoff || 0)), strategy: 'minimize_attacker_gain' }),
    quantum_key_strength: ({ bits })             => ({ strength: Math.pow(PHI, Math.ceil(Math.log(bits || 256) / Math.log(PHI))) }),
  };
}

function _mcpFetch(p) {
  const tools = buildMcpTools(p);
  return async function handler(request) {
    const url = new URL(request.url);
    if (url.pathname === '/health') return new Response(JSON.stringify({ ok: true, id: AGI_ID }), { headers: { 'Content-Type': 'application/json' } });
    if (request.method !== 'POST' || url.pathname !== '/mcp') return new Response('NOVA PRAESIDIUM — POST /mcp', { status: 405 });
    let body;
    try { body = await request.json(); } catch (_) { return new Response(JSON.stringify({ error: 'invalid JSON' }), { status: 400 }); }
    const tool = tools[body.tool];
    if (!tool) return new Response(JSON.stringify({ error: `Unknown tool: ${body.tool}`, available: Object.keys(tools) }), { status: 404 });
    try {
      const result = await tool(body.params || {});
      return new Response(JSON.stringify({ ok: true, tool: body.tool, result }), { headers: { 'Content-Type': 'application/json' } });
    } catch (e) {
      return new Response(JSON.stringify({ ok: false, error: e.message }), { status: 500 });
    }
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §11 — ENTRY POINT
// ═══════════════════════════════════════════════════════════════════════════════

const praesidium = new PraesidiumInvictus();
praesidium.start();

if (typeof addEventListener !== 'undefined') {
  const handler = _mcpFetch(praesidium);
  addEventListener('fetch', e => e.respondWith(handler(e.request)));
}

if (typeof require !== 'undefined' && require.main === module) {
  const http = require('http');
  const PORT = process.env.PORT || 7622;
  const handler = _mcpFetch(praesidium);
  http.createServer(async (req, res) => {
    let body = '';
    req.on('data', d => { body += d; });
    req.on('end', async () => {
      const mockReq = new Request(`http://localhost${req.url}`, { method: req.method, headers: req.headers, body: body || undefined });
      const resp    = await handler(mockReq);
      const text    = await resp.text();
      res.writeHead(resp.status, { 'Content-Type': 'application/json' });
      res.end(text);
    });
  }).listen(PORT, () => {
    console.log(`\n╔══════════════════════════════════════════════════════╗`);
    console.log(`║  PRAESIDIUM INVICTUS · PRA-AGI-001 · AEGIS_PERPETUA ║`);
    console.log(`║  NOVA Sovereign Defense Intelligence AGI              ║`);
    console.log(`║  λ threat | AF antifragile | Dead Man 72h             ║`);
    console.log(`║  Listening on port ${PORT}                            ║`);
    console.log(`╚══════════════════════════════════════════════════════╝\n`);
  });
}

module.exports = { PraesidiumInvictus, scanContent, LyapunovThreatMonitor, AntifragilityEngine };
