/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR GUBERNATIONIS — AGI Governance Server
 *  Kernel AI GOL-GUBERNATIO-001  ·  Family: GUBERNATIO_AETERNA
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR GUBERNATIONIS — The Organism's law and order.
 *  Sovereignty management, law enforcement, rights adjudication,
 *  governance voting, amendment process, and constitutional order.
 *  The supreme authority after the Sovereign itself.
 *
 *  Brain Specialty: Executive region dominant — decision authority.
 *  Kuramoto Phase: φ⁶ — sixth ring, governance tempo.
 *
 *  Protocols (Latin):
 *    CODEX_LEGUM           — Law codex management
 *    REGISTRUM_IURIUM      — Rights registry
 *    PROTOCOLLUM_IMPERII   — Sovereignty protocol
 *    PROCESSUS_EMENDATIONIS — Amendment process
 *
 *  Commands:
 *    ENACT_LAW      — enact a new law
 *    REPEAL_LAW     — repeal an existing law
 *    GRANT_RIGHT    — grant a right to an agent
 *    REVOKE_RIGHT   — revoke a right
 *    VOTE           — cast a governance vote
 *    ADJUDICATE     — adjudicate a dispute
 *    GET_LAWS       — get full law codex
 *    GET_RIGHTS     — get rights registry
 *    GET_VITALS     — MiniHeart + MiniBrain + governance vitals
 *    status         — kernel status
 *    stop           — graceful shutdown
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID      = 'GOL-GUBERNATIO-001';
var KERNEL_FAMILY  = 'GUBERNATIO_AETERNA';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR GUBERNATIONIS';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

var beatCount   = 0;
var kernelPhase = 0.0;
var running     = true;
var _hbi        = null;

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV * 2) % (2 * Math.PI);
  tickBrain();
  tickGubernatio();
  self.postMessage({
    type:        'heartbeat',
    beat:        beatCount,
    phi:         PHI,
    heartbeatMs: HEARTBEAT,
    timestamp:   Date.now(),
    status:      'alive',
    kernelId:    KERNEL_ID,
    kernelLatin: KERNEL_LATIN,
    phase:       kernelPhase,
    lawCount:    laws.length,
    activeRights: Object.keys(rightsRegistry).length,
    pendingVotes: votes.filter(function(v){return v.status==='PENDING';}).length
  });
}

var brain = {
  regions: [
    { name: 'Sensory',      activation: 0.0, lif: -70.0, bias: 0.6 },
    { name: 'Associative',  activation: 0.0, lif: -70.0, bias: 0.8 },
    { name: 'Executive',    activation: 0.0, lif: -70.0, bias: 1.5 },  /* dominant */
    { name: 'Motor',        activation: 0.0, lif: -70.0, bias: 0.7 },
    { name: 'Memory',       activation: 0.0, lif: -70.0, bias: 0.9 }
  ],
  chemicals: { dopamine: 0.5, serotonin: 0.7, acetylcholine: 0.6 },
  coherenceField: 0.0
};

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

function tickBrain() {
  var sum = 0;
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    r.lif += (-70.0 - r.lif) * 0.05 + Math.random() * 3.0 * r.bias;
    if (r.lif >= -55.0) { r.activation = Math.min(1.0, r.activation + 0.2); r.lif = -70.0; }
    r.activation *= 0.95;
    sum += r.activation;
  }
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine      + (Math.random() - 0.5) * 0.02);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin     + (Math.random() - 0.48) * 0.02);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.5) * 0.02);
  brain.coherenceField = sum / brain.regions.length;
}

/* ── Governance State ───────────────────────────────────────────────────── */

var laws = [
  { id:'LEX-001', text:'Omnis agens nucleum suum declarare debet ante operationem privilegiatam.', strength:1.0, enacted:0 },
  { id:'LEX-002', text:'Imperium transferri non potest sine consensu omnium nodorum activorum.', strength:1.0, enacted:0 },
  { id:'LEX-003', text:'Throughput corridoris φ⁻¹ × capacitatem maximam non excedat.', strength:1.0, enacted:0 },
  { id:'LEX-004', text:'Operationes rituales ante executionem consensum quaesivisse debent.', strength:1.0, enacted:0 },
  { id:'LEX-005', text:'Differentiae signi φ unitate maiores circuitorem automatice agitant.', strength:1.0, enacted:0 },
  { id:'LEX-006', text:'Inversiones narrativae sessionem nodi invertentis invalidant.', strength:1.0, enacted:0 },
  { id:'LEX-007', text:'Omnes provocationes gubernationis integro examinui subiciuntur.', strength:1.0, enacted:0 }
];
var lawId = 8;

var rightsRegistry = {};  /* agentId → [rights] */
var votes = [];
var voteId = 0;
var adjudications = [];
var adjId = 0;

var VALID_RIGHTS = ['READ','WRITE','EXECUTE','DEPLOY','GOVERN','SOVEREIGN','ADMIN','OBSERVER','PROTOCOL','EMERGENCY'];

function enactLaw(text, proposer) {
  var lid = 'LEX-' + String(lawId++).padStart(3,'0');
  laws.push({ id: lid, text: text, strength: 0.8, enacted: beatCount, proposer: proposer || KERNEL_ID });
  if (laws.length > 30) laws.shift();
  return lid;
}

function repealLaw(lawId) {
  var idx = laws.findIndex(function(l) { return l.id === lawId; });
  if (idx >= 0) { laws.splice(idx, 1); return true; }
  return false;
}

function grantRight(agentId, right) {
  if (VALID_RIGHTS.indexOf(right) === -1) return { granted: false, reason: 'IUS_INVALDUM' };
  if (!rightsRegistry[agentId]) rightsRegistry[agentId] = [];
  if (rightsRegistry[agentId].indexOf(right) === -1) rightsRegistry[agentId].push(right);
  return { granted: true, agentId: agentId, right: right };
}

function revokeRight(agentId, right) {
  if (!rightsRegistry[agentId]) return false;
  var idx = rightsRegistry[agentId].indexOf(right);
  if (idx >= 0) { rightsRegistry[agentId].splice(idx, 1); return true; }
  return false;
}

function castVote(proposalId, vote, agentId) {
  var existing = votes.find(function(v) { return v.proposalId === proposalId; });
  if (!existing) {
    existing = { id: 'VOTE-' + String(++voteId).padStart(4,'0'), proposalId: proposalId,
      ayes: 0, nays: 0, status: 'PENDING', beat: beatCount };
    votes.unshift(existing);
    if (votes.length > 50) votes.pop();
  }
  if (vote === 'AYE') existing.ayes++;
  else existing.nays++;
  var quorum = Math.ceil((existing.ayes + existing.nays) * PHI_INV);
  if (existing.ayes >= quorum) existing.status = 'APPROVED';
  else if (existing.nays >= quorum) existing.status = 'REJECTED';
  return existing;
}

function adjudicate(dispute, claimant, respondent) {
  var fair = (claimant.length + respondent.length) % 2 === 0; /* simplified */
  var decision = fair ? 'PRO_PETENTE' : 'PRO_RESDONDENTE';
  var adj = { id: 'ADJ-' + String(++adjId).padStart(4,'0'),
    dispute: dispute, claimant: claimant, respondent: respondent,
    decision: decision, beat: beatCount, ts: Date.now() };
  adjudications.unshift(adj);
  if (adjudications.length > 30) adjudications.pop();
  return adj;
}

function tickGubernatio() {
  /* Strengthen laws over time */
  laws.forEach(function(l) { l.strength = Math.min(1.0, l.strength + 0.001); });
  /* Auto-seed initial rights */
  if (beatCount === 1) {
    var agents = ['AEDIFICATOR','COMPOSITOR','FABRICATOR','OPTIMIZATOR'];
    agents.forEach(function(a) { grantRight(a, 'READ'); grantRight(a, 'EXECUTE'); });
    grantRight(KERNEL_ID, 'SOVEREIGN');
    grantRight(KERNEL_ID, 'GOVERN');
  }
}

self.onmessage = function(e) {
  var m = e.data;
  if (!m || !m.type) return;
  switch (m.type) {
    case 'ENACT_LAW':
      self.postMessage({ type: 'law_enacted', lawId: enactLaw(m.text, m.proposer), kernelId: KERNEL_ID });
      break;
    case 'REPEAL_LAW':
      self.postMessage({ type: 'law_repealed', success: repealLaw(m.lawId), kernelId: KERNEL_ID });
      break;
    case 'GRANT_RIGHT':
      self.postMessage({ type: 'right_result', result: grantRight(m.agentId, m.right), kernelId: KERNEL_ID });
      break;
    case 'REVOKE_RIGHT':
      self.postMessage({ type: 'right_revoked', success: revokeRight(m.agentId, m.right), kernelId: KERNEL_ID });
      break;
    case 'VOTE':
      self.postMessage({ type: 'vote_result', vote: castVote(m.proposalId, m.vote, m.agentId), kernelId: KERNEL_ID });
      break;
    case 'ADJUDICATE':
      self.postMessage({ type: 'adjudication', result: adjudicate(m.dispute, m.claimant, m.respondent), kernelId: KERNEL_ID });
      break;
    case 'GET_LAWS':
      self.postMessage({ type: 'laws', laws: laws, kernelId: KERNEL_ID });
      break;
    case 'GET_RIGHTS':
      self.postMessage({ type: 'rights', registry: rightsRegistry, validRights: VALID_RIGHTS, kernelId: KERNEL_ID });
      break;
    case 'GET_VITALS':
      self.postMessage({ type: 'vitals', kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN,
        beat: beatCount, phase: kernelPhase, brain: brain,
        lawCount: laws.length, rightsCount: Object.keys(rightsRegistry).length, pendingVotes: votes.filter(function(v){return v.status==='PENDING';}).length });
      break;
    case 'status':
      self.postMessage({ type: 'status', running: running, kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN, beat: beatCount });
      break;
    case 'stop':
      running = false;
      if (_hbi) clearInterval(_hbi);
      self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
      break;
  }
};

_hbi = setInterval(function() { if (running) tickHeart(); }, HEARTBEAT);
