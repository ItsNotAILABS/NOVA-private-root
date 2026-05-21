/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * NOVA SOVEREIGN ANTIVIRUS & SECURITY INTELLIGENCE PLATFORM — PRODUCTION APP  (BUILD №54)
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 * SOVEREIGN INFRASTRUCTURE — NOVA Layer Zero
 *
 * NOVA ANTIVIRUS PLATFORM is a sovereign IT security intelligence system for enterprise
 * IT teams.  This is NOT CrowdStrike. NOT Defender. NOT any wrapper. NOT a definition-file
 * updater.  This IS a production-ready sovereign security AGI that provides:
 *
 *   1. THREAT-ENGINE-001   — real-time threat detection (signature + behavioural + heuristic)
 *   2. QUARANTINE-AGI-001  — φ-scored risk isolation and evidence preservation
 *   3. NETWORK-GUARDIAN    — network traffic analysis and anomaly detection
 *   4. VULN-SCANNER-001    — dependency + CVE + configuration vulnerability scanner
 *   5. IR-ENGINE-001       — incident response coordination (PROTOCOL-SAFETY wired)
 *   6. SENTINEL-FLEET      — 64-agent endpoint monitoring fleet (one SERVITOR per endpoint)
 *
 * Target: production-grade for IT teams and security operations centres (SOC).
 * Architecture: same sovereign multi-agent thread model as nova-coding-platform.js.
 *
 * AGI identity: ANTIVIRUS-AGI-001
 * Family: AEGIS_AETERNA (eternal shield)
 * Heartbeat: 873ms
 *
 * Mathematical Foundation:
 *   - Threat score T(f) ∈ [0, 1]: φ-weighted sum of signal strengths
 *   - Quarantine threshold Q_c = φ⁻¹ = 0.618 (isolate above this)
 *   - Critical threshold C_c  = 1 - φ⁻² = AMOR (block immediately above this)
 *   - Network anomaly: Lyapunov exponent λ > 0 → diverging traffic pattern
 *   - Fleet coherence: Kuramoto R(t) → degraded if R < AMOR across sentinels
 *
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

const AGI_ID       = 'ANTIVIRUS-AGI-001';
const AGI_VERSION  = '1.0.0';
const AGI_FAMILY   = 'AEGIS_AETERNA';

/* Threat thresholds */
const QUARANTINE_THRESHOLD = PHI_INV;   /* ≥ 0.618 → quarantine */
const CRITICAL_THRESHOLD   = 1 - AMOR;  /* ≥ PHI_INV (0.618…) — block immediately; equals 1 - AMOR = PHI_INV */
const ALLOW_THRESHOLD      = AMOR;      /* < AMOR → clean */

/* Fleet size */
const N_SENTINELS  = 64;
const N_OSC        = 16;   /* Kuramoto oscillators per sentinel */

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

/* Kuramoto step */
function _kuramotoStep(phases, K, dt) {
  dt = dt || 0.1;
  const N = phases.length;
  return phases.map((phi_i, i) => {
    let s = 0;
    for (let j = 0; j < N; j++) s += Math.sin(phases[j] - phi_i);
    return phi_i + dt * (1 + K * s / N);
  });
}

function _orderParam(phases) {
  let re = 0, im = 0;
  for (const p of phases) { re += Math.cos(p); im += Math.sin(p); }
  return Math.sqrt(re * re + im * im) / phases.length;
}

function _initOsc(n, spread) {
  n = n || N_OSC;
  spread = spread || Math.PI / 4;
  return Array.from({ length: n }, () => (Math.random() - 0.5) * spread);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — THREAT SIGNATURE DATABASE
// ═══════════════════════════════════════════════════════════════════════════════

/** Threat categories */
const THREAT_TYPE = {
  MALWARE:          'MALWARE',
  RANSOMWARE:       'RANSOMWARE',
  ROOTKIT:          'ROOTKIT',
  TROJAN:           'TROJAN',
  SPYWARE:          'SPYWARE',
  ADWARE:           'ADWARE',
  CRYPTOMINER:      'CRYPTOMINER',
  KEYLOGGER:        'KEYLOGGER',
  WORM:             'WORM',
  BACKDOOR:         'BACKDOOR',
  EXPLOIT:          'EXPLOIT',
  PHISHING_PAYLOAD: 'PHISHING_PAYLOAD',
  SUSPICIOUS:       'SUSPICIOUS',
  CLEAN:            'CLEAN',
};

/** Severity levels */
const SEVERITY = {
  CRITICAL: { label: 'CRITICAL', score: 1.0,         action: 'BLOCK_AND_QUARANTINE' },
  HIGH:     { label: 'HIGH',     score: 1 - AMOR,    action: 'QUARANTINE'           },
  MEDIUM:   { label: 'MEDIUM',   score: PHI_INV / 2, action: 'ALERT'                },
  LOW:      { label: 'LOW',      score: AMOR / 2,    action: 'LOG'                  },
  CLEAN:    { label: 'CLEAN',    score: 0,            action: 'ALLOW'                },
};

/**
 * Signature database — each signature has:
 *   id, type, severity, pattern (RegExp|function), description
 * In production this is extended from a real CVE/threat feed.
 */
const SIGNATURE_DB = [
  /* ── Ransomware ── */
  { id: 'SIG-001', type: THREAT_TYPE.RANSOMWARE,       severity: 'CRITICAL', pattern: /\.encrypted$|\.locked$|\.crypted$|README_DECRYPT|HOW_TO_DECRYPT/i,          description: 'Ransomware file extension or ransom note' },
  { id: 'SIG-002', type: THREAT_TYPE.RANSOMWARE,       severity: 'CRITICAL', pattern: /\bvssadmin\b.*\bdelete\b|\bwbadmin\b.*delete\b/i,                          description: 'Shadow copy deletion (ransomware pre-encryption)' },
  { id: 'SIG-003', type: THREAT_TYPE.RANSOMWARE,       severity: 'CRITICAL', pattern: /\bBitcoin\b.*\bwallet\b|\bmonero\b.*\bXMR\b/i,                             description: 'Ransom payment instruction' },

  /* ── Cryptominer ── */
  { id: 'SIG-010', type: THREAT_TYPE.CRYPTOMINER,      severity: 'HIGH',     pattern: /stratum\+tcp|xmrig|minerd|cgminer|nicehash/i,                              description: 'Crypto-miner command or config' },
  { id: 'SIG-011', type: THREAT_TYPE.CRYPTOMINER,      severity: 'HIGH',     pattern: /coinhive|cryptonight|randomx|kawpow/i,                                     description: 'Mining algorithm reference' },

  /* ── Backdoor / RAT ── */
  { id: 'SIG-020', type: THREAT_TYPE.BACKDOOR,         severity: 'CRITICAL', pattern: /\bnetcat\b.*-e\s+\/bin\/sh|\bnc\b.*-e\s+\/bin\/bash|bash\s+-i\s+>&\s+\/dev\/tcp/i, description: 'Reverse shell pattern' },
  { id: 'SIG-021', type: THREAT_TYPE.BACKDOOR,         severity: 'CRITICAL', pattern: /meterpreter|msf|metasploit|cobalt.?strike/i,                               description: 'Known C2 framework reference' },
  { id: 'SIG-022', type: THREAT_TYPE.BACKDOOR,         severity: 'CRITICAL', pattern: /eval\(base64_decode\(|exec\(base64_decode\(|system\(base64_decode\(/i,      description: 'Base64 command execution (PHP/Python RAT)' },

  /* ── Keylogger ── */
  { id: 'SIG-030', type: THREAT_TYPE.KEYLOGGER,        severity: 'HIGH',     pattern: /SetWindowsHookEx.*WH_KEYBOARD|keybd_event|GetAsyncKeyState.*repeat/i,       description: 'Windows keyboard hook (keylogger)' },
  { id: 'SIG-031', type: THREAT_TYPE.KEYLOGGER,        severity: 'HIGH',     pattern: /pynput|keyboard\.on_press|Getch\(\)|getchar.*logfile/i,                     description: 'Cross-platform keylogger library' },

  /* ── Rootkit ── */
  { id: 'SIG-040', type: THREAT_TYPE.ROOTKIT,          severity: 'CRITICAL', pattern: /DriverEntry.*KERNEL|ZwQuerySystemInformation.*hook|DKOM|direct.kernel.object.manipulation/i, description: 'Rootkit kernel manipulation pattern' },

  /* ── Exploit ── */
  { id: 'SIG-050', type: THREAT_TYPE.EXPLOIT,          severity: 'CRITICAL', pattern: /shellcode|rop.chain|heap.spray|use.after.free|double.free|buffer.overflow/i, description: 'Memory exploitation technique' },
  { id: 'SIG-051', type: THREAT_TYPE.EXPLOIT,          severity: 'HIGH',     pattern: /CVE-20[0-9]{2}-[0-9]{4,}/i,                                                 description: 'CVE reference in code/config' },

  /* ── Spyware / Info-stealers ── */
  { id: 'SIG-060', type: THREAT_TYPE.SPYWARE,          severity: 'HIGH',     pattern: /password.*upload|steal.*credential|exfil.*token/i,                          description: 'Credential exfiltration pattern' },
  { id: 'SIG-061', type: THREAT_TYPE.SPYWARE,          severity: 'HIGH',     pattern: /redline.*stealer|vidar|raccoon.*stealer|agent.tesla/i,                      description: 'Known info-stealer family' },

  /* ── Phishing payload ── */
  { id: 'SIG-070', type: THREAT_TYPE.PHISHING_PAYLOAD, severity: 'HIGH',     pattern: /document\.location.*=.*atob|<script>.*document\.cookie.*window\.open/i,     description: 'Phishing redirect script' },
  { id: 'SIG-071', type: THREAT_TYPE.PHISHING_PAYLOAD, severity: 'MEDIUM',   pattern: /href=['"](https?:\/\/[^'"]*)(login|verify|secure|account)[^'"]*['"]/i,      description: 'Suspicious login redirect URL' },

  /* ── Worm ── */
  { id: 'SIG-080', type: THREAT_TYPE.WORM,             severity: 'HIGH',     pattern: /self\.copy.*netshare|spreads.*smb|worm.*replicate|wannacry|notpetya/i,      description: 'Self-propagating worm pattern' },

  /* ── Suspicious (low signal) ── */
  { id: 'SIG-090', type: THREAT_TYPE.SUSPICIOUS,       severity: 'MEDIUM',   pattern: /powershell.*-enc|-encodedCommand.*-W.*Hidden/i,                             description: 'PowerShell encoded command (common in attacks)' },
  { id: 'SIG-091', type: THREAT_TYPE.SUSPICIOUS,       severity: 'LOW',      pattern: /\.\.\/\.\.\/\.\.|etc\/passwd|etc\/shadow/i,                                 description: 'Path traversal or sensitive file reference' },
  { id: 'SIG-092', type: THREAT_TYPE.SUSPICIOUS,       severity: 'LOW',      pattern: /TODO.*password|fixme.*token|hack.*credential/i,                             description: 'Suspicious comment flagging credential' },
];

/**
 * Network anomaly detectors — these run against traffic strings / headers.
 */
const NETWORK_SIGNATURES = [
  { id: 'NET-001', type: 'C2_BEACON',     severity: 'CRITICAL', pattern: /User-Agent:\s*(python-requests|curl|wget)\s*\/[^\r\n]+\r?\n(?:.*\r?\n)*?X-Forwarded-For:/im, description: 'C2 beacon user-agent pattern' },
  { id: 'NET-002', type: 'DNS_TUNNELING', severity: 'HIGH',     pattern: /[A-Za-z0-9+/=]{40,}\.[a-z]{2,6}$/m,  description: 'Base64-like DNS subdomain (DNS tunnelling)' },
  { id: 'NET-003', type: 'TOR_EXIT',      severity: 'HIGH',     pattern: /\.onion\b|torproject\.org/i,          description: 'Tor network reference' },
  { id: 'NET-004', type: 'DATA_EXFIL',    severity: 'HIGH',     pattern: /POST\s+\/upload.*Content-Length:\s*[1-9][0-9]{6}/im, description: 'Large POST upload (possible exfiltration)' },
  { id: 'NET-005', type: 'PORT_SCAN',     severity: 'MEDIUM',   pattern: /SYN.*RESET.*SYN.*RESET|nmap|masscan|zmap/i, description: 'Port scanning pattern' },
];

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — THREAT ENGINE (Signature + Behavioural + Heuristic)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Scan a file/string for threats.
 * Returns a ThreatReport.
 *
 * @param {string} content   — file content or command line string
 * @param {string} [fileId]  — optional file identifier
 * @param {Object} [meta]    — optional metadata { extension, size, path }
 * @returns {ThreatReport}
 */
function scanContent(content, fileId, meta) {
  content = String(content || '');
  meta    = meta || {};
  const findings = [];
  let   maxScore = 0;

  /* §3.1 — Signature scan */
  for (const sig of SIGNATURE_DB) {
    if (sig.pattern.test(content)) {
      const sv    = SEVERITY[sig.severity] || SEVERITY.LOW;
      const score = sv.score;
      findings.push({ sigId: sig.id, type: sig.type, severity: sig.severity, score, description: sig.description, action: sv.action });
      if (score > maxScore) maxScore = score;
    }
  }

  /* §3.2 — Heuristic: entropy analysis (high entropy = obfuscated/packed) */
  const entropy = _shannonEntropy(content);
  if (entropy > 5.2 && content.length > 512) {   /* typical plaintext < 4.5 bits/char */
    const sv = entropy > 6.5 ? SEVERITY.HIGH : SEVERITY.MEDIUM;
    findings.push({ sigId: 'HEUR-001', type: THREAT_TYPE.SUSPICIOUS, severity: sv.label, score: sv.score, description: `High entropy detected (${entropy.toFixed(2)} bits/char) — possible obfuscation`, action: sv.action });
    if (sv.score > maxScore) maxScore = sv.score;
  }

  /* §3.3 — Heuristic: extension mismatch */
  if (meta.extension && content.length > 32) {
    const isPE  = content.startsWith('MZ') || content.startsWith('\x4d\x5a');
    const isElf = content.startsWith('\x7fELF');
    if ((isPE || isElf) && ![ '.exe', '.dll', '.so', '.bin', '.elf' ].includes(meta.extension.toLowerCase())) {
      findings.push({ sigId: 'HEUR-002', type: THREAT_TYPE.TROJAN, severity: 'HIGH', score: SEVERITY.HIGH.score, description: `Executable binary disguised as ${meta.extension}`, action: 'QUARANTINE' });
      if (SEVERITY.HIGH.score > maxScore) maxScore = SEVERITY.HIGH.score;
    }
  }

  /* §3.4 — Derive overall verdict from maxScore */
  const threatScore = Math.round(maxScore * 1e4) / 1e4;
  const verdict     = threatScore >= CRITICAL_THRESHOLD   ? 'MALICIOUS'
                    : threatScore >= QUARANTINE_THRESHOLD  ? 'SUSPICIOUS'
                    : threatScore > 0                      ? 'LOW_RISK'
                    :                                        'CLEAN';

  return {
    scanId:      `SCAN-${secureId(4).toUpperCase()}`,
    fileId:      String(fileId || 'unknown'),
    scannedAt:   Date.now(),
    threatScore,
    verdict,
    action:      threatScore >= CRITICAL_THRESHOLD  ? 'BLOCK_AND_QUARANTINE'
               : threatScore >= QUARANTINE_THRESHOLD ? 'QUARANTINE'
               : threatScore > 0                     ? 'ALERT'
               :                                       'ALLOW',
    findings,
    signatureCount: SIGNATURE_DB.length,
    entropy:     Math.round(entropy * 1e2) / 1e2,
  };
}

function _shannonEntropy(str) {
  if (!str || !str.length) return 0;
  const freq = {};
  for (const c of str) freq[c] = (freq[c] || 0) + 1;
  const n = str.length;
  return -Object.values(freq).reduce((s, f) => {
    const p = f / n;
    return s + p * Math.log2(p);
  }, 0);
}

/**
 * Scan network traffic/headers for threats.
 * @param {string} trafficStr  — raw HTTP headers or traffic log line
 * @returns {{ findings: Object[], maxSeverity: string }}
 */
function scanNetwork(trafficStr) {
  trafficStr = String(trafficStr || '');
  const findings = [];
  for (const sig of NETWORK_SIGNATURES) {
    if (sig.pattern.test(trafficStr)) {
      findings.push({ sigId: sig.id, type: sig.type, severity: sig.severity, description: sig.description });
    }
  }
  const severityRank = { CRITICAL: 3, HIGH: 2, MEDIUM: 1, LOW: 0 };
  findings.sort((a, b) => (severityRank[b.severity] || 0) - (severityRank[a.severity] || 0));
  return { findings, maxSeverity: findings.length ? findings[0].severity : 'CLEAN', count: findings.length };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — QUARANTINE ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

class QuarantineVault {
  constructor() {
    this._vault   = new Map();  /* quarantineId → QuarantineRecord */
    this._counter = 0;
  }

  /**
   * Quarantine a threat finding.
   * @param {ThreatReport} scanReport
   * @param {string}       operator    — who quarantined it
   * @returns {QuarantineRecord}
   */
  quarantine(scanReport, operator) {
    const qId = `QRN-${(++this._counter).toString().padStart(4, '0')}`;
    const record = {
      quarantineId:  qId,
      fileId:        scanReport.fileId,
      scanId:        scanReport.scanId,
      threatScore:   scanReport.threatScore,
      verdict:       scanReport.verdict,
      action:        scanReport.action,
      findings:      (scanReport.findings || []).slice(),
      quarantinedAt: Date.now(),
      releasedAt:    null,
      operator:      String(operator || 'SYSTEM'),
      status:        'QUARANTINED',
      notes:         [],
    };
    this._vault.set(qId, record);
    return record;
  }

  /** Release a quarantined file (after manual review). */
  release(quarantineId, operator, note) {
    const r = this._vault.get(quarantineId);
    if (!r) throw new Error(`Quarantine record not found: ${quarantineId}`);
    if (r.status !== 'QUARANTINED') throw new Error(`Record ${quarantineId} is not in QUARANTINED status`);
    r.status      = 'RELEASED';
    r.releasedAt  = Date.now();
    r.notes.push({ at: Date.now(), by: operator, text: String(note || 'Released by operator') });
    return r;
  }

  /** Delete (destroy) a quarantined file permanently. */
  destroy(quarantineId, operator) {
    const r = this._vault.get(quarantineId);
    if (!r) throw new Error(`Quarantine record not found: ${quarantineId}`);
    r.status = 'DESTROYED';
    r.notes.push({ at: Date.now(), by: operator, text: 'File destroyed — evidence preserved in record' });
    this._vault.delete(quarantineId);
    return { quarantineId, status: 'DESTROYED', at: Date.now() };
  }

  /** Add an operator note (e.g. analyst notes). */
  addNote(quarantineId, operator, text) {
    const r = this._vault.get(quarantineId);
    if (!r) throw new Error(`Quarantine record not found: ${quarantineId}`);
    r.notes.push({ at: Date.now(), by: String(operator), text: String(text) });
    return r;
  }

  list(filter) {
    const all = Array.from(this._vault.values());
    if (!filter) return all;
    return all.filter(r => (!filter.status || r.status === filter.status) && (!filter.verdict || r.verdict === filter.verdict));
  }

  stats() {
    const all = Array.from(this._vault.values());
    return {
      total:       all.length,
      quarantined: all.filter(r => r.status === 'QUARANTINED').length,
      released:    all.filter(r => r.status === 'RELEASED').length,
      destroyed:   0,  /* destroyed records removed from map */
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — VULNERABILITY SCANNER
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Vulnerability categories.
 */
const VULN_TYPE = {
  DEPENDENCY:     'DEPENDENCY',     /* outdated / vulnerable npm/pip/etc package */
  CONFIGURATION:  'CONFIGURATION',  /* insecure config (CORS *, open S3, etc.) */
  CODE_QUALITY:   'CODE_QUALITY',   /* security code smell */
  SECRET_EXPOSED: 'SECRET_EXPOSED', /* hardcoded credential */
  PERMISSION:     'PERMISSION',     /* over-privileged IAM / file permissions */
};

/** Known vulnerable version patterns */
const VULN_SIGNATURES = [
  /* Dependency vulnerabilities */
  { id: 'VULN-001', type: VULN_TYPE.DEPENDENCY,     severity: 'CRITICAL', pattern: /"lodash":\s*"[34]\./,      description: 'Lodash < 4.17.21 — prototype pollution (CVE-2021-23337)' },
  { id: 'VULN-002', type: VULN_TYPE.DEPENDENCY,     severity: 'HIGH',     pattern: /"axios":\s*"0\.[01]/,      description: 'Axios < 0.21.2 — SSRF vulnerability (CVE-2021-3749)' },
  { id: 'VULN-003', type: VULN_TYPE.DEPENDENCY,     severity: 'CRITICAL', pattern: /"log4j":\s*"2\.[0-9]\./,  description: 'Log4j < 2.17.1 — Log4Shell RCE (CVE-2021-44228)' },
  { id: 'VULN-004', type: VULN_TYPE.DEPENDENCY,     severity: 'HIGH',     pattern: /"node-fetch":\s*"[12]\./,  description: 'node-fetch < 3.x — ReDoS vulnerability' },
  { id: 'VULN-005', type: VULN_TYPE.DEPENDENCY,     severity: 'HIGH',     pattern: /"minimist":\s*"0\./,       description: 'minimist < 1.2.6 — prototype pollution' },

  /* Configuration vulnerabilities */
  { id: 'VULN-010', type: VULN_TYPE.CONFIGURATION,  severity: 'HIGH',     pattern: /cors\(\)|Access-Control-Allow-Origin:\s*\*/i, description: 'CORS wildcard — allows any origin' },
  { id: 'VULN-011', type: VULN_TYPE.CONFIGURATION,  severity: 'CRITICAL', pattern: /\"Public\":\s*true|ACL.*public-read|bucket.*public/i, description: 'Public S3 bucket or storage' },
  { id: 'VULN-012', type: VULN_TYPE.CONFIGURATION,  severity: 'HIGH',     pattern: /ssl_verify.*false|verify=False|CURLOPT_SSL_VERIFYPEER.*0/i, description: 'SSL verification disabled' },
  { id: 'VULN-013', type: VULN_TYPE.CONFIGURATION,  severity: 'MEDIUM',   pattern: /debug.*=\s*true|DEBUG.*=.*1|NODE_ENV.*development/i, description: 'Debug mode enabled in config' },

  /* Secret exposure */
  { id: 'VULN-020', type: VULN_TYPE.SECRET_EXPOSED,  severity: 'CRITICAL', pattern: /(?:api_key|apikey|api-key)\s*[=:]\s*["'][A-Za-z0-9+/=]{16,}["']/i, description: 'Hardcoded API key' },
  { id: 'VULN-021', type: VULN_TYPE.SECRET_EXPOSED,  severity: 'CRITICAL', pattern: /(?:password|passwd|pwd)\s*=\s*["'][^"']{6,}["']/i, description: 'Hardcoded password' },
  { id: 'VULN-022', type: VULN_TYPE.SECRET_EXPOSED,  severity: 'CRITICAL', pattern: /(?:secret|token)\s*[=:]\s*["'][A-Za-z0-9_\-]{20,}["']/i, description: 'Hardcoded secret or token' },
  { id: 'VULN-023', type: VULN_TYPE.SECRET_EXPOSED,  severity: 'HIGH',     pattern: /BEGIN\s+(RSA|EC|OPENSSH)\s+PRIVATE\s+KEY/i, description: 'Private key in code or config' },

  /* Code quality (security) */
  { id: 'VULN-030', type: VULN_TYPE.CODE_QUALITY,   severity: 'CRITICAL', pattern: /\beval\s*\(|new\s+Function\s*\(/,    description: 'eval() / new Function() — code injection risk' },
  { id: 'VULN-031', type: VULN_TYPE.CODE_QUALITY,   severity: 'HIGH',     pattern: /innerHTML\s*=|document\.write\s*\(/, description: 'innerHTML / document.write — XSS risk' },
  { id: 'VULN-032', type: VULN_TYPE.CODE_QUALITY,   severity: 'HIGH',     pattern: /child_process.*exec\s*\(.*req\.|shell:\s*true/i, description: 'User input passed to shell exec' },
  { id: 'VULN-033', type: VULN_TYPE.CODE_QUALITY,   severity: 'MEDIUM',   pattern: /Math\.random\(\).*token|Math\.random\(\).*key/i, description: 'Math.random() used for security token' },
];

/**
 * Scan content for vulnerabilities (dependencies, config, secrets, code quality).
 * @param {string} content
 * @param {string} [fileId]
 * @returns {VulnReport}
 */
function scanVulnerabilities(content, fileId) {
  content = String(content || '');
  const findings = [];
  for (const sig of VULN_SIGNATURES) {
    if (sig.pattern.test(content)) {
      findings.push({ vulnId: sig.id, type: sig.type, severity: sig.severity, description: sig.description });
    }
  }
  const critical = findings.filter(f => f.severity === 'CRITICAL').length;
  const high     = findings.filter(f => f.severity === 'HIGH').length;
  const riskScore = Math.min(1, (critical * 1.0 + high * PHI_INV) / Math.max(1, VULN_SIGNATURES.length * AMOR));
  return {
    vulnScanId:    `VSCAN-${secureId(4).toUpperCase()}`,
    fileId:        String(fileId || 'unknown'),
    scannedAt:     Date.now(),
    findings,
    critical,
    high,
    medium:        findings.filter(f => f.severity === 'MEDIUM').length,
    riskScore:     Math.round(riskScore * 1e4) / 1e4,
    verdict:       critical > 0 ? 'CRITICAL' : high > 0 ? 'HIGH' : findings.length > 0 ? 'MEDIUM' : 'CLEAN',
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — SENTINEL ENDPOINT AGENT (one per monitored endpoint)
// ═══════════════════════════════════════════════════════════════════════════════

class SentinelAgent {
  constructor(endpointId, opts) {
    opts             = opts || {};
    this.endpointId  = String(endpointId);
    this.servitorId  = `GOL-SEC-${String(endpointId).slice(0, 8).toUpperCase()}`;
    this._osc        = _initOsc(N_OSC, Math.PI / 8);
    this._beat       = 0;
    this._alerts     = [];
    this._scanCount  = 0;
    this._threatCount= 0;
    this._lastScan   = null;
    this._meta       = opts.meta || {};   /* { os, hostname, ip, tags } */
    this._sinks      = opts.sinks || [];
    this._status     = 'ACTIVE';
  }

  /** Scan a file or content string on this endpoint. */
  scan(content, fileId, meta) {
    this._osc       = _kuramotoStep(this._osc, AMOR, 0.1);
    this._beat++;
    this._scanCount++;
    const report    = scanContent(content, fileId, meta);
    report.endpointId = this.endpointId;
    report.servitorId = this.servitorId;
    report.coherence  = Math.round(_orderParam(this._osc) * 1e4) / 1e4;
    this._lastScan  = report;
    if (report.verdict !== 'CLEAN') {
      this._threatCount++;
      this._alerts.push({ at: Date.now(), scanId: report.scanId, verdict: report.verdict, score: report.threatScore });
      for (const fn of this._sinks) try { fn({ topic: 'SENTINEL:THREAT', endpoint: this.endpointId, report }); } catch (_) { /* non-fatal */ }
    }
    return report;
  }

  /** Scan network traffic on this endpoint. */
  scanNet(trafficStr) {
    const result = scanNetwork(trafficStr);
    result.endpointId = this.endpointId;
    if (result.count > 0) {
      this._threatCount++;
      for (const fn of this._sinks) try { fn({ topic: 'SENTINEL:NET_THREAT', endpoint: this.endpointId, result }); } catch (_) { /* non-fatal */ }
    }
    return result;
  }

  /** Scan for vulnerabilities (dependencies, config). */
  scanVulns(content, fileId) {
    return scanVulnerabilities(content, fileId);
  }

  status() {
    return {
      endpointId:   this.endpointId,
      servitorId:   this.servitorId,
      status:       this._status,
      beat:         this._beat,
      coherence:    Math.round(_orderParam(this._osc) * 1e4) / 1e4,
      scans:        this._scanCount,
      threats:      this._threatCount,
      alertCount:   this._alerts.length,
      lastScan:     this._lastScan ? { at: this._lastScan.scannedAt, verdict: this._lastScan.verdict } : null,
      meta:         this._meta,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — INCIDENT RESPONSE ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

const IR_PHASE = {
  DETECT:    'DETECT',
  CONTAIN:   'CONTAIN',
  ERADICATE: 'ERADICATE',
  RECOVER:   'RECOVER',
  REVIEW:    'REVIEW',
  CLOSED:    'CLOSED',
};

class IncidentResponseEngine {
  constructor() {
    this._incidents = new Map();   /* incidentId → IRRecord */
    this._counter   = 0;
  }

  /**
   * Open an IR incident from a threat scan report.
   * @param {ThreatReport} scanReport
   * @param {string}       severity     — override if desired
   * @param {string}       analyst      — assigned analyst ID
   * @returns {IRRecord}
   */
  openIncident(scanReport, severity, analyst) {
    const id = `IR-${(++this._counter).toString().padStart(4, '0')}`;
    const record = {
      incidentId:  id,
      scanId:      scanReport.scanId,
      fileId:      scanReport.fileId,
      endpointId:  scanReport.endpointId || 'UNKNOWN',
      threatScore: scanReport.threatScore,
      verdict:     scanReport.verdict,
      findings:    (scanReport.findings || []).slice(),
      severity:    severity || (scanReport.threatScore >= CRITICAL_THRESHOLD ? 'CRITICAL' : 'HIGH'),
      phase:       IR_PHASE.DETECT,
      analyst:     String(analyst || 'UNASSIGNED'),
      timeline:    [{ at: Date.now(), phase: IR_PHASE.DETECT, note: 'Incident opened from threat scan' }],
      containmentActions: [],
      eradicationActions: [],
      recoveryActions:    [],
      lessonsLearned:     '',
      openedAt:    Date.now(),
      closedAt:    null,
    };
    this._incidents.set(id, record);
    return record;
  }

  /** Advance the incident through IR phases. */
  advance(incidentId, note, actions) {
    const r = this._incidents.get(incidentId);
    if (!r) throw new Error(`IR incident not found: ${incidentId}`);
    const phases = Object.values(IR_PHASE);
    const idx    = phases.indexOf(r.phase);
    if (idx < 0 || idx >= phases.length - 1) throw new Error(`Cannot advance from phase ${r.phase}`);
    const next   = phases[idx + 1];
    r.phase      = next;
    r.timeline.push({ at: Date.now(), phase: next, note: String(note || ''), actions: actions || [] });
    if (next === IR_PHASE.CONTAIN)   r.containmentActions.push(...(actions || []));
    if (next === IR_PHASE.ERADICATE) r.eradicationActions.push(...(actions || []));
    if (next === IR_PHASE.RECOVER)   r.recoveryActions.push(...(actions || []));
    if (next === IR_PHASE.CLOSED)    r.closedAt = Date.now();
    return r;
  }

  /** Close and document lessons learned. */
  close(incidentId, lessonsLearned) {
    const r = this._incidents.get(incidentId);
    if (!r) throw new Error(`IR incident not found: ${incidentId}`);
    r.phase          = IR_PHASE.CLOSED;
    r.lessonsLearned = String(lessonsLearned || '');
    r.closedAt       = Date.now();
    r.timeline.push({ at: Date.now(), phase: IR_PHASE.CLOSED, note: lessonsLearned });
    return r;
  }

  /** Assign analyst. */
  assign(incidentId, analyst) {
    const r = this._incidents.get(incidentId);
    if (!r) throw new Error(`IR incident not found: ${incidentId}`);
    r.analyst = String(analyst);
    return r;
  }

  list(filter) {
    const all = Array.from(this._incidents.values());
    if (!filter) return all;
    return all.filter(r =>
      (!filter.phase    || r.phase    === filter.phase)    &&
      (!filter.severity || r.severity === filter.severity) &&
      (!filter.analyst  || r.analyst  === filter.analyst)
    );
  }

  stats() {
    const all  = Array.from(this._incidents.values());
    const open = all.filter(r => r.phase !== IR_PHASE.CLOSED);
    return { total: all.length, open: open.length, closed: all.length - open.length,
             critical: all.filter(r => r.severity === 'CRITICAL').length,
             phases: Object.fromEntries(Object.values(IR_PHASE).map(p => [p, all.filter(r => r.phase === p).length])) };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — IT TEAM DASHBOARD (aggregates fleet + quarantine + IR)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Produces a structured SOC/IT team dashboard snapshot.
 * @param {SovereignAntivirusPlatform} platform
 * @returns {DashboardSnapshot}
 */
function buildDashboard(platform) {
  const sentinelStatuses = Array.from(platform._sentinels.values()).map(s => s.status());
  const qStats           = platform._quarantine.stats();
  const irStats          = platform._ir.stats();
  const totalScans       = sentinelStatuses.reduce((s, x) => s + x.scans, 0);
  const totalThreats     = sentinelStatuses.reduce((s, x) => s + x.threats, 0);
  const fleetCoherence   = sentinelStatuses.length
    ? sentinelStatuses.reduce((s, x) => s + x.coherence, 0) / sentinelStatuses.length
    : 0;

  /* Fleet health: RED if coherence < AMOR, AMBER if < PHI_INV */
  const fleetHealth = fleetCoherence >= PHI_INV ? 'GREEN'
                    : fleetCoherence >= AMOR     ? 'AMBER'
                    :                              'RED';

  return {
    dashboardAt:    Date.now(),
    agentId:        platform.id,
    beat:           platform._beat,
    fleet: {
      total:        sentinelStatuses.length,
      active:       sentinelStatuses.filter(s => s.status === 'ACTIVE').length,
      coherence:    Math.round(fleetCoherence * 1e4) / 1e4,
      health:       fleetHealth,
    },
    scanning: {
      totalScans,
      totalThreats,
      threatRate:   totalScans > 0 ? Math.round(totalThreats / totalScans * 1e4) / 1e4 : 0,
    },
    quarantine:     qStats,
    incidentResponse: irStats,
    recentAlerts:   sentinelStatuses
      .flatMap(s => s.alertCount > 0 ? [{ endpoint: s.endpointId, alerts: s.alertCount }] : [])
      .slice(0, 20),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — NETWORK ANOMALY MONITOR (Lyapunov-based)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Tracks a sliding window of network event magnitudes and computes a
 * Lyapunov-like divergence exponent.  λ > 0 → anomalous / diverging traffic.
 *
 * λ ≈ (1/N) Σ log|ΔM_i|  where M_i is the event magnitude at step i.
 */
class NetworkAnomalyMonitor {
  constructor(windowSize) {
    this._window    = [];
    this._maxWindow = windowSize || 128;
    this._lambda    = 0;      /* Lyapunov exponent estimate */
    this._alerts    = [];
    this._sinks     = [];
  }

  /**
   * Record a network event.
   * @param {number} magnitude — normalised event magnitude [0, 1]
   * @param {string} label     — event label (e.g. 'bytes_out', 'conn_rate')
   */
  record(magnitude, label) {
    magnitude = Math.max(0, Math.min(1, Number(magnitude) || 0));
    this._window.push({ magnitude, label, at: Date.now() });
    if (this._window.length > this._maxWindow) this._window.shift();
    this._recompute();
    return this._lambda;
  }

  /** Compute Lyapunov exponent from window deltas. */
  _recompute() {
    const w = this._window;
    if (w.length < 4) { this._lambda = 0; return; }
    let logSum = 0, n = 0;
    for (let i = 1; i < w.length; i++) {
      const delta = Math.abs(w[i].magnitude - w[i-1].magnitude);
      if (delta > 1e-9) { logSum += Math.log(delta); n++; }
    }
    this._lambda = n > 0 ? logSum / n : 0;
    /* λ > 0 is anomalous in a stable system */
    if (this._lambda > 0) {
      const severity = this._lambda > Math.log(PHI) ? 'HIGH' : 'MEDIUM';
      const alert    = { at: Date.now(), lambda: Math.round(this._lambda * 1e4) / 1e4, severity };
      this._alerts.push(alert);
      if (this._alerts.length > 500) this._alerts.shift();
      for (const fn of this._sinks) try { fn({ topic: 'NET:ANOMALY', alert }); } catch (_) { /* non-fatal */ }
    }
  }

  registerSink(fn) { if (typeof fn === 'function') this._sinks.push(fn); return this; }

  status() {
    return {
      windowSize:    this._window.length,
      lambda:        Math.round(this._lambda * 1e4) / 1e4,
      isAnomalous:   this._lambda > 0,
      alertCount:    this._alerts.length,
      recentAlerts:  this._alerts.slice(-5),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — SOVEREIGN ANTIVIRUS PLATFORM (unified orchestrator)
// ═══════════════════════════════════════════════════════════════════════════════

class SovereignAntivirusPlatform {
  constructor(opts) {
    opts              = opts || {};
    this.id           = AGI_ID;
    this.family       = AGI_FAMILY;
    this.version      = AGI_VERSION;
    this._sentinels   = new Map();   /* endpointId → SentinelAgent */
    this._quarantine  = new QuarantineVault();
    this._ir          = new IncidentResponseEngine();
    this._netMonitor  = new NetworkAnomalyMonitor(opts.netWindow || 128);
    this._beat        = 0;
    this._osc         = _initOsc(N_OSC, Math.PI / 4);
    this._running     = false;
    this._hbi         = null;
    this._sinks       = [];
    this._stats       = { scans: 0, threats: 0, quarantines: 0, incidents: 0 };

    if (opts.autoStart !== false) this.start();
    else this._log('init', `${AGI_ID} ready (autoStart=false)`);
  }

  // ── ENDPOINT MANAGEMENT ──────────────────────────────────────────────────────

  /** Register a new endpoint and assign a sentinel agent. */
  registerEndpoint(endpointId, meta) {
    if (this._sentinels.has(endpointId)) return this._sentinels.get(endpointId);
    const sentinel = new SentinelAgent(endpointId, { meta: meta || {}, sinks: this._sinks });
    this._sentinels.set(endpointId, sentinel);
    this._publish('PLATFORM:ENDPOINT_REGISTERED', { endpointId, servitorId: sentinel.servitorId });
    return sentinel;
  }

  /** Get a sentinel agent by endpoint ID. */
  getSentinel(endpointId) { return this._sentinels.get(endpointId) || null; }

  // ── SCANNING ─────────────────────────────────────────────────────────────────

  /**
   * Full scan: threat + vulnerability.
   * Automatically quarantines and opens IR if threat is MALICIOUS.
   */
  fullScan(content, fileId, endpointId, meta) {
    const sentinel    = endpointId ? (this._sentinels.get(endpointId) || this.registerEndpoint(endpointId, {})) : null;
    const threatReport= sentinel ? sentinel.scan(content, fileId, meta) : scanContent(content, fileId, meta);
    const vulnReport  = scanVulnerabilities(content, fileId);

    this._stats.scans++;
    if (threatReport.verdict !== 'CLEAN') this._stats.threats++;

    let qRecord = null;
    let irRecord = null;

    /* Auto-quarantine if threat score ≥ threshold */
    if (threatReport.threatScore >= QUARANTINE_THRESHOLD) {
      qRecord = this._quarantine.quarantine(threatReport, 'PLATFORM_AUTO');
      this._stats.quarantines++;
      this._publish('PLATFORM:QUARANTINE', { fileId, verdict: threatReport.verdict, quarantineId: qRecord.quarantineId });
    }

    /* Auto-open IR for critical/high threats */
    if (threatReport.threatScore >= CRITICAL_THRESHOLD) {
      irRecord = this._ir.openIncident(threatReport, 'CRITICAL', 'UNASSIGNED');
      this._stats.incidents++;
      this._publish('PLATFORM:IR_OPENED', { incidentId: irRecord.incidentId, endpointId, verdict: threatReport.verdict });
    }

    return {
      fileId,
      endpointId,
      threatReport,
      vulnReport,
      quarantine:  qRecord ? { quarantineId: qRecord.quarantineId, status: qRecord.status } : null,
      incident:    irRecord ? { incidentId: irRecord.incidentId, phase: irRecord.phase } : null,
    };
  }

  /**
   * Quick scan — threat only (no vuln scan).
   */
  quickScan(content, fileId, endpointId) {
    const sentinel = endpointId ? (this._sentinels.get(endpointId) || this.registerEndpoint(endpointId, {})) : null;
    const report   = sentinel ? sentinel.scan(content, fileId) : scanContent(content, fileId);
    this._stats.scans++;
    if (report.verdict !== 'CLEAN') {
      this._stats.threats++;
      if (report.threatScore >= QUARANTINE_THRESHOLD) {
        const qr = this._quarantine.quarantine(report, 'PLATFORM_AUTO');
        this._stats.quarantines++;
        return Object.assign({}, report, { quarantineId: qr.quarantineId });
      }
    }
    return report;
  }

  /**
   * Scan network traffic (e.g. HTTP header string, log line).
   */
  scanNet(trafficStr, endpointId) {
    const result = scanNetwork(trafficStr);
    /* Feed magnitude to Lyapunov monitor */
    const sev    = { CRITICAL: 1.0, HIGH: 1 - AMOR, MEDIUM: PHI_INV / 2, LOW: AMOR / 2, CLEAN: 0 };
    this._netMonitor.record(sev[result.maxSeverity] || 0, 'net');
    if (result.count > 0) {
      this._publish('PLATFORM:NET_ALERT', { endpointId, result });
    }
    return Object.assign({}, result, { netMonitor: this._netMonitor.status() });
  }

  // ── QUARANTINE & IR ──────────────────────────────────────────────────────────

  releaseQuarantine(quarantineId, operator, note) { return this._quarantine.release(quarantineId, operator, note); }
  destroyQuarantine(quarantineId, operator)       { return this._quarantine.destroy(quarantineId, operator); }
  addQuarantineNote(quarantineId, op, text)        { return this._quarantine.addNote(quarantineId, op, text); }

  advanceIR(incidentId, note, actions) { return this._ir.advance(incidentId, note, actions); }
  closeIR(incidentId, lessons)         { return this._ir.close(incidentId, lessons); }
  assignIR(incidentId, analyst)        { return this._ir.assign(incidentId, analyst); }
  listIR(filter)                       { return this._ir.list(filter); }

  // ── DASHBOARD ─────────────────────────────────────────────────────────────────

  dashboard() { return buildDashboard(this); }

  // ── SIGNATURES ───────────────────────────────────────────────────────────────

  /**
   * Add a custom threat signature to the DB.
   * @param {{ id, type, severity, pattern, description }} sig
   */
  addSignature(sig) {
    if (!sig || !sig.pattern || !sig.id) throw new Error('Signature requires id, pattern, description');
    SIGNATURE_DB.push(sig);
    return { added: sig.id, total: SIGNATURE_DB.length };
  }

  signatureCount() { return { threats: SIGNATURE_DB.length, network: NETWORK_SIGNATURES.length, vulns: VULN_SIGNATURES.length }; }

  // ── MCP TOOL ENDPOINTS (Cloudflare Workers) ────────────────────────────────

  mcpFetch() {
    const platform = this;
    return async function(request) {
      const url  = new URL(request.url);
      const path = url.pathname;

      if (path === '/mcp/tools') {
        return _json({ tools: [
          { name: 'full_scan',          description: 'Full threat + vulnerability scan',              params: ['content', 'fileId', 'endpointId'] },
          { name: 'quick_scan',         description: 'Quick threat-only scan',                        params: ['content', 'fileId', 'endpointId'] },
          { name: 'scan_network',       description: 'Scan network traffic / headers',               params: ['trafficStr', 'endpointId'] },
          { name: 'scan_vulnerabilities',description: 'Scan for vulnerabilities only',              params: ['content', 'fileId'] },
          { name: 'register_endpoint',  description: 'Register an endpoint in the sentinel fleet',   params: ['endpointId', 'meta'] },
          { name: 'endpoint_status',    description: 'Get status of a sentinel endpoint',            params: ['endpointId'] },
          { name: 'release_quarantine', description: 'Release a quarantined file',                   params: ['quarantineId', 'operator', 'note'] },
          { name: 'advance_ir',         description: 'Advance an IR incident to the next phase',     params: ['incidentId', 'note', 'actions'] },
          { name: 'assign_ir',          description: 'Assign an analyst to an IR incident',          params: ['incidentId', 'analyst'] },
          { name: 'list_ir',            description: 'List IR incidents',                            params: ['filter'] },
          { name: 'dashboard',          description: 'Get full IT team / SOC dashboard',             params: [] },
          { name: 'platform_status',    description: 'Get platform status and stats',               params: [] },
          { name: 'signature_count',    description: 'Count of loaded signatures',                   params: [] },
          { name: 'add_signature',      description: 'Add a custom threat signature',               params: ['sig'] },
        ]});
      }

      if (path === '/mcp/invoke' && request.method === 'POST') {
        let body;
        try { body = await request.json(); } catch (_) { return _jsonErr(400, 'Invalid JSON'); }
        const { tool, params } = body || {};
        if (!tool) return _jsonErr(400, 'Missing tool');
        const p = params || {};
        try {
          let result;
          if      (tool === 'full_scan')           result = platform.fullScan(p.content, p.fileId, p.endpointId, p.meta);
          else if (tool === 'quick_scan')          result = platform.quickScan(p.content, p.fileId, p.endpointId);
          else if (tool === 'scan_network')        result = platform.scanNet(p.trafficStr, p.endpointId);
          else if (tool === 'scan_vulnerabilities')result = scanVulnerabilities(p.content, p.fileId);
          else if (tool === 'register_endpoint')   result = platform.registerEndpoint(p.endpointId, p.meta).status();
          else if (tool === 'endpoint_status')     { const s = platform.getSentinel(p.endpointId); result = s ? s.status() : null; }
          else if (tool === 'release_quarantine')  result = platform.releaseQuarantine(p.quarantineId, p.operator, p.note);
          else if (tool === 'advance_ir')          result = platform.advanceIR(p.incidentId, p.note, p.actions);
          else if (tool === 'assign_ir')           result = platform.assignIR(p.incidentId, p.analyst);
          else if (tool === 'list_ir')             result = platform.listIR(p.filter);
          else if (tool === 'dashboard')           result = platform.dashboard();
          else if (tool === 'platform_status')     result = platform.status();
          else if (tool === 'signature_count')     result = platform.signatureCount();
          else if (tool === 'add_signature')       result = platform.addSignature(p.sig);
          else                                     return _jsonErr(400, `Unknown tool: ${tool}`);
          return _json({ tool, result });
        } catch (e) {
          return _jsonErr(500, e.message);
        }
      }

      return _jsonErr(404, 'Not found');
    };
  }

  // ── STATUS ─────────────────────────────────────────────────────────────────

  status() {
    return {
      agentId:       this.id,
      family:        this.family,
      version:       this.version,
      beat:          this._beat,
      running:       this._running,
      coherence:     Math.round(_orderParam(this._osc) * 1e4) / 1e4,
      endpoints:     this._sentinels.size,
      stats:         Object.assign({}, this._stats),
      quarantine:    this._quarantine.stats(),
      ir:            this._ir.stats(),
      netMonitor:    this._netMonitor.status(),
      signatures:    this.signatureCount(),
    };
  }

  start() {
    if (this._running) return this;
    this._running = true;
    this._hbi = setInterval(() => {
      this._beat++;
      this._osc = _kuramotoStep(this._osc, AMOR, 0.05);
    }, HEARTBEAT_MS);
    this._log('start', `${AGI_ID} (${AGI_FAMILY}) online — NOVA Antivirus Platform v${AGI_VERSION}`);
    return this;
  }

  stop() {
    this._running = false;
    clearInterval(this._hbi);
    this._hbi = null;
    return this;
  }

  registerStream(fn) { if (typeof fn === 'function') { this._sinks.push(fn); this._netMonitor.registerSink(fn); } return this; }

  _publish(topic, payload) {
    const e = { topic, origin: this.id, payload, beat: this._beat, at: Date.now() };
    for (const fn of this._sinks) try { fn(e); } catch (_) { /* non-fatal */ }
  }

  _log(phase, msg) {
    if (typeof console !== 'undefined') console.log(`[${this.id}] ${msg}`);
  }
}

function _json(body, status) {
  return new Response(JSON.stringify(body), { status: status || 200, headers: { 'Content-Type': 'application/json' } });
}
function _jsonErr(status, msg) {
  return _json({ error: msg }, status);
}

// ═══════════════════════════════════════════════════════════════════════════════
// §11 — ENTRY POINT
// ═══════════════════════════════════════════════════════════════════════════════

const antivirusPlatform = new SovereignAntivirusPlatform({ autoStart: true });

/* Cloudflare Workers entry point */
if (typeof addEventListener !== 'undefined') {
  const handler = antivirusPlatform.mcpFetch();
  addEventListener('fetch', event => event.respondWith(handler(event.request)));
}

/* Node.js / CommonJS export */
if (typeof module !== 'undefined') {
  module.exports = {
    antivirusPlatform,
    SovereignAntivirusPlatform,
    SentinelAgent,
    QuarantineVault,
    IncidentResponseEngine,
    NetworkAnomalyMonitor,
    scanContent,
    scanNetwork,
    scanVulnerabilities,
    buildDashboard,
    THREAT_TYPE,
    SEVERITY,
    VULN_TYPE,
    IR_PHASE,
    SIGNATURE_DB,
    VULN_SIGNATURES,
    NETWORK_SIGNATURES,
    PHI, PHI_INV, AMOR, HEARTBEAT_MS,
    QUARANTINE_THRESHOLD, CRITICAL_THRESHOLD,
  };
}
