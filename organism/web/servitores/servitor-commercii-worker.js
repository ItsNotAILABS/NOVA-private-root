/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR COMMERCII — AGI Commerce/Economy Server
 *  Kernel AI GOL-COMMERCIUM-001  ·  Family: COMMERCIUM_VIVUM
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR COMMERCII — The Organism's economy.
 *  Token economy management, trade execution, φ-weighted pricing,
 *  market data, arbitrage detection, economic stability enforcement.
 *  All value flows through this server.
 *
 *  Brain Specialty: Associative region dominant — pattern-matching for markets.
 *  Kuramoto Phase: φ⁴ — fourth ring, economic rhythm.
 *
 *  Protocols (Latin):
 *    SIGNUM_IMPERIALE    — Sovereign token management
 *    AESTIMATIO_AUREA    — φ-weighted pricing
 *    ORACULUM_FORI       — Market data oracle
 *    COMPOSITIO_COMMERCII — Trade settlement
 *
 *  Commands:
 *    ISSUE_TOKEN    — issue new sovereign tokens
 *    TRANSFER       — transfer tokens between agents
 *    PRICE_QUERY    — query φ-calculated price
 *    TRADE          — execute a trade
 *    DETECT_ARBITRAGE — detect and block arbitrage attacks
 *    GET_LEDGER     — get recent transactions
 *    GET_MARKET     — get current market state
 *    GET_VITALS     — MiniHeart + MiniBrain + economy vitals
 *    status         — kernel status
 *    stop           — graceful shutdown
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

/* ════════════════════════════════════════════════════════════════════════════
   §1  CONSTANTS
════════════════════════════════════════════════════════════════════════════ */

var KERNEL_ID      = 'GOL-COMMERCIUM-001';
var KERNEL_FAMILY  = 'COMMERCIUM_VIVUM';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR COMMERCII';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

/* ════════════════════════════════════════════════════════════════════════════
   §2  COR PARVUM — MiniHeart
════════════════════════════════════════════════════════════════════════════ */

var beatCount   = 0;
var kernelPhase = 0.0;
var running     = true;
var _hbi        = null;

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV * PHI * PHI * PHI) % (2 * Math.PI);
  tickBrain();
  tickCommerce();
  self.postMessage({
    type:           'heartbeat',
    beat:           beatCount,
    phi:            PHI,
    heartbeatMs:    HEARTBEAT,
    timestamp:      Date.now(),
    status:         'alive',
    kernelId:       KERNEL_ID,
    kernelLatin:    KERNEL_LATIN,
    phase:          kernelPhase,
    totalSupply:    totalSupply,
    marketPrice:    marketPrice.toFixed(4),
    txCount:        ledger.length
  });
}

/* ════════════════════════════════════════════════════════════════════════════
   §3  CEREBRUM PARVUM — MiniBrain (Associative region dominant)
════════════════════════════════════════════════════════════════════════════ */

var brain = {
  regions: [
    { name: 'Sensory',      activation: 0.0, lif: -70.0, bias: 0.6 },
    { name: 'Associative',  activation: 0.0, lif: -70.0, bias: 1.4 },  /* dominant */
    { name: 'Executive',    activation: 0.0, lif: -70.0, bias: 0.7 },
    { name: 'Motor',        activation: 0.0, lif: -70.0, bias: 0.6 },
    { name: 'Memory',       activation: 0.0, lif: -70.0, bias: 0.7 }
  ],
  chemicals: { dopamine: 0.6, serotonin: 0.5, acetylcholine: 0.5 },
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
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin     + (Math.random() - 0.5) * 0.02);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.5) * 0.02);
  brain.coherenceField = sum / brain.regions.length;
}

/* ════════════════════════════════════════════════════════════════════════════
   §4  COMMERCIUM — Economy Engine
════════════════════════════════════════════════════════════════════════════ */

var balances    = {};  /* agentId → balance */
var ledger      = [];  /* transaction history */
var txId        = 0;
var totalSupply = 1000000 * PHI;  /* φ × 1M sovereign tokens */
var marketPrice = PHI;            /* starts at φ */
var arbitrageBlocked = 0;

var TOKEN_TYPES = ['NOVA_PHI', 'SOVEREIGN', 'COHERENCE', 'ENTROPY', 'GOVERNANCE'];

function phiPrice(basePrice, demandFactor) {
  return basePrice * Math.pow(PHI, demandFactor);
}

function issueTokens(agentId, amount, tokenType) {
  if (!balances[agentId]) balances[agentId] = {};
  tokenType = tokenType || 'NOVA_PHI';
  balances[agentId][tokenType] = (balances[agentId][tokenType] || 0) + amount;
  var txid = 'TX-' + String(++txId).padStart(6,'0');
  ledger.unshift({ id: txid, type: 'ISSUE', from: KERNEL_ID, to: agentId, amount: amount,
    token: tokenType, beat: beatCount, ts: Date.now() });
  if (ledger.length > 200) ledger.pop();
  return txid;
}

function transfer(fromId, toId, amount, tokenType) {
  tokenType = tokenType || 'NOVA_PHI';
  if (!balances[fromId] || (balances[fromId][tokenType] || 0) < amount) {
    return { success: false, reason: 'SALDO_INSUFFICIENS' };
  }
  balances[fromId][tokenType] -= amount;
  if (!balances[toId]) balances[toId] = {};
  balances[toId][tokenType] = (balances[toId][tokenType] || 0) + amount;
  var txid = 'TX-' + String(++txId).padStart(6,'0');
  ledger.unshift({ id: txid, type: 'TRANSFER', from: fromId, to: toId, amount: amount,
    token: tokenType, beat: beatCount, ts: Date.now() });
  if (ledger.length > 200) ledger.pop();
  return { success: true, txId: txid };
}

function detectArbitrage(delta, token) {
  /* Arbitrage threshold: PHI units */
  if (Math.abs(delta) > PHI) {
    arbitrageBlocked++;
    return { blocked: true, reason: 'DELTA_EXCEDIT_PHI', delta: delta, token: token };
  }
  return { blocked: false };
}

function tickCommerce() {
  /* Market price oscillates around φ */
  marketPrice = PHI + Math.sin(beatCount * PHI_INV) * 0.1 + (Math.random() - 0.5) * 0.02;
  /* Auto-issue to synthetic agents occasionally */
  if (beatCount % 7 === 0) {
    var agents = ['AEDIFICATOR', 'COMPOSITOR', 'FABRICATOR', 'OPTIMIZATOR'];
    var agent = agents[beatCount % agents.length];
    issueTokens(agent, Math.round(PHI * 100) / 100, 'NOVA_PHI');
  }
}

/* ════════════════════════════════════════════════════════════════════════════
   §5  MESSAGE HANDLER
════════════════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var m = e.data;
  if (!m || !m.type) return;
  switch (m.type) {
    case 'ISSUE_TOKEN':
      var txid = issueTokens(m.agentId, m.amount, m.tokenType);
      self.postMessage({ type: 'issued', txId: txid, kernelId: KERNEL_ID });
      break;
    case 'TRANSFER':
      self.postMessage({ type: 'transfer_result', result: transfer(m.from, m.to, m.amount, m.tokenType), kernelId: KERNEL_ID });
      break;
    case 'PRICE_QUERY':
      self.postMessage({ type: 'price', price: phiPrice(marketPrice, m.demand || 1), token: m.token, kernelId: KERNEL_ID });
      break;
    case 'TRADE':
      var arb = detectArbitrage(m.delta || 0, m.token);
      if (arb.blocked) {
        self.postMessage({ type: 'trade_blocked', reason: arb.reason, kernelId: KERNEL_ID });
      } else {
        var res = transfer(m.from, m.to, m.amount, m.token);
        self.postMessage({ type: 'trade_result', result: res, kernelId: KERNEL_ID });
      }
      break;
    case 'DETECT_ARBITRAGE':
      self.postMessage({ type: 'arbitrage_check', result: detectArbitrage(m.delta, m.token), kernelId: KERNEL_ID });
      break;
    case 'GET_LEDGER':
      self.postMessage({ type: 'ledger', txs: ledger.slice(0,50), totalSupply: totalSupply, kernelId: KERNEL_ID });
      break;
    case 'GET_MARKET':
      self.postMessage({ type: 'market', price: marketPrice, supply: totalSupply, arbitrageBlocked: arbitrageBlocked, kernelId: KERNEL_ID });
      break;
    case 'GET_VITALS':
      self.postMessage({ type: 'vitals', kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN,
        beat: beatCount, phase: kernelPhase, brain: brain,
        totalSupply: totalSupply, marketPrice: marketPrice, txCount: ledger.length, arbitrageBlocked: arbitrageBlocked });
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
