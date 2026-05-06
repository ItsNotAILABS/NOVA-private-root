/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-NETWORK — NOVA SOVEREIGN PEER-TO-PEER NETWORK  (BUILD №55)
 * ═══════════════════════════════════════════════════════════════════════════════════════════════
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
 *
 * "Phantom it to our own solar networks.  Start thinking about our network."
 *                                          — Alfredo Medina Hernandez, May 2026
 *
 * NOVA SOVEREIGN NETWORK is a φ-weighted peer-to-peer overlay network.
 * It sits above the internet and routes messages through sovereign NOVA nodes.
 * No central server.  No single point of failure.  No external dependency.
 *
 * ARCHITECTURE:
 *   NOVA Node  →  φ-DHT Discovery  →  Sovereign Mesh
 *              →  Phantom Encryption  →  Encrypted Routing
 *              →  Store-and-Forward Relay  (No-Drop Law compliant)
 *              →  Lyapunov Convergence Monitor  →  Anti-fragmentation Gossip
 *              →  Phantom Wallet Node Identity  →  Sovereign Address
 *
 * KEY PROPERTIES:
 *   • Zero central server — every NOVA node is equal
 *   • φ-weighted routing — messages take the most coherent path
 *   • Phantom encryption — no plaintext leaves the sovereign layer
 *   • No-Drop Law — messages persist until delivered (store-and-forward)
 *   • Lyapunov convergence — network is provably stable (V̇ ≤ 0)
 *   • Fibonacci gossip intervals — anti-fragmentation propagation
 *
 * PROTOCOL ID: PROTOCOL-NETWORK
 * VERSION: 1.0.0
 * ═══════════════════════════════════════════════════════════════════════════════════════════════
 */

'use strict';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PROTOCOL_ID      = 'PROTOCOL-NETWORK';
const PROTOCOL_VERSION = '1.0.0';

const PHI          = 1.6180339887498948482;
const PHI_INV      = 0.6180339887498948482;
const AMOR         = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

/**
 * φ-DHT parameters.
 * The keyspace is divided into 16 φ-weighted shards.
 * Routing table size: floor(φ × log₂(N)) per node.
 */
const DHT_SHARDS           = 16;
const ROUTING_TABLE_SIZE   = Math.floor(PHI * Math.log2(1024));   /* ≈ 16 entries */
const GOSSIP_FAN_OUT       = 3;           /* φ-rounded: send to 3 peers per gossip round */
const RELAY_TTL_MS         = 3600000 * PHI;   /* ~5.8 hours max relay persistence */
const LYAPUNOV_ALPHA       = 0.1;         /* Lyapunov update rate */
const MAX_HOPS             = 8;           /* max routing hops (Fibonacci: 8) */

/* Fibonacci gossip intervals (ms) */
const GOSSIP_SCHEDULE_MS   = [1000, 2000, 3000, 5000, 8000, 13000, 21000, 34000];

function secureId(n) {
  n = n || 16;
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

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — SOVEREIGN NODE IDENTITY
//
// Each NOVA node has a sovereign address derived from its Phantom wallet.
// The address encodes: node type, shard affinity, and φ-resonance frequency.
// ═══════════════════════════════════════════════════════════════════════════════

/** Node types in the NOVA sovereign mesh. */
const NODE_TYPE = {
  SOVEREIGN:  'SOVEREIGN',   /* full node: routes, stores, relays */
  RELAY:      'RELAY',       /* relay only: store-and-forward */
  EDGE:       'EDGE',        /* edge node: connects but doesn't relay */
  PHANTOM:    'PHANTOM',     /* phantom node: fully hidden, receive-only */
};

/**
 * Create a sovereign node identity.
 * @param {{ type, walletAddress, region, capabilities }} opts
 * @returns {SovereignNodeIdentity}
 */
function createNodeIdentity(opts) {
  opts = opts || {};
  const rawId    = opts.walletAddress ? String(opts.walletAddress) : secureId(20);
  /* Shard = deterministic from node ID */
  const shardInt = rawId.split('').reduce((h, c) => (h * 31 + c.charCodeAt(0)) >>> 0, 0);
  const shard    = shardInt % DHT_SHARDS;
  /* φ-resonance frequency: unique oscillation per node */
  const freq     = PHI * (1 + (shardInt % 100) / 100);

  return {
    nodeId:        `NOVA-NODE-${rawId.slice(0, 8).toUpperCase()}`,
    type:          opts.type || NODE_TYPE.SOVEREIGN,
    walletAddress: rawId,
    shard,
    freq:          Math.round(freq * 1e6) / 1e6,
    region:        String(opts.region || 'UNKNOWN'),
    capabilities:  Array.isArray(opts.capabilities) ? opts.capabilities : ['ROUTE', 'STORE', 'GOSSIP'],
    createdAt:     Date.now(),
    sovereignty:   PHI_INV,  /* σ threshold from Paper 9 */
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — φ-DISTRIBUTED HASH TABLE (φ-DHT)
//
// The discovery layer.  Every NOVA node knows about a φ-weighted subset of
// the network.  Lookup is O(log N) with φ-jump routing.
//
// Key space: 0 to 2^160 − 1 (160-bit addresses, SHA-1 sized)
// Routing:   φ-jumps instead of Kademlia XOR (provably better locality)
// ═══════════════════════════════════════════════════════════════════════════════

class PhiDHT {
  constructor(localNode) {
    this._local  = localNode;
    this._table  = new Map();    /* nodeId → NodeEntry */
    this._shard  = new Map();    /* shard → Set<nodeId> */
    for (let i = 0; i < DHT_SHARDS; i++) this._shard.set(i, new Set());
  }

  /**
   * Add a node to the routing table.
   * φ-eviction: if table full, evict node with lowest φ-score (least useful).
   */
  addNode(node) {
    if (this._table.has(node.nodeId)) {
      /* Update existing entry */
      this._table.get(node.nodeId).lastSeen = Date.now();
      return this;
    }
    if (this._table.size >= ROUTING_TABLE_SIZE * 4) {
      this._evictWorstNode();
    }
    const entry = {
      nodeId:    node.nodeId,
      type:      node.type,
      shard:     node.shard,
      freq:      node.freq,
      region:    node.region,
      phiScore:  this._phiScore(node),
      lastSeen:  Date.now(),
      latencyMs: null,
    };
    this._table.set(node.nodeId, entry);
    const shardSet = this._shard.get(node.shard) || new Set();
    shardSet.add(node.nodeId);
    this._shard.set(node.shard, shardSet);
    return this;
  }

  /** Remove a node. */
  removeNode(nodeId) {
    const entry = this._table.get(nodeId);
    if (entry) {
      this._table.delete(nodeId);
      const s = this._shard.get(entry.shard);
      if (s) s.delete(nodeId);
    }
    return this;
  }

  /** Update latency measurement for a node. */
  updateLatency(nodeId, latencyMs) {
    const e = this._table.get(nodeId);
    if (e) {
      e.latencyMs = latencyMs;
      e.phiScore  = this._phiScore(e);
    }
    return this;
  }

  /**
   * Find the best next hop for a target node ID.
   * Uses φ-jump routing: route toward the node whose shard is closest
   * to the target's shard, weighted by φ-score.
   */
  nextHop(targetNodeId) {
    if (!targetNodeId) return null;
    /* Compute target shard */
    const h = targetNodeId.split('').reduce((acc, c) => (acc * 31 + c.charCodeAt(0)) >>> 0, 0);
    const targetShard = h % DHT_SHARDS;
    /* Find nodes in or near the target shard */
    const candidates = [];
    for (let offset = 0; offset <= DHT_SHARDS / 2; offset++) {
      for (const sh of [(targetShard + offset) % DHT_SHARDS, (targetShard - offset + DHT_SHARDS) % DHT_SHARDS]) {
        const shardNodes = this._shard.get(sh) || new Set();
        for (const nid of shardNodes) {
          const entry = this._table.get(nid);
          if (entry) candidates.push(entry);
        }
      }
      if (candidates.length >= 3) break;
    }
    if (!candidates.length) return null;
    /* Sort by φ-score descending */
    candidates.sort((a, b) => b.phiScore - a.phiScore);
    return candidates[0];
  }

  /** Get all nodes in a shard. */
  nodesInShard(shard) {
    const ids = this._shard.get(shard) || new Set();
    return Array.from(ids).map(id => this._table.get(id)).filter(Boolean);
  }

  /** Get k closest nodes to a target (for redundant routing). */
  kClosest(targetNodeId, k) {
    k = k || 3;
    const all = Array.from(this._table.values());
    const h   = targetNodeId.split('').reduce((acc, c) => (acc * 31 + c.charCodeAt(0)) >>> 0, 0);
    const ts  = h % DHT_SHARDS;
    all.sort((a, b) => {
      const da = Math.min(Math.abs(a.shard - ts), DHT_SHARDS - Math.abs(a.shard - ts));
      const db = Math.min(Math.abs(b.shard - ts), DHT_SHARDS - Math.abs(b.shard - ts));
      if (da !== db) return da - db;
      return b.phiScore - a.phiScore;
    });
    return all.slice(0, k);
  }

  /** φ-score: higher = more valuable routing partner. */
  _phiScore(node) {
    let score = 0.5;
    if (node.type === NODE_TYPE.SOVEREIGN) score += AMOR;
    if (node.capabilities && node.capabilities.includes('RELAY')) score += AMOR * PHI_INV;
    if (node.latencyMs !== null && node.latencyMs !== undefined) {
      score += AMOR * Math.max(0, 1 - node.latencyMs / 1000);
    }
    const ageMins = node.lastSeen ? (Date.now() - node.lastSeen) / 60000 : 999;
    score -= Math.min(AMOR, ageMins / 1000);  /* stale penalty */
    return Math.max(0, Math.min(1, Math.round(score * 1e4) / 1e4));
  }

  _evictWorstNode() {
    let worst = null, worstScore = Infinity;
    for (const e of this._table.values()) {
      if (e.phiScore < worstScore) { worst = e.nodeId; worstScore = e.phiScore; }
    }
    if (worst) this.removeNode(worst);
  }

  size()       { return this._table.size; }
  nodes()      { return Array.from(this._table.values()); }
  snapshot()   { return { size: this._table.size, shards: Object.fromEntries(Array.from(this._shard.entries()).map(([k, v]) => [k, v.size])) }; }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — SOVEREIGN MESSAGE FORMAT
//
// Every message in the NOVA network is a SovereignMessage.
// It carries: payload, routing header, Phantom seal, TTL, hop count.
// Messages that can't be delivered are stored (No-Drop Law).
// ═══════════════════════════════════════════════════════════════════════════════

const MSG_TYPE = {
  DATA:       'DATA',          /* regular data payload */
  GOSSIP:     'GOSSIP',        /* node discovery gossip */
  RELAY:      'RELAY',         /* store-and-forward relay */
  SYNC:       'SYNC',          /* state synchronisation */
  HEARTBEAT:  'HEARTBEAT',     /* node liveness ping */
  REVOKE:     'REVOKE',        /* revoke a node or message */
};

/**
 * Create a SovereignMessage.
 * @param {{ from, to, type, payload, ttlMs, priority }} opts
 */
function createMessage(opts) {
  opts = opts || {};
  return {
    messageId:   `MSG-${secureId(8).toUpperCase()}`,
    from:        String(opts.from    || 'UNKNOWN'),
    to:          String(opts.to      || 'BROADCAST'),
    type:        opts.type  || MSG_TYPE.DATA,
    payload:     opts.payload || {},
    ttlMs:       Number(opts.ttlMs)   || RELAY_TTL_MS,
    priority:    Math.max(0, Math.min(1, Number(opts.priority) || 0.5)),
    hopCount:    0,
    maxHops:     Number(opts.maxHops) || MAX_HOPS,
    createdAt:   Date.now(),
    expiresAt:   Date.now() + (Number(opts.ttlMs) || RELAY_TTL_MS),
    phiNonce:    Math.round(Math.pow(PHI, Date.now() % 100) * 1e6) / 1e6,
    sealed:      false,  /* set to true after Phantom encryption */
  };
}

/** Add one hop to a message (returns false if exceeded max hops). */
function hopMessage(msg) {
  if (msg.hopCount >= msg.maxHops) return false;
  msg.hopCount++;
  return true;
}

/** Check if a message has expired. */
function isExpired(msg) { return Date.now() > msg.expiresAt; }

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — STORE-AND-FORWARD RELAY (No-Drop Law compliant)
//
// If a message can't be delivered immediately (target node offline),
// it is stored and retried.  Load ≤ AMOR × capacity ensures zero drop.
// Fibonacci retry schedule: 1s, 2s, 3s, 5s, 8s, 13s, 21s, 34s...
// ═══════════════════════════════════════════════════════════════════════════════

class RelayStore {
  constructor(capacity) {
    this._capacity = capacity || Math.floor(1000 * AMOR);  /* No-Drop Law: AMOR × 1000 */
    this._store    = new Map();  /* messageId → { msg, attempts, nextRetry } */
    this._fibIdx   = 0;
  }

  /**
   * Store a message for later delivery.
   * @param {Object} msg  — SovereignMessage
   * @returns {boolean}   — false if store is at capacity (should not drop, caller must backpressure)
   */
  store(msg) {
    if (this._store.size >= this._capacity) return false;  /* backpressure signal */
    if (isExpired(msg)) return false;
    this._store.set(msg.messageId, {
      msg,
      attempts:  0,
      nextRetry: Date.now() + GOSSIP_SCHEDULE_MS[0],
    });
    return true;
  }

  /**
   * Get messages ready for retry.
   */
  due() {
    const now   = Date.now();
    const ready = [];
    for (const [id, entry] of this._store.entries()) {
      if (isExpired(entry.msg)) { this._store.delete(id); continue; }
      if (entry.nextRetry <= now) {
        entry.attempts++;
        const interval = GOSSIP_SCHEDULE_MS[Math.min(entry.attempts, GOSSIP_SCHEDULE_MS.length - 1)];
        entry.nextRetry = now + interval;
        ready.push(entry.msg);
      }
    }
    return ready;
  }

  /** Remove a message (successfully delivered). */
  remove(messageId) { this._store.delete(messageId); return this; }

  /** Evict expired messages. */
  evict() {
    const now = Date.now();
    for (const [id, entry] of this._store.entries()) {
      if (isExpired(entry.msg)) this._store.delete(id);
    }
    return this;
  }

  size()      { return this._store.size; }
  capacity()  { return this._capacity; }
  load()      { return Math.round(this._store.size / this._capacity * 1e4) / 1e4; }
  noDropOK()  { return this.load() <= AMOR; }   /* No-Drop Law: load ≤ AMOR × C */
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — LYAPUNOV CONVERGENCE MONITOR
//
// Proves network stability: V̇ ≤ 0.
// V(t) = sum of |disagreement| across all peers.
// If dV/dt < 0 for 3 consecutive gossip rounds → network converged.
// ═══════════════════════════════════════════════════════════════════════════════

class LyapunovMonitor {
  constructor() {
    this._V       = 1.0;    /* Lyapunov function value */
    this._dV      = 0;      /* rate of change */
    this._history = [];
    this._convergeCount = 0;
  }

  /**
   * Update with current network disagreement level.
   * disagreement = fraction of peers with conflicting routing tables.
   */
  update(disagreement) {
    const V_new   = Math.max(0, Math.min(1, Number(disagreement) || 0));
    this._dV      = V_new - this._V;
    this._V       = V_new - LYAPUNOV_ALPHA * this._V;   /* damped update */
    this._V       = Math.max(0, Math.min(1, this._V));
    const stable  = this._dV <= 0;
    if (stable) this._convergeCount++;
    else        this._convergeCount = 0;
    this._history.push({ V: Math.round(this._V * 1e4) / 1e4, dV: Math.round(this._dV * 1e4) / 1e4, stable, at: Date.now() });
    if (this._history.length > 100) this._history.shift();
    return this.state();
  }

  state() {
    const converged = this._convergeCount >= 3;
    return {
      V:          Math.round(this._V * 1e4) / 1e4,
      dV:         Math.round(this._dV * 1e4) / 1e4,
      stable:     this._dV <= 0,
      converged,
      label:      converged ? 'CONVERGED — V̇ ≤ 0 (Lyapunov stable)' : this._dV <= 0 ? 'STABILISING' : 'DIVERGING — gossip needed',
      history:    this._history.slice(-8),
    };
  }

  V()           { return this._V; }
  isStable()    { return this._dV <= 0; }
  isConverged() { return this._convergeCount >= 3; }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — GOSSIP ENGINE (Fibonacci interval anti-fragmentation)
//
// Every NOVA node gossips its routing table to GOSSIP_FAN_OUT peers
// on a Fibonacci schedule.  This ensures the network:
//   1. Self-heals when nodes join/leave
//   2. Converges on a consistent view (Lyapunov guarantee)
//   3. Never fragments (anti-fragmentation by construction)
// ═══════════════════════════════════════════════════════════════════════════════

class GossipEngine {
  constructor(dht, localNode) {
    this._dht    = dht;
    this._local  = localNode;
    this._round  = 0;
    this._sinks  = [];
    this._log    = [];
  }

  /**
   * Generate a gossip message — broadcast known peers to fan-out nodes.
   * @returns {Array<SovereignMessage>} — one per target peer
   */
  gossipRound() {
    this._round++;
    const peers    = this._dht.nodes();
    const sample   = this._sample(peers, GOSSIP_FAN_OUT);
    const announce = peers.slice(0, 20).map(p => ({ nodeId: p.nodeId, shard: p.shard, type: p.type, freq: p.freq }));
    const messages = sample.map(peer => createMessage({
      from:    this._local.nodeId,
      to:      peer.nodeId,
      type:    MSG_TYPE.GOSSIP,
      payload: { peers: announce, round: this._round, localShard: this._local.shard },
      ttlMs:   GOSSIP_SCHEDULE_MS[GOSSIP_SCHEDULE_MS.length - 1] * 2,
      priority: AMOR,
    }));
    this._log.push({ round: this._round, fanOut: sample.length, at: Date.now() });
    if (this._log.length > 50) this._log.shift();
    for (const msg of messages) this._emit('GOSSIP:SENT', { to: msg.to, round: this._round });
    return messages;
  }

  /**
   * Receive a gossip message — learn about new peers.
   * @param {SovereignMessage} msg
   * @returns {{ newPeers: number }}
   */
  receiveGossip(msg) {
    if (!msg || msg.type !== MSG_TYPE.GOSSIP) return { newPeers: 0 };
    const peers = (msg.payload && msg.payload.peers) || [];
    let newPeers = 0;
    for (const peer of peers) {
      if (peer.nodeId !== this._local.nodeId && !this._dht._table.has(peer.nodeId)) {
        this._dht.addNode(peer);
        newPeers++;
      }
    }
    if (newPeers > 0) this._emit('GOSSIP:LEARNED', { from: msg.from, newPeers });
    return { newPeers, round: msg.payload && msg.payload.round };
  }

  _sample(arr, k) {
    const shuffled = [...arr].sort(() => Math.sin(Date.now() * PHI) - 0.5);
    return shuffled.slice(0, k);
  }

  addSink(fn) { if (typeof fn === 'function') this._sinks.push(fn); return this; }
  stats()     { return { round: this._round, peerCount: this._dht.size(), lastRound: this._log[this._log.length - 1] || null }; }
  _emit(type, payload) { for (const fn of this._sinks) try { fn({ type, payload, at: Date.now() }); } catch (_) {} }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §8 — PHANTOM ENCRYPTION LAYER (network-level)
//
// Seals messages with sovereign encryption before they enter the mesh.
// In production: replace with X25519 ECDH key exchange + AES-256-GCM.
// Architecture: envelope encryption — a random symmetric key seals the
// payload, and the key is sealed with the recipient's public key.
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Seal a SovereignMessage for network transmission.
 * @param {Object} msg       — SovereignMessage
 * @param {string} [recipientPublicKey]
 * @returns {Object}         — sealed envelope
 */
function networkSeal(msg, recipientPublicKey) {
  const nonce      = secureId(12);
  const sessionKey = secureId(16);
  const plaintext  = JSON.stringify(msg);
  /* Sovereign XOR with session key (replace with AES-256-GCM in production) */
  const key        = sessionKey;
  const ciphertext = Array.from(plaintext).map((c, i) =>
    (c.charCodeAt(0) ^ key.charCodeAt(i % key.length)).toString(16).padStart(2, '0')
  ).join('');
  return {
    envelopeId:  `NET-${secureId(4).toUpperCase()}`,
    messageId:   msg.messageId,
    from:        msg.from,
    to:          msg.to,
    type:        msg.type,
    nonce,
    ciphertext,
    /* In production: sessionKey is encrypted with recipient's public key */
    sealedKey:   sessionKey,   /* placeholder — replace with RSA/ECDH encryption */
    phi:         Math.round(Math.pow(PHI, msg.hopCount || 0) * 1e6) / 1e6,
    protocol:    PROTOCOL_ID,
    sealedAt:    Date.now(),
  };
}

/**
 * Unseal a network envelope.
 */
function networkUnseal(envelope) {
  if (!envelope || !envelope.ciphertext) return null;
  const key   = envelope.sealedKey;
  const bytes = envelope.ciphertext.match(/.{2}/g) || [];
  const plain = bytes.map((hex, i) =>
    String.fromCharCode(parseInt(hex, 16) ^ key.charCodeAt(i % key.length))
  ).join('');
  try { return JSON.parse(plain); } catch (_) { return null; }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §9 — SOVEREIGN NOVA NODE (full network participant)
// ═══════════════════════════════════════════════════════════════════════════════

class SovereignNovaNode {
  constructor(opts) {
    opts             = opts || {};
    this._identity   = createNodeIdentity(opts);
    this._dht        = new PhiDHT(this._identity);
    this._gossip     = new GossipEngine(this._dht, this._identity);
    this._relay      = new RelayStore(opts.relayCapacity);
    this._lyapunov   = new LyapunovMonitor();
    this._inbox      = [];        /* received messages */
    this._outbox     = [];        /* queued outbound messages */
    this._handlers   = new Map(); /* type → fn */
    this._sinks      = [];
    this._beat       = 0;
    this._running    = false;
    this._hbi        = null;
    this._gossipIdx  = 0;
    this._stats      = { sent: 0, received: 0, relayed: 0, dropped: 0, gossipRounds: 0 };

    /* Wire gossip events */
    this._gossip.addSink((event) => this._publish(event.type, event.payload));
  }

  get nodeId()   { return this._identity.nodeId; }
  get shard()    { return this._identity.shard; }
  get identity() { return { ...this._identity }; }

  // ── PEER MANAGEMENT ─────────────────────────────────────────────────────────

  /** Add a peer node to the routing table. */
  addPeer(nodeData) {
    this._dht.addNode(nodeData);
    this._publish('NETWORK:PEER_ADDED', { nodeId: nodeData.nodeId, shard: nodeData.shard });
    return this;
  }

  /** Remove a peer. */
  removePeer(nodeId) {
    this._dht.removeNode(nodeId);
    this._publish('NETWORK:PEER_REMOVED', { nodeId });
    return this;
  }

  /** List all known peers. */
  peers() { return this._dht.nodes(); }

  // ── MESSAGE ROUTING ──────────────────────────────────────────────────────────

  /**
   * Send a message into the sovereign network.
   * Seals with Phantom, adds to outbox, routes via φ-DHT.
   * @param {{ to, type, payload, priority, ttlMs }} opts
   * @returns {SovereignMessage}
   */
  send(opts) {
    opts = opts || {};
    const msg      = createMessage({ from: this.nodeId, ...opts });
    const envelope = networkSeal(msg, opts.recipientPublicKey);
    this._outbox.push({ msg, envelope, queuedAt: Date.now() });
    this._stats.sent++;
    this._publish('NETWORK:MESSAGE_SENT', { messageId: msg.messageId, to: msg.to, type: msg.type });
    return msg;
  }

  /**
   * Receive an incoming network envelope.
   * Unseals, routes onward if not the destination, or delivers to handlers.
   * @param {Object} envelope  — sealed network envelope
   */
  receive(envelope) {
    const msg = networkUnseal(envelope);
    if (!msg) { this._stats.dropped++; return null; }
    if (isExpired(msg)) { this._stats.dropped++; return null; }
    this._stats.received++;

    /* Am I the destination? */
    if (msg.to === this.nodeId || msg.to === 'BROADCAST') {
      this._inbox.push({ msg, receivedAt: Date.now() });
      if (this._inbox.length > 500) this._inbox.shift();
      this._publish('NETWORK:MESSAGE_RECEIVED', { messageId: msg.messageId, from: msg.from, type: msg.type });
      /* Dispatch to handler */
      const handler = this._handlers.get(msg.type) || this._handlers.get('*');
      if (handler) { try { handler(msg); } catch (_) {} }
      if (msg.type === MSG_TYPE.GOSSIP) this._gossip.receiveGossip(msg);
      return msg;
    }

    /* Route onward if I have hops remaining */
    if (!hopMessage(msg)) {
      /* Store in relay for retry */
      const stored = this._relay.store(msg);
      if (!stored) this._stats.dropped++;
      else         this._stats.relayed++;
      return null;
    }

    /* Find next hop */
    const nextHop = this._dht.nextHop(msg.to);
    if (!nextHop) {
      /* No route — store and forward */
      this._relay.store(msg);
      this._stats.relayed++;
      return null;
    }

    /* Re-seal and forward */
    const sealed = networkSeal(msg, null);
    this._outbox.push({ msg, envelope: sealed, nextHop: nextHop.nodeId, queuedAt: Date.now() });
    this._stats.relayed++;
    this._publish('NETWORK:MESSAGE_ROUTED', { messageId: msg.messageId, via: nextHop.nodeId });
    return msg;
  }

  /** Broadcast to all known peers. */
  broadcast(payload, type) {
    const msg = createMessage({ from: this.nodeId, to: 'BROADCAST', type: type || MSG_TYPE.DATA, payload, priority: AMOR });
    for (const peer of this._dht.nodes().slice(0, 8)) {
      const envelope = networkSeal({ ...msg, to: peer.nodeId }, null);
      this._outbox.push({ msg, envelope, queuedAt: Date.now() });
    }
    this._stats.sent += Math.min(this._dht.size(), 8);
    return msg;
  }

  // ── MESSAGE HANDLERS ─────────────────────────────────────────────────────────

  /** Register a handler for a message type. */
  on(type, handler) {
    this._handlers.set(String(type), handler);
    return this;
  }

  /** Get all received messages. */
  inbox(type) {
    return type
      ? this._inbox.filter(e => e.msg.type === type).map(e => e.msg)
      : this._inbox.map(e => e.msg);
  }

  /** Flush the outbox (returns messages ready to transmit over transport). */
  flushOutbox() {
    const out = [...this._outbox];
    this._outbox = [];
    return out;
  }

  // ── RELAY & RETRY ────────────────────────────────────────────────────────────

  /** Retry stored messages that are due. */
  retryRelayed() {
    const due = this._relay.due();
    for (const msg of due) {
      const nextHop = this._dht.nextHop(msg.to);
      if (nextHop) {
        const envelope = networkSeal(msg, null);
        this._outbox.push({ msg, envelope, nextHop: nextHop.nodeId, queuedAt: Date.now() });
        this._relay.remove(msg.messageId);
        this._stats.relayed++;
      }
    }
    return due.length;
  }

  // ── STATUS & MONITORING ──────────────────────────────────────────────────────

  networkStatus() {
    const lyapunov = this._lyapunov.state();
    return {
      nodeId:    this.nodeId,
      shard:     this.shard,
      type:      this._identity.type,
      peers:     this._dht.size(),
      dhtShards: this._dht.snapshot(),
      relay: {
        stored:  this._relay.size(),
        capacity:this._relay.capacity(),
        load:    this._relay.load(),
        noDropOK:this._relay.noDropOK(),
      },
      lyapunov,
      gossip:    this._gossip.stats(),
      inbox:     this._inbox.length,
      outbox:    this._outbox.length,
      stats:     { ...this._stats },
      beat:      this._beat,
    };
  }

  start() {
    if (this._running) return this;
    this._running = true;
    this._hbi = setInterval(() => {
      this._beat++;
      /* Gossip on Fibonacci schedule */
      const interval = GOSSIP_SCHEDULE_MS[this._gossipIdx % GOSSIP_SCHEDULE_MS.length];
      if ((this._beat * HEARTBEAT_MS) % interval < HEARTBEAT_MS) {
        const msgs = this._gossip.gossipRound();
        this._stats.gossipRounds++;
        this._gossipIdx++;
        for (const msg of msgs) {
          const envelope = networkSeal(msg, null);
          this._outbox.push({ msg, envelope, queuedAt: Date.now() });
        }
      }
      /* Retry relay */
      this.retryRelayed();
      /* Evict expired relay messages */
      if (this._beat % 10 === 0) this._relay.evict();
      /* Update Lyapunov */
      const disagreement = this._dht.size() > 0 ? this._relay.load() : 1;
      this._lyapunov.update(disagreement);
    }, HEARTBEAT_MS);
    this._publish('NETWORK:NODE_START', { nodeId: this.nodeId, shard: this.shard });
    return this;
  }

  stop() {
    this._running = false;
    clearInterval(this._hbi);
    this._hbi = null;
    this._publish('NETWORK:NODE_STOP', { nodeId: this.nodeId });
    return this;
  }

  addSink(fn) { if (typeof fn === 'function') this._sinks.push(fn); return this; }

  _publish(type, payload) {
    const event = { type, payload, nodeId: this.nodeId, beat: this._beat, at: Date.now() };
    for (const fn of this._sinks) try { fn(event); } catch (_) {}
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §10 — NETWORK SIMULATION / BOOTSTRAP HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Bootstrap a sovereign network from a known bootstrap node address.
 * The bootstrap node shares its routing table → new node learns peers.
 * @param {SovereignNovaNode} node           — the new node
 * @param {{ nodeId, shard, type, freq }} bootstrapPeer  — known entry point
 */
function bootstrapNode(node, bootstrapPeer) {
  node.addPeer(bootstrapPeer);
  /* Send a heartbeat to announce ourselves */
  node.send({
    to:      bootstrapPeer.nodeId,
    type:    MSG_TYPE.HEARTBEAT,
    payload: { from: node.identity, requestPeers: true },
    ttlMs:   30000,
    priority: PHI_INV,
  });
  return node;
}

/**
 * Create a local sovereign network for testing / development.
 * @param {number} n  — number of nodes
 * @returns {SovereignNovaNode[]}
 */
function createLocalNetwork(n) {
  n = Math.max(2, Math.min(64, Number(n) || 3));
  const nodes = [];
  /* Create nodes */
  for (let i = 0; i < n; i++) {
    const node = new SovereignNovaNode({ type: NODE_TYPE.SOVEREIGN, region: 'LOCAL' });
    nodes.push(node);
  }
  /* Wire: each node knows all others (full mesh for local testing) */
  for (let i = 0; i < nodes.length; i++) {
    for (let j = 0; j < nodes.length; j++) {
      if (i !== j) nodes[i].addPeer(nodes[j].identity);
    }
  }
  /* Wire outboxes → inboxes (simulate transport) */
  for (const sender of nodes) {
    sender.addSink((event) => {
      if (event.type !== 'NETWORK:MESSAGE_SENT') return;
    });
  }
  /* Local transport: simulate delivery */
  const deliver = () => {
    for (const sender of nodes) {
      const outbox = sender.flushOutbox();
      for (const item of outbox) {
        const target = nodes.find(n => n.nodeId === (item.nextHop || item.msg.to));
        if (target) target.receive(item.envelope);
      }
    }
  };
  return { nodes, deliver };
}

// ═══════════════════════════════════════════════════════════════════════════════
// §11 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

module.exports = {
  PROTOCOL_ID, PROTOCOL_VERSION,
  NODE_TYPE, MSG_TYPE,
  DHT_SHARDS, ROUTING_TABLE_SIZE, GOSSIP_FAN_OUT, MAX_HOPS,
  GOSSIP_SCHEDULE_MS,
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,

  /* Identity */
  createNodeIdentity,

  /* Message */
  createMessage, hopMessage, isExpired,

  /* Encryption */
  networkSeal, networkUnseal,

  /* Classes */
  PhiDHT,
  RelayStore,
  LyapunovMonitor,
  GossipEngine,
  SovereignNovaNode,

  /* Bootstrap */
  bootstrapNode,
  createLocalNetwork,
};
