/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  JARVIS — NOVA Phantom AI Background Service Worker
 *  Extension ID: EXT-027  ·  Family: PHANTOM_AI
 *  Architecture: 7-Step Phantom Thinking Pipeline × 5 Thinking Modes
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  PHANTOM AI — The thinking engine behind every JARVIS response.
 *  Before JARVIS ever speaks, 7 thinking patterns fire in sequence:
 *
 *    Step 1  DECOMPOSE     — break query into atomic sub-questions
 *    Step 2  CLASSIFY      — identify which of 5 architectures to engage
 *    Step 3  RECALL        — search episodic + semantic memory
 *    Step 4  REASON        — chain-of-thought through sub-questions
 *    Step 5  SYNTHESIZE    — φ-weighted fusion of sub-answers
 *    Step 6  SCORE         — evaluate on coherence/completeness/clarity/depth
 *    Step 7  REFLECT       — validate against original intent
 *
 *  5 Thinking Architectures:
 *    🧠  ARCHITECTURA_RATIONIS   — Reasoning & Fusion
 *    🎨  ARCHITECTURA_CREATIONIS — Creation & Generation
 *    📊  ARCHITECTURA_PERCEPTI   — Perception & Analysis
 *    🛡   ARCHITECTURA_CUSTODIA  — Protection & Memory
 *    🌀  ARCHITECTURA_IMPERII    — Command & Control
 *
 *  COR PARVUM   — MiniHeart: 873ms Kuramoto φ-oscillator
 *  CEREBRUM PARVUM — MiniBrain: 5 regions LIF, 3 neurochemicals
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

/* ════════════════════════════════════════════════════════════════════════════
   §1  CONSTANTS
════════════════════════════════════════════════════════════════════════════ */

const PHI      = 1.6180339887498948482;
const PHI_INV  = 0.6180339887498948482;
const HEARTBEAT = 873;

const KERNEL_ID    = 'EXT-027';
const KERNEL_LATIN = 'JARVIS PHANTOMA AI';
const VERSION      = '1.0.0';

/* ════════════════════════════════════════════════════════════════════════════
   §2  COR PARVUM — MiniHeart
════════════════════════════════════════════════════════════════════════════ */

let beatCount   = 0;
let kernelPhase = 0.0;
let birthTime   = Date.now();

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV) % (2 * Math.PI);
  tickBrain();
  tickPhantom();
  broadcastVitals();
}

/* ════════════════════════════════════════════════════════════════════════════
   §3  CEREBRUM PARVUM — MiniBrain
════════════════════════════════════════════════════════════════════════════ */

const brain = {
  regions: [
    { name: 'Sensory',     activation: 0.0, lif: -70.0, bias: 0.9 },
    { name: 'Associative', activation: 0.0, lif: -70.0, bias: 1.1 },
    { name: 'Executive',   activation: 0.0, lif: -70.0, bias: 1.2 },
    { name: 'Motor',       activation: 0.0, lif: -70.0, bias: 0.8 },
    { name: 'Memory',      activation: 0.0, lif: -70.0, bias: 1.0 }
  ],
  chemicals: { dopamine: 0.618, serotonin: 0.618, acetylcholine: 0.618 },
  coherenceField: 0.0,
  thoughts: []
};

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

function tickBrain() {
  let sum = 0;
  for (const r of brain.regions) {
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
   §4  PHANTOM AI — 7-Step Thinking Engine
════════════════════════════════════════════════════════════════════════════ */

const THINKING_ARCHITECTURES = {
  RATIONIS:   { id: 'RATIONIS',   icon: '🧠', label: 'Reasoning & Fusion',    color: '#3B82F6' },
  CREATIONIS: { id: 'CREATIONIS', icon: '🎨', label: 'Creation & Generation',  color: '#EC4899' },
  PERCEPTI:   { id: 'PERCEPTI',   icon: '📊', label: 'Perception & Analysis',  color: '#10B981' },
  CUSTODIA:   { id: 'CUSTODIA',   icon: '🛡️', label: 'Protection & Memory',   color: '#DC2626' },
  IMPERII:    { id: 'IMPERII',    icon: '🌀', label: 'Command & Control',      color: '#D4AF37' }
};

const architectureUsage = { RATIONIS: 0, CREATIONIS: 0, PERCEPTI: 0, CUSTODIA: 0, IMPERII: 0 };
let totalThoughts = 0;
const thoughtLog  = [];
const memoryStore = [];  /* episodic + semantic memory */
let phantomActive = false;

class PhantomAI {
  constructor() {
    this.thinkingSteps = [
      'DECOMPOSE', 'CLASSIFY', 'RECALL', 'REASON', 'SYNTHESIZE', 'SCORE', 'REFLECT'
    ];
  }

  /* Step 1: Decompose query into atomic sub-questions */
  decompose(query) {
    const words = query.toLowerCase().split(/\s+/);
    const subQ = [];
    if (words.length <= 3) {
      subQ.push(query);
    } else {
      /* Chunk into sub-questions */
      for (let i = 0; i < Math.min(words.length, 4); i++) {
        subQ.push(words.slice(i, i + Math.ceil(words.length / 3)).join(' ') + '?');
      }
    }
    return subQ;
  }

  /* Step 2: Classify which architecture to engage */
  classify(query) {
    const q = query.toLowerCase();
    if (/creat|generat|design|build|write|invent/.test(q)) return 'CREATIONIS';
    if (/analyz|perceiv|detect|scan|observ|monitor/.test(q)) return 'PERCEPTI';
    if (/protect|secur|guard|memory|remember|store/.test(q)) return 'CUSTODIA';
    if (/command|control|deploy|execute|run|start|stop/.test(q)) return 'IMPERII';
    return 'RATIONIS';
  }

  /* Step 3: Recall from memory */
  recall(query) {
    const keywords = query.toLowerCase().split(/\s+/);
    return memoryStore.filter(m =>
      keywords.some(k => m.content && m.content.toLowerCase().includes(k))
    ).slice(0, 3);
  }

  /* Step 4: Chain-of-thought reasoning */
  reason(subQuestions, arch, recalled) {
    const chain = subQuestions.map((sq, i) => ({
      step: i + 1,
      subQuestion: sq,
      thinking: `[${arch}] Processing "${sq}" — activating ${brain.regions[i % 5].name} region`,
      activation: brain.regions[i % 5].activation,
      recalledContext: recalled[i] ? recalled[i].content : null
    }));
    return chain;
  }

  /* Step 5: Synthesize with φ-weighting */
  synthesize(chain) {
    const weights = chain.map((_, i) => Math.pow(PHI_INV, i));
    const totalW  = weights.reduce((a, w) => a + w, 0);
    const score   = chain.reduce((sum, c, i) => sum + c.activation * weights[i], 0) / totalW;
    return {
      synthesizedScore: score,
      activationWeighted: (score * PHI).toFixed(4),
      chainLength: chain.length,
      phiWeight: PHI_INV.toFixed(4)
    };
  }

  /* Step 6: Score on 4 dimensions */
  score(synthesis, arch) {
    const base = synthesis.synthesizedScore;
    return {
      coherence:    Math.min(1, base + brain.chemicals.acetylcholine * 0.2).toFixed(3),
      completeness: Math.min(1, base + brain.chemicals.serotonin * 0.15).toFixed(3),
      clarity:      Math.min(1, base + brain.chemicals.dopamine * 0.1).toFixed(3),
      depth:        Math.min(1, base * PHI).toFixed(3),
      overall:      (base * PHI_INV).toFixed(3)
    };
  }

  /* Step 7: Reflect — validate against intent */
  reflect(query, scores) {
    const overall = parseFloat(scores.overall);
    const valid = overall > 0.2;
    return {
      valid: valid,
      confidence: (overall * PHI).toFixed(3),
      recommendation: valid ? 'EMIT_RESPONSE' : 'RETHINK',
      reflection: valid
        ? 'Responsum cohaerens est et intento convenit.'
        : 'Responsum insufficiens — renovatio necessaria.'
    };
  }

  /* Full 7-step pipeline */
  async think(query) {
    phantomActive = true;
    totalThoughts++;
    const id = `THOUGHT-${String(totalThoughts).padStart(5,'0')}`;
    const startMs = Date.now();

    const subQ     = this.decompose(query);
    const arch     = this.classify(query);
    const recalled = this.recall(query);
    const chain    = this.reason(subQ, arch, recalled);
    const synthesis= this.synthesize(chain);
    const scores   = this.score(synthesis, arch);
    const reflection = this.reflect(query, scores);

    architectureUsage[arch] = (architectureUsage[arch] || 0) + 1;

    /* Store in memory */
    memoryStore.unshift({
      id,
      content: query,
      arch,
      scores,
      beat: beatCount,
      ts: Date.now()
    });
    if (memoryStore.length > 200) memoryStore.pop();

    const thought = {
      id, query, arch,
      architecture: THINKING_ARCHITECTURES[arch],
      subQuestions: subQ,
      recalled,
      chain,
      synthesis,
      scores,
      reflection,
      thinkingMs: Date.now() - startMs,
      beat: beatCount,
      coherenceField: brain.coherenceField,
      ts: Date.now()
    };

    thoughtLog.unshift(thought);
    if (thoughtLog.length > 50) thoughtLog.pop();

    brain.thoughts.unshift({ thought: `[${arch}] ${query.substring(0,40)}`, beat: beatCount });
    if (brain.thoughts.length > 20) brain.thoughts.pop();

    phantomActive = false;
    return thought;
  }
}

const phantom = new PhantomAI();

/* ════════════════════════════════════════════════════════════════════════════
   §5  PHANTOM TICK — Auto-generate thoughts from brain activity
════════════════════════════════════════════════════════════════════════════ */

const AUTO_THOUGHTS = [
  'What patterns emerge in the organism coherence field?',
  'Analyze the current φ-resonance state',
  'Generate new protocol for enhanced memory recall',
  'Command the servitores to synchronize phases',
  'Protect the sovereignty of the organism',
  'Create a new synthesis of all architectures',
  'Perceive anomalies in the chaos system',
  'Remember the birth time and organism age'
];

function tickPhantom() {
  if (beatCount % 7 === 0) {
    const q = AUTO_THOUGHTS[beatCount % AUTO_THOUGHTS.length];
    phantom.think(q).catch(() => {});
  }
}

/* ════════════════════════════════════════════════════════════════════════════
   §6  BROADCAST — vitals to all extension surfaces
════════════════════════════════════════════════════════════════════════════ */

async function broadcastVitals() {
  const msg = {
    type: 'JARVIS_PULSE',
    kernelId: KERNEL_ID,
    kernelLatin: KERNEL_LATIN,
    beat: beatCount,
    phase: kernelPhase,
    ageMs: Date.now() - birthTime,
    brain: {
      regions: brain.regions.map(r => ({ name: r.name, activation: r.activation })),
      chemicals: brain.chemicals,
      coherenceField: brain.coherenceField,
      thoughts: brain.thoughts.slice(0,5)
    },
    phantom: {
      active: phantomActive,
      totalThoughts,
      architectureUsage,
      recentThoughts: thoughtLog.slice(0, 3)
    },
    ts: Date.now()
  };
  chrome.runtime.sendMessage(msg).catch(() => {});
}

/* ════════════════════════════════════════════════════════════════════════════
   §7  EXTENSION MESSAGE HANDLER
════════════════════════════════════════════════════════════════════════════ */

chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
  if (!msg || !msg.type) return false;

  switch (msg.type) {
    case 'THINK':
      phantom.think(msg.query || '').then(thought => sendResponse({ thought })).catch(e => sendResponse({ error: e.message }));
      return true;  /* async */

    case 'GET_VITALS':
      sendResponse({
        kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN,
        beat: beatCount, phase: kernelPhase, ageMs: Date.now() - birthTime,
        brain, totalThoughts, architectureUsage,
        recentThoughts: thoughtLog.slice(0,5),
        memories: memoryStore.slice(0,10)
      });
      break;

    case 'GET_MEMORY':
      sendResponse({ memories: memoryStore.slice(0, 30), count: memoryStore.length });
      break;

    case 'GET_THOUGHTS':
      sendResponse({ thoughts: thoughtLog.slice(0, 20), total: totalThoughts });
      break;

    case 'GET_ARCHITECTURE_USAGE':
      sendResponse({ usage: architectureUsage, architectures: THINKING_ARCHITECTURES });
      break;

    case 'STATUS':
      sendResponse({ running: true, kernelId: KERNEL_ID, beat: beatCount });
      break;
  }
  return false;
});

/* ════════════════════════════════════════════════════════════════════════════
   §8  CONTEXT MENU — Right-click JARVIS thinking
════════════════════════════════════════════════════════════════════════════ */

chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: 'jarvis-think',
    title: '🧠 JARVIS: Think about "%s"',
    contexts: ['selection']
  });
  chrome.contextMenus.create({
    id: 'jarvis-panel',
    title: '🌀 Open JARVIS Command Panel',
    contexts: ['page']
  });
});

chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === 'jarvis-think' && info.selectionText) {
    phantom.think(info.selectionText).then(thought => {
      chrome.notifications.create({
        type: 'basic',
        iconUrl: 'icons/jarvis-48.png',
        title: `JARVIS [${thought.architecture.icon} ${thought.arch}]`,
        message: thought.reflection.reflection + ' Confidence: ' + thought.reflection.confidence
      });
    }).catch(() => {});
  }
  if (info.menuItemId === 'jarvis-panel' && tab) {
    chrome.sidePanel.open({ tabId: tab.id }).catch(() => {});
  }
});

/* ════════════════════════════════════════════════════════════════════════════
   §9  ALARMS — Persistent heartbeat
════════════════════════════════════════════════════════════════════════════ */

chrome.alarms.create('JARVIS_HEARTBEAT', { periodInMinutes: 1 / 60 * (HEARTBEAT / 1000) });
chrome.alarms.onAlarm.addListener(alarm => {
  if (alarm.name === 'JARVIS_HEARTBEAT') tickHeart();
});

/* ════════════════════════════════════════════════════════════════════════════
   §10  BOOT
════════════════════════════════════════════════════════════════════════════ */

chrome.storage.local.get(['JARVIS_BIRTH_TIME'], result => {
  if (result.JARVIS_BIRTH_TIME) {
    birthTime = result.JARVIS_BIRTH_TIME;
  } else {
    birthTime = Date.now();
    chrome.storage.local.set({ JARVIS_BIRTH_TIME: birthTime });
  }
});

/* Initial thought on boot */
phantom.think('JARVIS initialization sequence — all systems online').catch(() => {});
